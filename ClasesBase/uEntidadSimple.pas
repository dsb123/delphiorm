{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uEntidadSimple.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uEntidadSimple;

interface

uses Classes, uEntidades, uColeccionEntidades, uSQLBuilder, uCampos;

type

  TORMEntidadSimpleDef = record
    Tabla: string;
    CampoClave: string;
    CampoDescripcion: string;
    CampoDescrReducida: string;
    CampoObservaciones: string;
    ClaveEsIdentidad: boolean;
    NombreEntidad : string;
    NombrePlural: string;
  end;

  TORMEntidadSimple = class(TORMEntidadBase)
  private
    function GetDescripcion: string;
    function GetDescrReducida: string;
    function GetID: integer;
    function GetObservaciones: string;
    procedure SetDescripcion(const Value: string);
    procedure SetDescrReducida(const Value: string);
    procedure SetID(const Value: integer);
    procedure SetObservaciones(const Value: string);
    function GetORMCampo(index: integer): TORMCampo;
  public
    constructor Create; overload;
    {
    Constructor Create( Tabla: string; NombreCampoClave: string;
                        NombreCampoDescripcion: string = 'Descripcion';
                        NombreCampoDescrReducida: string = 'DescripcionReducida';
                        NombreCampoObservaciones: string = 'Observaciones';
                        ClaveEsIdentidad: boolean = true); overload;
    Constructor Create(DatosEntidadSimple: TEntidadSimpleDef); overload;
    }
    procedure AsignarDatosEntidad(  const Tabla: string; const NombreCampoClave: string;
                                    const NombreCampoDescripcion: string = 'Descripcion';
                                    const NombreCampoDescrReducida: string = 'DescripcionReducida';
                                    const NombreCampoObservaciones: string = 'Observaciones';
                                    const ClaveEsIdentidad: boolean = true); overload;
    procedure AsignarDatosEntidad(const DatosEntidadSimple: TORMEntidadSimpleDef); overload;

    function ObtenerEntidad(const EntidadID: integer): boolean; virtual;
    procedure CargarCombo(Items: TStringList);
    property ORMCampo[index: integer]: TORMCampo read GetORMCampo;
  published
    property ID: integer read GetID write SetID;
    property Descripcion: string read GetDescripcion write SetDescripcion;
    property DescripcionReducida: string read GetDescrReducida write SetDescrReducida;
    property Observaciones: string read GetObservaciones write SetObservaciones;
  end;

  TORMColeccionEntidadSimple = class(TORMColeccionEntidades)
  private
    function GetEntidadSimple(index: integer): TORMEntidadSimple;
  protected
    procedure ProcesarDataSet; override;
  published
  public
    constructor Create( const Tabla: string; const NombreCampoClave: string;
                        const NombreCampoDescripcion: string = 'Descripcion';
                        const NombreCampoDescrReducida: string = 'DescripcionReducida';
                        const NombreCampoObservaciones: string = 'Observaciones';
                        const ClaveEsIdentidad: boolean = false); overload;
    constructor Create( EntidadSimple: TORMEntidadSimple); overload;
    constructor Create(const DatosEntidadSimple: TORMEntidadSimpleDef); overload;
    property ORMEntidadSimple[index: integer]: TORMEntidadSimple read GetEntidadSimple;
  end;

  function EntidadSimpleDefault(const Tabla, CampoClave, NombreEntidad,
                                NombreEntidadPlural: string): TORMEntidadSimpleDef; overload;
  function EntidadSimpleDefault(CampoClave: TORMCampo;
                                NombreEntidad,
                                NombreEntidadPlural: string): TORMEntidadSimpleDef; overload;
  function EntidadSimpleDefaultSoloDescripcion(  const Tabla, CampoClave, NombreEntidad,
                                NombreEntidadPlural: string): TORMEntidadSimpleDef;


const
  icClave = 0;
  icDescripcion = 1;
  icDescripcionReducida = 2;
  icObservaciones=3;

implementation

uses uExpresiones, Contnrs;

function EntidadSimpleDefault(  const Tabla, CampoClave, NombreEntidad,
                                NombreEntidadPlural: string): TORMEntidadSimpleDef;
begin
  Result.Tabla := Tabla;
  Result.CampoClave := CampoClave;
  Result.CampoDescripcion := 'Descripcion';
  Result.CampoDescrReducida := 'DescripcionReducida';
  Result.CampoObservaciones := 'Observaciones';
  Result.NombreEntidad := NombreEntidad;
  Result.NombrePlural := NombreEntidadPlural;
  Result.ClaveEsIdentidad := true;
end;

function EntidadSimpleDefaultSoloDescripcion(  const Tabla, CampoClave, NombreEntidad,
                                NombreEntidadPlural: string): TORMEntidadSimpleDef;
begin
  Result.Tabla              := Tabla;
  Result.CampoClave         := CampoClave;
  Result.CampoDescripcion   := 'Descripcion';
  Result.CampoDescrReducida := '';
  Result.CampoObservaciones := '';
  Result.NombreEntidad      := NombreEntidad;
  Result.NombrePlural       := NombreEntidadPlural;
  Result.ClaveEsIdentidad   := true;
end;

function EntidadSimpleDefault(  CampoClave: TORMCampo;
                                NombreEntidad,
                                NombreEntidadPlural: string): TORMEntidadSimpleDef; overload;
begin
  Result.Tabla := CampoClave.Tabla;
  Result.CampoClave := CampoClave.Nombre;
  Result.CampoDescripcion := 'Descripcion';
  Result.CampoDescrReducida := 'DescripcionReducida';
  Result.CampoObservaciones := 'Observaciones';
  Result.NombreEntidad := NombreEntidad;
  Result.NombrePlural := NombreEntidadPlural;
  Result.ClaveEsIdentidad := CampoClave.EsIdentidad;
  CampoClave.Free;
end;

{ TEntidadSimple }

procedure TORMEntidadSimple.AsignarDatosEntidad(const Tabla, NombreCampoClave,
  NombreCampoDescripcion, NombreCampoDescrReducida,
  NombreCampoObservaciones: string;
  const ClaveEsIdentidad: boolean);
begin
  //FCampos := TColeccionCampos.Create;
  FTabla := Tabla;

  {
   Para el caso que la clave tenga una secuencia (generador), seria obligatorio
   que el generador se llame igual que la tabla
  }
  if ClaveEsIdentidad then
     FCampos.Agregar(TORMCampo.Create( Tabla, NombreCampoClave, Tabla, '', '', icClave,
                                    60, 0, 0, true, true, false, false, tdInteger, faNinguna, 0))
  else
     FCampos.Agregar(TORMCampo.Create( Tabla, NombreCampoClave, '', '', '', icClave,
                                    60,  0, 0, false, true, false, false, tdInteger, faNinguna, 0));
  FCampos.Agregar(TORMCampo.Create(Tabla, NombreCampoDescripcion, '', '', '',
                                icDescripcion, 60,  0, 0, false, false, false, false, tdString,
                                faNinguna, ''));
  FCampos.Agregar(TORMCampo.Create(Tabla, NombreCampoDescrReducida, '', '', '',
                                icDescripcionReducida, 60,  0, 0, false, false, true, false, tdString,
                                faNinguna, ''));
  FCampos.Agregar(TORMCampo.Create(Tabla, NombreCampoObservaciones, '', '', '',
                                icObservaciones, 60,  0, 0, false, false, true, false, tdString,
                                faNinguna, ''));
  EsNueva := true;
end;

procedure TORMEntidadSimple.CargarCombo(Items: TStringList);
var
  select : TSelectStatement;
  CamposCombo: TORMColeccionCampos;
  ChangeEvent : TNotifyEvent;
  Sorted : boolean;
begin
  CamposCombo := TORMColeccionCampos.Create;
  CamposCombo.Agregar(FCampos.ORMCampo[icClave].Clonar);
  CamposCombo.Agregar(FCampos.ORMCampo[icDescripcion].Clonar);
  select := TSelectStatement.Create(CamposCombo);
  select.Orden.Agregar( FCampos.ORMCampo[icDescripcion], toAscendente);

  Conexion.SQLManager.EjecutarSelect(select);
  ChangeEvent := Items.OnChange;
  Items.OnChange := nil;

  Sorted := Items.Sorted;
  Items.Sorted := false;

  Items.Clear;
  while not select.Datos.Eof do
  begin
    Items.AddObject(Select.Datos.Fields[1].AsString, TDatoCombo.Create(Select.Datos.Fields[0].AsInteger));
    select.Datos.Next;
  end;
  Select.Free;
  CamposCombo.Free;
  Items.Sorted := Sorted;
  Items.OnChange := ChangeEvent;
  Items.OnChange(nil);
end;

constructor TORMEntidadSimple.Create;
begin
  Create(nil);
end;

procedure TORMEntidadSimple.AsignarDatosEntidad(const DatosEntidadSimple: TORMEntidadSimpleDef);
begin
  AsignarDatosEntidad(  DatosEntidadSimple.Tabla,
                        DatosEntidadSimple.CampoClave,
                        DatosEntidadSimple.CampoDescripcion,
                        DatosEntidadSimple.CampoDescrReducida,
                        DatosEntidadSimple.CampoObservaciones,
                        DatosEntidadSimple.ClaveEsIdentidad);
end;


function TORMEntidadSimple.GetORMCampo(index: integer): TORMCampo;
begin
  Result := FCampos.ORMCampo[index];
end;

function TORMEntidadSimple.GetDescripcion: string;
begin
  Result := FCampos.ORMCampo[icDescripcion].AsString;
end;

function TORMEntidadSimple.GetDescrReducida: string;
begin
  Result := '';
  if not FCampos.ORMCampo[icDescripcionReducida].EsNulo then
    Result := FCampos.ORMCampo[icDescripcionReducida].AsString;
end;

function TORMEntidadSimple.GetID: integer;
begin
  Result := FCampos.ORMCampo[icClave].AsInteger;
end;

function TORMEntidadSimple.GetObservaciones: string;
begin
  Result := '';
  if not  FCampos.ORMCampo[icObservaciones].EsNulo then
    Result := FCampos.ORMCampo[icObservaciones].AsString;
end;

function TORMEntidadSimple.ObtenerEntidad(const EntidadID: integer): boolean;
var
  select : TSelectStatement;
begin
  select := TSelectStatement.Create(FCampos);
  select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.ORMCampo[icClave],
                                                        tcIgual, EntidadID));
  Result := AsignarCamposDesdeSeleccion(select);
  select.Free;
end;

procedure TORMEntidadSimple.SetDescripcion(const Value: string);
begin
  FCampos.ORMCampo[icDescripcion].AsString := Value;
end;

procedure TORMEntidadSimple.SetDescrReducida(const Value: string);
begin
  FCampos.ORMCampo[icDescripcionReducida].AsString := Value;
end;

procedure TORMEntidadSimple.SetID(const Value: integer);
begin
  FCampos.ORMCampo[icClave].AsInteger := Value;
end;

procedure TORMEntidadSimple.SetObservaciones(const Value: string);
begin
  FCampos.ORMCampo[icObservaciones].AsString := Value;
end;

{ TColeccionEntidadSimple }

constructor TORMColeccionEntidadSimple.Create(const Tabla, NombreCampoClave,
  NombreCampoDescripcion, NombreCampoDescrReducida,
  NombreCampoObservaciones: string; const ClaveEsIdentidad: boolean);
begin
  inherited Create(TORMEntidadSimple);

  FCampos := TORMColeccionCampos.Create;
  {
   Para el caso que la clave tenga una secuencia (generador), seria obligatorio
   que el generador se llame igual que la tabla
  }
  if ClaveEsIdentidad then
     FCampos.Agregar(TORMCampo.Create( Tabla, NombreCampoClave, Tabla, '', '', icClave,
                                    60,  0, 0, true, true, false, false, tdInteger, faNinguna, 0))
  else
     FCampos.Agregar(TORMCampo.Create( Tabla, NombreCampoClave, '', '', '', icClave,
                                    60,  0, 0, true, true, false, false, tdInteger, faNinguna, 0));

  FCampos.Agregar(TORMCampo.Create(Tabla, NombreCampoDescripcion, '', '', '',
                                icDescripcion, 60,  0, 0, false, false, false, false, tdString,
                                faNinguna, ''));
  FCampos.Agregar(TORMCampo.Create(Tabla, NombreCampoDescrReducida, '', '', '',
                                icDescripcionReducida, 60,  0, 0, false, false, true, false, tdString,
                                faNinguna, ''));
  FCampos.Agregar(TORMCampo.Create(Tabla, NombreCampoObservaciones, '', '', '',
                                icObservaciones, 60,  0, 0, false, false, true, false, tdString,
                                faNinguna, ''));

end;

constructor TORMColeccionEntidadSimple.Create(EntidadSimple: TORMEntidadSimple);
var
  nCampo : integer;
begin
  inherited Create(TORMEntidadSimple);

  FCampos := TORMColeccionCampos.Create;

  for nCampo := 0 to EntidadSimple.ORMCampos.Count - 1 do
  begin
    with EntidadSimple.ORMCampo[nCampo] do
      FCampos.Agregar(TORMCampo.Create(Tabla, Nombre, Secuencia, AliasCampo,
                                    AliasTabla, Indice, Longitud, Precision,
                                    Escala, EsIdentidad,
                                    EsClavePrimaria, EsClaveForanea, AceptaNull,
                                    TipoDato,FuncionAgregacion, ValorPorDefecto));
  end;
end;

function TORMColeccionEntidadSimple.GetEntidadSimple(
  index: integer): TORMEntidadSimple;
begin
  Result := Items[index] as TORMEntidadSimple;
end;

procedure TORMColeccionEntidadSimple.ProcesarDataSet;
var
  unaEntidad : TORMEntidadSimple;
begin
  with FSelectStatement do
  begin
    if not Datos.Active then
      Datos.Active := true;

    Datos.First;
    while not Datos.Eof  do
    begin
      //unaEntidad := Add as TEntidadSimple;
      unaEntidad := TORMEntidadSimple.Create(self);
      unaEntidad.AsignarDatosEntidad( FCampos.ORMCampo[icClave].Tabla,
                                      FCampos.ORMCampo[icClave].Nombre,
                                      FCampos.ORMCampo[icDescripcion].Nombre,
                                      FCampos.ORMCampo[icDescripcionReducida].Nombre,
                                      FCampos.ORMCampo[icObservaciones].Nombre,
                                      FCampos.ORMCampo[icClave].EsIdentidad);
      unaEntidad.ID := Datos.Fields[icClave].AsInteger;
      unaEntidad.Descripcion := Datos.Fields[icDescripcion].AsString;

      unaEntidad.ORMCampo[icDescripcionReducida].EsNulo := Datos.Fields[icDescripcionReducida].IsNull;
      if not unaEntidad.ORMCampo[icDescripcionReducida].EsNulo then
        unaEntidad.DescripcionReducida := Datos.Fields[icDescripcionReducida].AsString;

      unaEntidad.ORMCampo[icObservaciones].EsNulo := Datos.Fields[icObservaciones].IsNull;
      if not unaEntidad.ORMCampo[icObservaciones].EsNulo then
        unaEntidad.Observaciones := Datos.Fields[icObservaciones].AsString;

      unaEntidad.ORMCampos.FueronCambiados := false;
      Datos.Next;
    end;
  end;
end;

constructor TORMColeccionEntidadSimple.Create(
  const DatosEntidadSimple: TORMEntidadSimpleDef);
begin
  Create( DatosEntidadSimple.Tabla, DatosEntidadSimple.CampoClave,
          DatosEntidadSimple.CampoDescripcion,
          DatosEntidadSimple.CampoDescrReducida,
          DatosEntidadSimple.CampoObservaciones,
          DatosEntidadSimple.ClaveEsIdentidad);
end;

end.

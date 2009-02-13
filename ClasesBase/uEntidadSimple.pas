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

  TEntidadSimpleDef = record
    Tabla: string;
    CampoClave: string;
    CampoDescripcion: string;
    CampoDescrReducida: string;
    CampoObservaciones: string;
    ClaveEsIdentidad: boolean;
    NombreEntidad : string;
    NombrePlural: string;
  end;

  TEntidadSimple = class(TEntidadBase)
  private
    function GetDescripcion: string;
    function GetDescrReducida: string;
    function GetID: integer;
    function GetObservaciones: string;
    procedure SetDescripcion(const Value: string);
    procedure SetDescrReducida(const Value: string);
    procedure SetID(const Value: integer);
    procedure SetObservaciones(const Value: string);
    function GetCampo(index: integer): TCampo;
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
    procedure AsignarDatosEntidad(const DatosEntidadSimple: TEntidadSimpleDef); overload;

    function ObtenerEntidad(const EntidadID: integer): boolean; virtual;
    procedure CargarCombo(Items: TStringList);
    property Campo[index: integer]: TCampo read GetCampo;
  published
    property ID: integer read GetID write SetID;
    property Descripcion: string read GetDescripcion write SetDescripcion;
    property DescripcionReducida: string read GetDescrReducida write SetDescrReducida;
    property Observaciones: string read GetObservaciones write SetObservaciones;
  end;

  TColeccionEntidadSimple = class(TColeccionEntidades)
  private
    function GetEntidadSimple(index: integer): TEntidadSimple;
  protected
    procedure ProcesarDataSet; override;
  published
  public
    constructor Create( const Tabla: string; const NombreCampoClave: string;
                        const NombreCampoDescripcion: string = 'Descripcion';
                        const NombreCampoDescrReducida: string = 'DescripcionReducida';
                        const NombreCampoObservaciones: string = 'Observaciones';
                        const ClaveEsIdentidad: boolean = false); overload;
    constructor Create( EntidadSimple: TEntidadSimple); overload;
    constructor Create(const DatosEntidadSimple: TEntidadSimpleDef); overload;
    property EntidadSimple[index: integer]: TEntidadSimple read GetEntidadSimple;
  end;

  function EntidadSimpleDefault(const Tabla, CampoClave, NombreEntidad,
                                NombreEntidadPlural: string): TEntidadSimpleDef; overload;
  function EntidadSimpleDefault(CampoClave: TCampo;
                                NombreEntidad,
                                NombreEntidadPlural: string): TEntidadSimpleDef; overload;

const
  icClave = 0;
  icDescripcion = 1;
  icDescripcionReducida = 2;
  icObservaciones=3;

implementation

uses uExpresiones, Contnrs;

function EntidadSimpleDefault(  const Tabla, CampoClave, NombreEntidad,
                                NombreEntidadPlural: string): TEntidadSimpleDef;
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

function EntidadSimpleDefault(  CampoClave: TCampo;
                                NombreEntidad,
                                NombreEntidadPlural: string): TEntidadSimpleDef; overload;
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

procedure TEntidadSimple.AsignarDatosEntidad(const Tabla, NombreCampoClave,
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
     FCampos.Agregar(TCampo.Create( Tabla, NombreCampoClave, Tabla, '', '', icClave,
                                    60, true, true, false, false, tdInteger, faNinguna, 0))
  else
     FCampos.Agregar(TCampo.Create( Tabla, NombreCampoClave, '', '', '', icClave,
                                    60, false, true, false, false, tdInteger, faNinguna, 0));
  FCampos.Agregar(TCampo.Create(Tabla, NombreCampoDescripcion, '', '', '',
                                icDescripcion, 60, false, false, false, false, tdString,
                                faNinguna, ''));
  FCampos.Agregar(TCampo.Create(Tabla, NombreCampoDescrReducida, '', '', '',
                                icDescripcionReducida, 60, false, false, true, false, tdString,
                                faNinguna, ''));
  FCampos.Agregar(TCampo.Create(Tabla, NombreCampoObservaciones, '', '', '',
                                icObservaciones, 60, false, false, true, false, tdString,
                                faNinguna, ''));
  EsNueva := true;
end;

procedure TEntidadSimple.CargarCombo(Items: TStringList);
var
  select : TSelectStatement;
  CamposCombo: TColeccionCampos;
  ChangeEvent : TNotifyEvent;
  Sorted : boolean;
begin
  CamposCombo := TColeccionCampos.Create;
  CamposCombo.Agregar(FCampos.Campo[icClave].Clonar);
  CamposCombo.Agregar(FCampos.Campo[icDescripcion].Clonar);
  select := TSelectStatement.Create(CamposCombo);
  select.Orden.Agregar( FCampos.Campo[icDescripcion], toAscendente);

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

constructor TEntidadSimple.Create;
begin
  Create(nil);
end;

procedure TEntidadSimple.AsignarDatosEntidad(const DatosEntidadSimple: TEntidadSimpleDef);
begin
  AsignarDatosEntidad(  DatosEntidadSimple.Tabla,
                        DatosEntidadSimple.CampoClave,
                        DatosEntidadSimple.CampoDescripcion,
                        DatosEntidadSimple.CampoDescrReducida,
                        DatosEntidadSimple.CampoObservaciones,
                        DatosEntidadSimple.ClaveEsIdentidad);
end;


function TEntidadSimple.GetCampo(index: integer): TCampo;
begin
  Result := FCampos.Campo[index];
end;

function TEntidadSimple.GetDescripcion: string;
begin
  Result := FCampos.Campo[icDescripcion].AsString;
end;

function TEntidadSimple.GetDescrReducida: string;
begin
  Result := '';
  if not FCampos.Campo[icDescripcionReducida].EsNulo then
    Result := FCampos.Campo[icDescripcionReducida].AsString;
end;

function TEntidadSimple.GetID: integer;
begin
  Result := FCampos.Campo[icClave].AsInteger;
end;

function TEntidadSimple.GetObservaciones: string;
begin
  Result := '';
  if not  FCampos.Campo[icObservaciones].EsNulo then
    Result := FCampos.Campo[icObservaciones].AsString;
end;

function TEntidadSimple.ObtenerEntidad(const EntidadID: integer): boolean;
var
  select : TSelectStatement;
begin
  select := TSelectStatement.Create(FCampos);
  select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.Campo[icClave],
                                                        tcIgual, EntidadID));
  Result := AsignarCamposDesdeSeleccion(select);
  select.Free;
end;

procedure TEntidadSimple.SetDescripcion(const Value: string);
begin
  FCampos.Campo[icDescripcion].AsString := Value;
end;

procedure TEntidadSimple.SetDescrReducida(const Value: string);
begin
  FCampos.Campo[icDescripcionReducida].AsString := Value;
end;

procedure TEntidadSimple.SetID(const Value: integer);
begin
  FCampos.Campo[icClave].AsInteger := Value;
end;

procedure TEntidadSimple.SetObservaciones(const Value: string);
begin
  FCampos.Campo[icObservaciones].AsString := Value;
end;

{ TColeccionEntidadSimple }

constructor TColeccionEntidadSimple.Create(const Tabla, NombreCampoClave,
  NombreCampoDescripcion, NombreCampoDescrReducida,
  NombreCampoObservaciones: string; const ClaveEsIdentidad: boolean);
begin
  inherited Create(TEntidadSimple);

  FCampos := TColeccionCampos.Create;
  {
   Para el caso que la clave tenga una secuencia (generador), seria obligatorio
   que el generador se llame igual que la tabla
  }
  if ClaveEsIdentidad then
     FCampos.Agregar(TCampo.Create( Tabla, NombreCampoClave, Tabla, '', '', icClave,
                                    60, true, true, false, false, tdInteger, faNinguna, 0))
  else
     FCampos.Agregar(TCampo.Create( Tabla, NombreCampoClave, '', '', '', icClave,
                                    60, true, true, false, false, tdInteger, faNinguna, 0));

  FCampos.Agregar(TCampo.Create(Tabla, NombreCampoDescripcion, '', '', '',
                                icDescripcion, 60, false, false, false, false, tdString,
                                faNinguna, ''));
  FCampos.Agregar(TCampo.Create(Tabla, NombreCampoDescrReducida, '', '', '',
                                icDescripcionReducida, 60, false, false, true, false, tdString,
                                faNinguna, ''));
  FCampos.Agregar(TCampo.Create(Tabla, NombreCampoObservaciones, '', '', '',
                                icObservaciones, 60, false, false, true, false, tdString,
                                faNinguna, ''));

end;

constructor TColeccionEntidadSimple.Create(EntidadSimple: TEntidadSimple);
var
  nCampo : integer;
begin
  inherited Create(TEntidadSimple);

  FCampos := TColeccionCampos.Create;

  for nCampo := 0 to EntidadSimple.Campos.Count - 1 do
  begin
    with EntidadSimple.Campo[nCampo] do
      FCampos.Agregar(TCampo.Create(Tabla, Nombre, Secuencia, AliasCampo,
                                    AliasTabla, Indice, Longitud, EsIdentidad,
                                    EsClavePrimaria, EsClaveForanea, AceptaNull,
                                    TipoDato,FuncionAgregacion, ValorPorDefecto));
  end;
end;

function TColeccionEntidadSimple.GetEntidadSimple(
  index: integer): TEntidadSimple;
begin
  Result := Items[index] as TEntidadSimple;
end;

procedure TColeccionEntidadSimple.ProcesarDataSet;
var
  unaEntidad : TEntidadSimple;
begin
  with FSelectStatement do
  begin
    if not Datos.Active then
      Datos.Active := true;

    Datos.First;
    while not Datos.Eof  do
    begin
      //unaEntidad := Add as TEntidadSimple;
      unaEntidad := TEntidadSimple.Create(self);
      unaEntidad.AsignarDatosEntidad( FCampos.Campo[icClave].Tabla,
                                      FCampos.Campo[icClave].Nombre,
                                      FCampos.Campo[icDescripcion].Nombre,
                                      FCampos.Campo[icDescripcionReducida].Nombre,
                                      FCampos.Campo[icObservaciones].Nombre,
                                      FCampos.Campo[icClave].EsIdentidad);
      unaEntidad.ID := Datos.Fields[icClave].AsInteger;
      unaEntidad.Descripcion := Datos.Fields[icDescripcion].AsString;

      unaEntidad.Campo[icDescripcionReducida].EsNulo := Datos.Fields[icDescripcionReducida].IsNull;
      if not unaEntidad.Campo[icDescripcionReducida].EsNulo then
        unaEntidad.DescripcionReducida := Datos.Fields[icDescripcionReducida].AsString;

      unaEntidad.Campo[icObservaciones].EsNulo := Datos.Fields[icObservaciones].IsNull;
      if not unaEntidad.Campo[icObservaciones].EsNulo then
        unaEntidad.Observaciones := Datos.Fields[icObservaciones].AsString;

      unaEntidad.Campos.FueronCambiados := false;
      Datos.Next;
    end;
  end;
end;

constructor TColeccionEntidadSimple.Create(
  const DatosEntidadSimple: TEntidadSimpleDef);
begin
  Create( DatosEntidadSimple.Tabla, DatosEntidadSimple.CampoClave,
          DatosEntidadSimple.CampoDescripcion,
          DatosEntidadSimple.CampoDescrReducida,
          DatosEntidadSimple.CampoObservaciones,
          DatosEntidadSimple.ClaveEsIdentidad);
end;

end.

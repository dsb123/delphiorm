{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uEntidadSimpleCombo.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uEntidadSimpleCombo;

interface

uses  uEntidades, uEntidadSimple, uColeccionEntidades,
      uSQLBuilder, uCampos, Classes, uExpresiones;

type
  TEntidadSimpleComboDef = record
    Tabla: string;
    CampoClave: string;
    CampoDescripcion: string;
    CampoDescrReducida: string;
    CampoObservaciones: string;
    ClaveEsIdentidad: boolean;

    Relacion: TRelacionDefSimple;
    EntidadSimpleAsociada: TEntidadSimpleDef;

    NombreEntidad : string;
    NombrePlural: string;
  end;

  TEntidadSimpleCombo = class(TEntidadBase)
  private
    FEntidadAsociada: TEntidadSimple;

    function GetCampo(index: integer): TCampo;
    function GetDescripcion: string;
    function GetDescripcionForanea: string;
    function GetDescripcionReducida: string;
    function GetID: integer;
    function GetIDForaneao: integer;
    function GetObservaciones: string;
    procedure SetDescripcion(const Value: string);
    procedure SetDescripcionReducida(const Value: string);
    procedure SetID(const Value: integer);
    procedure SetIDForaneo(const Value: integer);
    procedure SetObservaciones(const Value: string);
    function GetEntidadAsociada: TEntidadSimple;
    procedure SetDescripcionForanea(const Value: string);
  public
    DES : TEntidadSimpleDef;
    Relacion: TRelacionDefSimple;
    constructor Create; overload;
    procedure AsignarDatosEntidad(  Tabla: string; NombreCampoClave: string;
                                    ES: TEntidadSimpleDef;
                                    unaRelacion: TRelacionDefSimple;
                                    NombreCampoDescripcion: string = 'Descripcion';
                                    NombreCampoDescrReducida: string = 'DescripcionReducida';
                                    NombreCampoObservaciones: string = 'Observaciones';
                                    ClaveEsIdentidad: boolean = true); overload;
    procedure AsignarDatosEntidad( ESC: TEntidadSimpleComboDef); overload;
    destructor Destroy; override;
    function ObtenerEntidad(EntidadID: integer): boolean; virtual;
    property EntidadAsociada: TEntidadSimple read GetEntidadAsociada;
    property Campo[index: integer]: TCampo read GetCampo;
  published
    property ID: integer read GetID write SetID;
    property IDForeaneo: integer read GetIDForaneao write SetIDForaneo;
    property Descripcion: string read GetDescripcion write SetDescripcion;
    property DescripcionReducida: string read GetDescripcionReducida write SetDescripcionReducida;
    property Observaciones: string read GetObservaciones write SetObservaciones;
    property DescripcionForanea: string read GetDescripcionForanea write SetDescripcionForanea;
  end;

  TColeccionEntidadSimpleCombo = class(TColeccionEntidades)
  private
    FDES : TEntidadSimpleDef;
    FRelacion: TRelacionDefSimple;

    function GetEntidadSimpleCombo(index: integer): TEntidadSimpleCombo;
  protected
    procedure ProcesarDataSet; override;
  published
  public
    function ObtenerTodos: integer; override;
    procedure AsignarDatosEntidad(  Tabla: string; NombreCampoClave: string;
                                    NombreEntidad: string; NombrePlural: string;
                                    ES: TEntidadSimpleDef;
                                    Relacion: TRelacionDefSimple;
                                    NombreCampoDescripcion: string = 'Descripcion';
                                    NombreCampoDescrReducida: string = 'DescripcionReducida';
                                    NombreCampoObservaciones: string = 'Observaciones';
                                    ClaveEsIdentidad: boolean = true); overload;
    procedure AsignarDatosEntidad(ESC: TEntidadSimpleComboDef); overload;
    procedure AsignarDatosEntidad(EntidadSimpleCombo: TEntidadSimpleCombo); overload;
    property EntidadSimpleCombo[index: integer]: TEntidadSimpleCombo read GetEntidadSimpleCombo;
  end;

  function EntidadSimpleComboDefault( Tabla, CampoClave, CampoClaveForanea,
                                      TablaEntidadAsociada, CampoClaveEntidadAsociada,
                                      NombreEntidad,
                                      NombreEntidadPlural,
                                      NombreEntidadAsoc,
                                      NombreEntidadAsocPlural: string): TEntidadSimpleComboDef; overload;
  function EntidadSimpleComboDefault( CampoClave, CampoClaveForanea,
                                      CampoClaveEntidadAsociada: TCampo;
                                      NombreEntidad,
                                      NombreEntidadPlural,
                                      NombreEntidadAsoc,
                                      NombreEntidadAsocPlural: string): TEntidadSimpleComboDef; overload;


const
  icClave = 0;
  icDescripcion = 1;
  icDescripcionReducida = 2;
  icObservaciones = 3;
  icClaveForanea = 4;
  icDescripcionForanea = 5;

implementation

uses Contnrs, SysUtils;

function EntidadSimpleComboDefault( Tabla, CampoClave, CampoClaveForanea,
                                    TablaEntidadAsociada, CampoClaveEntidadAsociada,
                                    NombreEntidad,
                                    NombreEntidadPlural,
                                    NombreEntidadAsoc,
                                    NombreEntidadAsocPlural: string): TEntidadSimpleComboDef;
begin
  Result.Tabla := Tabla;
  Result.CampoClave := CampoClave;
  Result.CampoDescripcion := 'Descripcion';
  Result.CampoDescrReducida := 'DescripcionReducida';
  Result.CampoObservaciones := 'Observaciones';
  Result.ClaveEsIdentidad := true;
  Result.EntidadSimpleAsociada := EntidadSimpleDefault( TablaEntidadAsociada,
                                                        CampoClaveEntidadAsociada,
                                                        NombreEntidadAsoc,
                                                        NombreEntidadAsocPlural);
  Result.Relacion.CampoPrimario.Tabla := Tabla;
  Result.Relacion.CampoPrimario.Campo := CampoClaveForanea;
  Result.Relacion.CampoForaneo.Tabla := TablaEntidadAsociada;
  Result.Relacion.CampoForaneo.Campo := CampoClaveEntidadAsociada;
  Result.Relacion.TipoRelacion := trAmbas;
  Result.NombreEntidad := NombreEntidad;
  Result.NombrePlural := NombreEntidadPlural;
end;

function EntidadSimpleComboDefault( CampoClave, CampoClaveForanea,
                                    CampoClaveEntidadAsociada: TCampo;
                                    NombreEntidad,
                                    NombreEntidadPlural,
                                    NombreEntidadAsoc,
                                    NombreEntidadAsocPlural: string): TEntidadSimpleComboDef; overload;
begin
  Result.Tabla := CampoClave.Tabla;
  Result.CampoClave := CampoClave.Nombre;
  Result.CampoDescripcion := 'Descripcion';
  Result.CampoDescrReducida := 'DescripcionReducida';
  Result.CampoObservaciones := 'Observaciones';
  Result.ClaveEsIdentidad := CampoClave.EsIdentidad;

  Result.EntidadSimpleAsociada := EntidadSimpleDefault( CampoClaveEntidadAsociada.Tabla,
                                                        CampoClaveEntidadAsociada.Nombre,
                                                        NombreEntidadAsoc,
                                                        NombreEntidadAsocPlural);
  Result.Relacion.CampoPrimario.Tabla := CampoClaveForanea.Tabla;
  Result.Relacion.CampoPrimario.Campo := CampoClaveForanea.Nombre;
  Result.Relacion.CampoForaneo.Tabla := CampoClaveEntidadAsociada.Tabla;
  Result.Relacion.CampoForaneo.Campo := CampoClaveEntidadAsociada.Nombre;
  Result.Relacion.TipoRelacion := trAmbas;
  Result.NombreEntidad := NombreEntidad;
  Result.NombrePlural := NombreEntidadPlural;

  CampoClave.Free;
  CampoClaveForanea.Free;
  CampoClaveEntidadAsociada.Free;
end;

{ TEntidadSimpleCombo }

procedure TEntidadSimpleCombo.AsignarDatosEntidad(Tabla, NombreCampoClave: string;
  ES: TEntidadSimpleDef;
  unaRelacion: TRelacionDefSimple;
  NombreCampoDescripcion, NombreCampoDescrReducida,
  NombreCampoObservaciones: string;
  ClaveEsIdentidad: boolean);
begin
  //FCampos := TColeccionCampos.Create;
  FTabla := Tabla;

  DES := ES;
  Relacion := unaRelacion;

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
  FCampos.Agregar(TCampo.Create(Tabla, unaRelacion.CampoPrimario.Campo, '', '', '',
                                icClaveForanea, 10, false, false, true, true, tdInteger,
                                faNinguna, 0));
  FCampos.Agregar(TCampo.Create(ES.Tabla, ES.CampoDescripcion, '', '', '',
                                icDescripcionForanea, 60, false, false, true, false, tdString,
                                faNinguna, 0));
  FEntidadAsociada := nil;

  EsNueva := true;
end;

procedure TEntidadSimpleCombo.AsignarDatosEntidad(ESC: TEntidadSimpleComboDef);
begin
  AsignarDatosEntidad(  ESC.Tabla, ESC.CampoClave,
                        ESC.EntidadSimpleAsociada, ESC.Relacion, ESC.CampoDescripcion,
                        ESC.CampoDescrReducida, ESC.CampoObservaciones,
                        ESC.ClaveEsIdentidad);
end;

constructor TEntidadSimpleCombo.Create;
begin
  Create(nil);
end;

destructor TEntidadSimpleCombo.Destroy;
begin
  if assigned(FEntidadAsociada) then
    FEntidadAsociada.Free;

  inherited;
end;

function TEntidadSimpleCombo.GetCampo(index: integer): TCampo;
begin
  Result := FCampos.Campo[index];
end;

function TEntidadSimpleCombo.GetDescripcion: string;
begin
  Result := FCampos.Campo[icDescripcion].AsString;
end;

function TEntidadSimpleCombo.GetDescripcionForanea: string;
begin
  Result := '';
  if not FCampos.Campo[icDescripcionForanea].EsNulo then
    Result := FCampos.Campo[icDescripcionForanea].AsString;
end;

function TEntidadSimpleCombo.GetDescripcionReducida: string;
begin
  Result := '';
  if not FCampos.Campo[icDescripcionReducida].EsNulo then
    Result := FCampos.Campo[icDescripcionReducida].AsString;
end;

function TEntidadSimpleCombo.GetEntidadAsociada: TEntidadSimple;
begin
  if not assigned(EntidadAsociada) then begin
    FEntidadAsociada :=TEntidadSimple.Create;
    FEntidadAsociada.AsignarDatosEntidad(DES);
    FEntidadAsociada.ObtenerEntidad(FCampos.Campo[icClaveForanea].AsInteger);
  end;
  Result := FEntidadAsociada;
end;

function TEntidadSimpleCombo.GetID: integer;
begin
  Result := FCampos.Campo[icClave].AsInteger;
end;

function TEntidadSimpleCombo.GetIDForaneao: integer;
begin
  Result := -1;
  if not FCampos.Campo[icClaveForanea].EsNulo then
    Result := FCampos.Campo[icClaveForanea].AsInteger;;
end;

function TEntidadSimpleCombo.GetObservaciones: string;
begin
  Result := '';
  if not  FCampos.Campo[icObservaciones].EsNulo then
    Result := FCampos.Campo[icObservaciones].AsString;
end;

function TEntidadSimpleCombo.ObtenerEntidad(EntidadID: integer): boolean;
var
  select : TSelectStatement;
begin
  select := TSelectStatement.Create(FCampos);
  select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.Campo[icClave],
                                                        tcIgual, EntidadID));

  select.Relaciones.Agregar(Relacion.CampoPrimario.Tabla,
                            Relacion.CampoPrimario.Campo,
                            Relacion.CampoForaneo.Tabla,
                            Relacion.CampoForaneo.Campo,
                            Relacion.TipoRelacion);

  Result := AsignarCamposDesdeSeleccion(select);
  select.Free;
end;

procedure TEntidadSimpleCombo.SetDescripcion(const Value: string);
begin
  FCampos.Campo[icDescripcion].AsString := Value;
end;

procedure TEntidadSimpleCombo.SetDescripcionForanea(const Value: string);
begin
  FCampos.Campo[icDescripcionForanea].AsString := Value;
  FCampos.Campo[icDescripcionForanea].FueCambiado := false;
end;

procedure TEntidadSimpleCombo.SetDescripcionReducida(const Value: string);
begin
  FCampos.Campo[icDescripcionReducida].AsString := Value;
end;

procedure TEntidadSimpleCombo.SetID(const Value: integer);
begin
  FCampos.Campo[icClave].AsInteger := Value;
end;

procedure TEntidadSimpleCombo.SetIDForaneo(const Value: integer);
begin
  FCampos.Campo[icClaveForanea].AsInteger := Value;
end;

procedure TEntidadSimpleCombo.SetObservaciones(const Value: string);
begin
  FCampos.Campo[icObservaciones].AsString := Value;
end;

{ TColeccionEntidadSimpleCombo }

procedure TColeccionEntidadSimpleCombo.AsignarDatosEntidad(Tabla, NombreCampoClave,
  NombreEntidad, NombrePlural: string; ES: TEntidadSimpleDef;
  Relacion: TRelacionDefSimple; NombreCampoDescripcion,
  NombreCampoDescrReducida, NombreCampoObservaciones: string;
  ClaveEsIdentidad: boolean);
begin
  FCampos := TColeccionCampos.Create;

  FDES := ES;
  FRelacion := Relacion;

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
  FCampos.Agregar(TCampo.Create(Tabla, Relacion.CampoPrimario.Campo, '', '', '',
                                icClaveForanea, 10, false, false, true, true, tdInteger,
                                faNinguna, 0));
  FCampos.Agregar(TCampo.Create(ES.Tabla, ES.CampoDescripcion, '', '', '',
                                icDescripcionForanea, 60, false, false, true, false, tdString,
                                faNinguna, 0));
end;

procedure TColeccionEntidadSimpleCombo.AsignarDatosEntidad(
  ESC: TEntidadSimpleComboDef);
begin
  AsignarDatosEntidad(  ESC.Tabla, ESC.CampoClave, ESC.NombreEntidad,
                        ESC.NombrePlural, ESC.EntidadSimpleAsociada,
                        ESC.Relacion, ESC.CampoDescripcion,
                        ESC.CampoDescrReducida, ESC.CampoObservaciones,
                        ESC.ClaveEsIdentidad);
end;

procedure TColeccionEntidadSimpleCombo.AsignarDatosEntidad(
  EntidadSimpleCombo: TEntidadSimpleCombo);
var
  nCampo : integer;
begin
  FCampos := TColeccionCampos.Create;

  for nCampo := 0 to EntidadSimpleCombo.Campos.Count - 1 do
  begin
    with EntidadSimpleCombo.Campo[nCampo] do
      FCampos.Agregar(TCampo.Create(Tabla, Nombre, Secuencia, AliasCampo,
                                    AliasTabla, Indice, Longitud, EsIdentidad,
                                    EsClavePrimaria, EsClaveForanea, AceptaNull, TipoDato,
                                    FuncionAgregacion, ValorPorDefecto));
  end;
end;

function TColeccionEntidadSimpleCombo.GetEntidadSimpleCombo(
  index: integer): TEntidadSimpleCombo;
begin
  Result := Items[index] as TEntidadSimpleCombo;
end;

function TColeccionEntidadSimpleCombo.ObtenerTodos: integer;
var
  orden : TExpresionOrdenamiento;
  Relacion: TExpresionRelacion;
begin
  orden := TExpresionOrdenamiento.Create;
  Relacion := TExpresionRElacion.Create(FRelacion);
  orden.Agregar(FCampos.Campo[icDescripcionForanea], toAscendente);
  orden.Agregar(FCampos.Campo[icDescripcion], toAscendente);
  Result := ObtenerMuchos(nil, orden, nil, Relacion);
  Relacion.Free;
  orden.Free;
end;

procedure TColeccionEntidadSimpleCombo.ProcesarDataSet;
var
  unaEntidad : TEntidadSimpleCombo;
begin
  with FSelectStatement do
  begin
    if not Datos.Active then
      Datos.Active := true;

    Datos.First;
    while not Datos.Eof  do
    begin
      //unaEntidad := Add as TEntidadSimpleCombo;
      unaEntidad := TEntidadSimpleCombo.Create(Self);
      unaEntidad.AsignarDatosEntidad( FCampos.Campo[icClave].Tabla,
                                      FCampos.Campo[icClave].Nombre,
                                      FDES,
                                      Relaciones.Relacion[0].ObtenerDefinicion,
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

      unaEntidad.Campo[icClaveForanea].EsNulo := Datos.Fields[icClaveForanea].IsNull;
      if not unaEntidad.Campo[icClaveForanea].EsNulo then
        unaEntidad.IDForeaneo := Datos.Fields[icClaveForanea].AsInteger;

      unaEntidad.Campo[icDescripcionForanea].EsNulo := Datos.Fields[icDescripcionForanea].IsNull;
      if not unaEntidad.Campo[icDescripcionForanea].EsNulo then
        unaEntidad.DescripcionForanea := Datos.Fields[icDescripcionForanea].AsString;

      unaEntidad.Campos.FueronCambiados := false;
      Datos.Next;
    end;
  end;
end;

end.

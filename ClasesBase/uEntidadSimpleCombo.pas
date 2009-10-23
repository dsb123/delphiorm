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
  TORMEntidadSimpleComboDef = record
    Tabla: string;
    CampoClave: string;
    CampoDescripcion: string;
    CampoDescrReducida: string;
    CampoObservaciones: string;
    ClaveEsIdentidad: boolean;

    Relacion: TORMRelacionDefSimple;
    EntidadSimpleAsociada: TORMEntidadSimpleDef;

    NombreEntidad : string;
    NombrePlural: string;
  end;

  TORMEntidadSimpleCombo = class(TORMEntidadBase)
  private
    FEntidadAsociada: TORMEntidadSimple;

    function GetORMCampo(index: integer): TORMCampo;
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
    function GetEntidadAsociada: TORMEntidadSimple;
    procedure SetDescripcionForanea(const Value: string);
  public
    DES : TORMEntidadSimpleDef;
    Relacion: TORMRelacionDefSimple;
    constructor Create; overload;
    procedure AsignarDatosEntidad(  Tabla: string; NombreCampoClave: string;
                                    ES: TORMEntidadSimpleDef;
                                    unaRelacion: TORMRelacionDefSimple;
                                    NombreCampoDescripcion: string = 'Descripcion';
                                    NombreCampoDescrReducida: string = 'DescripcionReducida';
                                    NombreCampoObservaciones: string = 'Observaciones';
                                    ClaveEsIdentidad: boolean = true); overload;
    procedure AsignarDatosEntidad( ESC: TORMEntidadSimpleComboDef); overload;
    destructor Destroy; override;
    function ObtenerEntidad(EntidadID: integer): boolean; virtual;
    property EntidadAsociada: TORMEntidadSimple read GetEntidadAsociada;
    property ORMCampo[index: integer]: TORMCampo read GetORMCampo;
  published
    property ID: integer read GetID write SetID;
    property IDForeaneo: integer read GetIDForaneao write SetIDForaneo;
    property Descripcion: string read GetDescripcion write SetDescripcion;
    property DescripcionReducida: string read GetDescripcionReducida write SetDescripcionReducida;
    property Observaciones: string read GetObservaciones write SetObservaciones;
    property DescripcionForanea: string read GetDescripcionForanea write SetDescripcionForanea;
  end;

  TORMColeccionEntidadSimpleCombo = class(TORMColeccionEntidades)
  private
    FDES : TORMEntidadSimpleDef;
    FRelacion: TORMRelacionDefSimple;

    function GetEntidadSimpleCombo(index: integer): TORMEntidadSimpleCombo;
  protected
    procedure ProcesarDataSet; override;
  published
  public
    function ObtenerTodos: integer; override;
    procedure AsignarDatosEntidad(  Tabla: string; NombreCampoClave: string;
                                    NombreEntidad: string; NombrePlural: string;
                                    ES: TORMEntidadSimpleDef;
                                    Relacion: TORMRelacionDefSimple;
                                    NombreCampoDescripcion: string = 'Descripcion';
                                    NombreCampoDescrReducida: string = 'DescripcionReducida';
                                    NombreCampoObservaciones: string = 'Observaciones';
                                    ClaveEsIdentidad: boolean = true); overload;
    procedure AsignarDatosEntidad(ESC: TORMEntidadSimpleComboDef); overload;
    procedure AsignarDatosEntidad(EntidadSimpleCombo: TORMEntidadSimpleCombo); overload;
    property ORMEntidadSimpleCombo[index: integer]: TORMEntidadSimpleCombo read GetEntidadSimpleCombo;
  end;

  function EntidadSimpleComboDefault( Tabla, CampoClave, CampoClaveForanea,
                                      TablaEntidadAsociada, CampoClaveEntidadAsociada,
                                      NombreEntidad,
                                      NombreEntidadPlural,
                                      NombreEntidadAsoc,
                                      NombreEntidadAsocPlural: string): TORMEntidadSimpleComboDef; overload;
  function EntidadSimpleComboDefault( CampoClave, CampoClaveForanea,
                                      CampoClaveEntidadAsociada: TORMCampo;
                                      NombreEntidad,
                                      NombreEntidadPlural,
                                      NombreEntidadAsoc,
                                      NombreEntidadAsocPlural: string): TORMEntidadSimpleComboDef; overload;
  function EntidadSimpleComboDefaultSoloDescripcion(  Tabla, CampoClave, CampoClaveForanea,
                                                      TablaEntidadAsociada, CampoClaveEntidadAsociada,
                                                      NombreEntidad,
                                                      NombreEntidadPlural,
                                                      NombreEntidadAsoc,
                                                      NombreEntidadAsocPlural: string): TORMEntidadSimpleComboDef;


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
                                    NombreEntidadAsocPlural: string): TORMEntidadSimpleComboDef;
begin
  Result.Tabla := Tabla;
  Result.CampoClave := CampoClave;
  Result.CampoDescripcion := 'Descripcion';
  Result.CampoDescrReducida := 'DescripcionReducida';
  Result.CampoObservaciones := 'Observaciones';  Result.ClaveEsIdentidad := true;
  Result.EntidadSimpleAsociada := EntidadSimpleDefault( TablaEntidadAsociada,
                                                                        CampoClaveEntidadAsociada,
                                                                        NombreEntidadAsoc,
                                                                        NombreEntidadAsocPlural);
  Result.Relacion.CampoPrimario.Tabla := TablaEntidadAsociada;
  Result.Relacion.CampoPrimario.Campo := CampoClaveEntidadAsociada;
  Result.Relacion.CampoForaneo.Tabla := Tabla;
  Result.Relacion.CampoForaneo.Campo := CampoClaveForanea;
  Result.Relacion.TipoRelacion := trAmbas;
  Result.NombreEntidad := NombreEntidad;
  Result.NombrePlural := NombreEntidadPlural;
end;

function EntidadSimpleComboDefaultSoloDescripcion(  Tabla, CampoClave, CampoClaveForanea,
                                                    TablaEntidadAsociada, CampoClaveEntidadAsociada,
                                                    NombreEntidad,
                                                    NombreEntidadPlural,
                                                    NombreEntidadAsoc,
                                                    NombreEntidadAsocPlural: string): TORMEntidadSimpleComboDef;
begin
  Result.Tabla := Tabla;
  Result.CampoClave := CampoClave;
  Result.CampoDescripcion := 'Descripcion';
  Result.CampoDescrReducida := '';
  Result.CampoObservaciones := '';
  Result.ClaveEsIdentidad := true;
  Result.EntidadSimpleAsociada := EntidadSimpleDefaultSoloDescripcion(  TablaEntidadAsociada,
                                                                        CampoClaveEntidadAsociada,
                                                                        NombreEntidadAsoc,
                                                                        NombreEntidadAsocPlural);
  Result.Relacion.CampoPrimario.Tabla := TablaEntidadAsociada;
  Result.Relacion.CampoPrimario.Campo := CampoClaveEntidadAsociada;
  Result.Relacion.CampoForaneo.Tabla := Tabla;
  Result.Relacion.CampoForaneo.Campo := CampoClaveForanea;
  Result.Relacion.TipoRelacion := trAmbas;
  Result.NombreEntidad := NombreEntidad;
  Result.NombrePlural := NombreEntidadPlural;
end;

function EntidadSimpleComboDefault( CampoClave, CampoClaveForanea,
                                    CampoClaveEntidadAsociada: TORMCampo;
                                    NombreEntidad,
                                    NombreEntidadPlural,
                                    NombreEntidadAsoc,
                                    NombreEntidadAsocPlural: string): TORMEntidadSimpleComboDef; overload;
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
  Result.Relacion.CampoPrimario.Tabla := CampoClaveEntidadAsociada.Tabla;
  Result.Relacion.CampoPrimario.Campo := CampoClaveEntidadAsociada.Nombre;
  Result.Relacion.CampoForaneo.Tabla := CampoClaveForanea.Tabla;
  Result.Relacion.CampoForaneo.Campo := CampoClaveForanea.Nombre;
  Result.Relacion.TipoRelacion := trAmbas;
  Result.NombreEntidad := NombreEntidad;
  Result.NombrePlural := NombreEntidadPlural;

  CampoClave.Free;
  CampoClaveForanea.Free;
  CampoClaveEntidadAsociada.Free;
end;

{ TEntidadSimpleCombo }

procedure TORMEntidadSimpleCombo.AsignarDatosEntidad(Tabla, NombreCampoClave: string;
  ES: TORMEntidadSimpleDef;
  unaRelacion: TORMRelacionDefSimple;
  NombreCampoDescripcion, NombreCampoDescrReducida,
  NombreCampoObservaciones: string;
  ClaveEsIdentidad: boolean);
begin
  //FCampos := TColeccionCampos.Create;
  FTabla := Tabla;

  DES := ES;
  Relacion := unaRelacion;

  if ClaveEsIdentidad then
     FCampos.Agregar(TORMCampo.Create( Tabla, NombreCampoClave, Tabla, '', '', icClave,
                                    60,  0, 0, true, true, false, false, tdInteger, faNinguna, 0))
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
  FCampos.Agregar(TORMCampo.Create(Tabla, unaRelacion.CampoPrimario.Campo, '', '', '',
                                icClaveForanea, 10,  0, 0, false, false, true, true, tdInteger,
                                faNinguna, 0));
  FCampos.Agregar(TORMCampo.Create(ES.Tabla, ES.CampoDescripcion, '', '', '',
                                icDescripcionForanea, 60,  0, 0, false, false, true, false, tdString,
                                faNinguna, 0));
  FEntidadAsociada := nil;

  EsNueva := true;
end;

procedure TORMEntidadSimpleCombo.AsignarDatosEntidad(ESC: TORMEntidadSimpleComboDef);
begin
  AsignarDatosEntidad(  ESC.Tabla, ESC.CampoClave,
                        ESC.EntidadSimpleAsociada, ESC.Relacion, ESC.CampoDescripcion,
                        ESC.CampoDescrReducida, ESC.CampoObservaciones,
                        ESC.ClaveEsIdentidad);
end;

constructor TORMEntidadSimpleCombo.Create;
begin
  Create(nil);
end;

destructor TORMEntidadSimpleCombo.Destroy;
begin
  if assigned(FEntidadAsociada) then
    FEntidadAsociada.Free;

  inherited;
end;

function TORMEntidadSimpleCombo.GetORMCampo(index: integer): TORMCampo;
begin
  Result := FCampos.ORMCampo[index];
end;

function TORMEntidadSimpleCombo.GetDescripcion: string;
begin
  Result := FCampos.ORMCampo[icDescripcion].AsString;
end;

function TORMEntidadSimpleCombo.GetDescripcionForanea: string;
begin
  Result := '';
  if not FCampos.ORMCampo[icDescripcionForanea].EsNulo then
    Result := FCampos.ORMCampo[icDescripcionForanea].AsString;
end;

function TORMEntidadSimpleCombo.GetDescripcionReducida: string;
begin
  Result := '';
  if not FCampos.ORMCampo[icDescripcionReducida].EsNulo then
    Result := FCampos.ORMCampo[icDescripcionReducida].AsString;
end;

function TORMEntidadSimpleCombo.GetEntidadAsociada: TORMEntidadSimple;
begin
  if not assigned(EntidadAsociada) then begin
    FEntidadAsociada :=TORMEntidadSimple.Create;
    FEntidadAsociada.AsignarDatosEntidad(DES);
    FEntidadAsociada.ObtenerEntidad(FCampos.ORMCampo[icClaveForanea].AsInteger);
  end;
  Result := FEntidadAsociada;
end;

function TORMEntidadSimpleCombo.GetID: integer;
begin
  Result := FCampos.ORMCampo[icClave].AsInteger;
end;

function TORMEntidadSimpleCombo.GetIDForaneao: integer;
begin
  Result := -1;
  if not FCampos.ORMCampo[icClaveForanea].EsNulo then
    Result := FCampos.ORMCampo[icClaveForanea].AsInteger;;
end;

function TORMEntidadSimpleCombo.GetObservaciones: string;
begin
  Result := '';
  if not  FCampos.ORMCampo[icObservaciones].EsNulo then
    Result := FCampos.ORMCampo[icObservaciones].AsString;
end;

function TORMEntidadSimpleCombo.ObtenerEntidad(EntidadID: integer): boolean;
var
  select : TSelectStatement;
begin
  select := TSelectStatement.Create(FCampos);
  select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.ORMCampo[icClave],
                                                        tcIgual, EntidadID));

  select.Relaciones.Agregar('',
                            Relacion.CampoPrimario.Tabla,
                            Relacion.CampoPrimario.Campo,
                            Relacion.CampoForaneo.Tabla,
                            Relacion.CampoForaneo.Campo,
                            Relacion.TipoRelacion);

  Result := AsignarCamposDesdeSeleccion(select);
  select.Free;
end;

procedure TORMEntidadSimpleCombo.SetDescripcion(const Value: string);
begin
  FCampos.ORMCampo[icDescripcion].AsString := Value;
end;

procedure TORMEntidadSimpleCombo.SetDescripcionForanea(const Value: string);
begin
  FCampos.ORMCampo[icDescripcionForanea].AsString := Value;
  FCampos.ORMCampo[icDescripcionForanea].FueCambiado := false;
end;

procedure TORMEntidadSimpleCombo.SetDescripcionReducida(const Value: string);
begin
  FCampos.ORMCampo[icDescripcionReducida].AsString := Value;
end;

procedure TORMEntidadSimpleCombo.SetID(const Value: integer);
begin
  FCampos.ORMCampo[icClave].AsInteger := Value;
end;

procedure TORMEntidadSimpleCombo.SetIDForaneo(const Value: integer);
begin
  FCampos.ORMCampo[icClaveForanea].AsInteger := Value;
end;

procedure TORMEntidadSimpleCombo.SetObservaciones(const Value: string);
begin
  FCampos.ORMCampo[icObservaciones].AsString := Value;
end;

{ TColeccionEntidadSimpleCombo }

procedure TORMColeccionEntidadSimpleCombo.AsignarDatosEntidad(Tabla, NombreCampoClave,
  NombreEntidad, NombrePlural: string; ES: TORMEntidadSimpleDef;
  Relacion: TORMRelacionDefSimple; NombreCampoDescripcion,
  NombreCampoDescrReducida, NombreCampoObservaciones: string;
  ClaveEsIdentidad: boolean);
begin
  FCampos := TORMColeccionCampos.Create;

  FDES := ES;
  FRelacion := Relacion;

  if ClaveEsIdentidad then
     FCampos.Agregar(TORMCampo.Create( Tabla, NombreCampoClave, Tabla, '', '', icClave,
                                    60,  0, 0, true, true, false, false, tdInteger, faNinguna, 0))
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
  FCampos.Agregar(TORMCampo.Create(Tabla, Relacion.CampoPrimario.Campo, '', '', '',
                                icClaveForanea, 10,  0, 0, false, false, true, true, tdInteger,
                                faNinguna, 0));
  FCampos.Agregar(TORMCampo.Create(ES.Tabla, ES.CampoDescripcion, '', '', '',
                                icDescripcionForanea, 60,  0, 0, false, false, true, false, tdString,
                                faNinguna, 0));
end;

procedure TORMColeccionEntidadSimpleCombo.AsignarDatosEntidad(
  ESC: TORMEntidadSimpleComboDef);
begin
  AsignarDatosEntidad(  ESC.Tabla, ESC.CampoClave, ESC.NombreEntidad,
                        ESC.NombrePlural, ESC.EntidadSimpleAsociada,
                        ESC.Relacion, ESC.CampoDescripcion,
                        ESC.CampoDescrReducida, ESC.CampoObservaciones,
                        ESC.ClaveEsIdentidad);
end;

procedure TORMColeccionEntidadSimpleCombo.AsignarDatosEntidad(
  EntidadSimpleCombo: TORMEntidadSimpleCombo);
var
  nCampo : integer;
begin
  FCampos := TORMColeccionCampos.Create;

  for nCampo := 0 to EntidadSimpleCombo.ORMCampos.Count - 1 do
  begin
    with EntidadSimpleCombo.ORMCampo[nCampo] do
      FCampos.Agregar(TORMCampo.Create(Tabla, Nombre, Secuencia, AliasCampo,
                                    AliasTabla, Indice, Longitud, Precision, Escala,
                                    EsIdentidad, EsClavePrimaria, EsClaveForanea,
                                    AceptaNull, TipoDato, FuncionAgregacion, ValorPorDefecto));
  end;
end;

function TORMColeccionEntidadSimpleCombo.GetEntidadSimpleCombo(
  index: integer): TORMEntidadSimpleCombo;
begin
  Result := Items[index] as TORMEntidadSimpleCombo;
end;

function TORMColeccionEntidadSimpleCombo.ObtenerTodos: integer;
var
  orden : TExpresionOrdenamiento;
  Relacion: TExpresionRelacion;
begin
  orden := TExpresionOrdenamiento.Create;
  Relacion := TExpresionRelacion.Create(FRelacion);
  orden.Agregar(FCampos.ORMCampo[icDescripcionForanea], toAscendente);
  orden.Agregar(FCampos.ORMCampo[icDescripcion], toAscendente);
  Result := ObtenerMuchos(nil, orden, nil, Relacion);
  Relacion.Free;
  orden.Free;
end;

procedure TORMColeccionEntidadSimpleCombo.ProcesarDataSet;
var
  unaEntidad : TORMEntidadSimpleCombo;
begin
  with FSelectStatement do
  begin
    if not Datos.Active then
      Datos.Active := true;

    Datos.First;
    while not Datos.Eof  do
    begin
      //unaEntidad := Add as TEntidadSimpleCombo;
      unaEntidad := TORMEntidadSimpleCombo.Create(Self);
      unaEntidad.AsignarDatosEntidad( FCampos.ORMCampo[icClave].Tabla,
                                      FCampos.ORMCampo[icClave].Nombre,
                                      FDES,
                                      Relaciones.Relacion[0].ObtenerDefinicion,
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

      unaEntidad.ORMCampo[icClaveForanea].EsNulo := Datos.Fields[icClaveForanea].IsNull;
      if not unaEntidad.ORMCampo[icClaveForanea].EsNulo then
        unaEntidad.IDForeaneo := Datos.Fields[icClaveForanea].AsInteger;

      unaEntidad.ORMCampo[icDescripcionForanea].EsNulo := Datos.Fields[icDescripcionForanea].IsNull;
      if not unaEntidad.ORMCampo[icDescripcionForanea].EsNulo then
        unaEntidad.DescripcionForanea := Datos.Fields[icDescripcionForanea].AsString;

      unaEntidad.ORMCampos.FueronCambiados := false;
      Datos.Next;
    end;
  end;
end;

end.

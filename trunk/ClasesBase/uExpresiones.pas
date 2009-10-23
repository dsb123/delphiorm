{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uExpresiones.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uExpresiones;

interface

uses Contnrs, Classes, uCampos;

type
  { TCamposRelacion }
  TORMCamposRelacion = class
  private
    FTabla: string;
    FCampos: TStringList;
    function GetCampo(index: integer): string;
    function GetCantCampos: integer;
  public
    constructor Create(const Tabla: string; Campos: TStringList);
    destructor Destroy; override;
    function Clonar: TORMCamposRelacion;
    property Tabla: string read FTabla;
    property CantCampos: integer read GetCantCampos;
    property Campo[index: integer]: string read GetCampo;
  end;

  { Clases para el manejo de relaciones }
  TORMTipoRelacion=(trAmbas, trIzquierda, tdDerecha);
  TCampoDef = record
    Tabla : string;
    Campo : string;
  end;

  TORMRelacionDefSimple = record
    CampoPrimario: TCampoDef;
    CampoForaneo: TCampoDef;
    TipoRelacion: TORMTipoRelacion;
  end;

  TORMRelacion = class
  private
    FAlias           : string;
    FCamposPrimario  : TORMCamposRelacion;
    FCamposForaneo   : TORMCamposRelacion;
    FTipoRelacion    : TORMTipoRelacion;
  public
    constructor Create( const TablaPrimaria, CampoPrimario, TablaForanea,CampoForaneo: string;
                        const TipoRelacion: TORMTipoRelacion); overload;
    constructor Create( const Relacion: TORMRelacionDefSimple); overload;
    constructor Create( CampoPrimario, CampoForaneo: TORMCampo;
                        const TipoRelacion: TORMTipoRelacion); overload;
    constructor Create( CamposPrimarios: TORMCamposRelacion; CamposForaneos: TORMCamposRelacion;
                        const TipoRelacion: TORMTipoRelacion); overload;
    destructor Destroy; override;
    function Clonar: TORMRelacion;
    function ObtenerDefinicion: TORMRelacionDefSimple;
    property Alias: string read FAlias write FAlias;
    property CamposPrimario: TORMCamposRelacion read FCamposPrimario;
    property CamposForaneo: TORMCamposRelacion read FCamposForaneo;
    property TipoRelacion: TORMTipoRelacion read FTipoRelacion;
  end;

  TExpresionRelacion = class(TObjectList)
  private
    function GetRelacion(index: integer): TORMRelacion;
    procedure SetRelacion(index: integer; const Value: TORMRelacion);
  public
    Tag: integer;
    constructor Create(const TablaPrimaria, CampoPrimario, TablaForanea,CampoForaneo: string;
                        const TipoRelacion: TORMTipoRelacion); overload;
    constructor Create(const Alias, TablaPrimaria, CampoPrimario, TablaForanea,CampoForaneo: string;
                        const TipoRelacion: TORMTipoRelacion); overload;
    constructor Create(const Relacion: TORMRelacionDefSimple); overload;
    destructor Destroy; override;
    property Relacion[index: integer]: TORMRelacion read GetRelacion write SetRelacion;
    function Agregar( const AliasRelacion, TablaPrimaria, CampoPrimario, TablaForanea,CampoForaneo: string;
                      const TipoRelacion: TORMTipoRelacion): integer; overload;
    function Agregar(Relacion: TORMRelacion): integer; overload;
    function Agregar(Alias: string; Relacion: TORMRelacion): integer; overload;
    function Clonar: TExpresionRelacion;
  end;

  { Clase para el manejo de agrupamientos }
  TExpresionAgrupamiento = class(TObjectList)
  private
    function GetAgrupamiento(index: integer): TORMCampo;
    procedure SetAgrupamiento(index: integer; const Value: TORMCampo);
  public
    Tag: integer;
    constructor Create; overload;
    destructor Destroy; override;
    property Agrupamiento[index: integer]: TORMCampo read GetAgrupamiento write SetAgrupamiento;
    function Agregar(Campo: TORMCampo): integer;
  end;

  { Clases para el manejo de ordenamientos }
  TORMTipoOrden = (toAscendente, toDescendente);
  TOrdenamiento = class
  private
    FCampo : TORMCampo;
    FTipoOrden : TORMTipoOrden;
  public
    constructor Create(Campo: TORMCampo; const TipoOrden: TORMTipoOrden);
    destructor Destroy; override;
    property Campo: TORMCampo read FCampo;
    property TipoOrden: TORMTipoOrden read FTipoOrden;
  end;

  TExpresionOrdenamiento = Class(TObjectList)
    function GetOrdenamiento(index: integer): TOrdenamiento;
    procedure SetOrdenamiento(index: integer; const Value: TOrdenamiento);
  public
    Tag: integer;
    constructor Create;
    destructor Destroy; override;
    property Ordenamiento[index: integer]: TOrdenamiento read GetOrdenamiento write SetOrdenamiento;
    function Agregar(Campo: TORMCampo; const TipoOrden: TORMTipoOrden): integer;
  End;

  { Clases para el manejo de condiciones }
  TOperadorCondicion=(ocNinguno, ocOperadorAND, ocOperadorOR);
  TCondicion = class
  protected
    FOperador : TOperadorCondicion;
    FNegacion : boolean;
  public
    property Operador : TOperadorCondicion read FOperador;
    property Negacion : boolean read FNegacion default false;
  end;

  TColeccionCondicion = class(TObjectList)
    function GetCondicion(index: integer): TCondicion;
    procedure SetCondicion(index: integer; const Value: TCondicion);
  public
    property Condicion[index: integer]: TCondicion read GetCondicion write SetCondicion;
    function Agregar(Condicion: TCondicion): integer;
  end;

  TExpresionCondicion = class(TCondicion)
  private
    FCondiciones : TColeccionCondicion;
    function GetCount: integer;
  public
    Tag: integer;
    constructor Create;
    destructor Destroy; override;
    function Agregar(Condicion: TCondicion; const Negada: boolean = false): integer;
    function AgregarConAND(Condicion: TCondicion; const Negada: boolean = false): integer;
    function AgregarConOR(Condicion: TCondicion; const Negada: boolean = false): integer;

    property Condiciones: TColeccionCondicion read FCondiciones;
    property Count: integer read GetCount;
  end;

  TORMTipoComparacion = (tcIgual, tcDistinto, tcMenor, tcMenorIgual, tcMayor, tcMayorIgual);
  TCondicionComparacion = class(TCondicion)
  private
    FCampo : TORMCampo;
    FTipoComparacion : TORMTipoComparacion;
    FValor : variant;
  public
    constructor Create(Campo: TORMCampo; const TipoComparacion: TORMTipoComparacion; const Valor: variant);
    destructor Destroy; override;
    property Campo: TORMCampo read FCampo;
    property TipoComparacion: TORMTipoComparacion read FTipoComparacion;
    property Valor: variant read FValor;
  end;

  TORMItemInclusion=class(TObject)
  private
    FValor : variant;
  public
    constructor Create(const Valor: variant);
  end;

  TColeccionInclusion = Class(TObjectList)
    function GetItemInclusion(index: integer): variant;
    procedure SetItemInclusion(index: integer; const Value: variant);
  public
    property Item[index: integer]: variant read GetItemInclusion write SetItemInclusion;
    function Agregar(const Valor: variant): integer;
  End;

  TCondicionInclusion = class(TCondicion)
  private
    FCampo: TORMCampo;
    FLista: TColeccionInclusion;
  public
    constructor Create(Campo: TORMCampo; Lista: TColeccionInclusion);
    destructor Destroy; override;
    property Campo: TORMCampo read FCampo;
    property Lista: TColeccionInclusion read FLista ;
  end;

  TCondicionLike = class(TCondicion)
  private
    FCampo: TORMCampo;
    FCadenaABuscar: string;
  public
    constructor Create(unCampo: TORMCampo; CadenaABuscar: string);
    destructor Destroy; override;
    property Campo: TORMCampo read FCampo;
    property CadenaABuscar: string read FCadenaABuscar;
  end;

  TCondicionNull = class(TCondicion)
  private
    FCampo : TORMCampo;
  public
    constructor Create( Campo: TORMCampo);
    destructor Destroy; override;
    property Campo: TORMCampo read FCampo;
  end;

  TCondicionSeleccion = class(TCondicion)
  private
    FCampoSeleccion     : TORMCampo;
    FCampoInclusion     : TORMCampo;
    FCondicion          : TExpresionCondicion;
    FRelaciones         : TExpresionRelacion;
    FAgrupamiento       : TExpresionAgrupamiento;
    FFiltroHaving       : TExpresionCondicion;
    FSinDuplicados      : boolean;
  public
    constructor Create( CampoSeleccion, CampoInclusion: TORMCampo;
                        Condicion: TExpresionCondicion; Relaciones: TExpresionRelacion;
                        Agrupamiento: TExpresionAgrupamiento; FiltroHaving: TExpresionCondicion;
                        const SinDuplicados: boolean);
    destructor Destroy; override;
    property CampoSeleccion: TORMCampo read FCampoSeleccion;
    property CampoInclusion: TORMCampo read FCampoInclusion;
    property Condicion: TExpresionCondicion read FCondicion;
    property Relaciones: TExpresionRelacion read FRelaciones;
    property Agrupamiento: TExpresionAgrupamiento read FAgrupamiento;
    property FiltroHaving: TExpresionCondicion read FFiltroHaving;
    property SinDuplicados: boolean read FSinDuplicados;
  end;

  TORMGenerador = class
  public
    IndiceParametro: integer;
    Generador: string;
    IndiceCampo: integer;
    constructor Create(const nParametro: integer; nCampo: integer; const SQLGenerador: string);
  end;

  TORMColeccionGenerador = Class(TObjectList)
    function GetGenerador(index: integer): TORMGenerador;
    procedure SetGenerador(index: integer; const Value: TORMGenerador);
  public
    property Generador[index: integer]: TORMGenerador read GetGenerador write SetGenerador;
    function Agregar(Valor: TORMGenerador): integer;
  End;

implementation

uses SysUtils;

{ TOrdenamiento }

constructor TOrdenamiento.Create(Campo: TORMCampo; const TipoOrden: TORMTipoOrden);
begin
  FCampo := Campo;
  FTipoOrden := TipoOrden;
end;

destructor TOrdenamiento.Destroy;
begin
  if not assigned(Campo.Padre) then
    FCampo.Free;
  inherited;
end;

{ TExpresionOrdenamiento }

function TExpresionOrdenamiento.Agregar(Campo: TORMCampo; const TipoOrden: TORMTipoOrden): integer;
begin
  Result := Add(TOrdenamiento.Create(Campo, TipoOrden));
end;

constructor TExpresionOrdenamiento.Create;
begin
  inherited Create(true);
end;

destructor TExpresionOrdenamiento.Destroy;
begin
  inherited;
end;

function TExpresionOrdenamiento.GetOrdenamiento(index: integer): TOrdenamiento;
begin
  result := Items[index] as TOrdenamiento;
end;

procedure TExpresionOrdenamiento.SetOrdenamiento(index: integer;
  const Value: TOrdenamiento);
begin
  Items[index] := Value;
end;

{ TExpresionAgrupamiento }

function TExpresionAgrupamiento.Agregar(Campo: TORMCampo): integer;
begin
  Result := Add(Campo);
end;

constructor TExpresionAgrupamiento.Create;
begin
  inherited Create(true);
end;

destructor TExpresionAgrupamiento.Destroy;
//var
//  i : integer;
begin
//  for i := 0 to Count - 1 do
//    Items[i].Free;

  inherited;
end;

function TExpresionAgrupamiento.GetAgrupamiento(index: integer): TORMCampo;
begin
  result := Items[index] as TORMCampo;
end;

procedure TExpresionAgrupamiento.SetAgrupamiento(index: integer;
  const Value: TORMCampo);
begin
  Items[index] := Value;
end;

constructor TORMRelacion.Create(const TablaPrimaria, CampoPrimario,
  TablaForanea, CampoForaneo: string; const TipoRelacion: TORMTipoRelacion);
var
  sCampos : TStringList;
begin
  sCampos := TStringList.Create;

  sCampos.Add(CampoPrimario);
  FCamposPrimario := TORMCamposRelacion.Create(TablaPrimaria, sCampos);
  sCampos.Clear;

  sCampos.Add(CampoForaneo);
  FCamposForaneo := TORMCamposRelacion.Create(TablaForanea, sCampos);
  sCampos.Free;

  FTipoRelacion := TipoRelacion;
end;

constructor TORMRelacion.Create(CamposPrimarios, CamposForaneos: TORMCamposRelacion;
                              const TipoRelacion: TORMTipoRelacion);
begin
  FCamposPrimario := CamposPrimarios.Clonar;
  FCamposForaneo  := CamposForaneos.Clonar;
  FTipoRelacion   := TipoRelacion;
end;

function TORMRelacion.Clonar: TORMRelacion;
begin
  Result := TORMRelacion.Create( FCamposPrimario, FCamposForaneo, FTipoRelacion);
end;

constructor TORMRelacion.Create(CampoPrimario, CampoForaneo: TORMCampo;
  const TipoRelacion: TORMTipoRelacion);
begin
  Create( CampoPrimario.Tabla, CampoPrimario.Nombre,
          CampoForaneo.Tabla, CampoForaneo.Nombre, TipoRelacion);
end;

constructor TORMRelacion.Create(const Relacion: TORMRelacionDefSimple);
begin
  Create( Relacion.CampoPrimario.Tabla, Relacion.CampoPrimario.Campo,
          Relacion.CampoForaneo.Tabla, Relacion.CampoForaneo.Campo,
          Relacion.TipoRelacion);
end;

destructor TORMRelacion.Destroy;
begin
  FCamposPrimario.Free;
  FCamposForaneo.Free;
  inherited;
end;

function TORMRelacion.ObtenerDefinicion: TORMRelacionDefSimple;
begin
  Result.CampoPrimario.Tabla := FCamposPrimario.Tabla;
  Result.CampoPrimario.Campo := FCamposPrimario.Campo[0];
  Result.CampoForaneo.Tabla := FCamposForaneo.Tabla;
  Result.CampoForaneo.Campo := FCamposForaneo.Campo[0];
  Result.TipoRelacion := FTipoRelacion;
end;

{ TExpresionRelacion }

function TExpresionRelacion.Agregar(const AliasRelacion, TablaPrimaria, CampoPrimario, TablaForanea,
  CampoForaneo: string; const TipoRelacion: TORMTipoRelacion): integer;
var
  unaRelacion: TORMRelacion;
begin
  unaRelacion := TORMRelacion.Create(TablaPrimaria, CampoPrimario,
                                    TablaForanea, CampoForaneo, TipoRelacion);
  unaRelacion.Alias := AliasRelacion;
  Result := Add(unaRelacion);
end;

function TExpresionRelacion.Agregar(Relacion: TORMRelacion): integer;
begin
  Result := Add(Relacion);
end;

function TExpresionRelacion.Agregar(Alias: string;
  Relacion: TORMRelacion): integer;
begin
  Relacion.Alias := Alias;
  Result := Add(Relacion);
end;

function TExpresionRelacion.Clonar: TExpresionRelacion;
var
  i : integer;
begin
  Result := TExpresionRelacion.Create;
  for i := 0 to Count - 1 do
    Result.Agregar(GetRelacion(i).Clonar);

end;

constructor TExpresionRelacion.Create(const Alias, TablaPrimaria, CampoPrimario,
  TablaForanea, CampoForaneo: string; const TipoRelacion: TORMTipoRelacion);
begin
  inherited Create(true);
  Agregar(Alias, TablaPrimaria, CampoPrimario, TablaForanea, CampoForaneo, TipoRelacion);
end;

constructor TExpresionRelacion.Create(const Relacion: TORMRelacionDefSimple);
begin
  Create( Relacion.CampoPrimario.Tabla, Relacion.CampoPrimario.Campo,
          Relacion.CampoForaneo.Tabla, Relacion.CampoForaneo.Campo,
          Relacion.TipoRelacion);
end;

destructor TExpresionRelacion.Destroy;
begin
{var
  i : integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Free;}
  inherited;
end;

constructor TExpresionRelacion.Create(const TablaPrimaria, CampoPrimario,
  TablaForanea, CampoForaneo: string; const TipoRelacion: TORMTipoRelacion);
begin
  inherited Create(true);
  Agregar('', TablaPrimaria, CampoPrimario, TablaForanea, CampoForaneo, TipoRelacion);
end;

function TExpresionRelacion.GetRelacion(index: integer): TORMRelacion;
begin
  result := Items[index] as TORMRelacion;
end;

procedure TExpresionRelacion.SetRelacion(index: integer;
  const Value: TORMRelacion);
begin
  Items[index] := Value;
end;

{ TExpresionCondicion }

function TColeccionCondicion.Agregar(Condicion: TCondicion): integer;
begin
  Result := Add(Condicion);
end;

function TColeccionCondicion.GetCondicion(index: integer): TCondicion;
begin
  Result := Items[index] as TCondicion;
end;

procedure TColeccionCondicion.SetCondicion(index: integer;
  const Value: TCondicion);
begin
  Items[index] := Value;
end;

{ TExpresionCondicion }

function TExpresionCondicion.Agregar(Condicion: TCondicion;
  const Negada: boolean): integer;
begin
  if FCondiciones.Count = 0 then
    Condicion.FOperador := ocNinguno
  else
    Condicion.FOperador := ocOperadorAND;

  Condicion.FNegacion := Negada;
  Result := FCondiciones.Agregar(Condicion);
end;

function TExpresionCondicion.AgregarConAND(Condicion: TCondicion;
  const Negada: boolean): integer;
begin
  Condicion.FOperador := ocOperadorAND;
  Condicion.FNegacion := Negada;

  Result := FCondiciones.Agregar(Condicion);
end;

function TExpresionCondicion.AgregarConOR(Condicion: TCondicion;
  const Negada: boolean): integer;
begin
  if FCondiciones.Count = 0 then
    Condicion.FOperador := ocNinguno
  else
    Condicion.FOperador := ocOperadorOR;
  Condicion.FNegacion := Negada;

  Result := FCondiciones.Agregar(Condicion);
end;

constructor TExpresionCondicion.Create;
begin
  FCondiciones := TColeccionCondicion.Create;
end;

destructor TExpresionCondicion.Destroy;
begin
  FCondiciones.Free;
  inherited;
end;

function TExpresionCondicion.GetCount: integer;
begin
  Result := FCondiciones.Count;
end;

{ TCondicionComparacion }

constructor TCondicionComparacion.Create(Campo: TORMCampo;
  const TipoComparacion: TORMTipoComparacion; const Valor: variant);
begin
  FCampo := Campo;

  FTipoComparacion := TipoComparacion;
  FValor := Valor;
end;

destructor TCondicionComparacion.Destroy;
begin
  if not assigned(FCampo.Padre) then
    FCampo.Free;

  inherited;
end;

{ TItemInclusion }

constructor TORMItemInclusion.Create(const Valor: variant);
begin
  FValor := Valor;
end;

{ TColeccionInclusion }

function TColeccionInclusion.Agregar(const Valor: variant): integer;
begin
  Result := Add(TORMItemInclusion.Create(Valor));
end;

function TColeccionInclusion.GetItemInclusion(index: integer): variant;
begin
  Result := (Items[index] as TORMItemInclusion).FValor;
end;

procedure TColeccionInclusion.SetItemInclusion(index: integer;
  const Value: variant);
begin
  (Items[index] as TORMItemInclusion).FValor := value;
end;

{ TCondicionInclusion }

constructor TCondicionInclusion.Create(Campo: TORMCampo; Lista: TColeccionInclusion);
begin
  FCampo := Campo;
  FLista  := Lista;
end;

destructor TCondicionInclusion.Destroy;
begin
  if not assigned(FCampo.Padre) then
    FCampo.Free;

  inherited;
end;

{ TCondicionLike }

constructor TCondicionLike.Create(unCampo: TORMCampo; CadenaABuscar: string);
begin
  FCampo := unCampo;
  FCadenaABuscar := CadenaABuscar;
end;

destructor TCondicionLike.Destroy;
begin
  if not assigned(FCampo.Padre) then
    FCampo.Free;

  inherited;
end;

{ TCondicionNull }

constructor TCondicionNull.Create(Campo: TORMCampo);
begin
  FCampo := Campo;
end;

destructor TCondicionNull.Destroy;
begin
  if not assigned(FCampo.Padre) then
    FCampo.Free;
  inherited;
end;

{ TCondicionSeleccion }

constructor TCondicionSeleccion.Create(CampoSeleccion,
  CampoInclusion: TORMCampo; Condicion: TExpresionCondicion;
  Relaciones: TExpresionRelacion; Agrupamiento: TExpresionAgrupamiento;
  FiltroHaving: TExpresionCondicion; const SinDuplicados: boolean);
begin
  FCampoSeleccion := CampoSeleccion;
  FCampoInclusion := CampoInclusion;
  FCondicion := Condicion;
  FRelaciones := Relaciones;
  FAgrupamiento := FAgrupamiento;
  FFiltroHaving := FiltroHaving;
  FSinDuplicados := SinDuplicados;
end;

destructor TCondicionSeleccion.Destroy;
begin
  if not assigned(FCampoSeleccion.Padre) then
    FCampoSeleccion.Free;
  if not assigned(FCampoInclusion.Padre) then
    FCampoInclusion.Free;

  //FreeAndNil(FCondicion);
  //FreeAndNil(FRelaciones);
  //FreeAndNil(FAgrupamiento);
  //FreeAndNil(FFiltroHaving);
  inherited;
end;

{ TColeccionGenerador }

function TORMColeccionGenerador.Agregar(Valor: TORMGenerador): integer;
begin
  Result := Add(Valor);
end;

function TORMColeccionGenerador.GetGenerador(index: integer): TORMGenerador;
begin
  Result := Items[index] as TORMGenerador;
end;

procedure TORMColeccionGenerador.SetGenerador(index: integer;
  const Value: TORMGenerador);
begin
  Items[index] := Value;
end;

{ TGenerador }

constructor TORMGenerador.Create(const nParametro: Integer; nCampo: Integer; const SQLGenerador: string);
begin
  IndiceParametro := nParametro;
  Generador := SQLGenerador;
  IndiceCampo := nCampo;
end;

{ TCamposRelacion }

function TORMCamposRelacion.Clonar: TORMCamposRelacion;
begin
  Result := TORMCamposRelacion.Create(FTabla, FCampos);
end;

constructor TORMCamposRelacion.Create(const Tabla: string; Campos: TStringList);
begin
  FCampos := TStringList.Create;
  FCampos.AddStrings(Campos);
  FTabla := Tabla;
end;

destructor TORMCamposRelacion.Destroy;
begin
  FCampos.Free;
  inherited;
end;

function TORMCamposRelacion.GetCampo(index: integer): string;
begin
  if index < FCampos.Count then
    Result := FCampos[index]
  else
    Result := '';
end;

function TORMCamposRelacion.GetCantCampos: integer;
begin
  Result := FCampos.Count;
end;

end.

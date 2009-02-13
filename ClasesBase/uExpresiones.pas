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
  TCamposRelacion = class
  private
    FTabla: string;
    FCampos: TStringList;
    function GetCampo(index: integer): string;
    function GetCantCampos: integer;
  public
    constructor Create(const Tabla: string; Campos: TStringList);
    destructor Destroy; override;
    function Clonar: TCamposRelacion;
    property Tabla: string read FTabla;
    property CantCampos: integer read GetCantCampos;
    property Campo[index: integer]: string read GetCampo;
  end;

  { Clases para el manejo de relaciones }
  TTipoRelacion=(trAmbas, trIzquierda, tdDerecha);
  TCampoDef = record
    Tabla : string;
    Campo : string;
  end;

  TRelacionDefSimple = record
    CampoPrimario: TCampoDef;
    CampoForaneo: TCampoDef;
    TipoRelacion: TTipoRelacion;
  end;

  TRelacion = class
  private
    FCamposPrimario  : TCamposRelacion;
    FCamposForaneo   : TCamposRelacion;
    FTipoRelacion   : TTipoRelacion;
  public
    constructor Create( const TablaPrimaria, CampoPrimario, TablaForanea,CampoForaneo: string;
                        const TipoRelacion: TTipoRelacion); overload;
    constructor Create( const Relacion: TRelacionDefSimple); overload;
    constructor Create( CampoPrimario, CampoForaneo: TCampo;
                        const TipoRelacion: TTipoRelacion); overload;
    constructor Create( CamposPrimarios: TCamposRelacion; CamposForaneos: TCamposRelacion;
                        const TipoRelacion: TTipoRelacion); overload;
    destructor Destroy; override;
    function Clonar: TRelacion;
    function ObtenerDefinicion: TRelacionDefSimple;
    property CamposPrimario: TCamposRelacion read FCamposPrimario;
    property CamposForaneo: TCamposRelacion read FCamposForaneo;
    property TipoRelacion: TTipoRelacion read FTipoRelacion;
  end;

  TExpresionRelacion = class(TObjectList)
  private
    function GetRelacion(index: integer): TRelacion;
    procedure SetRelacion(index: integer; const Value: TRelacion);
  public
    Tag: integer;
    constructor Create(const TablaPrimaria, CampoPrimario, TablaForanea,CampoForaneo: string;
                        const TipoRelacion: TTipoRelacion); overload;
    constructor Create(const Relacion: TRelacionDefSimple); overload;
    destructor Destroy; override;
    property Relacion[index: integer]: TRelacion read GetRelacion write SetRelacion;
    function Agregar( const TablaPrimaria, CampoPrimario, TablaForanea,CampoForaneo: string;
                      const TipoRelacion: TTipoRelacion): integer; overload;
    function Agregar(Relacion: TRelacion): integer; overload;
    function Clonar: TExpresionRelacion;
  end;

  { Clase para el manejo de agrupamientos }
  TExpresionAgrupamiento = class(TObjectList)
  private
    function GetAgrupamiento(index: integer): TCampo;
    procedure SetAgrupamiento(index: integer; const Value: TCampo);
  public
    Tag: integer;
    constructor Create; overload;
    destructor Destroy; override;
    property Agrupamiento[index: integer]: TCampo read GetAgrupamiento write SetAgrupamiento;
    function Agregar(Campo: TCampo): integer;
  end;

  { Clases para el manejo de ordenamientos }
  TTipoOrden = (toAscendente, toDescendente);
  TOrdenamiento = class
  private
    FCampo : TCampo;
    FTipoOrden : TTipoOrden;
  public
    constructor Create(Campo: TCampo; const TipoOrden: TTipoOrden);
    destructor Destroy; override;
    property Campo: TCampo read FCampo;
    property TipoOrden: TTipoOrden read FTipoOrden;
  end;

  TExpresionOrdenamiento = Class(TObjectList)
    function GetOrdenamiento(index: integer): TOrdenamiento;
    procedure SetOrdenamiento(index: integer; const Value: TOrdenamiento);
  public
    Tag: integer;
    constructor Create;
    destructor Destroy; override;
    property Ordenamiento[index: integer]: TOrdenamiento read GetOrdenamiento write SetOrdenamiento;
    function Agregar(Campo: TCampo; const TipoOrden: TTipoOrden): integer;
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

  TTipoComparacion = (tcIgual, tcDistinto, tcMenor, tcMenorIgual, tcMayor, tcMayorIgual);
  TCondicionComparacion = class(TCondicion)
  private
    FCampo : TCampo;
    FTipoComparacion : TTipoComparacion;
    FValor : variant;
  public
    constructor Create(Campo: TCampo; const TipoComparacion: TTipoComparacion; const Valor: variant);
    destructor Destroy; override;
    property Campo: TCampo read FCampo;
    property TipoComparacion: TTipoComparacion read FTipoComparacion;
    property Valor: variant read FValor;
  end;

  TItemInclusion=class(TObject)
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
    FCampo: TCampo;
    FLista: TColeccionInclusion;
  public
    constructor Create(Campo: TCampo; Lista: TColeccionInclusion);
    destructor Destroy; override;
    property Campo: TCampo read FCampo;
    property Lista: TColeccionInclusion read FLista ;
  end;

  TCondicionLike = class(TCondicion)
  private
    FCampo: TCampo;
    FCadenaABuscar: string;
  public
    constructor Create(unCampo: TCampo; CadenaABuscar: string);
    destructor Destroy; override;
    property Campo: TCampo read FCampo;
    property CadenaABuscar: string read FCadenaABuscar;
  end;

  TCondicionNull = class(TCondicion)
  private
    FCampo : TCampo;
  public
    constructor Create( Campo: TCampo);
    destructor Destroy; override;
    property Campo: TCampo read FCampo;
  end;

  TCondicionSeleccion = class(TCondicion)
  private
    FCampoSeleccion     : TCampo;
    FCampoInclusion     : TCampo;
    FCondicion          : TExpresionCondicion;
    FRelaciones         : TExpresionRelacion;
    FAgrupamiento       : TExpresionAgrupamiento;
    FFiltroHaving       : TExpresionCondicion;
    FSinDuplicados      : boolean;
  public
    constructor Create( CampoSeleccion, CampoInclusion: TCampo;
                        Condicion: TExpresionCondicion; Relaciones: TExpresionRelacion;
                        Agrupamiento: TExpresionAgrupamiento; FiltroHaving: TExpresionCondicion;
                        const SinDuplicados: boolean);
    destructor Destroy; override;
    property CampoSeleccion: TCampo read FCampoSeleccion;
    property CampoInclusion: TCampo read FCampoInclusion;
    property Condicion: TExpresionCondicion read FCondicion;
    property Relaciones: TExpresionRelacion read FRelaciones;
    property Agrupamiento: TExpresionAgrupamiento read FAgrupamiento;
    property FiltroHaving: TExpresionCondicion read FFiltroHaving;
    property SinDuplicados: boolean read FSinDuplicados;
  end;

  TGenerador = class
  public
    IndiceParametro: integer;
    Generador: string;
    IndiceCampo: integer;
    constructor Create(const nParametro: integer; nCampo: integer; const SQLGenerador: string);
  end;

  TColeccionGenerador = Class(TObjectList)
    function GetGenerador(index: integer): TGenerador;
    procedure SetGenerador(index: integer; const Value: TGenerador);
  public
    property Generador[index: integer]: TGenerador read GetGenerador write SetGenerador;
    function Agregar(Valor: TGenerador): integer;
  End;

implementation

uses SysUtils;

{ TOrdenamiento }

constructor TOrdenamiento.Create(Campo: TCampo; const TipoOrden: TTipoOrden);
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

function TExpresionOrdenamiento.Agregar(Campo: TCampo; const TipoOrden: TTipoOrden): integer;
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

function TExpresionAgrupamiento.Agregar(Campo: TCampo): integer;
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

function TExpresionAgrupamiento.GetAgrupamiento(index: integer): TCampo;
begin
  result := Items[index] as TCampo;
end;

procedure TExpresionAgrupamiento.SetAgrupamiento(index: integer;
  const Value: TCampo);
begin
  Items[index] := Value;
end;

constructor TRelacion.Create(const TablaPrimaria, CampoPrimario,
  TablaForanea, CampoForaneo: string; const TipoRelacion: TTipoRelacion);
var
  sCampos : TStringList;
begin
  sCampos := TStringList.Create;

  sCampos.Add(CampoPrimario);
  FCamposPrimario := TCamposRelacion.Create(TablaPrimaria, sCampos);
  sCampos.Clear;

  sCampos.Add(CampoForaneo);
  FCamposForaneo := TCamposRelacion.Create(TablaForanea, sCampos);
  sCampos.Free;

  FTipoRelacion := TipoRelacion;
end;

constructor TRelacion.Create( CamposPrimarios, CamposForaneos: TCamposRelacion;
                              const TipoRelacion: TTipoRelacion);
begin
  FCamposPrimario := CamposPrimarios.Clonar;
  FCamposForaneo := CamposForaneos.Clonar;
end;

function TRelacion.Clonar: TRelacion;
begin
  Result := TRelacion.Create( FCamposPrimario, FCamposForaneo, FTipoRelacion);
end;

constructor TRelacion.Create(CampoPrimario, CampoForaneo: TCampo;
  const TipoRelacion: TTipoRelacion);
begin
  Create( CampoPrimario.Tabla, CampoPrimario.Nombre,
          CampoForaneo.Tabla, CampoForaneo.Nombre, TipoRelacion);
end;

constructor TRelacion.Create(const Relacion: TRelacionDefSimple);
begin
  Create( Relacion.CampoPrimario.Tabla, Relacion.CampoPrimario.Campo,
          Relacion.CampoForaneo.Tabla, Relacion.CampoForaneo.Campo,
          Relacion.TipoRelacion);
end;

destructor TRelacion.Destroy;
begin
  FCamposPrimario.Free;
  FCamposForaneo.Free;
  inherited;
end;

function TRelacion.ObtenerDefinicion: TRelacionDefSimple;
begin
  Result.CampoPrimario.Tabla := FCamposPrimario.Tabla;
  Result.CampoPrimario.Campo := FCamposPrimario.Campo[0];
  Result.CampoForaneo.Tabla := FCamposForaneo.Tabla;
  Result.CampoForaneo.Campo := FCamposForaneo.Campo[0];
  Result.TipoRelacion := FTipoRelacion;
end;

{ TExpresionRelacion }

function TExpresionRelacion.Agregar(const TablaPrimaria, CampoPrimario, TablaForanea,
  CampoForaneo: string; const TipoRelacion: TTipoRelacion): integer;
begin
  Result := Add(TRelacion.Create(TablaPrimaria, CampoPrimario, TablaForanea, CampoForaneo, TipoRelacion));
end;

function TExpresionRelacion.Agregar(Relacion: TRelacion): integer;
begin
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

constructor TExpresionRelacion.Create(const Relacion: TRelacionDefSimple);
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
  TablaForanea, CampoForaneo: string; const TipoRelacion: TTipoRelacion);
begin
  inherited Create(true);
  Agregar(TablaPrimaria, CampoPrimario, TablaForanea, CampoForaneo, TipoRelacion);
end;

function TExpresionRelacion.GetRelacion(index: integer): TRelacion;
begin
  result := Items[index] as TRelacion;
end;

procedure TExpresionRelacion.SetRelacion(index: integer;
  const Value: TRelacion);
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

constructor TCondicionComparacion.Create(Campo: TCampo;
  const TipoComparacion: TTipoComparacion; const Valor: variant);
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

constructor TItemInclusion.Create(const Valor: variant);
begin
  FValor := Valor;
end;

{ TColeccionInclusion }

function TColeccionInclusion.Agregar(const Valor: variant): integer;
begin
  Result := Add(TItemInclusion.Create(Valor));
end;

function TColeccionInclusion.GetItemInclusion(index: integer): variant;
begin
  Result := (Items[index] as TItemInclusion).FValor;
end;

procedure TColeccionInclusion.SetItemInclusion(index: integer;
  const Value: variant);
begin
  (Items[index] as TItemInclusion).FValor := value;
end;

{ TCondicionInclusion }

constructor TCondicionInclusion.Create(Campo: TCampo; Lista: TColeccionInclusion);
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

constructor TCondicionLike.Create(unCampo: TCampo; CadenaABuscar: string);
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

constructor TCondicionNull.Create(Campo: TCampo);
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
  CampoInclusion: TCampo; Condicion: TExpresionCondicion;
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

function TColeccionGenerador.Agregar(Valor: TGenerador): integer;
begin
  Result := Add(Valor);
end;

function TColeccionGenerador.GetGenerador(index: integer): TGenerador;
begin
  Result := Items[index] as TGenerador;
end;

procedure TColeccionGenerador.SetGenerador(index: integer;
  const Value: TGenerador);
begin
  Items[index] := Value;
end;

{ TGenerador }

constructor TGenerador.Create(const nParametro: Integer; nCampo: Integer; const SQLGenerador: string);
begin
  IndiceParametro := nParametro;
  Generador := SQLGenerador;
  IndiceCampo := nCampo;
end;

{ TCamposRelacion }

function TCamposRelacion.Clonar: TCamposRelacion;
begin
  Result := TCamposRelacion.Create(FTabla, FCampos);
end;

constructor TCamposRelacion.Create(const Tabla: string; Campos: TStringList);
begin
  FCampos := TStringList.Create;
  FCampos.AddStrings(Campos);
  FTabla := Tabla;
end;

destructor TCamposRelacion.Destroy;
begin
  FCampos.Free;
  inherited;
end;

function TCamposRelacion.GetCampo(index: integer): string;
begin
  if index < FCampos.Count then
    Result := FCampos[index]
  else
    Result := '';
end;

function TCamposRelacion.GetCantCampos: integer;
begin
  Result := FCampos.Count;
end;

end.

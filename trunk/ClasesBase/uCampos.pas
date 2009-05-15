{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uCampos.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uCampos;

interface

uses SysUtils, DB, Classes, Contnrs;

type
  TORMTipoDato=( tdDesconocido, tdInteger, tdFloat, tdString, tdDate, tdTime,
              tdDateTime, tdBlobText, tdBlobBinary, tdBoolean, tdTimeStamp);
  TORMFuncionAgregacion = (faNinguna, faCantidad, faCantidadFilas,
                        faCantidadSinDuplicados, faMaximo, faMinimo,
                        faSuma, faSumaSinDuplicados, faPromedio,
                        faPromedioSinDuplicados);
  TORMCampo = class(TObject)
  private
    FPadre            : TObject; //Si pertenece a alguien
    FNombre           : string;
    FTabla            : string;
    FAliasTabla       : string;
    FAliasCampo       : string;
    FSecuencia        : string;
    FParametroAsociado: string;
    FIndiceParametro  : integer;
    FIndice           : integer;
    FLongitud         : integer;
    FEsIdentidad      : boolean;
    FEsClavePrimaria  : boolean;
    FEsClaveForanea   : boolean;
    FAceptaNull       : boolean;
    FEsNulo           : boolean;
    FFueCambiado      : boolean;
    FTipoDato         : TORMTipoDato;
    FValorPorDefecto  : variant;
    FValorActual      : variant;
    FBlobField        : TMemoryStream;
    FFuncionAgregacion: TORMFuncionAgregacion;

    procedure SetValorActual(const Value: variant);
    function GetAsBoolean: boolean;
    function GetAsDateTime: TDateTime;
    function GetAsFloat: double;
    function GetAsInteger: integer;
    function GetAsString: string;
    procedure SetAsBoolean(const Value: boolean);
    procedure SetAsFloat(const Value: double);
    procedure SetAsInteger(const Value: integer);
    procedure SetAsString(const Value: string);
    procedure SetAsDateTime(const Value: TDateTime);
    function GetAsStream: TMemoryStream;
    procedure SetAsStream(const Value: TMemoryStream);
    function GetPadre: TObject;
    procedure SetPadre(const Value: TObject);
    procedure SetEsNulo(const Value: boolean);
  public
    constructor Create( const Tabla: string;
                        const NombreCampo: string;
                        const Secuencia: string;
                        const AliasCampo: string;
                        const AliasTabla: string;
                        const Indice: integer;
                        const Longitud: integer;
                        const EsIdentidad: boolean;
                        const EsClavePrimaria: boolean;
                        const EsClaveForanea: boolean;
                        const AceptaNull: boolean;
                        const TipoDato: TORMTipoDato;
                        const FuncionAgregacion: TORMFuncionAgregacion;
                        const ValorPorDefecto: variant); overload;
    constructor Create( const Tabla: string; const NombreCampo: string); overload;
    destructor Destroy; override;
    function Clonar: TORMCampo;
    property Nombre: string read FNombre;
    property Tabla: string read FTabla;
    property Secuencia: string read FSecuencia;
    property AliasTabla: string read FAliasTabla;
    property AliasCampo: string read FAliasCampo;
    property ParametroAsociado : string read FParametroAsociado write FParametroAsociado;
    property IndiceParametro: integer read FIndiceParametro write FIndiceParametro;
    property Indice: integer read FIndice;
    property Longitud: integer read FLongitud;
    property EsIdentidad: boolean read FEsIdentidad write FEsIdentidad;
    property EsClavePrimaria: boolean read FEsClavePrimaria;
    property EsClaveForanea: boolean read FEsClaveForanea;
    property AceptaNull: boolean read FAceptaNull;
    property EsNulo: boolean read FEsNulo write SetEsNulo;
    property FueCambiado: boolean read FFueCambiado write FFueCambiado;
    property TipoDato: TORMTipoDato read FTipoDato;
    property FuncionAgregacion: TORMFuncionAgregacion read FFuncionAgregacion;
    property ValorPorDefecto: variant read FValorPorDefecto;
    property ValorActual: variant read FValorActual write SetValorActual;
    property AsBoolean: boolean read GetAsBoolean write SetAsBoolean;
    property AsInteger: integer read GetAsInteger write SetAsInteger;
    property AsString: string read GetAsString write SetAsString;
    property AsFloat: double read GetAsFloat write SetAsFloat;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsStream: TMemoryStream read GetAsStream write SetAsStream;

    property Padre: TObject read GetPadre write SetPadre;
  end;

  TORMCamposEnumerator = class;
  TORMColeccionCampos = class(TObjectList)
  private
    function GetORMCampo(index: integer): TORMCampo;
    procedure SetDOrmCampo(index: integer; const Value: TORMCampo);
    procedure SetFueronCambiados(const Value: boolean);
    function GetFueronCambiados: boolean;
  public
    property ORMCampo[index: integer]: TORMCampo read GetORMCampo write SetDOrmCampo; default;
    property FueronCambiados:boolean read GetFueronCambiados write SetFueronCambiados;
    function Agregar(Campo: TORMCampo): integer;
    function Clonar: TORMColeccionCampos;
    function GetEnumerator: TORMCamposEnumerator;
    function CampoPorNombre(sCampo: string): TORMCampo;
  end;

  TORMCamposEnumerator = class
  private
    nCampoIndex: integer;
    FColeccion : TORMColeccionCampos;
  public
    constructor Create(ColeccionCampos: TORMColeccionCampos);
    function  GetCurrent: TORMCampo;
    function  MoveNext: boolean;
    property Current: TORMCampo read GetCurrent;
  end;

implementation

uses Variants;
{ TDOrmCampo }

constructor TORMCampo.Create(const Tabla, NombreCampo, Secuencia, AliasCampo, AliasTabla : string;
  const Indice, Longitud: integer; const EsIdentidad, EsClavePrimaria, EsClaveForanea, AceptaNull: boolean;
  const TipoDato: TORMTipoDato; const FuncionAgregacion: TORMFuncionAgregacion; const ValorPorDefecto: variant);
begin
  FNombre := NombreCampo;
  FTabla := Tabla;
  FSecuencia := Secuencia;
  FAliasTabla := AliasTabla;
  FAliasCampo := AliasCampo;
  FParametroAsociado:= '';
  FIndiceParametro  := -1;

  FIndice := Indice;
  FLongitud := Longitud;
  FEsIdentidad := EsIdentidad;
  FEsClavePrimaria := EsClavePrimaria;
  FEsClaveForanea := EsClaveForanea;
  FAceptaNull := AceptaNull;
  FEsNulo := AceptaNull;
  FFueCambiado := false;
  FTipoDato := TipoDato;
  FFuncionAgregacion := FuncionAgregacion;

  FValorPorDefecto  := ValorPorDefecto;
  FValorActual := FValorPorDefecto;
  FPadre := nil;
end;

function TORMCampo.Clonar: TORMCampo;
begin
  Result := TORMCampo.Create(FTabla, FNombre, FSecuencia, FAliasCampo, FAliasTabla,
  FIndice, FLongitud, FEsIdentidad, FEsClavePrimaria, FEsClaveForanea, FAceptaNull, FTipoDato,
  FFuncionAgregacion,  FValorPorDefecto);

  Result.ValorActual := ValorActual;
  
  if Assigned(FBlobField) then
    Result.AsStream.LoadFromStream(FBlobField);
end;

constructor TORMCampo.Create(const Tabla, NombreCampo: string);
begin
  FNombre := NombreCampo;
  FTabla := Tabla;
  FSecuencia := '';
  FAliasTabla := '';
  FAliasCampo := '';
  FIndice := 0;
  FLongitud := 0;
  FEsIdentidad := false;
  FEsClavePrimaria := false;
  FAceptaNull := false;
  FEsNulo := false;
  FFueCambiado := false;
  FTipoDato := tdDesconocido;
  FParametroAsociado:= '';
  FIndiceParametro := -1;
  FBlobField := nil;
  FFuncionAgregacion := faNinguna;
  FValorPorDefecto  := '';
  FPadre := nil;
end;

destructor TORMCampo.Destroy;
begin
  if assigned(FBlobField) then
    FreeAndNil(FBlobField);

  inherited;
end;

function TORMCampo.GetAsStream: TMemoryStream;
begin
  if not assigned(FBlobField) then
    FBlobField := TMemoryStream.Create;
  FueCambiado := true;
  EsNulo := false;
  Result := FBlobField;
end;

function TORMCampo.GetAsBoolean: boolean;
begin
  Result := ValorActual;
end;

function TORMCampo.GetAsDateTime: TDateTime;
begin
  Result := ValorActual;
end;

function TORMCampo.GetAsFloat: double;
begin
  Result := ValorActual;
end;

function TORMCampo.GetAsInteger: integer;
begin
  Result := ValorActual;
end;

function TORMCampo.GetAsString: string;
begin
  Result := ValorActual;
end;

function TORMCampo.GetPadre: TObject;
begin
  Result := FPadre;
end;

procedure TORMCampo.SetAsStream(const Value: TMemoryStream);
begin
  if assigned(FBlobField) then
    FreeAndNil(FBlobField);
  FBlobField := Value;
  EsNulo := not Assigned(Value);
end;

procedure TORMCampo.SetAsBoolean(const Value: boolean);
begin
  SetValorActual(Value);
end;

procedure TORMCampo.SetAsDateTime(const Value: TDateTime);
begin
  SetValorActual(Value);
end;

procedure TORMCampo.SetAsFloat(const Value: double);
begin
  SetValorActual(Value);
end;

procedure TORMCampo.SetAsInteger(const Value: integer);
begin
  SetValorActual(Value);
end;

procedure TORMCampo.SetAsString(const Value: string);
begin
  SetValorActual(Value);
end;

procedure TORMCampo.SetEsNulo(const Value: boolean);
begin
  if FEsNulo <> Value then
  begin
    FEsNulo := Value;
    FFueCambiado := true;
  end;
end;

procedure TORMCampo.SetPadre(const Value: TObject);
begin
  FPadre := Value;
end;

procedure TORMCampo.SetValorActual(const Value: variant);
begin
  if (VarType(ValorActual) <> VarType(Value)) then
  begin
    FEsNulo := false;
    FFueCambiado := true;
    FValorActual := Value;
  end
  else begin
    if ValorActual <> Value  then
    begin
      FEsNulo := false;
      FFueCambiado := true;
      FValorActual := Value;
    end
  end;
end;


{ TColeccionDOrmCampos }

function TORMColeccionCampos.Agregar(Campo: TORMCampo): integer;
begin
  Campo.Padre := self;
  Result := Add(Campo);
end;

function TORMColeccionCampos.CampoPorNombre(sCampo: string): TORMCampo;
var
  unCampo: TORMCampo;
begin
  Result := nil;
  for unCampo in Self do
  begin
    if unCampo.Nombre = sCampo then
    begin
      Result := unCampo;
      Break;
    end;
  end;
end;

function TORMColeccionCampos.Clonar: TORMColeccionCampos;
var
  nCampo : integer;
begin
  Result := TORMColeccionCampos.Create;

  for nCampo := 0 to Count - 1 do
    Result.Agregar(Self.GetORMCampo(nCampo).Clonar);

end;

function TORMColeccionCampos.GetORMCampo(index: integer): TORMCampo;
begin
  result := (inherited Items[index] as TORMCampo);
end;

function TORMColeccionCampos.GetEnumerator: TORMCamposEnumerator;
begin
  REsult := TORMCamposEnumerator.Create(self);
end;

function TORMColeccionCampos.GetFueronCambiados: boolean;
var
  unCampo : TORMCampo;
begin
  Result := false;
  for unCampo in self do
  begin
    Result := Result or unCampo.FueCambiado;
    if Result then
      Break;
  end;
end;

procedure TORMColeccionCampos.SetDOrmCampo(index: integer; const Value: TORMCampo);
begin
  inherited Items[index] := Value;
end;

procedure TORMColeccionCampos.SetFueronCambiados(const Value: boolean);
var
  unCampo : TORMCampo;
begin
  for unCampo in self do
    unCampo.FueCambiado := Value;
    
end;

{ TDOrmCamposEnumerator }

constructor TORMCamposEnumerator.Create(ColeccionCampos: TORMColeccionCampos);
begin
  inherited Create;

  nCampoIndex := -1;
  FColeccion := ColeccionCampos;
end;

function TORMCamposEnumerator.GetCurrent: TORMCampo;
begin
  Result := FColeccion[nCampoIndex];
end;

function TORMCamposEnumerator.MoveNext: boolean;
begin
  Result := nCampoIndex < (FColeccion.Count - 1);
  if Result then
    Inc(nCampoIndex);
end;

end.

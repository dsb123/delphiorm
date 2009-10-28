{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uCoreClasses.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uCoreClasses;

interface

uses Classes;

type
  TGenerador = class(TCollectionItem)
  private
    FNombre: string;
  published
    property Nombre:string read FNombre write FNombre;
  end;

  TColeccionGenerador = class(TCollection)
  private
    function GetGenerador(index: integer): TGenerador;
  public
    constructor Create; overload;
    function ObtenerGenerador(sNombre: string): TGenerador;
    function ExisteGenerador(sNombre: string): boolean;
    property Generador[index: integer]: TGenerador read GetGenerador;
  end;

  TCampo = class(TCollectionItem)
  private
    FEsClavePrimaria : boolean;
    FNombre: string;
    FAlias: string;
    FLong: integer;
    FPrecision: integer;
    FEscala: integer;
    FEsClaveForanea: boolean;
    FAceptaNull: boolean;
    FAsKeyWord: string;
    FTipoORM: string;
    FTipoVariable: string;
    FTipoBD: string;
    FSubTipoBD: string;
    FValorDefault: variant;
    FFuncionAgregacion: integer;
  public
    function Clonar(Coleccion: TCollection = nil): TCampo;
  published
    property EsClavePrimaria: boolean read FEsClavePrimaria write FEsClavePrimaria;
    property Nombre: string read FNombre write FNombre;
    property Alias: string read FAlias write FAlias;
    property Longitud: integer read FLong write FLong;
    property Precision: integer read FPrecision write FPrecision;
    property Escala: integer read FEscala write FEscala;
    property TipoVariable: string read FTipoVariable write FTipoVariable;
    property TipoORM: string read FTipoORM write FTipoORM;
    property TipoBD: string read FTipoBD write FTipoBD;
    property SubTipoBD: string read FSubTipoBD write FSubTipoBD;
    property AsKeyWord: string read FAsKeyWord write FAsKeyword;
    property EsClaveForanea: boolean read FEsClaveForanea write FEsClaveForanea;
    property AceptaNull : boolean read FAceptaNull write FAceptaNull;
    property ValorDefault: Variant read FValorDefault write FValorDefault;
    property FuncionAgregacion: integer read FFuncionAgregacion write FFuncionAgregacion;
  end;

  TColeccionCampos = class(TCollection)
  private
    function GetCampo(index: integer): TCampo;
  public
    constructor Create; overload;
    function Clonar: TColeccionCampos;
    property Campo[index: integer]: TCampo read GetCampo;
    function ObtenerCampo(sNombre: string): TCampo;
  end;

  TCamposFK = class(TCollectionItem)
  private
    FTablaOrigen : string;
    FTablaDestino: string;
    FNomRelacion : string;
    FNomRelacionAMuchos : string;
    FCamposOrigen: TColeccionCampos;
    FCamposDestino: TColeccionCampos;
  public
    procedure Inicializar;
    destructor Destroy; override;
    function Clonar(Coleccion: TCollection = nil): TCamposFK;

    procedure AgregarCampos(sTablaOrigen: string; sCampoOrigen: string;
                            sTablaDestino: string;sCampoDestino: string;
                            sNomRelacion:string = ''; sNomRelacionAMuchos: String = '');

    property TablaOrigen: string read FTablaOrigen write FTablaOrigen;
    property TablaDestino: string read FTablaDestino write FTablaDestino;
    property NomRelacion : string read FNomRelacion write FNomRelacion;
    property NomRelacionAMuchos : string read FNomRelacionAMuchos write FNomRelacionAMuchos;
    property CamposOrigen: TColeccionCampos read FCamposOrigen write FCamposOrigen;
    property CamposDestino: TColeccionCampos read FCamposDestino write FCamposDestino;
  end;

  TColeccionCamposFK = class(TCollection)
  private
    function GetCamposFK(index: integer): TCamposFK;
  public
    constructor Create; overload;
    function Clonar: TColeccionCamposFK;
    function ObtenerFKGemela(CamposFK: TCamposFK): TCamposFK;
    property CamposFK[index: integer]: TCamposFK read GetCamposFK;
  end;

  TRelacion=class(TCollectionItem)
  private
    FCamposFK: TCamposFK;
    FTipoRelacion: string;
    FAliasRelacion: string;
  public
    property CamposFK: TCamposFK read FCamposFK write FCamposFK;
    property TipoRelacion: string read FTipoRelacion write FTipoRelacion;
    property AliasRelacion: string read FAliasRelacion write FAliasRelacion;
  end;

  TColeccionRelacion = class(TCollection)
  private
    function GetRelacion(index: integer): TRelacion;
  public
    constructor Create; overload;
    function ObtenerRelacionConFK(unCampoFK: TCamposFK): TRelacion;
    property Relacion[index: integer]: TRelacion read GetRelacion;
  end;

  TTabla = class(TCollectionItem)
  private
    FNombre: string;
    FAlias : string;
    FCampos : TColeccionCampos;
    FTieneGenerador: boolean;
    FNombreGenerador: string;
    FCamposFK: TColeccionCamposFK;
    FCamposColeccion: TColeccionCamposFK;
    function GetCamposColeccion: TColeccionCamposFK;
    function GetCamposFK: TColeccionCamposFK;
    function GetCampos: TColeccionCampos;
  public
    procedure Inicializar;
    destructor Destroy; override;
    function Clonar(Coleccion: TCollection = nil): TTabla;
    property Nombre: string read FNombre write FNombre;
    property Alias: string read FAlias write FAlias;
    property TieneGenerador: boolean read FTieneGenerador write FTieneGenerador;
    property NombreGenerador: string read FNombreGenerador write FNombreGenerador;
    property Campos: TColeccionCampos read GetCampos write FCampos;
    property CamposFK: TColeccionCamposFK read GetCamposFK write FCamposFK;
    property CamposColeccion: TColeccionCamposFK read GetCamposColeccion write FCamposColeccion;
  end;

  TColeccionTabla = class(TCollection)
  private
    function GetTabla(index: integer): TTabla;
  public
    constructor Create; overload;
    property Tabla[index: integer]: TTabla read GetTabla;
    function ObtenerTablaPorAlias(sAlias: string): TTabla;
    function ObtenerTabla(sNombre: string): TTabla;
  end;

  TListaTabla = class(TCollectionItem)
  private
    FNombre : string;
    FColeccionTablas : TColeccionTabla;
    FColeccionRelacion: TColeccionRelacion;
    function GetComponentes: TColeccionTabla;
    function GetRelaciones: TColeccionRelacion;
  public
    constructor Create; overload;
    destructor Destroy; override;
    property NombreLista: string read FNombre write FNombre;
    property Componentes: TColeccionTabla read GetComponentes;
    property Relaciones: TColeccionRelacion read GetRelaciones;

  end;

  TColeccionListaTabla = class(TCollection)
  private
    function GetListaTabla(index: integer): TListaTabla;
  public
    constructor Create; overload;
    function ObtenerListaTabla(sNombre: string): TListaTabla;
    property ListaTabla[index: integer]: TListaTabla read GetListaTabla;
  end;

  function CrearNombreRelacion1a1(unaTabla: TTabla; sTablaRelacionada: string): string;
  function CrearNombreRelacion1aMuchos(unaTabla: TTabla; sTablaRelacionada: string): string;

implementation

uses SysUtils;

function CrearNombreRelacion1a1(unaTabla: TTabla; sTablaRelacionada: string): string;
var
  i: Integer;
begin
  Result := trim(sTablaRelacionada);
  for i := 0 to unaTabla.CamposFK.Count - 1 do
  begin
    if Result = unaTabla.CamposFK.CamposFK[i].FNomRelacion then
      Result := Result + '_';
  end;
end;

function CrearNombreRelacion1aMuchos(unaTabla: TTabla; sTablaRelacionada: string): string;
var
  i: Integer;
begin
  Result := trim(sTablaRelacionada);
  for i := 0 to unaTabla.CamposColeccion.Count - 1 do
  begin
    if Result = unaTabla.CamposColeccion.CamposFK[i].FNomRelacionAMuchos then
      Result := Result + '_';
  end;
end;

{ TColeccionGenerador }

function TColeccionGenerador.ObtenerGenerador(sNombre: string): TGenerador;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    if Generador[i].Nombre = sNombre then begin
      Result := Generador[i];
      exit;
    end;
  end;
end;

constructor TColeccionGenerador.Create;
begin
  inherited Create(TGenerador);
end;

function TColeccionGenerador.ExisteGenerador(sNombre: string): boolean;
var
  i : integer;
begin
  Result := false;
  for i := 0 to Count - 1 do begin
    if Generador[i].Nombre = sNombre then begin
      Result := true;
      exit;
    end;
  end;
end;

function TColeccionGenerador.GetGenerador(index: integer): TGenerador;
begin
  Result := Items[index] as TGenerador;
end;

{ TColeccionCampos }

function TColeccionCampos.Clonar: TColeccionCampos;
var
  nCampo : Integer;
begin
  Result := TColeccionCampos.Create;
  for nCampo := 0 to Count - 1 do
    Campo[nCampo].Clonar(Result);
end;

constructor TColeccionCampos.Create;
begin
  inherited Create(TCampo);
end;

function TColeccionCampos.GetCampo(index: integer): TCampo;
begin
  Result := Items[index] as TCampo;
end;

function TColeccionCampos.ObtenerCampo(sNombre: string): TCampo;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    if Campo[i].Nombre = sNombre then begin
      Result := Campo[i];
      exit;
    end;
  end;
end;

{ TTabla }

procedure TTabla.Inicializar;
begin
  //inherited Create(nil);
  FCampos := TColeccionCampos.Create;
  FCamposFK := nil;
  FCamposColeccion := nil;
end;

function TTabla.Clonar(Coleccion: TCollection): TTabla;
begin
  Result := TTabla.Create(Coleccion);
  Result.Nombre := Nombre;
  Result.Alias := Alias;
  Result.TieneGenerador := TieneGenerador;
  Result.Campos.Free;
  Result.Campos := Campos.Clonar;
  Result.CamposFK.Free;
  Result.CamposFK := CamposFK.Clonar;
  Result.CamposColeccion.Free;
  Result.CamposColeccion := CamposColeccion.Clonar;
end;

destructor TTabla.Destroy;
begin
  FCampos.Free;
  if assigned(FCamposFK) then
    FCamposFK.Free;

  if (assigned(FCamposColeccion)) then
    FCamposColeccion.Free;

  inherited Destroy;
end;

function TTabla.GetCampos: TColeccionCampos;
begin
  if not assigned(FCampos) then
    FCampos := TColeccionCampos.Create;

  Result := FCampos;
end;

function TTabla.GetCamposColeccion: TColeccionCamposFK;
begin
  if not assigned(FCamposColeccion) then
    FCamposColeccion := TColeccionCamposFK.Create;

  Result := FCamposColeccion;
end;

function TTabla.GetCamposFK: TColeccionCamposFK;
begin
  if not assigned(FCamposFK) then
    FCamposFK := TColeccionCamposFK.Create;

  Result := FCamposFK;
end;

{ TColeccionTabla }

constructor TColeccionTabla.Create;
begin
  inherited Create(TTabla);
end;

function TColeccionTabla.GetTabla(index: integer): TTabla;
begin
  Result := Items[index] as TTabla;
end;

function TColeccionTabla.ObtenerTabla(sNombre: string): TTabla;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    if ((Tabla[i].Nombre = sNombre) and (Tabla[i].Alias = '')) then
    begin
      Result := Tabla[i];
      exit;
    end;
  end;
end;

function TColeccionTabla.ObtenerTablaPorAlias(sAlias: string): TTabla;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    if Tabla[i].Alias = sAlias then begin
      Result := Tabla[i];
      exit;
    end;
  end;
end;

{ TColeccionCamposFK }
function TColeccionCamposFK.Clonar: TColeccionCamposFK;
var
  nCampoFK : integer;
begin
  Result := TColeccionCamposFK.Create;
  for nCampoFK := 0 to Count - 1 do
    CamposFK[nCampoFK].Clonar(Result);
end;

constructor TColeccionCamposFK.Create;
begin
  inherited Create(TCamposFK);
end;

function TColeccionCamposFK.GetCamposFK(index: integer): TCamposFK;
begin
  Result := Items[index] as TCamposFK;
end;

function TColeccionCamposFK.ObtenerFKGemela(CamposFK: TCamposFK): TCamposFK;
var
  nCampoFK: integer;
  nCampo: integer;
  unCampoCandidato: TCamposFK;
  bEslaFKBuscada: Boolean;
begin
  Result := nil;
  for nCampoFK := 0 to Count - 1 do
  begin
    unCampoCandidato := GetCamposFK(nCampoFK);
    bEslaFKBuscada := false;

    if  (unCampoCandidato.TablaOrigen = CamposFK.TablaOrigen) and
        (unCampoCandidato.TablaDestino = CamposFK.TablaDestino) then
    begin
      if unCampoCandidato.CamposOrigen.Count = CamposFK.CamposOrigen.Count then
      begin
        bEslaFKBuscada := True;
        for nCampo := 0 to unCampoCandidato.CamposOrigen.Count - 1 do
        begin
          if ((not Assigned(unCampoCandidato.CamposOrigen.ObtenerCampo(CamposFK.CamposOrigen.Campo[nCampo].Nombre))) or
              (not Assigned(unCampoCandidato.CamposDestino.ObtenerCampo(CamposFK.CamposDestino.Campo[nCampo].Nombre)))) then
          begin
            bEslaFKBuscada := False;
            Break;
          end;
        end;
      end;
    end;

    if bEslaFKBuscada then
    begin
      Result := unCampoCandidato;
      Break;
    end;
  end;
end;

{ TCamposFK }

procedure TCamposFK.AgregarCampos(sTablaOrigen, sCampoOrigen, sTablaDestino,
  sCampoDestino,sNomRelacion,sNomRelacionAMuchos : String);
var
  unCampo : TCampo;
begin
  FTablaOrigen  := sTablaOrigen;
  FTablaDestino := sTablaDestino;
  if sNomRelacion <> '' then
    FNomRelacion := sNomRelacion;

  if sNomRelacionAMuchos <> '' then
    FNomRelacionAMuchos:= sNomRelacionAMuchos;

  unCampo := TCampo(FCamposOrigen.Add);
  unCampo.Nombre := sCampoOrigen;

  unCampo := TCampo(FCamposDestino.Add);
  unCampo.Nombre := sCampoDestino;
end;

function TCamposFK.Clonar(Coleccion: TCollection): TCamposFK;
begin
  Result := TCamposFK.Create(Coleccion);
  Result.TablaOrigen        := TablaOrigen;
  Result.TablaDestino       := TablaDestino;
  Result.NomRelacion        := NomRelacion;
  Result.NomRelacionAMuchos := NomRelacionAMuchos;

  Result.CamposOrigen.Free;
  Result.CamposOrigen       := CamposOrigen.Clonar;

  Result.CamposDestino.Free;
  Result.CamposDestino      := CamposDestino.Clonar;
end;

destructor TCamposFK.Destroy;
begin
  FCamposOrigen.Free;
  FCamposDestino.Free;
  inherited;
end;

procedure TCamposFK.Inicializar;
begin
  FCamposOrigen := TColeccionCampos.Create;
  FCamposDestino := TColeccionCampos.Create;
end;

{ TListaTabla }

constructor TListaTabla.Create;
begin
  inherited Create(nil);

  FColeccionTablas := nil;
end;

destructor TListaTabla.Destroy;
begin
  if assigned(FColeccionTablas) then
    FColeccionTablas.Free;

  if Assigned(FColeccionRelacion) then
    FColeccionRelacion.Free;
  inherited;
end;

function TListaTabla.GetComponentes: TColeccionTabla;
begin
  if not assigned(FColeccionTablas) then
    FColeccionTablas := TColeccionTabla.Create;

  Result := FColeccionTablas;
end;

function TListaTabla.GetRelaciones: TColeccionRelacion;
begin
  if not assigned(FColeccionRelacion) then
    FColeccionRelacion := TColeccionRelacion.Create;

  Result := FColeccionRelacion;
end;

{ TColeccionListaTabla }

constructor TColeccionListaTabla.Create;
begin
  inherited Create(TListaTabla);
end;

function TColeccionListaTabla.GetListaTabla(index: integer): TListaTabla;
begin
  Result := Items[index] as TListaTabla;
end;

function TColeccionListaTabla.ObtenerListaTabla(sNombre: string): TListaTabla;
var
  nLista : integer;
  unaLista : TListaTabla;
begin
  Result := nil;
  for nLista := 0 to  Count - 1 do
  begin
    unaLista := GetListaTabla(nLista);
    if unaLista.NombreLista = sNombre then begin
      Result := unaLista;
      break;
    end;
  end;
end;

{ TCampo }

function TCampo.Clonar(Coleccion: TCollection): TCampo;
begin
  Result := TCampo.Create(Coleccion);
  Result.Nombre := Nombre;
  Result.Alias  := Alias;
  Result.EsClavePrimaria := EsClavePrimaria;
  Result.EsClaveForanea  := EsClaveForanea;
  Result.Longitud := Longitud;
  Result.AceptaNull := AceptaNull;
  Result.AsKeyWord := AsKeyWord;
  Result.TipoORM := TipoORM;
  Result.TipoVariable := TipoVariable;
  Result.TipoBD := TipoBD;
  Result.ValorDefault := ValorDefault;
end;

{ TColeccionRelacion }

constructor TColeccionRelacion.Create;
begin
  inherited Create(TRelacion);
end;

function TColeccionRelacion.GetRelacion(index: integer): TRelacion;
begin
  Result := Items[index] as TRelacion;
end;

function TColeccionRelacion.ObtenerRelacionConFK(
  unCampoFK: TCamposFK): TRelacion;
var
  nRelacion: integer;
begin
  Result := nil;
  for nRelacion := 0 to Count - 1 do
  begin
    if Relacion[nRelacion].CamposFK = unCampoFK then
      Result := Relacion[nRelacion];
  end;
end;

end.

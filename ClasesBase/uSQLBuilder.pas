{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uSQLBuilder.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uSQLBuilder;

interface

uses Classes, DB, SqlExpr, Contnrs, uCampos, uExpresiones;

type
  { Clases para el manejo de las sentencias SQL }
  TSQLStatement = class
  private
    FSQLParams: TParams;
    FSQLString: string;

    function GetSQLStatement: string;
    function GetSQLParams: TParams;
    procedure SetSQLParams(const Value: TParams);
    //FSQLConnection : TSQLConnection;
    //FEnTransaccion : boolean;
  protected
    FOwnSQLParams: boolean;
  
    function GenerarSQLStatement: string; virtual;

  public
    procedure PrepararSQL;
    function AgregarParametro(const TipoParametro: TTipoDato; valor: variant; const paramInputOutput: boolean = false): string; overload;
    function AgregarParametro(const TipoParametro: TTipoDato; Stream: TStream; const paramInputOutput: boolean = false): string; overload;

    property SQLStatement: string read GetSQLStatement;
    property SQLParams : TParams read GetSQLParams write SetSQLParams;
    //property SQLConnection: TSQLConnection read FSQLConnection write  FSQLConnection;

    //property EnTransaccion: boolean read FEnTransaccion write FEnTransaccion;
  end;

  TSelectStatement = class(TSQLStatement)
  private
    FSinDuplicados: boolean;
    FCantFilas        : integer;
    FTamPagina        : integer;
    FNroPagina        : integer;
    FRecordCount      : integer;

    FColeccionCampos  : TColeccionCampos;
    FCondicion        : TExpresionCondicion;
    FOrden            : TExpresionOrdenamiento;
    FAgrupamiento     : TExpresionAgrupamiento;
    FFiltroHaving     : TExpresionCondicion;
    FRelaciones       : TExpresionRelacion;

    FLiberarExpresiones : boolean;
    FDataSet          : TSQLQuery;

    {Campos de respuesta}
    function GetCondicion: TExpresionCondicion;
    function GetAgrupamiento: TExpresionAgrupamiento;
    function GetFiltroHaving: TExpresionCondicion;
    function GetOrden: TExpresionOrdenamiento;
    function GetRelaciones: TExpresionRelacion;
    function GetRecordCount: integer;
  protected
    function GenerarSQLStatement: string; override;
  public
    constructor Create( Campos: TColeccionCampos; Condicion: TExpresionCondicion;
                        Orden: TExpresionOrdenamiento; Agrupamiento: TExpresionAgrupamiento;
                        FiltroHaving: TExpresionCondicion; Relaciones: TExpresionRelacion;
                        const CantFilas, TamPagina, NroPagina: integer; const SinDuplicados: boolean); overload;
    constructor Create( Campos: TColeccionCampos;
                        const CantFilas, TamPagina, NroPagina: integer;
                        const SinDuplicados: boolean); overload;
    constructor Create(Campos: TColeccionCampos); overload;
    destructor Destroy; override;

    property SinDuplicados: boolean read FSinDuplicados write FSinDuplicados;
    property CantidadFilas: integer read FCantFilas write FCantFilas default 0;
    property TamPagina: integer read FTamPagina write FNroPagina default 0;
    property NroPagina: integer read FNroPagina write FNroPagina default 0;
    property RecordCount: integer read GetRecordCount;
    property ColeccionCampos: TColeccionCampos read FColeccionCampos;
    property Condicion: TExpresionCondicion read GetCondicion;
    property Orden : TExpresionOrdenamiento read GetOrden;
    property Agrupamiento: TExpresionAgrupamiento read GetAgrupamiento;
    property FiltroHaving: TExpresionCondicion read GetFiltroHaving;
    property Relaciones: TExpresionRelacion read GetRelaciones;
    property LiberarExpresiones: boolean read FLiberarExpresiones write FLiberarExpresiones;
    property Datos: TSQLQuery read FDataSet write FDataSet;
  end;
  TSelectStatementPointer = ^TSelectStatement;

  TInsertStatement = class(TSQLStatement)
  private
    FCampos : TColeccionCampos;
    {Campos de respuesta}
    FRegInsertados : integer;
    FGeneradores : TColeccionGenerador;
  protected
    function GenerarSQLStatement: string; override;
  public
    constructor Create(Campos: TColeccionCampos);
    destructor Destroy; override;

    property Campos: TColeccionCampos read FCampos;
    property RegistrosInsertados: integer read FRegInsertados write FRegInsertados;
    property Generadores: TColeccionGenerador read FGeneradores write FGeneradores;
  end;
  TInsertStatementPointer = ^TInsertStatement;

  TUpdateStatement = class(TSQLStatement)
  private
    FCampos: TColeccionCampos;
    FCondicion : TExpresionCondicion;
    FFiltroHaving : TExpresionCondicion;
    FRelaciones   : TExpresionRelacion;
    FLiberarExpresiones : boolean;

    {Campos de respuesta}
    FRegActualizados : integer;
    function GetCondicion: TExpresionCondicion;
    function GetFiltroHaving: TExpresionCondicion;
    function GetRelaciones: TExpresionRelacion;
  protected
    function GenerarSQLStatement: string; override;
  public
    constructor Create( Campos: TColeccionCampos; Condicion: TExpresionCondicion;
                        FiltroHaving: TExpresionCondicion; Relaciones: TExpresionRelacion); overload;
    constructor Create( Campos: TColeccionCampos); overload;
    destructor Destroy; override;

    property Campos: TColeccionCampos read FCampos;
    property Condicion: TExpresionCondicion read GetCondicion;
    property FiltroHaving: TExpresionCondicion read GetFiltroHaving;
    property Relaciones: TExpresionRelacion read GetRelaciones;
    property LiberarExpresiones: boolean read FLiberarExpresiones write FLiberarExpresiones;
    property RegistrosActualizados: integer read FRegActualizados write FRegActualizados;
  end;
  TUpdateStatementPointer = ^TUpdateStatement;

  TDeleteStatement = class(TSQLStatement)
  private
    FTabla: string;
    FCondicion : TExpresionCondicion;
    FFiltroHaving : TExpresionCondicion;
    FRelaciones   : TExpresionRelacion;
    FLiberarExpresiones : boolean;

    {Campos de respuesta}
    FRegEliminados : integer;
    function GetCondicion: TExpresionCondicion;
    function GetFiltroHaving: TExpresionCondicion;
    function GetRelaciones: TExpresionRelacion;
  protected
    function GenerarSQLStatement: string; override;
  public
    constructor Create( const Tabla: string; Condicion: TExpresionCondicion;
                        FiltroHaving: TExpresionCondicion; Relaciones: TExpresionRelacion); overload;
    constructor Create(const Tabla: string); overload;
    destructor Destroy; override;

    property Tabla: string read FTabla;
    property Condicion: TExpresionCondicion read GetCondicion;
    property FiltroHaving: TExpresionCondicion read GetFiltroHaving;
    property Relaciones: TExpresionRelacion read GetRelaciones;
    property LiberarExpresiones: boolean read FLiberarExpresiones write FLiberarExpresiones;
    property RegistrosEliminados: integer read FRegEliminados write FRegEliminados;
  end;
  TDeleteStatementPointer = ^TDeleteStatement;

implementation

uses SysUtils, uGeneradorSelect, uGeneradorInsert, uGeneradorUpdate, uGeneradorDelete;

{ TSelectStatement }

constructor TSelectStatement.Create(Campos: TColeccionCampos;
  Condicion: TExpresionCondicion; Orden: TExpresionOrdenamiento;
  Agrupamiento: TExpresionAgrupamiento; FiltroHaving: TExpresionCondicion;
  Relaciones: TExpresionRelacion; const CantFilas, TamPagina, NroPagina: integer;
  const SinDuplicados: boolean);
begin
  FLiberarExpresiones := true;
  FColeccionCampos := Campos;
  FCondicion := Condicion;
  FOrden := Orden;
  FAgrupamiento := Agrupamiento;
  FFiltroHaving := FiltroHaving;
  FRelaciones := Relaciones;
  FCantFilas := CantFilas;
  FTamPagina := TamPagina;
  FNroPagina := NroPagina;
  FSinDuplicados := SinDuplicados;
  FDataSet := TSQLQuery.Create(nil);
  FSQLString := '';
  FOwnSQLParams := false;
  FSQLParams := nil;
end;

constructor TSelectStatement.Create(Campos: TColeccionCampos);
begin
  FLiberarExpresiones := true;
  FColeccionCampos := Campos;
  FCondicion := nil;
  FOrden := nil;
  FAgrupamiento := nil;
  FFiltroHaving := nil;
  FRelaciones := nil;
  FCantFilas := 0;
  FTamPagina := 0;
  FNroPagina := 0;
  FRecordCount := -1;
  FSinDuplicados := false;
  FDataSet := TSQLQuery.Create(nil);
  FSQLString := '';
  FOwnSQLParams := false;
  FSQLParams := nil;  
end;

constructor TSelectStatement.Create(Campos: TColeccionCampos; const CantFilas,
  TamPagina, NroPagina: integer; const SinDuplicados: boolean);
begin
  FLiberarExpresiones := true;
  FColeccionCampos := Campos;
  FCondicion := nil;
  FOrden := nil;
  FAgrupamiento := nil;
  FFiltroHaving := nil;
  FRelaciones := nil;
  FCantFilas := CantFilas;
  FTamPagina := TamPagina;
  FNroPagina := NroPagina;
  FSinDuplicados := SinDuplicados;
  FDataSet := TSQLQuery.Create(nil);
  FSQLString := '';
  FOwnSQLParams := false;
  FSQLParams := nil;  
end;

destructor TSelectStatement.Destroy;
begin
  FDataSet.Close;
  FreeAndNil(FDataSet);

  if FLiberarExpresiones then begin
    if assigned(FCondicion) then FCondicion.Free;
    if assigned(FOrden) then FOrden.Free;
    if assigned(FAgrupamiento) then FAgrupamiento.Free;
    if assigned(FFiltroHaving) then FFiltroHaving.Free;
    if assigned(FRelaciones) then FRelaciones.Free;
  end
  else begin
    if assigned(FCondicion) and (FCondicion.Tag=1) then FCondicion.Free;
    if assigned(FOrden) and (FOrden.Tag=1) then FOrden.Free;
    if assigned(FAgrupamiento) and (FAgrupamiento.Tag=1) then FAgrupamiento.Free;
    if assigned(FFiltroHaving) and (FFiltroHaving.Tag=1) then FFiltroHaving.Free;
    if assigned(FRelaciones) and (FRelaciones.Tag=1) then FRelaciones.Free;
  end;

  if (FOwnSQLParams) then begin
    FSQLParams.Clear;
    FreeAndNil(FSQLParams);
  end;

  inherited;
end;

function TSelectStatement.GenerarSQLStatement: string;
var
  GenSelect : TGenSelectStatement;
begin
  GenSelect := TGenSelectStatement.Create(self);
  Result := GenSelect.GenerarSQL;
  GenSelect.Free;
end;

function TSelectStatement.GetAgrupamiento: TExpresionAgrupamiento;
begin
  if not assigned(FAgrupamiento) then begin
    FAgrupamiento := TExpresionAgrupamiento.Create;
    FAgrupamiento.Tag := 1;
  end;

  Result := FAgrupamiento;
end;

function TSelectStatement.GetCondicion: TExpresionCondicion;
begin
  if not assigned(FCondicion) then begin
    FCondicion := TExpresionCondicion.Create;
    FCondicion.Tag := 1;
  end;
  Result := FCondicion;
end;

function TSelectStatement.GetFiltroHaving: TExpresionCondicion;
begin
  if not assigned(FFiltroHaving) then begin
    FFiltroHaving := TExpresionCondicion.Create;
    FFiltroHaving.Tag := 1;
  end;

  Result := FFiltroHaving;
end;

function TSelectStatement.GetOrden: TExpresionOrdenamiento;
begin
  if not assigned(FOrden) then begin
    FOrden := TExpresionOrdenamiento.Create;
    FOrden.Tag := 1;
  end;

  Result := FOrden;
end;

function TSelectStatement.GetRecordCount: integer;
begin
  if FRecordCount = -1 then
  begin
    FDataSet.Active := true;
    FRecordCount := 0;
    FDataSet.First;
    while not FDataSet.Eof do
    begin
      Inc(FRecordCount);
      FDataSet.Next;
    end;
    FDataSet.First;
  end;
  Result := FRecordCount
end;

function TSelectStatement.GetRelaciones: TExpresionRelacion;
begin
  if not assigned(FRelaciones) then begin
    FRelaciones := TExpresionRelacion.Create;
    FRelaciones.Tag := 1;
  end;
  Result := FRelaciones;
end;

{ TInsertStatement }

constructor TInsertStatement.Create(Campos: TColeccionCampos);
begin
  FCampos := Campos;
  FGeneradores := TColeccionGenerador.Create;
end;

destructor TInsertStatement.Destroy;
begin
  FreeAndNil(FGeneradores);
  if (FOwnSQLParams) then begin
    FSQLParams.Clear;
    FreeAndNil(FSQLParams);
  end;
  inherited;
end;

function TInsertStatement.GenerarSQLStatement: string;
var
  GenInsert : TGenInsertStatement;
begin
  GenInsert := TGenInsertStatement.Create(self);
  Result := GenInsert.GenerarSQL;
  GenInsert.Free;
end;

{ TUpdateStatement }

constructor TUpdateStatement.Create(Campos: TColeccionCampos; Condicion,
  FiltroHaving: TExpresionCondicion; Relaciones: TExpresionRelacion);
begin
  FCampos := Campos;
  FCondicion := Condicion;
  FFiltroHaving := FiltroHaving;
  FRelaciones := Relaciones;
  FLiberarExpresiones := false;
end;

constructor TUpdateStatement.Create(Campos: TColeccionCampos);
begin
  FCampos := Campos;
  FCondicion := nil;
  FFiltroHaving := nil;
  FRelaciones := nil;
  FLiberarExpresiones := false;
end;

destructor TUpdateStatement.Destroy;
begin
  if (FOwnSQLParams) then begin
    FSQLParams.Clear;
    FreeAndNil(FSQLParams);
  end;
  if FLiberarExpresiones then begin
    if assigned(FCondicion) then FCondicion.Free;
    if assigned(FFiltroHaving) then FFiltroHaving.Free;
    if assigned(FRelaciones) then FRelaciones.Free;
  end
  else begin
    if assigned(FCondicion) and (FCondicion.Tag=1) then FCondicion.Free;
    if assigned(FFiltroHaving) and (FFiltroHaving.Tag=1) then FFiltroHaving.Free;
    if assigned(FRelaciones) and (FRelaciones.Tag=1) then FRelaciones.Free;
  end;
  inherited;
end;

function TUpdateStatement.GenerarSQLStatement: string;
var
  GenUpdate : TGenUpdateStatement;
begin
  GenUpdate := TGenUpdateStatement.Create(self);
  Result := GenUpdate.GenerarSQL;
  GenUpdate.Free;
end;

function TUpdateStatement.GetCondicion: TExpresionCondicion;
begin
  if not assigned(FCondicion) then begin
    FCondicion := TExpresionCondicion.Create;
    FCondicion.Tag := 1;
  end;
  Result := FCondicion;
end;

function TUpdateStatement.GetFiltroHaving: TExpresionCondicion;
begin
  if not assigned(FFiltroHaving) then begin
    FFiltroHaving := TExpresionCondicion.Create;
    FFiltroHaving.Tag := 1;
  end;
  Result := FFiltroHaving;
end;

function TUpdateStatement.GetRelaciones: TExpresionRelacion;
begin
  if not assigned(FRelaciones) then begin
    FRelaciones := TExpresionRelacion.Create;
    FRelaciones.Tag := 1;
  end;
  Result := FRelaciones;
end;

{ TDeleteStatement }

constructor TDeleteStatement.Create(const Tabla: string; Condicion,
  FiltroHaving: TExpresionCondicion; Relaciones: TExpresionRelacion);
begin
  FTabla        := Tabla;
  FCondicion    := Condicion;
  FFiltroHaving := FiltroHaving;
  FRelaciones   := Relaciones;
  FLiberarExpresiones := false;
end;

constructor TDeleteStatement.Create(const Tabla: string);
begin
  FTabla        := Tabla;
  FCondicion    := nil;
  FFiltroHaving := nil;
  FRelaciones   := nil;
  FLiberarExpresiones := false;
end;

destructor TDeleteStatement.Destroy;
begin
  if (FOwnSQLParams) then begin
    FSQLParams.Clear;
    FreeAndNil(FSQLParams);
  end;
  if FLiberarExpresiones then begin
    if assigned(FCondicion) then FCondicion.Free;
    if assigned(FFiltroHaving) then FFiltroHaving.Free;
    if assigned(FRelaciones) then FRelaciones.Free;
  end
  else begin
    if assigned(FCondicion) and (FCondicion.Tag=1) then FCondicion.Free;
    if assigned(FFiltroHaving) and (FFiltroHaving.Tag=1) then FFiltroHaving.Free;
    if assigned(FRelaciones) and (FRelaciones.Tag=1) then FRelaciones.Free;
  end;
  inherited;
end;

function TDeleteStatement.GenerarSQLStatement: string;
var
  GenDelete : TGenDeleteStatement;
begin
  GenDelete := TGenDeleteStatement.Create(self);
  Result := GenDelete.GenerarSQL;
  GenDelete.Free;
end;

function TDeleteStatement.GetCondicion: TExpresionCondicion;
begin
  if not assigned(FCondicion) then begin
    FCondicion := TExpresionCondicion.Create;
    FCondicion.Tag := 1;
  end;
  Result := FCondicion;
end;

function TDeleteStatement.GetFiltroHaving: TExpresionCondicion;
begin
  if not assigned(FFiltroHaving) then begin
    FFiltroHaving := TExpresionCondicion.Create;
    FFiltroHaving.Tag := 1;
  end;

  Result := FFiltroHaving;
end;

function TDeleteStatement.GetRelaciones: TExpresionRelacion;
begin
  if not assigned(FRelaciones) then begin
    FRelaciones := TExpresionRelacion.Create;
    FRelaciones.Tag := 1;
  end;
  Result := FRelaciones;
end;

{ TSQLStatement }

function TSQLStatement.AgregarParametro(const TipoParametro: TTipoDato;
  valor: variant; const paramInputOutput: boolean): string;
var
  Parametro : TParam;
begin
  if paramInputOutput then
    Parametro := TParam.Create(SQLParams, ptInputOutput)
  else
    Parametro := TParam.Create(SQLParams, ptInput);

  with Parametro do
  begin
    case TipoParametro of
      tdInteger: DataType := ftInteger;
      tdString: DataType := ftString;
      tdDate: DataType := ftDate;
      tdTime: DataType := ftTime;
      tdTimeStamp: DataType := ftTimeStamp;
      tdDateTime: DataType := ftDateTime;
      tdBlobText: DataType := ftMemo;
      tdBlobBinary: DataType := ftBlob;
      tdBoolean: Datatype := ftBoolean;
      tdFloat: Datatype := ftFloat;
    end;
  end;
  Parametro.Value := valor;
  Parametro.Name := 'Param' + IntToStr(SQLParams.Count);

  Result := Parametro.Name;
end;

function TSQLStatement.AgregarParametro(const TipoParametro: TTipoDato;
  Stream: TStream; const paramInputOutput: boolean): string;
var
  Parametro : TParam;
begin
  if paramInputOutput then
    Parametro := TParam.Create(SQLParams, ptInputOutput)
  else
    Parametro := TParam.Create(SQLParams, ptInput);

  with Parametro do
  begin
    case TipoParametro of
      tdBlobBinary: DataType := ftBlob;
    end;
  end;
  Parametro.LoadFromStream(Stream, ftTypedBinary);
  Parametro.Name := 'Param' + IntToStr(SQLParams.Count);

  Result := Parametro.Name;
end;

function TSQLStatement.GenerarSQLStatement: string;
begin

end;

function TSQLStatement.GetSQLParams: TParams;
begin
  if not assigned(FSQLParams) then
  begin
    FSQLParams := TParams.Create(nil);
    FOwnSQLParams := true;
  end;

  Result := FSQLParams;
end;

function TSQLStatement.GetSQLStatement: string;
begin
  if FSQLString = '' then
    FSQLString := GenerarSQLStatement;

  Result := FSQLString;
end;

procedure TSQLStatement.PrepararSQL;
begin
  FSQLString := GenerarSQLStatement;
end;

procedure TSQLStatement.SetSQLParams(const Value: TParams);
begin
  FSQLParams := Value;
  FOwnSQLParams := false;
end;

end.

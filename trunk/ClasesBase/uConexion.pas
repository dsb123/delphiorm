{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uConexion.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uConexion;

interface

{$I delphiorm.inc}

uses SysUtils, {$ifdef DELPHI2007}DBXCommon, {$else}dbxpress, {$endif}SqlExpr, uSQLBuilder;

type
  TORMOnExceptionEvent = procedure(e: exception) of object;
  TSQLStatementManager=class
  private
    procedure SetOnExceptionEvent(const Value: TORMOnExceptionEvent);
  protected
    FSQLConnection: TSQLConnection;

    FLastException: Exception;
    FOnExceptionEvent: TORMOnExceptionEvent;
    procedure SetLastException(const Value: Exception);
  public
    constructor Create;
    procedure SetSQLConnection(SQLConn: TSQLConnection);

    function EjecutarSelect(select: TSelectStatement): boolean; virtual; abstract;
    function EjecutarInsert(insert: TInsertStatement): boolean; virtual; abstract;
    function EjecutarUpdate(update: TUpdateStatement): boolean; virtual; abstract;
    function EjecutarDelete(delete: TDeleteStatement): boolean; virtual; abstract;

    property LastException: Exception read FLastException write SetLastException;
    property OnExceptionEvent: TORMOnExceptionEvent read FOnExceptionEvent write SetOnExceptionEvent;
  end;

  TORMEntidadConexion=class
  private
    {$ifdef DELPHI2006UP}
    FTransaccion: TDBXTransaction;
    {$else}
    FTransaccion: TTransactionDesc;
    FEnTransaccion: boolean;
    {$endif}
    FSQLConnection: TSQLConnection;

    FSQLStatementManager: TSQLStatementManager;
    FPublicConnection: boolean;

    function GetEnTransaccion: boolean;
    function GetLastException: Exception;
  public
    constructor Create(Conexion: TSQLConnection; SQLStatementManager: TSQLStatementManager);
    destructor Destroy; override;

    procedure BeginTransaction;
    procedure Commit;
    procedure RollBack;

    function Open: boolean;
    function Close: boolean;

    property EnTransaccion: boolean read GetEnTransaccion;
    property ConexionPublica: boolean read FPublicConnection write FPublicConnection;
    property LastException: Exception read GetLastException;
    property SQLManager: TSQLStatementManager read FSQLStatementManager;
  end;

implementation

{ TEntidadConexion }

procedure TORMEntidadConexion.BeginTransaction;
begin
  {$ifdef DELPHI2006UP}
  FTransaccion := FSQLConnection.BeginTransaction(TDBXIsolations.ReadCommitted);
  {$else}
  FTransaccion.TransactionID := Random(100000000);
  FTransaccion.GlobalID := 0;
  FTransaccion.IsolationLevel := xilREADCOMMITTED;

  FSQLConnection.StartTransaction(FTransaccion);
  FEnTransaccion := true;
  {$endif}
end;

function TORMEntidadConexion.Close: boolean;
begin
  if FSQLConnection.Connected then
    FSQLConnection.Close;

  Result := not FSQLConnection.Connected;
end;

procedure TORMEntidadConexion.Commit;
begin
  {$ifdef DELPHI2006UP}
  FSQLConnection.CommitFreeAndNil(FTransaccion);
  {$else}
  FSQLConnection.Commit(FTransaccion);
  FEnTransaccion := false;
  {$endif}
end;

constructor TORMEntidadConexion.Create(Conexion: TSQLConnection; SQLStatementManager: TSQLStatementManager);
begin
  {$ifdef DELPHI2006UP}
  FTransaccion := nil;
  {$else}
  Randomize;
  FEnTransaccion := false;
  {$endif}
  FPublicConnection := false;
  FSQLConnection := Conexion;
  FSQLStatementManager := SQLStatementManager;
  FSQLStatementManager.SetSQLConnection(FSQLConnection);
end;

destructor TORMEntidadConexion.Destroy;
begin
  FreeAndNil(FSQLConnection);
  FreeAndNil(FSQLStatementManager);
  inherited;
end;

function TORMEntidadConexion.GetEnTransaccion: boolean;
begin
  {$ifdef DELPHI2006UP}
  Result := assigned(FTransaccion);
  {$else}
  Result := FEnTransaccion;
  {$endif}
end;

function TORMEntidadConexion.GetLastException: Exception;
begin
  Result := FSQLStatementManager.LastException;
end;

function TORMEntidadConexion.Open: boolean;
begin
  if not FSQLConnection.Connected then
    FSQLConnection.Open;

  Result := FSQLConnection.Connected;
end;

procedure TORMEntidadConexion.RollBack;
begin
  {$ifdef DELPHI2006UP}
  FSQLConnection.RollbackFreeAndNil(FTransaccion);
  {$else}
  FSQLConnection.Rollback(FTransaccion);
  FEnTransaccion := false;
  {$endif}
end;

{ TSQLStatementManager }

constructor TSQLStatementManager.Create;
begin
  FSQLConnection := nil;
  FLastException := nil;
  FOnExceptionEvent := nil;
end;

procedure TSQLStatementManager.SetLastException(const Value: Exception);
begin
  FLastException := Value;
  if assigned(FOnExceptionEvent) then
    FOnExceptionEvent(Value);
end;

procedure TSQLStatementManager.SetOnExceptionEvent(
  const Value: TORMOnExceptionEvent);
begin
  FOnExceptionEvent := Value;
end;

procedure TSQLStatementManager.SetSQLConnection(SQLConn: TSQLConnection);
begin
  FSQLConnection := SQLConn;
end;

end.

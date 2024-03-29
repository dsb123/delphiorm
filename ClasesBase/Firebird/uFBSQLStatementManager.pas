{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uFBSQLStatementManager.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uFBSQLStatementManager;

interface

uses uConexion, uSQLBuilder, SysUtils, SqlExpr;

type
  TFBSQLStatementManager = class(TSQLStatementManager)
  public
    function EjecutarSelect(select: TSelectStatement): boolean; override;
    function EjecutarInsert(insert: TInsertStatement): boolean; override;
    function EjecutarUpdate(update: TUpdateStatement): boolean; override;
    function EjecutarDelete(delete: TDeleteStatement): boolean; override;
    function ObtenerSecuencia(sSecuencia: string): Integer; override;

  end;

implementation

{ TFBSQLStatementManager }

function TFBSQLStatementManager.EjecutarDelete(
  delete: TDeleteStatement): boolean;
begin
  Result := true;
  try
    delete.RegistrosEliminados := FSQLConnection.Execute(delete.SQLStatement, delete.SQLParams);
  except
    on e: exception do
    begin
      LastException := e;
      Result := false;
    end;
  end;
end;

function TFBSQLStatementManager.EjecutarInsert(
  insert: TInsertStatement): boolean;
var
  SQLDataSet : TSQLQuery;
  nGenerador : integer;
  nIndiceParametro : integer;
begin
  Result := true;
  try
    insert.PrepararSQL;
    if insert.Generadores.Count > 0 then
    begin
      SQLDataSet := TSQLQuery.Create(nil);
      SQLDataSet.SQLConnection := FSQLConnection;
      for nGenerador := 0 to insert.Generadores.Count - 1 do
      begin
        if not insert.Campos.ORMCampo[insert.Generadores.Generador[nGenerador].IndiceCampo].EsClaveForanea then
        begin
          {$ifdef DELPHI2006UP}
          SQLDataSet.CommandText := insert.Generadores.Generador[nGenerador].Generador;
          {$else}
          SQLDataSet.SQL.Text := insert.Generadores.Generador[nGenerador].Generador;
          {$endif}
          SQLDataSet.Open;
          if not (SQLDataSet.Eof and SQLDataSet.Bof) then begin
            nIndiceParametro := insert.Generadores.Generador[nGenerador].IndiceParametro;
            insert.SQLParams.Items[nIndiceParametro].AsInteger := SQLDataSet.Fields[0].AsInteger;
            insert.Campos.ORMCampo[insert.Generadores.Generador[nGenerador].IndiceCampo].AsInteger := SQLDataSet.Fields[0].AsInteger;
          end;
          SQLDataset.Close;
        end;
      end;
      SQLDataSet.Free;
    end;
    insert.RegistrosInsertados  := FSQLConnection.Execute(insert.SQLStatement, insert.SQLParams);
  except
    on e: exception do
    begin
      LastException := e;
      Result := false;
    end;
  end;
end;

function TFBSQLStatementManager.ObtenerSecuencia(sSecuencia: string): Integer;
var
  SQLDataSet : TSQLQuery;
  sSQLCommand: string;
begin
  SQLDataSet := TSQLQuery.Create(nil);
  SQLDataSet.SQLConnection := FSQLConnection;

  sSQLCommand := 'SELECT GEN_ID("' + sSecuencia + '", 1) FROM RDB$DATABASE';
  {$ifdef DELPHI2006UP}
  SQLDataSet.CommandText := sSQLCommand;
  {$else}
  SQLDataSet.SQL.Text := sSQLCommand;
  {$endif}
  SQLDataSet.Open;
  if not (SQLDataSet.Eof and SQLDataSet.Bof) then begin
    Result := SQLDataSet.Fields[0].AsInteger;
  end;
  SQLDataset.Close;
  SQLDataset.Free;
end;

function TFBSQLStatementManager.EjecutarSelect(
  select: TSelectStatement): boolean;
begin
  Result := true;
  try
    select.Datos.SQLConnection := FSQLConnection;
    {$ifdef DELPHI2006UP}
    select.Datos.CommandText := select.SQLStatement;
    {$else}
    select.Datos.SQL.Text := select.SQLStatement;
    {$endif}
    select.Datos.Params.AssignValues(select.SQLParams);
    select.Datos.Prepared := true;
//    FSQLConnection.Execute(select.SQLStatement, select.SQLParams, @select.Datos);
    //select.Datos.ExecSQL;
    select.Datos.Open;
    //SQLConnection.Close;
  except
    on e: exception do
    begin
      LastException := e;
      Result := false;
    end;
  end;
end;

function TFBSQLStatementManager.EjecutarUpdate(
  update: TUpdateStatement): boolean;
begin
  Result := true;
  try
    //GenerarSQLUpdate(Addr(update));
    update.RegistrosActualizados := FSQLCOnnection.Execute(update.SQLStatement,
                                    update.SQLParams);
    //SQLConnection.Close;
  except
    on e: exception do
    begin
      LastException := e;
      Result := false;
    end;
  end;
end;

end.

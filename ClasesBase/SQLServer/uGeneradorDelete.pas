{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uGeneradorDelete.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uGeneradorDelete;

interface

uses DB, uSQLBuilder, uCampos;

type
  TGenDeleteStatement = class
  private
    DeleteStatement: TDeleteStatement;
  public
    Constructor Create(ds: TDeleteStatement);
    function GenerarSQL: string;
  end;

implementation

uses SysUtils, uFuncionesGeneradores, uGeneradorCondiciones, uGeneradorRelaciones;

{ TGenUpdateStatement }

constructor TGenDeleteStatement.Create(ds: TDeleteStatement);
begin
  DeleteStatement := ds;
end;

function TGenDeleteStatement.GenerarSQL: string;
var
  GenCondiciones: TGenCondicionSQL;
  GenRelaciones : TGenRelacionSQL;
begin
  with DeleteStatement do
  begin
    Result := 'DELETE FROM ' + NombreTabla(Tabla);

    if assigned(Relaciones) and (Relaciones.Count > 0) then
    begin
      GenRelaciones := TGenRelacionSQL.Create(Relaciones);
      Result := Result + ' ' + GenRelaciones.ObtenerStringRelacion;
      GenRelaciones.Free;
    end;

    if assigned(Condicion) and (Condicion.Count > 0) then
    begin
      GenCondiciones:= TGenCondicionSQL.Create(Condicion, SQLParams);
      Result := Result + ' ' + GenCondiciones.ObtenerStringCondicion;
      GenCondiciones.Free;
    end;

    if assigned(FiltroHaving) and (FiltroHaving.Count>0)  then
    begin
      GenCondiciones:= TGenCondicionSQL.Create(Condicion, SQLParams, true);
      Result := Result + ' ' + GenCondiciones.ObtenerStringCondicion;
      GenCondiciones.Free;
    end;
  end;
end;

end.

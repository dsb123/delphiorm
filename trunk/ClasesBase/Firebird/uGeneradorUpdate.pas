{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uGeneradorUpdate.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uGeneradorUpdate;

interface

uses DB, uSQLBuilder, uCampos;

type
  TGenUpdateStatement = class
  private
    UpdateStatement: TUpdateStatement;

  public
    Constructor Create(us: TUpdateStatement);
    function GenerarSQL: string;
  end;

implementation

uses SysUtils, uFuncionesGeneradores, uGeneradorCondiciones, uGeneradorRelaciones;

{ TGenUpdateStatement }

constructor TGenUpdateStatement.Create(us: TUpdateStatement);
begin
  UpdateStatement := us;
end;

function TGenUpdateStatement.GenerarSQL: string;
var
  nCampo : integer;
  EsPrimero : boolean;
  GenCondiciones: TGenCondicionSQL;
  GenRelaciones : TGenRelacionSQL;
  sTabla : string;
begin
  with UpdateStatement do
  begin
    sTabla := Campos.ORMCampo[0].Tabla;
    Result := 'UPDATE ' + NombreTabla(Campos.ORMCampo[0].Tabla) + ' SET ';
    EsPrimero := true;
    for nCampo := 0 to Campos.Count - 1 do
    begin
      with Campos.ORMCampo[nCampo] do
      begin
        if FueCambiado and (Tabla = sTabla) then begin
          if not EsPrimero then Result := Result + ', ';
          if EsNulo then
            Result := Result + NombreCampo(Tabla, Nombre) + '=NULL'
          else
          begin
            if TipoDato = tdBlobBinary then begin
              ParametroAsociado := AgregarParametro(TipoDato, AsStream);
            end
            else
              ParametroAsociado := AgregarParametro(TipoDato, ValorActual);

            Result := Result + NombreCampo(Tabla, Nombre) + '=:' + ParametroAsociado;
          end;
          EsPrimero := false;
        end;
      end;
    end;

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

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uGeneradorInsert.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uGeneradorInsert;

interface

uses DB, uSQLBuilder, uCampos;

type
  TGenInsertStatement = class
  private
    InsertStatement: TInsertStatement;

  public
    Constructor Create(InS: TInsertStatement);
    function GenerarSQL: string;
  end;


implementation

uses SysUtils, Classes, uFuncionesGeneradores, uExpresiones;

{ TGenInsertStatement }

constructor TGenInsertStatement.Create(InS: TInsertStatement);
begin
  InsertStatement := Ins;
end;

function TGenInsertStatement.GenerarSQL: string;
var
  sValores : string;
  nCampo : integer;
  sCodigoGenerador : string;
  EsPrimero : boolean;
  sTabla : string;
begin
  with InsertStatement do
  begin
    sTabla := Campos.ORMCampo[0].Tabla;
    Result := 'INSERT INTO ' + NombreTabla(sTabla)+ ' (';

    sValores := '(';
    Generadores.Clear;

    EsPrimero := true;
    for nCampo := 0 to Campos.Count - 1 do
    begin
      with Campos.ORMCampo[nCampo] do
      begin
        if sTabla = Tabla then
        begin
          if not EsPrimero then
          begin
            Result := Result + ', ';
            sValores := sValores + ', ';
          end;

          Result := Result + NombreCampo(Tabla, Nombre);

          if (not EsNulo) or (EsIdentidad) then begin
            if TipoDato = tdBlobBinary then begin
              ParametroAsociado := AgregarParametro(TipoDato, AsStream);
            end
            else
              ParametroAsociado := AgregarParametro(TipoDato, ValorActual);
            IndiceParametro := SQLParams.Count-1;
            if EsIdentidad  then begin
              sCodigoGenerador := 'SELECT GEN_ID("' + Secuencia + '", 1) FROM RDB$DATABASE';
              Generadores.Agregar(TORMGenerador.Create(IndiceParametro, nCampo, sCodigoGenerador));
            end;

            sValores := sValores + ':' + ParametroAsociado;
          end
          else
            sValores := sValores + 'NULL';

          EsPrimero := false;
        end;
      end;
    end;
    sValores := sValores + ')';
    Result := Result + ') values ' + sValores;

    Result := Result;
  end;
end;

end.

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uGeneradorAgrupamientos.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uGeneradorAgrupamientos;

interface

uses uExpresiones;

type
  TGenAgrupamientoSQL = class
  private
    Agrupamiento : TExpresionAgrupamiento;
  public
    constructor Create(unAgrupamiento: TExpresionAgrupamiento);
    function ObtenerStringAgrupamiento: string;
  end;

implementation

uses uFuncionesGeneradores, uCampos;

{ TGenAgrupamientoSQL }

constructor TGenAgrupamientoSQL.Create(unAgrupamiento: TExpresionAgrupamiento);
begin
  Agrupamiento := unAgrupamiento;
end;

function TGenAgrupamientoSQL.ObtenerStringAgrupamiento: string;
var
  nAgrupamiento : integer;
  Campo : TCampo;
begin
  Result := 'GROUP BY ';
  for nAgrupamiento := 0 to Agrupamiento.Count - 1 do
  begin
    if nAgrupamiento > 0 then
      Result := Result + ', ';

    Campo := Agrupamiento.Agrupamiento[nAgrupamiento];
    Result := Result + NombreCampo(Campo.Tabla, Campo.Nombre);
  end;
end;

end.

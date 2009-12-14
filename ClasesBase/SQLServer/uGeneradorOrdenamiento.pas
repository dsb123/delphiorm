{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uGeneradorOrdenamiento.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uGeneradorOrdenamiento;

interface

uses uSQLBuilder, uExpresiones;

type
  TGenOrdenamientoSQL = class
  private
    Ordenamiento : TExpresionOrdenamiento;
  public
    constructor Create(unOrdenamiento: TExpresionOrdenamiento);
    function ObtenerStringOrdenamiento: string;
  end;

implementation

uses uFuncionesGeneradores;

{ TGenAgrupamientoSQL }

constructor TGenOrdenamientoSQL.Create(unOrdenamiento: TExpresionOrdenamiento);
begin
  Ordenamiento := unOrdenamiento;
end;

function TGenOrdenamientoSQL.ObtenerStringOrdenamiento: string;
var
  nOrdenamiento : integer;
  Orden : TOrdenamiento;
begin
  Result := 'ORDER BY ';
  for nOrdenamiento := 0 to Ordenamiento.Count - 1 do
  begin
    if nOrdenamiento > 0 then
      Result := Result + ', ';

    Orden := Ordenamiento.Ordenamiento[nOrdenamiento];
    Result := Result + NombreCampo(Orden.Campo.Tabla, Orden.Campo.Nombre);
    case Orden.TipoOrden of
      toAscendente: Result := Result + ' ASC';
      toDescendente: Result := Result + ' DESC';
    end;
  end;
end;

end.


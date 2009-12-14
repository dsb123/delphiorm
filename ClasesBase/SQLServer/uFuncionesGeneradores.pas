{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uFuncionesGeneradores.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uFuncionesGeneradores;

interface

uses uCampos;

function NombreCampo(const Tabla, Campo: string): string;
function NombreTabla(const Tabla: string): string;
function FuncionAgregacion(funcionAgregacion: TFuncionAgregacion; const Tabla, Campo: string): string;


implementation

function NombreCampo(const Tabla, Campo: string): string;
begin
  if Tabla <> '' then
    Result := '[' + Tabla + '].[' +  Campo + ']'
  else
    Result := '[' +  Campo + ']';
end;

function NombreTabla(const Tabla: string): string;
begin
  Result := '[' + Tabla + ']';
end;

function FuncionAgregacion(funcionAgregacion: TFuncionAgregacion; const Tabla, Campo: string): string;
begin
  case funcionAgregacion of
    faCantidad: Result := 'COUNT (' + NombreCampo(Tabla, Campo) + ')';
    faCantidadFilas: Result := 'COUNT (*)';
    faCantidadSinDuplicados: Result := 'COUNT (DISTINCT ' + NombreCampo(Tabla, Campo) + ')';
    faMaximo: Result := 'MAX (' + NombreCampo(Tabla, Campo) + ')';
    faMinimo: Result := 'MIN (' + NombreCampo(Tabla, Campo) + ')';
    faSuma: Result := 'SUM (' + NombreCampo(Tabla, Campo) + ')';
    faSumaSinDuplicados: Result := 'SUM (DISTINCT ' + NombreCampo(Tabla, Campo) + ')';
    faPromedio: Result := 'AVG (' + NombreCampo(Tabla, Campo) + ')';
    faPromedioSinDuplicados: Result := 'AVG (DISTINCT ' + NombreCampo(Tabla, Campo) + ')';
  end;
end;

end.

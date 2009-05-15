{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uGeneradorRelaciones.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uGeneradorRelaciones;

interface

uses uExpresiones;

type
  TGenRelacionSQL = class
  private
    Relaciones : TExpresionRelacion;
  public
    Constructor Create(Relacion: TExpresionRelacion);
    function ObtenerStringRelacion: string;
  end;

implementation

uses uFuncionesGeneradores;

{ TGenRelacionSQL }

constructor TGenRelacionSQL.Create(Relacion: TExpresionRelacion);
begin
  Relaciones := Relacion;
end;

function TGenRelacionSQL.ObtenerStringRelacion: string;
var
  Relacion : TORMRelacion;
  nRelacion : integer;
  nCampo: Integer;
begin
  Result := '';
  for nRelacion := 0 to Relaciones.Count - 1 do
  begin
    if nRelacion > 0 then
      Result := Result + ' ';

    Relacion := Relaciones.Relacion[nRelacion];

    case Relacion.TipoRelacion of
      trAmbas: Result := Result + ' INNER JOIN ';
      trIzquierda: Result := Result + ' LEFT JOIN ';
      tdDerecha: Result := Result + ' RIGHT JOIN ';
    end;

    Result := Result + '' + NombreTabla(Relacion.CamposForaneo.Tabla) + ' ON ';

    for nCampo := 0 to Relacion.CamposForaneo.CantCampos - 1 do
    begin
      Result := Result + Nombrecampo( Relacion.CamposPrimario.Tabla,
                                      Relacion.CamposPrimario.Campo[nCampo]) +
                ' = ' +  NombreCampo( Relacion.CamposForaneo.Tabla,
                                      Relacion.CamposForaneo.Campo[nCampo]);
      if nCampo < (Relacion.CamposForaneo.CantCampos - 1) then
        Result := Result + ' AND ';

    end;
  end;
end;

end.

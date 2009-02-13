{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uGeneradorSelect.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uGeneradorSelect;

interface

uses uSQLBuilder, uExpresiones, uCampos;

type
  TGenSelectStatement = class
  private
    SelectStatement: TSelectStatement;
  public
    Constructor Create; overload;
    Constructor Create(SS: TSelectStatement); overload;
    function GenerarSQL: string;
    function  CrearSelectSQL(SinDuplicados: boolean;
              NroPagina: integer; TamPagina: integer; CantidadFilas: integer;
              ColeccionCampos: TColeccionCampos; Relaciones: TExpresionRelacion;
              Condicion: TExpresionCondicion; Ordenamiento: TExpresionOrdenamiento;
              Agrupamiento: TExpresionAgrupamiento; FiltroHaving: TExpresionCondicion): String;
  end;

implementation

{ TGenSelectStatement }
uses  DB, SysUtils, StrUtils, uFuncionesGeneradores, uGeneradorCondiciones,
      uGeneradorRelaciones, uGeneradorAgrupamientos, uGeneradorOrdenamiento;

function TGenSelectStatement.CrearSelectSQL(SinDuplicados: boolean;
  NroPagina, TamPagina, CantidadFilas: integer; ColeccionCampos: TColeccionCampos;
  Relaciones: TExpresionRelacion; Condicion: TExpresionCondicion;
  Ordenamiento: TExpresionOrdenamiento; Agrupamiento: TExpresionAgrupamiento;
  FiltroHaving: TExpresionCondicion): String;
var
  nRegistroASaltear, nCampo : integer;
  sFrom : string;
  Campo : TCampo;
  GenCondiciones: TGenCondicionSQL;
  GenRelaciones : TGenRelacionSQL;
  GenAgrupamientos: TGenAgrupamientoSQL;
  GenOrdenamiento : TGenOrdenamientoSQL;
begin
  Result := 'SELECT ';

  if SinDuplicados then Result := Result + 'DISTINCT ' ;

  if NroPagina <> 0 and TamPagina then
  begin
    Result := Result + 'FIRST ' + IntToStr(TamPagina);
    nRegistroASaltear := NroPagina * (TamPagina-1);

    if nRegistroASaltear > 0  then
      Result := ' SKIP ' +  IntToStr(nRegistroASaltear);

    Result := Result + ' ';
  end
  else
    if CantidadFilas > 0 then
      Result := Result + ' FIRST ' +  IntToStr(CantidadFilas) + ' ';

  sFrom := '';

  for nCampo := 0 to ColeccionCampos.Count  - 1 do
  begin
    if nCampo > 0 then
      Result := Result + ', ';

    Campo := ColeccionCampos.Campo[nCampo];

    if sFrom = '' then begin
      sFrom := IfThen(Campo.AliasTabla <> '',
                      NombreTabla(Campo.Tabla) + ' ' + NombreTabla(Campo.AliasTabla),
                      NombreTabla(Campo.Tabla));
    end;

    if Campo.FuncionAgregacion = faNinguna then
    begin
      if Campo.AliasTabla <> '' then begin
        if Campo.AliasCampo <> '' then
          Result := Result + NombreCampo(Campo.AliasTabla, Campo.Nombre) + ' ' +  NombreCampo('', Campo.AliasCampo)
        else
          Result := Result + NombreCampo(Campo.AliasTabla, Campo.Nombre);
      end
      else begin
        if Campo.AliasCampo <> '' then
          Result := Result + NombreCampo(Campo.Tabla, Campo.Nombre) + ' ' +  NombreCampo('', Campo.AliasCampo)
        else
          Result := Result + NombreCampo(Campo.Tabla, Campo.Nombre);
      end;
    end
    else
    begin
      if Campo.AliasTabla <> '' then begin
        if Campo.AliasCampo <> '' then
          Result := Result + FuncionAgregacion( Campo.FuncionAgregacion,
                                                Campo.AliasTabla, Campo.AliasCampo)
        else
          Result := Result + FuncionAgregacion( Campo.FuncionAgregacion,
                                                Campo.AliasTabla, Campo.Nombre);
      end
      else begin
        if Campo.AliasCampo <> '' then
          Result := Result + FuncionAgregacion( Campo.FuncionAgregacion,
                                                Campo.Tabla, Campo.AliasCampo)
        else
          Result := Result + FuncionAgregacion( Campo.FuncionAgregacion,
                                                Campo.Tabla, Campo.Nombre);
      end;
    end;
  end;
  Result := Result + ' FROM ' + sFrom;

  if (assigned(Relaciones)) and (Relaciones.Count > 0) then
  begin
    GenRelaciones := TGenRelacionSQL.Create(Relaciones);
    Result := Result + ' ' + GenRelaciones.ObtenerStringRelacion;
    GenRelaciones.Free;
  end;

  if (assigned(Condicion)) and (Condicion.Count > 0) then
  begin
    GenCondiciones:= TGenCondicionSQL.Create(Condicion, SelectStatement.SQLParams);
    Result := Result + ' ' + GenCondiciones.ObtenerStringCondicion;
    GenCondiciones.Free;
  end;

  if (assigned(Agrupamiento)) and (Agrupamiento.Count > 0) then
  begin
    GenAgrupamientos := TGenAgrupamientoSQL.Create(Agrupamiento);
    Result := Result + ' ' + GenAgrupamientos.ObtenerStringAgrupamiento;
    GenAgrupamientos.Free;
  end;

  if (assigned(FiltroHaving)) and (FiltroHaving.Count > 0) then
  begin
    GenCondiciones:= TGenCondicionSQL.Create(Condicion, SelectStatement.SQLParams, true);
    Result := Result + ' ' + GenCondiciones.ObtenerStringCondicion;
    GenCondiciones.Free;
  end;

  if (assigned(Ordenamiento)) and (Ordenamiento.Count > 0) then
  begin
    GenOrdenamiento := TGenOrdenamientoSQL.Create(Ordenamiento);
    Result := Result + ' ' + GenOrdenamiento.ObtenerStringOrdenamiento;
    GenOrdenamiento.Free;
  end;

end;

constructor TGenSelectStatement.Create;
begin

end;

constructor TGenSelectStatement.Create(SS: TSelectStatement);
begin
  SelectStatement := SS;
end;

function TGenSelectStatement.GenerarSQL: string;
begin
  with SelectStatement do
  begin
    Result := CrearSelectSQL(SinDuplicados, NroPagina, TamPagina,
                    CantidadFilas, ColeccionCampos, Relaciones, Condicion,
                    Orden, Agrupamiento, FiltroHaving);
    
  end;
end;

end.

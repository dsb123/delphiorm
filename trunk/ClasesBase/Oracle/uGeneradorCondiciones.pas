{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uGeneradorCondiciones.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uGeneradorCondiciones;

interface

uses DB, uCampos, uSQLBuilder, uExpresiones;

type
  TGenCondicionSQL = class
  private
    Condicion: TExpresionCondicion;
    Params: TParams;
    ClausulaHaving : boolean;
    function CondicionString(Condicion: TExpresionCondicion; EmpezarClausula: boolean=false): string;
    function CondicionComparacionString(Condicion: TCondicionComparacion): string;
    function CondicionInclusionString(Condicion: TCondicionInclusion): string;
    function CondicionLikeString(Condicion: TCondicionLike): string;
    function CondicionNullString(Condicion: TCondicionNull): string;
    function CondicionSeleccionString(Condicion: TCondicionSeleccion): string;
    function AgregarParametro(TipoParametro: TORMTipoDato; valor: variant): string;
  public
    Constructor Create(unaCondicion: TExpresionCondicion; Parametros: TParams; EsClausulaHaving: boolean=false);
    function ObtenerStringCondicion: string;
  end;

implementation

uses SysUtils, StrUtils, uFuncionesGeneradores;

{ TGenCondicionSQL }

constructor TGenCondicionSQL.Create(unaCondicion: TExpresionCondicion;
  Parametros: TParams; EsClausulaHaving: boolean);
begin
  Condicion := unaCondicion;
  Params := Parametros;
  ClausulaHaving := EsClausulaHaving;
end;

function TGenCondicionSQL.ObtenerStringCondicion: string;
begin
  Result := CondicionString(Condicion);
end;

function TGenCondicionSQL.CondicionString(Condicion: TExpresionCondicion;
   EmpezarClausula: boolean): string;
var
  unaCondicion: TCondicion;
  nCondicion : integer;
begin
  if not EmpezarClausula then
    Result := IfThen(ClausulaHaving, 'HAVING ', 'WHERE ')
  else
    Result := '';

  with Condicion do
  begin
    for nCondicion := 0 to Condiciones.Count - 1 do
    begin
      if nCondicion > 0 then Result := Result + ' ';
      unaCondicion := Condiciones.Condicion[nCondicion];

      case unaCondicion.Operador of
        ocNinguno: Result := Result + '';
        ocOperadorAND: Result := Result + ' AND ';
        ocOperadorOR: Result := Result + ' OR ';
      end;

      if unaCondicion.Negacion then
        Result := Result + ' NOT ';

      if (unaCondicion is TCondicionComparacion) then
        Result := Result + CondicionComparacionString(unaCondicion as TCondicionComparacion)
      else if (unaCondicion is TCondicionInclusion) then
        Result := Result + CondicionInclusionString(unaCondicion as TCondicionInclusion)
      else if (unaCondicion is TCondicionLike) then
        Result := Result + CondicionLikeString(unaCondicion as TCondicionLike)
      else if (unaCondicion is TCondicionNull) then
        Result := Result + CondicionNullString(unaCondicion as TCondicionNull)
      else if (unaCondicion is TCondicionSeleccion) then
        Result := Result + CondicionSeleccionString(unaCondicion as TCondicionSeleccion)
      else if (unaCondicion is TExpresionCondicion) then
        Result := Result + '(' + CondicionString(unaCondicion as TExpresionCondicion, true) + ')';
    end;
  end;
end;

function TGenCondicionSQL.AgregarParametro(TipoParametro: TORMTipoDato;
  valor: variant): string;
var
  Parametro : TParam;
begin
  Parametro := TParam.Create(Params, ptInput);
  with Parametro do
  begin
    case TipoParametro of
      tdInteger: DataType := ftInteger;
      tdString: DataType := ftString;
      tdDate: DataType := ftDate;
      tdTime: DataType := ftTime;
      tdDateTime: DataType := ftDateTime;
      tdTimeStamp: DataType := ftTimeStamp;
      tdBlobText: DataType := ftMemo;
      tdBlobBinary: DataType := ftBlob;
      tdBoolean: Datatype := ftBoolean;
      tdFloat: Datatype := ftFloat;
    end;
  end;
  Parametro.Name := 'Param' + IntToStr(Params.Count);
  Parametro.Value := valor;
  Result := Parametro.Name;
end;

function TGenCondicionSQL.CondicionComparacionString(
  Condicion: TCondicionComparacion): string;
begin
  if Condicion.Campo.FuncionAgregacion = faNinguna then
    Result := NombreCampo(Condicion.Campo.Tabla, Condicion.Campo.Nombre)
  else
    Result := FuncionAgregacion(Condicion.Campo.FuncionAgregacion, Condicion.Campo.Tabla, Condicion.Campo.Nombre);

  case Condicion.TipoComparacion of
    tcIgual: Result := Result + '=';
    tcDistinto: Result := Result + '<>';
    tcMenor: Result := Result + '<';
    tcMenorIgual: Result := Result + '<=';
    tcMayor: Result := Result + '>';
    tcMayorIgual: Result := Result + '>=';
  end;
  if Assigned(Condicion.CampoValor) then
    Result := Result + NombreCampo(Condicion.CampoValor.Tabla, Condicion.CampoValor.Nombre)
  else
    Result := Result + ':' + AgregarParametro(Condicion.Campo.TipoDato,Condicion.Valor);
end;

function TGenCondicionSQL.CondicionInclusionString(
  Condicion: TCondicionInclusion): string;
var
  i : integer;
begin
  with Condicion do
  begin
    if Campo.AliasTabla <> '' then
    begin
      if Campo.AliasCampo <> ''  then
        Result := NombreCampo(Campo.AliasTabla, Campo.AliasCampo)
      else
        Result := NombreCampo(Campo.AliasTabla, Campo.Nombre);
    end
    else begin
      if Campo.AliasCampo <> ''  then
        Result := NombreCampo(Campo.Tabla, Campo.AliasCampo)
      else
        Result := NombreCampo(Campo.Tabla, Campo.Nombre);
    end;
    Result := Result + ' IN (';

    for i := 0 to Lista.Count - 1 do
    begin
      if i > 0 then
        Result := Result + ', ';
      Result := Result + ':' + AgregarParametro(Condicion.Campo.TipoDato, Lista.Item[i]);
    end;
    Result := Result + ')';
  end;
end;

function TGenCondicionSQL.CondicionLikeString(
  Condicion: TCondicionLike): string;
begin
  Result := NombreCampo(Condicion.Campo.Tabla, Condicion.Campo.Nombre) +
            ' LIKE ' + QuotedStr(Condicion.CadenaABuscar);
end;

function TGenCondicionSQL.CondicionNullString(
  Condicion: TCondicionNull): string;
begin
  Result := NombreCampo(Condicion.Campo.Tabla, Condicion.Campo.Nombre) + ' IS NULL';
end;

function TGenCondicionSQL.CondicionSeleccionString(
  Condicion: TCondicionSeleccion): string;
var
  ColeccionCampos : TORMColeccionCampos;
  Select : TSelectStatement;
begin
  ColeccionCampos := TORMColeccionCampos.Create;

  with Condicion do
  begin
    ColeccionCampos.Agregar(CampoSeleccion.Clonar);
    select := TSelectStatement.Create(ColeccionCampos,
                                      condicion,
                                      nil,
                                      Agrupamiento,
                                      FiltroHaving,
                                      Relaciones, 0, 0, 0, SinDuplicados);
    select.SQLParams := Params;
    Result := NombreCampo(CampoInclusion.Tabla, CampoInclusion.Nombre) +
              ' IN (' + select.SQLStatement + ')';

    FreeAndNil(ColeccionCampos);
    FreeAndNil(select);
  end;
end;

end.

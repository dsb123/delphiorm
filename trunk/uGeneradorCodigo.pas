{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uGeneradorCodigo.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uGeneradorCodigo;

interface

uses classes, Dialogs, SysUtils, StrUtils, uCoreClasses;

type
  TGeneradorCodigo=class
  private
    function ContextoBlobBinary(unCampo:TCampo; sVariableContexto: string): string;
    function ContextoCampoListas(ListaEntidad: TListaTabla; sVariableContexto: string): string;
    function ContextoEntidadListas(sVariableContexto: string; ListaEntidad: TListaTabla): string;
    function ContextoLista(sVariableContexto: string): string;
    function ContextoRelacionListas(ListaEntidad: TListaTabla; sVariableContexto: string): string;
    function ContextoBlobTypeLista(unaEntidad: TListaTabla; sVariableContexto: string): string;
    function ContextoEntidad(sVariableContexto: string): string;
    function ContextoEntidadAsociada(EntidadActiva: TTabla; sVariableContexto: string): string;
    function ContextoColeccionEntidadAsociada(EntidadActiva: TTabla; sVariableContexto: string): string;
    function ContextoCampoFK(CamposFK: TCamposFK; sVariableContexto: string): string;
    function ContextoCampo(EntidadActiva:TTabla ; sVariableContexto: string): string;
    function ContextoCampoClave(EntidadActiva: TTabla; sVariableContexto: string): string;
    function ContextoColeccion(sVariableContexto: string): string;
    function ContextoBlobType(unaEntidad: TTabla; sVariableContexto: string): string;

    function LimpiarLineasBlancos(sTexto: string): string;
  public
    Tablas: TColeccionTabla;
    Listas: TColeccionListaTabla;

    class function ComprobarTemplate(sl: TStringList): boolean;
    function GenerarCodigo(sTextoTemplate: string): string;
  end;

implementation

function HayError(sLinea, sEtiquetaIni:String; var nControl: Integer; nLinea: Integer): Boolean;
var
  sEtiquetaFin: string;
begin
  Result:=False;

  sEtiquetaFin  :=  MidStr(sEtiquetaIni, 1, 1) + '/';
  sEtiquetaFin  :=  sEtiquetaFin +
                    MidStr(sEtiquetaIni, 2, Length(sEtiquetaIni));

  if Pos(sEtiquetaIni, sLinea) > 0 then
  begin
    if nControl=1 then
    begin
      MessageDlg( 'Debe Cerrar un' + sEtiquetaIni +  'en la Linea: ' + IntToStr(nLinea + 1),
                  mtError, [mbOK], 1);
      Result:=True;
    end
    else
      nControl:=1;
  end;

  if Pos(sEtiquetaFin, sLinea) > 0 then
  begin
    if nControl=0 then
    begin
      MessageDlg( 'Debe Abrir un' + sEtiquetaIni +  'en la Linea: ' + IntToStr(nLinea + 1),
                  mtError, [mbOK], 1);
      Result:=True;
    end
    else
      nControl:=0;
  end;
end;

{ TGeneradorCodigo }

class function TGeneradorCodigo.ComprobarTemplate(sl: TStringList): boolean;
var
  nLinea: Integer;

  nEntidad, nEntidadAsociada: Integer;

  nLista,nListaEntidad: Integer;

  nColeccion, nCampo : Integer;

  nRelacion, nRelacionMuchos: Integer;

  nCampoFK, nCampoClave: Integer;
begin
  Result:=True;
  nEntidad          := 0;
  nEntidadAsociada  := 0;
  nLista            := 0;
  nListaEntidad     := 0;
  nColeccion        := 0;
  nCampo            := 0;
  nRelacion         := 0;
  nRelacionMuchos   := 0;
  nCampoFK          := 0;
  nCampoClave       := 0;

  for nLinea := 0 to sl.Count - 1 do
  begin
    if HayError(sl.Strings[nLinea], '<PorCadaEntidad>', nEntidad, nLinea) then
    begin
      Result:=False;
      Break;
    end;

    if HayError(sl.Strings[nLinea], '<PorCadaEntidadAsociada>', nEntidadAsociada, nLinea) then
    begin
      Result:=False;
      Break;
    end;

    if HayError(sl.Strings[nLinea], '<PorCadaLista>', nLista, nLinea) then
    begin
      Result:=False;
      Break;
    end;

    if HayError(sl.Strings[nLinea], '<PorCadaListaEntidad>', nListaEntidad, nLinea) then
    begin
      Result:=False;
      Break;
    end;

    if HayError(sl.Strings[nLinea], '<PorCadaColeccionAsociada>', nColeccion, nLinea) then
    begin
      Result:=False;
      Break;
    end;

    if HayError(sl.Strings[nLinea], '<PorCadaCampo>', nCampo, nLinea) then
    begin
      Result:=False;
      Break;
    end;

    if HayError(sl.Strings[nLinea], '<IfTieneRelacion>', nRelacion, nLinea) then
    begin
      Result:=False;
      Break;
    end;

    if HayError(sl.Strings[nLinea], '<IfTieneRelacionAMuchos>', nRelacionMuchos, nLinea) then
    begin
      Result:=False;
      Break;
    end;

    if HayError(sl.Strings[nLinea], '<PorCadaCampoFK>', nCampoFK, nLinea) then
    begin
      Result:=False;
      Break;
    end;

    if HayError(sl.Strings[nLinea], '<PorCadaCampoClave>', nCampoClave, nLinea) then
    begin
      Result:=False;
      Break;
    end;
  end;
end;

function TGeneradorCodigo.ContextoBlobBinary(unCampo:TCampo; sVariableContexto: string): string;
var
  PosElse : integer;
begin

  PosElse := Pos('<ElseBlobBinary>', sVariableContexto);
  if PosElse > 0 then
  begin
     if unCampo.TipoORM='tdBlobBinary' then
        sVariableContexto := MidStr(sVariableContexto, 1, PosElse - 1)
     else
        sVariableContexto := MidStr(sVariableContexto, PosElse + 16, Length(sVariableContexto));
  end;
  Result := sVariableContexto

end;

function TGeneradorCodigo.ContextoBlobType(unaEntidad: TTabla;
  sVariableContexto: string): string;
var
  j,nPosStart,nPosEnd : integer;
  sVarAux,sVarAux2:string;
begin
  Result:='';
  sVarAux := sVariableContexto;
  for j := 0 to unaEntidad.Campos.Count - 1 do
  begin
    if unaEntidad.Campos.Campo[j].TipoORM = 'tdBlobBinary' then
    begin
      sVarAux := StringReplace(sVarAux, '<BlobType>', '', [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '</BlobType>','', [rfReplaceAll]);
    end
    else
    begin
      nPosStart := -1;
      nPosEnd   := -2;
      while nPosStart <> nPosEnd  do
      begin
        nPosStart := Pos('<BlobType>', sVarAux);
        nPosEnd   := Pos('</BlobType>',sVarAux);
        if nPosStart <> nPosEnd then
        begin
          sVarAux2  := MidStr(sVarAux, nPosStart, nPosEnd + 11 - nPosStart);
          sVarAux   := StringReplace(sVarAux, sVarAux2,'', [rfReplaceAll]);
        end;
      end;
    end;
  end;
  Result  := sVarAux;
end;

function TGeneradorCodigo.ContextoBlobTypeLista(unaEntidad: TListaTabla;
  sVariableContexto: string): string;
var
  nComponente, nEntidad, nPosStart, nPosEnd : integer;
  bPaso:Boolean;
  sVarAux,sVarAux2:string;
begin
  Result  := '';
  bPaso   := False;
  with unaEntidad.Componentes do
  begin
    sVarAux :=  sVariableContexto;

    for nEntidad:=0 to Count- 1 do
    begin
      for nComponente := 0 to Tabla[nEntidad].Campos.Count - 1 do
      begin
        if Tabla[nEntidad].Campos.Campo[nComponente].TipoORM = 'tdBlobBinary' then
        begin
          sVarAux := StringReplace(sVarAux, '<BlobType>','', [rfReplaceAll]);
          sVarAux := StringReplace(sVarAux, '</BlobType>','', [rfReplaceAll]);
          bPaso:=True;
        end;
        if bPaso then Break;
      end;
      if bPaso then Break;
    end;

    if not bPaso then
    begin
      nPosStart := -1;
      nPosEnd   := -2;
      while nPosStart <> nPosEnd  do
      begin
        nPosStart := Pos('<BlobType>', sVarAux);
        nPosEnd   := Pos('</BlobType>',sVarAux);
        if nPosStart <> nPosEnd then
        begin
          sVarAux2  := MidStr(sVarAux, nPosStart, nPosEnd + 11 - nPosStart);
          sVarAux   := StringReplace(sVarAux, sVarAux2,'', [rfReplaceAll]);
        end;
      end;
    end;

    Result := sVarAux;
  end;
end;

function TGeneradorCodigo.ContextoCampo(EntidadActiva: TTabla;
  sVariableContexto: string): string;
var
  i,nPosStart,nPosEnd : integer;
  sVarAux,sVarAux2,sVarAuxIzq,sVarAuxDer : string;
begin
  Result := '';
  for i := 0 to EntidadActiva.Campos.Count - 1 do
  begin
    sVarAux := sVariableContexto;

    nPosStart := Pos('<IfBlobBinary>', sVarAux);
    while (nPosStart > 0) do
    begin
     nPosEnd    := Pos('</IfBlobBinary>', sVarAux);
     sVarAuxIzq := LeftStr(sVarAux,nPosStart - 1);
     sVarAuxDer := MidStr(sVarAux,nPosEnd + 15, length(sVarAux));
     sVarAux2   := MidStr(sVarAux, nPosStart + 14, nPosEnd - (nPosStart + 14));
     sVarAux    := sVarAuxIzq + ContextoBlobBinary(EntidadActiva.Campos.Campo[i], sVarAux2);
     sVarAux    := sVarAux + sVarAuxDer;
     nPosStart  := Pos('<IfBlobBinary>', sVarAux);
    end;

    sVarAux := StringReplace(sVarAux, '<NombreEntidad>',  EntidadActiva.Nombre, [rfReplaceAll]);
    sVarAux := StringReplace(sVarAux, '<IndiceCampo>',    IntToStr(i), [rfReplaceAll]);
    sVarAux := StringReplace(sVarAux, '<NombreCampo>',    EntidadActiva.Campos.Campo[i].Nombre, [rfReplaceAll]);
    sVarAux := StringReplace(sVarAux, '<TipoCampo>',      EntidadActiva.Campos.Campo[i].TipoVariable, [rfReplaceAll]);

    if  (EntidadActiva.TieneGenerador) and
        (EntidadActiva.Campos.Campo[i].EsClavePrimaria) then begin
      sVarAux := StringReplace(sVarAux, '<TieneGenerador>',   EntidadActiva.Nombre, [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '<bTieneGenerador>',  'True', [rfReplaceAll]);
    end
    else
    begin
      sVarAux := StringReplace(sVarAux, '<TieneGenerador>', '', [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '<bTieneGenerador>','False', [rfReplaceAll]);
    end;

    sVarAux := StringReplace(sVarAux, '<bAceptaNull>',      BoolToStr(EntidadActiva.Campos.Campo[i].AceptaNull, true), [rfReplaceAll]);
    sVarAux := StringReplace(sVarAux, '<bEsClavePrimaria>', BoolToStr(EntidadActiva.Campos.Campo[i].EsClavePrimaria,true), [rfReplaceAll]);
    sVarAux := StringReplace(sVarAux, '<bEsClaveForanea>',  BoolToStr(EntidadActiva.Campos.Campo[i].EsClaveForanea,true), [rfReplaceAll]);
    sVarAux := StringReplace(sVarAux, '<LongitudCampo>',    IntToStr(EntidadActiva.Campos.Campo[i].Longitud), [rfReplaceAll]);
    sVarAux := StringReplace(sVarAux, '<tdTipoCampo>',      EntidadActiva.Campos.Campo[i].TipoORM, [rfReplaceAll]);

    if (EntidadActiva.Campos.Campo[i].TipoORM = 'tdString') then
      sVarAux := StringReplace(sVarAux, '<TipoORM>', QuotedStr(''), [rfReplaceAll])
   else if EntidadActiva.Campos.Campo[i].TipoORM = 'tdInteger' then
      sVarAux := StringReplace(sVarAux, '<TipoORM>','0', [rfReplaceAll])
   else if  (EntidadActiva.Campos.Campo[i].TipoORM = 'tdDateTime') or
            (EntidadActiva.Campos.Campo[i].TipoORM = 'tdDate') or
            (EntidadActiva.Campos.Campo[i].TipoORM = 'tdTime') or
            (EntidadActiva.Campos.Campo[i].TipoORM = 'tdTimeStamp') then
      sVarAux := StringReplace(sVarAux, '<TipoORM>','now', [rfReplaceAll])
   else
      sVarAux := StringReplace(sVarAux, '<TipoORM>',QuotedStr(''), [rfReplaceAll]);

   sVarAux := StringReplace(sVarAux, '<AsKeyWord>', EntidadActiva.Campos.Campo[i].AsKeyWord, [rfReplaceAll]);

    if  i <(EntidadActiva.Campos.Count - 1) then begin
      sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',  ',', [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', ';', [rfReplaceAll]);
    end
    else
    begin
      sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',  '', [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', '', [rfReplaceAll]);
    end;
    Result := Result + sVarAux;
  end;
end;

function TGeneradorCodigo.ContextoCampoClave(EntidadActiva: TTabla;
  sVariableContexto: string): string;
var
  i,j, Contador : integer;
  sVarAux : string;
begin
  Contador:=0;
  for i := 0 to EntidadActiva.Campos.Count - 1 do
    if EntidadActiva.Campos.Campo[i].EsClavePrimaria then
      Inc(Contador);

  Result := '';
  j:=0;

  for i := 0 to EntidadActiva.Campos.Count - 1 do
  begin
    if EntidadActiva.Campos.Campo[i].EsClavePrimaria then
    begin
     Inc(j);
     sVarAux := sVariableContexto;
     sVarAux := StringReplace(sVarAux, '<NombreEntidad>',     EntidadActiva.Nombre, [rfReplaceAll]);
     sVarAux := StringReplace(sVarAux, '<IndiceCampoClave>',  IntToStr(i), [rfReplaceAll]);
     sVarAux := StringReplace(sVarAux, '<NombreCampoClave>',  EntidadActiva.Campos.Campo[i].Nombre, [rfReplaceAll]);
     sVarAux := StringReplace(sVarAux, '<TipoCampoClave>',    EntidadActiva.Campos.Campo[i].TipoVariable, [rfReplaceAll]);

     if j < Contador then begin
       sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',  ',', [rfReplaceAll]);
       sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', ';', [rfReplaceAll]);
     end
     else
     begin
       sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',  '', [rfReplaceAll]);
       sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', '', [rfReplaceAll])
     end;

     Result := Result + sVarAux;
    end;
  end;
end;

function TGeneradorCodigo.ContextoCampoFK(CamposFK: TCamposFK;
  sVariableContexto: string): string;
var
  i : integer;
  sVarAux : string;
begin
  Result := '';
  for i := 0 to CamposFK.CamposOrigen.Count - 1 do
  begin
   sVarAux := sVariableContexto;
   sVarAux := StringReplace(sVarAux, '<IndiceCampoFKOrigen>',   IntToStr(i) , [rfReplaceAll]);
   sVarAux := StringReplace(sVarAux, '<NombreCampoFKOrigen>',   CamposFK.CamposOrigen.Campo[i].Nombre , [rfReplaceAll]);
   sVarAux := StringReplace(sVarAux, '<IndiceCampoFKDestino>',  IntToStr(i) , [rfReplaceAll]);
   sVarAux := StringReplace(sVarAux, '<NombreCampoFKDestino>',  CamposFK.CamposDestino.Campo[i].Nombre , [rfReplaceAll]);

   if i<(CamposFK.CamposOrigen.Count - 1) then begin
     sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',   ',', [rfReplaceAll]);
     sVarAux := StringReplace(sVarAux, '</PComaParaEnum>',  ';', [rfReplaceAll]);
   end
   else
   begin
     sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',   '', [rfReplaceAll]);
     sVarAux := StringReplace(sVarAux, '</PComaParaEnum>',  '', [rfReplaceAll]);
   end;
   Result := Result + sVarAux;
  end;
end;

function TGeneradorCodigo.ContextoCampoListas(ListaEntidad:TListaTabla; sVariableContexto: string): string;
var
  nCampo, nPosStart, nPosEnd: integer;
  sVarAux, sVarAuxIzq, sVarAuxDer, sVarAux2: string;
  EntidadActiva : TTabla;
  //unCampoInfo: TCampo;
  nTablas: integer;
  nIndice : integer;
begin
  Result  := '';
  nIndice := 0;

  for nTablas := 0 to ListaEntidad.Componentes.Count - 1 do
  begin
    EntidadActiva := ListaEntidad.Componentes.Tabla[nTablas];

    for nCampo := 0 to EntidadActiva.Campos.Count - 1 do
    begin
      sVarAux := sVariableContexto;

      nPosStart := Pos('<IfBlobBinary>', sVarAux);
      while (nPosStart > 0) do
      begin
       nPosEnd      := Pos('</IfBlobBinary>', sVarAux);
       sVarAuxIzq   := LeftStr(sVarAux, nPosStart - 1);
       sVarAuxDer   := MidStr(sVarAux, nPosEnd + 15, length(sVarAux));
       sVarAux2     := MidStr(sVarAux, nPosStart + 14, nPosEnd - (nPosStart + 14));
       sVarAux      := sVarAuxIzq + ContextoBlobBinary(EntidadActiva.Campos.Campo[nCampo], sVarAux2);
       sVarAux      := sVarAux + sVarAuxDer;
       nPosStart    := Pos('<IfBlobBinary>', sVarAux);
      end;

      sVarAux := StringReplace(sVarAux,   '<IndiceCampo>',    IntToStr( nCampo + nIndice), [rfReplaceAll]);
      if (trim(EntidadActiva.Alias) = '') then
      begin
        sVarAux := StringReplace(sVarAux, '<NombreEntidad>',  EntidadActiva.Nombre, [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '<AliasEntidad>',   EntidadActiva.Nombre, [rfReplaceAll]);
      end
      else begin
        sVarAux := StringReplace(sVarAux, '<NombreEntidad>',  EntidadActiva.Nombre, [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '<AliasEntidad>',   EntidadActiva.Alias,  [rfReplaceAll]);
      end;

      with EntidadActiva.Campos do
      begin
        if (trim(Campo[nCampo].Alias) = '') then
        begin
          sVarAux := StringReplace(sVarAux, '<AliasCampo>', Campo[nCampo].Nombre, [rfReplaceAll]);
          sVarAux := StringReplace(sVarAux, '<NombreCampo>',Campo[nCampo].Nombre, [rfReplaceAll]);
        end
        else begin
          sVarAux := StringReplace(sVarAux, '<AliasCampo>', Campo[nCampo].Alias, [rfReplaceAll]);
          sVarAux := StringReplace(sVarAux, '<NombreCampo>',Campo[nCampo].Nombre, [rfReplaceAll]);
        end;

        //unCampoInfo := Tablas.ObtenerTabla(EntidadActiva.Nombre).Campos.ObtenerCampo(Campo[nCampo].Nombre);
        sVarAux := StringReplace(sVarAux, '<TipoCampo>',    Campo[nCampo].TipoVariable, [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '<AsKeyWord>',    Campo[nCampo].AsKeyWord, [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '<LongitudCampo>',IntToStr(Campo[nCampo].Longitud), [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '<tdTipoCampo>',  Campo[nCampo].TipoORM, [rfReplaceAll]);

        {
        sVarAux := StringReplace(sVarAux, '<TipoCampo>',    unCampoInfo.TipoVariable, [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '<AsKeyWord>',    unCampoInfo.AsKeyWord, [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '<LongitudCampo>',IntToStr(unCampoInfo.Longitud), [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '<tdTipoCampo>',  unCampoInfo.TipoORM, [rfReplaceAll]);
        }

      end;

      if nCampo<(EntidadActiva.Campos.Count - 1) then begin
        sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',  ',', [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', ';', [rfReplaceAll]);
      end
      else
      begin
        sVarAux := StringReplace(sVarAux, '</ComaParaEnum>', '', [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', '', [rfReplaceAll]);
      end;
      Result := Result + sVarAux;
    end;
    Inc(nIndice, EntidadActiva.Campos.Count);
  end;
end;

function TGeneradorCodigo.ContextoColeccion(sVariableContexto: string): string;
var
 i: integer;
 sVarAux, sVarAux2, sVarAuxIzq, sVarAuxDer : string;
 nPosStart, nPosEnd : integer;
begin
  Result := '';
  for i := 0 to Tablas.Count - 1 do
  begin
    sVarAux := sVariableContexto;

    nPosStart := Pos('<PorCadaCampo>', sVarAux);
    while (nPosStart > 0) do
    begin
      nPosEnd     := Pos('</PorCadaCampo>', sVarAux);
      sVarAuxIzq  := LeftStr(sVarAux,nPosStart - 1);
      sVarAuxDer  := MidStr(sVarAux,nPosEnd + 15, length(sVarAux));
      sVarAux2    := MidStr(sVarAux, nPosStart + 14, nPosEnd - (nPosStart + 14));
      sVarAux     := sVarAuxIzq + ContextoCampo(Tablas.Tabla[i],sVarAux2);
      sVarAux     := sVarAux + sVarAuxDer;
      nPosStart   := Pos('<PorCadaCampo>', sVarAux);
    end;

    sVarAux       := ContextoBlobType(Tablas.Tabla[i],sVarAux);
    sVarAux       := StringReplace(sVarAux, '<IndiceEntidad>', IntToStr(i), [rfReplaceAll]);
    sVarAux       := StringReplace(sVarAux, '<NombreEntidad>', Tablas.Tabla[i].Nombre, [rfReplaceAll]);
    if i<(Tablas.Count - 1) then begin
      sVarAux     := StringReplace(sVarAux, '</ComaParaEnum>',  ',', [rfReplaceAll]);
      sVarAux     := StringReplace(sVarAux, '</PComaParaEnum>', ';', [rfReplaceAll]);
    end
    else
    begin
      sVarAux     := StringReplace(sVarAux, '</ComaParaEnum>',  '', [rfReplaceAll]);
      sVarAux     := StringReplace(sVarAux, '</PComaParaEnum>', '', [rfReplaceAll]);
    end;
    sVarAux       := LimpiarLineasBlancos(sVarAux);
    Result := Result + sVarAux;
  end;
end;

function TGeneradorCodigo.ContextoColeccionEntidadAsociada(
  EntidadActiva: TTabla; sVariableContexto: string): string;
var
 i: integer;
 sVarAux, sVarAuxIzq, sVarAuxDer, sVarAux2 : string;
 nPosStart, nPosEnd : integer;
begin
  Result := '';
  with EntidadActiva.CamposColeccion do
  begin
    for i := 0 to Count - 1 do
    begin
      sVarAux := sVariableContexto;

      nPosStart := Pos('<PorCadaCampoFK>', sVarAux);
      while (nPosStart > 0) do begin
       nPosEnd    := Pos('</PorCadaCampoFK>', sVarAux);
       sVarAuxIzq := LeftStr(sVarAux, nPosStart - 1);
       sVarAuxDer := MidStr(sVarAux,  nPosEnd + 17,   length(sVarAux));
       sVarAux2   := MidStr(sVarAux,  nPosStart + 16, nPosEnd - (nPosStart + 16));
       sVarAux    := sVarAuxIzq + ContextoCampoFK(CamposFK[i], sVarAux2);
       sVarAux    := sVarAux + sVarAuxDer;
       nPosStart  := Pos('<PorCadaCampoFK>', sVarAux);
      end;

      sVarAux := StringReplace(sVarAux, '<IndiceEntidadAsociada>', IntToStr(i), [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '<NombreEntidadAsociada>', CamposFK[i].TablaDestino, [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '<NombreRelacionAMuchos>', CamposFK[i].NomRelacionAMuchos, [rfReplaceAll]);

      if i < (Count - 1) then begin
        sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',  ',', [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', ';', [rfReplaceAll]);
      end
      else
      begin
        sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',  '', [rfReplaceAll]);
        sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', '', [rfReplaceAll]);
      end;

      Result := Result + sVarAux;
    end;
  end;
end;

function TGeneradorCodigo.ContextoEntidad(sVariableContexto: string): string;
var
 nTabla : integer;
 sVarAux, sVarAux2, sVarAuxIzq, sVarAuxDer : string;
 nPosStart, nPosEnd : integer;
begin
  Result := '';
  for nTabla := 0 to Tablas.Count - 1 do
  begin
    sVarAux   := sVariableContexto;
    nPosStart := Pos('<IfTieneRelacion>', sVarAux);

    while nPosStart > 0 do begin
      if Tablas.Tabla[nTabla].CamposFK.Count > 0 then
      begin
        nPosEnd     := Pos('</IfTieneRelacion>', sVarAux);
        sVarAuxIzq  := LeftStr(sVarAux, nPosStart - 1);
        sVarAuxDer  := MidStr(sVarAux,  nPosEnd + 18, length(sVarAux));
        sVarAux2    := MidStr(sVarAux,  nPosStart + 17, nPosEnd - (nPosStart + 17));
        sVarAux     := sVarAuxIzq + sVarAux2;//saco los If y mando para que se procese lo del medio normalmente
        sVarAux     := sVarAux + sVarAuxDer;
        nPosStart   := Pos('<IfTieneRelacion>', sVarAux);
      end
      else
      begin
        nPosEnd     := Pos('</IfTieneRelacion>', sVarAux);
        sVarAuxIzq  := LeftStr(sVarAux, nPosStart - 1);
        sVarAuxDer  := MidStr(sVarAux, nPosEnd + 18, length(sVarAux));
        sVarAux     := sVarAuxIzq + sVarAuxDer;
        nPosStart   := Pos('<IfTieneRelacion>', sVarAux);
      end;
    end;

    nPosStart := Pos('<PorCadaEntidadAsociada>', sVarAux);
    while nPosStart > 0 do
    begin
      nPosEnd     := Pos('</PorCadaEntidadAsociada>', sVarAux);
      sVarAuxIzq  := LeftStr(sVarAux, nPosStart - 1);
      sVarAuxDer  := MidStr(sVarAux,nPosEnd + 25, length(sVarAux));
      sVarAux2    := MidStr(sVarAux, nPosStart + 24, nPosEnd - (nPosStart + 24));
      sVarAux     := sVarAuxIzq + ContextoEntidadAsociada(Tablas.Tabla[nTabla], sVarAux2);
      sVarAux     := sVarAux + sVarAuxDer;
      nPosStart   := Pos('<PorCadaEntidadAsociada>', sVarAux);
    end;

    nPosStart := Pos('<IfTieneRelacionAMuchos>', sVarAux);
    while nPosStart > 0 do begin
      if Tablas.Tabla[nTabla].CamposColeccion.Count > 0 then begin
        nPosEnd     := Pos('</IfTieneRelacionAMuchos>', sVarAux);
        sVarAuxIzq  := LeftStr(sVarAux, nPosStart - 1);
        sVarAuxDer  := MidStr(sVarAux,  nPosEnd + 25, length(sVarAux));
        sVarAux2    := MidStr(sVarAux,  nPosStart + 24, nPosEnd - (nPosStart + 24));
        sVarAux     := sVarAuxIzq + sVarAux2;//saco los If y mando para que se procese lo del medio normalmente
        sVarAux     := sVarAux + sVarAuxDer;
        nPosStart   := Pos('<IfTieneRelacionAMuchos>', sVarAux);
      end
      else
      begin
        nPosEnd     := Pos('</IfTieneRelacionAMuchos>', sVarAux);
        sVarAuxIzq  := LeftStr(sVarAux, nPosStart - 1);
        sVarAuxDer  := MidStr(sVarAux,  nPosEnd + 25, length(sVarAux));
        sVarAux     := sVarAuxIzq + sVarAuxDer;
        nPosStart   := Pos('<IfTieneRelacionAMuchos>', sVarAux);
      end;
    end;

    nPosStart := Pos('<PorCadaColeccionAsociada>', sVarAux);
    while (nPosStart > 0) do
    begin
      nPosEnd     := Pos('</PorCadaColeccionAsociada>', sVarAux);
      sVarAuxIzq  := LeftStr(sVarAux,nPosStart-1);
      sVarAuxDer  := MidStr(sVarAux,nPosEnd + 27, length(sVarAux));
      sVarAux2    := MidStr(sVarAux, nPosStart + 26, nPosEnd - (nPosStart + 26));
      sVarAux     := sVarAuxIzq + ContextoColeccionEntidadAsociada(Tablas.Tabla[nTabla], sVarAux2);
      sVarAux     := sVarAux + sVarAuxDer;
      nPosStart   := Pos('<PorCadaColeccionAsociada>', sVarAux);
    end;

    nPosStart := Pos('<PorCadaCampo>', sVarAux);
    while (nPosStart > 0) do
    begin
      nPosEnd     := Pos('</PorCadaCampo>', sVarAux);
      sVarAuxIzq  := LeftStr(sVarAux,nPosStart - 1);
      sVarAuxDer  := MidStr(sVarAux,nPosEnd + 15, length(sVarAux));
      sVarAux2    := MidStr(sVarAux, nPosStart + 14, nPosEnd - (nPosStart + 14));
      sVarAux     := sVarAuxIzq + ContextoCampo(Tablas.Tabla[nTabla],sVarAux2);
      sVarAux     := sVarAux + sVarAuxDer;
      nPosStart   := Pos('<PorCadaCampo>', sVarAux);
    end;

    nPosStart := Pos('<PorCadaCampoClave>', sVarAux);
    while (nPosStart > 0) do
    begin
      nPosEnd     := Pos('</PorCadaCampoClave>', sVarAux);
      sVarAuxIzq  := LeftStr(sVarAux,nPosStart - 1);
      sVarAuxDer  := MidStr(sVarAux,nPosEnd + 20, length(sVarAux));
      sVarAux2    := MidStr(sVarAux, nPosStart + 19, nPosEnd - (nPosStart + 19));
      sVarAux     := sVarAuxIzq + ContextoCampoClave(Tablas.Tabla[nTabla],  sVarAux2);
      sVarAux     := sVarAux + sVarAuxDer;
      nPosStart := Pos('<PorCadaCampoClave>', sVarAux);
    end;


    sVarAux := StringReplace(sVarAux, '<IndiceEntidad>', IntToStr(nTabla), [rfReplaceAll]);
    sVarAux := StringReplace(sVarAux, '<NombreEntidad>', Tablas.Tabla[nTabla].Nombre, [rfReplaceAll]);
    if nTabla < (Tablas.Count - 1) then
    begin
      sVarAux := StringReplace(sVarAux, '</ComaParaEnum>', ',', [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '</PComaParaEnum>',';', [rfReplaceAll]);
    end
    else
    begin
      sVarAux := StringReplace(sVarAux, '</ComaParaEnum>', '', [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '</PComaParaEnum>','', [rfReplaceAll]);
    end;
    sVarAux :=  LimpiarLineasBlancos(sVarAux);
    Result  := Result + sVarAux;
  end;
end;

function TGeneradorCodigo.ContextoEntidadAsociada(EntidadActiva: TTabla;
  sVariableContexto: string): string;
var
 i: integer;
 sVarAux, sVarAuxIzq, sVarAuxDer, sVarAux2 : string;
 nPosStart, nPosEnd : integer;
begin
  Result := '';
  for i := 0 to EntidadActiva.CamposFK.Count - 1 do
  begin
    sVarAux := sVariableContexto;

    nPosStart   := Pos('<PorCadaCampo>', sVarAux);
    while (nPosStart > 0) do begin
     nPosEnd    := Pos('</PorCadaCampo>', sVarAux);
     sVarAuxIzq := LeftStr(sVarAux,nPosStart - 1);
     sVarAuxDer := MidStr(sVarAux,nPosEnd + 15, length(sVarAux));
     sVarAux2   := MidStr(sVarAux, nPosStart + 14, nPosEnd - (nPosStart + 14));
     sVarAux    := sVarAuxIzq + ContextoCampo(EntidadActiva, sVarAux2);
     sVarAux    := sVarAux + sVarAuxDer;
     nPosStart  := Pos('<PorCadaCampo>', sVarAux);
    end;

    nPosStart   := Pos('<PorCadaCampoFK>', sVarAux);
    while (nPosStart > 0) do begin
     nPosEnd    := Pos('</PorCadaCampoFK>', sVarAux);
     sVarAuxIzq := LeftStr(sVarAux,nPosStart - 1);
     sVarAuxDer := MidStr(sVarAux,nPosEnd + 17, length(sVarAux));
     sVarAux2   := MidStr(sVarAux, nPosStart + 16, nPosEnd - (nPosStart + 16));
     sVarAux    := sVarAuxIzq + ContextoCampoFK(EntidadActiva.CamposFK.CamposFK[i], sVarAux2);
     sVarAux    := sVarAux + sVarAuxDer;
     nPosStart  := Pos('<PorCadaCampoFK>', sVarAux);
    end;

    sVarAux     := StringReplace(sVarAux, '<IndiceEntidadAsociada>', IntToStr(i), [rfReplaceAll]);
    sVarAux     := StringReplace(sVarAux, '<NombreEntidadAsociada>', EntidadActiva.CamposFK.CamposFK[i].TablaDestino, [rfReplaceAll]);
    sVarAux     := StringReplace(sVarAux, '<NombreRelacion>',        EntidadActiva.CamposFK.CamposFK[i].NomRelacion,  [rfReplaceAll]);

    if i < (EntidadActiva.CamposFK.Count - 1) then
    begin
      sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',  ',', [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', ';', [rfReplaceAll]);
    end
    else
    begin
      sVarAux := StringReplace(sVarAux, '</ComaParaEnum>',  '', [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', '', [rfReplaceAll]);
    end;

    Result := Result + sVarAux;
  end;
end;

function TGeneradorCodigo.ContextoEntidadListas(sVariableContexto: string;
                                                ListaEntidad:TListaTabla): string;
var
 sVarAux, sVarAux2, sVarAuxIzq, sVarAuxDer : string;
 nPosStart, nPosEnd : integer;
begin
  Result    := '';
  sVarAux   := sVariableContexto;
  nPosStart := Pos('<PorCadaCampo>', sVarAux);

  while (nPosStart > 0) do
  begin
    nPosEnd     := Pos('</PorCadaCampo>', sVarAux);
    sVarAuxIzq  := LeftStr(sVarAux,nPosStart - 1);
    sVarAuxDer  := MidStr(sVarAux,nPosEnd + 15, length(sVarAux));
    sVarAux2    := MidStr(sVarAux, nPosStart + 14, nPosEnd - (nPosStart + 14));
    sVarAux     := sVarAuxIzq + ContextoCampoListas(ListaEntidad, sVarAux2);
    sVarAux     := sVarAux + sVarAuxDer;
    nPosStart   := Pos('<PorCadaCampo>', sVarAux);
  end;

  sVarAux := StringReplace(sVarAux, '<TotalEntidades>', IntToStr(ListaEntidad.Componentes.Count), [rfReplaceAll]);

  nPosStart := Pos('<PorCadaRelacion>', sVarAux);
  while (nPosStart > 0) do
  begin
    nPosEnd     := Pos('</PorCadaRelacion>', sVarAux);
    sVarAuxIzq  := LeftStr(sVarAux,nPosStart - 1);
    sVarAuxDer  := MidStr(sVarAux,nPosEnd + 18, length(sVarAux));
    sVarAux2    := MidStr(sVarAux, nPosStart + 17, nPosEnd - (nPosStart + 17));
    sVarAux     := sVarAuxIzq + ContextoRelacionListas(ListaEntidad, sVarAux2);
    sVarAux     := sVarAux + sVarAuxDer;
    nPosStart   := Pos('<PorCadaRelacion>', sVarAux);
  end;
  Result := Result + sVarAux;
end;

function TGeneradorCodigo.ContextoLista(sVariableContexto: string): string;
Var
  nPosStart, nPosEnd, i: Integer;
  sVarAux, sVarAux2, sVarAuxIzq, sVarAuxDer : string;
begin
  Result := '';
  for i := 0 to Listas.Count - 1 do
  begin
    sVarAux := sVariableContexto;
    nPosStart := Pos('<PorCadaListaEntidad>', sVarAux);
    while (nPosStart > 0) do
    begin
      nPosEnd     := Pos('</PorCadaListaEntidad>', sVarAux);
      sVarAuxIzq  := LeftStr(sVarAux,nPosStart - 1);
      sVarAuxDer  := MidStr(sVarAux, nPosEnd + 22, length(sVarAux));
      sVarAux2    := MidStr(sVarAux, nPosStart + 21, nPosEnd - (nPosStart + 21));

      sVarAux     := sVarAuxIzq + ContextoEntidadListas(sVarAux2,Listas.ListaTabla[i]);
      sVarAux     := sVarAux + sVarAuxDer;
      nPosStart   := Pos('<PorCadaListaEntidad>', sVarAux);
    end;

    sVarAux:= ContextoBlobTypeLista(Listas.ListaTabla[i], sVarAux);
    sVarAux := StringReplace(sVarAux, '<IndiceListaEntidad>', IntToStr(i), [rfReplaceAll]);
    sVarAux := StringReplace(sVarAux, '<NombreListaEntidad>', Listas.ListaTabla[i].NombreLista, [rfReplaceAll]);
    sVarAux := StringReplace(sVarAux, '<NombreListaEntidad>', Listas.ListaTabla[i].NombreLista, [rfReplaceAll]);

    if i<(Listas.Count - 1) then
    begin
      sVarAux := StringReplace(sVarAux, '</ComaParaEnum>', ',', [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', ';', [rfReplaceAll]);
    end
    else
    begin
      sVarAux := StringReplace(sVarAux, '</ComaParaEnum>', '', [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '</PComaParaEnum>', '', [rfReplaceAll]);
    end;
    sVarAux := LimpiarLineasBlancos(sVarAux);
    Result  := Result + sVarAux;
  end;
end;

function TGeneradorCodigo.ContextoRelacionListas(ListaEntidad: TListaTabla;
  sVariableContexto: string): string;
var
  sVarAux: string;
  nTablas, nRelacion, nAux: integer;
  sNombreEntidad: string;
  unaTabla : TTabla;
begin
  Result := '';
  if ListaEntidad.Componentes.Count > 1 then
  begin
    for nTablas := 1 to ListaEntidad.Componentes.Count - 1 do begin
      unaTabla := Tablas.ObtenerTabla(ListaEntidad.Componentes.Tabla[nTablas].Nombre);
      sNombreEntidad := '';
      for nRelacion := 0 to unaTabla.CamposFK.Count - 1 do
      begin
        for nAux := 0 to nTablas do
        begin
          if unaTabla.CamposFK.CamposFK[nRelacion].TablaDestino = ListaEntidad.Componentes.Tabla[nAux].Nombre then
          begin
            sNombreEntidad := ListaEntidad.Componentes.Tabla[nAux].Nombre;
            break;
          end;
        end;
        if sNombreEntidad <> '' then
          break;
      end;

      if sNombreEntidad = '' then
      begin
        for nRelacion := 0 to unaTabla.CamposColeccion.Count - 1 do
        begin
          for nAux := 0 to nTablas do
          begin
            if unaTabla.CamposColeccion.CamposFK[nRelacion].TablaDestino = ListaEntidad.Componentes.Tabla[nAux].Nombre then
            begin
              sNombreEntidad := ListaEntidad.Componentes.Tabla[nAux].Nombre;
              break;
            end;
          end;
          if sNombreEntidad <> '' then
            break;
        end;
      end;

      sVarAux := sVariableContexto;
      sVarAux := StringReplace(sVarAux, '<NombreEntidad>',
                              sNombreEntidad, [rfReplaceAll]);
      sVarAux := StringReplace(sVarAux, '<NombreEntidadRelacionada>',
                              ListaEntidad.Componentes.Tabla[nTablas].Nombre, [rfReplaceAll]);

      Result := Result + sVarAux;
    end;
  end;
end;

function TGeneradorCodigo.GenerarCodigo(sTextoTemplate: string): string;
var
  nPosStart, nPosEnd:Integer;
  sVarAux, sVarAux2, sVarAuxIzq, sVarAuxDer : string;
begin
  Result  := '';
  sVarAux := sTextoTemplate;
  nPosStart := Pos('<PorCadaLista>', sVarAux);
  while (nPosStart > 0) do
  begin
    nPosEnd     := Pos('</PorCadaLista>', sVarAux);
    sVarAuxIzq  := LeftStr(sVarAux, nPosStart - 1);
    sVarAuxDer  := MidStr(sVarAux,nPosEnd + 15, length(sVarAux));
    sVarAux2    := MidStr(sVarAux, nPosStart + 14, nPosEnd - (nPosStart + 14));
    sVarAux     := sVarAuxIzq + ContextoLista(sVarAux2);
    sVarAux     := sVarAux + sVarAuxDer;
    nPosStart   := Pos('<PorCadaLista>', sVarAux);
  end;

  nPosStart := Pos('<PorCadaEntidad>', sVarAux);
  while (nPosStart > 0) do
  begin
    nPosEnd     := Pos('</PorCadaEntidad>', sVarAux);
    sVarAuxIzq  := LeftStr(sVarAux,nPosStart-1);
    sVarAuxDer  := MidStr(sVarAux,nPosEnd + 17, length(sVarAux));
    sVarAux2    := MidStr(sVarAux, nPosStart + 16, nPosEnd - (nPosStart + 16));
    sVarAux     := sVarAuxIzq + ContextoEntidad(sVarAux2);
    sVarAux     := sVarAux + sVarAuxDer;
    nPosStart   := Pos('<PorCadaEntidad>', sVarAux);
  end;

  nPosStart := Pos('<PorCadaColeccion>', sVarAux);
  while (nPosStart > 0) do
  begin
    nPosEnd     := Pos('</PorCadaColeccion>', sVarAux);
    sVarAuxIzq  := LeftStr(sVarAux,nPosStart-1);
    sVarAuxDer  := MidStr(sVarAux,nPosEnd + 19, length(sVarAux));
    sVarAux2    := MidStr(sVarAux, nPosStart + 18, nPosEnd - (nPosStart + 18));
    sVarAux     := sVarAuxIzq + ContextoColeccion(sVarAux2);
    sVarAux     := sVarAux + sVarAuxDer;
    nPosStart   := Pos('<PorCadaColeccion>', sVarAux);
  end;
  Result:=sVarAux;
end;

function TGeneradorCodigo.LimpiarLineasBlancos(sTexto: string): string;
var
  sl, slAux : TStringList;
  nLinea    : Integer;
begin
  Result:='';
  sl      :=  TStringList.Create;
  slAux   :=  TStringList.Create;

  sl.Text :=  sTexto;
  for nLinea := 0 to sl.Count - 1 do
  begin
    if Trim(sl.Strings[nLinea]) <> '' then
      slAux.Add(sl.Strings[nLinea]);
  end;

  Result  :=  slAux.Text;
  sl.Free;
  slAux.Free;
end;

end.

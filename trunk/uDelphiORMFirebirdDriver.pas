{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uDelphiORMFirebirdDriver.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uDelphiORMFirebirdDriver;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, WideStrings, DB, SqlExpr, uDelphiORMBaseDriver, uCoreClasses;

type
  TORMDriverManager = class(TForm, IORMDriverManager)
    lblServer: TLabel;
    edtServer: TEdit;
    lblUsuario: TLabel;
    edtUsuario: TEdit;
    lblPassword: TLabel;
    edtPassword: TEdit;
    lblBD: TLabel;
    edtBD: TEdit;
    sqlConn: TSQLConnection;
  private
    { Private declarations }
    function ObtenerSQLInfoTablas: string;
    function ObtenerSQLInfoRelaciones: string;
  public
    { Public declarations }
    function GetModule: THandle;
    function GetConnectionParameters: string;
    procedure SetConnectionParameters(const sConnectionString: string);
    function ValidateParameters: Boolean;
    function Connect: Boolean;
    function Disconnect: Boolean;
    function GetTablesInfo: TColeccionTabla;
    function GetGeneratorsInfo: TColeccionGenerador;
  end;

  TDatosTabla=class
  const
    Tabla = 0;
    Campo = 1;
    PermiteNulo = 2;
    Longitud = 3;
    Escala = 4;
    TipoDato = 5;
    SubTipoDato = 6;
    LongitudChar = 7;
    PrecisionNumerica = 8;
    ValorDefault = 9;
    EsClavePrimaria = 10;
  end;

  TDatosRelacion=class
  const
    NombreRelacion=0;
    TablaOrigen=1;
    CampoOrigen=2;
    TablaRelacionada=3;
    CampoRelacionado=4;
  end;

var
  ORMDriverManager: TORMDriverManager;

implementation

uses StrUtils;

{$R *.dfm}

function GetDelphiORMDriverName(): PChar;
begin
  Result := PChar('Firebird - Delphi ORM Driver');
end;

procedure ConvertirTipo(unCampo: TCampo; const sVariable: string; const sSubVar: string);
var
  sTipo, sSubTipo: string;
begin
  sTipo             := Trim(sVariable);
  sSubTipo          := Trim(sSubVar);
  unCampo.TipoBD    := sTipo;
  unCampo.SubTipoBD := sSubTipo;

  if ((sTipo = 'VARYING') or (sTipo = 'TEXT')) then begin
    unCampo.TipoVariable := 'string';
    unCampo.TipoORM := 'tdString';
    unCampo.AsKeyWord := 'AsString';
  end
  else if ((sTipo = 'SHORT') or (sTipo = 'LONG') or (sTipo = 'INT64')) then begin
    unCampo.TipoVariable := 'integer';
    unCampo.TipoORM := 'tdInteger';
    unCampo.AsKeyWord := 'AsInteger';
  end
  else if sTipo = 'DATE' then begin
    unCampo.TipoVariable := 'TDateTime';
    unCampo.TipoORM := 'tdDate';
    unCampo.AsKeyWord := 'AsDateTime';
  end
  else if ((sTipo = 'FLOAT') or (sTipo = 'DOUBLE')) then begin
    unCampo.TipoVariable := 'double';
    unCampo.TipoORM := 'tdfloat';
    unCampo.AsKeyWord := 'AsFloat';
  end
  else if (sTipo = 'TIMESTAMP') then begin
    unCampo.TipoVariable := 'TDateTime';
    unCampo.TipoORM := 'tdTimeStamp';
    unCampo.AsKeyWord := 'AsDateTime';
  end
  else if (sTipo = 'DATE') then begin
    unCampo.TipoVariable := 'TDateTime';
    unCampo.TipoORM := 'tdDate';
    unCampo.AsKeyWord := 'AsDateTime';
  end
  else if (sTipo = 'TIME') then begin
    unCampo.TipoVariable := 'TDateTime';
    unCampo.TipoORM := 'tdTime';
    unCampo.AsKeyWord := 'AsDateTime';
  end
  else if (sTipo = 'BLOB') then begin
    if sSubTipo = '1' then begin
      //Texto
      unCampo.TipoVariable := 'string';
      unCampo.TipoORM := 'tdBlobText';
      unCampo.AsKeyWord := 'AsString';
    end
    else begin
      //Binario
      unCampo.TipoVariable := 'TMemoryStream';
      unCampo.TipoORM := 'tdBlobBinary';
      unCampo.AsKeyWord := 'AsStream';
    end;
  end;
end;


{ TORMDriverManager }

function TORMDriverManager.Connect: Boolean;
begin
  sqlConn.Params.Values['Database'] := edtServer.Text + ':' + edtBD.Text;
  sqlConn.Params.Values['User_Name'] := edtUsuario.Text;
  sqlConn.Params.Values['Password'] := edtPassword.Text;
  sqlConn.Open;

  Result := sqlConn.Connected;
end;

function TORMDriverManager.Disconnect: Boolean;
begin
  sqlConn.Close;
  Result := not sqlConn.Connected;
end;

function TORMDriverManager.GetConnectionParameters: string;
begin
  Result := 'Server=' + edtServer.Text;
  Result := Result + '; DataBase=' + edtBD.Text;
  Result := Result + '; UserName=' + edtUsuario.Text;
  Result := Result + '; Password=' + edtPassword.Text;
end;

function TORMDriverManager.GetGeneratorsInfo: TColeccionGenerador;
var
  unDataSet: TDataSet;
  sSQL: string;
begin
  Result := TColeccionGenerador.Create;

  unDataSet := TSQLDataSet.Create(nil);
  sSQL := 'SELECT RDB$GENERATOR_NAME FROM RDB$GENERATORS WHERE RDB$SYSTEM_FLAG IS NULL or RDB$SYSTEM_FLAG = 0 order by 1';
  sqlConn.Execute(sSQL, nil, @unDataSet);

  while not unDataSet.Eof do
  begin
    with TGenerador.Create(Result) do
      Nombre := Trim(unDataSet.Fields[0].AsString);
    unDataSet.Next;
  end;
  FreeAndNil(unDataSet);
end;

function TORMDriverManager.GetModule: THandle;
begin
  Result := Windows.GetModuleHandle ('DelphiORMFirebirdDriver.bpl');
end;

function TORMDriverManager.GetTablesInfo: TColeccionTabla;
var
  unDataSet: TDataSet;
  sSQL: string;
  unaTabla: TTabla;
  unaTablaRelacionada: TTabla;
  Generadores: TColeccionGenerador;

  unCampo: TCampo;
  unCampoFK: TCamposFK;
  unCampoFKRel: TCamposFK;

  sTablaAnterior: string;
  sRelacionAnterior: string;
begin
  Result := TColeccionTabla.Create;
  Generadores := GetGeneratorsInfo;

  unDataSet := TSQLDataSet.Create(nil);
  sSQL := ObtenerSQLInfoTablas;

  sqlConn.Execute(sSQL, nil, @unDataSet);
  sTablaAnterior := '';
  while not unDataSet.Eof do
  begin
    if sTablaAnterior <> unDataSet.Fields[TDatosTabla.Tabla].AsString then
    begin
      unaTabla := TTabla.Create(Result);
      unaTabla.Inicializar;
      sTablaAnterior := unDataSet.Fields[TDatosTabla.Tabla].AsString;
      unaTabla.Nombre := Trim(sTablaAnterior);
      unaTabla.TieneGenerador := Generadores.ExisteGenerador(unaTabla.Nombre);
      unaTabla.NombreGenerador := unaTabla.Nombre;
    end;

    unCampo := TCampo.Create(unaTabla.Campos);
    unCampo.Nombre := Trim(unDataSet.Fields[TDatosTabla.Campo].AsString);
    unCampo.Longitud := unDataSet.Fields[TDatosTabla.LongitudChar].AsInteger;
    ConvertirTipo(unCampo,  unDataSet.Fields[TDatosTabla.TipoDato].AsString,
                            unDataSet.Fields[TDatosTabla.SubTipoDato].AsString);
    unCampo.AceptaNull := not (unDataSet.Fields[TDatosTabla.PermiteNulo].AsInteger = 1);
    unCampo.EsClavePrimaria := (unDataSet.Fields[TDatosTabla.EsClavePrimaria].AsInteger = 1);
    unCampo.ValorDefault := unDataSet.Fields[TDatosTabla.ValorDefault].AsVariant;

    unDataSet.Next;
  end;
  FreeAndNil(unDataSet);

  unDataSet := TSQLDataSet.Create(nil);
  sSQL := ObtenerSQLInfoRelaciones;

  sqlConn.Execute(sSQL, nil, @unDataSet);
  sRelacionAnterior := '';
  while not unDataSet.Eof do
  begin
    unaTabla := Result.ObtenerTabla(Trim(unDataSet.Fields[TDatosRelacion.TablaOrigen].AsString));
    unaTablaRelacionada := Result.ObtenerTabla(Trim(unDataSet.Fields[TDatosRelacion.TablaRelacionada].AsString));

    unCampoFK     := TCamposFK.Create(unaTabla.CamposFK);
    unCampoFKRel  := TCamposFK.Create(unaTablaRelacionada.CamposColeccion);

    unCampoFK.Inicializar;
    unCampoFKRel.Inicializar;

    unCampoFK.TablaOrigen           := Trim(unDataSet.Fields[TDatosRelacion.TablaOrigen].AsString);
    unCampoFK.TablaDestino          := Trim(unDataSet.Fields[TDatosRelacion.TablaRelacionada].AsString);

    unCampoFKRel.TablaOrigen        := unCampoFK.TablaDestino;
    unCampoFKRel.TablaDestino       := unCampoFK.TablaOrigen;

    unCampoFK.NomRelacion           := CrearNombreRelacion1a1(unaTabla, unDataSet.Fields[TDatosRelacion.TablaRelacionada].AsString);
    unCampoFKRel.NomRelacionAMuchos := CrearNombreRelacion1aMuchos(unaTablaRelacionada, unDataSet.Fields[TDatosRelacion.TablaOrigen].AsString);
    //unCampoFK.NomRelacionAMuchos    := unCampoFKRel.NomRelacionAMuchos;
    //unCampoFKRel.NomRelacion        := unCampoFK.NomRelacion;

    sRelacionAnterior := unDataSet.Fields[TDatosRelacion.NombreRelacion].AsString;
    while ( (not unDataSet.Eof) and
            (sRelacionAnterior = unDataSet.Fields[TDatosRelacion.NombreRelacion].AsString))  do
    begin
      unCampoFK.AgregarCampos(Trim(unDataSet.Fields[TDatosRelacion.TablaOrigen].AsString),
                              Trim(unDataSet.Fields[TDatosRelacion.CampoOrigen].AsString),
                              Trim(unDataSet.Fields[TDatosRelacion.TablaRelacionada].AsString),
                              Trim(unDataSet.Fields[TDatosRelacion.CampoRelacionado].AsString));
      unCampo := unaTabla.Campos.ObtenerCampo(Trim(unDataSet.Fields[TDatosRelacion.CampoOrigen].AsString));
      unCampo.EsClaveForanea := true;

      unCampoFKRel.AgregarCampos( Trim(unDataSet.Fields[TDatosRelacion.TablaRelacionada].AsString),
                                  Trim(unDataSet.Fields[TDatosRelacion.CampoRelacionado].AsString),
                                  Trim(unDataSet.Fields[TDatosRelacion.TablaOrigen].AsString),
                                  Trim(unDataSet.Fields[TDatosRelacion.CampoOrigen].AsString));

      unDataSet.Next;
    end;
  end;
  FreeAndNil(unDataSet);
  FreeAndNil(Generadores);
end;

function TORMDriverManager.ObtenerSQLInfoRelaciones: string;
begin
  Result := ' SELECT'+
          '   RELC_FOR.RDB$CONSTRAINT_NAME,'+
          '   RELC_FOR.RDB$RELATION_NAME,'+
          '   IS_FOR.RDB$FIELD_NAME,'+
          '   RELC_PRIM.RDB$RELATION_NAME,'+
          '   IS_PRIM.RDB$FIELD_NAME'+
          ' FROM'+
          '   RDB$RELATION_CONSTRAINTS RELC_FOR, RDB$REF_CONSTRAINTS REFC_FOR,'+
          '   RDB$RELATION_CONSTRAINTS RELC_PRIM, RDB$REF_CONSTRAINTS REFC_PRIM,'+
          '   RDB$INDEX_SEGMENTS IS_PRIM,  RDB$INDEX_SEGMENTS IS_FOR'+
          ' WHERE'+
          '   RELC_FOR.RDB$CONSTRAINT_TYPE = ''FOREIGN KEY'' and'+
          '   RELC_FOR.RDB$CONSTRAINT_NAME = REFC_FOR.RDB$CONSTRAINT_NAME and'+
          '   REFC_FOR.RDB$CONST_NAME_UQ = RELC_PRIM.RDB$CONSTRAINT_NAME and'+
          '   RELC_PRIM.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'' and'+
          '   RELC_PRIM.RDB$INDEX_NAME = IS_PRIM.RDB$INDEX_NAME and'+
          '   IS_FOR.RDB$INDEX_NAME = RELC_FOR.RDB$INDEX_NAME   and'+
          '   IS_PRIM.RDB$FIELD_POSITION = IS_FOR.RDB$FIELD_POSITION  and'+
          '   REFC_PRIM.RDB$CONSTRAINT_NAME = RELC_FOR.RDB$CONSTRAINT_NAME'+
          ' ORDER BY'+
          '   RELC_FOR.RDB$CONSTRAINT_NAME, RELC_PRIM.RDB$RELATION_NAME, IS_FOR.RDB$FIELD_POSITION';
end;

function TORMDriverManager.ObtenerSQLInfoTablas: string;
begin
  Result :=  'SELECT  a.RDB$RELATION_NAME,'+
          ' a.RDB$FIELD_NAME,'+
          ' a.RDB$NULL_FLAG,'+
          ' b. RDB$FIELD_LENGTH,'+
          ' b.RDB$FIELD_SCALE,'+
          ' c.RDB$TYPE_NAME,'+
          ' b.RDB$FIELD_SUB_TYPE,'+
          ' b.RDB$CHARACTER_LENGTH,'+
          ' b.RDB$FIELD_PRECISION,'+
          ' a.RDB$DEFAULT_VALUE,'+
          ' COALESCE((SELECT 1'+
          '           FROM  RDB$RELATION_CONSTRAINTS RELC_PRIM, RDB$INDEX_SEGMENTS IS_PRIM'+
          '           WHERE RELC_PRIM.RDB$INDEX_NAME = IS_PRIM.RDB$INDEX_NAME and'+
          '                 RELC_PRIM.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'' and'+
          '                 RELC_PRIM.RDB$RELATION_NAME = a.RDB$RELATION_NAME and'+
          '                 IS_PRIM.RDB$FIELD_NAME = a.RDB$FIELD_NAME),0)'+
          ' FROM RDB$RELATION_FIELDS a, RDB$FIELDS b'+
          ' LEFT JOIN RDB$TYPES c ON  b.RDB$FIELD_TYPE = c.RDB$TYPE and'+
          '                           c.RDB$FIELD_NAME = ''RDB$FIELD_TYPE'''+
          ' WHERE a.RDB$FIELD_SOURCE = b.RDB$FIELD_NAME and'+
          ' a.RDB$RELATION_NAME NOT LIKE ''RDB$%'' and '+
          ' a.RDB$RELATION_NAME NOT LIKE ''MON$%'' and a.RDB$VIEW_CONTEXT is null'+
          ' ORDER BY a.RDB$RELATION_NAME, a.RDB$FIELD_POSITION';
end;

procedure TORMDriverManager.SetConnectionParameters(
  const sConnectionString: string);
var
  sLista: TStringList;
begin
  sLista:= TStringList.Create;
  sLista.Text := StringReplace( sConnectionString, ';', #13#10, [rfReplaceAll] );;

  //No voy a validar que el string esté bien. Simplemente,
  //como siempre se genera, voy a presuponer que está bien formado.
  edtServer.Text := Trim(MidStr(sLista[0], Pos('=', sLista[0])+1, Length(sLista[0])));
  edtBD.Text := Trim(MidStr(sLista[1], Pos('=', sLista[1])+1, Length(sLista[1])));
  edtUsuario.Text := Trim(MidStr(sLista[2], Pos('=', sLista[2])+1, Length(sLista[2])));
  edtPassword.Text := Trim(MidStr(sLista[3], Pos('=', sLista[3])+1, Length(sLista[3])));

  sLista.Free;
end;

function TORMDriverManager.ValidateParameters: Boolean;
begin
  Result := true;

  if Trim(edtServer.Text) = '' then
  begin
    Application.MessageBox('Debe ingresar el nombre del servidor para realizar la conexión',
      'Application.Title', MB_OK + MB_ICONWARNING);
    edtServer.SetFocus;
    Result := False;
  end
  else if Trim(edtBD.Text) = '' then
  begin
    Application.MessageBox('Debe ingresar la BD para realizar la conexión',
      'Application.Title', MB_OK + MB_ICONWARNING);
    edtBD.SetFocus;
    Result := False;
  end
  else if Trim(edtUsuario.Text) = '' then
  begin
    Application.MessageBox('Debe ingresar el nombre del usuario para realizar la conexión',
      'Application.Title', MB_OK + MB_ICONWARNING);
    edtUsuario.SetFocus;
    Result := False;
  end
  else if Trim(edtPassword.Text) = '' then
  begin
    Application.MessageBox('Debe ingresar la clave del usuario para realizar la conexión',
      'Application.Title', MB_OK + MB_ICONWARNING);
    edtPassword.SetFocus;
    Result := False;
  end;
end;

exports
  GetDelphiORMDriverName,
  ConvertirTipo;
  
initialization
  theClass := TORMDriverManager;
  theForm  := nil;
  //RegisterFormClass (TORMDriverManager, Windows.GetModuleHandle('DelphiORMFirebirdDriver.bpl'));

end.

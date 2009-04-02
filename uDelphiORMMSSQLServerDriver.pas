{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uDelphiORMMSSQLServerDriver.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uDelphiORMMSSQLServerDriver;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uDelphiORMBaseDriver, WideStrings, DB, SqlExpr,
  uCoreClasses;

type
  TORMDriverManager = class(TForm, IORMDriverManager)
    sqlConn: TSQLConnection;
    lblServer: TLabel;
    lblUsuario: TLabel;
    lblPassword: TLabel;
    lblBD: TLabel;
    edtServer: TEdit;
    edtUsuario: TEdit;
    edtPassword: TEdit;
    edtBD: TEdit;
    chbUtilizarAutSO: TCheckBox;
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
    TipoDato = 4;
    EsIdentidad=5;
    EsClavePrimaria = 6;
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

{$R *.dfm}

uses StrUtils;

function GetDelphiORMDriverName(): PChar;
begin
  Result := PChar('MSSQL - Delphi ORM Driver');
end;

procedure ConvertirTipo(unCampo: TCampo; const sVariable: string; const sSubVar: string);
var
  sTipo, sSubTipo: string;
begin
  sTipo             := Trim(sVariable);
  sSubTipo          := Trim(sSubVar);
  unCampo.TipoBD    := sTipo;
  unCampo.SubTipoBD := sSubTipo;

  if ((sTipo = 'varchar') or (sTipo = 'char') or (sTipo = 'ntext') or
      (sTipo = 'nvarchar') or (sTipo = 'nchar')) then begin
    unCampo.TipoVariable := 'string';
    unCampo.TipoORM := 'tdString';
    unCampo.AsKeyWord := 'AsString';
  end
  else if ((sTipo = 'tinyint') or (sTipo = 'smallint') or (sTipo = 'int')) then begin
    unCampo.TipoVariable := 'integer';
    unCampo.TipoORM := 'tdInteger';
    unCampo.AsKeyWord := 'AsInteger';
  end
  else if ((sTipo = 'real') or (sTipo = 'money')) then begin
    unCampo.TipoVariable := 'double';
    unCampo.TipoORM := 'tdfloat';
    unCampo.AsKeyWord := 'AsFloat';
  end
  else if (sTipo = 'bit') then begin
    unCampo.TipoVariable := 'boolean';
    unCampo.TipoORM := 'tdBoolean';
    unCampo.AsKeyWord := 'AsBoolean';
  end
  else if ((sTipo = 'timestamp') or (sTipo = 'smalldatetime') or (sTipo = 'datetime')) then begin
    unCampo.TipoVariable := 'TDateTime';
    unCampo.TipoORM := 'tdTime';
    unCampo.AsKeyWord := 'AsDateTime';
  end
  else if (sTipo = 'image') then begin
    //Binario
    unCampo.TipoVariable := 'TMemoryStream';
    unCampo.TipoORM := 'tdBlobBinary';
    unCampo.AsKeyWord := 'AsStream';
  end;
end;

{ TORMDriverManager }

function TORMDriverManager.Connect: Boolean;
begin
  sqlConn.Params.Values['HostName']   := edtServer.Text;
  sqlConn.Params.Values['Database']   := edtBD.Text;
  sqlConn.Params.Values['User_Name']  := edtUsuario.Text;
  sqlConn.Params.Values['Password']   := edtPassword.Text;
  if chbUtilizarAutSO.Checked then
    sqlConn.Params.Values['OS Authentication'] := 'True'
  else
    sqlConn.Params.Values['OS Authentication'] := 'False';

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
  Result := Result + '; OSAut=';
  if chbUtilizarAutSO.Checked then
    Result := Result + 'True'
  else
    Result := Result + 'False';
end;

function TORMDriverManager.GetGeneratorsInfo: TColeccionGenerador;
begin
  Result := TColeccionGenerador.Create;
end;

function TORMDriverManager.GetModule: THandle;
begin
  Result := Windows.GetModuleHandle ('DelphiORMMSSQLServerDriver.bpl');
end;

function TORMDriverManager.GetTablesInfo: TColeccionTabla;
var
  unDataSet: TDataSet;
  sSQL: string;
  unaTabla: TTabla;
  unaTablaRelacionada: TTabla;
  //Generadores: TColeccionGenerador;

  unCampo: TCampo;
  unCampoFK: TCamposFK;
  unCampoFKRel: TCamposFK;

  sTablaAnterior: string;
  sRelacionAnterior: string;
begin
  Result := TColeccionTabla.Create;

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
    end;

    unCampo := TCampo.Create(unaTabla.Campos);
    if  ((unDataSet.Fields[TDatosTabla.EsClavePrimaria].AsInteger = 1) and
        (unDataSet.Fields[TDatosTabla.EsIdentidad].AsInteger = 1)) then
      unaTabla.TieneGenerador := true;

    unCampo.Nombre := Trim(unDataSet.Fields[TDatosTabla.Campo].AsString);
    unCampo.Longitud := unDataSet.Fields[TDatosTabla.Longitud].AsInteger;
    ConvertirTipo(unCampo,  unDataSet.Fields[TDatosTabla.TipoDato].AsString, '');
    unCampo.AceptaNull := (unDataSet.Fields[TDatosTabla.PermiteNulo].AsString = 'YES');
    unCampo.EsClavePrimaria := (unDataSet.Fields[TDatosTabla.EsClavePrimaria].AsInteger = 1);
    //unCampo.ValorDefault := unDataSet.Fields[TDatosTabla.ValorDefault].AsVariant;

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
end;

function TORMDriverManager.ObtenerSQLInfoRelaciones: string;
begin
  Result := 'SELECT	b.CONSTRAINT_NAME,'+
          	'	      a.TABLE_NAME As TablaOrigen,'+
		        '       a.COLUMN_NAME as ColumnaOrigen,'+
		        '       c.TABLE_NAME as TablaDestino,'+
		        '       c.COLUMN_NAME as ColumnaDestino'+
            ' FROM	INFORMATION_SCHEMA.KEY_COLUMN_USAGE a,'+
            '   		INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS b,'+
            '   		INFORMATION_SCHEMA.KEY_COLUMN_USAGE c'+
            ' WHERE a.CONSTRAINT_NAME = b.CONSTRAINT_NAME AND'+
            '       c.CONSTRAINT_NAME = b.UNIQUE_CONSTRAINT_NAME'+
            ' ORDER BY 1, 2';
end;

function TORMDriverManager.ObtenerSQLInfoTablas: string;
begin
  Result :=  '  SELECT	INFORMATION_SCHEMA.COLUMNS.TABLE_NAME,'+
             '   		COLUMN_NAME,'+
             '   		IS_NULLABLE,'+
             '   		CHARACTER_MAXIMUM_LENGTH,'+
             '   		DATA_TYPE,'+
             '      (SELECT COLUMNPROPERTY(OBJECT_ID(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME),'+
             '          INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME, ''IsIdentity'')) AS IsIdentity, '+
             '      (ISNULL((SELECT 1 FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE'+
             '          WHERE	TABLE_NAME=INFORMATION_SCHEMA.COLUMNS.TABLE_NAME AND'+
             '              TABLE_SCHEMA=''dbo'' AND'+
             '              COLUMN_NAME=INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME AND'+
             '              EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS'+
             '                  WHERE	TABLE_NAME=INFORMATION_SCHEMA.COLUMNS.TABLE_NAME AND'+
             '                      TABLE_SCHEMA=''dbo'' AND'+
             '                      CONSTRAINT_TYPE = ''PRIMARY KEY'' AND'+
             '                      CONSTRAINT_NAME=INFORMATION_SCHEMA.KEY_COLUMN_USAGE.CONSTRAINT_NAME)), 0)) AS IsPrimaryKey'+
             '  FROM	INFORMATION_SCHEMA.COLUMNS,'+
             '      INFORMATION_SCHEMA.TABLES'+
             '  WHERE	INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME AND'+
             '      INFORMATION_SCHEMA.TABLES.TABLE_TYPE = ''BASE TABLE'' AND'+
             '      INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA=''dbo'' AND'+
             '      INFORMATION_SCHEMA.COLUMNS.TABLE_NAME NOT LIKE ''sys%'' AND'+
             '      INFORMATION_SCHEMA.COLUMNS.TABLE_NAME NOT LIKE ''dt%'''+
             '  ORDER BY 1,3';
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
  if Trim(MidStr(sLista[4], Pos('=', sLista[4])+1, Length(sLista[4]))) = 'True' then
    chbUtilizarAutSO.Checked := True
  else
    chbUtilizarAutSO.Checked := False;

  sLista.Free;
end;

function TORMDriverManager.ValidateParameters: Boolean;
begin
  Result := true;

  if Trim(edtServer.Text) = '' then
  begin
    Application.MessageBox('Debe ingresar el nombre del servidor para realizar la conexión',
      'Atención', MB_OK + MB_ICONWARNING);
    edtServer.SetFocus;
    Result := False;
  end
  else if Trim(edtBD.Text) = '' then
  begin
    Application.MessageBox('Debe ingresar la BD para realizar la conexión',
      'Atención', MB_OK + MB_ICONWARNING);
    edtBD.SetFocus;
    Result := False;
  end;

  if not chbUtilizarAutSO.Checked then
  begin
    if Trim(edtUsuario.Text) = '' then
    begin
      Application.MessageBox('Debe ingresar el nombre del usuario para realizar la conexión',
        'Atención', MB_OK + MB_ICONWARNING);
      edtUsuario.SetFocus;
      Result := False;
    end
    else if Trim(edtPassword.Text) = '' then
    begin
      Application.MessageBox('Debe ingresar la clave del usuario para realizar la conexión',
        'Atención', MB_OK + MB_ICONWARNING);
      edtPassword.SetFocus;
      Result := False;
    end;
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

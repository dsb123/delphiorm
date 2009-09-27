{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uDelphiORMOracleDriver.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uDelphiORMOracleDriver;

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
    lblPuerto: TLabel;
    edtPuerto: TEdit;
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
  Result := PChar('Oracle - Delphi ORM Driver');
end;

procedure ConvertirTipo(unCampo: TCampo; const sVariable: string; const sSubVar: string;
                        const nPrecision: Integer; const nEscala: integer);
var
  sTipo, sSubTipo: string;
begin
  sTipo             := Trim(sVariable);
  sSubTipo          := Trim(sSubVar);
  unCampo.TipoBD    := sTipo;
  unCampo.SubTipoBD := sSubTipo;

  if  ( (sTipo = 'CHAR') or
        (sTipo = 'VARCHAR') or
        (sTipo = 'NCHAR') or
        (sTipo = 'NVARCHAR2') or
        (sTipo = 'VARCHAR2') or
        (sTipo = 'CLOB') or
        (sTipo = 'NCLOB') or
        (sTipo = 'LONG')) then begin
    unCampo.TipoVariable := 'string';
    unCampo.TipoORM := 'tdString';
    unCampo.AsKeyWord := 'AsString';
  end
  else if ( (sTipo = 'INTEGER') or
            (sTipo = 'INT') or
            (sTipo = 'SMALLINT')) then begin
    unCampo.TipoVariable := 'integer';
    unCampo.TipoORM := 'tdInteger';
    unCampo.AsKeyWord := 'AsInteger';
  end
  else if sTipo = 'DATE' then begin
    unCampo.TipoVariable := 'TDateTime';
    unCampo.TipoORM := 'tdDate';
    unCampo.AsKeyWord := 'AsDateTime';
  end
  else if ( (sTipo = 'FLOAT') or
            (sTipo = 'REAL') or
            (sTipo = 'DOUBLE PRECISION')) then begin
    unCampo.TipoVariable := 'double';
    unCampo.TipoORM := 'tdfloat';
    unCampo.AsKeyWord := 'AsFloat';
  end
  else if ( (sTipo = 'NUMBER') or
            (sTipo = 'NUMERIC') or
            (sTipo = 'DEC') or
            (sTipo = 'DECIMAL')) then begin
    if nEscala > 0 then
    begin
      unCampo.TipoVariable := 'double';
      unCampo.TipoORM := 'tdfloat';
      unCampo.AsKeyWord := 'AsFloat';
    end
    else
    begin
      unCampo.TipoVariable := 'integer';
      unCampo.TipoORM := 'tdInteger';
      unCampo.AsKeyWord := 'AsInteger';
    end;
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
    //Binario
    unCampo.TipoVariable := 'TMemoryStream';
    unCampo.TipoORM := 'tdBlobBinary';
    unCampo.AsKeyWord := 'AsStream';
  end;
end;


{ TORMDriverManager }

function TORMDriverManager.Connect: Boolean;
begin
  sqlConn.Params.Values['Database'] :=  edtServer.Text + ':' +
                                        edtPuerto.Text + '/' +
                                        edtBD.Text;
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
  Result := Result + '; Port=' + edtPuerto.Text;
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
  sSQL := 'SELECT sequence_name FROM user_sequences order by 1';
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
  Result := Windows.GetModuleHandle ('DelphiORMOracleDriver.bpl');
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
    unCampo.Longitud  := unDataSet.Fields[TDatosTabla.LongitudChar].AsInteger;
    unCampo.Precision := unDataSet.Fields[TDatosTabla.PrecisionNumerica].AsInteger;
    unCampo.Escala    := unDataSet.Fields[TDatosTabla.Escala].AsInteger;

    ConvertirTipo(unCampo,  unDataSet.Fields[TDatosTabla.TipoDato].AsString,
                            unDataSet.Fields[TDatosTabla.SubTipoDato].AsString,
                            unDataSet.Fields[TDatosTabla.PrecisionNumerica].AsInteger,
                            unDataSet.Fields[TDatosTabla.Escala].AsInteger);

    unCampo.AceptaNull := (unDataSet.Fields[TDatosTabla.PermiteNulo].AsString = 'Y');
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
  Result := 'select'+
            '    b.constraint_name,'+
            '    a.table_name,'+
            '    b.column_name,'+
            '    c.table_name parent_table,'+
            '    d.column_name parent_pk '+
            'from'+
            '    all_constraints a,'+
            '    all_cons_columns b,'+
            '    all_constraints c,'+
            '    all_cons_columns d,'+
            '    user_tables t '+
            'where'+
            '    a.constraint_name = b.constraint_name'+
            '    and t.table_name=c.table_name'+
            '    and a.r_constraint_name is not null'+
            '    and a.r_constraint_name=c.constraint_name'+
            '    and c.constraint_name=d.constraint_name '+
            'order by'+
            '    a.constraint_name,'+
            '    a.table_name, b.position';
end;

function TORMDriverManager.ObtenerSQLInfoTablas: string;
begin
  Result := 'select'+
            '    t.table_name,'+
            '    c.column_name,'+
            '    c.nullable,'+
            '    c.data_length,'+
            '    c.data_scale,'+
            '    c.data_type,'+
            '    c.data_type_mod,'+
            '    c.char_length,'+
            '    c.data_precision,'+
            '    c.data_default,'+
            '    ('+
            '        select distinct '+
            '            1'+
            '        from'+
            '            all_constraints cons,'+
            '            all_cons_columns cols'+
            '        where'+
            '            cols.table_name = t.table_name'+
            '            and     cols.column_name = c.column_name'+
            '            and     cons.constraint_type = ''P'''+
            '            and     cons.constraint_name = cols.constraint_name'+
            '            and     cons.owner = cols.owner'+
            '    ) ispkfield '+
            'from'+
            '    user_tables t,'+
            '    all_tab_columns c '+
            'where'+
            '    t.table_name = c.table_name '+
            'order by'+
            '    t.table_name,'+
            '    c.column_id';
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
  edtPuerto.Text := Trim(MidStr(sLista[1], Pos('=', sLista[1])+1, Length(sLista[1])));
  edtBD.Text := Trim(MidStr(sLista[2], Pos('=', sLista[2])+1, Length(sLista[2])));
  edtUsuario.Text := Trim(MidStr(sLista[3], Pos('=', sLista[3])+1, Length(sLista[3])));
  edtPassword.Text := Trim(MidStr(sLista[4], Pos('=', sLista[4])+1, Length(sLista[4])));

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
  else if Trim(edtPuerto.Text) = '' then
  begin
    Application.MessageBox('Debe ingresar el puerto listener para realizar la conexión',
      'Atención', MB_OK + MB_ICONWARNING);
    edtBD.SetFocus;
    Result := False;
  end
  else if Trim(edtBD.Text) = '' then
  begin
    Application.MessageBox('Debe ingresar la BD para realizar la conexión',
      'Atención', MB_OK + MB_ICONWARNING);
    edtBD.SetFocus;
    Result := False;
  end
  else if Trim(edtUsuario.Text) = '' then
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

exports
  GetDelphiORMDriverName,
  ConvertirTipo;
  
initialization
  theClass := TORMDriverManager;
  theForm  := nil;
  //RegisterFormClass (TORMDriverManager, Windows.GetModuleHandle('DelphiORMOracleDriver.bpl'));

end.

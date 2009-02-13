unit uDataModule;

interface

uses
  SysUtils, Classes, WideStrings, DB, SqlExpr;

type
  TSysDataModule = class(TDataModule)
    SQLConnection: TSQLConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SysDataModule: TSysDataModule;
  sDataBase: string;

implementation

{$R *.dfm}

uses DBXCommon;

procedure TSysDataModule.DataModuleCreate(Sender: TObject);
begin
  SQLConnection.Params.Values[TDBXPropertyNames.Database] := sDataBase;
end;

end.

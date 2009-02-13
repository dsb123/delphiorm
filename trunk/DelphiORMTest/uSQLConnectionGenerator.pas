unit uSQLConnectionGenerator;

interface

uses SqlExpr, uDataModule;

type
  TSQLConnectionGenerator=class
  private
    DM : TSysDataModule;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection: TSQLConnection;
  end;

implementation

uses DBXCommon;

{ TSQLConnectionGenerator }

constructor TSQLConnectionGenerator.Create;
begin
  inherited;
  DM := TSysDataModule.Create(nil);
end;

destructor TSQLConnectionGenerator.Destroy;
begin
  DM.Free;
  inherited;
end;

function TSQLConnectionGenerator.GetConnection: TSQLConnection;
begin
  Result := TSQLConnection.Create(nil);
  Result.LoginPrompt := False;
  Result.DriverName := DM.SQLConnection.DriverName;
  Result.ConnectionName := DM.SQLConnection.ConnectionName;
  Result.Name := DM.SQLConnection.Name + 'Clone1';
  Result.Params.AddStrings(DM.SQLConnection.Params);
  Result.GetDriverFunc := DM.SQLConnection.GetDriverFunc;
  Result.LibraryName := DM.SQLConnection.LibraryName;
  Result.VendorLib := DM.SQLConnection.VendorLib;

  Result.Params.Values[TDBXPropertyNames.Database] := sDataBase;
  Result.TableScope := DM.SQLConnection.TableScope;
  Result.Connected := true;
end;

end.

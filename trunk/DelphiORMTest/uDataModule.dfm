object SysDataModule: TSysDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object SQLConnection: TSQLConnection
    ConnectionName = 'TBODbxFirebird'
    DriverName = 'TBODBXFB'
    GetDriverFunc = 'getSQLDriver'
    LibraryName = 'tbodbxfb.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=TBODBXFB'
      'Database=database.fdb'
      'RoleName='
      'User_Name=sysdba'
      'Password=masterkey'
      'ServerCharSet='
      'SQLDialect=3'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'BlobSize=-1'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'TBODBXFB TransIsolation=ReadCommited'
      'Trim Char=False')
    VendorLib = 'fbclient.dll'
    Left = 88
    Top = 56
  end
end

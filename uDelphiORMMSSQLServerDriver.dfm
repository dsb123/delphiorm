object ORMDriverManager: TORMDriverManager
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'MSSQL Driver'
  ClientHeight = 136
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    466
    136)
  PixelsPerInch = 96
  TextHeight = 13
  object lblServer: TLabel
    Left = 16
    Top = 8
    Width = 40
    Height = 13
    Caption = 'Servidor'
  end
  object lblUsuario: TLabel
    Left = 16
    Top = 59
    Width = 36
    Height = 13
    Caption = 'Usuario'
  end
  object lblPassword: TLabel
    Left = 16
    Top = 86
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object lblBD: TLabel
    Left = 16
    Top = 35
    Width = 69
    Height = 13
    Caption = 'Base de Datos'
  end
  object edtServer: TEdit
    Left = 104
    Top = 5
    Width = 161
    Height = 21
    TabOrder = 0
  end
  object edtUsuario: TEdit
    Left = 104
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edtPassword: TEdit
    Left = 104
    Top = 83
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object edtBD: TEdit
    Left = 104
    Top = 29
    Width = 354
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object chbUtilizarAutSO: TCheckBox
    Left = 104
    Top = 110
    Width = 233
    Height = 17
    Caption = 'Utilizar autenticaci'#243'n del Sistema Operativo'
    TabOrder = 4
  end
  object sqlConn: TSQLConnection
    ConnectionName = 'MSSQLConnection'
    DriverName = 'MSSQL'
    GetDriverFunc = 'getSQLDriverMSSQL'
    LibraryName = 'dbxmss30.dll'
    Params.Strings = (
      'SchemaOverride=sa.dbo'
      'DriverName=MSSQL'
      'HostName=ServerName'
      'DataBase=Database Name'
      'User_Name=user'
      'Password=password'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'MSSQL TransIsolation=ReadCommited'
      'OS Authentication=False'
      'Prepare SQL=False')
    VendorLib = 'oledb'
    Left = 408
    Top = 72
  end
end

object ORMDriverManager: TORMDriverManager
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Driver para Oracle'
  ClientHeight = 113
  ClientWidth = 519
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    519
    113)
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
  object lblPuerto: TLabel
    Left = 248
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Puerto'
  end
  object edtServer: TEdit
    Left = 104
    Top = 5
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtUsuario: TEdit
    Left = 104
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object edtPassword: TEdit
    Left = 104
    Top = 83
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 4
  end
  object edtBD: TEdit
    Left = 104
    Top = 30
    Width = 407
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object edtPuerto: TEdit
    Left = 286
    Top = 5
    Width = 51
    Height = 21
    TabOrder = 1
    Text = '1521'
  end
  object sqlConn: TSQLConnection
    ConnectionName = 'OracleConnection'
    DriverName = 'Oracle'
    GetDriverFunc = 'getSQLDriverORACLE'
    LibraryName = 'dbxora.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Oracle'
      'DataBase=192.168.0.102:1521/XE'
      'User_Name=adearmas'
      'Password=ydpsrt'
      'RowsetSize=20'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Oracle TransIsolation=ReadCommited'
      'OS Authentication=False'
      'Multiple Transaction=False'
      'Trim Char=False'
      'Decimal Separator=.')
    VendorLib = 'oci.dll'
    Left = 472
    Top = 72
  end
end

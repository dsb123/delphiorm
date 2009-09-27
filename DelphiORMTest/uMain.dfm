object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 571
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnAgregarTipoDocumento: TButton
    Left = 8
    Top = 8
    Width = 177
    Height = 25
    Caption = 'Agregar Tipos de Documento'
    TabOrder = 0
  end
  object btnAgregarTipoDomicilio: TButton
    Left = 8
    Top = 39
    Width = 177
    Height = 25
    Caption = 'Agregar Tipo Domicilio'
    TabOrder = 2
  end
  object btnAgregarPersona: TButton
    Left = 8
    Top = 70
    Width = 177
    Height = 25
    Caption = 'Agregar Persona'
    TabOrder = 3
  end
  object dbgrd: TDBGrid
    Left = 191
    Top = 8
    Width = 352
    Height = 249
    DataSource = ds
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnVerTipoDocumento: TButton
    Left = 207
    Top = 263
    Width = 75
    Height = 25
    Caption = 'Ver Tipo Doc'
    TabOrder = 8
    OnClick = btnVerTipoDocumentoClick
  end
  object btnVerTipoDom: TButton
    Left = 288
    Top = 263
    Width = 75
    Height = 25
    Caption = 'Ver Tipo Dom'
    TabOrder = 9
  end
  object btnVerPersonas: TButton
    Left = 369
    Top = 263
    Width = 75
    Height = 25
    Caption = 'Ver Personas'
    TabOrder = 10
  end
  object btnVerLista: TButton
    Left = 450
    Top = 263
    Width = 75
    Height = 25
    Caption = 'Ver Lista'
    TabOrder = 11
    OnClick = btnVerListaClick
  end
  object btnPersDom: TButton
    Left = 8
    Top = 160
    Width = 177
    Height = 25
    Caption = 'Persona->Domicilio'
    TabOrder = 5
  end
  object btnPersonaDocumento: TButton
    Left = 8
    Top = 191
    Width = 177
    Height = 25
    Caption = 'Persona -> Tipo documento'
    TabOrder = 6
  end
  object btnObtener: TButton
    Left = 8
    Top = 129
    Width = 177
    Height = 25
    Caption = 'Obtener Persona ID = 1'
    TabOrder = 4
  end
  object btn1: TButton
    Left = 110
    Top = 222
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 7
    OnClick = btn1Click
  end
  object mmo1: TMemo
    Left = 191
    Top = 304
    Width = 334
    Height = 97
    Lines.Strings = (
      'mmo1')
    TabOrder = 12
  end
  object btnListaTipo: TButton
    Left = 191
    Top = 407
    Width = 105
    Height = 25
    Caption = 'Lista Tipo Persona'
    TabOrder = 13
    OnClick = btnListaTipoClick
  end
  object Button1: TButton
    Left = 302
    Top = 407
    Width = 115
    Height = 25
    Caption = 'Button1'
    TabOrder = 14
  end
  object btn2: TButton
    Left = 191
    Top = 438
    Width = 75
    Height = 25
    Caption = 'btn2'
    TabOrder = 15
    OnClick = btn2Click
  end
  object ds: TDataSource
    Left = 120
    Top = 256
  end
end

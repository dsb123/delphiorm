object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 318
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnAgregarTipoDocumento: TButton
    Left = 8
    Top = 8
    Width = 177
    Height = 25
    Caption = 'Agregar Tipos de Documento'
    TabOrder = 0
    OnClick = btnAgregarTipoDocumentoClick
  end
  object btnAgregarTipoDomicilio: TButton
    Left = 8
    Top = 39
    Width = 177
    Height = 25
    Caption = 'Agregar Tipo Domicilio'
    TabOrder = 2
    OnClick = btnAgregarTipoDomicilioClick
  end
  object btnAgregarPersona: TButton
    Left = 8
    Top = 70
    Width = 177
    Height = 25
    Caption = 'Agregar Persona'
    TabOrder = 3
    OnClick = btnAgregarPersonaClick
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
    TabOrder = 7
  end
  object btnVerTipoDom: TButton
    Left = 288
    Top = 263
    Width = 75
    Height = 25
    Caption = 'Ver Tipo Dom'
    TabOrder = 8
  end
  object btnVerPersonas: TButton
    Left = 369
    Top = 263
    Width = 75
    Height = 25
    Caption = 'Ver Personas'
    TabOrder = 9
  end
  object btnVerLista: TButton
    Left = 450
    Top = 263
    Width = 75
    Height = 25
    Caption = 'Ver Lista'
    TabOrder = 10
    OnClick = btnVerListaClick
  end
  object btnPersDom: TButton
    Left = 8
    Top = 160
    Width = 177
    Height = 25
    Caption = 'Persona->Domicilio'
    TabOrder = 5
    OnClick = btnPersDomClick
  end
  object btnPersonaDocumento: TButton
    Left = 8
    Top = 191
    Width = 177
    Height = 25
    Caption = 'Persona -> Tipo documento'
    TabOrder = 6
    OnClick = btnPersonaDocumentoClick
  end
  object btnObtener: TButton
    Left = 8
    Top = 129
    Width = 177
    Height = 25
    Caption = 'Obtener Persona ID = 1'
    TabOrder = 4
    OnClick = btnObtenerClick
  end
  object ds: TDataSource
    Left = 120
    Top = 256
  end
end

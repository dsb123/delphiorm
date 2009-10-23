
{***********************************************************************}
{                                                                       }
{                           XML Data Binding                            }
{                                                                       }
{         Generated on: 23/06/2009 02:35:11 p.m.                        }
{       Generated from: C:\Desarrollos\Delphi\DelphiORM\ORMXMLDef.xdb   }
{   Settings stored in: C:\Desarrollos\Delphi\DelphiORM\ORMXMLDef.xdb   }
{                                                                       }
{***********************************************************************}

unit ORMXMLDef;

interface

uses xmldom, XMLDoc, XMLIntf, Variants;

type

{ Forward Decls }

  IXMLORMEntidadesType = interface;
  IXMLGeneradoresType = interface;
  IXMLGeneradorType = interface;
  IXMLEntidadesType = interface;
  IXMLEntidadType = interface;
  IXMLCamposType = interface;
  IXMLCampoType = interface;
  IXMLForeignkeysType = interface;
  IXMLForeignkeyType = interface;
  IXMLForeignkeyTypeList = interface;
  IXMLOrigenType = interface;
  IXMLCampoRedType = interface;
  IXMLDestinoType = interface;
  IXMLListasType = interface;
  IXMLListaType = interface;
  IXMLListaTypeList = interface;
  IXMLRelacionesType = interface;
  IXMLRelacionType = interface;
  IXMLRelacionTypeList = interface;

{ IXMLORMEntidadesType }

  IXMLORMEntidadesType = interface(IXMLNode)
    ['{3EDEAF9A-4ABA-4958-B862-0360ECB1D783}']
    { Property Accessors }
    function Get_Driver: WideString;
    function Get_StringConexion: WideString;
    function Get_NombreArchivoDefault: WideString;
    function Get_Generadores: IXMLGeneradoresType;
    function Get_Entidades: IXMLEntidadesType;
    function Get_Listas: IXMLListasType;
    procedure Set_Driver(Value: WideString);
    procedure Set_StringConexion(Value: WideString);
    procedure Set_NombreArchivoDefault(Value: WideString);
    { Methods & Properties }
    property Driver: WideString read Get_Driver write Set_Driver;
    property StringConexion: WideString read Get_StringConexion write Set_StringConexion;
    property NombreArchivoDefault: WideString read Get_NombreArchivoDefault write Set_NombreArchivoDefault;
    property Generadores: IXMLGeneradoresType read Get_Generadores;
    property Entidades: IXMLEntidadesType read Get_Entidades;
    property Listas: IXMLListasType read Get_Listas;
  end;

{ IXMLGeneradoresType }

  IXMLGeneradoresType = interface(IXMLNodeCollection)
    ['{44382A93-FB85-4A8E-AC67-257194AAD790}']
    { Property Accessors }
    function Get_Generador(Index: Integer): IXMLGeneradorType;
    { Methods & Properties }
    function Add: IXMLGeneradorType;
    function Insert(const Index: Integer): IXMLGeneradorType;
    property Generador[Index: Integer]: IXMLGeneradorType read Get_Generador; default;
  end;

{ IXMLGeneradorType }

  IXMLGeneradorType = interface(IXMLNode)
    ['{0E267000-BC71-402D-B2D1-86E9C84787D5}']
    { Property Accessors }
    function Get_Nombre: WideString;
    procedure Set_Nombre(Value: WideString);
    { Methods & Properties }
    property Nombre: WideString read Get_Nombre write Set_Nombre;
  end;

{ IXMLEntidadesType }

  IXMLEntidadesType = interface(IXMLNodeCollection)
    ['{7B5BCB4F-CEE3-47DE-999E-B2A5B3F8C274}']
    { Property Accessors }
    function Get_Entidad(Index: Integer): IXMLEntidadType;
    { Methods & Properties }
    function Add: IXMLEntidadType;
    function Insert(const Index: Integer): IXMLEntidadType;
    property Entidad[Index: Integer]: IXMLEntidadType read Get_Entidad; default;
  end;

{ IXMLEntidadType }

  IXMLEntidadType = interface(IXMLNode)
    ['{BD0C892F-6302-4982-89F4-795F12F8101F}']
    { Property Accessors }
    function Get_Nombre: WideString;
    function Get_TieneGenerador: Boolean;
    function Get_NombreGenerador: WideString;
    function Get_Alias: WideString;
    function Get_Campos: IXMLCamposType;
    function Get_Relacion1a1: IXMLForeignkeysType;
    function Get_Relacion1an: IXMLForeignkeysType;
    procedure Set_Nombre(Value: WideString);
    procedure Set_TieneGenerador(Value: Boolean);
    procedure Set_NombreGenerador(Value: WideString);
    procedure Set_Alias(Value: WideString);
    { Methods & Properties }
    property Nombre: WideString read Get_Nombre write Set_Nombre;
    property TieneGenerador: Boolean read Get_TieneGenerador write Set_TieneGenerador;
    property NombreGenerador: WideString read Get_NombreGenerador write Set_NombreGenerador;
    property Alias: WideString read Get_Alias write Set_Alias;
    property Campos: IXMLCamposType read Get_Campos;
    property Relacion1a1: IXMLForeignkeysType read Get_Relacion1a1;
    property Relacion1an: IXMLForeignkeysType read Get_Relacion1an;
  end;

{ IXMLCamposType }

  IXMLCamposType = interface(IXMLNodeCollection)
    ['{DA17E3ED-DEA8-46F6-BDEB-E395823F4D84}']
    { Property Accessors }
    function Get_Campo(Index: Integer): IXMLCampoType;
    { Methods & Properties }
    function Add: IXMLCampoType;
    function Insert(const Index: Integer): IXMLCampoType;
    property Campo[Index: Integer]: IXMLCampoType read Get_Campo; default;
  end;

{ IXMLCampoType }

  IXMLCampoType = interface(IXMLNode)
    ['{EA37903F-D95A-4FF9-8383-CA37AC48FF19}']
    { Property Accessors }
    function Get_Nombre: WideString;
    function Get_Alias: WideString;
    function Get_Tipo: WideString;
    function Get_SubTipo: WideString;
    function Get_Longitud: Integer;
    function Get_Precision: Integer;
    function Get_Escala: Integer;
    function Get_AceptaNull: Boolean;
    function Get_EsClavePrimaria: Boolean;
    function Get_EsClaveForanea: Boolean;
    function Get_FuncionAgregacion: Integer;
    function Get_ValorDefault: Variant;
    procedure Set_Nombre(Value: WideString);
    procedure Set_Alias(Value: WideString);
    procedure Set_Tipo(Value: WideString);
    procedure Set_SubTipo(Value: WideString);
    procedure Set_Longitud(Value: Integer);
    procedure Set_Precision(Value: Integer);
    procedure Set_Escala(Value: Integer);
    procedure Set_AceptaNull(Value: Boolean);
    procedure Set_EsClavePrimaria(Value: Boolean);
    procedure Set_EsClaveForanea(Value: Boolean);
    procedure Set_FuncionAgregacion(Value: Integer);
    procedure Set_ValorDefault(Value: Variant);
    { Methods & Properties }
    property Nombre: WideString read Get_Nombre write Set_Nombre;
    property Alias: WideString read Get_Alias write Set_Alias;
    property Tipo: WideString read Get_Tipo write Set_Tipo;
    property SubTipo: WideString read Get_SubTipo write Set_SubTipo;
    property Longitud: Integer read Get_Longitud write Set_Longitud;
    property Precision: Integer read Get_Precision write Set_Precision;
    property Escala: Integer read Get_Escala write Set_Escala;
    property AceptaNull: Boolean read Get_AceptaNull write Set_AceptaNull;
    property EsClavePrimaria: Boolean read Get_EsClavePrimaria write Set_EsClavePrimaria;
    property EsClaveForanea: Boolean read Get_EsClaveForanea write Set_EsClaveForanea;
    property FuncionAgregacion: Integer read Get_FuncionAgregacion write Set_FuncionAgregacion;
    property ValorDefault: Variant read Get_ValorDefault write Set_ValorDefault;
  end;

{ IXMLForeignkeysType }

  IXMLForeignkeysType = interface(IXMLNodeCollection)
    ['{976417D8-707C-4438-B7E2-53D9D9BFA193}']
    { Property Accessors }
    function Get_Foreignkey(Index: Integer): IXMLForeignkeyType;
    { Methods & Properties }
    function Add: IXMLForeignkeyType;
    function Insert(const Index: Integer): IXMLForeignkeyType;
    property Foreignkey[Index: Integer]: IXMLForeignkeyType read Get_Foreignkey; default;
  end;

{ IXMLForeignkeyType }

  IXMLForeignkeyType = interface(IXMLNode)
    ['{5F1B88FB-DDE3-4F92-AE59-324682AC29D9}']
    { Property Accessors }
    function Get_TablaRelacionada: WideString;
    function Get_NombreRelacion: WideString;
    function Get_NombreRelacionAMuchos: WideString;
    function Get_Origen: IXMLOrigenType;
    function Get_Destino: IXMLDestinoType;
    procedure Set_TablaRelacionada(Value: WideString);
    procedure Set_NombreRelacion(Value: WideString);
    procedure Set_NombreRelacionAMuchos(Value: WideString);
    { Methods & Properties }
    property TablaRelacionada: WideString read Get_TablaRelacionada write Set_TablaRelacionada;
    property NombreRelacion: WideString read Get_NombreRelacion write Set_NombreRelacion;
    property NombreRelacionAMuchos: WideString read Get_NombreRelacionAMuchos write Set_NombreRelacionAMuchos;
    property Origen: IXMLOrigenType read Get_Origen;
    property Destino: IXMLDestinoType read Get_Destino;
  end;

{ IXMLForeignkeyTypeList }

  IXMLForeignkeyTypeList = interface(IXMLNodeCollection)
    ['{1E647864-D582-489D-B12D-776CE8A5F3B6}']
    { Methods & Properties }
    function Add: IXMLForeignkeyType;
    function Insert(const Index: Integer): IXMLForeignkeyType;
    function Get_Item(Index: Integer): IXMLForeignkeyType;
    property Items[Index: Integer]: IXMLForeignkeyType read Get_Item; default;
  end;

{ IXMLOrigenType }

  IXMLOrigenType = interface(IXMLNodeCollection)
    ['{C7EF3207-1166-45FA-8BB1-B03E4313F87C}']
    { Property Accessors }
    function Get_CampoRed(Index: Integer): IXMLCampoRedType;
    { Methods & Properties }
    function Add: IXMLCampoRedType;
    function Insert(const Index: Integer): IXMLCampoRedType;
    property CampoRed[Index: Integer]: IXMLCampoRedType read Get_CampoRed; default;
  end;

{ IXMLCampoRedType }

  IXMLCampoRedType = interface(IXMLNode)
    ['{5A15C62D-A790-47FB-8B65-8DA0D19D064F}']
    { Property Accessors }
    function Get_Tabla: WideString;
    function Get_Nombre: WideString;
    procedure Set_Tabla(Value: WideString);
    procedure Set_Nombre(Value: WideString);
    { Methods & Properties }
    property Tabla: WideString read Get_Tabla write Set_Tabla;
    property Nombre: WideString read Get_Nombre write Set_Nombre;
  end;

{ IXMLDestinoType }

  IXMLDestinoType = interface(IXMLNodeCollection)
    ['{8E165B99-C6B4-42BB-9A77-89B4B1687CD2}']
    { Property Accessors }
    function Get_CampoRed(Index: Integer): IXMLCampoRedType;
    { Methods & Properties }
    function Add: IXMLCampoRedType;
    function Insert(const Index: Integer): IXMLCampoRedType;
    property CampoRed[Index: Integer]: IXMLCampoRedType read Get_CampoRed; default;
  end;

{ IXMLListasType }

  IXMLListasType = interface(IXMLNodeCollection)
    ['{04EE6A3A-5851-4A8A-9456-6C46617C2C88}']
    { Property Accessors }
    function Get_Lista(Index: Integer): IXMLListaType;
    { Methods & Properties }
    function Add: IXMLListaType;
    function Insert(const Index: Integer): IXMLListaType;
    property Lista[Index: Integer]: IXMLListaType read Get_Lista; default;
  end;

{ IXMLListaType }

  IXMLListaType = interface(IXMLNode)
    ['{E91375AB-DE87-4E3F-91B9-0562037573B3}']
    { Property Accessors }
    function Get_Nombre: WideString;
    function Get_Entidades: IXMLEntidadesType;
    function Get_Relaciones: IXMLRelacionesType;
    procedure Set_Nombre(Value: WideString);
    { Methods & Properties }
    property Nombre: WideString read Get_Nombre write Set_Nombre;
    property Entidades: IXMLEntidadesType read Get_Entidades;
    property Relaciones: IXMLRelacionesType read Get_Relaciones;
  end;

{ IXMLListaTypeList }

  IXMLListaTypeList = interface(IXMLNodeCollection)
    ['{95D19CF5-19FC-411A-8DA9-71E4C40F32BE}']
    { Methods & Properties }
    function Add: IXMLListaType;
    function Insert(const Index: Integer): IXMLListaType;
    function Get_Item(Index: Integer): IXMLListaType;
    property Items[Index: Integer]: IXMLListaType read Get_Item; default;
  end;

{ IXMLRelacionesType }

  IXMLRelacionesType = interface(IXMLNodeCollection)
    ['{B9E97074-E2C2-4BFE-941D-48FDD1C5371A}']
    { Property Accessors }
    function Get_Relacion(Index: Integer): IXMLRelacionType;
    { Methods & Properties }
    function Add: IXMLRelacionType;
    function Insert(const Index: Integer): IXMLRelacionType;
    property Relacion[Index: Integer]: IXMLRelacionType read Get_Relacion; default;
  end;

{ IXMLRelacionType }

  IXMLRelacionType = interface(IXMLNode)
    ['{84BB6EC6-3D8D-41A1-991C-4687A80352D9}']
    { Property Accessors }
    function Get_TablaOrigen: WideString;
    function Get_TablaDestino: WideString;
    function Get_NombreRelacion: WideString;
    function Get_NombreRelacionAMuchos: WideString;
    function Get_TipoRelacion: WideString;
    procedure Set_TablaOrigen(Value: WideString);
    procedure Set_TablaDestino(Value: WideString);
    procedure Set_NombreRelacion(Value: WideString);
    procedure Set_NombreRelacionAMuchos(Value: WideString);
    procedure Set_TipoRelacion(Value: WideString);
    { Methods & Properties }
    property TablaOrigen: WideString read Get_TablaOrigen write Set_TablaOrigen;
    property TablaDestino: WideString read Get_TablaDestino write Set_TablaDestino;
    property NombreRelacion: WideString read Get_NombreRelacion write Set_NombreRelacion;
    property NombreRelacionAMuchos: WideString read Get_NombreRelacionAMuchos write Set_NombreRelacionAMuchos;
    property TipoRelacion: WideString read Get_TipoRelacion write Set_TipoRelacion;
  end;

{ IXMLRelacionTypeList }

  IXMLRelacionTypeList = interface(IXMLNodeCollection)
    ['{7C652341-C89B-4BA9-A311-E350B35426F9}']
    { Methods & Properties }
    function Add: IXMLRelacionType;
    function Insert(const Index: Integer): IXMLRelacionType;
    function Get_Item(Index: Integer): IXMLRelacionType;
    property Items[Index: Integer]: IXMLRelacionType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLORMEntidadesType = class;
  TXMLGeneradoresType = class;
  TXMLGeneradorType = class;
  TXMLEntidadesType = class;
  TXMLEntidadType = class;
  TXMLCamposType = class;
  TXMLCampoType = class;
  TXMLForeignkeysType = class;
  TXMLForeignkeyType = class;
  TXMLForeignkeyTypeList = class;
  TXMLOrigenType = class;
  TXMLCampoRedType = class;
  TXMLDestinoType = class;
  TXMLListasType = class;
  TXMLListaType = class;
  TXMLListaTypeList = class;
  TXMLRelacionesType = class;
  TXMLRelacionType = class;
  TXMLRelacionTypeList = class;

{ TXMLORMEntidadesType }

  TXMLORMEntidadesType = class(TXMLNode, IXMLORMEntidadesType)
  protected
    { IXMLORMEntidadesType }
    function Get_Driver: WideString;
    function Get_StringConexion: WideString;
    function Get_NombreArchivoDefault: WideString;
    function Get_Generadores: IXMLGeneradoresType;
    function Get_Entidades: IXMLEntidadesType;
    function Get_Listas: IXMLListasType;
    procedure Set_Driver(Value: WideString);
    procedure Set_StringConexion(Value: WideString);
    procedure Set_NombreArchivoDefault(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLGeneradoresType }

  TXMLGeneradoresType = class(TXMLNodeCollection, IXMLGeneradoresType)
  protected
    { IXMLGeneradoresType }
    function Get_Generador(Index: Integer): IXMLGeneradorType;
    function Add: IXMLGeneradorType;
    function Insert(const Index: Integer): IXMLGeneradorType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLGeneradorType }

  TXMLGeneradorType = class(TXMLNode, IXMLGeneradorType)
  protected
    { IXMLGeneradorType }
    function Get_Nombre: WideString;
    procedure Set_Nombre(Value: WideString);
  end;

{ TXMLEntidadesType }

  TXMLEntidadesType = class(TXMLNodeCollection, IXMLEntidadesType)
  protected
    { IXMLEntidadesType }
    function Get_Entidad(Index: Integer): IXMLEntidadType;
    function Add: IXMLEntidadType;
    function Insert(const Index: Integer): IXMLEntidadType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEntidadType }

  TXMLEntidadType = class(TXMLNode, IXMLEntidadType)
  protected
    { IXMLEntidadType }
    function Get_Nombre: WideString;
    function Get_TieneGenerador: Boolean;
    function Get_NombreGenerador: WideString;
    function Get_Alias: WideString;
    function Get_Campos: IXMLCamposType;
    function Get_Relacion1a1: IXMLForeignkeysType;
    function Get_Relacion1an: IXMLForeignkeysType;
    procedure Set_Nombre(Value: WideString);
    procedure Set_TieneGenerador(Value: Boolean);
    procedure Set_NombreGenerador(Value: WideString);
    procedure Set_Alias(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCamposType }

  TXMLCamposType = class(TXMLNodeCollection, IXMLCamposType)
  protected
    { IXMLCamposType }
    function Get_Campo(Index: Integer): IXMLCampoType;
    function Add: IXMLCampoType;
    function Insert(const Index: Integer): IXMLCampoType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCampoType }

  TXMLCampoType = class(TXMLNode, IXMLCampoType)
  protected
    { IXMLCampoType }
    function Get_Nombre: WideString;
    function Get_Alias: WideString;
    function Get_Tipo: WideString;
    function Get_SubTipo: WideString;
    function Get_Longitud: Integer;
    function Get_Precision: Integer;
    function Get_Escala: Integer;
    function Get_AceptaNull: Boolean;
    function Get_EsClavePrimaria: Boolean;
    function Get_EsClaveForanea: Boolean;
    function Get_FuncionAgregacion: Integer;
    function Get_ValorDefault: Variant;
    procedure Set_Nombre(Value: WideString);
    procedure Set_Alias(Value: WideString);
    procedure Set_Tipo(Value: WideString);
    procedure Set_SubTipo(Value: WideString);
    procedure Set_Longitud(Value: Integer);
    procedure Set_Precision(Value: Integer);
    procedure Set_Escala(Value: Integer);
    procedure Set_AceptaNull(Value: Boolean);
    procedure Set_EsClavePrimaria(Value: Boolean);
    procedure Set_EsClaveForanea(Value: Boolean);
    procedure Set_FuncionAgregacion(Value: Integer);
    procedure Set_ValorDefault(Value: Variant);
  end;

{ TXMLForeignkeysType }

  TXMLForeignkeysType = class(TXMLNodeCollection, IXMLForeignkeysType)
  protected
    { IXMLForeignkeysType }
    function Get_Foreignkey(Index: Integer): IXMLForeignkeyType;
    function Add: IXMLForeignkeyType;
    function Insert(const Index: Integer): IXMLForeignkeyType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLForeignkeyType }

  TXMLForeignkeyType = class(TXMLNode, IXMLForeignkeyType)
  protected
    { IXMLForeignkeyType }
    function Get_TablaRelacionada: WideString;
    function Get_NombreRelacion: WideString;
    function Get_NombreRelacionAMuchos: WideString;
    function Get_Origen: IXMLOrigenType;
    function Get_Destino: IXMLDestinoType;
    procedure Set_TablaRelacionada(Value: WideString);
    procedure Set_NombreRelacion(Value: WideString);
    procedure Set_NombreRelacionAMuchos(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLForeignkeyTypeList }

  TXMLForeignkeyTypeList = class(TXMLNodeCollection, IXMLForeignkeyTypeList)
  protected
    { IXMLForeignkeyTypeList }
    function Add: IXMLForeignkeyType;
    function Insert(const Index: Integer): IXMLForeignkeyType;
    function Get_Item(Index: Integer): IXMLForeignkeyType;
  end;

{ TXMLOrigenType }

  TXMLOrigenType = class(TXMLNodeCollection, IXMLOrigenType)
  protected
    { IXMLOrigenType }
    function Get_CampoRed(Index: Integer): IXMLCampoRedType;
    function Add: IXMLCampoRedType;
    function Insert(const Index: Integer): IXMLCampoRedType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCampoRedType }

  TXMLCampoRedType = class(TXMLNode, IXMLCampoRedType)
  protected
    { IXMLCampoRedType }
    function Get_Tabla: WideString;
    function Get_Nombre: WideString;
    procedure Set_Tabla(Value: WideString);
    procedure Set_Nombre(Value: WideString);
  end;

{ TXMLDestinoType }

  TXMLDestinoType = class(TXMLNodeCollection, IXMLDestinoType)
  protected
    { IXMLDestinoType }
    function Get_CampoRed(Index: Integer): IXMLCampoRedType;
    function Add: IXMLCampoRedType;
    function Insert(const Index: Integer): IXMLCampoRedType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLListasType }

  TXMLListasType = class(TXMLNodeCollection, IXMLListasType)
  protected
    { IXMLListasType }
    function Get_Lista(Index: Integer): IXMLListaType;
    function Add: IXMLListaType;
    function Insert(const Index: Integer): IXMLListaType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLListaType }

  TXMLListaType = class(TXMLNode, IXMLListaType)
  protected
    { IXMLListaType }
    function Get_Nombre: WideString;
    function Get_Entidades: IXMLEntidadesType;
    function Get_Relaciones: IXMLRelacionesType;
    procedure Set_Nombre(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLListaTypeList }

  TXMLListaTypeList = class(TXMLNodeCollection, IXMLListaTypeList)
  protected
    { IXMLListaTypeList }
    function Add: IXMLListaType;
    function Insert(const Index: Integer): IXMLListaType;
    function Get_Item(Index: Integer): IXMLListaType;
  end;

{ TXMLRelacionesType }

  TXMLRelacionesType = class(TXMLNodeCollection, IXMLRelacionesType)
  protected
    { IXMLRelacionesType }
    function Get_Relacion(Index: Integer): IXMLRelacionType;
    function Add: IXMLRelacionType;
    function Insert(const Index: Integer): IXMLRelacionType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRelacionType }

  TXMLRelacionType = class(TXMLNode, IXMLRelacionType)
  protected
    { IXMLRelacionType }
    function Get_TablaOrigen: WideString;
    function Get_TablaDestino: WideString;
    function Get_NombreRelacion: WideString;
    function Get_NombreRelacionAMuchos: WideString;
    function Get_TipoRelacion: WideString;
    procedure Set_TablaOrigen(Value: WideString);
    procedure Set_TablaDestino(Value: WideString);
    procedure Set_NombreRelacion(Value: WideString);
    procedure Set_NombreRelacionAMuchos(Value: WideString);
    procedure Set_TipoRelacion(Value: WideString);
  end;

{ TXMLRelacionTypeList }

  TXMLRelacionTypeList = class(TXMLNodeCollection, IXMLRelacionTypeList)
  protected
    { IXMLRelacionTypeList }
    function Add: IXMLRelacionType;
    function Insert(const Index: Integer): IXMLRelacionType;
    function Get_Item(Index: Integer): IXMLRelacionType;
  end;

{ Global Functions }

function GetORMEntidades(Doc: IXMLDocument): IXMLORMEntidadesType;
function LoadORMEntidades(const FileName: WideString): IXMLORMEntidadesType;
function NewORMEntidades: IXMLORMEntidadesType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetORMEntidades(Doc: IXMLDocument): IXMLORMEntidadesType;
begin
  Result := Doc.GetDocBinding('ORMEntidades', TXMLORMEntidadesType, TargetNamespace) as IXMLORMEntidadesType;
end;

function LoadORMEntidades(const FileName: WideString): IXMLORMEntidadesType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('ORMEntidades', TXMLORMEntidadesType, TargetNamespace) as IXMLORMEntidadesType;
end;

function NewORMEntidades: IXMLORMEntidadesType;
begin
  Result := NewXMLDocument.GetDocBinding('ORMEntidades', TXMLORMEntidadesType, TargetNamespace) as IXMLORMEntidadesType;
end;

{ TXMLORMEntidadesType }

procedure TXMLORMEntidadesType.AfterConstruction;
begin
  RegisterChildNode('Generadores', TXMLGeneradoresType);
  RegisterChildNode('Entidades', TXMLEntidadesType);
  RegisterChildNode('Listas', TXMLListasType);
  inherited;
end;

function TXMLORMEntidadesType.Get_Driver: WideString;
begin
  Result := AttributeNodes['Driver'].Text;
end;

procedure TXMLORMEntidadesType.Set_Driver(Value: WideString);
begin
  SetAttribute('Driver', Value);
end;

function TXMLORMEntidadesType.Get_StringConexion: WideString;
begin
  Result := AttributeNodes['StringConexion'].Text;
end;

procedure TXMLORMEntidadesType.Set_StringConexion(Value: WideString);
begin
  SetAttribute('StringConexion', Value);
end;

function TXMLORMEntidadesType.Get_NombreArchivoDefault: WideString;
begin
  Result := AttributeNodes['NombreArchivoDefault'].Text;
end;

procedure TXMLORMEntidadesType.Set_NombreArchivoDefault(Value: WideString);
begin
  SetAttribute('NombreArchivoDefault', Value);
end;

function TXMLORMEntidadesType.Get_Generadores: IXMLGeneradoresType;
begin
  Result := ChildNodes['Generadores'] as IXMLGeneradoresType;
end;

function TXMLORMEntidadesType.Get_Entidades: IXMLEntidadesType;
begin
  Result := ChildNodes['Entidades'] as IXMLEntidadesType;
end;

function TXMLORMEntidadesType.Get_Listas: IXMLListasType;
begin
  Result := ChildNodes['Listas'] as IXMLListasType;
end;

{ TXMLGeneradoresType }

procedure TXMLGeneradoresType.AfterConstruction;
begin
  RegisterChildNode('Generador', TXMLGeneradorType);
  ItemTag := 'Generador';
  ItemInterface := IXMLGeneradorType;
  inherited;
end;

function TXMLGeneradoresType.Get_Generador(Index: Integer): IXMLGeneradorType;
begin
  Result := List[Index] as IXMLGeneradorType;
end;

function TXMLGeneradoresType.Add: IXMLGeneradorType;
begin
  Result := AddItem(-1) as IXMLGeneradorType;
end;

function TXMLGeneradoresType.Insert(const Index: Integer): IXMLGeneradorType;
begin
  Result := AddItem(Index) as IXMLGeneradorType;
end;

{ TXMLGeneradorType }

function TXMLGeneradorType.Get_Nombre: WideString;
begin
  Result := AttributeNodes['Nombre'].Text;
end;

procedure TXMLGeneradorType.Set_Nombre(Value: WideString);
begin
  SetAttribute('Nombre', Value);
end;

{ TXMLEntidadesType }

procedure TXMLEntidadesType.AfterConstruction;
begin
  RegisterChildNode('Entidad', TXMLEntidadType);
  ItemTag := 'Entidad';
  ItemInterface := IXMLEntidadType;
  inherited;
end;

function TXMLEntidadesType.Get_Entidad(Index: Integer): IXMLEntidadType;
begin
  Result := List[Index] as IXMLEntidadType;
end;

function TXMLEntidadesType.Add: IXMLEntidadType;
begin
  Result := AddItem(-1) as IXMLEntidadType;
end;

function TXMLEntidadesType.Insert(const Index: Integer): IXMLEntidadType;
begin
  Result := AddItem(Index) as IXMLEntidadType;
end;

{ TXMLEntidadType }

procedure TXMLEntidadType.AfterConstruction;
begin
  RegisterChildNode('Campos', TXMLCamposType);
  RegisterChildNode('Relacion1a1', TXMLForeignkeysType);
  RegisterChildNode('Relacion1an', TXMLForeignkeysType);
  inherited;
end;

function TXMLEntidadType.Get_Nombre: WideString;
begin
  Result := AttributeNodes['Nombre'].Text;
end;

procedure TXMLEntidadType.Set_Nombre(Value: WideString);
begin
  SetAttribute('Nombre', Value);
end;

function TXMLEntidadType.Get_TieneGenerador: Boolean;
begin
  Result := AttributeNodes['TieneGenerador'].NodeValue;
end;

procedure TXMLEntidadType.Set_TieneGenerador(Value: Boolean);
begin
  SetAttribute('TieneGenerador', Value);
end;

function TXMLEntidadType.Get_NombreGenerador: WideString;
begin
  Result := AttributeNodes['NombreGenerador'].Text;
end;

procedure TXMLEntidadType.Set_NombreGenerador(Value: WideString);
begin
  SetAttribute('NombreGenerador', Value);
end;

function TXMLEntidadType.Get_Alias: WideString;
begin
  Result := AttributeNodes['Alias'].Text;
end;

procedure TXMLEntidadType.Set_Alias(Value: WideString);
begin
  SetAttribute('Alias', Value);
end;

function TXMLEntidadType.Get_Campos: IXMLCamposType;
begin
  Result := ChildNodes['Campos'] as IXMLCamposType;
end;

function TXMLEntidadType.Get_Relacion1a1: IXMLForeignkeysType;
begin
  Result := ChildNodes['Relacion1a1'] as IXMLForeignkeysType;
end;

function TXMLEntidadType.Get_Relacion1an: IXMLForeignkeysType;
begin
  Result := ChildNodes['Relacion1an'] as IXMLForeignkeysType;
end;

{ TXMLCamposType }

procedure TXMLCamposType.AfterConstruction;
begin
  RegisterChildNode('Campo', TXMLCampoType);
  ItemTag := 'Campo';
  ItemInterface := IXMLCampoType;
  inherited;
end;

function TXMLCamposType.Get_Campo(Index: Integer): IXMLCampoType;
begin
  Result := List[Index] as IXMLCampoType;
end;

function TXMLCamposType.Add: IXMLCampoType;
begin
  Result := AddItem(-1) as IXMLCampoType;
end;

function TXMLCamposType.Insert(const Index: Integer): IXMLCampoType;
begin
  Result := AddItem(Index) as IXMLCampoType;
end;

{ TXMLCampoType }

function TXMLCampoType.Get_Nombre: WideString;
begin
  Result := AttributeNodes['Nombre'].Text;
end;

procedure TXMLCampoType.Set_Nombre(Value: WideString);
begin
  SetAttribute('Nombre', Value);
end;

function TXMLCampoType.Get_Alias: WideString;
begin
  Result := AttributeNodes['Alias'].Text;
end;

procedure TXMLCampoType.Set_Alias(Value: WideString);
begin
  SetAttribute('Alias', Value);
end;

function TXMLCampoType.Get_Tipo: WideString;
begin
  Result := AttributeNodes['Tipo'].Text;
end;

procedure TXMLCampoType.Set_Tipo(Value: WideString);
begin
  SetAttribute('Tipo', Value);
end;

function TXMLCampoType.Get_SubTipo: WideString;
begin
  Result := AttributeNodes['SubTipo'].Text;
end;

procedure TXMLCampoType.Set_SubTipo(Value: WideString);
begin
  SetAttribute('SubTipo', Value);
end;

function TXMLCampoType.Get_Longitud: Integer;
begin
  Result := AttributeNodes['Longitud'].NodeValue;
end;

procedure TXMLCampoType.Set_Longitud(Value: Integer);
begin
  SetAttribute('Longitud', Value);
end;

function TXMLCampoType.Get_Precision: Integer;
begin
  if VarIsNull(AttributeNodes['Precision'].NodeValue)  then
    Result := 0
  else
    Result := AttributeNodes['Precision'].NodeValue;
end;

procedure TXMLCampoType.Set_Precision(Value: Integer);
begin
  SetAttribute('Precision', Value);
end;

function TXMLCampoType.Get_Escala: Integer;
begin
  if VarIsNull(AttributeNodes['Escala'].NodeValue)  then
    Result := 0
  else
    Result := AttributeNodes['Escala'].NodeValue;
end;

procedure TXMLCampoType.Set_Escala(Value: Integer);
begin
  SetAttribute('Escala', Value);
end;

function TXMLCampoType.Get_AceptaNull: Boolean;
begin
  Result := AttributeNodes['AceptaNull'].NodeValue;
end;

procedure TXMLCampoType.Set_AceptaNull(Value: Boolean);
begin
  SetAttribute('AceptaNull', Value);
end;

function TXMLCampoType.Get_EsClavePrimaria: Boolean;
begin
  Result := AttributeNodes['EsClavePrimaria'].NodeValue;
end;

procedure TXMLCampoType.Set_EsClavePrimaria(Value: Boolean);
begin
  SetAttribute('EsClavePrimaria', Value);
end;

function TXMLCampoType.Get_EsClaveForanea: Boolean;
begin
  Result := AttributeNodes['EsClaveForanea'].NodeValue;
end;

procedure TXMLCampoType.Set_EsClaveForanea(Value: Boolean);
begin
  SetAttribute('EsClaveForanea', Value);
end;

function TXMLCampoType.Get_FuncionAgregacion: Integer;
begin
  Result := AttributeNodes['FuncionAgregacion'].NodeValue;
end;

procedure TXMLCampoType.Set_FuncionAgregacion(Value: Integer);
begin
  SetAttribute('FuncionAgregacion', Value);
end;

function TXMLCampoType.Get_ValorDefault: Variant;
begin
  Result := AttributeNodes['ValorDefault'].NodeValue;
end;

procedure TXMLCampoType.Set_ValorDefault(Value: Variant);
begin
  SetAttribute('ValorDefault', Value);
end;

{ TXMLForeignkeysType }

procedure TXMLForeignkeysType.AfterConstruction;
begin
  RegisterChildNode('Foreignkey', TXMLForeignkeyType);
  ItemTag := 'Foreignkey';
  ItemInterface := IXMLForeignkeyType;
  inherited;
end;

function TXMLForeignkeysType.Get_Foreignkey(Index: Integer): IXMLForeignkeyType;
begin
  Result := List[Index] as IXMLForeignkeyType;
end;

function TXMLForeignkeysType.Add: IXMLForeignkeyType;
begin
  Result := AddItem(-1) as IXMLForeignkeyType;
end;

function TXMLForeignkeysType.Insert(const Index: Integer): IXMLForeignkeyType;
begin
  Result := AddItem(Index) as IXMLForeignkeyType;
end;

{ TXMLForeignkeyType }

procedure TXMLForeignkeyType.AfterConstruction;
begin
  RegisterChildNode('Origen', TXMLOrigenType);
  RegisterChildNode('Destino', TXMLDestinoType);
  inherited;
end;

function TXMLForeignkeyType.Get_TablaRelacionada: WideString;
begin
  Result := AttributeNodes['TablaRelacionada'].Text;
end;

procedure TXMLForeignkeyType.Set_TablaRelacionada(Value: WideString);
begin
  SetAttribute('TablaRelacionada', Value);
end;

function TXMLForeignkeyType.Get_NombreRelacion: WideString;
begin
  Result := AttributeNodes['NombreRelacion'].Text;
end;

procedure TXMLForeignkeyType.Set_NombreRelacion(Value: WideString);
begin
  SetAttribute('NombreRelacion', Value);
end;

function TXMLForeignkeyType.Get_NombreRelacionAMuchos: WideString;
begin
  Result := AttributeNodes['NombreRelacionAMuchos'].Text;
end;

procedure TXMLForeignkeyType.Set_NombreRelacionAMuchos(Value: WideString);
begin
  SetAttribute('NombreRelacionAMuchos', Value);
end;

function TXMLForeignkeyType.Get_Origen: IXMLOrigenType;
begin
  Result := ChildNodes['Origen'] as IXMLOrigenType;
end;

function TXMLForeignkeyType.Get_Destino: IXMLDestinoType;
begin
  Result := ChildNodes['Destino'] as IXMLDestinoType;
end;

{ TXMLForeignkeyTypeList }

function TXMLForeignkeyTypeList.Add: IXMLForeignkeyType;
begin
  Result := AddItem(-1) as IXMLForeignkeyType;
end;

function TXMLForeignkeyTypeList.Insert(const Index: Integer): IXMLForeignkeyType;
begin
  Result := AddItem(Index) as IXMLForeignkeyType;
end;
function TXMLForeignkeyTypeList.Get_Item(Index: Integer): IXMLForeignkeyType;
begin
  Result := List[Index] as IXMLForeignkeyType;
end;

{ TXMLOrigenType }

procedure TXMLOrigenType.AfterConstruction;
begin
  RegisterChildNode('CampoRed', TXMLCampoRedType);
  ItemTag := 'CampoRed';
  ItemInterface := IXMLCampoRedType;
  inherited;
end;

function TXMLOrigenType.Get_CampoRed(Index: Integer): IXMLCampoRedType;
begin
  Result := List[Index] as IXMLCampoRedType;
end;

function TXMLOrigenType.Add: IXMLCampoRedType;
begin
  Result := AddItem(-1) as IXMLCampoRedType;
end;

function TXMLOrigenType.Insert(const Index: Integer): IXMLCampoRedType;
begin
  Result := AddItem(Index) as IXMLCampoRedType;
end;

{ TXMLCampoRedType }

function TXMLCampoRedType.Get_Tabla: WideString;
begin
  Result := AttributeNodes['Tabla'].Text;
end;

procedure TXMLCampoRedType.Set_Tabla(Value: WideString);
begin
  SetAttribute('Tabla', Value);
end;

function TXMLCampoRedType.Get_Nombre: WideString;
begin
  Result := AttributeNodes['Nombre'].Text;
end;

procedure TXMLCampoRedType.Set_Nombre(Value: WideString);
begin
  SetAttribute('Nombre', Value);
end;

{ TXMLDestinoType }

procedure TXMLDestinoType.AfterConstruction;
begin
  RegisterChildNode('CampoRed', TXMLCampoRedType);
  ItemTag := 'CampoRed';
  ItemInterface := IXMLCampoRedType;
  inherited;
end;

function TXMLDestinoType.Get_CampoRed(Index: Integer): IXMLCampoRedType;
begin
  Result := List[Index] as IXMLCampoRedType;
end;

function TXMLDestinoType.Add: IXMLCampoRedType;
begin
  Result := AddItem(-1) as IXMLCampoRedType;
end;

function TXMLDestinoType.Insert(const Index: Integer): IXMLCampoRedType;
begin
  Result := AddItem(Index) as IXMLCampoRedType;
end;

{ TXMLListasType }

procedure TXMLListasType.AfterConstruction;
begin
  RegisterChildNode('Lista', TXMLListaType);
  ItemTag := 'Lista';
  ItemInterface := IXMLListaType;
  inherited;
end;

function TXMLListasType.Get_Lista(Index: Integer): IXMLListaType;
begin
  Result := List[Index] as IXMLListaType;
end;

function TXMLListasType.Add: IXMLListaType;
begin
  Result := AddItem(-1) as IXMLListaType;
end;

function TXMLListasType.Insert(const Index: Integer): IXMLListaType;
begin
  Result := AddItem(Index) as IXMLListaType;
end;

{ TXMLListaType }

procedure TXMLListaType.AfterConstruction;
begin
  RegisterChildNode('Entidades', TXMLEntidadesType);
  RegisterChildNode('Relaciones', TXMLRelacionesType);
  inherited;
end;

function TXMLListaType.Get_Nombre: WideString;
begin
  Result := AttributeNodes['Nombre'].Text;
end;

procedure TXMLListaType.Set_Nombre(Value: WideString);
begin
  SetAttribute('Nombre', Value);
end;

function TXMLListaType.Get_Entidades: IXMLEntidadesType;
begin
  Result := ChildNodes['Entidades'] as IXMLEntidadesType;
end;

function TXMLListaType.Get_Relaciones: IXMLRelacionesType;
begin
  Result := ChildNodes['Relaciones'] as IXMLRelacionesType;
end;

{ TXMLListaTypeList }

function TXMLListaTypeList.Add: IXMLListaType;
begin
  Result := AddItem(-1) as IXMLListaType;
end;

function TXMLListaTypeList.Insert(const Index: Integer): IXMLListaType;
begin
  Result := AddItem(Index) as IXMLListaType;
end;
function TXMLListaTypeList.Get_Item(Index: Integer): IXMLListaType;
begin
  Result := List[Index] as IXMLListaType;
end;

{ TXMLRelacionesType }

procedure TXMLRelacionesType.AfterConstruction;
begin
  RegisterChildNode('Relacion', TXMLRelacionType);
  ItemTag := 'Relacion';
  ItemInterface := IXMLRelacionType;
  inherited;
end;

function TXMLRelacionesType.Get_Relacion(Index: Integer): IXMLRelacionType;
begin
  Result := List[Index] as IXMLRelacionType;
end;

function TXMLRelacionesType.Add: IXMLRelacionType;
begin
  Result := AddItem(-1) as IXMLRelacionType;
end;

function TXMLRelacionesType.Insert(const Index: Integer): IXMLRelacionType;
begin
  Result := AddItem(Index) as IXMLRelacionType;
end;

{ TXMLRelacionType }

function TXMLRelacionType.Get_TablaOrigen: WideString;
begin
  Result := AttributeNodes['TablaOrigen'].Text;
end;

procedure TXMLRelacionType.Set_TablaOrigen(Value: WideString);
begin
  SetAttribute('TablaOrigen', Value);
end;

function TXMLRelacionType.Get_TablaDestino: WideString;
begin
  Result := AttributeNodes['TablaDestino'].Text;
end;

procedure TXMLRelacionType.Set_TablaDestino(Value: WideString);
begin
  SetAttribute('TablaDestino', Value);
end;

function TXMLRelacionType.Get_NombreRelacion: WideString;
begin
  Result := AttributeNodes['NombreRelacion'].Text;
end;

procedure TXMLRelacionType.Set_NombreRelacion(Value: WideString);
begin
  SetAttribute('NombreRelacion', Value);
end;

function TXMLRelacionType.Get_NombreRelacionAMuchos: WideString;
begin
  Result := AttributeNodes['NombreRelacionAMuchos'].Text;
end;

procedure TXMLRelacionType.Set_NombreRelacionAMuchos(Value: WideString);
begin
  SetAttribute('NombreRelacionAMuchos', Value);
end;

function TXMLRelacionType.Get_TipoRelacion: WideString;
begin
  Result := AttributeNodes['TipoRelacion'].Text;
end;

procedure TXMLRelacionType.Set_TipoRelacion(Value: WideString);
begin
  SetAttribute('TipoRelacion', Value);
end;

{ TXMLRelacionTypeList }

function TXMLRelacionTypeList.Add: IXMLRelacionType;
begin
  Result := AddItem(-1) as IXMLRelacionType;
end;

function TXMLRelacionTypeList.Insert(const Index: Integer): IXMLRelacionType;
begin
  Result := AddItem(Index) as IXMLRelacionType;
end;
function TXMLRelacionTypeList.Get_Item(Index: Integer): IXMLRelacionType;
begin
  Result := List[Index] as IXMLRelacionType;
end;

end.
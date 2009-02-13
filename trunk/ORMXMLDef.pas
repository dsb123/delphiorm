
{***********************************************************************}
{                                                                       }
{                           XML Data Binding                            }
{                                                                       }
{         Generated on: 09/01/2009 11:51:24                             }
{       Generated from: C:\Desarrollos\Delphi\DelphiORM\ORMXMLDef.xdb   }
{   Settings stored in: C:\Desarrollos\Delphi\DelphiORM\ORMXMLDef.xdb   }
{                                                                       }
{***********************************************************************}

unit ORMXMLDef;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLORMEntidadesType = interface;
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
    ['{5C6EE265-BAE3-4A76-BA6F-BA143644F7C6}']
    { Property Accessors }
    function Get_Driver: WideString;
    function Get_StringConexion: WideString;
    function Get_Entidades: IXMLEntidadesType;
    function Get_Listas: IXMLListasType;
    procedure Set_Driver(Value: WideString);
    procedure Set_StringConexion(Value: WideString);
    { Methods & Properties }
    property Driver: WideString read Get_Driver write Set_Driver;
    property StringConexion: WideString read Get_StringConexion write Set_StringConexion;
    property Entidades: IXMLEntidadesType read Get_Entidades;
    property Listas: IXMLListasType read Get_Listas;
  end;

{ IXMLEntidadesType }

  IXMLEntidadesType = interface(IXMLNodeCollection)
    ['{8B321C78-FBB5-4A8F-8A64-A2D69A5FF249}']
    { Property Accessors }
    function Get_Entidad(Index: Integer): IXMLEntidadType;
    { Methods & Properties }
    function Add: IXMLEntidadType;
    function Insert(const Index: Integer): IXMLEntidadType;
    property Entidad[Index: Integer]: IXMLEntidadType read Get_Entidad; default;
  end;

{ IXMLEntidadType }

  IXMLEntidadType = interface(IXMLNode)
    ['{2AE74EDC-AE1C-4E46-AC6C-99DA64D5C200}']
    { Property Accessors }
    function Get_Nombre: WideString;
    function Get_TieneGenerador: Boolean;
    function Get_Alias: WideString;
    function Get_Campos: IXMLCamposType;
    function Get_Relacion1a1: IXMLForeignkeysType;
    function Get_Relacion1an: IXMLForeignkeysType;
    procedure Set_Nombre(Value: WideString);
    procedure Set_TieneGenerador(Value: Boolean);
    procedure Set_Alias(Value: WideString);
    { Methods & Properties }
    property Nombre: WideString read Get_Nombre write Set_Nombre;
    property TieneGenerador: Boolean read Get_TieneGenerador write Set_TieneGenerador;
    property Alias: WideString read Get_Alias write Set_Alias;
    property Campos: IXMLCamposType read Get_Campos;
    property Relacion1a1: IXMLForeignkeysType read Get_Relacion1a1;
    property Relacion1an: IXMLForeignkeysType read Get_Relacion1an;
  end;

{ IXMLCamposType }

  IXMLCamposType = interface(IXMLNodeCollection)
    ['{050609D8-8C09-4BE2-B856-5CE5C4188704}']
    { Property Accessors }
    function Get_Campo(Index: Integer): IXMLCampoType;
    { Methods & Properties }
    function Add: IXMLCampoType;
    function Insert(const Index: Integer): IXMLCampoType;
    property Campo[Index: Integer]: IXMLCampoType read Get_Campo; default;
  end;

{ IXMLCampoType }

  IXMLCampoType = interface(IXMLNode)
    ['{4CA3B7E3-D0E2-45B6-A14F-DD4E4B2F3DFA}']
    { Property Accessors }
    function Get_Nombre: WideString;
    function Get_Alias: WideString;
    function Get_Tipo: WideString;
    function Get_SubTipo: WideString;
    function Get_Longitud: Integer;
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
    property AceptaNull: Boolean read Get_AceptaNull write Set_AceptaNull;
    property EsClavePrimaria: Boolean read Get_EsClavePrimaria write Set_EsClavePrimaria;
    property EsClaveForanea: Boolean read Get_EsClaveForanea write Set_EsClaveForanea;
    property FuncionAgregacion: Integer read Get_FuncionAgregacion write Set_FuncionAgregacion;
    property ValorDefault: Variant read Get_ValorDefault write Set_ValorDefault;
  end;

{ IXMLForeignkeysType }

  IXMLForeignkeysType = interface(IXMLNodeCollection)
    ['{7E8B9273-F505-41BB-89C8-A91C3C4C80F6}']
    { Property Accessors }
    function Get_Foreignkey(Index: Integer): IXMLForeignkeyType;
    { Methods & Properties }
    function Add: IXMLForeignkeyType;
    function Insert(const Index: Integer): IXMLForeignkeyType;
    property Foreignkey[Index: Integer]: IXMLForeignkeyType read Get_Foreignkey; default;
  end;

{ IXMLForeignkeyType }

  IXMLForeignkeyType = interface(IXMLNode)
    ['{7341357C-5069-478D-A3AE-3378F654D61F}']
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
    ['{175E74FE-B971-4A73-BC58-60081AFEC836}']
    { Methods & Properties }
    function Add: IXMLForeignkeyType;
    function Insert(const Index: Integer): IXMLForeignkeyType;
    function Get_Item(Index: Integer): IXMLForeignkeyType;
    property Items[Index: Integer]: IXMLForeignkeyType read Get_Item; default;
  end;

{ IXMLOrigenType }

  IXMLOrigenType = interface(IXMLNodeCollection)
    ['{29EB2AA5-0C3C-4A96-A10A-5508CC1CCDE8}']
    { Property Accessors }
    function Get_CampoRed(Index: Integer): IXMLCampoRedType;
    { Methods & Properties }
    function Add: IXMLCampoRedType;
    function Insert(const Index: Integer): IXMLCampoRedType;
    property CampoRed[Index: Integer]: IXMLCampoRedType read Get_CampoRed; default;
  end;

{ IXMLCampoRedType }

  IXMLCampoRedType = interface(IXMLNode)
    ['{CD708990-5C4A-467C-9ADA-36EA292B535A}']
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
    ['{18CFEAD8-AC3F-490E-B650-EAC409DB6445}']
    { Property Accessors }
    function Get_CampoRed(Index: Integer): IXMLCampoRedType;
    { Methods & Properties }
    function Add: IXMLCampoRedType;
    function Insert(const Index: Integer): IXMLCampoRedType;
    property CampoRed[Index: Integer]: IXMLCampoRedType read Get_CampoRed; default;
  end;

{ IXMLListasType }

  IXMLListasType = interface(IXMLNodeCollection)
    ['{B12D3379-5BAD-42A6-B24C-73A8A86A1A62}']
    { Property Accessors }
    function Get_Lista(Index: Integer): IXMLListaType;
    { Methods & Properties }
    function Add: IXMLListaType;
    function Insert(const Index: Integer): IXMLListaType;
    property Lista[Index: Integer]: IXMLListaType read Get_Lista; default;
  end;

{ IXMLListaType }

  IXMLListaType = interface(IXMLNode)
    ['{349904A3-1342-4E52-8D54-35CE7FE8B1E6}']
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
    ['{6F7CF203-A0B6-47D8-9E66-63A07311E9F4}']
    { Methods & Properties }
    function Add: IXMLListaType;
    function Insert(const Index: Integer): IXMLListaType;
    function Get_Item(Index: Integer): IXMLListaType;
    property Items[Index: Integer]: IXMLListaType read Get_Item; default;
  end;

{ IXMLRelacionesType }

  IXMLRelacionesType = interface(IXMLNodeCollection)
    ['{7D447239-4CEE-454B-9667-3B7BC77C0F7C}']
    { Property Accessors }
    function Get_Relacion(Index: Integer): IXMLRelacionType;
    { Methods & Properties }
    function Add: IXMLRelacionType;
    function Insert(const Index: Integer): IXMLRelacionType;
    property Relacion[Index: Integer]: IXMLRelacionType read Get_Relacion; default;
  end;

{ IXMLRelacionType }

  IXMLRelacionType = interface(IXMLNode)
    ['{1E9539E2-1BAB-4EEF-BFEC-286AA71D8EE0}']
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
    ['{3098C336-50BC-45F8-BFC5-46956095DFA9}']
    { Methods & Properties }
    function Add: IXMLRelacionType;
    function Insert(const Index: Integer): IXMLRelacionType;
    function Get_Item(Index: Integer): IXMLRelacionType;
    property Items[Index: Integer]: IXMLRelacionType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLORMEntidadesType = class;
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
    function Get_Entidades: IXMLEntidadesType;
    function Get_Listas: IXMLListasType;
    procedure Set_Driver(Value: WideString);
    procedure Set_StringConexion(Value: WideString);
  public
    procedure AfterConstruction; override;
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
    function Get_Alias: WideString;
    function Get_Campos: IXMLCamposType;
    function Get_Relacion1a1: IXMLForeignkeysType;
    function Get_Relacion1an: IXMLForeignkeysType;
    procedure Set_Nombre(Value: WideString);
    procedure Set_TieneGenerador(Value: Boolean);
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

function TXMLORMEntidadesType.Get_Entidades: IXMLEntidadesType;
begin
  Result := ChildNodes['Entidades'] as IXMLEntidadesType;
end;

function TXMLORMEntidadesType.Get_Listas: IXMLListasType;
begin
  Result := ChildNodes['Listas'] as IXMLListasType;
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
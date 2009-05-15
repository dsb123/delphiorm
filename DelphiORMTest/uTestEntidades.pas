unit uTestEntidades;

interface

uses Classes, SysUtils, uEntidades, uColeccionEntidades, uCampos, uExpresiones,
	 uConexion, uSQLConnectionGenerator, uFBSQLStatementManager;

type

TIndiceDomicilio=class
const
	DomicilioID=0;
	TipoDomicilioID=1;
	PersonaID=2;
	Calle=3;
	Numero=4;
end;
TIndicePersona=class
const
	PerdonaID=0;
	Apellido=1;
	Nombre=2;
	TipoDocumentoID=3;
	NumeroDocumento=4;
end;
TIndiceTipoDocumento=class
const
	TipoDocumentoID=0;
	Descripcion=1;
	DescripcionReducida=2;
	Observaciones=3;
end;
TIndiceTipoDomicilio=class
const
	TipoDomicilioID=0;
	Descripcion=1;
	DescripcionReducida=2;
	Observaciones=3;
end;

TIndiceListaPersona=class
const
	PerdonaID=0;
	Apellido=1;
	Nombre=2;
	DescripcionTipoDocumento=3;
end;

TFabricaCampoDomicilio=class
public
	class function DomicilioID: TORMCampo;
	class function TipoDomicilioID: TORMCampo;
	class function PersonaID: TORMCampo;
	class function Calle: TORMCampo;
	class function Numero: TORMCampo;
end;
TFabricaCampoPersona=class
public
	class function PerdonaID: TORMCampo;
	class function Apellido: TORMCampo;
	class function Nombre: TORMCampo;
	class function TipoDocumentoID: TORMCampo;
	class function NumeroDocumento: TORMCampo;
end;
TFabricaCampoTipoDocumento=class
public
	class function TipoDocumentoID: TORMCampo;
	class function Descripcion: TORMCampo;
	class function DescripcionReducida: TORMCampo;
	class function Observaciones: TORMCampo;
end;
TFabricaCampoTipoDomicilio=class
public
	class function TipoDomicilioID: TORMCampo;
	class function Descripcion: TORMCampo;
	class function DescripcionReducida: TORMCampo;
	class function Observaciones: TORMCampo;
end;

TFabricauTestEntidades=class
public
	class function CrearNuevaEntidadConexion(ConexionPublica: boolean = false): TORMEntidadConexion;
end;
TRelacionesDomicilio=class
public
	{Relaciones 1 a 1}
	class function TipoDomicilio(TipoRelacion: TORMTipoRelacion=TrAmbas): TORMRelacion;
	class function Persona(TipoRelacion: TORMTipoRelacion=TrAmbas): TORMRelacion;
end;
TRelacionesPersona=class
public
	{Relaciones 1 a 1}
	class function TipoDocumento(TipoRelacion: TORMTipoRelacion=TrAmbas): TORMRelacion;
	{Relaciones 1 a n}
	class function Domicilio(TipoRelacion: TORMTipoRelacion = TrAmbas): TORMRelacion;
end;



TDomicilio=class;
TColeccionDomicilio=class;
TPersona=class;
TColeccionPersona=class;
TTipoDocumento=class;
TColeccionTipoDocumento=class;
TTipoDomicilio=class;
TColeccionTipoDomicilio=class;


TDomicilio=class(TORMEntidadBase)
private
	FTipoDomicilio: TTipoDomicilio;
	FPersona: TPersona;
	function GetDomicilioID: integer;
	procedure SetDomicilioID(const Value:integer);
	function GetTipoDomicilioID: integer;
	procedure SetTipoDomicilioID(const Value:integer);
	function GetPersonaID: integer;
	procedure SetPersonaID(const Value:integer);
	function GetCalle: string;
	procedure SetCalle(const Value:string);
	function GetNumero: integer;
	procedure SetNumero(const Value:integer);
	function GetTipoDomicilio: TTipoDomicilio;
	function GetPersona: TPersona;
public
	constructor Create(Coleccion: TCollection = nil; ComoEntidadNueva: boolean = true); overload;
	constructor Create(const DomicilioID: integer); overload;
	function ObtenerEntidad(const DomicilioID: integer): boolean;
	destructor Destroy; override;
	function CrearNuevaConexionEntidad: TORMEntidadConexion; override;
	function GetORMCampo(IndiceCampo: integer): TORMCampo;
	procedure LiberarTipoDomicilio;
	procedure LiberarPersona;
	function EsNuloDomicilioID: boolean;
	function EsNuloTipoDomicilioID: boolean;
	function EsNuloPersonaID: boolean;
	function EsNuloCalle: boolean;
	function EsNuloNumero: boolean;
	property TipoDomicilio: TTipoDomicilio read GetTipoDomicilio;
	property Persona: TPersona read GetPersona;
published
	property DomicilioID: integer read GetDomicilioID write SetDomicilioID;
	property TipoDomicilioID: integer read GetTipoDomicilioID write SetTipoDomicilioID;
	property PersonaID: integer read GetPersonaID write SetPersonaID;
	property Calle: string read GetCalle write SetCalle;
	property Numero: integer read GetNumero write SetNumero;
end;
TPersona=class(TORMEntidadBase)
private
	FTipoDocumento: TTipoDocumento;
	FColeccionDomicilio: TColeccionDomicilio;
	function GetPerdonaID: integer;
	procedure SetPerdonaID(const Value:integer);
	function GetApellido: string;
	procedure SetApellido(const Value:string);
	function GetNombre: string;
	procedure SetNombre(const Value:string);
	function GetTipoDocumentoID: integer;
	procedure SetTipoDocumentoID(const Value:integer);
	function GetNumeroDocumento: integer;
	procedure SetNumeroDocumento(const Value:integer);
	function GetTipoDocumento: TTipoDocumento;
	function GetColeccionDomicilio: TColeccionDomicilio;
public
	constructor Create(Coleccion: TCollection = nil; ComoEntidadNueva: boolean = true); overload;
	constructor Create(const PerdonaID: integer); overload;
	function ObtenerEntidad(const PerdonaID: integer): boolean;
	destructor Destroy; override;
	function CrearNuevaConexionEntidad: TORMEntidadConexion; override;
	function GetORMCampo(IndiceCampo: integer): TORMCampo;
	procedure LiberarTipoDocumento;
	function EsNuloPerdonaID: boolean;
	function EsNuloApellido: boolean;
	function EsNuloNombre: boolean;
	function EsNuloTipoDocumentoID: boolean;
	function EsNuloNumeroDocumento: boolean;
	property TipoDocumento: TTipoDocumento read GetTipoDocumento;
	property ColeccionDomicilio: TColeccionDomicilio read GetColeccionDomicilio;
published
	property PerdonaID: integer read GetPerdonaID write SetPerdonaID;
	property Apellido: string read GetApellido write SetApellido;
	property Nombre: string read GetNombre write SetNombre;
	property TipoDocumentoID: integer read GetTipoDocumentoID write SetTipoDocumentoID;
	property NumeroDocumento: integer read GetNumeroDocumento write SetNumeroDocumento;
end;
TTipoDocumento=class(TORMEntidadBase)
private
	FColeccionPersona: TColeccionPersona;
	function GetTipoDocumentoID: integer;
	procedure SetTipoDocumentoID(const Value:integer);
	function GetDescripcion: string;
	procedure SetDescripcion(const Value:string);
	function GetDescripcionReducida: string;
	procedure SetDescripcionReducida(const Value:string);
	function GetObservaciones: string;
	procedure SetObservaciones(const Value:string);
	function GetColeccionPersona: TColeccionPersona;
public
	constructor Create(Coleccion: TCollection = nil; ComoEntidadNueva: boolean = true); overload;
	constructor Create(const TipoDocumentoID: integer); overload;
	function ObtenerEntidad(const TipoDocumentoID: integer): boolean;
	destructor Destroy; override;
	function CrearNuevaConexionEntidad: TORMEntidadConexion; override;
	function GetORMCampo(IndiceCampo: integer): TORMCampo;
	function EsNuloTipoDocumentoID: boolean;
	function EsNuloDescripcion: boolean;
	function EsNuloDescripcionReducida: boolean;
	function EsNuloObservaciones: boolean;
	property ColeccionPersona: TColeccionPersona read GetColeccionPersona;
published
	property TipoDocumentoID: integer read GetTipoDocumentoID write SetTipoDocumentoID;
	property Descripcion: string read GetDescripcion write SetDescripcion;
	property DescripcionReducida: string read GetDescripcionReducida write SetDescripcionReducida;
	property Observaciones: string read GetObservaciones write SetObservaciones;
end;
TTipoDomicilio=class(TORMEntidadBase)
private
	FColeccionDomicilio: TColeccionDomicilio;
	function GetTipoDomicilioID: integer;
	procedure SetTipoDomicilioID(const Value:integer);
	function GetDescripcion: string;
	procedure SetDescripcion(const Value:string);
	function GetDescripcionReducida: string;
	procedure SetDescripcionReducida(const Value:string);
	function GetObservaciones: string;
	procedure SetObservaciones(const Value:string);
	function GetColeccionDomicilio: TColeccionDomicilio;
public
	constructor Create(Coleccion: TCollection = nil; ComoEntidadNueva: boolean = true); overload;
	constructor Create(const TipoDomicilioID: integer); overload;
	function ObtenerEntidad(const TipoDomicilioID: integer): boolean;
	destructor Destroy; override;
	function CrearNuevaConexionEntidad: TORMEntidadConexion; override;
	function GetORMCampo(IndiceCampo: integer): TORMCampo;
	function EsNuloTipoDomicilioID: boolean;
	function EsNuloDescripcion: boolean;
	function EsNuloDescripcionReducida: boolean;
	function EsNuloObservaciones: boolean;
	property ColeccionDomicilio: TColeccionDomicilio read GetColeccionDomicilio;
published
	property TipoDomicilioID: integer read GetTipoDomicilioID write SetTipoDomicilioID;
	property Descripcion: string read GetDescripcion write SetDescripcion;
	property DescripcionReducida: string read GetDescripcionReducida write SetDescripcionReducida;
	property Observaciones: string read GetObservaciones write SetObservaciones;
end;

TColeccionDomicilio=class(TORMColeccionEntidades)
private
	type
		TColeccionDomicilioEnumerador = record
		private
			nEntidad: integer;
			FColeccion : TColeccionDomicilio;
		public
			constructor Create(Coleccion: TColeccionDomicilio);
			function  GetCurrent: TDomicilio; inline;
			function  MoveNext: boolean;
			property Current: TDomicilio read GetCurrent;
		end;
private
	function GetDomicilio(index: integer): TDomicilio;
	function GetORMCampo(indiceCampo: integer): TORMCampo;
protected
	procedure ProcesarDataSet; override;
published
public
	constructor Create; overload;
	function CrearNuevaConexionEntidad: TORMEntidadConexion; override;
	function GetEnumerator: TColeccionDomicilioEnumerador;
	property Domicilio[index: integer]: TDomicilio read GetDomicilio; default;
	property ORMCampo[indiceCampo: integer]: TORMCampo read GetORMCampo;
end;
TColeccionPersona=class(TORMColeccionEntidades)
private
	type
		TColeccionPersonaEnumerador = record
		private
			nEntidad: integer;
			FColeccion : TColeccionPersona;
		public
			constructor Create(Coleccion: TColeccionPersona);
			function  GetCurrent: TPersona; inline;
			function  MoveNext: boolean;
			property Current: TPersona read GetCurrent;
		end;
private
	function GetPersona(index: integer): TPersona;
	function GetORMCampo(indiceCampo: integer): TORMCampo;
protected
	procedure ProcesarDataSet; override;
published
public
	constructor Create; overload;
	function CrearNuevaConexionEntidad: TORMEntidadConexion; override;
	function GetEnumerator: TColeccionPersonaEnumerador;
	property Persona[index: integer]: TPersona read GetPersona; default;
	property ORMCampo[indiceCampo: integer]: TORMCampo read GetORMCampo;
end;
TColeccionTipoDocumento=class(TORMColeccionEntidades)
private
	type
		TColeccionTipoDocumentoEnumerador = record
		private
			nEntidad: integer;
			FColeccion : TColeccionTipoDocumento;
		public
			constructor Create(Coleccion: TColeccionTipoDocumento);
			function  GetCurrent: TTipoDocumento; inline;
			function  MoveNext: boolean;
			property Current: TTipoDocumento read GetCurrent;
		end;
private
	function GetTipoDocumento(index: integer): TTipoDocumento;
	function GetORMCampo(indiceCampo: integer): TORMCampo;
protected
	procedure ProcesarDataSet; override;
published
public
	constructor Create; overload;
	function CrearNuevaConexionEntidad: TORMEntidadConexion; override;
	function GetEnumerator: TColeccionTipoDocumentoEnumerador;
	property TipoDocumento[index: integer]: TTipoDocumento read GetTipoDocumento; default;
	property ORMCampo[indiceCampo: integer]: TORMCampo read GetORMCampo;
end;
TColeccionTipoDomicilio=class(TORMColeccionEntidades)
private
	type
		TColeccionTipoDomicilioEnumerador = record
		private
			nEntidad: integer;
			FColeccion : TColeccionTipoDomicilio;
		public
			constructor Create(Coleccion: TColeccionTipoDomicilio);
			function  GetCurrent: TTipoDomicilio; inline;
			function  MoveNext: boolean;
			property Current: TTipoDomicilio read GetCurrent;
		end;
private
	function GetTipoDomicilio(index: integer): TTipoDomicilio;
	function GetORMCampo(indiceCampo: integer): TORMCampo;
protected
	procedure ProcesarDataSet; override;
published
public
	constructor Create; overload;
	function CrearNuevaConexionEntidad: TORMEntidadConexion; override;
	function GetEnumerator: TColeccionTipoDomicilioEnumerador;
	property TipoDomicilio[index: integer]: TTipoDomicilio read GetTipoDomicilio; default;
	property ORMCampo[indiceCampo: integer]: TORMCampo read GetORMCampo;
end;

TFilaListaPersona=class(TORMEntidadBase)
private
	function GetPerdonaID: integer;
	procedure SetPerdonaID(const Value: integer);
	function GetApellido: string;
	procedure SetApellido(const Value: string);
	function GetNombre: string;
	procedure SetNombre(const Value: string);
	function GetDescripcionTipoDocumento: string;
	procedure SetDescripcionTipoDocumento(const Value: string);
public
	constructor Create(Coleccion: TCollection = nil); overload;
	destructor Destroy; override;
	function CrearNuevaConexionEntidad: TORMEntidadConexion; override;
published
	property PerdonaID: integer read GetPerdonaID write SetPerdonaID;
	property Apellido: string read GetApellido write SetApellido;
	property Nombre: string read GetNombre write SetNombre;
	property DescripcionTipoDocumento: string read GetDescripcionTipoDocumento write SetDescripcionTipoDocumento;
end;

TListaPersona=class(TORMColeccionEntidades)
private
	type
		TListaPersonaEnumerador = record
		private
			nEntidad: integer;
			FColeccion : TListaPersona;
		public
			constructor Create(Coleccion: TListaPersona);
			function  GetCurrent: TFilaListaPersona;
			function  MoveNext: boolean;
			property Current: TFilaListaPersona read GetCurrent;
		end;
private
	function GetFila(index: integer): TFilaListaPersona;
protected
	procedure ProcesarDataSet; override;
public
	constructor Create; overload;
	destructor Destroy; override;
	function CrearNuevaConexionEntidad: TORMEntidadConexion; override;
	function GetEnumerator: TListaPersonaEnumerador;
	function ObtenerTodos: integer; override;
	function ObtenerMuchos( Filtro: TExpresionCondicion;
							Orden: TExpresionOrdenamiento = nil;
							Agrupamiento: TExpresionAgrupamiento = nil;
							Relaciones: TExpresionRelacion = nil;
							FiltroHaving: TExpresionCondicion = nil;
							const CantFilas: integer = 0; const TamPagina: integer = 0;
							const NroPagina: integer = 0; const SinDuplicados: boolean = false): integer; override;
	property Fila[index: integer]: TFilaListaPersona read GetFila; default;
end;


var
	SQLConnectionGenerator: TSQLConnectionGenerator;
	SingleConnection : TORMEntidadConexion;
	OnuTestEntidadesException: TORMOnExceptionEvent;

implementation

uses DB, uSQLBuilder;

{TFabricauTestEntidades}

class function TFabricauTestEntidades.CrearNuevaEntidadConexion(ConexionPublica: boolean): TORMEntidadConexion;
begin
	if not assigned(SingleConnection) then
	begin
		Result := TORMEntidadConexion.Create(SQLConnectionGenerator.GetConnection, TFBSQLStatementManager.Create); 
		Result.ConexionPublica := ConexionPublica;
	end
	else
		Result := SingleConnection; 
end;


{ TDomicilio }
constructor TDomicilio.Create(Coleccion: TCollection; ComoEntidadNueva: boolean);
begin
	inherited Create(Coleccion, ComoEntidadNueva);
	FTabla:='Domicilio';
	FCampos.Agregar(TORMCampo.Create(FTabla,'DomicilioID', '','','',TIndiceDomicilio.DomicilioID, 0,  True, True,False, True, tdInteger, faNinguna,0));
	FCampos.Agregar(TORMCampo.Create(FTabla,'TipoDomicilioID', '','','',TIndiceDomicilio.TipoDomicilioID, 0,  False, False,True, False, tdInteger, faNinguna,0));
	FCampos.Agregar(TORMCampo.Create(FTabla,'PersonaID', '','','',TIndiceDomicilio.PersonaID, 0,  False, False,True, False, tdInteger, faNinguna,0));
	FCampos.Agregar(TORMCampo.Create(FTabla,'Calle', '','','',TIndiceDomicilio.Calle, 50,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TORMCampo.Create(FTabla,'Numero', '','','',TIndiceDomicilio.Numero, 0,  False, False,False, False, tdInteger, faNinguna,0));
	FTipoDomicilio:=nil;
	FPersona:=nil;
end;
destructor TDomicilio.Destroy;
begin
	if assigned(FTipoDomicilio) then
		FTipoDomicilio.Free;
	if assigned(FPersona) then
		FPersona.Free;
	inherited;
end;
function TDomicilio.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion; 
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TDomicilio.GetORMCampo(IndiceCampo: integer): TORMCampo;
begin
	Result := FCampos.ORMCampo[IndiceCampo];
end;	
constructor TDomicilio.Create(const DomicilioID: integer);
begin
	Create;
	ObtenerEntidad(DomicilioID);
end;	
function TDomicilio.GetDomicilioID: integer;
begin
	Result := FCampos.ORMCampo[TIndiceDomicilio.DomicilioID].AsInteger;
end;
function TDomicilio.EsNuloDomicilioID: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceDomicilio.DomicilioID].EsNulo;
end;
function TDomicilio.GetTipoDomicilioID: integer;
begin
	Result := FCampos.ORMCampo[TIndiceDomicilio.TipoDomicilioID].AsInteger;
end;
function TDomicilio.EsNuloTipoDomicilioID: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceDomicilio.TipoDomicilioID].EsNulo;
end;
function TDomicilio.GetPersonaID: integer;
begin
	Result := FCampos.ORMCampo[TIndiceDomicilio.PersonaID].AsInteger;
end;
function TDomicilio.EsNuloPersonaID: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceDomicilio.PersonaID].EsNulo;
end;
function TDomicilio.GetCalle: string;
begin
	Result := FCampos.ORMCampo[TIndiceDomicilio.Calle].AsString;
end;
function TDomicilio.EsNuloCalle: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceDomicilio.Calle].EsNulo;
end;
function TDomicilio.GetNumero: integer;
begin
	Result := FCampos.ORMCampo[TIndiceDomicilio.Numero].AsInteger;
end;
function TDomicilio.EsNuloNumero: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceDomicilio.Numero].EsNulo;
end;
procedure TDomicilio.SetDomicilioID(const Value: integer);
begin
	FCampos.ORMCampo[TIndiceDomicilio.DomicilioID].AsInteger:= Value;
end;	
procedure TDomicilio.SetTipoDomicilioID(const Value: integer);
begin
	FCampos.ORMCampo[TIndiceDomicilio.TipoDomicilioID].AsInteger:= Value;
end;	
procedure TDomicilio.SetPersonaID(const Value: integer);
begin
	FCampos.ORMCampo[TIndiceDomicilio.PersonaID].AsInteger:= Value;
end;	
procedure TDomicilio.SetCalle(const Value: string);
begin
	FCampos.ORMCampo[TIndiceDomicilio.Calle].AsString:= Value;
end;	
procedure TDomicilio.SetNumero(const Value: integer);
begin
	FCampos.ORMCampo[TIndiceDomicilio.Numero].AsInteger:= Value;
end;	
function TDomicilio.ObtenerEntidad(const DomicilioID: integer): boolean;
var
	select : TSelectStatement;
begin
	select := TSelectStatement.Create(FCampos);
	select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.ORMCampo[TIndiceDomicilio.DomicilioID], tcIgual, DomicilioID));
	Result := AsignarCamposDesdeSeleccion(select);
	select.Free;
end;
function TDomicilio.GetTipoDomicilio: TTipoDomicilio;
var
	nEntidadAsociada: integer;
begin
	if not assigned(FTipoDomicilio) then begin
		//FTipoDomicilio := TTipoDomicilio.Create(TipoDomicilioID);
		FTipoDomicilio := TTipoDomicilio.Create;
		FTipoDomicilio.AsignarConexion(Conexion);
		FTipoDomicilio.ObtenerEntidad(TipoDomicilioID);
		nEntidadAsociada := AgregarEntidadAsociada(FTipoDomicilio);
		AgregarCamposAsociadosEntidad(nEntidadAsociada, TIndiceDomicilio.TipoDomicilioID,TIndiceTipoDomicilio.TipoDomicilioID);
	end;
	Result := FTipoDomicilio;
end;
procedure TDomicilio.LiberarTipoDomicilio;
begin
	EliminarEntidadAsociada(FTipoDomicilio);	
	FTipoDomicilio := nil;
end;
function TDomicilio.GetPersona: TPersona;
var
	nEntidadAsociada: integer;
begin
	if not assigned(FPersona) then begin
		//FPersona := TPersona.Create(PersonaID);
		FPersona := TPersona.Create;
		FPersona.AsignarConexion(Conexion);
		FPersona.ObtenerEntidad(PersonaID);
		nEntidadAsociada := AgregarEntidadAsociada(FPersona);
		AgregarCamposAsociadosEntidad(nEntidadAsociada, TIndiceDomicilio.PersonaID,TIndicePersona.PerdonaID);
	end;
	Result := FPersona;
end;
procedure TDomicilio.LiberarPersona;
begin
	EliminarEntidadAsociada(FPersona);	
	FPersona := nil;
end;
{ TPersona }
constructor TPersona.Create(Coleccion: TCollection; ComoEntidadNueva: boolean);
begin
	inherited Create(Coleccion, ComoEntidadNueva);
	FTabla:='Persona';
	FCampos.Agregar(TORMCampo.Create(FTabla,'PerdonaID', '','','',TIndicePersona.PerdonaID, 0,  True, True,False, True, tdInteger, faNinguna,0));
	FCampos.Agregar(TORMCampo.Create(FTabla,'Apellido', '','','',TIndicePersona.Apellido, 50,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TORMCampo.Create(FTabla,'Nombre', '','','',TIndicePersona.Nombre, 50,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TORMCampo.Create(FTabla,'TipoDocumentoID', '','','',TIndicePersona.TipoDocumentoID, 0,  False, False,True, False, tdInteger, faNinguna,0));
	FCampos.Agregar(TORMCampo.Create(FTabla,'NumeroDocumento', '','','',TIndicePersona.NumeroDocumento, 0,  False, False,False, False, tdInteger, faNinguna,0));
	FTipoDocumento:=nil;
	FColeccionDomicilio:=nil;
end;
destructor TPersona.Destroy;
begin
	if assigned(FTipoDocumento) then
		FTipoDocumento.Free;
	if assigned(FColeccionDomicilio) then
		FColeccionDomicilio.Free;
	inherited;
end;
function TPersona.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion; 
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TPersona.GetORMCampo(IndiceCampo: integer): TORMCampo;
begin
	Result := FCampos.ORMCampo[IndiceCampo];
end;	
constructor TPersona.Create(const PerdonaID: integer);
begin
	Create;
	ObtenerEntidad(PerdonaID);
end;	
function TPersona.GetPerdonaID: integer;
begin
	Result := FCampos.ORMCampo[TIndicePersona.PerdonaID].AsInteger;
end;
function TPersona.EsNuloPerdonaID: boolean;
begin
	Result := FCampos.ORMCampo[TIndicePersona.PerdonaID].EsNulo;
end;
function TPersona.GetApellido: string;
begin
	Result := FCampos.ORMCampo[TIndicePersona.Apellido].AsString;
end;
function TPersona.EsNuloApellido: boolean;
begin
	Result := FCampos.ORMCampo[TIndicePersona.Apellido].EsNulo;
end;
function TPersona.GetNombre: string;
begin
	Result := FCampos.ORMCampo[TIndicePersona.Nombre].AsString;
end;
function TPersona.EsNuloNombre: boolean;
begin
	Result := FCampos.ORMCampo[TIndicePersona.Nombre].EsNulo;
end;
function TPersona.GetTipoDocumentoID: integer;
begin
	Result := FCampos.ORMCampo[TIndicePersona.TipoDocumentoID].AsInteger;
end;
function TPersona.EsNuloTipoDocumentoID: boolean;
begin
	Result := FCampos.ORMCampo[TIndicePersona.TipoDocumentoID].EsNulo;
end;
function TPersona.GetNumeroDocumento: integer;
begin
	Result := FCampos.ORMCampo[TIndicePersona.NumeroDocumento].AsInteger;
end;
function TPersona.EsNuloNumeroDocumento: boolean;
begin
	Result := FCampos.ORMCampo[TIndicePersona.NumeroDocumento].EsNulo;
end;
procedure TPersona.SetPerdonaID(const Value: integer);
begin
	FCampos.ORMCampo[TIndicePersona.PerdonaID].AsInteger:= Value;
end;	
procedure TPersona.SetApellido(const Value: string);
begin
	FCampos.ORMCampo[TIndicePersona.Apellido].AsString:= Value;
end;	
procedure TPersona.SetNombre(const Value: string);
begin
	FCampos.ORMCampo[TIndicePersona.Nombre].AsString:= Value;
end;	
procedure TPersona.SetTipoDocumentoID(const Value: integer);
begin
	FCampos.ORMCampo[TIndicePersona.TipoDocumentoID].AsInteger:= Value;
end;	
procedure TPersona.SetNumeroDocumento(const Value: integer);
begin
	FCampos.ORMCampo[TIndicePersona.NumeroDocumento].AsInteger:= Value;
end;	
function TPersona.ObtenerEntidad(const PerdonaID: integer): boolean;
var
	select : TSelectStatement;
begin
	select := TSelectStatement.Create(FCampos);
	select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.ORMCampo[TIndicePersona.PerdonaID], tcIgual, PerdonaID));
	Result := AsignarCamposDesdeSeleccion(select);
	select.Free;
end;
function TPersona.GetTipoDocumento: TTipoDocumento;
var
	nEntidadAsociada: integer;
begin
	if not assigned(FTipoDocumento) then begin
		//FTipoDocumento := TTipoDocumento.Create(TipoDocumentoID);
		FTipoDocumento := TTipoDocumento.Create;
		FTipoDocumento.AsignarConexion(Conexion);
		FTipoDocumento.ObtenerEntidad(TipoDocumentoID);
		nEntidadAsociada := AgregarEntidadAsociada(FTipoDocumento);
		AgregarCamposAsociadosEntidad(nEntidadAsociada, TIndicePersona.TipoDocumentoID,TIndiceTipoDocumento.TipoDocumentoID);
	end;
	Result := FTipoDocumento;
end;
procedure TPersona.LiberarTipoDocumento;
begin
	EliminarEntidadAsociada(FTipoDocumento);	
	FTipoDocumento := nil;
end;
function TPersona.GetColeccionDomicilio: TColeccionDomicilio;
var
	unFiltro : TExpresionCondicion;
	nColeccionAsociada: integer;
begin
	if not assigned(FColeccionDomicilio) then begin
		FColeccionDomicilio:= TColeccionDomicilio.Create;
		FColeccionDomicilio.AsignarConexion(Conexion);
		nColeccionAsociada:= AgregarColeccionAsociada(FColeccionDomicilio);
		unFiltro := TExpresionCondicion.Create;
		unFiltro.Agregar(TCondicionComparacion.Create(FColeccionDomicilio.FCampos.ORMCampo[TIndiceDomicilio.PersonaID], tcIgual, PerdonaID));
		AgregarCamposAsociadosColeccion(nColeccionAsociada, TIndicePersona.PerdonaID,TIndiceDomicilio.PersonaID);
		FColeccionDomicilio.ObtenerMuchos(unFiltro);
		unFiltro.Free;
	end;
	Result := FColeccionDomicilio;
end;
{ TTipoDocumento }
constructor TTipoDocumento.Create(Coleccion: TCollection; ComoEntidadNueva: boolean);
begin
	inherited Create(Coleccion, ComoEntidadNueva);
	FTabla:='TipoDocumento';
	FCampos.Agregar(TORMCampo.Create(FTabla,'TipoDocumentoID', '','','',TIndiceTipoDocumento.TipoDocumentoID, 0,  True, True,False, True, tdInteger, faNinguna,0));
	FCampos.Agregar(TORMCampo.Create(FTabla,'Descripcion', '','','',TIndiceTipoDocumento.Descripcion, 50,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TORMCampo.Create(FTabla,'DescripcionReducida', '','','',TIndiceTipoDocumento.DescripcionReducida, 20,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TORMCampo.Create(FTabla,'Observaciones', '','','',TIndiceTipoDocumento.Observaciones, 100,  False, False,False, False, tdString, faNinguna,''));
	FColeccionPersona:=nil;
end;
destructor TTipoDocumento.Destroy;
begin
	if assigned(FColeccionPersona) then
		FColeccionPersona.Free;
	inherited;
end;
function TTipoDocumento.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion; 
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TTipoDocumento.GetORMCampo(IndiceCampo: integer): TORMCampo;
begin
	Result := FCampos.ORMCampo[IndiceCampo];
end;	
constructor TTipoDocumento.Create(const TipoDocumentoID: integer);
begin
	Create;
	ObtenerEntidad(TipoDocumentoID);
end;	
function TTipoDocumento.GetTipoDocumentoID: integer;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDocumento.TipoDocumentoID].AsInteger;
end;
function TTipoDocumento.EsNuloTipoDocumentoID: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDocumento.TipoDocumentoID].EsNulo;
end;
function TTipoDocumento.GetDescripcion: string;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDocumento.Descripcion].AsString;
end;
function TTipoDocumento.EsNuloDescripcion: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDocumento.Descripcion].EsNulo;
end;
function TTipoDocumento.GetDescripcionReducida: string;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDocumento.DescripcionReducida].AsString;
end;
function TTipoDocumento.EsNuloDescripcionReducida: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDocumento.DescripcionReducida].EsNulo;
end;
function TTipoDocumento.GetObservaciones: string;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDocumento.Observaciones].AsString;
end;
function TTipoDocumento.EsNuloObservaciones: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDocumento.Observaciones].EsNulo;
end;
procedure TTipoDocumento.SetTipoDocumentoID(const Value: integer);
begin
	FCampos.ORMCampo[TIndiceTipoDocumento.TipoDocumentoID].AsInteger:= Value;
end;	
procedure TTipoDocumento.SetDescripcion(const Value: string);
begin
	FCampos.ORMCampo[TIndiceTipoDocumento.Descripcion].AsString:= Value;
end;	
procedure TTipoDocumento.SetDescripcionReducida(const Value: string);
begin
	FCampos.ORMCampo[TIndiceTipoDocumento.DescripcionReducida].AsString:= Value;
end;	
procedure TTipoDocumento.SetObservaciones(const Value: string);
begin
	FCampos.ORMCampo[TIndiceTipoDocumento.Observaciones].AsString:= Value;
end;	
function TTipoDocumento.ObtenerEntidad(const TipoDocumentoID: integer): boolean;
var
	select : TSelectStatement;
begin
	select := TSelectStatement.Create(FCampos);
	select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.ORMCampo[TIndiceTipoDocumento.TipoDocumentoID], tcIgual, TipoDocumentoID));
	Result := AsignarCamposDesdeSeleccion(select);
	select.Free;
end;
function TTipoDocumento.GetColeccionPersona: TColeccionPersona;
var
	unFiltro : TExpresionCondicion;
	nColeccionAsociada: integer;
begin
	if not assigned(FColeccionPersona) then begin
		FColeccionPersona:= TColeccionPersona.Create;
		FColeccionPersona.AsignarConexion(Conexion);
		nColeccionAsociada:= AgregarColeccionAsociada(FColeccionPersona);
		unFiltro := TExpresionCondicion.Create;
		unFiltro.Agregar(TCondicionComparacion.Create(FColeccionPersona.FCampos.ORMCampo[TIndicePersona.TipoDocumentoID], tcIgual, TipoDocumentoID));
		AgregarCamposAsociadosColeccion(nColeccionAsociada, TIndiceTipoDocumento.TipoDocumentoID,TIndicePersona.TipoDocumentoID);
		FColeccionPersona.ObtenerMuchos(unFiltro);
		unFiltro.Free;
	end;
	Result := FColeccionPersona;
end;
{ TTipoDomicilio }
constructor TTipoDomicilio.Create(Coleccion: TCollection; ComoEntidadNueva: boolean);
begin
	inherited Create(Coleccion, ComoEntidadNueva);
	FTabla:='TipoDomicilio';
	FCampos.Agregar(TORMCampo.Create(FTabla,'TipoDomicilioID', '','','',TIndiceTipoDomicilio.TipoDomicilioID, 0,  True, True,False, True, tdInteger, faNinguna,0));
	FCampos.Agregar(TORMCampo.Create(FTabla,'Descripcion', '','','',TIndiceTipoDomicilio.Descripcion, 50,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TORMCampo.Create(FTabla,'DescripcionReducida', '','','',TIndiceTipoDomicilio.DescripcionReducida, 30,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TORMCampo.Create(FTabla,'Observaciones', '','','',TIndiceTipoDomicilio.Observaciones, 100,  False, False,False, False, tdString, faNinguna,''));
	FColeccionDomicilio:=nil;
end;
destructor TTipoDomicilio.Destroy;
begin
	if assigned(FColeccionDomicilio) then
		FColeccionDomicilio.Free;
	inherited;
end;
function TTipoDomicilio.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion; 
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TTipoDomicilio.GetORMCampo(IndiceCampo: integer): TORMCampo;
begin
	Result := FCampos.ORMCampo[IndiceCampo];
end;	
constructor TTipoDomicilio.Create(const TipoDomicilioID: integer);
begin
	Create;
	ObtenerEntidad(TipoDomicilioID);
end;	
function TTipoDomicilio.GetTipoDomicilioID: integer;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDomicilio.TipoDomicilioID].AsInteger;
end;
function TTipoDomicilio.EsNuloTipoDomicilioID: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDomicilio.TipoDomicilioID].EsNulo;
end;
function TTipoDomicilio.GetDescripcion: string;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDomicilio.Descripcion].AsString;
end;
function TTipoDomicilio.EsNuloDescripcion: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDomicilio.Descripcion].EsNulo;
end;
function TTipoDomicilio.GetDescripcionReducida: string;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDomicilio.DescripcionReducida].AsString;
end;
function TTipoDomicilio.EsNuloDescripcionReducida: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDomicilio.DescripcionReducida].EsNulo;
end;
function TTipoDomicilio.GetObservaciones: string;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDomicilio.Observaciones].AsString;
end;
function TTipoDomicilio.EsNuloObservaciones: boolean;
begin
	Result := FCampos.ORMCampo[TIndiceTipoDomicilio.Observaciones].EsNulo;
end;
procedure TTipoDomicilio.SetTipoDomicilioID(const Value: integer);
begin
	FCampos.ORMCampo[TIndiceTipoDomicilio.TipoDomicilioID].AsInteger:= Value;
end;	
procedure TTipoDomicilio.SetDescripcion(const Value: string);
begin
	FCampos.ORMCampo[TIndiceTipoDomicilio.Descripcion].AsString:= Value;
end;	
procedure TTipoDomicilio.SetDescripcionReducida(const Value: string);
begin
	FCampos.ORMCampo[TIndiceTipoDomicilio.DescripcionReducida].AsString:= Value;
end;	
procedure TTipoDomicilio.SetObservaciones(const Value: string);
begin
	FCampos.ORMCampo[TIndiceTipoDomicilio.Observaciones].AsString:= Value;
end;	
function TTipoDomicilio.ObtenerEntidad(const TipoDomicilioID: integer): boolean;
var
	select : TSelectStatement;
begin
	select := TSelectStatement.Create(FCampos);
	select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.ORMCampo[TIndiceTipoDomicilio.TipoDomicilioID], tcIgual, TipoDomicilioID));
	Result := AsignarCamposDesdeSeleccion(select);
	select.Free;
end;
function TTipoDomicilio.GetColeccionDomicilio: TColeccionDomicilio;
var
	unFiltro : TExpresionCondicion;
	nColeccionAsociada: integer;
begin
	if not assigned(FColeccionDomicilio) then begin
		FColeccionDomicilio:= TColeccionDomicilio.Create;
		FColeccionDomicilio.AsignarConexion(Conexion);
		nColeccionAsociada:= AgregarColeccionAsociada(FColeccionDomicilio);
		unFiltro := TExpresionCondicion.Create;
		unFiltro.Agregar(TCondicionComparacion.Create(FColeccionDomicilio.FCampos.ORMCampo[TIndiceDomicilio.TipoDomicilioID], tcIgual, TipoDomicilioID));
		AgregarCamposAsociadosColeccion(nColeccionAsociada, TIndiceTipoDomicilio.TipoDomicilioID,TIndiceDomicilio.TipoDomicilioID);
		FColeccionDomicilio.ObtenerMuchos(unFiltro);
		unFiltro.Free;
	end;
	Result := FColeccionDomicilio;
end;

{TColeccionDomicilio}
constructor TColeccionDomicilio.Create;
var
	unaEntidad: TDomicilio;
begin
	inherited Create( TDomicilio );
	unaEntidad := TDomicilio.Create;
	FCampos := unaEntidad.ORMCampos.Clonar;
	unaEntidad.Free;
end;
function TColeccionDomicilio.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion;
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TColeccionDomicilio.GetEnumerator: TColeccionDomicilioEnumerador;
begin
	Result := TColeccionDomicilioEnumerador.Create(self); 
end;
function TColeccionDomicilio.GetDomicilio(index: integer): TDomicilio;
begin
	Result := Items[index] as TDomicilio
end;
function TColeccionDomicilio.GetORMCampo(indiceCampo: integer):TORMCampo;
begin
	Result := ObtenerCampo(indiceCampo);
end;
procedure TColeccionDomicilio.ProcesarDataSet;
var
	unaEntidad: TDomicilio;
begin
	with FSelectStatement do
	begin
		if not Datos.Active then
			Datos.Active := true;
		Datos.First;
		while not Datos.Eof  do
		begin
			unaEntidad := TDomicilio.Create(self, false);
			if (Datos.Fields[TIndiceDomicilio.DomicilioID].IsNull) then
			   unaEntidad.ORMCampos[TIndiceDomicilio.DomicilioID].EsNulo := true
			else
				unaEntidad.DomicilioID := Datos.Fields[TIndiceDomicilio.DomicilioID].AsInteger;
			if (Datos.Fields[TIndiceDomicilio.TipoDomicilioID].IsNull) then
			   unaEntidad.ORMCampos[TIndiceDomicilio.TipoDomicilioID].EsNulo := true
			else
				unaEntidad.TipoDomicilioID := Datos.Fields[TIndiceDomicilio.TipoDomicilioID].AsInteger;
			if (Datos.Fields[TIndiceDomicilio.PersonaID].IsNull) then
			   unaEntidad.ORMCampos[TIndiceDomicilio.PersonaID].EsNulo := true
			else
				unaEntidad.PersonaID := Datos.Fields[TIndiceDomicilio.PersonaID].AsInteger;
			if (Datos.Fields[TIndiceDomicilio.Calle].IsNull) then
			   unaEntidad.ORMCampos[TIndiceDomicilio.Calle].EsNulo := true
			else
				unaEntidad.Calle := Datos.Fields[TIndiceDomicilio.Calle].AsString;
			if (Datos.Fields[TIndiceDomicilio.Numero].IsNull) then
			   unaEntidad.ORMCampos[TIndiceDomicilio.Numero].EsNulo := true
			else
				unaEntidad.Numero := Datos.Fields[TIndiceDomicilio.Numero].AsInteger;
			unaEntidad.ORMCampos.FueronCambiados := false;
			unaEntidad.AsignarConexion(Conexion);
			Datos.Next;
		end;
	end;
end;
{TColeccionDomicilioEnumerador}
constructor TColeccionDomicilio.TColeccionDomicilioEnumerador.Create(Coleccion: TColeccionDomicilio);
begin
	nEntidad := -1;
	FColeccion := Coleccion;
end;
function TColeccionDomicilio.TColeccionDomicilioEnumerador.GetCurrent: TDomicilio;
begin
	Result := FColeccion[nEntidad];
end;
function TColeccionDomicilio.TColeccionDomicilioEnumerador.MoveNext: boolean;
begin
	Result := nEntidad < (FColeccion.Count - 1);
	if Result then
	   Inc(nEntidad);
end;
{TColeccionPersona}
constructor TColeccionPersona.Create;
var
	unaEntidad: TPersona;
begin
	inherited Create( TPersona );
	unaEntidad := TPersona.Create;
	FCampos := unaEntidad.ORMCampos.Clonar;
	unaEntidad.Free;
end;
function TColeccionPersona.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion;
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TColeccionPersona.GetEnumerator: TColeccionPersonaEnumerador;
begin
	Result := TColeccionPersonaEnumerador.Create(self); 
end;
function TColeccionPersona.GetPersona(index: integer): TPersona;
begin
	Result := Items[index] as TPersona
end;
function TColeccionPersona.GetORMCampo(indiceCampo: integer):TORMCampo;
begin
	Result := ObtenerCampo(indiceCampo);
end;
procedure TColeccionPersona.ProcesarDataSet;
var
	unaEntidad: TPersona;
begin
	with FSelectStatement do
	begin
		if not Datos.Active then
			Datos.Active := true;
		Datos.First;
		while not Datos.Eof  do
		begin
			unaEntidad := TPersona.Create(self, false);
			if (Datos.Fields[TIndicePersona.PerdonaID].IsNull) then
			   unaEntidad.ORMCampos[TIndicePersona.PerdonaID].EsNulo := true
			else
				unaEntidad.PerdonaID := Datos.Fields[TIndicePersona.PerdonaID].AsInteger;
			if (Datos.Fields[TIndicePersona.Apellido].IsNull) then
			   unaEntidad.ORMCampos[TIndicePersona.Apellido].EsNulo := true
			else
				unaEntidad.Apellido := Datos.Fields[TIndicePersona.Apellido].AsString;
			if (Datos.Fields[TIndicePersona.Nombre].IsNull) then
			   unaEntidad.ORMCampos[TIndicePersona.Nombre].EsNulo := true
			else
				unaEntidad.Nombre := Datos.Fields[TIndicePersona.Nombre].AsString;
			if (Datos.Fields[TIndicePersona.TipoDocumentoID].IsNull) then
			   unaEntidad.ORMCampos[TIndicePersona.TipoDocumentoID].EsNulo := true
			else
				unaEntidad.TipoDocumentoID := Datos.Fields[TIndicePersona.TipoDocumentoID].AsInteger;
			if (Datos.Fields[TIndicePersona.NumeroDocumento].IsNull) then
			   unaEntidad.ORMCampos[TIndicePersona.NumeroDocumento].EsNulo := true
			else
				unaEntidad.NumeroDocumento := Datos.Fields[TIndicePersona.NumeroDocumento].AsInteger;
			unaEntidad.ORMCampos.FueronCambiados := false;
			unaEntidad.AsignarConexion(Conexion);
			Datos.Next;
		end;
	end;
end;
{TColeccionPersonaEnumerador}
constructor TColeccionPersona.TColeccionPersonaEnumerador.Create(Coleccion: TColeccionPersona);
begin
	nEntidad := -1;
	FColeccion := Coleccion;
end;
function TColeccionPersona.TColeccionPersonaEnumerador.GetCurrent: TPersona;
begin
	Result := FColeccion[nEntidad];
end;
function TColeccionPersona.TColeccionPersonaEnumerador.MoveNext: boolean;
begin
	Result := nEntidad < (FColeccion.Count - 1);
	if Result then
	   Inc(nEntidad);
end;
{TColeccionTipoDocumento}
constructor TColeccionTipoDocumento.Create;
var
	unaEntidad: TTipoDocumento;
begin
	inherited Create( TTipoDocumento );
	unaEntidad := TTipoDocumento.Create;
	FCampos := unaEntidad.ORMCampos.Clonar;
	unaEntidad.Free;
end;
function TColeccionTipoDocumento.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion;
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TColeccionTipoDocumento.GetEnumerator: TColeccionTipoDocumentoEnumerador;
begin
	Result := TColeccionTipoDocumentoEnumerador.Create(self); 
end;
function TColeccionTipoDocumento.GetTipoDocumento(index: integer): TTipoDocumento;
begin
	Result := Items[index] as TTipoDocumento
end;
function TColeccionTipoDocumento.GetORMCampo(indiceCampo: integer):TORMCampo;
begin
	Result := ObtenerCampo(indiceCampo);
end;
procedure TColeccionTipoDocumento.ProcesarDataSet;
var
	unaEntidad: TTipoDocumento;
begin
	with FSelectStatement do
	begin
		if not Datos.Active then
			Datos.Active := true;
		Datos.First;
		while not Datos.Eof  do
		begin
			unaEntidad := TTipoDocumento.Create(self, false);
			if (Datos.Fields[TIndiceTipoDocumento.TipoDocumentoID].IsNull) then
			   unaEntidad.ORMCampos[TIndiceTipoDocumento.TipoDocumentoID].EsNulo := true
			else
				unaEntidad.TipoDocumentoID := Datos.Fields[TIndiceTipoDocumento.TipoDocumentoID].AsInteger;
			if (Datos.Fields[TIndiceTipoDocumento.Descripcion].IsNull) then
			   unaEntidad.ORMCampos[TIndiceTipoDocumento.Descripcion].EsNulo := true
			else
				unaEntidad.Descripcion := Datos.Fields[TIndiceTipoDocumento.Descripcion].AsString;
			if (Datos.Fields[TIndiceTipoDocumento.DescripcionReducida].IsNull) then
			   unaEntidad.ORMCampos[TIndiceTipoDocumento.DescripcionReducida].EsNulo := true
			else
				unaEntidad.DescripcionReducida := Datos.Fields[TIndiceTipoDocumento.DescripcionReducida].AsString;
			if (Datos.Fields[TIndiceTipoDocumento.Observaciones].IsNull) then
			   unaEntidad.ORMCampos[TIndiceTipoDocumento.Observaciones].EsNulo := true
			else
				unaEntidad.Observaciones := Datos.Fields[TIndiceTipoDocumento.Observaciones].AsString;
			unaEntidad.ORMCampos.FueronCambiados := false;
			unaEntidad.AsignarConexion(Conexion);
			Datos.Next;
		end;
	end;
end;
{TColeccionTipoDocumentoEnumerador}
constructor TColeccionTipoDocumento.TColeccionTipoDocumentoEnumerador.Create(Coleccion: TColeccionTipoDocumento);
begin
	nEntidad := -1;
	FColeccion := Coleccion;
end;
function TColeccionTipoDocumento.TColeccionTipoDocumentoEnumerador.GetCurrent: TTipoDocumento;
begin
	Result := FColeccion[nEntidad];
end;
function TColeccionTipoDocumento.TColeccionTipoDocumentoEnumerador.MoveNext: boolean;
begin
	Result := nEntidad < (FColeccion.Count - 1);
	if Result then
	   Inc(nEntidad);
end;
{TColeccionTipoDomicilio}
constructor TColeccionTipoDomicilio.Create;
var
	unaEntidad: TTipoDomicilio;
begin
	inherited Create( TTipoDomicilio );
	unaEntidad := TTipoDomicilio.Create;
	FCampos := unaEntidad.ORMCampos.Clonar;
	unaEntidad.Free;
end;
function TColeccionTipoDomicilio.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion;
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TColeccionTipoDomicilio.GetEnumerator: TColeccionTipoDomicilioEnumerador;
begin
	Result := TColeccionTipoDomicilioEnumerador.Create(self); 
end;
function TColeccionTipoDomicilio.GetTipoDomicilio(index: integer): TTipoDomicilio;
begin
	Result := Items[index] as TTipoDomicilio
end;
function TColeccionTipoDomicilio.GetORMCampo(indiceCampo: integer):TORMCampo;
begin
	Result := ObtenerCampo(indiceCampo);
end;
procedure TColeccionTipoDomicilio.ProcesarDataSet;
var
	unaEntidad: TTipoDomicilio;
begin
	with FSelectStatement do
	begin
		if not Datos.Active then
			Datos.Active := true;
		Datos.First;
		while not Datos.Eof  do
		begin
			unaEntidad := TTipoDomicilio.Create(self, false);
			if (Datos.Fields[TIndiceTipoDomicilio.TipoDomicilioID].IsNull) then
			   unaEntidad.ORMCampos[TIndiceTipoDomicilio.TipoDomicilioID].EsNulo := true
			else
				unaEntidad.TipoDomicilioID := Datos.Fields[TIndiceTipoDomicilio.TipoDomicilioID].AsInteger;
			if (Datos.Fields[TIndiceTipoDomicilio.Descripcion].IsNull) then
			   unaEntidad.ORMCampos[TIndiceTipoDomicilio.Descripcion].EsNulo := true
			else
				unaEntidad.Descripcion := Datos.Fields[TIndiceTipoDomicilio.Descripcion].AsString;
			if (Datos.Fields[TIndiceTipoDomicilio.DescripcionReducida].IsNull) then
			   unaEntidad.ORMCampos[TIndiceTipoDomicilio.DescripcionReducida].EsNulo := true
			else
				unaEntidad.DescripcionReducida := Datos.Fields[TIndiceTipoDomicilio.DescripcionReducida].AsString;
			if (Datos.Fields[TIndiceTipoDomicilio.Observaciones].IsNull) then
			   unaEntidad.ORMCampos[TIndiceTipoDomicilio.Observaciones].EsNulo := true
			else
				unaEntidad.Observaciones := Datos.Fields[TIndiceTipoDomicilio.Observaciones].AsString;
			unaEntidad.ORMCampos.FueronCambiados := false;
			unaEntidad.AsignarConexion(Conexion);
			Datos.Next;
		end;
	end;
end;
{TColeccionTipoDomicilioEnumerador}
constructor TColeccionTipoDomicilio.TColeccionTipoDomicilioEnumerador.Create(Coleccion: TColeccionTipoDomicilio);
begin
	nEntidad := -1;
	FColeccion := Coleccion;
end;
function TColeccionTipoDomicilio.TColeccionTipoDomicilioEnumerador.GetCurrent: TTipoDomicilio;
begin
	Result := FColeccion[nEntidad];
end;
function TColeccionTipoDomicilio.TColeccionTipoDomicilioEnumerador.MoveNext: boolean;
begin
	Result := nEntidad < (FColeccion.Count - 1);
	if Result then
	   Inc(nEntidad);
end;

{TRelacionesDomicilio}
class function TRelacionesDomicilio.TipoDomicilio(TipoRelacion: TORMTipoRelacion): TORMRelacion;
var
	sCamposOrigen, sCamposDestino: TStringList;
	CamposOrigen, CamposDestino: TORMCamposRelacion; 
begin
	sCamposOrigen := TStringList.Create;
	sCamposDestino:= TStringList.Create;
	sCamposOrigen.Add('TipoDomicilioID');
	sCamposDestino.Add('TipoDomicilioID');
	CamposOrigen := TORMCamposRelacion.Create('Domicilio', sCamposOrigen);
	CamposDestino:= TORMCamposRelacion.Create('TipoDomicilio', sCamposDestino);  
	Result := TORMRelacion.Create(CamposOrigen, CamposDestino, TipoRelacion);
	FreeAndNil(CamposOrigen);
	FreeAndNil(CamposDestino);    
	FreeAndNil(sCamposOrigen);
	FreeAndNil(sCamposDestino);	   	  														   				  						   
end;
{TRelacionesDomicilio}
class function TRelacionesDomicilio.Persona(TipoRelacion: TORMTipoRelacion): TORMRelacion;
var
	sCamposOrigen, sCamposDestino: TStringList;
	CamposOrigen, CamposDestino: TORMCamposRelacion; 
begin
	sCamposOrigen := TStringList.Create;
	sCamposDestino:= TStringList.Create;
	sCamposOrigen.Add('PersonaID');
	sCamposDestino.Add('PerdonaID');
	CamposOrigen := TORMCamposRelacion.Create('Domicilio', sCamposOrigen);
	CamposDestino:= TORMCamposRelacion.Create('Persona', sCamposDestino);  
	Result := TORMRelacion.Create(CamposOrigen, CamposDestino, TipoRelacion);
	FreeAndNil(CamposOrigen);
	FreeAndNil(CamposDestino);    
	FreeAndNil(sCamposOrigen);
	FreeAndNil(sCamposDestino);	   	  														   				  						   
end;
{TRelacionesPersona}
class function TRelacionesPersona.TipoDocumento(TipoRelacion: TORMTipoRelacion): TORMRelacion;
var
	sCamposOrigen, sCamposDestino: TStringList;
	CamposOrigen, CamposDestino: TORMCamposRelacion; 
begin
	sCamposOrigen := TStringList.Create;
	sCamposDestino:= TStringList.Create;
	sCamposOrigen.Add('TipoDocumentoID');
	sCamposDestino.Add('TipoDocumentoID');
	CamposOrigen := TORMCamposRelacion.Create('Persona', sCamposOrigen);
	CamposDestino:= TORMCamposRelacion.Create('TipoDocumento', sCamposDestino);  
	Result := TORMRelacion.Create(CamposOrigen, CamposDestino, TipoRelacion);
	FreeAndNil(CamposOrigen);
	FreeAndNil(CamposDestino);    
	FreeAndNil(sCamposOrigen);
	FreeAndNil(sCamposDestino);	   	  														   				  						   
end;
class function TRelacionesPersona.Domicilio(TipoRelacion: TORMTipoRelacion): TORMRelacion;
var
	sCamposOrigen, sCamposDestino: TStringList;
	CamposOrigen, CamposDestino: TORMCamposRelacion; 
begin
	sCamposOrigen := TStringList.Create;
	sCamposDestino:= TStringList.Create;
	sCamposOrigen.Add('PerdonaID');
	sCamposDestino.Add('PersonaID');
	CamposOrigen:= TORMCamposRelacion.Create('Persona', sCamposOrigen);
	CamposDestino:= TORMCamposRelacion.Create('Domicilio', sCamposDestino); 
	Result := TORMRelacion.Create(CamposOrigen, CamposDestino, TipoRelacion);
	FreeAndNil(CamposOrigen);
	FreeAndNil(CamposDestino);    	   	  		
	FreeAndNil(sCamposOrigen);
	FreeAndNil(sCamposDestino);												   				  						   
end;

{TFilaListaPersona}
constructor TFilaListaPersona.Create(Coleccion: TCollection);
begin
	inherited Create(Coleccion, false);
	FTabla:='ListaPersona';
	FCampos.Agregar(TORMCampo.Create('Persona','PerdonaID', '','PerdonaID','',TIndiceListaPersona.PerdonaID, 0,  false, false,false,false,tdInteger, faNinguna,''));
	FCampos.Agregar(TORMCampo.Create('Persona','Apellido', '','Apellido','',TIndiceListaPersona.Apellido, 50,  false, false,false,false,tdString, faNinguna,''));
	FCampos.Agregar(TORMCampo.Create('Persona','Nombre', '','Nombre','',TIndiceListaPersona.Nombre, 50,  false, false,false,false,tdString, faNinguna,''));
	FCampos.Agregar(TORMCampo.Create('TipoDocumento','Descripcion', '','DescripcionTipoDocumento','',TIndiceListaPersona.DescripcionTipoDocumento, 50,  false, false,false,false,tdString, faNinguna,''));
end;
destructor TFilaListaPersona.Destroy;
begin
	inherited;
end;
function TFilaListaPersona.CrearNuevaConexionEntidad: TORMEntidadConexion; 
begin
	Result := nil;
end;
function TFilaListaPersona.GetPerdonaID: integer;
begin
	Result := FCampos.ORMCampo[TIndiceListaPersona.PerdonaID].AsInteger; 
end;
procedure TFilaListaPersona.SetPerdonaID(const Value: integer);
begin
	FCampos.ORMCampo[TIndiceListaPersona.PerdonaID].AsInteger:= Value;
end;	
function TFilaListaPersona.GetApellido: string;
begin
	Result := FCampos.ORMCampo[TIndiceListaPersona.Apellido].AsString; 
end;
procedure TFilaListaPersona.SetApellido(const Value: string);
begin
	FCampos.ORMCampo[TIndiceListaPersona.Apellido].AsString:= Value;
end;	
function TFilaListaPersona.GetNombre: string;
begin
	Result := FCampos.ORMCampo[TIndiceListaPersona.Nombre].AsString; 
end;
procedure TFilaListaPersona.SetNombre(const Value: string);
begin
	FCampos.ORMCampo[TIndiceListaPersona.Nombre].AsString:= Value;
end;	
function TFilaListaPersona.GetDescripcionTipoDocumento: string;
begin
	Result := FCampos.ORMCampo[TIndiceListaPersona.DescripcionTipoDocumento].AsString; 
end;
procedure TFilaListaPersona.SetDescripcionTipoDocumento(const Value: string);
begin
	FCampos.ORMCampo[TIndiceListaPersona.DescripcionTipoDocumento].AsString:= Value;
end;	

{TListaPersona}
constructor TListaPersona.Create;
var
	unaEntidad: TFilaListaPersona;
begin
	inherited Create( TFilaListaPersona );
	unaEntidad := TFilaListaPersona.Create;
	FCampos := unaEntidad.ORMCampos.Clonar;
	unaEntidad.Free;
end;
destructor TListaPersona.Destroy;
begin
	inherited;
end;
function TListaPersona.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion;
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TListaPersona.GetEnumerator: TListaPersonaEnumerador;
begin
	Result := TListaPersonaEnumerador.Create(self);
end;
function TListaPersona.ObtenerTodos: integer;
var
	Relacion: TExpresionRelacion;
	nRel : integer;
	bLiberarRelaciones: boolean;
begin
	Relacion := nil;
	bLiberarRelaciones := false;
	nRel := 2; 
	if nRel > 1 then
	begin
		Relacion := TExpresionRelacion.Create;
		Relacion.Agregar(TRelacionesPersona.TipoDocumento);
		bLiberarRelaciones := true;
	end;
	Result := ObtenerMuchos(nil, nil, nil, Relacion);
	if (bLiberarRelaciones) then
		FreeAndNil(Relacion);
end;
function TListaPersona.ObtenerMuchos( Filtro: TExpresionCondicion;
                            Orden: TExpresionOrdenamiento;
                            Agrupamiento: TExpresionAgrupamiento;
                            Relaciones: TExpresionRelacion;
                            FiltroHaving: TExpresionCondicion;
                            const CantFilas: integer; const TamPagina: integer;
                            const NroPagina: integer; const SinDuplicados: boolean): integer;
var
	nRel : integer;
	bLiberarRelaciones: boolean;
begin
	bLiberarRelaciones := false;
	if not assigned(Relaciones) then 
	begin
		nRel := 2; 
		if nRel > 1 then
		begin
			Relaciones := TExpresionRelacion.Create;
			Relaciones.Agregar(TRelacionesPersona.TipoDocumento);
			bLiberarRelaciones := true;
		end;
	end;
	Result := inherited ObtenerMuchos(	Filtro, Orden, Agrupamiento, Relaciones, FiltroHaving,
		   	  						   	CantFilas, TamPagina, NroPagina, SinDuplicados);
	if (bLiberarRelaciones) then
		FreeAndNil(Relaciones);
end;
function TListaPersona.GetFila(index: integer): TFilaListaPersona;
begin
	Result := Items[index] as TFilaListaPersona;
end;
procedure TListaPersona.ProcesarDataSet;
var
	unaEntidad: TFilaListaPersona;
begin
	with FSelectStatement do
	begin
		if not Datos.Active then
			Datos.Active := true;
		Datos.First;
		while not Datos.Eof  do
		begin
			unaEntidad := TFilaListaPersona.Create(self);
			if (Datos.Fields[TIndiceListaPersona.PerdonaID].IsNull) then
			    unaEntidad.ORMCampos[TIndiceListaPersona.PerdonaID].EsNulo := true
			else
				unaEntidad.PerdonaID := Datos.Fields[TIndiceListaPersona.PerdonaID].AsInteger;
			if (Datos.Fields[TIndiceListaPersona.Apellido].IsNull) then
			    unaEntidad.ORMCampos[TIndiceListaPersona.Apellido].EsNulo := true
			else
				unaEntidad.Apellido := Datos.Fields[TIndiceListaPersona.Apellido].AsString;
			if (Datos.Fields[TIndiceListaPersona.Nombre].IsNull) then
			    unaEntidad.ORMCampos[TIndiceListaPersona.Nombre].EsNulo := true
			else
				unaEntidad.Nombre := Datos.Fields[TIndiceListaPersona.Nombre].AsString;
			if (Datos.Fields[TIndiceListaPersona.DescripcionTipoDocumento].IsNull) then
			    unaEntidad.ORMCampos[TIndiceListaPersona.DescripcionTipoDocumento].EsNulo := true
			else
				unaEntidad.DescripcionTipoDocumento := Datos.Fields[TIndiceListaPersona.DescripcionTipoDocumento].AsString;
			unaEntidad.ORMCampos.FueronCambiados := false;
			Datos.Next;
		end;
	end;
end;
{TColeccionListaPersonaEnumerador}
constructor TListaPersona.TListaPersonaEnumerador.Create(Coleccion: TListaPersona);
begin
	nEntidad := -1;
	FColeccion := Coleccion;
end;
function TListaPersona.TListaPersonaEnumerador.GetCurrent: TFilaListaPersona;
begin
	Result := FColeccion[nEntidad];
end;
function TListaPersona.TListaPersonaEnumerador.MoveNext: boolean;
begin
	Result := nEntidad < (FColeccion.Count - 1);
	if Result then
		Inc(nEntidad);
end;

class function TFabricaCampoDomicilio.DomicilioID: TORMCampo;
begin
	Result := TORMCampo.Create('Domicilio','DomicilioID', '','','',TIndiceDomicilio.DomicilioID, 0,  True, True,False, True, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoDomicilio.TipoDomicilioID: TORMCampo;
begin
	Result := TORMCampo.Create('Domicilio','TipoDomicilioID', '','','',TIndiceDomicilio.TipoDomicilioID, 0,  False, False,True, False, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoDomicilio.PersonaID: TORMCampo;
begin
	Result := TORMCampo.Create('Domicilio','PersonaID', '','','',TIndiceDomicilio.PersonaID, 0,  False, False,True, False, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoDomicilio.Calle: TORMCampo;
begin
	Result := TORMCampo.Create('Domicilio','Calle', '','','',TIndiceDomicilio.Calle, 50,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoDomicilio.Numero: TORMCampo;
begin
	Result := TORMCampo.Create('Domicilio','Numero', '','','',TIndiceDomicilio.Numero, 0,  False, False,False, False, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoPersona.PerdonaID: TORMCampo;
begin
	Result := TORMCampo.Create('Persona','PerdonaID', '','','',TIndicePersona.PerdonaID, 0,  True, True,False, True, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoPersona.Apellido: TORMCampo;
begin
	Result := TORMCampo.Create('Persona','Apellido', '','','',TIndicePersona.Apellido, 50,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoPersona.Nombre: TORMCampo;
begin
	Result := TORMCampo.Create('Persona','Nombre', '','','',TIndicePersona.Nombre, 50,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoPersona.TipoDocumentoID: TORMCampo;
begin
	Result := TORMCampo.Create('Persona','TipoDocumentoID', '','','',TIndicePersona.TipoDocumentoID, 0,  False, False,True, False, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoPersona.NumeroDocumento: TORMCampo;
begin
	Result := TORMCampo.Create('Persona','NumeroDocumento', '','','',TIndicePersona.NumeroDocumento, 0,  False, False,False, False, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoTipoDocumento.TipoDocumentoID: TORMCampo;
begin
	Result := TORMCampo.Create('TipoDocumento','TipoDocumentoID', '','','',TIndiceTipoDocumento.TipoDocumentoID, 0,  True, True,False, True, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoTipoDocumento.Descripcion: TORMCampo;
begin
	Result := TORMCampo.Create('TipoDocumento','Descripcion', '','','',TIndiceTipoDocumento.Descripcion, 50,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoTipoDocumento.DescripcionReducida: TORMCampo;
begin
	Result := TORMCampo.Create('TipoDocumento','DescripcionReducida', '','','',TIndiceTipoDocumento.DescripcionReducida, 20,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoTipoDocumento.Observaciones: TORMCampo;
begin
	Result := TORMCampo.Create('TipoDocumento','Observaciones', '','','',TIndiceTipoDocumento.Observaciones, 100,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoTipoDomicilio.TipoDomicilioID: TORMCampo;
begin
	Result := TORMCampo.Create('TipoDomicilio','TipoDomicilioID', '','','',TIndiceTipoDomicilio.TipoDomicilioID, 0,  True, True,False, True, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoTipoDomicilio.Descripcion: TORMCampo;
begin
	Result := TORMCampo.Create('TipoDomicilio','Descripcion', '','','',TIndiceTipoDomicilio.Descripcion, 50,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoTipoDomicilio.DescripcionReducida: TORMCampo;
begin
	Result := TORMCampo.Create('TipoDomicilio','DescripcionReducida', '','','',TIndiceTipoDomicilio.DescripcionReducida, 30,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoTipoDomicilio.Observaciones: TORMCampo;
begin
	Result := TORMCampo.Create('TipoDomicilio','Observaciones', '','','',TIndiceTipoDomicilio.Observaciones, 100,  False, False,False, False, tdString, faNinguna,''); 
end;



initialization
	SQLConnectionGenerator := TSQLConnectionGenerator.Create;
	SingleConnection := nil;
finalization
	FreeAndNil(SQLConnectionGenerator);
	if assigned(SingleConnection) then FreeAndNil(SingleConnection);

End.

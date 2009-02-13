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

TCampoDomicilio=class
const
	DomicilioID='DomicilioID';
	TipoDomicilioID='TipoDomicilioID';
	PersonaID='PersonaID';
	Calle='Calle';
	Numero='Numero';
end;
TCampoPersona=class
const
	PerdonaID='PerdonaID';
	Apellido='Apellido';
	Nombre='Nombre';
	TipoDocumentoID='TipoDocumentoID';
	NumeroDocumento='NumeroDocumento';
end;
TCampoTipoDocumento=class
const
	TipoDocumentoID='TipoDocumentoID';
	Descripcion='Descripcion';
	DescripcionReducida='DescripcionReducida';
	Observaciones='Observaciones';
end;
TCampoTipoDomicilio=class
const
	TipoDomicilioID='TipoDomicilioID';
	Descripcion='Descripcion';
	DescripcionReducida='DescripcionReducida';
	Observaciones='Observaciones';
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
	class function DomicilioID: TCampo;
	class function TipoDomicilioID: TCampo;
	class function PersonaID: TCampo;
	class function Calle: TCampo;
	class function Numero: TCampo;
end;
TFabricaCampoPersona=class
public
	class function PerdonaID: TCampo;
	class function Apellido: TCampo;
	class function Nombre: TCampo;
	class function TipoDocumentoID: TCampo;
	class function NumeroDocumento: TCampo;
end;
TFabricaCampoTipoDocumento=class
public
	class function TipoDocumentoID: TCampo;
	class function Descripcion: TCampo;
	class function DescripcionReducida: TCampo;
	class function Observaciones: TCampo;
end;
TFabricaCampoTipoDomicilio=class
public
	class function TipoDomicilioID: TCampo;
	class function Descripcion: TCampo;
	class function DescripcionReducida: TCampo;
	class function Observaciones: TCampo;
end;

TFabricauTestEntidades=class
public
	class function CrearNuevaEntidadConexion(ConexionPublica: boolean = false): TEntidadConexion;
end;
TRelacionDomicilio=class
public
	{Relaciones 1 a 1}
	class function TipoDomicilio(TipoRelacion: TTipoRelacion=TrAmbas): TRelacion;
	class function Persona(TipoRelacion: TTipoRelacion=TrAmbas): TRelacion;
end;
TRelacionPersona=class
public
	{Relaciones 1 a 1}
	class function TipoDocumento(TipoRelacion: TTipoRelacion=TrAmbas): TRelacion;
	{Relaciones 1 a n}
	class function Domicilio(TipoRelacion: TTipoRelacion = TrAmbas): TRelacion;
end;



TDomicilio=class;
TColeccionDomicilio=class;
TPersona=class;
TColeccionPersona=class;
TTipoDocumento=class;
TColeccionTipoDocumento=class;
TTipoDomicilio=class;
TColeccionTipoDomicilio=class;


TDomicilio=class(TEntidadBase)
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
	function CrearNuevaConexionEntidad: TEntidadConexion; override;
	function GetCampo(IndiceCampo: integer): TCampo; overload;
	procedure LiberarTipoDomicilio;
	procedure LiberarPersona;
	property TipoDomicilio: TTipoDomicilio read GetTipoDomicilio;
	property Persona: TPersona read GetPersona;
published
	property DomicilioID: integer read GetDomicilioID write SetDomicilioID;
	property TipoDomicilioID: integer read GetTipoDomicilioID write SetTipoDomicilioID;
	property PersonaID: integer read GetPersonaID write SetPersonaID;
	property Calle: string read GetCalle write SetCalle;
	property Numero: integer read GetNumero write SetNumero;
end;
TPersona=class(TEntidadBase)
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
	function CrearNuevaConexionEntidad: TEntidadConexion; override;
	function GetCampo(IndiceCampo: integer): TCampo; overload;
	procedure LiberarTipoDocumento;
	property TipoDocumento: TTipoDocumento read GetTipoDocumento;
	property ColeccionDomicilio: TColeccionDomicilio read GetColeccionDomicilio;
published
	property PerdonaID: integer read GetPerdonaID write SetPerdonaID;
	property Apellido: string read GetApellido write SetApellido;
	property Nombre: string read GetNombre write SetNombre;
	property TipoDocumentoID: integer read GetTipoDocumentoID write SetTipoDocumentoID;
	property NumeroDocumento: integer read GetNumeroDocumento write SetNumeroDocumento;
end;
TTipoDocumento=class(TEntidadBase)
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
	function CrearNuevaConexionEntidad: TEntidadConexion; override;
	function GetCampo(IndiceCampo: integer): TCampo; overload;
	property ColeccionPersona: TColeccionPersona read GetColeccionPersona;
published
	property TipoDocumentoID: integer read GetTipoDocumentoID write SetTipoDocumentoID;
	property Descripcion: string read GetDescripcion write SetDescripcion;
	property DescripcionReducida: string read GetDescripcionReducida write SetDescripcionReducida;
	property Observaciones: string read GetObservaciones write SetObservaciones;
end;
TTipoDomicilio=class(TEntidadBase)
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
	function CrearNuevaConexionEntidad: TEntidadConexion; override;
	function GetCampo(IndiceCampo: integer): TCampo; overload;
	property ColeccionDomicilio: TColeccionDomicilio read GetColeccionDomicilio;
published
	property TipoDomicilioID: integer read GetTipoDomicilioID write SetTipoDomicilioID;
	property Descripcion: string read GetDescripcion write SetDescripcion;
	property DescripcionReducida: string read GetDescripcionReducida write SetDescripcionReducida;
	property Observaciones: string read GetObservaciones write SetObservaciones;
end;

TColeccionDomicilio=class(TColeccionEntidades)
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
	function GetCampo(indiceCampo: integer): TCampo;
protected
	procedure ProcesarDataSet; override;
published
public
	constructor Create; overload;
	function CrearNuevaConexionEntidad: TEntidadConexion; override;
	function GetEnumerator: TColeccionDomicilioEnumerador;
	property Domicilio[index: integer]: TDomicilio read GetDomicilio; default;
	property Campo[indiceCampo: integer]: TCampo read GetCampo;
end;
TColeccionPersona=class(TColeccionEntidades)
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
	function GetCampo(indiceCampo: integer): TCampo;
protected
	procedure ProcesarDataSet; override;
published
public
	constructor Create; overload;
	function CrearNuevaConexionEntidad: TEntidadConexion; override;
	function GetEnumerator: TColeccionPersonaEnumerador;
	property Persona[index: integer]: TPersona read GetPersona; default;
	property Campo[indiceCampo: integer]: TCampo read GetCampo;
end;
TColeccionTipoDocumento=class(TColeccionEntidades)
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
	function GetCampo(indiceCampo: integer): TCampo;
protected
	procedure ProcesarDataSet; override;
published
public
	constructor Create; overload;
	function CrearNuevaConexionEntidad: TEntidadConexion; override;
	function GetEnumerator: TColeccionTipoDocumentoEnumerador;
	property TipoDocumento[index: integer]: TTipoDocumento read GetTipoDocumento; default;
	property Campo[indiceCampo: integer]: TCampo read GetCampo;
end;
TColeccionTipoDomicilio=class(TColeccionEntidades)
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
	function GetCampo(indiceCampo: integer): TCampo;
protected
	procedure ProcesarDataSet; override;
published
public
	constructor Create; overload;
	function CrearNuevaConexionEntidad: TEntidadConexion; override;
	function GetEnumerator: TColeccionTipoDomicilioEnumerador;
	property TipoDomicilio[index: integer]: TTipoDomicilio read GetTipoDomicilio; default;
	property Campo[indiceCampo: integer]: TCampo read GetCampo;
end;

TFilaListaPersona=class(TEntidadBase)
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
	function CrearNuevaConexionEntidad: TEntidadConexion; override;
published
	property PerdonaID: integer read GetPerdonaID write SetPerdonaID;
	property Apellido: string read GetApellido write SetApellido;
	property Nombre: string read GetNombre write SetNombre;
	property DescripcionTipoDocumento: string read GetDescripcionTipoDocumento write SetDescripcionTipoDocumento;
end;

TListaPersona=class(TColeccionEntidades)
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
	function CrearNuevaConexionEntidad: TEntidadConexion; override;
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
	SingleConnection : TEntidadConexion;
	OnuTestEntidadesException: TOnExceptionEvent;

implementation

uses DB, uSQLBuilder;

{TFabricauTestEntidades}

class function TFabricauTestEntidades.CrearNuevaEntidadConexion(ConexionPublica: boolean): TEntidadConexion;
begin
	if not assigned(SingleConnection) then
	begin
		Result := TEntidadConexion.Create(SQLConnectionGenerator.GetConnection, TFBSQLStatementManager.Create); 
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
	FCampos.Agregar(TCampo.Create(Tabla,'DomicilioID', 'Domicilio','','',TIndiceDomicilio.DomicilioID, 0,  True, True,False, True, tdInteger, faNinguna,0));
	FCampos.Agregar(TCampo.Create(Tabla,'TipoDomicilioID', '','','',TIndiceDomicilio.TipoDomicilioID, 0,  False, False,True, False, tdInteger, faNinguna,0));
	FCampos.Agregar(TCampo.Create(Tabla,'PersonaID', '','','',TIndiceDomicilio.PersonaID, 0,  False, False,True, False, tdInteger, faNinguna,0));
	FCampos.Agregar(TCampo.Create(Tabla,'Calle', '','','',TIndiceDomicilio.Calle, 50,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TCampo.Create(Tabla,'Numero', '','','',TIndiceDomicilio.Numero, 0,  False, False,False, False, tdInteger, faNinguna,0));
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
function TDomicilio.CrearNuevaConexionEntidad: TEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion; 
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TDomicilio.GetCampo(IndiceCampo: integer): TCampo;
begin
	Result := FCampos.Campo[IndiceCampo];
end;	
constructor TDomicilio.Create(const DomicilioID: integer);
begin
	Create;
	ObtenerEntidad(DomicilioID);
end;	
function TDomicilio.GetDomicilioID: integer;
begin
	Result := FCampos.Campo[TIndiceDomicilio.DomicilioID].AsInteger;
end;
function TDomicilio.GetTipoDomicilioID: integer;
begin
	Result := FCampos.Campo[TIndiceDomicilio.TipoDomicilioID].AsInteger;
end;
function TDomicilio.GetPersonaID: integer;
begin
	Result := FCampos.Campo[TIndiceDomicilio.PersonaID].AsInteger;
end;
function TDomicilio.GetCalle: string;
begin
	Result := FCampos.Campo[TIndiceDomicilio.Calle].AsString;
end;
function TDomicilio.GetNumero: integer;
begin
	Result := FCampos.Campo[TIndiceDomicilio.Numero].AsInteger;
end;
procedure TDomicilio.SetDomicilioID(const Value: integer);
begin
	FCampos.Campo[TIndiceDomicilio.DomicilioID].AsInteger:= Value;
end;	
procedure TDomicilio.SetTipoDomicilioID(const Value: integer);
begin
	FCampos.Campo[TIndiceDomicilio.TipoDomicilioID].AsInteger:= Value;
end;	
procedure TDomicilio.SetPersonaID(const Value: integer);
begin
	FCampos.Campo[TIndiceDomicilio.PersonaID].AsInteger:= Value;
end;	
procedure TDomicilio.SetCalle(const Value: string);
begin
	FCampos.Campo[TIndiceDomicilio.Calle].AsString:= Value;
end;	
procedure TDomicilio.SetNumero(const Value: integer);
begin
	FCampos.Campo[TIndiceDomicilio.Numero].AsInteger:= Value;
end;	
function TDomicilio.ObtenerEntidad(const DomicilioID: integer): boolean;
var
	select : TSelectStatement;
begin
	select := TSelectStatement.Create(FCampos);
	select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.Campo[TIndiceDomicilio.DomicilioID], tcIgual, DomicilioID));
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
	FCampos.Agregar(TCampo.Create(Tabla,'PerdonaID', 'Persona','','',TIndicePersona.PerdonaID, 0,  True, True,False, True, tdInteger, faNinguna,0));
	FCampos.Agregar(TCampo.Create(Tabla,'Apellido', '','','',TIndicePersona.Apellido, 50,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TCampo.Create(Tabla,'Nombre', '','','',TIndicePersona.Nombre, 50,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TCampo.Create(Tabla,'TipoDocumentoID', '','','',TIndicePersona.TipoDocumentoID, 0,  False, False,True, False, tdInteger, faNinguna,0));
	FCampos.Agregar(TCampo.Create(Tabla,'NumeroDocumento', '','','',TIndicePersona.NumeroDocumento, 0,  False, False,False, False, tdInteger, faNinguna,0));
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
function TPersona.CrearNuevaConexionEntidad: TEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion; 
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TPersona.GetCampo(IndiceCampo: integer): TCampo;
begin
	Result := FCampos.Campo[IndiceCampo];
end;	
constructor TPersona.Create(const PerdonaID: integer);
begin
	Create;
	ObtenerEntidad(PerdonaID);
end;	
function TPersona.GetPerdonaID: integer;
begin
	Result := FCampos.Campo[TIndicePersona.PerdonaID].AsInteger;
end;
function TPersona.GetApellido: string;
begin
	Result := FCampos.Campo[TIndicePersona.Apellido].AsString;
end;
function TPersona.GetNombre: string;
begin
	Result := FCampos.Campo[TIndicePersona.Nombre].AsString;
end;
function TPersona.GetTipoDocumentoID: integer;
begin
	Result := FCampos.Campo[TIndicePersona.TipoDocumentoID].AsInteger;
end;
function TPersona.GetNumeroDocumento: integer;
begin
	Result := FCampos.Campo[TIndicePersona.NumeroDocumento].AsInteger;
end;
procedure TPersona.SetPerdonaID(const Value: integer);
begin
	FCampos.Campo[TIndicePersona.PerdonaID].AsInteger:= Value;
end;	
procedure TPersona.SetApellido(const Value: string);
begin
	FCampos.Campo[TIndicePersona.Apellido].AsString:= Value;
end;	
procedure TPersona.SetNombre(const Value: string);
begin
	FCampos.Campo[TIndicePersona.Nombre].AsString:= Value;
end;	
procedure TPersona.SetTipoDocumentoID(const Value: integer);
begin
	FCampos.Campo[TIndicePersona.TipoDocumentoID].AsInteger:= Value;
end;	
procedure TPersona.SetNumeroDocumento(const Value: integer);
begin
	FCampos.Campo[TIndicePersona.NumeroDocumento].AsInteger:= Value;
end;	
function TPersona.ObtenerEntidad(const PerdonaID: integer): boolean;
var
	select : TSelectStatement;
begin
	select := TSelectStatement.Create(FCampos);
	select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.Campo[TIndicePersona.PerdonaID], tcIgual, PerdonaID));
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
		unFiltro.Agregar(TCondicionComparacion.Create(FColeccionDomicilio.FCampos.Campo[TIndiceDomicilio.PersonaID], tcIgual, PerdonaID));
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
	FCampos.Agregar(TCampo.Create(Tabla,'TipoDocumentoID', 'TipoDocumento','','',TIndiceTipoDocumento.TipoDocumentoID, 0,  True, True,False, True, tdInteger, faNinguna,0));
	FCampos.Agregar(TCampo.Create(Tabla,'Descripcion', '','','',TIndiceTipoDocumento.Descripcion, 50,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TCampo.Create(Tabla,'DescripcionReducida', '','','',TIndiceTipoDocumento.DescripcionReducida, 20,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TCampo.Create(Tabla,'Observaciones', '','','',TIndiceTipoDocumento.Observaciones, 100,  False, False,False, False, tdString, faNinguna,''));
	FColeccionPersona:=nil;
end;
destructor TTipoDocumento.Destroy;
begin
	if assigned(FColeccionPersona) then
		FColeccionPersona.Free;
	inherited;
end;
function TTipoDocumento.CrearNuevaConexionEntidad: TEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion; 
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TTipoDocumento.GetCampo(IndiceCampo: integer): TCampo;
begin
	Result := FCampos.Campo[IndiceCampo];
end;	
constructor TTipoDocumento.Create(const TipoDocumentoID: integer);
begin
	Create;
	ObtenerEntidad(TipoDocumentoID);
end;	
function TTipoDocumento.GetTipoDocumentoID: integer;
begin
	Result := FCampos.Campo[TIndiceTipoDocumento.TipoDocumentoID].AsInteger;
end;
function TTipoDocumento.GetDescripcion: string;
begin
	Result := FCampos.Campo[TIndiceTipoDocumento.Descripcion].AsString;
end;
function TTipoDocumento.GetDescripcionReducida: string;
begin
	Result := FCampos.Campo[TIndiceTipoDocumento.DescripcionReducida].AsString;
end;
function TTipoDocumento.GetObservaciones: string;
begin
	Result := FCampos.Campo[TIndiceTipoDocumento.Observaciones].AsString;
end;
procedure TTipoDocumento.SetTipoDocumentoID(const Value: integer);
begin
	FCampos.Campo[TIndiceTipoDocumento.TipoDocumentoID].AsInteger:= Value;
end;	
procedure TTipoDocumento.SetDescripcion(const Value: string);
begin
	FCampos.Campo[TIndiceTipoDocumento.Descripcion].AsString:= Value;
end;	
procedure TTipoDocumento.SetDescripcionReducida(const Value: string);
begin
	FCampos.Campo[TIndiceTipoDocumento.DescripcionReducida].AsString:= Value;
end;	
procedure TTipoDocumento.SetObservaciones(const Value: string);
begin
	FCampos.Campo[TIndiceTipoDocumento.Observaciones].AsString:= Value;
end;	
function TTipoDocumento.ObtenerEntidad(const TipoDocumentoID: integer): boolean;
var
	select : TSelectStatement;
begin
	select := TSelectStatement.Create(FCampos);
	select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.Campo[TIndiceTipoDocumento.TipoDocumentoID], tcIgual, TipoDocumentoID));
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
		unFiltro.Agregar(TCondicionComparacion.Create(FColeccionPersona.FCampos.Campo[TIndicePersona.TipoDocumentoID], tcIgual, TipoDocumentoID));
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
	FCampos.Agregar(TCampo.Create(Tabla,'TipoDomicilioID', 'TipoDomicilio','','',TIndiceTipoDomicilio.TipoDomicilioID, 0,  True, True,False, True, tdInteger, faNinguna,0));
	FCampos.Agregar(TCampo.Create(Tabla,'Descripcion', '','','',TIndiceTipoDomicilio.Descripcion, 50,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TCampo.Create(Tabla,'DescripcionReducida', '','','',TIndiceTipoDomicilio.DescripcionReducida, 30,  False, False,False, False, tdString, faNinguna,''));
	FCampos.Agregar(TCampo.Create(Tabla,'Observaciones', '','','',TIndiceTipoDomicilio.Observaciones, 100,  False, False,False, False, tdString, faNinguna,''));
	FColeccionDomicilio:=nil;
end;
destructor TTipoDomicilio.Destroy;
begin
	if assigned(FColeccionDomicilio) then
		FColeccionDomicilio.Free;
	inherited;
end;
function TTipoDomicilio.CrearNuevaConexionEntidad: TEntidadConexion;
begin
	Result := TFabricauTestEntidades.CrearNuevaEntidadConexion; 
	if assigned(OnuTestEntidadesException) then
	   Result.SQLManager.OnExceptionEvent := OnuTestEntidadesException; 
end;
function TTipoDomicilio.GetCampo(IndiceCampo: integer): TCampo;
begin
	Result := FCampos.Campo[IndiceCampo];
end;	
constructor TTipoDomicilio.Create(const TipoDomicilioID: integer);
begin
	Create;
	ObtenerEntidad(TipoDomicilioID);
end;	
function TTipoDomicilio.GetTipoDomicilioID: integer;
begin
	Result := FCampos.Campo[TIndiceTipoDomicilio.TipoDomicilioID].AsInteger;
end;
function TTipoDomicilio.GetDescripcion: string;
begin
	Result := FCampos.Campo[TIndiceTipoDomicilio.Descripcion].AsString;
end;
function TTipoDomicilio.GetDescripcionReducida: string;
begin
	Result := FCampos.Campo[TIndiceTipoDomicilio.DescripcionReducida].AsString;
end;
function TTipoDomicilio.GetObservaciones: string;
begin
	Result := FCampos.Campo[TIndiceTipoDomicilio.Observaciones].AsString;
end;
procedure TTipoDomicilio.SetTipoDomicilioID(const Value: integer);
begin
	FCampos.Campo[TIndiceTipoDomicilio.TipoDomicilioID].AsInteger:= Value;
end;	
procedure TTipoDomicilio.SetDescripcion(const Value: string);
begin
	FCampos.Campo[TIndiceTipoDomicilio.Descripcion].AsString:= Value;
end;	
procedure TTipoDomicilio.SetDescripcionReducida(const Value: string);
begin
	FCampos.Campo[TIndiceTipoDomicilio.DescripcionReducida].AsString:= Value;
end;	
procedure TTipoDomicilio.SetObservaciones(const Value: string);
begin
	FCampos.Campo[TIndiceTipoDomicilio.Observaciones].AsString:= Value;
end;	
function TTipoDomicilio.ObtenerEntidad(const TipoDomicilioID: integer): boolean;
var
	select : TSelectStatement;
begin
	select := TSelectStatement.Create(FCampos);
	select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.Campo[TIndiceTipoDomicilio.TipoDomicilioID], tcIgual, TipoDomicilioID));
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
		unFiltro.Agregar(TCondicionComparacion.Create(FColeccionDomicilio.FCampos.Campo[TIndiceDomicilio.TipoDomicilioID], tcIgual, TipoDomicilioID));
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
	FCampos := unaEntidad.Campos.Clonar;
	unaEntidad.Free;
end;
function TColeccionDomicilio.CrearNuevaConexionEntidad: TEntidadConexion;
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
function TColeccionDomicilio.GetCampo(indiceCampo: integer):TCampo;
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
			   unaEntidad.Campos[TIndiceDomicilio.DomicilioID].EsNulo := true
			else
				unaEntidad.DomicilioID := Datos.Fields[TIndiceDomicilio.DomicilioID].AsInteger;
			if (Datos.Fields[TIndiceDomicilio.TipoDomicilioID].IsNull) then
			   unaEntidad.Campos[TIndiceDomicilio.TipoDomicilioID].EsNulo := true
			else
				unaEntidad.TipoDomicilioID := Datos.Fields[TIndiceDomicilio.TipoDomicilioID].AsInteger;
			if (Datos.Fields[TIndiceDomicilio.PersonaID].IsNull) then
			   unaEntidad.Campos[TIndiceDomicilio.PersonaID].EsNulo := true
			else
				unaEntidad.PersonaID := Datos.Fields[TIndiceDomicilio.PersonaID].AsInteger;
			if (Datos.Fields[TIndiceDomicilio.Calle].IsNull) then
			   unaEntidad.Campos[TIndiceDomicilio.Calle].EsNulo := true
			else
				unaEntidad.Calle := Datos.Fields[TIndiceDomicilio.Calle].AsString;
			if (Datos.Fields[TIndiceDomicilio.Numero].IsNull) then
			   unaEntidad.Campos[TIndiceDomicilio.Numero].EsNulo := true
			else
				unaEntidad.Numero := Datos.Fields[TIndiceDomicilio.Numero].AsInteger;
			unaEntidad.Campos.FueronCambiados := false;
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
	FCampos := unaEntidad.Campos.Clonar;
	unaEntidad.Free;
end;
function TColeccionPersona.CrearNuevaConexionEntidad: TEntidadConexion;
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
function TColeccionPersona.GetCampo(indiceCampo: integer):TCampo;
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
			   unaEntidad.Campos[TIndicePersona.PerdonaID].EsNulo := true
			else
				unaEntidad.PerdonaID := Datos.Fields[TIndicePersona.PerdonaID].AsInteger;
			if (Datos.Fields[TIndicePersona.Apellido].IsNull) then
			   unaEntidad.Campos[TIndicePersona.Apellido].EsNulo := true
			else
				unaEntidad.Apellido := Datos.Fields[TIndicePersona.Apellido].AsString;
			if (Datos.Fields[TIndicePersona.Nombre].IsNull) then
			   unaEntidad.Campos[TIndicePersona.Nombre].EsNulo := true
			else
				unaEntidad.Nombre := Datos.Fields[TIndicePersona.Nombre].AsString;
			if (Datos.Fields[TIndicePersona.TipoDocumentoID].IsNull) then
			   unaEntidad.Campos[TIndicePersona.TipoDocumentoID].EsNulo := true
			else
				unaEntidad.TipoDocumentoID := Datos.Fields[TIndicePersona.TipoDocumentoID].AsInteger;
			if (Datos.Fields[TIndicePersona.NumeroDocumento].IsNull) then
			   unaEntidad.Campos[TIndicePersona.NumeroDocumento].EsNulo := true
			else
				unaEntidad.NumeroDocumento := Datos.Fields[TIndicePersona.NumeroDocumento].AsInteger;
			unaEntidad.Campos.FueronCambiados := false;
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
	FCampos := unaEntidad.Campos.Clonar;
	unaEntidad.Free;
end;
function TColeccionTipoDocumento.CrearNuevaConexionEntidad: TEntidadConexion;
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
function TColeccionTipoDocumento.GetCampo(indiceCampo: integer):TCampo;
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
			   unaEntidad.Campos[TIndiceTipoDocumento.TipoDocumentoID].EsNulo := true
			else
				unaEntidad.TipoDocumentoID := Datos.Fields[TIndiceTipoDocumento.TipoDocumentoID].AsInteger;
			if (Datos.Fields[TIndiceTipoDocumento.Descripcion].IsNull) then
			   unaEntidad.Campos[TIndiceTipoDocumento.Descripcion].EsNulo := true
			else
				unaEntidad.Descripcion := Datos.Fields[TIndiceTipoDocumento.Descripcion].AsString;
			if (Datos.Fields[TIndiceTipoDocumento.DescripcionReducida].IsNull) then
			   unaEntidad.Campos[TIndiceTipoDocumento.DescripcionReducida].EsNulo := true
			else
				unaEntidad.DescripcionReducida := Datos.Fields[TIndiceTipoDocumento.DescripcionReducida].AsString;
			if (Datos.Fields[TIndiceTipoDocumento.Observaciones].IsNull) then
			   unaEntidad.Campos[TIndiceTipoDocumento.Observaciones].EsNulo := true
			else
				unaEntidad.Observaciones := Datos.Fields[TIndiceTipoDocumento.Observaciones].AsString;
			unaEntidad.Campos.FueronCambiados := false;
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
	FCampos := unaEntidad.Campos.Clonar;
	unaEntidad.Free;
end;
function TColeccionTipoDomicilio.CrearNuevaConexionEntidad: TEntidadConexion;
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
function TColeccionTipoDomicilio.GetCampo(indiceCampo: integer):TCampo;
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
			   unaEntidad.Campos[TIndiceTipoDomicilio.TipoDomicilioID].EsNulo := true
			else
				unaEntidad.TipoDomicilioID := Datos.Fields[TIndiceTipoDomicilio.TipoDomicilioID].AsInteger;
			if (Datos.Fields[TIndiceTipoDomicilio.Descripcion].IsNull) then
			   unaEntidad.Campos[TIndiceTipoDomicilio.Descripcion].EsNulo := true
			else
				unaEntidad.Descripcion := Datos.Fields[TIndiceTipoDomicilio.Descripcion].AsString;
			if (Datos.Fields[TIndiceTipoDomicilio.DescripcionReducida].IsNull) then
			   unaEntidad.Campos[TIndiceTipoDomicilio.DescripcionReducida].EsNulo := true
			else
				unaEntidad.DescripcionReducida := Datos.Fields[TIndiceTipoDomicilio.DescripcionReducida].AsString;
			if (Datos.Fields[TIndiceTipoDomicilio.Observaciones].IsNull) then
			   unaEntidad.Campos[TIndiceTipoDomicilio.Observaciones].EsNulo := true
			else
				unaEntidad.Observaciones := Datos.Fields[TIndiceTipoDomicilio.Observaciones].AsString;
			unaEntidad.Campos.FueronCambiados := false;
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

{TRelacionDomicilio}
class function TRelacionDomicilio.TipoDomicilio(TipoRelacion: TTipoRelacion): TRelacion;
var
	sCamposOrigen, sCamposDestino: TStringList;
	CamposOrigen, CamposDestino: TCamposRelacion; 
begin
	sCamposOrigen := TStringList.Create;
	sCamposDestino:= TStringList.Create;
	sCamposOrigen.Add(TCampoDomicilio.TipoDomicilioID);
	sCamposDestino.Add(TCampoTipoDomicilio.TipoDomicilioID);
	CamposOrigen := TCamposRelacion.Create('Domicilio', sCamposOrigen);
	CamposDestino:= TCamposRelacion.Create('TipoDomicilio', sCamposDestino);  
	Result := TRelacion.Create(	CamposOrigen, CamposDestino,
		   	  					TipoRelacion);
	FreeAndNil(CamposOrigen);
	FreeAndNil(CamposDestino);    
	FreeAndNil(sCamposOrigen);
	FreeAndNil(sCamposDestino);	   	  														   				  						   
end;
{TRelacionDomicilio}
class function TRelacionDomicilio.Persona(TipoRelacion: TTipoRelacion): TRelacion;
var
	sCamposOrigen, sCamposDestino: TStringList;
	CamposOrigen, CamposDestino: TCamposRelacion; 
begin
	sCamposOrigen := TStringList.Create;
	sCamposDestino:= TStringList.Create;
	sCamposOrigen.Add(TCampoDomicilio.PersonaID);
	sCamposDestino.Add(TCampoPersona.PerdonaID);
	CamposOrigen := TCamposRelacion.Create('Domicilio', sCamposOrigen);
	CamposDestino:= TCamposRelacion.Create('Persona', sCamposDestino);  
	Result := TRelacion.Create(	CamposOrigen, CamposDestino,
		   	  					TipoRelacion);
	FreeAndNil(CamposOrigen);
	FreeAndNil(CamposDestino);    
	FreeAndNil(sCamposOrigen);
	FreeAndNil(sCamposDestino);	   	  														   				  						   
end;
{TRelacionPersona}
class function TRelacionPersona.TipoDocumento(TipoRelacion: TTipoRelacion): TRelacion;
var
	sCamposOrigen, sCamposDestino: TStringList;
	CamposOrigen, CamposDestino: TCamposRelacion; 
begin
	sCamposOrigen := TStringList.Create;
	sCamposDestino:= TStringList.Create;
	sCamposOrigen.Add(TCampoPersona.TipoDocumentoID);
	sCamposDestino.Add(TCampoTipoDocumento.TipoDocumentoID);
	CamposOrigen := TCamposRelacion.Create('Persona', sCamposOrigen);
	CamposDestino:= TCamposRelacion.Create('TipoDocumento', sCamposDestino);  
	Result := TRelacion.Create(	CamposOrigen, CamposDestino,
		   	  					TipoRelacion);
	FreeAndNil(CamposOrigen);
	FreeAndNil(CamposDestino);    
	FreeAndNil(sCamposOrigen);
	FreeAndNil(sCamposDestino);	   	  														   				  						   
end;
class function TRelacionPersona.Domicilio(TipoRelacion: TTipoRelacion): TRelacion;
var
	sCamposOrigen, sCamposDestino: TStringList;
	CamposOrigen, CamposDestino: TCamposRelacion; 
begin
	sCamposOrigen := TStringList.Create;
	sCamposDestino:= TStringList.Create;
	sCamposOrigen.Add(TCampoPersona.PerdonaID);
	sCamposDestino.Add(TCampoDomicilio.PersonaID);
	CamposOrigen:= TCamposRelacion.Create('Persona', sCamposOrigen);
	CamposDestino:= TCamposRelacion.Create('Domicilio', sCamposDestino); 
	Result := TRelacion.Create(CamposOrigen, CamposDestino, TipoRelacion);
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
	FCampos.Agregar(TCampo.Create('Persona','PerdonaID', '','PerdonaID','',TIndiceListaPersona.PerdonaID, 0,  false, false,false,false,tdInteger, faNinguna,''));
	FCampos.Agregar(TCampo.Create('Persona','Apellido', '','Apellido','',TIndiceListaPersona.Apellido, 50,  false, false,false,false,tdString, faNinguna,''));
	FCampos.Agregar(TCampo.Create('Persona','Nombre', '','Nombre','',TIndiceListaPersona.Nombre, 50,  false, false,false,false,tdString, faNinguna,''));
	FCampos.Agregar(TCampo.Create('TipoDocumento','Descripcion', '','DescripcionTipoDocumento','',TIndiceListaPersona.DescripcionTipoDocumento, 50,  false, false,false,false,tdString, faNinguna,''));
end;
destructor TFilaListaPersona.Destroy;
begin
	inherited;
end;
function TFilaListaPersona.CrearNuevaConexionEntidad: TEntidadConexion; 
begin
	Result := nil;
end;
function TFilaListaPersona.GetPerdonaID: integer;
begin
	Result := FCampos.Campo[TIndiceListaPersona.PerdonaID].AsInteger; 
end;
procedure TFilaListaPersona.SetPerdonaID(const Value: integer);
begin
	FCampos.Campo[TIndiceListaPersona.PerdonaID].AsInteger:= Value;
end;	
function TFilaListaPersona.GetApellido: string;
begin
	Result := FCampos.Campo[TIndiceListaPersona.Apellido].AsString; 
end;
procedure TFilaListaPersona.SetApellido(const Value: string);
begin
	FCampos.Campo[TIndiceListaPersona.Apellido].AsString:= Value;
end;	
function TFilaListaPersona.GetNombre: string;
begin
	Result := FCampos.Campo[TIndiceListaPersona.Nombre].AsString; 
end;
procedure TFilaListaPersona.SetNombre(const Value: string);
begin
	FCampos.Campo[TIndiceListaPersona.Nombre].AsString:= Value;
end;	
function TFilaListaPersona.GetDescripcionTipoDocumento: string;
begin
	Result := FCampos.Campo[TIndiceListaPersona.DescripcionTipoDocumento].AsString; 
end;
procedure TFilaListaPersona.SetDescripcionTipoDocumento(const Value: string);
begin
	FCampos.Campo[TIndiceListaPersona.DescripcionTipoDocumento].AsString:= Value;
end;	

{TListaPersona}
constructor TListaPersona.Create;
var
	unaEntidad: TFilaListaPersona;
begin
	inherited Create( TFilaListaPersona );
	unaEntidad := TFilaListaPersona.Create;
	FCampos := unaEntidad.Campos.Clonar;
	unaEntidad.Free;
end;
destructor TListaPersona.Destroy;
begin
	inherited;
end;
function TListaPersona.CrearNuevaConexionEntidad: TEntidadConexion;
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
		Relacion.Agregar(TRelacionPersona.TipoDocumento);
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
			Relaciones.Agregar(TRelacionPersona.TipoDocumento);
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
			    unaEntidad.Campos[TIndiceListaPersona.PerdonaID].EsNulo := true
			else
				unaEntidad.PerdonaID := Datos.Fields[TIndiceListaPersona.PerdonaID].AsInteger;
			if (Datos.Fields[TIndiceListaPersona.Apellido].IsNull) then
			    unaEntidad.Campos[TIndiceListaPersona.Apellido].EsNulo := true
			else
				unaEntidad.Apellido := Datos.Fields[TIndiceListaPersona.Apellido].AsString;
			if (Datos.Fields[TIndiceListaPersona.Nombre].IsNull) then
			    unaEntidad.Campos[TIndiceListaPersona.Nombre].EsNulo := true
			else
				unaEntidad.Nombre := Datos.Fields[TIndiceListaPersona.Nombre].AsString;
			if (Datos.Fields[TIndiceListaPersona.DescripcionTipoDocumento].IsNull) then
			    unaEntidad.Campos[TIndiceListaPersona.DescripcionTipoDocumento].EsNulo := true
			else
				unaEntidad.DescripcionTipoDocumento := Datos.Fields[TIndiceListaPersona.DescripcionTipoDocumento].AsString;
			unaEntidad.Campos.FueronCambiados := false;
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


class function TFabricaCampoDomicilio.DomicilioID: TCampo;
begin
	Result := TCampo.Create('Domicilio','DomicilioID', 'Domicilio','','',TIndiceDomicilio.DomicilioID, 0,  True, True,False, True, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoDomicilio.TipoDomicilioID: TCampo;
begin
	Result := TCampo.Create('Domicilio','TipoDomicilioID', '','','',TIndiceDomicilio.TipoDomicilioID, 0,  False, False,True, False, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoDomicilio.PersonaID: TCampo;
begin
	Result := TCampo.Create('Domicilio','PersonaID', '','','',TIndiceDomicilio.PersonaID, 0,  False, False,True, False, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoDomicilio.Calle: TCampo;
begin
	Result := TCampo.Create('Domicilio','Calle', '','','',TIndiceDomicilio.Calle, 50,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoDomicilio.Numero: TCampo;
begin
	Result := TCampo.Create('Domicilio','Numero', '','','',TIndiceDomicilio.Numero, 0,  False, False,False, False, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoPersona.PerdonaID: TCampo;
begin
	Result := TCampo.Create('Persona','PerdonaID', 'Persona','','',TIndicePersona.PerdonaID, 0,  True, True,False, True, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoPersona.Apellido: TCampo;
begin
	Result := TCampo.Create('Persona','Apellido', '','','',TIndicePersona.Apellido, 50,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoPersona.Nombre: TCampo;
begin
	Result := TCampo.Create('Persona','Nombre', '','','',TIndicePersona.Nombre, 50,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoPersona.TipoDocumentoID: TCampo;
begin
	Result := TCampo.Create('Persona','TipoDocumentoID', '','','',TIndicePersona.TipoDocumentoID, 0,  False, False,True, False, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoPersona.NumeroDocumento: TCampo;
begin
	Result := TCampo.Create('Persona','NumeroDocumento', '','','',TIndicePersona.NumeroDocumento, 0,  False, False,False, False, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoTipoDocumento.TipoDocumentoID: TCampo;
begin
	Result := TCampo.Create('TipoDocumento','TipoDocumentoID', 'TipoDocumento','','',TIndiceTipoDocumento.TipoDocumentoID, 0,  True, True,False, True, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoTipoDocumento.Descripcion: TCampo;
begin
	Result := TCampo.Create('TipoDocumento','Descripcion', '','','',TIndiceTipoDocumento.Descripcion, 50,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoTipoDocumento.DescripcionReducida: TCampo;
begin
	Result := TCampo.Create('TipoDocumento','DescripcionReducida', '','','',TIndiceTipoDocumento.DescripcionReducida, 20,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoTipoDocumento.Observaciones: TCampo;
begin
	Result := TCampo.Create('TipoDocumento','Observaciones', '','','',TIndiceTipoDocumento.Observaciones, 100,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoTipoDomicilio.TipoDomicilioID: TCampo;
begin
	Result := TCampo.Create('TipoDomicilio','TipoDomicilioID', 'TipoDomicilio','','',TIndiceTipoDomicilio.TipoDomicilioID, 0,  True, True,False, True, tdInteger, faNinguna,0); 
end;
class function TFabricaCampoTipoDomicilio.Descripcion: TCampo;
begin
	Result := TCampo.Create('TipoDomicilio','Descripcion', '','','',TIndiceTipoDomicilio.Descripcion, 50,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoTipoDomicilio.DescripcionReducida: TCampo;
begin
	Result := TCampo.Create('TipoDomicilio','DescripcionReducida', '','','',TIndiceTipoDomicilio.DescripcionReducida, 30,  False, False,False, False, tdString, faNinguna,''); 
end;
class function TFabricaCampoTipoDomicilio.Observaciones: TCampo;
begin
	Result := TCampo.Create('TipoDomicilio','Observaciones', '','','',TIndiceTipoDomicilio.Observaciones, 100,  False, False,False, False, tdString, faNinguna,''); 
end;



initialization
	SQLConnectionGenerator := TSQLConnectionGenerator.Create;
	SingleConnection := nil;
finalization
	FreeAndNil(SQLConnectionGenerator);
	if assigned(SingleConnection) then FreeAndNil(SingleConnection);

End.

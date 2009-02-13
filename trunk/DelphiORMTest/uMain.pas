unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, DB, uTestEntidades;

type
  TFrmPrincipal = class(TForm)
    btnAgregarTipoDocumento: TButton;
    btnAgregarTipoDomicilio: TButton;
    btnAgregarPersona: TButton;
    dbgrd: TDBGrid;
    btnVerTipoDocumento: TButton;
    btnVerTipoDom: TButton;
    btnVerPersonas: TButton;
    ds: TDataSource;
    btnVerLista: TButton;
    btnPersDom: TButton;
    btnPersonaDocumento: TButton;
    btnObtener: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAgregarTipoDocumentoClick(Sender: TObject);
    procedure btnAgregarTipoDomicilioClick(Sender: TObject);
    procedure btnAgregarPersonaClick(Sender: TObject);
    procedure btnObtenerClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPersDomClick(Sender: TObject);
    procedure btnPersonaDocumentoClick(Sender: TObject);
    procedure btnVerListaClick(Sender: TObject);
  private
    { Private declarations }
    unaPersonaPrivada: TPersona;
    unaLista: TListaPersona;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses uDataModule;

{$R *.dfm}

procedure TFrmPrincipal.btnAgregarPersonaClick(Sender: TObject);
var
  unaPersona: TPersona;
begin
  unaPersona := TPersona.Create;
  unaPersona.Apellido := 'Perez';
  unaPersona.Nombre := 'Juan';
  unaPersona.TipoDocumentoID := 1; //DNI
  unaPersona.NumeroDocumento := 33333333;

  //Ahora agrego los domicilios
  with TDomicilio.Create(unaPersona.ColeccionDomicilio) do
  begin
    TipoDomicilioID := 1; //Particular
    Calle := 'Cucha Cucha';
    Numero := 5655;
  end;

  //Ahora agrego los domicilios
  with TDomicilio.Create(unaPersona.ColeccionDomicilio) do
  begin
    TipoDomicilioID := 2; //Laboral
    Calle := 'San Martin';
    Numero := 1225;
  end;

  unaPersona.Guardar;
  unaPersona.Free;
end;

procedure TFrmPrincipal.btnAgregarTipoDocumentoClick(Sender: TObject);
var
  unTipoDoc: TTipoDocumento;
begin
  unTipoDoc:= TTipoDocumento.Create;
  unTipoDoc.Descripcion := 'Documento Nacional de Identidad';
  unTipoDoc.DescripcionReducida := 'DNI';
  unTipoDoc.Observaciones := 'Nada';
  unTipoDoc.Guardar;
  unTipoDoc.Free;

  unTipoDoc:= TTipoDocumento.Create;
  unTipoDoc.Descripcion := 'Cédula';
  unTipoDoc.DescripcionReducida := 'Cédula';
  unTipoDoc.Observaciones := 'Nada 2';
  unTipoDoc.Guardar;
  unTipoDoc.Free;

  unTipoDoc:= TTipoDocumento.Create;
  unTipoDoc.Descripcion := 'Libreta Cívica';
  unTipoDoc.DescripcionReducida := 'LC';
  unTipoDoc.Campos[TIndiceTipoDocumento.Observaciones].EsNulo := true;
  unTipoDoc.Guardar;
  unTipoDoc.Free;
end;

procedure TFrmPrincipal.btnAgregarTipoDomicilioClick(Sender: TObject);
var
  Coleccion: TColeccionTipoDomicilio;
begin
  Coleccion := TColeccionTipoDomicilio.Create;
  with TTipoDomicilio.Create(Coleccion) do
  begin
    Descripcion := 'Particular';
    DescripcionReducida := 'Particular';
  end;

  with TTipoDomicilio.Create(Coleccion) do
  begin
    Descripcion := 'Laboral';
    DescripcionReducida := 'Laboral';
  end;

  with TTipoDomicilio.Create(Coleccion) do
  begin
    Descripcion := 'Constituido';
    DescripcionReducida := 'Constituido';
  end;
  Coleccion.Guardar;
  Coleccion.Free;
end;

procedure TFrmPrincipal.btnObtenerClick(Sender: TObject);
begin
  unaPersonaPrivada := TPersona.Create(1); // Le paso el ID = 1
end;

procedure TFrmPrincipal.btnPersDomClick(Sender: TObject);
begin
  ds.DataSet := unaPersonaPrivada.ColeccionDomicilio.AsDataSet;
  ds.DataSet.Open;
end;

procedure TFrmPrincipal.btnPersonaDocumentoClick(Sender: TObject);
begin
  ShowMessage(unaPersonaPrivada.TipoDocumento.Descripcion);
end;

procedure TFrmPrincipal.btnVerListaClick(Sender: TObject);
begin
  if not Assigned(unaLista) then
    unaLista := TListaPersona.Create;
  unaLista.ObtenerTodos;

  ds.DataSet := unaLista.AsDataSet;
  ds.DataSet.Open;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  uDataModule.sDataBase := 'localhost:c:\Desarrollos\Delphi\DelphiORM\DelphiORMTest\Datos\DelphiORM.fdb';
  SingleConnection := TFabricauTestEntidades.CrearNuevaEntidadConexion(true);
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  if Assigned(unaPersonaPrivada)  then
    FreeAndNil(unaPErsonaPrivada);
  if assigned(unaLista) then
    FreeAndNil(unaLista);
  
end;

end.

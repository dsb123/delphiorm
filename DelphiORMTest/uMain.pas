unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, DB;

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
    btn1: TButton;
    mmo1: TMemo;
    btnListaTipo: TButton;
    Button1: TButton;
    btn2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btnListaTipoClick(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btnVerTipoDocumentoClick(Sender: TObject);
    procedure btnVerListaClick(Sender: TObject);
  private
    { Private declarations }
    //unaPersonaPrivada: TPersona;
    //unaLista: TListaPersona;
    procedure AtraparErrores(e: exception);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses  uDataModule,
      uExpresiones,
      uTestEntidades;

{$R *.dfm}

procedure TFrmPrincipal.AtraparErrores(e: exception);
begin
  ShowMessage(e.Message);
end;

procedure TFrmPrincipal.btn1Click(Sender: TObject);
begin
  ds.DataSet.Post;
  //unaPersonaPrivada.Guardar;
end;

procedure TFrmPrincipal.btn2Click(Sender: TObject);
var
  unaPersona : TPersona;
begin
  unaPersona := TPersona.Create(1);
  unaPersona.Nombre := 'Gabrieliiiiiiiiito';
  unaPersona.Apellido := 'Melgar';
  unaPersona.TipoDocumento.Descripcion := 'DNI';
  unaPersona.NumeroDocumento := 25459633;
  unaPersona.Guardar;
  FreeAndNil(unaPersona);
end;

procedure TFrmPrincipal.btnListaTipoClick(Sender: TObject);
var
  unaColeccion: TColeccionTipoDocumento;
  unTipoPersona: TTipoDocumento;
begin
  unaColeccion:= TColeccionTipoDocumento.Create;
  unaColeccion.ObtenerTodos;

  for unTipoPersona in unaColeccion do
  begin
    mmo1.Lines.Add(unTipoPersona.Descripcion);
  end;

  FreeAndNil(unaColeccion);
end;

procedure TFrmPrincipal.btnVerListaClick(Sender: TObject);
var
  unaLista: TListaPersona;
begin
  unaLista := TListaPersona.Create;
  unaLista.ObtenerTodos;

  ShowMessage(IntToStr(unaLista.Count));
  ShowMessage(unaLista[0].DescripcionTipoDocumento);

  FreeAndNil(unaLista);

end;

procedure TFrmPrincipal.btnVerTipoDocumentoClick(Sender: TObject);
var
  unaColeccion: TColeccionPersona;
  unPersona: TPersona;
begin
  unaColeccion:= TColeccionPersona.Create;
  unaColeccion.ObtenerTodos;

  for unPersona in unaColeccion do
  begin
    mmo1.Lines.Add(unPersona.Nombre + ', ' + unPersona.Apellido);
  end;

  FreeAndNil(unaColeccion);
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  uDataModule.sDataBase := '192.168.0.107:1521/XE';
  SingleConnection := uTestEntidades.TFabricauTestEntidades.CrearNuevaEntidadConexion(True);
end;

end.

unit uFrmEditorEntidad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvgLabel, JvExControls, JvGradient, ExtCtrls, StdCtrls, NxColumns,
  NxColumnClasses, Mask, JvExMask, JvToolEdit, AdvCombobox, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, ImgList, uCoreClasses;

type
  TFrmEditorEntidad = class(TForm)
    barSuperior: TJvGradient;
    jvgTitulo: TJvgLabel;
    img1: TImage;
    bvl1: TBevel;
    pnlBottom: TPanel;
    bvlBottom: TBevel;
    btnCerrar: TButton;
    nxtgrdCampos: TNextGrid;
    lblGenerador: TLabel;
    cbGenerador: TAdvComboBox;
    colTextNombre: TNxTextColumn;
    colTextTipo: TNxTextColumn;
    colTextSubTipo: TNxTextColumn;
    colTextLongitud: TNxTextColumn;
    colImgClavePrimaria: TNxImageColumn;
    colImgClaveForanea: TNxImageColumn;
    ilCampos: TImageList;
    colImgTextAceptaNulos: TNxImageColumn;
    procedure btnCerrarClick(Sender: TObject);
    procedure cbGeneradorSelectItem(Sender: TObject);
  private
    { Private declarations }
    FGeneradores: TColeccionGenerador;
    FTabla: TTabla;
    procedure SetGeneradores(const Value: TColeccionGenerador);
    procedure SetTabla(const Value: TTabla);
  public
    { Public declarations }
    procedure SetTopColor(ColorDesde: TColor; ColorHasta: TColor);

    property Generadores: TColeccionGenerador read FGeneradores write SetGeneradores;
    property Tabla: TTabla read FTabla write SetTabla;

  end;

var
  FrmEditorEntidad: TFrmEditorEntidad;

implementation

{$R *.dfm}

{ TFrmEditorEntidad }

procedure TFrmEditorEntidad.btnCerrarClick(Sender: TObject);
begin
  close;
end;

procedure TFrmEditorEntidad.cbGeneradorSelectItem(Sender: TObject);
begin
  FTabla.NombreGenerador := cbGenerador.Text;
  FTabla.TieneGenerador := not (Trim(FTabla.NombreGenerador)= '');
end;

procedure TFrmEditorEntidad.SetGeneradores(const Value: TColeccionGenerador);
var
  nGenerador: integer;
  nSel: Integer;
begin
  FGeneradores := Value;

  cbGenerador.Items.Clear;
  nSel := -1;
  for nGenerador := FGeneradores.Count - 1 downto 0 do
  begin
    cbGenerador.Items.Add(FGeneradores.Generador[nGenerador].Nombre);
    if FGeneradores.Generador[nGenerador].Nombre = FTabla.NombreGenerador then
      nSel := cbGenerador.Items.Count -1;
  end;

  if nSel > -1 then
    cbGenerador.ItemIndex := nSel;
end;

procedure TFrmEditorEntidad.SetTabla(const Value: TTabla);
var
  nCampo: integer;
begin
  FTabla := Value;
  nxtgrdCampos.BeginUpdate;
  nxtgrdCampos.ClearRows;
  with FTabla.Campos do
  begin
    nxtgrdCampos.AddRow(Count);
    for nCampo := 0 to Count - 1 do
    begin
      if Campo[nCampo].EsClavePrimaria then
        nxtgrdCampos.Cell[0, nCampo].AsInteger := 0
      else
        nxtgrdCampos.Cell[0, nCampo].AsInteger := -1;

      nxtgrdCampos.Cell[1, nCampo].AsString := Campo[nCampo].Nombre;
      nxtgrdCampos.Cell[2, nCampo].AsString := Campo[nCampo].TipoBD;
      nxtgrdCampos.Cell[3, nCampo].AsString := Campo[nCampo].TipoVariable;
      nxtgrdCampos.Cell[4, nCampo].AsInteger:= Campo[nCampo].Longitud;
      if Campo[nCampo].AceptaNull then
        nxtgrdCampos.Cell[5, nCampo].AsInteger := 2
      else
        nxtgrdCampos.Cell[5, nCampo].AsInteger := 3;
        
      if Campo[nCampo].EsClaveForanea then
        nxtgrdCampos.Cell[6, nCampo].AsInteger := 1
      else
        nxtgrdCampos.Cell[6, nCampo].AsInteger := -1;
    end;
  end;
  nxtgrdCampos.EndUpdate;
  jvgTitulo.Caption := FTabla.Nombre;
end;

procedure TFrmEditorEntidad.SetTopColor(ColorDesde, ColorHasta: TColor);
begin
  barSuperior.StartColor := ColorDesde;
  barSuperior.EndColor := ColorHasta;
end;

end.

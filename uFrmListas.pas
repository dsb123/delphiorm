{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uFrmListas.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uFrmListas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvGradient, JvExControls, JvgLabel, ExtCtrls, uFormGenerico,
  uCoreClasses, ComCtrls, NxPageControl, JvXPCore, JvXPButtons, NxScrollControl,
  NxCustomGridControl, NxCustomGrid, NxGrid, NxColumnClasses, NxColumns,
  JvExExtCtrls, JvExtComponent, JvSplit, ImgList, NxEdit, Mask, JvExMask,
  JvToolEdit, AdvCombobox, JvXPContainer, Menus;

type
  TFrmListas = class(TFormGenerico)
    img1: TImage;
    jvgTitulo: TJvgLabel;
    barSuperior: TJvGradient;
    StaticText1: TStaticText;
    tvListas: TTreeView;
    jvxspltr1: TJvxSplitter;
    ilEntidades: TImageList;
    ilLista: TImageList;
    pnlContenedor: TPanel;
    nxpgcntrlListas: TNxPageControl;
    nxtbshtLista: TNxTabSheet;
    lblEntidades: TLabel;
    nxtgrdLista: TNextGrid;
    nxtxtclmnEntidad: TNxTextColumn;
    nxtxtclmnAlias: TNxTextColumn;
    nxtxtclmnRelacion: TNxTextColumn;
    nxtxtclmnTipoRelacion: TNxTextColumn;
    btnPasar: TJvXPButton;
    btnQuitar: TJvXPButton;
    grpRelaciones: TGroupBox;
    lblRelacion: TLabel;
    Label1: TLabel;
    cbRelaciones: TAdvComboBox;
    cbTipo: TAdvComboBox;
    lvListas: TListView;
    nxtbshtAtributos: TNxTabSheet;
    lblAtributos: TLabel;
    lblAtributo: TLabel;
    lblExpresion: TLabel;
    lblAtributosConExpresiones: TLabel;
    nxtgrdAtributos: TNextGrid;
    nxchckbxclmnSeleccion: TNxCheckBoxColumn;
    nxtxtclmnAtributo: TNxTextColumn;
    nxtxtclmnAliasCampo: TNxTextColumn;
    nxcmbxclmnFuncionAgregacion: TNxComboBoxColumn;
    nxtxtclmnEntidadCampos: TNxTextColumn;
    nxtgrdAtributosExpresion: TNextGrid;
    nxtxtclmnAtributoAE: TNxTextColumn;
    nxtxtclmnExpresion: TNxTextColumn;
    edtAtributo: TEdit;
    edtExpresion: TEdit;
    btnAgregar: TJvXPButton;
    btnEliminar: TJvXPButton;
    cbbFuncionesAgregacion: TNxComboBox;
    jvxpcntnr1: TJvXPContainer;
    lblNombre: TLabel;
    edtNombreLista: TEdit;
    btnAceptar: TJvXPButton;
    Label2: TLabel;
    nxnmbrclmnNumber: TNxNumberColumn;
    nxnmbrclmnNumberEntidad: TNxNumberColumn;
    btnNueva: TJvXPButton;
    pmTareas: TPopupMenu;
    Nueva1: TMenuItem;
    N1: TMenuItem;
    Eliminar1: TMenuItem;
    procedure btnPasarClick(Sender: TObject);
    procedure btnQuitarClick(Sender: TObject);
    procedure nxtgrdListaSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure cbRelacionesSelectItem(Sender: TObject);
    procedure cbTipoSelectItem(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    procedure nxtgrdAtributosCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure tvListasClick(Sender: TObject);
    procedure tvListasEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure btnNuevaClick(Sender: TObject);
    procedure tvListasContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Eliminar1Click(Sender: TObject);
  private
    { Private declarations }
    nEntidad: integer;
    procedure FiltrarPorRelaciones;
    procedure EliminarAtributosPorEntidad(nEntidad: integer);
    function ComponeLaLista(sTabla: string): Boolean;
    procedure CargarLista(unNodo:TTreeNode; unaLista: TListaTabla);
    function ObtenerPrimeraRelacion(unaTabla: TTabla; nUltFilaParaControl: integer): TCamposFK;
    function ObtenerDescripcionRelacion(unCampoFK: TCamposFK): string;
    function ObtenerNodoPorDescripcion(const sText: string): TTreeNode;
    procedure AgregarTablaListaTablas(unaTabla: TTabla; unCampoFK: TCamposFK; sTipoRelacion: string);
    procedure CargarTodasLasTablasListaSeleccion;
    procedure EliminarItemLista(unaLista: TListaTabla);
  public
    { Public declarations }
    procedure Inicializar; override;
    function Cerrar: Boolean; override;
    function Guardar: Boolean; override;
    procedure SetTopColor(ColorDesde: TColor; ColorHasta: TColor); override;
  end;

var
  FrmListas: TFrmListas;

implementation

{$R *.dfm}

{ TFrmListas }

procedure TFrmListas.AgregarTablaListaTablas(unaTabla: TTabla;
  unCampoFK: TCamposFK; sTipoRelacion: string);
var
  nCampo : integer;
begin
  with nxtgrdLista do
  begin
    BeginUpdate;
    AddRow();
    Cell[0, LastAddedRow].AsString := unaTabla.Nombre;
    Cell[0, LastAddedRow].ObjectReference := unaTabla;
    Cell[1, LastAddedRow].AsString := unaTabla.Alias;

    if RowCount > 1 then
    begin
      Cell[2, LastAddedRow].AsString := ObtenerDescripcionRelacion(unCampoFK);
      Cell[2, LastAddedRow].ObjectReference := unCampoFK;
      Cell[3, LastAddedRow].AsString := sTipoRelacion;
    end;
    Cell[4, LastAddedRow].AsInteger := nEntidad;
    EndUpdate;
  end;

  with nxtgrdAtributos do
  begin
    BeginUpdate;
    for nCampo := 0 to unaTabla.Campos.Count - 1 do
    begin
      AddRow();
      Cell[0, LastAddedRow].ObjectReference := unaTabla.Campos.Campo[nCampo];
      Cell[1, LastAddedRow].AsString := unaTabla.Campos.Campo[nCampo].Nombre;
      if unaTabla.Alias <> '' then
        Cell[4, LastAddedRow].AsString := unaTabla.Alias
      else
        Cell[4, LastAddedRow].AsString := unaTabla.Nombre;
      Cell[5, LastAddedRow].AsInteger := nEntidad;
    end;
    EndUpdate;
  end;
  Inc(nEntidad);
end;

procedure TFrmListas.btnAceptarClick(Sender: TObject);
var
  unaLista: TListaTabla;
  nRow : integer;
  sUltEntidad: string;
  unNodo: TTreeNode;

  unaTabla: TTabla;
  bCargarLista: Boolean;
begin
  bCargarLista := true;

  if edtNombreLista.Text <> '' then
  begin
    unNodo := ObtenerNodoPorDescripcion(edtNombreLista.Text);
    if edtNombreLista.Enabled then
    begin
      if Assigned(unNodo) then
      begin
        Application.MessageBox('Ya existe una lista con el nombre seleccionado.',
          'Atención', MB_OK + MB_ICONSTOP);
        bCargarLista := false;
      end;
    end
    else
    begin
      unaLista := TListaTabla(unNodo.Data);
      EliminarItemLista(unaLista);
    end;

    if bCargarLista then
    begin
      unaLista := TListaTabla.Create(ColeccionListas);
      unaLista.NombreLista := edtNombreLista.Text;
      with nxtgrdLista do
      begin
        //Primero agrego las tablas
        for nRow := 0 to RowCount - 1 do
        begin
          with TTabla.Create(unaLista.Componentes) do
          begin
              Nombre := Cell[0, nRow].AsString;
              Alias  := Cell[1, nRow].AsString;
          end;

          if Assigned(Cell[2, nRow].ObjectReference) then
          begin
            with TRelacion(unaLista.Relaciones.Add) do
            begin
              CamposFK := TCamposFK(Cell[2, nRow].ObjectReference);
              TipoRelacion := Cell[3, nRow].AsString;
            end;
          end;
        end;

        //Ahora agrego los campos a la tabla
        sUltEntidad := '';
        with nxtgrdAtributos do
        begin
          for nRow := 0 to RowCount - 1 do
          begin
            if sUltEntidad <> Cell[4,nRow].AsString then
            begin
              sUltEntidad := Cell[4,nRow].AsString;
              unaTabla := unaLista.Componentes.ObtenerTabla(sUltEntidad);
            end;

            if Cell[0, nRow].AsBoolean then
            begin
              with TCampo(Cell[0, nRow].ObjectReference).Clonar(unaTabla.Campos) do
              begin
                Alias := Cell[2, nRow].AsString;
                FuncionAgregacion := cbbFuncionesAgregacion.Items.IndexOf(Cell[3, nRow].AsString);
              end;
            end;
          end;
        end;
      end;

      CargarLista(unNodo, unaLista);
      nxtgrdLista.ClearRows;
      nxtgrdAtributos.ClearRows;
      nxpgcntrlListas.ActivePage := nxtbshtLista;
      CargarTodasLasTablasListaSeleccion;
      edtNombreLista.Text := '';
      edtNombreLista.Enabled := True;
    end;
  end
  else
    Application.MessageBox('Debe Ingresar el nombre de la lista', 'Atención',
      MB_OK + MB_ICONSTOP);

end;

procedure TFrmListas.btnNuevaClick(Sender: TObject);
begin
  nxtgrdLista.ClearRows;
  nxtgrdAtributos.ClearRows;
  edtNombreLista.Text := '';
  edtNombreLista.Enabled := True;
  CargarTodasLasTablasListaSeleccion;
end;

procedure TFrmListas.btnPasarClick(Sender: TObject);
var
  unaTabla: TTabla;
  nRow : Integer;
begin
  if Assigned(lvListas.Selected) then
  begin
    unaTabla := TTabla(lvListas.Selected.Data);
    if nxtgrdLista.RowCount > 0 then
    begin
      nRow := nxtgrdLista.RowCount - 1;
      AgregarTablaListaTablas(unaTabla,
                              ObtenerPrimeraRelacion(unaTabla, nRow),
                              'Ambas');
    end
    else
      AgregarTablaListaTablas(unaTabla,
                              nil,
                              'Ambas');
    FiltrarPorRelaciones;
  end;
  btnAceptar.Enabled := (nxtgrdLista.RowCount > 0);
end;

procedure TFrmListas.btnQuitarClick(Sender: TObject);
var
  nRow: integer;
begin
  if nxtgrdLista.SelectedRow > -1 then
  begin
    for nRow := nxtgrdLista.RowCount - 1 downto nxtgrdLista.SelectedRow do
    begin
      EliminarAtributosPorEntidad(nxtgrdLista.Cell[4, nRow].AsInteger);
      nxtgrdLista.DeleteRow(nRow);
    end;

    if nxtgrdLista.RowCount > 0 then
      FiltrarPorRelaciones
    else
      CargarTodasLasTablasListaSeleccion;
  end;
  btnAceptar.Enabled := (nxtgrdLista.RowCount > 0);
end;

procedure TFrmListas.CargarLista(unNodo: TTreeNode; unaLista: TListaTabla);
var
  nTabla, nCampo: integer;

  unCampo: TCampo;
  unaTabla: TTabla;
begin
  if not Assigned(unNodo) then
    unNodo := tvListas.Items.AddChild(nil, unaLista.NombreLista)
  else
    unNodo.DeleteChildren;

  unNodo.Data := unaLista;
  unNodo.ImageIndex := 0;
  unNodo.SelectedIndex := 0;
  for nTabla := 0 to unaLista.Componentes.Count - 1 do
  begin
    unaTabla := unaLista.Componentes.Tabla[nTabla];
    for nCampo := 0 to unaTabla.Campos.Count - 1 do
    begin
      unCampo := unaLista.Componentes.Tabla[nTabla].Campos.Campo[nCampo];
      with tvListas.Items.AddChild(unNodo, unaTabla.Nombre + '.' + unCampo.Nombre)do
      begin
        ImageIndex := 1;
        SelectedIndex := 1;
      end;
    end;
  end;
end;

procedure TFrmListas.CargarTodasLasTablasListaSeleccion;
var
  unItem: TListItem;
  nTabla: integer;
begin
  lvListas.Clear;
  for nTabla := 0 to ColeccionTablas.Count - 1 do
  begin
    unItem := lvListas.Items.Add;
    if ColeccionTablas.Tabla[nTabla].Alias <> '' then
    begin
      unItem.Caption := ColeccionTablas.Tabla[nTabla].Alias;
      unItem.ImageIndex := 1;
    end
    else begin
      unItem.Caption := ColeccionTablas.Tabla[nTabla].Nombre;
      unItem.ImageIndex := 0;
    end;
    unItem.Data := ColeccionTablas.Tabla[nTabla];
  end;
end;

procedure TFrmListas.cbRelacionesSelectItem(Sender: TObject);
begin
  with nxtgrdLista do
  begin
    Cell[2, SelectedRow].AsString := ObtenerDescripcionRelacion(TCamposFK(cbRelaciones.SelectedObject));
    Cell[2, SelectedRow].ObjectReference := cbRelaciones.SelectedObject;
  end;
end;

procedure TFrmListas.cbTipoSelectItem(Sender: TObject);
begin
  nxtgrdLista.Cell[3, nxtgrdLista.SelectedRow].AsString := cbTipo.Text;
end;

function TFrmListas.Cerrar: Boolean;
begin
  if Assigned(FCambioDatosMapeo) then
    FCambioDatosMapeo(Self);

  Result := true;
end;

function TFrmListas.ComponeLaLista(sTabla: string): Boolean;
var
  nRow: integer;
begin
  Result := false;
  for nRow := 0 to nxtgrdLista.RowCount - 1 do
  begin
    if nxtgrdLista.Cell[0, nRow].AsString = sTabla then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TFrmListas.Eliminar1Click(Sender: TObject);
var
  unaLista: TListaTabla;
  nLista: integer;
begin
  unaLista := TListaTabla(tvListas.Selected.Data);
  for nLista := (FColeccionListas.Count-1) downto 0 do
  begin
    if FColeccionListas.ListaTabla[nLista] = unaLista then
      FColeccionListas.Delete(nLista);
    tvListas.Items.Delete(tvListas.Selected);
  end;
end;

procedure TFrmListas.EliminarAtributosPorEntidad(nEntidad: integer);
var
  nRow: integer;
begin
  nxtgrdAtributos.BeginUpdate;
  for nRow := nxtgrdAtributos.RowCount - 1 downto 0 do
  begin
    if nxtgrdAtributos.Cell[5, nRow].AsInteger = nEntidad then
      nxtgrdAtributos.DeleteRow(nRow);
  end;
  nxtgrdAtributos.EndUpdate;  
end;

procedure TFrmListas.EliminarItemLista(unaLista: TListaTabla);
var
  nLista: integer;
begin
  for nLista := 0 to ColeccionListas.Count - 1 do
  begin
      if ColeccionListas.ListaTabla[nLista] = unaLista then
      begin
        ColeccionListas.Delete(nLista);
        Break;
      end;
  end;

end;

procedure TFrmListas.FiltrarPorRelaciones;
var
  unItem: TListItem;
  nTabla: integer;
  unaTabla: TTabla;

  bAgregarEntidad: Boolean;
  nCampoFK: integer;
begin
  lvListas.Clear;
  for nTabla := 0 to ColeccionTablas.Count - 1 do
  begin
    unaTabla := ColeccionTablas.Tabla[nTabla];
    bAgregarEntidad := false;

    for nCampoFK := 0 to unaTabla.CamposFK.Count - 1 do
    begin
      if  ComponeLaLista(unaTabla.CamposFK.CamposFK[nCampoFK].TablaDestino) then
      begin
        bAgregarEntidad := true;
        break;
      end;
    end;

    if not bAgregarEntidad then
    begin
      for nCampoFK := 0 to unaTabla.CamposColeccion.Count - 1 do
      begin
        if ComponeLaLista(unaTabla.CamposColeccion.CamposFK[nCampoFK].TablaDestino) then
        begin
          bAgregarEntidad := true;
          break;
        end;
      end;
    end;

    if bAgregarEntidad then
    begin
      unItem := lvListas.Items.Add;
      if ColeccionTablas.Tabla[nTabla].Alias <> '' then
      begin
        unItem.Caption := ColeccionTablas.Tabla[nTabla].Alias;
        unItem.ImageIndex := 1;
      end
      else begin
        unItem.Caption := ColeccionTablas.Tabla[nTabla].Nombre;
        unItem.ImageIndex := 0;
      end;
      unItem.Data := ColeccionTablas.Tabla[nTabla];
    end;
  end;

end;

function TFrmListas.Guardar: Boolean;
begin
  Result := true;
end;

procedure TFrmListas.Inicializar;
var
  nLista: Integer;
begin
  CargarTodasLasTablasListaSeleccion;
  for nLista := 0 to ColeccionListas.Count - 1 do
    CargarLista(nil, ColeccionListas.ListaTabla[nLista]);
end;

procedure TFrmListas.nxtgrdAtributosCellClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  btnAceptar.Enabled := (nxtgrdLista.RowCount > 0);
end;

procedure TFrmListas.nxtgrdListaSelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  unaTabla: TTabla;
  unCampoFK : TCamposFK;
  nCampoFK: integer;
  nRow: integer;
  sDescripcion: string;
  bAgregarRelacion: Boolean;
  nItemSeleccionado: integer;
begin
  nItemSeleccionado := 0;
  
  if ARow = 0 then
  begin
    cbRelaciones.Enabled := false;
    cbTipo.Enabled := false;
  end
  else begin
    cbRelaciones.Enabled := true;
    cbTipo.Enabled := true;

    unaTabla := TTabla(nxtgrdLista.Cell[0, nxtgrdLista.SelectedRow].ObjectReference);
    cbRelaciones.Items.Clear;
    for nCampoFK := 0 to unaTabla.CamposFK.Count - 1 do
    begin
      bAgregarRelacion := false;
      unCampoFK := unaTabla.CamposFK.CamposFK[nCampoFK];
      for nRow := 0 to ARow - 1 do
      begin
        if nxtgrdLista.Cell[0, nRow].AsString = unCampoFK.TablaDestino then
        begin
          bAgregarRelacion := true;
          Break;
        end;
      end;
      if bAgregarRelacion then
      begin
        sDescripcion := ObtenerDescripcionRelacion(unCampoFK);
        cbRelaciones.Items.AddObject(sDescripcion, unCampoFK);
        if sDescripcion = nxtgrdLista.Cell[2, ARow].AsString then
          nItemSeleccionado := cbRelaciones.Items.Count-1;
      end;
    end;

    for nCampoFK := 0 to unaTabla.CamposColeccion.Count - 1 do
    begin
      bAgregarRelacion := false;
      unCampoFK := unaTabla.CamposColeccion.CamposFK[nCampoFK];
      for nRow := 0 to ARow - 1 do
      begin
        if nxtgrdLista.Cell[0, nRow].AsString = unCampoFK.TablaDestino then
        begin
          bAgregarRelacion := true;
          Break;
        end;
      end;
      if bAgregarRelacion then
      begin
        sDescripcion := ObtenerDescripcionRelacion(unCampoFK);
        cbRelaciones.Items.AddObject(sDescripcion, unCampoFK);
        if sDescripcion = nxtgrdLista.Cell[2, ARow].AsString then
          nItemSeleccionado := cbRelaciones.Items.Count-1;
      end;
    end;
    cbRelaciones.ItemIndex :=nItemSeleccionado;

    sDescripcion := nxtgrdLista.Cell[3, ARow].AsString;
    if  sDescripcion = 'Ambas' then
      cbTipo.ItemIndex := 0
    else if sDescripcion = 'Izquierda' then
      cbTipo.ItemIndex := 1
    else
      cbTipo.ItemIndex := 2;

  end;
end;

function TFrmListas.ObtenerDescripcionRelacion(unCampoFK: TCamposFK): string;
var
  nCampo: integer;
  sParteOrigen, sParteDestino: string;
begin
  if unCampoFK.NomRelacion = '' then
    Result := unCampoFK.NomRelacionAMuchos + '(1..n): '
  else
    Result := unCampoFK.NomRelacion + '(1..1): ';

  sParteOrigen := '';
  for nCampo := 0 to unCampoFK.CamposOrigen.Count - 1 do
  begin
    if sParteOrigen <> '' then
      sParteOrigen := sParteOrigen + ', ';
    sParteOrigen := unCampoFK.CamposOrigen.Campo[nCampo].Nombre;
    if sParteDestino <> '' then
      sParteDestino := sParteDestino + ', ';
    sParteDestino := unCampoFK.CamposDestino.Campo[nCampo].Nombre;
  end;
  Result := Result +
            unCampoFK.TablaOrigen + '(' + sParteOrigen + ') ->' +
            unCampoFK.TablaDestino + '(' + sParteDestino + ')';
end;

function TFrmListas.ObtenerNodoPorDescripcion(const sText: string): TTreeNode;
var
  unNodo: TTreeNode;
begin
  Result := nil;
  unNodo := tvListas.Items.GetFirstNode;
  while Assigned(unNodo) do
  begin
    if unNodo.Text = sText then
    begin
      Result := unNodo;
      break;
    end;
    unNodo := unNodo.getNextSibling;
  end;
  

end;

function TFrmListas.ObtenerPrimeraRelacion(unaTabla: TTabla;
  nUltFilaParaControl: integer): TCamposFK;
var
  nFila : integer;
  nCampo: integer;
  sTabla : string;
begin
  Result := nil;
  for nFila := 0 to nUltFilaParaControl do
  begin
    sTabla := nxtgrdLista.Cell[0,nFila].AsString;
    for nCampo := 0 to unaTabla.CamposFK.Count - 1 do
    begin
      if unaTabla.CamposFK.CamposFK[nCampo].TablaDestino = sTabla then
      begin
        Result := unaTabla.CamposFK.CamposFK[nCampo];
        Break;
      end;
    end;
  end;

  if not Assigned(Result) then
  begin
    for nFila := 0 to nUltFilaParaControl do
    begin
      sTabla := nxtgrdLista.Cell[0,nFila].AsString;
      for nCampo := 0 to unaTabla.CamposColeccion.Count - 1 do
      begin
        if unaTabla.CamposColeccion.CamposFK[nCampo].TablaDestino = sTabla then
        begin
          Result := unaTabla.CamposColeccion.CamposFK[nCampo];
          Break;
        end;
      end;
    end;
  end;
end;

procedure TFrmListas.SetTopColor(ColorDesde, ColorHasta: TColor);
begin
  inherited;
  barSuperior.StartColor := ColorDesde;
  barSuperior.EndColor := ColorHasta;
end;

procedure TFrmListas.tvListasClick(Sender: TObject);
var
  unaLista: TListaTabla;
  unaTabla: TTabla;
  Campos: TColeccionCampos;
  nTabla: integer;
  nRow: integer;
  nCampo: integer;
begin
  if (Assigned(tvListas.Selected) and tvListas.Selected.HasChildren) then
  begin
    nxtgrdLista.ClearRows;
    nxtgrdAtributos.ClearRows;
    unaLista := TListaTabla(tvListas.Selected.Data);

    for nTabla := 0 to unaLista.Componentes.Count - 1 do
    begin
      if unaLista.Componentes.Tabla[nTabla].Alias <> '' then
        unaTabla := FColeccionTablas.ObtenerTablaPorAlias(unaLista.Componentes.Tabla[nTabla].Alias)
      else
        unaTabla := FColeccionTablas.ObtenerTabla(unaLista.Componentes.Tabla[nTabla].Nombre);

      if nTabla = 0 then
        AgregarTablaListaTablas(unaTabla, nil, '')
      else
        AgregarTablaListaTablas(unaTabla, unaLista.Relaciones.Relacion[nTabla-1].CamposFK,
                                          unaLista.Relaciones.Relacion[nTabla-1].TipoRelacion);

      Campos :=unaLista.Componentes.Tabla[nTabla].Campos;
      for nCampo := 0 to Campos.Count - 1 do
      begin
        for nRow := (nxtgrdAtributos.RowCount-unaTabla.Campos.Count) to nxtgrdAtributos.RowCount - 1 do
        begin
          if nxtgrdAtributos.Cell[1, nRow].AsString = Campos.Campo[nCampo].Nombre then
          begin
            nxtgrdAtributos.Cell[0, nRow].AsBoolean := true;
            nxtgrdAtributos.Cell[2, nRow].AsString  := Campos.Campo[nCampo].Alias;
            nxtgrdAtributos.Cell[3, nRow].AsString  := cbbFuncionesAgregacion.Items[Campos.Campo[nCampo].FuncionAgregacion];
          end;
        end;
      end;
    end;
    edtNombreLista.Text := unaLista.NombreLista;
    edtNombreLista.Enabled := False;
  end;
end;

procedure TFrmListas.tvListasContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  Eliminar1.Enabled := (tvListas.SelectionCount > 0);
  pmTareas.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TFrmListas.tvListasEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
begin
  if Node.HasChildren then
    TListaTabla(Node.Data).NombreLista := S
  else
    S := Node.Text;
end;

end.

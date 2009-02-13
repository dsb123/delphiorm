{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uFrmInfoEntidades.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uFrmInfoEntidades;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvGradient, JvExControls, JvgLabel, ComCtrls,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, JvExExtCtrls,
  JvExtComponent, JvSplit, NxColumnClasses, NxColumns, ImgList, uFormGenerico,
  Menus, uCoreClasses;

type
  TFrmInfoEntidades = class(TFormGenerico)
    jvgTitulo: TJvgLabel;
    barSuperior: TJvGradient;
    img1: TImage;
    stSeparadorTop: TStaticText;
    StaticText1: TStaticText;
    tvEntidades: TTreeView;
    jvxspltr1: TJvxSplitter;
    pnlCentro: TPanel;
    nxtgrdEntidad: TNextGrid;
    nxmgclmnTipo: TNxImageColumn;
    nxtxtclmnNombre: TNxTextColumn;
    nxtxtclmnTipoDato: TNxTextColumn;
    nxtxtclmnLongitud: TNxTextColumn;
    ilImagenes: TImageList;
    jvxspltr2: TJvxSplitter;
    tvRelaciones: TTreeView;
    pmEntidades: TPopupMenu;
    Clonar1: TMenuItem;
    N1: TMenuItem;
    EliminarEntidadClonada1: TMenuItem;
    procedure tvEntidadesClick(Sender: TObject);
    procedure tvRelacionesEdited(Sender: TObject; Node: TTreeNode;
      var S: string);
    procedure tvEntidadesContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Clonar1Click(Sender: TObject);
    procedure tvEntidadesEdited(Sender: TObject; Node: TTreeNode;
      var S: string);
    procedure EliminarEntidadClonada1Click(Sender: TObject);
  private
    { Private declarations }
    function CargarItemTabla(unaTabla: TTabla): TTreeNode;
  public
    { Public declarations }
    procedure Inicializar; override;
    function Cerrar: Boolean; override;
    function Guardar: Boolean; override;
    procedure SetTopColor(ColorDesde: TColor; ColorHasta: TColor); override;
  end;

var
  FrmInfoEntidades: TFrmInfoEntidades;

implementation

{$R *.dfm}

{ TFrmInfoEntidades }

function TFrmInfoEntidades.CargarItemTabla(unaTabla: TTabla): TTreeNode;
var
  unItemCampo : TTreeNode;
  nCampo: integer;
  unCampo: TCampo;
begin
  Result := tvEntidades.Items.AddChild(nil, unaTabla.Nombre);
  if Trim(unaTabla.Alias) <> '' then
  begin
    Result.ImageIndex := 1;
    Result.SelectedIndex := 1;
    Result.Text := unaTabla.Alias;
  end
  else begin
    Result.ImageIndex := 0;
    Result.SelectedIndex := 0;
  end;
  Result.Data := unaTabla;
  for nCampo := 0 to unaTabla.Campos.Count -1 do
  begin
    unCampo := unaTabla.Campos.Campo[nCampo];
    unItemCampo := tvEntidades.Items.AddChild(Result, unCampo.Nombre);
    unItemCampo.ImageIndex := 4;
    unItemCampo.SelectedIndex := 4;

    if unCampo.EsClavePrimaria then
    begin
      unItemCampo.Text := unItemCampo.Text + ' (PK)';
      if (not unCampo.EsClaveForanea) and (unaTabla.TieneGenerador) then
        unItemCampo.Text := unItemCampo.Text + ' (Autogenerado)';

      unItemCampo.ImageIndex := 2;
      unItemCampo.SelectedIndex := 2;
    end;

    if unCampo.EsClaveForanea then
    begin
      unItemCampo.Text := unItemCampo.Text + ' (FK)';
      unItemCampo.ImageIndex := 3;
      unItemCampo.SelectedIndex := 3;
    end;
  end;
end;

function TFrmInfoEntidades.Cerrar: Boolean;
begin
  Result := true;
end;

procedure TFrmInfoEntidades.Clonar1Click(Sender: TObject);
var
  unaTabla: TTabla;
  unaTablaClonada: TTabla;
begin
  unaTabla := TTabla(tvEntidades.Selected.Data);
  unaTablaClonada := unaTabla.Clonar(FColeccionTablas);
  unaTablaClonada.Alias := 'Clon' + unaTabla.Nombre;
  with CargarItemTabla(unaTablaClonada) do
  begin
    Selected := true;
    SetFocus;
  end;
end;

procedure TFrmInfoEntidades.EliminarEntidadClonada1Click(Sender: TObject);
var
  unaTabla: TTabla;
  nTabla: integer;
begin
  unaTabla := TTabla(tvEntidades.Selected.Data);

  for nTabla := 0 to ColeccionTablas.Count - 1 do
  begin
    if ColeccionTablas.Tabla[nTabla] = unaTabla then
      Break;
  end;
  ColeccionTablas.Delete(nTabla);
  tvEntidades.Items.Delete(tvEntidades.Selected);
end;

function TFrmInfoEntidades.Guardar: Boolean;
begin
  Result := true;
end;

procedure TFrmInfoEntidades.Inicializar;
var
  unaTabla: TTabla;
  nTabla: integer;
begin
  inherited;

  for nTabla := 0 to FColeccionTablas.Count - 1 do
  begin
    unaTabla := FColeccionTablas.Tabla[nTabla];
    CargarItemTabla(unaTabla);
  end;
end;

procedure TFrmInfoEntidades.SetTopColor(ColorDesde, ColorHasta: TColor);
begin
  barSuperior.StartColor := ColorDesde;
  barSuperior.EndColor := ColorHasta;
end;

procedure TFrmInfoEntidades.tvEntidadesClick(Sender: TObject);
var
  unaTabla : TTabla;
  unCampo : TCampo;
  nCampo : Integer;

  unNodo: TTreeNode;
  unNodoRelacion: TTreeNode;
  nRelacion: integer;
  unCampoFK: TCamposFK;
begin
  if tvEntidades.Selected.HasChildren then
  begin
    nxtgrdEntidad.BeginUpdate;
    nxtgrdEntidad.ClearRows;
    unaTabla := TTabla(tvEntidades.Selected.Data);
    nxtgrdEntidad.AddRow(unaTabla.Campos.Count);
    for nCampo := 0 to unaTabla.Campos.Count - 1 do
    begin
      unCampo := unaTabla.Campos.Campo[nCampo];
      nxtgrdEntidad.Cell[1, nCampo].AsString := unCampo.Nombre;
      nxtgrdEntidad.Cell[0, nCampo].AsInteger := 4;
      if unCampo.EsClavePrimaria then
      begin
        nxtgrdEntidad.Cell[1, nCampo].AsString := nxtgrdEntidad.Cell[1, nCampo].AsString + ' (PK)';
        nxtgrdEntidad.Cell[0, nCampo].AsInteger := 2;
      end;
      if unCampo.EsClaveForanea then
      begin
        nxtgrdEntidad.Cell[1, nCampo].AsString := nxtgrdEntidad.Cell[1, nCampo].AsString + ' (FK)';
        nxtgrdEntidad.Cell[0, nCampo].AsInteger := 3;
      end;
      nxtgrdEntidad.Cell[2, nCampo].AsString := unCampo.TipoBD + '(' + unCampo.TipoVariable + ')';
      nxtgrdEntidad.Cell[3, nCampo].AsInteger := unCampo.Longitud;
    end;
    nxtgrdEntidad.EndUpdate;

    tvRelaciones.Items.Clear;
    unNodo := tvRelaciones.Items.AddChild(nil, 'Relaciones 1 a 1');
    unNodo.ImageIndex := 3;
    unNodo.SelectedIndex := 3;
    for nRelacion := 0 to unaTabla.CamposFK.Count - 1 do
    begin
      unCampoFK := unaTabla.CamposFK.CamposFK[nRelacion];
      unNodoRelacion := tvRelaciones.Items.AddChild(unNodo, unCampoFK.NomRelacion);
      unNodoRelacion.ImageIndex := 0;
      unNodoRelacion.SelectedIndex := 0;
      unNodoRelacion.Data := unCampoFK;

      for nCampo := 0 to unCampoFK.CamposOrigen.Count - 1 do
      begin
        with tvRelaciones.Items.AddChild( unNodoRelacion,
                                          unCampoFK.TablaOrigen + '.' +
                                          unCampoFK.CamposOrigen.Campo[nCampo].Nombre +
                                          ' -> ' +
                                          unCampoFK.TablaDestino + '.' +
                                          unCampoFK.CamposDestino.Campo[nCampo].Nombre) do
        begin
          ImageIndex := 5;
          SelectedIndex := 5;
        end;
      end;
    end;

    unNodo := tvRelaciones.Items.AddChild(nil, 'Relaciones 1 a n');
    unNodo.ImageIndex := 3;
    unNodo.SelectedIndex := 3;
    for nRelacion := 0 to unaTabla.CamposColeccion.Count - 1 do
    begin
      unCampoFK := unaTabla.CamposColeccion.CamposFK[nRelacion];
      unNodoRelacion := tvRelaciones.Items.AddChild(unNodo, unCampoFK.NomRelacionAMuchos);
      unNodoRelacion.ImageIndex := 0;
      unNodoRelacion.SelectedIndex := 0;
      unNodoRelacion.Data := unCampoFK;

      for nCampo := 0 to unCampoFK.CamposOrigen.Count - 1 do
      begin
        with tvRelaciones.Items.AddChild( unNodoRelacion,
                                          unCampoFK.TablaDestino + '.' +
                                          unCampoFK.CamposDestino.Campo[nCampo].Nombre +
                                          ' -> ' +
                                          unCampoFK.TablaOrigen + '.' +
                                          unCampoFK.CamposOrigen.Campo[nCampo].Nombre) do
        begin
          ImageIndex := 5;
          SelectedIndex := 5;
        end;
      end;
    end;
  end;
end;

procedure TFrmInfoEntidades.tvEntidadesContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  unaTabla: TTabla;
begin
  if tvEntidades.SelectionCount > 0 then
  begin
    unaTabla := TTabla(tvEntidades.Selected.Data);
    EliminarEntidadClonada1.Enabled := (Trim(unaTabla.Alias) <> '');
    Clonar1.Enabled := (Trim(unaTabla.Alias) = '');
    pmEntidades.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end;
end;

procedure TFrmInfoEntidades.tvEntidadesEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  unaTabla: TTabla;
begin
  if Node.HasChildren then
  begin
    unaTabla := TTabla(Node.Data);
    if unaTabla.Alias = '' then
      S := Node.Text
    else
      unaTabla.Alias := S;
  end
  else
    S := Node.Text;
end;

procedure TFrmInfoEntidades.tvRelacionesEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  unCampoFK: TCamposFK;
begin
  if Assigned(Node.Data) then
  begin
    unCampoFK:= TCamposFK(Node.Data);
    if unCampoFK.NomRelacion <> '' then
      unCampoFK.NomRelacion := S
    else
      unCampoFK.NomRelacionAMuchos := S;
  end
  else
    s := Node.Text;
end;

end.

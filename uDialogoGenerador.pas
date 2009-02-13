{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uDialogoGenerador.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uDialogoGenerador;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uFormGenerico, Dialogs, ExtCtrls, SynMemo, ComCtrls, ToolWin, JvExComCtrls,
  JvToolBar, SynEdit, SynHighlighterPas, SynEditHighlighter, SynHighlighterHtml,
  ImgList, JvExExtCtrls, JvSplitter, JvExtComponent, JvSplit, dlgSearchText,
  dlgReplaceText,SynEditTypes, SynEditMiscClasses, SynEditRegexSearch,
  SynEditSearch,dlgConfirmReplace, ActnList, StdCtrls, Mask, JvExMask,
  JvToolEdit, AdvCombobox;

type
  TFormCodGen = class(TFormGenerico)
    PanelHtml: TPanel;
    PanelPas: TPanel;
    JvToolBar1: TJvToolBar;
    btnHGuardar: TToolButton;
    btnHReemplazar: TToolButton;
    SynMemoCodigo: TSynMemo;
    JvToolBar2: TJvToolBar;
    btnCGuardar: TToolButton;
    btnCReemplazar: TToolButton;
    btnCGenerar: TToolButton;
    SynMemoTmpl: TSynMemo;
    SynHTML: TSynHTMLSyn;
    SynPas: TSynPasSyn;
    ImageList1: TImageList;
    sdGuardar: TSaveDialog;
    JvxSplitter1: TJvxSplitter;
    SynEditRegexSearch: TSynEditRegexSearch;
    SynEditSearch: TSynEditSearch;
    btnHBuscar: TToolButton;
    btnCBuscar: TToolButton;
    btnCBuscarS: TToolButton;
    btnCBuscarA: TToolButton;
    ToolButton3: TToolButton;
    btnHBuscarS: TToolButton;
    btnHBuscarA: TToolButton;
    ToolButton6: TToolButton;
    ActionListTmpl: TActionList;
    BuscarSigTmpl: TAction;
    BuscarSigCod: TAction;
    BuscarTmpl: TAction;
    BuscarCod: TAction;
    ReemplazarTmpl: TAction;
    ReemplazarCod: TAction;
    lblTemplate: TLabel;
    cbTemplates: TAdvComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btnHGuardarClick(Sender: TObject);
    procedure btnCGuardarClick(Sender: TObject);
    procedure btnCGenerarClick(Sender: TObject);
    procedure btnHReemplazarClick(Sender: TObject);
    procedure btnHBuscarClick(Sender: TObject);
    procedure btnCBuscarClick(Sender: TObject);
    procedure btnCReemplazarClick(Sender: TObject);
    procedure btnHBuscarSClick(Sender: TObject);
    procedure btnHBuscarAClick(Sender: TObject);
    procedure btnCBuscarSClick(Sender: TObject);
    procedure btnCBuscarAClick(Sender: TObject);
    procedure BuscarSigTmplExecute(Sender: TObject);
    procedure BuscarSigCodExecute(Sender: TObject);
    procedure BuscarTmplExecute(Sender: TObject);
    procedure BuscarCodExecute(Sender: TObject);
    procedure ReemplazarTmplExecute(Sender: TObject);
    procedure ReemplazarCodExecute(Sender: TObject);
    procedure SynMemoTmplReplaceText(Sender: TObject; const ASearch,
      AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
    procedure cbTemplatesSelectItem(Sender: TObject);
  private
    fSearchFromCaret: boolean;
    procedure BuscarTexto(bReemplazar:Boolean; SynMemoAux:TSynMemo);
    procedure DoSearchReplaceText(AReplace: boolean;
      ABackwards: boolean; SynMemoAux:TSynMemo);
    { Private declarations }
  public
    TmplAbierto,TmplMod:Boolean;

    { Public declarations }
  end;

var
  FormCodGen: TFormCodGen;

implementation

uses uGeneradorCodigo, JclFileUtils;

{$R *.dfm}
var
  gbSearchBackwards: boolean;
  gbSearchCaseSensitive: boolean;
  gbSearchFromCaret: boolean;
  gbSearchSelectionOnly: boolean;
  gbSearchTextAtCaret: boolean;
  gbSearchWholeWords: boolean;
  gbSearchRegex: boolean;

  gsSearchText: string;
  gsSearchTextHistory: string;
  gsReplaceText: string;
  gsReplaceTextHistory: string;

resourcestring
  STextNotFound = 'Texto no Encontrado';
  SNoSelectionAvailable = 'Esta No es una Seleccion Permitida, Por Favor Realice otra Seleccion';


procedure TFormCodGen.btnCGenerarClick(Sender: TObject);
var
  slAux: TStringList;
  unGenerador: TGeneradorCodigo;
begin
  slAux       := TStringList.Create;
  slAux.Text  := SynMemoTmpl.Text;

  unGenerador := TGeneradorCodigo.Create;
  unGenerador.Tablas := FColeccionTablas;
  unGenerador.Listas := FColeccionListas;

  if unGenerador.ComprobarTemplate(slAux) then
    SynMemoCodigo.Text := unGenerador.GenerarCodigo(SynMemoTmpl.Text);

  FreeAndNil(unGenerador);
  FreeAndNil(slAux);
end;

procedure TFormCodGen.btnCGuardarClick(Sender: TObject);
var
  sVarAux, sNombre: string;
  slAux: TStringList;
begin
  sdGuardar.Filter  := 'Archivo PAS|*.pas';
  sdGuardar.Title   := 'Guardar Codigo Generado';

  slAux := TStringList.Create;

  if sdGuardar.Execute then
  begin
   sNombre    := ExtractFileName(sdGuardar.FileName);
   sNombre    := ChangeFileExt(sNombre,'');
   sVarAux    := SynMemoCodigo.Text;
   sVarAux    := StringReplace(sVarAux, '<NombreUnidad>', sNombre, [rfReplaceAll]);

   SynMemoCodigo.Clear;
   slAux.Text := sVarAux;
   slAux.SaveToFile(sdGuardar.FileName);

   SynMemoCodigo.Text := slAux.Text;
  end;
  slAux.Free;
end;

procedure TFormCodGen.btnCReemplazarClick(Sender: TObject);
begin
  BuscarTexto(True,SynMemoCodigo);
end;

procedure TFormCodGen.BuscarTexto(bReemplazar:Boolean;SynMemoAux:TSynMemo);
var
  dlg: TTextSearchDialog;
begin
  if bReemplazar then
    dlg := TTextReplaceDialog.Create(Self)
  else
    dlg := TTextSearchDialog.Create(Self);
  with dlg do try
    // assign search options
    SearchBackwards       := gbSearchBackwards;
    SearchCaseSensitive   := gbSearchCaseSensitive;
    SearchFromCursor      := gbSearchFromCaret;
    SearchInSelectionOnly := gbSearchSelectionOnly;

    // start with last search text
    SearchText            := gsSearchText;

    if gbSearchTextAtCaret then begin
      // if something is selected search for that text
      if SynMemoAux.SelAvail and (SynMemoAux.BlockBegin.Line = SynMemoAux.BlockEnd.Line)
      then
        SearchText := SynMemoAux.SelText
      else
        SearchText := SynMemoAux.GetWordAtRowCol(SynMemoAux.CaretXY);
    end;

    SearchTextHistory := gsSearchTextHistory;
    if bReemplazar then
    begin
      with dlg as TTextReplaceDialog do
      begin
        ReplaceText := gsReplaceText;
        ReplaceTextHistory := gsReplaceTextHistory;
      end;
    end;

    SearchWholeWords := gbSearchWholeWords;
    if ShowModal = mrOK then
    begin
      gbSearchSelectionOnly := SearchInSelectionOnly;
      gbSearchBackwards     := SearchBackwards;
      gbSearchCaseSensitive := SearchCaseSensitive;
      gbSearchFromCaret     := SearchFromCursor;
      gbSearchWholeWords    := SearchWholeWords;
      gbSearchRegex         := SearchRegularExpression;
      gsSearchText          := SearchText;
      gsSearchTextHistory   := SearchTextHistory;

      if bReemplazar then
      begin
        with dlg as TTextReplaceDialog do
        begin
          gsReplaceText := ReplaceText;
          gsReplaceTextHistory := ReplaceTextHistory;
        end;
      end;

      fSearchFromCaret := gbSearchFromCaret;
      if gsSearchText <> '' then
      begin
        DoSearchReplaceText(bReemplazar, gbSearchBackwards,SynMemoAux);
        fSearchFromCaret := TRUE;
      end;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TFormCodGen.BuscarTmplExecute(Sender: TObject);
begin
  BuscarTexto(False, SynMemoTmpl);
end;

procedure TFormCodGen.cbTemplatesSelectItem(Sender: TObject);
var
  sDir : string;
begin
  sDir := ExtractFileDir(Application.ExeName) + '\';
  SynMemoTmpl.Lines.LoadFromFile(sDir + cbTemplates.Text + '.tmpl');
  TmplAbierto :=True;
  TmplMod     :=False;
end;

procedure TFormCodGen.DoSearchReplaceText(AReplace: boolean;
  ABackwards: boolean; SynMemoAux:TSynMemo);
var
  Options: TSynSearchOptions;
begin
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];
  if ABackwards then
    Include(Options, ssoBackwards);
  if gbSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not fSearchFromCaret then
    Include(Options, ssoEntireScope);
  if gbSearchSelectionOnly then
  begin
    if (not SynMemoAux.SelAvail) or SameText(SynMemoAux.SelText, gsSearchText) then
    begin
      if MessageDlg(SNoSelectionAvailable, mtWarning, [mbYes, mbNo], 0) = mrYes then
        gbSearchSelectionOnly := False
      else
        Exit;
    end
    else
      Include(Options, ssoSelectedOnly);
  end;
  if gbSearchWholeWords then
    Include(Options, ssoWholeWord);
  if gbSearchRegex then
    SynMemoAux.SearchEngine := SynEditRegexSearch
  else
    SynMemoAux.SearchEngine := SynEditSearch;
  if SynMemoAux.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    if ssoBackwards in Options then
      SynMemoAux.BlockEnd := SynMemoAux.BlockBegin
    else
      SynMemoAux.BlockBegin := SynMemoAux.BlockEnd;
    SynMemoAux.CaretXY := SynMemoAux.BlockBegin;
  end;

  if ConfirmReplaceDialog <> nil then
    ConfirmReplaceDialog.Free;
end;

procedure TFormCodGen.btnHReemplazarClick(Sender: TObject);
begin
  BuscarTexto(true,SynMemoTmpl);
end;

procedure TFormCodGen.btnHGuardarClick(Sender: TObject);
var
  slAux: TStringList;
begin
  slAux       := TStringList.Create;
  slAux.Text  := SynMemoTmpl.Text;

  slAux.SaveToFile(ExtractFileDir(Application.ExeName) + '\' + cbTemplates.Text + '.tmpl');
  MessageDlg('El template se ha Guardado Correctamente', mtInformation,[mbYes],0);
  TmplMod:=False;
  slAux.Free;
end;

procedure TFormCodGen.FormCreate(Sender: TObject);
var
  slArchivos: TStringList;
  nArchivo: integer;
  sDir : string;
begin
  sDir := ExtractFileDir(Application.ExeName) + '\';
  TmplAbierto := False;
  TmplMod     := False;

  slArchivos := TStringList.Create;
  BuildFileList(sDir + '*.tmpl', faArchive, slArchivos);

  for nArchivo := 0 to slArchivos.Count - 1 do
    cbTemplates.Items.Add(ChangeFileExt(slArchivos[nArchivo], ''));

  slArchivos.Free;
end;

procedure TFormCodGen.ReemplazarCodExecute(Sender: TObject);
begin
  BuscarTexto(True,SynMemoCodigo);
end;

procedure TFormCodGen.ReemplazarTmplExecute(Sender: TObject);
begin
  BuscarTexto(True,SynMemoTmpl);
end;

procedure TFormCodGen.SynMemoTmplReplaceText(Sender: TObject; const ASearch,
  AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
var
  APos: TPoint;
  EditRect: TRect;
begin
  if ASearch = AReplace then
    Action := raSkip
  else begin
    APos := SynMemoTmpl.ClientToScreen( SynMemoTmpl.RowColumnToPixels(
                                        SynMemoTmpl.BufferToDisplayPos(
                                        BufferCoord(Column, Line) ) ) );
    EditRect := ClientRect;
    EditRect.TopLeft := ClientToScreen(EditRect.TopLeft);
    EditRect.BottomRight := ClientToScreen(EditRect.BottomRight);

    if ConfirmReplaceDialog = nil then
      ConfirmReplaceDialog := TConfirmReplaceDialog.Create(Application);
    ConfirmReplaceDialog.PrepareShow(EditRect, APos.X, APos.Y,
      APos.Y + SynMemoTmpl.LineHeight, ASearch);
    case ConfirmReplaceDialog.ShowModal of
      mrYes: Action := raReplace;
      mrYesToAll: Action := raReplaceAll;
      mrNo: Action := raSkip;
      else Action := raCancel;
    end;
  end;
end;

procedure TFormCodGen.btnCBuscarSClick(Sender: TObject);
begin
  DoSearchReplaceText(FALSE,FALSE, SynMemoCodigo);
end;

procedure TFormCodGen.btnHBuscarAClick(Sender: TObject);
begin
  DoSearchReplaceText(FALSE,TRUE, SynMemoTmpl);
end;

procedure TFormCodGen.btnHBuscarClick(Sender: TObject);
begin
  BuscarTexto(False,SynMemoTmpl);
end;

procedure TFormCodGen.btnHBuscarSClick(Sender: TObject);
begin
  DoSearchReplaceText(FALSE,FALSE, SynMemoTmpl);
end;

procedure TFormCodGen.BuscarCodExecute(Sender: TObject);
begin
  BuscarTexto(False,SynMemoCodigo);
end;

procedure TFormCodGen.BuscarSigCodExecute(Sender: TObject);
begin
  DoSearchReplaceText(False,False,SynMemoCodigo);
end;

procedure TFormCodGen.BuscarSigTmplExecute(Sender: TObject);
begin
  DoSearchReplaceText(False,False,SynMemoTmpl);
end;

procedure TFormCodGen.btnCBuscarAClick(Sender: TObject);
begin
  DoSearchReplaceText(FALSE, TRUE, SynMemoCodigo);
end;

procedure TFormCodGen.btnCBuscarClick(Sender: TObject);
begin
  BuscarTexto(False,SynMemoCodigo);
end;

end.

program DelphiORM;

uses
  Forms,
  uMainMenu in 'uMainMenu.pas' {FrmMain},
  uFormGenerico in 'uFormGenerico.pas',
  uFrmMetadataHandler in 'uFrmMetadataHandler.pas' {FrmMetadataHandler},
  uFrmInfoEntidades in 'uFrmInfoEntidades.pas' {FrmInfoEntidades},
  uFrmListas in 'uFrmListas.pas' {FrmListas},
  ORMXMLDef in 'ORMXMLDef.pas',
  uDialogoGenerador in 'uDialogoGenerador.pas' {FormCodGen},
  dlgSearchText in 'dlgSearchText.pas' {TextSearchDialog},
  dlgConfirmReplace in 'dlgConfirmReplace.pas' {ConfirmReplaceDialog},
  dlgReplaceText in 'dlgReplaceText.pas' {TextReplaceDialog},
  uGeneradorCodigo in 'uGeneradorCodigo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmMetadataHandler, FrmMetadataHandler);
  Application.CreateForm(TFrmInfoEntidades, FrmInfoEntidades);
  Application.CreateForm(TFrmListas, FrmListas);
  Application.CreateForm(TFormCodGen, FormCodGen);
  Application.CreateForm(TConfirmReplaceDialog, ConfirmReplaceDialog);
  Application.Run;
end.

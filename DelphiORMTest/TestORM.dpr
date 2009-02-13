program TestORM;

uses
  Forms,
  uMain in 'uMain.pas' {FrmPrincipal},
  uTestEntidades in 'uTestEntidades.pas',
  uDataModule in 'uDataModule.pas',
  uCampos in '..\ClasesBase\uCampos.pas',
  uColeccionEntidades in '..\ClasesBase\uColeccionEntidades.pas',
  uConexion in '..\ClasesBase\uConexion.pas',
  uEntidades in '..\ClasesBase\uEntidades.pas',
  uEntidadSimple in '..\ClasesBase\uEntidadSimple.pas',
  uEntidadSimpleCombo in '..\ClasesBase\uEntidadSimpleCombo.pas',
  uExpresiones in '..\ClasesBase\uExpresiones.pas',
  uSQLBuilder in '..\ClasesBase\uSQLBuilder.pas',
  uSQLConnectionGenerator in 'uSQLConnectionGenerator.pas',
  uComunGeneradores in '..\ClasesBase\Firebird\uComunGeneradores.pas',
  uFBSQLStatementManager in '..\ClasesBase\Firebird\uFBSQLStatementManager.pas',
  uFuncionesGeneradores in '..\ClasesBase\Firebird\uFuncionesGeneradores.pas',
  uGeneradorAgrupamientos in '..\ClasesBase\Firebird\uGeneradorAgrupamientos.pas',
  uGeneradorCondiciones in '..\ClasesBase\Firebird\uGeneradorCondiciones.pas',
  uGeneradorDelete in '..\ClasesBase\Firebird\uGeneradorDelete.pas',
  uGeneradorInsert in '..\ClasesBase\Firebird\uGeneradorInsert.pas',
  uGeneradorOrdenamiento in '..\ClasesBase\Firebird\uGeneradorOrdenamiento.pas',
  uGeneradorRelaciones in '..\ClasesBase\Firebird\uGeneradorRelaciones.pas',
  uGeneradorSelect in '..\ClasesBase\Firebird\uGeneradorSelect.pas',
  uGeneradorUpdate in '..\ClasesBase\Firebird\uGeneradorUpdate.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.

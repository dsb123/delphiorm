program TestORM;

uses
  Forms,
  uMain in 'uMain.pas' {FrmPrincipal},
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
  uComunGeneradores in '..\ClasesBase\Oracle\uComunGeneradores.pas',
  uFuncionesGeneradores in '..\ClasesBase\Oracle\uFuncionesGeneradores.pas',
  uGeneradorAgrupamientos in '..\ClasesBase\Oracle\uGeneradorAgrupamientos.pas',
  uGeneradorCondiciones in '..\ClasesBase\Oracle\uGeneradorCondiciones.pas',
  uGeneradorDelete in '..\ClasesBase\Oracle\uGeneradorDelete.pas',
  uGeneradorInsert in '..\ClasesBase\Oracle\uGeneradorInsert.pas',
  uGeneradorOrdenamiento in '..\ClasesBase\Oracle\uGeneradorOrdenamiento.pas',
  uGeneradorRelaciones in '..\ClasesBase\Oracle\uGeneradorRelaciones.pas',
  uGeneradorSelect in '..\ClasesBase\Oracle\uGeneradorSelect.pas',
  uGeneradorUpdate in '..\ClasesBase\Oracle\uGeneradorUpdate.pas',
  uOracleSQLStatementManager in '..\ClasesBase\Oracle\uOracleSQLStatementManager.pas',
  uTestEntidades in 'uTestEntidades.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.

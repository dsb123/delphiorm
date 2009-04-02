{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uFrmMetadataHandler.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uFrmMetadataHandler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uInterfaces, StdCtrls, JvgLabel, JvExControls, JvGradient, uFormGenerico,
  Mask, JvExMask, JvToolEdit, AdvCombobox, uCoreClasses, ExtCtrls;

type
  TFrmMetadataHandler = class(TFormGenerico)
    stSeparadorTop: TStaticText;
    barSuperior: TJvGradient;
    jvgTitulo: TJvgLabel;
    lblMotor: TLabel;
    cbORMDrivers: TAdvComboBox;
    lblInfo: TLabel;
    mmoDBInfo: TMemo;
    btnEjecutar: TButton;
    grpContenedor: TGroupBox;
    img1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbORMDriversSelectItem(Sender: TObject);
    procedure btnEjecutarClick(Sender: TObject);
  private
    { Private declarations }
    FCrearNuevo: Boolean;
    PackageHandle: HModule;
    slFiles: TStringList;

    procedure CargarDelphiORMDrivers;
    procedure EliminarTabladeListas(const sTabla: string);
    procedure CargarComboDrivers(sModulo: string);
    procedure ControlarCambios(TablasNuevas: TColeccionTabla); overload;
    procedure ControlarCambios(GeneradoresNuevos: TColeccionGenerador); overload;
    procedure ControlarTabla(unaTablaNueva, unaTablaOriginal: TTabla);
    procedure ControlarRelaciones(unaTablaNueva, unaTablaOriginal: TTabla);
    procedure ControlarCampo(CampoOriginal, CampoNuevo: TCampo);
    procedure EliminarCampoDeListas(const sTabla, sCampo: string);
    procedure EliminarListaConRelacion(unCampoFK: TCamposFK);
    procedure EliminarRelaciones(const sTabla: string);    
  public
    { Public declarations }
    procedure Inicializar; override;
    function Cerrar: Boolean; override;
    function Guardar: Boolean; override;
    procedure SetTopColor(ColorDesde: TColor; ColorHasta: TColor); override;

    property CrearNuevo: boolean read FCrearNuevo write FCrearNuevo;
  end;

var
  FrmMetadataHandler: TFrmMetadataHandler;

implementation

uses uDelphiORMBaseDriver, JclFileUtils;

{$R *.dfm}

{ TFrmCrearNuevo }

procedure TFrmMetadataHandler.btnEjecutarClick(Sender: TObject);
var
  i: integer;
begin
  with (theForm as IORMDriverManager) do
  begin
    if ValidateParameters then
    begin
      if Connect then
      begin
        FStringConexion := GetConnectionParameters;
        if FCrearNuevo then
        begin
          FreeAndNil(FColeccionTablas);
          FColeccionTablas := GetTablesInfo;
          FColeccionGeneradores := GetGeneratorsInfo;
          
          mmoDBInfo.Lines.Add('Se ha obtenido información de las siguientes tablas:');
          for i := 0 to FColeccionTablas.Count - 1 do
          begin
            mmoDBInfo.Lines.Add(FColeccionTablas.Tabla[i].Nombre)
          end;
          mmoDBInfo.Lines.Add('--------------------------------------------------');
          mmoDBInfo.Lines.Add('En total se ha leido ' + IntToStr(FColeccionTablas.Count) + ' tablas');
        end
        else begin
          ControlarCambios(GetTablesInfo);
          ControlarCambios(GetGeneratorsInfo);
        end;
        Disconnect;

        if Assigned(FCambioDatosMapeo) then
          FCambioDatosMapeo(Self);
      end;
    end;
  end;

end;

procedure TFrmMetadataHandler.CargarComboDrivers(sModulo: string);
var
  phm: HModule;
  GetDelphiORMDriverName: function: PChar;
  s : string;
begin
  phm := LoadPackage(sModulo);
  GetDelphiORMDriverName := nil;
  if phm <> 0 then
  begin
    try
      GetDelphiORMDriverName := GetProcAddress(phm,'GetDelphiORMDriverName');
      if Assigned(GetDelphiORMDriverName) then
      begin
        //GetDelphiORMDriverName;
        s := GetDelphiORMDriverName;
        cbORMDrivers.Items.Add(s);
      end;
        //cbORMDrivers.Items.Add(Trim(GetDelphiORMDriverName));
    finally
      UnloadPackage(phm);
    end;
  end;
end;

procedure TFrmMetadataHandler.CargarDelphiORMDrivers;
var
  nIndex  : integer;
  sModulo : string;
begin
  slFiles.Clear;
  BuildFileList(ExtractFilePath(Application.ExeName) + 'DelphiORM*Driver.bpl', faArchive, slFiles);

  //Limpieza preliminar
  for nIndex := 0 to slFiles.Count - 1 do
  begin
    sModulo := UpperCase(ExtractFileName(slFiles[nIndex]));
    if sModulo = 'DELPHIORMBASEDRIVER.BPL' then
    begin
      slFiles.Delete(nIndex);
      Break;
    end;
  end;

  if FCrearNuevo then
  begin
    for sModulo in slFiles do
      CargarComboDrivers(sModulo);
  end
  else begin
    nIndex := -1;
    for sModulo in slFiles do
    begin
      CargarComboDrivers(sModulo);
      if sModulo = Driver then
        nIndex := cbORMDrivers.Items.Count-1;
    end;

    if nIndex > -1 then
      cbORMDrivers.ItemIndex := nIndex;

  end;

end;

procedure TFrmMetadataHandler.cbORMDriversSelectItem(Sender: TObject);
begin
  if Assigned(theForm) then
  begin
    theForm.Close;
    FreeAndNil(theForm);
    UnloadPackage(PackageHandle);
  end;
  
  Driver := slFiles[cbORMDrivers.ItemIndex];
  PackageHandle := LoadPackage(Driver);
  if PackageHandle > 0 then
  begin
    theForm := theClass.Create(Self);

    theForm.BorderStyle := bsNone;
    theForm.Parent := grpContenedor;
    theForm.Align := alClient;

    if not FCrearNuevo then
      (theForm as IORMDriverManager).SetConnectionParameters(FStringConexion);

    theForm.Show;
  end;
end;

function TFrmMetadataHandler.Cerrar: Boolean;
begin
  if Assigned(theForm) then
  begin
    theForm.Close;
    FreeAndNil(theForm);
    UnloadPackage(PackageHandle);
  end;

  Result := True;
end;

procedure TFrmMetadataHandler.ControlarCambios(TablasNuevas: TColeccionTabla);
var
  nTabla: integer;
  unaTabla: TTabla;
begin
  //Primero controlo que existan las todas las tablas
  for nTabla := FColeccionTablas.Count - 1 downto 0 do
  begin
    unaTabla := TablasNuevas.ObtenerTabla(FColeccionTablas.Tabla[nTabla].Nombre);
    if not Assigned(unaTabla) then
    begin
      //Esta tabla fue eliminada
      mmoDBInfo.Lines.Add('Entidad eliminada: ' + FColeccionTablas.Tabla[nTabla].Nombre);
      EliminarTabladeListas(FColeccionTablas.Tabla[nTabla].Nombre);
      EliminarRelaciones(FColeccionTablas.Tabla[nTabla].Nombre);
      FColeccionTablas.Delete(nTabla);
    end;
  end;

  for nTabla := 0 to TablasNuevas.Count - 1 do
  begin
    unaTabla := FColeccionTablas.ObtenerTabla(TablasNuevas.Tabla[nTabla].Nombre);
    if not Assigned(unaTabla) then
    begin
      mmoDBInfo.Lines.Add('Se agregó la entidad ' + TablasNuevas.Tabla[nTabla].Nombre);
      TablasNuevas.Tabla[nTabla].Clonar(FColeccionTablas);
    end
    else begin
      ControlarTabla(TablasNuevas.Tabla[nTabla], unaTabla);
      ControlarRelaciones(TablasNuevas.Tabla[nTabla], unaTabla);
    end;
  end;
  FreeAndNil(TablasNuevas);
end;

procedure TFrmMetadataHandler.ControlarCambios(
  GeneradoresNuevos: TColeccionGenerador);
var
  nGenerador: integer;
  unGen: TGenerador;

  nTabla: integer;
  unaTabla: TTabla;
begin
  for nGenerador := FColeccionGeneradores.Count - 1 downto 0 do
  begin
    unGen := GeneradoresNuevos.ObtenerGenerador(FColeccionGeneradores.Generador[nGenerador].Nombre);
    if not Assigned(unGen) then
    begin
      //Estos fueron eliminados
      mmoDBInfo.Lines.Add('Se eliminó el generador ' + FColeccionGeneradores.Generador[nGenerador].Nombre);

      //Busco la tabla que lo busca y le saco el generador
      for nTabla := 0 to FColeccionTablas.Count - 1 do
      begin
        unaTabla := FColeccionTablas.Tabla[nTabla];
        if unaTabla.NombreGenerador = FColeccionGeneradores.Generador[nGenerador].Nombre then
        begin
          mmoDBInfo.Lines.Add('La entidad '+ unaTabla.Nombre + ' se ha quedado sin generador para la clave');
          unaTabla.NombreGenerador := '';
          unaTabla.TieneGenerador  := false;
        end;
      end;
      FColeccionGeneradores.Delete(nGenerador);
    end;
  end;

  for nGenerador := GeneradoresNuevos.Count-1 downto 0 do
  begin
    //Ahora los que se agregaron
    unGen := FColeccionGeneradores.ObtenerGenerador(GeneradoresNuevos.Generador[nGenerador].Nombre);
    if not Assigned(unGen) then
    begin
      mmoDBInfo.Lines.Add('Se agregó el generador ' + GeneradoresNuevos.Generador[nGenerador].Nombre);

      with TGenerador.Create(FColeccionGeneradores) do
      begin
        Nombre := GeneradoresNuevos.Generador[nGenerador].Nombre;

        for nTabla := 0 to FColeccionTablas.Count - 1 do
        begin
          unaTabla := FColeccionTablas.Tabla[nTabla];
          if (unaTabla.Nombre = Nombre) and (unaTabla.NombreGenerador = '') then
          begin
            unaTabla.NombreGenerador := Nombre;
            unaTabla.TieneGenerador  := True;
            mmoDBInfo.Lines.Add('La entidad ' + unaTabla.Nombre + ' ahora posee generador');
          end;
        end;
      end;
    end;
  end;
  FreeAndNil(GeneradoresNuevos);
end;

procedure TFrmMetadataHandler.ControlarCampo(CampoOriginal, CampoNuevo: TCampo);
begin
  if CampoOriginal.EsClavePrimaria <> CampoNuevo.EsClavePrimaria then
  begin
    CampoOriginal.EsClavePrimaria := CampoNuevo.EsClavePrimaria;
    if CampoOriginal.EsClavePrimaria then
      mmoDBInfo.Lines.Add('El campo ' + CampoOriginal.Nombre + ' es ahora parte de la clave primaria')
    else
      mmoDBInfo.Lines.Add('El campo ' + CampoOriginal.Nombre + ' dejó de ser parte de la clave primaria');
  end;

  if CampoOriginal.TipoBD <> CampoNuevo.TipoBD then
  begin
    CampoOriginal.TipoVariable  := CampoNuevo.TipoVariable;
    CampoOriginal.TipoORM       := CampoNuevo.TipoORM;
    CampoOriginal.TipoBD        := CampoNuevo.TipoBD;
    CampoOriginal.AsKeyWord     := CampoNuevo.AsKeyWord;

    mmoDBInfo.Lines.Add('El campo ' + CampoOriginal.Nombre +
                        ' es ahora del tipo ' + CampoOriginal.TipoBD);
  end;

  if CampoOriginal.Longitud <> CampoNuevo.Longitud then
  begin
    CampoOriginal.Longitud := CampoNuevo.Longitud;

    mmoDBInfo.Lines.Add('El campo ' + CampoOriginal.Nombre +
                        ' es ahora tiene longitud ' + IntToStr(CampoOriginal.Longitud));
  end;

  if CampoOriginal.AceptaNull <> CampoNuevo.AceptaNull then
  begin
    CampoOriginal.AceptaNull := CampoNuevo.AceptaNull;
    if CampoOriginal.AceptaNull then
      mmoDBInfo.Lines.Add('El campo ' + CampoOriginal.Nombre + ' ahora acepta nulos')
    else
      mmoDBInfo.Lines.Add('El campo ' + CampoOriginal.Nombre + ' ya no acepta nulos');
  end;

  if CampoOriginal.ValorDefault <> CampoNuevo.ValorDefault then
  begin
    CampoOriginal.ValorDefault := CampoNuevo.ValorDefault;
    mmoDBInfo.Lines.Add('El campo ' + CampoOriginal.Nombre + ' ahora tiene como valor default ' + CampoOriginal.ValorDefault);
  end;

end;

procedure TFrmMetadataHandler.ControlarRelaciones(unaTablaNueva,
  unaTablaOriginal: TTabla);
var
  nCampoFK: integer;
  unCampoFK: TCamposFK;
begin
  for nCampoFK := (unaTablaOriginal.CamposFK.Count - 1) downto 0 do
  begin
    unCampoFK := unaTablaNueva.CamposFK.ObtenerFKGemela(unaTablaOriginal.CamposFK.CamposFK[nCampoFK]);
    if not Assigned(unCampoFK) then
    begin
      mmoDBInfo.Lines.Add('La relación ' +  unaTablaOriginal.CamposFK.CamposFK[nCampoFK].NomRelacion +
                                            unaTablaOriginal.CamposFK.CamposFK[nCampoFK].NomRelacionAMuchos +
                          ' ha dejado de existir');
      EliminarListaConRelacion(unaTablaOriginal.CamposFK.CamposFK[nCampoFK]);
      unaTablaOriginal.CamposFK.Delete(nCampoFK);
    end;
  end;

  for nCampoFK := (unaTablaOriginal.CamposColeccion.Count - 1) downto 0 do
  begin
    unCampoFK := unaTablaNueva.CamposColeccion.ObtenerFKGemela(unaTablaOriginal.CamposColeccion.CamposFK[nCampoFK]);
    if not Assigned(unCampoFK) then
    begin
      mmoDBInfo.Lines.Add('La relación ' +  unaTablaOriginal.CamposColeccion.CamposFK[nCampoFK].NomRelacion +
                                            unaTablaOriginal.CamposColeccion.CamposFK[nCampoFK].NomRelacionAMuchos +
                          ' ha dejado de existir');
      EliminarListaConRelacion(unaTablaOriginal.CamposColeccion.CamposFK[nCampoFK]);
      unaTablaOriginal.CamposColeccion.Delete(nCampoFK);
    end;
  end;

  //Relaciones nuevas
  for nCampoFK := 0 to unaTablaNueva.CamposFK.Count - 1 do
  begin
    unCampoFK := unaTablaOriginal.CamposFK.ObtenerFKGemela(unaTablaNueva.CamposFK.CamposFK[nCampoFK]);
    if not Assigned(unCampoFK) then
    begin
      mmoDBInfo.Lines.Add('Se agrega la relación (1 a 1) ' +  unaTablaNueva.CamposFK.CamposFK[nCampoFK].TablaOrigen +
                          '->' + unaTablaNueva.CamposFK.CamposFK[nCampoFK].TablaDestino);
      unaTablaNueva.CamposFK.CamposFK[nCampoFK].Clonar(unaTablaOriginal.CamposFK);
    end;
  end;

  for nCampoFK := 0 to unaTablaNueva.CamposColeccion.Count - 1 do
  begin
    unCampoFK := unaTablaOriginal.CamposColeccion.ObtenerFKGemela(unaTablaNueva.CamposColeccion.CamposFK[nCampoFK]);
    if not Assigned(unCampoFK) then
    begin
      mmoDBInfo.Lines.Add('Se agrega la relación (1 a n) ' +  unaTablaNueva.CamposColeccion.CamposFK[nCampoFK].TablaOrigen +
                          '->' + unaTablaNueva.CamposColeccion.CamposFK[nCampoFK].TablaDestino);
      unaTablaNueva.CamposColeccion.CamposFK[nCampoFK].Clonar(unaTablaOriginal.CamposColeccion);
    end;
  end;

end;

procedure TFrmMetadataHandler.ControlarTabla(unaTablaNueva,
  unaTablaOriginal: TTabla);
var
  unCampo: TCampo;
  nCampo: integer;
begin
  if unaTablaNueva.TieneGenerador and (not unaTablaOriginal.TieneGenerador) then
  begin
    unaTablaOriginal.TieneGenerador := unaTablaNueva.TieneGenerador;
    mmoDBInfo.Lines.Add('Entidad ' + unaTablaOriginal.Nombre + ' ha agregado un generador para la clave');
  end;

  //Controlo los campos.

  //Primero aquellos que hayan sido eliminados
  for nCampo := unaTablaOriginal.Campos.Count - 1 downto 0 do
  begin
    with unaTablaOriginal.Campos do
    begin
      unCampo := unaTablaNueva.Campos.ObtenerCampo(Campo[nCampo].Nombre);
      if not Assigned(unCampo) then
      begin
        mmoDBInfo.Lines.Add('El campo ' + Campo[nCampo].Nombre +
                            ' ha sido eliminado de la tabla ' +
                            unaTablaOriginal.Nombre);
        EliminarCampoDeListas(unaTablaOriginal.Nombre, Campo[nCampo].Nombre);
        unaTablaOriginal.Campos.Delete(nCampo);
      end
      else
        ControlarCampo(Campo[nCampo], unCampo);
    end;
  end;

  //Ahora los que se agregaron
  for nCampo := 0 to unaTablaNueva.Campos.Count - 1 do
  begin
    with unaTablaNueva.Campos do
    begin
      unCampo := unaTablaOriginal.Campos.ObtenerCampo(Campo[nCampo].Nombre);
      if not Assigned(unCampo) then
      begin
        mmoDBInfo.Lines.Add('El campo ' + Campo[nCampo].Nombre +
                            ' ha sido agregado a la tabla ' +
                            unaTablaOriginal.Nombre);
        Campo[nCampo].Clonar(unaTablaOriginal.Campos);
      end
      else
        ControlarCampo(unCampo, Campo[nCampo]);
    end;
  end;

end;

procedure TFrmMetadataHandler.EliminarCampoDeListas(const sTabla,
  sCampo: string);
var
  nLista, nAux, nCampo: Integer;
begin
  for nLista := 0 to FColeccionListas.Count - 1 do
  begin
    with FColeccionListas.ListaTabla[nLista] do
    begin
      for nAux := (Componentes.Count  -1) downto 0 do
      begin
        if Componentes.Tabla[nAux].Nombre = sTabla then
        begin
          with Componentes.Tabla[nAux].Campos do
          begin
            for nCampo := (Count - 1) downto 0 do
            begin
              if Campo[nCampo].Nombre = sCampo then
              begin
                mmoDBInfo.Lines.Add('Se eliminó el campo ' + sCampo + ' de la lista ' +
                                    FColeccionListas.ListaTabla[nAux].NombreLista);
                Delete(nCampo);
              end;
            end;
          end;
        end;
      end;

      for nAux := (Relaciones.Count - 1) downto 0 do
      begin
        if (Relaciones.Relacion[nAux].CamposFK.TablaOrigen  = sTabla) then
        begin
          with Relaciones.Relacion[nAux].CamposFK do
          begin
            for nCampo := (CamposOrigen.Count-1) downto 0 do
            begin
              if CamposOrigen.Campo[nCampo].Nombre = sCampo then
              begin
                mmoDBInfo.Lines.Add('Se eliminó la relación ' +
                                    Relaciones.Relacion[nAux].CamposFK.NomRelacion +
                                    Relaciones.Relacion[nAux].CamposFK.NomRelacionAMuchos +
                                    ' de la lista ' +
                                    FColeccionListas.ListaTabla[nAux].NombreLista +
                                    ' por contener el campo ' + CamposOrigen.Campo[nCampo].Nombre);
                Relaciones.Delete(nAux);
              end;
            end;
          end;
        end;

        if (Relaciones.Relacion[nAux].CamposFK.TablaDestino  = sTabla) then
        begin
          with Relaciones.Relacion[nAux].CamposFK do
          begin
            for nCampo := (CamposDestino.Count-1) downto 0 do
            begin
              if CamposDestino.Campo[nCampo].Nombre = sCampo then
              begin
                mmoDBInfo.Lines.Add('Se eliminó la relación ' +
                                    Relaciones.Relacion[nAux].CamposFK.NomRelacion +
                                    Relaciones.Relacion[nAux].CamposFK.NomRelacionAMuchos +
                                    ' de la lista ' +
                                    FColeccionListas.ListaTabla[nAux].NombreLista +
                                    ' por contener el campo ' + CamposOrigen.Campo[nCampo].Nombre);
                Relaciones.Delete(nAux);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrmMetadataHandler.EliminarListaConRelacion(unCampoFK: TCamposFK);
var
  unaRelacion: TRelacion;
  nLista: integer;
begin
  with FColeccionListas do
  begin
    for nLista := (Count - 1) downto 0 do
    begin
      unaRelacion := ListaTabla[nLista].Relaciones.ObtenerRelacionConFK(unCampoFK);
      if Assigned(unaRelacion) then
      begin
        mmoDBInfo.Lines.Add('Se eliminó la lista ' + ListaTabla[nLista].NombreLista +
                            ' por contener la relación ' +
                            unaRelacion.CamposFK.NomRelacion +
                            unaRelacion.CamposFK.NomRelacionAMuchos);
        FColeccionListas.Delete(nLista);
      end;
    end;
  end;
end;

procedure TFrmMetadataHandler.EliminarRelaciones(const sTabla: string);
var
  unaTabla: TTabla;
  nTabla: integer;
  nCampoFK: integer;
begin
  for nTabla := 0 to FColeccionTablas.Count - 1 do
  begin
    unaTabla:= FColeccionTablas.Tabla[nTabla];
    for nCampoFK := (unaTabla.CamposFK.Count-1) downto 0 do
    begin
      if  (unaTabla.CamposFK.CamposFK[nCampoFK].TablaOrigen = sTabla) or
          (unaTabla.CamposFK.CamposFK[nCampoFK].TablaDestino = sTabla) then
        unaTabla.CamposFK.Delete(nCampoFK);
    end;

    for nCampoFK := (unaTabla.CamposColeccion.Count-1) downto 0 do
    begin
      if  (unaTabla.CamposColeccion.CamposFK[nCampoFK].TablaOrigen = sTabla) or
          (unaTabla.CamposColeccion.CamposFK[nCampoFK].TablaDestino = sTabla) then
        unaTabla.CamposColeccion.Delete(nCampoFK);
    end;
  end;
end;

procedure TFrmMetadataHandler.EliminarTabladeListas(const sTabla: string);
var
  nLista: integer;
  nAux: integer;
begin
  for nLista := 0 to FColeccionListas.Count - 1 do
  begin
    with FColeccionListas.ListaTabla[nLista] do
    begin
      for nAux := (Componentes.Count  -1) downto 0 do
      begin
        if Componentes.Tabla[nAux].Nombre = sTabla then
        begin
          Componentes.Delete(nAux);
          mmoDBInfo.Lines.Add('Se eliminó la tabla ' + sTabla +
                              ' de la lista ' +
                              FColeccionListas.ListaTabla[nAux].NombreLista);
        end;
      end;

      for nAux := (Relaciones.Count - 1) downto 0 do
      begin
        if (Relaciones.Relacion[nAux].CamposFK.TablaOrigen  = sTabla) or
           (Relaciones.Relacion[nAux].CamposFK.TablaDestino = sTabla) then
        begin
          mmoDBInfo.Lines.Add('Se eliminó la relación ' +
                              Relaciones.Relacion[nAux].CamposFK.NomRelacion +
                              Relaciones.Relacion[nAux].CamposFK.NomRelacionAMuchos +
                              ' de la lista ' +
                              FColeccionListas.ListaTabla[nAux].NombreLista);

          Relaciones.Delete(nAux);
        end;
      end;
    end;
  end;
end;

procedure TFrmMetadataHandler.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  slFiles.Free;
end;

procedure TFrmMetadataHandler.FormCreate(Sender: TObject);
begin
  slFiles := TStringList.Create;
end;

function TFrmMetadataHandler.Guardar: Boolean;
begin
  Result := True;
end;

procedure TFrmMetadataHandler.Inicializar;
begin
  inherited;
  if FCrearNuevo then
    jvgTitulo.Caption := 'Crear nuevo archivo de mapeo'
  else
    jvgTitulo.Caption := 'Actualizar archivo de mapeo';

  CargarDelphiORMDrivers;

end;

procedure TFrmMetadataHandler.SetTopColor(ColorDesde, ColorHasta: TColor);
begin
  barSuperior.StartColor := ColorDesde;
  barSuperior.EndColor := ColorHasta;
end;

end.

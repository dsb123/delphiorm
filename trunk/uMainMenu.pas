{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uMainMenu.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uMainMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvOutlookBar, ImgList, JvXPCore, JvXPContainer,
  ExtCtrls, JvNavigationPane, uFormGenerico, uCoreClasses, Menus;

type
  TFrmMain = class(TForm)
    jvtlkbrMenu: TJvOutlookBar;
    ilMenu: TImageList;
    jvxpcntnrContainer: TJvXPContainer;
    mmPrincipal: TMainMenu;
    Archivos1: TMenuItem;
    Ay4da1: TMenuItem;
    Nuevo1: TMenuItem;
    Abrir1: TMenuItem;
    Cerrar1: TMenuItem;
    Salir2: TMenuItem;
    Guardar1: TMenuItem;
    GuardarComo1: TMenuItem;
    N1: TMenuItem;
    ilMenuPrincipal: TImageList;
    dlgSaveORM: TSaveDialog;
    dlgOpen: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure Nuevo1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure jvtlkbrMenuPages0Buttons0Click(Sender: TObject);
    procedure jvtlkbrMenuPages0Buttons2Click(Sender: TObject);
    procedure Guardar1Click(Sender: TObject);
    procedure GuardarComo1Click(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
    procedure Cerrar1Click(Sender: TObject);
    procedure jvtlkbrMenuPages0Buttons3Click(Sender: TObject);
    procedure jvtlkbrMenuPages0Buttons1Click(Sender: TObject);
  private
    { Private declarations }
    unFormActivo: TFormGenerico;
    Tablas: TColeccionTabla;
    Listas: TColeccionListaTabla;
    sNombreArchivo: string;
    sStringConexion: string;
    sDriver: string;

    procedure CargarFormGenerico(unForm: TFormGenerico);
    procedure GuardarDatosMapeo;
    procedure AbrirArchivo(sArchivo: string);
    function ObtenerNombreArchivo: string;
    function ObtenerCamposFK(const sTablaOrigen, sTablaDestino, sNombreRelacion, sNombreRelacionAMuchos: string): TCamposFK;
    procedure CambioDatosMapeo(Sender: TObject);
  public
    { Public declarations }
    procedure MostrarTablas;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses  uFrmMetadataHandler, uFrmInfoEntidades, uDialogoGenerador, uFrmListas,
      ORMXMLDef, XMLDoc, Registry, shlobj;

procedure RegisterFileType(ExtName:String; AppName:String) ;
var
   reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
   reg.RootKey:=HKEY_CLASSES_ROOT;
   reg.OpenKey('.' + ExtName, True) ;
   reg.WriteString('', ExtName + 'file') ;
   reg.CloseKey;
   reg.CreateKey(ExtName + 'file') ;
   reg.OpenKey(ExtName + 'file\DefaultIcon', True) ;
   reg.WriteString('', AppName + ',0') ;
   reg.CloseKey;
   reg.OpenKey(ExtName + 'file\shell\open\command', True) ;
   reg.WriteString('',AppName+' "%1"') ;
   reg.CloseKey;
  finally
   reg.Free;
  end;

  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

procedure TFrmMain.Abrir1Click(Sender: TObject);
begin
  if (dlgOpen.Execute) then
    AbrirArchivo(dlgOpen.FileName);
end;

procedure TFrmMain.AbrirArchivo(sArchivo: string);
var
  ORMEntidades : IXMLORMENTIDADESType;
  XMLDoc       : TXMLDocument;

  nTabla       : integer;
  nLista       : integer;
  nCampo       : integer;
  nCampoFK     : integer;
  nRelacion    : integer;

  unaTabla     : TTabla;
  unaListaTabla: TListaTabla;
  unCampo      : TCampo;
  unCampoFK    : TCamposFK;
  unaRelacion  : TRelacion;

  ConvertirTipo: procedure(unCampo: TCampo; const sTipo: string; const sSubTipo: string);
  phm: HModule;
begin
  sNombreArchivo := sArchivo;
  Caption := 'Delphi ORM - ' + sNombreArchivo;

  XMLDoc          := TXMLDocument.Create(sNombreArchivo);
  ORMEntidades    := GetORMEntidades(xmldoc);
  sDriver         := ORMEntidades.Driver;
  sStringConexion := ORMEntidades.StringConexion;

  phm := LoadPackage(ORMEntidades.Driver);
  //ConvertirTipo := nil;
  if phm <> 0 then
  begin
    try
      ConvertirTipo := GetProcAddress(phm,'ConvertirTipo');
      if Assigned(ConvertirTipo) then begin
        Tablas.Clear;
        Listas.Clear;

        with ORMEntidades.Entidades do
        begin
          for nTabla := 0 to Count - 1 do
          begin
            with TTabla.Create(Tablas) do
            begin
              Nombre        := Entidad[nTabla].Nombre;
              Alias         := Entidad[nTabla].Alias;
              TieneGenerador:= Entidad[nTabla].TieneGenerador;
              for nCampo := 0 to Entidad[nTabla].Campos.Count - 1 do
              begin
                unCampo := TCampo.Create(Campos);
                unCampo.Nombre            := Entidad[nTabla].Campos.Campo[nCampo].Nombre;
                unCampo.Alias             := Entidad[nTabla].Campos.Campo[nCampo].Alias;
                unCampo.EsClavePrimaria   := Entidad[nTabla].Campos.Campo[nCampo].EsClavePrimaria;
                unCampo.EsClaveForanea    := Entidad[nTabla].Campos.Campo[nCampo].EsClaveForanea;
                unCampo.AceptaNull        := Entidad[nTabla].Campos.Campo[nCampo].AceptaNull;
                unCampo.Longitud          := Entidad[nTabla].Campos.Campo[nCampo].Longitud;
                unCampo.FuncionAgregacion := Entidad[nTabla].Campos.Campo[nCampo].FuncionAgregacion;
                //unCampo.ValorDefault      := ENTIDAD[nTabla].CAMPOS.CAMPO[nCampo].ValorDefault;

                ConvertirTipo(unCampo,  Entidad[nTabla].Campos.Campo[nCampo].Tipo,
                                        Entidad[nTabla].Campos.Campo[nCampo].SubTipo);
              end;
            end;
          end;

          //Cargo las FK
          for nTabla := 0 to Count - 1 do
          begin
            unaTabla := Tablas.ObtenerTabla(Entidad[nTabla].Nombre);

            for nCampoFK := 0 to Entidad[nTabla].Relacion1a1.Count - 1 do
            begin
              unCampoFK     := TCamposFK.Create(unaTabla.CamposFK);
              unCampoFK.Inicializar;

              unCampoFK.TablaOrigen         := unaTabla.Nombre;
              unCampoFK.TablaDestino        := Entidad[nTabla].Relacion1a1.Foreignkey[nCampoFK].TablaRelacionada;

              unCampoFK.NomRelacion         := Entidad[nTabla].Relacion1a1.Foreignkey[nCampoFK].NombreRelacion;
              unCampoFK.NomRelacionAMuchos  := Entidad[nTabla].Relacion1a1.Foreignkey[nCampoFK].NombreRelacionAMuchos;
              for nCampo := 0 to Entidad[nTabla].Relacion1a1.Foreignkey[nCampoFK].Origen.Count - 1 do
              begin
                with TCampo.Create(unCampoFK.CamposOrigen) do
                  Nombre := Entidad[nTabla].Relacion1a1.Foreignkey[nCampoFK].Origen.CampoRed[nCampo].Nombre;

                with TCampo.Create(unCampoFK.CamposDestino) do
                  Nombre := Entidad[nTabla].Relacion1a1.Foreignkey[nCampoFK].Destino.CampoRed[nCampo].Nombre;
              end;
            end;

            for nCampoFK := 0 to Entidad[nTabla].Relacion1an.Count - 1 do
            begin
              unCampoFK     := TCamposFK.Create(unaTabla.CamposColeccion);
              unCampoFK.Inicializar;

              unCampoFK.TablaOrigen         := unaTabla.Nombre;
              unCampoFK.TablaDestino        := Entidad[nTabla].Relacion1an.Foreignkey[nCampoFK].TablaRelacionada;

              unCampoFK.NomRelacion         := Entidad[nTabla].Relacion1an.Foreignkey[nCampoFK].NombreRelacion;
              unCampoFK.NomRelacionAMuchos  := Entidad[nTabla].Relacion1an.Foreignkey[nCampoFK].NombreRelacionAMuchos;

              for nCampo := 0 to Entidad[nTabla].Relacion1an.Foreignkey[nCampoFK].Origen.Count - 1 do
              begin
                with TCampo.Create(unCampoFK.CamposOrigen) do
                  Nombre := Entidad[nTabla].Relacion1an.Foreignkey[nCampoFK].Origen.CampoRed[nCampo].Nombre;

                with TCampo.Create(unCampoFK.CamposDestino) do
                  Nombre := Entidad[nTabla].Relacion1an.Foreignkey[nCampoFK].Destino.CampoRed[nCampo].Nombre;
              end;
            end;
          end;
        end;

        //Ahora las listas
        for nLista := 0 to ORMEntidades.Listas.Count - 1 do
        begin
          unaListaTabla :=  TListaTabla.Create(Listas);
          unaListaTabla.NombreLista :=  ORMEntidades.Listas[nLista].Nombre;
          for nTabla := 0 to ORMEntidades.Listas.Lista[nLista].Entidades.Count - 1 do
          begin
            unaTabla := TTabla.Create(unaListaTabla.Componentes);
            with ORMEntidades.Listas.Lista[nLista].Entidades.Entidad[nTabla] do
            begin
              unaTabla.Nombre         := Nombre;
              unaTabla.Alias          := Alias;

              for nCampo := 0 to Campos.Count - 1 do
              begin
                unCampo := TCampo.Create(unaTabla.Campos);
                unCampo.Nombre            := Campos.Campo[nCampo].Nombre;
                unCampo.Alias             := Campos.Campo[nCampo].Alias;
                unCampo.FuncionAgregacion := Campos.Campo[nCampo].FuncionAgregacion;
              end;
            end;
          end;

          //Con las relaciones hay que hacer algo mas loco. Hay que buscar y hacer referencia a las FK ya existentes.
          for nRelacion := 0 to ORMEntidades.Listas.Lista[nLista].Relaciones.Count - 1 do
          begin
            unaRelacion := TRelacion.Create(unaListaTabla.Relaciones);
            with ORMEntidades.Listas.Lista[nLista].Relaciones do
            begin
              unaRelacion.TipoRelacion := Relacion[nRelacion].TipoRelacion;
              unaRelacion.CamposFK     := ObtenerCamposFK(Relacion[nRelacion].TablaOrigen,
                                                          Relacion[nRelacion].TablaDestino,
                                                          Relacion[nRelacion].NombreRelacion,
                                                          Relacion[nRelacion].NombreRelacionAMuchos);
            end;
          end;
        end;

        //Apertura de las entidades
        MostrarTablas;
      end
      else
        Application.MessageBox('No se puede cargar la función ConvertirTipo del driver. Se cancelará la carga.',
          'Error con el Driver', MB_OK + MB_ICONSTOP);
    finally
      UnloadPackage(phm);
    end;
  end
  else
    Application.MessageBox('No se puede cargar la función ConvertirTipo del driver. Se cancelará la carga.',
      'Error con el Driver', MB_OK + MB_ICONSTOP);

end;

procedure TFrmMain.CambioDatosMapeo(Sender: TObject);
begin
  if Assigned(unFormActivo) then
  begin
    sStringConexion := unFormActivo.StringConexion;
    sDriver := unFormActivo.Driver;
    Tablas := unFormActivo.ColeccionTablas;
    Listas := unFormActivo.ColeccionListas;    
  end;
end;

procedure TFrmMain.CargarFormGenerico(unForm: TFormGenerico);
begin
  if Assigned(unFormActivo) then
    unFormActivo.Cerrar;

  with unForm do
  begin
    BorderStyle := bsNone;
    Parent := jvxpcntnrContainer;
    ParentWindow := jvxpcntnrContainer.Handle;
    Align := alClient;
    SetTopColor(clBtnShadow,clBtnFace);
    ColeccionTablas   := Tablas;
    ColeccionListas   := Listas;
    StringConexion    := sStringConexion;
    Driver            := sDriver;
    CambioDatosMapeo  := Self.CambioDatosMapeo;
    Inicializar;
    Show;
  end;

  if Assigned(unFormActivo) then
  begin
    unFormActivo.Close;
    FreeAndNil(unFormActivo);
  end;

  unFormActivo := unForm;
end;

procedure TFrmMain.Cerrar1Click(Sender: TObject);
begin
  Tablas.Clear;
  Listas.Clear;
  sDriver := '';
  sNombreArchivo := '';

  Caption := 'Delphi ORM';

  //Apertura de las entidades
  MostrarTablas;
end;

procedure TFrmMain.FormCreate(Sender: TObject);

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Tablas := TColeccionTabla.Create;
  Listas := TColeccionListaTabla.Create;

  if ParamCount > 0 then
    AbrirArchivo(ParamStr(1));

  RegisterFileType('do', Application.ExeName) ;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Tablas);
  FreeAndNil(Listas);
end;

procedure TFrmMain.Guardar1Click(Sender: TObject);
begin
  if sNombreArchivo = '' then
    sNombreArchivo := ObtenerNombreArchivo;
  GuardarDatosMapeo;
end;

procedure TFrmMain.GuardarComo1Click(Sender: TObject);
begin
  sNombreArchivo:= ObtenerNombreArchivo;
  GuardarDatosMapeo;
end;

procedure TFrmMain.GuardarDatosMapeo;
var
  ORMEntidades  : IXMLORMEntidadesType;
  XMLDoc        : TXMLDocument;

  unaTabla      : TTabla;
  unaLista      : TListaTabla;
  unaRelacion   : TRelacion;
  unCampo       : TCampo;
  unCampoFK     : TCamposFK;

  nLista        : integer;
  nTabla        : integer;
  nRelacion     : integer;
  nCampo        : integer;
  nCampoRelacion: integer;

begin
  XMLDoc       := TXMLDocument.Create(nil);
  ORMEntidades := GetORMEntidades(xmldoc);
  ORMEntidades.Driver := sDriver;
  ORMEntidades.StringConexion := sStringConexion;
  for nTabla := 0 to Tablas.Count - 1 do
  begin
    ORMEntidades.Entidades.Add;
    unaTabla := Tablas.Tabla[nTabla];

    with  ORMEntidades.Entidades.Entidad[nTabla] do
    begin
      Nombre          := unaTabla.Nombre;
      TieneGenerador  := unaTabla.TieneGenerador;
      for nCampo := 0 to unaTabla.Campos.Count - 1 do
      begin
        Campos.Add;
        unCampo:= unaTabla.Campos.Campo[nCampo];
        with Campos.Campo[nCampo] do
        begin
          Nombre            := unCampo.Nombre;
          Tipo              := unCampo.TipoBD;
          SubTipo	          := unCampo.SubTipoBD;
          Longitud          := unCampo.Longitud;
          AceptaNull        := unCampo.AceptaNull;
          EsClavePrimaria   := unCampo.EsClavePrimaria;
          EsClaveForanea    := unCampo.EsClaveForanea;
          FuncionAgregacion := unCampo.FuncionAgregacion;
          //ValorDefault      := unCampo.ValorDefault;
        end;
      end;

      if(unaTabla.CamposFK.Count > 0 ) then
      begin
        for nCampo := 0 to unaTabla.CamposFK.Count - 1 do
        begin
          unCampoFK := unaTabla.CamposFK.CamposFK[nCampo];
          Relacion1a1.Add;
          with Relacion1a1[nCampo] do
          begin
            TablaRelacionada     := unCampoFK.TablaDestino;
            NombreRelacion       := unCampoFK.NomRelacion;
            NombreRelacionAMuchos:= unCampoFK.NomRelacionAMuchos;
            for nCampoRelacion := 0 to unCampoFK.CamposDestino.Count - 1 do
            begin
              Origen.Add;
              Destino.Add;
              Origen.CampoRed[nCampoRelacion].Tabla := unaTabla.Nombre;
              Origen.CampoRed[nCampoRelacion].Nombre := unCampoFK.CamposOrigen.Campo[nCampoRelacion].Nombre;

              Destino.CampoRed[nCampoRelacion].Tabla := unCampoFK.TablaDestino;
              Destino.CampoRed[nCampoRelacion].Nombre := unCampoFK.CamposDestino.Campo[nCampoRelacion].Nombre;
            end;
          end;
        end;
      end;

      if(unaTabla.CamposColeccion.Count > 0 ) then
      begin
        for nCampo := 0 to unaTabla.CamposColeccion.Count - 1 do
        begin
          unCampoFK := unaTabla.CamposColeccion.CamposFK[nCampo];
          Relacion1an.Add;
          with Relacion1an[nCampo] do
          begin
            TablaRelacionada     := unCampoFK.TablaDestino;
            NombreRelacion       := unCampoFK.NomRelacion;
            NombreRelacionAMuchos:= unCampoFK.NomRelacionAMuchos;
            for nCampoRelacion := 0 to unCampoFK.CamposDestino.Count - 1 do
            begin
              Origen.Add;
              Destino.Add;
              Origen.CampoRed[nCampoRelacion].Tabla := unaTabla.Nombre;
              Origen.CampoRed[nCampoRelacion].Nombre := unCampoFK.CamposOrigen.Campo[nCampoRelacion].Nombre;

              Destino.CampoRed[nCampoRelacion].Tabla := unCampoFK.TablaDestino;
              Destino.CampoRed[nCampoRelacion].Nombre := unCampoFK.CamposDestino.Campo[nCampoRelacion].Nombre;
            end;
          end;
        end;
      end;
    end;
  end;

  //Ahora las listas
  for nLista := 0 to Listas.Count - 1 do
  begin
    unaLista :=  Listas.ListaTabla[nLista];
    ORMEntidades.Listas.add;
    with ORMEntidades.Listas.Lista[nLista] do
    begin
      Nombre := unaLista.NombreLista;

      for nTabla := 0 to unaLista.Componentes.Count - 1 do
      begin
        Entidades.Add;
        Entidades.Entidad[nTabla].Nombre  :=  unaLista.Componentes.Tabla[nTabla].Nombre;
        Entidades.Entidad[nTabla].Alias   :=  unaLista.Componentes.Tabla[nTabla].Alias;
        for nCampo := 0 to unaLista.Componentes.Tabla[nTabla].Campos.Count - 1 do
        begin
          unCampo :=  unaLista.Componentes.Tabla[nTabla].Campos.Campo[nCampo];
          Entidades.Entidad[nTabla].CAMPOS.Add;
          with Entidades.Entidad[nTabla].Campos.Campo[nCampo] do
          begin
            Nombre            :=  unCampo.Nombre;
            Alias             :=  unCampo.Alias;
            FuncionAgregacion := unCampo.FuncionAgregacion;
          end;
        end;
      end;

      for nRelacion := 0 to unaLista.Relaciones.Count - 1 do
      begin
        unaRelacion := unaLista.Relaciones.Relacion[nRelacion];
        Relaciones.Add;
        with Relaciones.Relacion[nRelacion] do
        begin
          TablaOrigen           := unaRelacion.CamposFK.TablaOrigen;
          TablaDestino          := unaRelacion.CamposFK.TablaDestino;
          NombreRelacion        := unaRelacion.CamposFK.NomRelacion;
          NombreRelacionAMuchos := unaRelacion.CamposFK.NomRelacionAMuchos;
          TipoRelacion := unaRelacion.TipoRelacion;
        end;
      end;
    end;
  end;

  xmldoc.SaveToFile(sNombreArchivo);
  Caption := 'Delphi ORM - ' + sNombreArchivo;
  //Apertura de las entidades
  MostrarTablas;
end;

procedure TFrmMain.jvtlkbrMenuPages0Buttons0Click(Sender: TObject);
var
  unForm : TFrmInfoEntidades;
begin
  unForm := TFrmInfoEntidades.Create(jvxpcntnrContainer);
  CargarFormGenerico(unForm);
end;

procedure TFrmMain.jvtlkbrMenuPages0Buttons1Click(Sender: TObject);
var
  unForm : TFrmMetadataHandler;
begin
  unForm := TFrmMetadataHandler.Create(jvxpcntnrContainer);
  unForm.CrearNuevo := false;

  CargarFormGenerico(unForm);
end;

procedure TFrmMain.jvtlkbrMenuPages0Buttons2Click(Sender: TObject);
var
  unForm : TFrmListas;
begin
  unForm := TFrmListas.Create(jvxpcntnrContainer);
  CargarFormGenerico(unForm);
end;

procedure TFrmMain.jvtlkbrMenuPages0Buttons3Click(Sender: TObject);
var
  unForm : TFormCodGen;
begin
  unForm := TFormCodGen.Create(jvxpcntnrContainer);
  CargarFormGenerico(unForm);
end;

procedure TFrmMain.MostrarTablas;
begin
  jvtlkbrMenuPages0Buttons0Click(nil);
end;

procedure TFrmMain.Nuevo1Click(Sender: TObject);
var
  unForm : TFrmMetadataHandler;
begin
  unForm := TFrmMetadataHandler.Create(jvxpcntnrContainer);
  unForm.CrearNuevo := true;

  CargarFormGenerico(unForm);
end;

function TFrmMain.ObtenerCamposFK(const sTablaOrigen, sTablaDestino,
  sNombreRelacion, sNombreRelacionAMuchos: string): TCamposFK;
var
  unaTabla : TTabla;
  nCamposFK: Integer;
  unCampoFK: TCamposFK;
begin
  unaTabla := Tablas.ObtenerTabla(sTablaOrigen);
  Result := nil;
  if sNombreRelacion <> '' then
  begin
    for nCamposFK := 0 to unaTabla.CamposFK.Count - 1 do
    begin
      unCampoFK := unaTabla.CamposFK.CamposFK[nCamposFK];
      if ((unCampoFK.TablaOrigen = sTablaOrigen) and
          (unCampoFK.TablaDestino = sTablaDestino) and
          (unCampoFK.NomRelacion  = sNombreRelacion) and
          (unCampoFK.NomRelacionAMuchos = sNombreRelacionAMuchos)) then
      begin
        Result := unCampoFK;
        Break;
      end;
    end;

    if not Assigned(Result) then
    begin
      unaTabla := Tablas.ObtenerTabla(sTablaDestino);
      for nCamposFK := 0 to unaTabla.CamposFK.Count - 1 do
      begin
        unCampoFK := unaTabla.CamposFK.CamposFK[nCamposFK];
        if ((unCampoFK.TablaOrigen = sTablaDestino) and
            (unCampoFK.TablaDestino = sTablaOrigen) and
            (unCampoFK.NomRelacion  = sNombreRelacion) and
            (unCampoFK.NomRelacionAMuchos = sNombreRelacionAMuchos)) then
        begin
          Result := unCampoFK;
          Break;
        end;
      end;
    end;
  end
  else begin
    for nCamposFK := 0 to unaTabla.CamposColeccion.Count - 1 do
    begin
      unCampoFK := unaTabla.CamposColeccion.CamposFK[nCamposFK];
      if ((unCampoFK.TablaOrigen = sTablaOrigen) and
          (unCampoFK.TablaDestino = sTablaDestino) and
          (unCampoFK.NomRelacion  = sNombreRelacion) and
          (unCampoFK.NomRelacionAMuchos = sNombreRelacionAMuchos)) then
      begin
        Result := unCampoFK;
        Break;
      end;
    end;

    if not Assigned(Result) then
    begin
      unaTabla := Tablas.ObtenerTabla(sTablaDestino);
      for nCamposFK := 0 to unaTabla.CamposColeccion.Count - 1 do
      begin
        unCampoFK := unaTabla.CamposColeccion.CamposFK[nCamposFK];
        if ((unCampoFK.TablaOrigen = sTablaDestino) and
            (unCampoFK.TablaDestino = sTablaOrigen) and
            (unCampoFK.NomRelacion  = sNombreRelacion) and
            (unCampoFK.NomRelacionAMuchos = sNombreRelacionAMuchos)) then
        begin
          Result := unCampoFK;
          Break;
        end;
      end;
    end;
  end;
end;

function TFrmMain.ObtenerNombreArchivo: string;
begin
  Result := '';
  dlgSaveORM.FileName := sNombreArchivo;
  if dlgSaveORM.Execute then
    Result := dlgSaveORM.FileName;
end;

end.



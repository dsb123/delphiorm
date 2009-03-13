{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uEntidades.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uEntidades;

interface

uses  Classes, SysUtils, Contnrs, uCampos, uSQLBuilder, uColeccionEntidades,
      uConexion, uExpresiones;

type
  TEntidadBase = class;
  TDatoCombo = class
  private
    FDato: variant;
    function GetAsInteger: integer;
    function GetAsString: string;
    function GetAsVariant: Variant;
  public
    constructor Create(Dato: variant);
    property AsInteger: integer read GetAsInteger;
    property AsString: string read GetAsString;
    property AsVariant: Variant read GetAsVariant;
  end;

  TCamposRelacionados=class
  private
    FCampoOrigen: integer;
    FCampoDestino: integer;
  public
    constructor Create(nCampoOrigen, nCampoDestino: integer);

    property CampoOrigen: integer read FCampoOrigen;
    property CampoDestino: integer read FCampoDestino;
  end;

  TEntidadAsociada = class
  private
    function GetCamposRelacionados(index: integer): TCamposRelacionados;
    function GetCantidadRelaciones: integer;
    function GetEntidad: TEntidadBase;
    function GetColeccionEntidades: TColeccionEntidades;
  protected
    FCamposRelacionados : TObjectList;
    FObjetoAsociado     : TObject;
  public
    constructor Create(unaEntidad: TEntidadBase); overload;
    constructor Create(unaColeccion: TColeccionEntidades); overload;
    destructor Destroy; override;
    procedure AgregarCamposRelacionados(nCampoOrigen, nCampoDestino: integer);

    property Entidad: TEntidadBase read GetEntidad;
    property ColeccionEntidades: TColeccionEntidades read GetColeccionEntidades;
    property CantidadRelaciones: integer read GetCantidadRelaciones;
    property CamposRelacionados[index: integer]: TCamposRelacionados read GetCamposRelacionados;
  end;

  TEntidadBase = class(TCollectionItem)
  protected
    FTabla              : string;
    FEsNueva            : boolean;
    FCampos             : TColeccionCampos;
    FEnEdicion          : boolean;
    FEntidadesAsociadas : TObjectList;
    FColeccionesAsociadas: TObjectList;
    FEntidadConexion    : TEntidadConexion;
    FOwnsEntidadConexion: boolean;
    FEntidadAsociadaID  : integer;

    function InsertarEntidad: boolean; virtual;
    function ActualizarEntidad: boolean; virtual;
    function AsignarCamposDesdeSeleccion(select : TSelectStatement): boolean;
  private
    function GetEntidadesAsociadas: TObjectList;
    function GetColeccionesAsociadas: TObjectList;
    function GetEntidadConexion: TEntidadConexion;
    property EntidadesAsociadas: TObjectList read GetEntidadesAsociadas;
    property ColeccionesAsociadas: TObjectList read GetColeccionesAsociadas;
  public
    constructor Create(Coleccion: TCollection; ComoEntidadNueva: boolean = true);
    destructor Destroy; override;

    function CrearNuevaConexionEntidad: TEntidadConexion; virtual;
    function Clonar(Coleccion: TCollection = nil): TEntidadBase;

    function AgregarEntidadAsociada(Entidad: TEntidadBase): integer;
    procedure EliminarEntidadAsociada(Entidad: TEntidadBase);
    
    procedure AgregarCamposAsociadosEntidad(nEntidadAsociada, nCampoOrigen, nCampoDestino: integer);

    function AgregarColeccionAsociada(ColeccionEntidades: TColeccionEntidades): integer;
    procedure AgregarCamposAsociadosColeccion(nColeccionAsociada, nCampoOrigen, nCampoDestino: integer);

    procedure AsignarConexion( ConexionEntidad: TEntidadConexion);

    function Guardar: boolean; virtual;
    function Eliminar: boolean; virtual;

    procedure CargarCombo(IndiceCampoDato: integer;
                          IndiceCampoDescripcion: integer;
                          Items: TStringList; SinDuplicados: boolean = false); overload;
    procedure CargarCombo(IndiceCampoDato: integer;
                          IndiceCampoDescripcion: integer;
                          IndiceCampoCondicion: integer;
                          ValorCondicion: Variant;
                          Items: TStringList; SinDuplicados: boolean = false); overload;
    procedure CargarCombo(IndiceCampoDato: integer;
                          IndiceCampoDescripcion: integer;
                          IndiceCampoCondicion1: integer;
                          ValorCondicion1: Variant;
                          IndiceCampoCondicion2: integer;
                          ValorCondicion2: Variant;
                          Items: TStringList; SinDuplicados: boolean = false); overload;
    procedure CargarCombo(IndiceCampoDato: integer;
                          IndiceCampoDescripcion: integer;
                          aIndiceCampoCondicion: array of Integer;
                          aTipoCondicion: array of TTipoComparacion;
                          aValorCondicion: array of Variant;
                          Items: TStringList; SinDuplicados: boolean = false); overload;

    property Tabla: string read FTabla write FTabla;
    property EsNueva: boolean read FEsNueva write FEsNueva;
    property Campos: TColeccionCampos read FCampos write FCampos;
    property EnEdicion: boolean read FEnEdicion write FEnEdicion;
    property Conexion: TEntidadConexion read GetEntidadConexion;
    property EntidadAsociadaID: integer read FEntidadAsociadaID write FEntidadAsociadaID;
  end;

  function ObtenerItemIndex(Items: TStrings; nValor: integer): integer;  overload;
  function ObtenerItemIndex(Items: TStrings; sValor: string): integer; overload;

implementation

uses DB;

function ObtenerItemIndex(Items: TStrings; nValor: integer): integer;
var
  i : integer;
begin
  Result := -1;
  for i := 0 to Items.Count-1 do
  begin
    if (Items.Objects[i] as TDatoCombo).GetAsInteger = nValor then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function ObtenerItemIndex(Items: TStrings; sValor: string): integer;
var
  i : integer;
begin
  Result := -1;
  for i := 0 to Items.Count-1 do
  begin
    if (Items.Objects[i] as TDatoCombo).GetAsString = sValor then
    begin
      Result := i;
      Break;
    end;
  end;
end;

{ TEntidadBase }

function TEntidadBase.ActualizarEntidad: boolean;
var
  update : TUpdateStatement;
  nCampo : integer;
begin
  Result := true;
  if FCampos.FueronCambiados then
  begin
    update := TUpdateStatement.Create(FCampos);

    for nCampo := 0 to FCampos.Count - 1 do
    begin
      if FCampos.Campo[nCampo].EsClavePrimaria then
      begin
        update.Condicion.Agregar(TCondicionComparacion.Create(FCampos.Campo[nCampo],
                                                              tcIgual,
                                                              FCampos.Campo[nCampo].ValorActual))
      end;
    end;
    if Conexion.SQLManager.EjecutarUpdate(update) then
      Result := (update.RegistrosActualizados = 1)
    else
      Result := false;
    update.Free;
  end;
end;

procedure TEntidadBase.AgregarCamposAsociadosEntidad(nEntidadAsociada, nCampoOrigen,
  nCampoDestino: integer);
begin
  (EntidadesAsociadas.Items[nEntidadAsociada] as TEntidadAsociada).AgregarCamposRelacionados(nCampoOrigen, nCampoDestino);
end;

procedure TEntidadBase.AgregarCamposAsociadosColeccion(nColeccionAsociada,
  nCampoOrigen, nCampoDestino: integer);
begin
  (ColeccionesAsociadas.Items[nColeccionAsociada] as TEntidadAsociada).AgregarCamposRelacionados(nCampoOrigen, nCampoDestino);
end;

function TEntidadBase.AgregarColeccionAsociada(
  ColeccionEntidades: TColeccionEntidades): integer;
begin
  Result := ColeccionesAsociadas.Add(TEntidadAsociada.Create(ColeccionEntidades));
end;

function TEntidadBase.AgregarEntidadAsociada(Entidad: TEntidadBase): integer;
begin
  Result := EntidadesAsociadas.Add(TEntidadAsociada.Create(Entidad));
  Entidad.EntidadAsociadaID := Result;
end;

function TEntidadBase.AsignarCamposDesdeSeleccion(select: TSelectStatement): boolean;
var
  nCampo : integer;
  stream : TStream;
begin
  Conexion.SQLManager.EjecutarSelect(select);
  Result := true;
  if not select.Datos.Eof then begin
    for nCampo := 0 to FCampos.Count - 1 do
    begin
      FCampos.Campo[nCampo].EsNulo := select.Datos.Fields[nCampo].IsNull;
      if not FCampos.Campo[nCampo].EsNulo then begin
        if FCampos.Campo[nCampo].TipoDato = tdBlobBinary then begin
          stream := select.Datos.CreateBlobStream(select.Datos.Fields[nCampo], bmRead);
          FCampos.Campo[nCampo].AsStream.LoadFromStream(stream);
          stream.Free;
        end
        else
          FCampos.Campo[nCampo].ValorActual := select.Datos.Fields[nCampo].Value;
      end;
    end;
    FCampos.FueronCambiados := false;
    EsNueva := false;
  end
  else begin
    for nCampo := 0 to FCampos.Count - 1 do
      FCampos.Campo[nCampo].ValorActual := FCampos.Campo[nCampo].ValorPorDefecto;
    FCampos.FueronCambiados := false;
    EsNueva := true;
    Result := false;
  end;
end;

procedure TEntidadBase.AsignarConexion(ConexionEntidad: TEntidadConexion);
begin
  FEntidadConexion := ConexionEntidad;
  FOwnsEntidadConexion := false;
end;

procedure TEntidadBase.CargarCombo(IndiceCampoDato,
  IndiceCampoDescripcion: integer; Items: TStringList; SinDuplicados: boolean);
begin
  CargarCombo(IndiceCampoDato, IndiceCampoDescripcion, -1, '', -1, '', Items, SinDuplicados);
end;

procedure TEntidadBase.CargarCombo(IndiceCampoDato, IndiceCampoDescripcion,
  IndiceCampoCondicion: integer; ValorCondicion: Variant; Items: TStringList; SinDuplicados: boolean);
begin
  CargarCombo(IndiceCampoDato, IndiceCampoDescripcion, IndiceCampoCondicion,
              ValorCondicion, -1, '', Items, SinDuplicados);
end;

procedure TEntidadBase.CargarCombo(IndiceCampoDato, IndiceCampoDescripcion,
  IndiceCampoCondicion1: integer; ValorCondicion1: Variant;
  IndiceCampoCondicion2: integer; ValorCondicion2: Variant; Items: TStringList; SinDuplicados: boolean);
begin
  CargarCombo(IndiceCampoDato, IndiceCampoDescripcion,
              [IndiceCampoCondicion1, IndiceCampoCondicion2],
              [tcIgual, tcIgual], [ValorCondicion1, Valorcondicion2],
              Items, SinDuplicados);
end;

function TEntidadBase.Clonar(Coleccion: TCollection): TEntidadBase;
begin
  if Assigned(Coleccion) then
    Result := TEntidadBase(Coleccion.ItemClass.Create(Coleccion))
  else
    Result := TEntidadBase.Create(Coleccion);
  Result.Campos.Free;
  Result.Campos   := Campos.Clonar;
  Result.Tabla    := FTabla;
  Result.EsNueva  := FEsNueva;
  Result.EnEdicion:= FEnEdicion;
end;

function TEntidadBase.CrearNuevaConexionEntidad: TEntidadConexion;
begin
  Result := nil;
end;

constructor TEntidadBase.Create(Coleccion: TCollection; ComoEntidadNueva: boolean);
begin
  inherited Create(Coleccion);
  FCampos := TColeccionCampos.Create;
  EsNueva := ComoEntidadNueva;
  FEntidadesAsociadas   := nil;
  FColeccionesAsociadas := nil;
  FEntidadConexion      := nil;
  FOwnsEntidadConexion  := false;
  if assigned(Coleccion) then
    AsignarConexion((Coleccion as TColeccionEntidades).Conexion);
end;

destructor TEntidadBase.Destroy;
begin
  FreeAndNil(FCampos);
  FreeAndNil(FEntidadesAsociadas);
  FreeAndNil(FColeccionesAsociadas);

  if (FOwnsEntidadConexion) and (not FEntidadConexion.ConexionPublica) then
    FreeAndNil(FEntidadConexion);

  inherited;
end;

function TEntidadBase.Eliminar: boolean;
var
  delete : TDeleteStatement;
  nCampo : integer;
begin
  delete := TDeleteStatement.Create(FTabla);

  for nCampo := 0 to FCampos.Count - 1 do
  begin
    if FCampos.Campo[nCampo].EsClavePrimaria then
    begin
      delete.Condicion.Agregar(TCondicionComparacion.Create(FCampos.Campo[nCampo],
                                                            tcIgual,
                                                            FCampos.Campo[nCampo].ValorActual))
    end;
  end;
  if Conexion.SQLManager.EjecutarDelete(delete) then
    Result := (delete.RegistrosEliminados = 1)
  else
    Result := false;

  delete.Free;
end;

procedure TEntidadBase.EliminarEntidadAsociada(Entidad: TEntidadBase);
var
  nPos: integer;
begin
  if Assigned(Entidad) then
  begin
    for nPos := 0 to EntidadesAsociadas.Count - 1 do
    begin
      if TEntidadAsociada(EntidadesAsociadas.Items[nPos]).Entidad = Entidad then
      begin
        EntidadesAsociadas.Delete(nPos);
        FreeAndNil(Entidad);
        Break;
      end;
    end;
  end;
end;

function TEntidadBase.GetColeccionesAsociadas: TObjectList;
begin
  if not assigned(FColeccionesAsociadas) then
    FColeccionesAsociadas := TObjectList.Create(true);

  Result := FColeccionesAsociadas;
end;

function TEntidadBase.GetEntidadConexion: TEntidadConexion;
begin
  if not assigned(FEntidadConexion)  then
  begin
    FEntidadConexion := CrearNuevaConexionEntidad;
    FOwnsEntidadConexion := true;
  end;
  Result := FEntidadConexion;
end;

function TEntidadBase.GetEntidadesAsociadas: TObjectList;
begin
  if not assigned(FEntidadesAsociadas) then
    FEntidadesAsociadas := TObjectList.Create(true);

  Result := FEntidadesAsociadas;
end;

function TEntidadBase.Guardar: boolean;
var
  bComienzoTransaccion : boolean;
  nEntidad, nEntidadColeccion, nCampo : integer;
  unaEntidadAsociada: TEntidadAsociada;
  unaEntidad: TEntidadBase;
  unCR : TCamposRelacionados;
begin
  bComienzoTransaccion := false;
  Result := true;

  if not Conexion.EnTransaccion then begin
    Conexion.BeginTransaction;
    bComienzoTransaccion := true;
  end;

  if assigned(FEntidadesAsociadas) then begin
    for nEntidad := 0 to FEntidadesAsociadas.Count - 1 do begin
      unaEntidadAsociada := (FEntidadesAsociadas.Items[nEntidad] as TEntidadAsociada);
      //Se asigna al crearse
      unaEntidadAsociada.Entidad.AsignarConexion(FEntidadConexion);
      Result := unaEntidadAsociada.Entidad.Guardar;
      if Result then begin
        for nCampo := 0 to unaEntidadAsociada.CantidadRelaciones - 1 do begin
          unCR := unaEntidadAsociada.CamposRelacionados[nCampo];
          FCampos.Campo[unCR.CampoOrigen].ValorActual := unaEntidadAsociada.Entidad.Campos.Campo[unCR.CampoDestino].ValorActual;
        end;
      end
      else
        Break;
    end;
  end;

  if Result then begin
    if FEsNueva then begin
      Result := InsertarEntidad;
      if Result then
        FEsNueva := false;
    end
    else
      Result := ActualizarEntidad;
  end;

  if assigned(FColeccionesAsociadas) then begin
    for nEntidad := 0 to FColeccionesAsociadas.Count - 1 do begin
      unaEntidadAsociada := (FColeccionesAsociadas.Items[nEntidad] as TEntidadAsociada);
      //Asigno valores
      for nEntidadColeccion := 0 to unaEntidadAsociada.ColeccionEntidades.Count - 1 do begin
        unaEntidad := (unaEntidadAsociada.ColeccionEntidades.Items[nEntidadColeccion] as TEntidadBase);
        if (unaEntidad.EsNueva) or (unaEntidad.Campos.FueronCambiados) then
        begin
          for nCampo := 0 to unaEntidadAsociada.CantidadRelaciones - 1 do begin
            unCR := unaEntidadAsociada.CamposRelacionados[nCampo];
            unaEntidad.Campos.Campo[unCR.CampoDestino].ValorActual := FCampos.Campo[unCR.CampoOrigen].ValorActual;
          end;
        end;
      end;
      Result := unaEntidadAsociada.ColeccionEntidades.Guardar;
    end;
  end;

  if bComienzoTransaccion then begin
    if (Result) then
      Conexion.Commit
    else
      Conexion.RollBack;
  end;
end;

function TEntidadBase.InsertarEntidad: boolean;
var
  insert : TInsertStatement;
begin
  insert := TInsertStatement.Create(FCampos);

  if Conexion.SQLManager.EjecutarInsert(insert) then
    Result := (insert.RegistrosInsertados = 1)
  else
    Result := false;

  insert.Free;
end;

procedure TEntidadBase.CargarCombo(IndiceCampoDato,
  IndiceCampoDescripcion: integer; aIndiceCampoCondicion: array of Integer;
  aTipoCondicion: array of TTipoComparacion; aValorCondicion: array of Variant; 
  Items: TStringList; SinDuplicados: boolean);
var
  select : TSelectStatement;
  CamposCombo: TColeccionCampos;
  ChangeEvent : TNotifyEvent;
  Sorted : boolean;
  nCondicion: Integer;
begin
  CamposCombo := TColeccionCampos.Create;
  CamposCombo.Agregar(FCampos.Campo[IndiceCampoDato].Clonar);
  CamposCombo.Agregar(FCampos.Campo[IndiceCampoDescripcion].Clonar);
  select := TSelectStatement.Create(CamposCombo);
  select.SinDuplicados := SinDuplicados;
  select.Orden.Agregar( FCampos.Campo[IndiceCampoDescripcion], toAscendente);

  for nCondicion := 0 to Length(aIndiceCampoCondicion) - 1 do
  begin
    if (aIndiceCampoCondicion[nCondicion] > -1) then
      select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.Campo[aIndiceCampoCondicion[nCondicion]],
                                aTipoCondicion[nCondicion], aValorCondicion[nCondicion]));
  end;

  Conexion.SQLManager.EjecutarSelect(select);
  ChangeEvent := nil;
  if Assigned(Items.OnChange) then
    ChangeEvent := Items.OnChange;
  Items.OnChange := nil;

  Sorted := Items.Sorted;
  Items.Sorted := false;

  Items.Clear;
  while not select.Datos.Eof do
  begin
    Items.AddObject(Select.Datos.Fields[1].AsString, TDatoCombo.Create(Select.Datos.Fields[0].AsVariant));
    select.Datos.Next;
  end;
  Select.Free;
  CamposCombo.Free;
  Items.Sorted := Sorted;
  if Assigned(ChangeEvent) then
  begin
    Items.OnChange := ChangeEvent;
    Items.OnChange(nil);
  end;
end;

{ TDatoCombo }

constructor TDatoCombo.Create(Dato: variant);
begin
  FDato := Dato;
end;

function TDatoCombo.GetAsInteger: integer;
begin
  Result := FDato;
end;

function TDatoCombo.GetAsString: string;
begin
  Result := FDato;
end;

function TDatoCombo.GetAsVariant: Variant;
begin
  Result := FDato;
end;

{ TParCampos }

constructor TCamposRelacionados.Create(nCampoOrigen, nCampoDestino: integer);
begin
  FCampoOrigen  := nCampoOrigen;
  FCampoDestino := nCampoDestino;
end;

{ TEntidadAsociada }

procedure TEntidadAsociada.AgregarCamposRelacionados(nCampoOrigen,
  nCampoDestino: integer);
begin
  FCamposRelacionados.Add(TCamposRelacionados.Create(nCampoOrigen, nCampoDestino));
end;

constructor TEntidadAsociada.Create(unaEntidad: TEntidadBase);
begin
  FObjetoAsociado := unaEntidad;
  FCamposRelacionados:= TObjectList.Create(true);
end;

constructor TEntidadAsociada.Create(unaColeccion: TColeccionEntidades);
begin
  FObjetoAsociado := unaColeccion;
  FCamposRelacionados:= TObjectList.Create(true);
end;

destructor TEntidadAsociada.Destroy;
begin
  FCamposRelacionados.Free;
  inherited;
end;

function TEntidadAsociada.GetCamposRelacionados(
  index: integer): TCamposRelacionados;
begin
  Result := FCamposRelacionados.Items[index] as TCamposRelacionados;
end;

function TEntidadAsociada.GetCantidadRelaciones: integer;
begin
  Result := FCamposRelacionados.Count;
end;

function TEntidadAsociada.GetColeccionEntidades: TColeccionEntidades;
begin
  Result := FObjetoAsociado as TColeccionEntidades;
end;

function TEntidadAsociada.GetEntidad: TEntidadBase;
begin
  Result := FObjetoAsociado as TEntidadBase;
end;

end.

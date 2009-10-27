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
  TORMEntidadBase = class;
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

  TORMCamposRelacionados=class
  private
    FCampoOrigen: integer;
    FCampoDestino: integer;
  public
    constructor Create(nCampoOrigen, nCampoDestino: integer);

    property CampoOrigen: integer read FCampoOrigen;
    property CampoDestino: integer read FCampoDestino;
  end;

  TORMEntidadAsociada = class
  private
    function GetCamposRelacionados(index: integer): TORMCamposRelacionados;
    function GetCantidadRelaciones: integer;
    function GetEntidad: TORMEntidadBase;
    function GetColeccionEntidades: TORMColeccionEntidades;
  protected
    FCamposRelacionados : TObjectList;
    FObjetoAsociado     : TObject;
  public
    constructor Create(unaEntidad: TORMEntidadBase); overload;
    constructor Create(unaColeccion: TORMColeccionEntidades); overload;
    destructor Destroy; override;
    procedure AgregarCamposRelacionados(nCampoOrigen, nCampoDestino: integer);

    property Entidad: TORMEntidadBase read GetEntidad;
    property ColeccionEntidades: TORMColeccionEntidades read GetColeccionEntidades;
    property CantidadRelaciones: integer read GetCantidadRelaciones;
    property CamposRelacionados[index: integer]: TORMCamposRelacionados read GetCamposRelacionados;
  end;

  TORMEntidadBase = class(TCollectionItem)
  protected
    FTabla              : string;
    FEsNueva            : boolean;
    FCampos             : TORMColeccionCampos;
    FEnEdicion          : boolean;
    FEntidadesAsociadas : TObjectList;
    FColeccionesAsociadas: TObjectList;
    FEntidadConexion    : TORMEntidadConexion;
    FOwnsEntidadConexion: boolean;
    FEntidadAsociadaID  : integer;

    function InsertarEntidad: boolean; virtual;
    function ActualizarEntidad: boolean; virtual;
    function AsignarCamposDesdeSeleccion(select : TSelectStatement): boolean;
  private
    function GetEntidadesAsociadas: TObjectList;
    function GetColeccionesAsociadas: TObjectList;
    function GetEntidadConexion: TORMEntidadConexion;
    property EntidadesAsociadas: TObjectList read GetEntidadesAsociadas;
    property ColeccionesAsociadas: TObjectList read GetColeccionesAsociadas;
  public
    constructor Create(Coleccion: TCollection; ComoEntidadNueva: boolean = true);
    destructor Destroy; override;

    function CrearNuevaConexionEntidad: TORMEntidadConexion; virtual;
    function Clonar(Coleccion: TCollection = nil): TORMEntidadBase;

    function AgregarEntidadAsociada(Entidad: TORMEntidadBase): integer;
    procedure EliminarEntidadAsociada(Entidad: TORMEntidadBase);

    procedure AgregarCamposAsociadosEntidad(nEntidadAsociada, nCampoOrigen, nCampoDestino: integer);

    function AgregarColeccionAsociada(ColeccionEntidades: TORMColeccionEntidades): integer;
    procedure AgregarCamposAsociadosColeccion(nColeccionAsociada, nCampoOrigen, nCampoDestino: integer);

    procedure AsignarConexion(ConexionEntidad: TORMEntidadConexion);

    function Guardar: boolean; virtual;
    function Eliminar: boolean; virtual;
    function GetRelacionesDefault(OwnObjects: Boolean=True): TExpresionRelacion; virtual;

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
                          aTipoCondicion: array of TORMTipoComparacion;
                          aValorCondicion: array of Variant;
                          Items: TStringList; SinDuplicados: boolean = false); overload;

    property Tabla: string read FTabla write FTabla;
    property EsNueva: boolean read FEsNueva write FEsNueva;
    property ORMCampos: TORMColeccionCampos read FCampos write FCampos;
    property EnEdicion: boolean read FEnEdicion write FEnEdicion;
    property Conexion: TORMEntidadConexion read GetEntidadConexion;
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

function TORMEntidadBase.ActualizarEntidad: boolean;
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
      if FCampos.ORMCampo[nCampo].EsClavePrimaria then
      begin
        update.Condicion.Agregar(TCondicionComparacion.Create(FCampos.ORMCampo[nCampo],
                                                              tcIgual,
                                                              FCampos.ORMCampo[nCampo].ValorActual))
      end;
    end;
    if Conexion.SQLManager.EjecutarUpdate(update) then
      Result := (update.RegistrosActualizados = 1)
    else
      Result := false;
    update.Free;
  end;
end;

procedure TORMEntidadBase.AgregarCamposAsociadosEntidad(nEntidadAsociada, nCampoOrigen,
  nCampoDestino: integer);
begin
  (EntidadesAsociadas.Items[nEntidadAsociada] as TORMEntidadAsociada).AgregarCamposRelacionados(nCampoOrigen, nCampoDestino);
end;

procedure TORMEntidadBase.AgregarCamposAsociadosColeccion(nColeccionAsociada,
  nCampoOrigen, nCampoDestino: integer);
begin
  (ColeccionesAsociadas.Items[nColeccionAsociada] as TORMEntidadAsociada).AgregarCamposRelacionados(nCampoOrigen, nCampoDestino);
end;

function TORMEntidadBase.AgregarColeccionAsociada(
  ColeccionEntidades: TORMColeccionEntidades): integer;
begin
  Result := ColeccionesAsociadas.Add(TORMEntidadAsociada.Create(ColeccionEntidades));
end;

function TORMEntidadBase.AgregarEntidadAsociada(Entidad: TORMEntidadBase): integer;
begin
  Result := EntidadesAsociadas.Add(TORMEntidadAsociada.Create(Entidad));
  Entidad.EntidadAsociadaID := Result;
end;

function TORMEntidadBase.AsignarCamposDesdeSeleccion(select: TSelectStatement): boolean;
var
  nCampo : integer;
  stream : TStream;
begin
  Conexion.SQLManager.EjecutarSelect(select);
  Result := true;
  if not select.Datos.Eof then begin
    for nCampo := 0 to FCampos.Count - 1 do
    begin
      FCampos.ORMCampo[nCampo].EsNulo := select.Datos.Fields[nCampo].IsNull;
      if not FCampos.ORMCampo[nCampo].EsNulo then begin
        if FCampos.ORMCampo[nCampo].TipoDato = tdBlobBinary then begin
          stream := select.Datos.CreateBlobStream(select.Datos.Fields[nCampo], bmRead);
          FCampos.ORMCampo[nCampo].AsStream.LoadFromStream(stream);
          stream.Free;
        end
        else
          FCampos.ORMCampo[nCampo].ValorActual := select.Datos.Fields[nCampo].Value;
      end;
    end;
    FCampos.FueronCambiados := false;
    EsNueva := false;
  end
  else begin
    for nCampo := 0 to FCampos.Count - 1 do
      FCampos.ORMCampo[nCampo].ValorActual := FCampos.ORMCampo[nCampo].ValorPorDefecto;
    FCampos.FueronCambiados := false;
    EsNueva := true;
    Result := false;
  end;
end;

procedure TORMEntidadBase.AsignarConexion(ConexionEntidad: TORMEntidadConexion);
begin
  FEntidadConexion := ConexionEntidad;
  FOwnsEntidadConexion := false;
end;

procedure TORMEntidadBase.CargarCombo(IndiceCampoDato,
  IndiceCampoDescripcion: integer; Items: TStringList; SinDuplicados: boolean);
begin
  CargarCombo(IndiceCampoDato, IndiceCampoDescripcion, -1, '', -1, '', Items, SinDuplicados);
end;

procedure TORMEntidadBase.CargarCombo(IndiceCampoDato, IndiceCampoDescripcion,
  IndiceCampoCondicion: integer; ValorCondicion: Variant; Items: TStringList; SinDuplicados: boolean);
begin
  CargarCombo(IndiceCampoDato, IndiceCampoDescripcion, IndiceCampoCondicion,
              ValorCondicion, -1, '', Items, SinDuplicados);
end;

procedure TORMEntidadBase.CargarCombo(IndiceCampoDato, IndiceCampoDescripcion,
  IndiceCampoCondicion1: integer; ValorCondicion1: Variant;
  IndiceCampoCondicion2: integer; ValorCondicion2: Variant; Items: TStringList; SinDuplicados: boolean);
begin
  CargarCombo(IndiceCampoDato, IndiceCampoDescripcion,
              [IndiceCampoCondicion1, IndiceCampoCondicion2],
              [tcIgual, tcIgual], [ValorCondicion1, Valorcondicion2],
              Items, SinDuplicados);
end;

function TORMEntidadBase.Clonar(Coleccion: TCollection): TORMEntidadBase;
begin
  if Assigned(Coleccion) then
    Result := TORMEntidadBase(Coleccion.ItemClass.Create(Coleccion))
  else
    Result := TORMEntidadBase.Create(Coleccion);
  Result.ORMCampos.Free;
  Result.ORMCampos:= ORMCampos.Clonar;
  Result.Tabla    := FTabla;
  Result.EsNueva  := FEsNueva;
  Result.EnEdicion:= FEnEdicion;
end;

function TORMEntidadBase.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
  Result := nil;
end;

constructor TORMEntidadBase.Create(Coleccion: TCollection; ComoEntidadNueva: boolean);
begin
  inherited Create(Coleccion);
  FCampos := TORMColeccionCampos.Create;
  EsNueva := ComoEntidadNueva;
  FEntidadesAsociadas   := nil;
  FColeccionesAsociadas := nil;
  FEntidadConexion      := nil;
  FOwnsEntidadConexion  := false;
  if assigned(Coleccion) then
    AsignarConexion((Coleccion as TORMColeccionEntidades).Conexion);
end;

destructor TORMEntidadBase.Destroy;
begin
  FreeAndNil(FCampos);
  FreeAndNil(FEntidadesAsociadas);
  FreeAndNil(FColeccionesAsociadas);

  if (FOwnsEntidadConexion) and (not FEntidadConexion.ConexionPublica) then
    FreeAndNil(FEntidadConexion);

  inherited;
end;

function TORMEntidadBase.Eliminar: boolean;
var
  delete : TDeleteStatement;
  nCampo : integer;
begin
  delete := TDeleteStatement.Create(FTabla);

  for nCampo := 0 to FCampos.Count - 1 do
  begin
    if FCampos.ORMCampo[nCampo].EsClavePrimaria then
    begin
      delete.Condicion.Agregar(TCondicionComparacion.Create(FCampos.ORMCampo[nCampo],
                                                            tcIgual,
                                                            FCampos.ORMCampo[nCampo].ValorActual))
    end;
  end;
  if Conexion.SQLManager.EjecutarDelete(delete) then
    Result := (delete.RegistrosEliminados = 1)
  else
    Result := false;

  delete.Free;
end;

procedure TORMEntidadBase.EliminarEntidadAsociada(Entidad: TORMEntidadBase);
var
  nPos: integer;
begin
  if Assigned(Entidad) then
  begin
    for nPos := 0 to EntidadesAsociadas.Count - 1 do
    begin
      if TORMEntidadAsociada(EntidadesAsociadas.Items[nPos]).Entidad = Entidad then
      begin
        EntidadesAsociadas.Delete(nPos);
        FreeAndNil(Entidad);
        Break;
      end;
    end;
  end;
end;

function TORMEntidadBase.GetColeccionesAsociadas: TObjectList;
begin
  if not assigned(FColeccionesAsociadas) then
    FColeccionesAsociadas := TObjectList.Create(true);

  Result := FColeccionesAsociadas;
end;

function TORMEntidadBase.GetEntidadConexion: TORMEntidadConexion;
begin
  if not assigned(FEntidadConexion)  then
  begin
    FEntidadConexion := CrearNuevaConexionEntidad;
    FOwnsEntidadConexion := true;
  end;
  Result := FEntidadConexion;
end;

function TORMEntidadBase.GetEntidadesAsociadas: TObjectList;
begin
  if not assigned(FEntidadesAsociadas) then
    FEntidadesAsociadas := TObjectList.Create(true);

  Result := FEntidadesAsociadas;
end;

function TORMEntidadBase.GetRelacionesDefault(OwnObjects: Boolean): TExpresionRelacion;
begin
  Result := nil;
end;

function TORMEntidadBase.Guardar: boolean;
var
  bComienzoTransaccion : boolean;
  nEntidad, nEntidadColeccion, nCampo : integer;
  unaEntidadAsociada: TORMEntidadAsociada;
  unaEntidad: TORMEntidadBase;
  unCR : TORMCamposRelacionados;
begin
  bComienzoTransaccion := false;
  Result := true;

  if not Conexion.EnTransaccion then begin
    Conexion.BeginTransaction;
    bComienzoTransaccion := true;
  end;

  if assigned(FEntidadesAsociadas) then begin
    for nEntidad := 0 to FEntidadesAsociadas.Count - 1 do begin
      unaEntidadAsociada := (FEntidadesAsociadas.Items[nEntidad] as TORMEntidadAsociada);
      //Se asigna al crearse
      unaEntidadAsociada.Entidad.AsignarConexion(FEntidadConexion);
      Result := unaEntidadAsociada.Entidad.Guardar;
      if Result then begin
        for nCampo := 0 to unaEntidadAsociada.CantidadRelaciones - 1 do begin
          unCR := unaEntidadAsociada.CamposRelacionados[nCampo];
          FCampos.ORMCampo[unCR.CampoOrigen].ValorActual := unaEntidadAsociada.Entidad.ORMCampos.ORMCampo[unCR.CampoDestino].ValorActual;
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
      unaEntidadAsociada := (FColeccionesAsociadas.Items[nEntidad] as TORMEntidadAsociada);
      //Asigno valores
      for nEntidadColeccion := 0 to unaEntidadAsociada.ColeccionEntidades.Count - 1 do begin
        unaEntidad := (unaEntidadAsociada.ColeccionEntidades.Items[nEntidadColeccion] as TORMEntidadBase);
        if (unaEntidad.EsNueva) or (unaEntidad.ORMCampos.FueronCambiados) then
        begin
          for nCampo := 0 to unaEntidadAsociada.CantidadRelaciones - 1 do begin
            unCR := unaEntidadAsociada.CamposRelacionados[nCampo];
            unaEntidad.ORMCampos.ORMCampo[unCR.CampoDestino].ValorActual := FCampos.ORMCampo[unCR.CampoOrigen].ValorActual;
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

function TORMEntidadBase.InsertarEntidad: boolean;
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

procedure TORMEntidadBase.CargarCombo(IndiceCampoDato,
  IndiceCampoDescripcion: integer; aIndiceCampoCondicion: array of Integer;
  aTipoCondicion: array of TORMTipoComparacion; aValorCondicion: array of Variant; 
  Items: TStringList; SinDuplicados: boolean);
var
  select : TSelectStatement;
  CamposCombo: TORMColeccionCampos;
  ChangeEvent : TNotifyEvent;
  Sorted : boolean;
  nAux: Integer;
  Relaciones: TExpresionRelacion;
begin
  CamposCombo := TORMColeccionCampos.Create;
  CamposCombo.Agregar(FCampos.ORMCampo[IndiceCampoDato].Clonar);
  CamposCombo.Agregar(FCampos.ORMCampo[IndiceCampoDescripcion].Clonar);
  select := TSelectStatement.Create(CamposCombo);
  select.SinDuplicados := SinDuplicados;
  select.Orden.Agregar( FCampos.ORMCampo[IndiceCampoDescripcion], toAscendente);

  for nAux := 0 to Length(aIndiceCampoCondicion) - 1 do
  begin
    if (aIndiceCampoCondicion[nAux] > -1) then
      select.Condicion.Agregar(TCondicionComparacion.Create(FCampos.ORMCampo[aIndiceCampoCondicion[nAux]],
                                aTipoCondicion[nAux], aValorCondicion[nAux]));
  end;

  Relaciones := GetRelacionesDefault(False);
  if Assigned(Relaciones) then
  begin
    for nAux := 0 to Relaciones.Count - 1 do
    begin
      select.Relaciones.Agregar(Relaciones.Relacion[nAux]);
    end;
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
  FreeAndNil(Select);
  FreeAndNil(CamposCombo);
  FreeAndNil(Relaciones);
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

constructor TORMCamposRelacionados.Create(nCampoOrigen, nCampoDestino: integer);
begin
  FCampoOrigen  := nCampoOrigen;
  FCampoDestino := nCampoDestino;
end;

{ TEntidadAsociada }

procedure TORMEntidadAsociada.AgregarCamposRelacionados(nCampoOrigen,
  nCampoDestino: integer);
begin
  FCamposRelacionados.Add(TORMCamposRelacionados.Create(nCampoOrigen, nCampoDestino));
end;

constructor TORMEntidadAsociada.Create(unaEntidad: TORMEntidadBase);
begin
  FObjetoAsociado := unaEntidad;
  FCamposRelacionados:= TObjectList.Create(true);
end;

constructor TORMEntidadAsociada.Create(unaColeccion: TORMColeccionEntidades);
begin
  FObjetoAsociado := unaColeccion;
  FCamposRelacionados:= TObjectList.Create(true);
end;

destructor TORMEntidadAsociada.Destroy;
begin
  FCamposRelacionados.Free;
  inherited;
end;

function TORMEntidadAsociada.GetCamposRelacionados(
  index: integer): TORMCamposRelacionados;
begin
  Result := FCamposRelacionados.Items[index] as TORMCamposRelacionados;
end;

function TORMEntidadAsociada.GetCantidadRelaciones: integer;
begin
  Result := FCamposRelacionados.Count;
end;

function TORMEntidadAsociada.GetColeccionEntidades: TORMColeccionEntidades;
begin
  Result := FObjetoAsociado as TORMColeccionEntidades;
end;

function TORMEntidadAsociada.GetEntidad: TORMEntidadBase;
begin
  Result := FObjetoAsociado as TORMEntidadBase;
end;

end.

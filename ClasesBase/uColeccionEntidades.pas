{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uColeccionEntidades.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}

unit uColeccionEntidades;

interface

uses Classes, Contnrs, DB, uSQLBuilder, uExpresiones, uCampos, uConexion;

type
  TColeccionEntidades = Class(TCollection)
  private
    FEntidadesEliminadas: TObjectList;
    FDataSet: TDataSet;
    FEntidadConexion    : TEntidadConexion;
    FOwnsEntidadConexion: boolean;

    function GetDataSet: TDataSet;
    procedure SetDataSet(const Value: TDataSet);
    function GetEntidadConexion: TEntidadConexion;
  protected
    FCampos : TColeccionCampos;
    FSelectStatement : TSelectStatement;
    function ObtenerCampo(index: integer): TCampo;
    procedure ProcesarDataSet; virtual;
  public
    constructor Create(ItemClass: TCollectionItemClass);
    destructor Destroy; override;

    function Guardar: boolean;
    function EliminarTodosFisico: boolean;
    procedure Eliminar(nItem: integer); overload;
    procedure Eliminar(Item: TCollectionItem); overload;
    procedure EliminarTodos;

    function CrearNuevaConexionEntidad: TEntidadConexion; virtual;
    procedure AsignarConexion( ConexionEntidad: TEntidadConexion);

    function ObtenerTodos: integer; virtual;
    function ObtenerMuchos( Filtro: TExpresionCondicion;
                            Orden: TExpresionOrdenamiento = nil;
                            Agrupamiento: TExpresionAgrupamiento = nil;
                            Relaciones: TExpresionRelacion = nil;
                            FiltroHaving: TExpresionCondicion = nil;
                            const CantFilas: integer = 0; const TamPagina: integer = 0;
                            const NroPagina: integer = 0; const SinDuplicados: boolean = false): integer; virtual;
    property AsDataSet: TDataSet read GetDataSet write SetDataSet;
    property Conexion: TEntidadConexion read GetEntidadConexion;
  end;

implementation

uses SnapObjectDataset, SysUtils, uEntidades;

{ TColeccionEntidades }

procedure TColeccionEntidades.AsignarConexion(
  ConexionEntidad: TEntidadConexion);
begin
  FEntidadConexion := ConexionEntidad;
  FOwnsEntidadConexion := false;
end;

function TColeccionEntidades.CrearNuevaConexionEntidad: TEntidadConexion;
begin
  Result := nil;
end;

constructor TColeccionEntidades.Create(ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FDataSet := nil;
  FEntidadConexion := nil;
  FEntidadesEliminadas := TObjectList.Create;
  FOwnsEntidadConexion := false;
end;

destructor TColeccionEntidades.Destroy;
begin
  FCampos.Free;
  FEntidadesEliminadas.Free;

  if assigned(FSelectStatement) then
    FSelectStatement.Free;

  if assigned(FDataSet) then
    FDataSet.Free;

  if (FOwnsEntidadConexion) and (not FEntidadConexion.ConexionPublica) then
    FreeAndNil(FEntidadConexion);

  inherited;
end;

procedure TColeccionEntidades.Eliminar(nItem: integer);
var
  unaEntidadSimple: TEntidadBase;
begin
  if nItem < Count then
  begin
    unaEntidadSimple := (Items[nItem] as TEntidadBase).Clonar;
    unaEntidadSimple.AsignarConexion(Conexion);
    FEntidadesEliminadas.Add(unaEntidadSimple);
    Delete(nItem);
  end;
end;

procedure TColeccionEntidades.Eliminar(Item: TCollectionItem);
var
  nItem : integer;
begin
  for nItem := 0 to Count -1 do
  begin
    if Items[nItem] = Item then
    begin
      Eliminar(nItem);
      break;
    end;
  end;
end;

procedure TColeccionEntidades.EliminarTodos;
var
  nItem : integer;
begin
  for nItem := Count-1 downto 0 do
    Eliminar(nItem);
end;

function TColeccionEntidades.EliminarTodosFisico: boolean;
var
  bCerrarTransaccion: boolean;
  {$ifdef DELPHI2006UP}
  unaEntidad: TCollectionItem;
  {$else}
  nEntidad: integer;
  {$endif}
begin
  bCerrarTransaccion := false;
  if not Conexion.EnTransaccion then begin
    Conexion.BeginTransaction;
    bCerrarTransaccion := true;
  end;
  Result := true;
  {$ifdef DELPHI2006UP}
  for unaEntidad in Self do
    Result := Result and (unaEntidad as TEntidadBase).Eliminar;
  {$else}
  for nEntidad:= 0 to Count-1 do
    Result := Result and (Items[nEntidad] as TEntidadBase).Eliminar;
  {$endif}

  if bCerrarTransaccion then
  begin
    if Result then
      Conexion.Commit
    else
      Conexion.RollBack;
  end;

  if Result then
    Clear;
end;

function TColeccionEntidades.ObtenerCampo(index: integer): TCampo;
begin
  Result := FCampos.Campo[index];
end;

function TColeccionEntidades.GetDataSet: TDataSet;
begin
  if not assigned(FDataSet) then
  begin
    FDataSet := TSnapObjectDataset.Create(nil);
    (FDataSet as TSnapObjectDataset).ObjectInstance := self;
  end;
  Result := FDataSet;
end;

function TColeccionEntidades.GetEntidadConexion: TEntidadConexion;
begin
  if not assigned(FEntidadConexion) then
  begin
    FEntidadConexion := CrearNuevaConexionEntidad;
    FOwnsEntidadConexion := true;
  end;
  Result := FEntidadconexion;
end;

function TColeccionEntidades.Guardar: boolean;
var
  bCerrarTransaccion: boolean;
  {$ifdef DELPHI2006UP}
  unaEntidad: TCollectionItem;
  {$endif}
  nEntidad: integer;
begin
  bCerrarTransaccion := false;
  if not Conexion.EnTransaccion then begin
    Conexion.BeginTransaction;
    bCerrarTransaccion := true;
  end;

  Result := true;

  for nEntidad := 0 to FEntidadesEliminadas.Count - 1 do
    Result := Result and TEntidadBase(FEntidadesEliminadas[nEntidad]).Eliminar;

  {$ifdef DELPHI2006UP}
  for unaEntidad in Self do
    Result := Result and (unaEntidad as TEntidadBase).Guardar;
  {$else}
  for nEntidad := 0 to Count -1 do
    Result := Result and (Items[nEntidad] as TEntidadBase).Guardar;
  {$endif}

  if bCerrarTransaccion then
  begin
    if Result then
      Conexion.Commit
    else
      Conexion.RollBack;
  end;
  {
  if Result then
    FEntidadesEliminadas.Clear;
  }
end;


function TColeccionEntidades.ObtenerMuchos(Filtro: TExpresionCondicion;
  Orden: TExpresionOrdenamiento; Agrupamiento: TExpresionAgrupamiento;
  Relaciones: TExpresionRelacion; FiltroHaving: TExpresionCondicion; const CantFilas,
  TamPagina, NroPagina: integer; const SinDuplicados: boolean): integer;
{
var
  nEntidad: integer;
}
begin
  FSelectStatement := TSelectStatement.Create(FCampos , Filtro, Orden, Agrupamiento, FiltroHaving, Relaciones, CantFilas, TamPagina, NroPagina, SinDuplicados);

  Conexion.SQLManager.EjecutarSelect(FSelectStatement);
  ProcesarDataSet;
  {
  for nEntidad := 0 to Count - 1 do
  begin
    with TEntidadBase(GetItem(nEntidad)) do
    begin
      EsNueva := false;
      Campos.FueronCambiados := false;
    end;
  end;
  }
  FSelectStatement.LiberarExpresiones := false;

  FreeAndNil(FSelectStatement);
  Result := Count;
end;

function TColeccionEntidades.ObtenerTodos: integer;
begin
  Result := ObtenerMuchos(nil);
end;

procedure TColeccionEntidades.ProcesarDataSet;
begin

end;

procedure TColeccionEntidades.SetDataSet(const Value: TDataSet);
begin
  if FDataSet <> Value then
    FDataSet := Value;
end;

end.

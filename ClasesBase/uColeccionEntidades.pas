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
  TORMColeccionEntidades = Class(TCollection)
  private
    FEntidadesEliminadas: TObjectList;
    FDataSet: TDataSet;
    FEntidadConexion    : TORMEntidadConexion;
    FOwnsEntidadConexion: boolean;
    FLastSQLStatement: string;

    function GetDataSet: TDataSet;
    procedure SetDataSet(const Value: TDataSet);
    function GetEntidadConexion: TORMEntidadConexion;
  protected
    FCampos : TORMColeccionCampos;
    FSelectStatement : TSelectStatement;
    function ObtenerCampo(index: integer): TORMCampo;
    procedure ProcesarDataSet; virtual;
  public
    constructor Create(ItemClass: TCollectionItemClass);
    destructor Destroy; override;

    function Guardar: boolean;
    function EliminarTodosFisico: boolean;
    procedure Eliminar(nItem: integer); overload;
    procedure Eliminar(Item: TCollectionItem); overload;
    procedure EliminarTodos;

    function CrearNuevaConexionEntidad: TORMEntidadConexion; virtual;
    procedure AsignarConexion( ConexionEntidad: TORMEntidadConexion);
    function GetLastSQLStatement: string;

    function ObtenerTodos: integer; virtual;
    function ObtenerMuchos( Filtro: TExpresionCondicion;
                            Orden: TExpresionOrdenamiento = nil;
                            Agrupamiento: TExpresionAgrupamiento = nil;
                            Relaciones: TExpresionRelacion = nil;
                            FiltroHaving: TExpresionCondicion = nil;
                            const CantFilas: integer = 0; const TamPagina: integer = 0;
                            const NroPagina: integer = 0; const SinDuplicados: boolean = false): integer; virtual;
    property AsDataSet: TDataSet read GetDataSet write SetDataSet;
    property Conexion: TORMEntidadConexion read GetEntidadConexion;
  end;

implementation

uses SnapObjectDataset, SysUtils, uEntidades;

{ TColeccionEntidades }

procedure TORMColeccionEntidades.AsignarConexion(
  ConexionEntidad: TORMEntidadConexion);
begin
  FEntidadConexion := ConexionEntidad;
  FOwnsEntidadConexion := false;
end;

function TORMColeccionEntidades.CrearNuevaConexionEntidad: TORMEntidadConexion;
begin
  Result := nil;
end;

constructor TORMColeccionEntidades.Create(ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FDataSet := nil;
  FEntidadConexion := nil;
  FEntidadesEliminadas := TObjectList.Create;
  FOwnsEntidadConexion := false;
end;

destructor TORMColeccionEntidades.Destroy;
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

procedure TORMColeccionEntidades.Eliminar(nItem: integer);
var
  unaEntidadSimple: TORMEntidadBase;
begin
  if nItem < Count then
  begin
    unaEntidadSimple := (Items[nItem] as TORMEntidadBase).Clonar;
    unaEntidadSimple.AsignarConexion(Conexion);
    FEntidadesEliminadas.Add(unaEntidadSimple);
    Delete(nItem);
  end;
end;

procedure TORMColeccionEntidades.Eliminar(Item: TCollectionItem);
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

procedure TORMColeccionEntidades.EliminarTodos;
var
  nItem : integer;
begin
  for nItem := Count-1 downto 0 do
    Eliminar(nItem);
end;

function TORMColeccionEntidades.EliminarTodosFisico: boolean;
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
    Result := Result and (Items[nEntidad] as TORMEntidadBase).Eliminar;
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

function TORMColeccionEntidades.ObtenerCampo(index: integer): TORMCampo;
begin
  Result := FCampos.ORMCampo[index];
end;

function TORMColeccionEntidades.GetDataSet: TDataSet;
begin
  if not assigned(FDataSet) then
  begin
    FDataSet := TSnapObjectDataset.Create(nil);
    (FDataSet as TSnapObjectDataset).ObjectInstance := self;
  end;
  Result := FDataSet;
end;

function TORMColeccionEntidades.GetEntidadConexion: TORMEntidadConexion;
begin
  if not assigned(FEntidadConexion) then
  begin
    FEntidadConexion := CrearNuevaConexionEntidad;
    FOwnsEntidadConexion := true;
  end;
  Result := FEntidadconexion;
end;

function TORMColeccionEntidades.GetLastSQLStatement: string;
begin
  Result := FLastSQLStatement;
end;

function TORMColeccionEntidades.Guardar: boolean;
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
    Result := Result and TORMEntidadBase(FEntidadesEliminadas[nEntidad]).Eliminar;

  {$ifdef DELPHI2006UP}
  for unaEntidad in Self do
    Result := Result and (unaEntidad as TEntidadBase).Guardar;
  {$else}
  for nEntidad := 0 to Count -1 do
    Result := Result and (Items[nEntidad] as TORMEntidadBase).Guardar;
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


function TORMColeccionEntidades.ObtenerMuchos(Filtro: TExpresionCondicion;
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
  FLastSQLStatement := FSelectStatement.SQLStatement;

  FreeAndNil(FSelectStatement);
  Result := Count;
end;

function TORMColeccionEntidades.ObtenerTodos: integer;
begin
  Result := ObtenerMuchos(nil);
end;

procedure TORMColeccionEntidades.ProcesarDataSet;
begin

end;

procedure TORMColeccionEntidades.SetDataSet(const Value: TDataSet);
begin
  if FDataSet <> Value then
    FDataSet := Value;
end;

end.

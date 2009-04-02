{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uFormGenerico.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uFormGenerico;

interface

uses Forms, Graphics, Classes, uCoreClasses;

type
  TFormGenerico = class(TForm)
  protected
    FColeccionGeneradores: TColeccionGenerador;
    FColeccionTablas: TColeccionTabla;
    FColeccionListas: TColeccionListaTabla;
    FStringConexion: string;
    FDriver: string;
    FCambioDatosMapeo: TNotifyEvent;
  public
    procedure Inicializar; virtual;
    function Cerrar: Boolean; virtual;
    function Guardar: Boolean; virtual;
    procedure SetTopColor(ColorDesde: TColor; ColorHasta: TColor); virtual;

    property ColeccionTablas: TColeccionTabla read FColeccionTablas write FColeccionTablas;
    property ColeccionListas: TColeccionListaTabla read FColeccionListas write FColeccionListas;
    property ColeccionGeneradores: TColeccionGenerador read FColeccionGeneradores write FColeccionGeneradores;
    property StringConexion: string read FStringConexion write FStringConexion;
    property Driver: string read FDriver write FDriver;
    property CambioDatosMapeo: TNotifyEvent read FCambioDatosMapeo write FCambioDatosMapeo;
  end;

implementation

{ TFormGenerico }

function TFormGenerico.Cerrar: Boolean;
begin
  Result := true;
end;

function TFormGenerico.Guardar: Boolean;
begin
  Result := true;
end;

procedure TFormGenerico.Inicializar;
begin

end;

procedure TFormGenerico.SetTopColor(ColorDesde, ColorHasta: TColor);
begin

end;

end.

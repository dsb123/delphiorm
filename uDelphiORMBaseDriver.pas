{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: uDelphiORMBaseDriver.PAS, released on 2008-08-26.

The Initial Developer of the Original Code is Adrian De Armas [adearmas@gmail.com]
Portions created by Adrian De Armas are Copyright (C) 2008 Adrian De Armas.
All Rights Reserved.
-----------------------------------------------------------------------------}
unit uDelphiORMBaseDriver;

interface

uses Classes, Contnrs, Forms, uCoreClasses;
  //Windows, Dialogs, Contnrs, Forms, Menus, Classes, TypInfo;

type
  IORMDriverManager=interface
    ['{50D302F3-0741-41D1-9307-C0BB6C4B3E4C}']
    function GetModule: THandle;
    function GetConnectionParameters: string;
    procedure SetConnectionParameters(const sConnectionString: string);
    function ValidateParameters: Boolean;
    function Connect: Boolean;
    function Disconnect: Boolean;
    function GetTablesInfo: TColeccionTabla;
  end;

var
  theClass: TFormClass;
  theForm: TForm;

implementation

initialization
  theClass := nil;
  theForm  := nil;

finalization
  // gets called when finalizing the packages using it!!!
  // listFormClasses.Free;
  // listActiveForms.Free;
end.


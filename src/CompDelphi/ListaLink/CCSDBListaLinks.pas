// NutWin - Programa de Apoio a Nutrição(R)
// Copyright (C) 2002-2010 Departamento de Informática em Saúde
// Universidade Federal de São Paulo - UNIFESP <www.unifesp.br>
//
// This file is part of NutWin.
//
// NutWin is free software:  you  can  redistribute  it  and/or
// modify it under the terms of the GNU General Public  License
// as published by the Free Software Foundation, either version
// 3 of the License, or (at your option) any later version.
//
// Nutwin is distributed in the hope that it  will  be  useful,
// but WITHOUT ANY WARRANTY; without even the implied  warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
// the GNU General Public License for more details.
//
// You should have received a copy of the  GNU  General  Public
// License along with Foobar.
// If not, see <http://www.gnu.org/licenses/>.




unit CCSDBListaLinks;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CCSListaLinks,db,dbtables;

type
  TCCSDBListaLinks = class(TCCSListaLinks)
  private
    FDatabase: TDataBase;
    { Private declarations }
  protected
    FDM : TDataModule;
    { Protected declarations }
    procedure SetDatabase(const Value: TDataBase);virtual;
    procedure SetDM(const Value: TDataModule);virtual;
    procedure DefineDM;virtual;
    procedure OpenTables; virtual;
    procedure CloseTables; Virtual;
    property  DM : TDataModule read FDM write SetDM;
  public
    { Public declarations }
        procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  published
    { Published declarations }
    property Database : TDataBase read FDatabase write SetDatabase;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('BASICOS', [TCCSDBListaLinks]);
end;

{ TCCSDBListaLinks }


procedure TCCSDBListaLinks.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FDatabase then
        FDatabase := nil
     else if AComponent = FDM then
        FDM := nil;

end;


procedure TCCSDBListaLinks.SetDatabase(const Value: TDataBase);
begin
  FDatabase := Value;
  DefineDM;
end;

procedure TCCSDBListaLinks.SetDM(const Value: TDataModule);
begin
  FDM := Value;
  DefineDM;
end;

procedure TCCSDBListaLinks.CloseTables;
var
I : integer;
begin
  if (Assigned (FDatabase)) and (Assigned(FDM)) then
  for I:=0 to FDM.ComponentCount -1 do
    if (FDM.Components[I] is TDBDataSet) then
       TDBDataSet(FDM.Components[I]).Close;
end;

procedure TCCSDBListaLinks.DefineDM;
var
I : integer;
begin
  CloseTables;
  if (Assigned (FDatabase)) and (Assigned(FDM)) then
  for I:=0 to FDM.ComponentCount -1 do
    if (FDM.Components[I] is TDBDataSet) then
       TDBDataSet(FDM.Components[I]).DatabaseName := FDatabase.DatabaseName;
  OpenTables;
end;

procedure TCCSDBListaLinks.OpenTables;
var
I : integer;
begin
  if (Assigned (FDatabase)) and (Assigned(FDM)) then
  for I:=0 to FDM.ComponentCount -1 do
    if (FDM.Components[I] is TDBDataSet) then
       TDBDataSet(FDM.Components[I]).Open;
end;

end.

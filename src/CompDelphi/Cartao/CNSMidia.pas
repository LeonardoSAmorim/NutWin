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




unit CNSMidia;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, filectrl, CCSListaLinks;

type
  TCNSMidia = class(TCCSListaLinks)
  private
    { Private declarations }
    FMidia : string;
    FDrive : string;
    FDirectory : string;
    FUnidade : byte;
    FDriveComboBox : TDriveComboBox;
    FDriveSize : double;
    FDriveFree : double;
    FClick : TNotifyEvent;
    function GetUnidade : byte;
    procedure SetDriveComboBox(Value : TDriveComboBox);
    procedure DirectoryChange(Sender:Tobject);
    procedure DriveComboBoxClick(Sender: TObject);

  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor create(AOwner : TComponent); override;
    destructor destroy; override;
    property Unidade : byte read GetUnidade;
    property Midia : string read FMidia write FMidia;

  published
    { Published declarations }
    property Directory : string read FDirectory;
    property DriveComboBox : TDriveComboBox read FDriveComboBox write SetDriveComboBox;
    property DriveFree : double read FDriveFree;
    property DriveSize : double read FDriveSize;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Cartao', [TCNSMidia]);
end;
constructor TCNSMidia.create(AOwner : TComponent);
begin
   inherited create(AOWner);
end;

destructor TCNSMidia.Destroy;
begin
  inherited Destroy;
  if assigned(FDriveComboBox) then
     FDriveComboBox.onChange := nil;
end;


function TCNSMidia.GetUnidade : byte;
var
   xDrive : string;
begin
   xDrive := 'a';
   xDrive[1] := FDriveComboBox.Drive;
   Result := ORD(UpperCase(xDrive)[1]) - 64;
end;

procedure TCNSMidia.SetDriveComboBox(Value : TDriveComboBox);
begin
   FDriveComboBox := Value;
   if assigned(Value) then
   begin
      value.freenotification(self);
//    FClick := Value.onClick;
      value.onchange := DrivecomboBoxClick;
      if assigned(value.DirList) then
         value.Dirlist.OnChange := DirectoryChange;
//      else
//         showmessage('É necessário o componente DirectoryLIST');
   end;
end;

procedure TCNSMidia.DriveComboBoxClick(Sender : TObject);
begin
   FDriveFree := (DiskFree(Unidade))/1024 ;
   FDriveSize := (DiskSize(Unidade)*0.95)/1024;
   NotifyLinks(self, lRefresh);
end;

procedure TCNSMidia.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FDriveComboBox <> nil) and (AComponent = DriveComboBox) then
       DriveComboBox := nil;
  end;
end;

procedure TCNSMidia.DirectoryChange(Sender:Tobject);
begin
   FDirectory := FDriveCombobox.DirList.Directory;
   NotifyLinks(self, lRefresh);
end;

end.

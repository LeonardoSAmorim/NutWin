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




unit CNSSpeedControl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, CNSCONNECT, CNSSubItem, DsgnIntf, CNSSubItemReg;

type
  TCNSSpeedControl = class(TSpeedButton)
  private
    { Private declarations }
    FMenuControl : TCustomMenuControl;
    FItemRelacionado : TCNSSubItem;
    procedure SetMenuControl(const Value: TCustomMenuControl);
    procedure SetItemRelacionado(const Value: TCNSSubItem);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property MenuControl :  TCustomMenuControl read FMenuControl write SetMenuControl;
    property ItemRelacionado : TCNSSubItem read FItemRelacionado write SetItemRelacionado;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Cartao', [TCNSSpeedControl]);
  RegisterPropertyEditor(TypeInfo(TCNSSubItem), nil, 'ItemRelacionado', TCNSSubItemProperty);
end;

{ TCNSSpeedControl }


constructor TCNSSpeedControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItemRelacionado := TCNSSubItem.Create;
end;

procedure TCNSSpeedControl.SetMenuControl(const Value: TCustomMenuControl);
begin
  FMenuControl := Value;
  if Value <> nil then
  begin
     FItemRelacionado.MenuControl := Value;
     Value.FreeNotification(self);
  end;
end;
procedure TCNSSpeedControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FMenuControl <> nil) and (AComponent = MenuControl) then
       MenuControl := nil;
  end;
end;

procedure TCNSSpeedControl.SetItemRelacionado(const Value: TCNSSubItem);
begin
  FItemRelacionado := Value;
end;

end.

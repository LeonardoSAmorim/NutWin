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




unit ItemsDefault;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db,stdctrls;

type
  TItemsDefault = class(TPersistent)
  private
    FListaOpcoes: TStrings;
    FOpcoesMenu : string;
    FAOwnerk : Tcomponent;
    procedure SetOpcoesMenu(const Value: string);
    procedure SetAOWner(Value : TComponent);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create;
  published
    { Published declarations }
    property OpcoesMenu : string read FOpcoesMenu write SetOpcoesMenu;
    property ListaOpcoes : Tstrings read FListaOpcoes write FListaOpcoes;
    property AOWnerk : TComponent read FAownerk write SetAOwner;
  end;


implementation

uses CNSConnect;
{ TItemsDefault }

constructor TItemsDefault.Create;
begin
  inherited Create;
end;

procedure TItemsDefault.SetOpcoesMenu(const Value: string);
begin
  FOpcoesmenu := Value;
end;

procedure TItemsDefault.SetAoWner( Value: TComponent);
begin
//  FListaOpcoes := TStringList.Create;
  FAOwnerk := Value;
  FOpcoesMenu := TCNSMenuControl(FAOwnerk).Name;
  showmessage(TCNSMenuControl(FAOwnerk).Name);
end;

end.

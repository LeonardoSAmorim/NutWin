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




unit CNSSubItem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db,stdctrls, CNSCONNECT;

type
  TCNSSubItem = class(TPersistent)
  private
    FMenuControl : TCustomMenuControl;
    FItemRelacionado: string;
    procedure SetMenuControl(const Value: TCustomMenuControl);
    procedure SetItemRelacionado(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property MenuControl :  TCustomMenuControl read FMenuControl write SetMenuControl;
    property ItemRelacionado : string read FItemRelacionado write SetItemRelacionado;
  end;


implementation
{ TCNSSubItem }

procedure TCNSSubItem.SetItemRelacionado(const Value: string);
begin
  FItemRelacionado := Value;
end;
procedure TCNSSubItem.SetMenuControl(const Value: TCustomMenuControl);
begin
  FMenuControl := Value;
end;


end.

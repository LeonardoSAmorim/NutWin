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




unit Ednovo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TEdnovo = class(TEdit)
  procedure KeyDown(var Key: Word; Shift:TShiftState); override;
  procedure KeyPress(var Key: Char); override;

  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Cartao', [TEdnovo]);
end;

procedure TEdNovo.KeyDown(var Key: Word; Shift:TShiftState);
var c1:TWinControl;
Begin
     inherited KeyDown(Key,Shift);
     c1:=Parent; While c1.Parent<>nil Do c1:=c1.Parent;
     if key=vk_down then sendmessage(c1.handle,wm_nextdlgctl, 0, 0)
     Else if key=vk_Up then sendmessage(c1.handle,wm_nextdlgctl, 1, 0);
end;

procedure TEdNovo.KeyPress(var Key: Char);
var c1:TWinControl;
begin
     inherited KeyPress(Key);
     If key = #13 Then begin
        c1:=Parent; While c1.Parent<>nil Do c1:=c1.Parent;
        sendmessage(c1.handle,wm_nextdlgctl, 0, 0);
        key:=#0
        end
end;

end.

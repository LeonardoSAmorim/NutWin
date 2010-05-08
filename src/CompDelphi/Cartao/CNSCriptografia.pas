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




unit CNSCriptografia;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ccslistalinks;

type
  TCNSCriptografia = class(TCCSListaLinks)
  private
    { Private declarations }
    FSenha : string;
    FCripto : string;
    procedure SetSenha(Value : string);
    procedure SetCripto(Value : string);
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Senha : string read FSenha write SetSenha;
    property Cripto : string read FCripto write SetCripto;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Cartao', [TCNSCriptografia]);
end;

procedure TCNSCriptografia.SetSenha(Value : string);

  function Cript(S1:string):string;
  var S2:string;
      I,K:integer;
  const
      C='O Ministério da Saúde adverte: Fumar faz mal à saúde.';
  begin
    S2:=S1;
    for I:=1 to length(S1) do
    begin
      if I>length(C)
        then K:=I-length(C)
        else K:=I;
      S2[I]:=char((254+I+100-(ord(S1[I])+ord(C[K]))) mod 254);
    end;
    Result:=S2;
  end;

begin
   FSenha := Value;
   FCripto := Cript(Value);
   NotifyLinks(self, lRefreshViewer);
end;

procedure TCNSCriptografia.SetCripto(Value : string);
begin
   FCripto := Value;
   NotifyLinks(self, lRefreshViewer);
end;

end.

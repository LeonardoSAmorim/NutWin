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




unit CNSLib;
interface
uses SysUtils;
type
   ECNSExcecoes = class(Exception)
      public CodErro : Integer;
      end;
   EFuncionario = class(ECNSExcecoes);
   ELog         = class(ECNSExcecoes);
   ELote         = class(ECNSExcecoes);
   ECartaoSUS   = class(ECNSExcecoes);
   EUsuario     = class(ECNSExcecoes);
   EMunicipio   = class(ECNSExcecoes);
   EUF          = class(ECNSExcecoes);

   function brancos (m: integer):string;
   function zeros   (n: integer):string;

implementation

function brancos(m:integer):string;
var
   i:integer;
begin
   result := '';
for  i:=1  to m  do
begin
   result := result + #32;
end;
end;

function zeros(n:integer):string;
var
   i:integer;
begin
   result := '';
for  i:=1  to n  do
begin
   result := result + #48; 
end;
end;

end.

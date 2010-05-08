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




unit CalcLib;

interface

Function Space(pQtdSpc:Integer):String;
function PoeEspacoEsquerda(pString:String; pTam:integer):String;
function PoeEspacoDireita(pString:String; pTam:integer):String;

implementation

Function Space(pQtdSpc:Integer):String;
Var
  I:Integer;
  ms_String:String;
begin
  ms_String:='';
  for i:=1 to pQtdSpc do
    ms_String:=Ms_String+' ';

  Result:=ms_String;
end;

function PoeEspacoEsquerda(pString:String; pTam:integer):String;
begin
  Result:=Space(pTam - length(pString))+pString;
end;

function PoeEspacoDireita(pString:String; pTam:integer):String;
begin
  Result:=pString+Space(pTam - length(pString));
end;

end.
 
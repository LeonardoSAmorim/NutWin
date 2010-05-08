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




unit Index32;
interface
uses SysUtils;

type
  TipoEntry = record
    Texto  : PString;
    Indice : integer;
  end;
  TipoEntryArray = array[0..100000] of TipoEntry;
  TipoIndex = record
    Numero,Maximo :  integer;
    Entry         :  ^TipoEntryArray;
  end;
procedure CriaIndex(var Ind:TipoIndex;Tamanho:integer);
function InsereIndex(var Ind:TipoIndex;S:string;EsteIndice:integer):boolean;
function IndexFind(var L:TipoIndex;Chave:string;var Posicao:integer;var EsteIndice:integer):boolean;
Procedure RemoveIndex(var Ind:TipoIndex);

implementation

procedure CriaIndex(var Ind:TipoIndex;Tamanho:integer);
var I : integer;
begin
  with Ind do
    begin
      Maximo := Tamanho;
      getmem(Entry,(Maximo+1)*sizeof(TipoEntry));
      for I := 0 to Maximo do Entry^[I].Texto := nil;
      Numero := 0;
    end;
end; {CriaIndex}

function IndexFind(var L:TipoIndex;Chave:string;var Posicao:integer;var EsteIndice:integer):boolean;
var Top,Bottom,Mid : integer;
begin
  Top := L.Numero;
  Bottom := 1;
  while Top > Bottom do
    begin
      Mid := (Top + Bottom) div 2;
      if Chave > L.Entry^[Mid].Texto^
        then Bottom := Mid + 1
        else Top := Mid;
    end;
  if Top = 0
    then IndexFind := false
    else IndexFind := (Chave = L.Entry^[Top].Texto^);
  Posicao := Top;
  EsteIndice := L.Entry^[Top].Indice;
end;{IndexFind}

function InsereIndex(var Ind:TipoIndex;S:string;EsteIndice:integer):boolean;
var I,J      : integer;
    Location : integer;
begin
  with Ind do
    begin
      if (Numero = 0) or (S > Entry^[Numero].Texto^) then
        begin
          inc(Numero);
          Entry^[Numero].Texto  := NewStr(S);
          Entry^[Numero].Indice := EsteIndice;
          InsereIndex := true;
        end
      else
        if not IndexFind(Ind,S,Location,J) then
          begin
            Inc(Numero);
            for I := Numero-1 downto Location do
              Entry^[I+1] := Entry^[I];
            Entry^[Location].Texto  := NewStr(S);
            Entry^[Location].Indice := EsteIndice;
            InsereIndex := true;
          end
        else InsereIndex := false;
    end;
end;{InsereIndex}

Procedure RemoveIndex(var Ind:TipoIndex);
var I : integer;
begin
  with Ind do
    begin
      for I := 1 to Numero do
        if Entry^[I].Texto <> nil then DisposeStr(Entry^[I].Texto);
      freemem(Entry,Maximo*sizeof(TipoEntry));
      Maximo := 0;
      Numero := 0;
    end;
end; {RemoveIndex}
begin
end.

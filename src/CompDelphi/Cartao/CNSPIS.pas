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




unit CNSPIS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ccslistalinks, cnsdbsus;

type
  TCNSPIS = class(TCCSListaLinks)
  private
    fPisValido: boolean;
    fNumeroPis: string;
    function getPisValido: boolean;
  protected
    { Protected declarations }
  public
  published
    { Published declarations }
    property PisValido:boolean read  getPisValido;
    property NumeroPis:string  read FNumeroPis  write fNumeroPis;

  end;

procedure Register;

implementation

{ Função que calcula a soma dos digitos do
  número multiplicados pelo fator }

function calcdigito(x:string):integer;
  var i, r, soma, digito:integer;
      fator: string;
  begin
    fator:= '3298765432';
    soma:= 0;
    for i:= length(x) downto 1 do
      soma:= soma +  strtoint(x[i])* strtoint(fator[i]);
  r:= soma mod 11;
  result:= r;
end;

 { Função que verifica se o NumeroPis é numérico
   e se o dígito informado é igual ao calculado}

function tCNSpis.getPisValido: boolean;
  var digito, r:integer;
      wdigito, wNumeroPis: string;
      numero: real;
  begin
    if length(fNumeroPis) > 11 then
      begin
        result:= false;
        exit;
      end;
    try
       numero:= strtofloat(fNumeroPis);
    except
       on EconvertError do
         begin
           result:= false;
           exit;
         end;
    end;
  wdigito:= copy(fNumeroPis, length(fNumeroPis),1);
  wNumeroPis:= copy(fNumeroPis, 1 , (length (fNumeroPis) -1));
  r:= calcdigito(wNumeroPis);
  case r of
   0: digito:= 0;
   1: begin
      result:= false;
      exit;
      end;
   else digito:= 11 - r;
  end;
  if  wdigito = inttostr(digito)
  then result:= true
  else result:= false;
end;
procedure Register;
begin
  RegisterComponents('CARTAO', [TCNSPIS]);
end;

end.

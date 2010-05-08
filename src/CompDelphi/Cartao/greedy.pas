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




unit greedy;
{--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--
     Trabalho de Estatistica                                    24-11-98
     Prof. Mercedes

     Participantes                         Matricula
     ------------------------------------- ---------
 --*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--}

interface
uses classes;
type
   TGreedy = class(TObject)
   {atributos do objeto greedy}
    private
//    FNumerador     : double;
//    FDenominador   : double;
      FDecomposta    : boolean;
      FCount         : integer;
      FOnDecompondo  : TNotifyEvent;
    public
      ArrayDenominadores : array [1..1000] of real;
      Numerador     : real;
      Denominador   : real;
      procedure Decompor;
//    property Numerador : double read FNumerador write FNumerador;
//    property Denominador : double read FDenominador write FDenominador;
      property Count : integer read FCount write FCount;
      property Decomposta : boolean read FDecomposta write FDecomposta;
   published
      property OnDecompondo : TNotifyEvent read FOnDecompondo write FOnDecompondo;

   end;

implementation

{Obejeto TPilha}
procedure TGreedy.Decompor;
var
   i : real;
   DenominadorGerado : string;
   SomaFracao, Fracao : real;
   idxArray : integer;
begin
   {
      Metodo para encontrar a decomposicao egipicia de uma fracao, o metodo
   ira somar as fracoes ate chegar no valor da fracao atingir o limite de fracoes
   ou do denominador, no caso dos valores inteiros o limite sera controlado pelo
   tamanho do tipo da varialvel;
   }
   SomaFracao := 0; i := 2; idxArray := 1;
   Fracao := Numerador / Denominador;
   while (SomaFracao < Fracao) and (i <= 2147483647) and (idxArray < 999) do
   begin
      if (SomaFracao + (1 / i) <= Fracao) then
      begin
        SomaFracao := SomaFracao + (1 / i);
        {
         Monta um array com os resultados para quem for utilizar o objeto
         apenas pegar a lista que foi criada e desmontra-la como quiser
        }
        ArrayDenominadores[idxArray] := i;
        inc(idxArray);
     end;
      {
         F a b i o    esta parte a baixo e so para exibir o progresso do
      processo, como voce vai usar o modo grafico e so mudar os comandos
      e fazer como vc achar melhor
      }
      i := i + 1;
      if assigned(FOnDecompondo) then FOnDecompondo(self);
  end;
   {
   Indica o numero de elementos encontrados que estarao no intervalo [1..1000]
   }
   Count := idxArray - 1;
   {
   Indica que a fracao foi decomposta completamente
   }
   Decomposta := (SomaFracao = (Numerador / Denominador));
end;

end.
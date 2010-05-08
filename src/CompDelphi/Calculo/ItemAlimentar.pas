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




{*******************************************************}
{                                                       }
{       Componente ItemAlimentar                        }
{                                                       }
{       Copyright © 2000 by DIS-EPM/UNIFESP             }
{                                                       }
{*******************************************************}

unit ItemAlimentar;

interface

uses Classes, Forms;

type

  TItemAlimentar = class(TComponent)
  private
     FPesoEmGramas: Double;
     FFrequenciaDia: Integer;
     FAlimento: String;
     FIDAlimento: String;
     FMedidaCaseira: String;
     FRefeicao: String;
     FIDMedida: String;
     FQuantidade: String;
     FIDRefeicao: String;
     procedure FoiModificado;
     procedure SetAlimento(const Value: String);
     procedure SetFrequenciaDia(const Value: Integer);
     procedure SetIDAlimento(const Value: String);
     procedure SetIDMedida(const Value: String);
     procedure SetIDRefeicao(const Value: String);
     procedure SetMedidaCaseira(const Value: String);
     procedure SetPesoEmGramas(const Value: Double);
     procedure SetQuantidade(const Value: String);
     procedure SetRefeicao(const Value: String);
  protected
  public
     procedure Assign(Sou : TItemAlimentar);reintroduce;overload;
     procedure AssignTo(Dest : TPersistent); override;
  published
     property IDAlimento : String read FIDAlimento write SetIDAlimento;
     property IDRefeicao : String read FIDRefeicao write SetIDRefeicao;
     property IDMedida : String read FIDMedida write SetIDMedida;
     property Quantidade : String read FQuantidade write SetQuantidade;
     property PesoEmGramas : Double read FPesoEmGramas write SetPesoEmGramas;
     property FrequenciaDia : Integer read FFrequenciaDia write SetFrequenciaDia;
     property Alimento : String read FAlimento write SetAlimento;
     property MedidaCaseira : String read FMedidaCaseira write SetMedidaCaseira;
     property Refeicao : String read FRefeicao write SetRefeicao;
  end;

procedure Register;

implementation

uses Memoria;

procedure Register;
begin
   RegisterComponents('Calculadora', [TItemAlimentar]);
end;

{ TItemAlimentar }

procedure TItemAlimentar.Assign(Sou: TItemAlimentar);
begin
   if (Sou = nil) then
      exit;
   IDAlimento := Sou.FIDAlimento;
   IDRefeicao := Sou.FIDRefeicao;
   IDMedida := Sou.FIDMedida;
   Quantidade := Sou.FQuantidade;
   PesoEmGramas := Sou.FPesoEmGramas;
   FrequenciaDia := Sou.FFrequenciaDia;
   Alimento := Sou.FAlimento;
   MedidaCaseira := Sou.FMedidaCaseira;
   Refeicao := Sou.FRefeicao;
   if Name = '' then
      Name:=Sou.Name;
end;

procedure TItemAlimentar.AssignTo(Dest: TPersistent);
begin
   if Dest is TItemAlimentar then
      begin
         TItemAlimentar(Dest).IDAlimento := FIDAlimento;
         TItemAlimentar(Dest).IDRefeicao := FIDRefeicao;
         TItemAlimentar(Dest).IDMedida := FIDMedida;
         TItemAlimentar(Dest).Quantidade := FQuantidade;
         TItemAlimentar(Dest).PesoEmGramas := FPesoEmGramas;
         TItemAlimentar(Dest).FrequenciaDia := FFrequenciaDia;
         TItemAlimentar(Dest).Alimento := FAlimento;
         TItemAlimentar(Dest).MedidaCaseira := FMedidaCaseira;
         TItemAlimentar(Dest).Refeicao := FRefeicao;
         if TItemAlimentar(Dest).Name = '' then
            TItemAlimentar(Dest).Name := Name;
      end
   else
      inherited AssignTo(Dest);
end;

procedure TItemAlimentar.FoiModificado;
var
   OwnerNow : TComponent;
begin
   // Pra achar a memoria onde a medida está (se existir memoria)
   OwnerNow := Owner;
   while not ( OwnerNow is TMemoria ) and
         not ( OwnerNow is TApplication ) do
         OwnerNow := OwnerNow.Owner;
   if OwnerNow is TMemoria then
      TMemoria( OwnerNow ).AddModified;
end;

procedure TItemAlimentar.SetAlimento(const Value: String);
var
   FModifield : Boolean;
begin
   FModifield := ( FAlimento <> Value );
   FAlimento := Value;
   // Só digo que modificou depois do assign acima
   // Esta variavel deveria ser public, mas fica pra outra versao
   if FModifield then
      FoiModificado;
end;

procedure TItemAlimentar.SetFrequenciaDia(const Value: Integer);
var
   FModifield : Boolean;
begin
   FModifield := ( FFrequenciaDia <> Value );
   FFrequenciaDia := Value;
   // Só digo que modificou depois do assign acima
   // Esta variavel deveria ser public, mas fica pra outra versao
   if FModifield then
      FoiModificado;
end;

procedure TItemAlimentar.SetIDAlimento(const Value: String);
var
   FModifield : Boolean;
begin
   FModifield := ( FIDAlimento <> Value );
   FIDAlimento := Value;
   // Só digo que modificou depois do assign acima
   // Esta variavel deveria ser public, mas fica pra outra versao
   if FModifield then
      FoiModificado;
end;

procedure TItemAlimentar.SetIDMedida(const Value: String);
var
   FModifield : Boolean;
begin
   FModifield := ( FIDMedida <> Value );
   FIDMedida := Value;
   // Só digo que modificou depois do assign acima
   // Esta variavel deveria ser public, mas fica pra outra versao
   if FModifield then
      FoiModificado;
end;

procedure TItemAlimentar.SetIDRefeicao(const Value: String);
var
   FModifield : Boolean;
begin
   FModifield := ( FIDRefeicao <> Value );
   FIDRefeicao := Value;
   // Só digo que modificou depois do assign acima
   // Esta variavel deveria ser public, mas fica pra outra versao
   if FModifield then
      FoiModificado;
end;

procedure TItemAlimentar.SetMedidaCaseira(const Value: String);
var
   FModifield : Boolean;
begin
   FModifield := ( FMedidaCaseira <> Value );
   FMedidaCaseira := Value;
   // Só digo que modificou depois do assign acima
   // Esta variavel deveria ser public, mas fica pra outra versao
   if FModifield then
      FoiModificado;
end;

procedure TItemAlimentar.SetPesoEmGramas(const Value: Double);
var
   FModifield : Boolean;
begin
   FModifield := ( FPesoEmGramas <> Value );
   FPesoEmGramas := Value;
   // Só digo que modificou depois do assign acima
   // Esta variavel deveria ser public, mas fica pra outra versao
   if FModifield then
      FoiModificado;
end;

procedure TItemAlimentar.SetQuantidade(const Value: String);
var
   FModifield : Boolean;
begin
   FModifield := ( FQuantidade <> Value );
   FQuantidade := Value;
   // Só digo que modificou depois do assign acima
   // Esta variavel deveria ser public, mas fica pra outra versao
   if FModifield then
      FoiModificado;
end;

procedure TItemAlimentar.SetRefeicao(const Value: String);
var
   FModifield : Boolean;
begin
   FModifield := ( FRefeicao <> Value );
   FRefeicao := Value;
   // Só digo que modificou depois do assign acima
   // Esta variavel deveria ser public, mas fica pra outra versao
   if FModifield then
      FoiModificado;
end;

end.

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




{ ****************************************************************** }
{                                                                    }
{   Delphi component TProcedimento                                   }
{                                                                    }
{   Procedimento de cálculo                                          }
{                                                                    }
{   Copyright © 1997 by DIS-EPM/UNIFESP                              }
{                                                                    }
{ ****************************************************************** }

unit Procedimento;

interface

uses Classes, SysUtils, Forms;

type

  TProcState = ( psNone, psChecked, psDisabled, psInvisible, psHidden );

  TProcedimento = class(TComponent)
  private
     FDescricao: String;
     FEstado: TProcState;
    FEscopo: String;
     function GetNomeMedidaValidacao : String;
     procedure SetDescricao(const Value: String);
     procedure SetEstado(const Value: TProcState);
    function GetDescricao: String;
    procedure SetEscopo(const Value: String);
  public
     constructor Create(AOwner : TComponent); override;
     destructor Destroy; override;
     procedure AssignTo(Dest: TPersistent); override;
  published
     property Descricao : String read GetDescricao write SetDescricao;
     property Estado : TProcState read FEstado write SetEstado;
     property NomeMedidaValidacao : String read GetNomeMedidaValidacao;
     property Escopo : String read FEscopo write SetEscopo;
  end;

procedure Register;

implementation

uses Memoria;

procedure Register;
begin
   RegisterComponents('Calculadora', [TProcedimento]);
end;

{ TProcedimento }

procedure TProcedimento.AssignTo(Dest: TPersistent);
begin
   if Dest is TProcedimento then
      with Dest as TProcedimento do
      begin
        Descricao := self.FDescricao;
        Estado := self.FEstado;
        Name := self.Name;
        Escopo := self.FEscopo;
      end;
end;

constructor TProcedimento.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
end;

destructor TProcedimento.Destroy;
begin
   inherited Destroy;
end;

function TProcedimento.GetDescricao: String;
begin
   // Isto é para que a descrição não apareça com (pr) para o usuário
   Result := StringReplace(FDescricao, '(pr)', '', [rfReplaceAll, rfIgnoreCase]);
end;

function TProcedimento.GetNomeMedidaValidacao: String;
begin
   Result := 'mdvl' + Name;
end;

procedure TProcedimento.SetDescricao(const Value: String);
begin
   FDescricao := Value;
end;

procedure TProcedimento.SetEscopo(const Value: String);
begin
  FEscopo := Value;
end;

procedure TProcedimento.SetEstado(const Value: TProcState);
var
   FModifield : Boolean;
   OwnerNow : TComponent;
begin
   FModifield := ( FEstado <> Value );
   FEstado := Value;
   // Só digo que modificou depois do assign acima
   // Esta variavel deveria ser public, mas fica pra outra versao
   if FModifield then
      begin
         // Pra achar a memoria onde a medida está (se existir memoria)
         OwnerNow := Owner;
         while not ( OwnerNow is TMemoria ) and
               not ( OwnerNow is TApplication ) do
               OwnerNow := OwnerNow.Owner;
         if OwnerNow is TMemoria then
            TMemoria( OwnerNow ).AddModified;
      end;
end;

end.

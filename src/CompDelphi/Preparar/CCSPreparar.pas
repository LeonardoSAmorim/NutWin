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




unit CCSPreparar;

interface
{ ****************************************************************** }
{                                                                    }
{   CCSPreparar.pas                                                    }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Maio/1998                                                     }
{   09/Setembro/1999 segmento da unit CNS                            }
{                                                                    }
{ ****************************************************************** }

uses Classes, SysUtils, CCSListaLInks;

type

  TTiposPermitidos = set of char;

  TCustomPreparar = Class(TCCSListaLinks)
  private
     FNome : string;
     FNomeTratado : string;
     FOnTratado : TNotifyEvent;
     procedure SetNome(Value : string);
  protected
    { Protected declarations }
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DescendentEvent(Sender : TObject; lState : TLinkState); override;
    procedure TratarNome; virtual;
    procedure TirarSinasDiacriticos; virtual;
    procedure TirarEspacosDuplicados; virtual;
    procedure TirarCaracteresInvalidos; virtual;
    property Nome : string read FNome write SetNome;
    property NomeTratado : string read FNomeTratado write FNomeTratado;
    property OnTratado : TNotifyEvent read FOnTratado write FOnTratado;
  published
    { Published declarations }
  end;

  TCCSPreparar = Class(TCustomPreparar)
  private
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property OnTratado : TNotifyEvent read FOnTratado write FOnTratado;
  end;


procedure register;

implementation

const
  //Tipos permitidos no nome
  CaracteresPermitidos : TTiposPermitidos =
  [#39, ' ', '0'..'9',  'a'..'z', 'A'..'Z', 'à'..'ã', 'À'..'Ã', 'é', 'ê', 'É', 'Ê', 'í', 'Í', 'ó', 'ô', 'õ', 'Ó', 'Ô', 'Õ', 'ù'..'ü', 'Ù'..'Ü', 'ç', 'Ç'];


procedure Register;
begin
  RegisterComponents('CCS-SIS', [TCCSPreparar]);
end;
//////////////////////////////////TTratar Nome///////////////////////
constructor TCustomPreparar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TCustomPreparar.Loaded;
begin
  inherited Loaded;
end;

destructor TCustomPreparar.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomPreparar.SetNome(Value : string);
begin
   FNome := Value;
   FNomeTratado := Value;
end;
procedure TCustomPreparar.TratarNome;
begin
   FNomeTratado := UpperCase(Trim(FNome));
   TirarCaracteresInvalidos;
   TirarEspacosDuplicados;
   if assigned(FOnTratado) then FOnTratado(Self);
end;

procedure TCustomPreparar.TirarSinasDiacriticos;
begin
end;
procedure TCustomPreparar.TirarEspacosDuplicados;
{
         Eliminar Bracos a mais no meio do Nome
}
var
   NomeAux : string;
   j    : integer;
begin
   j := 1;
   NomeAux := '';
   while (j <= Length(FNomeTratado)) do
   begin
      while (FNomeTratado[j] = #32) and  (FNomeTratado[j + 1] = #32) and (j < Length(FNomeTratado))  do Inc(j);
      NomeAux := NomeAux + FNomeTratado[j];
      inc(j)
   end;
   FNomeTratado := NomeAux;
end;

procedure TCustomPreparar.TirarCaracteresInvalidos;
{
          Este metodo ira retirar os caracteres nao numereicos e nao alfanumericos
permitido somente os caracteres da lista de caracteres permitidos
}
var
   NomeAux : string;
   j    : integer;
begin
   NomeAux := '';
   for j := 1 to Length(FNomeTratado) do
      if (FNomeTratado[j] in  CaracteresPermitidos) then
          NomeAux := NomeAux + FNomeTratado[j];
   FNomeTratado := NomeAux;
end;


procedure TCustomPreparar.DescendentEvent(Sender: TObject;
  lState: TLinkState);
begin
//(Pablo) nao sei o que fazer aqui...
end;

end.

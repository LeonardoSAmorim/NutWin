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




unit CCSPilhas;
{ ****************************************************************** }
{                                                                    }
{   CCSPilhas.pas                                                    }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Maio/1998                                                     }
{   09/Setembro/1999 segmento da unit CNS                            }
{                                                                    }
{ ****************************************************************** }

interface

uses classes, dialogs,SysUtils;

type
  TElemento = string;
  TDirecao = (Direita, Esquerda);

  TCusTomPilha = class(TComponent)
  private
    { Private declarations }
    FPosicao : integer;
  protected
    { Protected declarations }
    function IsFull : boolean; virtual; abstract;
    function IsEmpty : boolean; virtual; abstract;
    procedure Init; virtual; abstract;
    function Pop : TElemento; virtual; abstract;
    function View(PosicaoPilha : integer) : TElemento; virtual; abstract;
    procedure Push(Elemento : TElemento); virtual; abstract;
    function IndexOf(Elemento : TElemento): integer; virtual; abstract;
    property Posicao : integer read FPosicao write FPosicao;
  public
    { Public declarations }
  published
    { Published declarations }
  end;


  TCusTomPilhaStatica = class(TCustomPilha)
  private
    { Private declarations }
    FArrayElementos : array [1..100] of TElemento;
    FPosicao : integer;
  protected
    { Protected declarations }
    procedure Loaded; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy ; override;
    function IsFull : boolean; override;
    function IsEmpty : boolean; override;
    procedure Init; override;
    function Pop : TElemento; override;
    function View(PosicaoPilha : integer) : TElemento; override;
    procedure Push(Elemento : TElemento); override;
    function IndexOf(Elemento : TElemento) : integer; override;
    property Posicao : integer read FPosicao write FPosicao;

  published
    { Published declarations }
  end;

  TCCSPilhaStatica = class(TCustomPilhaStatica)
  private
    { Private declarations }
  protected
    { Protected declarations }

  public
    { Public declarations }
  published
    { Published declarations }
  end;


  TElementoVariante = Variant;
  PPratoDinamico = ^TPratoDinamico;
  TPratoDinamico = record
                 PriorPrato : PPratoDinamico;
                 Elemento   : TElementoVariante;
                 NextPrato  : PPratoDinamico;
  end;


  TCusTomPilhaDinamica = class(TCustomPilha)
  private
    { Private declarations }
    FirstPrato : pointer;
    LastPrato : pointer;
    FPrato : PPratoDinamico;
    FPosicao : integer;
  protected
    { Protected declarations }
    procedure Loaded; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsFull : boolean; override;
    function IsEmpty : boolean; override;
    procedure Init; override;
    function Pop : TElementoVariante; reintroduce;
    function View(PosicaoPilha : integer) : TElementoVariante; reintroduce;
    procedure Push(Elemento : TElementoVariante); reintroduce;
    property Posicao : integer read FPosicao write FPosicao;
  published
    { Published declarations }
end;

  TCCSPilhaDinamica = class(TCusTomPilhaDinamica)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
end;



  TCCSInteiro = class(TComponent)
  private
    { Private declarations }
    FValue : integer;
    function GetPar : boolean;
  protected
    { Protected declarations }
    procedure Loaded; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsPar(Value : integer) : boolean;
    property Par : boolean read GetPar;
{    property IsImpar : boolean;
    property IsPositivo : boolean;
    property IsNegativo : boolean;
}
  published
     property Valor : integer read FValue write FValue;
    { Published declarations }
  end;

procedure SepararNomes(NomePilha : TCusTomPilhaStatica; Value : string; Separador : char; Direcao : TDirecao);
function JuntarNomes(NomePilha : TCusTomPilhaStatica; Separador : char; Direcao : TDirecao) : string;
procedure register;

implementation

const

  MAXPlatos = 100;


procedure Register;
begin
  RegisterComponents('CCS-SIS', [TCCSPilhaStatica]);
  RegisterComponents('CCS-SIS', [TCCSPilhaDinamica]);
  RegisterComponents('CCS-SIS', [TCCSInteiro]);
end;

procedure SepararNomes(NomePilha : TCusTomPilhaStatica; Value : string; Separador : char; Direcao : TDirecao);
{
          Metodo para Separar Nomes e coloca-lo em um pilha
          parametros Descricao
          ---------- ------------------------------------------------------
          NomePilha  Pilha que ira contar o Nome fragmentado
          Value      Nome a ser falgamento
          Separador  Caracter de separacao
          Direcao    Sentido da fragmentacao 1 - esq p/ dir  2 - dir p/ esq
}
var
  k , j, i: integer;
begin
  k :=  Length(Value);
  j := 1;
  i := j;
  NomePilha.Init;
  // Separa  palavras
  if Direcao = Esquerda then //indica que a direcao e da esquerda para direita
  begin
      while (k >= j) do
      begin
         while (k > j) and (Value[j] <> Separador) do
         inc(j);
         if k = j then
            inc(j);
         NomePilha.Push(copy(Value,i ,j - i));
        i := J + 1;
        inc(j);
      end;
  end else
  if Direcao = Direita then // indica que a direcao a da direita para esquerda
  begin
      i := k;
      J := K;
      while (j >= 1) do
      begin
         while (j > 1) and (Value[j] <> separador) do
         dec(j);
         if j = 1 then
            dec(j);
         NomePilha.Push(copy(Value,j + 1 ,i - j));
        i := J - 1;
        dec(j);
      end;
  end else
      ShowMessage('Direcao Invalida.');

end;

function JuntarNomes(NomePilha : TCusTomPilhaStatica; Separador : char; Direcao : TDirecao) : string;
{
         metodo para montar um nome atravez de uma pilha de palavras
          parametros Descricao
          ---------- ------------------------------------------------------
          NomePilha  Pilha que  contem o Nome fragmentado
          Result     Nome Montado
          Separador  Caracter de separacao
          Direcao    Sentido da fragmentacao 1 - esq p/ dir  2 - dir p/ esq

}
var
   NomeAux : string;
   i       : integer;
begin
    NomeAux := ' ';
    if Direcao = Esquerda then
       for i := 1 to NomePilha.Posicao do
          NomeAux := NomeAux + NomePilha.View(i) + Separador
    else
      if Direcao = Direita then
         for i := NomePilha.Posicao downto 1 do
           NomeAux := NomeAux + NomePilha.View(i) + Separador
      else
         ShowMessage('Direcao Invalida');
   Result :=  Trim(NomeAux);
   //olhar depois e cortar so o ultimo separardor
   Result := copy(result, 1, length(result) -1);
end;

//TPilha Estatica /////////////////////////////////////


constructor TCusTomPilhaStatica.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
//  init;
end;

destructor TCusTomPilhaStatica.Destroy;
begin
  inherited Destroy;
end;

procedure TCusTomPilhaStatica.Loaded;
begin
  inherited Loaded;
  Init;
end;

procedure TCusTomPilhaStatica.Init;
begin
   FPosicao := 0;
end;


function TCusTomPilhaStatica.Pop : TElemento;
begin
   if not IsEmpty then
   begin
      Result := FArrayElementos[FPosicao];
      dec(FPosicao);
   end
   else
      ShowMessage('Pilha Vazia');
end;

function TCusTomPilhaStatica.View(PosicaoPilha : integer) : TElemento;
begin
   if (PosicaoPilha > 0) and (PosicaoPilha <= FPosicao) then
   begin
      Result := FArrayElementos[PosicaoPilha];
   end
   else
      ShowMessage('Fora da Faixa da Pilha');
end;


procedure TCusTomPilhaStatica.Push(Elemento : TElemento);
begin
   if not IsFull then
   begin
      inc(FPosicao);
      FArrayElementos[FPosicao] := Elemento;
   end
   else
      ShowMessage('Pilha Cheia');

end;

function TCusTomPilhaStatica.IsEmpty : boolean;
begin
   Result := (FPosicao = 0);
end;

function TCusTomPilhaStatica.IsFull : boolean;
begin
   Result := (FPosicao = MAXPLATOS);
end;

function TCusTomPilhaStatica.IndexOf(Elemento : TElemento) : integer;
var
   i : integer;
begin
   Result := -1;
   for i := 1 to FPosicao do
   begin
      if FArrayElementos[i] = Elemento then
      begin
         Result := i;
         break;
      end
   end;
end;


///////////////////////////////////////////TCusTomPilhaDinamica//////////////////////////////////////////////////////////////


constructor TCusTomPilhaDinamica.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FPosicao := 0;
 init;
end;

destructor TCusTomPilhaDinamica.Destroy;
begin
  inherited Destroy;
end;

procedure TCusTomPilhaDinamica.Loaded;
begin
  inherited Loaded;
  FPosicao := 0;
  Init;
end;

procedure TCusTomPilhaDinamica.Init;
{
          Inicia uma nova pilha se a pilha ja possuir informacoes entao estas informacoes
serao destruidas e a pilha reiniciada.
}
var
   PratoAux : PPratoDinamico;
begin
   if FirstPrato <> nil then
   begin
      FPrato := FirstPrato;
      while FPrato <> nil do
      begin
           PratoAux := FPrato;
           FPrato := FPrato^.NextPrato;
           dispose(PratoAux);
      end;
   end;
   FPosicao := 0;
   FirstPrato := nil;
   FPrato := nil;
end;


function TCusTomPilhaDinamica.Pop : TElementoVariante;
{
         Retira o ultimo elemento  a entrar na pilha e destroe esta posicao de memoria
}
var
   PosAux : PPratoDinamico;
begin
   if not IsEmpty then
   begin
      PosAux := FPrato;
      Result := FPrato^.Elemento;
      FPrato := FPrato^.PriorPrato;
      if FPrato <> nil then
      begin
         FPrato^.NextPrato := nil;
      end;
      dispose(PosAux);
      LastPrato := FPrato;
      dec(FPosicao);
   end else
      ShowMessage('Pilha Vazia');
end;

function TCusTomPilhaDinamica.View(PosicaoPilha : integer) : TElementoVariante;
{
         Metodo para ler um elemento dentro do deslocamento da pilha sem que
a posicao do ponteriro.
}
var
   PosAux : PPratoDinamico;
   i : integer;
begin
   try
      if (PosicaoPilha > 0) and (PosicaoPilha <= FPosicao) then
      begin
         PosAux := FirstPrato;
         for i := 1 to PosicaoPilha - 1  do
             PosAux := PosAux^.NextPrato;
         Result := PosAux^.Elemento;
      end;
   except
      ShowMessage('Fora da Faixa da Pilha');
   end;
end;


procedure TCusTomPilhaDinamica.Push(Elemento : TElementoVariante);
var
   NewPrato : PPratoDinamico;
begin
   try
      //Cria ponteiro para prato
      new(NewPrato);
      //aponta nova prato para prato anteriror
      NewPrato^.PriorPrato := FPrato;
      //Verifica se pilha vazia se nao se ponteiros
      if isEmpty then
         FirstPrato := NewPrato
      else
        //aponta prato anteiro para novo prato
        FPrato^.NextPrato := NewPrato;
      //faz novo prato ser o prato corrente
      FPrato := NewPrato;
      //indica topo da pilha
      FPrato^.NextPrato := nil;
      //coloca elemento no top da pilha
      FPrato.Elemento := Elemento;
      //atualiza ponteiro para o topo da lista
      LastPrato := FPrato;
      //atualiza quantidade de elementos
      inc(FPosicao);
   except
      //se occorer algum erro indica na execao
      ShowMessage('Pilha Cheia');
   end;
end;

function TCusTomPilhaDinamica.IsEmpty : boolean;
begin
   Result := (LastPrato = nil);
end;

function TCusTomPilhaDinamica.IsFull : boolean;
begin
   Result := (FPosicao = 30);
end;

//TCCSInteiro    /////////////////////////////////////////
constructor TCCSInteiro.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCCSInteiro.Destroy;
begin
  inherited Destroy;
end;

procedure TCCSInteiro.Loaded;
begin
  inherited Loaded;
end;

function TCCSInteiro.IsPar(Value : integer) : boolean;
begin
   Result := (value - (value div 2) = 0);
end;

function TCCSInteiro.GetPar : boolean;
begin
   Result := IsPar(Valor);
end;


end.

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




unit CCSAbreviar;

interface

uses Classes, extctrls, Dialogs, CCSPilhas,SysUtils, CCSPreparar, CCSListaLinks;

type

  TPadrao = (CEF, TSE, PIS, MPAS, CUSTOM);

//  TCustomAbreviar = class(TCompOCX) para gerar ocx, tirei pois quero esse cara no DM
  TCustomAbreviar = class(TCCSListaLinks)
  private
    { Private declarations }
    FOnAntesAbreviar: TNotifyEvent;
    FOnDepoisAbreviar: TNotifyEvent;
    //variavel para receber o nome natural
    FNome : string;
    //Variavel para receber o nome abreviado
    FNomeAbreviado : string;
    //Variavel para indicar se abrevidado ou nao (s/n)
    FIndicador : char;
    //Indica o tamanho maximo do nome abreviado
    FTamanhoSaida : integer;
    //Indica quantidade de nomes no inicio e no fim do Nome se couper
    FNomesExternos : integer;
    FNomesExternosEsquerda : integer;
    FNomesExternosDireita : integer;
    //Indicador da direcao da saida;
    FDirecao : TDirecao;
    //Pilha para conter nomes separados
    FPilhaNomes : TCusTomPilhaStatica;
    FPilhaNomes2 : TCusTomPilhaStatica;
    Stack        : TCusTomPilhaStatica;
    //Image para poder conter o bitmap de apresentacao
//    Image : TImage;
    //Tratar nome
    FTratarNome : TCustomPreparar;
    //Indicador se exite paraente
    FExisteParente : boolean;
    FTratarParente : boolean;
    //Variavel para indicar quantas palavras retirar do topo da pilha
    FTirarTopo : integer;
    //Variavel para indicar quantas palavras montar na base da pilha
    FManterBase : integer;
    FPadrao : TPadrao;

    //Metodos
    procedure AjustarPadrao;
    procedure SetPadrao(Value : TPadrao);
    procedure SetAbreviar(Value : String);
    function GetExisteParente : boolean;
    function GetLenNomeDigitado : integer;
    function GetLenNomeAbreviado : integer;
//    procedure Change;

  protected
    { Protected declarations }
    procedure Loaded; override;
//    procedure paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AbreviarNome; virtual;
    procedure AbreviarNomesIntermediarios; virtual;
    procedure AbreviarParentes; virtual;
    procedure SepararNomes(NomePilha : TCusTomPilhaStatica; Value : string; Separador : char; Direcao : TDirecao);
    function JuntarNomes(NomePilha : TCusTomPilhaStatica; Separador : char; Direcao : TDirecao) : string;
    function JuntarPilhasNomes(PilhaNomes1, PilhaNomes2 : TCusTomPilhaStatica; separador : char; Direcao : TDirecao) : string;
    function VerificarPreposicao(Value : string) : boolean; virtual;
    procedure TirarPreposicoes; virtual;
    procedure TirarPatentes; virtual;
    procedure TirarTodasPreposicoes; virtual;
    property ExisteParente : boolean read GetExisteParente write FExisteParente;
    property Indicador : char read FIndicador;
    property NomeAbreviado : string read FNomeAbreviado;
    property Nome : string read FNome write SetAbreviar;
    property TamanhoSaida : integer read FTamanhoSaida write FTamanhoSaida;
    property NomesExternos : integer read FNomesExternos write FNomesExternos;
    property NomesExternosEsquerda : integer read FNomesExternosEsquerda write FNomesExternosEsquerda;
    property NomesExternosDireita : integer read FNomesExternosDireita write FNomesExternosDireita;
    property Padrao : TPadrao read FPadrao write SetPadrao default CEF;
    property TratarParente : boolean read FTratarParente write FTratarParente;
    property DirecaoAbreviacao : TDirecao read FDirecao write FDirecao;
    property LenNomeDigitado : integer read GetLenNomeDigitado;
    property LenNomeAbreviado : integer read GetlenNomeAbreviado;
    property OnAntesAbreviar: TNotifyEvent read FOnAntesAbreviar write FOnAntesAbreviar;
    property OnDepoisAbreviar: TNotifyEvent read FOnDepoisAbreviar write FOnDepoisAbreviar;
  published
    { Published declarations }
  end;


  TCCSAbreviar = class(TCustomAbreviar)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property ExisteParente;
    property Indicador;
    property NomeAbreviado;
    property Nome;
    property TamanhoSaida;
    property NomesExternosEsquerda;
    property NomesExternosDireita;
    property Padrao;
    property TratarParente;
    property DirecaoAbreviacao;
    property LenNomeDigitado;
    property LenNomeAbreviado;
    property OnAntesAbreviar;
    property OnDepoisAbreviar;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TCCSAbreviar]);
end;

const

  //Array com as abreviacoes de fim de nome
  ArrayParentes: array[1..32] of Pchar =
  ('JUNIOR',      'JÚNIOR',
   'BISNETA',     'BISNETO',
   'NETO',        'NETOS',     'NETA',          'NETAS',
   'FILHA',       'FILHAS',
   'FILHO',       'FILHOS',
   'SOBRINHO',    'SOBRINHOS', 'SOBRINHA',      'SOBRINHAS',
   'PRIMO',       'PRIMOS',    'PRIMA',         'PRIMAS',
   'PRIMEIRO',    'PRIMEIROS', 'PRIMEIRA',      'PRIMEIRAS',
   'SEGUNDO',     'SEGUNDOS',  'SEGUNDA',       'SEGUNDAS',
   'TERCEIRO',    'TERCEIROS', 'TERCEIRA',      'TERCEIRAS'
  );

  //Array de Siglas para parentes relacionados acima
  ArraySiglaParentes: array[1..32] of Pchar =
  ('JR',          'JR',
   'BIS',         'BIS',
   'NT',          'NT',        'NT',            'NT',
   'FA',          'FA',
   'FO',          'FO',
   'SB',          'SB',        'SB',            'SB',
   'PM',          'PM',        'PM',            'PM',
   'PRI',         'PRI',       'PRI',           'PRI',
   'SEG',         'SEG',       'SEG',           'SEG',
   'TER',         'TER',       'TER',           'TER'
  );

  //Array para auxiliar na retirada de patentes
  ArrayPatentes: array[1..15] of Pchar =
  ('BEL',
   'CEL',
   'ENG',
   'MAJ',
   'MIN',
   'PROF',
   'TEN',
   'CAP',
   'DR',
   'DRA',
   'GAL',
   'MED',
   'PE',
   'SARG',
   'VVA'
  );

  //Array para auxiliar na retirada de patentes
  ArrayNomesInter : array[1..16] of Pchar =
  ('DA',
   'DE',
   'DI',
   'DO',
   'DU',
   'DAS',
   'DOS',
   'DEL',
   'DER',
   'LA.',
   'LE',
   'LES',
   'LOS',
   'VAN',
   'VON',
   'EL'
  );

  //Tipos de caracteres de separa
  cBranco : char = #32;
//  cPonto : char = '.';




////////////////////////////Abreviar//////////////////////////////////////

constructor TCustomAbreviar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  Image := TImage.Create(self);
  FTratarNome := TCustomPreparar.Create(nil);
  FPadrao := CEF;
  AjustarPadrao;
//  FTratarNome.name := 'TratarNome';
//  InitImage;
//  Width := 28;
//  Height := 28;
//  Inicia Pilha Nomes
  FPilhaNomes := TCusTomPilhaStatica.Create(nil);
  FPilhaNomes2 := TCusTomPilhaStatica.Create(nil);
  Stack := TCusTomPilhaStatica.Create(nil);
  Stack.Init;
end;
{ so para quando tiver compocx
procedure TCustomAbreviar.Paint;
begin
   inherited paint;
end;
}

procedure TCustomAbreviar.Loaded;
begin
  inherited Loaded;
  AjustarPadrao;
end;

destructor TCustomAbreviar.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomAbreviar.SetAbreviar(Value : String);
begin
   FNome := Value;
end;

procedure TCustomAbreviar.SetPadrao(Value : TPadrao);
begin
   FPadrao := Value;
   AjustarPadrao;
end;

procedure TCustomAbreviar.AjustarPadrao;
begin
   if not(csLoading in ComponentState) then
   begin
      case Padrao of
         CEF, TSE  :
         begin
            TamanhoSaida := 70;
            NomesExternosDireita := 2;
            NomesExternosEsquerda := 2;
            TratarParente := True;
            DirecaoAbreviacao := Direita;
         end;
         MPAS  :
         begin
            TamanhoSaida := 60;
            NomesExternosDireita := 1;
            NomesExternosEsquerda := 1;
            TratarParente := True;
            DirecaoAbreviacao := Direita;
         end;
{         CUSTOM :
         begin
            TamanhoSaida := 40;
            NomesExternosDireita := 1;
            NomesExternosEsquerda := 1;
            TratarParente := False;
            DirecaoAbreviacao := Esquerda;
         end;
}      end;
   end;
end;


{ Sem uso por enquanto
procedure TCustomAbreviar.Change;
begin
//   NotifyLinks(Self, lChange);
end;}

procedure TCustomAbreviar.AbreviarNome;
{
          Este metodo ira disparar os metodos para Abreviar Nome
}
begin
   if Assigned(FOnAntesAbreviar) then FOnAntesAbreviar(Self);
   if Length(FNome) <> 0 then
   begin
      FIndicador := 'N';
      // 0
      FNomeAbreviado := uppercase(FNome);
      // 4
      TirarPatentes;
      // 1, 2, 3, 5
      FTratarNome.Nome := FNomeAbreviado;
      FTratarNome.TratarNome;
      FNomeAbreviado :=  FTratarNome.NomeTratado;
      // 6
      //Indica se exite parente a ser abreviado
      ExisteParente := False;

      AbreviarParentes;

      SepararNomes(FPilhaNomes, FNomeAbreviado, cBranco, Esquerda);

      if FPilhaNomes.Posicao > 2 then
      begin
         TirarPreposicoes;
         // 7
         AbreviarNomesIntermediarios;
      end;
   end;
   if Assigned(FOnDepoisAbreviar) then FOnDepoisAbreviar(Self);
//   NotifyLinks(self, lLoad);
end;

procedure TCustomAbreviar.TirarPatentes;
{
    Rotina para tirar patentes do inicio do nome se abreviada
}
var
   i         : integer;
   Patente   : string;
begin
  SepararNomes(FPilhaNomes, FNomeAbreviado, cBranco, Direita);
  Patente := FPilhaNomes.View(FPilhaNomes.Posicao);
  for i := 1 to 15 do
  begin
     if (Patente = string(ArrayPatentes[i])) or (Patente = (string(ArrayPatentes[i]+ '.'))) then
     begin
        //Substitui Parente pela Sigla do Parente
        Patente := FPilhaNomes.Pop;
        FNomeAbreviado := JuntarNomes(FPilhaNomes, cBranco, Direita);
        FIndicador := 'S';
        break;
     end;
  end;
end;

function TCustomAbreviar.GetLenNomeDigitado : integer;
begin
   Result := length(FNome);
end;

function TCustomAbreviar.GetLenNomeAbreviado : integer;
begin
   Result := length(FNomeAbreviado);
end;


function TCustomAbreviar.GetExisteParente : boolean;
{
         Mesmo que existe parente se propriedade indicar que nao e para tratar
   parente ira prevalecer o valo da propriedade que indica se trata ou nao o
   parente.
}
begin
   if FTratarParente and FExisteParente then
      Result := true
   else
      Result := false;
end;

procedure TCustomAbreviar.AbreviarParentes;
{
          Rotina para abreviar nomes de parentes, nao sera usada por definicao da
reuniao de 11/05/98 CEF RJ
}
var
   i : integer;
   Parente   : string;
begin
   SepararNomes(FPilhaNomes, FNomeAbreviado, cBranco, Esquerda);
   if FPilhaNomes.Posicao > 0 then
   begin
      Parente := FPilhaNomes.view(FPilhaNomes.Posicao);
      //Procura por Parente no Nome
      for i := 1 to 32 do
      begin
         if Parente = string(ArrayParentes[i]) then
         begin
            //Substitui Parente pela Sigla do Parente
            ExisteParente := True;
            Parente := FPilhaNomes.Pop;
            FPilhaNomes.Push(string(ArraySiglaParentes[i]));
            FNomeAbreviado := JuntarNomes(FPilhaNomes, cBranco, esquerda);
            FIndicador := 'S';
            break;
         end;
      end;
   end;
end;

procedure TCustomAbreviar.TirarTodasPreposicoes;
{
         Metodo publico para retinar nomes intermediarios tipo do da dos
}
begin
   Stack.Push(IntToStr(FTamanhoSaida));
   Stack.Push(FNome);
   FTamanhoSaida := 0;
   TirarPreposicoes;
   FNome := Stack.Pop;
   FTamanhoSaida := StrToInt(Stack.Pop);
end;

procedure TCustomAbreviar.TirarPreposicoes;
var
   NomeInter  : string;
begin
  // Monta Nova Pilha
  SepararNomes(FPilhaNomes, FNomeAbreviado, cBranco, Esquerda);
  if FPilhaNomes.Posicao < 3 then exit;
  //Tirar Nomes Intermediarios tal como da, de di e etc ver table NomesIntermedirario
  FPilhaNomes2.Init;
  FPilhaNomes2.Push(FPilhaNomes.Pop);
  while (FPilhaNomes.Posicao > 1) and (Length(FNomeAbreviado) > FTamanhoSaida) do
  begin
     NomeInter := FPilhaNomes.Pop;
     if not (VerificarPreposicao(NomeInter)) then
        FPilhaNomes2.Push(NomeInter);
     FNomeAbreviado := JuntarPilhasNomes(FPilhaNomes, FPilhaNomes2, cBranco, Esquerda);
  end;
end;

procedure TCustomAbreviar.AbreviarNomesIntermediarios;
{
          Metodo para abreviar os nomes intermediarios da Esquerda para Direita
}
var
   i : integer;
   FDirecaoAux : TDirecao;
begin
  {
    Condicao para determinar a direcao da abreviacao e se existe parente pois
  deacordo com a especificacao da caixa se existir Parente o antepenultima nome
  nao deve ser alterado
  }
  FDirecaoAux := FDirecao;
  if (FDirecao = esquerda) then
  begin
     FDirecaoAux := Direita;
     FTirarTopo := FNomesExternosEsquerda;
     if (NomesExternosDireita < 3) and ExisteParente  then
        FManterBase := 3
     else
        FManterBase := FNomesExternosDireita;
  end else
  if (FDirecao = Direita) then
  begin
     FDirecaoAux := Esquerda;
     FManterBase := FNomesExternosEsquerda;
     if (NomesExternosDireita < 3)  and ExisteParente then
        FTirarTopo := 3
     else
        FTirarTopo := FNomesExternosDireita;
  end;
  while (Length(FNomeAbreviado) > FTamanhoSaida)  and (FTirarTopo > 0) do
  begin
     // Monta Nova Pilha
     SepararNomes(FPilhaNomes, FNomeAbreviado, cBranco, FDirecaoAux);

     //verifica a validade dos parametros
     if FPilhaNomes.Posicao < FTirarTopo then
     begin
       ShowMessage('Nomes externos nao pode ser maior que Numero de subNomes.');
       exit;
     end;
     FPilhaNomes2.Init;
     //Tira os primeiros nomes da lista
     for i := 1 to FTirarTopo do
       FPilhaNomes2.Push(FPilhaNomes.Pop);
     //Abreviar nomes
     while (FPilhaNomes.Posicao > FManterBase) and (Length(FNomeAbreviado) > FTamanhoSaida) do
     begin
 ///    estou com erro aqui quando coloco porcaria
        FPilhaNomes2.Push(FPilhaNomes.Pop[1]);
        FNomeAbreviado := JuntarPilhasNomes(FPilhaNomes, FPilhaNomes2, cBranco, FDirecaoAux);
     end;
     {
          Caso o nome nao tenha ficado no tamanho desejado com os nomes esternos
      comeca a diminuir o numero de nomes esternos tentanto sempre manter o parente
     }
     if FDirecao = Esquerda then
     begin
        Dec(FTirarTopo);
        if (FTirarTopo = 0) and (FManterBase - 1 > 0) then
        begin
           Dec(FManterBase);
           FTirarTopo := 1;
        end
     end else
     if FDirecao = Direita then
     begin
        Dec(FManterBase);
        if (FManterBase = 0) and (FTirarTopo - 1 >= 0) then
        begin
           Dec(FTirarTopo);
           FManterBase := 1;
        end
     end;
  end;
end;

function TCustomAbreviar.VerificarPreposicao(Value : string) : boolean;
{
         Metodo para procurar no arry de nomes inter valor passado
}
var
   i : integer;
begin
   Result := False;
   for i := 1 to 15 do
   begin
      if Value = string(ArrayNomesInter[i]) then
      begin
         Result := True;
         break;
      end;
   end;
end;

procedure TCustomAbreviar.SepararNomes(NomePilha : TCusTomPilhaStatica; Value : string; Separador : char; Direcao : TDirecao);
{
          Passei o metodo como procedure global da unit CCSPilhas(Pablo)
}
begin
   CCSPilhas.SepararNomes (NomePilha,Value,Separador,Direcao);
end;

function TCustomAbreviar.JuntarNomes(NomePilha : TCusTomPilhaStatica; Separador : char; Direcao : TDirecao) : string;
{
          Passei o metodo como procedure global da unit CCSPilhas(Pablo)
}
begin
   Result:=CCSPilhas.JuntarNomes (NomePilha,Separador,Direcao);
end;

function TCustomAbreviar.JuntarPilhasNomes(PilhaNomes1, PilhaNomes2 : TCusTomPilhaStatica; separador : char; Direcao : TDirecao) : string;
{
         metodo para montar um nome atravez de duas pilhas de palavras
         parametros Descricao
         ---------- ------------------------------------------------------
         NomePilha  Pilha que  contem o  inicio do Nome flagmentado
         NomePilha2 Pilha que  contem o  fim do Nome flagmentado
         Separador  Caracter de separacao
         Result     Nome Montado

}
var
   NomeAux : string;
   i       : integer;
   PilhaAux : TCusTomPilhaStatica;
begin
   if Direcao = Direita then
   begin
      PilhaAux := PilhaNomes1;
      PilhaNomes1 := PilhaNomes2;
      PilhaNomes2 := PilhaAux;
   end;
   NomeAux := ' ';
   for i := 1 to PilhaNomes1.Posicao  do
     NomeAux := NomeAux +  separador + PilhaNomes1.View(i);
   for i := PilhaNomes2.Posicao downto 1 do
     NomeAux := NomeAux +  separador + PilhaNomes2.View(i);
   Result :=  Trim(NomeAux);
end;

end.

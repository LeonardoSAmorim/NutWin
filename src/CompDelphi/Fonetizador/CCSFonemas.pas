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




unit CCSFonemas;

interface

uses Classes, CCSListaLinks;

type

  TConsoantes = set of char;
  TVogais = set of char;
  TConsoantesInvalidas = set of char;
  TTipoX = set of char;

  TOrigemFonemas = (ofCEF, ofCUSTOM);

  TCustomFonemas = class(TCCSListaLinks)
  private
    //Indica o token a ser avalidado
    FToken: string;
    //Indica o token de saida
    FNewToken : string;
    //Indica o fonema a ser utilizado na nome
    FFonema : string;
    //Nome a ser fonetizado
    FNome : string;
    //Lista para conter os tokens
//    FItems : TStrings;
    //Lista para token de substituicao
    FListaFonemas : TStrings;
    FListaTokens : TStrings;
    //Indica posicao da tabela;
    FPosicao : integer;
    //Indica o deslocamento dentro do nome
    FLenToken : integer;
    FLenNewToken : integer;
    FLenNome : integer;
    //Tamanho do segmento a ser retirado do Nome para inclusao do novo
    FLenSeg : integer;
    FOrigemFonemas : TOrigemFonemas;
    FIdxNome : integer;
    procedure SetOrigemFonemas(Value : TOrigemFonemas);
    procedure SetListaFonemas(Value : TStrings);
    function GetListaFonemas : TStrings;

    procedure SetListaTokens(Value : TStrings);
    function GetListaTokens : TStrings;

    function GetCount : integer;
    procedure SetToken(Value : String);
    procedure SetNewToken(Value : String);
    procedure SetNome(Value : String);
    function  AddSpacesToRight(Str : string; QtdSpc : integer) : string;
    procedure AjustarFonemas;
  protected
    procedure Loaded; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function TrocarToken : Boolean;
    function AddTokens(SegStr : string; IndSegStr, IndToken : integer) : string;
    procedure First;
    function Prior : boolean;
    function Next  : boolean;
    procedure Last;
    function view(Idx : integer) : boolean;

    property Nome : string read FNome write SetNome;
    property Token : string read FToken write SetToken;
    property NewToken : string read FNewToken write SetNewToken;
    property Fonema : string read FFonema write FFonema;
    property Posicao : integer read FPosicao write FPosicao;
    property IdxNome : integer read FIdxNome write FIdxNome;
    property Count : integer read GetCount;
    property LenToken : integer read FLenToken write FLenToken;
    property LenNewToken : integer read FLenNewToken write FLenNewToken;
    property LenNome : integer read FLenNome write FLenNome;
    property LenSeg : integer read FLenSeg write FLenSeg;

    property ListaFonemas : TStrings read GetListaFonemas write SetListaFonemas;
    property ListaTokens : TStrings read GetListaTokens write SetListaTokens;
    property OrigemFonemas : TOrigemFonemas read FOrigemFonemas write SetOrigemFonemas default ofCEF;

  published
  end;

  TCCSFonemas = class(TCustomFonemas)
  private
  protected
  public
    property Nome : string read FNome write SetNome;
    property Token : string read FToken write SetToken;
    property NewToken : string read FNewToken write SetNewToken;
    property Fonema : string read FFonema write FFonema;
    property Posicao : integer read FPosicao write FPosicao;
    property IdxNome : integer read FIdxNome write FIdxNome;
    property Count : integer read GetCount;
    property LenToken : integer read FLenToken write FLenToken;
    property LenNewToken : integer read FLenNewToken write FLenNewToken;
    property LenNome : integer read FLenNome write FLenNome;
    property LenSeg : integer read FLenSeg write FLenSeg;
  published
    property ListaFonemas;
    property ListaTokens;
    property OrigemFonemas;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TCCSFonemas]);
end;

const

  Consoantes : TConsoantes =  ['B'..'D', 'G'..'H', 'J'..'N', 'P'..'T', 'V'..'Z'];
  Vogais : TVogais = ['A','E','I','O','U'];
  ConsoantesInvalidas : TConsoantesInvalidas = ['R', 'L', 'H', ' '];
  TiposExtranhos : TTipoX = ['P'];
//  TiposDescartaveis : TTipoX = ['H'];
  TiposRepetidosPermitidos : TTipoX = ['S', 'R'];


  MAXTOKENS = 64;
  {
  Array de tokens para auxiliar na fonetizacao
  ! indica qualquer vogal
  ? indica qualquer consoante
  . indica as consoantes R, L, H -
  % indica caracter reptido fora o invalidos
  & serve para ignorar o caracter na posicao
  * indica que devera ser utilizado o caracter do new token para almentar
  @ Serve para pegar o caracter que for
  + indica caracter reptido fora o invalidos para qualquer repticao
  }
  ArrayTokens : array [1..MAXTOKENS] of Pchar =
  ('PH',        // 10
   'INNG ',     // 20
   'INNG?',     // 30
   'ING ',      // 40
   'ING?',      // 50
   'NN ',       // 60
   'NM ',       // 70
   'W',         // 80
   'Y',         // 90
   'GI',        // 100
   'GE',        // 110
   'QUA',       // 120
   'QUO',       // 130
   'CA',        // 140
   'CO',        // 150
   'CU',        // 160
   ' H',        // 170
   '?D ',       // 180
   '?F ',       // 190
   '?P ',       // 200
   '?B ',       // 210
   '?T ',       // 220
   '!D *',      // 230
   '!F *',      // 240
   '!P *',      // 250
   '!B *',      // 260
   '!T *',      // 270
   '!&?',       // 280
   '?%%',       // 290
   '?%',        // 300
   '?% ',       // 310
   '!%%',       // 290
   '!%',        // 300
   '!% ',       // 310
   'QUA',       // 320
   'QUE',       // 330
   'QUI',       // 340
   'N?',        // 350
   'N ',        // 360
   'SCH',       // 370
   'SH',        // 380
   'C&!',       // 390
   'C&?',       // 400
   'CH ',       // 410
   'LHA',       // 420
   'LHO',       // 430
   'LHU',       // 440
   'VID ',      // 450
   'D.@',        // 460
   'F.@',        // 480
   'P.@',        // 490
   'B.@',        // 500
   'T.@',        // 510
   '!&?',       // 520
   'H',         // 530
   '!S!',       // 540
   ' S*?',      // 550
   'GUE',       // 560
   'GUI',       // 570
   'CE',        // 580
   'CI',        // 590
   'UEL',       // 600
   '!&?',       // 610
   '?+'         // 620
  );
  //Array para trocar tokens
  ArrayNewTokens : array [1..MAXTOKENS] of Pchar =
  ('F',
   'IM ',
   'IM?',
   'IM ',
   'IM?',
   'MM ',
   'MM ',
   'V',
   'I',
   'JI',
   'JE',
   'KUA',
   'KUO',
   'KA',
   'KO',
   'KU',
   ' ',
   '? ',
   '? ',
   '? ',
   '? ',
   '? ',
   '!DI ',
   '!FI ',
   '!PI ',
   '!BI ',
   '!TI ',
   '!&? ', // caso 32
   '%%',
   '%',
   '% ',
   '%%',
   '%',
   '% ',
   'KA',
   'KE',
   'KI',
   'M?',
   'M ',
   'X',
   'X',
   'X&!',
   'K&?',
   'K ',
   'LIA',
   'LIO',
   'LIU',
   'VI ',
   'DI@',
   'FI@',
   'PI@',
   'BI@',
   'TI@',
   '!&?',
   '',
   '!Z!',
   ' ES?',
   'GE',
   'GI',
   'SE',
   'SI',
   'OEL',
   '!&?',
   '?'
  );




///////TTabela de Tokens////////////////////////////////////////

constructor TCustomFonemas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListaFonemas := TStringList.Create;
  FListaTokens := TStringList.Create;
  FOrigemFonemas := ofCEF;
  AjustarFonemas;
end;

procedure TCustomFonemas.Loaded;
begin
  inherited Loaded;
end;


destructor TCustomFonemas.Destroy;
begin
  FListaFonemas.Free;
  FListaTokens.Free;
  inherited Destroy;
end;

procedure TCustomFonemas.SetOrigemFonemas(Value : TOrigemFonemas);
begin
   FOrigemFonemas := Value;
   AjustarFonemas;
end;

procedure TCustomFonemas.AjustarFonemas;
var
   i : integer;
begin
   if FOrigemFonemas = ofCEF then
   begin
      FListaFonemas.clear;
      FListaTokens.clear;
      for i := 1 to MAXTOKENS do
      begin
         FListaFonemas.add(string(ArrayTokens[i]));
         FListaTokens.add(string(ArrayNewTokens[i]));
      end;
   end;
   if (FOrigemFonemas = ofCUSTOM) and ((FListaFonemas.Count - 1) = 0) then
   begin
      FListaFonemas.clear;
      FListaTokens.clear;
   end;
end;
function TCustomFonemas.GetListaFonemas : TStrings;
begin
     Result := FListaFonemas;
end;

function TCustomFonemas.GetListaTokens : TStrings;
begin
     Result := FListaTokens;
end;

procedure TCustomFonemas.SetListaFonemas(Value : TStrings);
begin
     FListaFonemas.Assign(Value);
end;

procedure TCustomFonemas.SetListaTokens(Value : TStrings);
begin
     FListaTokens.Assign(Value);
end;

procedure TCustomFonemas.First;
begin
   FPosicao := 0;
   Token := FListaFonemas[0];
   NewToken := FListaTokens[0];
end;

function TCustomFonemas.Prior : boolean;
begin
   Result := True;
   if FPosicao > 0 then
      dec(FPosicao)
   else
      Result := False;
   Token := FListaFonemas[FPosicao];
   NewToken := FListaTokens[FPosicao];
end;

function TCustomFonemas.Next : boolean;
begin
   Result := True;
   if FPosicao < FListaFonemas.count -1 then
      inc(Fposicao)
   else
      Result := false;
   Token := FListaFonemas[FPosicao];
   NewToken := FListaTokens[FPosicao];
end;

procedure TCustomFonemas.Last;
begin
   FPosicao := FListaFonemas.count -1;
   Token := FListaFonemas[FPosicao];
   NewToken := FListaTokens[FPosicao];
end;

function TCustomFonemas.view(idx : integer): boolean;
begin
   if not ((idx < 0) or (idx > FListaFonemas.count -1)) then
   begin
      Result := true;
      Token := FListaFonemas[idx];
      NewToken := FListaTokens[idx];
   end else
      Result := False;
end;

function TCustomFonemas.GetCount : integer;
begin
   Result := FListaFonemas.Count - 1;
end;

procedure TCustomFonemas.SetToken(Value : string);
begin
   FToken := Value;
   FLenToken := length(Value);
end;

procedure TCustomFonemas.SetNewToken(Value : string);
begin
   FNewToken := Value;
   FLenNewToken := length(Value);
end;

procedure TCustomFonemas.SetNome(Value : string);
begin
   FNome := Value;
   FLenNome := length(Value);
end;


function TCustomFonemas.TrocarToken : Boolean;
{
         Metodo para pesquizar se token e valido e montar token para troca

         Parametro   Descricao
         -------------------------------------------------------------------
         FNome        Nomes a ser fonetizado
         FToken       Token a ser avalidado para troca
         FNewToken    O token que devera ser trocado
         FIdxNome     indica a posicao do ponteiro dentro do nome
         FFonema      Token formado para troca se result = true

}
var
   i, j : integer;  // indice para o token e para o nome
   RepCons : char;
   FlentokenAux : integer;
   FNomeAux : string; //para conter o nome aumentado se necessario
begin
   i := 0;
   j := 0;
   FLenTokenAux := FLenToken;
   Result := True;
   RepCons := FNome[i + FIdxNome];
   FFonema := '';
   FNomeAux := AddSpacesToRight(FNome, ((FIdxNome + FLenToken)- FLenNome));
// estava embaixo antes acho que nao preciso mais ((FLenNome >= (FIdxNome + i)) or (FToken[i + 1] = '*')) and
   while ((FLenToken > i) and (Result)) do
   begin
      if FToken[i + 1] = FNomeAux[j + FIdxNome] then
         FFonema := FFonema + AddTokens(FNewToken, (i + 1), (i + 1))
      else
         if ((FToken[i + 1] = '?') and (FNomeAux[j + FIdxNome] in Consoantes)) or
            ((FToken[i + 1] = '!') and (FNomeAux[j + FIdxNome] in Vogais)) or
            ((FToken[i + 1] = '%') and (FNomeAux[j + FIdxNome] = RepCons) and not (RepCons in TiposRepetidosPermitidos)) or
            ((FToken[i + 1] = '+') and (FNomeAux[j + FIdxNome] = RepCons)) or
            ((FToken[i + 1] = '&') and (FNomeAux[j + FIdxNome] in TiposExtranhos)) or
            (FToken[i + 1] = '@') then
            FFonema := FFonema + AddTokens(FNomeAux, (j + FIdxNome), (i + 1))
         else
            if ((FToken[i + 1] = '.') and (FNomeAux[j + FIdxNome] in Consoantes) and not (FNomeAux[j + FIdxNome] in ConsoantesInvalidas)) or
                (FToken[i + 1] = '*') then
            begin
               FFonema := FFonema + FNewToken[i + 1];
               Dec(FLenTokenAux);
               Dec(j); // para indicar a posicao no nome que nao deslocou
            end else
               Result := False;
      inc(i);
      inc(j);
   end;
   //esta linha e para os casos em que o fonema e mairo que o token
   FLenSeg := FLentokenAux;
end;


function TCustomFonemas.AddTokens(SegStr : string; IndSegStr, IndToken : integer) : string;
{
          Metodo para devolver o caracter do fonema se existir
          parametros Descricao
          ---------- ------------------------------------------------------
          SegStr     Segmento do string a ser avaliado
          IndSegStr  Posicao do token a ser retirado o caracter
          IndToken   Posicao do token onde esta o char
}

begin
   // O & indica que o caracter na posicao devera ser ignorado
   if ((FLenNewToken >= IndToken) and (FToken[IndToken] <> '&') and (SegStr <> '')) then
      Result := SegStr[IndSegStr]
   else
      Result := '';
end;

function TCustomFonemas.AddSpacesToRight(Str : string; QtdSpc : integer) : string;
{
         Funcao para aumentar o tamanho do nome para fonetizacao de aumento
}
var
  i : integer;
begin
   if QtdSpc > 0 then
      for i := 1 to QtdSpc do
          Str := Str + #32;
   Result := Str;
end;



end.

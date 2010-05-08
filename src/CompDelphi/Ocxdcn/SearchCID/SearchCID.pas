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




unit SearchCID;

interface

//uses
//  SysUtils, WinProcs, Messages, Classes,inifiles,
//  registry,Forms, Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, Index32, ComCtrls;
uses SysUtils, WinTypes, Classes, Graphics, Controls, clipbrd, comctrls, DicNut, Activex, Dialogs, registry;


type
  tipoOcorr = array[0..16382] of integer;    {máximo de 16382 ocorrencias da mesma palavra}
  pOcorr = ^tipoOcorr;
  TipoEntry = record
    Texto  : PString;
    Indice : integer;
  end;
  TipoEntryArray = array[0..100000] of TipoEntry;
  TipoIndex = record
    Numero,Maximo :  integer;
    Entry         :  ^TipoEntryArray;
  end;

  TSearchCID = class(TNewDic)
  private
    { Private declarations }
    LastChar :Char;
    SemDic:boolean;
    Initialized : boolean;
    SelectedItemIndex : integer;
    FPesquisaAutomatica: boolean;
    FQtdOcorrencias: integer;
    FCodigoEscolhido: string;
    FDiretorioCID: string;
    FArquivosCID: string;
    FChave: string;
    FPesquisaInicial: string;
    FDetalheCID: TRichEdit;
    FLista: TStringList;
    procedure SetArquivosCID(const Value: string);
    procedure SetChave(const Value: string);
    procedure SetCodigoEscolhido(const Value: string);
    procedure SetDetalheCID(const Value: TRichEdit);
    procedure SetDiretorioCID(const Value: string);
    procedure SetLista(const Value: TStringList);
    procedure SetPesquisaAutomatica(const Value: boolean);
    procedure SetPesquisaInicial(const Value: string);
    procedure SetQtdOcorrencias(const Value: integer);
    //Estas rotinas estao tambem no arquivo Index32 no package do Pesqcid
    //estao copiadas para nao ter dependencias entre os packages
    procedure CriaIndex(var Ind:TipoIndex;Tamanho:integer);
    function InsereIndex(var Ind:TipoIndex;S:string;EsteIndice:integer):boolean;
    function IndexFind(var L:TipoIndex;Chave:string;var Posicao:integer;var EsteIndice:integer):boolean;
//    Procedure RemoveIndex(var Ind:TipoIndex);
  protected
  Terminou, ChDup, TemChDup, TemChave: boolean;
  TextDescrCID : string;
  //////////////
  IndPalavra: tipoIndex;
  Palavra, S, NomeDic, NomeTxt, NomeInv: string;
  NumOcorr, NumPal, MaxPal, MaxOcorr, Location, EsteIndice: integer;
  Entrada: text;
  ArqTexto, ArqInv: file;
  ListOcorr, TempOcorr, EstaOcorr: pOcorr;
  Exclusao, Prox, TemBarra, TextoExc: boolean;
  ///////////////
    //Eram procedures soltas
    procedure ANDLogico(var A,B,Temp : TipoOcorr);
    procedure CarregaOcorr(var EsteIndice: integer; var EstaOcorr:tipoOcorr);
    procedure ChaveDupla(PosTab,PosSep,Ch1,Ch2:integer;Tex:string; var Lin:string);
    function GetToken(var S: string): string;
    function minimo(Pi,Pe:pchar):pchar;
    procedure ORLogico(var A,B,Temp : TipoOcorr);
    procedure PegaAsterisco(Palavra:string; var Saida:tipoOcorr);
    function PegaPalavra(var S,Palavra:String):boolean;
    function PegaTexto(Desloc:integer):string;
    function SemAcento(S:String):String;
    function InitDic:boolean;
  public
    { Public declarations }
    property Lista: TStringList read FLista write SetLista;
    property Chave: string read FChave write SetChave;
    property QtdOcorrencias: integer read FQtdOcorrencias write SetQtdOcorrencias;
    property CodigoEscolhido: string read FCodigoEscolhido write SetCodigoEscolhido;
    property PesquisaAutomatica: boolean read FPesquisaAutomatica write SetPesquisaAutomatica;
    property DetalheCID: TRichEdit read FDetalheCID write SetDetalheCID;

    constructor Create (AOwner: TComponent); override;
    procedure Search;
    procedure Loaded;override;
    procedure ListaShowItem(ItemIndex:integer);
    procedure Monta(Tex:string);
    procedure TrocaChar;
    procedure BoldNota;
    function PosSep(Tex:string):integer;
    procedure DetalheSelectionChange(Sender: TObject);
    procedure SearchCodigoEscolhido;
    procedure Mostra(PosSep:integer; Tex:string; Indent:string);
    procedure ListaSelect;
    procedure CopyToClipboard;
    destructor Destroy;override;

    function ConnectDictionary(const UserID, UserPassword: WideString): TOleBool;override; stdcall;
    procedure DisconnectDictionary;override; stdcall;
    function GetFirstCodeByDesc(var Code, Description: WideString): TOleBool;override; stdcall;
    function GetNextCodeByDesc(var Code, Description: WideString): TOleBool;override; stdcall;
    function FindCodeByDescription(var Code: WideString; const Description: WideString): Smallint;override; stdcall;

  published
    property DiretorioCID : string read FDiretorioCID write SetDiretorioCID;
    property ArquivosCID : string read FArquivosCID write SetArquivosCID;
    property PesquisaInicial : string read FPesquisaInicial write SetPesquisaInicial;
  end;

procedure Register;


implementation

{$R PSQCIDBMP.RES}

const
  Maximo = 15000;
{  TamL = 25;
  FLista: array[1..TamL] of string =
   ('AO','AOS','AS','DA','DAS','DE','DO','DOS','E','EM','ENTRE','NA',
    'NAS','NO','NOS','O','OS','OU','POR','PARA','PELO','PELA','PELOS',
    'PELAS','QUE');}
  StrMax = 2000;

function TSearchCID.GetToken(var S: string): string;
var  I: integer;
     Temp: string;
begin
  I := pos(',',S);
  if I > 0 then
    begin
      GetToken := copy(S,1,I-1);
      Temp := copy(S,I+1,length(S)-I);
      S := Temp;
    end
  else
    begin
      GetToken := S;
      S := '';
    end;
end;{GetToken}

{ TSearchCID }
constructor TSearchCID.Create (AOwner : TComponent);
begin
inherited;
  {encontra arquivo .dic}
  LastChar:=char(0);
  SemDic:=False;
  Initialized:=False;
  ArquivosCID:='CID10N4A';
  FLista:=TStringList.Create;
  FDetalheCID:=TRichEdit.CreateParented (TWinControl(Owner).Handle);
  FDetalheCID.Visible := False;
end;

function TSearchCID.InitDic:boolean;
var
Reg: TRegistry;
begin
  Result:=False;
  NomeDic := DiretorioCID + ArquivosCID +'.dic';
  if not FileExists(NomeDic) then
    begin
    //Verifica se e um OCX
    Reg:=TRegistry.Create;
    try
      begin
        Reg.RootKey:=HKEY_CLASSES_ROOT; // Section to look for within the registry
        if Reg.OpenKey('\CLSID\{A8A4FAA5-8936-11D3-8576-006008DF8A1A}\InprocServer32',False) then
           DiretorioCID:=copy (Reg.ReadString(''),1,LastDelimiter('\',Reg.ReadString('')))
        else
           //Tenta no diretorio corrente
           DiretorioCID:='';
      end;
    finally
      Reg.Free;
    end;

    NomeDic:=DiretorioCID + ArquivosCID +'.dic';

    if not FileExists(NomeDic) then
       NomeDic:=ArquivosCID +'.dic';
    //Procura no diretorio corrente
    if not FileExists(NomeDic) then
       begin
       SemDic:=True;
       exit;
       end
    else
        begin
        //Achou no diretorio corrente
        DiretorioCID:='';
        end;
    end;

  FChave:='';

  Result:=True;
  assignfile(Entrada,NomeDic);
  reset(Entrada);
  {Aloca memória para o dicionario}
  readln(Entrada,MaxPal,MaxOcorr);
  getmem(ListOcorr,(Maximo)*sizeof(integer));
  getmem(TempOcorr,(Maximo)*sizeof(integer));
  getmem(EstaOcorr,(Maximo)*sizeof(integer));
  CriaIndex(IndPalavra,MaxPal+1);
  {Carrega dicionario}
  NumPal := 0;
  while not eof(Entrada) do
    begin
      readln(Entrada,S);
      Palavra  := getToken(S);
      EsteIndice := StrToInt(GetToken(S));
      insereIndex(IndPalavra,Palavra,EsteIndice);
    end;
  closefile(Entrada);
  {Carrega textos originais}
  NomeTxt := changefileext(NomeDic,'.txt');
  if not FileExists(NomeTxt) then
    begin
      NomeTxt := changefileext(NomeDic,'.dat');
      if not FileExists(NomeTxt) then
         begin
         showmessage('Arquivo '+NomeTxt+' não encontrado');
         exit;
         end;
    end;
  assignfile(ArqTexto,NomeTxt);
  reset(ArqTexto,1); {Mantem aberto para BuscarTexto}
  NomeInv := changefileext(NomeDic,'.inv');
  if not FileExists(NomeInv) then
    begin
      showmessage('Arquivo '+NomeInv+' não encontrado');
      exit;
    end;
  assignfile(ArqInv,NomeInv);
  reset(ArqInv,1); {Mantem aberto para Invertido}
  Initialized:=True;
end;

function TSearchCID.PegaPalavra(var S,Palavra:String):boolean;
begin
  Result := true;
  while (length(S) > 0) and (S[1] = ' ') do delete(S,1,1);
  if S = '' then
    begin
      Palavra := '';
      Result := false;
      Exit;
    end;
  Palavra := '';
  while (length(S) > 0) and (S[1] <> ' ') do
    begin
      Palavra := Palavra + S[1];
      delete(S,1,1);
    end;
    {if ForaDoDic
      then Result:=PegaPalavra(S,Palavra);}
end;

procedure TSearchCID.ANDLogico(var A,B,Temp : TipoOcorr);
var
  IndA,IndB : integer;
begin
  Temp[0] := 0;
  IndA    := 1;
  IndB    := 1;
  if (A[0] > 0) and (B[0] > 0) then
    repeat
      if A[IndA] = B[IndB] then
        begin
          inc(Temp[0]);
          Temp[Temp[0]] := A[IndA];
          inc(IndA);
          inc(IndB);
        end
      else
        if A[IndA] < B[IndB]
          then inc(IndA)
          else inc(IndB);
    until (IndA > A[0]) or (IndB > B[0]);
end;{ANDLogico}

procedure TSearchCID.ORLogico(var A,B,Temp : TipoOcorr);
var
  IndA,IndB : integer;
begin
  Temp[0] := 0;
  IndA    := 1;
  IndB    := 1;
  if A[0] = 0 then
    begin
      for IndB := 0 to B[0] do Temp[IndB] := B[IndB];
      exit;
    end;
  repeat  {Enquanto houver duas listas}
    if A[IndA] = B[IndB] then
      begin
        inc(Temp[0]);
        Temp[Temp[0]] := A[IndA];
        inc(IndA);
        inc(IndB);
      end;
    if (A[IndA] < B[IndB]) then
      begin
        inc(Temp[0]);
        Temp[Temp[0]] := A[IndA];
        inc(IndA);
      end;
    if (A[IndA] > B[IndB]) then
      begin
        inc(Temp[0]);
        Temp[Temp[0]] := B[IndB];
        inc(IndB);
      end;
  until (IndA > A[0]) or (IndB > B[0]);
  {Esvazia a lista remanescente}
  if IndA <= A[0] then
    for IndA := IndA to A[0] do
      begin
        inc(Temp[0]);
        Temp[Temp[0]] := A[IndA];
      end;
  if IndB <= B[0] then
    for IndB := IndB to B[0] do
      begin
        inc(Temp[0]);
        Temp[Temp[0]] := B[IndB];
      end;
end;{ORLogico}

procedure TSearchCID.CarregaOcorr(var EsteIndice: integer; var EstaOcorr:tipoOcorr);
begin
  seek(ArqInv,EsteIndice);
  blockread(ArqInv,EstaOcorr[0],sizeof(integer));
  blockread(ArqInv,EstaOcorr[1],EstaOcorr[0]*sizeof(integer));
end;

procedure TSearchCID.PegaAsterisco(Palavra:string; var Saida:tipoOcorr);
var
  ListOcorr : pOcorr;
  I         : integer;
begin
  getmem(ListOcorr,16382*sizeof(integer));
  delete(Palavra,length(Palavra),1);
  IndexFind(IndPalavra,Palavra,Location,EsteIndice);
  ListOcorr^[0] := 0;
  with IndPalavra do
  begin
    while  (Location <= Numero) and
           (Palavra = copy(Entry^[Location].Texto^,1,length(Palavra))) do
      begin
        CarregaOcorr(Entry^[Location].Indice, EstaOcorr^);
        ORLogico(ListOcorr^,EstaOcorr^,TempOcorr^);
        for I := 0 to TempOcorr^[0] do
        ListOcorr^[I] := TempOcorr^[I];
        inc(Location);
      end;
  end;
  for I := 0 to ListOcorr^[0] do Saida[I] := ListOcorr^[I];
  freemem(ListOcorr,16382*sizeof(integer));
end;{PegaAsterisco}

function TSearchCID.SemAcento(S:String):String;
var
  Temp : String;
  I    :integer;
begin
  Temp := '';
  for I := 1 to length(S) do
    case S[I] of
    #199 : Temp := Temp + 'C';
    #231 : Temp := Temp + 'c';
    #227 : Temp := Temp + 'a';
    #195 : Temp := Temp + 'A';
    #225 : Temp := Temp + 'a';
    #193 : Temp := Temp + 'A';
    #226 : Temp := Temp + 'a';
    #194 : Temp := Temp + 'A';
    #224 : Temp := Temp + 'a';
    #192 : Temp := Temp + 'A';
    #233 : Temp := Temp + 'e';
    #201 : Temp := Temp + 'E';
    #234 : Temp := Temp + 'e';
    #202 : Temp := Temp + 'E';
    #232 : Temp := Temp + 'e';
    #200 : Temp := Temp + 'E';
    #237 : Temp := Temp + 'i';
    #205 : Temp := Temp + 'I';
    #213 : Temp := Temp + 'O';
    #245 : Temp := Temp + 'o';
    #243 : Temp := Temp + 'o';
    #211 : Temp := Temp + 'O';
    #244 : Temp := Temp + 'o';
    #212 : Temp := Temp + 'O';
    #242 : Temp := Temp + 'o';
    #210 : Temp := Temp + 'O';
    #250 : Temp := Temp + 'u';
    #218 : Temp := Temp + 'U';
    #252 : Temp := Temp + 'u';
    #220 : Temp := Temp + 'U';
      else Temp := Temp + S[I];
    end;
  SemAcento := Temp;
end;

function TSearchCID.PegaTexto(Desloc:integer):string;
var
  Temp  : string;
  Lidos : integer;
begin
  seek(ArqTexto,Desloc);
  SetLength(Temp, StrMax);
  blockread(Arqtexto,Temp[1],StrMax,Lidos);
  SetLength(Temp, Lidos);
  SetLength(Temp, pos(chr($0D),Temp)-1);
  PegaTexto := Temp;
end;


function TSearchCID.PosSep(Tex:string):integer;
var Pi,Pe:integer;
begin
  Pi:=pos('|',Tex);
  Pe:=pos('\',Tex);
  if Pi>0
    then
      if Pe>0
        then
          if Pi<Pe
            then Result:=Pi
            else Result:=Pe
        else Result:=Pi
    else
      if Pe>0
        then Result:=Pe
        else Result:=StrMax;
end;

procedure TSearchCID.Search;
var Temp,Tex,Aux: string;
    I,Brc: integer;
begin
  FLista.Clear;
  FDetalheCID.Clear;
  FQtdOcorrencias := 0;
  FCodigoEscolhido:= '';
  Temp := trim(UpperCase(SemAcento(FChave)));

  if Temp = ''
    then
      begin
        FCodigoEscolhido := '';
        exit;
      end;

  //Poe um asterisco no fim
  if FPesquisaAutomatica then
     begin
     if Length (Temp) > 2 then
        begin
        Aux:=FChave;
        if (LastChar=' ') and
           (Aux[length (Aux)]='*') and
           (Aux[length (Aux)-1]=' ') then
           begin
           Aux[length (Aux)-1]:='*';
           Aux[length (Aux)]:=' ';
           FChave:=Aux;
           end;

        if LastDelimiter ('*',Temp) < length (FChave) then
          begin
          FChave:=FChave + '*';
          Temp:=Temp + '*';
          end;
        end
     else
        begin
        if Length (Temp) = 1 then exit;
        if LastDelimiter ('*',Temp) > 0 then
           begin
           Temp:= Copy (Temp,0,Length(Temp)-1);
           FChave:=Copy (FChave,0,Length(FChave)-1);
           end;
        end;
     end;

  {Primeira palavra}
  PegaPalavra(Temp,Palavra);
  //Correcao do bug do * sozinho
  if (Palavra[length(Palavra)] = '*') and (Palavra <> '*')
    then PegaAsterisco(Palavra,ListOcorr^)
    else if IndexFind(IndPalavra,Palavra,Location,EsteIndice)
           then CarregaOcorr(EsteIndice,ListOcorr^)
           else ListOcorr^[0] := 0;
  {eventuais outras palavras}
  while PegaPalavra(Temp,Palavra) do
    begin
      //Correcao do bug do * sozinho
      if (Palavra[length(Palavra)] = '*') and (Palavra <> '*')
        then PegaAsterisco(Palavra,EstaOcorr^)
        else if IndexFind(IndPalavra,Palavra,Location,EsteIndice)
               then CarregaOcorr(EsteIndice,EstaOcorr^)
               else EstaOcorr^[0] := 0;
      ANDLogico(ListOcorr^,EstaOcorr^,TempOcorr^);
      for I := 0 to TempOcorr^[0] do ListOcorr^[I] := TempOcorr^[I];
    end;
  NumOcorr := ListOcorr^[0];
  if NumOcorr > 0 then
    begin
      FQtdOcorrencias := NumOcorr;
      for I := 1 to NumOcorr do
        begin
          S := PegaTexto(ListOcorr^[I]);
          Tex := S;
          Tex := copy(S,1,possep(Tex)-1);
          Brc := pos(' ',Tex);
          case Brc of                  {alinha textos na tela superior}
            6: insert('   ',Tex,Brc);
            7: insert(' ',Tex,Brc);
            else insert('      ',Tex,Brc);
          end;
          FLista.Add(' ' + Tex);  {escreve na tela superior}
        end;
    end
  else   {se não encontrou nenhuma ocrrência}
    FQtdOcorrencias := 0;
end;

function TSearchCID.minimo(Pi,Pe:pchar):pchar;
begin
  TemBarra := true;
  Prox := false;
  if (Pi <> nil) and (Pe = nil)
    then
      begin
      Result := Pi;
      Prox := false;
      exit;
      end;
  if (Pi = nil) and (Pe <> nil)
    then
      begin
      Result := Pe;
      Prox :=true;
      exit;
      end;
  if (Pi = nil) and (Pe = nil)
    then
      begin
      Result := nil;
      Prox := false;
      exit;
      end;
  if Pi <= Pe
    then
      begin
      Result := Pi;
      Prox := false;
      end
    else
      begin
      Result := Pe;
      Prox := true;
      end;
end;

procedure TSearchCID.ListaShowItem(ItemIndex:integer);
var
  Tex , Dscr: string;
  Buffer: array[1..StrMax] of char;
  I, Lidos: integer;
  PS, Barra, Pinc, Pexc: PChar;
  Ncar, tam : integer;
begin
  if (0 > ItemIndex) or (ItemIndex >= FLista.Count) then
     exit;
  SelectedItemIndex:=ItemIndex;

  TemBarra := false;
  Exclusao := false;
  TextoExc := false;
  Tex := copy(FLista.Strings[SelectedItemIndex],2,StrMax); {pula branco}
  Ncar := pos(' ',Tex); {guarda número de caracteres do código CID}
  FCodigoEscolhido := '';
  FCodigoEscolhido := copy(Tex,1,Ncar-1);  {atualiza código CID}
  TextDescrCID:=copy(FLista.Strings[SelectedItemIndex],Ncar+1,StrMax); {pula branco}
  TextDescrCID:=Trim(TextDescrCID);
  tam := length(tex);
  dscr := copy(tex,ncar,tam - 1);
  Seek(ArqTexto,ListOcorr^[SelectedItemIndex+1]);
  blockread(ArqTexto,Buffer,Sizeof(Buffer),Lidos);
  PS := @Buffer;
  for I := 1 to Lidos do    {marca com zero o fim da linha no Buffer}
    if Buffer[I] = chr($0D) then
      begin
        Buffer[I] := chr(0);
        break;
      end;
  Barra := nil;
  Pinc := strPos(PS,'|');
  Pexc := strPos(PS,'\');
  if (Pinc <> nil) or (Pexc <> nil)
  then
    begin
      Barra := minimo(Pinc,Pexc);  {marca a posição da próxima barra}
      Barra[0] := char(0);
    end;
  PS := PS + Ncar; {elimina código do texto}
  FDetalheCID.clear;
  FDetalheCID.SelAttributes.Style := [fsBold];
  FDetalheCID.SelAttributes.Size := 10;
  FDetalheCID.lines.add(strpas(PS)); {escreve o título da descrição}
  FDetalheCID.SelAttributes.Style := [];
  FDetalheCID.SelAttributes.Size := 8;
  while Barra <> nil do
    begin
      PS := Barra + 1;
      Pinc := strpos(PS,'|');
      Pexc := strpos(PS,'\');
      Barra := minimo(Pinc,Pexc); {marca a posição da próxima barra}
      if Barra <> nil
        then Barra[0] := char(0);
      Monta(strpas(PS));  {monta as linhas da descrição}
      if Exclusao = false
        then Exclusao := Prox;
    end;
  Terminou := false;
  BoldNota;
  TrocaChar;
  Terminou := true;
  TemChDup := false;
  TemChave := false;
end;

procedure TSearchCID.ChaveDupla(PosTab,PosSep,Ch1,Ch2:integer;
                     Tex:string; var Lin:string);
begin
  if PosTab > 0
    then Lin:= Lin + chr(Ch1) + '   '
               + copy(Tex,PosSep+3,PosTab-PosSep-2)
               + chr(Ch2) + '   '
               + copy(Tex,PosTab+1,StrMax)
    else Lin:= Lin + chr(Ch1) + '   '
               + copy(Tex,PosSep+3,StrMax)
               + chr(09) + chr(Ch2);
end;

procedure TSearchCID.Mostra(PosSep:integer; Tex:string; Indent:string);
var PosTab: integer;
    Lin, TipoSep: string;
begin
  if  PosSep > 0
    then
      begin
      TemChave:= true;
      TipoSep:= copy(Tex,PosSep,3);
      Lin:= copy(Tex,1,PosSep-1) + chr(09);
      if TipoSep = '@<@'
        then Lin:= Lin + chr(130)                    {cabeça da chave}
        else if (TipoSep = '@#@') and (ChDup = false)
        then Lin:= Lin + chr(166)                    {meio da chave}
        else if TipoSep = '@>@'
        then Lin:= Lin + chr(254)                    {fim da chave}
        else if TipoSep = '@1@'
        then
          begin
          PosTab:= pos(chr(09),Tex);
          ChaveDupla(PosTab,PosSep,130,131,Tex,Lin);
          ChDup:= true;
          TemChDup:= true;
          FDetalheCID.lines.add('    ' + Indent + Lin);
          exit;
          end
        else if TipoSep = '@2@'
        then
          begin
          PosTab:= pos(chr(09),Tex);
          ChaveDupla(PosTab,PosSep,254,132,Tex,Lin);
          ChDup:= false;
          FDetalheCID.lines.add('    ' + Indent + Lin);
          exit;
          end
        else if (TipoSep = '@#@') and (ChDup = true)
        then
          begin
          PosTab:= pos(chr(09),Tex);
          ChaveDupla(PosTab,PosSep,166,166,Tex,Lin);
          FDetalheCID.lines.add('    ' + Indent + Lin);
          exit;
          end;
      Lin:= Lin + '   ' + copy(Tex,PosSep+3,StrMax);
      end
    else Lin:= Tex;
  FDetalheCID.lines.add('    ' + Indent + Lin);
end;

procedure TSearchCID.Monta(Tex:string);
var 
    PosSep : integer;
begin
  PosSep:= pos('@',Tex);
  if (Exclusao = false) and (TemBarra = true) {termos de inclusão}
     then
       begin
       Mostra(PosSep,Tex,'');
       exit;
       end;
  if (Exclusao = true) and (TemBarra = true)  {termos de exclusão}
     then
       begin
         if TextoExc = false then
           begin
             FDetalheCID.SelAttributes.Style := [fsBold,fsItalic];
             FDetalheCID.lines.add('     Exclui:');
             FDetalheCID.SelAttributes.Style := [];
             TextoExc := true;
           end;
       Mostra(PosSep,Tex,'            ');
       end;
end;

procedure TSearchCID.BoldNota;
var P: integer;
begin
  P := FDetalheCID.Findtext('Nota:',1,StrMax,[]);
  if P > 0
    then
      begin
      FDetalheCID.SelStart:= P;
      FDetalheCID.SelLength:= 5;
      FDetalheCID.SelAttributes.Style := [fsBold,fsItalic];
      FDetalheCID.SelStart:= 0;
      FDetalheCID.SelLength:= 0;
      FDetalheCID.SelAttributes.Style := [];
      end;
end;

procedure TSearchCID.TrocaChar;
var P: integer;
begin
  if TemChave = false
    then exit;
  P:= -1;
  repeat
    P:= FDetalheCID.Findtext(chr(130),P+1,StrMax,[]);  {cabeça da chave}
    FDetalheCID.SelStart:= P;
    FDetalheCID.SelLength:= 1;
    FDetalheCID.SelAttributes.Name:= 'Symbol';
    if P <> -1 then FDetalheCID.SelText:= chr(252);
  until P = -1;
  repeat
    P:= FDetalheCID.Findtext(chr(166),P+1,StrMax,[]);  {meio da chave}
    FDetalheCID.SelStart:= P;
    FDetalheCID.SelLength:= 1;
    FDetalheCID.SelAttributes.Name:= 'Symbol';
    if P <> -1 then FDetalheCID.SelText:= chr(239);
  until P = -1;
  repeat
    P:= FDetalheCID.Findtext(chr(254),P+1,StrMax,[]);  {fim da chave}
    FDetalheCID.SelStart:= P;
    FDetalheCID.SelLength:= 1;
    FDetalheCID.SelAttributes.Name:= 'Symbol';
  until P = -1;
  if TemChDup = true
  then
    begin
    repeat
      P:= FDetalheCID.Findtext(chr(131),P+1,StrMax,[]);  {fim da chave}
      FDetalheCID.SelStart:= P;
      FDetalheCID.SelLength:= 1;
      FDetalheCID.SelAttributes.Name:= 'Symbol';
      if P <> -1 then FDetalheCID.SelText:= chr(236);
    until P = -1;
    repeat
      P:= FDetalheCID.Findtext(chr(132),P+1,StrMax,[]);  {fim da chave}
      FDetalheCID.SelStart:= P;
      FDetalheCID.SelLength:= 1;
      FDetalheCID.SelAttributes.Name:= 'Symbol';
      if P <> -1 then FDetalheCID.SelText:= chr(238);
    until P = -1;
    end;
  FDetalheCID.SelAttributes.Name:= 'Arial';
  FDetalheCID.SelStart:= 0;
  FDetalheCID.SelLength:= 0;
end;

procedure TSearchCID.DetalheSelectionChange(Sender: TObject);
begin
  if (FDetalheCID.SelLength > 0) and (Terminou = true)
    then
      if LastDelimiter (' ',FDetalheCID.SelText) = 0 then
         begin
         FChave := FDetalheCID.SelText;
         Search;
         end;
end;

procedure TSearchCID.SearchCodigoEscolhido;
begin
if FCodigoEscolhido <> ''
  then
    begin
      FChave := copy(FCodigoEscolhido,1,3);
      Search;
    end;
end;

procedure TSearchCID.SetPesquisaAutomatica (const Value: boolean);
begin

FPesquisaAutomatica:=Value;

if FPesquisaAutomatica then
   begin
//   FChave.OnChange := Search;
   end
else
   begin
//   FChave.OnChange := nil;
   end;
end;

procedure TSearchCID.ListaSelect;
begin
//
end;

procedure TSearchCID.CopyToClipboard;
var
Texto : string;
begin
Texto :=FLista.Strings[SelectedItemIndex];

if LastDelimiter(#134,Texto) > 0 then
   Texto [LastDelimiter(#134,Texto)]:='+';

Clipboard.SetTextBuf(PChar(Texto));
end;


//Componente PesqCID
procedure Register;
begin
  RegisterComponents('Samples', [TSearchCID]);
end;


destructor TSearchCID.Destroy;
begin
if Assigned (FDetalheCID) then
   FDetalheCID.Free;

FLista.Free;

inherited;
end;


procedure TSearchCID.SetDiretorioCID(const Value: string);
var
  tam : integer;
begin
  FDiretorioCID := Trim(Value);
  if FDiretorioCID='' then
     exit;
  tam := length(FDiretorioCID);
  if copy (FDiretorioCID,tam,1) <> '\' then
     FDiretorioCID := FDiretorioCID + '\';
end;

procedure TSearchCID.SetPesquisaInicial(const Value: string);
begin
  FPesquisaInicial := Value;
end;


{procedure TSearchCID.LoadControlBitmap;
begin
FBitMap.LoadFromResourceName(HInstance, 'TSearchCIDX');
end;
procedure TSearchCID.Paint;
//
//          Metodo para pintar o quadro do bitmap
//
var
  Rect: TRect;
begin
  inherited Paint;
  Width  := 24;
  Height := 24;
  Rect := GetClientRect;
  with Canvas do
  begin
    Brush.Color := clwhite;
    FillRect(Rect);
    Brush.Style := bscross ;
    Font := Self.Font;
    if not Assigned (FBitMap) then
       exit
    else
        Canvas.StretchDraw(Rect, FBitMap);
  end;
end;

procedure TSearchCID.WMSize(var Message: TWMSize);
begin
//Filtra mensagem de WMSize, nao deixa mudar o tamanho

// Width  := 24;
// Height := 24;

end;
}

procedure TSearchCID.SetArquivosCID(const Value: string);
begin
  FArquivosCID := Value;
end;


procedure TSearchCID.SetChave(const Value: string);
begin
  FChave := Value;
end;

procedure TSearchCID.SetCodigoEscolhido(const Value: string);
begin
  FCodigoEscolhido := Value;
end;

procedure TSearchCID.SetDetalheCID(const Value: TRichEdit);
begin
//ReadOnly
//  FDetalheCID := Value;
end;

procedure TSearchCID.SetLista(const Value: TStringList);
begin
  FLista := Value;
end;

procedure TSearchCID.SetQtdOcorrencias(const Value: integer);
begin
  FQtdOcorrencias := Value;
end;

function TSearchCID.ConnectDictionary(const UserID,
  UserPassword: WideString): TOleBool;stdcall;
begin
Result:=inherited ConnectDictionary(UserID,UserPassword);
if not Result then exit;
if not Initialized then
   InitDic;
if SemDic then
  begin
  showmessage('Arquivo '+ NomeDic +' não encontrado');
  end;
  FDetalheCID.Paragraph.Tab[0]:= 150;
  FDetalheCID.Paragraph.Tab[1]:= 300;
  FDetalheCID.Paragraph.Tab[2]:= 450;
  FDetalheCID.Paragraph.Tab[3]:= 600;
end;

procedure TSearchCID.DisconnectDictionary;
begin
inherited;
end;

function TSearchCID.FindCodeByDescription(var Code: WideString;
  const Description: WideString): Smallint;
var
AuxDesc: string;
begin
AuxDesc:=Description;
if AuxDesc[1]='%' then
   AuxDesc[1]:=' ';
if AuxDesc[Length(AuxDesc)]='%' then
   AuxDesc[Length(AuxDesc)]:=' ';
AuxDesc:=Trim(AuxDesc);

Chave:=AuxDesc;
Code:='';
Search;
Result:=FQtdOcorrencias;
if Result > 0 then
   ListaShowItem (0);
Code:=FCodigoEscolhido;
end;

function TSearchCID.GetFirstCodeByDesc(var Code,
  Description: WideString): TOleBool;
begin
Result:=False;

Code:='';
Description:='';

if FQtdOcorrencias > 0 then
   ListaShowItem (0)
else
    exit;

Code:=FCodigoEscolhido;
Description:=TextDescrCID;
Result:=True;
end;

function TSearchCID.GetNextCodeByDesc(var Code,
  Description: WideString): TOleBool;
begin
  Result:=False;

  Code:='';
  Description:='';

  if SelectedItemIndex >= FQtdOcorrencias then
     exit;

  Result:=True;
  SelectedItemIndex:=SelectedItemIndex+1;

  ListaShowItem (SelectedItemIndex);
  Code:=FCodigoEscolhido;
  Description:=TextDescrCID;

end;

procedure TSearchCID.Loaded;
begin
  inherited;
  FDetalheCID.Name := 'RichEdit'+Name;
end;

//Rotinas do arquivo Index32
procedure TSearchCID.CriaIndex(var Ind:TipoIndex;Tamanho:integer);
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

function TSearchCID.IndexFind(var L:TipoIndex;Chave:string;var Posicao:integer;var EsteIndice:integer):boolean;
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

function TSearchCID.InsereIndex(var Ind:TipoIndex;S:string;EsteIndice:integer):boolean;
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

{ Quando precisar é só tirar o comentário
Procedure TSearchCID.RemoveIndex(var Ind:TipoIndex);
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
end; }{RemoveIndex}

end.

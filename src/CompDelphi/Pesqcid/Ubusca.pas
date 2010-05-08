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






     { Desenvolvido por:

                    Ernani Bento Bandarra
                    Celso Escobar Pinheiro

       Versão Componente:
                    Edinaldo Pereira dos Santos
                    Fabio Jacob Ribeiro
                    Isabel Cristina da Silva Pereira
                    Rosana Pinto
                    Sonia Bochner Araujo
                    Gilmar Martins de Azeredo

                                DATASUS - RJ - 06/04/1999 }



unit Ubusca;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, Index32, ComCtrls;

type
  TBuscaCodigo = class(TForm)
    paPeqsquisa: TPanel;
    bProcura: TBitBtn;
    lbQtd: TLabel;
    Lista: TListBox;
    lbPesquisar: TLabel;
    cbChave: TComboBox;
    bAtivaDicionario: TSpeedButton;
    SalvaGlyph1: TSpeedButton;
    SalvaGlyph2: TSpeedButton;
    lbQtdValor: TLabel;
    paCodigo: TPanel;
    lbDescricao: TLabel;
    Detalhe: TRichEdit;
    lbCodigoEscolhido: TLabel;
    paBotoes: TPanel;
    btOK: TBitBtn;
    btCancela: TBitBtn;
    btHelp: TBitBtn;
    btSair: TBitBtn;
    lbExemplo: TLabel;
    chbxPAutomatica: TCheckBox;
    lbResPesquisa: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bProcuraClick(Sender: TObject);
    procedure ListaClick(Sender: TObject);
    procedure bAtivaDicionarioClick(Sender: TObject);
    procedure Monta(Tex:string);
    procedure TrocaChar;
    procedure BoldNota;
    function PosSep(Tex:string):integer;
    procedure DetalheSelectionChange(Sender: TObject);
    procedure lbCodigoEscolhidoDblClick(Sender: TObject);
    procedure Mostra(PosSep:integer; Tex:string; Indent:string);
    procedure cbChaveKeyPress(Sender: TObject; var Key: Char);
    procedure btOKClick(Sender: TObject);
    procedure DetalheMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chbxPAutomaticaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListaDblClick(Sender: TObject);


  private
    { Private declarations }
    LastChar :Char;
    PAutoOld :boolean;
    SemDic:boolean;
  public
    { Public declarations }
  end;

  TCloseCIDQueryEvent = procedure (Sender: TComponent; NewCID : string ; var CanClose: Boolean)  of object ;
  TPesqCid = class(TComponent)
  private
    FHelpContext: integer;
    FDiretorioCID: string;
    FCodigoCID: string;
    FPesquisaInicial: string;
    FDescricaoCID: string;

    FOnCanClose: TCloseCIDQueryEvent;
    FOnClose: TnotifyEvent;
    FOnShow: TnotifyEvent;
    FDetalheCID: string;
    FFormHeight: Integer;
    FFormTop: Integer;
    FFormLeft: Integer;
    FFormWidth: Integer;
    FFormPosition: TPosition;
    FFormWindowState: TWindowState;
    FPesquisaAutomatica: boolean;
    procedure SetCodigoCID(const Value: string);
    procedure SetDescricaoCID(const Value: string);
    procedure SetDiretorioCID(const Value: string);
    procedure SetHelpContext(const Value: integer);
    procedure SetOnCanClose(const Value: TCloseCIDQueryEvent);
    procedure SetOnClose(const Value: TnotifyEvent);
    procedure SetOnShow(const Value: TnotifyEvent);
    procedure SetPesquisaInicial(const Value: string);
    procedure SetDetalheCID(const Value: string);
    procedure SetFormHeight(const Value: Integer);
    procedure SetFormLeft(const Value: Integer);
    procedure SetFormPosition(const Value: TPosition);
    procedure SetFormTop(const Value: Integer);
    procedure SetFormWidth(const Value: Integer);
    procedure SetFormWindowState(const Value: TWindowState);
    procedure SetPesquisaAutomatica(const Value: boolean);
    { Private declarations }
  protected
    { Protected declarations }
    FTelaCid : TBuscaCodigo;
//    procedure LoadControlBitmap;override;
  public
    { Public declarations }

    Constructor Create(AOwner:TComponent);override;
    Function Execute : boolean;
    Destructor Destroy ; override;

 // Obs : Os filhos : Vão Ter filtros de CID ( por capítulos, etc).


  published
    { Published declarations }
    //Form properties
    property FormWindowState :TWindowState read FFormWindowState write SetFormWindowState default wsNormal;
    property FormPosition : TPosition read FFormPosition write SetFormPosition default poScreenCenter;
    property FormTop : Integer read FFormTop write SetFormTop default 10;
    property FormLeft : Integer read FFormLeft write SetFormLeft default 10;
    property FormWidth : Integer read FFormWidth write SetFormWidth default 620;
    property FormHeight : Integer read FFormHeight write SetFormHeight default 450;

    property PesquisaAutomatica : boolean read FPesquisaAutomatica write SetPesquisaAutomatica default True;

    //Propriedades Read Only
    property CodigoCID : string read FCodigoCID write SetCodigoCID;
    property DescricaoCID :  string read FDescricaoCID write SetDescricaoCID;
    property DetalheCID : string read FDetalheCID write SetDetalheCID;

    property DiretorioCID : string read FDiretorioCID write SetDiretorioCID;
           // Se branco usa diretório corrente da aplicação,
           // Se ActiveX, usa o diretório de instalação do ActiveX.
    property HelpContext : integer read FHelpContext write SetHelpContext;
    property PesquisaInicial : string read FPesquisaInicial write SetPesquisaInicial;
    property OnCanClose  : TCloseCIDQueryEvent  read FOnCanClose write SetOnCanClose;
    property OnClose : TnotifyEvent read FOnClose write SetOnClose;
    property OnShow : TnotifyEvent read FOnShow write SetOnShow;

 end;
procedure Register;

var
  BuscaCodigo: TBuscaCodigo;
  Terminou, ChDup, TemChDup, TemChave: boolean;
  Rota : string;
  TextDescrCID : string;

implementation

{$R *.DFM}

type
  tipoOcorr = array[0..16382] of integer;    {máximo de 16382 ocorrencias da mesma palavra}
  pOcorr = ^tipoOcorr;
Var
  IndPalavra: tipoIndex;
  Palavra, S, NomeDic, NomeTxt, NomeInv: string;
  NumOcorr, NumPal, MaxPal, MaxOcorr, Location, EsteIndice: integer;
  Entrada: text;
  ArqTexto, ArqInv: file;
  ListOcorr, TempOcorr, EstaOcorr: pOcorr;
  DicionarioAtivo, Exclusao, Prox, TemBarra, TextoExc: boolean;

const
  Maximo = 15000;
{  TamL = 25;
  Lista: array[1..TamL] of string =
   ('AO','AOS','AS','DA','DAS','DE','DO','DOS','E','EM','ENTRE','NA',
    'NAS','NO','NOS','O','OS','OU','POR','PARA','PELO','PELA','PELOS',
    'PELAS','QUE');}
  StrMax = 2000;

function GetToken(var S: string): string;
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

{ TBuscaCodigo }
procedure TBuscaCodigo.FormCreate(Sender: TObject);
begin
  {encontra arquivo .dic}
  DicionarioAtivo := false;
  LastChar:=char(0);
  PAutoOld :=True;
  SemDic:=False;

//  if paramcount = 1
//    then NomeDic := paramstr(1)
//    else
    NomeDic := rota + 'cid10n4a.dic';
  if not FileExists(NomeDic) then
    begin
      SemDic:=True;
      exit;
    end;
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
      showmessage('Arquivo '+NomeTxt+' não encontrado');
      halt;
    end;
  assignfile(ArqTexto,NomeTxt);
  reset(ArqTexto,1); {Mantem aberto para BuscarTexto}
  NomeInv := changefileext(NomeDic,'.inv');
  if not FileExists(NomeInv) then
    begin
      showmessage('Arquivo '+NomeInv+' não encontrado');
      halt;
    end;
  assignfile(ArqInv,NomeInv);
  reset(ArqInv,1); {Mantem aberto para Invertido}
end;

procedure TBuscaCodigo.FormShow(Sender: TObject);
begin
  Detalhe.Paragraph.Tab[0]:= 150;
  Detalhe.Paragraph.Tab[1]:= 300;
  Detalhe.Paragraph.Tab[2]:= 450;
  Detalhe.Paragraph.Tab[3]:= 600;
end;

procedure TBuscaCodigo.FormActivate(Sender: TObject);
begin
if SemDic then
  begin
  showmessage('Arquivo '+ NomeDic +' não encontrado');
  Close;
  end
end;

{function ForaDoDic: boolean;
var I: integer;
begin
  Result := false;
  for I := 1 to TamL do
    if Palavra = Lista[I] then
      begin
        Result := true;
        Exit;
      end;
end;}

function PegaPalavra(var S,Palavra:String):boolean;
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

procedure ANDLogico(var A,B,Temp : TipoOcorr);
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

procedure ORLogico(var A,B,Temp : TipoOcorr);
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

procedure CarregaOcorr(var EsteIndice: integer; var EstaOcorr:tipoOcorr);
begin
  seek(ArqInv,EsteIndice);
  blockread(ArqInv,EstaOcorr[0],sizeof(integer));
  blockread(ArqInv,EstaOcorr[1],EstaOcorr[0]*sizeof(integer));
end;

procedure PegaAsterisco(Palavra:string; var Saida:tipoOcorr);
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

function SemAcento(S:String):String;
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

function PegaTexto(Desloc:integer):string;
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


function TBuscaCodigo.PosSep(Tex:string):integer;
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

procedure TBuscaCodigo.bProcuraClick(Sender: TObject);
var Temp,Tex,Aux: string;
    I,Brc: integer;
begin
  Lista.Clear;
  Detalhe.Clear;
  lbQtdValor.Caption := '...';
  lbQtdValor.Refresh;
  lbCodigoEscolhido.Caption := '';
  lbCodigoEscolhido.Refresh;
  Temp := trim(UpperCase(SemAcento(cbChave.text)));

  if Temp = ''
    then
      begin
        lbCodigoEscolhido.Caption := '';
        lbCodigoEscolhido.Refresh;
        exit;
      end;

  //Poe um asterisco no fim
  if chbxPAutomatica.Checked then
     begin
     if Length (Temp) > 2 then
        begin
        Aux:=cbChave.Text;
        if (LastChar=' ') and
           (Aux[length (Aux)]='*') and
           (Aux[length (Aux)-1]=' ') then
           begin
           Aux[length (Aux)-1]:='*';
           Aux[length (Aux)]:=' ';
           cbChave.Text:=Aux;
           end;

        if LastDelimiter ('*',Temp) < length (cbChave.Text) then
          begin
          cbChave.text:=cbChave.Text + '*';
          Temp:=Temp + '*';
          end;
        end
     else
        begin
        if Length (Temp) = 1 then exit; 
        if LastDelimiter ('*',Temp) > 0 then
           begin
           Temp:= Copy (Temp,0,Length(Temp)-1);
           cbChave.Text:=Copy (cbChave.Text,0,Length(cbChave.Text)-1);
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
      lbQtdValor.Caption := IntToStr(NumOcorr);
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
          Lista.Items.Add(' ' + Tex);  {escreve na tela superior}
        end;
        if visible then
           Lista.SetFocus;
      { Lista.ItemIndex := 0;
        ListaClick(bProcura); }
    end
  else   {se não encontrou nenhuma ocrrência}
    lbQtdValor.Caption := '0';
  if Visible then
     begin
     cbChave.SetFocus;
     if (LastDelimiter ('*',cbChave.Text) < length (cbChave.Text)) or
        (not chbxPAutomatica.Checked) then
        cbChave.SelStart := length (cbChave.Text)
     else
         cbChave.SelStart:=Length(cbChave.Text)-1;
     cbChave.SelLength :=0;
     end;
end;

function minimo(Pi,Pe:pchar):pchar;
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

procedure TBuscaCodigo.ListaClick(Sender: TObject);
var
  Tex , Dscr: string;
  Buffer: array[1..StrMax] of char;
  I, Lidos: integer;
  PS, Barra, Pinc, Pexc: PChar;
  Ncar, tam : integer;
begin
  TemBarra := false;
  Exclusao := false;
  TextoExc := false;
  Tex := copy(Lista.Items[Lista.ItemIndex],2,StrMax); {pula branco}
  Ncar := pos(' ',Tex); {guarda número de caracteres do código CID}
  lbCodigoEscolhido.caption := '';
  paCodigo.repaint;
  lbCodigoEscolhido.caption := copy(Tex,1,Ncar-1);  {atualiza código CID}
  TextDescrCID:=copy(Lista.Items[Lista.ItemIndex],Ncar+1,StrMax); {pula branco}
  TextDescrCID:=Trim(TextDescrCID);
  tam := length(tex);
  dscr := copy(tex,ncar,tam - 1);
  lbCodigoEscolhido.repaint;
  Seek(ArqTexto,ListOcorr^[Lista.ItemIndex+1]);
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
  Detalhe.clear;
  Detalhe.SelAttributes.Style := [fsBold];
  Detalhe.SelAttributes.Size := 10;
  Detalhe.lines.add(strpas(PS)); {escreve o título da descrição}
  Detalhe.SelAttributes.Style := [];
  Detalhe.SelAttributes.Size := 8;
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
  Lista.SetFocus;
end;

procedure ChaveDupla(PosTab,PosSep,Ch1,Ch2:integer;
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

procedure TBuscaCodigo.Mostra(PosSep:integer; Tex:string; Indent:string);
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
          Detalhe.lines.add('    ' + Indent + Lin);
          exit;
          end
        else if TipoSep = '@2@'
        then
          begin
          PosTab:= pos(chr(09),Tex);
          ChaveDupla(PosTab,PosSep,254,132,Tex,Lin);
          ChDup:= false;
          Detalhe.lines.add('    ' + Indent + Lin);
          exit;
          end
        else if (TipoSep = '@#@') and (ChDup = true)
        then
          begin
          PosTab:= pos(chr(09),Tex);
          ChaveDupla(PosTab,PosSep,166,166,Tex,Lin);
          Detalhe.lines.add('    ' + Indent + Lin);
          exit;
          end;
      Lin:= Lin + '   ' + copy(Tex,PosSep+3,StrMax);
      end
    else Lin:= Tex;
  Detalhe.lines.add('    ' + Indent + Lin);
end;

procedure TBuscaCodigo.Monta(Tex:string);
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
             Detalhe.SelAttributes.Style := [fsBold,fsItalic];
             Detalhe.lines.add('     Exclui:');
             Detalhe.SelAttributes.Style := [];
             TextoExc := true;
           end;
       Mostra(PosSep,Tex,'            ');
       end;
end;

procedure TBuscaCodigo.BoldNota;
var P: integer;
begin
  P := Detalhe.Findtext('Nota:',1,StrMax,[]);
  if P > 0
    then
      begin
      Detalhe.SelStart:= P;
      Detalhe.SelLength:= 5;
      Detalhe.SelAttributes.Style := [fsBold,fsItalic];
      Detalhe.SelStart:= 0;
      Detalhe.SelLength:= 0;
      Detalhe.SelAttributes.Style := [];
      end;
end;

procedure TBuscaCodigo.TrocaChar;
var P: integer;
begin
  if TemChave = false
    then exit;
  Detalhe.SetFocus;
  P:= -1;
  repeat
    P:= Detalhe.Findtext(chr(130),P+1,StrMax,[]);  {cabeça da chave}
    Detalhe.SelStart:= P;
    Detalhe.SelLength:= 1;
    Detalhe.SelAttributes.Name:= 'Symbol';
    if P <> -1 then Detalhe.SelText:= chr(252);
  until P = -1;
  repeat
    P:= Detalhe.Findtext(chr(166),P+1,StrMax,[]);  {meio da chave}
    Detalhe.SelStart:= P;
    Detalhe.SelLength:= 1;
    Detalhe.SelAttributes.Name:= 'Symbol';
    if P <> -1 then Detalhe.SelText:= chr(239);
  until P = -1;
  repeat
    P:= Detalhe.Findtext(chr(254),P+1,StrMax,[]);  {fim da chave}
    Detalhe.SelStart:= P;
    Detalhe.SelLength:= 1;
    Detalhe.SelAttributes.Name:= 'Symbol';
  until P = -1;
  if TemChDup = true
  then
    begin
    repeat
      P:= Detalhe.Findtext(chr(131),P+1,StrMax,[]);  {fim da chave}
      Detalhe.SelStart:= P;
      Detalhe.SelLength:= 1;
      Detalhe.SelAttributes.Name:= 'Symbol';
      if P <> -1 then Detalhe.SelText:= chr(236);
    until P = -1;
    repeat
      P:= Detalhe.Findtext(chr(132),P+1,StrMax,[]);  {fim da chave}
      Detalhe.SelStart:= P;
      Detalhe.SelLength:= 1;
      Detalhe.SelAttributes.Name:= 'Symbol';
      if P <> -1 then Detalhe.SelText:= chr(238);
    until P = -1;
    end;
  Detalhe.SelAttributes.Name:= 'Arial';
  Detalhe.SelStart:= 0;
  Detalhe.SelLength:= 0;
end;

procedure TBuscaCodigo.bAtivaDicionarioClick(Sender: TObject);
var
I : integer;
begin
  if DicionarioAtivo then
    begin
      DicionarioAtivo := false;
      bAtivaDicionario.Hint := 'Abrir Dicionário';
      cbChave.Items.Clear;
      bAtivaDicionario.Glyph.Assign(SalvaGlyph1.Glyph);
      chbxPAutomatica.Checked := PAutoOld;
    end
  else
    begin
      DicionarioAtivo := true;
      PAutoOld:=chbxPAutomatica.Checked;
      chbxPAutomatica.Checked:=False;
      bAtivaDicionario.Hint := 'Fechar dicionário';
      for I := 1 to MaxPal do
        cbChave.Items.Add(LowerCase(IndPalavra.Entry^[I].Texto^));
      bAtivaDicionario.Glyph.Assign(SalvaGlyph2.Glyph);
      cbChave.DroppedDown := True;
    end;
end;

procedure TBuscaCodigo.DetalheSelectionChange(Sender: TObject);
begin
  if (Detalhe.SelLength > 0) and (Terminou = true)
    then
      if LastDelimiter (' ',Detalhe.SelText) = 0 then
         begin
         cbChave.Text := Detalhe.SelText;
         bProcuraClick(Detalhe);
         end;
end;

procedure TBuscaCodigo.lbCodigoEscolhidoDblClick(Sender: TObject);
begin
if lbCodigoEscolhido.Caption <> ''
  then
    begin
      cbChave.Text := copy(lbCodigoEscolhido.Caption,1,3);
      bProcuraClick(lbCodigoEscolhido);
    end;
end;

procedure TBuscaCodigo.cbChaveKeyPress(Sender: TObject; var Key: Char);
begin
 if ord(Key)=13 then
    bProcuraClick(self);
 LastChar :=Key;
end;

procedure TBuscaCodigo.btOKClick(Sender: TObject);
begin
if LastDelimiter ('-',lbCodigoEscolhido.Caption ) >0 then
   begin
   ShowMessage ('O código escolhido é uma categoria.'+#13#10+'Escolha um código de subcategoria.');
   ModalResult :=0;
   end
end;

procedure TBuscaCodigo.DetalheMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

//Componente PesqCID
procedure Register;
begin
  RegisterComponents('Samples', [TPesqCid]);
end;

{ TPesqCid }

constructor TPesqCid.Create(AOwner: TComponent);
begin
  inherited;
  FFormPosition:=poScreenCenter;
  FFormWindowState:=wsNormal;
  FFormTop:=10;
  FFormLeft:=10;
  FFormWidth:=620;
  FFormHeight:=450;
  FPesquisaAutomatica:=True;
end;

destructor TPesqCid.Destroy;
begin
  inherited;
end;

function TPesqCid.Execute: boolean;
var
PesqForm :TBuscaCodigo;
CanClose : Boolean;
Digitos : set of '0'..'9';
begin
   Digitos:=['0','1','2','3','4','5','6','7','8','9'];
   //Cria o formulario
   PesqForm:=TBuscaCodigo.create(self);
   PesqForm.btSair.Visible :=False;
   PesqForm.paBotoes.Visible :=True;

   //Acerta as propriedades de tamanho e posicao
   PesqForm.Top := FFormTop;
   PesqForm.Left := FFormLeft;
   PesqForm.Height := FFormHeight;
   PesqForm.Width := FFormWidth ;

   PesqForm.WindowState := FFormWindowState;
   PesqForm.Position := FFormPosition;

   PesqForm.chbxPAutomatica.Checked:=FPesquisaAutomatica;
   PesqForm.cbChave.Text := FPesquisaInicial;
   PesqForm.bProcura.Click;

repeat
 begin
 if Assigned (OnShow) then
    OnShow(self);
 PesqForm.ShowModal;
 if PesqForm.ModalResult = mrOk then
    begin
      CanClose:=True;
      if Assigned(OnCanClose) then
         OnCanClose(self,PesqForm.lbCodigoEscolhido.Caption,CanClose);
      if CanClose then
         begin
         FCodigoCID := PesqForm.lbCodigoEscolhido.Caption ;
         if (Length(FCodigoCID) > 0) and not (FCodigoCID[Length(FCodigoCID)] in Digitos) then
            FCodigoCID:=copy (FCodigoCID,1,Length(FCodigoCID)-1);
         FDescricaoCID:= TextDescrCID;
         FDetalheCID:=PesqForm.Detalhe.Text;
         FPesquisaInicial := PesqForm.cbChave.Text;
         result := true
         end
      else
         result := false;
    end
   else
    begin
    result := false;
    CanClose:=True;
    end;
 end;
until (CanClose);

 if Assigned (OnClose) then
    OnClose(self);

   PesqForm.free;
end;

procedure TPesqCid.SetCodigoCID(const Value: string);
begin
//Read Only, nao faz nada
end;

procedure TPesqCid.SetDescricaoCID(const Value: string);
begin
//Read Only, nao faz nada
end;

procedure TPesqCid.SetDiretorioCID(const Value: string);
var
  tam : integer;
begin
  Rota := Value;
  tam := length(rota);
  if copy (rota,tam,1) <> '\' then
     rota := rota + '\';
  FDiretorioCID := Rota;
end;

procedure TPesqCid.SetHelpContext(const Value: integer);
begin
  FHelpContext := Value;
end;

procedure TPesqCid.SetOnCanClose(const Value: TCloseCIDQueryEvent);
begin
  FOnCanClose := Value;
end;

procedure TPesqCid.SetOnClose(const Value: TnotifyEvent);
begin
  FOnClose := Value;
end;

procedure TPesqCid.SetOnShow(const Value: TnotifyEvent);
begin
  FOnShow := Value;
end;

procedure TPesqCid.SetPesquisaInicial(const Value: string);
begin
  FPesquisaInicial := Value;
end;

procedure TPesqCid.SetDetalheCID(const Value: string);
begin
//Read Only, nao faz nada
end;


procedure TPesqCid.SetFormHeight(const Value: Integer);
begin
  FFormHeight := Value;
end;

procedure TPesqCid.SetFormLeft(const Value: Integer);
begin
  FFormLeft := Value;
end;

procedure TPesqCid.SetFormPosition(const Value: TPosition);
begin
  FFormPosition := Value;
end;

procedure TPesqCid.SetFormTop(const Value: Integer);
begin
  FFormTop := Value;
end;

procedure TPesqCid.SetFormWidth(const Value: Integer);
begin
  FFormWidth := Value;
end;

procedure TPesqCid.SetFormWindowState(const Value: TWindowState);
begin
  FFormWindowState := Value;
end;


procedure TBuscaCodigo.chbxPAutomaticaClick(Sender: TObject);
begin
if chbxPAutomatica.Checked then
   cbChave.OnChange := bProcuraClick
else
   cbChave.OnChange := nil;
end;

procedure TBuscaCodigo.ListaDblClick(Sender: TObject);
begin
if paBotoes.Visible then
   btOK.Click;
end;

procedure TPesqCid.SetPesquisaAutomatica(const Value: boolean);
begin
  FPesquisaAutomatica := Value;
end;

{procedure TPesqCid.LoadControlBitmap;
begin
FBitMap.LoadFromResourceName(HInstance, 'TPESQCID');
end;
}
initialization
  Terminou := false;
  ChDup := false;
  TemChDup := false;
  TemChave := false;

end.

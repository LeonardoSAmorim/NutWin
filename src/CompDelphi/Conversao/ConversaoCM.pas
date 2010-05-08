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




unit ConversaoCM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, StdCtrls, ComCtrls, Gauges, ExtCtrls;

type
  TAntesDeGravarEvent = procedure (TabelaDestino:String;
                                   var CampoDestino:String;
                                   var valor:Variant) of object;

  TfmConversaoCM = class(TForm)
    paClient: TPanel;
    gaTabela: TGauge;
    gaTotal: TGauge;
    laTabela: TLabel;
    Label1: TLabel;
    laIndicator: TLabel;
    laIndicatorReg: TLabel;
    btCancelar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCancelarClick(Sender: TObject);
  private
    { Private declarations }
    Indicator: Integer;
    TotIndicator : Integer;
    FfTemErros:Boolean;
    FfCancelou:boolean;
    FfJaTeveErro:Boolean;
    FArquivoDeErro: TextFile;
    FsWinTempDir:String;
    FsNomeArquivo:String;
    FfLimpaTabela:Boolean;
    FOnAntesDeGravar: TAntesDeGravarEvent;
    Function CopiaTabelasConversao(LtaOrigem:TDBDataSet;Var LtaDestino:TTable):Boolean;
    Function CopiaRegistroConversao(LtaOrigem:TDBDataSet;Var LtaDestino:TTable):Boolean;
    Procedure LimparTabelasNovoDB;
    Function ExisteTabelaNoNovoBD(LsNomeTabela:String):Boolean;
    Function ExisteTabelaNoVelhoBD(LsNomeTabela:String):Boolean;
    function LerArquivoDeErro:String;
  public
    { Public declarations }
    {Parâmetros}
    psDataBase:String;
    psDataBaseNew:String;
    PsSenha:String;
    PsUserName:String;
    property TemErros : Boolean read FfTemErros;
    property Cancelou : Boolean read FfCancelou;
    {Fim Parâmetros}
    Procedure AdicionaErro(lsErro:String);
    procedure SetOnAntesDeGravar(const Value: TAntesDeGravarEvent);
    procedure SetLimpaTabela(const Value: Boolean);
    Function Converter:boolean;
  end;

var
  fmConversaoCM: TfmConversaoCM;

Implementation

uses ConversaoErros, procedures, procConv, dmConversao;

{$R *.DFM}

procedure TfmConversaoCM.SetLimpaTabela(const Value: Boolean);
begin
  FfLimpaTabela := Value;
end;

{Para não sobrecarregar a memória, o sistema lerá somente 200 linhas do
 arquivo de erro gerado. Para ler o restante, peça para que o usuário
 utilize o WordPad.exe para abrir o arquivo ConversaoLog.txt criado
 no diretório Windows/temp}
function TfmConversaoCM.LerArquivoDeErro:String;
var
  ms_conteudo, ms_linha:string;
  liLinha:integer;
  LArquivoDeErro:TextFile;
begin
  try
    AssignFile(LArquivoDeErro, FsWinTempDir+FsNomeArquivo);
    Reset(LArquivoDeErro);
    LiLinha:=0;
    while (not Eof(LArquivoDeErro)) or (liLinha<=200) do
    begin
      readln(LArquivoDeErro,ms_linha);
      ms_conteudo:=ms_conteudo+trim(ms_linha);
      if ms_conteudo<>'' then
        ms_conteudo:=ms_conteudo+#10;
      inc(LiLinha);
    end;
    CloseFile(LArquivoDeErro);
    result:=trim(ms_conteudo);
  except
    on e:exception do
    begin
      result:=e.message;
    end;
  end;
end;

Procedure TfmConversaoCM.AdicionaErro(lsErro:String);
//Var
//  LiLength: Integer;
begin
  // Initialize Variable
  try
    if Not FfTemErros then //Primeira Vez
    begin
      AssignFile(FArquivoDeErro, FsWinTempDir+FsNomeArquivo);
      Rewrite(FArquivoDeErro);
      Writeln(FArquivoDeErro, 'Data: '+DateToStr(Date)+'  Hora: '+TimetoStr(time));
      Writeln(FArquivoDeErro, '');
    end;
    Writeln(FArquivoDeErro, LsErro);
    FfTemErros:=True;
  except
    on e:exception do
    begin
//      MessageDlg('CONVERSÃO-'+E.message,mtError,[mbOk],0);
    end;
  end;
end;

Function TfmConversaoCM.CopiaTabelasConversao(LtaOrigem:TDBDataSet;Var LtaDestino:TTable):Boolean;
begin
  try
    FfJaTeveErro:=False;
    Indicator := 0;
    laIndicatorReg.Caption := 'Registro:';
    laIndicatorReg.Update;
    TotIndicator := ltaOrigem.RecordCount;
    ltaOrigem.First;
    While not ltaOrigem.eof do
    begin
      Application.ProcessMessages;
      gaTabela.Progress:=gaTabela.Progress+1;
      CopiaRegistroConversao(ltaOrigem,LtaDestino);
      ltaOrigem.Next;
      //Se o usuário pressionou botão cancelar, então ...
      if FfCancelou then
      begin
        if MessageDlg('A operação de conversão não pode ser abortada!, Confirma ?',mtConfirmation,[mbNo, mbYes],0)=mrYes then
        begin
          AdicionaErro('Operação interrompida durante cópia da tabela '+LtaDestino.tableName);
          result := False;
          Exit;
        end
        else
          FfCancelou := False;
      end;
    end;
    result:=True;
  except
    on e:exception do
    begin
      AdicionaErro('ERRO! tabela '+LtaDestino.tableName+' não copiada!');
      AdicionaErro('Detalhe: '+ E.Message);
      Result:=False;
    end;
  end;
end;

{Copia todo o registro POSICIONADO de uma tabela ORIGEM para outra
 de mesma estrutura (DESTINO) }
Function TfmConversaoCM.CopiaRegistroConversao(LtaOrigem:TDBDataSet;Var LtaDestino:TTable):Boolean;
const
   eKeyViol = 9729;
var
  i,LiNumCampos:integer;
  LsCampo,LsCampos,LsDados:String;
  LValor:Variant;
  LlTratarErro : Boolean;
//  LfPrintCabec:Boolean;
begin
  Result := False;
  Try
    LtaDestino.insert;
    for i:=0 to LtaOrigem.FieldCount-1 do
    begin
      //So vale para campos que existam fisicamente na tabela.
      //Ignorando os campos Lockup, calculados, etc.
      try
        if LtaOrigem.Fields[i].FieldKind = fkData then
        begin
          LsCampo:=LtaOrigem.Fields[i].fieldName;
          LValor:=LtaOrigem.fieldByName(lsCampo).value;
          if Assigned(FOnAntesDeGravar) then //Se foi escrito um evento, ...
            FOnAntesDeGravar(LtaDestino.tableName,LsCampo,LValor);
          if LtaDestino.FieldList.Find(LsCampo)<>nil then //Se encontrar o campo...
            LtaDestino.FieldByName(LsCampo).value:=LValor
            //Se não existe o campo, e o Evento AntesDeGravar mudou seu valor...
          else if (lsCampo <> LtaOrigem.Fields[i].fieldName) then
            AdicionaErro ('ERRO NO EVENTO AntesDeGravar! Campo '+lsCampo+' inexistente!!!');
        end;
      Except
        On E:Exception do
        Begin
          if Assigned(FOnAntesDeGravar) then //Houve mudan
            AdicionaErro('ERRO no Evento AntesDeGravar! campo '+LsCampo+' da tabela '+LtaDestino.tableName + ' não copiado!')
          else
            AdicionaErro('ERRO! campo '+LsCampo+' da tabela '+LtaDestino.tableName+ ' não copiado!');
          AdicionaErro('Detalhe: '+ E.Message);
        end;
      end;
    end;
    LtaDestino.Post;
    result:=True;
    //self.refresh;
  except
    On E:Exception do
    begin
       LlTratarErro := True;
       if (E is EDBEngineError) then
          if ((E as EDBEngineError).Errors[0].Errorcode = eKeyViol) and
             ( dmConv.taTabelasConv.FieldByName( 'LIMPAR' ).AsString = 'F' ) then
              LlTratarErro := False;
       LtaDestino.cancel;
       if LlTratarErro then
       begin
          Result:=False;
          if Not FfJaTeveErro then
          begin
             AdicionaErro('Atenção! Os seguintes registros da tabela '+LtaDestino.tableName+' não foram copiados');
             AdicionaErro('Detalhe: '+E.Message);
             //Colocando os nomes dos campos em forma de coluna
             LsCampos:='';
             LiNumCampos:=LtaOrigem.FieldCount;
             For i:=0 to LiNumCampos-1 do
             begin
                if LsCampos<>'' then LsCampos:=LsCampos+', ';
                   LsCampos:=LsCampos+UpperCase(LtaOrigem.Fields[i].fieldName);
             end;
             AdicionaErro(LsCampos);
             FfJaTeveErro:=True;
          end;
          //Colocando alguns dados que não foram copiados, para futura identificação
          LsDados:='';
          LiNumCampos:=LtaOrigem.FieldCount;
          For i:=0 to LiNumCampos-1 do
          begin
             if LsDados<>'' then LsDados:=LsDados+',';
                LsCampo:=LtaOrigem.Fields[i].fieldName;
             LsDados := LsDados+'"'+LtaOrigem.FieldByName(LsCampo).AsString+'"';
          end;
          AdicionaErro(LsDados);
       end;
    end;
  end;
  Indicator := Indicator + 1;
  laIndicator.Caption := IntToStr( Indicator ) + '/' + IntToStr(TotIndicator);
  laIndicator.Update;
end;

Function TfmConversaoCM.ExisteTabelaNoNovoBD(LsNomeTabela:String):Boolean;
var
  LListaDeTAbelas:TStringList;
begin
LListaDeTAbelas := TStringList.Create;
try
//  Result := True;
//  exit;
  //Adiciona as tabelas em um TStringList
  Session.GetTableNames(dmConv.dbNovo.DatabaseName{psDataBaseNew}, '',False, False, LListaDeTAbelas);
  Result := (LListaDeTAbelas.IndexOf(LsNomeTabela)<>-1);
finally
  LListaDeTAbelas.Free;
end;
end;

Function TfmConversaoCM.ExisteTabelaNoVelhoBD(LsNomeTabela:String):Boolean;
var
  LListaDeTAbelas:TStringList;
begin
//  Result := True;
//  exit;
   LListaDeTAbelas := TStringList.Create;
   try
     //Adiciona as tabelas em um TStringList
     Session.GetTableNames(dmConv.dbAntigo.DatabaseName {psDataBase}, '',False, False, LListaDeTAbelas);
     Result := (LListaDeTAbelas.IndexOf(LsNomeTabela)<>-1);
finally
  LListaDeTAbelas.Free;
end;
end;

Procedure TfmConversaoCM.LimparTabelasNovoDB;
 var
   LsTabela:String;
begin
 try
  {Limpando os dados das tabelas do novo banco de dados}
  With dmConv.taTabelasConv, dmConv do
  begin
    gaTabela.Progress:=0;
    gaTabela.MaxValue:=RecordCount+1;
    last;
    last;
    While not bof do
    begin
      try
        LsTabela:=FieldByName('TabDestino').AsString;
        if LsTabela='' then
          LsTabela := FieldByName('TabOrigem').AsString;
        if ExisteTabelaNoNovoBD(LsTabela) then
        begin
          taNovo.tableName := LsTabela;
          // limpar tabela nova se estiver True
          if taTabelasConv.FieldByName( 'LIMPAR' ).AsString = 'T' then
             taNovo.EmptyTable;
          edit;
          FieldByName('Copiado').AsString := 'F';
          Post;
          Application.ProcessMessages;
        end;
      finally
        prior;
        gaTabela.Progress:=gaTabela.Progress+1;
        Application.ProcessMessages;
      end;
    end;
  end;
 except
   on E:Exception do
   begin
     MessageDlg(e.message,mtInformation,[mbOk],0);
     Exit;
   end;
 end;
end;

procedure TfmConversaoCM.FormCreate(Sender: TObject);
begin
   //Variáveis privates
   FfTemErros:=False;
   FfCancelou:=False;
   FsWinTempDir:=PegaDiretorioTemporario;
   FsNomeArquivo:='ConversaoLog.txt';
end;

Function TfmConversaoCM.Converter:boolean;
var
  LsTabOrigem, LsTabDestino: String;
  LiNumTabsConv: Integer;
  LfCopiou: Char;
begin

  if (psDataBase='') or (psDataBaseNew='') then
   begin
      MessageDlg('Parâmetros inválidos', mtError, [mbOk], 0);
      Result := False;
      Exit;
   end;


   // Gambiarra para sair mais rápido
 with dmConv do
 begin
   DBAntigo.AliasName := PsDataBase;
   dbNovo.AliasName := PsDataBaseNew;

   DBAntigo.Params.Add( 'USERNAME='+PsUserName );
   DBAntigo.Params.Add( 'PASSWORD='+PsSenha );
   dbNovo.Params.Add( 'USERNAME='+PsUserName );
   dbNovo.Params.Add( 'PASSWORD='+PsSenha );

   DBAntigo.Connected := True;
   dbNovo.Connected := True;

   //Abrindo tabela de conversão
   try
      taTabelasConv.IndexName := 'CONVERSAOBD0';
      taTabelasConv.Open;
   except
   on E:exception do
   begin
      MessageDlg('Erro ao abrir tabela ConversaoBD'+#13#13+
                 'Detalhe:'+#13+
                 e.message, mtError, [mbOk], 0);
   end;
   end;
   result := True;
   LiNumTabsConv := taTabelasConv.RecordCount;
   //Total
   gaTotal.MaxValue := LiNumTabsConv;
   gaTotal.Progress := 0;
   //Antes de começar a conversão as tabelas do NovoBD terão que estar vazias
   if FfLimpaTabela then //Set essa variável para FALSE, se desejar popular tabelas
     LimparTabelasNovoDB;
   //Inicio da conversão
   taTabelasConv.First;
   btCancelar.Enabled := True;
   while not taTabelasConv.eof do
   begin
      try
         LsTabOrigem := taTabelasConv.FieldByName('TabOrigem').AsString;
         LsTabDestino := taTabelasConv.FieldByName('TabDestino').AsString;
         gaTabela.Progress := 0;
         laTabela.caption := 'Tabela '+lsTabOrigem+'...';
         laTabela.Refresh;
         if LsTabDestino = '' then
            LsTabDestino := LsTabOrigem;
         if ExisteTabelaNoVelhoBD(LsTabOrigem) then
         begin
            if ExisteTabelaNoNovoBD(LsTabDestino) then
            begin
               //Antigo
               taAntigo.Close;
               taAntigo.tablename := LsTabOrigem;
               taAntigo.Open;
               //novo
               taNovo.Close;
               taNovo.tablename := lsTabDestino;
               taNovo.Open;
               //definindo a barra de Progressao
               gaTabela.MaxValue:=taAntigo.RecordCount;
               if CopiaTabelasConversao(taAntigo,taNovo) then
                  LfCopiou:= 'T'
               else
                  LfCopiou := 'F';
               //Grava status se copiou ou não no banco
               taTabelasConv.Edit;
               taTabelasConv.FieldByName('Copiado').AsString:=LfCopiou;
               taTabelasConv.Post;
               if FfCancelou then //Usuário pressionou Botão cancelar e confirmou...
               begin
                  // Pra terminar
                  DBAntigo.Connected := False;
                  dbNovo.Connected := False;
                  Exit;
               end;
            end
            else
               AdicionaErro('ERRO! tabela '+LsTabDestino+' não encontrada na nova versão do banco!');
         end
         else
            AdicionaErro('Atenção! A tabela '+LsTabOrigem+' não existia na versão antiga do banco de dados');
            finally
               if not FfCancelou then // pois acabei de fechar os Databases
                  taTabelasConv.Next;
         if gaTabela.Progress < gaTabela.MaxValue then
            gaTabela.Progress := gaTabela.MaxValue;
         gaTotal.Progress := gaTotal.Progress+1;
      end;
   end;
   Self.Refresh;
   if FfTemErros then
   begin
      if Application.FindComponent('fmConversaoErros') = nil then
         Application.CreateForm(TfmConversaoErros,fmConversaoErros);
      AdicionaErro('');
      AdicionaErro('FIM');
      CloseFile(FArquivoDeErro);
      fmConversaoErros.reErrosConv.Text := LerArquivoDeErro; //Lerá somente 200 linhas deste arquivo
      {Se o Texto da última linha não for FIM, significa que o arquivo de erro não
      foi lido por completo. Então eu vou mostrar um label de explicação sobre
      o Texto ter sido truncado, etc e tal... Para o usuário ler o arquivo pelo Notepad.exe}
      if fmConversaoErros.reErrosConv.lines[fmConversaoErros.reErrosConv.lines.count-1] <> 'FIM' Then
         fmConversaoErros.laObs.visible := True;
      fmConversaoErros.ShowModal;
//      fmConversaoErros.Top := fmConversaoErros.Top-LvTop;
//      fmConversaoErros.Refresh;
   end;

   // Pra terminar
{   try
   DBAntigo.Close;
   dbNovo.Close;
   except
   ShowMessage( 'Não consegui fechar.');
   end;}
   DBAntigo.Connected := False;
   dbNovo.Connected := False;
 end;
end;

procedure TfmConversaoCM.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmConversaoCM.SetOnAntesDeGravar(
  const Value: TAntesDeGravarEvent);
begin
  FOnAntesDeGravar := Value;
end;

procedure TfmConversaoCM.btCancelarClick(Sender: TObject);
begin
   FfCancelou := True;
end;

end.

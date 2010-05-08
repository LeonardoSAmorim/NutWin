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




unit CNSPacote;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CNSDBSUS, CNSLote, db, dbtables, CNSMidia, Inifiles, CNSConfig;

type
  TCNSPacote = class(TComponent)
  private
    { Private declarations }
    // propriedades
    FLote : TCNSLote;
    FMidia : TCNSMidia;
    FListaLotes : Tstrings;
    FListaUsuarios : TStrings;
    FQueryUsuario : TDataSet;
    FNomeArquivo : string;
    FNomeArquivoAux : string;
    FUnidade : byte;
    FConfig : TCNSConfig ;
    // funções internas
    function MontarHeader : string;
    function MontarRegistro : string;
    function MontarTrailler : string;
    function GetNomeArquivo : string;
    procedure SetMidia(Value : TCNSMidia);
    procedure SetLote(Value : TCNSLote);
    procedure SetConfig(Value : TCNSConfig);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor create(AOwner : TComponent); override;
    destructor destroy; override;
    procedure MontarPacote; virtual;
    procedure MontarPacotePeriodo(xDataInicial, xDataFinal : TDate; xStatus : string);virtual;
    procedure MontarPacoteStatus(xStatus : string); virtual;
    procedure MontarPacoteGeral(lista:TStrings);
    function AvaliaMeio : boolean;
    property  NomeArquivo : string read GetNomeArquivo;

  published
    { Published declarations }
    property Config : TCNSConfig read FConfig write SetConfig;
    property Lote : TCNSLote read FLote write SetLote;
    property Midia : TCNSMidia read FMidia write SetMidia;
  end;

procedure Register;

implementation
uses CNSLib;
var
 nu_seq_reg : integer;
 cod_mun : string;
 ultpac : integer;
 xNome : string;  // nome do arquivo sem o path

procedure Register;
begin
  RegisterComponents('Cartao', [TCNSPacote]);
end;

constructor TCNSPacote.create(AOwner : TComponent);
begin
   inherited create(AOWner);
   FListaLotes := TStringList.create;
   FListaUsuarios := TStringList.create;
end;

destructor TCNSPacote.Destroy;
begin
  FListaLotes.Free;
  FListaUsuarios.Free;
  inherited Destroy;
end;

procedure TCNSPacote.SetMidia(Value : TCNSMidia);
begin
   FMidia := Value;
   if assigned(Value) then
   begin
      value.FreeNotification(self);
   end;
end;

procedure TCNSPacote.SetLote(Value : TCNSLote);
begin
   FLote := Value;
   if assigned(Value) then
   begin
      value.FreeNotification(self);
   end;
end;

procedure TCNSPacote.SetConfig(Value : TCNSConfig);
begin
   FConfig := Value;
   if assigned(Value) then
   begin
      value.FreeNotification(self);
   end;
end;


procedure TCNSPacote.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FMidia <> nil) and (AComponent = Midia) then
       Midia := nil;
    if (FLote <> nil) and (AComponent = Lote) then
       Lote := nil;
    if (FConfig <> nil) and (AComponent = Config) then
       Config := nil;
  end;
end;


function TCNSPacote.GetNomeArquivo : string;
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  Present:= Now;
  DecodeDate(present, Year, Month, Day);
  ultpac  := Config.inifile.Readinteger('Pacotes','ultpacote',0 );
  ultpac  := ultpac + 1;
  cod_mun := Config.inifile.Readstring('Ambiente','municipio',' ') ;
  result  := Midia.Directory +'\'+ cod_mun + inttostr(day) + inttostr(month) + '.M'+ format('%2.2d',[ultpac]);
  xNome   := cod_mun + inttostr(day) + inttostr(month) + '.M'+ format('%2.2d',[ultpac]);
end;



// ROTINAS DE MONTAGEM DE PACOTES    -----------------------------------------------------
procedure TCNSPacote.MontarPacoteGeral(lista:TStrings);
var
   QPacote : TDataSet;
begin
   FListaLotes.addstrings(Lista);
   MontarPacote;
end;

procedure TCNSPacote.MontarPacotePeriodo(xDataInicial, xDataFinal : TDate; xStatus : string);

begin

   FListaLotes := Flote.ListaLotesPeriodo(xDataInicial,xDataFinal, xStatus);
   MontarPacote;
end;

procedure TCNSPacote.MontarPacoteStatus(xStatus : string);
begin
   FListaLotes := Flote.ListaLotesStatus(xStatus);
   MontarPacote;
end;

procedure TCNSPacote.MontarPacote;
var
  i : integer;
begin
   nu_seq_reg := 1;
   FNomeArquivoAux := NomeArquivo;
   if FListaLotes.Count > 0 then
   begin
      FListaUsuarios.Clear;
      FListaUsuarios.Add(MontarHeader);
      for i := 0 to FListaLotes.Count -1 do
      begin
         Flote.SelecionarUsuariosLote(strtoint(FListaLotes[i]));
         with TQuery(FLote.DataSource.DataSet) do
         begin
             first;
             While not eof do
             begin
                FListaUsuarios.Add(MontarRegistro);
                next;
             end;
         end;
      end;
      FListaUsuarios.Add(MontarTrailler);
      FListaUsuarios.SaveToFile(FNomeArquivoAux);
      config.inifile.writeinteger('Pacotes','ultpacote', ultpac ) ;
      Lote.ST_Atualizar('ENVIADO',flistalotes);
   end;
end;
// F I M  --   MONTAGEM DE PACOTES    ---------




// ROTINAS  HEADER+REGISTROS DE USUÁRIOS SUS + TRAILLER----------
function TCNSPacote.MontarHeader : string;
var
  aux : string;
begin
  result := format('%7.7d', [ nu_seq_reg ] ) + '1' + FormatDateTime('yyyymmdd',date) +
             cod_mun+ xNome + CNSLib.brancos(12) + CNSLib.Brancos(598); //Esta funçào já traz no formato que deseja ficar a data
  inc(nu_seq_reg);
end;

function TCNSPacote.MontarRegistro : string;
var
  dt: string;
  XX : STRING;
begin
    with TQuery(FLote.DataSource.DataSet) do
    begin
        Result := format('%7.7d', [ nu_seq_reg ] ) + '2'; // 2= Tipo Registro de Usuário
        Result := result + FieldByName('NUM_CONTROLE').AsString + CNSLib.brancos(40-LENGTH(FieldByName('NUM_CONTROLE').AsString));
        Result := Result + FieldByName('NOME_FONET').AsString + CNSLib.Brancos(28-LENGTH(FieldByName('NOME_FONET').AsString));
        // Não enviar Pis algum ==>  Result := Result + FieldByName('PIS').AsString+ CNSLib.Brancos(11-LENGTH(FieldByName('PIS').AsString));
        // Result := Result +CNSLib.zeros(11-LENGTH(trim(FieldByName('PIS').AsString)))+ trim(FieldByName('PIS').AsString);  //PIS1
        Result := Result + CNSLib.zeros(11);  // PIS1  ???????? zeros
        Result := Result + CNSLib.zeros(11);  // PIS2  ???????? zeros
        Result := Result + '1';  // 1= cadastramento e 3= Alteração( 'não está sendo utilizado neste momento )
        if FieldByName('DT_CADASTRAMENTO').AsString <> '' then
           begin
             dt := formatDateTime('yyyymmdd' , (FieldByName('DT_CADASTRAMENTO').Asdatetime));
             Result := Result + dt;
           end
        else
            result := result + CNSLib.zeros(8);

        Result := Result +CNSLib.zeros(11-LENGTH(trim(FieldByName('PIS_FUNCIONARIOALTEROU').AsString)))+ trim(FieldByName('PIS_FUNCIONARIOALTEROU').AsString);

        if FieldByName('DT_NASCIMENTO').AsString <> '' then
           begin
             dt := formatDateTime('yyyymmdd' , (FieldByName('DT_NASCIMENTO').Asdatetime));
             Result := Result + dt;
           end
        else
            result := result + CNSLib.zeros(8);

        Result := Result + FieldByName('NOME_LONGO').AsString+CNSLib.Brancos(70-LENGTH(FieldByName('NOME_LONGO').AsString));
        Result := Result + FieldByName('NOME_MAE').AsString+CNSLib.Brancos(70-LENGTH(FieldByName('NOME_MAE').AsString));;
        Result := Result + FieldByName('NOME_PAI').AsString+CNSLib.Brancos(70-LENGTH(FieldByName('NOME_PAI').AsString));
        Result := Result + FieldByName('SEXO').AsString+CNSLib.Brancos(1-LENGTH(FieldByName('SEXO').AsString));
        Result := Result + FieldByName('RACACOR').AsString+CNSLib.Brancos(2-LENGTH(FieldByName('RACACOR').AsString));
        Result := Result +CNSLib.zeros(7-LENGTH(trim(FieldByName('COD_IBGE_NASCIMENTO').AsString)))+ trim(FieldByName('COD_IBGE_NASCIMENTO').AsString);
        Result := Result + FieldByName('TIPO_IDENTIDADE').AsString+CNSLib.Brancos(2-LENGTH(FieldByName('TIPO_IDENTIDADE').AsString));
        Result := Result + FieldByName('NUM_IDENTIDADE').AsString+CNSLib.Brancos(15-LENGTH(FieldByName('NUM_IDENTIDADE').AsString));
        Result := Result + FieldByName('SIGLA_UF_EMISSORA_IDENT').AsString+CNSLib.Brancos(2-LENGTH(FieldByName('SIGLA_UF_EMISSORA_IDENT').AsString));

        if FieldByName('DT_EMISSAO_IDENT').AsString <> '' then
           begin
             dt := formatDateTime('yyyymmdd' , (FieldByName('DT_EMISSAO_IDENT').Asdatetime));
             Result := Result + dt;
           end
        else
            result := result + CNSLib.zeros(8);

        Result := Result + FieldByName('TIPO_CERTIDAO').AsString+CNSLib.zeros(2-LENGTH(FieldByName('TIPO_CERTIDAO').AsString));
        Result := Result + FieldByName('NOME_CARTORIO').AsString+CNSLib.Brancos(20-LENGTH(FieldByName('NOME_CARTORIO').AsString));
        Result := Result + FieldByName('LIVRO_CERTIDAO').AsString+CNSLib.Brancos(8-LENGTH(FieldByName('LIVRO_CERTIDAO').AsString));
        Result := Result + FieldByName('FOLHA_CERTIDAO').AsString+CNSLib.Brancos(4-LENGTH(FieldByName('FOLHA_CERTIDAO').AsString));
        Result := Result + FieldByName('TERMO_CERTIDAO').AsString+CNSLib.Brancos(8-LENGTH(FieldByName('TERMO_CERTIDAO').AsString));

        if FieldByName('DT_EMISSAO_CERTIDAO').AsString <> '' then
           begin
             dt := formatDateTime('yyyymmdd' , (FieldByName('DT_EMISSAO_CERTIDAO').Asdatetime));
             Result := Result + dt;
           end
        else
            result := result + CNSLib.zeros(8);

        Result := Result +CNSLib.zeros(11-LENGTH(trim(FieldByName('CPF').AsString)))+trim( FieldByName('CPF').AsString);
        Result := Result +CNSLib.zeros(7-LENGTH(trim(FieldByName('CTPS').AsString)))+trim( FieldByName('CTPS').AsString);
        Result := Result +CNSLib.zeros(5-LENGTH(trim(FieldByName('CTPS_SERIE').AsString)))+trim( FieldByName('CTPS_SERIE').AsString);
        Result := Result + FieldByName('CTPS_UF').AsString+CNSLib.Brancos(2-LENGTH(FieldByName('CTPS_UF').AsString));

        if FieldByName('DT_EMISSAO_CTPS').AsString <> '' then
           begin
             dt := formatDateTime('yyyymmdd' , (FieldByName('DT_EMISSAO_CTPS').Asdatetime));
             Result := Result + dt;
           end
        else
            result := result + CNSLib.zeros(8);

        Result := Result +CNSLib.zeros(13-LENGTH(trim(FieldByName('TIT_ELEIT').AsString)))+trim(FieldByName('TIT_ELEIT').AsString);
        Result := Result +CNSLib.zeros(3-LENGTH(trim(FieldByName('TIT_ELEIT_ZONA').AsString)))+trim( FieldByName('TIT_ELEIT_ZONA').AsString);
        Result := Result +CNSLib.zeros(4-LENGTH(trim(FieldByName('TIT_ELEIT_SECAO').AsString)))+trim(FieldByName('TIT_ELEIT_SECAO').AsString);
        Result := Result + FieldByName('NACIONALIDADE').AsString+CNSLib.Brancos(3-LENGTH(FieldByName('NACIONALIDADE').AsString));

        if FieldByName('DT_CHEGADA').AsString <> '' then
           begin
             dt := formatDateTime('yyyymmdd' , (FieldByName('DT_CHEGADA').Asdatetime));
             Result := Result + dt;
           end
        else
            result := result + CNSLib.zeros(8);

// SO PREENCHER COM 0 CAMPO VAZIO, E NAO COMPLETAR COM 0 CAMPO COM VALOR
        Result := Result +CNSLib.zeros(16-LENGTH(trim(FieldByName('NUM_PORTARIA').AsString)))+ trim(FieldByName('NUM_PORTARIA').AsString);

        if FieldByName('DT_NATURALIZACAO').AsString <> '' then
           begin
             dt := formatDateTime('yyyymmdd' , (FieldByName('DT_NATURALIZACAO').Asdatetime));
             Result := Result + dt;
           end
        else
            result := result + CNSLib.zeros(8);

        Result := Result + FieldByName('NOME_LOGRADOURO').AsString+CNSLib.Brancos(50-LENGTH(FieldByName('NOME_LOGRADOURO').AsString));
        Result := Result + CNSLib.zeros(5-LENGTH(trim(FieldByName('NUM_LOGRADOURO').AsString)))+ trim(FieldByName('NUM_LOGRADOURO').AsString);
        Result := Result + FieldByName('COMPL_LOGRADOURO').AsString+CNSLib.Brancos(15-LENGTH(FieldByName('COMPL_LOGRADOURO').AsString));
        Result := Result + FieldByName('BAIRRO').AsString+CNSLib.Brancos(30-LENGTH(FieldByName('BAIRRO').AsString));
        Result := Result +CNSLib.zeros(8-LENGTH(trim(FieldByName('CEP').AsString)))+ trim(FieldByName('CEP').AsString);
        Result := Result +CNSLib.zeros(7-LENGTH(trim(FieldByName('COD_IBGE').AsString)))+ trim(FieldByName('COD_IBGE').AsString);
        Result := Result + '1'; // Sit. End.1=valido 3=invalido 5=devolvida 9=não válidado pelO SISTEMA
        Result := Result + '1'; // Data nasc. 1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // Nome usu 1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // Nome mae 1= Prenchido e 3=Nao preenchido
        Result := Result + '3'; // Nome pai 1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // Sexo 1= Prenchido e 3=Nao preenchido
        Result := Result + '3'; // Raca cor 1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // municipio ibge nasc 1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // Altera identidade 1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // Altera certidao 1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // CPF  1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // CTPS 1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // TITULO 1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // Altera Dados Estrangeiro - Nacionalidade  1= Prenchido e 3=Nao preenchido
        Result := Result + '1'; // Altera Endereço  1= Prenchido e 3=Nao preenchido
        inc(nu_seq_reg)
    end;
end;

function TCNSPacote.MontarTrailler : string;
begin
   Result := format('%7.7d', [ nu_seq_reg ] ) + '8';  // 8=registro tipo Trailler
   Result := result +  cod_mun + format('%7.7d' ,[ FListaUsuarios.Count+1] ) +CNSLib.Brancos(619);
end;

//end;
// F I M  --  Partes do Arquivo TXT : HEADER+REGISTROS DE USUÁRIOS SUS + TRAILLER





// ROTINAS PARA TRASNMISSÃO DO PACOTE

function TCNSPacote.AvaliaMeio : boolean;
var
   xCapaciLivre, xCapaciIdeal : double;
begin
   result := false;  // var definida em meio.pas
   if assigned(Midia) then
      xCapaciIdeal := (FMidia.DriveFree*0.95);
   if xCapaciLivre <= xCapaciIdeal  then
      begin
         { mostra o total de bytes no form ao lado da unidade lógica indicada }
         result := true;
         showmessage('Cálculo feito com  margem de 5% de segurança');

      end;

end;
// F I M  -  ROTINAS PARA TRASNMISSÃO DO PACOTE

end.

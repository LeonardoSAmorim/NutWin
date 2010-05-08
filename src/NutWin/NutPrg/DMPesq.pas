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




unit DMPesq;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Measurement, dmMBoard, NutCnst, ItemAlimentar, Memoria, Procedimento;

const
  OP_PASTAS = '0';
  OP_PESSOAS = '1';
  OP_INQUERITOS = '2';

type
  TDMPesquisa = class(TDataModule)
    DSPastas: TDataSource;
    TbPastas: TTable;
    DSCor: TDataSource;
    TbCor: TTable;
    DSSexo: TDataSource;
    TbSexo: TTable;
    TbCorCodCor: TStringField;
    TbCorDescCor: TStringField;
    TbSexoCodSexo: TStringField;
    TbSexoDescSexo: TStringField;
    DSNacionalidade: TDataSource;
    TbNacionalidade: TTable;
    TbNacionalidadeNACIONALIDADE: TStringField;
    TbNacionalidadeSIGLA: TStringField;
    TbNacionalidadeIDNAC: TStringField;
    DSNaturalidade: TDataSource;
    TbNaturalidade: TTable;
    TbNaturalidadeDescrCid: TStringField;
    TbNaturalidadeUF: TStringField;
    TbNaturalidadeIdCid: TStringField;
    TbNaturalidadeCepCid: TStringField;
    TbNaturalidadeDDD: TStringField;
    DSPessoa: TDataSource;
    DSAlimento: TDataSource;
    TbPessoa: TTable;
    TbAlimento: TTable;
    TbNaturalidadeCidUF: TStringField;
    TbPessoaIDPESSOA: TStringField;
    TbPessoaSOBRPESS: TStringField;
    TbPessoaNOMEPESS: TStringField;
    TbPessoaDATANASC: TDateTimeField;
    TbPessoaCODSEXO: TStringField;
    TbPessoaDATACAD: TDateTimeField;
    TbAlimentoIDALI: TStringField;
    TbAlimentoNOME: TStringField;
    TbAlimentoNOMESIMP: TStringField;
    TbAlimentoIDORIG: TStringField;
    TbAlimentoIDGRUALI: TStringField;
    TbAlimentoTIPOALI: TStringField;
    TbAlimentoPREP: TStringField;
    TbAlimentoOBSALI: TStringField;
    DSPesqTemp: TDataSource;
    qrPesqTemp: TQuery;
    DSPesqTemp1: TDataSource;
    tbPesqTemp1: TTable;
    DSCadPastas: TDataSource;
    TbCadPastas: TTable;
    TbCadPastasIDPASTA: TStringField;
    TbCadPastasIDPESSOA: TStringField;
    TbCadPastasDATACAD: TDateTimeField;
    tbPesqTemp1IDPESSOA: TStringField;
    tbPesqTemp1CODIGO: TStringField;
    DSPessComp: TDataSource;
    TbPessComp: TTable;
    TbPessCompIDPESSOA: TStringField;
    TbPessCompCODNATURAL: TStringField;
    TbPessCompCODNACIONAL: TStringField;
    TbPessCompCODESTCIVIL: TStringField;
    TbPessCompCODCOR: TStringField;
    TbPessCompCODPROFIS: TStringField;
    TbPessCompOBS: TMemoField;
    TbPessCompCODINSTRUC: TStringField;
    TbPessCompREGISTRO: TStringField;
    DSInqueritos: TDataSource;
    TbInqueritos: TTable;
    DbPesq: TDatabase;
    TbPastasIDPASTA: TStringField;
    TbPastasNOMEPASTA: TStringField;
    UpdateSQL1: TUpdateSQL;
    TbInqueritosIDPESSOA: TStringField;
    TbInqueritosDATA: TDateTimeField;
    TbInqueritosINQUERITO: TMemoField;
    DSAntropsPesq: TDataSource;
    TbAntropsPesq: TTable;
    TbAntropsPesqIDPESSOA: TStringField;
    TbAntropsPesqDATA: TDateTimeField;
    TbAntropsPesqANTROP: TMemoField;
    TbAntropsPesqIMCPESQ: TStringField;
    TbAntropsPesqPESOATUALPESQ: TStringField;
    TbAntropsPesqPDIMCPESQ: TStringField;
    TbAntropsPesqPDMPESQ: TStringField;
    TbAntropsPesqESTATURAPESQ: TStringField;
    TbAntropsPesqPDCSPESQ: TStringField;
    DSCNut: TDataSource;
    TbCNut: TTable;
    TbCNutCOD_CNUT: TStringField;
    TbCNutDESCR_CNUT: TStringField;
    TbCNutNIVEL: TStringField;
    TbCNutTIPO: TStringField;
    TbCNutCLASSE: TStringField;
    DSInqPesq: TDataSource;
    TbInqPesq: TTable;
    TbNutrientesPq: TTable;
    TbNutrientesPqValorNut: TStringField;
    TbNutrientesPqIDNUT: TStringField;
    TbNutrientesPqABREV: TStringField;
    TbNutrientesPqNOMENUT: TStringField;
    TbNutrientesPqUNIDADE: TStringField;
    TbNutrientesPqIDORIG: TStringField;
    TbNutrientesPqVISIVEL: TStringField;
    TbNutrientesPqORDPADRAO: TFloatField;
    DSNutrientesPq: TDataSource;
    TbInqPesqIDPESSOA: TStringField;
    TbInqPesqDATA: TDateTimeField;
    TbInqPesqINQUERITO: TMemoField;
    TbInqPesqDESCRICAO: TStringField;
    DSAliNut: TDataSource;
    TbAliNutPesq: TTable;
    TbAliNutPesqIDALI: TStringField;
    TbAliNutPesqIDNUT: TStringField;
    TbAliNutPesqVALOR: TFloatField;
    TbPesqTemp1DATANASC: TDateTimeField;
    TbPesqTemp1CODSEXO: TStringField;
    TbPesqTemp1DATACAD: TDateTimeField;
    DSPessoabk: TDataSource;
    TbPessoabk: TTable;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    DateTimeField1: TDateTimeField;
    StringField4: TStringField;
    DateTimeField2: TDateTimeField;
    DSCadPastasbk: TDataSource;
    TbCadPastasbk: TTable;
    StringField5: TStringField;
    StringField6: TStringField;
    DateTimeField3: TDateTimeField;
    TbPesqTemp1SOBRPESS: TStringField;
    TbPesqTemp1NOMEPESS: TStringField;
    procedure DMPesquisaCreate(Sender: TObject);
    procedure DMPesquisaDestroy(Sender: TObject);
//    procedure TbAntropsPesqCalcFields(DataSet: TDataSet);

  private
    FListaAnt1: TStrings;
    FListaAnt2: TStrings;
    FSequencia: string;
    procedure SetSequencia(const Value: string);
    procedure SetListaAnt1(const Value: TStrings);
    procedure SetListaAnt2(const Value: TStrings);
    function ListaMedidasAntropUsadas( Memoria : TMemoria ) : String;


    { Private declarations }
  public
    { Public declarations }

    stOpcaoSelecaoInicial : String ;
    stCodigoControleUsuario : String ;
    stNomePasta : string ;
    lsPastas        : TStrings;
    stIdade         : String ;
    stSexo          : String ;
    stCor           : String ;
    stNaturalidade  : String ;
    stNacionalidade : String ;

    DataAntInicial : TDateTime;
    DataAntFinal   : TDateTime;

    stPath : string ;

    property ListaAnt1 : TStrings read FListaAnt1 write SetListaAnt1;
    property ListaAnt2 : TStrings read FListaAnt2 write SetListaAnt2;
    property Sequencia : string read FSequencia write SetSequencia;

    procedure EncheListaAntropometrica;
    procedure EncheListaNutInqueritos;
    function ControlaSinais ( Sinal : String ) : TStrings ;
    procedure LimpaTabeladePesquisa;

    function GeraArquivoSDF : boolean;
    function GeraArquivoSDFInq : boolean;

  end;

var
  DMPesquisa: TDMPesquisa;

implementation


{$R *.DFM}

function TDMPesquisa.ControlaSinais ( Sinal : String ) : TStrings ;
var
  Sinais1 : TStrings;
  Sinais2 : TStrings;

begin
   Result  := TStringList.create;
   Sinais1 := TStringList.create;
   Sinais1.Add('<') ;
   Sinais1.Add('<=');
   Sinais1.Add('<>');

   Sinais2 := TStringlist.create;
   Sinais2.Add('>') ;
   Sinais2.Add('>=');
   Sinais2.Add('<>');

  // Result.Clear;

   if (Sinal = '>') or (Sinal = '>=') then
      Result.AddStrings(Sinais1)
   else if (Sinal = '<') or (Sinal = '<=') then
      Result.AddStrings(Sinais2) ;

   Sinais1.Free;
   Sinais2.Free;

end;

procedure TDMPesquisa.DMPesquisaCreate(Sender: TObject);
begin
    lsPastas  := TStringList.Create;
    FListaAnt1 := TStringList.Create;
    FListaAnt2 := TStringList.Create;
    DataAntInicial := Now();
    DataAntFinal := Now();
    stPath := 'c:\Pesquisa.txt';


end;

procedure TDMPesquisa.DMPesquisaDestroy(Sender: TObject);
begin
    lsPastas.Free;
    FListaAnt1.Free;
    FListaAnt2.Free;
end;

procedure TDMPesquisa.LimpaTabeladePesquisa;
var
stSQL : string;

begin
    stSQL := '';
    stSQL := ' DELETE FROM PESQTEMP WHERE PESQTEMP.CODIGO = ' +  ':stCodControleUsuario' ;
    DMPesquisa.qrPesqTemp.Close;
    DMPesquisa.qrPesqTemp.SQL.Clear;
    DMPesquisa.qrPesqTemp.SQL.Add( stSQL );
    DMPesquisa.qrPesqTemp.ParamByName('stCodControleUsuario').asString := stCodigoControleUsuario;
    DMPesquisa.qrPesqTemp.ExecSQL;


end;

procedure TDMPesquisa.EncheListaAntropometrica;
var
   AuxGUID : TGUIDItem;
begin
   // Encher a lista com o nome das medidas antropométricas
   DMPesquisa.TbCNut.First;
   FListaAnt1.Clear;
   FListaAnt2.Clear;
   While not DMPesquisa.TbCNut.EOF do
       begin
          if ( Copy( DMPesquisa.TbCNut.Fieldbyname('COD_CNUT').asString, 1, 4 ) <> 'mdvl' ) and
             ( Copy( DMPesquisa.TbCNut.Fieldbyname('COD_CNUT').asString, 1, 4 ) <> 'vlmd' ) then
           begin
              AuxGUID := TGUIDItem.Create( Owner );
              AuxGUID.Guid := DMPesquisa.TbCNut.Fieldbyname('COD_CNUT').asString;
              FListaAnt1.AddObject(DMPesquisa.TbCNut.Fieldbyname('DESCR_CNUT').asString, AuxGUID);
           end;
           DMPesquisa.TbCNut.Next;
       end;

end;

function TDMPesquisa.GeraArquivoSDFInq : boolean;
var
  mdTemp : TMedida;
  ItemAli : TItemalimentar;
  CxInq : TCaixa;

  I, J, K, L: Integer;
  Linha1, Linha, Linha_Campos, stData, stSexo: String;
  CSVFile: TextFile;
  PesqPess : TDataSet;
  OldPesqPessFiltered : Boolean;
  nNut : double;
begin
    TbPesqTemp1.Refresh;
    TbPessoa.Refresh;
    TbPessoabk.Refresh;
    TbInqPesq.Refresh;

//   dmMotherBoard.DBIOController.DataSource := DSInqPesq;
   // Setar a tabela de pessoas ou pesqtemp1 como master de Inqpesq
   // Fazer para a Tabela PesqTemp1
   // Filtrar antes pelo código
   if stOpcaoSelecaoInicial = OP_PASTAS then
   begin
      PesqPess := tbPesqTemp1;
      tbInqPesq.MasterSource := DSPesqTemp1;
      tbInqPesq.MasterFields := 'IDPESSOA';
      tbInqPesq.IndexFieldNames := 'IDPESSOA;DATA';
      stdata := 'CODIGO = ' +  '''' + stCodigoControleUsuario + '''';
      PesqPess.Filter := stData;
      OldPesqPessFiltered := PesqPess.Filtered;
      PesqPess.Filtered := True;
   end
   else
   begin
      PesqPess := tbPessoa;
      tbInqPesq.MasterSource := DSPessoa;
      tbInqPesq.MasterFields := 'IDPESSOA';
      tbInqPesq.IndexFieldNames := 'IDPESSOA';
   end;

   // Fazer para a Tabela tbInqPesq
   // Filtrar antes pela data.
   stdata := 'DATA >= '+ ''''+ DateToStr(DMPesquisa.DataAntInicial) + '''' + ' and DATA <= ' + '''' + DateToStr(DMPesquisa.DataAntFinal)+ '''';
   tbInqPesq.Filter := stData;
   tbInqPesq.Filtered := True;

   Linha_Campos := '';

   // Pedir o local onde gravar o arquivo
   try
    begin
     AssignFile(CSVFile, DMPesquisa.stPath);
     Rewrite(CSVFile);
    end
   except
     Result := False;
   end;
      // Linha de campos do individuo   (Pego do Banco de Dados)
   for K:=0 to PesqPess.FieldCount-1 do
   Begin
      if Linha_Campos = '' then
         Linha_Campos:= '''' + PesqPess.Fields[K].DisplayName + ''''
      else if Linha_Campos <> '' then
         Linha_Campos:= Linha_Campos+'; '+ '''' + PesqPess.Fields[K].FieldName + '''';
    End;


   // Linha de cabeçalho do inquerito
    {  Linha_Campos:= '''IDPESSOA '''+ '; ' + '''DATA '''+'; '+  '''DIAS INQ ''' +'; '+
                     '''REFEIÇÃO ''' +'; ' + '''QTDE ''' +'; '+ '''MEDIDA ''' +'; '+ '''ALIMENTO ''' +'; '+
                     '''QTDE GR. '''  ;  }
      Linha_Campos:= Linha_Campos + '; ' + '''DATA '''+'; '+  '''DIAS INQ ''' +'; '+
                     '''REFEIÇÃO ''' +'; ' + '''QTDE ''' +'; '+ '''MEDIDA ''' +'; '+ '''ALIMENTO ''' +'; '+
                     '''QTDE GR. '''  ;


   for K:=0 to (ListaAnt2.Count -1 ) do
   Begin
   // Pego os NOMES dos nutrientes

      Linha_Campos:= Linha_Campos+'; ' + '''' + ListaAnt2.Strings[K] + '''' ;

   end;
   try
    writeln(CSVFile,Linha_Campos);
   except
    Result := False;
   end;

   // Varre todos os individuos
   PesqPess.First;
   for K := 0 to (PesqPess.RecordCount-1) do
   Begin
      // Se tem blob de inquerito
      Linha1 := '';
      if ( tbInqPesq.RecordCount > 0 ) then
      begin
        // Pega dados do individuo
          for J:=0 to PesqPess.FieldCount-1 do
          Begin
            if PesqPess.Fields[J].Visible then
            Begin
               if linha1 = '' then
                  begin
                     // Mudo o valor do sexo para feminino ou masculino
                     if (PesqPess.Fields[J].DisplayName = 'CODSEXO') and (PesqPess.Fields[J].AsString = '1') then
                        linha1:= ''''+ 'Feminino' + ''''
                     else if (PesqPess.Fields[J].DisplayName = 'CODSEXO') and (PesqPess.Fields[J].AsString = '2') then
                        linha1:= ''''+ 'Masculino' + ''''
                     else
                        // traz os valores do campo de forma bruta
                        linha1:= ''''+ PesqPess.Fields[J].AsString + '''';
                  end
               else
                  begin
                     // Mudo o valor do sexo para feminino ou masculino
                     if (PesqPess.Fields[J].DisplayName = 'CODSEXO') and (PesqPess.Fields[J].AsString = '1') then
                        linha1:=linha1+'; '+ ''''+ 'Feminino' + ''''
                     else if (PesqPess.Fields[J].DisplayName = 'CODSEXO') and (PesqPess.Fields[J].AsString = '2') then
                        linha1:=linha1+'; '+ ''''+ 'Masculino' + ''''
                     else
                        // traz os valores do campo de forma bruta
                       linha1:=linha1+'; '+ ''''+ PesqPess.Fields[J].AsString + '''';
                  end;
            End;
          End;

         // Varre todos os inqueritos do individuo corrente
         tbInqPesq.First;
         for I := 0 to (tbInqPesq.RecordCount-1) do
         begin
             // Pega a caixa de inquerito corrente
             Linha := Linha1;
            dmMotherBoard.DBIOController.Calculo.Memoria.Limpar;
            dmMotherBoard.DBIOController.Calculo.Memoria.SetMem(tbInqPesq.FieldByName( 'INQUERITO' ).AsString );
            if dmMotherBoard.DBIOController.Calculo.Memoria.Acha( 'cxcaInquerito1' , TObject(cxInq)) and
               dmMotherBoard.DBIOController.Calculo.Memoria.Acha( 'cxcaInquerito1DiasDeConsumo' , TObject(mdTemp)) then

             Begin
                 // Pega número de dias do inquerito

                 // Pega os itens alimentares do inquerito corrente
                 for L := 0 to (cxInq.ComponentCount - 1) do
                 if ( cxInq.Components[L] is TItemAlimentar ) then
                 begin
                    ItemAli := TItemAlimentar(cxInq.Components[L]);

                    linha := linha + '; ' + '''' + TbInqPesq.Fieldbyname('DATA').asString + '''' + '; '
                                             + mdTemp.ValorApresentacao + '; '
                                             + ItemAli.Refeicao + '; '
                                             + ItemAli.Quantidade + '; '
                                             + ItemAli.MedidaCaseira + '; '
                                             + ItemAli.Alimento + '; '
                                             + FloattoStr(ItemAli.PesoEmGramas/mdTemp.AsFloat)  ;


                     for J:=0 to (ListaAnt2.Count -1 ) do
                     begin
                       // procuro cada nutriente, pego seu valor e calculo para 100 gramas
                       if  TbAliNutPesq.Locate('IDALI;IDNUT',VarArrayOf([ItemAli.IDAlimento,TGUIDItem(ListaAnt2.Objects[J]).Guid ]), []) then
                           begin
                           // Nao entendi o porque destes totais, por isso mudei ISL
                          //  linha := linha + ';' + '''' +  FloatToStr( ( TbAliNutPesq.Fieldbyname('VALOR').AsFloat * 100 )/ ItemAli.PesoEmGramas ) + '''' ;
                            // Pego o valor em 100 gramas e calculo para o valor do inquerito e XXXXXXX ainda divido pelos dias do inquerito
                            linha := linha + ';' + '''' +  FloatToStr( ( TbAliNutPesq.Fieldbyname('VALOR').AsFloat / 100 ) * (ItemAli.PesoEmGramas/mdTemp.AsFloat ) ) + '''' ;
                           end
                       else
                           begin
                            linha := linha + ';' + '''' + ''''   ;

                           end;

                     end ;

                      try
                       writeln(CSVFile,linha);
                      except
                       Result := False;
                      end;

                      linha := '' ;
                      linha := linha1;
                 end;
             end;
             tbInqPesq.Next;
         end;
      end;
      PesqPess.Next;
   End;
   // Volto o estado do filtered, se necessário, pois
   // eu não sei que tabela é PesqPess
   if OldPesqPessFiltered <> PesqPess.Filtered then
      PesqPess.Filtered := OldPesqPessFiltered;
   tbInqPesq.Filtered := False;
   try
    begin
      CloseFile(CSVfile);
      Result := True;
    end
   except
    Result := False ;
   end;
end;


function TDMPesquisa.GeraArquivoSDF : boolean;
var
  mdTemp : TMedida;
  I, J, K: Integer;
  Linha1, Linha, Linha_Campos, stData: String;
  CSVFile: TextFile;
  PesqPess : TDataSet;
  OldPesqPessFiltered : Boolean;
begin
    TbPesqTemp1.Refresh;
    TbPessoa.Refresh;
    TbPessoabk.Refresh;
    TbAntropsPesq.Refresh;

//   dmMotherBoard.DBIOController.DataSource := DSAntropsPesq;
   // Setar a tabela de pessoas ou pesqtemp1 como master de antrops
   // Fazer para a Tabela PesqTemp1
   // Filtrar antes pelo código
   if stOpcaoSelecaoInicial = OP_PASTAS then
   begin
      PesqPess := tbPesqTemp1;
      tbAntropsPesq.MasterSource := DSPesqTemp1;
      tbAntropsPesq.MasterFields := 'IDPESSOA';
      TbAntropsPesq.IndexFieldNames := 'IDPESSOA;DATA';
      stdata := 'CODIGO = ' +  '''' + stCodigoControleUsuario + '''';
      PesqPess.Filter := stData;
      OldPesqPessFiltered := PesqPess.Filtered;
      PesqPess.Filtered := True;
     // ShowMessage('Pesquisa realizada sobre '+ InttoStr(PesqPess.RecordCount) + ' pessoas: ' );

   end
   else
   begin
      PesqPess := tbPessoa;
      tbAntropsPesq.MasterSource := DSPessoa;
      tbAntropsPesq.MasterFields := 'IDPESSOA';
      TbAntropsPesq.IndexFieldNames := 'IDPESSOA';
    //  ShowMessage('Pesquisa realizada sobre '+ InttoStr(PesqPess.RecordCount) + ' pessoas: ' );

   end;

   // Fazer para a Tabela tbAntropsPesq
   // Filtrar antes pela data.
   stdata := 'DATA >= '+ ''''+ DateToStr(DMPesquisa.DataAntInicial) + '''' + ' and DATA <= ' + '''' + DateToStr(DMPesquisa.DataAntFinal)+ '''';
   TbAntropsPesq.Filter := stData;
   TbAntropsPesq.Filtered := True;

   Linha_Campos := '';

   // Pedir o local onde gravar o arquivo
   // AssignFile(CSVFile, 'c:\TabNutAntrop.TXT');
   try
    begin
     AssignFile(CSVFile, DMPesquisa.stPath);
     Rewrite(CSVFile);
    end
   except
     Result := False;
   end;

   // Linha de campos do individuo
   for K:=0 to PesqPess.FieldCount-1 do
   Begin
      if Linha_Campos = '' then
         Linha_Campos:= '''' + PesqPess.Fields[K].DisplayName + ''''
      else if Linha_Campos <> '' then
         Linha_Campos:= Linha_Campos+'; '+ '''' + PesqPess.Fields[K].FieldName + '''';
    End;

   // Linha de medidas do antrops
   for K:=0 to (ListaAnt2.Count -1 ) do
   Begin
      if (ListaAnt2.Objects[k] is TGUIDItem ) then
         Linha_Campos:= Linha_Campos+'; '+ '''' + TGUIDItem(ListaAnt2.Objects[k]).Guid  + '''';
   end;
   try
    writeln(CSVFile,Linha_Campos)
   except
    Result := False;
   end;

   // Varre todos os individuos
   PesqPess.First;
   for K := 0 to PesqPess.RecordCount-1 do
   Begin
      Linha1 := '';
      // xxxxxxxxxxxxx
      if ( tbAntropsPesq.RecordCount > 0 ) then
      begin
          for J:=0 to PesqPess.FieldCount-1 do
          Begin
            if PesqPess.Fields[J].Visible then
            Begin
               if linha1 = '' then
                  begin
                  // Mudo o valor do sexo para feminino ou masculino
                   if (PesqPess.Fields[J].DisplayName = 'CODSEXO') and (PesqPess.Fields[J].AsString = '1') then
                      linha1:= ''''+ 'Feminino' + ''''
                   else if (PesqPess.Fields[J].DisplayName = 'CODSEXO') and (PesqPess.Fields[J].AsString = '2') then
                      linha1:= ''''+ 'Masculino' + ''''
                   else
                   // traz os valores do campo de forma bruta
                      linha1:= ''''+ PesqPess.Fields[J].AsString + '''';
                  end
               else
                  begin
                     // Mudo o valor do sexo para feminino ou masculino
                     if (PesqPess.Fields[J].DisplayName = 'CODSEXO') and (PesqPess.Fields[J].AsString = '1') then
                        linha1:=linha1+'; '+ ''''+ 'Feminino' + ''''
                     else if (PesqPess.Fields[J].DisplayName = 'CODSEXO') and (PesqPess.Fields[J].AsString = '2') then
                        linha1:=linha1+'; '+ ''''+ 'Masculino' + ''''
                     else
                        // traz os valores do campo de forma bruta
                       linha1:=linha1+'; '+ ''''+ PesqPess.Fields[J].AsString + '''';
                  end;
            End;
          End;
          // Varre todos as antropometrias do individuo corrente
         TbAntropsPesq.First;
         for I := 0 to TbAntropsPesq.RecordCount-1 do
         begin
             Linha := Linha1;
             for J:=0 to (ListaAnt2.Count -1 ) do
             Begin
                 dmMotherBoard.DBIOController.Calculo.Memoria.Limpar;
                 dmMotherBoard.DBIOController.Calculo.Memoria.SetMem(TbAntropsPesq.FieldByName( 'ANTROP' ).AsString );
                 // Verifica se a medida foi usada mesmo
//*                 if Pos( mdTemp.Name, ListaMedidasAntropUsadas( dmMotherBoard.DBIOController.Calculo.Memoria ) ) = 0 then
//*                    linha:= linha+'; '+ '''' + ' ' + ''''
                 if dmMotherBoard.DBIOController.Calculo.Memoria.Acha( TGUIDItem(ListaAnt2.Objects[J]).Guid , TObject(mdTemp)) then
                    linha:= linha+'; '+ '''' + mdTemp.ValorApresentacao + ' ' + mdTemp.UnidadeApresentacao +  ''''
                 else
                    linha:= linha+'; '+ '''' + ' ' + '''';
             end;
             try
               writeln(CSVFile,linha)
             except
               Result := False
             end;
             TbAntropsPesq.Next;
         end;
      end;
      PesqPess.Next;
   End;
   // Volto o estado do filtered, se necessário, pois
   // eu não sei que tabela é PesqPess
   if OldPesqPessFiltered <> PesqPess.Filtered then
      PesqPess.Filtered := OldPesqPessFiltered;
   TbAntropsPesq.Filtered := False;
   try
    begin
      CloseFile(CSVfile);
      Result := True;
    end
   except
    Result := False
   end;

end;

procedure TDMPesquisa.SetListaAnt1(const Value: TStrings);
begin
  FListaAnt1.Assign( Value );
end;

procedure TDMPesquisa.SetListaAnt2(const Value: TStrings);
begin
  FListaAnt2.Assign( Value );
end;

procedure TDMPesquisa.EncheListaNutInqueritos;
var
   AuxGUID : TGUIDItem;
begin
   // Encher a lista com o nome dos nutrientes

    DMPesquisa.TbNutrientesPq.Refresh;
   DMPesquisa.TbNutrientesPq.First;
   FListaAnt1.Clear;
   FListaAnt2.Clear;
   While not DMPesquisa.TbNutrientesPq.EOF do
       begin
        AuxGUID := TGUIDItem.Create( Owner );
        AuxGUID.Guid := DMPesquisa.TbNutrientesPq.Fieldbyname('IDNUT').asString;
        FListaAnt1.AddObject(DMPesquisa.TbNutrientesPq.Fieldbyname('NOMENUT').asString, AuxGUID);
        DMPesquisa.TbNutrientesPq.Next;
       end;

end;

procedure TDMPesquisa.SetSequencia(const Value: string);
begin
  FSequencia := Value;
end;


function TDMPesquisa.ListaMedidasAntropUsadas( Memoria : TMemoria ) : String;
var
   I : Integer;
   AuxCx,
   AuxPr : TComponent;
   LstProcChecked : TStringList;
   LstMedidasChecked : TStringList;
begin
  Result := '';
  // para testar #######################################
  LstProcChecked := TStringList.Create;
  LstMedidasChecked := TStringList.Create;
try
  if Assigned (Memoria) then
  begin
     AuxCx := Memoria.FindComponent( 'cxcaAntrop' );
     if Assigned( AuxCx ) and ( AuxCx is TCaixa ) then
     with (AuxCx as TCaixa ) do
     begin
       // Cria as listas de procedimentos checked e não checked
       For I := 0 to ComponentCount - 1 do
          if ( Components[I] is TProcedimento ) then
          begin
             if TProcedimento( Components[I] ).Estado = psChecked then
                LstProcChecked.Add( TProcedimento( Components[I] ).Name );
          end;
     end;
     // Enche a lista de medidas checked
     dmMotherBoard.caProcessador.Procedimentos.Clear;
     dmMotherBoard.caProcessador.Procedimentos := LstProcChecked;
     if dmMotherBoard.caProcessador.ListaMedidasProcedimentos( LstMedidasChecked ) < 0 then
        exit;
     Result := LstMedidasChecked.Text;
  end;
finally
  LstProcChecked.Free;
  LstMedidasChecked.Free;
end;
end;




end.

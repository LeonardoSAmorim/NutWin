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




unit Pessoa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, NutCnst;

type
  TDMPessoa = class(TDataModule)
    TbSexo: TTable;
    TbSexoDescSexo: TStringField;
    TbCidade: TTable;
    TbEndereco: TTable;
    TbEnderecoIDPessoa: TStringField;
    TbEnderecoNomeLograd: TStringField;
    TbEnderecoNumLograd: TStringField;
    TbEnderecoComplem: TStringField;
    TbEnderecoBairro: TStringField;
    TbEnderecoEmail: TStringField;
    TbEstado: TTable;
    TbNacionalidade: TTable;
    TbTelefone: TTable;
    TbTelefoneIDPessoa: TStringField;
    TbTelefoneTipo: TStringField;
    TbTelefoneDDD: TStringField;
    TbTelefoneNumTel: TStringField;
    TbTelefoneRamal: TStringField;
    TbCor: TTable;
    TbProfissao: TTable;
    TbProfissaoCodProfis: TStringField;
    TbProfissaoDescProf: TStringField;
    TbInstrucao: TTable;
    TbInstrucaoCodInstruc: TStringField;
    TbInstrucaoDescInst: TStringField;
    TbPessoa: TTable;
    TbPessoaIDPessoa: TStringField;
    TbPessoaSobrPess: TStringField;
    TbPessoaNomePess: TStringField;
    TbPessoaCodSexo: TStringField;
    TbPessoaSobrResp: TStringField;
    TbPessoaNomeResp: TStringField;
    TbPessoaFotoPess: TGraphicField;
    TbPessComp: TTable;
    TbPessCompIDPessoa: TStringField;
    TbPessCompCodNacional: TStringField;
    TbPessCompCodEstCivil: TStringField;
    DSPessoa: TDataSource;
    DSSexo: TDataSource;
    DSCidade: TDataSource;
    DSEndereco: TDataSource;
    DSEstado: TDataSource;
    DSNacionalidade: TDataSource;
    DSPessComp: TDataSource;
    DSTelefone: TDataSource;
    DSCor: TDataSource;
    DSInstrucao: TDataSource;
    DSProfissao: TDataSource;
    TbPessCompCodNatural: TStringField;
    TbCorDescCor: TStringField;
    TbCorCodCor: TStringField;
    DSUsuarios: TDataSource;
    TbUsuarios: TTable;
    TbTemp: TTable;
    TbEnderecoCep: TStringField;
    DSAnamnese: TDataSource;
    TbAnamnese: TTable;
    TbEnderecoCidade: TStringField;
    TbEnderecoDescCid: TStringField;
    TbEnderecoUF: TStringField;
    DSTipoAnam: TDataSource;
    TbTipoAnam: TTable;
    TbAnamneseIDPessoa: TStringField;
    TbAnamneseAnam: TMemoField;
    DSCadPastas: TDataSource;
    TbCadPastas: TTable;
    TbCadPastasIdPessoa: TStringField;
    TbCadPastasIdPasta: TStringField;
    TbCadPastasNomePasta: TStringField;
    TbCadPastasNomePess: TStringField;
    TbCadPastasSobrPess: TStringField;
    DSCadPastasbk: TDataSource;
    TbCadPastasbk: TTable;
    TbCadPastasbkIdPasta: TStringField;
    TbCadPastasbkIdPessoa: TStringField;
    DSCadPastasInd: TDataSource;
    TbCadPastasInd: TTable;
    TbCadPastasIndIdPasta: TStringField;
    TbCadPastasIndIdPessoa: TStringField;
    TbCadPastasIndNomePastas: TStringField;
    TbCidadeIdCid: TStringField;
    TbCidadeDescrCid: TStringField;
    TbCidadeCepCid: TStringField;
    TbCidadeDDD: TStringField;
    TbEstadoIdEstado: TStringField;
    TbEstadoAbrevEstado: TStringField;
    TbEstadoNomeEstado: TStringField;
    TbCidadeUF: TStringField;
    TbAnamNavTbl: TTable;
    StringField1: TStringField;
    MemoField1: TMemoField;
    DSAnamNavTbl: TDataSource;
    DSInqueritos: TDataSource;
    DSDietas: TDataSource;
    DSMetas: TDataSource;
    TbInqueritos: TTable;
    TbDietas: TTable;
    TbMetas: TTable;
    TbInqueritosIdPessoa: TStringField;
    TbInqueritosInquerito: TMemoField;
    TbDietasIdPessoa: TStringField;
    TbDietasDieta: TMemoField;
    TbMetasIdPessoa: TStringField;
    DSInqueritosBk: TDataSource;
    TbInqueritosBk: TTable;
    StringField2: TStringField;
    MemoField2: TMemoField;
    DSDietasBk: TDataSource;
    TbDietasBk: TTable;
    StringField3: TStringField;
    MemoField3: TMemoField;
    DSMetasBk: TDataSource;
    TbMetasBk: TTable;
    StringField4: TStringField;
    DSAntrops: TDataSource;
    TbAntrops: TTable;
    DSAntropsBk: TDataSource;
    TbAntropsBk: TTable;
    TbAntropsIdPessoa: TStringField;
    TbAntropsAntrop: TMemoField;
    TbAntropsBkIdPessoa: TStringField;
    TbAntropsBkAntrop: TMemoField;
    TbOpcoes: TTable;
    TbOpcoesNaturalidade: TStringField;
    TbOpcoesNacionalidade: TStringField;
    TbOpcoesCor: TStringField;
    TbOpcoesCidade: TStringField;
    DSOpcoes: TDataSource;
    TbSexoCodSexo: TStringField;
    TbOpcoesSexo: TStringField;
    TbCidadeCidUF: TStringField;
    TbPessoaIDADEANOS: TStringField;
    TbPessoaIDADEMESES: TStringField;
    TbPessoaIDADEDIAS: TStringField;
    TbPessoaNOMECOMPL: TStringField;
    TbOpcoesRCabec1: TStringField;
    TbOpcoesRCabec2: TStringField;
    TbOpcoesRCabec3: TStringField;
    TbOpcoesRCabec4: TStringField;
    TbOpcoesRRodap1: TStringField;
    TbOpcoesRLogo: TGraphicField;
    TbPessCompRegistro: TStringField;
    DSTipoExa: TDataSource;
    TbTipoExa: TTable;
    DSExaPess: TDataSource;
    TbExaPess: TTable;
    TbExaPessIdPessoa: TStringField;
    TbExaPessExames: TMemoField;
    DSExaPessBk: TDataSource;
    TbExaPessBk: TTable;
    StringField5: TStringField;
    MemoField5: TMemoField;
    TbPessCompObs: TMemoField;
    TbPessoabk: TTable;
    DSPessoabk: TDataSource;
    TbPessoabkIDPessoa: TStringField;
    TbPessoabkSobrPess: TStringField;
    TbPessoabkNomePess: TStringField;
    TbPessoabkCodSexo: TStringField;
    TbPessoabkSobrResp: TStringField;
    TbPessoabkNomeResp: TStringField;
    TbPessoabkFotoPess: TGraphicField;
    TbPessoaFonetizado: TStringField;
    TbPessoabkFonetizado: TStringField;
    DSPessoaFon: TDataSource;
    TbPessCompCODCOR: TStringField;
    TbPessCompCODPROFIS: TStringField;
    TbPessCompCODINSTRUC: TStringField;
    qrPessoaFon: TQuery;
    TbPessoabkNomeCompleto: TStringField;
    TbExaPessBkDATA: TDateTimeField;
    TbExaPessDATA: TDateTimeField;
    TbAntropsBkDATA: TDateTimeField;
    TbAntropsDATA: TDateTimeField;
    TbMetasBkDATA: TDateTimeField;
    TbMetasDATA: TDateTimeField;
    TbDietasBkDATA: TDateTimeField;
    TbDietasDATA: TDateTimeField;
    TbInqueritosBkDATA: TDateTimeField;
    TbInqueritosDATA: TDateTimeField;
    TbAnamNavTblDATA: TDateTimeField;
    TbCadPastasIndDATACAD: TDateTimeField;
    TbCadPastasbkDATACAD: TDateTimeField;
    TbCadPastasDATACAD: TDateTimeField;
    TbPessoabkDATANASC: TDateTimeField;
    TbPessoabkDATACAD: TDateTimeField;
    TbPessoaDATANASC: TDateTimeField;
    TbPessoaDATACAD: TDateTimeField;
    TbAnamneseDATA: TDateTimeField;
    DbPessoa: TDatabase;
    TbMetasMETA: TMemoField;
    TbMetasBkMETA: TMemoField;
    DSPastas: TDataSource;
    TbPastas: TTable;
    TbPastasIDPASTA: TStringField;
    TbPastasNOMEPASTA: TStringField;
    TbPastasICON: TIntegerField;
    TbTipoAnamTIPO: TStringField;
    TbTipoAnamDATA: TDateTimeField;
    TbTipoAnamDESCR: TMemoField;
    TbTipoExaTIPO: TStringField;
    TbTipoExaDATA: TDateTimeField;
    TbTipoExaDESCR: TMemoField;
    DSPessCompbk: TDataSource;
    qrPessCompbk: TQuery;
    TbPessCompCidade: TStringField;
    TbAntropsDESCRICAO: TStringField;
    TbAntropsBkDESCRICAO: TStringField;
    TbDietasBkDESCRICAO: TStringField;
    TbDietasDESCRICAO: TStringField;
    TbInqueritosBkDESCRICAO: TStringField;
    TbInqueritosDESCRICAO: TStringField;
    DSPastasBk: TDataSource;
    TbPastasbk: TTable;
    StringField6: TStringField;
    StringField7: TStringField;
    IntegerField1: TIntegerField;
    TbNacionalidadeNACIONALIDADE: TStringField;
    TbNacionalidadeSIGLA: TStringField;
    TbNacionalidadeIDNAC: TStringField;
    TbOpcoesIDOPCOES: TStringField;
    DSEstadobk: TDataSource;
    TbEstadobk: TTable;
    TbEstadobkIDESTADO: TStringField;
    TbEstadobkABREVESTADO: TStringField;
    TbEstadobkNOMEESTADO: TStringField;
    TbUsuariosUSERNAME: TStringField;
    TbUsuariosSENHA: TStringField;
    DSDica: TDataSource;
    TbDica: TTable;
    TbDicaCODDICA: TStringField;
    TbDicaPALPORT: TStringField;
    TbDicaDICAPORT: TMemoField;
    TbUsuariosFUNDO_TELA: TIntegerField;
    TbUsuariosMOSTRA_DICA: TIntegerField;
    TbOpcoesESTADO: TStringField;
    TbNaturalidade: TTable;
    StringField8: TStringField;
    StringField9: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    DSNaturalidade: TDataSource;
    TbCidadeEst: TTable;
    DSCidadeEst: TDataSource;
    TbCidadeEstDESCRCID: TStringField;
    TbCidadeEstUF: TStringField;
    TbCidadeEstIDCID: TStringField;
    TbCidadeEstCEPCID: TStringField;
    TbCidadeEstDDD: TStringField;
    TbCidadeEstCIDUF: TStringField;
    TbInstrucaoORDEM: TIntegerField;
    TbUsuariosCABEC_LINHA: TIntegerField;
    TbUsuariosCABEC_TEXTO: TStringField;
    procedure TbPessoaNewRecord(DataSet: TDataSet);
    procedure TbNacionalidadeNewRecord(DataSet: TDataSet);
    procedure TbProfissaoNewRecord(DataSet: TDataSet);
    procedure TbInstrucaoNewRecord(DataSet: TDataSet);
    procedure TbCidadeNewRecord(DataSet: TDataSet);
    procedure TbCorNewRecord(DataSet: TDataSet);
    procedure TbPessoaDataNascValidate(Sender: TField);
    procedure TbNacionalidadePostError(DataSet: TDataSet;
      E: EDatabaseError; var Action: TDataAction);
    procedure TbTipoAnamNewRecord(DataSet: TDataSet);
    procedure TbAnamneseNewRecord(DataSet: TDataSet);
    procedure TbPastasNewRecord(DataSet: TDataSet);
    procedure TbEstadoNewRecord(DataSet: TDataSet);
    procedure TbPessoaBeforeDelete(DataSet: TDataSet);
    procedure TbPessoaCalcFields(DataSet: TDataSet);
    procedure TbPessoaAfterEdit(DataSet: TDataSet);
    procedure TbTipoExaNewRecord(DataSet: TDataSet);
    procedure TbExaPessNewRecord(DataSet: TDataSet);
    procedure TbPessoaAfterPost(DataSet: TDataSet);
    procedure TbEnderecoAfterPost(DataSet: TDataSet);
    procedure TbPessoabkCalcFields(DataSet: TDataSet);
    procedure TbAnamnesePostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbExaPessPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbPastasBeforeDelete(DataSet: TDataSet);
    procedure TbOpcoesNewRecord(DataSet: TDataSet);
    procedure TbCadPastasAfterPost(DataSet: TDataSet);
    procedure TbPastasPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbCorPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbCidadePostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbUsuariosPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbTipoAnamPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbTipoExaPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbProfissaoPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbInstrucaoPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbEstadoPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbTelefonePostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbCidadeBeforeDelete(DataSet: TDataSet);
    procedure TbEstadoBeforeDelete(DataSet: TDataSet);
    procedure TbProfissaoBeforeDelete(DataSet: TDataSet);
    procedure TbPastasAfterPost(DataSet: TDataSet);
    procedure TbCidadeBeforePost(DataSet: TDataSet);
  private
    FUsuarioLogado: string;
    procedure SetUsuarioLogado(const Value: string);
    { Private declarations }
  public
    { Public declarations }
      function  DataMaiorHoje( Data : TDateTime; Mens : Boolean ) : boolean;
      function  DataMaior120anos( Data : TDateTime; Mens : Boolean ) : boolean;
      function  DataVazia( Data : string; Mens : Boolean ) : boolean ;
      function  DataNegativa( DataInicial: TDateTime; DataFinal : TDateTime; Mens : string ) : boolean;
      procedure AbrePessoa ;
      procedure FechaPessoa ;
      procedure InserePessoa ;
      procedure ValidaPessoa ;
      procedure CancelaPessoa;
      procedure EditaPessoa;
      procedure DeletaPessoa;
      procedure AnteriorPessoa;
      procedure ProximaPessoa;
      procedure PrimeiraPessoa;
      procedure UltimaPessoa;
      procedure AtualizaPessoa;
      function  VerificaDuplicidade (dtDataset : TTable; lsChave : string; lsBusca : string ) : boolean ;
      procedure ControlaDuplicidade (dtDataset : TTable; lsChave : string; lsBusca : string );
      procedure AbreTabelasPessoas;
      procedure FechaTabelasPessoas;
      function Cript (cPassW : String) : String;
      property UsuarioLogado : string read FUsuarioLogado write SetUsuarioLogado;

  end;

var
  DMPessoa: TDMPessoa;



implementation

//uses Tabela;

{$R *.DFM}


procedure TDMPessoa.TbPessoaNewRecord(DataSet: TDataSet);
var
 stNatural, stNacional, stCor, stCidade, stEstado : string    ;

begin
    stNatural  := DMPessoa.TbOpcoes.Fieldbyname('Naturalidade').asString;
    stNacional := DMPessoa.TbOpcoes.Fieldbyname('Nacionalidade').asString;
    stCor      := DMPessoa.TbOpcoes.Fieldbyname('Cor').asString ;
    stCidade   := DMPessoa.TbOpcoes.Fieldbyname('Cidade').asString;
    stEstado   := DMPessoa.TbOpcoes.Fieldbyname('Estado').asString;

    TbPessoa.Fieldbyname('IDPessoa').AsString:=CreateNewGUID;
    TbPessoa.Fieldbyname('DataCad').asDateTime := Date;
    TbPessoa.Fieldbyname('CodSexo').AsString := DmPessoa.TbOpcoes.Fieldbyname('Sexo').asString;

    DMPessoa.TbPessComp.Insert;
    TbPessComp.Fieldbyname('CodNatural').asString  := stNatural;
    TbPessComp.Fieldbyname('CodNacional').asString := stNacional;
    TbPessComp.Fieldbyname('CodCor').asString         := stCor;
    DMPessoa.TbPessComp.Post;

    DMPessoa.TbEndereco.Insert;
    TbEndereco.Fieldbyname('Cidade').asString      := stCidade;
    TbEndereco.Fieldbyname('UF').asString          := stEstado;
    DMPessoa.TbEndereco.Post;

    {
    DMPessoa.TbPessComp.Insert;
    TbPessCompCodNatural.asString  := DMPessoa.TbOpcoesNaturalidade.asString;
    TbPessCompCodNacional.asString := DMPessoa.TbOpcoesNacionalidade.asString;
    TbPessCompCor.asString         := DMPessoa.TbOpcoesCor.asString ;

    DMPessoa.TbEndereco.Insert;
    TbEnderecoCidade.asString      := DMPessoa.TbOpcoesNaturalidade.asString  ;
    }

end;

procedure TDMPessoa.TbNacionalidadeNewRecord(DataSet: TDataSet);
begin
    TbNacionalidade.Fieldbyname('IDNac').AsString:=CreateNewGUID;
end;

procedure TDMPessoa.TbPessoaDataNascValidate(Sender: TField);
begin
    if DataMaiorHoje( TbPessoaDataNasc.asDateTime , True) then
       DmPessoa.TbPessoaDataNasc.FocusControl;
end;

function TDMPessoa.DataMaiorHoje( Data : TDateTime; Mens : Boolean ) : boolean;
begin
   if Data > Date then
      begin
        if Mens = True then ShowMessage('Esta data é maior que o dia de hoje');
        DataMaiorHoje := True;
      end
   else
        DataMaiorHoje := False;

end;

function  TDMPessoa.DataNegativa( DataInicial: TDateTime; DataFinal : TDateTime; Mens : string ) : boolean;
begin

    if Mens = '' then
       Mens := 'Data inválida.';

    if ( DataFinal - DataInicial ) < 0 then
       begin
        ShowMessage( Mens );
        Result := True;
      end
   else
        Result := False;

end;


procedure TDMPessoa.TbProfissaoNewRecord(DataSet: TDataSet);
begin
    TbprofissaoCodProfis.AsString:=CreateNewGUID;
end;

procedure TDMPessoa.TbInstrucaoNewRecord(DataSet: TDataSet);
begin
    TbInstrucao.Fieldbyname('CodInstruc').AsString:=CreateNewGUID;
    TbInstrucao.Fieldbyname('ORDEM').AsInteger:= 1;

end;

procedure TDMPessoa.TbCidadeNewRecord(DataSet: TDataSet);
begin
    TbCidade.Fieldbyname('IdCid').AsString:=CreateNewGUID;
end;

procedure TDMPessoa.TbCorNewRecord(DataSet: TDataSet);
begin
   TbCor.Fieldbyname('CodCor').AsString:=CreateNewGUID;
end;


procedure TDMPessoa.AbrePessoa ;
begin

    // Abrindo todos os bancos de dados relativos ao pessoa.

    with DMPessoa do
      begin
       TbPessoa.Active := True;
       TbPessComp.Active := True;
       TbSexo.Active := True;
       TbEndereco.Active := True;
       TbInstrucao.Active := True;
       TbCor.Active := True;
       TbTelefone.Active := True;
       TbCidade.Active := True;
       TbEstado.Active := True;
       TbNacionalidade.Active := True;
       TbProfissao.Active := True;
      end;
end;

procedure TDMPessoa.FechaPessoa ;
begin

    // Fechando todos os bancos de dados relativos ao pessoa.

     with DMPessoa do
       begin
        TbPessoa.Active := False;
        TbPessComp.Active := False;
        TbSexo.Active := False;
        TbEndereco.Active := False;
        TbInstrucao.Active := False;
        TbCor.Active := False;
        TbTelefone.Active := False;
        TbCidade.Active := False;
        TbEstado.Active := False;
        TbNacionalidade.Active := False;
        TbProfissao.Active := False;
      end;
  end;

procedure TDMPessoa.InserePessoa;

begin
  // Insere dados nos bancos relativos ao pessoa.

     with DMPessoa do
       begin
         try
           TbPessoa.Insert;
           TbPessComp.Insert;
           TbEndereco.Insert;
           TbTelefone.Insert;
         except
           on Exception do ShowMessage( 'Erro na Inserção!!');
         end;

       end;


end;

procedure TDMPessoa.ValidaPessoa;
begin
    // Valida dados nos bancos relativos ao pessoa.

     with DMPessoa do
       begin
         try
           TbPessoa.Post;
           // Se nao tiver nenhuma alteracao, cancelo para nao gerar registro em branco
           If TbPessComp.Modified then
              TbPessComp.Post
           else
              TbPessComp.Cancel;

           If TbEndereco.Modified then
              TbEndereco.Post
           else
              TbEndereco.Cancel;

           If TbTelefone.Modified then
              TbTelefone.Post
           else
              TbTelefone.Cancel;
         except
           on Exception do ShowMessage( 'Erro na Validação!!');
         end;

      end;

end;


procedure TDMPessoa.CancelaPessoa;
begin
    // Cancela dados nos bancos relativos ao pessoa.

     with DMPessoa do
       begin
         try
          TbPessoa.Cancel;
          TbPessComp.Cancel;
          TbEndereco.Cancel;
          TbTelefone.Cancel;
         except
           on Exception do ShowMessage( 'Erro no Cancelamento!!');
         end;

      end;

end;

procedure TDMPessoa.EditaPessoa;
begin
    // Coloca os bancos relativos ao pessoa em modo de edição.

     with DMPessoa do
       begin
        try
          TbPessoa.Edit;
          TbPessComp.Edit;
          TbEndereco.Edit;
          TbTelefone.Edit;
         except
           on Exception do ShowMessage( 'Erro na Edição!!');
         end;

      end;
end;

procedure TDMPessoa.DeletaPessoa;
var
I : integer;

begin
    // Deleta todos os dados da Pessoa

    for I:=0 to DMPessoa.ComponentCount -1 do
    begin
       if DMPessoa.Components[i] is TTable then
          if  ((DMPessoa.Components[i] as TTable).Mastersource = DSPessoa) or
              ((DMPessoa.Components[i] as TTable).Mastersource = DSPessoabk) then
          begin
            (DMPessoa.Components[i] as TTable).First;
           While (DMPessoa.Components[i] as TTable).RecordCount <> 0 do
              begin
                if not (DMPessoa.Components[i] as TTable).IsEmpty then
                  begin
                  //ShowMessage( (DMPessoa.Components[i] as TTable).name + '  ' + InttoStr((DMPessoa.Components[i] as TTable).RecordCount) );
                  (DMPessoa.Components[i] as TTable).Delete;
                  (DMPessoa.Components[i] as TTable).Next;
                  end;
              end;
          end;

    end;


end;


procedure TDMPessoa.AnteriorPessoa;
begin
    TbPessoa.Prior;
    if TbPessoa.BOF then
       ShowMessage( 'Inicio da Tabela');

end;

procedure TDMPessoa.ProximaPessoa;
begin
    TbPessoa.Next;
    if TbPessoa.EOF then
       ShowMessage( 'Final da Tabela');

end;

procedure TDMPessoa.PrimeiraPessoa;
begin
    TbPessoa.First;
end;

procedure TDMPessoa.UltimaPessoa;
begin
    TbPessoa.Last;
end;

procedure TDMPessoa.AtualizaPessoa;
begin
   TbPessoa.Refresh;
   TbPessComp.Refresh;
   TbEndereco.Refresh;
   TbTelefone.Refresh;
end;



function TDMPessoa.VerificaDuplicidade (dtDataset : TTable; lsChave : string; lsBusca : string ) : boolean ;
begin
    TbTemp.Active := False ;
    TbTemp.DatabaseName :=  dtDataSet.DatabaseName ;
    TbTemp.TableName    :=  dtDataSet.TableName ;
    TbTemp.Active := True ;
    VerificaDuplicidade := TbTemp.Locate( lsChave, lsBusca, [] );

end;

procedure TDMPessoa.ControlaDuplicidade (dtDataset : TTable; lsChave : string; lsBusca : string );
begin
    if VerificaDuplicidade(dtDataset,lsChave, lsBusca)  then
       begin
          ShowMessage ( 'Campo Duplicado!' );
          dtDataSet.Cancel ;
       end;

end;


procedure TDMPessoa.AbreTabelasPessoas;
begin
       // Abrindo todos os bancos de dados relativos as tabelas de pessoas

    with DMPessoa do
      begin
       TbInstrucao.Active := True;
       TbCor.Active := True;
       TbTelefone.Active := True;
       TbCidade.Active := True;
       TbEstado.Active := True;
       TbNacionalidade.Active := True;
       TbProfissao.Active := True;
       TbUsuarios.Active := True;
      end;
end;

procedure TDMPessoa.FechaTabelasPessoas;
begin
     // Fechando todos os bancos de dados relativos a tabelas de pessoa.

     with DMPessoa do
       begin
        TbInstrucao.Active := False;
        TbCor.Active := False;
        TbTelefone.Active := False;
        TbCidade.Active := False;
        TbEstado.Active := False;
        TbNacionalidade.Active := False;
        TbProfissao.Active := False;
        TbUsuarios.Active := False;
      end;
end;

procedure TDMPessoa.TbNacionalidadePostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );

end;

procedure TDMPessoa.TbTipoAnamNewRecord(DataSet: TDataSet);
begin
    TbTipoAnam.Fieldbyname('Data').AsDateTime := Date ;
end;

procedure TDMPessoa.TbAnamneseNewRecord(DataSet: TDataSet);
begin
    DMPessoa.TbAnamneseData.AsDateTime := Date ;
end;

procedure TDMPessoa.TbPastasNewRecord(DataSet: TDataSet);
begin
   DMPessoa.TbPastas.FieldByName('IDPASTA').AsString := CreateNewGUID;
   DMPessoa.TbPastas.FieldByName('ICON').AsInteger   := 0 ;
end;

procedure TDMPessoa.TbEstadoNewRecord(DataSet: TDataSet);
begin
    TbEstado.Fieldbyname('IdEstado').AsString:=CreateNewGUID;
end;

procedure TDMPessoa.TbPessoaBeforeDelete(DataSet: TDataSet);
begin
    DMPessoa.DeletaPessoa;
end;

procedure TDMPessoa.TbPessoaCalcFields(DataSet: TDataSet);
begin
    DMPessoa.TbPessoaNOMECOMPL.asString := Trim(DMPessoa.TbPessoaNomePess.asString) + ' ' +
                                                DMPessoa.TbPessoaSobrPess.asString ;
end;

procedure TDMPessoa.TbPessoaAfterEdit(DataSet: TDataSet);
begin
    TbPessoaDataCad.asDateTime := Date;
end;

procedure TDMPessoa.TbTipoExaNewRecord(DataSet: TDataSet);
begin
    TbTipoExaData.AsDateTime := Date ;
end;

procedure TDMPessoa.TbExaPessNewRecord(DataSet: TDataSet);
begin
    TbExaPessData.AsDateTime := Date ;
end;

procedure TDMPessoa.TbPessoaAfterPost(DataSet: TDataSet);
begin

   with DMPessoa do
   begin
    if (TbPessComp.State = dsInsert) or (TbPessComp.State = dsEdit) then
        TbPessComp.Post;
   end;
end;

procedure TDMPessoa.TbEnderecoAfterPost(DataSet: TDataSet);
begin
    if (DMPessoa.TbTelefone.State = dsInsert) or (DMPessoa.TbTelefone.State = dsInsert) then
        DMPessoa.TbTelefone.Post;
end;

procedure TDMPessoa.TbPessoabkCalcFields(DataSet: TDataSet);
begin
    DMPessoa.TbPessoabkNOMECOMPLETO.asString := Trim(DMPessoa.TbPessoabkNomePess.asString) + ' ' +
                                                DMPessoa.TbPessoabkSobrPess.asString ;

end;

function TDMPessoa.Cript(cPassW: String): String;
// chama uma vez e encripta, se chama de novo desencripta
var
 I : Integer;
begin
   Result := '';
   cPassW := UpperCase( cPassW );
   For I := 1 to Length(cPassW) do
       Result := Result + Chr(255 - I - Ord(cPassW[I]));
end;



procedure TDMPessoa.SetUsuarioLogado(const Value: string);
begin
  FUsuarioLogado := Value;

end;

procedure TDMPessoa.TbAnamnesePostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
var
 iDBIError: Integer;
begin
  if (E is EDBEngineError) then
  begin
    iDBIError := (E as EDBEngineError).Errors[0].Errorcode;
    case iDBIError of
      eKeyViol:
        {The primary key is OrderNo}
        begin
          MessageDlg(' Verifique se esta data já foi cadastrada. ', mtWarning,
            [mbOK], 0);
          Abort;
        end;
    end;
  end;
end;

procedure TDMPessoa.TbExaPessPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
var
 iDBIError: Integer;
begin
  if (E is EDBEngineError) then
  begin
    iDBIError := (E as EDBEngineError).Errors[0].Errorcode;
    case iDBIError of
      eKeyViol:
        {The primary key is OrderNo}
        begin
          MessageDlg(' Verifique se esta data já foi cadastrada. ', mtWarning,
            [mbOK], 0);
          Abort;
        end;
    end;
  end;
end;

procedure TDMPessoa.TbPastasBeforeDelete(DataSet: TDataSet);
begin
   // Vou procurar se tem alguem na pasta e não deixo deletar.Se achar um unico registro, nao deixo
  // if DMPessoa.TbCadPastas.Locate('IDPASTA;IDPESSOA',VarArrayOf([DMPessoa.TbPastas['IDPASTA'],DMPessoa.TbPessoa['IDPESSOA']]), []) then
  if DMPessoa.TbCadPastas.Locate('IDPASTA',DMPessoa.TbPastas['IDPASTA'], []) then
   begin
      if MessageDlg('Deseja apagar todos os indivíduos cadastrados para esta Pasta ? ', mtConfirmation,
         [mbYes, mbNo], 0) = mrYes then
         begin
           While DMPessoa.TbCadPastas.RecordCount <> 0 do
             begin
              if not DMPessoa.TbCadPastas.IsEmpty then
                 begin
                //ShowMessage( (DMPessoa.Components[i] as TTable).name + '  ' + InttoStr((DMPessoa.Components[i] as TTable).RecordCount) );
                  DMPessoa.TbCadPastas.Delete;
                  DMPessoa.TbCadPastas.Next;
                 end;
             end;
         end
      else // caso não queira apagar a pasta, aborto a deleção
         begin
           Abort;
         end
     end ;

end;

function TDMPessoa.DataMaior120anos(Data: TDateTime; Mens : Boolean): boolean;
var
  AnoNasc,  MesNasc,  DiaNasc  : Word;
  AnoAtual, MesAtual, DiaAtual : Word;

begin
     // Coloquei como limite 120 anos. Subtraio a data de hoje da data de nascimento e verifico se é menor que 120 anos.
     DecodeDate( Data, AnoNasc, MesNasc, DiaNasc );
     DecodeDate( Date - 120, AnoAtual, MesAtual, DiaAtual );

     if AnoNasc < (AnoAtual - 120 ) then
      begin
        if Mens = True then ShowMessage('Idade acima do limite de 120 anos.');
        DataMaior120anos := True;
      end
   else
        DataMaior120anos := False;
end;

function  TDMPessoa.DataVazia( Data : string ; Mens : Boolean) : boolean ;
var
  AnoAtual, MesAtual, DiaAtual : Word;
  Total : Integer;
  DataAnalisada : TDateTime;
begin
   // Transformo a data para TDateTime
   try
    begin
     DataAnalisada := StrtoDAte( Data ) ;

     // Recebo a data para analisar
     DecodeDate( DataAnalisada, AnoAtual, MesAtual, DiaAtual );

     // Saberei se ela está em branco se sua soma for 0
      Total := AnoAtual + MesAtual + DiaAtual ;

     if Total = 0 then
        Result := True
     else
        Result := False;
    end
   except
        Result := True;
   end;

end;

procedure TDMPessoa.TbOpcoesNewRecord(DataSet: TDataSet);
begin
    TbOpcoes.Fieldbyname('IDOPCOES').asString := CreateNewGUID;

end;

procedure TDMPessoa.TbCadPastasAfterPost(DataSet: TDataSet);
begin
      TbCadPastasInd.Refresh;
      TbCadPastasBk.Refresh;
end;

procedure TDMPessoa.TbPastasPostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
var
 iDBIError: Integer;
begin
  if (E is EDBEngineError) then
  begin
    iDBIError := (E as EDBEngineError).Errors[0].Errorcode;
    case iDBIError of
      eKeyViol:
        begin
          MessageDlg(' Erro de Duplicação de Dados ! Insira outro nome ou valor ou Cancele os dados. ', mtWarning,
            [mbOK], 0);
          Abort;
        end;
    end;
  end;
end;

procedure TDMPessoa.TbCorPostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMPessoa.TbCidadePostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMPessoa.TbUsuariosPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMPessoa.TbTipoAnamPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMPessoa.TbTipoExaPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMPessoa.TbProfissaoPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMPessoa.TbInstrucaoPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMPessoa.TbEstadoPostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMPessoa.TbTelefonePostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMPessoa.TbCidadeBeforeDelete(DataSet: TDataSet);
begin
   if MessageDlg('Esta exclusão poderá afetar informações já existentes em outros cadastros. Continua? ', mtConfirmation,
         [mbYes, mbNo], 0) = mrNo then
         begin
           Abort;
         end ;

end;

procedure TDMPessoa.TbEstadoBeforeDelete(DataSet: TDataSet);
begin
   if MessageDlg('Esta exclusão poderá afetar informações já existentes em outros cadastros. Continua? ', mtConfirmation,
         [mbYes, mbNo], 0) = mrNo then
         begin
           Abort;
         end ;
end;

procedure TDMPessoa.TbProfissaoBeforeDelete(DataSet: TDataSet);
begin
   if MessageDlg('Esta exclusão poderá afetar informações já existentes em outros cadastros. Continua? ', mtConfirmation,
         [mbYes, mbNo], 0) = mrNo then
         begin
           Abort;
         end ;
end;

procedure TDMPessoa.TbPastasAfterPost(DataSet: TDataSet);
begin
   DMPessoa.TbPastasbk.Refresh;
end;

procedure TDMPessoa.TbCidadeBeforePost(DataSet: TDataSet);
begin
 TbCidade.Fieldbyname('CidUF').AsString := TbCidade.Fieldbyname('DescrCid').asString +' ('+ TbCidadeEst.Fieldbyname('UF').asString + ')';

end;

end.


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




unit DMAliPrep;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, NutCnst, Db;

type
  TDMAlimentos = class(TDataModule)
    TbOrigem: TTable;
    TbOrigemIDORIG: TStringField;
    TbOrigemDESCRICAO: TStringField;
    TbGAlimentar: TTable;
    TbGAlimentarIDGRUALI: TStringField;
    TbGAlimentarNOMEGRU: TStringField;
    DSOrigem: TDataSource;
    DSGAlimentar: TDataSource;
    DSAlimento: TDataSource;
    TbAlimento: TTable;
    TbAlimentoNOME: TStringField;
    TbAlimentoNOMESIMP: TStringField;
    TbAlimentoIDGRUALI: TStringField;
    TbAlimentoTIPOALI: TStringField;
    TbAlimentoOrigem: TStringField;
    TbAlimentoGrupoAlimentar: TStringField;
    DSAlimentobk: TDataSource;
    TbAlimentoBk: TTable;
    TbMedidas: TTable;
    TbMedidasMEDIDA: TStringField;
    DSMedidas: TDataSource;
    DSMedidasCaseiras: TDataSource;
    TbMedidasCaseiras: TTable;
    TbMedidasCaseirasIDALI: TStringField;
    TbMedidasCaseirasIDMEDCAS: TStringField;
    TbMedidasCaseirasVALOR: TFloatField;
    TbMedidasCaseirasNomeMedida: TStringField;
    DSPreparac: TDataSource;
    TbPreparac: TTable;
    TbPreparacPrep: TMemoField;
    DSMCVisNut: TDataSource;
    TbMCVisNut: TTable;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    TbMCVisNutVALOR: TFloatField;
    DSMCPreco: TDataSource;
    TbMCPreco: TTable;
    TbMCPrecoIDALI: TStringField;
    TbMCPrecoIDMEDCAS: TStringField;
    TbMCPrecoVALOR: TFloatField;
    TbMedPr: TTable;
    StringField16: TStringField;
    DSMedPr: TDataSource;
    TbMCPrecoNomeMedida: TStringField;
    TbPrecoAli: TTable;
    TbPrecoAliIDALI: TStringField;
    TbPrecoAliIDMEDCAS: TStringField;
    TbPrecoAliQTDE: TFloatField;
    TbPrecoAliPRECO: TFloatField;
    TbPrecoAliMEDGR: TStringField;
    DSPrecoAli: TDataSource;
    TbMCPrecoNomeValor: TStringField;
    TbMVisNut: TTable;
    StringField18: TStringField;
    DSMVisNut: TDataSource;
    DSMCSC: TDataSource;
    TbMCSC: TTable;
    StringField19: TStringField;
    StringField20: TStringField;
    TbMSC: TTable;
    StringField23: TStringField;
    DSMSC: TDataSource;
    TbMCSCVALOR: TFloatField;
    TbMCSCNomeValor: TStringField;
    TbMCSCNomeMedida: TStringField;
    DSMCSP: TDataSource;
    TbMCSP: TTable;
    StringField21: TStringField;
    StringField24: TStringField;
    TbMSP: TTable;
    StringField28: TStringField;
    DSMSP: TDataSource;
    TbMCSPNomeValor: TStringField;
    TbMCSPNomeMedida: TStringField;
    TbMCSPVALOR: TFloatField;
    DSAliNut: TDataSource;
    TbAliNut: TTable;
    TbAliNutIDALI: TStringField;
    TbAliNutIDNUT: TStringField;
    TbAliNutVALOR: TFloatField;
    TbAliGCal: TTable;
    TbAliGCalQTDE: TStringField;
    TbAliGCalIDALI: TStringField;
    TbAliGCalIDGRUCAL: TStringField;
    TbAliGCalIDMEDCAS: TStringField;
    TbAliGCalMEDGR: TStringField;
    DSAliGCal: TDataSource;
    DSAliGProt: TDataSource;
    TbAliGProt: TTable;
    TbAliGProtIdali: TStringField;
    TbAliGProtIdGruProt: TStringField;
    TbAliGProtIdMedCas: TStringField;
    TbAliGProtQtde: TStringField;
    TbAliGProtMedGr: TStringField;
    TbAlimentoBkNOME: TStringField;
    TbAlimentoBkNOMESIMP: TStringField;
    TbAlimentoBkIDGRUALI: TStringField;
    TbAlimentoBkTIPOALI: TStringField;
    DSAliNutBK: TDataSource;
    TbAliNutBK: TTable;
    TbAliNutBKIDALI: TStringField;
    TbAliNutBKIDNUT: TStringField;
    TbAliNutBKVALOR: TFloatField;
    TbAlimentoIDALI: TStringField;
    TbAlimentoIDORIG: TStringField;
    TbAlimentoBkIDALI: TStringField;
    TbAlimentoBkIDORIG: TStringField;
    TbMedidasIDMEDCAS: TStringField;
    TbPreparacIDALI: TStringField;
    TbMVisNutIDMEDCAS: TStringField;
    TbMedPrIDMEDCAS: TStringField;
    TbMSCIDMEDCAS: TStringField;
    TbMSPIDMEDCAS: TStringField;
    TbAlimentoOBSALI: TStringField;
    TbAlimentoBkOBSALI: TStringField;
    TbPrecoAliDATA: TDateTimeField;
    TbPreparacDATA: TDateTimeField;
    DBOrganizador: TDatabase;
    TbAlimentoPREP: TStringField;
    TbAlimentoBkPREP: TStringField;
    tbRefeicao: TTable;
    DSRefeicao: TDataSource;
    tbRefeicaoID_REFEICAO: TStringField;
    tbRefeicaoNOME: TStringField;
    tbRefeicaoHORARIO: TDateTimeField;
    DSListaRefeicao: TDataSource;
    tbListaRefeicao: TTable;
    tbListaRefeicaoID_REFEICAO: TStringField;
    tbListaRefeicaoID_MODREF: TStringField;
    tbListaRefeicaoHORARIO: TDateTimeField;
    DSModRefeicao: TDataSource;
    tbModRefeicao: TTable;
    tbModRefeicaoID_MODREF: TStringField;
    tbModRefeicaoNOME: TStringField;
    tbListaRefeicaoRefeicao: TStringField;
    tbListaRefeicaoModeloRef: TStringField;
    TbMedidasCaseirasORDPADRAO: TFloatField;
    TbMedidasCaseirasPORCAOPAD: TStringField;
    DSFonetAlim: TDataSource;
    qrFonetAlim: TQuery;
    TbPrecoAliMedidaCaseira: TStringField;
    DSNutrientesbk: TDataSource;
    TbNutrientesbk: TTable;
    TbNutrientesbkIDNUT: TStringField;
    TbNutrientesbkNOMENUT: TStringField;
    TbAliNutBKNutrientes: TStringField;
    DSDuplicaAlim: TDataSource;
    qrDuplicaAlim: TQuery;
    DSVerRefeicoes: TDataSource;
    TbVerRefeicoes: TTable;
    TbVerRefeicoesID_REFEICAO: TStringField;
    TbVerRefeicoesID_MODREF: TStringField;
    TbVerRefeicoesHORARIO: TDateTimeField;
    TbVerRefeicoesNomeRefeicao: TStringField;
    DSVerModRefeicao: TDataSource;
    TbVerModRefeicao: TTable;
    StringField1: TStringField;
    StringField2: TStringField;
    TbGAlimentarPROTAVB: TStringField;
    TbGAlimentarREADONLY: TStringField;
    TbMedidasREADONLY: TStringField;
    TbOrigemREADONLY: TStringField;
    procedure TbOrigemNewRecord(DataSet: TDataSet);
    procedure TbGAlimentarNewRecord(DataSet: TDataSet);
    procedure QAlimentoAfterPost(DataSet: TDataSet);
    procedure QAlimentoBeforeDelete(DataSet: TDataSet);
    procedure TbAlimentoNewRecord(DataSet: TDataSet);
    procedure TbPrecoAliNewRecord(DataSet: TDataSet);
    procedure TbMCPrecoCalcFields(DataSet: TDataSet);
    procedure TbMCSCCalcFields(DataSet: TDataSet);
    procedure TbMCSPCalcFields(DataSet: TDataSet);
    procedure TbGAlimentarBeforeDelete(DataSet: TDataSet);
    procedure tbRefeicaoNewRecord(DataSet: TDataSet);
    procedure tbModRefeicaoNewRecord(DataSet: TDataSet);
    procedure TbOrigemPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure tbRefeicaoPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure tbListaRefeicaoPostError(DataSet: TDataSet;
      E: EDatabaseError; var Action: TDataAction);
    procedure tbModRefeicaoPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbGAlimentarPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbOrigemBeforeDelete(DataSet: TDataSet);
    procedure tbRefeicaoBeforeDelete(DataSet: TDataSet);
    procedure tbListaRefeicaoBeforeDelete(DataSet: TDataSet);
    procedure tbModRefeicaoBeforeDelete(DataSet: TDataSet);
    procedure TbGAlimentarBeforeEdit(DataSet: TDataSet);
    procedure TbOrigemBeforeEdit(DataSet: TDataSet);
    procedure DMAlimentosCreate(Sender: TObject);
  private
    FAlimentoADuplicar: string;
    FCodAlimentoADuplicar: string;
    procedure SetAlimentoADuplicar(const Value: string);
    procedure SetCodAlimentoADuplicar(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    procedure GravaDados;
    procedure DeletaAlimento;
    function ConfirmaDelecao : boolean;
    function TravaGruposAlimentares : boolean ;
    property AlimentoADuplicar : string  read FAlimentoADuplicar write SetAlimentoADuplicar;
    property CodAlimentoADuplicar : string read FCodAlimentoADuplicar write SetCodAlimentoADuplicar;
  end;

var
  DMAlimentos: TDMAlimentos;

implementation

uses DMMedidas, DMSubstCal, Alimento, uAliasName;

{$R *.DFM}

function TDMAlimentos.ConfirmaDelecao : boolean;
begin
// Esta função pode ser usada direto no before de qualquer banco de dados.
// Não coloquei nos alimentos porque como mando deletar em cascata, ficava me perguntando para cada banco.

  if MessageDlg('Confirma a exclusão dos dados ?',mtConfirmation, [mbYes, mbNo], 0) = mrNo then
     begin
      Abort ;
      Result := False;
     end
  else
      Result := True;
end;


procedure TDMAlimentos.DeletaAlimento;
var
I : integer;

begin
    // Deleta todos os dados do Alimento

    // Avisa antes de deletar se tem dieta ou inquerito que utiliza este alimento.


    // Dados do DMAlimento
    for I:=0 to DMAlimentos.ComponentCount -1 do
    begin
       if DMAlimentos.Components[i] is TTable then
          if  (DMAlimentos.Components[i] as TTable).Mastersource = DSAlimento then
          begin
            (DMAlimentos.Components[i] as TTable).First;
           While (DMAlimentos.Components[i] as TTable).RecordCount <> 0 do
              begin
                if not (DMAlimentos.Components[i] as TTable).IsEmpty then
                  begin
                 // ShowMessage( (DMAlimentos.Components[i] as TTable).name + '  ' + InttoStr((DMAlimentos.Components[i] as TTable).RecordCount) );
                  (DMAlimentos.Components[i] as TTable).Delete;
                  (DMAlimentos.Components[i] as TTable).Next;
                  end;
              end;
          end;

    end;

    // Dados do DMSubsCalorico
    for I:=0 to DMSubsCalorico.ComponentCount -1 do
    begin
       if DMSubsCalorico.Components[i] is TTable then
          if  (DMSubsCalorico.Components[i] as TTable).Mastersource = DMAlimentos.DSAlimento then
          begin
            (DMSubsCalorico.Components[i] as TTable).First;
           While (DMSubsCalorico.Components[i] as TTable).RecordCount <> 0 do
              begin
                if not (DMSubsCalorico.Components[i] as TTable).IsEmpty then
                  begin
                 // ShowMessage( (DMSubsCalorico.Components[i] as TTable).name + '  ' + InttoStr((DMSubsCalorico.Components[i] as TTable).RecordCount) );
                  (DMSubsCalorico.Components[i] as TTable).Delete;
                  (DMSubsCalorico.Components[i] as TTable).Next;
                  end;
              end;
          end;

    end;



end;





procedure TDMAlimentos.TbOrigemNewRecord(DataSet: TDataSet);
begin
   TbOrigemIDORIG.AsString:=CreateNewGUID;
   TbOrigem.Fieldbyname('READONLY').AsString  := 'F';
end;

procedure TDMAlimentos.TbGAlimentarNewRecord(DataSet: TDataSet);
begin
   TbGAlimentarIDGRUALI.AsString:=CreateNewGUID;
   TbGAlimentar.Fieldbyname('READONLY').AsString  := 'F';

end;
procedure TDMAlimentos.GravaDados;
var
I : integer;
begin
with DBOrganizador do
     begin
//     StartTransaction;
     Try
      for I :=0 to DatasetCount -1 do
          begin
          if DataSets[I].CachedUpdates=True  then //and ((DataSets[I].State = dsEdit) or (DataSets[I].State = dsInsert))
          begin
          DataSets[I].ApplyUpdates;
          DataSets[I].CommitUpdates;
          end;
          if (DataSets[I].Name <> '') then
             DataSets[I].Refresh;
          end;
     //QAlim2.Close;
     //QAlim2.Open;
//     DMFisico.QAlim2.Refresh;
//     DMFisico.TbIngredientes.Refresh;
//       DMFisico.TbIngredientes.Close;
//       DMFisico.TbIngredientes.Open;
     except
//      Rollback;
      raise;
     end;
//     Commit;
     end;
end;

procedure TDMAlimentos.QAlimentoAfterPost(DataSet: TDataSet);
begin
GravaDados;
end;

procedure TDMAlimentos.QAlimentoBeforeDelete(DataSet: TDataSet);
begin
    ShowMessage( 'Atenção !!! Você pode estar apagando um alimento que existe em dietas e inquéritos. Continua ?');

end;

procedure TDMAlimentos.TbAlimentoNewRecord(DataSet: TDataSet);
begin
   TbAlimentoIDALI.AsString  := CreateNewGUID;
   TbAlimento.FieldByName('PREP').asString := 'F';
   //DMAlimentos.TbPrep.Insert;
   //DMAlimentos.TbIngrPrep.Insert;
end;

procedure TDMAlimentos.TbPrecoAliNewRecord(DataSet: TDataSet);
begin
    DMAlimentos.TbPrecoAli.Fieldbyname('DATA').AsDateTime := Date;
end;

procedure TDMAlimentos.TbMCPrecoCalcFields(DataSet: TDataSet);
begin
      DMAlimentos.TbMCPrecoNOMEVALOR.AsString := DMAlimentos.TbMCPrecoNomeMedida.asString +
                  ' (' + DMAlimentos.TbMCPrecoVALOR.asString + 'g' + ')' ;
end;

procedure TDMAlimentos.TbMCSCCalcFields(DataSet: TDataSet);
begin
   DMAlimentos.TbMCSCNOMEVALOR.AsString := DMAlimentos.TbMCSCNomeMedida.asString +
            ' (' + DMAlimentos.TbMCSCVALOR.asString + 'g' + ')' ;

end;

procedure TDMAlimentos.TbMCSPCalcFields(DataSet: TDataSet);
begin
   DMAlimentos.TbMCSPNOMEVALOR.AsString := DMAlimentos.TbMCSPNomeMedida.asString +
            ' (' + DMAlimentos.TbMCSPVALOR.asString + 'g' + ')' ;

end;

function TDMAlimentos.TravaGruposAlimentares : boolean;
begin
       // Verifico se alguem quer apagar um destes grupos e não deixo.
       with DMAlimentos.TbGAlimentar do
        begin
          if (FieldByName('IDGRUALI').asString = '{34011660-AAFD-11D2-8C95-00609723109D}') or //        OLEAGINOSAS
             (FieldByName('IDGRUALI').asString = '{34011661-AAFD-11D2-8C95-00609723109D}') or //	OUTRAS CARNES
             (FieldByName('IDGRUALI').asString = '{34011662-AAFD-11D2-8C95-00609723109D}') or //	PRATOS PRONTOS
             (FieldByName('IDGRUALI').asString = '{88DD935A-66F8-11D1-A6A0-008048B86BEE}') or //	FRUTAS
             (FieldByName('IDGRUALI').asString = '{88DD935B-66F8-11D1-A6A0-008048B86BEE}') or //	HORTALIÇAS
             (FieldByName('IDGRUALI').asString = '{88DD935C-66F8-11D1-A6A0-008048B86BEE}') or //	CARNE BOVINA
             (FieldByName('IDGRUALI').asString = '{88DD935D-66F8-11D1-A6A0-008048B86BEE}') or //	ACUCARES/DOCES/SOBREMESAS
             (FieldByName('IDGRUALI').asString = '{88DD935E-66F8-11D1-A6A0-008048B86BEE}') or //	BEBIDAS
             (FieldByName('IDGRUALI').asString = '{88DD935F-66F8-11D1-A6A0-008048B86BEE}') or //	TUBERCULOS
             (FieldByName('IDGRUALI').asString = '{88DD9360-66F8-11D1-A6A0-008048B86BEE}') or //	OLEOS/GORDURAS
             (FieldByName('IDGRUALI').asString = '{88DD9361-66F8-11D1-A6A0-008048B86BEE}') or //	PEIXES/FRUTOS DO MAR
             (FieldByName('IDGRUALI').asString = '{88DD9362-66F8-11D1-A6A0-008048B86BEE}') or //	CEREAIS/DERIVADOS
             (FieldByName('IDGRUALI').asString = '{88DD9363-66F8-11D1-A6A0-008048B86BEE}') or //	CARNE SUINA
             (FieldByName('IDGRUALI').asString = '{88DD9364-66F8-11D1-A6A0-008048B86BEE}') or //	LEITE/SUBSTITUTOS
             (FieldByName('IDGRUALI').asString = '{88DD9365-66F8-11D1-A6A0-008048B86BEE}') or //	LEGUMINOSAS
             (FieldByName('IDGRUALI').asString = '{88DD9366-66F8-11D1-A6A0-008048B86BEE}') or //	AVES
             (FieldByName('IDGRUALI').asString = '{88DD9367-66F8-11D1-A6A0-008048B86BEE}') or //	FORMULADOS
             (FieldByName('IDGRUALI').asString = '{88DD9368-66F8-11D1-A6A0-008048B86BEE}') or //	OVOS
             (FieldByName('IDGRUALI').asString = '{88DD9369-66F8-11D1-A6A0-008048B86BEE}') or //	PREPARACAO/RECEITA
             (FieldByName('IDGRUALI').asString = '{8B8455B0-C0CD-11D2-86AB-ECFEC2437F41}') or //	EMBUTIDOS
             (FieldByName('IDGRUALI').asString = '{8C1E7C60-BA94-11D2-86AB-ECFEC2437F41}') or //	SEMENTES
             (FieldByName('IDGRUALI').asString = '{CE1E4688-B9DC-11D2-86AB-ECFEC2437F41}') then //	TEMPERO
              Result := True
          else
             Result := False;
        end;
end;


procedure TDMAlimentos.TbGAlimentarBeforeDelete(DataSet: TDataSet);
begin
   if TravaGruposAlimentares then
      begin
        ShowMessage('Este grupo não pode ser apagado.' );
        Abort;
      end

end;



procedure TDMAlimentos.tbRefeicaoNewRecord(DataSet: TDataSet);
begin
   TbRefeicao.FieldByName('Id_Refeicao').AsString  := CreateNewGUID;
end;

procedure TDMAlimentos.tbModRefeicaoNewRecord(DataSet: TDataSet);
begin
   TbModRefeicao.FieldByName('Id_ModRef').AsString  := CreateNewGUID;
end;


procedure TDMAlimentos.TbOrigemPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMAlimentos.tbRefeicaoPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMAlimentos.tbListaRefeicaoPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMAlimentos.tbModRefeicaoPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMAlimentos.TbGAlimentarPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
 ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMAlimentos.SetAlimentoADuplicar(const Value: string);
begin
  FAlimentoADuplicar := Value;
end;

procedure TDMAlimentos.SetCodAlimentoADuplicar(const Value: string);
begin
  FCodAlimentoADuplicar := Value;
end;

procedure TDMAlimentos.TbOrigemBeforeDelete(DataSet: TDataSet);
begin
   if TbOrigem.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Esta informação não pode ser apagada.');
       Abort;
      end;
end;

procedure TDMAlimentos.tbRefeicaoBeforeDelete(DataSet: TDataSet);
begin
   if MessageDlg('Esta exclusão poderá afetar informações já existentes em outros cadastros. Continua? ', mtConfirmation,
         [mbYes, mbNo], 0) = mrNo then
         begin
           Abort;
         end ;
end;

procedure TDMAlimentos.tbListaRefeicaoBeforeDelete(DataSet: TDataSet);
begin
   if MessageDlg('Esta exclusão poderá afetar informações já existentes em outros cadastros. Continua? ', mtConfirmation,
         [mbYes, mbNo], 0) = mrNo then
         begin
           Abort;
         end ;
end;

procedure TDMAlimentos.tbModRefeicaoBeforeDelete(DataSet: TDataSet);
begin
   if MessageDlg('Esta exclusão poderá afetar informações já existentes em outros cadastros. Continua? ', mtConfirmation,
         [mbYes, mbNo], 0) = mrNo then
         begin
           Abort;
         end ;
end;

procedure TDMAlimentos.TbGAlimentarBeforeEdit(DataSet: TDataSet);
begin
   if TravaGruposAlimentares then
      begin
        ShowMessage('Este grupo não pode ser editado.' );
        Abort;
      end
end;

procedure TDMAlimentos.TbOrigemBeforeEdit(DataSet: TDataSet);
begin
   if TbOrigem.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Este grupo não pode ser editado.');
       Abort;
      end;
end;

procedure TDMAlimentos.DMAlimentosCreate(Sender: TObject);
begin
DBOrganizador.AliasName := BDE_ALIAS_NAME;
openAllTables(self);
end;

end.

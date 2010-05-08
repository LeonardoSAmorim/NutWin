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
  DBTables, dbpersis, Db;

type
  TDMAlimentos = class(TDataModule)
    TbOrigem: TTable;
    TbOrigemIDORIG: TStringField;
    TbOrigemDESCRICAO: TStringField;
    TbGAlimentar: TTable;
    TbGAlimentarIDGRUALI: TStringField;
    TbGAlimentarNOMEGRU: TStringField;
    DBOrganizador: TDatabase;
    DSOrigem: TDataSource;
    DSGAlimentar: TDataSource;
    DSAlimento: TDataSource;
    TbAlimento: TTable;
    TbAlimentoNOME: TStringField;
    TbAlimentoNOMESIMP: TStringField;
    TbAlimentoIDGRUALI: TStringField;
    TbAlimentoIDMEDPAD: TStringField;
    TbAlimentoTIPOALI: TStringField;
    TbAlimentoOUIDPai: TStringField;
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
    TbPreparacData: TDateField;
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
    TbPrecoAliDATA: TDateField;
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
    TbAlimentoBkIDMEDPAD: TStringField;
    TbAlimentoBkTIPOALI: TStringField;
    TbAlimentoBkOUIDPai: TStringField;
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
    TbAlimentoPREP: TStringField;
    TbAlimentoOBSALI: TStringField;
    TbAlimentoBkPREP: TStringField;
    TbAlimentoBkOBSALI: TStringField;
    procedure TbOrigemNewRecord(DataSet: TDataSet);
    procedure TbGAlimentarNewRecord(DataSet: TDataSet);
    procedure QAlimentoAfterPost(DataSet: TDataSet);
    procedure QAlimentoBeforeDelete(DataSet: TDataSet);
    procedure TbAlimentoNewRecord(DataSet: TDataSet);
    procedure TbPrecoAliNewRecord(DataSet: TDataSet);
    procedure TbPrecoAliBeforePost(DataSet: TDataSet);
    procedure TbMCPrecoCalcFields(DataSet: TDataSet);
    procedure TbMCSCCalcFields(DataSet: TDataSet);
    procedure TbMCSPCalcFields(DataSet: TDataSet);
    procedure TbAlimentoBeforeDelete(DataSet: TDataSet);
    procedure TbPreparacBeforeDelete(DataSet: TDataSet);
    procedure TbPrecoAliBeforeDelete(DataSet: TDataSet);
    procedure TbMedidasCaseirasBeforeDelete(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GravaDados;
    procedure DeletaAlimento;
    function ConfirmaDelecao : boolean;
  end;

var
  DMAlimentos: TDMAlimentos;

implementation

uses DMMedidas, DMSubstCal, Alimento;

{$R *.DFM}

function TDMAlimentos.ConfirmaDelecao : boolean;
begin
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
   TbOrigemIDORIG.AsString:=TDSPersist.CreateNewGUID;
end;

procedure TDMAlimentos.TbGAlimentarNewRecord(DataSet: TDataSet);
begin
   TbGAlimentarIDGRUALI.AsString:=TDSPersist.CreateNewGUID;

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
   TbAlimentoIDALI.AsString  := TDSPersist.CreateNewGUID;
   TbAlimento.FieldByName('PREP').asString := 'F';
   //DMAlimentos.TbPrep.Insert;
   //DMAlimentos.TbIngrPrep.Insert;
end;

procedure TDMAlimentos.TbPrecoAliNewRecord(DataSet: TDataSet);
begin
    DMAlimentos.TbPrecoAliDATA.AsDateTime := Date;
end;

procedure TDMAlimentos.TbPrecoAliBeforePost(DataSet: TDataSet);
begin
    DMAlimentos.TbPrecoAliDATA.AsDateTime := Date;
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

procedure TDMAlimentos.TbAlimentoBeforeDelete(DataSet: TDataSet);
begin
    ConfirmaDelecao ;
    DMAlimentos.DeletaAlimento;

end;

procedure TDMAlimentos.TbPreparacBeforeDelete(DataSet: TDataSet);
begin
    ConfirmaDelecao ;
end;

procedure TDMAlimentos.TbPrecoAliBeforeDelete(DataSet: TDataSet);
begin
    ConfirmaDelecao ;
end;

procedure TDMAlimentos.TbMedidasCaseirasBeforeDelete(DataSet: TDataSet);
begin
    ConfirmaDelecao ;
end;

end.

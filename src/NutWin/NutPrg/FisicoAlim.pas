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




unit FisicoAlim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, dbpersis;

type
  TDMFisico = class(TDataModule)
    QAlimento: TQueryPersist;
    QPreparacao: TQueryPersist;
    UPAlimento: TUpdateObjectView;
    UpPreparacao: TUpdateObjectView;
    DBOrganizador: TDatabase;
    QAlim2: TQueryPersist;
    UpAlim2: TUpdateObjectView;
    QPreparacaoOUID: TStringField;
    QPreparacaoNOME: TStringField;
    QPreparacaoNOMESIMP: TStringField;
    QPreparacaoIDORG: TStringField;
    QPreparacaoIDGRUALI: TStringField;
    QPreparacaoIDMEDPAD: TStringField;
    QPreparacaoTIPOALI: TStringField;
    QPreparacaoOUIDPai: TStringField;
    QPreparacaoOUID_1: TStringField;
    QPreparacaoOUIDPai_1: TStringField;
    QPreparacaoPESOFINAL: TFloatField;
    QPreparacaoRECEITA: TMemoField;
    TbIngredientes: TTable;
    TbIngredientesIDPREP: TStringField;
    TbIngredientesIDALI: TStringField;
    TbIngredientesIDMEDCAS: TStringField;
    TbIngredientesQTDE: TFloatField;
    TbIngredientesMISTURADO: TBooleanField;
    TbIngredientesAlimento: TStringField;
    TbSubIngredientes: TTable;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    FloatField1: TFloatField;
    StringField4: TStringField;
    TbOrigem: TTable;
    QAlimentoOUID: TStringField;
    QAlimentoNOME: TStringField;
    QAlimentoNOMESIMP: TStringField;
    QAlimentoIDORG: TStringField;
    QAlimentoIDGRUALI: TStringField;
    QAlimentoIDMEDPAD: TStringField;
    QAlimentoTIPOALI: TStringField;
    QAlimentoOUIDPai: TStringField;
    TbOrigemIDORIG: TStringField;
    TbOrigemDESCRICAO: TStringField;
    TbMedidasCaseiras: TTable;
    TbMedidas: TTable;
    TbMedidasCaseirasIDALI: TStringField;
    TbMedidasCaseirasIDMEDCAS: TStringField;
    TbMedidasCaseirasVALOR: TFloatField;
    TbMedidasCaseirasNomeMedida: TStringField;
    TbGAlimentar: TTable;
    TbMedidasIDMED: TStringField;
    TbMedidasMEDIDA: TStringField;
    TbGAlimentarIDGRUALI: TStringField;
    TbGAlimentarNOMEGRU: TStringField;
    TbPrecoAli: TTable;
    TbPrecoAliIDALI: TStringField;
    TbPrecoAliIDMEDCAS: TStringField;
    TbPrecoAliQTDE: TFloatField;
    TbPrecoAliPRECO: TFloatField;
    TbPrecoAliDATA: TDateField;
    TbPrecoAliMedida: TStringField;
    TbNutrientes: TTable;
    TbNutrientesIDNUT: TStringField;
    TbNutrientesABREV: TStringField;
    TbNutrientesNOMENUT: TStringField;
    TbNutrientesUNIDADE: TStringField;
    TbAliNut: TTable;
    TbAliNutVALOR: TFloatField;
    TbAliNutAlimento: TStringField;
    TbAliNutNutriente: TStringField;
    TbAliNutIDALI: TStringField;
    TbAliNutIDNUT: TStringField;
    TbAliNutalim: TStringField;
    TbIngredientesMedidaCaseira: TStringField;
    TbGruCal: TTable;
    TbGAliCal: TTable;
    TbAliGCal: TTable;
    TbAliGCalIDALI: TStringField;
    TbAliGCalIDGRUCAL: TStringField;
    TbAliGCalIDMEDCAS: TStringField;
    TbAliGCalQTDE: TStringField;
    TbGAliCalID_GRUCAL: TStringField;
    TbGAliCalID_GRUALI: TStringField;
    TbAliGCalMedidaCaseira: TStringField;
    TbGAliCalNomeCal: TStringField;
    TbAliGCalNomeGruCal: TStringField;
    TbSubIngredientesMISTURADO: TBooleanField;
    QAlimentoGrupoAlimentar: TStringField;
    QAlimentoOrigem: TStringField;
    QPreparacaoOrigem: TStringField;
    QPreparacaoGrupoAlimentar: TStringField;
    TbMedCasLkp: TTable;
    StringField5: TStringField;
    StringField6: TStringField;
    FloatField2: TFloatField;
    StringField7: TStringField;
    TbMedidasCaseirasMedidaEscolhida: TStringField;
    procedure TbOrigemNewRecord(DataSet: TDataSet);
    procedure TbMedidasNewRecord(DataSet: TDataSet);
    procedure TbGAlimentarNewRecord(DataSet: TDataSet);
    procedure TbMedidasCaseirasNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function AchaValorNutriente( NomeNut : string ) : string;

  end;

var
  DMFisico: TDMFisico;

implementation

uses ModAlim, TstAlim;

{$R *.DFM}

procedure TDMFisico.TbOrigemNewRecord(DataSet: TDataSet);
begin
    TbOrigemIDORIG.AsString:=TDSPersist.CreateNewGUID;
end;

procedure TDMFisico.TbMedidasNewRecord(DataSet: TDataSet);
begin
    TbMedidasIDMED.AsString:=TDSPersist.CreateNewGUID;
end;

procedure TDMFisico.TbGAlimentarNewRecord(DataSet: TDataSet);
begin
    TbGAlimentarIDGRUALI.AsString:=TDSPersist.CreateNewGUID;
end;

procedure TDMFisico.TbMedidasCaseirasNewRecord(DataSet: TDataSet);
begin
  TbMedidasCaseirasIDMEDCAS.AsString:=TDSPersist.CreateNewGUID;
end;

function TDMFisico.AchaValorNutriente( NomeNut : string ) : string;

var
   stCodNut : string;

begin
// Os nutrientes ja estao filtrados por alimento.
  TbNutrientes.Open;
  If TbNutrientes.Locate('NOMENUT', NomeNut,[]) then
     begin
     stCodNut := TbNutrientes.FieldByName ('IDNUT').AsString;

     // Procura, dependendo do Nome do Nutriente, o seu valor
     TbAliNut.Open;
     TbAliNut.Locate( 'IDNUT', stCodNut,[]);
     AchaValorNutriente := FloattoStr( TbAliNut['VALOR'] );
    end
  else
      AchaValorNutriente := '0' ;

end;


end.

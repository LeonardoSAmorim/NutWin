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




{ **************************************************************************** }
{   SISTEMA DE APOIO A NUTRICAO                                                }
{                                                                              }
{   Units:         TCalcAli........................... T1                      }
{   Componentes:   TCustomCalculoAlimentar............ T2                      }
{                  TCalculoAlimentar.................. T3                      }
{                  TCalculoDieta...................... T4                      }
{                  TCalculoInquerito.................. T5                      }
{                  TCalculoInqueritoFrequencia........ T6                      }
{                  TCalculoPreparacao................. T7                      }
{                                                                              }
{   created on 2 March 1998 at 14:05                                           }
{                                                                              }
{   Copyright © 1998 by DIS-EPM/UNIFESP                                        }
{                                                                              }
{ **************************************************************************** }

unit CalcAli;

interface

uses SysUtils, Classes, DB, Controls, DBTables, Dialogs, Forms, Stdctrls,
     memoria, measurement, CCSDBListaLinks, MacroNut, CLstAli, CAlimento,
     DelayedOpIndicator, NutCnst, ItemAlimentar;

{******************************************************************************}
{                                 T1-TCALCALI                                  }
{******************************************************************************}

const

   // estes identificadores não podem ser alterados
   IDREFGLOBAL = '{406472C0-4A45-11D3-9DBD-000021609D7C}';
   IDMEDGRAMAS = '{406472C1-4A45-11D3-9DBD-000021609D7C}';
   IDPROTEINA  = '{B01C0040-AEE3-11D2-B4C0-00609723104C}';
   IDAGSATURADO       = '{B01C0070-AEE3-11D2-B4C0-00609723104C}';
   IDAGPOLINSATURADO  = '{B01C0083-AEE3-11D2-B4C0-00609723104C}';
   IDAGMONOINSATURADO = '{B01C0082-AEE3-11D2-B4C0-00609723104C}';
   IDCALCIO = '{B01C0049-AEE3-11D2-B4C0-00609723104C}';
   IDFOSFORO = '{B01C004C-AEE3-11D2-B4C0-00609723104C}';
   IDENERGIA = '{B01C0044-AEE3-11D2-B4C0-00609723104C}';
   IDCARBOIDRATO =  '{B01C0042-AEE3-11D2-B4C0-00609723104C}';
   IDALCOOL = '{B01C0045-AEE3-11D2-B4C0-00609723104C}';
   IDAGUA = '{B01C0046-AEE3-11D2-B4C0-00609723104C}';
   // usado no arquivo .NUT
   OBS_NAME = 'Observacao';

type

  // Para ativar os cálculos
  TTipoCalculoAlimentar = (
     tcaTotalNutrientes,
     tcaPorcentagemNutrientesValidos,
     tcaTotalMacroNutrientes,
     tcaProteinaAVBPorRefeicao,
     tcaProteinaAVBPorCalculo,
     tcaRelacaoCaPPorRefeicao,
     tcaRelacaoCaPPorCalculo,
     tcaRelacaoAcidosGraxosPorRef,
     tcaRelacaoAcidosGraxosPorCalc,
     tcaRelacaoCaloriaNitrogenioPorRef,
     tcaRelacaoCaloriaNitrogenioPorCalc,
     tcaPorcentagemEnergiaCalculada,
     tcaNutrientesPorPesoDia,
     tcaGrupoAlimentarPorNutriente,
     tcaAlimentoPorNutriente,
     tcaSaldoNutrientes );

  TListaCalculosAlimentares = set of TTipoCalculoAlimentar;

  // Notity dos eventos On...Item para passar o ID da refeição
  TNotifyItemRefeicao = procedure (Sender: TObject; const IDRefeicao : String ) of object;

  TCalcAli = class(TDataModule)
     dsItensAli: TDataSource;
     taItensAli: TTable;
     dsAlimento: TDataSource;
     taAlimento: TTable;
     taAlimentoIDALI: TStringField;
     taAlimentoNOME: TStringField;
     taAlimentoNOMESIMP: TStringField;
     taAlimentoIDORIG: TStringField;
     taAlimentoIDGRUALI: TStringField;
     taAlimentoTIPOALI: TStringField;
     dsMedCas: TDataSource;
     taMedCas: TTable;
     taMedCasIDMEDCAS: TStringField;
     taMedCasMEDIDA: TStringField;
     dsTotalNut: TDataSource;
     taTotalNut: TTable;
     taTotalNutIDNUT: TStringField;
     taTotalNutABREV: TStringField;
     taTotalNutNOMENUT: TStringField;
     taTotalNutUNIDADE: TStringField;
     taTotalNutVALORTOT: TFloatField;
     taTotalNutVALORREF: TFloatField;
     taTotalNutREFTOT: TFloatField;
     taItensAliAux: TTable;
     taAliNut: TTable;
     taAliNutIDALI: TStringField;
     taAliNutIDNUT: TStringField;
     taAliNutVALOR: TFloatField;
     dsRefeicao: TDataSource;
     dsRefCalcAli: TDataSource;
     taRefCalcAli: TTable;
     taRefCalcAliID_REFEICAO: TStringField;
     taRefCalcAliNOMEREF: TStringField;
     taRefCalcAliHORARIO: TStringField;
     dsItensAliAux: TDataSource;
     taItensAliAll: TTable;
     dsItensAliAll: TDataSource;
     dsAliNut: TDataSource;
     dsMacroNut: TDataSource;
     taMacroNut: TTable;
     taMacroNutIDMACRONUT: TStringField;
     taMacroNutORDPADRAO: TFloatField;
     taMacroNutVALORTOT: TFloatField;
     taMacroNutRELACAOENERGIA: TFloatField;
     taMacroNutVALORTOTREF: TFloatField;
     taMacroNutRELACENERGIAREF: TFloatField;
     taMacroNutFATORENERGIA: TFloatField;
     taMacroNutUNIDADE: TStringField;
     taAlimentoPREP: TStringField;
     taRefCalcAliHORAREF: TTimeField;
     MacroNutTot: TMacroNut;
     MacroNutRef: TMacroNut;
     taTotalNutAux: TTable;
     StringField1: TStringField;
     StringField2: TStringField;
     StringField3: TStringField;
     StringField4: TStringField;
     FloatField1: TFloatField;
     FloatField2: TFloatField;
     FloatField3: TFloatField;
     dsTotalNutAux: TDataSource;
     dsSaldoNut: TDataSource;
     taSaldoNut: TTable;
     StringField5: TStringField;
     StringField6: TStringField;
     StringField7: TStringField;
     StringField8: TStringField;
     FloatField4: TFloatField;
     FloatField5: TFloatField;
     FloatField6: TFloatField;
     taSaldoNutRECNUT: TFloatField;
     taSaldoNutSALDONUT: TFloatField;
     taAlimentoOBSALI: TStringField;
     taMacroNutDESCRICAO: TStringField;
     taRefCalcAliID_CALCALI: TStringField;
     taItensAliID_CALCALI: TStringField;
     taItensAliID_REFEICAO: TStringField;
     taItensAliID_MEDIDA: TStringField;
     taItensAliQUANT: TFloatField;
     taItensAliPESO: TFloatField;
     taItensAliNOMEALI: TStringField;
     taItensAliNOMEMED: TStringField;
     dsCalcAli: TDataSource;
     taCalcAli: TTable;
     taItensAliID_ALI: TStringField;
     quDelCalcAli: TQuery;
     quDelRefCalcAli: TQuery;
     quDelItensAli: TQuery;
     taItensAliFREQDIA: TFloatField;
     taItensAliGUID: TStringField;
     taRefCalcAliGUID: TStringField;
     taCalcAliGUID: TStringField;
     taCalcAliID_CALCALI: TStringField;
     taCalcAliNOME_CALC: TStringField;
     taCalcAliDATA_CRIACAO: TDateTimeField;
     taNut: TTable;
     taNutIDNUT: TStringField;
     taNutABREV: TStringField;
     taNutNOMENUT: TStringField;
     taNutUNIDADE: TStringField;
     taNutORDPADRAO: TFloatField;
     taNutVISIVEL: TStringField;
     taNutIDORIG: TStringField;
     taRefCalcAliDISTRIBUICAO: TFloatField;
     quDistEnergiaTotal: TQuery;
     quDistEnergiaTotalID_CALCALI: TStringField;
     quDistEnergiaTotalSOMA: TFloatField;
     quDistEnergiaVazio: TQuery;
     StringField9: TStringField;
     quDistEnergiaVazioVAZIO: TIntegerField;
     taGruAli: TTable;
     dsGruAli: TDataSource;
     taGruAliIDGRUALI: TStringField;
     taGruAliNOMEGRU: TStringField;
     taGruAliPROTAVB: TStringField;
     taItensAliNUT_PROT: TFloatField;
     quProtAVBRef: TQuery;
     taItensAliNUT_PROTAVB: TFloatField;
     quProtAVBRefID_CALCALI: TStringField;
     quProtAVBRefID_REFEICAO: TStringField;
     quProtAVBRefTOT_PROTAVB: TFloatField;
     quProtAVBRefTOT_PROT: TFloatField;
     quProtAVBRefPERC_PROTAVB: TFloatField;
     quProtAVBCalc: TQuery;
     quProtAVBCalcID_CALCALI: TStringField;
     quProtAVBCalcTOT_PROTAVB: TFloatField;
     quProtAVBCalcTOT_PROT: TFloatField;
     quProtAVBCalcPERC_PROTAVB: TFloatField;
     quRelacaoCaPRef: TQuery;
     quRelacaoCaPRefID_CALCALI: TStringField;
     quRelacaoCaPRefID_REFEICAO: TStringField;
     quRelacaoCaPRefRELREF_CA_P: TFloatField;
     quRelacaoCaPCalc: TQuery;
     quRelacaoCaPCalcID_CALCALI: TStringField;
     quRelacaoCaPCalcRELCALC_CA_P: TFloatField;
     taItensAliNUT_ENERGIA: TFloatField;
     taItensAliNUT_CALCIO: TFloatField;
     taItensAliNUT_FOSFORO: TFloatField;
     taItensAliNUT_AGSAT: TFloatField;
     taItensAliNUT_AGPOL: TFloatField;
     taItensAliNUT_AGMON: TFloatField;
     quRelacaoAgSatPolMonRef: TQuery;
     quRelacaoAgSatPolMonCalc: TQuery;
     quRelacaoAgSatPolMonRefID_CALCALI: TStringField;
     quRelacaoAgSatPolMonRefID_REFEICAO: TStringField;
     quRelacaoAgSatPolMonRefRELREF_AGSAT: TFloatField;
     quRelacaoAgSatPolMonRefRELREF_AGPOL: TFloatField;
     quRelacaoAgSatPolMonCalcID_CALCALI: TStringField;
     quRelacaoAgSatPolMonRefRELREF_AGMON: TFloatField;
     quRelacaoCalNRef: TQuery;
     quRelacaoCalNRefID_CALCALI: TStringField;
     quRelacaoCalNRefID_REFEICAO: TStringField;
     quRelacaoCalNRefREL_CALN_REF: TFloatField;
     quRelacaoCalNCalc: TQuery;
     quRelacaoCalNCalcID_CALCALI: TStringField;
     quRelacaoCalNCalcREL_CALN_CALC: TFloatField;
     taTotalNutVALORTOTPESODIA: TFloatField;
     taTotalNutAuxVALORTOTPESODIA: TFloatField;
     taSaldoNutVALORTOTPESODIA: TFloatField;
     taTotalNutPesoDia: TTable;
     StringField10: TStringField;
     StringField11: TStringField;
     StringField12: TStringField;
     StringField13: TStringField;
     FloatField7: TFloatField;
     FloatField8: TFloatField;
     FloatField9: TFloatField;
     FloatField10: TFloatField;
     dsTotalNutPesoDia: TDataSource;
     taTotalNutPesoDiaUNIDADEPESODIA: TStringField;
     taSaldoNutUNIDADEPESODIA: TStringField;
     taTotalNutAuxUNIDADEPESODIA: TStringField;
     taTotalNutUNIDADEPESODIA: TStringField;
     quPorcentagemEnergia: TQuery;
     quRelacaoAgSatPolMonCalcRELCALC_AGSAT: TFloatField;
     quRelacaoAgSatPolMonCalcRELCALC_AGPOL: TFloatField;
     quRelacaoAgSatPolMonCalcRELCALC_AGMON: TFloatField;
     quPorcentagemEnergiaID_CALCALI: TStringField;
     quPorcentagemEnergiaPORC_ENERGIA_PROT: TFloatField;
     quPorcentagemEnergiaPORC_ENERGIA_CARBO: TFloatField;
     quPorcentagemEnergiaPORC_ENERGIA_AGSAT: TFloatField;
     quPorcentagemEnergiaPORC_ENERGIA_AGMON: TFloatField;
     quPorcentagemEnergiaPORC_ENERGIA_AGPOL: TFloatField;
     quPorcentagemEnergiaPORC_ENERGIA_ALCOOL: TFloatField;
     quPorcentagemEnergiaTOT_ENERGIA_CALC: TFloatField;
     taItensAliNUT_CARBO: TFloatField;
     taItensAliNUT_ALCOOL: TFloatField;
     quPorcentagemEnergiaTOT_ENERGIA: TFloatField;
     taSaldoNutNUTVALIDOREF: TStringField;
     taSaldoNutNUTVALIDOCALC: TStringField;
     taTotalNutAuxNUTVALIDOREF: TStringField;
     taTotalNutAuxNUTVALIDOCALC: TStringField;
     taTotalNutNUTVALIDOREF: TStringField;
     taTotalNutNUTVALIDOCALC: TStringField;
     taTotalNutPesoDiaNUTVALIDOREF: TStringField;
     taTotalNutPesoDiaNUTVALIDOCALC: TStringField;
     taPorcentagemNutValidos: TTable;
     StringField14: TStringField;
     StringField15: TStringField;
     StringField16: TStringField;
     StringField17: TStringField;
     FloatField11: TFloatField;
     StringField18: TStringField;
     FloatField12: TFloatField;
     FloatField13: TFloatField;
     FloatField14: TFloatField;
     StringField19: TStringField;
     StringField20: TStringField;
     taItensAliIDGRUALI: TStringField;
     dsTotGru_Gru: TDataSource;
     taTotGru_Gru: TTable;
     taTotGru_GruIDGRUALI: TStringField;
     taTotGru_GruNOMEGRU: TStringField;
     taTotGru_GruPROTAVB: TStringField;
     dsTotGru_AliNut: TDataSource;
     taTotGru_AliNut: TTable;
     taTotGru_ItensAli: TTable;
     dsTotGru_ItensAli: TDataSource;
     taTotGru_Nut: TTable;
     dsTotGru_Nut: TDataSource;
     dsNut: TDataSource;
     dsPorcentagemNutValidos: TDataSource;
     taTotalNutVISIVEL: TStringField;
     taTotalNutAuxVISIVEL: TStringField;
     taSaldoNutVISIVEL: TStringField;
     taTotalNutPesoDiaVISIVEL: TStringField;
     taPorcentagemNutValidosVISIVEL: TStringField;
     dsTotAli_Ali: TDataSource;
     taTotAli_Ali: TTable;
     StringField21: TStringField;
     StringField22: TStringField;
     StringField23: TStringField;
     StringField24: TStringField;
     StringField25: TStringField;
     FloatField16: TFloatField;
     StringField26: TStringField;
     taTotAli_AliFREQDIA: TFloatField;
     dsTotAli_Nut: TDataSource;
     taTotAli_Nut: TTable;
     dsTotAli_AliNut: TDataSource;
     taTotAli_AliNut: TTable;
     taTotAli_AliQUANT: TFloatField;
     taTotAli_AliIDGRUALI: TStringField;
     taTotAli_AliNUT_PROT: TFloatField;
     taTotAli_AliNUT_PROTAVB: TFloatField;
     taTotAli_AliNUT_ENERGIA: TFloatField;
     taTotAli_AliNUT_CALCIO: TFloatField;
     taTotAli_AliNUT_FOSFORO: TFloatField;
     taTotAli_AliNUT_AGSAT: TFloatField;
     taTotAli_AliNUT_AGPOL: TFloatField;
     taTotAli_AliNUT_AGMON: TFloatField;
     taTotAli_AliNUT_CARBO: TFloatField;
     taTotAli_AliNUT_ALCOOL: TFloatField;
     taCalcAliOBSERVACOES: TBlobField;
     quPesoTotalItensAli: TQuery;
     mdPesoIngredientes: TMedida;
     mdSaldoPeso: TMedida;
     mdAguaRestante: TMedida;
     mdTotalAgua: TMedida;
     taItensAliAllNOMEREF: TStringField;
     taItensAliAllID_REFEICAO: TStringField;
     taItensAliAllID_ALI: TStringField;
     taItensAliAllID_MEDIDA: TStringField;
     taItensAliAllNOMEALI: TStringField;
     taItensAliAllNOMEMED: TStringField;
     taItensAliAllGUID: TStringField;
     taItensAliAllID_CALCALI: TStringField;
     taItensAliAllQUANT: TFloatField;
     taItensAliAllPESO: TFloatField;
     taItensAliAllFREQDIA: TFloatField;
     taItensAliAllIDGRUALI: TStringField;
     taItensAliAllNUT_PROT: TFloatField;
     taItensAliAllNUT_PROTAVB: TFloatField;
     taItensAliAllNUT_ENERGIA: TFloatField;
     taItensAliAllNUT_CALCIO: TFloatField;
     taItensAliAllNUT_FOSFORO: TFloatField;
     taItensAliAllNUT_AGSAT: TFloatField;
     taItensAliAllNUT_AGPOL: TFloatField;
     taItensAliAllNUT_AGMON: TFloatField;
     taItensAliAllNUT_CARBO: TFloatField;
     taItensAliAllNUT_ALCOOL: TFloatField;
     dsModRefeicao: TDataSource;
     taModRefeicao: TTable;
     taModRefeicaoID_MODREF: TStringField;
     taModRefeicaoNOME: TStringField;
     dsRefeicaoAux: TDataSource;
     taRefeicaoAux: TTable;
     quRefeicao: TQuery;
     taRefeicaoAuxID_REFEICAO: TStringField;
     taRefeicaoAuxNOME: TStringField;
     taRefeicaoAuxHORARIO: TDateTimeField;
     taRefeicaoAuxEXCLUSIVE: TStringField;
    taItensAliAllNOMESIMP: TStringField;
    taMacroNutRELACENERGIAUNID: TStringField;
    taTotAli_AliNUT_TEMP: TFloatField;
    taItensAliNUT_TEMP: TFloatField;
    taItensAliITEM: TIntegerField;
    taItensAliAllNUT_TEMP: TFloatField;
    taItensAliAllITEM: TIntegerField;
    quRelacaoCaPCalcTOT_CALCIO: TFloatField;
    quRelacaoCaPCalcTOT_FOSFORO: TFloatField;
    quRelacaoCaPRefTOT_CALCIO: TFloatField;
    quRelacaoCaPRefTOT_FOSFORO: TFloatField;
    quRelacaoAgSatPolMonCalcRELCALC_AGSAT2: TFloatField;
    quRelacaoAgSatPolMonCalcRELCALC_AGPOL2: TFloatField;
    quRelacaoAgSatPolMonCalcRELCALC_AGMON2: TFloatField;
    quRelacaoAgSatPolMonRefRELREF_AGSAT2: TFloatField;
    quRelacaoAgSatPolMonRefRELREF_AGPOL2: TFloatField;
    quRelacaoAgSatPolMonRefRELREF_AGMON2: TFloatField;
     { Apaga todas os registros relacionados ao ID }
     function  LimpaCalcAli( ID : String ) : Boolean;
     { Insere o ID do calculo a ser instanciado }
     function  CriaCalcAli( ID : String; NomeCalc : String = '' ) : Boolean;
     procedure taTotalNutCalcFields(DataSet: TDataSet);
     procedure DMCalcAliCreate(Sender: TObject);
     procedure taMacroNutCalcFields(DataSet: TDataSet);
     procedure taSaldoNutCalcFields(DataSet: TDataSet);
     procedure taCalcAliNewRecord(DataSet: TDataSet);
     procedure taRefCalcAliDISTRIBUICAOValidate(Sender: TField);
     procedure CalcAliDestroy(Sender: TObject);
     procedure taTotGru_GruCalcFields(DataSet: TDataSet);
     procedure taTotGru_GruBeforeOpen(DataSet: TDataSet);
     procedure taTotAli_AliBeforeOpen(DataSet: TDataSet);
     procedure taTotAli_AliCalcFields(DataSet: TDataSet);
     procedure dsItensAliDataChange(Sender: TObject; Field: TField);
    procedure quProtAVBRefCalcFields(DataSet: TDataSet);
    procedure quProtAVBCalcCalcFields(DataSet: TDataSet);
    procedure quRelacaoCaPCalcCalcFields(DataSet: TDataSet);
    procedure quRelacaoCaPRefCalcFields(DataSet: TDataSet);
    procedure quRelacaoAgSatPolMonCalcCalcFields(DataSet: TDataSet);
    procedure quRelacaoAgSatPolMonRefCalcFields(DataSet: TDataSet);
  private
     // Campo temporário para ordenação por nutriente dos alimentos
//     FNutTemp : TStringField;
     FItem : Integer;
     FActiveRefreshAll : Boolean;
     FPesoCorporal: TMedida;
     // Calculo de Grupos Alimentares por Nutrientes
     F : TStringField;
     ListaNutGru : TStringList;
     ListaNutAli : TStringList;
     FShowAllNut: Boolean;
     FAlimentoCorrente: TAlimento;
     FPesoFinal : TMedida;
     FDelayedOpIndicator: TDelayedOpIndicator;
     FcxRecNut: TCaixa;
     FPeriodo: Integer;
     FOnBeforeAppendItem: TNotifyItemRefeicao;
     FOnBeforeDeleteItem: TNotifyItemRefeicao;
     function TotalNutPorGrupoAlimentar(const IDGRUPO, IDNUT : String; var Total : Double) : Boolean;
     function TotalNutPorAlimento( const IDNUT : String; var Total : Double ) : Boolean;
     procedure CriaNutToFields( DataSetNut, DataSetFields : TDataSet; ListaNut : TStringList );
     procedure SetPesoCorporal(const Value: TMedida);
     procedure SetShowAllNut(const Value: Boolean);
     procedure SetAlimentoCorrente(const Value: TAlimento);
     procedure SetDelayedOpIndicator(const Value: TDelayedOpIndicator);
     procedure SetcxRecNut(const Value: TCaixa);
     procedure SetPeriodo(const Value: Integer);
     procedure SetOnBeforeDeleteItem(const Value: TNotifyItemRefeicao);
     procedure SetOnBeforeAppendItem(const Value: TNotifyItemRefeicao);
  public
      // representa um campo selecionado e o sentido da ordem
      FMyField : TField;
      FOrdem : TTipoOrdem;
     { Periodo em que o calculo alimentar se refere em dias }
     property Periodo : Integer read FPeriodo write SetPeriodo;
     { Caixa de Recomendacoes Nutricionais }
     property cxRecNut : TCaixa read FcxRecNut write SetcxRecNut;
     { ponteiro para o peso final da preparacão }
     property mdPesoFinal : TMedida read FPesoFinal;
     { Peso Corporal para calculo do Total de Kg por Dia }
     property PesoCorporal : TMedida read FPesoCorporal write SetPesoCorporal;
     { Mostra todos os nutrientes, independente de seu flag }
     property ShowAllNut : Boolean read FShowAllNut write SetShowAllNut;
     property AlimentoCorrente : TAlimento read FAlimentoCorrente write SetAlimentoCorrente;
     property DelayedOpIndicator : TDelayedOpIndicator read FDelayedOpIndicator write SetDelayedOpIndicator;
     property OnBeforeAppendItem : TNotifyItemRefeicao read FOnBeforeAppendItem write SetOnBeforeAppendItem;
     property OnBeforeDeleteItem : TNotifyItemRefeicao read FOnBeforeDeleteItem write SetOnBeforeDeleteItem;
     { Retorna o valor da proteína e se é AVB }
     function IsProteinaAVB( var Valor : Double; IDAlimento : String ) : String;
     { Carrega Nutrientes para ItensAli }
     procedure NutToItensAli( const IDAli : String; DataSet : TDataSet );
     function Refresh( ListaCalcAli : TListaCalculosAlimentares ) : Boolean;
     procedure SetPesoIngredientes;
     function ProximoItem : Integer;
     procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  end;

{******************************************************************************}
{                           T2-TCUSTOMCALCULOALIMENTAR                         }
{******************************************************************************}

type

   TAtivaCustomCalculoAlimentar = class( TPersistent )
   private
      FPorcentagemNutrientesValidos: Boolean;
      FTotalNutrientes: Boolean;
      FTotalMacroNutrientes: Boolean;
      FListaCalculos: TListaCalculosAlimentares;
      FOnCalcular: TNotifyEvent;
      procedure SetPorcentagemNutrientesValidos(const Value: Boolean);
      procedure SetTotalMacroNutrientes(const Value: Boolean);
      procedure SetTotalNutrientes(const Value: Boolean);
      procedure SetOnCalcular(const Value: TNotifyEvent);
   protected
   public
      property ListaCalculos : TListaCalculosAlimentares read FListaCalculos;
      property OnCalcular : TNotifyEvent read FOnCalcular write SetOnCalcular;
   published
      property TotalNutrientes : Boolean read FTotalNutrientes write SetTotalNutrientes;
      property PorcentagemNutrientesValidos : Boolean read FPorcentagemNutrientesValidos write SetPorcentagemNutrientesValidos;
      property TotalMacroNutrientes : Boolean read FTotalMacroNutrientes write SetTotalMacroNutrientes;
   end;

   // Notity do evento AntesDeAdicionar, onde Cancelar evita a adicao
   TNotifyAntesDeAdicionar = procedure (Sender: TObject; var Cancelar : Boolean; JaExiste : Boolean ) of object;
   // Notity do evento AntesDeAdicionar, onde Cancelar evita a adicao
   TNotifyAntesDeAlterar = procedure (Sender: TObject; var Cancelar : Boolean ) of object;
   // Notify PegaCalcDesc, onde cancelar interrope o calculo
   TNotifyPegaCalcDesc = procedure (Sender: TObject; var Cancelar : Boolean ) of object;

   TCustomCalculoAlimentar = class(TCCSDBListaLInks)
   private
      FTituloCalculo : String;
      FNomeCalculo : String;
      FDescricaoCalculo : TMedidaOrdinal;
      FListaAlimento : TCustomListaAlimento;
      FQtdeAlimento : Double;
      FIDMedCasAlimento : String;
      FMemoria : TMemoria;
      FItemsAlimentar : TDatasource;
      FTotalNutrientes : TDatasource;
      FTotalMacroNutrientes : TDatasource;
      FCancelar : Boolean;
      FDMCalcAli : TCalcAli;
      FOnAntesDeAdicionar : TNotifyAntesDeAdicionar;
      FOnAntesDeAlterar: TNotifyAntesDeAlterar;
      FOnPegaCalcDesc : TNotifyPegaCalcDesc;
      FOnDepoisDeSalvar : TNotifyEvent;
      FItensAliCount : Integer;
      FFrequenciaDiaAux : String;
      { Identificador da instancia }
      FIDCalcAli: String;
      FPesoItemAlimentar: TMedida;
      FPorcentagemNutrientesValidos: TDataSource;
      FAtivar: TAtivaCustomCalculoAlimentar;
      FAlimentoCorrente: TAlimento;
      FDescricao: String;
      FObservacoes: TDataSource;
      FDelayedOpIndicator: TDelayedOpIndicator;
    FOnDepoisDeOrdenaAliNutPorNutriente: TNotifyEvent;
      { Copia CalcAli da memoria para as Tabelas }
      function CopiaCalcAliParaTabelas : Boolean;
      { Copia Tabelas para CalcAli da memoria }
      function CopiaTabelasParaCalcali : Boolean;
      procedure SetTotalNutrientes (Value : TDatasource);
      procedure SetTotalMacroNutrientes(const Value: TDatasource);
      procedure SetItemsAlimentar(const Value: TDatasource);
      procedure SetPesoItemAlimentar(const Value: TMedida);
      procedure SetPorcentagemNutrientesValidos(const Value: TDataSource);
      procedure SetAtivar(const Value: TAtivaCustomCalculoAlimentar);
      procedure DoCalcular( Sender : TObject );
      procedure SetMostraTodosNutrientes(const Value: Boolean);
      function GetMostraTodosNutrientes: Boolean;
      procedure SetAlimentoCorrente(const Value: TAlimento);
      procedure SetDescricao(const Value: String);
      procedure SetObservacoes(const Value: TDataSource);
      procedure SetDelayedOpIndicator(const Value: TDelayedOpIndicator);
      procedure SetDescricaoCalculo(const Value: TMedidaOrdinal);
      procedure SetIDMedCasAlimento(const Value: String);
      procedure SetQtdeAlimento(const Value: Double);
      procedure SetListaAlimento(const Value: TCustomListaAlimento);
      procedure SetMemoria(const Value: TMemoria);
      procedure SetNomeCalculo(const Value: String);
      procedure SetOnAntesDeAdicionar(const Value: TNotifyAntesDeAdicionar);
      procedure SetOnAntesDeAlterar(const Value: TNotifyAntesDeAlterar);
      procedure SetOnDepoisDeSalvar(const Value: TNotifyevent);
      procedure SetOnPegaCalcDesc(const Value: TNotifyPegaCalcDesc);
    procedure SetOnDepoisDeOrdenaAliNutPorNutriente(const Value: TNotifyEvent);
   protected
      procedure Loaded; override;
      procedure AntesDeAdicionar( var Cancelar : Boolean; JaExiste : Boolean );
      procedure AntesDeAlterar( var Cancelar : Boolean );
      procedure PegaCalcDesc;
      procedure DepoisDeSalvar;
      //especializacao dos metodos do TCCSDBListaLinks para poder tratar a
      //situacao de ter tabelas que eu nao quero mexer
      procedure DefineDM; override;
      procedure OpenTables; override;
      procedure CloseTables; override;
      function CriaAtivarCalculoAlimentar : TAtivaCustomCalculoAlimentar;virtual;
   public
      { Identificador do Calculo }
      property IDCalcAli : String read FIDCalcAli;
      { Descricao do Calculo }
      property DescricaoCalculo : TMedidaOrdinal read FDescricaoCalculo write SetDescricaoCalculo;
      { ID da Medida Caseira do Alimento }
      property IDMedCasAlimento : String read FIDMedCasAlimento write SetIDMedCasAlimento;
      { Quantidade do Alimento }
      property QtdeAlimento : Double read FQtdeAlimento write SetQtdeAlimento;
      { DataModule de Calculo Alimentar }
      property DMCalculoAlimentar : TCalcAli read FDMCalcAli;
      property MostraTodosNutrientes : Boolean read GetMostraTodosNutrientes write SetMostraTodosNutrientes;
      // Pra fazer algo depois do método OrdenaAlinutPorNutriente
      property OnDepoisDeOrdenaAliNutPorNutriente : TNotifyEvent read FOnDepoisDeOrdenaAliNutPorNutriente write SetOnDepoisDeOrdenaAliNutPorNutriente;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Notification(AComponent : TComponent; Operation : TOperation); override;
      { Adiciona um alimento ao calculo }
      procedure Adicionar; virtual;
      { Altera um item alimentar do calculo }
      procedure Alterar; virtual;
      { Retira um alimento do calculo }
      procedure Retirar; virtual;
      { Abrir um calculo gravado  }
      procedure Abrir( const ReadOnly : Boolean = False ); virtual;
      { Gravar um calculo }
      procedure Salvar; virtual;
      { Limpa calculo }
      procedure Novo( const ReadOnly : Boolean = False ); virtual;
      { Fecha (limpa) tabelas temporarias }
      function Fechar : Boolean;
      { Faz o refresh dos calculos }
      function Calcular : Boolean;
      { Indica se lista de itens esta vazia }
      function IsEmpty : Boolean;
      procedure OrdenaAliNutPorNutriente(AField: TField; const Ordem : TTipoOrdem );
   published
      property DelayedOpIndicator : TDelayedOpIndicator read FDelayedOpIndicator write SetDelayedOpIndicator;
      { Nome do Calculo }
      property NomeCalculo : String read FNomeCalculo write SetNomeCalculo;
      { Descricao do Calculo }
      property Descricao : String read FDescricao write SetDescricao;
      { Lista de Alimento }
      property ListaAlimento : TCustomListaAlimento read FListaAlimento write SetListaAlimento;
      property PesoItemAlimentar : TMedida read FPesoItemAlimentar write SetPesoItemAlimentar;
      { Cancelou calculo }
      property Cancelou : Boolean read FCancelar;
      { Memoria }
      property Memoria : TMemoria read FMemoria write SetMemoria;
      { ItemsAlimentar }
      property ItemsAlimentar : TDatasource read FItemsAlimentar write SetItemsAlimentar;
      { TotalNutrientes }
      property TotalNutrientes : TDatasource read FTotalNutrientes write SetTotalNutrientes;
      { TotalMacroNutrientes }
      property TotalMacroNutrientes : TDatasource read FTotalMacroNutrientes write SetTotalMacroNutrientes;
      property PorcentagemNutrientesValidos : TDataSource read FPorcentagemNutrientesValidos write SetPorcentagemNutrientesValidos;
      property Ativar : TAtivaCustomCalculoAlimentar read FAtivar write SetAtivar;
      { Evento AntesDeAdicionar }
      property OnAntesDeAdicionar : TNotifyAntesDeAdicionar read FOnAntesDeAdicionar write SetOnAntesDeAdicionar;
      { Evento AntesDeAlterar }
      property OnAntesDeAlterar : TNotifyAntesDeAlterar read FOnAntesDeAlterar write SetOnAntesDeAlterar;
      property OnPegaCalcDesc : TNotifyPegaCalcDesc read FOnPegaCalcDesc write SetOnPegaCalcDesc;
      property OnDepoisDeSalvar : TNotifyevent read FOnDepoisDeSalvar write SetOnDepoisDeSalvar;
      property AlimentoCorrente : TAlimento read FAlimentoCorrente write SetAlimentoCorrente;
      property Observacoes : TDataSource read FObservacoes write SetObservacoes;
   end;

{******************************************************************************}
{                              T3-TCALCULOALIMENTAR                            }
{******************************************************************************}

type

   TAtivaCalculoAlimentar = class( TAtivaCustomCalculoAlimentar )
   private
      FPorcentagemEnergiaCalculada: Boolean;
      FNutrientesPorPesoDia: Boolean;
      FGrupoAlimentarPorNutriente: Boolean;
      FRelacaoCaPPorRefeicao: Boolean;
      FRelacaoAcidosGraxosPorRef: Boolean;
      FRelacaoCaloriaNitrogenioPorCalc: Boolean;
      FProteinaAVBPorRefeicao: Boolean;
      FRelacaoAcidosGraxosPorCalc: Boolean;
      FRelacaoCaPPorCalculo: Boolean;
      FProteinaAVBPorCalculo: Boolean;
      FRelacaoCaloriaNitrogenioPorRef: Boolean;
      FAlimentoPorNutriente: Boolean;
      FSaldoNutrientes: Boolean;
      procedure SetGrupoAlimentarPorNutriente(const Value: Boolean);
      procedure SetNutrientesPorPesoDia(const Value: Boolean);
      procedure SetPorcentagemEnergiaCalculada(const Value: Boolean);
      procedure SetProteinaAVBPorCalculo(const Value: Boolean);
      procedure SetProteinaAVBPorRefeicao(const Value: Boolean);
      procedure SetRelacaoAcidosGraxosPorCalc(const Value: Boolean);
      procedure SetRelacaoAcidosGraxosPorRef(const Value: Boolean);
      procedure SetRelacaoCaloriaNitrogenioPorCalc(const Value: Boolean);
      procedure SetRelacaoCaloriaNitrogenioPorRef(const Value: Boolean);
      procedure SetRelacaoCaPPorCalculo(const Value: Boolean);
      procedure SetRelacaoCaPPorRefeicao(const Value: Boolean);
      procedure SetAlimentoPorNutriente(const Value: Boolean);
      procedure SetSaldoNutrientes(const Value: Boolean);
   protected
   published
      property ProteinaAVBPorRefeicao : Boolean read FProteinaAVBPorRefeicao write SetProteinaAVBPorRefeicao;
      property ProteinaAVBPorCalculo : Boolean read FProteinaAVBPorCalculo write SetProteinaAVBPorCalculo;
      property RelacaoCaPPorRefeicao : Boolean read FRelacaoCaPPorRefeicao write SetRelacaoCaPPorRefeicao;
      property RelacaoCaPPorCalculo : Boolean read FRelacaoCaPPorCalculo write SetRelacaoCaPPorCalculo;
      property RelacaoAcidosGraxosPorRef : Boolean read FRelacaoAcidosGraxosPorRef write SetRelacaoAcidosGraxosPorRef;
      property RelacaoAcidosGraxosPorCalc : Boolean read FRelacaoAcidosGraxosPorCalc write SetRelacaoAcidosGraxosPorCalc;
      property RelacaoCaloriaNitrogenioPorRef : Boolean read FRelacaoCaloriaNitrogenioPorRef write SetRelacaoCaloriaNitrogenioPorRef;
      property RelacaoCaloriaNitrogenioPorCalc : Boolean read FRelacaoCaloriaNitrogenioPorCalc write SetRelacaoCaloriaNitrogenioPorCalc;
      property PorcentagemEnergiaCalculada : Boolean read FPorcentagemEnergiaCalculada write SetPorcentagemEnergiaCalculada;
      property NutrientesPorPesoDia : Boolean read FNutrientesPorPesoDia write SetNutrientesPorPesoDia;
      property GrupoAlimentarPorNutriente : Boolean read FGrupoAlimentarPorNutriente write SetGrupoAlimentarPorNutriente;
      property AlimentoPorNutriente : Boolean read FAlimentoPorNutriente write SetAlimentoPorNutriente;
      property SaldoNutrientes : Boolean read FSaldoNutrientes write SetSaldoNutrientes;
   end;

   // Notify PegaRefeicoes, onde Entrada sao as refeicoes escolhidas e saida a escolher
   TNotifyPegaRefeicoes = procedure (Sender: TObject; Entrada, Saida : TStrings; var Cancelar : Boolean ) of object;

   // Notify PegaRecCalorica
   TNotifyPegaRecCalorica = procedure (Sender: TObject; var Cancelar : Boolean ) of object;

   TCalculoAlimentar = class(TCustomCalculoAlimentar)
   private
      FSaidaRefeicao: TStrings;
      FEntradaRefeicao: TStrings;
      FOnPegaRefeicoes : TNotifyPegaRefeicoes;
      FRefeicoesEscolhidas: TDataSource;
      FPesoCorporal: TMedida;
      FOnPegaRecCalorica : TNotifyPegaRecCalorica;
      FSaldoNutrientes: TDatasource;
      FCaixaRecNut: String;
      FProteinaAVBPorRefeicao: TDatasource;
      FProteinaAVBPorCalculo: TDatasource;
      FRelacaoCaPPorRefeicao: TDatasource;
      FRelacaoCaPPorCalculo: TDatasource;
      FRelacaoAcidosGraxosPorCalc: TDataSource;
      FRelacaoAcidosGraxosPorRef: TDataSource;
      FRelacaoCaloriaNitrogenioPorCalc: TDataSource;
      FRelacaoCaloriaNitrogenioPorRef: TDataSource;
      FPorcentagemEnergiaCalculada: TDataSource;
      FNutrientesPorPesoDia: TDataSource;
      FGrupoAlimentarPorNutriente: TDataSource;
      FAlimentoPorNutriente: TDataSource;
      FModelosRefeicoes: TDataSource;
      procedure SetRefeicoesEscolhidas(const Value: TDataSource);
      procedure SetEntradaRefeicao(const Value: TStrings);
      procedure SetSaidaRefeicao(const Value: TStrings);
      procedure SetPesoCorporal(const Value: TMedida);
      procedure SetProteinaAVBPorRefeicao(const Value: TDatasource);
      procedure SetProteinaAVBPorCalculo(const Value: TDatasource);
      procedure SetRelacaoCaPPorCalculo(const Value: TDatasource);
      procedure SetRelacaoCaPPorRefeicao(const Value: TDatasource);
      procedure SetRelacaoAcidosGraxosPorCalc(const Value: TDataSource);
      procedure SetRelacaoAcidosGraxosPorRef(const Value: TDataSource);
      procedure SetRelacaoCaloriaNitrogenioPorCalc(const Value: TDataSource);
      procedure SetRelacaoCaloriaNitrogenioPorRef(const Value: TDataSource);
      procedure SetPorcentagemEnergiaCalculada(const Value: TDataSource);
      procedure SetNutrientesPorPesoDia(const Value: TDataSource);
      procedure SetGrupoAlimentarPorNutriente(const Value: TDataSource);
      procedure SetAlimentoPorNutriente(const Value: TDataSource);
      procedure SetSaldoNutrientes(const Value: TDatasource);
      procedure SetCaixaRecNut(const Value: String);
      procedure SetOnPegaRecCalorica(const Value: TNotifyPegaRecCalorica);
      procedure SetOnPegaRefeicoes(const Value: TNotifyPegaRefeicoes);
      procedure SetModelosRefeicoes(const Value: TDataSource);
      procedure BeforeAppendItem( Sender : TObject; const IDRefeicao : String );
      procedure BeforeDeleteItem( Sender : TObject; const IDRefeicao : String );
   protected
      procedure Loaded; override;
      procedure PegaRefeicoes;
      procedure PegaRecCalorica;
      function CriaAtivarCalculoAlimentar : TAtivaCustomCalculoAlimentar;override;
   public
      property EntradaRefeicao : TStrings read FEntradaRefeicao write SetEntradaRefeicao;
      property SaidaRefeicao : TStrings read FSaidaRefeicao write SetSaidaRefeicao;
      property PesoCorporal : TMedida read FPesoCorporal write SetPesoCorporal;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Notification(AComponent : TComponent; Operation : TOperation); override;
      procedure Novo( const ReadOnly : Boolean = False ); override;
      procedure Abrir( const ReadOnly : Boolean = False ); override;
      procedure Salvar; override;
      { Pega refeicoes selecionadas }
      procedure PegaRefeicoesSelecionadas;
      { Seta refeicoes selecionadas }
      procedure SetaRefeicoesSelecionadas;
      procedure SetaRecNut;
      procedure IncItensRefeicao( const IDRefeicao : String; N: Integer = 1 );
      procedure DecItensRefeicao( const IDRefeicao : String; N: Integer = 1 );
      function CountItensRefeicao( const IDRefeicao : String ) : Integer;
      function RefeicaoIsEmpty : String;
      procedure EmptyCounterItensRefeicao;
      procedure MsgRefeicoes;
   published
      property ModelosRefeicoes : TDataSource read FModelosRefeicoes write SetModelosRefeicoes;
      property RefeicoesEscolhidas : TDataSource read FRefeicoesEscolhidas write SetRefeicoesEscolhidas;
      property OnPegaRefeicoes : TNotifyPegaRefeicoes read FOnPegaRefeicoes write SetOnPegaRefeicoes;
      { ProteinaAVBPorRefeicao }
      property ProteinaAVBPorRefeicao : TDatasource read FProteinaAVBPorRefeicao write SetProteinaAVBPorRefeicao;
      { ProteinaAVBPorCalculo }
      property ProteinaAVBPorCalculo : TDatasource read FProteinaAVBPorCalculo write SetProteinaAVBPorCalculo;
      { Relacao Ca/P por Refeicao }
      property RelacaoCaPPorRefeicao : TDatasource read FRelacaoCaPPorRefeicao write SetRelacaoCaPPorRefeicao;
      { Relacao Ca/P por Calculo }
      property RelacaoCaPPorCalculo : TDatasource read FRelacaoCaPPorCalculo write SetRelacaoCaPPorCalculo;
      { Relacao Ag Sat/Ag Pol/Ag Mon por Refeicao }
      property RelacaoAcidosGraxosPorRef : TDataSource read FRelacaoAcidosGraxosPorRef write SetRelacaoAcidosGraxosPorRef;
      { Relacao Ag Sat/Ag Pol/Ag Mon por Calculo }
      property RelacaoAcidosGraxosPorCalc : TDataSource read FRelacaoAcidosGraxosPorCalc write SetRelacaoAcidosGraxosPorCalc;
      { Relacao Caloria/Nitrogenio por Refeicao }
      property RelacaoCaloriaNitrogenioPorRef : TDataSource read FRelacaoCaloriaNitrogenioPorRef write SetRelacaoCaloriaNitrogenioPorRef;
      { Relacao Caloria/Nitrogenio por Calculo }
      property RelacaoCaloriaNitrogenioPorCalc : TDataSource read FRelacaoCaloriaNitrogenioPorCalc write SetRelacaoCaloriaNitrogenioPorCalc;
      { Porcentagem de Energia Calculada em relacao a alguns nutrientes }
      property PorcentagemEnergiaCalculada : TDataSource read FPorcentagemEnergiaCalculada write SetPorcentagemEnergiaCalculada;
      property NutrientesPorPesoDia : TDataSource read FNutrientesPorPesoDia write SetNutrientesPorPesoDia;
      property GrupoAlimentarPorNutriente : TDataSource read FGrupoAlimentarPorNutriente write SetGrupoAlimentarPorNutriente;
      property AlimentoPorNutriente : TDataSource read FAlimentoPorNutriente write SetAlimentoPorNutriente;
      { SaldoNutrientes }
      property SaldoNutrientes : TDatasource read FSaldoNutrientes write SetSaldoNutrientes;
      { Caixa de Recomendação de Nutrientes }
      property CaixaRecNut : String read FCaixaRecNut write SetCaixaRecNut;
      { Published properties of TCalculoDieta }
      property OnPegaRecCalorica : TNotifyPegaRecCalorica read FOnPegaRecCalorica write SetOnPegaRecCalorica;
   end;

{******************************************************************************}
{                               T4-TCALCULODIETA                               }
{******************************************************************************}

type

   TAtivaCalculoDieta = class( TAtivaCalculoAlimentar )
   private
   protected
   published
   end;

   TCalculoDieta = class(TCalculoAlimentar)
   private
   protected
      procedure Loaded; override;
      function CriaAtivarCalculoAlimentar : TAtivaCustomCalculoAlimentar; override;
   public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Notification(AComponent : TComponent; Operation : TOperation); override;
      procedure Abrir( const ReadOnly : Boolean = False ); override;
      procedure Novo( const ReadOnly : Boolean = False ); override;
      procedure Salvar; override;
   published
   end;

{******************************************************************************}
{                              T5-TCALCULOINQUERITO                            }
{******************************************************************************}

type

   // Notify PegaDiasDeConsumo, onde cancelar interrope o calculo
   TNotifyPegaDiasDeConsumo = procedure (Sender: TObject; var Cancelar : Boolean ) of object;

   TCalculoInquerito = class(TCalculoAlimentar)
   private
      FDiasDeConsumo : TMedida;
      FOnPegaDiasDeConsumo : TNotifyPegaDiasDeConsumo;
      procedure SetDiasDeConsumo(const Value: TMedida);
   protected
      procedure Loaded; override;
   public
      property DiasDeConsumo : TMedida read FDiasDeConsumo write SetDiasDeConsumo;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure PegaDiasDeConsumo;
      procedure Notification(AComponent : TComponent; Operation : TOperation); override;
      procedure Abrir( const ReadOnly : Boolean = False ); override;
      procedure Novo( const ReadOnly : Boolean = False ); override;
      procedure Salvar; override;
   published
   end;

{******************************************************************************}
{                        T6-TCALCULOINQUERITOFREQUENCIA                        }
{******************************************************************************}

type

   TCalculoInqueritoFrequencia = class(TCalculoInquerito)
   private
      FFrequenciaDia : TCustomEdit;
      FOnPegaDiasDeConsumo: TNotifyPegaDiasDeConsumo;
      procedure SetFrequenciaDia(const Value: TCustomEdit);
      procedure SetOnPegaDiasDeConsumo(const Value: TNotifyPegaDiasDeConsumo);
   protected
      procedure Loaded; override;
   public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Notification(AComponent : TComponent; Operation : TOperation); override;
      procedure Adicionar; override;
   published
      { Frequencia Dia de consumo }
      property FrequenciaDia : TCustomEdit read FFrequenciaDia write SetFrequenciaDia;
      property OnPegaDiasDeConsumo : TNotifyPegaDiasDeConsumo read FOnPegaDiasDeConsumo write SetOnPegaDiasDeConsumo;
   end;

{******************************************************************************}
{                              T7-TCALCULOPREPARACAO                           }
{******************************************************************************}

type

   // Notify PegaCalcDesc, onde cancelar interrope o calculo
   TNotifyPegaPesoFinal = procedure (Sender: TObject; var Cancelar : Boolean ) of object;

   TCalculoPreparacao = class(TCustomCalculoAlimentar)
   private
      FPesoFinal : TMedida;
      FOnPegaPesoFinal : TNotifyPegaPesoFinal;
      FIDSelf: String;
      FOnErroAdicionarSelf: TNotifyEvent;
      FPesoIngredientes: TMedida;
      FSaldoPeso: TMedida;
      FAguaRestante: TMedida;
      FTotalAgua: TMedida;
      procedure SetIDSelf(const Value: String);
      procedure SetOnErroAdicionarSelf(const Value: TNotifyEvent);
      procedure SetPesoFinal(const Value: TMedida);
      procedure SetOnPegaPesoFinal(const Value: TNotifyPegaPesoFinal);
   protected
      procedure Loaded; override;
      procedure PegaPesoFinal;
   public
      property PesoFinal : TMedida read FPesoFinal write SetPesoFinal;
      property PesoIngredientes : TMedida read FPesoIngredientes;
      property SaldoPeso : TMedida read FSaldoPeso;
      property TotalAgua : TMedida read FTotalAgua;
      property AguaRestante : TMedida read FAguaRestante;
      property IDSelf : String read FIDSelf write SetIDSelf;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Notification(AComponent : TComponent; Operation : TOperation); override;
      function SaldoPesoValido( var Texto : String ) : Boolean;
      procedure Abrir( const ReadOnly : Boolean = False ); override;
      procedure Novo( const ReadOnly : Boolean = False ); override;
      procedure Salvar; override;
      procedure Adicionar; override;
      procedure Alterar; override;
      procedure Retirar; override;
   published
      property OnPegaPesoFinal : TNotifyPegaPesoFinal read FOnPegaPesoFinal write SetOnPegaPesoFinal;
      property OnErroAdicionarSelf : TNotifyEvent read FOnErroAdicionarSelf write SetOnErroAdicionarSelf;
   end;

procedure Register;

implementation

{$R *.DFM}

procedure Register;
begin
   RegisterComponents('Nutricao', [TCalculoAlimentar]);
   RegisterComponents('Nutricao', [TCalculoDieta]);
   RegisterComponents('Nutricao', [TCalculoInquerito]);
   RegisterComponents('Nutricao', [TCalculoInqueritoFrequencia]);
   RegisterComponents('Nutricao', [TCalculoPreparacao]);
end;

//========================== T2-TCUSTOMCALCULOALIMENTAR ========================

procedure TCustomCalculoAlimentar.Notification(AComponent : TComponent; Operation : TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FItemsAlimentar then
        FItemsAlimentar := nil
     else if AComponent = FPesoItemAlimentar then
        FPesoItemAlimentar := nil
     else if AComponent = FDescricaoCalculo then
        FDescricaoCalculo := nil
     else if AComponent = FListaAlimento then
        FListaAlimento := nil
     else if AComponent = FMemoria then
        FMemoria := nil
     else if AComponent = FTotalNutrientes then
        FTotalNutrientes := nil
     else if AComponent = FTotalMacroNutrientes then
        FTotalMacroNutrientes := nil
    else if AComponent = FPorcentagemNutrientesValidos then
        FPorcentagemNutrientesValidos := nil
    else if AComponent = FAlimentoCorrente then
        begin
           FAlimentoCorrente := nil;
           if Assigned( FDMCalcAli ) then
              FDMCalcAli.AlimentoCorrente := nil;
        end
    else if AComponent = FDMCalcAli then
        FDMCalcAli := nil
    else if AComponent = FObservacoes then
        FObservacoes := nil
    else if AComponent = FDelayedOpIndicator then
        FDelayedOpIndicator := nil;
        if Assigned( FDMCalcAli ) then
           FDMCalcAli.DelayedOpIndicator := nil;
end;

constructor TCustomCalculoAlimentar.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   // propriedades a serem inicializadas
   FIDCalcAli := CreateNewGUID;
   FCancelar := False;
   FFrequenciaDiaAux := '1';
   FTituloCalculo := 'Cálculo Alimentar';
   // Cria datamodule
   Application.CreateForm (TCalcAli,FDMCalcAli);
   FDMCalcAli.FreeNotification(self);
   FAtivar := CriaAtivarCalculoAlimentar;
   FAtivar.OnCalcular := DoCalcular;
   FDMCalcAli.DelayedOpIndicator := FDelayedOpIndicator;
end;

destructor TCustomCalculoAlimentar.Destroy;
begin
   if Assigned(FDMCalcAli) then
      FDMCalcAli.Free;
   if Assigned(FAtivar) then
      FAtivar.Free;
   inherited Destroy;
end;

procedure TCustomCalculoAlimentar.Loaded;
begin
   inherited Loaded;
   // Seta os Databaseanem
   DM := FDMCalcAli;
end;

// Limpa Calculo para um novo
procedure TCustomCalculoAlimentar.Novo( const ReadOnly : Boolean = False );
var
   CalculoAlimentar : TCaixa;
   mdModRefeicao : TMedidaOrdinal;
begin
   // Inicializa contador de items
   FItensAliCount := 0;
   // Cria este calculo nas tabelas
   FDMCalcAli.CriaCalcAli( FIDCalcAli, FNomeCalculo );
   // Procura ou cria caixa
   if not FMemoria.Acha( FNomeCalculo, TObject( CalculoAlimentar )) then
   begin
      CalculoAlimentar := TCaixa.Create(FMemoria);
      CalculoAlimentar.Name := FNomeCalculo;
      CalculoAlimentar.Descricao := '';
   end;
   // Cria algumas medidas na memoria
   mdModRefeicao := TMedidaOrdinal.Create(CalculoAlimentar);
   mdModRefeicao.Descricao := 'Modelo';
   mdModRefeicao.ValorNumerico := 'Padrão';
   mdModRefeicao.Unidade := '';
   mdModRefeicao.Valid := True;
   mdModRefeicao.Name := self.FNomeCalculo + 'ModRefeicao';
   if not FDMCalcAli.taModRefeicao.Locate( 'NOME', mdModRefeicao.ValorNumerico, [] ) then
      ShowMessage( 'Modelo ' + mdModRefeicao.ValorNumerico + ' não encontrado.' );
   // Cria algumas medidas na memoria
   FDescricaoCalculo := TMedidaOrdinal.Create(CalculoAlimentar);
   FDescricaoCalculo.Descricao := 'Nome';
   FDescricaoCalculo.ValorNumerico := '';
   FDescricaoCalculo.Unidade := '';
   FDescricaoCalculo.Valid := True;
   FDescricaoCalculo.Name := self.FNomeCalculo + 'CalcDesc';
   // Pede a descricao deste calculo
   if not ReadOnly then
      PegaCalcDesc;
end;

// Carrega um calculo da memoria
procedure TCustomCalculoAlimentar.Abrir( const ReadOnly : Boolean = False );
var
   mdModRefeicao : TMedidaOrdinal;
begin
   if CopiaCalcAliParaTabelas then
      begin
         if FMemoria.Acha( self.FNomeCalculo + 'ModRefeicao', TObject( mdModRefeicao ) ) then
            if not FDMCalcAli.taModRefeicao.Locate( 'NOME', mdModRefeicao.ValorNumerico, [] ) then
               ShowMessage( 'Modelo ' + mdModRefeicao.ValorNumerico + ' não encontrado.' );
         FMemoria.Acha( self.FNomeCalculo + 'CalcDesc', TObject( FDescricaoCalculo ) );
         if not ReadOnly then
            PegaCalcDesc;
      end;
   Calcular;
end;

// Copia CalcAli da memoria para as Tabelas Temporaria
function TCustomCalculoAlimentar.CopiaCalcAliParaTabelas : Boolean;
var
   OldActiveRefreshAll : Boolean;
   CalculoAlimentar : TCaixa;
   Observacao : TMedidaOrdinal;
   I : Integer;
begin
   Result := True;
   // Inicializa contador de Itens
   FItensAliCount := 0;
   OldActiveRefreshAll := FDMCalcAli.FActiveRefreshAll;
   FDMCalcAli.FActiveRefreshAll := False;
   // Pega a lista para a sua leitura
   if not FMemoria.Acha( FNomeCalculo, TObject( CalculoAlimentar ) ) then
      begin
         Result := False;
         exit;
      end;
   // Limpa este calculo caso ele exista (por seguranca)
   FDMCalcAli.LimpaCalcAli( FIDCalcAli );
   // Cria este calculo
   FDMCalcAli.CriaCalcAli( FIDCalcAli );
   with FDMCalcAli do
   begin
      FItem := 0; // inicia número item
      for I := 0 to CalculoAlimentar.ComponentCount - 1 do
         if ( CalculoAlimentar.Components[I] is TItemAlimentar ) then
         with TItemAlimentar( CalculoAlimentar.Components[I] ) do
         begin
            // Adicionei mais um item
            Inc(FItensAliCount );
            if Assigned( FOnBeforeAppendItem ) then
               FOnBeforeAppendItem(self, IDRefeicao);
            taItensAliAux.Append;
            taItensAliAux.FieldByName( 'ID_CALCALI' ).AsString := FIDCalcAli;
            taItensAliAux.FieldByName( 'ID_ALI' ).AsString  := IDAlimento;
            taItensAliAux.FieldByName( 'ID_REFEICAO' ).AsString := IDRefeicao;
            taItensAliAux.FieldByName( 'ID_MEDIDA' ).AsString := IDMedida;
            taItensAliAux.FieldByName( 'QUANT' ).AsString := Quantidade;
            taItensAliAux.FieldByName( 'PESO' ).AsFloat := PesoEmGramas;
            taItensAliAux.FieldByName( 'FREQDIA' ).AsInteger := FrequenciaDia;
            taItensAliAux.FieldByName( 'ITEM' ).AsInteger := ProximoItem;
            NutToItensAli( taItensAliAux.FieldByName( 'ID_ALI' ).AsString, taItensAliAux);
            taItensAliAux.Post;
         end;
      taItensAliAux.Refresh;
      if FMemoria.Acha( self.FNomeCalculo + OBS_NAME, TObject(Observacao) ) then
      begin
         taCalcAli.Edit;
         taCalcAli.FieldByName( 'OBSERVACOES' ).AsString := Observacao.ValorNumerico;
         taCalcAli.Post;
      end;
   end;
   FDMCalcAli.FActiveRefreshAll := OldActiveRefreshAll;
end;

// Grava calculo atual na memoria
procedure TCustomCalculoAlimentar.Salvar;
begin
   // Copia o conteúdo das tabelas para a memoria
   if not CopiaTabelasParaCalcAli then
      begin
         ShowMessage( 'Não consegui salvar o cálculo!' );
         exit;
      end;
   // Roda o evento, se houver um
   DepoisDeSalvar;
end;

// Fecha (limpa) tabelas temporarias
function TCustomCalculoAlimentar.Fechar: Boolean;
begin
   // Limpa este calculo caso ele exista
   Result := FDMCalcAli.LimpaCalcAli( FIDCalcAli );
end;

function TCustomCalculoAlimentar.CopiaTabelasParaCalcali: Boolean;
var
   CalculoAlimentar : TCaixa;
   Observacao : TMedidaOrdinal;
   ItemAlimentar : TItemAlimentar;
   OldActiveRefreshAll : Boolean;
   J: Integer;
begin
   Result := True;
   // Salva o atual estado do refresh e desliga-o
   OldActiveRefreshAll := FDMCalcAli.FActiveRefreshAll;
   FDMCalcAli.FActiveRefreshAll := False;
   // Limpa os itens, pois pode ter havido exclusões, alterações, etc.
   if FMemoria.Acha( FNomeCalculo, TObject( CalculoAlimentar ) ) then
      For J := (CalculoAlimentar.ComponentCount -1) downto 0 do
      begin
         if ( CalculoAlimentar.Components[J] is TItemAlimentar ) then
            TItemAlimentar(CalculoAlimentar.Components[J]).Free;
      end
   else
      begin
         CalculoAlimentar := TCaixa.Create(FMemoria);
         CalculoAlimentar.Name := FNomeCalculo;
      end;
   // Preenchendo a lista com o calculo
   with FDMCalcAli do
   begin
      taItensAliAll.refresh; // preciso fazer isto senão não funciona no Interbase
      taItensAliAll.First;
      while not taItensAliAll.EOF do
      begin
         if taRefCalcAli.Locate( 'ID_REFEICAO', taItensAliAll.FieldByName( 'ID_REFEICAO' ).AsString, [] ) or
            ( taItensAliAll.FieldByName( 'ID_REFEICAO' ).AsString = '' ) then
            with ItemAlimentar do
            begin
               ItemAlimentar := TItemAlimentar.Create( CalculoAlimentar );
               IDAlimento := taItensAliAll.FieldByName( 'ID_ALI' ).AsString;
               IDRefeicao := taItensAliAll.FieldByName( 'ID_REFEICAO' ).AsString;
               IDMedida   := taItensAliAll.FieldByName( 'ID_MEDIDA' ).AsString;
               Quantidade := taItensAliAll.FieldByName( 'QUANT' ).AsString;
               PesoEmGramas := taItensAliAll.FieldByName( 'PESO' ).AsFloat;
               FrequenciaDia := taItensAliAll.FieldByName( 'FREQDIA' ).AsInteger;
               if taItensAliAll.FieldByName( 'NOMESIMP' ).AsString = '' then
                  Alimento := taItensAliAll.FieldByName( 'NOMEALI' ).AsString
               else
                  Alimento := taItensAliAll.FieldByName( 'NOMESIMP' ).AsString;
               MedidaCaseira := taItensAliAll.FieldByName( 'NOMEMED' ).AsString;
               Refeicao := taItensAliAll.FieldByName( 'NOMEREF' ).AsString;
               // Estas informações não são recuperáveis (não pego de volta para a tabela)
               Name := GUIDToName(taItensAliAll.FieldByName( 'GUID' ).AsString);
               taItensAliAll.AutoCalcFields := True;
               taItensAliAll.AutoCalcFields := False;
               Tag := taItensAliAll.FieldByName( 'ITEM' ).AsInteger;
            end;
         taItensAliAll.Next;
      end;
      if not FMemoria.Acha( FNomeCalculo + OBS_NAME, TObject( Observacao ) ) then
         begin
            Observacao := TMedidaOrdinal.Create(CalculoAlimentar);
            Observacao.Valid := True;
            Observacao.Name := FNomeCalculo + OBS_NAME;
         end;
      Observacao.Descricao := 'Observacao';
      Observacao.ValorNumerico := taCalcAli.FieldByName( 'OBSERVACOES' ).AsString;
      Observacao.Unidade := '';
   end;
   FDMCalcAli.FActiveRefreshAll := OldActiveRefreshAll;
end;

// Adiciona um alimento
procedure TCustomCalculoAlimentar.Adicionar;
var
   Cancelar : Boolean;
   IDREF : String;
begin
   Cancelar := False;
   with FDMCalcAli do
   begin
      if taRefCalcAli.FieldByNAme( 'ID_REFEICAO' ).AsString = '' then
         IDREF := IDREFGLOBAL
      else
         IDREF := taRefCalcAli.FieldByNAme( 'ID_REFEICAO' ).AsString;
      if taItensAli.Locate( 'ID_CALCALI;ID_REFEICAO;ID_ALI;ID_MEDIDA',
                            VarArrayOf( [FIDCalcAli,
                             IDREF,
                             FListaAlimento.DMListaAlimento.quAli.FieldByName( 'IDALI' ).AsString,
                             FIDMedCasAlimento] ), [] ) then
         begin
            // Já existe um alimento igual
            AntesDeAdicionar( Cancelar, True );
            if Cancelar then
               exit;
            taItensAli.Edit;
            if FQtdeAlimento > 0 then
               taItensAli.FieldByName( 'QUANT' ).AsFloat := taItensAli.FieldByName( 'QUANT' ).AsFloat +  FQtdeAlimento;
            taItensAli.FieldByName( 'PESO' ).AsFloat := taItensAli.FieldByName( 'PESO' ).AsFloat + FPesoItemAlimentar.AsFloat;
            taItensAli.FieldByName( 'FREQDIA' ).AsString := FFrequenciaDiaAux;
            taItensAli.Post;
         end
      else
         begin
            // False = não existe alimento igual
            AntesDeAdicionar( Cancelar, False );
            if Cancelar then exit;
            // Adicionei mais um item
            Inc( FItensAliCount );
            if Assigned( FOnBeforeAppendItem ) then
               FOnBeforeAppendItem(self, taRefCalcAli.FieldByNAme( 'ID_REFEICAO' ).AsString);
            taItensAli.Append;
            taItensAli.FieldByName( 'ID_CALCALI' ).AsString := FIDCALCALI;
            taItensAli.FieldByName( 'ID_ALI' ).AsString := FListaAlimento.DMListaAlimento.quAli.FieldByName( 'IDALI' ).AsString;
            taItensAli.FieldByName( 'ID_REFEICAO' ).AsString := taRefCalcAli.FieldByNAme( 'ID_REFEICAO' ).AsString;
            if FQtdeAlimento > 0 then
                  taItensAli.FieldByName( 'QUANT' ).AsFloat :=  FQtdeAlimento;
            taItensAli.FieldByName( 'ID_MEDIDA' ).AsString := FIDMedCasAlimento;
            taItensAli.FieldByName( 'PESO' ).AsFloat :=  FPesoItemAlimentar.AsFloat;
            taItensAli.FieldByName( 'FREQDIA' ).AsString := FFrequenciaDiaAux;
            taItensAli.FieldByName( 'ITEM' ).AsInteger := ProximoItem;
            // Carrega Nutrientes para calculos de proteinaAVB e relacoes
            NutToItensAli( taItensAli.FieldByName( 'ID_ALI' ).AsString, taItensAli);
            taItensAli.Post;
         end;
   end;
   FPesoItemAlimentar.AsFloat := 0;
   FIDMedCasAlimento := IDMEDGRAMAS;
   Calcular;
end;

// Alterar um item alimentar
procedure TCustomCalculoAlimentar.Alterar;
begin
   with FDMCalcAli do
   begin
      if not( taItensAli.IsEmpty ) then
         begin
            taItensAli.Edit;
            if FQtdeAlimento > 0 then
               taItensAli.FieldByName( 'QUANT' ).AsFloat := FQtdeAlimento
            else
               taItensAli.FieldByName( 'QUANT' ).Clear;
            taItensAli.FieldByName( 'ID_MEDIDA' ).AsString := FIDMedCasAlimento;
            taItensAli.FieldByName( 'PESO' ).AsFloat := FPesoItemAlimentar.AsFloat;
            taItensAli.FieldByName( 'FREQDIA' ).AsString := FFrequenciaDiaAux;
            taItensAli.Post;
         end;
   end;
   FPesoItemAlimentar.AsFloat := 0;
   FIDMedCasAlimento := IDMEDGRAMAS;
   Calcular;
end;

// Retira um alimento do calculo
procedure TCustomCalculoAlimentar.Retirar;
begin
   with FDMCalcAli do
   begin
      if taItensAli.IsEmpty then
         exit;
      // Retirei um item
      Dec( FItensAliCount );
      if Assigned( FOnBeforeDeleteItem ) then
         FOnBeforeDeleteItem(self, taItensAli.FieldByName( 'ID_REFEICAO' ).AsString);
      taItensAli.Delete;
      Calcular;
   end;
end;

function TCustomCalculoAlimentar.Calcular : Boolean;
begin
   Result := FDMCalcAli.Refresh( Ativar.ListaCalculos );
   OrdenaAliNutPorNutriente(FDMCalcAli.FMyField, FDMCalcAli.FOrdem);
end;

{ Method to generate OnPegaRefeicoes event }
procedure TCustomCalculoAlimentar.AntesDeAdicionar( var Cancelar : Boolean; JaExiste : Boolean );
begin
   if Assigned( FOnAntesDeAdicionar ) then
      FOnAntesDeAdicionar( Self, Cancelar, JaExiste );
end;

procedure TCustomCalculoAlimentar.AntesDeAlterar(var Cancelar: Boolean);
begin
end;

procedure TCustomCalculoAlimentar.PegaCalcDesc;
begin
    // Ordem para nao executar esta janela
    if FCancelar then
       exit;
    if Assigned(FOnPegaCalcDesc) then
       begin
          FOnPegaCalcDesc(Self, FCancelar);
          if FCancelar then
             exit;
       end;
end;

procedure TCustomCalculoAlimentar.DepoisDeSalvar;
begin
   if Assigned(FOnDepoisDeSalvar) then
      begin
         FOnDepoisDeSalvar(Self);
      end;
end;

procedure TCustomCalculoAlimentar.CloseTables;
var
   I : integer;
begin
   if (Assigned (Database)) and (Assigned(FDMCalcAli)) then
      for I:=0 to FDMCalcAli.ComponentCount -1 do
         if (FDMCalcAli.Components[I] is TDBDataSet) and (FDMCalcAli.Components[I].Tag = 0)  and
            (Trim(TDBDataSet(FDMCalcAli.Components[I]).DataBaseName) <> '') then
            TDBDataSet(FDMCalcAli.Components[I]).Close;
end;

procedure TCustomCalculoAlimentar.DefineDM;
var
   I : integer;
begin
   CloseTables;
   if (Assigned (Database)) and (Assigned(FDMCalcAli)) then
      for I:=0 to FDMCalcAli.ComponentCount -1 do
         if (FDMCalcAli.Components[I] is TDBDataSet) and (FDMCalcAli.Components[I].Tag = 0) then
            begin
               TDBDataSet(FDMCalcAli.Components[I]).DatabaseName := Database.DatabaseName;
            end;
   with FDMCalcAli do
   begin
      FActiveRefreshAll := False;
      // Tabelas de pesquisa
      taRefeicaoAux.Open;
      taAlimento.open;
      taMedCas.Open;
      quRefeicao.Open;
      taModRefeicao.Open;
      taAliNut.Open;
      taGruAli.Open;
      taNut.Open;
      // tabelas de edicao
      taCalcAli.Open;
      taItensAli.Open;
      taRefCalcAli.Open;
      taItensAliAux.Open;
      taItensAliAll.Open;
      FActiveRefreshAll := True;
   end;
end;

procedure TCustomCalculoAlimentar.OpenTables;
var
   I : integer;
begin
   if (Assigned (Database)) and (Assigned(FDMCalcAli)) then
      for I:=0 to FDMCalcAli.ComponentCount -1 do
         if (FDMCalcAli.Components[I] is TDBDataSet) and (FDMCalcAli.Components[I].Tag = 0) then
            begin
               TDBDataSet(FDMCalcAli.Components[I]).Open;
            end;
end;

procedure TCustomCalculoAlimentar.SetTotalNutrientes(Value: TDatasource);
begin
   FTotalNutrientes:=Value;
   if Assigned (Value) then
      begin
         Value.DataSet := FDMCalcAli.taTotalNut;
         Value.FreeNotification(self);
      end;
end;

procedure TCustomCalculoAlimentar.SetTotalMacroNutrientes(const Value: TDatasource);
begin
   FTotalMacroNutrientes:=Value;
   if Assigned (Value) then
      begin
         Value.DataSet := FDMCalcAli.taMacroNut;
         Value.FreeNotification(self);
      end;
end;

procedure TCustomCalculoAlimentar.SetPorcentagemNutrientesValidos(const Value: TDataSource);
begin
   FPorcentagemNutrientesValidos := Value;
   if Assigned (Value) then
   begin
      Value.DataSet := FDMCalcAli.taPorcentagemNutValidos;
      Value.FreeNotification(self);
   end;
end;

procedure TCustomCalculoAlimentar.SetItemsAlimentar(
  const Value: TDatasource);
begin
   FItemsAlimentar:=Value;
   if Assigned (Value) then
   begin
      Value.DataSet := FDMCalcAli.taItensAli;
      Value.FreeNotification(self);
   end;
end;

procedure TCustomCalculoAlimentar.SetDescricao(const Value: String);
begin
  FDescricao := Value;
end;

procedure TCustomCalculoAlimentar.SetObservacoes(const Value: TDataSource);
begin
   FObservacoes := Value;
   if Assigned (Value) then
   begin
      Value.DataSet := FDMCalcAli.taCalcAli;
      Value.FreeNotification(self);
   end;
end;

function TCustomCalculoAlimentar.IsEmpty: Boolean;
begin
   Result := ( FItensAliCount = 0  );
end;

//============================= T3-TCALCULOALIMENTAR ===========================

{ Resets prop of component type if referenced component deleted }
procedure TCalculoAlimentar.Notification(AComponent : TComponent; Operation : TOperation);
begin
   inherited Notification(AComponent, Operation);
   if Operation <> opRemove then
      Exit;
   if AComponent = FRefeicoesEscolhidas then
      FRefeicoesEscolhidas := nil
   else if AComponent = FProteinaAVBPorRefeicao then
      FProteinaAVBPorRefeicao := nil
   else if AComponent = FProteinaAVBPorCalculo then
      FProteinaAVBPorCalculo := nil
   else if AComponent = FRelacaoCaPPorRefeicao then
      FRelacaoCaPPorRefeicao := nil
   else if AComponent = FRelacaoCaPPorCalculo then
      FRelacaoCaPPorCalculo := nil
   else if AComponent = FRelacaoAcidosGraxosPorCalc then
      FRelacaoAcidosGraxosPorCalc := nil
   else if AComponent = FRelacaoAcidosGraxosPorRef then
      FRelacaoAcidosGraxosPorRef := nil
   else if AComponent = FRelacaoCaloriaNitrogenioPorCalc then
      FRelacaoCaloriaNitrogenioPorCalc := nil
   else if AComponent = FRelacaoCaloriaNitrogenioPorRef then
      FRelacaoCaloriaNitrogenioPorRef := nil
   else if AComponent = FPorcentagemEnergiaCalculada then
      FPorcentagemEnergiaCalculada := nil
   else if AComponent = FNutrientesPorPesoDia then
      FNutrientesPorPesoDia := nil
   else if AComponent = FGrupoAlimentarPorNutriente then
      FGrupoAlimentarPorNutriente := nil
   else if AComponent = FPesoCorporal then
      begin
         FPesoCorporal := nil;
         if Assigned( FDMCalcAli ) then
            FDMCalcAli.PesoCorporal := nil;
      end
   else if AComponent = FAlimentoPorNutriente then
      FAlimentoPorNutriente := nil
   else if AComponent = FSaldoNutrientes then
      FSaldoNutrientes := nil
   else if AComponent = FModelosRefeicoes then
      FModelosRefeicoes := nil;
end;

constructor TCalculoAlimentar.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FEntradaRefeicao := TStringList.Create;
   FSaidaRefeicao := TStringList.Create;
   FTituloCalculo := 'Cálculo Alimentar';
   // Estes eventos servem para contar os items alimentares que são inseridos e deletados
   // de cada refeição
   with FDMCalcAli do
   begin
      OnBeforeAppendItem := BeforeAppendItem;
      OnBeforeDeleteItem := BeforeDeleteItem;
   end;
end;

destructor TCalculoAlimentar.Destroy;
begin
   FEntradaRefeicao.Free;
   FSaidaRefeicao.Free;
   inherited Destroy;
end;

procedure TCalculoAlimentar.Loaded;
begin
     inherited Loaded;
end;

procedure TCalculoAlimentar.PegaRefeicoesSelecionadas;
var
   RefGUIDItem : TGUIDItem;
   I : Integer;
begin
   // Limpa listas
   for I := FEntradaRefeicao.Count - 1  downto 0 do
       TObject( FEntradaRefeicao.Objects[I] ).Free;
   FEntradaRefeicao.Clear;
   for I := FSaidaRefeicao.Count - 1  downto 0 do
       TObject( FSaidaRefeicao.Objects[I] ).Free;
   FSaidaRefeicao.Clear;
   with FDMCalcAli do
   begin
      // Carrega listas
      quRefeicao.First;
      while not quRefeicao.EOF do
      begin
         // Cria GUIDItem para controle de items exclusivos
         RefGUIDItem := TGUIDItem( Self.FindComponent( GUIDToName( quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString )));
         if not Assigned( RefGUIDItem ) then
            RefGUIDItem := TGUIDItem.Create(self);
         with RefGUIDItem do
         begin
             Name := GUIDToName(quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString);
             Guid := quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString;
             Exclusive := ( quRefeicao.FieldByName( 'EXCLUSIVE' ).AsString = 'T' );
             Tag := 0; // número de items alimentares nesta refeição
         end;
         if taItensAliAux.Locate( 'ID_CALCALI;ID_REFEICAO', VarArrayOf( [FIDCalcAli, quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString]), [] ) then
            FEntradaRefeicao.AddObject( quRefeicao.FieldByName( 'NOME' ).AsString, RefGUIDItem )
         else
            FSaidaRefeicao.AddObject( quRefeicao.FieldByName( 'NOME' ).AsString, RefGUIDItem );
         quRefeicao.Next;
      end;
      // Atualiza acumuladores
      taItensAliAux.First;
      while not taItensAliAux.Eof do
      begin
          IncItensRefeicao(taItensAliAux.FieldByName( 'ID_REFEICAO' ).AsString);
          taItensAliAux.Next;
      end;
   end;
end;

procedure TCalculoAlimentar.SetaRefeicoesSelecionadas;
var
   I : Integer;
begin
   // Efetua as inclusoes e exclusoes de refeicoes e seus itens de alimentos
   with FDMCalcAli do
   begin
      // Adiciona refeicoes
      for I := 0 to FEntradaRefeicao.Count - 1 do
          if quRefeicao.Locate( 'NOME', FEntradaRefeicao.Strings[I], [] ) then
             if not taRefCalcAli.Locate( 'ID_CALCALI;ID_REFEICAO', VarArrayOf( [FIDCalcAli,quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString]), [] ) then
                begin
                   taRefCalcAli.Append;
                   taRefCalcAli.FieldByName( 'ID_CALCALI' ).AsString := FIDCalcAli;
                   taRefCalcAli.FieldByName( 'ID_REFEICAO' ).AsString := quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString;
                   if quRefeicao.Locate( 'NOME', FEntradaRefeicao.Strings[I], [] ) then
                      taRefCalcAli.FieldByName( 'HORARIO' ).AsString := quRefeicao.FieldByName( 'HORARIO' ).AsString;
                   taRefCalcAli.Post;
                end;
      // Exclui refeicoes não escolhidas
      for I := 0 to FSaidaRefeicao.Count - 1 do
          if quRefeicao.Locate( 'NOME', FSaidaRefeicao.Strings[I], [] ) then
             begin
                if taRefCalcAli.Locate( 'ID_CALCALI;ID_REFEICAO', VarArrayOf([FIDCalcAli, quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString]), [] ) then
                begin
                   ShowMessage( 'Deletando refeição ' + FSaidaRefeicao.Strings[I] );
                   taRefCalcAli.Delete;
                end;
                while taItensAliAux.Locate( 'ID_CALCALI;ID_REFEICAO', VarArrayOf([FIDCalcAli, quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString]), [] ) do
                   begin
                      taItensAliAux.Delete;
                   end;
             end;
      // Excluir possivel refeicao global
      if FEntradaRefeicao.Count > 0 then
         while taItensAliAux.Locate( 'ID_CALCALI;ID_REFEICAO', VarArrayOf( [ FIDCalcAli, '']), [] ) do
            begin
               taItensAliAux.Delete;
            end;
      // Deletando refeição e seus itens de um modelo anterior
      taRefCalcAli.Filter := 'ID_CALCALI = ' + '''' + FIDCalcAli + '''';
      taRefCalcAli.Filtered := True;
      taRefCalcAli.First;
      while not taRefCalcAli.EOF do
      begin
          // Se não consta do modelo de refeições atual
          if not quRefeicao.Locate( 'ID_REFEICAO', taRefCalcAli.FieldByName( 'ID_REFEICAO' ).AsString, [] ) then
             begin
                if taRefeicaoAux.Locate( 'ID_REFEICAO', taRefCalcAli.FieldByName( 'ID_REFEICAO' ).AsString, [] ) then
                   ShowMessage( 'Deletando refeição ' + taRefeicaoAux.FieldByName( 'NOME' ).AsString )
                else
                   ShowMessage( 'Deletando refeição desconhecida.' );
                while taItensAliAux.Locate( 'ID_CALCALI;ID_REFEICAO', VarArrayOf([FIDCalcAli, taRefCalcAli.FieldByName( 'ID_REFEICAO' ).AsString]), [] ) do
                      taItensAliAux.Delete;
                taRefCalcAli.Delete;
             end
          else
             taRefCalcAli.Next;
      end;
      // Refresh nos dados
      taRefCalcAli.Filtered := False;
      taRefCalcAli.Filter := '';
      taRefCalcAli.First;
   end;
end;

procedure TCalculoAlimentar.Abrir( const ReadOnly : Boolean = False );
begin
   inherited Abrir( ReadOnly );
   if not ReadOnly then
      PegaRefeicoes
   else
     begin
      PegaRefeicoesSelecionadas;
      SetaRefeicoesSelecionadas;
     end;
end;

procedure TCalculoAlimentar.Salvar;
begin
   inherited Salvar;
end;

procedure TCalculoAlimentar.Novo( const ReadOnly : Boolean = False );
begin
   inherited Novo( ReadOnly );
   if not ReadOnly then
      PegaRefeicoes
   else
      begin
         PegaRefeicoesSelecionadas;
         SetaRefeicoesSelecionadas;
      end;
end;

procedure TCalculoAlimentar.PegaRefeicoes;
begin
   // Ordem para nao executar esta janela
   if FCancelar then
      exit;
   PegaRefeicoesSelecionadas;
   if Assigned(FOnPegaRefeicoes) then
      begin
         FOnPegaRefeicoes(Self, FEntradaRefeicao, FSaidaRefeicao, FCancelar );
         if FCancelar then
            exit;
      end;
   SetaRefeicoesSelecionadas;
end;

procedure TCalculoAlimentar.SetaRecNut;
var
   AuxCx : TCaixa;
   mdNut : TMedida;
begin
   if FCaixaRecNut <> '' then
   with DMCalculoAlimentar do
   begin
      cxRecNut := TCaixa( FMemoria.FindComponent( FCaixaRecNut ) );
      if not Assigned( cxRecNut ) then
      begin
         AuxCx := TCaixa.Create( FMemoria );
         AuxCx.Name := FCaixaRecNut;
         AuxCx.Descricao := 'Recomendação Nutricional';
         cxRecNut := AuxCx;
      end;
      with taNut do
      begin
         First;
         while not EOF do
         begin
            if not cxRecNut.Acha( GuidToName( FieldByName( 'IDNUT' ).AsString, cxRecNut.Name ), TObject( mdNut ) ) then
               begin
                  mdNut := TMedida.Create( self );
                  mdNut.Name := GuidToName( FieldByName( 'IDNUT' ).AsString, cxRecNut.Name );
                  mdNut.Descricao := FieldByName( 'NOMENUT' ).AsString;
                  mdNut.Unidade := FieldByName( 'UNIDADE' ).AsString;
                  mdNut.Empty := True;
                  mdNut.Valid := False;
                  mdNut.Tag := FieldByName( 'ORDPADRAO' ).AsInteger;
                  FMemoria.Adiciona( mdNut.Name, TObject( mdNut ), cxRecNut.Name );
                  mdNut.Free;
               end;
            Next;
         end;
      end;
   end;
end;

procedure TCalculoAlimentar.PegaRecCalorica;
begin
   // Ordem para nao executar esta janela
   if FCancelar then
      exit;
   if Assigned(FOnPegaRecCalorica) then
      begin
         FOnPegaRecCalorica(Self, FCancelar);
         if FCancelar then
            exit;
      end;
end;

procedure TCalculoAlimentar.SetSaldoNutrientes(const Value: TDatasource);
begin
   FSaldoNutrientes:=Value;
   if Assigned (Value) then
   begin
      Value.DataSet := FDMCalcAli.taSaldoNut;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetRefeicoesEscolhidas(
  const Value: TDataSource);
begin
   FRefeicoesEscolhidas:=Value;
   if Assigned (Value) then
   begin
      Value.DataSet := FDMCalcAli.taRefCalcAli;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetEntradaRefeicao(const Value: TStrings);
begin
   FEntradaRefeicao.Assign( Value );
end;

procedure TCalculoAlimentar.SetSaidaRefeicao(const Value: TStrings);
begin
   FSaidaRefeicao.Assign( Value );
end;

procedure TCalculoAlimentar.SetPesoCorporal(const Value: TMedida);
begin
   FPesoCorporal := Value;
   if Assigned( Value ) then
   begin
      FDMCalcAli.PesoCorporal := Value;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetProteinaAVBPorRefeicao(const Value: TDatasource);
begin
   FProteinaAVBPorRefeicao:=Value;
   if Assigned(Value) then
   begin
      Value.DataSet := FDMCalcAli.quProtAVBRef;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetProteinaAVBPorCalculo(const Value: TDatasource);
begin
   FProteinaAVBPorCalculo:=Value;
   if Assigned (Value) then
   begin
      Value.DataSet := FDMCalcAli.quProtAVBCalc;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetRelacaoCaPPorCalculo(const Value: TDatasource);
begin
   FRelacaoCaPPorCalculo := Value;
   if Assigned (Value) then
   begin
      Value.DataSet := FDMCalcAli.quRelacaoCaPCalc;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetRelacaoCaPPorRefeicao(const Value: TDatasource);
begin
   FRelacaoCaPPorRefeicao := Value;
   if Assigned(Value) then
   begin
      Value.DataSet := FDMCalcAli.quRelacaoCaPRef;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetRelacaoAcidosGraxosPorCalc(const Value: TDataSource);
begin
   FRelacaoAcidosGraxosPorCalc := Value;
   if Assigned(Value) then
   begin
      Value.DataSet := FDMCalcAli.quRelacaoAgSatPolMonCalc;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetRelacaoAcidosGraxosPorRef(const Value: TDataSource);
begin
   FRelacaoAcidosGraxosPorRef := Value;
   if Assigned(Value) then
   begin
      Value.DataSet := FDMCalcAli.quRelacaoAgSatPolMonRef;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetRelacaoCaloriaNitrogenioPorCalc(const Value: TDataSource);
begin
   FRelacaoCaloriaNitrogenioPorCalc := Value;
   if Assigned(Value) then
   begin
      Value.DataSet := FDMCalcAli.quRelacaoCalNCalc;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetRelacaoCaloriaNitrogenioPorRef(const Value: TDataSource);
begin
   FRelacaoCaloriaNitrogenioPorRef := Value;
   if Assigned(Value) then
   begin
      Value.DataSet := FDMCalcAli.quRelacaoCalNRef;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetPorcentagemEnergiaCalculada(const Value: TDataSource);
begin
   FPorcentagemEnergiaCalculada := Value;
   if Assigned(Value) then
   begin
      Value.DataSet := FDMCalcAli.quPorcentagemEnergia;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetNutrientesPorPesoDia(const Value: TDataSource);
begin
   FNutrientesPorPesoDia := Value;
   if Assigned(Value) then
   begin
      Value.DataSet := FDMCalcAli.taTotalNutPesoDia;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetGrupoAlimentarPorNutriente(const Value: TDataSource);
begin
  FGrupoAlimentarPorNutriente := Value;
   if Assigned(Value) then
   begin
      Value.DataSet := FDMCalcAli.taTotGru_Gru;
      Value.FreeNotification(self);
   end;
end;

procedure TCalculoAlimentar.SetCaixaRecNut(const Value: String);
begin
   FCaixaRecNut := Value;
end;

function TCalculoAlimentar.CriaAtivarCalculoAlimentar: TAtivaCustomCalculoAlimentar;
begin
   Result := TAtivaCalculoAlimentar.Create;
end;

//============================= T4-TCALCULODIETA ================================

constructor TCalculoDieta.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FTituloCalculo := 'Dieta';
end;

destructor TCalculoDieta.Destroy;
begin
   inherited Destroy;
end;

procedure TCalculoDieta.Loaded;
begin
   inherited Loaded;
end;

procedure TCalculoDieta.Abrir( const ReadOnly : Boolean = False );
begin
   inherited Abrir( ReadOnly );
end;

procedure TCalculoDieta.Salvar;
begin
   inherited Salvar;
end;

procedure TCalculoDieta.Novo( const ReadOnly : Boolean = False );
var
   CalculoAlimentar : TCaixa;
   mdSelRC : TMedida;
begin
   inherited Novo( ReadOnly );
   // Procura ou cria caixa
   if not FMemoria.Acha( FNomeCalculo, TObject( CalculoAlimentar )) then
   begin
      CalculoAlimentar := TCaixa.Create(FMemoria);
      CalculoAlimentar.Name := FNomeCalculo;
      CalculoAlimentar.Descricao := 'Plano Alimentar';
   end;
   FDescricaoCalculo.Descricao := 'Nome do Plano Alimentar';
   // Indica o tipo de recomendação nutricional
   mdSelRC := TMedida.Create(CalculoAlimentar);
   mdSelRC.Name := 'mdSelRecCal';
   mdSelRC.Descricao := '';
   mdSelRC.ValorNumerico := '0';
   mdSelRC.Unidade := 'ItemIndex';
end;

procedure TCalculoDieta.Notification(AComponent: TComponent; Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
end;

function TCalculoDieta.CriaAtivarCalculoAlimentar: TAtivaCustomCalculoAlimentar;
begin
   Result := TAtivaCalculoDieta.Create;
end;

//============================= T5-TCALULOINQUERITO ============================

{ Resets prop of component type if referenced component deleted }
procedure TCalculoInquerito.Notification(AComponent : TComponent; Operation : TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FDiasDeConsumo then
        FDiasDeConsumo := nil;

end;

constructor TCalculoInquerito.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FTituloCalculo := 'Inquérito Alimentar';
end;

destructor TCalculoInquerito.Destroy;
begin
   inherited Destroy;
end;

procedure TCalculoInquerito.Loaded;
begin
     inherited Loaded;
end;

procedure TCalculoInquerito.Abrir( const ReadOnly : Boolean = False );
begin
   inherited Abrir( ReadOnly );
   FMemoria.Acha( self.FNomeCalculo + 'DiasDeConsumo', TObject( FDiasDeConsumo ) );
   if not ReadOnly then
      PegaDiasDeConsumo;
end;

procedure TCalculoInquerito.Salvar;
begin
   inherited Salvar;
end;

procedure TCalculoInquerito.Novo( const ReadOnly : Boolean = False );
var
   CalculoAlimentar : TCaixa;
   mdSelRC : TMedida;
begin
   inherited Novo( ReadOnly );
   // Procura ou cria caixa
   if not FMemoria.Acha( FNomeCalculo, TObject( CalculoAlimentar )) then
   begin
      CalculoAlimentar := TCaixa.Create(FMemoria);
      CalculoAlimentar.Name := FNomeCalculo;
      CalculoAlimentar.Descricao := 'Inquerito';
   end;
   // Indica o tipo de recomendação nutricional
   mdSelRC := TMedida.Create(CalculoAlimentar);
   mdSelRC.Name := 'mdSelRecCal';
   mdSelRC.Descricao := 'RDA';
   mdSelRC.ValorNumerico := '2';
   mdSelRC.Unidade := 'ItemIndex';

   FDescricaoCalculo.Descricao := 'Nome do Inquérito';
   FDiasDeConsumo := TMedida.Create(CalculoAlimentar);
   FDiasDeConsumo.Descricao := 'Inquerito de';
   FDiasDeConsumo.ValorNumerico := '1';
   FDiasDeConsumo.Unidade := 'dia(s)';
   FDiasDeConsumo.Valid := True; // deveria validar na entrada este flag
   FDiasDeConsumo.Name := self.FNomeCalculo + 'DiasDeConsumo';
   if not ReadOnly then
      PegaDiasDeConsumo;
end;

procedure TCalculoInquerito.PegaDiasDeConsumo;
begin
     // Ordem para nao executar esta janela
     if FCancelar then
        exit;
     if Assigned(FOnPegaDiasDeConsumo) then
        begin
           FOnPegaDiasDeConsumo(Self, FCancelar);
           if FCancelar then
              exit;
        end;
     FDMCalcAli.Periodo := StrToInt( FDiasDeConsumo.ValorNumerico );
end;

//========================= T6-TCALCULOINQUERITOFREQUENCIA =====================

procedure TCalculoInqueritoFrequencia.Notification(AComponent : TComponent; Operation : TOperation);
begin
   inherited Notification(AComponent, Operation);
   if Operation <> opRemove then
      Exit;
   if AComponent = FFrequenciaDia then
      FFrequenciaDia := nil;
end;

constructor TCalculoInqueritoFrequencia.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FTituloCalculo := 'Inquérito de Frequência';
end;

destructor TCalculoInqueritoFrequencia.Destroy;
begin
   inherited Destroy;
end;

procedure TCalculoInqueritoFrequencia.Loaded;
begin
   inherited Loaded;
end;

procedure TCalculoInqueritoFrequencia.Adicionar;
begin
   FFrequenciaDiaAux := FFrequenciaDia.Text;
   inherited Adicionar;
end;

//=========================== T7-TCALULOPREPARACAO =============================

constructor TCalculoPreparacao.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FTituloCalculo := 'Preparação';
   FPesoIngredientes := FDMCalcAli.mdPesoIngredientes;
   FSaldoPeso := FDMCalcAli.mdSaldoPeso;
   FTotalAgua := FDMCalcAli.mdTotalAgua;
   FAguaRestante := FDMCalcAli.mdAguaRestante;
end;

destructor TCalculoPreparacao.Destroy;
begin
   inherited Destroy;
end;

procedure TCalculoPreparacao.Loaded;
begin
   inherited Loaded;
end;

procedure TCalculoPreparacao.Notification(AComponent : TComponent; Operation : TOperation);
begin
   inherited Notification(AComponent, Operation);
   if Operation <> opRemove then
      Exit;
   if AComponent = FPesoFinal then
      begin
         FPesoFinal := nil;
         if Assigned( FDMCalcAli ) then
            FDMCalcAli.FPesoFinal := nil;
      end
   else if AComponent = FPesoIngredientes then
      FPesoIngredientes := nil
   else if AComponent = FSaldoPeso then
      FSaldoPeso := nil
   else if AComponent = FTotalAgua then
      FTotalAgua := nil
   else if AComponent = FAguaRestante then
      FAguaRestante := nil;
end;

procedure TCalculoPreparacao.Abrir( const ReadOnly : Boolean = False );
begin
   inherited Abrir( ReadOnly );
   // Efetua a inclusao de refeicao Global
   with FDMCalcAli do
   begin
      if quRefeicao.Locate( 'NOME', 'Global', [] ) then
         if not taRefCalcAli.Locate( 'ID_CALCALI;ID_REFEICAO', VarArrayOf( [FIDCalcAli,quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString]), [] ) then
            begin
               taRefCalcAli.Append;
               taRefCalcAli.FieldByName( 'ID_CALCALI' ).AsString := FIDCalcAli;
               taRefCalcAli.FieldByName( 'ID_REFEICAO' ).AsString := quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString;
               taRefCalcAli.FieldByName( 'HORARIO' ).AsString := quRefeicao.FieldByName( 'HORARIO' ).AsString;
               taRefCalcAli.Post;
            end;
   end;
   // se achaou o peso final, seta a medida de calculo do DataModule
   if FMemoria.Acha( self.FNomeCalculo + 'PesoFinal', TObject( FPesoFinal ) ) then
      FDMCalcAli.FPesoFinal := FPesoFinal;
   if not ReadOnly then
      PegaPesoFinal;
end;

procedure TCalculoPreparacao.Salvar;
begin
   inherited Salvar;
end;

procedure TCalculoPreparacao.Novo( const ReadOnly : Boolean = False );
var
   CalculoAlimentar : TCaixa;
begin
   inherited Novo( ReadOnly );
   // Efetua a inclusao de refeicao Global
   with FDMCalcAli do
   begin
      if quRefeicao.Locate( 'NOME', 'Global', [] ) then
         if not taRefCalcAli.Locate( 'ID_CALCALI;ID_REFEICAO', VarArrayOf( [FIDCalcAli,quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString]), [] ) then
            begin
               taRefCalcAli.Append;
               taRefCalcAli.FieldByName( 'ID_CALCALI' ).AsString := FIDCalcAli;
               taRefCalcAli.FieldByName( 'ID_REFEICAO' ).AsString := quRefeicao.FieldByName( 'ID_REFEICAO' ).AsString;
               taRefCalcAli.FieldByName( 'HORARIO' ).AsString := quRefeicao.FieldByName( 'HORARIO' ).AsString;
               taRefCalcAli.Post;
            end;
   end;
   // Procura ou cria caixa
   if not FMemoria.Acha( FNomeCalculo, TObject( CalculoAlimentar )) then
   begin
      CalculoAlimentar := TCaixa.Create(FMemoria);
      CalculoAlimentar.Name := FNomeCalculo;
      CalculoAlimentar.Descricao := 'Preparação';
   end;
   FPesoFinal := TMedida.Create(CalculoAlimentar);
   FPesoFinal.Descricao := 'Peso Final';
   FPesoFinal.ValorNumerico := '0';
   FPesoFinal.Unidade := 'g';
   FPesoFinal.Valid := True; // deveria validar na entrada este flag
   FPesoFinal.Name := self.FNomeCalculo + 'PesoFinal';
   FDMCalcAli.FPesoFinal := FPesoFinal;
   if not ReadOnly then
      PegaPesoFinal;
end;

procedure TCalculoPreparacao.PegaPesoFinal;
begin
     // Ordem para nao executar esta janela
     if FCancelar then
        exit;
     if Assigned(FOnPegaPesoFinal) then
        begin
           FOnPegaPesoFinal(Self, FCancelar);
           if FCancelar then
              exit;
        end;
end;

//================================ T1- TCALCALI ================================

// Apaga todas os registros relacionados ao ID
function TCalcAli.LimpaCalcAli( ID : String ) : Boolean;
begin
   Result := True;
   // Verifica se ha tabela para excluir
   if not taCalcali.Active then
      exit;
   // Localiza Calculo a ser excluido
   if taCalcAli.Locate( 'ID_CALCALI', ID, [] ) then
   begin
      quDelItensAli.ParamByName( 'ID_CALCALI' ).AsString := ID;
      quDelItensAli.ExecSQL;
      quDelRefCalcAli.ParamByName( 'ID_CALCALI' ).AsString := ID;
      quDelRefCalcAli.ExecSQL;
      quDelCalcAli.ParamByName( 'ID_CALCALI' ).AsString := ID;
      // Inicia processo demorado
      if Assigned( FDelayedOpIndicator ) then
         FDelayedOpIndicator.Start;
      Try
        quDelCalcAli.ExecSQL;
      finally
        // Finaliza Processo demorado
        if Assigned( FDelayedOpIndicator ) then
           FDelayedOpIndicator.Finish;
      end;
   end
   else
   begin
      Result := False;
   end;
end;

// Insere o ID do calculo a ser instanciado
function TCalcAli.CriaCalcAli( ID : String; NomeCalc : String = '' ) : Boolean;
begin
   Result := True;
   // Verifica se ha tabela para incluir
   if not taCalcali.Active then exit;
   // Desliga refresh
   FActiveRefreshAll := False;
   taCalcAli.Append;
   taCalcAli.FieldByName( 'ID_CALCALI' ).AsString := ID;
   taCalcAli.FieldByName( 'NOME_CALC' ).AsString := NomeCalc;
   taCalcAli.FieldByName( 'DATA_CRIACAO' ).AsDateTime := Date;
   taCalcAli.Post;
   // Verifica se criou e posiciona
   if not taCalcAli.Locate( 'ID_CALCALI', ID, [] ) then
   begin
      Result := False;
      ShowMessage( 'Não consegui criar calculo: ' + ID );
   end;
   // liga o refresh e faz o mesmo
   FActiveRefreshAll := True;
end;

// Calcula campos de totais de nutrientes
procedure TCalcAli.taTotalNutCalcFields(DataSet: TDataSet);
var
   ValorTot,
   ValorRef,
   ValorItem : Double;
   ContNutRefValidos,
   ContNutCalcValidos,
   ContNutRef,
   ContNutCalc : Integer;
begin
   // executa se estiver ativo
   if taItensAliAux.Active then
   begin
      // Contadores de nutrientes
      ContNutRefValidos := 0;
      ContNutCalcValidos := 0;
      ContNutRef := 0;
      ContNutCalc := 0;
      // Valores dos nutrientes
      ValorTot := 0;
      ValorRef := 0;
      with taItensAliAux do
      begin
         first;
         while not EOF do
         begin
           // Acumula os valores dos nutrientes de cada alimento
           if taAliNut.Locate(    'IDALI;IDNUT',
                                  VarArrayOf([ FieldByName( 'ID_ALI' ).AsString,
                                  DataSet.FieldByName( 'IDNUT' ).AsString ]), [] ) then
              begin
                 // Valor do nutriente do item
                 ValorItem := taAliNut.FieldByName( 'VALOR' ).AsFloat  * FieldByName( 'PESO' ).AsFloat / 100;
                 // Total por nutriente por refeicao
                 if FieldByName( 'ID_REFEICAO' ).AsString = taRefCalcAli.FieldByName( 'ID_REFEICAO' ).AsString then
                    begin
                       ValorRef := ValorRef + ( ValorItem / Periodo );
                       // Contando nutrientes por refeicao, validos
                       Inc( ContNutRefValidos );
                    end;
                 // Total geral de nutrientes
                 ValorTot := ValorTot + ( ValorItem / Periodo );
                 // Contando nutrientes validos
                 Inc( ContNutCalcValidos );
              end;
           // Contando nutrientes por refeicao
           if FieldByName( 'ID_REFEICAO' ).AsString = taRefCalcAli.FieldByName( 'ID_REFEICAO' ).AsString then
              Inc( ContNutRef );
           Inc( ContNutCalc );
           next;
         end;
//################  SÓ FUNCIONA PARA O NUTRIENTE ÁGUA ###########
       if ( DataSet.FieldByName( 'IDNUT' ).AsString = IDAGUA ) then
       begin
         // Total antes da evaporação
            mdTotalAgua.AsFloat := ValorTot;
            mdTotalAgua.Valid := True;
         // Este ajuste no nutriente agua só vale para preparacao
         // Se o saldo for positivo, quer dizer que houve perda de água por evaporação
         SetPesoIngredientes;
         mdSaldoPeso.Valid := True;  // considera valido de inicio
         if ( mdSaldoPeso.AsFloat > 0 ) then
         begin
            // Caso o saldo seja maior que a agua total da preparacao,
            // não posso aceitar o saldo como valido, mas vou retirar toda a
            // agua. Ha casos que o total de agua de uma preparação não é 100%
            // válido, portanto ao subtrair do saldo o valor pode dar negativo
            if ValorTot < mdSaldoPeso.AsFloat then
               begin
                  mdSaldoPeso.Valid := False;
                  ValorTot := 0;
                  ValorRef := 0;
               end
            else
               begin
                  mdSaldoPeso.Valid := True;
                  ValorTot := ValorTot - mdSaldoPeso.AsFloat;
                  ValorRef := ValorRef - mdSaldoPeso.AsFloat;
               end;
         end;
         // água restante após a evaporação
         mdAguaRestante.AsFloat := ValorTot;
         mdAguaRestante.Valid := True;
       end;
//################  SÓ FUNCIONA PARA O NUTRIENTE ÁGUA ###########
      end;
      // Seta os campos calculados com os totais acumulados
      DataSet.FieldByName( 'VALORTOT' ).AsString := FormatFloat( '###0.00', ValorTot );
      DataSet.FieldByName( 'VALORREF' ).AsString := FormatFloat( '###0.00', ValorRef );
      // Seta campos de Peso por Energia
      if Assigned( FPesoCorporal ) and ( not FPesoCorporal.Empty ) and ( FPesoCorporal.AsFloat <> 0 ) then
         begin
            DataSet.FieldByName( 'VALORTOTPESODIA' ).AsString := FormatFloat( '###0.00', ValorTot/FPesoCorporal.AsFloat );
            DataSet.FieldByName( 'UNIDADEPESODIA' ).AsString := Trim( DataSet.FieldByName( 'UNIDADE' ).AsString ) + '/' +
                                                                Trim( FPesoCorporal.Unidade ) +
                                                                '/dia';
         end
      else
         begin
            DataSet.FieldByName( 'VALORTOTPESODIA' ).AsString := FormatFloat( '###0.00', 0 );
            DataSet.FieldByName( 'UNIDADEPESODIA' ).AsString := '';
         end;
       // Seta porcentagem entre Refeicao e Total
       if ValorTot <> 0 then
         DataSet.FieldByName( 'REFTOT' ).AsString := FormatFloat( '##0.00', ( ValorRef / ValorTot ) * 100 )
      else
         DataSet.FieldByName( 'REFTOT' ).AsString := FormatFloat( '##0.00', 0 );
      // Seta Porcentagem nutrientes validos
      if ( ContNutRef > 0 ) AND ( ContNutCalc > 0 ) then
         begin
            DataSet.FieldByName( 'NUTVALIDOREF' ).AsString := FormatFloat( '##0.00', ( ContNutRefValidos / ContNutRef ) * 100 );
            DataSet.FieldByName( 'NUTVALIDOCALC' ).AsString := FormatFloat( '##0.00',( ContNutCalcValidos / ContNutCalc ) * 100 );
         end
      else
         begin
            DataSet.FieldByName( 'NUTVALIDOREF' ).AsString := FormatFloat( '##0.00', 0 );
            DataSet.FieldByName( 'NUTVALIDOCALC' ).AsString := FormatFloat( '##0.00', 0 );
         end;
   end;
end;

// Cria datamodule do calculo alimentar instanciado
procedure TCalcAli.DMCalcAliCreate(Sender: TObject);
begin
   // Periodo default eh 1
   Periodo := 1;
   // Seta name do DataModule do calculo alimentar
   self.Name := GuidTOName( CreateNewGuid );
   // Lista de nutrientes para calculo de Grupo Alimentar por Nutriente
   ListaNutGru := TStringList.Create;
   // Lista de nutrientes para calculo de Alimentos por Nutriente
   ListaNutAli := TStringList.Create;
end;

// Calcula os campos de macronutrientes
procedure TCalcAli.taMacroNutCalcFields(DataSet: TDataSet);
begin
   // Nao executa se nao estiver ativo
   if not DataSet.Active then exit;
   if not MacroNutRef.Calcular then
      exit; // nao conseguiu calcular
   if not MacroNutTot.Calcular then
      exit; // nao conseguiu calcular
   // Passa valores calculados para os campos
   with DataSet do
   begin
      if ( MacroNutTot.IDEnergia = DataSet.FieldByName( 'IDMACRONUT' ).AsString ) then
      begin
         FieldByName( 'VALORTOT' ).AsString := FormatFloat( '###0', MacroNutTot.Energia );
         FieldByName( 'VALORREF' ).AsString := FormatFloat( '###0', MacroNutRef.Energia );
      end;
      if ( MacroNutTot.IDProteinas = DataSet.FieldByName( 'IDMACRONUT' ).AsString ) then
      begin
         FieldByName( 'VALORTOT' ).AsString := FormatFloat( '###0.00', MacroNutTot.Proteinas );
         FieldByName( 'VALORREF' ).AsString := FormatFloat( '###0.00', MacroNutRef.Proteinas );
         FieldByName( 'RELACENERGIATOT' ).AsString := FormatFloat( '###0.00', MacroNutTot.PorcentagemProteinas );
         FieldByName( 'RELACENERGIAREF' ).AsString := FormatFloat( '###0.00', MacroNutRef.PorcentagemProteinas );
         FieldByName( 'RELACENERGIAUNID' ).AsString := '% kcal';
      end;
      if ( MacroNutTot.IDCarboidratos = DataSet.FieldByName( 'IDMACRONUT' ).AsString ) then
      begin
         FieldByName( 'VALORTOT' ).AsString := FormatFloat( '###0.00', MacroNutTot.Carboidratos );
         FieldByName( 'VALORREF' ).AsString := FormatFloat( '###0.00', MacroNutRef.Carboidratos );
         FieldByName( 'RELACENERGIATOT' ).AsString := FormatFloat( '###0.00', MacroNutTot.PorcentagemCarboidratos );
         FieldByName( 'RELACENERGIAREF' ).AsString := FormatFloat( '###0.00', MacroNutRef.PorcentagemCarboidratos );
         FieldByName( 'RELACENERGIAUNID' ).AsString := '% kcal';
      end;
      if ( MacroNutTot.IDLipideos = DataSet.FieldByName( 'IDMACRONUT' ).AsString ) then
      begin
         FieldByName( 'VALORTOT' ).AsString := FormatFloat( '###0.00', MacroNutTot.Lipideos );
         FieldByName( 'VALORREF' ).AsString := FormatFloat( '###0.00', MacroNutRef.Lipideos );
         FieldByName( 'RELACENERGIATOT' ).AsString := FormatFloat( '###0.00', MacroNutTot.PorcentagemLipideos );
         FieldByName( 'RELACENERGIAREF' ).AsString := FormatFloat( '###0.00', MacroNutRef.PorcentagemLipideos );
         FieldByName( 'RELACENERGIAUNID' ).AsString := '% kcal';
     end;
   end;
end;

// Pega so o horario do campo DateTime
procedure TCalcAli.taSaldoNutCalcFields(DataSet: TDataSet);
var
   mdNut : TMedida;
begin
   // Nao executa se nao estiver ativo
   if not DataSet.Active then exit;
   // Calcula os totais de nutrientes para fazer o saldo
   taTotalNutCalcFields(DataSet);
   // Passa valores calculados para os campos
   if Assigned( cxRecNut ) then
   begin
      if cxRecNut.Acha( GuidToName( DataSet.FieldByName( 'IDNUT' ).AsString, cxRecNut.Name ), TObject( mdNut ) ) AND mdNut.Valid AND ( mdNut.ValorNumerico <> '' ) AND (mdNut.AsFloat > 0) then
         DataSet.FieldByName( 'RECNUT' ).AsString := FormatFloat( '#####0.00', mdNut.AsFloat );
      if ( DataSet.FieldByName( 'VALORTOT' ).AsString <> '' ) AND ( DataSet.FieldByName( 'RECNUT' ).AsString <> '' ) then
         DataSet.FieldByName( 'SALDONUT' ).AsString  := FormatFloat( '#####0.00',DataSet.FieldByName( 'VALORTOT' ).AsFloat - DataSet.FieldByName( 'RECNUT' ).AsFloat);
   end;
end;

//==============================================================================

procedure TCalcAli.taCalcAliNewRecord(DataSet: TDataSet);
begin
   DataSet.FieldByName( 'GUID' ).AsString := CreateNewGUID;
end;

procedure TCustomCalculoAlimentar.SetPesoItemAlimentar(const Value: TMedida);
begin
   FPesoItemAlimentar := Value;
   if Assigned( Value ) then
      Value.FreeNotification(self);
end;

procedure TCalcAli.taRefCalcAliDISTRIBUICAOValidate(Sender: TField);
var
   Soma,
   Vazio,
   ValorMax,
   ValorMin : Double;
begin
   with quDistEnergiaTotal do
   begin
      Open;
      Soma := FieldByName( 'SOMA' ).AsFloat;
      Close;
   end;
   with quDistEnergiaVazio do
   begin
      Open;
      Vazio := FieldByName( 'VAZIO' ).AsFloat;
      Close;
   end;
   ValorMin := 1;
   ValorMax := 100-(Soma+(Vazio-1));
   if ( Sender.AsFloat < ValorMin) or (Sender.AsFloat > ValorMax) then
      raise Exception.CreateFmt('%f não está entre a faixa válida: %f..%f',
                                [Sender.AsFloat, ValorMin, ValorMax]);
end;

function TCalcAli.IsProteinaAVB(var Valor: Double; IDAlimento: String): String;
begin
   Result := '';
   if taAliNut.Locate( 'IDALI;IDNUT', VarArrayOf([ IDAlimento, IDPROTEINA ]), [] ) then
      begin
         Valor := taAliNut.FieldByName( 'VALOR' ).AsFloat;
         if taAlimento.Locate( 'IDALI', IDAlimento, [] ) then
            if taGruAli.Locate( 'IDGRUALI', taAlimento.FieldByName( 'IDGRUALI' ).AsString, [] ) then
               Result := taGruAli.FieldByName( 'PROTAVB' ).AsString;
      end
   else
      Valor := 0;
end;

procedure TCalcAli.NutToItensAli( const IDAli : String; DataSet : TDataSet );
var
   Valor : Double;
   IsProtAVB : String;
begin
   with DataSet do
   begin
      IsProtAVB := IsProteinaAVB( Valor, IDAli );
      if IsProtAVB = 'T' then
         begin
            FieldByName( 'NUT_PROTAVB' ).AsString := FormatFloat( '###0.0', Valor );
            FieldByName( 'NUT_PROT' ).AsFloat := Valor;
         end
      else
         begin
            FieldByName( 'NUT_PROTAVB' ).AsFloat := 0;
            FieldByName( 'NUT_PROT' ).AsString := FormatFloat( '###0.0', Valor );
         end;
     if taAliNut.Locate( 'IDALI;IDNUT', VarArrayOf([ IDAli, IDENERGIA ]), [] ) then
           FieldByName( 'NUT_ENERGIA' ).AsFloat := taAliNut.FieldByName( 'VALOR' ).AsFloat
        else
           FieldByName( 'NUT_ENERGIA' ).AsFloat := 0;
     if taAliNut.Locate( 'IDALI;IDNUT', VarArrayOf([ IDAli, IDCALCIO ]), [] ) then
           FieldByName( 'NUT_CALCIO' ).AsFloat := taAliNut.FieldByName( 'VALOR' ).AsFloat
        else
           FieldByName( 'NUT_CALCIO' ).AsFloat := 0;
     if taAliNut.Locate( 'IDALI;IDNUT', VarArrayOf([ IDAli, IDFOSFORO ]), [] ) then
           FieldByName( 'NUT_FOSFORO' ).AsFloat := taAliNut.FieldByName( 'VALOR' ).AsFloat
        else
           FieldByName( 'NUT_FOSFORO' ).AsFloat := 0;
     if taAliNut.Locate( 'IDALI;IDNUT', VarArrayOf([ IDAli, IDAGSATURADO ]), [] ) then
           FieldByName( 'NUT_AGSAT' ).AsFloat := taAliNut.FieldByName( 'VALOR' ).AsFloat
        else
           FieldByName( 'NUT_AGSAT' ).AsFloat := 0;
     if taAliNut.Locate( 'IDALI;IDNUT', VarArrayOf([ IDAli, IDAGPOLINSATURADO ]), [] ) then
           FieldByName( 'NUT_AGPOL' ).AsFloat := taAliNut.FieldByName( 'VALOR' ).AsFloat 
        else
           FieldByName( 'NUT_AGPOL' ).AsFloat := 0;
     if taAliNut.Locate( 'IDALI;IDNUT', VarArrayOf([ IDAli, IDAGMONOINSATURADO ]), [] ) then
           FieldByName( 'NUT_AGMON' ).AsFloat := taAliNut.FieldByName( 'VALOR' ).AsFloat
        else
           FieldByName( 'NUT_AGMON' ).AsFloat := 0;
     if taAliNut.Locate( 'IDALI;IDNUT', VarArrayOf([ IDAli, IDCARBOIDRATO ]), [] ) then
           FieldByName( 'NUT_CARBO' ).AsFloat := taAliNut.FieldByName( 'VALOR' ).AsFloat
        else
           FieldByName( 'NUT_CARBO' ).AsFloat := 0;
     if taAliNut.Locate( 'IDALI;IDNUT', VarArrayOf([ IDAli, IDALCOOL ]), [] ) then
           FieldByName( 'NUT_ALCOOL' ).AsFloat := taAliNut.FieldByName( 'VALOR' ).AsFloat
        else
           FieldByName( 'NUT_ALCOOL' ).AsFloat := 0;
     if taAlimento.Locate( 'IDALI', FieldByName( 'ID_ALI' ).AsString, [] ) then
           FieldByName( 'IDGRUALI' ).AsString := taAlimento.FieldByName( 'IDGRUALI' ).AsString
        else
           FieldByName( 'IDGRUALI' ).AsString := '';
   end;
end;

procedure TCalcAli.SetPesoCorporal(const Value: TMedida);
begin
   FPesoCorporal := Value;
   if Assigned( Value ) then
      Value.FreeNotification(self);
end;

procedure TCalcAli.CalcAliDestroy(Sender: TObject);
begin
   // Destruir lista de nutrientes para calculo de Grupo Alimetar por Nutriente
   ListaNutGru.Free;
   // Destruir lista de nutrientes para calculo de Alimentos por Nutriente
   ListaNutAli.Free;
end;

procedure TCalcAli.taTotGru_GruCalcFields(DataSet: TDataSet);
var
   I : Integer;
   Soma : Double;
begin
    // Quando eu abro taTotGru_Gru estes ainda não foram
    // abertos
    if not ( taTotGru_Nut.Active ) or
       not( taTotGru_ItensAli.Active ) or
       not ( taTotGru_AliNut.Active ) then
       exit;
    // Faz o total de um nutriente de um grupo alimentar
    For I := 0 to ListaNutGru.Count - 1 do
       if taTotGru_Nut.Locate( 'IDNUT', ListaNutGru.Strings[I], [] ) then
          if TotalNutPorGrupoAlimentar( DataSet.FieldByName( 'IDGRUALI' ).AsString,
                                        ListaNutGru.Strings[I], Soma ) then
             DataSet.FieldByName( 'NUT' + IntToStr(I) ).AsString := FormatFloat( '##0.00', Soma )
          else
             DataSet.FieldByName( 'NUT' + IntToStr(I) ).AsString := '';
end;

procedure TCalcAli.taTotGru_GruBeforeOpen(DataSet: TDataSet);
begin
   CriaNutToFields(taTotGru_Nut, DataSet, ListaNutGru);
end;

function TCalcAli.TotalNutPorGrupoAlimentar(const IDGRUPO,
  IDNUT: String; var Total : Double): Boolean;
begin
   Result := False;
   Total := 0;
   taTotGru_ItensAli.Filter := 'IDGRUALI = ''' + IDGRUPO + '''';
   taTotGru_ItensAli.filtered := True;
   while not taTotGru_ItensAli.Eof do
   begin
      if taTotGru_AliNut.Locate( 'IDALI;IDNUT', VarArrayOf( [taTotGru_ItensAli.FieldByName( 'ID_ALI' ).AsString, IDNUT ]), [] ) then
      begin
         Total := Total + ( (taTotGru_AliNut.FieldByName( 'VALOR' ).AsFloat*
                            (taTotGru_ItensAli.FieldByName( 'PESO' ).AsFloat/Periodo)/100)*
                            taTotGru_ItensAli.FieldByName( 'FREQDIA' ).AsFloat );
         Result := True;
      end;
      taTotGru_ItensAli.Next;
   end;
end;

procedure TCalcAli.CriaNutToFields( DataSetNut, DataSetFields : TDataSet; ListaNut : TStringList );
var
   I : Integer;
   Nome : String;
begin
   // Ainda não foi aberto
   if not DataSetNut.Active then
      exit;
   for I := 0 to ListaNut.Count - 1 do
       TStringField( ListaNut.Objects[I] ).Free;
   ListaNut.Clear;
   FMyField := nil;
   I := 0;
   DataSetNut.First;
   while not DataSetNut.Eof do
   begin
      if ( DataSetNut.FieldByName( 'VISIVEL' ).asString = 'T' ) or FShowAllNut then
      begin
         F := TStringField.Create(self);
         Nome := 'NUT' + IntToStr(I);
         ListaNut.AddObject( DataSetNut.FieldByName( 'IDNUT' ).AsString, F );
         with F do
         begin
            Alignment := taRightJustify;
            DisplayLabel := DataSetNut.FieldByName( 'NOMENUT' ).AsString +
                            ' (' + DataSetNut.FieldByName( 'UNIDADE' ).AsString + ')';
            DisplayWidth := 20;
            FieldKind := fkCalculated;
            FieldName := Nome;
            Name := DataSetFields.Name + Nome;
            ReadOnly := False;
            Required := False;
            Size := 20;
            Transliterate := True;
            Visible := True;
            // Vincula
            DataSet := DataSetFields;
         end;
         Inc(I);
      end;
      DataSetNut.Next;
   end;
end;

function TCalcAli.Refresh( ListaCalcAli : TListaCalculosAlimentares ): Boolean;

 function SQLProtAVBRef(const nPeriodo : Integer) : String;
 begin
    Result := 'SELECT ID_CALCALI, ID_REFEICAO, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROTAVB)/100)/FREQDIA) TOT_PROTAVB, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA) TOT_PROT ' +
                      'FROM ITENSALI ' +
                      'WHERE ID_CALCALI = :ID_CALCALI AND ' +
                      'ID_REFEICAO = :ID_REFEICAO ' +
                      'GROUP BY  ID_CALCALI, ID_REFEICAO, FREQDIA';
 end;
 function SQLProtAVBCalc(const nPeriodo : Integer) : String;
 begin
    Result := 'SELECT ID_CALCALI,' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROTAVB)/100)/FREQDIA) TOT_PROTAVB, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA) TOT_PROT ' +
                      'FROM ITENSALI ' +
                      'WHERE ID_CALCALI = :ID_CALCALI ' +
                      'GROUP BY  ID_CALCALI, FREQDIA';
 end;
 function SQLRelacaoCaPRef(const nPeriodo : Integer) : String;
 begin
    Result := 'SELECT ID_CALCALI, ID_REFEICAO, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_CALCIO)/100)/FREQDIA) TOT_CALCIO, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_FOSFORO)/100)/FREQDIA) TOT_FOSFORO ' +
                      'FROM ITENSALI ' +
                      'WHERE ID_CALCALI = :ID_CALCALI AND ' +
                      'ID_REFEICAO = :ID_REFEICAO ' +
                      'GROUP BY  ID_CALCALI, ID_REFEICAO, FREQDIA';
 end;
 function SQLRelacaoCaPCalc(const nPeriodo : Integer) : String;
 begin
    Result := 'SELECT ID_CALCALI, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_CALCIO)/100)/FREQDIA) TOT_CALCIO, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_FOSFORO)/100)/FREQDIA) TOT_FOSFORO ' +
                      'FROM ITENSALI ' +
                      'WHERE ID_CALCALI = :ID_CALCALI ' +
                      'GROUP BY  ID_CALCALI, FREQDIA';
 end;
 function SQLRelacaoAgSatPolMonRef(const nPeriodo : Integer) : String;
 begin
    Result := 'SELECT ID_CALCALI, ID_REFEICAO, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGSAT)/100)/FREQDIA) TOT_AGSAT, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGPOL)/100)/FREQDIA) TOT_AGPOL, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGMON)/100)/FREQDIA) TOT_AGMON  ' +
                      'FROM ITENSALI ' +
                      'WHERE ID_CALCALI = :ID_CALCALI AND ' +
                      'ID_REFEICAO = :ID_REFEICAO ' +
                      'GROUP BY  ID_CALCALI, ID_REFEICAO, FREQDIA';
 end;
 function SQLRelacaoAgSatPolMonCalc(const nPeriodo : Integer) : String;
 begin
    Result := 'SELECT ID_CALCALI, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGSAT)/100)/FREQDIA) TOT_AGSAT, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGPOL)/100)/FREQDIA) TOT_AGPOL, ' +
                      '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGMON)/100)/FREQDIA) TOT_AGMON  ' +
                      'FROM ITENSALI ' +
                      'WHERE ID_CALCALI = :ID_CALCALI ' +
                      'GROUP BY  ID_CALCALI, FREQDIA';
 end;
 function SQLRelacaoCalNRef(const nPeriodo : Integer) : String;
 begin
    Result := 'SELECT ID_CALCALI, ID_REFEICAO, ' +
              '((((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ENERGIA)/100)/FREQDIA)-((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA) )/' +
              '(4*((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA)/6.25)) REL_CALN_REF ' +
              'FROM ITENSALI ' +
              'WHERE ID_CALCALI = :ID_CALCALI AND ' +
              'ID_REFEICAO = :ID_REFEICAO ' +
              'GROUP BY  ID_CALCALI, ID_REFEICAO, FREQDIA';
 end;
 function SQLRelacaoCalNCalc(const nPeriodo : Integer) : String;
 begin
    Result := 'SELECT ID_CALCALI, ' +
              '((((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ENERGIA)/100)/FREQDIA)-((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA) )/' +
              '(4*((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA)/6.25)) REL_CALN_CALC ' +
              'FROM ITENSALI ' +
              'WHERE ID_CALCALI = :ID_CALCALI ' +
              'GROUP BY  ID_CALCALI, FREQDIA';
 end;
 function SQLPorcentagemEnergia(const nPeriodo : Integer) : String;
 begin
    Result := 'SELECT ID_CALCALI, ' +

       '((4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA))/' +
       '((4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA))+ ' +
       '(4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_CARBO)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGSAT)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGMON)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGPOL)/100)/FREQDIA))+ ' +
       '(7 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ALCOOL)/100)/FREQDIA)))*100) PORC_ENERGIA_PROT, ' +

       '((4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_CARBO)/100)/FREQDIA))/' +
       '((4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA))+ ' +
       '(4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_CARBO)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGSAT)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGMON)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGPOL)/100)/FREQDIA))+ ' +
       '(7 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ALCOOL)/100)/FREQDIA)))*100) PORC_ENERGIA_CARBO, ' +

       '((9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGSAT)/100)/FREQDIA))/' +
       '((4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA))+ ' +
       '(4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_CARBO)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGSAT)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGMON)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGPOL)/100)/FREQDIA))+ ' +
       '(7 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ALCOOL)/100)/FREQDIA)))*100) PORC_ENERGIA_AGSAT, ' +

       '((9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGMON)/100)/FREQDIA))/' +
       '((4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA))+ ' +
       '(4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_CARBO)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGSAT)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGMON)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGPOL)/100)/FREQDIA))+ ' +
       '(7 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ALCOOL)/100)/FREQDIA)))*100) PORC_ENERGIA_AGMON, ' +

       '((9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGPOL)/100)/FREQDIA))/' +
       '((4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA))+ ' +
       '(4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_CARBO)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGSAT)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGMON)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGPOL)/100)/FREQDIA))+ ' +
       '(7 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ALCOOL)/100)/FREQDIA)))*100) PORC_ENERGIA_AGPOL, ' +

       '((7 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ALCOOL)/100)/FREQDIA))/' +
       '((4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA))+ ' +
       '(4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_CARBO)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGSAT)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGMON)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGPOL)/100)/FREQDIA))+ ' +
       '(7 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ALCOOL)/100)/FREQDIA)))*100) PORC_ENERGIA_ALCOOL, ' +

       '((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ENERGIA)/100)/FREQDIA) TOT_ENERGIA, ' +

       '((4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_PROT)/100)/FREQDIA))+ ' +
       '(4 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_CARBO)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGSAT)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGMON)/100)/FREQDIA))+ ' +
       '(9 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_AGPOL)/100)/FREQDIA))+ ' +
       '(7 * ((SUM((PESO/' + IntToStr(Periodo) + ')*NUT_ALCOOL)/100)/FREQDIA))) TOT_ENERGIA_CALC ' +

       'FROM ITENSALI ' +
       'WHERE ID_CALCALI = :ID_CALCALI ' +
       'GROUP BY  ID_CALCALI, FREQDIA';
 end;

begin
Result := True;
if FActiveRefreshAll then
begin
 // Inicia indicador de operação demorada
 if Assigned( FDelayedOpIndicator ) then
    FDelayedOpIndicator.Start;
 Try
      if taItensAliAux.Active then
         taItensAliAux.Refresh;
      if tcaTotalNutrientes in ListaCalcAli then
         begin
            taTotalNut.Filtered := not FShowAllNut;
            if taTotalNut.Active then
               taTotalNut.Refresh
            else
               taTotalNut.Open;
         end
      else
         taTotalNut.Close;
      if tcaTotalMacroNutrientes in ListaCalcAli then
         begin
            if taMacroNut.Active then
               taMacroNut.Refresh
            else
               begin
                  taTotalNutAux.Open;
                  taMacroNut.Open;
               end;
         end
      else
         begin
            taTotalNutAux.Close;
            taMacroNut.Close;
         end;
      if tcaSaldoNutrientes in ListaCalcAli then
         begin
            taSaldoNut.Filtered := not FShowAllNut;
            if taSaldoNut.Active then
               taSaldoNut.Refresh
            else
               taSaldoNut.Open;
         end
      else
         taSaldoNut.Close;
      if tcaPorcentagemNutrientesValidos in ListaCalcAli then
         begin
            taPorcentagemNutValidos.Filtered := not FShowAllNut;
            if taPorcentagemNutValidos.Active then
               taPorcentagemNutValidos.Refresh
            else
               taPorcentagemNutValidos.Open;
         end
      else
         taPorcentagemNutValidos.Close;
      if tcaProteinaAVBPorRefeicao in ListaCalcAli then
         begin
            if quProtAVBRef.Active then
               begin
                  quProtAVBRef.Close;
               end;
               quProtAVBRef.SQL.Clear;
               quProtAVBRef.SQL.Add( SQLProtAVBRef( Periodo ));
               quProtAVBRef.Open;
         end
      else
         quProtAVBRef.Close;
      if tcaProteinaAVBPorCalculo in ListaCalcAli then
         begin
            if quProtAVBCalc.Active then
               begin
                  quProtAVBCalc.Close;
               end;
               quProtAVBCalc.SQL.Clear;
               quProtAVBCalc.SQL.Add( SQLProtAVBCalc( Periodo ) );
               quProtAVBCalc.Open;
         end
      else
         quProtAVBCalc.Close;
      if tcaRelacaoCaPPorRefeicao in ListaCalcAli then
         begin
            if quRelacaoCaPRef.Active then
               begin
                  quRelacaoCaPRef.Close;
               end;
               quRelacaoCaPRef.SQL.Clear;
               quRelacaoCaPRef.SQL.Add( SQLRelacaoCaPRef( Periodo ) );
               quRelacaoCaPRef.Open;
         end
      else
         quRelacaoCaPRef.Close;
      if tcaRelacaoCaPPorCalculo in ListaCalcAli then
         begin
            if quRelacaoCaPCalc.Active then
               begin
                  quRelacaoCaPCalc.Close;
               end;
               quRelacaoCaPCalc.SQL.Clear;
               quRelacaoCaPCalc.SQL.Add( SQLRelacaoCaPCalc( Periodo ) );
               quRelacaoCaPCalc.Open;
         end
      else
         quRelacaoCaPCalc.Close;
      if tcaRelacaoAcidosGraxosPorRef in ListaCalcAli then
         begin
            if quRelacaoAgSatPolMonRef.Active then
               begin
                  quRelacaoAgSatPolMonRef.Close;
               end;
               quRelacaoAgSatPolMonRef.SQL.Clear;
               quRelacaoAgSatPolMonRef.SQL.Add( SQLRelacaoAgSatPolMonRef( Periodo ) );
               quRelacaoAgSatPolMonRef.Open;
         end
      else
         quRelacaoAgSatPolMonRef.Close;
      if tcaRelacaoAcidosGraxosPorCalc in ListaCalcAli then
         begin
            if quRelacaoAgSatPolMonCalc.Active then
               begin
                  quRelacaoAgSatPolMonCalc.Close;
               end;
               quRelacaoAgSatPolMonCalc.SQL.Clear;
               quRelacaoAgSatPolMonCalc.SQL.Add( SQLRelacaoAgSatPolMonCalc( Periodo ) );
               quRelacaoAgSatPolMonCalc.Open;
         end
      else
         quRelacaoAgSatPolMonCalc.Close;
      if tcaRelacaoCaloriaNitrogenioPorRef in ListaCalcAli then
         begin
            if quRelacaoCalNRef.Active then
               begin
                  quRelacaoCalNRef.Close;
               end;
               quRelacaoCalNRef.SQL.Clear;
               quRelacaoCalNRef.SQL.Add( SQLRelacaoCalNRef( Periodo ) );
               quRelacaoCalNRef.Open;
         end
      else
         quRelacaoCalNRef.Close;
      if tcaRelacaoCaloriaNitrogenioPorCalc in ListaCalcAli then
         begin
            if quRelacaoCalNCalc.Active then
               begin
                  quRelacaoCalNCalc.Close;
               end;
               quRelacaoCalNCalc.SQL.Clear;
               quRelacaoCalNCalc.SQL.Add( SQLRelacaoCalNCalc( Periodo ) );
               quRelacaoCalNCalc.Open;
         end
      else
         quRelacaoCalNCalc.Close;
      if tcaPorcentagemEnergiaCalculada in ListaCalcAli then
         begin
            if quPorcentagemEnergia.Active then
               begin
                  quPorcentagemEnergia.Close;
               end;
               quPorcentagemEnergia.SQL.Clear;
               quPorcentagemEnergia.SQL.Add( SQLPorcentagemEnergia( Periodo ) );
               quPorcentagemEnergia.Open;
         end
      else
         quPorcentagemEnergia.Close;
      if tcaGrupoAlimentarPorNutriente in ListaCalcAli then
         begin
            if taTotGru_Gru.Active then
               taTotGru_Gru.Refresh
            else
               begin
                  taTotGru_ItensAli.Open;
                  taTotGru_AliNut.Open;
                  taTotGru_Nut.Open;
                  taTotGru_Gru.Open;
               end;
         end
      else
         begin
            taTotGru_Gru.Close;
         end;
      if tcaAlimentoPorNutriente in ListaCalcAli then
         begin
            if taTotAli_Ali.Active then
               taTotAli_Ali.Refresh
            else
               begin
                  taTotAli_AliNut.Open;
                  taTotAli_Nut.Open;
                  taTotAli_Ali.Open;
               end;
         end
      else
         begin
            taTotAli_Ali.Close;
         end;
      if tcaNutrientesPorPesoDia in ListaCalcAli then
         begin
            taTotalNutPesoDia.Filtered := not FShowAllNut;
            if taTotalNutPesoDia.Active then
               taTotalNutPesoDia.Refresh
            else
               taTotalNutPesoDia.Open;
         end
      else
         taTotalNutPesoDia.Close;
 // Finaliza indicador de operação demorada
 finally
      if Assigned( FDelayedOpIndicator ) then
         FDelayedOpIndicator.Finish;
 end;
end;
end;

{ TAtivaCalculoDieta }

{ TAtivaCustomCalculoAlimentar }

procedure TAtivaCustomCalculoAlimentar.SetOnCalcular(const Value: TNotifyEvent);
begin
   FOnCalcular := Value;
end;

procedure TAtivaCustomCalculoAlimentar.SetPorcentagemNutrientesValidos(const Value: Boolean);
begin
   if FPorcentagemNutrientesValidos <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaPorcentagemNutrientesValidos]
         else
            FListaCalculos := FListaCalculos - [tcaPorcentagemNutrientesValidos];
      end;
   FPorcentagemNutrientesValidos := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCustomCalculoAlimentar.SetTotalMacroNutrientes(const Value: Boolean);
begin
   if FTotalMacroNutrientes <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaTotalMacroNutrientes]
         else
            FListaCalculos := FListaCalculos - [tcaTotalMacroNutrientes];
      end;
   FTotalMacroNutrientes := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCustomCalculoAlimentar.SetTotalNutrientes(const Value: Boolean);
begin
   if FTotalNutrientes <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaTotalNutrientes]
         else
            FListaCalculos := FListaCalculos - [tcaTotalNutrientes];
      end;
   FTotalNutrientes := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

{ TAtivaCalculoAlimentar }

procedure TAtivaCalculoAlimentar.SetAlimentoPorNutriente(
  const Value: Boolean);
begin
  if FAlimentoPorNutriente <> Value then
     begin
        if Value then
           FListaCalculos := FListaCalculos + [tcaAlimentoPorNutriente]
        else
           FListaCalculos := FListaCalculos - [tcaAlimentoPorNutriente];
     end;
  FAlimentoPorNutriente := Value;
  if Assigned( FOnCalcular ) then
     FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetGrupoAlimentarPorNutriente(const Value: Boolean);
begin
   if FGrupoAlimentarPorNutriente <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaGrupoAlimentarPorNutriente]
         else
            FListaCalculos := FListaCalculos - [tcaGrupoAlimentarPorNutriente];
      end;
   FGrupoAlimentarPorNutriente := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetNutrientesPorPesoDia(const Value: Boolean);
begin
   if FNutrientesPorPesoDia <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaNutrientesPorPesoDia]
         else
            FListaCalculos := FListaCalculos - [tcaNutrientesPorPesoDia];
      end;
   FNutrientesPorPesoDia := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetPorcentagemEnergiaCalculada(const Value: Boolean);
begin
   if FPorcentagemEnergiaCalculada <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaPorcentagemEnergiaCalculada]
         else
            FListaCalculos := FListaCalculos - [tcaPorcentagemEnergiaCalculada];
      end;
   FPorcentagemEnergiaCalculada := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetProteinaAVBPorCalculo(const Value: Boolean);
begin
   if FProteinaAVBPorCalculo <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaProteinaAVBPorCalculo]
         else
            FListaCalculos := FListaCalculos - [tcaProteinaAVBPorCalculo];
      end;
   FProteinaAVBPorCalculo := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetProteinaAVBPorRefeicao(const Value: Boolean);
begin
   if FProteinaAVBPorRefeicao <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaProteinaAVBPorRefeicao]
         else
            FListaCalculos := FListaCalculos - [tcaProteinaAVBPorRefeicao];
      end;
   FProteinaAVBPorRefeicao := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetRelacaoAcidosGraxosPorCalc(const Value: Boolean);
begin
   if FRelacaoAcidosGraxosPorCalc <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaRelacaoAcidosGraxosPorCalc]
         else
            FListaCalculos := FListaCalculos - [tcaRelacaoAcidosGraxosPorCalc];
      end;
   FRelacaoAcidosGraxosPorCalc := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetRelacaoAcidosGraxosPorRef(const Value: Boolean);
begin
   if FRelacaoAcidosGraxosPorRef <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaRelacaoAcidosGraxosPorRef]
         else
            FListaCalculos := FListaCalculos - [tcaRelacaoAcidosGraxosPorRef];
      end;
   FRelacaoAcidosGraxosPorRef := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetRelacaoCaloriaNitrogenioPorCalc(const Value: Boolean);
begin
   if FRelacaoCaloriaNitrogenioPorCalc <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaRelacaoCaloriaNitrogenioPorCalc]
         else
            FListaCalculos := FListaCalculos - [tcaRelacaoCaloriaNitrogenioPorCalc];
      end;
   FRelacaoCaloriaNitrogenioPorCalc := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetRelacaoCaloriaNitrogenioPorRef(const Value: Boolean);
begin
   if FRelacaoCaloriaNitrogenioPorRef <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaRelacaoCaloriaNitrogenioPorRef]
         else
            FListaCalculos := FListaCalculos - [tcaRelacaoCaloriaNitrogenioPorRef];
      end;
   FRelacaoCaloriaNitrogenioPorRef := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetRelacaoCaPPorCalculo(const Value: Boolean);
begin
   if FRelacaoCaPPorCalculo <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaRelacaoCaPPorCalculo]
         else
            FListaCalculos := FListaCalculos - [tcaRelacaoCaPPorCalculo];
      end;
   FRelacaoCaPPorCalculo := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetRelacaoCaPPorRefeicao(const Value: Boolean);
begin
   if FRelacaoCaPPorRefeicao <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaRelacaoCaPPorRefeicao]
         else
            FListaCalculos := FListaCalculos - [tcaRelacaoCaPPorRefeicao];
      end;
   FRelacaoCaPPorRefeicao := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TAtivaCalculoAlimentar.SetSaldoNutrientes(const Value: Boolean);
begin
   if FSaldoNutrientes <> Value then
      begin
         if Value then
            FListaCalculos := FListaCalculos + [tcaSaldoNutrientes]
         else
            FListaCalculos := FListaCalculos - [tcaSaldoNutrientes];
      end;
   FSaldoNutrientes := Value;
   if Assigned( FOnCalcular ) then
      FOnCalcular( self );
end;

procedure TCustomCalculoAlimentar.SetAtivar(const Value: TAtivaCustomCalculoAlimentar);
begin
   FAtivar := Value;
end;

function TCustomCalculoAlimentar.CriaAtivarCalculoAlimentar: TAtivaCustomCalculoAlimentar;
begin
   Result := TAtivaCustomCalculoAlimentar.Create;
end;

procedure TCustomCalculoAlimentar.DoCalcular(Sender: TObject);
begin
   Calcular;
end;

procedure TCalcAli.SetShowAllNut(const Value: Boolean);
begin
   FShowAllNut := Value;
end;

procedure TCustomCalculoAlimentar.SetMostraTodosNutrientes(const Value: Boolean);
begin
   FDMCalcAli.ShowAllNut := Value;
end;

function TCustomCalculoAlimentar.GetMostraTodosNutrientes: Boolean;
begin
   Result := FDMCalcAli.ShowAllNut;
end;

procedure TCalcAli.taTotAli_AliBeforeOpen(DataSet: TDataSet);
begin
   CriaNutToFields(taTotAli_Nut, DataSet, ListaNutAli);
end;

procedure TCalcAli.taTotAli_AliCalcFields(DataSet: TDataSet);
var
   I : Integer;
   Soma : Double;
begin
   // Quando eu abro taTotAli_Ali estes ainda não foram
   // abertos
   if not ( taTotAli_Nut.Active ) or
      not( taTotAli_Ali.Active ) or
      not ( taTotAli_AliNut.Active ) then
      exit;
   // Faz o total de um nutriente de um grupo alimentar
   For I := 0 to ListaNutAli.Count - 1 do
       if taTotAli_Nut.Locate( 'IDNUT', ListaNutAli.Strings[I], [] ) then
          if TotalNutPorAlimento( ListaNutAli.Strings[I], Soma ) then
             DataSet.FieldByName( 'NUT' + IntToStr(I) ).AsString := FormatFloat( '##0.00', Soma )
          else
             DataSet.FieldByName( 'NUT' + IntToStr(I) ).AsString := '';
end;

function TCalcAli.TotalNutPorAlimento(const IDNUT: String; var Total: Double): Boolean;
begin
   Result := False;
   Total := 0;
   if taTotAli_AliNut.Locate( 'IDALI;IDNUT', VarArrayOf( [taTotAli_Ali.FieldByName( 'ID_ALI' ).AsString, IDNUT ]), [] ) then
      begin
         Total := Total + ( (taTotAli_AliNut.FieldByName( 'VALOR' ).AsFloat*
                            (taTotAli_Ali.FieldByName( 'PESO' ).AsFloat/Periodo)/100)*
                            taTotAli_Ali.FieldByName( 'FREQDIA' ).AsFloat );
         Result := True;
      end;
end;

procedure TCalculoAlimentar.SetAlimentoPorNutriente(const Value: TDataSource);
begin
   FAlimentoPorNutriente := Value;
   if Assigned (Value) then
   begin
      Value.DataSet := FDMCalcAli.taTotAli_Ali;
      Value.FreeNotification(self);
   end;
end;

procedure TCustomCalculoAlimentar.SetAlimentoCorrente(const Value: TAlimento);
begin
   FAlimentoCorrente := Value;
   FDMCalcAli.AlimentoCorrente := Value;
   if Assigned( Value ) Then
      Value.FreeNotification(self);
end;

procedure TCalcAli.SetAlimentoCorrente(const Value: TAlimento);
begin
   FAlimentoCorrente := Value;
   if Assigned( Value ) then
   begin
      Value.FreeNotification(self);
      taItensAli.Refresh;
   end;
end;

procedure TCalcAli.dsItensAliDataChange(Sender: TObject; Field: TField);
begin
   if Assigned( FAlimentoCorrente ) and (Field = nil) then
   begin
      FAlimentoCorrente.Peso := taItensAli.FieldByName( 'PESO' ).AsFloat;
      FAlimentoCorrente.IDAlimento := taItensAli.FieldByName( 'ID_ALI' ).AsString;
   end;
end;

procedure TCalculoPreparacao.Adicionar;
begin
   if FIDSelf <> FListaAlimento.AlimentoCorrente.IDAlimento then
      begin
         inherited Adicionar;
      end
   else if Assigned( FOnErroAdicionarSelf ) then
      FOnErroAdicionarSelf( Self );
end;

procedure TCalculoPreparacao.Alterar;
begin
   inherited Alterar;
end;

procedure TCalculoPreparacao.Retirar;
begin
   inherited Retirar;
end;

procedure TCalculoPreparacao.SetIDSelf(const Value: String);
begin
   FIDSelf := Value;
end;

procedure TCalculoPreparacao.SetOnErroAdicionarSelf(const Value: TNotifyEvent);
begin
   FOnErroAdicionarSelf := Value;
end;

procedure TCalcAli.SetPesoIngredientes;
begin
   with quPesoTotalItensAli do
      begin
         Open;
         mdPesoIngredientes.AsFloat := FieldByName( 'PESO_TOTAL_ITENSALI' ).AsFloat;
         mdPesoIngredientes.Valid := True;
         Close;
         if Assigned( FPesoFinal ) then
            mdSaldoPeso.AsFloat := mdPesoIngredientes.AsFloat - FPesoFinal.AsFloat;
      end;
end;

function TCalculoPreparacao.SaldoPesoValido( var Texto : String ) : Boolean;
var
   OldShowAll : Boolean;
   OldAtivarTotalNut : Boolean;
begin
   // Faz um refresh dos Totais de Nutrientes por causa da água
   OldShowAll := MostraTodosNutrientes;
   OldAtivarTotalNut := Ativar.TotalNutrientes;
   try
      MostraTodosNutrientes := True;
      Ativar.TotalNutrientes := True;
      // Tenho que atualizar o saldo
      if TotalNutrientes.DataSet.Locate( 'IDNUT', IDAGUA, [] ) then
         TotalNutrientes.DataSet.Refresh;
   finally
      Ativar.TotalNutrientes := OldAtivarTotalNut;
      MostraTodosNutrientes := OldShowAll;
   end;
   Result := True;
   if ( FSaldoPeso.AsFloat < 0 ) then
      begin
         Texto := 'ATENÇÃO: o Peso Final desta preparação é MAIOR do que o ' +
                  'Peso dos Ingredientes da mesma. Não existe modo de preparo ' +
                  'que possa aumentar o Peso Final de uma preparação! ' +
                  'Corrija alterando os ingredientes ou alterando o Peso ' +
                  'Final para poder prosseguir.';
         Result := False;
      end
   else if ( not FSaldoPeso.Valid ) then
      begin
         Texto := 'ATENÇÃO: o Saldo de Peso é MAIOR do que a quantidade total do ' +
                  'nutriente "água" que pode ter evaporado! ' +
                  'Corrija alterando os ingredientes, alterando o Peso ' +
                  'Final ou verificando se todos os ingredientes possuem o valor do nutriente "água" ' +
                  'para poder prosseguir.';
         Result := False;
      end
   else if FSaldoPeso.AsFloat > 0 then
      begin
         Texto := 'Esta preparação deve se tratar de uma mistura ' +
                  'de ingredientes que sofreu AQUECIMENTO, pois o Peso ' +
                  'Final informado é MENOR que a soma dos pesos dos ingredientes. ' +
                  'Caso não seja verdadeira a afirmação acima, verifique ' +
                  'se o Peso Final e a quantidade dos ingredientes estão corretos ' +
                  'antes de prosseguir.' +
                  #13+#10+#13+#10+
                  'Quantidade de Água Evaporada = ' +
                   FormatFloat( '####0.00', ( FTotalAgua.AsFloat -  FAguaRestante.AsFloat ) ) +
                  ' g';
      end
   else if FSaldoPeso.AsFloat = 0 then
      begin
         Texto := 'Esta preparação deve se tratar de uma mistura ' +
                  'de ingredientes que NÃO SOFREU AQUECIMENTO, pois o Peso ' +
                  'Final informado é IGUAL a soma dos pesos dos ingredientes. ' +
                  'Caso não seja verdadeira a afirmação acima, verifique ' +
                  'se o Peso Final e a quantidade dos ingredientes estão corretos ' +
                  'antes de prosseguir.';
      end;
end;

procedure TCustomCalculoAlimentar.SetDelayedOpIndicator(const Value: TDelayedOpIndicator);
begin
   FDelayedOpIndicator := Value;
   if Assigned( FDMCalcAli ) then
      FDMCalcAli.DelayedOpIndicator := Value;
   if Value <> nil then
      Value.FreeNotification(Self);
end;

procedure TCalcAli.SetDelayedOpIndicator(const Value: TDelayedOpIndicator);
begin
   FDelayedOpIndicator := Value;
   if Value <> nil then
      Value.FreeNotification(Self);
end;

procedure TCalcAli.SetcxRecNut(const Value: TCaixa);
begin
   FcxRecNut := Value;
   if Value <> nil then
      Value.FreeNotification(Self);
end;

procedure TCalcAli.SetPeriodo(const Value: Integer);
begin
   FPeriodo := Value;
end;

procedure TCustomCalculoAlimentar.SetDescricaoCalculo(const Value: TMedidaOrdinal);
begin
   FDescricaoCalculo := Value;
   if Value <> nil then
      Value.FreeNotification(Self);
end;

procedure TCustomCalculoAlimentar.SetIDMedCasAlimento(const Value: String);
begin
   FIDMedCasAlimento := Value;
end;

procedure TCustomCalculoAlimentar.SetQtdeAlimento(const Value: Double);
begin
   FQtdeAlimento := Value;
end;

procedure TCustomCalculoAlimentar.SetListaAlimento(const Value: TCustomListaAlimento);
begin
   FListaAlimento := Value;
   if Value <> nil then
      Value.FreeNotification(Self);
end;

procedure TCustomCalculoAlimentar.SetMemoria(const Value: TMemoria);
begin
   FMemoria := Value;
   if Value <> nil then
      Value.FreeNotification(Self);
end;

procedure TCustomCalculoAlimentar.SetNomeCalculo(const Value: String);
begin
   FNomeCalculo := Value;
end;

procedure TCustomCalculoAlimentar.SetOnAntesDeAdicionar(const Value: TNotifyAntesDeAdicionar);
begin
   FOnAntesDeAdicionar := Value;
end;

procedure TCustomCalculoAlimentar.SetOnAntesDeAlterar(const Value: TNotifyAntesDeAlterar);
begin
   FOnAntesDeAlterar := Value;
end;

procedure TCustomCalculoAlimentar.SetOnDepoisDeSalvar(const Value: TNotifyevent);
begin
   FOnDepoisDeSalvar := Value;
end;

procedure TCustomCalculoAlimentar.SetOnPegaCalcDesc(const Value: TNotifyPegaCalcDesc);
begin
   FOnPegaCalcDesc := Value;
end;

procedure TCalculoAlimentar.SetOnPegaRecCalorica(const Value: TNotifyPegaRecCalorica);
begin
   FOnPegaRecCalorica := Value;
end;

procedure TCalculoAlimentar.SetOnPegaRefeicoes(const Value: TNotifyPegaRefeicoes);
begin
   FOnPegaRefeicoes := Value;
end;

procedure TCalculoInquerito.SetDiasDeConsumo(const Value: TMedida);
begin
   FDiasDeConsumo := Value;
   if Value <> nil then
      begin
         FDMCalcAli.Periodo := StrToInt( FDiasDeConsumo.ValorNumerico );
         Value.FreeNotification(Self);
      end;
end;

procedure TCalculoInqueritoFrequencia.SetFrequenciaDia(const Value: TCustomEdit);
begin
   FFrequenciaDia := Value;
   if Value <> nil then
      Value.FreeNotification(Self);
end;

procedure TCalculoInqueritoFrequencia.SetOnPegaDiasDeConsumo(const Value: TNotifyPegaDiasDeConsumo);
begin
   FOnPegaDiasDeConsumo := Value;
end;

procedure TCalculoPreparacao.SetPesoFinal(const Value: TMedida);
begin
   FPesoFinal := Value;
   if Value <> nil then
      Value.FreeNotification(Self);
end;

procedure TCalculoPreparacao.SetOnPegaPesoFinal(const Value: TNotifyPegaPesoFinal);
begin
   FOnPegaPesoFinal := Value;
end;

procedure TCalculoAlimentar.SetModelosRefeicoes(const Value: TDataSource);
begin
   FModelosRefeicoes := Value;
   if Assigned (Value) then
   begin
      Value.DataSet := FDMCalcAli.taModRefeicao;
      Value.FreeNotification(self);
   end;
end;

function TCalculoAlimentar.CountItensRefeicao(const IDRefeicao: String): Integer;
var
   I : Integer;
begin
   // "conta" quantos itens alimentares existem numa determinada refeicao
   Result := 0;
   for I := 0 to FEntradaRefeicao.Count - 1 do
       if TGUIDItem( FEntradaRefeicao.Objects[I] ).Guid = IDRefeicao then
       begin
          Result := TGUIDItem( FEntradaRefeicao.Objects[I] ).Tag;
          exit;
       end;
end;

procedure TCalculoAlimentar.DecItensRefeicao(const IDRefeicao: String; N: Integer);
var
   I : Integer;
begin
   // Decrementa o Tag da refeição especificada
   for I := 0 to FEntradaRefeicao.Count - 1 do
       if TGUIDItem( FEntradaRefeicao.Objects[I] ).Guid = IDRefeicao then
       begin
          TGUIDItem( FEntradaRefeicao.Objects[I] ).Tag := TGUIDItem( FEntradaRefeicao.Objects[I] ).Tag - N;
          exit;
       end;
end;

procedure TCalculoAlimentar.IncItensRefeicao(const IDRefeicao: String; N: Integer);
var
   I : integer;
begin
   // Decrementa o Tag da refeição especificada
   for I := 0 to FEntradaRefeicao.Count - 1 do
       if TGUIDItem( FEntradaRefeicao.Objects[I] ).Guid = IDRefeicao then
       begin
          TGUIDItem( FEntradaRefeicao.Objects[I] ).Tag := TGUIDItem( FEntradaRefeicao.Objects[I] ).Tag + N;
          exit;
       end;
end;

procedure TCalcAli.SetOnBeforeDeleteItem(const Value: TNotifyItemRefeicao);
begin
   FOnBeforeDeleteItem := Value;
end;

procedure TCalcAli.SetOnBeforeAppendItem(const Value: TNotifyItemRefeicao);
begin
   FOnBeforeAppendItem := Value;
end;

procedure TCalculoAlimentar.BeforeAppendItem(Sender: TObject; const IDRefeicao : String);
begin
   IncItensRefeicao(IDRefeicao);
end;

procedure TCalculoAlimentar.BeforeDeleteItem(Sender: TObject; const IDRefeicao : String);
begin
   DecItensRefeicao(IDRefeicao);
end;

function TCalculoAlimentar.RefeicaoIsEmpty: String;
var
   I : Integer;
begin
   // Retorna a primeira refeição que está vazia
   Result := '';
   for I := 0 to FEntradaRefeicao.Count - 1 do
       if CountItensRefeicao( TGUIDItem( FEntradaRefeicao.Objects[I] ).Guid ) = 0 then
       begin
          Result := FEntradaRefeicao.Strings[I];
          exit;
       end;
end;

procedure TCalculoAlimentar.EmptyCounterItensRefeicao;
var
   I : Integer;
begin
   // limpa os contadores de itens das refeições
   for I := 0 to FEntradaRefeicao.Count - 1 do
       TGUIDItem( FEntradaRefeicao.Objects[I] ).Tag := 0;
end;

// Ativar quando teste
procedure TCalculoAlimentar.MsgRefeicoes;
begin
end;
{var
   I : Integer;
   S : String;
begin
  for I := 0 to FEntradaRefeicao.Count - 1 do
      S := S + FEntradaRefeicao.Strings[I] + ' (' +
               IntToStr(TGUIDItem( FEntradaRefeicao.Objects[I] ).Tag) + ')'+#13#10;
   ShowMessage( S );
end;}

procedure TCustomCalculoAlimentar.OrdenaAliNutPorNutriente(AField: TField; const Ordem : TTipoOrdem );
var
  Fator : Integer;
  Valor : Double;
begin

 with FDMCalcAli do
 begin
   // Quando eu abro taTotAli_Ali estes ainda não foram
   // abertos
   if not ( taTotAli_Nut.Active ) or
      not( taTotAli_Ali.Active ) or
      not ( taTotAli_AliNut.Active ){ or
      not Assigned( FNutTemp )} then
      exit;

   // Cada vez que adiciona/retira/edita um alimento, e este calculo estiver ativo, rodar esta rotina
   // com os parametros adequados
   with taTotAli_Ali do
   begin

      // Guardar a última configuração de ordenação
      FMyField := AField;
      FOrdem := Ordem;

      // Volta a ordem normal
      if ( AField = nil ) or ( Ordem = toNenhuma ) then
      begin
         IndexFieldNames := 'ID_CALCALI;ID_REFEICAO;ID_ALI;ID_MEDIDA';
         exit;
      end;

      // Ordena por um determinado nutriente
      DisableControls;
      Try
         IndexFieldNames := 'ID_CALCALI;ID_REFEICAO;ID_ALI;ID_MEDIDA';
         First;
         While not Eof do
         begin
            // Estou multiplicando por -1 para similar a ordenação
            // decrescente, que o master/detail não deixa (só se
            // criar um índice descending, que não está funcionando no Interbase).
            // Portanto, o campo NUT_TEMP não contém valores válidos.
            if Ordem = toDecrescente then
               Fator := 1
            else if Ordem = toCrescente then
               Fator := -1
            else
               Fator := 0;
            // Para converter o valor nulo
            if AField.AsString = '' then
               Valor := 0
            else
               Valor := AField.AsFloat;
            if FieldByName( 'NUT_TEMP' ).AsFloat <> ( Valor * Fator ) then
            begin
               Edit;
               FieldByName( 'NUT_TEMP' ).AsFloat := Valor * Fator;
               Post;
            end;
            Next;
         end;
         IndexFieldNames := 'ID_CALCALI;ID_REFEICAO;NUT_TEMP';
      finally
         EnableControls;
      end;
   end;
 end;

 // Evento pra atualizar o utilizador deste método
 if Assigned(FOnDepoisDeOrdenaAliNutPorNutriente) then
    begin
       FOnDepoisDeOrdenaAliNutPorNutriente(Self);
    end;

end;

procedure TCustomCalculoAlimentar.SetOnDepoisDeOrdenaAliNutPorNutriente(
  const Value: TNotifyEvent);
begin
  FOnDepoisDeOrdenaAliNutPorNutriente := Value;
end;

function TCalcAli.ProximoItem: Integer;
begin
   FItem := FItem + 1;
   Result := FItem;
end;

procedure TCalcAli.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FcxRecNut then
        FcxRecNut := nil
end;

procedure TCalcAli.quProtAVBRefCalcFields(DataSet: TDataSet);
begin
   if (DataSet.FieldByName( 'TOT_PROT' ).AsFloat > 0 ) then
      DataSet.FieldByName( 'PERC_PROTAVB' ).AsFloat := (DataSet.FieldByName( 'TOT_PROTAVB' ).AsFloat / DataSet.FieldByName( 'TOT_PROT' ).AsFloat)*100
   else
      DataSet.FieldByName( 'PERC_PROTAVB' ).AsFloat := 0;
end;

procedure TCalcAli.quProtAVBCalcCalcFields(DataSet: TDataSet);
begin
   if (DataSet.FieldByName( 'TOT_PROT' ).AsFloat > 0 ) then
      DataSet.FieldByName( 'PERC_PROTAVB' ).AsFloat := (DataSet.FieldByName( 'TOT_PROTAVB' ).AsFloat / DataSet.FieldByName( 'TOT_PROT' ).AsFloat)*100
   else
      DataSet.FieldByName( 'PERC_PROTAVB' ).AsFloat := 0;
end;

procedure TCalcAli.quRelacaoCaPCalcCalcFields(DataSet: TDataSet);
begin
   if (DataSet.FieldByName( 'TOT_FOSFORO' ).AsFloat > 0 ) then
      DataSet.FieldByName( 'RELCALC_CA_P' ).AsFloat := (DataSet.FieldByName( 'TOT_CALCIO' ).AsFloat / DataSet.FieldByName( 'TOT_FOSFORO' ).AsFloat)
   else
      DataSet.FieldByName( 'RELCALC_CA_P' ).AsFloat := 0;
end;

procedure TCalcAli.quRelacaoCaPRefCalcFields(DataSet: TDataSet);
begin
   if (DataSet.FieldByName( 'TOT_FOSFORO' ).AsFloat > 0 ) then
      DataSet.FieldByName( 'RELREF_CA_P' ).AsFloat := (DataSet.FieldByName( 'TOT_CALCIO' ).AsFloat / DataSet.FieldByName( 'TOT_FOSFORO' ).AsFloat)
   else
      DataSet.FieldByName( 'RELREF_CA_P' ).AsFloat := 0;
end;

procedure TCalcAli.quRelacaoAgSatPolMonCalcCalcFields(DataSet: TDataSet);
var
   TotAcGrax : Double;
begin
   TotAcGrax := DataSet.FieldByName( 'TOT_AGSAT' ).AsFloat + DataSet.FieldByName( 'TOT_AGPOL' ).AsFloat + DataSet.FieldByName( 'TOT_AGMON' ).AsFloat;
   if ( TotAcGrax > 0 ) then
   begin
      DataSet.FieldByName( 'RELCALC_AGSAT' ).AsFloat := (3 * DataSet.FieldByName( 'TOT_AGSAT' ).AsFloat / TotAcGrax);
      DataSet.FieldByName( 'RELCALC_AGPOL' ).AsFloat := (3 * DataSet.FieldByName( 'TOT_AGPOL' ).AsFloat / TotAcGrax);
      DataSet.FieldByName( 'RELCALC_AGMON' ).AsFloat := (3 * DataSet.FieldByName( 'TOT_AGMON' ).AsFloat / TotAcGrax);
   end
   else
   begin
      DataSet.FieldByName( 'RELCALC_AGSAT' ).AsFloat := 0;
      DataSet.FieldByName( 'RELCALC_AGPOL' ).AsFloat := 0;
      DataSet.FieldByName( 'RELCALC_AGMON' ).AsFloat := 0;
   end;
end;

procedure TCalcAli.quRelacaoAgSatPolMonRefCalcFields(DataSet: TDataSet);
var
   TotAcGrax : Double;
begin
   TotAcGrax := DataSet.FieldByName( 'TOT_AGSAT' ).AsFloat + DataSet.FieldByName( 'TOT_AGPOL' ).AsFloat + DataSet.FieldByName( 'TOT_AGMON' ).AsFloat;
   if ( TotAcGrax > 0 ) then
   begin
      DataSet.FieldByName( 'RELREF_AGSAT' ).AsFloat := (3 * DataSet.FieldByName( 'TOT_AGSAT' ).AsFloat / TotAcGrax);
      DataSet.FieldByName( 'RELREF_AGPOL' ).AsFloat := (3 * DataSet.FieldByName( 'TOT_AGPOL' ).AsFloat / TotAcGrax);
      DataSet.FieldByName( 'RELREF_AGMON' ).AsFloat := (3 * DataSet.FieldByName( 'TOT_AGMON' ).AsFloat / TotAcGrax);
   end
   else
   begin
      DataSet.FieldByName( 'RELREF_AGSAT' ).AsFloat := 0;
      DataSet.FieldByName( 'RELREF_AGPOL' ).AsFloat := 0;
      DataSet.FieldByName( 'RELREF_AGMON' ).AsFloat := 0;
   end;
end;

end.


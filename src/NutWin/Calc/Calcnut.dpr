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

program calcnut;

uses
    Forms,
    Dialogs,
    SysUtils,
    Windows,
//  WebConst in '..\webconst.pas',
    CalcNutr in 'CalcNutr.pas' {fmCalcNutr},
    Antrop01 in 'Antrop01.pas' {fmAntrop02},
    RecCal01 in 'RecCal01.pas' {fmRecCal01},
    Inquer01 in 'Inquer01.pas' {fmInquer01},
    DMMBoard in 'DMMBoard.pas' {dmMotherBoard: TDataModule},
    NutWiz in 'NutWiz.pas' {fmNutWiz},
    Antrop02 in 'Antrop02.pas' {fmAntrop01},
    NutCalcAli in 'NutCalcAli.pas' {fmNutCalcAli},
    Dieta01 in 'Dieta01.pas' {fmDieta01},
    Prepar01 in 'Prepar01.pas' {fmPrepar01},
    NutAli in 'NutAli.pas' {fmNutrientes},
    RefAli in 'RefAli.pas' {fmRefeicao},
    RlAntr01 in 'RlAntr01.pas' {fmRelAntrop01},
    RlRecRDA in 'RlRecRDA.pas' {fmRelRecRDA},
    RlAFis01 in 'RlAFis01.pas' {fmRelAtivFis01},
    RlEsp01 in 'RlEsp01.pas' {fmRelEspeciais01},
    RlPrep01 in 'RlPrep01.pas' {fmRelPrep01},
    SelNut in 'SelNut.pas' {fmSelNutriente},
    SelGruAli in 'SelGruAli.pas' {fmSelGruAli},
    SelAliOrg in 'SelAliOrg.pas' {fmAliOrigem},
    MedCas in 'MedCas.pas' {fmMedidas},
    RlListaAli in 'RlListaAli.pas' {fmRelListaAlimentos},
    RecCal02 in 'RecCal02.pas' {fmRecCal02},
    RecCal03 in 'RecCal03.pas' {fmRecCal03},
    RecCal04 in 'RecCal04.pas' {fmRecCal04},
    RecCal05 in 'RecCal05.pas' {fmRecCal05},
    DumpMem in 'DumpMem.pas' {Dump},
    fmRelViewer in '..\..\COMPDELPHI\CALCULO\fmRelViewer.pas' {RelViewer},
    RegConst2 in 'RegConst2.pas',
    RegEdit in 'RegEdit.pas',
    fmFormRelMedResult in 'fmFormRelMedResult.pas' {fmRepMedResult},
    fmCfgCalculos in 'fmCfgCalculos.pas' {fmConfigCalculos},
    RlItensAli in 'RlItensAli.pas' {fmRelItensAli},
    fmFormRelIndividuo in 'fmFormRelIndividuo.pas' {FormRepIndividuo},
    SelRecCal in 'SelRecCal.pas' {fmSelRecCal},
    fmFormRelCalcAli in 'fmFormRelCalcAli.pas' {fmRepCalcAli},
    SelRefCalcAli in 'SelRefCalcAli.pas' {fmSelRefCalcAli},
    RecCal06 in 'RecCal06.pas' {fmRecCal06},
    RecNut in 'RecNut.pas' {fmRecNut},
    RecCal07 in 'RecCal07.pas' {fmRecCal07},
    NutCnst in '..\..\COMPDELPHI\CALCULO\NutCnst.pas',
    AliWizPeso in 'AliWizPeso.pas' {fmAliWizPeso},
    AliWizLista in 'AliWizLista.pas' {fmAliWizLista},
    AliWizMedida in 'AliWizMedida.pas' {fmAliWizMedida},
    AliWiz in 'AliWiz.pas' {fmAliWiz},
    AliWizQtde in 'AliWizQtde.pas' {fmAliWizQtde},
    fmPrepPF in 'fmPrepPF.pas' {fmPrepPesoFinal},
    fmInquND in 'fmInquND.pas' {fmInqNumDias},
    fmInqNome in 'fmInqNome.pas' {fmInqueritoNome},
//    fmDistrEnergia in 'fmDistrEnergia.pas' {fmDistribuicaoEnergia},
    fmNutAcomp in 'fmNutAcomp.pas' {fmNutrientesAcomp},
    fmSelRelCalcAli in 'fmSelRelCalcAli.pas' {fmRelCalcAli},
    qrepform in '..\..\COMPDELPHI\CALCULO\QREPFORM.pas' {FormReport},
    RlPorcEnergia in 'RlPorcEnergia.pas' {fmRelPorcEnergia},
    RlIdentificacao in 'RlIdentificacao.pas' {fmRelIdentificacao},
    RlNutPesoDia in 'RlNutPesoDia.pas' {fmRelNutPesoDia},
    RlNutrientes in 'RlNutrientes.pas' {fmRelNutrientes},
    RlRecNut in 'RlRecNut.pas' {fmRelRecNut},
    RlValidaNut in 'RlValidaNut.pas' {fmRelValidaNut},
    RlRelacoesNut in 'RlRelacoesNut.pas' {fmRelRelacoesNut},
    RlMacroNut in 'RlMacroNut.pas' {fmRelProtAVB},
    RlAliNut in 'RlAliNut.pas' {fmRelAliNutr},
    RlGruAliNut in 'RlGruAliNut.pas' {fmRelGruAliNut},
    RlEquEnergia in 'RlEquEnergia.pas' {fmRelEquEnergia},
    RlEquProteina in 'RlEquProteina.pas' {fmRelEquProteina},
    RlItensAliEquEnergia in 'RlItensAliEquEnergia.pas' {fmRelItensAliEquEnergia},
    RlItensAliEquProteina in 'RlItensAliEquProteina.pas' {fmRelItensAliEquProteina},
    RlGrafRecNut in 'RlGrafRecNut.pas' {fmRelGrafRecNut},
    RlReceita in 'RlReceita.pas' {fmRelReceita},
    RlIngredientes in 'RlIngredientes.pas' {fmRelIngredientes},
    RlDieObs in 'RlDieObs.pas' {fmRelDieObservacoes},
    RlInqObs in 'RlInqObs.pas' {fmRelInqObservacoes},
    fmBarraProg in 'fmBarraProg.pas' {fmBarraDeProgresso},
    fmPrepVerifPF in 'fmPrepVerifPF.pas' {fmVerificaPesoFinal},
    fmHpAntrop in 'fmHpAntrop.pas' {fmHelpAntrop},
    InfoSistema in '..\..\CompDelphi\About\InfoSistema.pas' {fmInfoSistema},
    Sobre in '..\..\CompDelphi\About\Sobre.pas' {fmSobre},
    NovoPreview in '..\..\CompDelphi\Calculo\NovoPreview.pas' {fmNovoPreview},
    InqAtivFis in 'InqAtivFis.pas' {fmInqAtivFis},
    dmHelp in '..\..\CompDelphi\HlpNut\dmHelp.pas' {dmHlp: TDataModule},
    fmTempoAtivF in 'fmTempoAtivF.pas' {fmTempoAtivFis},
    UItensAliOrdem in 'UItensAliOrdem.pas' {fmItensAliOrdem},
    fmRelBranco in 'fmRelBranco.pas' {fmRelatBranco},
    RlIdentificacaoLandscape in 'RlIdentificacaoLandscape.pas' {fmRelIdentificacaoLandscape},
    RelConfig in '..\..\CompDelphi\Calculo\RelConfig.pas',
    uAliasName in '..\NutPrg\uAliasName.pas',

    DataGateway in '..\..\CompDelphi\ConnectionConfigurator\DataGateway.pas';

//  DMDBNut in '..\..\CompDelphi\AliNut\DMDBNut.pas' {dmDataBasesNut: TDataModule};

{$R *.RES}

var
    MainPath: string;
//  DMMaster : TdmDataBasesNut;

begin
    if True {not AppIsAlreadyRunning(ID_CALCULADORA)} then
        begin
            Application.Initialize;
            Application.HintPause := 250;
            Application.HintHidePause := 5000;
            Application.Title := 'Calculadora Nutricional';
            ShortDateFormat := 'dd/mm/yyyy';
            LongTimeFormat := 'hh:mm:ss';
            ShortTimeFormat := 'hh:mm';
            TimeSeparator := ':';
            DecimalSeparator := ',';
            ThousandSeparator := '.';
            DateSeparator := '/';

  // Se existe arquivo do Banco para conversão então faça-a
  // Seta Individuos como opção não liberada
            if not CarregaChaveString (CFGRoot, CFGPath, 'Path', MainPath) then
                begin
                    ShowMessage ('Erro de leitura da Chave: Path.' + #13#10 +
                        'O programa não pode ser iniciado.') ;
                    exit;
                end;

            if  not TDataGateway.testConfiguration then
                begin

                            MessageDlg ('Não foi possível se conectar ao banco de dados', mtError, [mbOk], 0) ;
                            exit;

                end;

            with TfmBarraDeProgresso.Create (nil) do
                try
                    pbProgresso.Max := 100;
                    Show;
                    Update;

     // Contém um database para todo o sistema
                    laOperacao.Caption := 'Conectando ao Banco de Dados...';
                    laOperacao.Update;
//     Application.CreateForm(TdmDataBasesNut, DMMaster);
//     DMMaster.dbOrg1.Connected := True;
//     DMMaster.RestauraActive := True; // vai manter aberto o que já está aberto
                    pbProgresso.StepBy (20) ;

                    laOperacao.Caption := 'Criando Tabelas Temporárias...';
                    laOperacao.Update;
//     Application.CreateForm(TdmCriaTabelasTemp, dmCriaTabelasTemp);
                    pbProgresso.StepBy (20) ;

                    laOperacao.Caption := 'Criando Componentes...';
                    laOperacao.Update;
                    Application.CreateForm (TdmHlp, dmHlp) ;
                    Application.CreateForm (TdmMotherBoard, dmMotherBoard) ;
                    pbProgresso.StepBy (20) ;

                    laOperacao.Caption := 'Criando Console...';
                    laOperacao.Update;
                    Application.CreateForm (TfmCalcNutr, fmCalcNutr) ;
                    pbProgresso.StepBy (20) ;

                    laOperacao.Caption := 'Criando Dump...';
                    laOperacao.Update;
//     Application.CreateForm(TDump, Dump);
                    pbProgresso.StepBy (20) ;
                finally
                    Free;
                end;
            Application.Run;
        end
    else
        ShowMessage ('A Calculadora já está aberta!') ;
end.


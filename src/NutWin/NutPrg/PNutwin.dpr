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




program PNutwin;

uses
  Forms,
  Dialogs,
  SysUtils,
  Graphics,
  controls,
  qrprntr,
  Pessoa in 'Pessoa.pas' {DMPessoa: TDataModule},
  NutMenu in 'NutMenu.pas' {fm_MenuNut},
  TabAli in 'TabAli.pas' {fmTabAli},
  Tabela in 'Tabela.pas' {fmTabPess},
  UPessoa in 'UPessoa.pas' {fmPessoa},
  Alimento in 'Alimento.pas' {fmAlim},
//  USelNut in 'USelNut.pas' {fmSelecNut},
  DMSubstCal in 'DMSubstCal.pas' {DMSubsCalorico: TDataModule},
  NutOpc in 'Nutopc.pas' {fm_Opcoes},
  DMAliPrep in 'DMAliPrep.pas' {DMAlimentos: TDataM0odule},
  DMMedidas in 'DMMedidas.pas' {DMedidas: TDataModule},
  DMNutrien in 'DMNutrien.pas' {DMNutrientes: TDataModule},
  DMRelat in 'Relatorios\DMRelat.pas' {DMRelatAli: TDataModule},
  DMRelMed in 'Relatorios\DMRelMed.pas' {DMRelMedidas: TDataModule},
  DMRElNut in 'Relatorios\DMRElNut.pas' {DMRelNutrientes: TDataModule},
  DMRelPess in 'Relatorios\DMRelPess.pas' {DMRelPessoa: TDataModule},
  DMRelPrAli in 'Relatorios\DMRelPrAli.pas' {DMRelPreco: TDataModule},
  DMRelSuCal in 'Relatorios\DMRelSuCal.pas' {DMRelSCAl: TDataModule},
  Nutrelat in 'Relatorios\Nutrelat.pas' {fmRelatorios},
  UAliFicha in 'Relatorios\UAliFicha.pas' {fmAliFicha},
  UAliOrdGAli in 'Relatorios\UAliOrdGAli.pas' {fmAliOrdGAli},
  UAliOrigem in 'Relatorios\UAliOrigem.pas' {fmRlAliOrigem},
  UAliSubsCal in 'Relatorios\UAliSubsCal.pas' {fmRelAliSubs},
  UPess in 'Relatorios\UPess.pas' {fmRelPess},
  URelAlim in 'Relatorios\URelAlim.pas' {fmRelAlimentar},
  URelAliMed in 'Relatorios\URelAliMed.pas' {fmRelAliMed},
  URelAliNut in 'Relatorios\URelAliNut.pas' {fmRelAliNut},
  URelTAli in 'Relatorios\URelTAli.pas' {fmRTAGAli},
  URTAGCal in 'Relatorios\URTAGCal.pas' {fmRTAGCal},
  UAliOrdAlf in 'Relatorios\UAliOrdAlf.pas' {fmAliOrdAlf},
  URTANut in 'URTANut.pas' {fmRTANut},
  URTAMCas in 'Relatorios\URTAMCas.pas' {fmRTAMCas},
  URTANac in 'Relatorios\URTANac.pas' {fmRTPNac},
  URTAOrigem in 'Relatorios\URTAOrigem.pas' {fmRTAOrigem},
  URTASCal in 'Relatorios\URTASCal.pas' {fmRTASCal},
  URTPCid in 'Relatorios\URTPCid.pas' {fmRTPCid},
  URTPCor in 'Relatorios\URTPCor.pas' {fmRTPCor},
  URTPEst in 'Relatorios\URTPEst.pas' {fmRTPEst},
  URTPInst in 'Relatorios\URTPInst.pas' {fmRTPInst},
  URTPPessoa in 'Relatorios\URTPPessoa.pas' {fmRTPProf},
  URTPUsuario in 'Relatorios\URTPUsuario.pas' {fmRTPUsuario},
  Unit1 in 'Relatorios\Unit1.pas' {fmRelAli},
  CadAnam in 'CadAnam.pas' {fmAnam},
  fmModAnam in 'fmModAnam.pas' {fmTipoAnam},
  UImpress in 'UImpress.pas' {fmImpressora},
  UCadPastas in 'UCadPastas.pas' {fmCadPastas},
  ULocPess in 'ULocPess.pas' {fmLocPess},
  ULocAlim in 'ULocAlim.pas' {fmLocAlim},
  OpcSalas in 'OpcSalas.pas' {fmOpcSalas},
  UListaNut in 'UListaNut.pas' {fmListNut},
  UTipoExame in 'UTipoExame.pas' {fmTipoExame},
  URelTipExa in 'URelTipExa.pas' {fmRelTipoExa},
  UfmRTipAnam in 'UfmRTipAnam.pas' {fmRelTipAnam},
  RelTot in 'RelTot.pas' {fmRelTotALI},
  RelTotPess in 'RelTotPess.pas' {fmRelTotPess},
  RelSCal in 'RelSCal.pas' {fmRelSCal},
  URListNut in 'URListNut.pas' {fmRelListNut},
  URelSProt in 'Relatorios\URelSProt.pas' {fmRelSProt},
  DMMBoard in '..\calc\DMMBoard.pas' {dmMotherBoard: TDataModule},
//  UDataNasc in 'UDataNasc.pas' {fmDataNasc},
  NutCnst in 'NutCnst.pas',
  RegConst2 in '..\..\CompDelphi\calculo\RegConst2.pas',
  RegEdit in '..\..\CompDelphi\RegEdit\RegEdit.pas',
  DMGraf in 'DMGraf.pas' {dmGraficos: TDataModule},
  URGrafAcomp in 'URGrafAcomp.pas' {fmRelGrafAcomp},
  UPessApr in 'UPessApr.pas' {fmPessApresent},
  UDupAlim in 'UDupAlim.pas' {fmDupAlim},
  USelecInqueritos in 'USelecInqueritos.pas' {fmSelecionaInqueritos},
  UIndiv in 'UIndiv.pas' {fmPPastas},
  UPrinc in 'UPrinc.pas' {fmTelaPrincipal},
  USelDados in 'USelDados.pas' {fmPSelDados},
  DMPesq in 'DMPesq.pas' {DMPesquisa: TDataModule},
  UPesquisa in 'UPesquisa.pas' {fmPesquisa},
  qrepform in '..\..\COMPDELPHI\CALCULO\qrepform.pas' {FormReport},
  NutLogin in 'NUTLOGIN.PAS' {fm_Login},
  USplash in 'USplash.pas' {fmSplash},
  UEESelecaoGrupo in 'UEESelecaoGrupo.pas' {fmEESelecaoGrupo},
  UEESelecMedidas in 'UEESelecMedidas.pas' {fmEESelecMedidas},
  UEEValorMedidas in 'UEEValorMedidas.pas' {fmEEValorMedidas},
  UEEValorGramas in 'UEEValorGramas.pas' {fmEEValorGramas},
  UEEWizard in 'UEEWizard.pas' {fmEEWizard},
  UEPSelecGrupo in 'UEPSelecGrupo.pas' {fmEPSelecaoGrupo},
  UEPSelecMedidas in 'UEPSelecMedidas.pas' {fmEPSelecMedidas},
  UEPValorGramas in 'UEPValorGramas.pas' {fmEPValorGramas},
  UEPValorMedidas in 'UEPValorMedidas.pas' {fmEPValorMedidas},
  UEPWizard in 'UEPWizard.pas' {fmEPWizard},
  FonAlim in 'FonAlim.pas' {fmFonetAlim},
{  WebConst in '..\webconst.pas',
  DbConsts in '..\dbconsts.pas',
  IBConst in '..\ibconst.pas',
  MidConst in '..\midconst.pas',
  mxConsts in '..\mxconsts.pas',
  OleConst in '..\oleconst.pas',
  Consts in '..\consts.pas',}
  UFonetPess in 'UFonetPess.pas' {fmFonetPess},
  UAlimApresent in 'UAlimApresent.pas' {fmAlimApresent},
  UMedCasOrdem in 'UMedCasOrdem.pas' {fmMedCasOrdem},
//  DMCriaTabTemp in '..\calc\DMCriaTabTemp.pas' {dmCriaTabelasTemp: TDataModule},
  UOpSist in 'UOpSist.pas' {fmOpcoesSistema},
  UopAlim in 'UopAlim.pas' {fmOpcoesAlimentos},
  UOpcoes in 'UOpcoes.pas' {fmOpcoesPess},
  URelPesList in 'Relatorios\URelPesList.pas' {fmRelPesList},
  URPessoasPastas in 'Relatorios\URPessoasPastas.pas' {fmRelPessoasporPastas},
  URPastasPessoas in 'Relatorios\URPastasPessoas.pas' {fmRelPastasporPessoas},
  URPastas in 'Relatorios\URPastas.pas' {fmRelPastas},
  NutRelatInd in 'Relatorios\NutrelatInd.pas' {fmNutRelInd},
  Sobre in '..\..\CompDelphi\about\Sobre.pas' {fmSobre},
  InfoSistema in '..\..\CompDelphi\about\InfoSistema.pas' {fmInfoSistema},
  USelDadosInq in 'USelDadosInq.pas' {fmSelDadosInq},
  UConfDados in 'UConfDados.pas' {fmConfDados},
  URTAGPro in 'Relatorios\URTAGPro.pas' {fmRTAGPro},
  fmRelGraficos in 'Relatorios\fmRelGraficos.pas',
  NovoPreview in '..\..\CompDelphi\Calculo\NovoPreview.pas' {fmNovoPreview},
  NutDica in 'NutDica.pas' {fm_Dica},
  URTASProt in 'URTASProt.pas' {fmRTASProt},
//  fmCadHelp in 'fmCadHelp.pas' {fmCadHlp},
//  dmHelp in '..\..\CompDelphi\HlpNut\dmHelp.pas' {dmHlp: TDataModule},
  UGrafWiz in 'UGrafWiz.pas' {fmGrafWiz},
  UGrafWizData in 'UGrafWizData.pas' {fmGrafWizData},
  UGrafWizFormulas in 'UGrafWizFormulas.pas' {fmGrafWizFormulas},
  UGrafWizGraficos in 'UGrafWizGraficos.pas' {fmGrafWizGraficos},
  DMSemaf in 'DMSemaf.pas' {dmSemaforo: TDataModule},
  Validade in '..\..\CompDelphi\Validade\Validade.pas' {fmValidade},
  uAliasName in 'uAliasName.pas',
  fmFormRelMedResult in '..\Calc\fmFormRelMedResult.pas',
  fmFormRelIndividuo in '..\Calc\fmFormRelIndividuo.pas' {FormRepIndividuo},
  AliWizMedida in '..\Calc\AliWizMedida.pas' {fmAliWizMedida},
  DMUmAli in '..\..\CompDelphi\Alinut\DMUmAli.pas' {DMUmAlimento: TDataModule},
  Services in '..\..\CompDelphi\Servicos\Services.pas',
  VersionInfo in '..\..\CompDelphi\About\VersionInfo.pas';
// FIM

{$R *.RES}



var
  MainPath, MsgErro : string;
  SalvaCursor: TCursor;
  NumLicencas : integer;



  //&  DMMaster : TdmDataBasesNut;
  //******************************************************************************
  //  RestaurandoDB : Boolean;
  //******************************************************************************

begin
  NumLicencas := -1; // pra garantir que esta informação vai ser pega de algum lugar
  // não deixa dois ou mais organizadores rodarem ao mesmo tempo
  if  true {not AppIsAlreadyRunning(ID_ORGANIZADOR)  }then
  begin

    Application.Initialize;

    // Algumas configurações gerais
    Application.Title := 'Organizador do Nutrição';
    //  Application.ShowHint := False;
    //  Application.OnHint:=DisplayHint;
    //  Application.ShowHint := True;
    Application.HintColor := clWhite;
    Application.HintPause := 0;
    ShortDateFormat := 'dd/mm/yyyy';
    LongTimeFormat := 'hh:mm:ss';
    ShortTimeFormat := 'hh:mm';
    TimeSeparator := ':';
    DecimalSeparator := ',';
    ThousandSeparator := '.';
    DateSeparator := '/';


    // Se existe arquivo do Banco para conversão então faça-a
    // Seta Individuos como opção não liberada
 //   CFGPath
    if not CarregaChaveString(CFGRoot, CFGPath, 'Path', MainPath) then
    begin
      ShowMessage('Erro de leitura da Chave: Path.' + #13#10 +
        'O programa não pode ser iniciado.');
      exit;
    end;

    // A conversão não foi feita, portanto sair do programa
//    if ConverteuBD(MainPath + '\IBDados\CVSBDADOS.GDB', MainPath + '\IBDados\BDADOS.GDB', MainPath + '\IBDados\ib_cvsdb.exe') <> 0 then
//      exit;

    SalvaCursor := Screen.Cursor; { Salva cursor atual }
    Screen.Cursor := crHourglass; { Mostra ampulheta }

    //Validade do programa
    with TfmValidade.Create(nil) do
    try
      DataBaseName := uAliasName.BDE_ALIAS_NAME;

      case TipoValidade of
        REGISTRO_VENCIDO,
          PERSONA_INEXISTENTE,
          PERSONA_DANIFICADA:
          begin
            ShowModal;
            if TipoValidade <> REGISTRO_OK then
              exit;
          end;
        REGISTRO_DESENV: ShowModal;
        REGISTRO_AVALIACAO: begin
                               ShowModal;
                               NumLicencas := LicencasPermitidas( MsgErro );
                               if NumLicencas < 0 then
                               begin
                                  ShowMessage(MsgErro);
                                  exit;
                               end
                            end; // Pegando número de licenças
        REGISTRO_OK: begin
                        NumLicencas := LicencasPermitidas( MsgErro );
                        if NumLicencas < 0 then
                        begin
                           ShowMessage(MsgErro);
                           exit;
                        end
                     end; // Pegando número de licenças
      end;
    finally
      Free;
    end;

    //******************************************************************************
    //repeat
    //RestaurandoDB := True;
    //******************************************************************************

      // Mostra tela de Splash
    with TfmSplash.Create(nil) do
    try
      pbProgresso.Max := 100;
      Show;
      Update;

     // Contém um database para todo o sistema
      laOperacao.Caption := 'Conectando ao Banco de Dados...';
      laOperacao.Update;
      //&     Application.CreateForm(TdmDataBasesNut, DMMaster);
      //&     DMMaster.dbOrg1.Connected := True;
      //&     DMMaster.RestauraActive := True; // vai manter aberto o que já está aberto
      pbProgresso.StepBy(10);

      // Cria e seta tabelas temporárias
      laOperacao.Caption := 'Criando Tabelas Temporárias...';
      laOperacao.Update;
//      Application.CreateForm(TdmCriaTabelasTemp, dmCriaTabelasTemp);
  pbProgresso.StepBy(5);

      laOperacao.Caption := 'Criando Tabelas de Semáforo...';
      laOperacao.Update;
      Application.CreateForm(TdmSemaforo, dmSemaforo);
      if ( NumLicencas <> 0 ) and ( dmSemaforo.GetAplicacoesAtivas( false ) >= NumLicencas ) then // tem que contar esta tb
      begin
          ShowMessage('O número de licenças adquiridas (' + IntToStr(NumLicencas) + ') para uso simultâneo já foi atingindo.'+#13#10 +
                      'Aguarde a saída de algum usuário e tente novamente' + #13#10 +
                      'ou entre em contato para adquirir mais licenças.'+chr(13)+chr(10)+chr(13)+chr(10)+ TEXTO_ENDERECO);
          dmSemaforo.Free;
          dmSemaforo := nil;
          exit;
      end;
      pbProgresso.StepBy(5);

      // Cria e seta Tabelas de Alimentos
      laOperacao.Caption := 'Abrindo Banco de Dados... Alimentos';
      laOperacao.Update;
      Application.CreateForm(TDMAlimentos, DMAlimentos);
      //&     DMMaster.DefineDM(DMAlimentos);
      pbProgresso.StepBy(5);

      // Cria e seta Tabelas de Medidas
      laOperacao.Caption := 'Abrindo Banco de Dados... Medidas';
      laOperacao.Update;
      Application.CreateForm(TDMedidas, DMedidas);
      //&     DMMaster.DefineDM(DMedidas);
      pbProgresso.StepBy(5);

      // Cria e seta Tabelas de Substitutos
      laOperacao.Caption := 'Abrindo Banco de Dados... Substitutos';
      laOperacao.Update;
      Application.CreateForm(TDMSubsCalorico, DMSubsCalorico);
      //&     DMMaster.DefineDM(DMSubsCalorico);
      pbProgresso.StepBy(5);

      // Cria e seta Tabelas de Pessoas
      laOperacao.Caption := 'Abrindo Banco de Dados... Pessoa';
      laOperacao.Update;
      Application.CreateForm(TDMPessoa, DMPessoa);
      //&     DMMaster.DefineDM(DMPessoa);
      pbProgresso.StepBy(5);

      // Cria e seta Tabelas de Nutrientes
      laOperacao.Caption := 'Abrindo Banco de Dados... Nutrientes';
      laOperacao.Update;
      Application.CreateForm(TDMNutrientes, DMNutrientes);
      //&     DMMaster.DefineDM(DMNutrientes);
      pbProgresso.StepBy(5);

      // Cria e seta Tabelas de Indexação
      laOperacao.Caption := 'Abrindo Banco de Dados... Indexação';
      laOperacao.Update;
      //*     Application.CreateForm(TDMIndexacao, DMIndexacao);
      //&     DMMaster.DefineDM(DMIndexacao);
      pbProgresso.StepBy(5);

      // Cria componentes de gráficos
      laOperacao.Caption := 'Abrindo Banco de Dados... Gráficos';
      laOperacao.Update;
      Application.CreateForm(TdmGraficos, dmGraficos);
      //&     DMMaster.DefineDM(dmGraficos);
      pbProgresso.StepBy(5);

      // Cria componentes da calculadora
      laOperacao.Caption := 'Criando Componentes...';
      laOperacao.Update;
//      Application.CreateForm(TdmHlp, dmHlp);
      Application.CreateForm(TdmMotherBoard, dmMotherBoard);
      //&     dmMotherBoard.DMDataBases := DMMaster;
      pbProgresso.StepBy(5);

      // Cria e seta Tabelas de Pesquisa
      laOperacao.Caption := 'Abrindo Banco de Dados... Pesquisa';
      laOperacao.Update;
      Application.CreateForm(TDMPesquisa, DMPesquisa);
      //&     DMMaster.DefineDM(DMPesquisa);
      pbProgresso.StepBy(20);

      // Cria tela principal do sistema
      laOperacao.Caption := 'Criando Console...';
      laOperacao.Update;
      Application.CreateForm(Tfm_MenuNut, fm_MenuNut);
      pbProgresso.StepBy(10);

      // Cria form que gerencia os tipos de salas
      laOperacao.Caption := 'Criando Salas...';
      laOperacao.Update;
      Application.CreateForm(TfmOpcSalas, fmOpcSalas);
      pbProgresso.StepBy(10);

      paProgresso.Visible := False;

    finally
      Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
      Free;
    end;

    // Abre janela de logim/senha
    Application.CreateForm(Tfm_Login, fm_Login);
    if fm_Login.ShowModal = mrOk then
    begin
      //**     fm_Login.Free;
           // Roda a aplicação
      Application.Run;
      // Preciso verificar pois se a saida for pela
      // opção de restaurar backup, o dmSemafora não existe mais
      if dmSemaforo <> nil then
      begin
         dmSemaforo.Free;
         dmSemaforo := nil;
      end;
    end

    else
    begin
      // Elimina todos os datamodules e forms
      (**
      Jair - Estou matando o datamodule de cotnrole de acesso aqui para evitar
             um AV na saída do aplicativo sem login.
      **)
      dmSemaforo.Free;
      dmSemaforo := nil;

//      dmCriaTabelasTemp.free;
      DMAlimentos.free;
      DMedidas.free;
      DMSubsCalorico.free;
      DMPessoa.free;
      DMNutrientes.free;
      //*        DMIndexacao.free;
      dmGraficos.free;
      dmMotherBoard.free;
      DMPesquisa.free;
      fm_MenuNut.free;
      fmOpcSalas.free;
      fm_Login.free;
      //&        DMMaster.free;
    end;

    //*****************************************************************************
    //until not RestaurandoDB;
    //*****************************************************************************

  end
  else
    ShowMessage('Já tem um Organizador aberto!');
end.


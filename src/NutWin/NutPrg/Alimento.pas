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




unit Alimento;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls, ExtCtrls, Spin, Grids, DBGrids, ComCtrls, Buttons,
  Mask, Tabs, DBMyNav, db, Menus, DBActns,
  ActnList, DBCGrids, NutCnst, MmLstBox, MoveItens, RXDBCtrl, CalculoViewer,
  measurement, RXLookup, ToolEdit, CCSAbreviar, CCSListaLinks, CCSFonetizar,
  FnpNumericEdit, FnpNEditBlank, CalculoTextViewer;

type
  TfmAlim = class(TForm)
    Bevel1: TBevel;
    pcAlimentos: TPageControl;
    teAliNutrientes: TTabSheet;
    be_Ali_Nutrientes: TBevel;
    teAliMedidas: TTabSheet;
    teAliSubstitutos: TTabSheet;
    teAliPreparacao: TTabSheet;
    teAliPreco: TTabSheet;
    laNut: TLabel;
    paSubsCal: TPanel;
    laGruSub: TLabel;
    nvNutr: TDBMyNav;
    nvAligCal: TDBMyNav;
    puCadMedidas: TPopupMenu;
    Cadastrar1: TMenuItem;
    laCal: TLabel;
    Label14: TLabel;
    lbEquiv: TLabel;
    Label20: TLabel;
    laQtdeMed: TLabel;
    Label5: TLabel;
    paPrep: TPanel;
    DBGrid2: TDBGrid;
    DBMemo1: TDBMemo;
    Label11: TLabel;
    DBEdit1: TDBEdit;
    Label6: TLabel;
    DBMyNav4: TDBMyNav;
    laPesqAli: TLabel;
    DBMyNav5: TDBMyNav;
    Label15: TLabel;
    paMCSCal: TPanel;
    Label16: TLabel;
    Label8: TLabel;
    paGrSCal: TPanel;
    Label17: TLabel;
    Label13: TLabel;
    teAliSubsProt: TTabSheet;
    paSP: TPanel;
    Label18: TLabel;
    laProt: TLabel;
    Label21: TLabel;
    lbEquivProt: TLabel;
    Label23: TLabel;
    Label26: TLabel;
    nvSubsProt: TDBMyNav;
    paMCSProt: TPanel;
    Label27: TLabel;
    laCal100: TLabel;
    teDadosAli: TTabSheet;
    pnAli: TPanel;
    la_Ali_Nome: TLabel;
    la_Ali_Apelido: TLabel;
    la_Ali_Grupo: TLabel;
    Label12: TLabel;
    deNomeAli: TDBEdit;
    deNAliSimp: TDBEdit;
    pcBotAlim: TPageControl;
    teAlimento: TTabSheet;
    sbNovAlim: TBitBtn;
    sbCanAlim: TBitBtn;
    sbExcAlim: TBitBtn;
    tePreparacao: TTabSheet;
    sbNovPrep: TBitBtn;
    sbExcPrep: TBitBtn;
    sbAltPrep: TBitBtn;
    teMedidas: TTabSheet;
    sbNovMed: TBitBtn;
    sbAltMed: TBitBtn;
    sbExcMed: TBitBtn;
    teNutrientes: TTabSheet;
    sbNovNutr: TBitBtn;
    sbAltNutr: TBitBtn;
    sbExcNutr: TBitBtn;
    teSubsCal: TTabSheet;
    sbNovSCal: TBitBtn;
    sbAltSCal: TBitBtn;
    sbExcSCal: TBitBtn;
    tePreco: TTabSheet;
    sbNovPreco: TBitBtn;
    sbAltPreco: TBitBtn;
    sbExcPreco: TBitBtn;
    teSubsProt: TTabSheet;
    sbNovSProt: TBitBtn;
    sbAltSProt: TBitBtn;
    sbExcSProt: TBitBtn;
    alAlimento: TActionList;
    AlimProx: TDataSetNext;
    AlimAnt: TDataSetPrior;
    AlimCan: TDataSetCancel;
    AlimDel: TDataSetDelete;
    AlimEdi: TDataSetEdit;
    AlimNov: TDataSetInsert;
    sbAltAlim: TBitBtn;
    NutDel: TDataSetDelete;
    NutNov: TDataSetInsert;
    sbCanMed: TBitBtn;
    MedCan: TDataSetCancel;
    MedDel: TDataSetDelete;
    MedEdi: TDataSetEdit;
    MedNov: TDataSetInsert;
    SpeedButton1: TBitBtn;
    SCalCan: TDataSetCancel;
    SCalDel: TDataSetDelete;
    SCalEdi: TDataSetEdit;
    SCalNov: TDataSetInsert;
    sbCanSprot: TBitBtn;
    SProtCan: TDataSetCancel;
    SProtDel: TDataSetDelete;
    SProtEdi: TDataSetEdit;
    SProtNov: TDataSetInsert;
    sbPrecoCanc: TBitBtn;
    PrecoCan: TDataSetCancel;
    PrecoDel: TDataSetDelete;
    PrecoEdi: TDataSetEdit;
    PrecoNov: TDataSetInsert;
    sbSalMed: TBitBtn;
    AlimSal: TDataSetPost;
    NutSal: TDataSetPost;
    MedSal: TDataSetPost;
    SCalSal: TDataSetPost;
    SProtSal: TDataSetPost;
    PrecoSal: TDataSetPost;
    sbSalAlim: TBitBtn;
    sbSalNutr: TBitBtn;
    sbCanNutr: TBitBtn;
    NutCan: TDataSetCancel;
    SpeedButton6: TBitBtn;
    sbSalSProt: TBitBtn;
    sbSalPreco: TBitBtn;
    Panel2: TPanel;
    laQtdeMedSP: TLabel;
    Label25: TLabel;
    SProtControleGProt: TAction;
    SCalControleGCal: TAction;
    ChecaGravacaoAlim: TAction;
    Label19: TLabel;
    NutEdi: TAction;
    paMed: TPanel;
    Label2: TLabel;
    deValor: TDBEdit;
    Label1: TLabel;
    naMedCas: TDBMyNav;
    MedPro: TDataSetNext;
    MedAnt: TDataSetPrior;
    grMCas: TDBGrid;
    paNut: TPanel;
    teNomeNut: TDBText;
    teValorNut: TDBEdit;
    teUnidNut: TDBText;
    btMudaOrd: TButton;
    grNutVisao: TRxDBGrid;
    deObsAli: TDBEdit;
    cvVideo: TCalculoTextViewer;
    paVis: TPanel;
    btVis: TButton;
    btOrdNut: TButton;
    btPocConsumo: TButton;
    cnFon: TCCSFonetizar;
    cnAbreviar: TCCSAbreviar;
    teGrupo: TDBText;
    Label10: TLabel;
    teMedCas: TDBText;
    teQtdeMed: TDBText;
    teValGramas: TDBText;
    Panel1: TPanel;
    teGruSub: TDBText;
    Panel3: TPanel;
    Label22: TLabel;
    teMedCasSP: TDBText;
    paGrSProt: TPanel;
    Label29: TLabel;
    Label24: TLabel;
    teQtdeMedSP: TDBText;
    teGrMedSP: TDBText;
    deAlim: TDBText;
    pnPreco: TPanel;
    rgPreco: TRadioGroup;
    paMCPr: TPanel;
    Label9: TLabel;
    Label4: TLabel;
    llMedCasPr: TDBLookupListBox;
    paGr: TPanel;
    Label3: TLabel;
    laData: TLabel;
    deDataPreco: TDBEdit;
    Label7: TLabel;
    nvPreco: TDBMyNav;
    laGr: TLabel;
    DBText2: TDBText;
    Label28: TLabel;
    lcMed: TRxDBLookupCombo;
    lcOrigem: TRxDBLookupCombo;
    btRelatorios: TBitBtn;
    acRelatorios: TAction;
    lcGrupo: TRxDBLookupCombo;
    laFonet: TLabel;
    fnQtde: TFnpNEditBlank;
    fnGramas: TFnpNEditBlank;
    fnPreco: TFnpNEditBlank;
    edOrigem: TEdit;
    edMedida: TEdit;
    imClip0: TImage;
    reVisorPreparacao: TRichEdit;
    LocALim: TAction;
    paAlimentoLocal: TPanel;
    BitBtn1: TBitBtn;
    btLocAlim: TBitBtn;
    btNavAnterior: TBitBtn;
    btNavProximo: TBitBtn;
    btFechar: TBitBtn;
    Fechar: TAction;
    Label30: TLabel;
    procedure buNutClick(Sender: TObject);
    procedure btApllyUpdateClick(Sender: TObject);
    procedure DBGrid3CellClick(Column: TColumn);
    procedure sdQtdeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sdNutChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Cadastrar1Click(Sender: TObject);
    procedure btVisClick(Sender: TObject);
    procedure rgPrecoClick(Sender: TObject);
    procedure llMedCasPrClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pcAlimentosChange(Sender: TObject);
    procedure NutNovExecute(Sender: TObject);
    procedure AlimNovExecute(Sender: TObject);
    procedure deNomeAliChange(Sender: TObject);
    procedure AlimSalExecute(Sender: TObject);
    procedure NutSalExecute(Sender: TObject);
    procedure SProtEdiExecute(Sender: TObject);
    procedure SProtNovExecute(Sender: TObject);
    procedure SProtCanExecute(Sender: TObject);
    procedure SProtSalExecute(Sender: TObject);
    procedure SCalNovExecute(Sender: TObject);
    procedure SCalEdiExecute(Sender: TObject);
    procedure SCalSalExecute(Sender: TObject);
    procedure ChecaGravacaoAlimExecute(Sender: TObject);
    procedure NutEdiExecute(Sender: TObject);
    procedure AlimEdiExecute(Sender: TObject);
    procedure AlimCanExecute(Sender: TObject);
    procedure MedCanExecute(Sender: TObject);
    procedure MedNovExecute(Sender: TObject);
    procedure MedDelExecute(Sender: TObject);
    procedure MedEdiExecute(Sender: TObject);
    procedure MedSalExecute(Sender: TObject);
    procedure NutCanExecute(Sender: TObject);
    procedure NutDelExecute(Sender: TObject);
    procedure btMudaOrdClick(Sender: TObject);
    procedure grNutVisaoGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure teAliPreparacaoShow(Sender: TObject);
    procedure AlimDelExecute(Sender: TObject);

    //####################
    procedure bbAnteriorClick(Sender: TObject);
    procedure bbProximoClick(Sender: TObject);
    procedure bbInicioClick(Sender: TObject);
    procedure bbUltimoClick(Sender: TObject);
    procedure ntDataCalculoNavChange(Sender: TObject);
    procedure cvVideoAfterWizardTerminate(Sender: TObject);
    procedure teCalculosShow(Sender: TObject);
    procedure teValorNutKeyPress(Sender: TObject; var Key: Char);
    procedure grNutVisaoKeyPress(Sender: TObject; var Key: Char);
    procedure btOrdNutClick(Sender: TObject);
    procedure deNomeAliKeyPress(Sender: TObject; var Key: Char);
    procedure deObsAliExit(Sender: TObject);
    procedure teAliNutrientesEnter(Sender: TObject);
    procedure teAliNutrientesExit(Sender: TObject);
    procedure teValorNutExit(Sender: TObject);
    procedure PrecoNovExecute(Sender: TObject);
    procedure PrecoEdiExecute(Sender: TObject);
    procedure PrecoSalExecute(Sender: TObject);
    procedure PrecoDelExecute(Sender: TObject);
    procedure PrecoCanExecute(Sender: TObject);
    procedure SCalDelExecute(Sender: TObject);
    procedure SProtDelExecute(Sender: TObject);
    procedure SCalCanExecute(Sender: TObject);
    procedure deNomeAliExit(Sender: TObject);
    procedure lcMed2CloseUp(Sender: TObject);
    procedure grNutVisaoDblClick(Sender: TObject);
    procedure teValorNutDblClick(Sender: TObject);
    procedure AlimProxExecute(Sender: TObject);
    procedure AlimAntExecute(Sender: TObject);
    procedure deValorExit(Sender: TObject);
    procedure lcMedCloseUp(Sender: TObject);
    procedure acRelatoriosExecute(Sender: TObject);
    procedure acRelatoriosUpdate(Sender: TObject);
    procedure teAliMedidasExit(Sender: TObject);
    procedure laFonetClick(Sender: TObject);
    procedure fnQtdeExit(Sender: TObject);
    procedure fnGramasExit(Sender: TObject);
    procedure fnGramasClick(Sender: TObject);
    procedure fnPrecoExit(Sender: TObject);
    procedure lcOrigemCloseUp(Sender: TObject);
    procedure edOrigemExit(Sender: TObject);
    procedure lcOrigemEnter(Sender: TObject);
    procedure edMedidaExit(Sender: TObject);
    procedure LocALimExecute(Sender: TObject);
    procedure FecharExecute(Sender: TObject);
    //####################
  private
    { Private declarations }
    stProt: string;
    stMedCasProt: string;
    stCal: string;
    FChamadaPeloMenu: Boolean;
    procedure SetChamadaPeloMenu(const Value: Boolean);

  public
    { Public declarations }
    paAlimento: TPanel;
    FRecurso : String;
    procedure ConfAlimPreco;
    procedure ConfAlimSubsCal;
    procedure ConfAlimSubsProt;
    procedure ConfAlimPreparacao;
    procedure MostraBotoesAlim;
    procedure SPMedCas;
    procedure NutTrocaGrid;
    procedure ChavePressionada(Sender: TObject; var Key: Char);
    property ChamadaPeloMenu: Boolean read FChamadaPeloMenu write SetChamadaPeloMenu;

    //##############################################
    procedure DefineKeys(Sender: TObject; Dataset: TDataSet);
    procedure AfterDefineCalcPreparacao(Sender: TObject);
    procedure BeforeCalcularPreparacao(Sender: TObject);
    procedure ErroAdicionarSelf(Sender: TObject);
    //###############################################
  end;

var
  fmAlim: TfmAlim;

implementation

uses USelNut, DMAliPrep, DMNutrien, DMSubstCal,
  DMMedidas, DMPrecoAlim, NutMenu, TabAli, ULocAlim, UListaNut, UCadMed,
  DMMBoard, UEEWizard, UEESelecaoGrupo, UEPWizard, FonAlim,
  UMedCasOrdem, UopAlim, dmSemaf;
//UOpcoes,
{$R *.DFM}

procedure TfmAlim.SetChamadaPeloMenu(const Value: Boolean);
begin
  FChamadaPeloMenu := Value;
end;

procedure TfmAlim.NutTrocaGrid;
begin
  paNut.Visible := False;
  NutSal.DataSource.DataSet.Refresh;
  DMNutrientes.TbNutrientesbk.Refresh;
  ConfAlimSubsCal;
  ConfAlimSubsProt;
end;

procedure TfmAlim.SPMedCas;
begin
  // Traz o valor da medida caseira selecionada
  if DMedidas.TbMedidasCaseiras.Locate('IDALI;IDMEDCAS', VarArrayOf([DMAlimentos.TbAlimento['IDALI'], DMSubsCalorico.TbAliGProt['IdMedCas']]), []) then
    stMedCasProt := DMedidas.TbMedidasCaseirasVALOR.asString
  else
    stMedCasProt := '';
  // Controle das opcoes da Quantidade
  laQtdeMedSP.Caption := DMSubsCalorico.AproximaMedida(lbEquivProt.Caption,
    stMedCasProt);

end;

procedure TfmAlim.MostraBotoesAlim;
begin
  pcBotAlim.ActivePage := pcBotAlim.Pages[pcAlimentos.ActivePage.PageIndex];
end;

procedure TfmAlim.ConfAlimPreparacao;
begin
  if DMAlimentos.TbAlimento.FieldByName('Prep').asString = 'T' then
    teAliPreparacao.TabVisible := True
  else
    teAliPreparacao.TabVisible := False;

end;

procedure TfmAlim.ConfAlimSubsProt;

begin
  // Controle das Proteinas

  stProt := DMNutrientes.AchaValorNutriente(DMAlimentos.TbAlimento.Fieldbyname('IDALI').asString, '{B01C0040-AEE3-11D2-B4C0-00609723104C}'); // Proteína
  if stProt = '' then
  begin
    stProt := '0';
    laProt.Caption := '';
    //ShowMessage('Cadastre o nutriente Proteinas antes de cadastrar o Substituto Proteico');
    teAliSubsProt.TabVisible := False;
  end
  else
  begin
    teAliSubsProt.TabVisible := True;
    laProt.Caption := '100 g deste alimento contêm ' + Trim(stProt) + ' g de proteinas';

    // Controle do Equivalente
    if DMSubsCalorico.SPEquiv <> '0' then
      lbEquivProt.caption := DMSubsCalorico.SPEquiv
    else
      lbEquivProt.caption := '';

    // Controle da Medida e resultado em gramas
    // if lcMedCasSP.SelectedItem <> '' then
    if DMSubsCalorico.TbAliGProt.Fieldbyname('IDMEDCAS').asString <> '' then
    begin
      // Traz o valor da medida caseira selecionada
      DMSubsCalorico.SPMedCas;
    end;
  end;

end;

procedure TfmAlim.ConfAlimSubsCal;

begin
  // Controle das Calorias
  stCal := DMNutrientes.AchaValorNutriente(DMAlimentos.TbAlimento.Fieldbyname('IDALI').asString, '{B01C0044-AEE3-11D2-B4C0-00609723104C}'); // Calorias
  if stCal = '' then
  begin
    stCal := '0';
    laCal.Caption := '';
    // ShowMessage('Cadastre o nutriente Energia antes de cadastrar o Equivalente Energético')
    teAliSubstitutos.TabVisible := False;
  end
  else
  begin // Completo o valor das calorias
    teAliSubstitutos.TabVisible := True;
    laCal.Caption := '100 g deste alimento contêm ' + Trim(stCal) + ' calorias';
    laCal100.Caption := stCal;

    // Controle do Equivalente
    if DMSubsCalorico.SCEquiv <> '0' then
      lbEquiv.caption := DMSubsCalorico.SCEquiv
    else
      lbEquiv.caption := '';

    // Controle da Medida e resultado em gramas
    if DMSubsCalorico.TbAliGCalIDMEDCAS.asString <> '' then
    begin
      // Traz o valor da medida caseira selecionada
      DMSubsCalorico.SCMedCas;

    end;

  end;
end;

procedure TfmAlim.ConfAlimPreco;
begin
  if pcAlimentos.ActivePage = teAliPreco then
  begin
    if DMAlimentos.TbPrecoAli.Fieldbyname('IDMEDCAS').asString = '' then
    begin
      rgPreco.ItemIndex := 1; // coloco em gramas, pois não tenho nenhuma mc cadastrada
    end
    else
    begin
      rgPreco.ItemIndex := 0;
    end;

    // Isto é feito para configurar os componentes fnp
    with DMAlimentos.TbPrecoAli do
    begin
      if DMAlimentos.TbPrecoAli.Fieldbyname('MEDGR').asString = '' then
        fnGramas.Value := StrtoFloat('0,00')
      else
        fnGramas.Value := DMAlimentos.TbPrecoAli.Fieldbyname('MEDGR').asFloat;
      fnQtde.Value := DMAlimentos.TbPrecoAli.Fieldbyname('QTDE').asFloat;
      fnPreco.Value := DMAlimentos.TbPrecoAli.Fieldbyname('PRECO').asFloat;
    end;

  end;
end;

procedure TfmAlim.buNutClick(Sender: TObject);
begin
  fmSelecNut := TfmSelecNut.Create(self);
  fmSelecNut.ShowModal;
  fmSelecNut.free;
end;

procedure TfmAlim.btApllyUpdateClick(Sender: TObject);
begin
  DMAlimentos.GravaDados;
end;

procedure TfmAlim.DBGrid3CellClick(Column: TColumn);
begin
  DMNutrientes.TbAliNut.Refresh;
end;

procedure TfmAlim.sdQtdeChange(Sender: TObject);
begin
  DMNutrientes.TbAliNut.Refresh;
end;

procedure TfmAlim.FormCreate(Sender: TObject);
begin
  //###############################################################
     // Seta properties que não puderam ser setadas na interface
  with dmMotherBoard do
  begin

    cvVideo.Calculo := caProcessador;
    cvVideo.DelayedOpIndicator := Ampulheta;

    sbNovPrep.Action := cnDBNovaPreparacao;
    sbAltPrep.Action := cnDBCalcular;
    sbExcPrep.Action := cnDBExcluir;
    CalcPreparacao.OnErroAdicionarSelf := ErroAdicionarSelf;
  end;

  // Seta Eventos
  dmMotherBoard.cnDBNovaPreparacao.OnDefineAlmaHumana := nil;
  dmMotherBoard.cnDBNovaPreparacao.OnDefineDataCalculo := nil;
  dmMotherBoard.cnDBNovaPreparacao.OnBeforeCalcular := BeforeCalcularPreparacao;
  dmMotherBoard.cnDBCalcular.OnBeforeCalcular := BeforeCalcularPreparacao;
  dmMotherBoard.cnDBSalvar.OnDefineKeys := DefineKeys;
  dmMotherBoard.cnDBCalcAntropometria.OnAfterDefineCalculo := nil;
  dmMotherBoard.cnDBCalcInquerito.OnAfterDefineCalculo := nil;
  dmMotherBoard.cnDBCalcDieta.OnAfterDefineCalculo := nil;
  dmMotherBoard.cnDBCalcPreparacao.OnAfterDefineCalculo := AfterDefineCalcPreparacao;

  dmMotherBoard.DBIniciar(cvVideo);

  dmMotherBoard.cnDBCalcPreparacao.ExecuteTarget(self);
  dmMotherBoard.cnDBCalcPreparacao.UpdateTarget(self);
  //###############################################################

  //    Application.CreateForm(TfmLocAlim, fmLocAlim);
  Application.CreateForm(TfmListNut, fmListNut);
  pcAlimentos.ActivePage := teDadosAli;
  pcBotAlim.ActivePage := teAlimento;

end;

procedure TfmAlim.sdNutChange(Sender: TObject);
begin
  DMNutrientes.TbAliNut.Refresh;
end;

procedure TfmAlim.Button3Click(Sender: TObject);
begin
  DMALimentos.TbAlimento.Next;
end;

procedure TfmAlim.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DMALimentos.TbAlimento.Refresh;
  fm_MenuNut.HabilitaMenu;
  //   fmLocAlim.free;
  fmListNut.free;

  ChecaGravacaoAlimExecute(Sender);
  Action := caFree;
  //##################################
  dmMotherBoard.DBTerminar;
  //##################################

end;

procedure TfmAlim.Cadastrar1Click(Sender: TObject);
begin
  Application.CreateForm(TfmTabAli, fmTabAli);
  fmTabAli.pgcTabelas.ActivePage := fmTabAli.tsTAMedCas;
  MostraBotoesAlim; // Sincroniza os botoes.
  fmTabAli.ShowModal;
  fmTabAli.Free;
end;

procedure TfmAlim.btVisClick(Sender: TObject);
begin
  fmListNut.WindowState := wsNormal;
  fmListNut.lvNutCalc.Items.Clear;
  fmListNut.Show;
end;

procedure TfmAlim.rgPrecoClick(Sender: TObject);
begin
  pnPreco.Enabled := True;
  if rgPreco.ItemIndex = 0 then // Medidas Caseiras
  begin
    if (DMAlimentos.TbMCPreco.IsEmpty) and
      ((DMAlimentos.TbPrecoAli.State = dsEdit) or (DMAlimentos.TbPrecoAli.State = dsInsert)) then
    begin
      ShowMessage('Não existe Medida Caseira cadastrada para este Alimento.');
      rgPreco.ItemIndex := 1;
      paMCPr.Visible := False;
      paGr.Enabled := True;
    end
    else
    begin
      paMCPr.Visible := True;
      // deQtde.Setfocus;
      paGr.Enabled := False;
    end;
  end
  else // gramas
  begin
    paMCPr.Visible := False;
    paGr.Enabled := True;

    if (DMAlimentos.TbPrecoAli.State = dsEdit) or (DMAlimentos.TbPrecoAli.State = dsInsert) then
    begin
      // caso tenha uma medida caseira cadastrada, devo apaga-la e sua unidade.
      if DMAlimentos.TbPrecoAli.Fieldbyname('IDMEDCAS').asString <> '' then
      begin
        if MessageDlg('A Quantidade e Medida cadastrada será apagada.',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          DMAlimentos.TbPrecoAli.Edit;
          DMAlimentos.TbPrecoAli.Fieldbyname('IDMEDCAS').asString := '';
          DMAlimentos.TbPrecoAli.Fieldbyname('QTDE').asFloat := StrtoFloat('0,00');
          fnQtde.Value := DMAlimentos.TbPrecoAli.Fieldbyname('QTDE').asFloat;

        end;
      end;
      fnGramas.SetFocus;
    end;
  end;

  if (DMAlimentos.TbPrecoAli.State = dsEdit) or (DMAlimentos.TbPrecoAli.State = dsInsert) then
    pnPreco.Enabled := True
  else
    pnPreco.Enabled := False;
end;

procedure TfmAlim.llMedCasPrClick(Sender: TObject);
begin
  with DMAlimentos do
  begin
    TbPrecoAli.Fieldbyname('MEDGR').asString := FloattoStr(TbPrecoAli.Fieldbyname('QTDE').asFloat * TbMCPreco.Fieldbyname('VALOR').asFloat);
    ConfAlimPreco;
  end;
end;

procedure TfmAlim.FormShow(Sender: TObject);
begin
  //)   fmCalcNutr.ifFormWizard.Container := paPreparacao;
  pcAlimentos.ActivePage := teDadosAli;
  pcBotAlim.ActivePage := teAlimento;
  (**
  Jair - Desabilidade os botões de navigação que estarão desabilitados para
         a versão rede da aplicação, fica mais facil o usuario navegar pela
         tela de cadastro.
  **)
//  AlimAnt.Visible := false;
//  AlimProx.Visible := false;
  LocALim.Visible:= false;
  AlimNov.Visible:= false;

  ConfAlimPreco;
  //  ConfAlimSubsCal;
  ConfAlimSubsProt;
  ConfAlimPreparacao;

  // Jair e Wagner
  if (FRecurso = '')  then
    begin
      if not (dmSemaforo.TravaRecurso(DMAlimentos.TbAlimento.FieldByName('IDALI').AsString, copy('Alimento: ' +
              DMAlimentos.TbAlimento.FieldByName('NOME').AsString, 1, 50))) then
         begin
            pcBotAlim.Visible := False;
            FRecurso := '';
         end
         else
         begin
            FRecurso := DMAlimentos.TbAlimento.FieldByName('IDALI').AsString;
            pcBotAlim.Visible := True;
         end;
  end;
  //   Dump.Show;
end;

procedure TfmAlim.pcAlimentosChange(Sender: TObject);
begin
  MostraBotoesAlim; // Sincroniza os botoes.

  // Configuracao de alimentos
  if pcAlimentos.ActivePage = teDadosAli then
  begin
  end

    // Configuracao de Nutrientes
  else if pcAlimentos.ActivePage = teAliNutrientes then
  begin

  end

    // Configuracao para Medidas Caseiras
  else if pcAlimentos.ActivePage = teAliMedidas then
  begin
  end

    // Configuracao para Preparação
  else if pcAlimentos.ActivePage = teAliPreparacao then
  begin
  end

    // Configuracao para Substitutos Caloricos
  else if pcAlimentos.ActivePage = teAliSubstitutos then
    //  ConfAlimSubsCal

    // Configuracao para Preco
  else if pcAlimentos.ActivePage = teAliPreco then
    ConfAlimPreco

    // Configuracao para Substitutos Proteicos
  else if pcAlimentos.ActivePage = teAliSubsProt then
    ConfAlimSubsProt;

  // Em qualquer mudanca de pastinha, devo salvar meus dados. Por isso checo todos os bancos e seu estado.

  if (DMAlimentos.TbAlimento.State = dsEdit) or (DMAlimentos.TbAlimento.State = dsInsert) then
  begin
    pcAlimentos.ActivePage := teDadosAli;
    MostraBotoesAlim; // Sincroniza os botoes.

    if MessageDlg('Deseja salvar os dados de Alimentos ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      AlimCanExecute(Sender)
    else
      AlimSalExecute(Sender);
  end

  else if (DMNutrientes.TbAliNut.State = dsEdit) or (DMNutrientes.TbAliNut.State = dsInsert) then
  begin
    pcAlimentos.ActivePage := teAliNutrientes;
    MostraBotoesAlim; // Sincroniza os botoes.

    if MessageDlg('Deseja salvar os dados dos Nutrientes ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      NutCanExecute(Sender)
    else
      NutSalExecute(Sender);
  end

  else if (DMedidas.TbMedidasCaseiras.State = dsEdit) or (DMedidas.TbMedidasCaseiras.State = dsInsert) then
  begin
    pcAlimentos.ActivePage := teAliMedidas;
    MostraBotoesAlim; // Sincroniza os botoes.

    if MessageDlg('Deseja salvar os dados das Medidas Caseiras ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      MedCanExecute(Sender)
    else
      MedSalExecute(Sender);
  end

  else if (DMSubsCalorico.TbAliGCal.State = dsEdit) or (DMSubsCalorico.TbAliGCal.State = dsInsert) then
  begin
    if MessageDlg('Deseja salvar os dados dos Equivalentes de Energia ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      DMSubsCalorico.TbAliGCal.Cancel
    else
      DMSubsCalorico.TbAliGCal.Post;
  end

  else if (DMAlimentos.TbPrecoAli.State = dsEdit) or (DMAlimentos.TbPrecoAli.State = dsInsert) then
  begin
    pcAlimentos.ActivePage := teAliPreco;
    MostraBotoesAlim; // Sincroniza os botoes.

    if MessageDlg('Deseja salvar os dados dos Precos ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      PrecoCanExecute(Sender)
    else
      PrecoSalExecute(Sender);
  end

  else if (DMSubsCalorico.TbAliGProt.State = dsEdit) or (DMSubsCalorico.TbAliGProt.State = dsInsert) then
  begin
    if MessageDlg('Deseja salvar os dados dos Equivalentes de Proteina ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      DMSubsCalorico.TbAliGProt.Cancel
    else
      DMSubsCalorico.TbAliGProt.Post;
  end;

  MostraBotoesAlim; // Sincroniza os botoes.

end;

procedure TfmAlim.NutNovExecute(Sender: TObject);
begin
  {    fmSelecNut := TfmSelecNut.Create( self );
      fmSelecNut.ShowModal;
      fmSelecNut.free;     }
  paNut.Visible := True;
  // verifico se achei o determinado nutriente. Se for editar ou incluo e posiciono.

  if DMNutrientes.TbAliNut.Locate('IDALI;IDNUT', VarArrayOf([DMAlimentos.TbAlimento['IDALI'], DMNutrientes.TbNutrientesbk['IDNUT']]), []) then
  begin
    DMNutrientes.TbAliNut.Edit;
  end
  else
  begin
    DMNutrientes.TbAliNut.Insert;
    DMNutrientes.TbAliNut.Fieldbyname('IDNUT').asString := DMNutrientes.TbNutrientesbk.Fieldbyname('IDNUT').asString;
  end;

  ConfAlimSubsCal;
  ConfAlimSubsProt;
end;

procedure TfmAlim.AlimNovExecute(Sender: TObject);
begin
  // Sempre posiciono em Alimentos
  pcAlimentos.ActivePage := teDadosAli;
  pcBotAlim.ActivePage := teAlimento;

  // esconde o link para o fonetizado.
  laFonet.Visible := False;

  // posiciono quando for um novo registro em Alimentos
  pnAli.Enabled := True;
  // Travo os botões
  paAlimento.Visible := False;
  AlimNov.DataSource.DataSet.Insert;

  // Jair e Wagner
  if (FRecurso <> '') then
    dmSemaforo.LiberaRecurso(FRecurso);
  pcBotAlim.Visible := True;
  FRecurso := DMAlimentos.TbAlimento.FieldByName('IDALI').AsString;
  dmSemaforo.TravaRecurso( FRecurso, 'Alimento novo' );

  deNomeAli.SetFocus;
  // desativo estas pastas. So volto a ativa-las quando salvar.
  teAliNutrientes.TabVisible := False;
  teAliMedidas.TabVisible := False;
  teAliPreco.TabVisible := False;

  // Configuracao para Preco
  ConfAlimPreco;

end;

procedure TfmAlim.deNomeAliChange(Sender: TObject);
//var
  //stNome: string;
begin
  ConfAlimPreparacao;
  ConfAlimSubsCal;
  ConfAlimSubsProt;
  DmNutrientes.TbNutrientesbk.Refresh;
  DMedidas.TbMedidasCaseiras.Locate('IDALI;IDMEDCAS', VarArrayOf([DMAlimentos.TbAlimento['IDALI'], DMedidas.qrMedCIndexada['IDMEDCAS']]), []);
  DMSubsCalorico.TbGruCal.Refresh;

  // coloca no nome a palavra a abreviar
  //cnAbreviar.Nome := Trim( AnsiUpperCase( deNomeAli.Text ) ) ;
  // chama o metodo abreviar
  //cnAbreviar.AbreviarNome;
  // pega o valor no nome abreviado. Coloco sempre a primeira letra em maiúscula e as demais em minúscula
  // laNomeAbrev.caption  := cnAbreviar.NomeAbreviado  ;
end;

procedure TfmAlim.AlimSalExecute(Sender: TObject);
var
  stFormataNomeAlimento: string;
  CampoVazio: TField;

begin

  // devo sempre tirar o foco do campo. Em alguns casos dá erro quando utilizada a tecla de atalho.
  if pcAlimentos.ActivePage = teDadosAli then
    sbSalAlim.SetFocus;

  // desativo o label de acesso a Fonetização
  laFonet.Visible := False;

  CampoVazio := InvalidRequiredField(DMAlimentos.TbAlimento);
  if CampoVazio = nil then
  try
    begin
      paAlimento.Visible := True;
      // ativo estes campos
      deNomeAli.Enabled := True;
      lcOrigem.Enabled := True;
      lcGrupo.Enabled := True;

      // Caso seja uma alteração, diferente de Preparação, mas o campo Prep esteja True, preciso avisar.
      // apagar a Preparação gravada ou retornar o campo ao estado anterior.

      if (DMAlimentos.TbAlimento.State = dsEdit) and
        (DMAlimentos.TbAlimento.Fieldbyname('IDGRUALI').asString <> '{88DD9369-66F8-11D1-A6A0-008048B86BEE}') and
        (DMAlimentos.TbAlimento.Fieldbyname('PREP').asString = 'T') then
      begin

        if MessageDlg('Foi efetuada uma alteração no Grupo Alimentar. Excluir a Preparação ?', mtConfirmation,
          [mbYes, mbNo], 0) = mrYes then

        begin
          // Excluo a Preparação existente.
          dmMotherBoard.cnDBExcluir.ExecuteTarget(Sender);
        end
        else
        begin
          // Aqui altero o grupo para Preparação novamente.
          DMAlimentos.TbAlimento.Fieldbyname('IDGRUALI').asString := '{88DD9369-66F8-11D1-A6A0-008048B86BEE}';
        end;
      end;

      // se for Preparacao devo marcar o campo Prep como True .
      if AlimSal.DataSource.DataSet.FieldByName('IDGRUALI').asString =
        '{88DD9369-66F8-11D1-A6A0-008048B86BEE}' then
        AlimSal.DataSource.DataSet.FieldByName('Prep').AsString := 'T'
      else
        AlimSal.DataSource.DataSet.FieldByName('Prep').AsString := 'F';

      // Coloco sempre a primeira letra em maiúscula e as demais em minúscula
     //   stFormataNomeAlimento := Trim( LowerCase(AlimSal.DataSource.DataSet.FieldByName('NOME').asString) );

      stFormataNomeAlimento := Trim(LowerCase(deNomeAli.Text));
      if length(stFormataNomeAlimento) > 0 then
        stFormataNomeAlimento[1] := (Uppercase(stFormataNomeAlimento[1]))[1];
      AlimSal.DataSource.DataSet.FieldByName('NOME').asString := stFormataNomeAlimento;

      AlimSal.DataSource.DataSet.Post;
      // Depois que salvou, não retorna mais para o menu ...
      ChamadaPeloMenu := False;

      //#################################
           //Seta o IDSelf da Preparação com o seu ID
      dmMotherBoard.CalcPreparacao.IDSelf := AlimSal.DataSource.DataSet.FieldByName('IDALI').AsString;
      //#################################

           // ativo estas pastas
      teAliNutrientes.TabVisible := True;
      teAliMedidas.TabVisible := True;
      teAliPreco.TabVisible := True;

      // Configuro os substitutos
       // ConfAlimSubsProt;
      ConfAlimPreparacao;
      pnAli.SetFocus;
      pnAli.Enabled := False;

    end
  except
    on E: EDatabaseError do
    begin
      raise
    end;
  end;

end;

procedure TfmAlim.NutSalExecute(Sender: TObject);
begin
  paAlimento.Visible := True;
  if (NutSal.DataSource.DataSet.State = dsEdit) or
    (NutSal.DataSource.DataSet.State = dsInsert) then
    NutSal.DataSource.DataSet.Post;
  NutSal.DataSource.DataSet.Refresh; // acrescentei esta linha, pois estava dando problemas na atualização da tela.
end;

procedure TfmAlim.SProtEdiExecute(Sender: TObject);
begin
  {  paAlimento.Visible := False;
    SProtNov.DataSource.DataSet.Edit;
    paSP.Enabled := True;
    dbGruSubProt.Setfocus;
   }

  SProtNov.DataSource.DataSet.Edit;
  Application.CreateForm(TfmEPWizard, fmEPWizard);
  fmEPWizard.ShowModal;
  fmEPWizard.Free;
  if DMSubsCalorico.SPEquiv <> '0' then
    lbEquivProt.caption := DMSubsCalorico.SPEquiv
  else
    lbEquivProt.caption := '';
end;

procedure TfmAlim.SProtNovExecute(Sender: TObject);
begin

  // Verifico se já tem algum cadastrado, se tiver eu travo
  if SProtNov.DataSource.DataSet.RecordCount = 1 then
  begin
    ShowMessage('Só está disponível o cadastramento de 1 único registro para Equivalentes de Proteina');
  end
  else
  begin
    SProtNov.DataSource.DataSet.Insert;
    Application.CreateForm(TfmEPWizard, fmEPWizard);
    fmEPWizard.ShowModal;
    fmEPWizard.Free;
    if DMSubsCalorico.SPEquiv <> '0' then
      lbEquivProt.caption := DMSubsCalorico.SPEquiv
    else
      lbEquivProt.caption := '';
  end;

end;

procedure TfmAlim.SProtCanExecute(Sender: TObject);
begin
  if MessageDlg('Confirma o cancelamento dos dados ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    paAlimento.Visible := True;
    SProtNov.DataSource.DataSet.Cancel;
    paSP.Enabled := False;
  end;
end;

procedure TfmAlim.SProtSalExecute(Sender: TObject);
begin
  paAlimento.Visible := True;
  if (SProtNov.DataSource.DataSet.Fieldbyname('MedGr').asString = '') and
    (SProtNov.DataSource.DataSet.Fieldbyname('IDMEDCAS').asString <> '') then
  begin
    ShowMessage('Complete a quantidade da Medida Caseira');

  end
  else
  begin
    SProtNov.DataSource.DataSet.Post;
    paSP.Enabled := False;
  end;
end;

procedure TfmAlim.SCalNovExecute(Sender: TObject);
begin
  // Verifico se já tem algum cadastrado, se tiver eu travo
  if SCalNov.DataSource.DataSet.RecordCount = 1 then
  begin
    ShowMessage('Só está disponível o cadastramento de 1 único registro para Equivalentes de Energia.');
  end
  else
  begin
    SCalNov.DataSource.DataSet.Insert;
    Application.CreateForm(TfmEEWizard, fmEEWizard);
    fmEEWizard.ShowModal;
    fmEEWizard.Free;
    if DMSubsCalorico.SCEquiv <> '0' then
      lbEquiv.caption := DMSubsCalorico.SCEquiv
    else
      lbEquiv.caption := '';
  end;

end;

procedure TfmAlim.SCalEdiExecute(Sender: TObject);
begin
  {  paAlimento.Visible := False;
    SCalNov.DataSource.DataSet.Edit;
    paSubsCal.Enabled := True;
    dbGruSub.setfocus;
  }
  SCalNov.DataSource.DataSet.Edit;
  Application.CreateForm(TfmEEWizard, fmEEWizard);
  fmEEWizard.ShowModal;
  fmEEWizard.Free;
  if DMSubsCalorico.SCEquiv <> '0' then
    lbEquiv.caption := DMSubsCalorico.SCEquiv
  else
    lbEquiv.caption := '';

end;

procedure TfmAlim.SCalSalExecute(Sender: TObject);
begin
  paAlimento.Visible := True;
  if ((SCalNov.DataSource.DataSet.Fieldbyname('MedGr').asString = '') or
    (SCalNov.DataSource.DataSet.Fieldbyname('MedGr').asString = '0')) and
    (SCalNov.DataSource.DataSet.Fieldbyname('IDMEDCAS').asString <> '') then
  begin
    ShowMessage('Complete a quantidade da Medida Caseira');
  end
  else
  begin
    SCalNov.DataSource.DataSet.Post;
    paSubsCal.Enabled := False;
  end;
end;

procedure TfmAlim.ChecaGravacaoAlimExecute(Sender: TObject);
begin
  with DMAlimentos do
  begin
    if (TbAlimento.State = dsEdit) or (TbAlimento.State = dsInsert) then
      TbAlimento.Post;
    if (TbPreparac.State = dsEdit) or (TbPreparac.State = dsInsert) then
      TbPreparac.Post;
    if (TbPrecoAli.State = dsEdit) or (TbPrecoAli.State = dsInsert) then
      TbPrecoAli.Post;
  end;
  if (DMNutrientes.TbAliNut.State = dsEdit) or (DMNutrientes.TbAliNut.State = dsInsert) then
    DMNutrientes.TbAliNut.Post;
  if (DMedidas.TbMedidasCaseiras.State = dsEdit) or (DMedidas.TbMedidasCaseiras.State = dsInsert) then
    DMedidas.TbMedidasCaseiras.Post;
  with DMSubsCalorico do
  begin
    if (TbAliGCal.State = dsEdit) or (TbAliGCal.State = dsInsert) then
      TbAliGCal.Post;
    if (TbAliGProt.State = dsEdit) or (TbAliGProt.State = dsInsert) then
      TbAliGProt.Post;
  end;

end;

procedure TfmAlim.NutEdiExecute(Sender: TObject);
begin
  // cancelo primeiro qualquer estado do banco. Isso evita que o usuario clique duas vezes em inserir ou alterar.
  NutCanExecute(Sender);
  paAlimento.Visible := False;

  grNutVisao.SetFocus;

  // verifico se achei o determinado nutriente. Se for editar ou incluo e posiciono.
  // caso seja da USDA que mandamos, não deixamos alterar.
  if (DMAlimentos.TbAlimento.Fieldbyname('IDORIG').asString = '{B970DAE1-B505-11D1-B683-00001D13DDBD}') and
    (DMNutrientes.TbNutrientesbk.Fieldbyname('IDORIG').asString = '{B970DAE1-B505-11D1-B683-00001D13DDBD}') then
  begin
    ShowMessage('Os valores dos Nutrientes vindos da Tabela da USDA, não poderão ser alterados.');
    paAlimento.Visible := True;
  end
  else
  begin
    // so deixo alterar se nao for do grupo de Preparação
    if DMAlimentos.TbAlimento.Fieldbyname('IDGRUALI').asString = '{88DD9369-66F8-11D1-A6A0-008048B86BEE}' then
    begin
      ShowMessage('Nutrientes da Preparação/Receita são calculados pelo Programa');
      paAlimento.Visible := True;
    end
    else
    begin
      //grNut.Visible := True;
      paNut.Visible := True;
      if DMNutrientes.TbAliNut.Locate('IDALI;IDNUT', VarArrayOf([DMAlimentos.TbAlimento['IDALI'], DMNutrientes.TbNutrientesbk['IDNUT']]), []) then
      begin
        DMNutrientes.TbAliNut.Edit;
      end
      else
      begin
        DMNutrientes.TbAliNut.Insert;
        DMNutrientes.TbAliNut.FieldByName('IDALI').asString := DMAlimentos.TbAlimento.FieldByName('IDALI').asString;
        DMNutrientes.TbAliNut.FieldByName('IDNUT').asString := DMNutrientes.TbNutrientesbk.FieldByName('IDNUT').asString;
      end;
      // focando a alteracao
      teValorNut.SetFocus;
    end;
  end;
end;

procedure TfmAlim.AlimEdiExecute(Sender: TObject);
begin
  // esconde o link para o fenetizado.
  laFonet.Visible := False;

  paAlimento.Visible := False;
  // se o alimento for da USDA, não poderá ser alterado ...
  if AlimNov.DataSource.DataSet.FieldByName('IDORIG').asString = '{B970DAE1-B505-11D1-B683-00001D13DDBD}' then
  begin
    ShowMessage(' Alguns dados originários da Tabela USDA, não podem ser alterados. Somente serão liberados o Nome Simplificado e Observações. ');
    pnAli.Enabled := True;
    // trava os campos da usda que não podem ser alterados
    deNomeAli.Enabled := False;
    lcOrigem.Enabled := False;
    lcGrupo.Enabled := False;

    AlimNov.DataSource.DataSet.Edit;
    deNAliSimp.Setfocus;
  end
  else
  begin
    deNomeAli.Enabled := True;
    lcOrigem.Enabled := True;
    lcGrupo.Enabled := True;
    pnAli.Enabled := True;
    AlimNov.DataSource.DataSet.Edit;
    deNomeAli.Setfocus;
  end;

end;

procedure TfmAlim.AlimCanExecute(Sender: TObject);
begin
  if MessageDlg('Confirma o cancelamento dos dados ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    // esconde o link para o fonetizado.
    laFonet.Visible := False;

    paAlimento.Visible := True;
    AlimCan.DataSource.DataSet.Cancel;
    // ativo estas pastas
    teAliNutrientes.TabVisible := True;
    teAliMedidas.TabVisible := True;
    teAliPreco.TabVisible := True;

    // ativo estes campos
    deNomeAli.Enabled := True;
    lcOrigem.Enabled := True;
    lcGrupo.Enabled := True;

    pnAli.SetFocus;
    pnAli.Enabled := False;

    // Se está cancelando e veio pelo menu, deve retornar para lá
    if ChamadaPeloMenu = True then
      FecharExecute(Sender);

  end;
end;

procedure TfmAlim.MedCanExecute(Sender: TObject);
begin
  if MessageDlg('Confirma o cancelamento dos dados ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    paAlimento.Visible := True;
    MedCan.DataSource.DataSet.Cancel;
    paMed.Enabled := False;
  end;
end;

procedure TfmAlim.MedNovExecute(Sender: TObject);
begin
  paAlimento.Visible := False;
  paMed.Enabled := True;
  MedNov.DataSource.DataSet.Insert;
  lcMed.SetFocus;

end;

procedure TfmAlim.MedDelExecute(Sender: TObject);
begin
  if MessageDlg('Confirma a exclusão ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    paAlimento.Visible := True;
    paMed.Enabled := True;
    MedDel.DataSource.DataSet.Delete;
    DMedidas.TbMCOrdPad.Refresh;
    paMed.Enabled := False;
  end;

end;

procedure TfmAlim.MedEdiExecute(Sender: TObject);
begin
  // Se eu não puder alterar, já dou o aviso antes de mandar fazer ...
  if MedEdi.DataSource.DataSet.FieldByName('READONLY').asString = 'T' then
    ShowMessage('Esta informação não pode ser editada.')
  else
  begin
    paAlimento.Visible := False;
    paMed.Enabled := True;
    MedEdi.DataSource.DataSet.Edit;
    lcMed.SetFocus;
  end;

end;

procedure TfmAlim.MedSalExecute(Sender: TObject);
var
  CampoVazio: TField;

begin
  // devo sempre tirar o foco do campo. Em alguns casos dá erro quando utilizada a tecla de atalho.
  if pcAlimentos.ActivePage = teAliMedidas then
    sbSalMed.SetFocus;

  // Em primeiro lugar, devo tirar o foco do campo, pois quando salvo com tecla de atalho,
  // e tento editar, o sistema diz que não dá para focar em janela desabilitada
  teAliMedidas.SetFocus;

  // Não está conseguindo controlar o campo de lookup através do InvalidRequiredField
  // Foi feita uma checagem manual.

  if lcMed.Value = '1' then
    // Se a medida for 1 é porque não foi selecionada nenhuma medida ainda.
    // Peço para selecionar, antes de gravar
  begin
    ShowMessage('Selecione uma Medida Caseira.');
    lcMed.SetFocus;
  end
  else
  begin
    CampoVazio := InvalidRequiredField(MedSal.DataSource.DataSet);
    if CampoVazio = nil then
    try
      begin
        paAlimento.Visible := True;
        MedSal.DataSource.DataSet.Post;
        DMedidas.qrMedCIndexada.DataSource.DataSet.Refresh;
        //paMed.SetFocus;
        paMed.Enabled := False;
      end;
    except
      on E: EDatabaseError do
      begin
        raise
      end
    end;
  end;

end;

procedure TfmAlim.NutCanExecute(Sender: TObject);
begin
  //   if MessageDlg('Confirma o cancelamento dos dados ? ', mtConfirmation,
  //      [mbYes, mbNo], 0) = mrYes then
  //   begin
  paAlimento.Visible := True;
  paNut.Visible := False;
  DMNutrientes.TbAliNut.Cancel;
  DMNutrientes.TbNutrientesbk.Refresh;
  //   end;
end;

procedure TfmAlim.NutDelExecute(Sender: TObject);
var
  Cod: string;
begin
  if MessageDlg('Confirma a exclusão ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    // Não apago se for da USDA, de modo algum
    if (DMAlimentos.TbAlimento.Fieldbyname('IDORIG').asString = '{B970DAE1-B505-11D1-B683-00001D13DDBD}') then
      ShowMessage('Os Nutrientes da USDA não podem ser excluídos.')

    else
    begin
      paAlimento.Visible := True;
      paNut.Visible := False;
      //localizo  o registro em AliNut. Caso tenha, deve deletar
      if DMNutrientes.TbAliNut.Locate('IDALI;IDNUT', VarArrayOf([DMAlimentos.TbAlimento['IDALI'], DMNutrientes.TbNutrientesbk['IDNUT']]), []) then
      begin
        Cod := DMNutrientes.TbAliNut.FieldByName('IDNUT').asString;
        DMNutrientes.TbAliNut.Delete;
      end
      else
        DMNutrientes.TbAliNut.Cancel;

      //Vejo se está sendo apagado Energia ou Proteina, caso seja, devo alterar a pasta.
      if (Cod = '{B01C0044-AEE3-11D2-B4C0-00609723104C}') or
        (Cod = '{B01C0040-AEE3-11D2-B4C0-00609723104C}') then
      begin
        ConfAlimSubsCal;
        ConfAlimSubsProt;
      end;
      DMNutrientes.TbNutrientesbk.Refresh;
    end;
  end;
end;

procedure TfmAlim.btMudaOrdClick(Sender: TObject);
begin

  DMedidas.TbMCOrdPad.DisableControls;
  Application.CreateForm(TfmMedCasOrdem, fmMedCasOrdem);
  fmMedCasOrdem.ShowModal;
  fmMedCasOrdem.Free;
  DMedidas.TbMCOrdPad.EnableControls;

end;

procedure TfmAlim.grNutVisaoGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  if Field.DataSet.FieldByName('IDORIG').asString <> '{B970DAE1-B505-11D1-B683-00001D13DDBD}' then
  begin
    AFont.Color := clBlue;
  end;
end;

procedure TfmAlim.teAliPreparacaoShow(Sender: TObject);
begin
  //fmCalcNutr.ShowPreview;
end;

procedure TfmAlim.AlimDelExecute(Sender: TObject);
begin
  if MessageDlg('Confirma a exclusão ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then

  begin
    // caso seja um alimento da USDA, não deixo apagar de maneira alguma
    if (DMAlimentos.TbAlimento.Fieldbyname('IDORIG').asString = '{B970DAE1-B505-11D1-B683-00001D13DDBD}') then
      ShowMessage('Os alimentos da USDA não podem ser excluídos.')
    else

    begin
      // esconde o link para o fonetizado.
      laFonet.Visible := False;
      paAlimento.Visible := True;

      // ativo estes campos
      deNomeAli.Enabled := True;
      lcOrigem.Enabled := True;
      lcGrupo.Enabled := True;

      AlimCan.DataSource.DataSet.Delete;
      pnAli.Enabled := False;
      lbEquiv.Caption := '';
      {** Jair e Wagner é preciso fechar aqui pois não pode ir para um novo registro
      Esperasse que saindo, destrave o registro preso pra deletar }
      FecharExecute(Sender);
      //#         LocALimExecute(Sender);
    end;

  end;

end;

//### EVENTOS ############################################################

procedure TfmAlim.DefineKeys(Sender: TObject; Dataset: TDataSet);
var
  mdData: TMedida;
begin
  if not dmMotherBoard.DBIOController.Calculo.Memoria.Acha('mdDataCalc', TObject(mdData)) then
    Exit;
  DataSet.FieldByName('IDALI').asString := DMAlimentos.dsAlimento.DataSet.FieldByName('IDALI').AsString;
  DataSet.FieldByName('DATA').asDateTime := StrToDateTime(mdData.ValorNumerico);
end;

procedure TfmAlim.AfterDefineCalcPreparacao(Sender: TObject);
begin
  dmMotherBoard.DBIOController.DataSource := DMAlimentos.DSPreparac;
  dmMotherBoard.ProcessadorAtual := cvVideo.AntropButtons[ncPreparacao].Processador;
end;

procedure TfmAlim.cvVideoAfterWizardTerminate(Sender: TObject);
var
  Temp: Boolean;
begin
  with dmMotherBoard do
  begin
    cnDBSalvar.ExecuteTarget(self);
    cnDBSalvar.UpdateTarget(self);
    with CalcPreparacao do
    begin
      Temp := MostraTodosNutrientes;
      MostraTodosNutrientes := True;
      Ativar.TotalNutrientes := True;
      Ativar.PorcentagemNutrientesValidos := True;
      TotalNutrientes.DataSet.First;
      while not TotalNutrientes.DataSet.Eof do
      begin
        if (TotalNutrientes.DataSet.FieldByName('NUTVALIDOCALC').AsFloat > 0) then
        begin
          if not DMNutrientes.TbAliNut.Locate('IDALI;IDNUT',
            VarArrayOf([DMAlimentos.TbAlimento.FieldByName('IDALI').AsString,
            TotalNutrientes.DataSet.FieldByName('IDNUT').AsString]), []) then

          begin
            DMNutrientes.TbAliNut.Append;
            DMNutrientes.TbAliNut.FieldByName('IDALI').AsString := DMAlimentos.TbAlimento.FieldByName('IDALI').AsString;
            DMNutrientes.TbAliNut.FieldByName('IDNUT').AsString := TotalNutrientes.DataSet.FieldByName('IDNUT').AsString;
          end
          else
            DMNutrientes.TbAliNut.Edit;
          DMNutrientes.TbAliNut.FieldByName('VALOR').AsFloat := TotalNutrientes.DataSet.FieldByName('VALORTOT').AsFloat * 100 / PesoFinal.AsFloat;
          DMNutrientes.TbAliNut.Post;
        end;
        TotalNutrientes.DataSet.Next;
      end;
      Ativar.PorcentagemNutrientesValidos := False;
      Ativar.TotalNutrientes := False;
      MostraTodosNutrientes := Temp;
    end;
  end;
end;

procedure TfmAlim.ntDataCalculoNavChange(Sender: TObject);
begin
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self);
  dmMotherBoard.cnDBAbrir.UpdateTarget(self);
end;

// BOTOES DE NAVEGACAO DA PESSOA ===============================================

procedure TfmAlim.bbAnteriorClick(Sender: TObject);
begin
  DMAlimentos.dsAlimento.DataSet.Prior;
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self);
  dmMotherBoard.cnDBAbrir.UpdateTarget(self);
end;

procedure TfmAlim.bbProximoClick(Sender: TObject);
begin
  DMAlimentos.dsAlimento.DataSet.Next;
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self);
  dmMotherBoard.cnDBAbrir.UpdateTarget(self);
end;

procedure TfmAlim.bbInicioClick(Sender: TObject);
begin
  DMAlimentos.dsAlimento.DataSet.First;
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self);
  dmMotherBoard.cnDBAbrir.UpdateTarget(self);
end;

procedure TfmAlim.bbUltimoClick(Sender: TObject);
begin
  DMAlimentos.dsAlimento.DataSet.Last;
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self);
  dmMotherBoard.cnDBAbrir.UpdateTarget(self);
end;

procedure TfmAlim.teCalculosShow(Sender: TObject);
begin
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self);
  dmMotherBoard.cnDBAbrir.UpdateTarget(self);
end;

//###############################################################

procedure TfmAlim.teValorNutKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = CHR(VK_RETURN)) then // se for dado um <enter>
  begin
    grNutVisao.SetFocus;
    // estamos usando o componente Keynav que controla os <enters>. Para que ele sete o foco manualmente,
    // devemos anular o enter.
    key := #0;
  end;
end;

procedure TfmAlim.grNutVisaoKeyPress(Sender: TObject; var Key: Char);
begin

  //   Verifico se foi pressionado qualquer numero de 0 a 9 ou <enter>. Entra automaticamente na edição.
  if (Key = chr(48)) or (Key = chr(49)) or (Key = chr(50)) or (Key = chr(51)) or
    (Key = chr(52)) or (Key = chr(53)) or (Key = chr(54)) or (Key = chr(55)) or
    (Key = chr(56)) or (Key = chr(57)) or (key = CHR(VK_RETURN)) then
    NutEdiExecute(Sender); // entra na edição ou inclusão
end;

procedure TfmAlim.btOrdNutClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  grNutVisao.DisableScroll;
  Application.CreateForm(TfmOpcoesAlimentos, fmOpcoesAlimentos);
  Screen.Cursor := crDefault;
  fmOpcoesAlimentos.ShowModal;
  fmOpcoesAlimentos.Free;
  grNutVisao.EnableScroll;

end;

procedure TfmAlim.ChavePressionada(Sender: TObject; var Key: Char);
begin
  if key = CHR(VK_RETURN) then
  begin
    key := #0;
    if (Sender is TDBGrid) then
      TDBGrid(Sender).Perform(WM_KeyDown, VK_Tab, 0)
    else
      Perform(Wm_NextDlgCtl, 0, 0);
  end;
end;

procedure TfmAlim.deNomeAliKeyPress(Sender: TObject; var Key: Char);
begin
  // ChavePressionada( Sender, key );
end;

procedure TfmAlim.deObsAliExit(Sender: TObject);
begin
  // temporariamente vou desativar este codigo porque nao esta dando certo salvar automaticamente
  // no <enter>. Não consigo usar o enter, porque o inform builder e o componente que controla
  // teclas não deixa que eu capte.

   {if (DMAlimentos.TbAlimento.State = dsInsert) or (DMAlimentos.TbAlimento.State = dsEdit) then
     begin
       if MessageDlg('Deseja salvar seus dados ?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            begin
              AlimSalExecute(Sender);
              // Verifico se salvou mesmo o banco ... Estava dando erro, pois se acontecesse algum problema
              // na gravação, ele acabava posicionando no lugar errado.
              if  (DMAlimentos.TbAlimento.State <> dsInsert) and
                  (DMAlimentos.TbAlimento.State <> dsEdit) then
                  begin
                  // Se for preparacao, posicione na orelhinha de preparacao, senao em nutriente
}//                    if DMAlimentos.TbAlimento.fieldbyname('IDGRUALI').asString <> '{88DD9369-66F8-11D1-A6A0-008048B86BEE}' then
{                      begin
                       pcAlimentos.ActivePage := teAliNutrientes ;
                       MostraBotoesAlim;  // Sincroniza os botoes.
                       grNutVisao.SetFocus;
                      end
                   else // se for preparação
                       begin
                       pcAlimentos.ActivePage := teAliPreparacao ;
                       MostraBotoesAlim;  // Sincroniza os botoes.
                      end;
                  end;
            end
       else
         deNomeAli.SetFocus;
       end;
}
end;

procedure TfmAlim.teAliNutrientesEnter(Sender: TObject);
begin
  fm_MenuNut.KeyPreview := False;
end;

procedure TfmAlim.teAliNutrientesExit(Sender: TObject);
begin
  fm_MenuNut.KeyPreview := True;
end;

procedure TfmAlim.teValorNutExit(Sender: TObject);
begin

  if teValorNut.Text = '' then // se eu tiver tentando salvar em branco é porque quero excluir o valor.
  begin
    if (DMNutrientes.TbAliNut.state = dsInsert) then
      NutCanExecute(Sender) //  na inserção, se eu cancelar já resolvo.
    else if (DMNutrientes.TbAliNut.state = dsEdit) then
    begin
      NutCanExecute(Sender); // para apagar na edição, devo primeiro cancelar e
      NutDelExecute(Sender); // depois deletar.
    end;
  end
  else // caso contrário devo somente salvar
    NutSalExecute(Sender); // salva

  grNutVisao.SetFocus;
  DMNutrientes.TbNutrientesbk.Next;

end;

procedure TfmAlim.PrecoNovExecute(Sender: TObject);
begin
  paAlimento.Visible := False;
  pnPreco.Enabled := True;
  //fnGramas.SetFocus;
  if DMAlimentos.TbPrecoAli.RecordCount = 1 then
  begin
    ShowMessage('Só está disponível o cadastramento de 1 único registro para Preço');
    paAlimento.Visible := True;
    pnPreco.Enabled := False;
  end
  else
  begin
    DMAlimentos.TbPrecoAli.Insert;
    if paGr.Enabled = True then
      fnGramas.SetFocus
    else
      fnPreco.SetFocus;
  end;
end;

procedure TfmAlim.PrecoEdiExecute(Sender: TObject);
begin
  paAlimento.Visible := False;
  pnPreco.Enabled := True;
  DMALimentos.TbPrecoAli.Edit;

end;

procedure TfmAlim.PrecoSalExecute(Sender: TObject);
var
  CampoVazio: TField;
begin
  // devo sempre tirar o foco do campo. Em alguns casos dá erro quando utilizada a tecla de atalho.
  if pcAlimentos.ActivePage = teAliPreco then
    sbSalPreco.SetFocus;

  CampoVazio := InvalidRequiredField(DMAlimentos.TbPrecoAli);
  if CampoVazio = nil then
  try
    begin
      // caso tenha med. caseira, devo completar a quantidade
      if (DMAlimentos.TbPrecoAli.Fieldbyname('IDMEDCAS').asString <> '') and
        (DMAlimentos.TbPrecoAli.Fieldbyname('QTDE').asFloat = StrtoFloat('0,00')) then
        ShowMessage('Complete o campo Quantidade antes de salvar.')

        // caso tenha quantidade, devo ter medida caseira tambem.
      else if (DMAlimentos.TbPrecoAli.Fieldbyname('IDMEDCAS').asString = '') and
        (DMAlimentos.TbPrecoAli.Fieldbyname('QTDE').asFloat <> StrtoFloat('0,00')) then
        ShowMessage('Complete o campo Medida Caseira antes de salvar.')
      else
      begin
        paAlimento.Visible := True;
        DMAlimentos.TbPrecoAli.Post;
        pnPreco.Enabled := False;
      end;
    end;
  except
    on E: EDatabaseError do
    begin
      raise
    end;
  end;
  ConfAlimPreco;

end;

procedure TfmAlim.PrecoDelExecute(Sender: TObject);
begin
  if MessageDlg('Confirma a exclusão ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    paAlimento.Visible := True;
    DMAlimentos.TbPrecoAli.Delete;
    pnPreco.Enabled := False;
    ConfAlimPreco;
  end;

end;

procedure TfmAlim.PrecoCanExecute(Sender: TObject);
begin
  if MessageDlg('Confirma o cancelamento dos dados ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    paAlimento.Visible := True;
    DMAlimentos.TbPrecoAli.Cancel;
    pnPreco.Enabled := False;
    ConfAlimPreco;
  end;
end;

procedure TfmAlim.SCalDelExecute(Sender: TObject);
begin
  if MessageDlg('Confirma a exclusão ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    paAlimento.Visible := True;
    DMSubsCalorico.TbAliGCal.Delete;
    if DMSubsCalorico.SCEquiv <> '0' then
      lbEquiv.caption := DMSubsCalorico.SCEquiv
    else
      lbEquiv.caption := '';
  end;
end;

procedure TfmAlim.SProtDelExecute(Sender: TObject);
begin
  if MessageDlg('Confirma a exclusão ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    paAlimento.Visible := True;
    DMSubsCalorico.TbAliGProt.Delete;
    if DMSubsCalorico.SPEquiv <> '0' then
      lbEquivProt.caption := DMSubsCalorico.SPEquiv
    else
      lbEquivProt.caption := '';
  end;

end;

procedure TfmAlim.SCalCanExecute(Sender: TObject);
begin
  if MessageDlg('Confirma o cancelamento dos dados ? ', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    paAlimento.Visible := True;
    DMSubsCalorico.TbAliGCal.Cancel;
    if DMSubsCalorico.SCEquiv <> '0' then
      lbEquiv.caption := DMSubsCalorico.SCEquiv
    else
      lbEquiv.caption := '';
  end;

end;

procedure TfmAlim.deNomeAliExit(Sender: TObject);
var
  stFonetAlim: string;

begin

  // checo na saida do campo alimento se tem ou nao tem semelhante ...
  if DMAlimentos.TbAlimento.State = dsInsert then
  begin
    stFonetAlim := deNomeAli.Text;
    DMAlimentos.qrFonetAlim.Active := False;
    DMAlimentos.qrFonetAlim.Params[0].AsString := stFonetAlim;
    DMAlimentos.qrFonetAlim.Active := True;

    if DMAlimentos.qrFonetAlim.RecordCount <> 0 then
      // ativo o label com o acesso aos semelhantes
      laFonet.Visible := True
    else
      laFonet.Visible := False;

  end;

end;

procedure TfmAlim.lcMed2CloseUp(Sender: TObject);
begin
  deValor.SetFocus;
end;

procedure TfmAlim.grNutVisaoDblClick(Sender: TObject);
begin
  NutEdiExecute(Sender); // entra na edição ou inclusão
end;

procedure TfmAlim.teValorNutDblClick(Sender: TObject);
begin
  grNutVisao.SetFocus;
end;

procedure TfmAlim.AlimProxExecute(Sender: TObject);
begin

  // caso esteja na pasta de preparação, devo passar para indivíduos, pois fica mais rápido
  if pcAlimentos.ActivePage = teAliPreparacao then
    pcAlimentos.ActivePage := teDadosAli;
  MostraBotoesAlim; // Sincroniza os botoes.

    DMAlimentos.TbAlimento.Next;
    if not (DMAlimentos.TbAlimento.Eof) then
    begin
      dmSemaforo.LiberaRecurso(FRecurso);
      if not (dmSemaforo.TravaRecurso(DMAlimentos.TbAlimento.FieldByName('IDALI').AsString, copy('Alimento: ' +
              DMAlimentos.TbAlimento.FieldByName('NOME').AsString, 1, 50))) then
         begin
            pcBotAlim.Visible := False;
            FRecurso := '';
         end
         else
         begin
            FRecurso := DMAlimentos.TbAlimento.FieldByName('IDALI').AsString;
            pcBotAlim.Visible := True;
         end;
    end;

  MostraBotoesAlim; // Sincroniza os botoes.
  if pcAlimentos.ActivePage = teAliPreco then
    ConfAlimPreco;

  // mudou de alimento, tem que configurar
  ConfAlimPreparacao;
  ConfAlimSubsCal;
  ConfAlimSubsProt;
  DmNutrientes.TbNutrientesbk.Refresh;
  DMedidas.TbMedidasCaseiras.Locate('IDALI;IDMEDCAS', VarArrayOf([DMAlimentos.TbAlimento['IDALI'], DMedidas.qrMedCIndexada['IDMEDCAS']]), []);
  DMSubsCalorico.TbGruCal.Refresh;

end;

procedure TfmAlim.AlimAntExecute(Sender: TObject);
begin

  if pcAlimentos.ActivePage = teAliPreparacao then
    pcAlimentos.ActivePage := teDadosAli;
  MostraBotoesAlim; // Sincroniza os botoes.

    DMAlimentos.TbAlimento.Prior;
    if not (DMAlimentos.TbAlimento.Bof) then
    begin
      dmSemaforo.LiberaRecurso(FRecurso);
      if not (dmSemaforo.TravaRecurso(DMAlimentos.TbAlimento.FieldByName('IDALI').AsString, copy('Alimento: ' +
              DMAlimentos.TbAlimento.FieldByName('NOME').AsString, 1, 50))) then
         begin
            pcBotAlim.Visible := False;
            FRecurso := '';
         end
         else
         begin
            FRecurso := DMAlimentos.TbAlimento.FieldByName('IDALI').AsString;
            pcBotAlim.Visible := True;
         end;
    end;

  MostraBotoesAlim; // Sincroniza os botoes.
  if pcAlimentos.ActivePage = teAliPreco then
    ConfAlimPreco;

  // mudou de alimento, tem que configurar
  ConfAlimPreparacao;
  ConfAlimSubsCal;
  ConfAlimSubsProt;
  DmNutrientes.TbNutrientesbk.Refresh;
  DMedidas.TbMedidasCaseiras.Locate('IDALI;IDMEDCAS', VarArrayOf([DMAlimentos.TbAlimento['IDALI'], DMedidas.qrMedCIndexada['IDMEDCAS']]), []);
  DMSubsCalorico.TbGruCal.Refresh;

end;

procedure TfmAlim.deValorExit(Sender: TObject);
begin
  {  if (DMedidas.TbMedidasCaseiras.State = dsInsert) or (DMedidas.TbMedidasCaseiras.State = dsEdit) then
       begin
        if MessageDlg('Deseja salvar seus dados ? ',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            begin
             MedSalExecute(Sender);
             sbNovMed.SetFocus;
            end
         else
            begin
             grMCas.SetFocus;
             MedCanExecute( Sender);
            end;
       end;
   }
  sbSalMed.SetFocus;

end;

procedure TfmAlim.lcMedCloseUp(Sender: TObject);
begin
  if lcMed.Text = 'Nova Medida' then
  begin
    lcMed.Visible := False;
    edMedida.Visible := True;
    edMedida.Text := '';
    edMedida.SetFocus;
  end;

end;

procedure TfmAlim.acRelatoriosExecute(Sender: TObject);
begin
  BeforeCalcularPreparacao(Sender);
  dmMotherBoard.Imprimir;
end;

procedure TfmAlim.acRelatoriosUpdate(Sender: TObject);
begin
  btRelatorios.Enabled := not (dmMotherBoard.CalcNut.Empty) and
    not (cvVideo.Calculando);
end;

procedure TfmAlim.teAliMedidasExit(Sender: TObject);
begin
  // quando saio das pastinhas, devo sempre deixar a lista de Alterar a ordem das medidas desabilitada.
 { if miMedCas.Visible = True then
     begin
      pcAlimentos.ActivePage := teAliMedidas;
      ShowMessage('Salve ou Cancele as alterações.');
     end;}
end;

procedure TfmAlim.BeforeCalcularPreparacao(Sender: TObject);
begin
  if dmMotherBoard.CalcPreparacao.DescricaoCalculo = nil then
    exit;
  with dmMotherBoard.CalcPreparacao.DescricaoCalculo do
  begin
    ReadOnly := False;
    ValorNumerico := DMAlimentos.TbAlimento.FieldByName('NOME').AsString;
    ReadOnly := True;
  end;

end;

procedure TfmAlim.laFonetClick(Sender: TObject);
begin
  // Traz a tela de fonetização

  Application.CreateForm(TfmFonetAlim, fmFonetAlim);
  fmFonetAlim.ShowModal;
  fmFonetAlim.Free;
  deNAliSimp.SetFocus;

end;

procedure TfmAlim.ErroAdicionarSelf(Sender: TObject);
begin
  ShowMessage('A preparação não pode ser adicionada a ela mesma!');
end;

procedure TfmAlim.fnQtdeExit(Sender: TObject);
begin
  DMAlimentos.TbPrecoAli.Fieldbyname('QTDE').asFloat := fnQtde.Value;
  if DMAlimentos.TbPrecoAli.Fieldbyname('IDMEDCAS').asString <> '' then
  begin
    if (DMAlimentos.TbPrecoAli.State <> dsEdit) or
      (DMAlimentos.TbPrecoAli.State <> dsInsert) then
      DMAlimentos.TbPrecoAli.Edit;
    DMAlimentos.TbPrecoAli.Fieldbyname('MEDGR').asString := FloattoStr(
      (DMAlimentos.TbMCPreco.Fieldbyname('VALOR').asFloat * DMAlimentos.TbPrecoAli.Fieldbyname('QTDE').asFloat));
  end;
end;

procedure TfmAlim.fnGramasExit(Sender: TObject);
begin
  DMAlimentos.TbPrecoAli.Fieldbyname('MEDGR').asFloat := fnGramas.Value;
end;

procedure TfmAlim.fnGramasClick(Sender: TObject);
begin
  // caso tenha uma medida caseira cadastrada, devo apaga-la e sua unidade.
  if DMAlimentos.TbPrecoAliIDMEDCAS.asString <> '' then
  begin
    if MessageDlg('A Quantidade e Medida serão excluídas.',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      DMAlimentos.TbPrecoAli.Edit;
      DMAlimentos.TbPrecoAliIDMEDCAS.asString := '';
      DMAlimentos.TbPrecoAliQTDE.asFloat := 0;
      fnGramas.SetFocus;
    end;

  end;
end;

procedure TfmAlim.fnPrecoExit(Sender: TObject);
begin
  DMAlimentos.TbPrecoAli.Fieldbyname('PRECO').asFloat := fnPreco.Value;
end;

procedure TfmAlim.lcOrigemCloseUp(Sender: TObject);
begin
  // Controlar inclusao de nova Origem

  if lcOrigem.Text = 'Nova Origem' then
  begin
    lcOrigem.Visible := False;
    edOrigem.Visible := True;
    edOrigem.Text := '';
    edOrigem.SetFocus;
  end;

  // Libera o banco origem para aparecer a USDA
  DMAlimentos.TbOrigem.Filtered := False;

end;

procedure TfmAlim.edOrigemExit(Sender: TObject);
begin
  edOrigem.Visible := False;
  lcOrigem.Visible := True;

  // se nao achar a origem, grava uma nova
  if edOrigem.Text = '' then
  begin
    DMAlimentos.TbAlimento.Edit;
    DMAlimentos.TbAlimento.Fieldbyname('IDORIG').asString := '';
  end
  else
  begin
    if not DMAlimentos.TbOrigem.Locate('DESCRICAO', edOrigem.Text, [loCaseInsensitive]) then
    begin
      try
        DMAlimentos.TbOrigem.Insert;
        DMAlimentos.TbOrigem.Fieldbyname('DESCRICAO').asString := edOrigem.Text;
        DMAlimentos.TbOrigem.Post;
      except
        on Exception do
          ShowMessage('Erro na Inserção!!');
      end;
    end;

    // se achei a origem, ela já estando cadastrada ...
    DMAlimentos.TbAlimento.Edit;
    DMAlimentos.TbAlimento.Fieldbyname('IDORIG').asString := DMAlimentos.TbOrigem.Fieldbyname('IDORIG').asString;

  end;

end;

procedure TfmAlim.lcOrigemEnter(Sender: TObject);
begin
  // Filtra o banco origem para nao aparecer a USDA
  DMAlimentos.TbOrigem.Filtered := True;
end;

procedure TfmAlim.edMedidaExit(Sender: TObject);
begin
  edMedida.Visible := False;
  lcMed.Visible := True;

  // se nao achar a medida, grava uma nova
  if edMedida.Text = '' then
  begin
    DMedidas.TbMedidasCaseiras.Edit;
    DMedidas.TbMedidasCaseiras.Fieldbyname('IDMEDCAS').asString := '';
  end
  else
  begin
    edMedida.Text := UpperCase(Copy(edMedida.Text, 1, 1)) + LowerCase(Copy(edMedida.Text, 2, Length(edMedida.Text)));
    if not DMedidas.TbMedidas.Locate('MEDIDA', edMedida.Text, [loCaseInsensitive]) then
    begin
      try
        DMedidas.TbMedidas.Insert;
        DMedidas.TbMedidas.Fieldbyname('MEDIDA').asString := edMedida.Text;
        DMedidas.TbMedidas.Post;
      except
        on Exception do
          ShowMessage('Erro na Inserção!!');
      end;
    end;

    // se achei a medida, ela já estando cadastrada ...
    DMedidas.TbMedidasCaseiras.Edit;
    DMedidas.TbMedidasCaseiras.Fieldbyname('IDMEDCAS').asString := DMedidas.TbMedidas.Fieldbyname('IDMEDCAS').asString;

  end;
end;

procedure TfmAlim.LocALimExecute(Sender: TObject);
var
  fmLocAlimento: TfmLocAlim;
  SalvaCursor: TCursor;
begin
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }

  fmLocAlimento := TFmLocAlim.Create(self);
  fmLocAlimento.ShowModal;

  if fmLocAlimento.ModalResult = mrOk then
  begin
    if not DMAlimentos.TbAlimento.Locate('IDALI', dmMotherBoard.AlimentoCorrente.IDAlimento, []) then
      // se não achou o correspondente é porque está vazio, então eu devo entrar direto em modo de inclusão
      ShowMessage('Banco de Dados vazio !! Cadastre um alimento.');
  end;
  //#  else if fmLocAlimento.ModalResult = mrCancel then
  //#          Fechar.OnExecute(sender);

  Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  fmLocAlimento.Free;
end;

procedure TfmAlim.FecharExecute(Sender: TObject);
begin
  //###############################################3
  if dmMotherBoard.DBIOController.Fechar then
    //###############################################3
  begin
    (**
    Jair - Limpa recurso da tabela
    assim não fica preso para essa aplicação
    **)
    dmSemaforo.LiberaRecurso(FRecurso);
    FRecurso := '';
    Close;
  end;
end;

end.


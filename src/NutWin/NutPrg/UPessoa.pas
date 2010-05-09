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




unit UPessoa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, Tabs, Buttons, Grids, DBGrids, Mask, ComCtrls,
  ExtCtrls, ExtDlgs, OleCtnrs, Menus, DBMyNav, NavTable, db, dbTables,
  UDIdade, jpeg, Pessoa, clipbrd,
  DBActns, ActnList, RlAntr01, Measurement, Idade, Memoria, NutCnst,
  AlmaHumana, ToolWin, CalculoViewer, Boxes, BxRichTB, CCSFonetizar,
  CCSListaLinks, CCSAbreviar, RXLookup, DBListView98, CalculoTextViewer;

type
  TfmPessoa = class(TForm)
    paIndividuo: TPanel;
    pcPessoa: TPageControl;
    tsEndereco: TTabSheet;
    beEndereco: TBevel;
    tbsConsulta: TTabSheet;
    tsAnam: TTabSet;
    tbsPessoal: TTabSheet;
    dlgAbreFoto: TOpenPictureDialog;
    dbPess: TDBMyNav;
    ntAnam: TNavTable;
    reAnam: TDBRichEdit;
    puTabPess: TPopupMenu;
    Tabelas: TMenuItem;
    puPess: TPopupMenu;
    Incluir1: TMenuItem;
    Excluir1: TMenuItem;
    Incluir2: TMenuItem;
    diPess: TDataIdade;
    dbAnamnese: TDBMyNav;
    gbNovo: TGroupBox;
    laDataAnam: TLabel;
    btAnamModelo: TButton;
    reAnamEdicao: TDBRichEdit;
    deData: TDBEdit;
    pgcBotoes: TPageControl;
    tbsPessoa: TTabSheet;
    btNavNova: TBitBtn;
    btNavCancela: TBitBtn;
    btNavExcluir: TBitBtn;
    tbsAnamnese: TTabSheet;
    btAnamNov: TBitBtn;
    btAnExcluir: TBitBtn;
    bbCAD: TBitBtn;
    tbsMetas: TTabSheet;
    bbIns: TBitBtn;
    bbAlt: TBitBtn;
    bbDel: TBitBtn;
    tbsAntrop: TTabSheet;
    btAntropNov: TBitBtn;
    btAntropEdi: TBitBtn;
    btAntropDel: TBitBtn;
    tbsInquerito: TTabSheet;
    btInqNov: TBitBtn;
    btInqAlt: TBitBtn;
    btInqExc: TBitBtn;
    tbsDieta: TTabSheet;
    btDieNov: TBitBtn;
    btDieAlt: TBitBtn;
    btDieExc: TBitBtn;
    teExames: TTabSheet;
    gbExa: TGroupBox;
    Label4: TLabel;
    btModExame: TButton;
    deModExa: TDBRichEdit;
    deDataExa: TDBEdit;
    reExaEdicao: TDBRichEdit;
    tsExame: TTabSet;
    nvExame: TDBMyNav;
    tbsExames: TTabSheet;
    btExNova: TBitBtn;
    btExAltera: TBitBtn;
    btExExclui: TBitBtn;
    alPessoa: TActionList;
    PessCanc: TDataSetCancel;
    PessDel: TDataSetDelete;
    PessNov: TDataSetInsert;
    AnamDel: TDataSetDelete;
    AnamNov: TDataSetInsert;
    AnamEdi: TDataSetEdit;
    AntropDel: TDataSetDelete;
    AntropEdi: TDataSetEdit;
    AntropNov: TDataSetInsert;
    InqDel: TDataSetDelete;
    InqEdi: TDataSetEdit;
    InqNov: TDataSetInsert;
    DietaDel: TDataSetDelete;
    DietaEdi: TDataSetEdit;
    DietaNov: TDataSetInsert;
    MetasDel: TDataSetDelete;
    MetasEdi: TDataSetEdit;
    MetasNov: TDataSetInsert;
    ExaDel: TDataSetDelete;
    ExaEdi: TDataSetEdit;
    ExaNov: TDataSetInsert;
    PessProximo: TDataSetNext;
    btPessSal: TBitBtn;
    PessSal: TDataSetPost;
    PessAnterior: TDataSetPrior;
    ChecaGravacaoPessoa: TAction;
    teAntropometria: TTabSheet;
    tbsEndereco: TTabSheet;
    ntDataAntropometria: TNavTable;
    tsAntropometria: TTabSet;
    ntExame: TNavTable;
    cnAbreviar: TCCSAbreviar;
    cnFon: TCCSFonetizar;
    btGraficos: TBitBtn;
    acGrafAcomp: TAction;
    btEndCan: TBitBtn;
    btEndExc: TBitBtn;
    btEndSal: TBitBtn;
    EndCan: TDataSetCancel;
    EndDel: TDataSetDelete;
    EndSal: TDataSetPost;
    btPessAlt: TBitBtn;
    PessEdi: TDataSetEdit;
    btEndAlt: TBitBtn;
    EndEdi: TDataSetEdit;
    paDPess: TPanel;
    dmObs: TDBMemo;
    laObservacao: TLabel;
    diFoto: TDBImage;
    deNomeMae: TDBEdit;
    laResp: TLabel;
    deDataNasc: TDBEdit;
    _btAlteraDataNasc: TButton;
    laDtnasc: TLabel;
    deNome: TDBEdit;
    laNomePess: TLabel;
    laSobrPess: TLabel;
    deSobrenome: TDBEdit;
    laAno: TLabel;
    laMeses: TLabel;
    laDia: TLabel;
    laSexo: TLabel;
    deDias: TDBEdit;
    deMeses: TDBEdit;
    deAnos: TDBEdit;
    laSobrMae: TLabel;
    deSobrMae: TDBEdit;
    deAtual: TDBEdit;
    laUltAtual: TLabel;
    laNac: TLabel;
    laNatural: TLabel;
    laCor: TLabel;
    deReg: TDBEdit;
    laRegistro: TLabel;
    paEnder: TPanel;
    laEndereco: TLabel;
    deEndereco: TDBEdit;
    laNumero: TLabel;
    deNumero: TDBEdit;
    laBairro: TLabel;
    deBairro: TDBEdit;
    deCompl: TDBEdit;
    laCompl: TLabel;
    laCidade: TLabel;
    deCep: TDBEdit;
    laCep: TLabel;
    laemail: TLabel;
    deEMail: TDBEdit;
    gbTelefones: TGroupBox;
    grTelefones: TDBGrid;
    ntFone: TDBMyNav;
    ahAlmaIndividuo: TAlmaHumana;
    AnamCan: TDataSetCancel;
    AnamSal: TDataSetPost;
    bbAnamSal: TBitBtn;
    bbAnamCan: TBitBtn;
    ExaSal: TDataSetPost;
    ExaCanc: TDataSetCancel;
    btExSal: TBitBtn;
    btExCanc: TBitBtn;
    deNomeCompleto: TDBText;
    laFoto: TLabel;
    lcSexo: TRxDBLookupCombo;
    lcCor: TRxDBLookupCombo;
    lcNatural: TRxDBLookupCombo;
    lcNacional: TRxDBLookupCombo;
    btRelatoriosAntropometria: TBitBtn;
    acRelatorios: TAction;
    edNatural: TEdit;
    edCidade: TEdit;
    lcCidade: TRxDBLookupCombo;
    teInquerito: TTabSheet;
    tePlanoAlimentar: TTabSheet;
    tsInquerito: TTabSet;
    tsPlanoAlimentar: TTabSet;
    ntDataInquerito: TNavTable;
    ntDataPlanoAlimentar: TNavTable;
    btRelatoriosInquerito: TBitBtn;
    btRelatoriosPlanoAlimentar: TBitBtn;
    laProf: TLabel;
    lcProf: TRxDBLookupCombo;
    edProf: TEdit;
    laInstr: TLabel;
    edInstruc: TEdit;
    lcInstruc: TRxDBLookupCombo;
    edNacional: TEdit;
    puAnamnese: TPopupMenu;
    puTodasAnamneses: TMenuItem;
    miAnamnese: TMenuItem;
    ImpAnam: TAction;
    ImpAllAnam: TAction;
    btEndNov: TBitBtn;
    cvVideoAntropometria: TCalculoTextViewer;
    imClip1: TImage;
    reVisorAntropometria: TRichEdit;
    cvVideoInquerito: TCalculoTextViewer;
    imClip2: TImage;
    reVisorInquerito: TRichEdit;
    cvVideoPlanoAlimentar: TCalculoTextViewer;
    imClip3: TImage;
    reVisorPlanoAlimentar: TRichEdit;
    Image1: TImage;
    Image2: TImage;
    WizAvDPes: TAction;
    WizCanDPes: TAction;
    WizVolEnd: TAction;
    WizAvEnd: TAction;
    WizCanEnd: TAction;
    paIndWiz: TPageControl;
    tsConPessoa: TTabSheet;
    tsConEndereco: TTabSheet;
    sbWizVoltar: TSpeedButton;
    sbWizAvancar: TSpeedButton;
    sbWizCancelar: TSpeedButton;
    sbWizTerminar: TSpeedButton;
    sbWizVoltarEnd: TSpeedButton;
    sbWizAvEnd: TSpeedButton;
    sbWizCanEnd: TSpeedButton;
    sbWizTermEnd: TSpeedButton;
    WizInicial: TAction;
    WizFinal: TAction;
    LocalizarPess: TAction;
    Fechar: TAction;
    paIndLocal: TPanel;
    btNovoIndiv: TBitBtn;
    btNavLocalizar: TBitBtn;
    btNavAnterior: TBitBtn;
    btNavProximo: TBitBtn;
    btFechar: TBitBtn;
    laEstado: TLabel;
    lcEstado: TRxDBLookupCombo;
    procedure bbIncluirClick(Sender: TObject);
    procedure bbConfirmarClick(Sender: TObject);
    procedure bbEditarClick(Sender: TObject);
    procedure bbAtualizarClick(Sender: TObject);
    procedure bbFinalClick(Sender: TObject);
    procedure rgPesqPessClick(Sender: TObject);
    procedure cbPesqPessChange(Sender: TObject);
    procedure dbPessClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure dbAnamneseClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabelasClick(Sender: TObject);
    procedure lcEstNatCloseUp(Sender: TObject);
    procedure deDataNascExit(Sender: TObject);
    procedure deAtualExit(Sender: TObject);
    procedure diFotoDblClick(Sender: TObject);
    procedure Incluir2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btNavProximoClick(Sender: TObject);
    procedure btNavAnteriorClick(Sender: TObject);
    procedure btNavNovaClick(Sender: TObject);
    procedure btNavExcluirClick(Sender: TObject);
    procedure btNavCancelaClick(Sender: TObject);
    procedure btAnamModeloClick(Sender: TObject);
    procedure btModExameClick(Sender: TObject);
    procedure AnamNovExecute(Sender: TObject);
    procedure AnamEdiExecute(Sender: TObject);
    procedure AntropNovExecute(Sender: TObject);
    procedure AntropEdiExecute(Sender: TObject);
    procedure InqNovExecute(Sender: TObject);
    procedure InqEdiExecute(Sender: TObject);
    procedure DietaNovExecute(Sender: TObject);
    procedure DietaEdiExecute(Sender: TObject);
    procedure ExaNovExecute(Sender: TObject);
    procedure ExaEdiExecute(Sender: TObject);
    procedure ExaDelExecute(Sender: TObject);
    procedure ChecaGravacaoPessoaExecute(Sender: TObject);
//    procedure btAlteraDataNascClick(Sender: TObject);
    procedure MontaEscopo;
    procedure teAntropShow(Sender: TObject);
    procedure teInqShow(Sender: TObject);
    procedure teDietaShow(Sender: TObject);
    procedure tsAntropometriaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PessNovExecute(Sender: TObject);
    procedure PessSalExecute(Sender: TObject);
    procedure acGrafAcompExecute(Sender: TObject);
    procedure PessDelExecute(Sender: TObject);
    procedure PessCancExecute(Sender: TObject);
    procedure EndCanExecute(Sender: TObject);
    procedure EndDelExecute(Sender: TObject);
    procedure EndSalExecute(Sender: TObject);
    procedure EndEdiExecute(Sender: TObject);
    procedure PessEdiExecute(Sender: TObject);
    procedure deNomeExit(Sender: TObject);
    procedure deSobrenomeExit(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    //####################
    procedure bbAnteriorClick(Sender: TObject);
    procedure bbProximoClick(Sender: TObject);
    procedure bbInicioClick(Sender: TObject);
    procedure bbUltimoClick(Sender: TObject);
    procedure ntDataAntropometriaNavChange(Sender: TObject);
    procedure cvVideoAntropometriaAfterWizardTerminate(Sender: TObject);
    procedure teAntropometriaShow(Sender: TObject);
    procedure tbsConsultaEnter(Sender: TObject);
    procedure tbsConsultaExit(Sender: TObject);
    procedure teExamesEnter(Sender: TObject);
    procedure teExamesExit(Sender: TObject);
//    procedure deDataNascEnter(Sender: TObject);
    procedure deEMailKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AnamCanExecute(Sender: TObject);
    procedure AnamSalExecute(Sender: TObject);
    procedure AnamDelExecute(Sender: TObject);
    procedure ExaSalExecute(Sender: TObject);
    procedure ExaCancExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure acRelatoriosExecute(Sender: TObject);
    procedure acRelatoriosUpdate(Sender: TObject);
    procedure acGrafAcompUpdate(Sender: TObject);
    procedure pcPessoaChange(Sender: TObject);
    procedure deRegExit(Sender: TObject);
    procedure deCepExit(Sender: TObject);
    procedure edNaturalExit(Sender: TObject);
    procedure lcNaturalCloseUp(Sender: TObject);
    procedure edCidadeExit(Sender: TObject);
    procedure lcCidadeCloseUp(Sender: TObject);
    procedure reAnamEdicaoEnter(Sender: TObject);
    procedure deModExaEnter(Sender: TObject);
    procedure btAntropEdiClick(Sender: TObject);
    procedure edProfExit(Sender: TObject);
    procedure lcProfCloseUp(Sender: TObject);
    procedure edInstrucExit(Sender: TObject);
    procedure lcInstrucCloseUp(Sender: TObject);
    procedure edNacionalExit(Sender: TObject);
    procedure lcNacionalCloseUp(Sender: TObject);
    procedure ImpAnamExecute(Sender: TObject);
    procedure ImpAllAnamExecute(Sender: TObject);
    procedure cvVideoInqueritoAfterWizardTerminate(Sender: TObject);
    procedure cvVideoPlanoAlimentarAfterWizardTerminate(Sender: TObject);
    procedure WizAvDPesExecute(Sender: TObject);
    procedure WizCanDPesExecute(Sender: TObject);
    procedure WizVolEndExecute(Sender: TObject);
    procedure WizAvEndExecute(Sender: TObject);
    procedure WizCanEndExecute(Sender: TObject);
    procedure WizInicialExecute(Sender: TObject);
    procedure WizFinalExecute(Sender: TObject);
    procedure LocalizarPessExecute(Sender: TObject);
    procedure FecharExecute(Sender: TObject);
    procedure lcEstadoClick(Sender: TObject);
    procedure lcCidadeExit(Sender: TObject);
    procedure lcCidadeEnter(Sender: TObject);
    procedure pcPessoaChanging(Sender: TObject; var AllowChange: Boolean);
    procedure puAnamnesePopup(Sender: TObject);
    //####################
  private
    { Private declarations }
    FlagDNascimento: boolean;
    FAbreCalculos: Boolean;
    FChamadaPeloMenu: Boolean;
    FRecurso : String;
    FModoInserir : Boolean;
    FOnClickSaida: TNotifyEvent;
    procedure SetAbreCalculos(const Value: Boolean);
    procedure SetChamadaPeloMenu(const Value: Boolean);
    procedure AbreCalculoCorrente;
    procedure SetOnClickSaida(const Value: TNotifyEvent);
  public
    { Public declarations }
    fmRelAntrop01: TfmRelAntrop01;
    paInd: TPanel;
    property OnClickSaida: TNotifyEvent read FOnClickSaida write SetOnClickSaida;
    property AbreCalculos: Boolean read FAbreCalculos write SetAbreCalculos;
    property ChamadaPeloMenu: Boolean read FChamadaPeloMenu write SetChamadaPeloMenu;
    procedure InicioBotoes;
    procedure ControlaEscPessoa;
    procedure ControlaTelefones;
    procedure DesativarAbasPessoa;
    procedure AtivarAbasPessoa;

    //##############################################
    procedure DefineAlmaHumana(Sender: TObject);
    procedure DefineDataCalculo(Sender: TObject; var DataCalculo: string; var CancelaCalculo: Boolean);
    procedure DefineKeys(Sender: TObject; Dataset: TDataSet);
    procedure AfterDefineCalcAntropometria(Sender: TObject);
    procedure AfterDefineCalcInquerito(Sender: TObject);
    procedure AfterDefineCalcDieta(Sender: TObject);
    procedure AfterNovoCalculo(Sender: TObject);
    //###############################################
  end;

var
  fmPessoa: TfmPessoa;

implementation

uses UCadPes, MenPes, NutMenu, CadAnam, CalcNutr, NutWiz, ULocPess,
  fmModAnam, UTipoExame, {UDataNasc,} UGrafAc, UCadPastas, DMSemaf,
  //##########################
  DMMBoard, DatCalc, UFonetPess, UPess, DMRelPess, DMGraf, UGrafWiz;
//##########################

{$R *.DFM}

procedure TfmPessoa.bbIncluirClick(Sender: TObject);
begin
  DMPessoa.InserePessoa;

end;

procedure TfmPessoa.bbConfirmarClick(Sender: TObject);
begin
  DMPessoa.ValidaPessoa;

end;

procedure TfmPessoa.bbEditarClick(Sender: TObject);
begin
  DMPessoa.EditaPessoa;

end;

procedure TfmPessoa.bbAtualizarClick(Sender: TObject);
begin
  DMPessoa.CancelaPessoa;

end;
{*
procedure TfmPessoa.bbAnteriorClick(Sender: TObject);
begin
     DMPessoa.AnteriorPessoa;
end;

procedure TfmPessoa.bbProximoClick(Sender: TObject);
begin
     DMPessoa.ProximaPessoa;
end;

procedure TfmPessoa.bbInicioClick(Sender: TObject);
begin
    DMPessoa.PrimeiraPessoa;
end;
}

procedure TfmPessoa.bbFinalClick(Sender: TObject);
begin
  DMPessoa.UltimaPessoa;
end;

procedure TfmPessoa.InicioBotoes;
begin
  // Posiciona no Primeiro registro do Pessoa
  DMPessoa.TbPessoa.First;

end;

procedure TfmPessoa.rgPesqPessClick(Sender: TObject);
begin
  //   DMPessoa.qrPessoa.Close;
  //   DMPessoa.qrPessoa.SQL.Clear;
    { if rgPesqPess.Itemindex = 0 then
        NPessoa.TrocarIndice('NomePess')

     //      DMPessoa.qrPessoa.SQL.Add('SELECT * from Pessoa WHERE NomePess = :NP')
     else
        //DMPessoa.qrPessoa.SQL.Add('SELECT * from Pessoa WHERE SobrPess = :NP');
         NPessoa.TrocarIndice('SobrPess');
     }
end;

procedure TfmPessoa.cbPesqPessChange(Sender: TObject);
begin
  {DMPessoa.qrPessoa.Close;
  DMPessoa.qrPessoa.Params[0].asString := cbPesqPess.Text;
  DMPessoa.qrPessoa.Open;}
end;

procedure TfmPessoa.dbPessClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  pcPessoa.ActivePage := tbsPessoal;
  if (Button = nbEdit) or (Button = nbInsert) then
    deNome.SetFocus;

end;

procedure TfmPessoa.dbAnamneseClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
  if Button = nbInsert then
    DMPessoa.TbAnamneseData.asDateTime := Date;
end;

procedure TfmPessoa.FormShow(Sender: TObject);
begin
  pcPessoa.ActivePage := tbsPessoal;
  pgcBotoes.ActivePage := tbsPessoa;
  //   laNomeCompl.Caption := Trim( deNome.Text ) + ' ' + deSobrenome.Text;
  pcPessoa.ActivePage := pcPessoa.Pages[0];
  (**
  Jair - Desabilidade os botões de navigação que estarão desabilitados para
         a versão rede da aplicação, fica mais facil o usuario navegar pela
         tela de cadastro.
  **)
  PessAnterior.Visible := false;
  PessProximo.Visible := false;
  PessNov.Visible:= false;
  LocalizarPess.Visible:= false;

  if not DMPessoa.DataVazia(deDataNasc.Text, True) then
    diPess.GDataCompleta;

  FModoInserir := ( DMPessoa.TbPessoa.State = dsInsert );

end;

procedure TfmPessoa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fm_MenuNut.HabilitaMenu;
  ChecaGravacaoPessoaExecute(Sender);

  if (fmRelPess <> nil) and (fmRelPess.Report.Printer <> nil) and not (fmRelPess.Report.Printer.ShowingPreview) then
    FreeAndNil(fmRelPess);
  Action := caFree;
  //##################################
  dmMotherBoard.DBTerminar;
  //##################################

end;

procedure TfmPessoa.TabelasClick(Sender: TObject);
begin
  fm_MenuNut.CriaFormTabPessoa(False);
end;

procedure TfmPessoa.lcEstNatCloseUp(Sender: TObject);
begin
  // DMPessoa.TbPessCompCodNatural.AsString := '';
end;

procedure TfmPessoa.deDataNascExit(Sender: TObject);
begin
  // Verifico se a data é valida
  if DMPessoa.DataMaiorHoje(DMPessoa.TbPessoa.Fieldbyname('DataNasc').asDateTime, True) or
    DMPessoa.DataMaior120anos(DMPessoa.TbPessoa.Fieldbyname('DataNasc').asDateTime, True) or
    DMPessoa.DataVazia(deDataNasc.Text, True) then
  begin
    pcPessoa.ActivePage := tbsPessoal;
    pgcBotoes.ActivePage := pgcBotoes.Pages[TTabSheet(pcPessoa.ActivePage).PageIndex];
    if paDPess.Enabled = True then
      deDataNasc.SetFocus;
  end
  else
    diPess.GDataCompleta;

end;

procedure TfmPessoa.deAtualExit(Sender: TObject);
begin
  if DMPessoa.DataMaiorHoje(DMPessoa.TbPessoaDataCad.asDateTime, True) then
    DmPessoa.TbPessoaDataCad.FocusControl;

end;

procedure TfmPessoa.diFotoDblClick(Sender: TObject);
begin
  // dlgAbreFoto.FileName := '*.bmp;*.ico;*.jpg;*.emf;*.wmf';
  dlgAbreFoto.FileName := '';
  if dlgAbreFoto.Execute then
  begin
    DMPessoa.TbPessoa.Edit;
    try
      begin
        diFoto.Picture.LoadFromFile(dlgAbreFoto.FileName);
      end
    except
      ShowMessage('Arquivo de imagem inexistente ou incompatível!');
      // DMPessoa.TbPessoa.Refresh;
    end;
  end;

  if (pos('.JPG', UpperCase(dlgAbreFoto.Filename)) <> 0 or
    pos('.JPEG', UpperCase(dlgAbreFoto.Filename))) then
  begin
    Clipboard.assign(diFoto.Picture);
    diFoto.PasteFromClipboard;
  end;
  //  else
  //     dbFoto.Picture := diFoto.Picture;

end;

procedure TfmPessoa.Incluir2Click(Sender: TObject);
begin
  if DMPessoa.TbPessoa.State <> dsEdit then
    DMPessoa.TbPessoa.Edit;
  diFoto.Picture.LoadFromFile('');
end;

procedure TfmPessoa.FormCreate(Sender: TObject);
begin

  FRecurso := DMPessoa.TbPessoa.FieldByName('IDPESSOA').AsString;

  // Configurações iniciais para os controle deste form
  deNomeCompleto.Top := 2;
  pgcBotoes.Top := 24;
  //!  paInd.Top := 24;
  pcPessoa.Top := 91;

  //   paInd.ActivePage := tsControles ;

  AbreCalculos := True;
  FlagDNascimento := False;
  //###############################################################
     // Seta properties que não puderam ser setadas na interface
  with dmMotherBoard do
  begin
    cvVideoAntropometria.Calculo := caProcessador;
    cvVideoInquerito.Calculo := caProcessador;
    cvVideoPlanoAlimentar.Calculo := caProcessador;

    cvVideoAntropometria.DelayedOpIndicator := Ampulheta;
    cvVideoInquerito.DelayedOpIndicator := Ampulheta;
    cvVideoPlanoAlimentar.DelayedOpIndicator := Ampulheta;

    ahAlmaIndividuo.Repositorio := CalcNut;

    btAntropNov.Action := cnDBNovo;
    btAntropEdi.Action := cnDBCalcular; //***
    btAntropDel.Action := cnDBExcluir;

    btInqNov.Action := cnDBNovo;
    btInqAlt.Action := cnDBCalcular; //***
    btInqExc.Action := cnDBExcluir;

    btDieNov.Action := cnDBNovo;
    btDieAlt.Action := cnDBCalcular; //***
    btDieExc.Action := cnDBExcluir;

    {      toBotaoCalculos.Images := imAtalhos2;
          toBotaoCalculos.HotImages := imHotAtalhos2;
          toBotaoCalculos.DisabledImages := imDisabledAtalhos2; }
  end;

  // Seta Eventos
  dmMotherBoard.cnDBNovo.OnDefineAlmaHumana := DefineAlmaHumana;
  dmMotherBoard.cnDBNovo.OnDefineDataCalculo := DefineDataCalculo;
  dmMotherBoard.cnDBNovo.OnAfterNovoCalculo := AfterNovoCalculo;
  dmMotherBoard.cnDBSalvar.OnDefineKeys := DefineKeys;
  dmMotherBoard.cnDBCalcAntropometria.OnAfterDefineCalculo := AfterDefineCalcAntropometria;
  dmMotherBoard.cnDBCalcInquerito.OnAfterDefineCalculo := AfterDefineCalcInquerito;
  dmMotherBoard.cnDBCalcDieta.OnAfterDefineCalculo := AfterDefineCalcDieta;

  dmMotherBoard.CalculoViewer := cvVideoAntropometria;
  dmMotherBoard.DBIniciar(cvVideoAntropometria); {}

  dmMotherBoard.cnDBCalcAntropometria.ExecuteTarget(self);
  dmMotherBoard.cnDBCalcAntropometria.UpdateTarget(self); {}
  //###############################################################

  pcPessoa.ActivePage := tbsPessoal;
  pgcBotoes.ActivePage := tbsPessoa;

end;

procedure TfmPessoa.btNavProximoClick(Sender: TObject);
begin
  // dbPess.BtnClick(nbNext);
end;

procedure TfmPessoa.btNavAnteriorClick(Sender: TObject);
begin
  //dbPess.BtnClick(nbPrior);
end;

procedure TfmPessoa.btNavNovaClick(Sender: TObject);
begin
  //dbPess.BtnClick(nbInsert);
end;

procedure TfmPessoa.btNavExcluirClick(Sender: TObject);
begin
  //dbPess.BtnClick(nbDelete);
end;

procedure TfmPessoa.btNavCancelaClick(Sender: TObject);
begin
  //dbPess.BtnClick(nbCancel);
end;

procedure TfmPessoa.btAnamModeloClick(Sender: TObject);
begin
  if not DMPessoa.TbTipoAnam.IsEmpty then
  begin
    Application.CreateForm(TfmTipoAnam, fmTipoAnam);
    fmTipoAnam.DBREdDestino := reAnamEdicao;
    fmTipoAnam.ShowModal;
    fmTipoAnam.Free;
  end
  else
    // sendo vazia
    ShowMessage('Não existe nenhum Modelo definido. Cadastre-o antes em Utilitarios /Tabelas / Indivíduos.');

end;

procedure TfmPessoa.btModExameClick(Sender: TObject);
begin
  if not DMPessoa.TbTipoExa.IsEmpty then
  begin
    Application.CreateForm(TfmTipoExame, fmTipoExame);
    fmTipoExame.DBREdDestExa := deModExa;
    fmTipoExame.ShowModal;
    fmTipoExame.Free;
  end
  else
    // sendo vazia
    ShowMessage('Não existe nenhum Modelo definido. Cadastre-o antes em Utilitarios / Tabelas / Indivíduos.');

end;

procedure TfmPessoa.AnamNovExecute(Sender: TObject);
begin
  if DMPessoa.TbPessoa.Fieldbyname('IDPessoa').asString = '' then
    ShowMessage('Faltam Dados Pessoais. Cadastre-os antes.')
  else
  begin
    paInd.Visible := False;
    // DMPessoa.TbAnamnese.GotoBookmark(DMPessoa.TbAnamNavTbl.GetBookmark);
    gbNovo.Visible := True;
    //dbAnamnese.BtnClick(nbInsert);
    DMPessoa.TbAnamnese.Insert;
    DMPessoa.TbAnamnese.Fieldbyname('Anam').asString := 'Para selecionar um Modelo pré-definido, utilize o botão Modelo. Se desejar cadastrar um novo, clique em Utilitarios/ Tabelas/ Individuos.';
  end;

end;

procedure TfmPessoa.AnamEdiExecute(Sender: TObject);
begin
  paInd.Visible := False;
  //   Application.CreateForm(TfmAnam, fmAnam);
    // xxx voltar depois DMPessoa.TbAnamnese.GotoBookmark(DMPessoa.TbAnamNavTbl.GetBookmark);
  //   fmAnam.ShowModal;
  //   fmAnam.Free;
  //   DMPessoa.TbAnamNavTbl.Refresh;
  gbNovo.Visible := True;
  DMPessoa.TbAnamnese.Edit;

end;

procedure TfmPessoa.AntropNovExecute(Sender: TObject);
begin
  DMPessoa.DSAntropsBK.DataSet.DisableControls;
  DMPessoa.DSAntropsBK.DataSet.EnableControls;

end;

procedure TfmPessoa.AntropEdiExecute(Sender: TObject);
begin
  DMPessoa.DSAntropsBK.DataSet.DisableControls;
  DMPessoa.DSAntropsBK.DataSet.EnableControls;

end;

procedure TfmPessoa.InqNovExecute(Sender: TObject);
begin
  DMPessoa.DSInqueritosBK.DataSet.DisableControls;
  DMPessoa.DSInqueritosBK.DataSet.EnableControls;
end;

procedure TfmPessoa.InqEdiExecute(Sender: TObject);
begin
  DMPessoa.DSInqueritosBK.DataSet.DisableControls;
  DMPessoa.DSInqueritosBK.DataSet.EnableControls;
end;

procedure TfmPessoa.DietaNovExecute(Sender: TObject);
begin
  DMPessoa.DSDietasBK.DataSet.DisableControls;
  DMPessoa.DSDietasBK.DataSet.EnableControls;

end;

procedure TfmPessoa.DietaEdiExecute(Sender: TObject);
begin
  DMPessoa.DSDietasBK.DataSet.DisableControls;
  DMPessoa.DSDietasBK.DataSet.EnableControls;

end;

procedure TfmPessoa.ExaNovExecute(Sender: TObject);
begin
  if DMPessoa.TbPessoa.Fieldbyname('IDPessoa').asString = '' then
    ShowMessage('Faltam Dados Pessoais. Cadastre-os antes.')
  else
  begin
    paInd.Visible := False;
    // DMPessoa.TbExaPess.GotoBookmark(DMPessoa.TbExaPessBk.GetBookmark);
    gbExa.Visible := True;
    DMPessoa.TbExaPess.Insert;
    DMPessoa.TbExaPess.Fieldbyname('Exames').asString := 'Para selecionar um Modelo pré-definido, utilize o botão Modelo. Se desejar cadastrar um novo, clique em Utilitarios/ Tabelas/ Individuos.';

  end;

end;

procedure TfmPessoa.ExaEdiExecute(Sender: TObject);
begin
  paInd.Visible := False;
  //  DMPessoa.TbExaPess.GotoBookmark(DMPessoa.TbExaPessBk.GetBookmark);
  gbExa.Visible := True;
  DMPessoa.TbExaPess.Edit;

end;

procedure TfmPessoa.ExaDelExecute(Sender: TObject);
begin
  // Deixo somente aparecer o conj. de botoes se não estiver no modo wizard
  if paIndWiz.Visible = False then
    paInd.Visible := True;

  if MessageDlg('Deseja realmente excluir os dados ? ',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    DMPessoa.TbExaPess.Delete;
  DMPessoa.TbExaPessBk.Refresh;
  gbExa.Visible := False;

end;

procedure TfmPessoa.ChecaGravacaoPessoaExecute(Sender: TObject);
begin
  with DMPessoa do
  begin
    if (TbPessoa.State = dsEdit) or (TbPessoa.State = dsInsert) then
      TbPessoa.Post;
    if (TbPessComp.State = dsEdit) or (TbPessComp.State = dsInsert) then
      TbPessComp.Post;
    if (TbEndereco.State = dsEdit) or (TbEndereco.State = dsInsert) then
      TbEndereco.Post;
    if (TbTelefone.State = dsEdit) or (TbTelefone.State = dsInsert) then
      TbTelefone.Post;
    if (TbAnamnese.State = dsEdit) or (TbAnamnese.State = dsInsert) then
      TbAnamnese.Post;
    if (TbAntrops.State = dsEdit) or (TbAntrops.State = dsInsert) then
      TbAntrops.Post;
    if (TbInqueritos.State = dsEdit) or (TbInqueritos.State = dsInsert) then
      TbInqueritos.Post;
    if (TbDietas.State = dsEdit) or (TbDietas.State = dsInsert) then
      TbDietas.Post;
    if (TbExaPess.State = dsEdit) or (TbExaPess.State = dsInsert) then
      TbExaPess.Post;
  end;
end;

{procedure TfmPessoa.btAlteraDataNascClick(Sender: TObject);
var
  fmDataNasc: TfmDataNasc;
  Ref, Nasc: TMedida;
  Idade: TIdade;
begin
  fmDataNasc := TfmDataNasc.Create(self);
  Ref := TMedida.Create(self);
  Nasc := TMedida.Create(self);
  Idade := TIdade.Create(self);
  Ref.ValorNumerico := DMPessoa.TbPessoaDataCad.AsString;
  Nasc.ValorNumerico := DMPessoa.TbPessoaDataNasc.AsString;
  if Nasc.Empty then
    Nasc.ValorNumerico := DateToStr(Now);

  with fmDataNasc do
  begin
    PainelNascimento1.mdNascimento := Nasc;
    PainelNascimento1.mdReferencia := Ref;
    PainelNascimento1.mdIdade := Idade;
    if ShowModal = mrOK then
    begin
      DMPessoa.TbPessoaDataNasc.DataSet.Edit;
      DMPessoa.TbPessoaDataNasc.AsString := PainelNascimento1.mdNascimento.ValorNumerico;
      deDataNascExit(self);
    end;
    free;
  end;
  Ref.Free;
  Nasc.Free;
  Idade.free;
end;
}
procedure TfmPessoa.MontaEscopo;
var
  NovoEscopo: TMemoria;
  MedAux: TMedida;
begin
  if NovoEscopo.Acha('mdNomeIndividuo', TObject(MedAux)) then
    MedAux.ValorNumerico := DMPessoa.TbPessoaNomePess.asString
      + ' ' + DMPessoa.TbPessoaSobrPess.asString;
  if NovoEscopo.Acha('mdGUIDIndividuo', TObject(MedAux)) then
    MedAux.ValorNumerico := DMPessoa.TbPessoaIDPessoa.AsString;
  if NovoEscopo.Acha('mdDataNascimento', TObject(MedAux)) then
    MedAux.ValorNumerico := DMPessoa.TbPessoaDataNasc.AsString;
  if NovoEscopo.Acha('mdDataCalc', TObject(MedAux)) then
    MedAux.ValorNumerico := DateToStr(Date);
  if NovoEscopo.Acha('mdSexo', TObject(MedAux)) then
    MedAux.ValorNumerico := DMPessoa.TbSexoDescSexo.AsString;
end;

procedure TfmPessoa.teAntropShow(Sender: TObject);
begin
  //   fmCalcNutr.ifFormWizard.Container := paAntrop;
  //   fmCalcNutr.sbAntropometria.Down := True;
end;

procedure TfmPessoa.teInqShow(Sender: TObject);
begin
  //   fmCalcNutr.ifFormWizard.Container := paInquerito;
  //   fmCalcNutr.sbInquerito.Down := True;
end;

procedure TfmPessoa.teDietaShow(Sender: TObject);
begin
  //   fmCalcNutr.ifFormWizard.Container := paDieta;
  //   fmCalcNutr.sbDieta.Down := True;
end;

procedure TfmPessoa.tsAntropometriaMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //fmCalcNutr.ShowPreview;
end;

procedure TfmPessoa.PessNovExecute(Sender: TObject);
var
  Controle: boolean;
begin
  DesativarAbasPessoa;
  WizInicialExecute(Sender);

  //   paInd.Visible := False;
  // adicionei esta linha para que apareçam o botões de simulação de Wizard na interface
  paIndWiz.ActivePage := tsConPessoa;

  // Esconde os botoes enquando estiver usando o falso wizard.
  pgcBotoes.Visible := False;

  Controle := True;

  if Controle then
  begin
    // configurar o painel de Fonetização

  // deNome.Text := '';   deSobrenome.Text := '';
  //  grFon.DataSource.DataSet.Refresh;
//     paFon.Visible := True;

 //  end
//    else

    DMPessoa.TbPessoa.Insert;

    // Jair e Wagner
    FRecurso := DMPessoa.TbPessoaIDPessoa.AsString;
    dmSemaforo.TravaRecurso( FRecurso, 'Indivíduo novo' );

    paDPess.Enabled := True;
    deNome.SetFocus;
  end;
end;

procedure TfmPessoa.PessSalExecute(Sender: TObject);
var
  stFon: string;
  Controle: boolean;
  modoTabela: TDataSetstate;
  CampoVazio: TField;
begin

  // devo sempre tirar o foco do campo. Em alguns casos dá erro quando utilizada a tecla de atalho.
  if (pcPessoa.ActivePage = tbsPessoal) and (pgcBotoes.Visible = True) then
    btPessSal.SetFocus;

  // Deixo somente aparecer o conj. de botoes se não estiver no modo wizard
  if paIndWiz.Visible = False then
    paInd.Visible := True;

  //paDPess.SetFocus;
  Controle := False;
  stFon := UpperCase(cnFon.Fonetizacao(Trim(DMPessoa.TbPessoaNomePess.asString) + ' ' +
    DMPessoa.TbPessoaSobrPess.asString));
  modoTabela := DMPessoa.TbPessoa.state;
  DMPessoa.TbPessoaFonetizado.asString := stFon;

  AbreCalculos := False;
  CampoVazio := InvalidRequiredField(DMPessoa.TbPessoa);
  if CampoVazio = nil then
  try
    begin
      // Verifico se a data é valida
      if (DMPessoa.DataMaiorHoje(DMPessoa.TbPessoa.Fieldbyname('DataNasc').asDateTime, False)) or
        (DMPessoa.DataMaior120anos(DMPessoa.TbPessoa.Fieldbyname('DataNasc').asDateTime, False)) or
        (DMPessoa.DataVazia(deDataNasc.Text, True)) then
        deDataNasc.SetFocus
      else
      begin
        diPess.GDataCompleta;
        DMPessoa.TbPessoa.Post;
        paDPess.Enabled := False;
      end;
    end
  except
    on E: EDatabaseError do
    begin
      ShowMessage('Erro no Banco de Dados: ' + #13 + #10 + E.Message);
      Exit;
    end;
  end
  else
  begin
    pcPessoa.ActivePage := tbsPessoal;
    pgcBotoes.ActivePage := pgcBotoes.Pages[TTabSheet(pcPessoa.ActivePage).PageIndex];
    CampoVazio.FocusControl;
    exit;
  end;

  AbreCalculos := True;

  if Controle then
  begin
    if (ModoTabela = dsInsert) and not (DMPessoa.TbPastas.IsEmpty) then
    begin
      if MessageDlg('Deseja atribuir o indivíduo a alguma Pasta?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        // Posiciono no TbPessoabk, para que quando a pasta for criada, já esteja posicionado na pessoa atual.
//        DMPessoa.TbPessoabk.Locate('IDPESSOA', DMPessoa.TbPessoa['IDPESSOA'].asString, [] );
        fm_MenuNut.CriaFormPastas(False, 'A');
      end;
    end
    else
    begin
      if MessageDlg('Para utilizar as Pastas, cadastre-as antes. Deseja incluí-las agora ?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        fm_MenuNut.CriaFormPastas(False, 'C');
      end;
    end;
  end;
end;

procedure TfmPessoa.acGrafAcompExecute(Sender: TObject);
var
  dtData1, dtData2: TDateTime;

begin
  {    Application.CreateForm(TfmGrafAcomp, fmGrafAcomp);
     with dmGraficos do begin
        IDPessoa := DMPessoa.TbPessoa.Fieldbyname('IDPessoa').asString;
        NomeIndividuo := DMPessoa.TbPessoa.Fieldbyname('NOMECOMPL').asString;
     end;
      fmGrafAcomp.ShowModal;
      fmGrafAcomp.Free;
   }
          // Verifica se tem dados. Se nao tiver, nem apresenta o gráfico
  if DMPessoa.TbAntrops.IsEmpty then
    ShowMessage('Não temos dados para gerar os gráficos.')
  else
  begin
    // Pegar datas e como não sei o indice, verifico quem é a maior e quem é a menor.
    dmPessoa.TbAntrops.First;
    dtData1 := dmPessoa.TbAntrops.Fieldbyname('DATA').AsDateTime;

    dmPessoa.TbAntrops.Last;
    dtData2 := dmPessoa.TbAntrops.Fieldbyname('DATA').AsDateTime;

    if dtData1 < dtData2 then
    begin
      dmGraficos.DataInicialUsuario := dtData1;
      dmGraficos.DataFinalUsuario := dtData2;
    end
    else
    begin
      dmGraficos.DataInicialUsuario := dtData2;
      dmGraficos.DataFinalUsuario := dtData1;
    end;
  end;

  Application.CreateForm(TfmGrafWiz, fmGrafWiz);
  with dmGraficos do
  begin
    IDPessoa := DMPessoa.TbPessoa.Fieldbyname('IDPessoa').asString;
    NomeIndividuo := DMPessoa.TbPessoa.Fieldbyname('NOMECOMPL').asString;
  end;
  fmGrafWiz.ShowModal;
  fmGrafWiz.Free;
end;

procedure TfmPessoa.PessDelExecute(Sender: TObject);
begin
  // Deixo somente aparecer o conj. de botoes se não estiver no modo wizard
  if paIndWiz.Visible = False then
    paInd.Visible := True;

  if MessageDlg('Deseja excluir os dados de ' + Trim(DMPessoa.TbPessoaNomePess.asString) + ' ' +
    DMPessoa.TbPessoaSobrPess.asString + ' ?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DMPessoa.TbPessoa.Delete;
    {** Jair e Wagner é preciso fechar aqui pois não pode ir para um novo registro
    Esperasse que saindo, destrave o registro preso pra deletar }
    FecharExecute(Sender);
  end;

{  Foi tirado, pois não vai mostrar o próximo registro, pois volta para o menu

  paDPess.Enabled := False;
  if not DMPessoa.DataVazia(deDataNasc.Text, True) then
    diPess.GDataCompleta;

  // Se estiver vazio, pergunto se quer cadastrar ou sair do cadastro de pessoa
  if DMPessoa.TbPessoa.RecordCount = 0 then
  begin
    //           if MessageDlg('Base de Dados vazia. Deseja cadastrar novo indivíduo ?' ,
    //              mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    //              PessNovExecute(Sender)
    //           else
    FecharExecute(Sender)
  end;
  //#      else
  //#              LocalizarPessExecute(Sender) ;
}
end;

procedure TfmPessoa.PessCancExecute(Sender: TObject);
begin
  // Deixo somente aparecer o conj. de botoes se não estiver no modo wizard
  if paIndWiz.Visible = False then
    paInd.Visible := True;

  DMPessoa.TbPessoa.Cancel;
  paDPess.SetFocus;
  paDPess.Enabled := False;
  if not DMPessoa.DataVazia(deDataNasc.Text, False) then
    diPess.GDataCompleta;

  // ativa a aba de controles
//   paInd.ActivePage := tsControles;

    {** Jair e Wagner é preciso fechar aqui pois não pode ir para um novo registro
    Esperasse que saindo, destrave o registro preso pra deletar }
    FecharExecute(Sender);
end;

procedure TfmPessoa.EndCanExecute(Sender: TObject);
begin
  // Deixo somente aparecer o conj. de botoes se não estiver no modo wizard
  if paIndWiz.Visible = False then
    paInd.Visible := True;

  DMPessoa.TbEndereco.Cancel;
  paEnder.SetFocus;
  paEnder.Enabled := False;
end;

procedure TfmPessoa.EndDelExecute(Sender: TObject);
begin
  // Deixo somente aparecer o conj. de botoes se não estiver no modo wizard
  if paIndWiz.Visible = False then
    paInd.Visible := True;

  DMPessoa.TbEndereco.Delete;
  paEnder.Enabled := False;
end;

procedure TfmPessoa.EndSalExecute(Sender: TObject);
begin
  // devo sempre tirar o foco do campo. Em alguns casos dá erro quando utilizada a tecla de atalho.
  if (pcPessoa.ActivePage = tsEndereco) and (pgcBotoes.Visible = true) then
    pgcBotoes.SetFocus;

  // Deixo somente aparecer o conj. de botoes se não estiver no modo wizard
  if paIndWiz.Visible = False then
    paInd.Visible := True;

  DMPessoa.TbEndereco.Post;
  //    DMPessoa.TbTelefone.Post;

  DMPessoa.TbCidade.Filtered := False;

  if paEnder.Enabled = true then
    paEnder.SetFocus;
  paEnder.Enabled := False;
end;

procedure TfmPessoa.EndEdiExecute(Sender: TObject);
var
  Filtro: string;

begin
  if DMPessoa.TbPessoa.Fieldbyname('IDPessoa').asString = '' then
    ShowMessage('Faltam Dados Pessoais. Cadastre-os antes.')
  else
  begin
    //   paInd.Visible := False;

       // adicionei esta linha para que apareçam o botões de simulação de Wizard na interface
       // Somente ativo se já estiver sendo usado em Dados Pessoais.
    if paIndWiz.ActivePage = tsConPessoa then
      paIndWiz.ActivePage := tsConEndereco;

    DMPessoa.TbEndereco.Edit;

    // fazer aparecer já filtrada a cidade por estado
    Filtro := 'UF=' + '''' + DMPessoa.TbEstado.Fieldbyname('AbrevEstado').asString + '''';
    DMPessoa.TbCidade.Filter := Filtro;
    DMPessoa.TbCidade.Filtered := True;

    paEnder.Enabled := True;
    if paEnder.Enabled = True then
      deEndereco.Setfocus;
  end;
end;

procedure TfmPessoa.PessEdiExecute(Sender: TObject);
begin
  try
    DMPessoa.TbPessoa.Edit;
  except
    exit;
  end;
  paInd.Visible := False;
  paDPess.Enabled := True;
  if not DMPessoa.DataVazia(deDataNasc.Text, True) then
    diPess.GDataCompleta;
  deNome.Setfocus;
end;
{*
procedure TfmPessoa.SetAlmaIndividuo;
begin
   with ahAlmaIndividuo, DMPessoa do
   begin
      GUID := TbPessoaIDPessoa.AsString;
      Nome := TbPessoaNomePess.AsString + ' ' + TbPessoaSobrPess.AsString;
      if TbPessoaCodSexo.AsString = '1' then
         Sexo := 'Feminino'
      else
         Sexo := 'Masculino';
      DataNascimento := TbPessoaDataNasc.AsDateTime;
  end;
end;
*}

procedure TfmPessoa.deNomeExit(Sender: TObject);
var
  stFon: string;
begin
  // Fonetiza e procura semelhantes
  stFon := UpperCase(cnFon.Fonetizacao(Trim(deNome.Text) + ' ' + deSobrenome.Text));
  // DMPessoa.TbPessoaFon.Locate('Fonetizado', stFon, [loPartialKey] );
end;

procedure TfmPessoa.deSobrenomeExit(Sender: TObject);
var
  stFon: string;
begin
  // Fonetiza e procura semelhantes
  stFon := cnFon.Fonetizacao(UpperCase(Trim(deNome.Text) + ' ' + deSobrenome.Text));

  // Estas 2 linhas sao para o controle de fonetizacao antigo
  //    if DMPessoa.TbPessoaFon.Locate('Fonetizado', stFon, [] ) then
  //       ShowMessage('Indivíduo semelhante já cadastrado. Compare alguns dados. ' );
  DMPessoa.qrPessoaFon.Active := False;
  DMPessoa.qrPessoaFon.Params[0].AsString := stFon;
  DMPessoa.qrPessoaFon.Active := True;

  if (DMPessoa.qrPessoaFon.RecordCount <> 0) and (DMPessoa.TbPessoa.State = dsInsert) then
  begin

    if MessageDlg('Existem nomes semelhantes! Deseja obter mais informações?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Application.CreateForm(TfmFonetPess, fmFonetPess);
      fmFonetPess.ShowModal;
      fmFonetPess.Free;
      deReg.SetFocus;
    end;
    deReg.SetFocus;
  end;

  //DMPessoa.qrPessoaFon.ExecSQL;
end;

procedure TfmPessoa.btOkClick(Sender: TObject);
begin

end;

//### EVENTOS ############################################################

procedure TfmPessoa.DefineAlmaHumana(Sender: TObject);
begin
  with ahAlmaIndividuo, DMPessoa.dsPessoa.DataSet do
  begin
    GUID := FieldByName('IDPESSOA').AsString;
    Nome := FieldByName('NOMEPESS').AsString + ' ' + FieldByName('SOBRPESS').AsString;
    if FieldByName('CODSEXO').AsString = '1' then
      Sexo := 'Feminino'
    else
      Sexo := 'Masculino';
    DataNascimento := FieldByName('DATANASC').AsDateTime;
  end;

  // Faz o update dos dados da pessoa para a memoria (Alma)
  ahAlmaIndividuo.UpdateRepositorio;

end;

procedure TfmPessoa.DefineDataCalculo(Sender: TObject;
  var DataCalculo: string; var CancelaCalculo: Boolean);
var
  F1: TfmDataCalc;
begin
  // Pede data da visita
  F1 := TfmDataCalc.Create(Application);
  F1.mdData.Text := DateToStr(Date);
  F1.ShowModal;
  if F1.ModalResult = mrCancel then
  begin
    AbreCalculoCorrente;
    F1.Free;
    CancelaCalculo := True;
    exit;
  end;
  // Verifica se jah tem
  if dmMotherBoard.DBIOController.DataSource.DataSet.Locate('DATA', StrToDate(F1.mdData.Text), []) then
  begin
    ShowMessage('Esta data já está cadastrada!');
    AbreCalculoCorrente;
    F1.Free;
    CancelaCalculo := True;
    exit;
  end;
  DataCalculo := F1.mdData.Text;
  F1.Free;
end;

procedure TfmPessoa.DefineKeys(Sender: TObject; Dataset: TDataSet);
var
  mdData: TMedida;
begin
  if not dmMotherBoard.DBIOController.Calculo.Memoria.Acha('mdDataCalc', TObject(mdData)) then
    Exit;
  DataSet.FieldByName('IDPESSOA').asString := DMPessoa.dsPessoa.DataSet.FieldByName('IDPESSOA').AsString;
  DataSet.FieldByName('DATA').asDateTime := StrToDateTime(mdData.ValorNumerico);
end;

procedure TfmPessoa.AfterDefineCalcAntropometria(Sender: TObject);
begin
  dmMotherBoard.DBIOController.DataSource := DMPessoa.DSAntrops;
  dmMotherBoard.ProcessadorAtual := cvVideoAntropometria.AntropButtons[ncAntropometria].Processador;
end;

procedure TfmPessoa.AfterDefineCalcInquerito(Sender: TObject);
begin
  dmMotherBoard.DBIOController.DataSource := DMPessoa.DSInqueritos;
  dmMotherBoard.ProcessadorAtual := cvVideoInquerito.AntropButtons[ncInquerito].Processador;
end;

procedure TfmPessoa.AfterDefineCalcDieta(Sender: TObject);
begin
  dmMotherBoard.DBIOController.DataSource := DMPessoa.DSDietas;
  dmMotherBoard.ProcessadorAtual := cvVideoPlanoAlimentar.AntropButtons[ncDieta].Processador;
end;

procedure TfmPessoa.cvVideoAntropometriaAfterWizardTerminate(Sender: TObject);
begin
  dmMotherBoard.cnDBSalvar.ExecuteTarget(self);
  dmMotherBoard.cnDBSalvar.UpdateTarget(self);
end;

procedure TfmPessoa.ntDataAntropometriaNavChange(Sender: TObject);
begin
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self); //***
  dmMotherBoard.cnDBAbrir.UpdateTarget(self); //***
end;

// BOTOES DE NAVEGACAO DA PESSOA ===============================================

procedure TfmPessoa.bbAnteriorClick(Sender: TObject);
begin
  //-   DMPessoa.dsPessoa.DataSet.Prior;
  DMPessoa.AnteriorPessoa;
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self); //***
  dmMotherBoard.cnDBAbrir.UpdateTarget(self); //***
  if not DMPessoa.DataVazia(deDataNasc.Text, True) then
    diPess.GDataCompleta;
end;

procedure TfmPessoa.bbProximoClick(Sender: TObject);
begin
  //-   DMPessoa.dsPessoa.DataSet.Next;
  DMPessoa.ProximaPessoa;
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self); //***
  dmMotherBoard.cnDBAbrir.UpdateTarget(self); //***
  if not DMPessoa.DataVazia(deDataNasc.Text, True) then
    diPess.GDataCompleta;

end;

procedure TfmPessoa.bbInicioClick(Sender: TObject);
begin
  //-   DMPessoa.dsPessoa.DataSet.First;
  DMPessoa.PrimeiraPessoa;
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self); //***
  dmMotherBoard.cnDBAbrir.UpdateTarget(self); //***
end;

procedure TfmPessoa.bbUltimoClick(Sender: TObject);
begin
  DMPessoa.dsPessoa.DataSet.Last;
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self); //***
  dmMotherBoard.cnDBAbrir.UpdateTarget(self); //***
end;

procedure TfmPessoa.teAntropometriaShow(Sender: TObject);
begin
  if AbreCalculos then {}
  begin
    dmMotherBoard.cnDBAbrir.ExecuteTarget(self);
    dmMotherBoard.cnDBAbrir.UpdateTarget(self);
  end; {}
end;

//###############################################################

procedure TfmPessoa.tbsConsultaEnter(Sender: TObject);
begin
  fm_MenuNut.KeyPreview := False;
end;

procedure TfmPessoa.tbsConsultaExit(Sender: TObject);
begin
  fm_MenuNut.KeyPreview := True;
end;

procedure TfmPessoa.teExamesEnter(Sender: TObject);
begin
  fm_MenuNut.KeyPreview := False;
end;

procedure TfmPessoa.teExamesExit(Sender: TObject);
begin
  fm_MenuNut.KeyPreview := True;
end;

{procedure TfmPessoa.deDataNascEnter(Sender: TObject);
begin
  if not FlagDNascimento then
  begin
    FlagDNascimento := True;
//    btAlteraDataNascClick(Sender);
  end
  else
    FlagDNascimento := false;

end;
}
procedure TfmPessoa.deEMailKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) or (Key = VK_TAB) or (Key = VK_DOWN) then
    EndSalExecute(Sender); // salvo
end;

procedure TfmPessoa.AnamCanExecute(Sender: TObject);
begin
  paInd.Visible := True;
  //dbAnamnese.BtnClick(nbCancel);
  DMPessoa.TbAnamnese.Cancel;
  gbNovo.Visible := False;
end;

procedure TfmPessoa.AnamSalExecute(Sender: TObject);
var
  CampoVazio: TField;
begin

  // devo sempre tirar o foco do campo. Em alguns casos dá erro quando utilizada a tecla de atalho.
  if pcPessoa.ActivePage = tbsConsulta then
    bbAnamSal.SetFocus;

  // se achei e é um registro novo, aviso que a data está repetida
  if (DMPessoa.TbAnamNavTbl.Locate('IDPESSOA;DATA', VarArrayOf([DMPessoa.TbPessoa['IDPESSOA'], deData.Text]), [])) and
    (DMPessoa.TbAnamnese.State = dsInsert) then
  begin
    ShowMessage('Esta data já foi cadastrada. ');
    deData.Setfocus;
  end
    // tenho que verificar se o usuario controlou a data corretamente
  else if DMPessoa.DataMaiorHoje(StrtoDate(deData.Text), True) or
    DMPessoa.DataNegativa(StrtoDate(deDataNasc.Text), StrtoDate(deData.Text), 'Data menor que o nascimento.') or
    DMPessoa.DataVazia(deData.Text, True) then
  begin
    deData.SetFocus;
  end

  else
  begin
    CampoVazio := InvalidRequiredField(DMPessoa.TbAnamnese);
    if CampoVazio = nil then
    try
      begin
        if (DMPessoa.TbAnamnese.State = dsEdit) or
          (DMPessoa.TbAnamnese.State = dsInsert) then
          DMPessoa.TbAnamnese.Post;
        gbNovo.Visible := False;
        //DMPessoa.TbAnamNavTbl.Refresh;
        paInd.Visible := True;
      end
    except
      on E: EDatabaseError do
      begin
        raise
      end
    end;
  end;
end;

procedure TfmPessoa.AnamDelExecute(Sender: TObject);
begin
  paInd.Visible := True;
  // xxx voltar depois  DMPessoa.TbAnamnese.GotoBookmark(DMPessoa.TbAnamNavTbl.GetBookmark);

  if MessageDlg('Deseja realmente excluir os dados ? ',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    DMPessoa.TbAnamnese.Delete;
  DMPessoa.TbAnamNavTbl.Refresh;
  //dbAnamnese.BtnClick(nbDelete);
  gbNovo.Visible := False;
end;

procedure TfmPessoa.ExaSalExecute(Sender: TObject);
var
  CampoVazio: TField;

begin
  // devo sempre tirar o foco do campo. Em alguns casos dá erro quando utilizada a tecla de atalho.
  if pcPessoa.ActivePage = teExames then
    btExSal.SetFocus;

  // se achei e é um registro novo, aviso que a data está repetida
  if (DMPessoa.TbExaPessbk.Locate('IDPESSOA;DATA', VarArrayOf([DMPessoa.TbPessoa['IDPESSOA'], deDataExa.Text]), [])) and
    (DMPessoa.TbExaPess.State = dsInsert) then
  begin
    ShowMessage('Esta data já foi cadastrada. ');
    deDataExa.Setfocus;
  end
    // Verifico se a data é valida
  else if DMPessoa.DataMaiorHoje(StrtoDate(deDataExa.Text), True) or
    DMPessoa.DataNegativa(StrtoDate(deDataNasc.Text), StrtoDate(deDataExa.Text), 'Data menor que o nascimento.') or
    DMPessoa.DataVazia(deDataExa.Text, True) then
    deDataExa.SetFocus

  else
  begin
    CampoVazio := InvalidRequiredField(DMPessoa.TbExaPess);
    if CampoVazio = nil then
    try
      begin
        if (DMPessoa.TbExaPess.State = dsEdit) or
          (DMPessoa.TbExaPess.State = dsInsert) then
        begin
          DMPessoa.TbExaPess.Post;
          gbExa.Visible := False;
          paInd.Visible := True;
        end;
      end
    except
      on E: EDatabaseError do
      begin
        raise
      end
    end;
  end;
  DMPessoa.TbExaPessBk.Refresh;

end;

procedure TfmPessoa.ExaCancExecute(Sender: TObject);
begin
  paInd.Visible := True;
  DMPessoa.TbExaPess.Cancel;
  gbExa.Visible := False;
end;

procedure TfmPessoa.ControlaEscPessoa;
begin
  if (DMPessoa.TbPessoa.state = dsInsert) or (DMPessoa.TbPessoa.state = dsEdit) then
  begin
    if MessageDlg('Seus dados serão cancelados !', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    begin
      DMPessoa.TbPessoa.Cancel;
      Close;
    end;
  end;

end;

procedure TfmPessoa.FormKeyPress(Sender: TObject; var Key: Char);
begin

  // controlar o esc. Verificar no informbuilder ...xxxxxxxxxxxxxxx
 //if (key = CHR(VK_ESCAPE)) then   // se for dado um <esc>
 //   ControlaEscPessoa;

end;

procedure TfmPessoa.SetAbreCalculos(const Value: Boolean);
begin
  FAbreCalculos := Value;
end;

procedure TfmPessoa.SetChamadaPeloMenu(const Value: Boolean);
begin
  FChamadaPeloMenu := Value;
end;

procedure TfmPessoa.acRelatoriosExecute(Sender: TObject);
begin
  // *** posiciona aqui ao inves de no datachange
  AbreCalculoCorrente;
  dmMotherBoard.Imprimir;
end;

procedure TfmPessoa.acRelatoriosUpdate(Sender: TObject);
begin
  btRelatoriosAntropometria.Enabled := not (dmMotherBoard.CalcNut.Empty) and
    not (cvVideoAntropometria.Calculando);
  btRelatoriosInquerito.Enabled := not (dmMotherBoard.CalcNut.Empty) and
    not (cvVideoInquerito.Calculando);
  btRelatoriosPlanoAlimentar.Enabled := not (dmMotherBoard.CalcNut.Empty) and
    not (cvVideoPlanoAlimentar.Calculando);
end;

procedure TfmPessoa.acGrafAcompUpdate(Sender: TObject);
begin
  btGraficos.Enabled := not (dmMotherBoard.CalcNut.Empty) and
    not (cvVideoAntropometria.Calculando);
end;

procedure TfmPessoa.pcPessoaChange(Sender: TObject);
begin

  pgcBotoes.ActivePage := pgcBotoes.Pages[TTabSheet(pcPessoa.ActivePage).PageIndex];

  // se o Wizard falso estiver ativo :
  if (paIndWiz.Visible = True) then
  begin
    if pcPessoa.ActivePage = tbsPessoal then
    begin
      //               paInd.ActivePage := tsConPessoa;
      WizVolEnd.Execute;
    end
    else
    begin
      paIndWiz.ActivePage := tsConEndereco;
      WizAvDPes.Execute;
    end
  end;

  // Saindo de Pessoa ...
  if (pcPessoa.ActivePage <> tbsPessoal) and
    ((DMPessoa.TbPessoa.state = dsInsert) or (DMPessoa.TbPessoa.state = dsEdit)) then
  begin
    pcPessoa.ActivePage := tbsPessoal;
    pgcBotoes.ActivePage := pgcBotoes.Pages[TTabSheet(pcPessoa.ActivePage).PageIndex];
    PessSalExecute(Sender);
  end;

  // Saindo de Endereço ...
  if (pcPessoa.ActivePage <> tsEndereco) then
  begin
    // Endereco está ativo ?
    if ((DMPessoa.TbEndereco.state = dsInsert) or (DMPessoa.TbEndereco.state = dsEdit)) then
    begin

      // O telefone também está ativo ?

      if ((DMPessoa.TbTelefone.state = dsInsert) or (DMPessoa.TbTelefone.state = dsEdit)) then
      begin
        // endereco e telefone ativos
        // tento salvar o telefone até conseguir
        try
          DMPessoa.TbTelefone.Post;
          pcPessoa.ActivePage := tsEndereco;
          pgcBotoes.ActivePage := pgcBotoes.Pages[TTabSheet(pcPessoa.ActivePage).PageIndex];
          EndSalExecute(Sender);
        except
          on Exception do
            ControlaTelefones;
        end; // final do except
      end // final do begin do Telefone Ativo sim

        // O telefone não esta ativo
      else
      begin
        pcPessoa.ActivePage := tsEndereco;
        pgcBotoes.ActivePage := pgcBotoes.Pages[TTabSheet(pcPessoa.ActivePage).PageIndex];
        EndSalExecute(Sender);
      end;

    end // begin do Endereco Ativo ?
    else
      // caso o endereço não esteja ativo. Somente o telefone está ativo.
    begin
      //

      if ((DMPessoa.TbTelefone.state = dsInsert) or (DMPessoa.TbTelefone.state = dsEdit)) then
      begin
        try
          DMPessoa.TbTelefone.Post;
          pcPessoa.ActivePage := tsEndereco;
          pgcBotoes.ActivePage := pgcBotoes.Pages[TTabSheet(pcPessoa.ActivePage).PageIndex];
          paInd.Visible := True;
          paEnder.Setfocus;
          paEnder.Enabled := False;
        except
          on Exception do
            ControlaTelefones;
        end; // final do except
      end; // final do begin do Telefone Ativo sim

    end; // endereço não ativo

  end; // saindo da pasta endereco

  // Saindo da Anamnese ...
  if (pcPessoa.ActivePage <> tbsConsulta) and
    ((DMPessoa.TbAnamnese.state = dsInsert) or (DMPessoa.TbAnamnese.state = dsEdit)) then
  begin
    pcPessoa.ActivePage := tbsConsulta;
    pgcBotoes.ActivePage := pgcBotoes.Pages[TTabSheet(pcPessoa.ActivePage).PageIndex];
    AnamSalExecute(Sender);
  end;

  // Saindo da Exames ...
  if (pcPessoa.ActivePage <> teExames) and
    ((DMPessoa.TbExaPess.state = dsInsert) or (DMPessoa.TbExaPess.state = dsEdit)) then
  begin
    pcPessoa.ActivePage := teExames;
    pgcBotoes.ActivePage := pgcBotoes.Pages[TTabSheet(pcPessoa.ActivePage).PageIndex];
    ExaSalExecute(Sender);
  end;

  // Calculos
  if (pcPessoa.ActivePage = teAntropometria) then
  begin
    dmMotherBoard.SetDBCalculoViewer(cvVideoAntropometria);
    dmMotherBoard.cnDBCalcAntropometria.ExecuteTarget(self);
    dmMotherBoard.cnDBCalcAntropometria.UpdateTarget(self);
    DMPessoa.DSAntrops.DataSet.First;
  end
  else if (pcPessoa.ActivePage = teInquerito) then
  begin
    dmMotherBoard.SetDBCalculoViewer(cvVideoInquerito);
    dmMotherBoard.cnDBCalcInquerito.ExecuteTarget(self);
    dmMotherBoard.cnDBCalcInquerito.UpdateTarget(self);
    DMPessoa.DSInqueritos.DataSet.First;
  end
  else if (pcPessoa.ActivePage = tePlanoAlimentar) then
  begin
    dmMotherBoard.SetDBCalculoViewer(cvVideoPlanoAlimentar);
    dmMotherBoard.cnDBCalcDieta.ExecuteTarget(self);
    dmMotherBoard.cnDBCalcDieta.UpdateTarget(self);
    DMPessoa.DSDietas.DataSet.First;
  end;

end;

procedure TfmPessoa.deRegExit(Sender: TObject);
var
  stReg: string;

begin
  stReg := deReg.Text;

  DMPessoa.qrPessCompbk.Active := False;
  DMPessoa.qrPessCompbk.Params[0].AsString := stReg;
  DMPessoa.qrPessCompbk.Active := True;

  if (deReg.Text <> '') and
    (((DMPessoa.TbPessoa.state = dsInsert) and (DMPessoa.qrPessCompbk.RecordCount >= 1)) or
    ((DMPessoa.TbPessoa.state = dsEdit) and (DMPessoa.qrPessCompbk.RecordCount > 1))) then
  begin
    ShowMessage(' Este Registro já existe.');
    deReg.SetFocus;
    DMPessoa.qrPessCompbk.Active := False;
  end;
end;

procedure TfmPessoa.deCepExit(Sender: TObject);
begin
  // Para valores de 1 a 5
  if ((Length(Trim(deCep.Text)) > 0) and (Length(Trim(deCep.Text)) < 5)) then
  begin
    ShowMessage('Valor de CEP é menor que 5');
    deCep.Setfocus;
  end;
end;

procedure TfmPessoa.edNaturalExit(Sender: TObject);
begin
  edNatural.Visible := False;
  lcNatural.Visible := True;

  // se nao achar a cidade, grava uma nova
  if edNatural.Text = '' then
  begin
    DMPessoa.TbPessComp.Edit;
    DMPessoa.TbPessComp.Fieldbyname('CodNatural').asString := '';
  end
  else
  begin
    if not DMPessoa.TbCidade.Locate('DESCRCID', edNatural.Text, [loCaseInsensitive]) then
    begin
      try
        DMPessoa.TbCidade.Insert;
        DMPessoa.TbCidade.Fieldbyname('DESCRCID').asString := edNatural.Text;
        DMPessoa.TbCidade.Post;
      except
        on Exception do
          ShowMessage('Erro na Inserção!!');
      end;
    end;

    // se achei a cidade, ela já estando cadastrada ...
    DMPessoa.TbPessComp.Edit;
    DMPessoa.TbPessComp.Fieldbyname('CodNatural').asString := DMPessoa.TbCidade.Fieldbyname('IDCID').asString;

  end;
end;

procedure TfmPessoa.lcNaturalCloseUp(Sender: TObject);
begin
  {  If lcNatural.Text = 'Nova Cidade' then
       begin
          lcNatural.Visible := False;
          edNatural.Visible := True ;
          edNatural.Text := '';
          edNatural.SetFocus;
       end;
   }
end;

procedure TfmPessoa.edCidadeExit(Sender: TObject);
begin
  edCidade.Visible := False;
  lcCidade.Visible := True;

  DMPessoa.TbCidade.Filtered := False;
  // se nao achar a cidade, grava uma nova
  if edCidade.Text = '' then
  begin
    DMPessoa.TbEndereco.Edit;
    DMPessoa.TbEndereco.Fieldbyname('CIDADE').asString := '';
  end
  else
  begin
    if not DMPessoa.TbCidade.Locate('DESCRCID;UF', VarArrayOf([edCidade.Text, lcEstado.Text]), [loCaseInsensitive]) then
    begin
      try
        DMPessoa.TbCidade.Filtered := False; // (tiro o filtro para gravar)
        DMPessoa.TbCidade.Insert;
        DMPessoa.TbCidade.Fieldbyname('DESCRCID').asString := edCidade.Text;
        DMPessoa.TbCidade.Fieldbyname('UF').asString := lcEstado.Text;

        DMPessoa.TbCidade.Post;
      except
        on Exception do
          ShowMessage('Erro na Inserção!!');
      end;
    end;

    // se achei a cidade, ela já estando cadastrada ...
    DMPessoa.TbEndereco.Edit;
    DMPessoa.TbEndereco.Fieldbyname('CIDADE').asString := DMPessoa.TbCidade.Fieldbyname('IDCID').asString;

  end;

end;

procedure TfmPessoa.lcCidadeCloseUp(Sender: TObject);
begin
  if lcCidade.Text = 'Nova Cidade' then
  begin
    lcCidade.Visible := False;
    edCidade.Visible := True;
    edCidade.Text := '';
    edCidade.SetFocus;
  end;
end;

procedure TFmPessoa.ControlaTelefones;
begin
  ShowMessage('Verifique se os campos foram cadastrados corretamente!!');
  pcPessoa.ActivePage := tsEndereco;
  pgcBotoes.ActivePage := pgcBotoes.Pages[TTabSheet(pcPessoa.ActivePage).PageIndex];

end;

procedure TfmPessoa.reAnamEdicaoEnter(Sender: TObject);
begin
  reAnamEdicao.SelectAll;
end;

procedure TfmPessoa.deModExaEnter(Sender: TObject);
begin
  deModExa.SelectAll;
end;

procedure TfmPessoa.AbreCalculoCorrente;
begin
  dmMotherBoard.cnDBAbrir.ExecuteTarget(self);
  dmMotherBoard.cnDBAbrir.UpdateTarget(self);
end;

procedure TfmPessoa.btAntropEdiClick(Sender: TObject);
begin
  AbreCalculoCorrente;
  dmMotherBoard.cnDBCalcular.ExecuteTarget(self);
  dmMotherBoard.cnDBCalcular.UpdateTarget(self);
end;

procedure TfmPessoa.edProfExit(Sender: TObject);
begin
  edProf.Visible := False;
  lcProf.Visible := True;

  // se nao achar a Profissao, grava uma nova
  if edProf.Text = '' then
  begin
    DMPessoa.TbPessComp.Edit;
    DMPessoa.TbPessComp.Fieldbyname('CodProfis').asString := '';
  end
  else
  begin
    if not DMPessoa.TbProfissao.Locate('DESCPROF', edProf.Text, [loCaseInsensitive]) then
    begin
      try
        DMPessoa.TbProfissao.Insert;
        DMPessoa.TbProfissao.Fieldbyname('DESCPROF').asString := edProf.Text;
        DMPessoa.TbProfissao.Post;
      except
        on Exception do
          ShowMessage('Erro na Inserção!!');
      end;
    end;

    // se achei a profissao, ela já estando cadastrada ...
    DMPessoa.TbPessComp.Edit;
    DMPessoa.TbPessComp.Fieldbyname('CodProfis').asString := DMPessoa.TbProfissao.Fieldbyname('CODPROFIS').asString;

  end;

end;

procedure TfmPessoa.lcProfCloseUp(Sender: TObject);
begin
  if lcProf.Text = 'Nova Profissão' then
  begin
    lcProf.Visible := False;
    edProf.Visible := True;
    edProf.Text := '';
    edProf.SetFocus;
  end;
end;

procedure TfmPessoa.edInstrucExit(Sender: TObject);
begin
  edInstruc.Visible := False;
  lcInstruc.Visible := True;

  // se nao achar a Instrucao, grava uma nova
  if edInstruc.Text = '' then
  begin
    DMPessoa.TbPessComp.Edit;
    DMPessoa.TbPessComp.Fieldbyname('CodInstruc').asString := '';
  end
  else
  begin
    if not DMPessoa.TbInstrucao.Locate('DESCINST', edInstruc.Text, [loCaseInsensitive]) then
    begin
      try
        DMPessoa.TbInstrucao.Insert;
        DMPessoa.TbInstrucao.Fieldbyname('DESCINST').asString := edInstruc.Text;
        DMPessoa.TbInstrucao.Post;
      except
        on Exception do
          ShowMessage('Erro na Inserção!!');
      end;
    end;

    // se achei a profissao, ela já estando cadastrada ...
    DMPessoa.TbPessComp.Edit;
    DMPessoa.TbPessComp.Fieldbyname('CodInstruc').asString := DMPessoa.TbInstrucao.Fieldbyname('CODINSTRUC').asString;

  end;

end;

procedure TfmPessoa.lcInstrucCloseUp(Sender: TObject);
begin
  if lcInstruc.Text = 'Nova Instrucao' then
  begin
    lcInstruc.Visible := False;
    edInstruc.Visible := True;
    edInstruc.Text := '';
    edInstruc.SetFocus;
  end;
end;

procedure TfmPessoa.edNacionalExit(Sender: TObject);
begin
  edNacional.Visible := False;
  lcNacional.Visible := True;

  // se nao achar a Nacionalidade, grava uma nova
  if edNacional.Text = '' then
  begin
    DMPessoa.TbPessComp.Edit;
    DMPessoa.TbPessComp.Fieldbyname('CodNacional').asString := '';
  end
  else
  begin
    if not DMPessoa.TbNacionalidade.Locate('NACIONALIDADE', edNacional.Text, [loCaseInsensitive]) then
    begin
      try
        DMPessoa.TbNacionalidade.Insert;
        DMPessoa.TbNacionalidade.Fieldbyname('NACIONALIDADE').asString := edNacional.Text;
        DMPessoa.TbNacionalidade.Post;
      except
        on Exception do
          ShowMessage('Erro na Inserção!!');
      end;
    end;

    // se achei a nacionalidade, ela já estando cadastrada ...
    DMPessoa.TbPessComp.Edit;
    DMPessoa.TbPessComp.Fieldbyname('CodNacional').asString := DMPessoa.TbNacionalidade.Fieldbyname('IDNAC').asString;

  end;

end;

procedure TfmPessoa.lcNacionalCloseUp(Sender: TObject);
begin
  {     If lcNacional.Text = 'Nova Nacionalidade' then
     begin
        lcNacional.Visible := False;
        edNacional.Visible := True ;
        edNacional.Text := '';
        edNacional.SetFocus;
     end;    }
end;

procedure TfmPessoa.ImpAnamExecute(Sender: TObject);
var
  Config, Config2 : string;
  Rel: TfmRelPess;
begin
  // Crio o relatório
  Application.CreateForm(TDMRelPessoa, DMRelPessoa);
  Rel := TfmRelPess.Create(nil);
  try
    with Rel do
    begin
    qgNomePess.Enabled := False;
      // dados pessoais
      qbDadosPess.Enabled := False;
      // dados complementares
      qsdDadosCompl.Enabled := False;
      // Anamnese Nutricional
      qrAnamNutr.Enabled := True;
      //         Config  := 'IDPessoa = ''' + DMRelPessoa.TbPessoaIDPessoa.asString  + '''' ;
      Config := 'IDPessoa = ''' + DMPessoa.TbPessoa.Fieldbyname('IDPessoa').asString + '''';
      DMRelPessoa.TbPessoa.Filter := Config;
      DMRelPessoa.TbPessoa.Filtered := True;
      Config2 := 'DATA = ''' + DMPessoa.TbAnamnese.Fieldbyname('DATA').asString + '''';
      DMRelPessoa.TbAnam.Filter := Config2;
      DMRelPessoa.TbAnam.Filtered := True;
      // Mostra Rel
      Report.PreviewModal;
    end;
  finally
    Rel.Free;
    DMRelPessoa.free;
  end;
end;

procedure TfmPessoa.ImpAllAnamExecute(Sender: TObject);
var
  Config: string;
  Rel: TfmRelPess;
begin
  // Crio o relatório
  Application.CreateForm(TDMRelPessoa, DMRelPessoa);
  Rel := TfmRelPess.Create(nil);
  try
    with Rel do
    begin
      // dados pessoais
      qbDadosPess.Enabled := True;
      // dados complementares
      qsdDadosCompl.Enabled := True;
      // Anamnese Nutricional
      qrAnamNutr.Enabled := True;
      //         Config  := 'IDPessoa = ''' + DMRelPessoa.TbPessoaIDPessoa.asString  + '''' ;
      Config := 'IDPessoa = ''' + DMPessoa.TbPessoa.Fieldbyname('IDPessoa').asString + '''';
      DMRelPessoa.TbPessoa.Filter := Config;
      DMRelPessoa.TbPessoa.Filtered := True;
      // Mostra Rel
      Report.PreviewModal;
    end;
  finally
    Rel.Free;
    DMRelPessoa.free;
  end;
end;

procedure TfmPessoa.DesativarAbasPessoa;
begin

  tsEndereco.TabVisible := False;
  tbsConsulta.TabVisible := False;
  teExames.TabVisible := False;
  teAntropometria.TabVisible := False;
  teInquerito.TabVisible := False;
  tePlanoAlimentar.TabVisible := False;

end;

procedure TfmPessoa.AtivarAbasPessoa;
begin
  tbsPessoal.TabVisible := True;
  tsEndereco.TabVisible := True;
  tbsConsulta.TabVisible := True;
  teExames.TabVisible := True;
  teAntropometria.TabVisible := True;
  teInquerito.TabVisible := True;
  tePlanoAlimentar.TabVisible := True;

end;

procedure TfmPessoa.cvVideoInqueritoAfterWizardTerminate(Sender: TObject);
begin
  // Salvar itens antes de salvar tudo
  dmMotherBoard.CalcInquerito.Salvar;
  dmMotherBoard.cnDBSalvar.ExecuteTarget(self);
  dmMotherBoard.cnDBSalvar.UpdateTarget(self);
end;

procedure TfmPessoa.cvVideoPlanoAlimentarAfterWizardTerminate(
  Sender: TObject);
begin
  // Salvar itens antes de salvar tudo
  dmMotherBoard.CalcDieta.Salvar;
  dmMotherBoard.cnDBSalvar.ExecuteTarget(self);
  dmMotherBoard.cnDBSalvar.UpdateTarget(self);
end;

procedure TfmPessoa.WizAvDPesExecute(Sender: TObject);
begin
  // Ativa sempre a pasta dos dados pessoais
  tbsPessoal.TabVisible := True;
  tsEndereco.TabVisible := False;

  // Esconde os botoes
  pgcBotoes.Visible := False;

  // Controle manual dos campos em branco
  if deNome.Text = '' then
  begin
    ShowMessage(' Campo "Nome" é obrigatório !!');
    deNome.SetFocus;
  end
  else if deSobrenome.Text = '' then
  begin
    ShowMessage(' Campo "Sobrenome" é obrigatório !!');
    deSobrenome.SetFocus;
  end
  else if DMPessoa.DataVazia(deDataNasc.Text, True) then
  begin
    ShowMessage(' Campo "Data de Nascimento" é obrigatório !!');
    deDataNasc.SetFocus;
  end
  else if DMPessoa.DataMaiorHoje(DMPessoa.TbPessoa.Fieldbyname('DataNasc').asDateTime, False) or
    DMPessoa.DataMaior120anos(DMPessoa.TbPessoa.Fieldbyname('DataNasc').asDateTime, False) or
    DMPessoa.DataVazia(deDataNasc.Text, True) then
  begin
    deDataNasc.SetFocus;
  end
  else if lcSexo.Text = '' then
  begin
    ShowMessage(' Campo "Sexo" é obrigatório !!');
    lcSexo.SetFocus;
  end
  else
  begin
    if (DMPessoa.TbPessoa.state = dsInsert) or (DMPessoa.TbPessoa.state = dsEdit) then
      PessSalExecute(Sender);
    tsEndereco.TabVisible := True;
    pcPessoa.ActivePage := tsEndereco;

    paIndWiz.Visible := True;

    //pcPessoaChange(Sender);
    EndEdiExecute(Sender);

    tsConPessoa.TabVisible := False;
    paIndWiz.ActivePage := tsConEndereco;
    // Quando pessoa estiver ativo, desativo o endereco e vice-versa
    tbsPessoal.TabVisible := False;
    tsEndereco.TabVisible := True;
  end;

end;

procedure TfmPessoa.WizCanDPesExecute(Sender: TObject);
var
  PessoaVazio: boolean;
begin

  if DMPessoa.TbPessoa.RecordCount = 0 then
  begin
    PessoaVazio := True;
  end
  else
  begin
    PessoaVazio := False;
  end;

  // cópia do PessDelExecute(Sender) alterada

  if MessageDlg('Deseja cancelar os dados ? ', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if PessoaVazio then
      DMPessoa.TbPessoa.Cancel
    else if (DMPessoa.TbPessoa.State = dsInsert) or (DMPessoa.TbPessoa.State = dsEdit) then
      DMPessoa.TbPessoa.Delete;

    paInd.Visible := True;

    paDPess.Enabled := False;
    if not DMPessoa.DataVazia(deDataNasc.Text, True) then
      diPess.GDataCompleta;

    // abre todas as orelhinhas da pasta de Pessoa
    AtivarAbasPessoa;

    //Esconde o falso wizard
    tsConPessoa.TabVisible := False;
    tsConEndereco.Tabvisible := False;

    // Apresenta os botoes
    pgcBotoes.Visible := True;

    // ativa a aba de controles
//        paInd.ActivePage := tsControles;

    WizFinalExecute(Sender);

    // Se estiver vazio ou vier do Menu, pergunto se quer cadastrar ou sair do cadastro de pessoa
    if (DMPessoa.TbPessoa.RecordCount = 0) or (ChamadaPeloMenu = True) then
    begin
      //           if MessageDlg('Deseja retornar ao Menu Principal ?' ,
      //              mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      FecharExecute(Sender)
        //           else
//              PessNovExecute(Sender);
    end;

  end;
end;

procedure TfmPessoa.WizVolEndExecute(Sender: TObject);
begin
  if (DMPessoa.TbEndereco.State = dsInsert) or (DMPessoa.TbEndereco.State = dsEdit) then
    EndSalExecute(Sender);
  tbsPessoal.TabVisible := True;
  tsEndereco.TabVisible := False;

  pcPessoa.ActivePage := tbsPessoal;
  PessEdiExecute(Sender);

  // Deixo somente aparecer o conj. de botoes se não estiver no modo wizard
  if paIndWiz.Visible = False then
    paInd.Visible := True;

  paIndWiz.ActivePage := tsConPessoa;

end;

procedure TfmPessoa.WizAvEndExecute(Sender: TObject);
begin
  if (DMPessoa.TbEndereco.State = dsInsert) or (DMPessoa.TbEndereco.State = dsEdit) then
    EndSalExecute(Sender);

  ShowMessage('Serão criadas as Pastas : ' + #13#10 +
    'Anamnese, Exames Laboratoriais, Antropometria, Inquérito, Plano Alimentar' + #13#10 +
    'Você deve incluir uma ficha nova, sempre que necessário.' + #13#10 + #13#10 +
    'Lembre-se que o indivíduo pode ser atribuído a uma pasta para futura pesquisa. Veja em Arquivo/Abrir/Pastas.');

  // abre todas as orelhinhas da pasta de Pessoa
  AtivarAbasPessoa;

  // Agora qualquer alteração não voltara direto para o menu
  ChamadaPeloMenu := False;

  {  tbsConsulta.TabVisible := True;
    teExames.TabVisible := True;
    teAntropometria.TabVisible := True;
    teInquerito.TabVisible := True;
    tePlanoAlimentar.TabVisible := True;  }

 // esconde o falso wizard
  tsConPessoa.TabVisible := False;
  tsConEndereco.Tabvisible := False;

  // Apresenta os botoes
  pgcBotoes.Visible := True;

  // ativa a aba de controles

  //   paInd.ActivePage := tsControles;
  WizFinalExecute(Sender);

end;

procedure TfmPessoa.WizCanEndExecute(Sender: TObject);
begin

  tbsPessoal.TabVisible := True;
  tsEndereco.TabVisible := False;

  pcPessoa.ActivePage := tbsPessoal;
  // ativa a aba de controles
  paIndWiz.ActivePage := tsConPessoa;

  // cópia do PessDelExecute(Sender)

  if MessageDlg('Deseja excluir os dados de ' + Trim(DMPessoa.TbPessoaNomePess.asString) + ' ' +
    DMPessoa.TbPessoaSobrPess.asString + ' ?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    paInd.Visible := True;
    DMPessoa.TbPessoa.Delete;
    paDPess.Enabled := False;
    if not DMPessoa.DataVazia(deDataNasc.Text, True) then
      diPess.GDataCompleta;

    // abre todas as orelhinhas da pasta de Pessoa
    AtivarAbasPessoa;
    pgcBotoes.Visible := True;
    // ativa a aba de controles
//         paInd.ActivePage := tsControles;
    WizFinalExecute(Sender);

    // Se estiver vazio ou vier do menu, pergunto se quer cadastrar ou sair do cadastro de pessoa
    if (DMPessoa.TbPessoa.RecordCount = 0) or (ChamadaPeloMenu = True) then
    begin
      // if MessageDlg('Deseja retornar ao Menu Principal ?' ,
      //    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      FecharExecute(Sender)
        // else
//    PessNovExecute(Sender);
    end;

  end
end;

procedure TfmPessoa.WizInicialExecute(Sender: TObject);
begin
  // Configurações iniciais para os controle deste form
  deNomeCompleto.Top := 2;
  pgcBotoes.Top := 24;
  //!  paInd.Top := 24;
  paInd.Visible := False;

  pcPessoa.Top := 24;
  pgcBotoes.Visible := False;
  paInd.Visible := False;
  paIndWiz.Visible := True;
  paIndWiz.ActivePage := tsConPessoa;

end;

procedure TfmPessoa.WizFinalExecute(Sender: TObject);
begin
  //terminar

   // Configurações finais para os controle deste form
  deNomeCompleto.Top := 2;
  pgcBotoes.Top := 24;
  paInd.Top := 24;

  pcPessoa.Top := 91;
  pgcBotoes.Visible := True;
  pgcBotoes.ActivePage := tbsPessoa;

  paInd.Visible := True;
  paIndWiz.Visible := False;
  pcPessoa.ActivePage := tbsPessoal;

  if not DMPessoa.DataVazia(deDataNasc.Text, True) then
    diPess.GDataCompleta;
end;

procedure TfmPessoa.LocalizarPessExecute(Sender: TObject);
var
  fmLocPess: TfmLocPess;

begin
  DMPessoa.TbPessoabk.Refresh;
  fmLocPess := TfmLocPess.Create(self);
  fmLocPess.WindowState := wsNormal;
  fmLocPess.edBusca.Text := '';
  fmLocPess.ShowModal;

  if fmLocPess.ModalResult = mrOk then
  begin
    if not DMPessoa.TbPessoa.Locate('IDPESSOA', DMPessoa.TbPessoabk.Fieldbyname('IDPESSOA').asString, []) then
      // se não achou o correspondente é porque está vazio, então eu devo entrar direto em modo de inclusão
      ShowMessage('Banco de Dados vazio !! Cadastre um indivíduo.');
  end;
  //#     else if fmLocPess.ModalResult = mrCancel then
  //#             FecharExecute(Sender);

  fmLocPess.Free;

end;

procedure TfmPessoa.FecharExecute(Sender: TObject);
begin
  //###############################################3
  if dmMotherBoard.DBIOController.Fechar then
    //###############################################3
  begin
    ChecaGravacaoPessoaExecute(Sender);
    (**
    Jair - Limpa recurso da tabela
    assim não fica preso para essa aplicação
    **)
    dmSemaforo.LiberaRecurso(FRecurso);
    FRecurso := '';
    Close;
    // Jair e Wagner - criado pra apertar o botão de localizar
  //  if Assigned(FOnClickSaida) and not FModoInserir then
 //      FOnClickSaida(nil);
  end;
end;

procedure TfmPessoa.lcEstadoClick(Sender: TObject);
var
  Filtro: string;

begin
  // se estiver na edicao ou inserçao, pois no modo browse não altero nada)
  if (DMPessoa.TbEndereco.State = dsEdit) or (DMPessoa.TbEndereco.State = dsInsert) then
  begin
    // A cada mudança de Estado, limpa cidade
    DMPessoa.TbEndereco.Fieldbyname('Cidade').asString := '';
    // Vou filtrar o banco Cidade aqui, baseado no escolhido pelo Estado
    Filtro := 'UF=' + '''' + DMPessoa.TbEstado.Fieldbyname('AbrevEstado').asString + '''';
    DMPessoa.TbCidade.Filter := Filtro;
    DMPessoa.TbCidade.Filtered := True;
  end
  else
    DMPessoa.TbCidade.Filtered := False;
end;

procedure TfmPessoa.lcCidadeExit(Sender: TObject);
begin
  DMPessoa.TbCidade.Filtered := False;
end;

procedure TfmPessoa.lcCidadeEnter(Sender: TObject);
var
  Filtro: string;

begin
  // Vou filtrar o banco Cidade aqui, baseado no escolhido pelo Estado
  Filtro := 'UF=' + '''' + DMPessoa.TbEstado.Fieldbyname('AbrevEstado').asString + '''';
  DMPessoa.TbCidade.Filter := Filtro;
  DMPessoa.TbCidade.Filtered := True;
end;

procedure TfmPessoa.AfterNovoCalculo(Sender: TObject);
begin
  AbreCalculoCorrente;
end;

procedure TfmPessoa.pcPessoaChanging(Sender: TObject;
  var AllowChange: Boolean);
begin

  // Saindo de Pessoa sem salvar
  if (pcPessoa.ActivePage = tbsPessoal) and
    ((DMPessoa.TbPessoa.state = dsInsert) or (DMPessoa.TbPessoa.state = dsEdit)) then
  begin
    AllowChange := False;
    ShowMessage('Salve ou cancele seus dados antes de mudar de pasta.');
  end;

  // Saindo de Endereço ou Telefone sem salvar
  if (pcPessoa.ActivePage = tsEndereco) then
  begin
    // Endereco está ativo ?
    if ((DMPessoa.TbEndereco.state = dsInsert) or (DMPessoa.TbEndereco.state = dsEdit) or
      (DMPessoa.TbTelefone.state = dsInsert) or (DMPessoa.TbTelefone.state = dsEdit)) then
    begin
      AllowChange := False;
      ShowMessage('Salve ou cancele seus dados antes de mudar de pasta.');
    end;
  end;

  // Saindo da Anamnese sem gravar
  if (pcPessoa.ActivePage = tbsConsulta) and
    ((DMPessoa.TbAnamnese.state = dsInsert) or (DMPessoa.TbAnamnese.state = dsEdit)) then
  begin
    AllowChange := False;
    ShowMessage('Salve ou cancele seus dados antes de mudar de pasta.');
  end;

  // Saindo da Exames sem gravar
  if (pcPessoa.ActivePage = teExames) and
    ((DMPessoa.TbExaPess.state = dsInsert) or (DMPessoa.TbExaPess.state = dsEdit)) then
  begin
    AllowChange := False;
    ShowMessage('Salve ou cancele seus dados antes de mudar de pasta.');
  end;

end;

procedure TfmPessoa.SetOnClickSaida(const Value: TNotifyEvent);
begin
  FOnClickSaida := Value;
end;

procedure TfmPessoa.puAnamnesePopup(Sender: TObject);
begin
   miAnamnese.Caption := '&Imprimir Anamnese de ' + DMPessoa.TbAnamnese.Fieldbyname('DATA').asString;  
end;

end.


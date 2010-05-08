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




unit NutMenu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, StdCtrls, Buttons, DBCtrls, ComCtrls, DBTables, DB,
  Grids, Spin, DBGrids, Mask, Tabs, InsFrm, RXDBCtrl, ActnList,
  USalas, OpcSalas, qrprntr, HtmlHlp,Sobre,
  RegEdit, RegConst2, KeyNav, NutCnst, jpeg, ULocAlim, Validade, dmValidade;

type
  // To have a custom preview be used as the default preview,
  // you first define an interface class.  You will provide two
  // functions for this class, Show, and ShowModal.

  TQRMDIPreviewInterface = class(TQRPreviewInterface)
  public
    function Show(AQRPrinter: TQRPrinter): TWinControl; override;
    function ShowModal(AQRPrinter: TQRPrinter): TWinControl; override;
  end;

  Tfm_MenuNut = class(TForm)
    pn_Atalhos: TPanel;
    mn_Principal: TMainMenu;
    mn_Arquivo: TMenuItem;
    mn_Sair: TMenuItem;
    mn_Utilitarios: TMenuItem;
    mn_Ajuda: TMenuItem;
    mn_Conteudo: TMenuItem;
    mn_Dica: TMenuItem;
    mn_Separador1: TMenuItem;
    mn_Sobre: TMenuItem;
    tm_Status: TTimer;
    mn_Calculadora: TMenuItem;
    mn_Separador4: TMenuItem;
    mn_Relatorios: TMenuItem;
    mn_Tabelas: TMenuItem;
    sb_Termina: TSpeedButton;
    sb_Dica: TSpeedButton;
    sb_Ajuda: TSpeedButton;
    stMensagem: TStatusBar;
    ifIndividuo: TInFormBuilder;
    ifAlimento: TInFormBuilder;
    ifTabPes: TInFormBuilder;
    ifPesquisa: TInFormBuilder;
    Individuos1: TMenuItem;
    Alimentos1: TMenuItem;
    ifPastas: TInFormBuilder;
    Opes1: TMenuItem;
    ifOpcoesPess: TInFormBuilder;
    pa_Menu_Visual: TPanel;
    ifTabAli: TInFormBuilder;
    Exportardados1: TMenuItem;
    N1: TMenuItem;
    Indexao1: TMenuItem;
    mnDupAli: TMenuItem;
    ifDuplAlim: TInFormBuilder;
    Abrir1: TMenuItem;
    mn_Pastas: TMenuItem;
    mn_Individuos: TMenuItem;
    mn_Alimentos: TMenuItem;
    mnOpInd: TMenuItem;
    mnOpAlim: TMenuItem;
    mnOpSist: TMenuItem;
    ifOpcoesSistema: TInFormBuilder;
    ifOpcoesAlimentos: TInFormBuilder;
    mn_RelAlim: TMenuItem;
    mn_RelInd: TMenuItem;
    Antrop1: TMenuItem;
    Inq1: TMenuItem;
    pnAtalhoPA: TPanel;
    sbAliLoc: TSpeedButton;
    sbAliInc: TSpeedButton;
    sbPessIncl: TSpeedButton;
    sbPessLoc: TSpeedButton;
    mn_LocAlim: TMenuItem;
    mn_NovoAli: TMenuItem;
    mn_LocInd: TMenuItem;
    mn_NovoIndiv: TMenuItem;
    paBotoesNav: TPanel;
    sbNovo: TSpeedButton;
    sbLocalizar: TSpeedButton;
    sbAnterior: TSpeedButton;
    sbProximo: TSpeedButton;
    sbFechar: TSpeedButton;
    mnRegistro: TMenuItem;
    N2: TMenuItem;
    mnBackup: TMenuItem;
    mnRestore: TMenuItem;
    ifBackup: TInFormBuilder;
    ifRestore: TInFormBuilder;
    mnDesconectar: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure mn_SairClick(Sender: TObject);
    procedure btbSairClick(Sender: TObject);
    procedure mn_ConteudoClick(Sender: TObject);
    procedure mn_DicaClick(Sender: TObject);
    procedure mn_SobreClick(Sender: TObject);
    procedure mn_OpcoesClick(Sender: TObject);
    procedure mn_PesquisaClick(Sender: TObject);
    procedure sb_TerminaClick(Sender: TObject);
    procedure sb_DicaClick(Sender: TObject);
    procedure sb_AjudaClick(Sender: TObject);
    procedure mn_RedeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mn_IndividuosClick(Sender: TObject);
    procedure mn_CalculadoraClick(Sender: TObject);
    procedure mn_ExportarClick(Sender: TObject);
    procedure mn_ImportarClick(Sender: TObject);
    procedure mn_Config_ImpClick(Sender: TObject);
    procedure mn_ImprimirClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure sbLocalizarClick(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure Individuos1Click(Sender: TObject);
    procedure Alimentos1Click(Sender: TObject);
    procedure Alimentos2Click(Sender: TObject);
    //    procedure Indivduos1Click(Sender: TObject);
    procedure Tabelas1Click(Sender: TObject);
    procedure mn_PastasClick(Sender: TObject);

    procedure ClickObjetoSala(Sender: TObject; ObjetoSala: TObjetoSala);
    procedure Indexao1Click(Sender: TObject);
    procedure mnDupAliClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure puIndivClick(Sender: TObject);
    procedure puAlimClick(Sender: TObject);
    procedure mnOpIndClick(Sender: TObject);
    procedure mnOpAlimClick(Sender: TObject);
    procedure mnOpSistClick(Sender: TObject);
    procedure mn_RelAlimClick(Sender: TObject);
    procedure mn_RelIndClick(Sender: TObject);
    procedure Antrop1Click(Sender: TObject);
    procedure Inq1Click(Sender: TObject);
    procedure sbPessLocClick(Sender: TObject);
    procedure mn_NovoAliClick(Sender: TObject);
    procedure mn_LocAlimClick(Sender: TObject);
    procedure sbAliLocClick(Sender: TObject);
    procedure sbAliIncClick(Sender: TObject);
    procedure mn_LocIndClick(Sender: TObject);
    procedure mn_NovoIndivClick(Sender: TObject);
    procedure sbPessInclClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnRegistroClick(Sender: TObject);
    procedure mnBackupClick(Sender: TObject);
    procedure mnRestoreClick(Sender: TObject);
    procedure mnDesconectarClick(Sender: TObject);
    //    procedure FormKeyPress(Sender: TObject; var Key: Char);
    //    procedure FormKeyDown(Sender: TObject; var Key: Word;
    //      Shift: TShiftState);

  private
    { Private declarations }
    function LocateActionByName(ActionList: TActionList; AName: string): TAction;
  public
    { Public declarations }
    FDicaTexto: array[1..2] of string;
    FDica: Integer;
    FEntrou: Boolean;
    FGavetaAberta: Integer;
    FHelpAtivado: Boolean;
    FRestore: boolean;

    procedure Iniciar;
    procedure Termina;
    procedure Mostra_Dica(InicioAplicacao: Boolean = false);
    procedure FechaUltimaGaveta(GavetaAberta: integer);
    procedure Mostra_Sobre;
    procedure Mostra_Ajuda;
    procedure MsgManut;
    procedure HabilitaMenu;
    procedure DesabilitaMenu;
    procedure CriaFormTabPessoa(Interno: boolean);
    procedure CriaFormTabAlimento(Interno: boolean);
    procedure CriaFormPessoa(Interno: boolean);
    procedure CriaFormAlimento(Interno: boolean);
    procedure CriaFormPastas(Interno: boolean; Ativa: string = '');
    procedure CriaFormOpcoesPess(Interno: boolean);
    procedure CriaFormOpcoesAlim(Interno: boolean);
    procedure CriaFormOpcoesSist(Interno: boolean);
    procedure CriaBackup(Interno: boolean);
    procedure CriaRestore(Interno: boolean);

    procedure CriaFormPesquisa(Sequencia: string; Interno: boolean);
    procedure DisplayHint(Sender: TObject);
  end;

var
  fm_MenuNut: Tfm_MenuNut;

  // Minhas variaveis

  lPrimeiraVez: Boolean;

  // Fim das minhas variaveis

implementation

uses NutOpc, NutRelat, NutPesq, NutLogin, NutRede, AnamAlim, AnamMed,
  UManut, DMNutWin, Tabela, UPesquisa, Pessoa, UPessoa, TabAli, Alimento,
  UCadPastas, UOpcoes, DMIndex, UDupAlim, UPessApr, UPrinc, UAlimApresent,
  CadAnam, UopAlim, UOpSist, NutRelatInd, DMMBoard, DMPesq, ULocPess,
  DMAliPrep, NutDica, NovoPreview, UBackup, URestore, DMSemaf;

{$R *.DFM}

// Now define the functions for the interface class.

function TQRMDIPreviewInterface.Show(AQRPrinter: TQRPrinter): TWinControl;
begin
  Result := TfmNovoPreview.CreatePreview(Application, AQRPrinter);

  // You can set options for your preview here
  TfmNovoPreview(Result).bCanPrint := CanPrint;

  TfmNovoPreview(Result).Show;
end;

function TQRMDIPreviewInterface.ShowModal(AQRPrinter: TQRPrinter): TWinControl;
begin
  Result := TfmNovoPreview.CreatePreview(Application, AQRPrinter);

  // You can set options for your preview here
  TfmNovoPreview(Result).bCanPrint := CanPrint;

  TfmNovoPreview(Result).ShowModal;

end;

procedure Tfm_MenuNut.ClickObjetoSala(Sender: TObject; ObjetoSala: TObjetoSala);
begin
  case ObjetoSala of
    //osPorta : Termina; //TForm(Sender).Close;
    osPorta: Close;
    osPrateleira: mn_ConteudoClick(Sender); //ShowMessage( 'Prateleira' );
    osGaveta1a: mn_NovoIndivClick(Sender); //ShowMessage( 'Gaveta1a' );
    osGaveta1b: mn_LocIndClick(Sender); //ShowMessage( 'Gaveta1b' );
    osGaveta2a: mn_NovoAliClick(Sender); //ShowMessage( 'Gaveta2a' );
    osGaveta2b: mn_LocAlimClick(Sender); //ShowMessage( 'Gaveta2b' );
    osGaveta3a: Individuos1Click(Sender); //ShowMessage( 'Gaveta3a' )
    osGaveta3b: Alimentos1Click(Sender); //ShowMessage( 'Gaveta3' )
    osCalculadora: mn_CalculadoraClick(Sender); //ShowMessage( 'Calculadora' );
    osLupa: mn_PastasClick(Sender); //ShowMessage( 'Lupa' );
    osCanetaOpInd: mnOpIndClick(Sender); //ShowMessage( 'Caneta' );
    osCanetaOpAlim: mnOpAlimClick(Sender); //ShowMessage( 'Caneta' );
    osCanetaOpSist: mnOpSistClick(Sender); //ShowMessage( 'Caneta' );
    osPapeisAlim: mn_RelAlimClick(Sender); //ShowMessage( 'Papeis' );
    osPapeisInd: mn_RelIndClick(Sender); //ShowMessage( 'Papeis' );
    //      osJanela : Exportardados1Click(Sender); //ShowMessage( 'Janela' );
    osJanela1: Antrop1Click(Sender); //ShowMessage( 'Janela2' );
    osJanela2: Inq1Click(Sender); //ShowMessage( 'Janela1' );
  end;
end;

// Inicio das minhas procedures

procedure Tfm_MenuNut.HabilitaMenu;
begin
  mn_arquivo.Enabled := True;
  mn_calculadora.Enabled := True;
  mn_utilitarios.Enabled := True;

  sbPessIncl.Visible := True;
  sbPessLoc.Visible := True;
  sbAliInc.Visible := True;
  sbAliLoc.Visible := True;

  paBotoesNav.Visible := False;
  //!    pn_Atalhos.Visible := True;
end;

procedure Tfm_MenuNut.CriaFormOpcoesPess(Interno: boolean);
begin
  if interno then
  begin
    ifOpcoesPess.CriaFormInterno(TfmOpcoesPess);
    ifOpcoesPess.ShowInForm;
  end
  else
  begin
    Application.CreateForm(TfmOpcoesPess, fmOpcoesPess);
    try
       (**
       Jair - Trava/libera a pasta para o usuário.
       **)
       if fmOpcoesPess.Travapasta then
       begin
          fmOpcoesPess.ShowModal;
       end;
    finally
       fmOpcoesPess.Liberapasta;
       fmOpcoesPess.Free;
    end;
  end;
end;

procedure Tfm_MenuNut.CriaFormTabPessoa(Interno: boolean);
begin
  if interno then
  begin
    fm_MenuNut.DesabilitaMenu;
    ifTabPes.CriaFormInterno(TfmTabPess);
    ifTabPes.ShowInForm;
  end
  else
  begin
    Application.CreateForm(TfmTabPess, fmTabPess);
    fmTabPess.ShowModal;
    fmTabPess.Free;
  end;
end;

procedure Tfm_MenuNut.CriaFormTabAlimento(Interno: boolean);
begin
  if interno then
  begin
    fm_MenuNut.DesabilitaMenu;
    ifTabAli.CriaFormInterno(TfmTabAli);
    ifTabAli.ShowInForm;
  end
  else
  begin
    Application.CreateForm(TfmTabAli, fmTabAli);
    fmTabAli.ShowModal;
    fmTabAli.Free;
  end;
end;

procedure Tfm_MenuNut.CriaFormPessoa(Interno: boolean);
begin
  //!   pn_Atalhos.Visible := False;
  if Interno then
  begin
    fm_MenuNut.DesabilitaMenu;
    ifIndividuo.CriaFormInterno(TfmPessoa);
    TfmPessoa(ifIndividuo.FormBuilded).paInd := paBotoesNav;
    TfmPessoa(ifIndividuo.FormBuilded).OnClickSaida := sbPessLocClick;
    sbNovo.Action := LocateActionByName(TfmPessoa(ifIndividuo.FormBuilded).alPessoa, 'PessNov'); // TfmPessoa( ifIndividuo.FormBuilded ).alPessoa.Actions[2];
    sbLocalizar.Action := LocateActionByName(TfmPessoa(ifIndividuo.FormBuilded).alPessoa, 'LocalizarPess'); // TfmPessoa( ifIndividuo.FormBuilded ).alPessoa.Actions[45];
    sbAnterior.Action := LocateActionByName(TfmPessoa(ifIndividuo.FormBuilded).alPessoa, 'PessAnterior'); // TfmPessoa( ifIndividuo.FormBuilded ).alPessoa.Actions[3];
    sbProximo.Action := LocateActionByName(TfmPessoa(ifIndividuo.FormBuilded).alPessoa, 'PessProximo'); // TfmPessoa( ifIndividuo.FormBuilded ).alPessoa.Actions[4];
    sbFechar.Action := LocateActionByName(TfmPessoa(ifIndividuo.FormBuilded).alPessoa, 'Fechar'); // TfmPessoa( ifIndividuo.FormBuilded ).alPessoa.Actions[46];
    sbNovo.Glyph.Assign(sbPessIncl.Glyph);
    sbLocalizar.Glyph.Assign(sbPessLoc.Glyph);
    paBotoesNav.Visible := True;
    ifIndividuo.ShowInForm;
  end
  else
  begin
    Application.CreateForm(TfmPessoa, fmPessoa);
    fmPessoa.ShowModal;
    fmPessoa.Free;
  end;

end;

procedure Tfm_MenuNut.CriaFormAlimento(Interno: boolean);
begin
  //!   pn_Atalhos.Visible := False;
  if Interno then
  begin
    fm_MenuNut.DesabilitaMenu;
    ifAlimento.CriaFormInterno(TfmAlim);
    TfmAlim(ifAlimento.FormBuilded).paAlimento := paBotoesNav;
    sbNovo.Action := LocateActionByName(TfmAlim(ifAlimento.FormBuilded).alAlimento, 'AlimNov'); // TfmAlim( ifAlimento.FormBuilded ).alAlimento.Actions[5];
    sbLocalizar.Action := LocateActionByName(TfmAlim(ifAlimento.FormBuilded).alAlimento, 'LocAlim'); // TfmAlim( ifAlimento.FormBuilded ).alAlimento.Actions[38];
    sbAnterior.Action := LocateActionByName(TfmAlim(ifAlimento.FormBuilded).alAlimento, 'AlimAnt'); // TfmAlim( ifAlimento.FormBuilded ).alAlimento.Actions[1];
    sbProximo.Action := LocateActionByName(TfmAlim(ifAlimento.FormBuilded).alAlimento, 'AlimProx'); // TfmAlim( ifAlimento.FormBuilded ).alAlimento.Actions[0];
    sbFechar.Action := LocateActionByName(TfmAlim(ifAlimento.FormBuilded).alAlimento, 'Fechar'); // TfmAlim( ifAlimento.FormBuilded ).alAlimento.Actions[39];
    sbNovo.Glyph.Assign(sbAliInc.Glyph);
    sbLocalizar.Glyph.Assign(sbAliLoc.Glyph);
    paBotoesNav.Visible := True;
    ifAlimento.ShowInForm;
  end
  else
  begin
    Application.CreateForm(TfmAlim, fmAlim);
    fmAlim.ShowModal;
    fmAlim.Free;
  end;
end;

procedure Tfm_MenuNut.CriaFormPastas(Interno: boolean; Ativa: string = '');
begin

  if Interno then
  begin
    fm_MenuNut.DesabilitaMenu;
    ifPastas.CriaFormInterno(TfmCadPastas);
    ifPastas.ShowInForm;
  end
  else
  begin
    Application.CreateForm(TfmCadPastas, fmCadPastas);
    try
      { Os tipos definidos para apresentação sao :
        C = mostra a tela de cadastramento das pastas
        A = mostra a tela de atribuição
        I = informativo. Mostra primeiro Ver Individuos pelas Pastas
       }
      if Ativa = 'C' then
        fmCadPastas.pcPastas.ActivePage := fmCadPastas.tsCadPastas
      else if Ativa = 'A' then
        fmCadPastas.pcPastas.ActivePage := fmCadPastas.tsPastas
      else if Ativa = 'I' then
        fmCadPastas.pcPastas.ActivePage := fmCadPastas.tsIndPas;
      (**
      Jair - Trava pasta escolhida, assim mais de uma pessoa NÃO pode acessar
             essa pasta esteja ela na mesma máquina ou nao.
      **)
      if (dmSemaforo.TravaRecurso('Pst_' + fmCadPastas.Name,'Cadastro de pastas')) then
        fmCadPastas.ShowModal
      else
        ShowMessage('Pasta em uso, favor tentar novamente mais tarde!');
    finally
      begin
        (**
        Jair - Limpa recurso da tabela
        assim não fica preso para essa aplicação
        **)
        dmSemaforo.LiberaRecurso('Pst_' + fmCadPastas.Name);
        fmCadPastas.Free;
      end;
    end;
  end;
end;

procedure Tfm_MenuNut.DesabilitaMenu;
begin
  mn_arquivo.Enabled := False;
  mn_calculadora.Enabled := False;
  mn_utilitarios.Enabled := False;

  sbPessIncl.Visible := False;
  sbPessLoc.Visible := False;
  sbAliInc.Visible := False;
  sbAliLoc.Visible := False;

end;

procedure Tfm_MenuNut.Mostra_Dica(InicioAplicacao: Boolean);
//var
  //Hour, Min, Sec, MSec: Word;
  //fm_Dica: Tfm_Dica;

begin

  Application.CreateForm(Tfm_Dica, fm_Dica);

  // Se for inicio da aplicacao
  if InicioAplicacao then
    if not fm_Dica.CheckBox1.Checked then // trocar por uma variavel de banco ou .ini
    begin
      fm_Dica.Free;
      exit;
    end;

  {// Mostra dica
  DecodeTime(Time, Hour, Min, Sec, MSec);
  If Sec > 30 then
     begin
      FDica := 1;
      fm_Dica.mDica.Text := FDicaTexto[1];
     end
  else
     begin
      FDica := 2;
      fm_Dica.mDica.Text := FDicaTexto[2];
     end; }

  fm_Dica.ShowModal;
  fm_Dica.Free;

end;

procedure Tfm_MenuNut.Termina;
begin
  if MessageDlg('Confirma a saida do programa?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    Close;
  end;

end;

procedure Tfm_MenuNut.Mostra_Sobre;
var
   fmSobre : TfmSobre;
begin
   fmSobre := TfmSobre.Create(self);
   fmSobre.NomeUsuario := DMPessoa.UsuarioLogado;
   fmSobre.ShowModal;
   fmSobre.Free;
end; { end of Sobre }

procedure Tfm_MenuNut.Mostra_Ajuda;
var
  MainPath: string;
begin
  // Seta Individuos como opção não liberada
  if not CarregaChaveString(CFGRoot, CFGPath, 'Path', MainPath) then
  begin
    ShowMessage('Erro de leitura da Chave: Path');
    exit;
  end;

  //  MsgManut;
 //Application.HelpCommand(HELP_FINDER, 0);
  HtmlHelp(0, PChar(MainPath + '\Help\organiza.chm'), HH_DISPLAY_TOC, 0);

end;

procedure Tfm_MenuNut.Iniciar;
var
  //  fm_Log : Tfm_Login;
  Texto: string;
begin

  //seta a data para aparecer completa
//   ShortDateFormat:='dd/mm/yyyy';

  Application.ShowHint := False;
  Application.OnHint := DisplayHint;
  Application.ShowHint := True;
  {  Application.HintColor := clWhite;
    Application.HintPause := 1000;
    Application.CreateForm(Tfm_Login, fm_Log);
    fm_Log.ShowModal;
    fm_Log.Free; }

  fm_MenuNut.pa_Menu_Visual.Align := alClient;

  FDicaTexto[1] := chr(13) + chr(10) + chr(13) + chr(10) +
    '     Combinar as cores dos alimentos,' + chr(13) + chr(10) +
    '     criando pratos atraentes, é uma' + chr(13) + chr(10) +
    '     forma de comer menos...';
  FDicaTexto[2] := chr(13) + chr(10) +
    chr(13) + chr(10) +
    '     Esta é uma versão protótipo,' + chr(13) + chr(10) +
    '     aguarde a nova versão para ter' + chr(13) + chr(10) +
    '     mais dicas...';
  FDica := 1;
  FEntrou := False;
  FGavetaAberta := 0;
  FHelpAtivado := False;

  // Mostra opção de Registro se for versão de avaliação
  with TdmValida.Create(self) do
  try
    DataBaseName := dmMotherBoard.DBOrg.DatabaseName;
    mnRegistro.Visible := (taValidade.FieldByName('Versao_Avaliacao').AsString = 'T')
  finally
    Free;
  end;

  // Seta Individuos como opção não liberada
{  if not CarregaChaveString(CFGRoot, CFGPath, OPCmnOrgAcessoNegado, Texto ) then
     ShowMessage( 'Erro de leitura da Chave: ' + OPCmnOrgAcessoNegado )
  else
     SetMenuListaTag( self, Texto, MN_ACESSONEGADO );
}
  Texto := '';
  SetMenuListaTag(self, Texto, MN_ACESSONEGADO);
end;

procedure Tfm_MenuNut.MsgManut;
var
  fmManu: TfmManut;
begin
  fmManu := TfmManut.Create(self);
  fmManu.ShowModal;
  fmManu.Free;
end;

// Novo evento de Hint

procedure Tfm_MenuNut.DisplayHint(Sender: TObject);
begin
  stMensagem.Panels[0].Text := GetLongHint(Application.Hint);
end; { End of DisplayHint }

// Fim das minhas procedures

procedure Tfm_MenuNut.FormActivate(Sender: TObject);
var
  Valor: Integer;
begin
  if not FEntrou then
  begin
    FEntrou := True;
    if DMPessoa.TbUsuarios.Locate('USERNAME', DMPessoa.UsuarioLogado, []) then
      Valor := DMPessoa.TbUsuarios.FieldByName('FUNDO_TELA').AsInteger
    else
      Valor := OPCTelaDefault;

    with fmOpcSalas do
    begin
      ifSala1.Container := pa_Menu_Visual;
      ifSala2.Container := pa_Menu_Visual;
      EventoObjetoSala := fm_MenuNut.ClickObjetoSala;
      case Valor of
        0: ShowSala2;
        1: ShowSala1;
        2: ShowSala0;
      end;
    end;

    Mostra_Dica(True); // Eh inicio de aplicacao

  end;
end;

procedure Tfm_MenuNut.mn_SairClick(Sender: TObject);
begin
  Close;
end;

procedure Tfm_MenuNut.btbSairClick(Sender: TObject);
begin
  Close;
end;

procedure Tfm_MenuNut.mn_ConteudoClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mn_Conteudo.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  Mostra_Ajuda;
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.mn_DicaClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mn_Dica.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  // Application.CreateForm( Tfm_Dica, fm_Dica) ;
  // fm_Dica.ShowModal;
  // fm_Dica.Free;
  Mostra_Dica;
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.mn_SobreClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mn_Sobre.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  Mostra_Sobre;
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.mn_OpcoesClick(Sender: TObject);

begin
  MsgManut;
end;

procedure Tfm_MenuNut.mn_PesquisaClick(Sender: TObject);
begin
  fm_MenuNut.DesabilitaMenu;
  ifPesquisa.CriaFormInterno(TfmPesquisa);
  ifPesquisa.ShowInForm;
end;

procedure Tfm_MenuNut.sb_TerminaClick(Sender: TObject);
begin
  Close;
end;

procedure Tfm_MenuNut.sb_DicaClick(Sender: TObject);
begin
  Mostra_Dica;
end;

procedure Tfm_MenuNut.sb_AjudaClick(Sender: TObject);
begin
  Mostra_Ajuda;
end;

procedure Tfm_MenuNut.mn_RedeClick(Sender: TObject);
var
  fm_Red: Tfm_Rede;
begin
  fm_Red := Tfm_Rede.Create(self);
  fm_Red.ShowModal;
  fm_Red.Free;
end;

procedure Tfm_MenuNut.FormCreate(Sender: TObject);
begin

  RegisterPreviewClass(TQRMDIPreviewInterface);

  Iniciar;
end;

procedure Tfm_MenuNut.mn_IndividuosClick(Sender: TObject);
// hhhh
begin
end;
{var
stControle : string ;

begin
    // Proibe a entrada nesta opção
    if mn_Individuos.Tag = MN_ACESSONEGADO then
       begin
          ShowMessage( MSG_ACESSONEGADO );
          exit;
       end;

    Application.CreateForm(TfmPessApresent,fmPessApresent);
    fmPessApresent.ShowModal;
    stControle := fmPessApresent.Controle ;
    fmPessApresent.Free;

    // Muda o cursor
    Screen.Cursor := crHourGlass;
    if stControle <> 'Fechar' then
    begin

      CriaFormPessoa( True );

      if (stControle = 'Localizar') or (stControle = 'Alterar') or (stControle = 'Excluir') then
 //        (ifIndividuo.FormBuilded as TfmPessoa).btLocalizarClick( Sender)
         (ifIndividuo.FormBuilded as TfmPessoa).LocalizarPessExecute( Sender)
      else if (stControle = 'Inserir')  then
         (ifIndividuo.FormBuilded as TfmPessoa).PessNovExecute( Sender) ;
    end;
       Screen.Cursor := crDefault;
end; }

procedure Tfm_MenuNut.mn_CalculadoraClick(Sender: TObject);
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  MainPath: string;
begin
  // Proibe a entrada nesta opção
  if mn_Calculadora.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  // Seta Individuos como opção não liberada
  if not CarregaChaveString(CFGRoot, CFGPath, 'Path', MainPath) then
  begin
    ShowMessage('Erro de leitura da Chave: Path');
    exit;
  end;

  Screen.Cursor := crHourGlass;

  fillchar(SI, sizeof(SI), 0);
  SI.cb := sizeof(SI);
  //   MsgManut;
  CreateProcess(PChar(MainPath + '\calc\Calcnut.exe'), '',
    nil,
    nil,
    false,
    0,
    nil,
    nil,
    SI,
    PI);
  Screen.Cursor := crDefault;

end;

procedure Tfm_MenuNut.mn_ExportarClick(Sender: TObject);
begin
  MsgManut;
end;

procedure Tfm_MenuNut.mn_ImportarClick(Sender: TObject);
begin
  MsgManut;
end;

procedure Tfm_MenuNut.mn_Config_ImpClick(Sender: TObject);
begin
  MsgManut;
end;

procedure Tfm_MenuNut.mn_ImprimirClick(Sender: TObject);
begin
  MsgManut;
end;

procedure Tfm_MenuNut.FechaUltimaGaveta(GavetaAberta: integer);
begin

end;

procedure Tfm_MenuNut.BitBtn1Click(Sender: TObject);
begin
  MsgManut;
end;

procedure Tfm_MenuNut.BitBtn2Click(Sender: TObject);
begin
  MsgManut;
end;

procedure Tfm_MenuNut.BitBtn4Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn5Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn6Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn7Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn8Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn9Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn10Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn11Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.sbLocalizarClick(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn16Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn15Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn14Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn13Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.BitBtn12Click(Sender: TObject);
begin
  MsgManut;

end;

procedure Tfm_MenuNut.CriaBackup(Interno: boolean);
var
  MainPath: string;

begin
  if interno then
  begin
    ifBackup.CriaFormInterno(TfmBackup);
    ifBackup.ShowInForm;
  end
  else
  begin
    if not CarregaChaveString(CFGRoot, CFGPath, 'Path', MainPath) then
    begin
      ShowMessage('Erro de leitura da Chave: Path');
      exit;
    end;

    Application.CreateForm(TfmBackup, fmBackup);
    // Seto alguns valores em backup.

    fmBackup.pListaDeArquivos.Add(MainPath + '\IBDADOS\BDADOS.GDB'); //Default
    fmBackup.edTitulo.text := 'Cópia feita por ' + DMPessoa.UsuarioLogado + ' em ' + DateToStr(Date);
    fmBackup.edArquivo.text := 'A:\NUTWIN.BNW';
    try
       (**
       Jair - Trava/libera a pasta para o usuário.
       **)
       if fmBackup.Travapasta then
       begin
          fmBackup.ShowModal;
       end;
    finally
       fmBackup.Liberapasta;
       fmBackup.Free;
    end;
  end;

end;

procedure Tfm_MenuNut.CriaRestore(Interno: boolean);
begin
  if interno then
  begin
    ifRestore.CriaFormInterno(TfmRestore);
    ifRestore.ShowInForm;
  end
  else
  begin
    Application.CreateForm(TfmRestore, fmRestore);
    try
       (**
       Jair - Trava/libera a pasta para o usuário.
       **)
       if fmRestore.Travapasta then
       begin
          fmRestore.ShowModal;
       end;
    finally
       fmRestore.Liberapasta;
       fmRestore.Free;
    end;
  end;

end;

procedure Tfm_MenuNut.Individuos1Click(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if Individuos1.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  CriaFormTabPessoa(True);
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.Alimentos1Click(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if Alimentos1.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  CriaFormTabAlimento(True);
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.Alimentos2Click(Sender: TObject);
begin
  fmRelatorios := TfmRelatorios.Create(self);
  // fmRelatorios.CriaRelAlimentos;
  fmRelatorios.ShowModal;
  fmRelatorios.pgcRelatorio.ActivePage := fmRelatorios.tbsRelAlimentos;

  // fmRelatorios.Free;
end;

{procedure Tfm_MenuNut.Indivduos1Click(Sender: TObject);
var
  fmRel : TfmRelatorios;
begin
  fmRel := TfmRelatorios.Create(self);
  fmRel.ShowModal;
  fmRel.pgcRelatorio.ActivePage  := fmRel.tbsRelIndividuos;
  fmRel.Free;
end;}

procedure Tfm_MenuNut.Tabelas1Click(Sender: TObject);
var
  fmRel: TfmRelatorios;
begin
  fmRel := TfmRelatorios.Create(self);
  fmRel.ShowModal;
  fmRel.Free;
end;

{procedure Tfm_MenuNut.mn_RelatoriosClick(Sender: TObject);
begin
    // Proibe a entrada nesta opção
    if mn_Relatorios.Tag = MN_ACESSONEGADO then
       begin
          ShowMessage( MSG_ACESSONEGADO );
          exit;
       end;

  Screen.Cursor := crHourGlass;
  fm_MenuNut.DesabilitaMenu;
  fmRelatorios := TfmRelatorios.Create(self);
  fmRelatorios.CriaRelAlimentos;
  fmRelatorios.CriaRelPessoa;
  fmRelatorios.CriaRelTabAlim;
  fmRelatorios.ShowModal;
  fmRelatorios.LimpaMemoriaAlim ;
  fmRelatorios.Free;
  fm_MenuNut.HabilitaMenu;
  Screen.Cursor := crDefault;
end;}

procedure Tfm_MenuNut.mn_PastasClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mn_Pastas.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  CriaFormPastas(False);
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.Indexao1Click(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if Indexao1.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  DMIndexacao.Indexar;
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.mnDupAliClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mnDupAli.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  fm_MenuNut.DesabilitaMenu;

  Screen.Cursor := crHourGlass;
  ifDuplAlim.CriaFormInterno(TfmDupAlim);
  ifDuplAlim.ShowInForm;

  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  if MessageDlg('Confirma a saida do programa?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    for I := Application.ComponentCount - 1 downto 0 do
      if Application.Components[I].ClassType = TfmNovoPreview then
        TfmNovoPreview(Application.Components[I]).Close;
    Action := caFree;
  end
  else
    Action := caNone;
end;

procedure Tfm_MenuNut.puIndivClick(Sender: TObject);
begin
  Individuos1Click(Sender);
end;

procedure Tfm_MenuNut.puAlimClick(Sender: TObject);
begin
  Alimentos1Click(Sender);
end;

procedure Tfm_MenuNut.CriaFormPesquisa(Sequencia: string; Interno: boolean);
begin
  if interno then
  begin
    ifPesquisa.CriaFormInterno(TfmPesquisa);
    DMPesquisa.Sequencia := Sequencia;
    ifPesquisa.ShowInForm;
  end
  else
  begin
    Application.CreateForm(TfmPesquisa, fmPesquisa);
    DMPesquisa.Sequencia := Sequencia;
    fmPesquisa.ShowModal;
    fmPesquisa.Free;
  end;
end;

{procedure Tfm_MenuNut.FormKeyPress(Sender: TObject; var Key: Char);
begin

   if key = CHR(VK_RETURN) then
   begin
      key := #0 ;
      if (Sender is TDBGrid) then
         TDBGrid(Sender).Perform(WM_KeyDown, VK_Tab, 0)   // para grids
      else if (Sender is TRxDBGrid) then
         TRxDBGrid(Sender).Perform(WM_KeyDown, VK_Tab, 0)  // para DBGrids
      else if (Sender is TDBRichEdit) then
         TDBRichEdit(Sender).Perform(WM_KeyDown, VK_Tab, 0)  // Para DBRichEdit
      else
         Perform(Wm_NextDlgCtl,0,0);
   end;

end;}

{procedure Tfm_MenuNut.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      // O dblookupCombobox usa as teclas para cima e para baixo como forma de selecionar uma opção.

  {if not(ActiveControl is TDBLookupCombobox) then
     begin
       if Key = VK_UP then
          SelectNext(ActiveControl,False,True);
       if Key = VK_DOWN then
          SelectNext(ActiveControl,True,True);
       if Key = VK_PRIOR then
          begin
            SelectFirst;
            if (ActiveControl is TPageControl) then
               SelectNext(ActiveControl,True,True);
          end;
       if Key = VK_NEXT then
          begin
           SelectFirst;
           SelectNext(ActiveControl,False,True);
          end;
    end;
end;    }

procedure Tfm_MenuNut.CriaFormOpcoesAlim(Interno: boolean);
begin
  if interno then
  begin
    ifOpcoesAlimentos.CriaFormInterno(TfmOpcoesAlimentos);
    ifOpcoesAlimentos.ShowInForm;
  end
  else
  begin
    Application.CreateForm(TfmOpcoesAlimentos, fmOpcoesAlimentos);
    try
       (**
       Jair - Trava/libera a pasta para o usuário.
       **)
       if fmOpcoesAlimentos.Travapasta then
       begin
          fmOpcoesAlimentos.ShowModal;
       end;
    finally
       fmOpcoesAlimentos.Liberapasta;
       fmOpcoesAlimentos.Free;
    end;
  end;
end;

procedure Tfm_MenuNut.CriaFormOpcoesSist(Interno: boolean);
begin
  if interno then
  begin
    ifOpcoesSistema.CriaFormInterno(TfmOpcoesSistema);
    ifOpcoesSistema.ShowInForm;
  end
  else
  begin
    Application.CreateForm(TfmOpcoesSistema, fmOpcoesSistema);
    try
       (**
       Jair - Trava/libera a pasta para o usuário.
       **)
       if fmOpcoesSistema.Travapasta then
       begin
          fmOpcoesSistema.ShowModal;
       end;
    finally
       fmOpcoesSistema.Liberapasta;
       fmOpcoesSistema.Free;
    end;
  end;

end;

procedure Tfm_MenuNut.mnOpIndClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mnOpInd.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  CriaFormOpcoesPess(False);
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.mnOpAlimClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mnOpAlim.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  CriaFormOpcoesAlim(False);
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.mnOpSistClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mnOpSist.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  CriaFormOpcoesSist(False);
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.mn_RelAlimClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mn_RelAlim.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  fm_MenuNut.DesabilitaMenu;
  fmRelatorios := TfmRelatorios.Create(self);
  fmRelatorios.CriaRelAlimentos;
  // fmRelatorios.CriaRelPessoa;
  fmRelatorios.ShowModal;
  // fmRelatorios.LimpaMemoriaAlim ;
  // fmRelatorios.Free;
  fm_MenuNut.HabilitaMenu;
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.mn_RelIndClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mn_RelInd.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  fm_MenuNut.DesabilitaMenu;
  fmNutRelInd := TfmNutRelInd.Create(self);
  fmNutRelInd.ShowModal;
  //  fmNutRelInd.LimpaMemoriaAlim ;
  fmNutRelInd.Free;
  fm_MenuNut.HabilitaMenu;
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.Antrop1Click(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if Antrop1.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;
  if DMPessoa.TbPessoa.RecordCount = 0 then
    // Tabela Vazia
    ShowMessage('Não temos dados cadastrados para gerar a Pesquisa.')
  else
    CriaFormPesquisa('Pesquisa', False);
  // Esta sequencia tem os seguintes forms:
  // fmTelaPrincipal, fmPesquisa, fmPPastas, fmPselDados, fmSelecionaInqueritos
end;

procedure Tfm_MenuNut.Inq1Click(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if Inq1.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  if DMPessoa.TbPessoa.RecordCount = 0 then
    // Tabela Vazia
    ShowMessage('Não temos dados cadastrados para gerar a Pesquisa.')
  else
    CriaFormPesquisa('PesqInq', False);
  // Esta sequencia tem os seguintes forms:
  // fmTelaPrincipal, fmPesquisa, fmPPastas, fmPselDados, fmSelecionaInqueritos
end;

procedure Tfm_MenuNut.sbPessLocClick(Sender: TObject);
begin
  mn_LocIndClick(Sender);

end;

procedure Tfm_MenuNut.mn_NovoAliClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mn_Alimentos.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  // Muda o cursor
  Screen.Cursor := crHourGlass;

  CriaFormAlimento(True);

  // Seto a variavel para dizer que chamei pelo menu
  (ifAlimento.FormBuilded as TfmAlim).ChamadaPeloMenu := True;

  // Novo Alimento
  (ifAlimento.FormBuilded as TfmAlim).AlimNovExecute(Sender);
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.mn_LocAlimClick(Sender: TObject);
var
  fmLocAlimento: TfmLocAlim;
  IDAliEscolhido: string;
begin
  // Proibe a entrada nesta opção
  if mn_Alimentos.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  // Muda o cursor
  Screen.Cursor := crHourGlass;

  //############

  fmLocAlimento := TFmLocAlim.Create(self);
  try
    fmLocAlimento.ShowModal;
    // restabelece defaults, pois outros vão usar esta instância
    dmMotherBoard.ListaAlimento.DefineDefaults;
    dmMotherBoard.ListaAlimento.Refresh;
    // Pega o ID escolhido pois na linha seguinte o ponteiro deste vai mudar
//     IDALIEscolhido := dmMotherBoard.AlimentoCorrente.IDAlimento; // não está funcionando da 1a. vez
    IDALIEscolhido := fmLocAlimento.IDAliEscolhido;
    if fmLocAlimento.ModalResult = mrOk then
    begin
      if not DMAlimentos.TbAlimento.Locate('IDALI', IDALIEscolhido, []) then
        // se não achou o correspondente é porque está vazio, então eu devo entrar direto em modo de inclusão
        ShowMessage('Banco de Dados vazio !! Cadastre um alimento.')
      else
        CriaFormAlimento(True);
    end
  finally
    fmLocAlimento.Free;
  end;

  //############

  //#   CriaFormAlimento( True );
     // Localiza Alimento
  //#  (ifAlimento.FormBuilded as TfmAlim).LocAlimExecute( Sender) ;
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.sbAliLocClick(Sender: TObject);
begin
  mn_LocAlimClick(Sender);
end;

procedure Tfm_MenuNut.sbAliIncClick(Sender: TObject);
begin
  mn_NovoAliClick(Sender);
end;

procedure Tfm_MenuNut.mn_LocIndClick(Sender: TObject);
var
  fmLocPess: TfmLocPess;
begin
  // Proibe a entrada nesta opção
  if mn_Individuos.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  // Muda o cursor
  Screen.Cursor := crHourGlass;

  if DMPessoa.TbPessoa.RecordCount = 0 then
    // Tabela Vazia
  begin
    if MessageDlg('Base de Dados vazia. Deseja cadastrar novo indivíduo ?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      CriaFormPessoa(True);
      // Novo Individuo
      (ifIndividuo.FormBuilded as TfmPessoa).PessNovExecute(Sender);
    end;
  end
  else
  begin

    //##############

    DMPessoa.TbPessoabk.Refresh;
    fmLocPess := TfmLocPess.Create(self);
    fmLocPess.WindowState := wsNormal;
    fmLocPess.edBusca.Text := '';
    fmLocPess.ShowModal;

    if fmLocPess.ModalResult = mrOk then
    begin
      fmLocPess.Free;
      if not DMPessoa.TbPessoa.Locate('IDPESSOA', DMPessoa.TbPessoabkIDPESSOA.asString, []) then
        // se não achou o correspondente é porque está vazio, então eu devo entrar direto em modo de inclusão
        ShowMessage('Banco de Dados vazio !! Cadastre um indivíduo.')
      else
        CriaFormPessoa(True);
    end
    else
      fmLocPess.Free;

    //##############

    //#         CriaFormPessoa( True );
              // Localiza individuo
    //#         (ifIndividuo.FormBuilded as TfmPessoa).LocalizarPessExecute( Sender) ;
  end;
  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.mn_NovoIndivClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mn_Individuos.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  // Muda o cursor
  Screen.Cursor := crHourGlass;

  CriaFormPessoa(True);

  // Setar a variável ChamadaPeloMenu como True
  (ifIndividuo.FormBuilded as TfmPessoa).ChamadaPeloMenu := True;

  // Novo Individuo
  (ifIndividuo.FormBuilded as TfmPessoa).PessNovExecute(Sender);

  Screen.Cursor := crDefault;
end;

procedure Tfm_MenuNut.sbPessInclClick(Sender: TObject);
begin
  mn_NovoIndivClick(Sender);
end;

function Tfm_MenuNut.LocateActionByName(ActionList: TActionList; AName: string): TAction;
var
  I: Integer;
begin

  for I := 0 to ActionList.ActionCount - 1 do
    if UpperCase(ActionList.Actions[I].Name) = UpperCase(AName) then
    begin
      Result := TAction(ActionList.Actions[I]);
      exit;
    end;

  ShowMessage('O Action: ' + AName + ' não existe na ActionList: ' + ActionList.Name);

  Result := nil;

end;

procedure Tfm_MenuNut.FormShow(Sender: TObject);
begin
  if DMPessoa.UsuarioLogado = '' then
    fm_MenuNut.Caption := 'Programa de Apoio à Nutrição'
  else
    fm_MenuNut.Caption := 'Programa de Apoio à Nutrição    ' + 'Usuário: ' + DMPessoa.UsuarioLogado;

end;

procedure Tfm_MenuNut.mnRegistroClick(Sender: TObject);
begin
  //Validade do programa
  with TfmValidade.Create(nil) do
  try
    DataBaseName := 'BDOrganizador';
    //     ShowMessage( IntToStr(TipoValidade));
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
      REGISTRO_AVALIACAO: ShowModal;
      REGISTRO_OK: ; // não faz nada
    end;
    // se registrou esconde opção do menu
    mnRegistro.Visible := not (PfRegistrou);
  finally
    Free;
  end;
end;

procedure Tfm_MenuNut.mnBackupClick(Sender: TObject);
begin
  // Proibe a entrada nesta opção
  if mnBackup.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  CriaBackup(False);
  Screen.Cursor := crDefault;

end;

procedure Tfm_MenuNut.mnRestoreClick(Sender: TObject);
var
  I: integer;

begin
  // Proibe a entrada nesta opção
  if mnRestore.Tag = MN_ACESSONEGADO then
  begin
    ShowMessage(MSG_ACESSONEGADO);
    exit;
  end;

  FRestore := False;
  if MessageDlg('O programa disponibiliza duas formas de restaurar seus dados.' + #13#10 +
    'No primeiro modo, será EXCLUÍDA toda a base de dados e gravada a do disquete.' + #13#10 +
    'Na outra opção, o arquivo BDADOS.GDB será gravado no local de sua escolha e deverá depois ser copiado em cima do banco original.' + #13#10 +
    'Deseja continuar ?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    // Fechando todos os DataModules para não dar problemas no restore.
    for I := Application.ComponentCount - 1 downto 0 do
    begin
      if (Application.Components[I] is TDataModule) then
        (Application.Components[I]).Free;
    end;
    FRestore := True;
    Screen.Cursor := crHourGlass;
    Showmessage('Atenção !!! Estamos desconectando os bancos de dados. ' + #13#10 +
      'Após sair desta opção, o programa voltará para a tela do Windows.');
    CriaRestore(False);
    Screen.Cursor := crDefault;
    Showmessage('O programa será agora finalizado. Chame-o novamente para que sejam refeitas as configurações.');
    Application.Terminate;

    {         Caso necessite reabrir todos os DataModules, desative estas linhas
                // Cria e seta tabelas temporárias
               Application.CreateForm(TdmCriaTabelasTemp, dmCriaTabelasTemp);
               // Cria e seta Tabelas de Alimentos
               Application.CreateForm(TDMAlimentos, DMAlimentos);
              // Cria e seta Tabelas de Medidas
              Application.CreateForm(TDMedidas, DMedidas);
              // Cria e seta Tabelas de Substitutos
              Application.CreateForm(TDMSubsCalorico, DMSubsCalorico);
              // Cria e seta Tabelas de Pessoas
              Application.CreateForm(TDMPessoa, DMPessoa);
              // Cria e seta Tabelas de Nutrientes
              Application.CreateForm(TDMNutrientes, DMNutrientes);
              // Cria componentes de gráficos
              Application.CreateForm(TdmGraficos, dmGraficos);
              // Cria componentes da calculadora
          //    Application.CreateForm(TdmHlp, dmHlp);
              Application.CreateForm(TdmMotherBoard, dmMotherBoard);
              // Cria e seta Tabelas de Pesquisa
              Application.CreateForm(TDMPesquisa, DMPesquisa);
              Close; }
  end;
end;

procedure Tfm_MenuNut.mnDesconectarClick(Sender: TObject);
begin
     // Abre janela de logim/senha
     DMPessoa.TbUsuarios.Open;
     if fm_Login.ShowModal = mrOk then
     begin
        DMPessoa.UsuarioLogado := DMPessoa.TbUsuarios.fieldbyname('Username').asString;
        FormShow(Sender);
        Iniciar;
        with fmOpcSalas do
        begin
            Container := fm_MenuNut.pa_Menu_Visual;
            Modal := False;
            EventoObjetoSala := fm_MenuNut.ClickObjetoSala;
            case DMPessoa.TbUsuarios.FieldByName('FUNDO_TELA').AsInteger of
              0 : ShowSala2;
              1 : ShowSala1;
              2 : ShowSala0;
            end;
       end;
     end;
end;

initialization

  // Meus comandos de inicialização

  lPrimeiraVez := True;

  // Fim dos meus comandos

end.


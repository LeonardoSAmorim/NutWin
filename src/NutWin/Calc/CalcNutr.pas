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




unit CalcNutr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons, StdCtrls, ComCtrls, Menus, ToolWin, DMMBoard, CalculoViewer,
  ActnList, NutCnst, CalculoTextViewer, qrprntr, jpeg, NovoPreview, HtmlHlp,
  RegConst2, RegEdit;

type
  // To have a custom preview be used as the default preview,
  // you first define an interface class.  You will provide two
  // functions for this class, Show, and ShowModal.

  TQRMDIPreviewInterface = class(TQRPreviewInterface)
  public
    function Show(AQRPrinter : TQRPrinter) : TWinControl; override;
    function ShowModal(AQRPrinter : TQRPrinter): TWinControl; override;
  end;

  TfmCalcNutr = class(TForm)
    mmMenuPrincipal: TMainMenu;
    mmArquivo: TMenuItem;
    mmArqNovo: TMenuItem;
    mmArqAbrir: TMenuItem;
    mmArqSalvar: TMenuItem;
    mmArqSalvarComo: TMenuItem;
    mmArqSeparador2: TMenuItem;
    mmArqSair: TMenuItem;
    mmCalcular: TMenuItem;
    mmCalcAntropometria: TMenuItem;
    mmCalcRecCalorica: TMenuItem;
    mmCalcAtivFisica: TMenuItem;
    mmCalcEspeciais: TMenuItem;
    mmCalcInquerito: TMenuItem;
    mmCalcDieta: TMenuItem;
    mmAjuda: TMenuItem;
    mmHlpConteudo: TMenuItem;
    mmHlpSeparador: TMenuItem;
    mmHlpSobre: TMenuItem;
    mmConfigurar: TMenuItem;
    mmCfgCalcAntrop: TMenuItem;
    mmCalcSeparador: TMenuItem;
    mmCalcCalcular: TMenuItem;
    mmCalcPreparacao: TMenuItem;
    alMenuNut: TActionList;
    mnArqSair: TAction;
    mmArqFechar: TMenuItem;
    mmArqSeparador1: TMenuItem;
    mmCalcInqFrequencia: TMenuItem;
    mmCalcMetas: TMenuItem;
    cvVideo: TCalculoViewer;
    mnHlpConteudo: TAction;
    mnHlpSobre: TAction;
    mnCfgCalcAntrop: TAction;
    mnArqImprimir: TAction;
    mmCfgNutrientes: TMenuItem;
    mnCfgNutrientes: TAction;
    VerResultados1: TMenuItem;
    paPapel: TPanel;
    CalculoTextViewer1: TCalculoTextViewer;
    reVisorCalculoComp: TRichEdit;
    spDivisor: TSplitter;
    laAviso: TLabel;
    paCalcKeyBoard: TPanel;
    imSkin: TImage;
    beOp1: TBevel;
    toOpArq: TToolBar;
    btArqNovo: TToolButton;
    btArqAbrir: TToolButton;
    btArqSlavar: TToolButton;
    btArqFechar: TToolButton;
    toOpSis: TToolBar;
    tbOpSis: TToolButton;
    btSair: TToolButton;
    toOpCalculos: TToolBar;
    btCalcAntropometria: TToolButton;
    btCalcRecCalorica: TToolButton;
    btCalcAtivFisica: TToolButton;
    btCalcInquerito: TToolButton;
    btCalcDieta: TToolButton;
    btCalcPreparacao: TToolButton;
    bbCalcCalcular: TSpeedButton;
    sbVisualizar: TSpeedButton;
    beOp2: TBevel;
    ppSkin: TPopupMenu;
    Pele11: TMenuItem;
    Pele21: TMenuItem;
    imVisor: TImage;
    laDisplay: TLabel;
    stMensagem: TStatusBar;
    paMargem: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnArqSairExecute(Sender: TObject);
    procedure mnHlpConteudoExecute(Sender: TObject);
    procedure mnHlpSobreExecute(Sender: TObject);
    procedure mnCfgCalcAntropExecute(Sender: TObject);
    procedure mnArqImprimirExecute(Sender: TObject);
    procedure mnArqImprimirUpdate(Sender: TObject);
    procedure cvVideoBeforePreview(Sender: TObject; var Cancel: Boolean);
    procedure mnArqSairUpdate(Sender: TObject);
    procedure mnCfgNutrientesExecute(Sender: TObject);
    procedure CalculoTextViewer1BeforePreview(Sender: TObject;
      var Cancel: Boolean);
    procedure CalculoTextViewer1AfterPreview(Sender: TObject);
    procedure Pele11Click(Sender: TObject);
    procedure Pele21Click(Sender: TObject);
    procedure reVisorCalculoCompChange(Sender: TObject);

  private
    { Private declarations }
    FPodeFechar : Boolean;

    // Para armazenar os eventos antigos
    FDepoisDeAbrir : TNotifyEvent;
    FDepoisDeFechar : TNotifyEvent;
    FDepoisDeNovo : TNotifyEvent;
    FDepoisDeGravar : TNotifyEvent;

//     procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
    procedure DepoisDeAbrir( Sender : TObject );
    procedure DepoisDeFechar( Sender : TObject );
    procedure DepoisDeNovo( Sender : TObject );
    procedure DepoisDeGravar( Sender : TObject );
  public
    { Public declarations }
    procedure Mostra_Ajuda;

  end;
var
  fmCalcNutr: TfmCalcNutr;

implementation

uses DumpMem;

{$R *.DFM}

// Now define the functions for the interface class.

function TQRMDIPreviewInterface.Show(AQRPrinter : TQRPrinter) : TWinControl;
begin
  Result := TfmNovoPreview.CreatePreview(Application, AQRPrinter);

  // You can set options for your preview here
  TfmNovoPreview(Result).bCanPrint := CanPrint;

  TfmNovoPreview(Result).Show;
end;

function TQRMDIPreviewInterface.ShowModal(AQRPrinter : TQRPrinter) : TWinControl;
begin
  Result := TfmNovoPreview.CreatePreview(Application, AQRPrinter);

  // You can set options for your preview here
  TfmNovoPreview(Result).bCanPrint := CanPrint;

  TfmNovoPreview(Result).ShowModal;

end;

procedure TfmCalcNutr.FormCreate(Sender: TObject);
//var
//FrmHandle : THandle;
begin
  RegisterPreviewClass(TQRMDIPreviewInterface);
//FrmHandle:= CreateRoundRectRgn(
//0, {coordenada x do canto superior esquerdo da região}
//0, {coordenada y do canto superior esquerdo da região}
//Width, {coordenada x do canto inferior direito da região}
//Height, {coordenada y do canto inferior direito da região}
//50, {altura da elipse para os cantos redondos}
//50 {largura da elipse para os cantos redondos}
//);
//SetWindowRgn(Handle,FrmHandle,True);

//    Application.HelpFile := GetPathExe + '..\Help\Formulas.hlp';
//    dmMotherBoard.Iniciar( cvVideo );
    dmMotherBoard.Iniciar( CalculoTextViewer1 );
    Caption := dmMotherBoard.TituloVersao;
    laDisplay.Caption := laAviso.Caption;

    // Guardando antigos eventos para chamar dentro dos novos
    FDepoisDeNovo := dmMotherBoard.IOController.OnDepoisDeNovo;
    FDepoisDeAbrir := dmMotherBoard.IOController.OnDepoisDeAbrir;
    FDepoisDeFechar := dmMotherBoard.IOController.OnDepoisDeFechar;
    FDepoisDeGravar := dmMotherBoard.IOController.OnDepoisDeGravar;
    // Novos eventos
    dmMotherBoard.IOController.OnDepoisDeNovo := DepoisDeNovo;
    dmMotherBoard.IOController.OnDepoisDeAbrir := DepoisDeAbrir;
    dmMotherBoard.IOController.OnDepoisDeFechar := DepoisDeFechar;
    dmMotherBoard.IOController.OnDepoisDeGravar := DepoisDeGravar;


end;

procedure TfmCalcNutr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := dmMotherBoard.Terminar;
end;

procedure TfmCalcNutr.mnArqSairExecute(Sender: TObject);
begin
   Close;
end;

procedure TfmCalcNutr.mnHlpConteudoExecute(Sender: TObject);
begin
//   dmMotherBoard.Ajuda;
   Mostra_Ajuda;
end;

procedure TfmCalcNutr.mnHlpSobreExecute(Sender: TObject);
begin
   dmMotherBoard.Sobre;
end;

procedure TfmCalcNutr.mnCfgCalcAntropExecute(Sender: TObject);
begin
   dmMotherBoard.CfgCalcAntrop;
end;

procedure TfmCalcNutr.mnArqImprimirExecute(Sender: TObject);
begin
   dmMotherBoard.Imprimir;
end;

procedure TfmCalcNutr.mnArqImprimirUpdate(Sender: TObject);
begin
    mnArqImprimir.Enabled := not (dmMotherBoard.CalcNut.Empty ) and
                             not ( CalculoTextViewer1.Calculando ) and
                             dmMotherBoard.PodeImprimir( CalculoTextViewer1.CalculoCorrente );
end;

procedure TfmCalcNutr.cvVideoBeforePreview(Sender: TObject;
  var Cancel: Boolean);
begin
   CalculoTextViewer1.Print := dmMotherBoard.PodeImprimir( CalculoTextViewer1.CalculoCorrente );
end;

procedure TfmCalcNutr.mnArqSairUpdate(Sender: TObject);
begin
   mnArqSair.Enabled := not ( CalculoTextViewer1.Calculando )
end;

procedure TfmCalcNutr.mnCfgNutrientesExecute(Sender: TObject);
begin
   dmMotherBoard.CfgNutrientes;
end;

{Procedimento que permite mover a janela sem o title bar}
//procedure TfmCalcNutr.WMNCHitTest(var M: TWMNCHitTest);
//begin
//inherited; {chamar o handle da mensagem herdada}
//if M.Result = htClient then {Testar o click é na área cliente da form}
//M.Result := htCaption; {Se é então fazemos o Windows pensar que é no title bar}
//end;

//******** Eventos de teste *********************************************

procedure TfmCalcNutr.FormShow(Sender: TObject);
begin
//   Dump.Show;
   DepoisDeFechar(Sender);
end;

procedure TfmCalcNutr.DepoisDeAbrir(Sender: TObject);
var
   I : Integer;
begin
   // Chamando evento original
   if Assigned( FDepoisDeAbrir ) then
      FDepoisDeAbrir(Sender);

   for I := 0 to toOpCalculos.ButtonCount - 1 do
      begin
         TToolButton( toOpCalculos.Buttons[I] ).Grouped := True;
         TToolButton( toOpCalculos.Buttons[I] ).Down := False;
      end;
      CalculoTextViewer1.DefineCalculo(ncNenhum);
      Caption := dmMotherBoard.TituloNomeArquivo;
      reVisorCalculoComp.Clear;
      reVisorCalculoComp.Lines.Add( 'ARQUIVO ABERTO COM SUCESSO!' );
//      reVisorCalculoComp.Lines.Add( '' );
      reVisorCalculoComp.Lines.Add( 'NOME: ' + dmMotherBoard.caProcessador.Memoria.NomeArquivo );
      reVisorCalculoComp.Lines.Add( 'SELECIONE UM DOS TIPOS DE CÁLCULO NOS BOTÕES OU MENU' );
      reVisorCalculoComp.Lines.Add( 'EM CÁLCULOS, PARA VISUALIZAR OU [IMPRIMIR] O RESULTADO.' );
      reVisorCalculoComp.Lines.Add( 'PARA CALCULA-LO, PRESSIONE A OPÇÃO [CALCULAR]' );
      FPodeFechar := True;
      CalculoTextViewer1.Visible := True;
end;

procedure TfmCalcNutr.DepoisDeFechar(Sender: TObject);
var
   I : Integer;
begin

   // Chamando evento original
   if Assigned( FDepoisDeFechar ) then
      FDepoisDeFechar(Sender);

   for I := 0 to toOpCalculos.ButtonCount - 1 do
      begin
         TToolButton( toOpCalculos.Buttons[I] ).Grouped := False;
         TToolButton( toOpCalculos.Buttons[I] ).Down := False;
      end;
//      CalculoTextViewer1.ShowPreview;
      Caption := dmMotherBoard.TituloVersao;
      if FPodeFechar then
      begin
         reVisorCalculoComp.Clear;
         reVisorCalculoComp.Lines.Add( 'ARQUIVO FECHADO COM SUCESSO!' );
//         reVisorCalculoComp.Lines.Add( '' );
         reVisorCalculoComp.Lines.Add( 'PARA FAZER UM CÁLCULO, VOCE PRECISA' );
         reVisorCalculoComp.Lines.Add( 'CRIAR UM NOVO ARQUIVO OU ABRIR UM JÁ' );
         reVisorCalculoComp.Lines.Add( 'EXISTENTE, USANDO OS BOTÕES OU MENU' );
         reVisorCalculoComp.Lines.Add( 'EM ARQUIVO.' );
         FPodeFechar := False;
         CalculoTextViewer1.Visible := False;
      end;
end;

procedure TfmCalcNutr.DepoisDeNovo(Sender: TObject);
begin

   // Chamando evento original
   if Assigned( FDepoisDeNovo ) then
      FDepoisDeNovo(Sender);

   DepoisDeAbrir(Sender);
   Caption := dmMotherBoard.TituloVersao;
   reVisorCalculoComp.Clear;
   reVisorCalculoComp.Lines.Add( 'ARQUIVO NOVO CRIADO COM SUCESSO!' );
//   reVisorCalculoComp.Lines.Add( '' );
   reVisorCalculoComp.Lines.Add( 'SELECIONE UM DOS TIPOS DE CÁLCULO NOS BOTÕES OU MENU' );
   reVisorCalculoComp.Lines.Add( 'EM CÁLCULOS, PARA VISUALIZAR OU [IMPRIMIR] O RESULTADO.' );
   reVisorCalculoComp.Lines.Add( 'PARA CALCULÁ-LO, PRESSIONE A OPÇÃO [CALCULAR]' );
   FPodeFechar := True;
   CalculoTextViewer1.Visible := True;
end;

procedure TfmCalcNutr.DepoisDeGravar(Sender: TObject);
begin

   // Chamando evento original
   if Assigned( FDepoisDeGravar ) then
      FDepoisDeGravar(Sender);

   Caption := dmMotherBoard.TituloNomeArquivo;
end;

procedure TfmCalcNutr.CalculoTextViewer1BeforePreview(Sender: TObject;
  var Cancel: Boolean);
begin
   // Quebra galho para sincronizar botoes com menu
    if dmMotherBoard.caProcessador.Memoria.Empty then
       // Gambiarra para esconder o checked do menu
       // quando tiver metas tem que mudar isto
       mmCalcMetas.Checked := True
    else
    with CalculoTextViewer1 do
    if CalculoCorrente = 'Antropometria' then
       begin
          mmCalcAntropometria.Checked := True;
          btCalcAntropometria.Down := True;
       end
    else if CalculoCorrente = 'RecCalorica' then
       begin
          mmCalcRecCalorica.Checked := True;
          btCalcRecCalorica.Down := True;
       end
    else if CalculoCorrente = 'Preparacao' then
       begin
          mmCalcPreparacao.Checked := True;
          btCalcPreparacao.Down := True;
       end
    else if CalculoCorrente = 'Inquerito' then
       begin
          mmCalcInquerito.Checked := True;
          btCalcInquerito.Down := True;
       end
    else if CalculoCorrente = 'PlanoAlimentar' then
       begin
          mmCalcDieta.Checked := True;
          btCalcDieta.Down := True;
       end
    else if CalculoCorrente = 'AtividadeFisica' then
       begin
          mmCalcAtivFisica.Checked := True;
          btCalcAtivFisica.Down := True;
       end;
end;

procedure TfmCalcNutr.CalculoTextViewer1AfterPreview(Sender: TObject);
begin
  with CalculoTextViewer1 do
  if Visor.Lines.Count <= 0 then
  begin
    if CalculoCorrente = 'Antropometria' then
       begin
          Visor.Lines.Add( 'CÁLCULO ANTROPOMÉTRICO SELECIONADO!' );
       end
    else if CalculoCorrente = 'RecCalorica' then
       begin
          Visor.Lines.Add( 'CÁLCULO DE RECOMENDAÇÃO DE ENERGIA SELECIONADO!' );
       end
    else if CalculoCorrente = 'Preparacao' then
       begin
          Visor.Lines.Add( 'CÁLCULO DE PREPARAÇÃO SELECIONADO!' );
       end
    else if CalculoCorrente = 'Inquerito' then
       begin
          Visor.Lines.Add( 'CÁLCULO DE INQUÉRITO SELECIONADO!' );
       end
    else if CalculoCorrente = 'PlanoAlimentar' then
       begin
          Visor.Lines.Add( 'CÁLCULO DE PLANO ALIMENTAR SELECIONADO!' );
       end
    else if CalculoCorrente = 'AtividadeFisica' then
       begin
          Visor.Lines.Add( 'CÁLCULO DE ATIVIDADE FÍSICA SELECIONADO!' );
          Visor.Lines.Add( 'OBS.: ESTE CÁLCULO NÃO PODE SER GRAVADO OU IMPRESSO.' );
       end
    else
       exit;
//    Visor.Lines.Add( '' );
    Visor.Lines.Add( 'PRESSIONE [CALCULAR] PARA FAZER O CÁLCULO.' );
  end;
end;

procedure TfmCalcNutr.Mostra_Ajuda;
var
   MainPath : String;
begin
  // Seta Individuos como opção não liberada
  if not CarregaChaveString(CFGRoot, CFGPath, 'Path', MainPath ) then
  begin
     ShowMessage( 'Erro de leitura da Chave: Path'  );
     exit;
  end;

   //  MsgManut;
  //Application.HelpCommand(HELP_FINDER, 0);
     HtmlHelp(0, PChar(MainPath + '\Help\Calculo.chm'), HH_DISPLAY_TOC, 0);
end;

procedure TfmCalcNutr.Pele11Click(Sender: TObject);
begin
   imSkin.Picture.LoadFromFile( 'FundoCalcnut1.bmp' );
end;

procedure TfmCalcNutr.Pele21Click(Sender: TObject);
begin
   imSkin.Picture.LoadFromFile( 'FundoCalcnut2.bmp' );
end;

procedure TfmCalcNutr.reVisorCalculoCompChange(Sender: TObject);
begin
   laDisplay.Caption := reVisorCalculoComp.Lines.Strings[0] + #13 +
                        reVisorCalculoComp.Lines.Strings[1] + #13 +
                        reVisorCalculoComp.Lines.Strings[2];
end;

end.


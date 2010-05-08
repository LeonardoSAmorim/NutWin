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




unit fmSelRelCalcAli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MmLstBox, ExtCtrls, MontaLst, RlItensAli, QuickRpt,
  RlIdentificacao, RlMacroNut, RlNutPesoDia, RlNutrientes, RlRecNut,
  RlValidaNut, RlRelacoesNut, RlPorcEnergia, RlAliNut, RlGruAliNut,
  RlEquEnergia, RlEquProteina, RlItensAliEquEnergia, RlItensAliEquProteina,
  RlGrafRecNut, RlReceita, RlIngredientes, RlDieObs, RlInqObs,
  NutCnst, CalcAli, Measurement, memoria, qrepform, QRPRNTR, fmBarraProg,
  HintListBox, RlNCal01, RlRecRDA, fmRelBranco, PRINTERS, RlIdentificacaoLandscape,
  MoveItens, RelConfig, ImgList, Spin;


const REL_IDENTIFICACAO        = 1;
const REL_IDENTIFICACAO_LANDSCAPE = 1;
const REL_ITENSALI             = 2;
const REL_DISTRIBUICAOENERGIA  = 3;
const REL_NUTPESODIA           = 4;
const REL_TOTALNUTRIENTES      = 5;
const REL_SALDONUTRIENTES      = 6;
const REL_VALIDANUTRIENTES     = 7;
const REL_MACRONUT             = 8;
const REL_RELACOESNUT          = 9;
//const REL_NENHUM               = 10;  
const REL_ALINUT               = 11;
const REL_GRUALINUT            = 12;
const REL_EQUENERGIA           = 13;
const REL_EQUPROTEINA          = 14;
const REL_ITENSALIEQUENERGIA   = 15;
const REL_ITENSALIEQUPROTEINA  = 16;
const REL_GRAFRECNUT           = 17;
const REL_RECEITA              = 18;  // *****
const REL_INGREDIENTES         = 19;  // *****
const REL_DIEOBSERVACOES       = 20;
const REL_INQOBSERVACOES       = 21;
const REL_RECENERGIA           = 22;   //*******
const REL_RECRDA               = 23;   // *******

type

  TfmRelCalcAli = class(TForm)
    mlSelRelCalcAli: TMontaLista;
    Label1: TLabel;
    Label2: TLabel;
    lbSaida: TMmListBox;
    lbEntrada: TMmListBox;
    bbRelCalcAliExcluir: TBitBtn;
    bbRelCalcAliTodos: TBitBtn;
    bbRelCalcAliLimpar: TBitBtn;
    bbRelCalcAliAdicionar: TBitBtn;
    QRCompositeReport: TQRCompositeReport;
    pnConfiguracoes: TPanel;
    Label4: TLabel;
    ckRelatSeparados: TCheckBox;
    pnModelos: TPanel;
    rgModelos: TRadioGroup;
    laRepModelos: TLabel;
    paBotoes: TPanel;
    sbModelos: TSpeedButton;
    sbVisualizar: TSpeedButton;
    sbImprimir: TSpeedButton;
    sbFechar: TSpeedButton;
    pnTitulo: TPanel;
    laDescricaoCalculo: TLabel;
    sbConfig: TSpeedButton;
    miEscolhidos: TMoveItens;
    btSobeItem: TBitBtn;
    btDesceItem: TBitBtn;
    imlRelatorio: TImageList;
    sbVoltar: TSpeedButton;
    Bevel1: TBevel;
    sbNutrientes: TSpeedButton;
    gbTipoId: TGroupBox;
    imCompleta: TImage;
    rbCompleta: TRadioButton;
    imSimples: TImage;
    rbSimples: TRadioButton;
    imNenhuma: TImage;
    rbNenhuma: TRadioButton;
    gbPosicaoId: TGroupBox;
    im5: TImage;
    ckIdentificacaoParaTodos: TCheckBox;
    im1: TImage;
    im2: TImage;
    ckIdentificacaoPaginaUnica: TCheckBox;
    im3: TImage;
    im4: TImage;
    sbPadrao: TSpeedButton;
    Label3: TLabel;
    laRelA: TLabel;
    laRelB: TLabel;
    laRelA2: TLabel;
    laRelB2: TLabel;
    paLinhaSeparadora: TPanel;
    ckLinhaSeparadora: TCheckBox;
    laDistancia: TLabel;
    spDistancia: TSpinEdit;
    laUnidade: TLabel;
    procedure sbVisualizarClick(Sender: TObject);
    procedure QRCompositeReportAddReports(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbImprimirClick(Sender: TObject);
    procedure sbFecharClick(Sender: TObject);
    procedure ckRelatSeparadosClick(Sender: TObject);
    procedure ckIdentificacaoParaTodosClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rgModelosClick(Sender: TObject);
    procedure sbModelosClick(Sender: TObject);
    procedure sbConfigClick(Sender: TObject);
    procedure mlSelRelCalcAliErroAoMover(Sender: TObject; Item: String;
      Destino: TDestino);
    procedure mlSelRelCalcAliAntesDeMover(Sender: TObject);
    procedure mlSelRelCalcAliDepoisDeMoverItem(Sender: TObject;
      Item: String; Destino: TDestino);
    procedure mlSelRelCalcAliDepoisDeMover(Sender: TObject);
    procedure ckIdentificacaoPaginaUnicaClick(Sender: TObject);
    procedure sbVoltarClick(Sender: TObject);
    procedure rbCompletaClick(Sender: TObject);
    procedure rbSimplesClick(Sender: TObject);
    procedure rbNenhumaClick(Sender: TObject);
    procedure sbPadraoClick(Sender: TObject);
    procedure sbNutrientesClick(Sender: TObject);
  private
    { Private declarations }
    fmqrIdentificacao :TfmRelIdentificacao;
    fmqrIdentificacaoLandscape :TfmRelIdentificacaoLandscape;
    fmqrRelBranco : TfmRelatBranco;
    fmqrItensAli :TfmRelItensAli;
    fmqrMacroNut :TfmRelMacroNut;
    fmqrNutPesoDia : TfmRelNutPesoDia;
    fmqrTotalNutrientes : TfmRelNutrientes;
    fmqrSaldoNutrientes : TfmRelRecNut;
    fmqrValidaNutrientes : TfmRelValidaNut;
    fmqrPorcEnergia : TfmRelPorcEnergia;
    fmqrRelacoesNut : TfmRelRelacoesNut;
//    fmqrNenhum : TfmRelNenhum; 
    fmqrAliNut : TfmRelAliNutr;
    fmqrGruAliNut : TfmRelGruAliNut;
    fmqrEquEnergia : TfmRelEquEnergia;
    fmqrEquProteina : TfmRelEquProteina;
    fmqrItensAliEquEnergia : TfmRelItensAliEquEnergia;
    fmqrItensAliEquProteina : TfmRelItensAliEquProteina;
    fmqrGrafRecNut : TfmRelGrafRecNut;
    fmqrReceita : TfmRelReceita;
    fmqrIngredientes : TfmRelIngredientes;
    fmqrDieObs : TfmRelDieObservacoes;
    fmqrInqObs : TfmRelInqObservacoes;
    fmqrNecesCal01 : TfmRelNecesCal01;
    fmqrRecRDA : TfmRelRecRDA;
    FProcessador: TObject;
    FRelatoriosSeparados: Boolean;
    FIdentificacaoParaTodos: Boolean;
    FTipoIdentificacao : TRelTipoIdentificacao;
    FPassouPorErroAoMover : Boolean;
    FAlterouModelo : Boolean;
    FIdentificacaoPaginaUnica: Boolean;
    procedure SetProcessador(const Value: TObject);
    procedure CarregaRelModelos;
    procedure SetRelatoriosSeparados(const Value: Boolean);
    procedure SetIdentificacaoParaTodos(const Value: Boolean);
    procedure CriarReports;
    procedure DestruirReports;
    function ReportBind(Report : TObject; Indice : Integer) : Boolean;
    function FoiEscolhido(Tag : Integer) : Integer;
    function TemRelatoriosEquivalentesEnergia : Boolean;
    function TemRelatoriosEquivalentesProteina: Boolean;
    procedure SetIdentificacaoPaginaUnica(const Value: Boolean);
    procedure SetImages;
  protected
    { Resets prop of component type if referenced component deleted }
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  public
    { Public declarations }
    property RelatoriosSeparados : Boolean read FRelatoriosSeparados write SetRelatoriosSeparados;
    property Processador : TObject read FProcessador write SetProcessador;
    property IdentificacaoParaTodos : Boolean read FIdentificacaoParaTodos write SetIdentificacaoParaTodos;
    property IdentificacaoPaginaUnica : Boolean read FIdentificacaoPaginaUnica write SetIdentificacaoPaginaUnica;
  end;

var
  fmRelCalcAli: TfmRelCalcAli;

implementation

uses DMMBoard;

{$R *.DFM}

function TfmRelCalcAli.FoiEscolhido(Tag: Integer): Integer;
var
   I : Integer;
begin
     Result := -1;
     for I := 0 to lbEntrada.Items.Count - 1 do
     begin
        if TRelatorio(lbEntrada.Items.Objects[I]).Tag = Tag then
        begin
           Result := I;
           break;
        end;
     end;
end;

// Liga os itens escolhidos às instancias dos relatórios correspondentes
function TfmRelCalcAli.ReportBind(Report : TObject; Indice : Integer): Boolean;
begin
   TFormReport( TQuickRep(Report).Owner ).SetRelConfig(TRelatorio(lbEntrada.Items.Objects[Indice]));
   Result := True;
end;

procedure TfmRelCalcAli.sbVisualizarClick(Sender: TObject);
var
   I : Integer;
begin
  // Cria as intâncias dos relatórios
  if lbEntrada.Items.Count > 0 then
     CriarReports
  else
     exit;

  // Tem que ter o mesmo código que o print
  QRCompositeReport.PrinterSettings.Orientation := poPortrait;
  if lbEntrada.Items.Count > 0 then
  begin
     for I := 0 to lbEntrada.Items.Count - 1 do
     begin
       // Aproveita e seta a orientação deste relatório para todos
       if ( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_ALINUT ) or
          ( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_GRUALINUT ) then
       begin
          QRCompositeReport.PrinterSettings.Orientation := poLandscape;
          break;
       end;
     end;
     QRCompositeReport.PrinterSettings.Title := QRCompositeReport.ReportTitle;
     QRCompositeReport.Preview;
  end;
end;

procedure TfmRelCalcAli.QRCompositeReportAddReports(Sender: TObject);

function GetRelConfigIdentificacao(const AReport : TObject) : TRelatorio;
var
   FRelConfigTemp : TRelatorio;
begin
   Result := nil;
   if FIdentificacaoPaginaUnica then
   begin
      FRelConfigTemp := TRelatorio.Create(self);
      with FRelConfigTemp do
      begin
         Descricao := 'Identificação';
         FormClassName := self.ClassName;
         ProcessadorClassName := '';
         Orientacao := poLandscape;
         NovaPagina := True; // Aqui é que faz a diferença!
         TipoIdentificacao := riNenhuma;
         IdentificacaoParaTodos := False;
         LinhaSeparadora := 0;
         Report := AReport;
         MostraTitulo := True;
      end;
      Result := FRelConfigTemp;
   end;
end;

var
   I : Integer;
begin
   // Coloca uma Identificação no ou como o primeiro relatório SEMPRE, exceto para PREPARAÇÃO
   if not( FProcessador is TCalculoPreparacao ) then
   begin
      // Poe identificação completa na primeira se for páginas juntas
      if (not(FIdentificacaoParaTodos) or not(FRelatoriosSeparados)) and ( FTipoIdentificacao = riCompleta ) then
      begin
         if (QRCompositeReport.PrinterSettings.Orientation = poLandscape) then
         begin
            // nil significa: usar TRelatorio default
            fmqrIdentificacaoLandscape.SetRelConfig(nil);
            QRCompositeReport.Reports.Add( fmqrIdentificacaoLandscape.Report )
         end
         else
         begin
            // nil significa: usar TRelatorio default
            fmqrIdentificacao.SetRelConfig(nil);
            QRCompositeReport.Reports.Add( fmqrIdentificacao.Report );
         end;
      end
      else if ( FIdentificacaoPaginaUnica ) and ( FTipoIdentificacao <> riCompleta ) then
      begin
         if (QRCompositeReport.PrinterSettings.Orientation = poLandscape) then
         begin
            fmqrIdentificacaoLandscape.SetRelConfig(GetRelConfigIdentificacao(fmqrIdentificacaoLandscape.Report));
            QRCompositeReport.Reports.Add( fmqrIdentificacaoLandscape.Report );
         end
         else
         begin
            fmqrIdentificacao.SetRelConfig(GetRelConfigIdentificacao(fmqrIdentificacao.Report));
            QRCompositeReport.Reports.Add( fmqrIdentificacao.Report );
         end;
      end;
   end;
   // Adiciona todos os relatórios escolhidos
   for I := 0 to lbEntrada.Items.Count - 1 do
   begin
       // Por enquanto só este dois tem este tipo de configuração
       if not( FProcessador is TCalculoPreparacao ) and
          not( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_RECENERGIA ) and
          not( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_RECRDA ) and
          not( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_EQUENERGIA ) and
          not( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_EQUPROTEINA ) then
       begin
          TRelatorio( lbEntrada.Items.Objects[I] ).IdentificacaoParaTodos := FIdentificacaoParaTodos;
          // Muda para simplificada a partir do segundo relatório pois Identificacao completa não é para todos
          if ( FTipoIdentificacao = riCompleta ) and
             ( not FIdentificacaoParaTodos ) and
             (I > 0) then
             begin
                // No caso de serem na mesma página, não tem identificação nenhuma
                if ckRelatSeparados.Checked then
                   TRelatorio( lbEntrada.Items.Objects[I] ).TipoIdentificacao := riSimplificada
                else
                   TRelatorio( lbEntrada.Items.Objects[I] ).TipoIdentificacao := riNenhuma;
             end
          else
             begin
                // Se for 2a. pagina e for junto nao tem identificação
                if not(ckRelatSeparados.Checked) and (I > 0) then
                   TRelatorio( lbEntrada.Items.Objects[I] ).TipoIdentificacao := riNenhuma
                else
                   TRelatorio( lbEntrada.Items.Objects[I] ).TipoIdentificacao := FTipoIdentificacao;
             end;
       end;

       // Define quais relatórios terá a Identificação e qual tipo
       if not( FProcessador is TCalculoPreparacao ) and
          not ( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_EQUENERGIA ) and
          not ( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_EQUPROTEINA ) and
          not ( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_RECENERGIA ) and
          not ( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_RECRDA ) and
          not ( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_GRAFRECNUT ) and
          FIdentificacaoParaTodos and
          ckRelatSeparados.Checked and
         ( FTipoIdentificacao = riCompleta ) then
       begin
          if not (QRCompositeReport.PrinterSettings.Orientation = poLandscape) then
          begin
             // nil significa: usar TRelatorio default
             fmqrIdentificacao.SetRelConfig(nil);
             QRCompositeReport.Reports.Add( fmqrIdentificacao.Report );
             fmqrIdentificacao.Report.ReportTitle := TCustomCalculoAlimentar( FProcessador ).Descricao;
          end
          else
          begin
             // nil significa: usar TRelatorio default
             fmqrIdentificacaoLandscape.SetRelConfig(nil);
             QRCompositeReport.Reports.Add( fmqrIdentificacaoLandscape.Report );
             fmqrIdentificacaoLandscape.Report.ReportTitle := TCustomCalculoAlimentar( FProcessador ).Descricao;
          end;
       end;

       // Define se os relatórios vão ficar separados ou juntos
       if not FRelatoriosSeparados then
         begin
            if I = 0 then
               TRelatorio( lbEntrada.Items.Objects[I] ).MostraTitulo := True
            else
               TRelatorio( lbEntrada.Items.Objects[I] ).MostraTitulo := False;
            TRelatorio( lbEntrada.Items.Objects[I] ).NovaPagina := False;
            if (I < ( lbEntrada.Items.Count - 1 )) and ( ckLinhaSeparadora.Checked ) then
               TRelatorio( lbEntrada.Items.Objects[I] ).LinhaSeparadora := spDistancia.Value //3
            else
               TRelatorio( lbEntrada.Items.Objects[I] ).LinhaSeparadora := 0;
         end
         else
         begin
            TRelatorio( lbEntrada.Items.Objects[I] ).MostraTitulo := True;
            TRelatorio( lbEntrada.Items.Objects[I] ).LinhaSeparadora := 0;
            if I < ( lbEntrada.Items.Count - 1 ) then
            begin
               TRelatorio( lbEntrada.Items.Objects[I] ).NovaPagina := True;
            end
            else
            begin
               TRelatorio( lbEntrada.Items.Objects[I] ).NovaPagina := False;
            end;
       end;

       // Seta o titulo do relatório
       if ( FProcessador is TCustomCalculoAlimentar ) then
           TQuickRep( TRelatorio(lbEntrada.Items.Objects[I]).Report ).ReportTitle := TCustomCalculoAlimentar( FProcessador ).Descricao;

       // Adiciona relatório propriamente dito
       QRCompositeReport.Reports.Add( TRelatorio(lbEntrada.Items.Objects[I]).Report );
   end;
end;

procedure TfmRelCalcAli.SetProcessador(const Value: TObject);
begin
  FProcessador := Value;
  // Preciso fazer isto senao nao considera nr. de dias do inquerito
  if ( FProcessador is TCalculoInquerito ) then
  begin
     TCalculoInquerito(FProcessador).PegaDiasDeConsumo;
  end;
end;

procedure TfmRelCalcAli.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FProcessador then
        FProcessador := nil;
end;

procedure TfmRelCalcAli.FormShow(Sender: TObject);
var
   mdMedAux : TMedida;
   TagEE, TagEP : Integer;
begin
  // Inicializa variáveis
  self.Height := 480;
  self.Width := 640;
  mlSelRelCalcAli.BringToFront;
  pnConfiguracoes.Align := alClient;
  pnModelos.Align := alClient;
  mlSelRelCalcAli.Align := alClient;
  TagEE := 0;
  TagEP := 0;
  FPassouPorErroAoMover := False;
  FAlterouModelo := False;

  // Seta o Título do tipo de relatório
  if ( FProcessador is TCustomCalculoAlimentar ) then
     laDescricaoCalculo.Caption := TCustomCalculoAlimentar( FProcessador ).Descricao;

  // Limpa as listas de escolhas
  lbEntrada.Clear;
  lbSaida.Clear;

  // sincroniza checked com property
  FRelatoriosSeparados := True; //ckRelatSeparados.Checked;
  FIdentificacaoParaTodos := True; //ckIdentificacaoParaTodos.Checked;
  FidentificacaoPaginaUnica := False; // not ckIdentificacaoPaginaUnica.Checked
  FTipoIdentificacao := riCompleta;  // rgTipoIdentificacao := riCompleta;
  ckIdentificacaoParaTodos.Enabled := True;
  ckIdentificacaoPaginaUnica.Enabled := False;
  ckLinhaSeparadora.Checked := True;
  paLinhaSeparadora.Visible := not FRelatoriosSeparados;

  if ( FProcessador is TCalculoPreparacao )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelReceita';
           ProcessadorClassName := 'TCalculoPreparacao';
           Tag := REL_RECEITA;
           lbSaida.Items.AddObject( 'Receita', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoPreparacao )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelIngredientes';
           ProcessadorClassName := 'TCalculoPreparacao';
           Tag := REL_INGREDIENTES;
           lbSaida.Items.AddObject( 'Ingredientes', MySelf );
         end;
     end;
  if ( FProcessador is TCalculoAlimentar ) then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelItensAli';
           ProcessadorClassName := 'TCalculoAlimentar';
           Tag := REL_ITENSALI;
           lbSaida.Items.AddObject( 'Itens Alimentares', MySelf );
         end;
     end;
  if ( FProcessador is TCalculoAlimentar ) then  // é Custom por causa da preparação
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelPorcEnergia';
           ProcessadorClassName := 'TCustomCalculoAlimentar';
           Tag := REL_DISTRIBUICAOENERGIA;
           lbSaida.Items.AddObject( 'Distribuição de Energia', MySelf );
         end;
     end;
  if ( FProcessador is TCalculoAlimentar ) then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelNutPesoDia';
           ProcessadorClassName := 'TCalculoAlimentar';
           Tag := REL_NUTPESODIA;
           lbSaida.Items.AddObject( 'Nutrientes/Peso/Dia', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoAlimentar ) then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelMacroNut';
           ProcessadorClassName := 'TCalculoAlimentar';
           Tag := REL_MACRONUT;
           lbSaida.Items.AddObject( 'Macro Nutrientes', MySelf );
        end;
     end;
  if ( FProcessador is TCustomCalculoAlimentar )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelNutrientes';
           ProcessadorClassName := 'TCustomCalculoAlimentar';
           Tag := REL_TOTALNUTRIENTES;
           lbSaida.Items.AddObject( 'Nutrientes', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoDieta ) then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelRecNut';
           ProcessadorClassName := 'TCalculoDieta';
           Tag := REL_SALDONUTRIENTES;
           lbSaida.Items.AddObject( 'Recomendação Nutricional', MySelf );
        end;
     end;
  if ( FProcessador is TCustomCalculoAlimentar ) then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelValidaNut';
           ProcessadorClassName := 'TCustomCalculoAlimentar';
           Tag := REL_VALIDANUTRIENTES;
           lbSaida.Items.AddObject( 'Nutrientes Válidos', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoAlimentar ) then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelRelacoesNut';
           ProcessadorClassName := 'TCalculoAlimentar';
           Tag := REL_RELACOESNUT;
           lbSaida.Items.AddObject( 'Relações Nutricionais', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoAlimentar )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelAliNutr';
           ProcessadorClassName := 'TCalculoAlimentar';
           Orientacao := poLandscape;
           Tag := REL_ALINUT;
           Exclusive := True;
           lbSaida.Items.AddObject( 'Alimentos/Nutrientes (Horizontal)', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoAlimentar )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelGruAliNut';
           ProcessadorClassName := 'TCalculoAlimentar';
           Orientacao := poLandscape;
           Tag := REL_GRUALINUT;
           Exclusive := True;
           lbSaida.Items.AddObject( 'Grupos Alimentares/Nutrientes (Horizontal)', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoDieta ) then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelEquEnergia';
           ProcessadorClassName := 'TCalculoDieta';
           if TemRelatoriosEquivalentesEnergia then
              Tag := REL_EQUENERGIA
           else
              // isto sinaliza para que o relatório não possa ser selecionado no listbox
              Tag := REL_EQUENERGIA * (-1);
           TagEE := Tag;
           lbSaida.Items.AddObject( 'Equivalentes de Energia', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoDieta )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelEquProteina';
           ProcessadorClassName := 'TCalculoDieta';
           if TemRelatoriosEquivalentesProteina then
              Tag := REL_EQUPROTEINA
           else
              // isto sinaliza para que o relatório não possa ser selecionado no listbox
              Tag := REL_EQUPROTEINA * (-1);
           TagEP := Tag;
           lbSaida.Items.AddObject( 'Equivalentes de Proteína', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoDieta )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelItensAliEquEnergia';
           ProcessadorClassName := 'TCalculoDieta';
        // Isto só é possível porque este relatório vem depois do Equivalientes de Energia
        // portanto NAO MUDE A ORDEM!!!!!!!!!!!!!!!
        if TagEE > 0 then
           Tag := REL_ITENSALIEQUENERGIA
        else
           Tag := REL_ITENSALIEQUENERGIA * (-1);
           lbSaida.Items.AddObject( 'Itens Alimentares com Equivalentes de Energia', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoDieta )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelItensAliEquProteina';
           ProcessadorClassName := 'TCalculoDieta';
        // Isto só é possível porque este relatório vem depois do Equivalientes de Energia
        // portanto NAO MUDE A ORDEM!!!!!!!!!!!!!!!
        if TagEP > 0 then
           Tag := REL_ITENSALIEQUPROTEINA
        else
           Tag := REL_ITENSALIEQUPROTEINA * (-1);
           lbSaida.Items.AddObject( 'Itens Alimentares com Equivalentes de Proteína', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoDieta )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelDieObservacoes';
           ProcessadorClassName := 'TCalculoDieta';
           Tag := REL_DIEOBSERVACOES;
           lbSaida.Items.AddObject( 'Observações', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoInquerito )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelInqObservacoes';
           ProcessadorClassName := 'TCalculoInquerito';
           Tag := REL_INQOBSERVACOES;
           lbSaida.Items.AddObject( 'Observações', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoDieta )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelGrafRecNut';
           ProcessadorClassName := 'TCalculoDieta';
           if TCalculoDieta(FProcessador).Memoria.Acha( 'mdSelRecCal', TObject( mdMedAux ) ) and
              ( mdMedAux.AsFloat = 0 ) then  // Calculado por ...
              Tag := REL_GRAFRECNUT * (-1)
           else
              Tag := REL_GRAFRECNUT;
           lbSaida.Items.AddObject( 'Gráfico de Recomendação Nutricional', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoDieta )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelNecesCal01';
           ProcessadorClassName := '';
           if TCalculoDieta(FProcessador).Memoria.Acha( 'mdSelRecCal', TObject( mdMedAux ) ) and
              ( mdMedAux.AsFloat = 0 ) then  // Calculado por ...
              Tag := REL_RECENERGIA * (-1)
           else
              Tag := REL_RECENERGIA;
           lbSaida.Items.AddObject( 'Recomendação Nutricional e de Energia', MySelf );
        end;
     end;
  if ( FProcessador is TCalculoAlimentar )  then
     begin
        with TRelatorio.Create(self) do
        begin
           FormClassName := 'TfmRelRecRDA';
           ProcessadorClassName := 'TCalculoAlimentar';
           Tag := REL_RECRDA;
           lbSaida.Items.AddObject( 'Recomendação Nutricional para RDA', MySelf );
        end;
     end;

   CarregaRelModelos;

end;

procedure TfmRelCalcAli.FormDestroy(Sender: TObject);
begin
   DestruirReports;
end;

procedure TfmRelCalcAli.CriarReports;
var
   mdMedAux : TMedida;
   Indice,
   FracaoTempo : Integer;
begin
   // Inicia indicador de operação demorada
   if Assigned( dmMotherBoard.Ampulheta ) then
      dmMotherBoard.Ampulheta.Start;
   with TfmBarraDeProgresso.Create(nil) do
   try
        //indicador de progresso
        pbProgresso.Max := 100;
        Show;
        Update;
        // Define fração de Tempo para cada relatório escolhido
        if (lbEntrada = nil) or (lbEntrada.Items.Count = 0) then
           FracaoTempo := 1
        else
           FracaoTempo := (pbProgresso.Max div (lbEntrada.Items.Count + 1));
        // Aqui estão os relatorios que podem ser montados e que
        // utilizam um processador
        // RELATÓRIO DE IDENTIFICAÇÃO PORTRAIT**********************************
        // Cria relatório de Identificação, tanto para Portrait quanto para Landscape
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Identificacao...';
        laOperacao.Update;
        if ( fmqrIdentificacao = nil ) and ( FProcessador is TCalculoAlimentar ) then
        begin
           fmqrIdentificacao := TfmRelIdentificacao.Create(nil);
           if ( Fprocessador is TCalculoInquerito ) then
           begin
              fmqrIdentificacao.SetVisorMedidaNumDiasInquerito( TCalculoInquerito( FProcessador ).DiasDeConsumo.Name )
           end;
           fmqrIdentificacao.Report.Tag := REL_IDENTIFICACAO;
        end;
        // RELATÓRIO DE IDENTIFICAÇÃO LANDSCAPE ********************************
        if ( fmqrIdentificacaoLandscape = nil ) and ( FProcessador is TCalculoAlimentar ) then
        begin
          fmqrIdentificacaoLandscape := TfmRelIdentificacaoLandscape.Create(nil);
          if ( Fprocessador is TCalculoInquerito ) then
          begin
             fmqrIdentificacaoLandscape.SetVisorMedidaNumDiasInquerito( TCalculoInquerito( FProcessador ).DiasDeConsumo.Name )
          end;
          fmqrIdentificacaoLandscape.Report.Tag := REL_IDENTIFICACAO_LANDSCAPE;
        end;
        // RELATÓRIO EM BRANCO ***************************************************
        // Quedra galho pra resolver um problema de quebra de página
        if ( fmqrRelBranco = nil ) and ( FProcessador is TCalculoAlimentar )  then
        begin
           fmqrRelBranco := TfmRelatBranco.Create(nil);
        end;
        // RELATÓRIO DE RECEITA ************************************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Receita...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_RECEITA);
        if ( fmqrReceita = nil ) and ( Indice >= 0 )  then
        begin
           fmqrReceita := TfmRelReceita.Create(nil);
           fmqrReceita.CalculoAlimentar := TCalculoPreparacao( FProcessador );
           fmqrReceita.Report.Tag := REL_RECEITA;
           ReportBind(fmqrReceita.Report, Indice);
        end;
        // RELATÓRIO DE INGREDIENTES *******************************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Ingredientes...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_INGREDIENTES);
        if ( fmqrIngredientes = nil )  and ( Indice >= 0 )  then
        begin
           fmqrIngredientes := TfmRelIngredientes.Create(nil);
           fmqrIngredientes.CalculoAlimentar := TCalculoPreparacao( FProcessador );
           fmqrIngredientes.Report.Tag := REL_INGREDIENTES;
           ReportBind(fmqrIngredientes.Report, Indice);
        end;
        // RELATÓRIO DE ITENS ALIMENTARES **************************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Itens Alimentares...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_ITENSALI);
        if ( fmqrItensAli = nil )  and ( Indice >= 0 ) then
        begin
           fmqrItensAli := TfmRelItensAli.Create(nil);
           fmqrItensAli.CalculoAlimentar := TCalculoAlimentar( FProcessador );
           fmqrItensAli.Report.Tag := REL_ITENSALI;
           ReportBind(fmqrItensAli.Report, Indice);
        end;
        // RELATÓRIO DE MACRONUTRIENTES ****************************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Macro Nutrientes...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_MACRONUT);
        if ( fmqrMacroNut = nil )  and ( Indice >= 0 ) then  // era Custom por causa da preparação
        begin
           fmqrMacroNut := TfmRelMacroNut.Create(nil);
           fmqrMacroNut.CalculoAlimentar := TCustomCalculoAlimentar( FProcessador );
           fmqrMacroNut.Report.Tag := REL_MACRONUT;
           ReportBind( fmqrMacroNut.Report, Indice);
        end;
        // RELATÓRIO DE NUTRIENTES/PESO/DIA ************************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Nutrientes/Peso/Dia...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_NUTPESODIA);
        if ( fmqrNutPesoDia = nil )  and ( Indice >= 0 ) then
        begin
           fmqrNutPesoDia := TfmRelNutPesoDia.Create(nil);
           fmqrNutPesoDia.CalculoAlimentar := TCalculoAlimentar( FProcessador );
           fmqrNutPesoDia.Report.Tag := REL_NUTPESODIA;
           ReportBind(fmqrNutPesoDia.Report, Indice );
        end;
        // RELATÓRIO DE NUTRIENTES *********************************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Nutrientes...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_TOTALNUTRIENTES);
        if ( fmqrTotalNutrientes = nil )  and ( Indice >= 0 )  then
        begin
           fmqrTotalNutrientes := TfmRelNutrientes.Create(nil);
           fmqrTotalNutrientes.CalculoAlimentar := TCustomCalculoAlimentar( FProcessador );
           fmqrTotalNutrientes.Report.Tag := REL_TOTALNUTRIENTES;
           ReportBind(fmqrTotalNutrientes.Report, Indice);
        end;
        // RELATÓRIO DE RECOMENDAÇÕES NUTRICIONAIS ******************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Recomendação Nutricional...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_SALDONUTRIENTES);
        if ( fmqrSaldoNutrientes = nil )  and ( Indice >= 0 ) then
        begin
           fmqrSaldoNutrientes := TfmRelRecNut.Create(nil);
           fmqrSaldoNutrientes.CalculoAlimentar := TCalculoDieta( FProcessador );
           fmqrSaldoNutrientes.Report.Tag := REL_SALDONUTRIENTES;
           ReportBind(fmqrSaldoNutrientes.Report, Indice);
        end;
        // RELATÓRIO DE NUTRIENTES VÁLIDOS *************************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Nutrientes Válidos...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_VALIDANUTRIENTES);
        if ( fmqrValidaNutrientes = nil )  and ( Indice >= 0 ) then
        begin
           fmqrValidaNutrientes := TfmRelValidaNut.Create(nil);
           fmqrValidaNutrientes.CalculoAlimentar := TCustomCalculoAlimentar( FProcessador );
           fmqrValidaNutrientes.Report.Tag := REL_VALIDANUTRIENTES;
           ReportBind(fmqrValidaNutrientes.Report, Indice);
        end;
        // RELATÓRIO DE DISTRIBUIÇÃO DE ENERGIA ********************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Distribuição de Energia...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_DISTRIBUICAOENERGIA);
        if ( fmqrPorcEnergia = nil )  and ( Indice >= 0 ) then
        begin
           fmqrPorcEnergia := TfmRelPorcEnergia.Create(nil);
           fmqrPorcEnergia.CalculoAlimentar := TCalculoAlimentar( FProcessador );
           fmqrPorcEnergia.Report.Tag := REL_DISTRIBUICAOENERGIA;
           ReportBind(fmqrPorcEnergia.Report, Indice);
        end;
        // RELATÓRIO DE RELAÇÕES NUTRICIONAIS **********************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Relações Nutricionais...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_RELACOESNUT);
        if ( fmqrRelacoesNut = nil )  and ( Indice >= 0 ) then
        begin
           fmqrRelacoesNut := TfmRelRelacoesNut.Create(nil);
           fmqrRelacoesNut.CalculoAlimentar := TCalculoAlimentar( FProcessador );
           fmqrRelacoesNut.Report.Tag := REL_RELACOESNUT;
           ReportBind(fmqrRelacoesNut.Report, Indice);
        end;
        // RELATÓRIO DE PORCENTAGEM DE ENERGIA *********************************
//        pbProgresso.StepBy( FracaoTempo );
//        laOperacao.Caption := 'Carregando Relatório de Nenhum...';
//        laOperacao.Update;
//        Indice := FoiEscolhido(REL_NENHUM);
//        if ( fmqrNenhum = nil )  and ( Indice >= 0 )  then
//        begin
//           fmqrNenhum := TfmRelNenhum.Create(nil);
//          fmqrNenhum.CalculoAlimentar := TCalculoAlimentar( FProcessador );
//           fmqrNenhum.Report.Tag := REL_NENHUM;
//           ReportBind(fmqrNenhum.Report, Indice);
//        end;
        // RELATÓRIO DE ALIMENTOS/NUTRIENTES
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Alimentos/Nutrientes...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_ALINUT);
        if ( fmqrAliNut = nil )  and ( Indice >= 0 )  then
        begin
           fmqrAliNut := TfmRelAliNutr.Create(nil);
           fmqrAliNut.CalculoAlimentar := TCalculoAlimentar( FProcessador );
           fmqrAliNut.Report.Tag := REL_ALINUT;
           ReportBind(fmqrAliNut.Report, Indice);
        end;
        // RELATÓRIO DE GRUPOS ALIMENTARES/NUTRIENTES **************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Grupos Alimentares/Nutrientes...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_GRUALINUT);
        if ( fmqrGruAliNut = nil )  and ( Indice >= 0 )  then
        begin
           fmqrGruAliNut := TfmRelGruAliNut.Create(nil);
           fmqrGruAliNut.CalculoAlimentar := TCalculoAlimentar( FProcessador );
           fmqrGruAliNut.Report.Tag := REL_GRUALINUT;
           ReportBind(fmqrGruAliNut.Report, Indice);
        end;
        // RELATÓRIOS DE EQUIVALENTES DE ENERGIA *******************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Equivalentes de Energia...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_EQUENERGIA);
        if ( fmqrEquEnergia = nil )  and ( Indice >= 0 )  then
        begin
           fmqrEquEnergia := TfmRelEquEnergia.Create(nil);
           fmqrEquEnergia.CalculoAlimentar := TCalculoDieta( FProcessador );
           fmqrEquEnergia.Report.Tag := REL_EQUENERGIA;
           ReportBind(fmqrEquEnergia.Report, Indice);
        end;
        // RELATÓRIO DE EQUIVALENTES DE PROTEÍNA *******************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Equivalentes de Proteína...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_EQUPROTEINA);
        if ( fmqrEquProteina = nil )  and ( Indice >= 0 )  then
        begin
            fmqrEquProteina := TfmRelEquProteina.Create(nil);
            fmqrEquProteina.CalculoAlimentar := TCalculoDieta( FProcessador );
            fmqrEquProteina.Report.Tag := REL_EQUPROTEINA;
            ReportBind(fmqrEquProteina.Report, Indice);
        end;
        // RELATÓRIO DE ITENS ALIMENTARES COM EQUIVALENTES DE ENERGIA **********
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Itens Alimentares com Equivalentes de Energia...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_ITENSALIEQUENERGIA);
        if ( fmqrItensAliEquEnergia = nil )  and ( Indice >= 0 )  then
        begin
           fmqrItensAliEquEnergia := TfmRelItensAliEquEnergia.Create(nil);
           fmqrItensAliEquEnergia.CalculoAlimentar := TCalculoDieta( FProcessador );
           fmqrItensAliEquEnergia.Report.Tag := REL_ITENSALIEQUENERGIA;
           ReportBind(fmqrItensAliEquEnergia.Report, Indice);
        end;
        // RELATÓRIO DE ITENS ALIMENTARES COM EQUIVALENTES DE PROTEÍNA *********
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Itens Alimentares com Equivalentes de Proteína...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_ITENSALIEQUPROTEINA);
        if ( fmqrItensAliEquProteina = nil )  and ( Indice >= 0 )  then
        begin
           fmqrItensAliEquProteina := TfmRelItensAliEquProteina.Create(nil);
           fmqrItensAliEquProteina.CalculoAlimentar := TCalculoDieta( FProcessador );
           fmqrItensAliEquProteina.Report.Tag := REL_ITENSALIEQUPROTEINA;
           ReportBind(fmqrItensAliEquProteina.Report, Indice);
        end;
        // RELATÓRIO DE OBSERVAÇÕES DO PLANO ALIMENTAR *************************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Observações...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_DIEOBSERVACOES);
        if ( fmqrDieObs = nil )  and ( Indice >= 0 )  then
        begin
           fmqrDieObs := TfmRelDieObservacoes.Create(nil);
           fmqrDieObs.CalculoAlimentar := TCalculoDieta( FProcessador );
           fmqrDieObs.Report.Tag := REL_DIEOBSERVACOES;
           ReportBind(fmqrDieObs.Report, Indice);
        end;
        // RELATÓRIO DE OBSERVAÇÕES DO INQUÉRITO ALIMENTAR *********************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Observações...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_INQOBSERVACOES);
        if ( fmqrInqObs = nil )  and ( Indice >= 0 )  then
        begin
           fmqrInqObs := TfmRelInqObservacoes.Create(nil);
           fmqrInqObs.CalculoAlimentar := TCalculoInquerito( FProcessador );
           fmqrInqObs.Report.Tag := REL_INQOBSERVACOES;
           ReportBind(fmqrInqObs.Report, Indice);
        end;
        // RELATÓRIO DE GRÁFICO DE RECOMENDAÇÃO NUTRICIONAL ********************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Gráfico de Recomendação Nutricional...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_GRAFRECNUT);
        if ( fmqrGrafRecNut = nil )  and ( Indice >= 0 )  then
        begin
           fmqrGrafRecNut := TfmRelGrafRecNut.Create(nil);
           fmqrGrafRecNut.CalculoAlimentar := TCalculoDieta( FProcessador );
           fmqrGrafRecNut.Report.Tag := REL_GRAFRECNUT;
           if TCalculoDieta(FProcessador).Memoria.Acha( 'mdSelRecCal', TObject( mdMedAux ) ) and
              ( mdMedAux.AsFloat = 0 ) then  // Calculado por ...
              fmqrGrafRecNut.Report.Tag := REL_GRAFRECNUT * (-1)
           else
              fmqrGrafRecNut.Report.Tag := REL_GRAFRECNUT;
           ReportBind(fmqrGrafRecNut.Report, Indice);
        end;
        // RELATÓRIO DE RECOMENDAÇÃO NUTRICIONAL E DE ENERGIA ******************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Recomendação Nutricional e de Energia...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_RECENERGIA);
        if ( fmqrNecesCal01 = nil )  and ( Indice >= 0 )  then
        begin
           fmqrNecesCal01 := TfmRelNecesCal01.Create(nil);
           if TCalculoDieta(FProcessador).Memoria.Acha( 'mdSelRecCal', TObject( mdMedAux ) ) and
              ( mdMedAux.AsFloat = 0 ) then  // Calculado por ...
              fmqrNecesCal01.Report.Tag := REL_RECENERGIA * (-1)
           else
              fmqrNecesCal01.Report.Tag := REL_RECENERGIA;
           ReportBind(fmqrNecesCal01.Report, Indice);
        end;
        // RELATÓRIO DE RECOMENDAÇÃO NUTRICONAL PELA RDA ***********************
        pbProgresso.StepBy( FracaoTempo );
        laOperacao.Caption := 'Carregando Relatório de Recomendação Nutricional para RDA...';
        laOperacao.Update;
        Indice := FoiEscolhido(REL_RECRDA);
        if ( fmqrRecRDA = nil )  and ( Indice >= 0 )  then
        begin
           fmqrRecRDA := TfmRelRecRDA.Create(nil);
           fmqrRecRDA.CalculoAlimentar := TCalculoAlimentar( FProcessador );
           fmqrRecRDA.Report.Tag := REL_RECRDA;
           ReportBind(fmqrRecRDA.Report, Indice);
        end;
   // Finaliza indicador de operação demorada
   finally
        if Assigned( dmMotherBoard.Ampulheta ) then
           dmMotherBoard.Ampulheta.Finish;
        Free; // Barra de progresso
   end;
end;

procedure TfmRelCalcAli.DestruirReports;
begin
   if fmqrIdentificacao <> nil then
   begin
      fmqrIdentificacao.free;
      fmqrIdentificacao := nil;
   end;
   if fmqrIdentificacaoLandscape <> nil then
   begin
      fmqrIdentificacaoLandscape.free;
      fmqrIdentificacaoLandscape := nil;
   end;
   if fmqrRelBranco <> nil then
   begin
      fmqrRelBranco.Free;
      fmqrRelBranco := nil;
   end;
   if fmqrItensAli <> nil then
   begin
      fmqrItensAli.Free;
      fmqrItensAli := nil;
   end;
   if fmqrMacroNut <> nil then
   begin
      fmqrMacroNut.Free;
      fmqrMacroNut := nil;
   end;
   if fmqrNutPesoDia <> nil then
   begin
      fmqrNutPesoDia.Free;
      fmqrNutPesoDia := nil;
   end;
   if fmqrTotalNutrientes <> nil then
   begin
      fmqrTotalNutrientes.Free;
      fmqrTotalNutrientes := nil;
   end;
   if fmqrSaldoNutrientes <> nil then
   begin
      fmqrSaldoNutrientes.Free;
      fmqrSaldoNutrientes := nil;
   end;
   if fmqrValidaNutrientes <> nil then
   begin
      fmqrValidaNutrientes.Free;
      fmqrValidaNutrientes := nil;
   end;
   if fmqrPorcEnergia <> nil then
   begin
      fmqrPorcEnergia.Free;
      fmqrPorcEnergia := nil;
   end;
   if fmqrRelacoesNut <> nil then
   begin
      fmqrRelacoesNut.Free;
      fmqrRelacoesNut := nil;
   end;
//   if fmqrNenhum <> nil then
//   begin
//      fmqrNenhum.Free;
//      fmqrNenhum := nil;
//   end;
   if fmqrAliNut <> nil then
   begin
      fmqrAliNut.Free;
      fmqrAliNut := nil;
   end;
   if fmqrGruAliNut <> nil then
   begin
      fmqrGruAliNut.Free;
      fmqrGruAliNut := nil;
   end;
   if fmqrEquEnergia <> nil then
   begin
      fmqrEquEnergia.Free;
      fmqrEquEnergia := nil;
   end;
   if fmqrEquProteina <> nil then
   begin
      fmqrEquProteina.Free;
      fmqrEquProteina := nil;
   end;
   if fmqrItensAliEquEnergia <> nil then
   begin
      fmqrItensAliEquEnergia.Free;
      fmqrItensAliEquEnergia := nil;
   end;
   if fmqrItensAliEquProteina <> nil then
   begin
      fmqrItensAliEquProteina.Free;
      fmqrItensAliEquProteina := nil;
   end;
   if fmqrGrafRecNut <> nil then
   begin
      fmqrGrafRecNut.Free;
      fmqrGrafRecNut := nil;
   end;
   if fmqrReceita <> nil then
   begin
      fmqrReceita.Free;
      fmqrReceita := nil;
   end;
   if fmqrIngredientes <> nil then
   begin
      fmqrIngredientes.Free;
      fmqrIngredientes := nil;
   end;
   if fmqrDieObs <> nil then
   begin
      fmqrDieObs.Free;
      fmqrDieObs := nil;
   end;
   if fmqrInqObs <> nil then
   begin
      fmqrInqObs.Free;
      fmqrInqObs := nil;
   end;
   if fmqrNecesCal01 <> nil then
   begin
      fmqrNecesCal01.Free;
      fmqrNecesCal01 := nil;
   end;
   if fmqrRecRDA <> nil then
   begin
      fmqrRecRDA.Free;
      fmqrRecRDA := nil;
   end;
end;

procedure TfmRelCalcAli.sbImprimirClick(Sender: TObject);
var
   I : Integer;
begin
  // Cria as intâncias dos relatórios
  if lbEntrada.Items.Count > 0 then
     CriarReports
  else
     exit;   

  // Tem que ter o mesmo código que o preview
  QRCompositeReport.PrinterSettings.Orientation := poPortrait;
  if lbEntrada.Items.Count > 0 then
  begin
     for I := 0 to lbEntrada.Items.Count - 1 do
     begin
       // Aproveita e seta a orientação deste relatório para todos
       if ( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_ALINUT ) or
          ( TRelatorio( lbEntrada.Items.Objects[I] ).Tag = REL_GRUALINUT ) then
       begin
          QRCompositeReport.PrinterSettings.Orientation := poLandscape;
          break;
       end;
     end;
     QRCompositeReport.PrinterSettings.Title := QRCompositeReport.ReportTitle;
     QRCompositeReport.Print;
  end;
end;

procedure TfmRelCalcAli.sbFecharClick(Sender: TObject);
begin
   Close;
end;

procedure TfmRelCalcAli.CarregaRelModelos;
var
   cxCalculo : TCaixa;
   mdModelo : TMedida;
   I, J : Integer;
   CalcName : String;
begin
   if Processador <> nil then
      CalcName := TCustomCalculoAlimentar( Processador ).Name
   else
      CalcName := '';
   with dmMotherBoard do
   begin
      meRelModelos.Limpar;

      cxCalculo := TCaixa.Create( meRelModelos );
      cxCalculo.Name := 'CalcPreparacao';

      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'ResumoPreparacao';
      mdModelo.Descricao := 'RESUMO';
      mdModelo.ValorNumerico := IntToStr( REL_INGREDIENTES ) + ',' +
                                IntToStr( REL_RECEITA );

      cxCalculo := TCaixa.Create( meRelModelos );
      cxCalculo.Name := 'CalcInquerito';

      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'ResumoInquerito';
      mdModelo.Descricao := 'RESUMO';
      mdModelo.ValorNumerico := IntToStr( REL_ITENSALI ) + ',' +
                                IntToStr( REL_NUTPESODIA ) + ',' +
                                IntToStr( REL_MACRONUT ) + ',' +
                                IntToStr( REL_DISTRIBUICAOENERGIA ) + ',' +
                                IntToStr( REL_RELACOESNUT ) + ',' +
                                IntToStr( REL_INQOBSERVACOES );

      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'GrupoAliInquerito';
      mdModelo.Descricao := 'GRUPOS ALIMENTARES';
      mdModelo.ValorNumerico := IntToStr( REL_GRUALINUT );

      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'AlimentosNutrientesInquerito';
      mdModelo.Descricao := 'ALIMENTOS/NUTRIENTES';
      mdModelo.ValorNumerico := IntToStr( REL_ALINUT );

{      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'AdequacaoNutricionalInquerito';
      mdModelo.Descricao := 'ADEQUAÇÃO NUTRICIONAL';
      mdModelo.ValorNumerico := IntToStr( REL_GRAFRECNUT ) + ',' +
                                IntToStr( REL_SALDONUTRIENTES );  } // estes relatórios não se aplicam a um inquérito

      cxCalculo := TCaixa.Create( meRelModelos );
      cxCalculo.Name := 'CalcDieta';

      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'ResumoDieta';
      mdModelo.Descricao := 'RESUMO';
      mdModelo.ValorNumerico := IntToStr( REL_ITENSALI ) + ',' +
                                IntToStr( REL_NUTPESODIA ) + ',' +
                                IntToStr( REL_MACRONUT ) + ',' +
                                IntToStr( REL_DISTRIBUICAOENERGIA ) + ',' +
                                IntToStr( REL_RELACOESNUT ) + ',' +
                                IntToStr( REL_DIEOBSERVACOES );

      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'GrupoAliDieta';
      mdModelo.Descricao := 'GRUPOS ALIMENTARES';
      mdModelo.ValorNumerico := IntToStr( REL_GRUALINUT );

      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'AlimentosNutrientesDieta';
      mdModelo.Descricao := 'ALIMENTOS/NUTRIENTES';
      mdModelo.ValorNumerico := IntToStr( REL_ALINUT );

      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'AdequacaoNutricionalDieta';
      mdModelo.Descricao := 'ADEQUAÇÃO NUTRICIONAL';
      mdModelo.ValorNumerico := IntToStr( REL_GRAFRECNUT ) + ',' +
                                IntToStr( REL_SALDONUTRIENTES );

      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'EquivalentesEnergiaDieta';
      mdModelo.Descricao := 'EQUIVALENTES DE ENERGIA';
      mdModelo.ValorNumerico := IntToStr( REL_DISTRIBUICAOENERGIA ) + ',' + 
                                IntToStr( REL_ITENSALIEQUENERGIA ) + ',' +
                                IntToStr( REL_EQUENERGIA );

      mdModelo := TMedida.Create( cxCalculo );
      mdModelo.Name := 'EquivalentesProteinaDieta';
      mdModelo.Descricao := 'EQUIVALENTES DE PROTEINA';
      mdModelo.ValorNumerico := IntToStr( REL_DISTRIBUICAOENERGIA ) + ',' +
                                IntToStr( REL_ITENSALIEQUENERGIA ) + ',' +
                                IntToStr( REL_EQUPROTEINA );

      // Popula o RadioGroup com os modelos
      For I := 0 to meRelModelos.ComponentCount - 1 do
      begin
         if ( meRelModelos.Components[I] is TCaixa ) and
            ( TCaixa( meRelModelos.Components[I] ).Name = CalcName ) then
            for J := 0 to TCaixa( meRelModelos.Components[I] ).ComponentCount - 1 do
            begin
               rgModelos.Items.AddObject(
               TMedida( TCaixa( meRelModelos.Components[I] ).Components[J] ).Descricao, TCaixa( meRelModelos.Components[I] ).Components[J] );
            end;
      end;
   end;
end;

procedure TfmRelCalcAli.SetRelatoriosSeparados(const Value: Boolean);
begin
  FRelatoriosSeparados := Value;
end;

procedure TfmRelCalcAli.ckRelatSeparadosClick(Sender: TObject);
begin
   paLinhaSeparadora.Visible := not ckRelatSeparados.Checked;
   laDistancia.Enabled := ckLinhaSeparadora.Checked;
   spDistancia.Enabled := ckLinhaSeparadora.Checked;
   laUnidade.Enabled := ckLinhaSeparadora.Checked;
   FRelatoriosSeparados := ckRelatSeparados.Checked;
   SetImages;
end;

procedure TfmRelCalcAli.SetIdentificacaoParaTodos(const Value: Boolean);
begin
  FIdentificacaoParaTodos := Value;
end;

procedure TfmRelCalcAli.ckIdentificacaoParaTodosClick(Sender: TObject);
begin
   FIdentificacaoParaTodos := ckIdentificacaoParaTodos.Checked;
   SetImages;
end;


function TfmRelCalcAli.TemRelatoriosEquivalentesEnergia: Boolean;
var
   FCalculoAlimentar : TCalculoAlimentar;
begin
   FCalculoAlimentar := TCalculoAlimentar( FProcessador );
   Result := True;
   // Alguem está usando e não pode
   if dmMotherBoard.EquivalenteEnergia.Ativar then
   begin
      Result := False;
      exit;
   end;
   // Preparação
   FCalculoAlimentar.RefeicoesEscolhidas.DataSet.First;
   FCalculoAlimentar.ItemsAlimentar.DataSet.First;
   dmMotherBoard.EquivalenteEnergia.Ativar := True;
   // Verificação
   while Result do
   begin
      // Para sincronizar itensalimentares com gruposalimentares com equivalentes
      dmMotherBoard.EquivalenteEnergia.Alimento.DMUmAlimento.taAlimento.Locate( 'IDALI',
             FCalculoAlimentar.ItemsAlimentar.DataSet.FieldByName( 'ID_ALI' ).AsString,[] );
      // Se tem equivalentes e ainda não foi impresso
      if not dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.Eof then
         begin
             Result := True;
             Break;
         end;
      // vai para próximo itemalimentar
      FCalculoAlimentar.ItemsAlimentar.DataSet.Next;
      // acabaram os items da refeicao corrente
      if FCalculoAlimentar.ItemsAlimentar.DataSet.Eof then
         begin
            // passa para outra refeicao
            FCalculoAlimentar.RefeicoesEscolhidas.DataSet.Next;
            // não tem mais refeicoes
            if FCalculoAlimentar.RefeicoesEscolhidas.DataSet.Eof then
            begin
               Result := False;
               break;
            end;
         end;
   end;
   // Termino
   dmMotherBoard.EquivalenteEnergia.Ativar := False;
end;

function TfmRelCalcAli.TemRelatoriosEquivalentesProteina: Boolean;
var
   FCalculoAlimentar : TCalculoAlimentar;
begin
   FCalculoAlimentar := TCalculoAlimentar( FProcessador );
   Result := True;
   // Alguem está usando e não pode
   if dmMotherBoard.EquivalenteProteina.Ativar then
   begin
      Result := False;
      exit;
   end;
   // Preparação
   FCalculoAlimentar.RefeicoesEscolhidas.DataSet.First;
   FCalculoAlimentar.ItemsAlimentar.DataSet.First;
   dmMotherBoard.EquivalenteProteina.Ativar := True;
   // Verificação
   while Result do
   begin
      // Para sincronizar itensalimentares com gruposalimentares com equivalentes
      dmMotherBoard.EquivalenteProteina.Alimento.DMUmAlimento.taAlimento.Locate( 'IDALI',
             FCalculoAlimentar.ItemsAlimentar.DataSet.FieldByName( 'ID_ALI' ).AsString,[] );
      // Se tem equivalentes e ainda não foi impresso
      if not dmMotherBoard.EquivalenteProteina.ListaDeAlimentosEquivalentes.DataSet.Eof then
         begin
             Result := True;
             break;
         end;
      // vai para próximo itemalimentar
      FCalculoAlimentar.ItemsAlimentar.DataSet.Next;
      // acabaram os items da refeicao corrente
      if FCalculoAlimentar.ItemsAlimentar.DataSet.Eof then
         begin
            // passa para outra refeicao
            FCalculoAlimentar.RefeicoesEscolhidas.DataSet.Next;
            // não tem mais refeicoes
            if FCalculoAlimentar.RefeicoesEscolhidas.DataSet.Eof then
            begin
               Result := False;
               break
            end;
         end;
   end;
   // Termino
   dmMotherBoard.EquivalenteProteina.Ativar := False;
end;

procedure TfmRelCalcAli.rgModelosClick(Sender: TObject);
var
//   mdModelo : TMedida;
   I, J : Integer;
//   CalcName : String;
   IDRelatorios : TStringList;
begin
      mlSelRelCalcAli.MoveTudoParaSaida;
      if ( rgModelos.Items.Strings[rgModelos.ItemIndex] = '<Nenhum>' ) or ( rgModelos.Items.Strings[rgModelos.ItemIndex] = '' ) then
         exit;
      IDRelatorios := TStringList.Create;
      IDRelatorios.CommaText := TMedida( rgModelos.Items.Objects[rgModelos.ItemIndex] ).ValorNumerico;
      For I := 0 to  IDRelatorios.Count - 1 do
         For J := lbSaida.Items.Count - 1 downto 0 do
           if StrToInt( IDRelatorios.Strings[I] ) = TRelatorio( lbSaida.Items.Objects[J] ).Tag then
           begin
              mlSelRelCalcAli.MoveParaEntrada( J );
           end;
      IDRelatorios.Free;
end;

procedure TfmRelCalcAli.sbModelosClick(Sender: TObject);
begin

   if (sbModelos.Caption = 'Ocultar &Modelos') then
   begin
      mlSelRelCalcAli.BringToFront;
      sbModelos.Caption := '&Modelos';
      FAlterouModelo := False;
   end
   else
   begin
      pnModelos.BringToFront;
      sbModelos.Caption := 'Ocultar &Modelos';
      if FAlterouModelo then
      begin
         rgModelos.ItemIndex := -1;
         mlSelRelCalcAli.MoveTudoParaSaida;
      end;   
   end;
end;

procedure TfmRelCalcAli.sbConfigClick(Sender: TObject);
begin
   paBotoes.Visible := False;
   pnConfiguracoes.BringToFront;
end;

procedure TfmRelCalcAli.mlSelRelCalcAliErroAoMover(Sender: TObject;
  Item: String; Destino: TDestino);
begin
   if not FPassouPorErroAoMover then
   begin
      ShowMessage( 'Relatórios do tipo "Horizontal"' + chr(13)+chr(10) +
                   'devem ser escolhidos sozinhos.' );
      FPassouPorErroAoMover := True;
   end;
end;
 
procedure TfmRelCalcAli.mlSelRelCalcAliAntesDeMover(Sender: TObject);
begin
   FPassouPorErroAoMover := False;
end;


procedure TfmRelCalcAli.mlSelRelCalcAliDepoisDeMoverItem(Sender: TObject;
  Item: String; Destino: TDestino);
begin
   FAlterouModelo := True;
end;


procedure TfmRelCalcAli.mlSelRelCalcAliDepoisDeMover(Sender: TObject);
begin
   FAlterouModelo := True;
end;


procedure TfmRelCalcAli.SetIdentificacaoPaginaUnica(const Value: Boolean);
begin
  FIdentificacaoPaginaUnica := Value;
end;

procedure TfmRelCalcAli.ckIdentificacaoPaginaUnicaClick(Sender: TObject);
begin
   FIdentificacaoPaginaUnica := ckIdentificacaoPaginaUnica.Checked;
   SetImages;
end;

procedure TfmRelCalcAli.sbVoltarClick(Sender: TObject);
begin
   paBotoes.Visible := True;
   pnConfiguracoes.SendToBack;
end;

procedure TfmRelCalcAli.rbCompletaClick(Sender: TObject);
begin
   FTipoIdentificacao := riCompleta;
   ckIdentificacaoParaTodos.Enabled := True;
   ckIdentificacaoPaginaUnica.Enabled := False;
   SetImages;
end;

procedure TfmRelCalcAli.rbSimplesClick(Sender: TObject);
begin
   FTipoIdentificacao := riSimplificada;
   ckIdentificacaoParaTodos.Enabled := False;
   ckIdentificacaoPaginaUnica.Enabled := True;
   SetImages;
end;

procedure TfmRelCalcAli.rbNenhumaClick(Sender: TObject);
begin
   FTipoIdentificacao := riNenhuma;
   ckIdentificacaoParaTodos.Enabled := False;
   ckIdentificacaoPaginaUnica.Enabled := True;
   SetImages;
end;

procedure TfmRelCalcAli.sbPadraoClick(Sender: TObject);
begin
   rbCompleta.Checked := True;
   ckRelatSeparados.Checked := True;
   ckIdentificacaoParaTodos.Checked := True;
   ckIdentificacaoPaginaUnica.Checked := False;
end;

procedure TfmRelCalcAli.sbNutrientesClick(Sender: TObject);
begin
   dmMotherBoard.CfgNutrientes;
end;

procedure TfmRelCalcAli.SetImages;

procedure SetImage(I : Integer; im : TImage);
var
    Bitmap: TBitmap;
begin
    Bitmap := TBitmap.Create;
    try
       imlRelatorio.GetBitmap(I, Bitmap);
       im.Picture.Bitmap := Bitmap;
    finally
       Bitmap.Free;
    end;
end;
begin
    laRelA.Caption := laRelA2.Caption;
    laRelA.Visible := True;
    laRelA2.Visible := False;
    laRelB.Visible := True;
    laRelB2.Visible := False;
    if rbCompleta.Checked then
    begin
          SetImage(1, im1);
          SetImage(2, im2);
          if ckIdentificacaoParaTodos.Checked then
             SetImage(1, im3)
          else
             SetImage(2, im3);
          SetImage(2, im4);
          SetImage(2, im5);
    end
    else if rbSimples.Checked then
    begin
       if ckIdentificacaoPaginaUnica.Checked then
       begin
          SetImage(0, im1);
          laRelA.Caption := 'Identificação';
//         laRelA.Visible := False;
          laRelA2.Visible := True;
          laRelB.Visible := False;
          laRelB2.Visible := True;
       end
       else
       begin
          SetImage(2, im1);
       end;
       SetImage(2, im2);
       SetImage(2, im3);
       SetImage(2, im4);
       SetImage(2, im5);
    end
    else if rbNenhuma.Checked then
    begin
       if ckIdentificacaoPaginaUnica.Checked then
       begin
          SetImage(0, im1);
          laRelA.Caption := 'Identificação';
//          laRelA.Visible := False;;
          laRelA2.Visible := True;
          laRelB.Visible := False;
          laRelB2.Visible := True;
       end
       else
          SetImage(3, im1);
       SetImage(3, im2);
       SetImage(3, im3);
       SetImage(3, im4);
       SetImage(3, im5);
    end;

    if not ckRelatSeparados.Checked then
    begin
       SetImage(3, im2);
       SetImage(3, im3);
       SetImage(3, im4);
       SetImage(3, im5);
    end

end;

end.

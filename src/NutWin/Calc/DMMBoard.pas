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




unit DMMBoard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, filectrl,
  Memoria, Calculo, OCXDCNLib_TLB, DicNut, db, MemoriaViewer,
  DBTables, ObjVis, DescriptorManager, Measurement, Idade, Procedimento,
  CCSListaLinks, CCSDBListaLinks, CalcAli, RDA, IOController, Escopo,
  fmRelViewer, CalculoViewer, ImgList, CalcNutActns, ActnList, NutCnst,
  fmCfgCalculos, fmNutAcomp,
  RlAntr01,RlNCal01,
  RlAFis01, RlEsp01, RlInq01,
  RlDiet01, RlPrep01, DBIOController, DBCalcNutActns, CLstAli,
  MedidasCaseiras, Nutrientes, EquEnergia, CAlimento, EquProteina, AliWiz,
  Conector, KeyNav, Wizard, fmSelRelCalcAli, DelayedOpIndicator,
  QuickRpt, comctrls, DSList, NutAli, VersionInfo;

type
  TStateMem = ( cnStart, cnBrowse, cnEdit, cnCancel, cnPost, cnEmpty );

  TdmMotherBoard = class(TDataModule)
    caProcessador: TCalculo;
    meAnterior: TMemoria;
    dcROM: TCacheDic;
    CorpoHumano: TCorpoHumano;
    Indicadores: TDescriptorManager;
    CfgMemoria: TMemoria;
    meMemAux: TMemoria;
    DBOrg: TDatabase;
    CalcDieta: TCalculoDieta;
    CalcInquerito: TCalculoInquerito;
    CalcInqFreq: TCalculoInqueritoFrequencia;
    CalcPreparacao: TCalculoPreparacao;
    RDA: TRDA;
    CalcNut: TMemoria;
    IOController: TIOController;
    odAbrir: TOpenDialog;
    s_Salvar: TSaveDialog;
    Escopo: TEscopo;
    imAtalhos2: TImageList;
    imHotAtalhos2: TImageList;
    imDisabledAtalhos2: TImageList;
    imAtalhos1: TImageList;
    imHotAtalhos1: TImageList;
    imDisabledAtalhos1: TImageList;
    alCalcNut: TActionList;
    cnNovo: TCalcNutNovo;
    cnAbrir: TCalcNutAbrir;
    cnSalvar: TCalcNutGravar;
    cnFechar: TCalcNutFechar;
    cnSalvaComo: TCalcNutGravarComo;
    cnCalcAntropometria: TCalcNutDefineCalculo;
    cnCalcRecCalorica: TCalcNutDefineCalculo;
    cnCalcAtivFisica: TCalcNutDefineCalculo;
    cnCalcEspeciais: TCalcNutDefineCalculo;
    cnCalcDieta: TCalcNutDefineCalculo;
    cnCalcInquerito: TCalcNutDefineCalculo;
    cnCalcInqFrequencia: TCalcNutDefineCalculo;
    cnCalcMetas: TCalcNutDefineCalculo;
    cnCalcPreparacao: TCalcNutDefineCalculo;
    cnCalcCalcular: TCalcNutCalcular;
    DBIOController: TDBIOController;
    alDBCalcNut: TActionList;
    cnDBAbrir: TDBCalcNutAbrir;
    cnDBAbrirDe: TDBCalcNutAbrirDe;
    cnDBCalcular: TDBCalcNutCalcular;
    cnDBCalcInquerito: TDBCalcNutDefineCalculo;
    cnDBExcluir: TDBCalcNutFechar;
    cnDBSalvar: TDBCalcNutGravar;
    cnDBSalvarComo: TDBCalcNutGravarComo;
    cnDBNovo: TDBCalcNutNovo;
    cnDBCalcAntropometria: TDBCalcNutDefineCalculo;
    cnDBCalcDieta: TDBCalcNutDefineCalculo;
    cnDBCalcPreparacao: TDBCalcNutDefineCalculo;
    ListaAlimento: TCustomListaAlimento;
    AlimentoCorrente: TAlimento;
    MedidasCaseiras: TMedidasCaseiras;
    dsMedCas: TDataSource;
    Nutrientes: TNutrientes;
    EquivalenteEnergia: TEquivalenteEnergia;
    EquivalenteProteina: TEquivalenteProteina;
    ValorQtdeMedida: TMedida;
    mdAliQtde: TMedida;
    mdAliPeso: TMedida;
    DieEquivalenteEnergia: TEquivalenteEnergia;
    DieEquivalenteProteina: TEquivalenteProteina;
    Wizard: TNewWizard;
    AliWiz: TNewWizard;
    meRelModelos: TMemoria;
    cnDBNovaPreparacao: TDBCalcNutNovaPreparacao;
    Ampulheta: TDelayedOpCursor;

    cnCalcNenhum: TCalcNutDefineCalculo;
    Atalhos3: TImageList;
    dslListaAlimento: TDSList;
    dsOrigem: TDSNut;
    dsLstAli: TDSNut;
    dsNut: TDSNut;
    dsGruAli: TDSNut;
    dsUserName: TDSNut;
    dslNutrientes: TDSList;
    dsNutrientes: TDSNut;
    dsCfgNut: TDSNut;
    dslEquivalenteEnergia: TDSList;
    dsGruEquEnergia: TDSNut;
    dsAliEquEnergia: TDSNut;
    dslEquivalenteProteina: TDSList;
    dsGruEquProteina: TDSNut;
    dsAliEquProteina: TDSNut;
    dslDieEquivalenteProteina: TDSList;
    dsDieGruEquProteina: TDSNut;
    dsDieAliEquProteina: TDSNut;
    dslDieEquivalenteEnergia: TDSList;
    dsDieGruEquEnergia: TDSNut;
    dsDieAliEquEnergia: TDSNut;
    dslCalcInqFreq: TDSList;
    dsInqFItemAlim: TDSNut;
    dsInqFRefEscolhida: TDSNut;
    dsInqFMacroNut: TDSNut;
    dsInqFTotalNut: TDSNut;
    dslCalcPreparacao: TDSList;
    dsPrepItemsAlim: TDSNut;
    dsPrepMacroNut: TDSNut;
    dsPrepTotalNut: TDSNut;
    dsPrepPorcNutValidos: TDSNut;
    dsPrepReceita: TDSNut;
    dslCalcInquerito: TDSList;
    dsInqItemsAlim: TDSNut;
    dsInqTotalNut: TDSNut;
    dsInqRefEscolhidas: TDSNut;
    dsInqRelCalNRef: TDSNut;
    dsInqSaldoNut: TDSNut;
    dsInqObservacoes: TDSNut;
    dsInqModRefeicoes: TDSNut;
    dsInqPorcNutValidos: TDSNut;
    dsInqRelCalNCalc: TDSNut;
    dsInqMacroNut: TDSNut;
    dsInqRelCalPCalc: TDSNut;
    dsInqPorcEnergiaCalc: TDSNut;
    dsInqProtAVBCalc: TDSNut;
    dsInqProtAVBRef: TDSNut;
    dsInqNutPesoDia: TDSNut;
    dsInqRelAGRef: TDSNut;
    dsInqRelCalPRef: TDSNut;
    dsInqGruAliPorNut: TDSNut;
    dsInqRelAGCalc: TDSNut;
    dslCalcDieta: TDSList;
    dsDieItemsAlim: TDSNut;
    dsDieTotalNut: TDSNut;
    dsDieMacroNut: TDSNut;
    dsDieSaldoNut: TDSNut;
    dsDieModRefeicoes: TDSNut;
    dsDieRefEscolhidas: TDSNut;
    dsDieObservacoes: TDSNut;
    dsDieAliPorNut: TDSNut;
    dsDieRelCaPRef: TDSNut;
    dsDieGruAliPorNut: TDSNut;
    dsDieProtAVBRef: TDSNut;
    dsDieProtAVBCalc: TDSNut;
    dsDieRelCalNCalc: TDSNut;
    dsDieRelAGCalc: TDSNut;
    dsDieNutPesoDia: TDSNut;
    dsDiePorcNutValidos: TDSNut;
    dsDieRelCalPCalc: TDSNut;
    dsDiePorcEnergiaCalc: TDSNut;
    dsDieRelAGRef: TDSNut;
    dsDieRelCalNRef: TDSNut;
    dsMedNut: TDSNut;
    dsInqAliPorNut: TDSNut;
    DieAlimentoCorrente: TAlimento;
    DieNutrientes: TNutrientes;
    dslDieNutrientes: TDSList;
    dsDieNut: TDSNut;
    dsDieCfgNut: TDSNut;
    dsDieMedNut: TDSNut;
    InqAlimentoCorrente: TAlimento;
    PrepAlimentoCorrente: TAlimento;
    InqNutrientes: TNutrientes;
    PrepNutrientes: TNutrientes;
    dslInqNutrientes: TDSList;
    dslPrepNutrientes: TDSList;
    dsPrepNut: TDSNut;
    dsPrepCfgNut: TDSNut;
    dsPrepMedNut: TDSNut;
    dsInqNut: TDSNut;
    dsInqCfgNut: TDSNut;
    dsInqMedNut: TDSNut;
    procedure dmMotherBoardCreate(Sender: TObject);
    procedure alCalcNutExecute(Action: TBasicAction; var Handled: Boolean);
    procedure AntesDeAdicionar(Sender: TObject; var Cancelar: Boolean; JaExiste: Boolean);
    procedure IOControllerDepoisDeNovo(Sender: TObject);
    procedure DBIOControllerDepoisDeNovo(Sender: TObject);

  private
    { Private declarations }
    AntropButtons : CalcButtons;

    FTemBackup : Boolean;
    FMemOld : TMemoria;
    FProcessadorAtual: TObject;
    FCurrentViewer: TRelViewer;
    FCalculoViewer: TCalculoViewer;
    FDMDataBases: TDataModule;
    procedure DefineCalcArray( Video : TCalculoViewer );
    procedure SetProcessadorAtual(const Value: TObject);
    function GetCurrentViewer: TRelViewer;
    procedure SetCalculoViewer(const Value: TCalculoViewer);
    procedure SetDMDataBases(const Value: TDataModule);
    function PrintASingleReport : Boolean;

  public
    { Public declarations }
    lslSobre : TVersionInfo;
    ToolBarItemAli : TToolBar;
    function AddDiretorio(const NomeCalculo: String) : Boolean;
    procedure AlteraItemAlimentar( CalcAli : TCustomCalculoAlimentar );
    procedure ConsultaNutrientes( Nutrientes : TNutrientes; IDMedCas: String = ''; QtdeMedCas : Double = 0; VlrGramas : Double = 100 );

    function LimpaRecNut( Caixa : String ) : Boolean;
    procedure BackupMemoria;
    procedure RestoreMemoria;
    procedure SwitchToMemAux( MemAux : TMemoria = nil );
    procedure SwitchToMainMem;

    procedure ExecutaCalculoCorrente( ModoOrg : Boolean = False );
    procedure Iniciar( Video : TCalculoViewer );
    procedure DBIniciar( Video : TCalculoViewer );
    procedure SetDBCalculoViewer( Video : TCalculoViewer );
    function Terminar : TCloseAction;
    function DBTerminar: TCloseAction;
    procedure Imprimir;
    function PodeImprimir( const NomeCalculo : String ) : Boolean;
    procedure CfgCalcAntrop;
    procedure CfgNutrientes;
    procedure Ajuda;
    procedure Sobre;
    function TituloVersao : String;
    function TituloNomeArquivo : String;
  published
    property CalculoViewer : TCalculoViewer read FCalculoViewer write SetCalculoViewer;
    property CurrentViewer: TRelViewer read GetCurrentViewer write FCurrentViewer;
    property ProcessadorAtual : TObject read FProcessadorAtual write SetProcessadorAtual;
    property DMDataBases : TDataModule read FDMDataBases write SetDMDataBases;
  end;

  procedure Register;

var
  dmMotherBoard: TdmMotherBoard;

implementation

uses Sobre, uAliasName;

{$R *.DFM}

procedure Register;
begin
  RegisterComponents('Calculadora', [TdmMotherBoard]);
end;
procedure TdmMotherBoard.BackupMemoria;
begin
   caProcessador.Memoria.CopiaPara( meAnterior );
   FTemBackup := True;
end;

// Restaura conteudo anterior da memoria
procedure TdmMotherBoard.RestoreMemoria;
begin
   if FTemBackup then
   begin
      meAnterior.CopiaPara( caProcessador.Memoria );
      if Assigned(caProcessador.Memoria.OnModified) then
         caProcessador.Memoria.OnModified(caProcessador.Memoria);
      FTemBackup := False;
   end;
end; { end of RestoreMemoria }

procedure TdmMotherBoard.dmMotherBoardCreate(Sender: TObject);
begin
//     DBOrg.AliasName := BDE_ALIAS_NAME;
   FMemOld := nil;
   lslSobre:= TVersionInfo.create();
   // Conecta dicionario (ROM)
   if not dmMotherBoard.caProcessador.ConnectCalculo('','') then
      begin
         ShowMessage( 'Houve um erro na conexão com o dicionário de cálculos!');
         Application.Terminate;
      end;

   // Cria Procedimentos de IMC
   caProcessador.CriaListaProc( meMemAux , 'cxcaIMC', 'caIMC', psNone);

   // Abre e/ou cria lista de procedimentos para configuracao
   if not dmMotherBoard.CfgMemoria.Abrir then
      dmMotherBoard.caProcessador.CriaListaProc( dmMotherBoard.CfgMemoria, 'cxcaAntrop', 'caAntrop', psNone);
   // Torna o procedimento ECCP "Escondido"
   dmMotherBoard.caProcessador.SetEstadoProc( dmMotherBoard.CfgMemoria, 'cxcaAntrop', 'prECCP', psHidden );

end;

//========== PASSAR PARA UM COMPONENTE ============

procedure TdmMotherBoard.SwitchToMainMem;
begin
   if Assigned( FMemOld ) then
      caProcessador.Memoria := FMemOld;
   FMemOld := nil;
end;

procedure TdmMotherBoard.SwitchToMemAux( MemAux : TMemoria = nil );
begin
   if not Assigned( MemAux ) then
      MemAux := meMemAux;
   FMemOld := caProcessador.Memoria;
   caProcessador.Memoria := MemAux;
end;

function TdmMotherBoard.LimpaRecNut( Caixa : String ) : Boolean;
var
   cxRecNut : TCaixa;
   I : Integer;
begin
   Result := False;
   if not caProcessador.Memoria.Acha( Caixa, TObject( cxRecNut ) ) then
      exit;
   for I := 0 to cxRecNut.ComponentCount - 1 do
   begin
       TMedida( cxRecNut.Components[I] ).ValorNumerico := '';
       TMedida( cxRecNut.Components[I] ).Empty := True;
       TMedida( cxRecNut.Components[I] ).Valid := True;
       TMedida( cxRecNut.Components[I] ).Tag := 0;
   end;
   Result := True;
end;

procedure TdmMotherBoard.SetProcessadorAtual(const Value: TObject);
begin
  FProcessadorAtual := Value;
end;

function TdmMotherBoard.GetCurrentViewer: TRelViewer;
begin
   if Assigned( CalculoViewer.CurrentViewer ) then
      FCurrentViewer := CalculoViewer.CurrentViewer;
   Result := FCurrentViewer;
end;

procedure TdmMotherBoard.SetCalculoViewer(const Value: TCalculoViewer);
begin
  FCalculoViewer := Value;
end;

//-
procedure TdmMotherBoard.ExecutaCalculoCorrente( ModoOrg : Boolean );
begin
   if (FCalculoViewer.CalculoCorrente = '') then
      begin
         ShowMessage( 'Cálculo não implementado!' );
      end
   else
      begin
         if not(FCalculoViewer.CalculoCorrente = 'Preparacao') then
            begin
               if Escopo.Pegar( ModoOrg ) then
                   begin
                      FCalculoViewer.Calculando:=True;
                      FCalculoViewer.FechaPreview;
                   end;
            end
         else
            begin
               FCalculoViewer.Calculando:=True;
               FCalculoViewer.FechaPreview;
            end;
      end;
end;

procedure TdmMotherBoard.alCalcNutExecute(Action: TBasicAction;
  var Handled: Boolean);
begin
   if ( Action is TCalcNutDefineCalculo ) then
      ProcessadorAtual := CalculoViewer.AntropButtons[TCalcNutDefineCalculo(Action).TipoCalculo].Processador;
end;

procedure TdmMotherBoard.DefineCalcArray( Video : TCalculoViewer );
begin

   AntropButtons[ncNenhum].Calculo:='';
   AntropButtons[ncNenhum].RepClass:=nil;
   AntropButtons[ncNenhum].Processador:= nil;

   AntropButtons[ncAntropometria].Calculo:='Antropometria';
   AntropButtons[ncAntropometria].RepClass:=TfmRelAntrop01;
   AntropButtons[ncAntropometria].Processador:= nil;

   AntropButtons[ncRecCalorica].Calculo:='RecCalorica';
   AntropButtons[ncRecCalorica].RepClass:=TfmRelNecesCal01;
   AntropButtons[ncRecCalorica].Processador:= nil;

   AntropButtons[ncAtivFisica].Calculo:='AtividadeFisica';
   AntropButtons[ncAtivFisica].RepClass:=TfmRelAtivFis01;
   AntropButtons[ncAtivFisica].Processador:= nil;

   AntropButtons[ncCalcEspeciais].Calculo:='';
   AntropButtons[ncCalcEspeciais].RepClass:=TfmRelEspeciais01;
   AntropButtons[ncCalcEspeciais].Processador:= nil;

   AntropButtons[ncPreparacao].Calculo:='Preparacao';
   AntropButtons[ncPreparacao].RepClass:=TfmRelPrep01;
   AntropButtons[ncPreparacao].Processador:= dmMotherBoard.CalcPreparacao;

   AntropButtons[ncInquerito].Calculo:='Inquerito';
   AntropButtons[ncInquerito].RepClass:=TfmRelInq01;
   AntropButtons[ncInquerito].Processador:= dmMotherBoard.CalcInquerito;

   AntropButtons[ncDieta].Calculo:='PlanoAlimentar';
   AntropButtons[ncDieta].RepClass:=TfmRelDieta01;
   AntropButtons[ncDieta].Processador:= dmMotherBoard.CalcDieta;
{
   AntropButtons[ncInqFreq].Calculo:='';
   AntropButtons[ncInqFreq].RepClass:=TfmRelInqFreq01;
   AntropButtons[ncInqFreq].Processador:= dmMotherBoard.CalcInqFreq;

   AntropButtons[ncMetas].Calculo:='';
   AntropButtons[ncMetas].RepClass:=TfmRelMetas01;
   AntropButtons[ncMetas].Processador:= nil;
}
   Video.AntropButtons := AntropButtons;

   CalculoViewer := Video;

end;

procedure TdmMotherBoard.Iniciar( Video : TCalculoViewer );
var
   I : Integer;
begin

   DefineCalcArray( Video );

   For I := 0 to alCalcNut.ActionCount - 1 do
       TCalcNutAction( alCalcNut.Actions[I] ).CalculoViewer := Video;

   For I := 0 to alDBCalcNut.ActionCount - 1 do
       TDBCalcNutAction( alDBCalcNut.Actions[I] ).CalculoViewer := Video;

   // Abre arquivo(s) se houver linha de comando
   IOController.Abrir( True );

   // Mostra o calculo (falta posicionar de acordo com o 1o. calculo do Diretorio)
   Video.DefineCalculo(ncNenhum, not( caProcessador.Memoria.Empty));

   // Pra atualizar os botões (o problema é que precisa setar a var Aberto := True
   // mas ela é var em CalcNutActns)
   dmMotherBoard.cnAbrir.UpdateTarget(nil);

end;

// Existe somente para manter compatibilidade
procedure TdmMotherBoard.DBIniciar( Video : TCalculoViewer );
var
   I : Integer;
begin

   DefineCalcArray( Video );

   For I := 0 to alDBCalcNut.ActionCount - 1 do
       TDBCalcNutAction( alDBCalcNut.Actions[I] ).CalculoViewer := Video;

   // Abre arquivo(s) se houver linha de comando
   DBIOController.Abrir( True );

   Video.DefineCalculo(ncAntropometria, False);

end;

procedure TdmMotherBoard.SetDBCalculoViewer( Video : TCalculoViewer );
var
   I : Integer;
begin

   DefineCalcArray( Video );

   For I := 0 to alDBCalcNut.ActionCount - 1 do
       TDBCalcNutAction( alDBCalcNut.Actions[I] ).CalculoViewer := Video;

end;

function TdmMotherBoard.Terminar: TCloseAction;
begin
   CalculoViewer.EndingApplication := True;
   if not IOController.Fechar then
      begin
         CalculoViewer.EndingApplication := False;
         Result := caNone;
         exit;
      end;
   Result := caFree;
   if Result = caFree then
      CalculoViewer.FechaPreview;
   // Desconecta Dicionario (memoria ROM)
   caProcessador.DisconnectCalculo;

end;

function TdmMotherBoard.DBTerminar: TCloseAction;
begin
   CalculoViewer.EndingApplication := True;
   if not DBIOController.Fechar then
      begin
         CalculoViewer.EndingApplication := False;
         Result := caNone;
         exit;
      end;
   Result := caFree;
   if Result = caFree then
      CalculoViewer.FechaPreview;
   // Desconecta Dicionario (memoria ROM)
//^^^   caProcessador.DisconnectCalculo;

end;

// Ajuda da calculadora
procedure TdmMotherBoard.Ajuda;
begin
//  Application.HelpCommand(HELP_FINDER, 0);
end; { end of Ajuda }

// Sobre a Calculadora
procedure TdmMotherBoard.Sobre;
var
   fmSobre : TfmSobre;
begin
   fmSobre := TfmSobre.Create(self);
   fmSobre.ShowModal;
   fmSobre.Free;
end; { end of Sobre }

procedure TdmMotherBoard.CfgCalcAntrop;
var
   F : TfmConfigCalculos;
begin
   F := TfmConfigCalculos.Create( Self );
   F.ShowModal;
   F.Free;
end;

procedure TdmMotherBoard.AlteraItemAlimentar( CalcAli : TCustomCalculoAlimentar );
var
   F : TfmAliWiz;
   OldFiltrarNomeAlimento : String;
   OldFiltrarPorGrupoAlimentar,
   OldFiltrarPorOrigem,
   OldMedidasCaseiras : Boolean;
begin

     // Guarda o estado atual da lista, pois preciso
     // fazer uma pesquisa em todos os alimentos
      with  ListaAlimento do
      begin
         OldFiltrarNomeAlimento := FiltrarNomeAlimento;
         OldFiltrarPorGrupoAlimentar := FiltrarPorGrupoAlimentar;
         OldFiltrarPorOrigem := FiltrarPorOrigem;
         FiltrarNomeAlimento := '';
         FiltrarPorGrupoAlimentar := False;
         OldFiltrarPorOrigem := False;
      end;
      OldMedidasCaseiras := MedidasCaseiras.Ativar;

      if not ListaAlimento.DMListaAlimento.quAli.Locate( 'IDALI',
         CalcAli.DMCalculoAlimentar.taItensAli.FieldByName( 'ID_ALI' ).AsString, [] ) then
         begin
            ShowMessage( 'Alimento não encontrado!' );
            // Restura o estado atual da lista, pois precisei
            // fazer uma pesquisa em todos os alimentos
            with ListaAlimento do
            begin
               FiltrarNomeAlimento := OldFiltrarNomeAlimento;
               FiltrarPorGrupoAlimentar := OldFiltrarPorGrupoAlimentar;
               FiltrarPorOrigem := OldFiltrarPorOrigem;
            end;
            MedidasCaseiras.Ativar := OldMedidasCaseiras;
            exit;
         end;
      F := TfmAliWiz.Create(self);

            // Prepara wizard
         AliWiz.BotaoAvancar := F.tbAvancar;
         AliWiz.BotaoVoltar := F.tbVoltar;
         AliWiz.BotaoTerminar := F.tbTerminar;
         AliWiz.BotaoCancelar := F.tbCancelar;
         AliWiz.PainelWizard := F.paAliWiz;
         AliWiz.OnCancel := F.AliWizCancel;
         AliWiz.OnTerminate := F.AliWizTerminate;

      MedidasCaseiras.Ativar := True;
      if MedidasCaseiras.TemMedidaCaseira then
         dmMotherBoard.AliWiz.Iniciar('ModAliQtde')
      else
         begin
            mdAliQtde.AsFloat := 0;
            mdAliPeso.AsFloat := 0;
            dmMotherBoard.AliWiz.Iniciar('ModAliPeso');
         end;
      F.ShowModal;
      if F.Teste <> '' then
         begin
            with dmMotherBoard do
            begin
               if mdAliQtde.AsFloat > 0 then
                  begin
                     CalcAli.QtdeAlimento := mdAliQtde.AsFloat;
                     CalcAli.IDMedCasAlimento := MedidasCaseiras.ListaDeMedidas.DataSet.FieldByName( 'IDMEDCAS' ).AsString;
                  end
               else
                  begin
                     CalcAli.QtdeAlimento := 0;
                     CalcAli.IDMedCasAlimento := '{406472C1-4A45-11D3-9DBD-000021609D7C}';
                  end;   
               CalcAli.Alterar;
            end;
         end;
      F.Free;
      // Restura o estado atual da lista, pois precisei
      // fazer uma pesquisa em todos os alimentos
      with  ListaAlimento do
      begin
         FiltrarNomeAlimento := OldFiltrarNomeAlimento;
         FiltrarPorGrupoAlimentar := OldFiltrarPorGrupoAlimentar;
         FiltrarPorOrigem := OldFiltrarPorOrigem;
      end;
      MedidasCaseiras.Ativar := OldMedidasCaseiras;
end;

procedure TdmMotherBoard.Imprimir;
var
   F : TfmRelCalcAli;
begin
{   if ( ProcessadorAtual = nil ) then
      begin
      end
   else }
      if not PrintASingleReport then
      begin
         F := TfmRelCalcAli.Create( self );
         F.Processador := ProcessadorAtual;
         F.ShowModal;
         F.Free;
      end;
end;

function TdmMotherBoard.AddDiretorio(const NomeCalculo: String): Boolean;
var
   mdDiretorio : TMedidaOrdinal;
   Diretorio : TStringList;
begin

   // Se não consequir
   Result := False;

   // carrega lista de cálculos já efetuados (mdDiretorio)
   Diretorio := TStringList.Create;
   if caProcessador.Memoria.Acha('mdDiretorio', TObject( mdDiretorio ) ) then
      begin
         Diretorio.CommaText := mdDiretorio.ValorNumerico;
         // Adiciona o novo calculo no diretorio
         if ( Diretorio.IndexOf( NomeCalculo ) = -1 ) then
         begin
            Diretorio.Add( NomeCalculo );
            mdDiretorio.ValorNumerico := Diretorio.CommaText;
            Result := True;
         end;
      end;
   Diretorio.Free;

end;

function TdmMotherBoard.PodeImprimir(const NomeCalculo: String): Boolean;
var
   Diretorio : TStringList;
   mdDiretorio : TMedidaOrdinal;
begin
   // Verifica se o calculo existe na memoria
   Result := True;
   Diretorio := TStringList.Create;
   if caProcessador.Memoria.Acha('mdDiretorio', TObject( mdDiretorio ) ) then
      Diretorio.CommaText := mdDiretorio.ValorNumerico;
   // calculo já existe
   if ( Diretorio.IndexOf( NomeCalculo ) < 0 ) then
      Result := False;
   Diretorio.Free;
end;


procedure TdmMotherBoard.CfgNutrientes;
var
   F : TfmNutrientesAcomp;
begin
   F := TfmNutrientesAcomp.Create(self);
   F.BorderIcons := [biSystemMenu,biHelp];
   F.Position := poScreenCenter;
   F.ShowModal;
   F.Free;
end;

function TdmMotherBoard.TituloVersao: String;
var
    LtffPreRelease : TFileFlag;
begin
   LtffPreRelease := vsPreRelease;
   if lslsobre.FileFlags = [LtffPreRelease] then
      Result := lslSobre.ProductName + ' - versão Beta ' +
                lslSobre.FileVersion.AsString
   else
      Result := lslSobre.ProductName + ' - versão ' +
                lslSobre.FileVersion.AsString;
end;

function TdmMotherBoard.TituloNomeArquivo: String;
begin
   Result :=  ExtractFileName(caProcessador.Memoria.NomeArquivo) + ' - ' +
              lslSobre.ProductName;
end;

procedure TdmMotherBoard.AntesDeAdicionar(Sender: TObject;
  var Cancelar: Boolean; JaExiste: Boolean);
begin
    if JaExiste then
       if MessageDlg('Este item Alimentar já está presente.' +
                      #13#10 + 'Deseja somá-lo ao existente?',
           mtConfirmation, [mbYes, mbNo], 0) = mrNo then
           Cancelar := True;
end;

procedure TdmMotherBoard.SetDMDataBases(const Value: TDataModule);
begin
  FDMDataBases := Value;
end;

function TdmMotherBoard.PrintASingleReport: Boolean;
var
   fmqrAntropometria : TfmRelAntrop01;
   fmqrRecEnergia : TfmRelNecesCal01;
//   TfmRelAtivFis01 : TTfmRelAtivFis01;
   Report : TQuickRep;
begin
  Result := True;
  fmqrAntropometria := nil;
  fmqrRecEnergia := nil;
//  fmRelAtivFis01 := nil;

  // Estes são relatórios prontos e não precisam ser montados
  // e não tem processador como os de alimentos
  if ( CalculoViewer.CalculoCorrente = 'Antropometria' )  then
     begin
        fmqrAntropometria := TfmRelAntrop01.Create(self);
        Report := fmqrAntropometria.Report;
     end
  else if ( dmMotherBoard.CalculoViewer.CalculoCorrente = 'RecCalorica' )  then
     begin
        fmqrRecEnergia := TfmRelNecesCal01.Create(self);
        Report := fmqrRecEnergia.Report;
     end
  else if ( dmMotherBoard.CalculoViewer.CalculoCorrente = 'AtividadeFisica' )  then
     begin
        ShowMessage( 'Relatório não disponível.');
        exit;
//        fmRelAtivFis01 := TfmRelAtivFis01.Create(self);
//        Report := fmRelAtivFis01.Report;
     end
  else
     begin
        Result := False;
        exit;
     end;

//  Report.ReportTitle := TQuickRep( lbSaida.Items ).ReportTitle;
  Report.PreviewModal;

  if fmqrAntropometria <> nil then
     fmqrAntropometria.Free
  else if fmqrRecEnergia <> nil then
     fmqrRecEnergia.Free;

end;

procedure TdmMotherBoard.IOControllerDepoisDeNovo(Sender: TObject);
var
    LtffPreRelease : TFileFlag;
    mdTemp : TMedidaOrdinal;
begin
   LtffPreRelease := vsPreRelease;
   with caProcessador do
   begin
      mdTemp := TMedidaOrdinal.Create(self);
      // Nome do produto que gerou o cálculo
      mdTemp.Name := 'mdProductName';
      mdTemp.ValorNumerico := lslSobre.ProductName;
      Memoria.Adiciona( 'ProductName', TObject( mdTemp ) );
      // Indica se é PreRelease ou não
      mdTemp.Name := 'mdPreRelease';
      if lslsobre.FileFlags = [LtffPreRelease] then
         mdTemp.ValorNumerico := 'True'
      else
         mdTemp.ValorNumerico := 'False';
      Memoria.Adiciona( 'PreRelease', TObject( mdTemp ) );
      // Número da versão do gerador do cálculo
      mdTemp.Name := 'mdFileVersion';
      mdTemp.ValorNumerico := lslSobre.FileVersion.AsString;
      Memoria.Adiciona( 'FileVersion', TObject( mdTemp ) );
      mdTemp.Free;
   end;
end;

procedure TdmMotherBoard.DBIOControllerDepoisDeNovo(Sender: TObject);
begin
   IOControllerDepoisDeNovo(Sender);
end;

procedure TdmMotherBoard.ConsultaNutrientes(Nutrientes: TNutrientes;
  IDMedCas: String = ''; QtdeMedCas : Double = 0; VlrGramas : Double = 100);
var
   fmNut : TfmNutrientes;
begin
   fmNut := TfmNutrientes.Create(self);
   try
      fmNut.Nutrientes := Nutrientes;
      fmNut.ShowModal;
   finally
      fmNut.Free;
   end;
end;

end.
         
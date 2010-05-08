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




unit NutWiz;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wizard, StdCtrls, Buttons, ExtCtrls, OleCtrls, OCXDCNLib_TLB, DicNut, measurement,
  Antrop02, Antrop01, RecCal01, RecCal02, RecCal03, RecCal04, RecCal05, RecCal06,SelRecCal,
  NutCalcAli, SelRefCalcAli, RecNut, RecCal07,CalculoEditor,
  fmPrepPF, fmInquND, fmDietaNome, fmInqNome, fmDistrEnergia, fmNutAcomp, fmReceita,
  fmDieObs, fmInqObs, fmPrepVerifPF, InqAtivFis;

type
  TfmNutWiz = class(TCalculoEditor)
    paNutWiz: TPanel;
    paBtWiz: TPanel;
    sbWizVoltar: TSpeedButton;
    sbWizAvancar: TSpeedButton;
    sbWizCancelar: TSpeedButton;
    sbWizTerminar: TSpeedButton;
    blWizard: TBevel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure WizardBeforeCancel(Sender: TObject; var Abort : Boolean ); virtual;
//    procedure WizardCancel(Sender: TObject; CurrentForm: TForm;
//      CurrentOption: Integer); virtual;
    procedure WizardAfterCancel(Sender: TObject); virtual;
    procedure WizardAfterTerminate(Sender: TObject); virtual;
  private
    { Private declarations }
    FSequencia: string;
    procedure SetSequencia(const Value: string);
  public
    { Public declarations }
    class function AtivaWizard (Container : TWinControl;Sequencia: string; Parent: Boolean = True):TCalculoEditor;override;
    procedure AtivaW (Sequencia: string);override;
    constructor Create (AOwner: TComponent);override;

    procedure Iniciar;
  published
    property Sequencia : string read FSequencia write SetSequencia;
  end;

var
  fmNutWiz: TfmNutWiz;

implementation

uses  DMMBoard;

{$R *.DFM}

procedure TfmNutWiz.FormShow(Sender: TObject);
begin
//#   dmMotherBoard.BackupMemoria;
end;

procedure TfmNutWiz.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;
{
procedure TfmNutWiz.WizardCancel(Sender: TObject; CurrentForm: TForm;
  CurrentOption: Integer);
begin
end;
}

procedure TfmNutWiz.WizardAfterCancel(Sender: TObject);
var
   mdTmp : TObject;
begin
   with dmMotherBoard do
   begin
      // alguem fez backup
      caProcessador.RestoreMemoria;
      // Faz o servico de fechar
{#      if not CalcDieta.Fechar then
         ShowMessage( 'Não consegui fechar CalcDieta' );
      if not CalcInquerito.Fechar then
         ShowMessage( 'Não consegui fechar CalcInquerito' );
      if not CalcPreparacao.Fechar then
         ShowMessage( 'Não consegui fechar CalcPreparacao' );
}
      CalcDieta.Fechar;
      CalcInquerito.Fechar;
      CalcPreparacao.Fechar;

      // Abrindo Os demais calculos da memoria para as tabelas
      if caProcessador.Memoria.Acha( CalcDieta.NomeCalculo, mdTmp ) then
      begin
         CalcDieta.Abrir( True );
         // liga a lista de recomendação de energia com os nutrientes da
         // dieta para calcular o saldo
         CalcDieta.SetaRecNut;
      end;
//#      else
//#         CalcDieta.Novo( True );
      if caProcessador.Memoria.Acha( CalcInquerito.NomeCalculo, mdTmp ) then
      begin
         CalcInquerito.Abrir( True );
         // liga a lista de recomendação de energia com os nutrientes da
         // dieta para calcular o saldo
         CalcInquerito.SetaRecNut;
      end;
//#      else
//#         CalcInquerito.Novo( True );
      if caProcessador.Memoria.Acha( CalcPreparacao.NomeCalculo, mdTmp ) then
         CalcPreparacao.Abrir( True );
//#      else
//#         CalcPreparacao.Novo( True );
   end;
   if Assigned( OnAfterCancel ) then
      OnAfterCancel( Sender );
   Close;
end;

procedure TfmNutWiz.WizardAfterTerminate(Sender: TObject);
begin
   if dmMotherBoard.caProcessador.Execute < 0 then
      // WizardCancel(Sender, nil, 0)
      WizardAfterCancel(Sender)
   else
     begin
         // preciso fazer isto antes de dizer que terminei
         with dmMotherBoard do
         begin
            // Registra no diretorio o calculo executado
            AddDiretorio( CalculoViewer.CalculoCorrente );
            CalculoViewer.ShowPreview;
         end;
         if Assigned( OnAfterTerminate ) then
            OnAfterTerminate( Sender );
         Close;
     end;
end;

procedure TfmNutWiz.SetSequencia(const Value: string);
begin
  FSequencia := Value;
end;

procedure TfmNutWiz.Iniciar;
begin
with dmMotherBoard do //wgb
begin //wgb
   Wizard.BotaoAvancar := sbWizAvancar; //wgb
   Wizard.BotaoVoltar := sbWizVoltar; //wgb
   Wizard.BotaoTerminar := sbWizTerminar; //wgb
   Wizard.BotaoCancelar := sbWizCancelar; //wgb
   Wizard.PainelWizard := paNutWiz; //wgb
   Wizard.OnAfterCancel := WizardAfterCancel; //wgb
   Wizard.OnBeforeCancel := WizardBeforeCancel; //wgb
   Wizard.OnAfterTerminate := WizardAfterTerminate; //wgb

   self.Caption := '';

   Wizard.Iniciar (FSequencia);
   Wizard.ShowCurrentForm;
end; //wgb
end;

class function TfmNutWiz.AtivaWizard(Container: TWinControl;
  Sequencia: string; Parent: Boolean):TCalculoEditor;
var
   WizardForm : TfmNutWiz;
begin

   if Sequencia='' then
      begin
         ShowMessage( 'Cálculo não disponível!' );
         Result := nil;
         exit;
   end;

   WizardForm := TfmNutWiz(inherited AtivaWizard(Container,  Sequencia, Parent));

//   WizardForm.Wizard.OnAfterCancel := WizardForm.WizardAfterCancel;
//   WizardForm.Wizard.onAfterTerminate := WizardForm.WizardAfterTerminate;
   dmMotherBoard.Wizard.OnAfterCancel := WizardForm.WizardAfterCancel;  //wgb
   dmMotherBoard.Wizard.onAfterTerminate := WizardForm.WizardAfterTerminate; //wgb

   if Parent then
      begin
         WizardForm.Sequencia := Sequencia;
         WizardForm.Show;
         WizardForm.Iniciar;
      end
   else
      begin
         WizardForm.Sequencia := Sequencia;
         WizardForm.Iniciar;
         WizardForm.ShowModal;
      end;
   Result:=WizardForm;
end;

constructor TfmNutWiz.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
end;


procedure TfmNutWiz.AtivaW(Sequencia: string);
begin

   if Sequencia='' then
      begin
         ShowMessage( 'Cálculo não disponível!' );
         exit;
   end;

with dmMotherBoard do //wgb
begin //wgb
   Wizard.OnAfterCancel := WizardAfterCancel;
   Wizard.OnBeforeCancel := WizardBeforeCancel;
   Wizard.onAfterTerminate := WizardAfterTerminate;
end; //wgb

   if FModal then
      begin
         FSequencia := Sequencia;
         Show;
         Iniciar;
      end
   else
      begin
         FSequencia := Sequencia;
         Iniciar;
         ShowModal;
      end;

end;

procedure TfmNutWiz.WizardBeforeCancel(Sender: TObject; var Abort: Boolean);
begin
  // só pergunta se algo foi modificado
  if dmMotherBoard.caProcessador.Memoria.Modified > 0 then
     Abort :=  ( MessageDlg('Deseja cancelar este cálculo?',
                 mtConfirmation, [ mbNo, mbYes], 0) = mrNo );
end;

initialization
    RegisterClass(TfmNutWiz);

    RegisterClass(TfmAntrop01);
    RegisterClass(TfmAntrop02);
    RegisterClass(TfmRecCal01);
    RegisterClass(TfmRecCal02);
    RegisterClass(TfmRecCal03);
    RegisterClass(TfmRecCal04);
    RegisterClass(TfmRecCal05);
    RegisterClass(TfmRecCal06);
    RegisterClass(TfmRecCal07);
    RegisterClass(TfmNutCalcAli);
    RegisterClass(TfmSelRecCal);
    RegisterClass(TfmSelRefCalcAli);
    RegisterClass(TfmRecNut);
    RegisterClass(TfmPrepPesoFinal);
    RegisterClass(TfmInqueritoNome);
    RegisterClass(TfmInqNumDias);
    RegisterClass(TfmPlanoAlimentarNome);
    RegisterClass(TfmDistribuicaoEnergia);
    RegisterClass(TfmNutrientesAcomp);
    RegisterClass(TfmPrepReceita);
    RegisterClass(TfmDieObservacoes);
    RegisterClass(TfmInqObservacoes);
    RegisterClass(TfmVerificaPesoFinal);
    RegisterClass(TfmInqAtivFis);
end.



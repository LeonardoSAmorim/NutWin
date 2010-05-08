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




unit NutCalcAli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, InsFrm, StdCtrls, DBCtrls, Grids, DBGrids, ComCtrls,
  CalcAli, Buttons, Menus, CCSListaLinks,
  CCSDBListaLinks, ToolWin, AliWiz;
//   RlListaAli,

type
  TfmNutCalcAli = class(TForm)
    paCalcAli: TPanel;
    ifCalcAli: TInFormBuilder;
    paListaAlimento: TPanel;
    edNomeAli: TEdit;
    ckDoInicio: TCheckBox;
    laNomeAli: TLabel;
    SpeedButton1: TSpeedButton;
    tbItemAli: TToolBar;
    bbEditar: TToolButton;
    bbExcluir: TToolButton;
    ToolButton5: TToolButton;
    sbOk: TSpeedButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    laMsgBotoes: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure sbRelatorioClick(Sender: TObject);
    procedure edNomeAliKeyPress(Sender: TObject; var Key: Char);
    procedure ckDoInicioClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure bbEditarClick(Sender: TObject);
    procedure bbExcluirClick(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbOkClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
  private
    { Private declarations }
    F : TfmAliWiz;
  public
    { Public declarations }
//     fmRelLstAli : TfmRelListaAlimentos;
     CalcAli : TCustomCalculoAlimentar;
  end;

var
  fmNutCalcAli: TfmNutCalcAli;

implementation

uses DMMBoard, Inquer01, Prepar01, Dieta01,
     UItensAliOrdem;

{$R *.DFM}

procedure TfmNutCalcAli.FormCreate(Sender: TObject);
begin

   // Cria form Interno
   with dmMotherBoard do
   if CalculoViewer.CalculoCorrente = 'Preparacao' then
      begin
        ifCalcAli.CriaFormInterno(TfmPrepar01);
        CalcAli := CalcPreparacao;
      end
   else if CalculoViewer.CalculoCorrente = 'Inquerito' then
      begin
        ifCalcAli.CriaFormInterno(TfmInquer01);
        CalcAli := CalcInquerito;
      end
   else if CalculoViewer.CalculoCorrente = 'PlanoAlimentar' then
      begin
        ifCalcAli.CriaFormInterno(TfmDieta01);
        CalcAli := CalcDieta;
      end
   else
      begin
        CalcAli := nil;
        exit;
      end;

   // Repassa Caption
   if Assigned( ifCalcAli.FormBuilded ) then
      Caption := ifCalcAli.FormBuilded.Caption;

   // Prepara Relatorio de Alimentos
//   fmRelLstAli := TfmRelListaAlimentos.Create(self);
//   fmRelLstAli.Report.DataSet := nil; //ListaAli.DMAlimento.quAli;
//   fmRelLstAli.QRDBText1.DataSet := nil; //ListaAli.DMAlimento.quAli;
//   fmRelLstAli.QRDBText1.DataField := 'NOME';

   dmMotherBoard.ToolBarItemAli := tbItemAli;

end;

procedure TfmNutCalcAli.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   // Passar do Temporario para a Memoria
   // Obs.: Quando o wizard fecha este form porque voltou no caminho
   // este método é chamado erroneamente (isto deve ser arrumado)
   CalcAli.Salvar;

   // Fechar form interno
   ifCalcAli.CloseInForm;

   Action := caFree;
end;

procedure TfmNutCalcAli.FormShow(Sender: TObject);
begin

   // Repassa Caption
   if Assigned( ifCalcAli.FormBuilded ) then
      Caption := ifCalcAli.FormBuilded.Caption;

   // Mostra form interno
   ifCalcAli.ShowInForm;

   // Prepara o form para inicializacao
   dmMotherBoard.MedidasCaseiras.Ativar := False;
   edNomeAli.SetFocus;

   if Assigned( CalcAli ) then
      if CalcAli.Cancelou then
end;

procedure TfmNutCalcAli.FormHide(Sender: TObject);
begin
   // Esconde Form Interno
   ifCalcAli.HideInForm;
end;

procedure TfmNutCalcAli.SpeedButton11Click(Sender: TObject);
begin
//         fmRelLstAli.qlTituloListaAlimentos.Caption := '';
//         fmRelLstAli.Report.Preview;
end;

procedure TfmNutCalcAli.sbRelatorioClick(Sender: TObject);
begin
//         fmRelLstAli.qlTituloListaAlimentos.Caption := '';
//         fmRelLstAli.Report.Print;
end;

//=======================================================================================

procedure TfmNutCalcAli.edNomeAliKeyPress(Sender: TObject; var Key: Char);
begin

   // vai para Lista de Alimentos
   if (Key = chr( VK_RETURN )) and not assigned(F) then
   begin
      Key := #0;
      // Prepara o form para a sua saida
      dmMotherBoard.ListaAlimento.FiltrarNomeAlimento := Trim( edNomeAli.Text );
      dmMotherBoard.ListaAlimento.FiltrarDoInicio := ckDoInicio.Checked;
      if dmMotherBoard.ListaAlimento.ListaDeAlimentos.DataSet.IsEmpty then
         begin
            ShowMessage( 'Não encontrei este alimento. Verifique se você não esqueceu de acentuar o nome do alimento procurado.' );
            edNomeAli.Clear; //SelectAll;
            exit
         end;

      F := TfmAliWiz.Create(self);

      // Prepara wizard
      with dmMotherBoard do
      begin
         AliWiz.BotaoAvancar := F.tbAvancar;
         AliWiz.BotaoVoltar := F.tbVoltar;
         AliWiz.BotaoTerminar := F.tbTerminar;
         AliWiz.BotaoCancelar := F.tbCancelar;
         AliWiz.PainelWizard := F.paAliWiz;
         AliWiz.OnCancel := F.AliWizCancel;
         AliWiz.OnTerminate := F.AliWizTerminate;
      end;

      dmMotherBoard.AliWiz.Iniciar('AdicionaAli');
      F.ShowModal;
      edNomeAli.SetFocus;
      edNomeAli.Clear; //SelectAll;
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
               CalcAli.Adicionar;
            end;
         end;
      F.Free;
      F := nil;
   end;
end;

procedure TfmNutCalcAli.ckDoInicioClick(Sender: TObject);
begin
   // mantem o foco no NomeAli
   edNomeAli.SetFocus;
end;

procedure TfmNutCalcAli.SpeedButton1Click(Sender: TObject);
var
   Key : Char;
begin
   Key :=  chr(VK_RETURN);
   edNomeAliKeyPress(Sender, Key);
end;

procedure TfmNutCalcAli.bbEditarClick(Sender: TObject);
begin
   dmMotherBoard.AlteraItemAlimentar( CalcAli );
end;

procedure TfmNutCalcAli.bbExcluirClick(Sender: TObject);
begin
   if MessageDlg('Confirma exclusão deste item alimentar?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      CalcAli.Retirar;
end;

procedure TfmNutCalcAli.ToolButton3Click(Sender: TObject);
begin
   CalcAli.Adicionar;
end;

procedure TfmNutCalcAli.ToolButton4Click(Sender: TObject);
var
   Key : Char;
begin
   Key :=  chr(VK_RETURN);
   edNomeAliKeyPress(Sender, Key);
end;

procedure TfmNutCalcAli.FormDestroy(Sender: TObject);
begin
   dmMotherBoard.ToolBarItemAli := nil;
end;

procedure TfmNutCalcAli.sbOkClick(Sender: TObject);
var
   Key : Char;
begin
   Key :=  chr(VK_RETURN);
   edNomeAliKeyPress(Sender, Key);
end;

procedure TfmNutCalcAli.ToolButton1Click(Sender: TObject);
var
   F : TfmItensAliOrdem;
begin
   F := TfmItensAliOrdem.Create(self);
   F.CalcAli := CalcAli;
   F.ShowModal;
   F.Free;
   Refresh;
end;

procedure TfmNutCalcAli.ToolButton2Click(Sender: TObject);
begin
   if ( CalcAli is TCalculoDieta ) then
      dmMotherBoard.ConsultaNutrientes( dmMotherBoard.DieNutrientes )
   else if ( CalcAli is TCalculoInquerito ) then
      dmMotherBoard.ConsultaNutrientes( dmMotherBoard.InqNutrientes )
   else if ( CalcAli is TCalculoPreparacao ) then
      dmMotherBoard.ConsultaNutrientes( dmMotherBoard.PrepNutrientes );
end;

end.

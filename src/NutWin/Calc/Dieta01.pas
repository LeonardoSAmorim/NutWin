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




unit Dieta01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CalcAli, Grids, DBGrids, ComCtrls, Mask, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, RefAli, Db, CCSListaLinks, CCSDBListaLinks, Measurement, NutAli,
  RXDBCtrl, NutCnst, Menus;

type
  TfmDieta01 = class(TForm)
    paCalcAli: TPanel;
    paItensAlimentares: TPanel;
    paTotais: TPanel;
    paItensAli: TPanel;
    pcCalcAli: TPageControl;
    teMacroNutrientes: TTabSheet;
    grMacroNutrientes: TDBGrid;
    paMacNutTitulo: TPanel;
    paMacNutTit3: TPanel;
    paMacNutTit2: TPanel;
    paMacNutTit1: TPanel;
    teNutrientes: TTabSheet;
    grNutrientes: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    teSaldoNut: TTabSheet;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    grSaldoNut: TDBGrid;
    teProtAVB: TTabSheet;
    paProtAVB: TPanel;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    DBText5: TDBText;
    DBText6: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    teRelacoesNut: TTabSheet;
    paRelacoes: TPanel;
    DBText7: TDBText;
    DBText8: TDBText;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    DBText9: TDBText;
    Label12: TLabel;
    Label13: TLabel;
    DBText12: TDBText;
    DBText11: TDBText;
    DBText13: TDBText;
    Label14: TLabel;
    DBText14: TDBText;
    Label15: TLabel;
    DBText15: TDBText;
    Label16: TLabel;
    DBText10: TDBText;
    Label17: TLabel;
    DBText16: TDBText;
    Label18: TLabel;
    teNutPesoDia: TTabSheet;
    DBGrid1: TDBGrid;
    tePorcentagemEnergia: TTabSheet;
    Panel9: TPanel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    DBText17: TDBText;
    DBText18: TDBText;
    DBText19: TDBText;
    DBText20: TDBText;
    DBText21: TDBText;
    DBText22: TDBText;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    DBText23: TDBText;
    DBText24: TDBText;
    Label31: TLabel;
    tePorcentagemNutValido: TTabSheet;
    grNutValidos: TDBGrid;
    teGruAliPorNut: TTabSheet;
    paGruAli1: TPanel;
    grNutPorGrupoAlimentar: TDBGrid;
    paGruAli2: TPanel;
    grNutGruAliAux: TDBGrid;
    grItensAlimentar: TDBGrid;
    teAliPorNut: TTabSheet;
    Panel10: TPanel;
    grNutPorAlimento0: TDBGrid;
    Panel11: TPanel;
    grNutPorAliAux: TDBGrid;
    Panel12: TPanel;
    teEquEnergia: TTabSheet;
    DBGrid3: TDBGrid;
    Panel13: TPanel;
    DBText25: TDBText;
    DBText27: TDBText;
    teEquProteina: TTabSheet;
    Panel14: TPanel;
    DBText29: TDBText;
    DBGrid2: TDBGrid;
    paTitulo: TPanel;
    deRefeicao: TDBText;
    naRefeicoes: TDBNavigator;
    laRefeicao: TLabel;
    grNutPorAlimento: TRxDBGrid;
    DBText30: TDBText;
    DBText31: TDBText;
    DBText26: TDBText;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure deRefeicaoClick(Sender: TObject);
    procedure grSaldoNutDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure grItensAlimentarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grItensAlimentarDblClick(Sender: TObject);
    procedure naRefeicoesClick(Sender: TObject; Button: TNavigateBtn);
    procedure grNutValidosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure pcCalcAliChange(Sender: TObject);
    procedure pcCalcAliChanging(Sender: TObject; var AllowChange: Boolean);
    procedure FormHide(Sender: TObject);
    procedure grItensAlimentarEnter(Sender: TObject);
    procedure grItensAlimentarExit(Sender: TObject);
    procedure grNutPorAlimentoTitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
    procedure grNutPorAlimentoGetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
  private
    { Private declarations }
    fmRef : TfmRefeicao;
    MySortMarker: TSortMarker;
    MyField : TField;
    MyCol : Integer;
    procedure SetCalculoAlimentar( Ativa : Boolean );
    procedure DataChange(DataSet : TDataSet);
    procedure DepoisDeOrdenaAliNutPorNutriente( Sender : TObject );
  public
    { Public declarations }
  end;

var
  fmDieta01: TfmDieta01;

implementation

uses DMMBoard, NutCalcAli, Wizard;

{$R *.DFM}

procedure TfmDieta01.FormCreate(Sender: TObject);
var
   Tmp : TObject;
   i : Integer;
begin
  MySortMarker := smNone;

  with pcCalcAli do
    for i := 0 to PageCount - 1 do
    begin
       Pages[i].Hint := Pages[i].Caption;
       Pages[i].ShowHint := True;
    end;

with dmMotherBoard do
begin

   // Para controlar a posição da coluna ordenada sempre a esquerda
   CalcDieta.OnDepoisDeOrdenaAliNutPorNutriente := DepoisDeOrdenaAliNutPorNutriente;

   // Cria janela para selecao de refeicao
   fmRef := TfmRefeicao.Create( self );
   fmRef.grRefeicoes.DataSource := dsDieRefEscolhidas;

   // Pega peso corporal para calculo de NutPesoDia
   if not Assigned( CalcDieta.PesoCorporal ) then
      if caProcessador.Memoria.Acha( 'mdPeso', Tmp ) then
         CalcDieta.PesoCorporal := TMedida( Tmp );

   CalcDieta.Calcular;

end;

end;

procedure TfmDieta01.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   // Limpa pra não dar problema
   dmMotherBoard.CalcDieta.OnDepoisDeOrdenaAliNutPorNutriente := nil;
   SetCalculoAlimentar(False);
   fmRef.Free;
   Action := caFree;
end;

procedure TfmDieta01.deRefeicaoClick(Sender: TObject);
begin
   fmRef.Show;
end;

procedure TfmDieta01.grSaldoNutDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
   if Column.FieldName = 'SALDONUT' Then
   begin
     if Column.Field.AsFloat < 0 then
        grSaldoNut.Canvas.Font.Color := clRed
     else
       if Column.Field.AsFloat = 0 then
          grSaldoNut.Canvas.Font.Color := clGreen;
   end;
   grSaldoNut.Canvas.FillRect(Rect);
   grSaldoNut.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfmDieta01.grItensAlimentarKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if ( Key = VK_DELETE ) and ( not dmMotherBoard.CalcDieta.IsEmpty ) then
      begin
         if MessageDlg('Confirma exclusão deste item alimentar?',
                        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            dmMotherBoard.CalcDieta.Retirar;
         end
   else if Key = VK_RETURN then
      dmMotherBoard.AlteraItemAlimentar( dmMotherBoard.CalcDieta );
//   else if Key = VK_INSERT then
//      dmMotherBoard.CalcDieta.Adicionar;
end;

procedure TfmDieta01.grItensAlimentarDblClick(Sender: TObject);
begin
   dmMotherBoard.AlteraItemAlimentar( dmMotherBoard.CalcDieta );
end;

procedure TfmDieta01.naRefeicoesClick(Sender: TObject;
  Button: TNavigateBtn);
begin
   dmMotherBoard.CalcDieta.Calcular;
end;

procedure TfmDieta01.grNutValidosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
   if ( Column.FieldName = 'NUTVALIDOREF' ) OR
      ( Column.FieldName = 'NUTVALIDOCALC' ) then
   begin
     if Column.Field.AsString = '' then
        exit
     else if Column.Field.AsFloat < 100 then
        grNutValidos.Canvas.Font.Color := clRed
     else if Column.Field.AsFloat > 0 then
        grNutValidos.Canvas.Font.Color := clGreen;
   end;
   grNutValidos.Canvas.FillRect(Rect);
   grNutValidos.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfmDieta01.FormShow(Sender: TObject);
begin
   pcCalcAliChange(Sender);

   grItensAlimentar.DataSource.DataSet.AfterInsert := DataChange;
   grItensAlimentar.DataSource.DataSet.AfterDelete := DataChange;

   DataChange(grItensAlimentar.DataSource.DataSet);

end;

procedure TfmDieta01.SetCalculoAlimentar(Ativa: Boolean);
var
   I : Integer;
//*   Save_Cursor:TCursor;
begin
//*   Save_Cursor := Screen.Cursor;
//*   Screen.Cursor := crHourglass;    { Show hourglass cursor }
//*   try
   dmMotherBoard.CalcDieta.MostraTodosNutrientes := dmMotherBoard.Nutrientes.VerTodos;
   with TAtivaCalculoDieta( dmMotherBoard.CalcDieta.Ativar ) do
      if pcCalcAli.ActivePage = teMacroNutrientes then
         TotalMacroNutrientes := Ativa
      else if pcCalcAli.ActivePage = teNutrientes then
         TotalNutrientes := Ativa
      else if pcCalcAli.ActivePage = teSaldoNut then
         SaldoNutrientes := Ativa
      else if pcCalcAli.ActivePage = teProtAVB then
         begin
            ProteinaAVBPorRefeicao := Ativa;
            ProteinaAVBPorCalculo := Ativa;
         end
      else if pcCalcAli.ActivePage = teRelacoesNut then
         begin
            RelacaoCaPPorRefeicao := Ativa;
            RelacaoCaPPorCalculo := Ativa;
            RelacaoAcidosGraxosPorRef := Ativa;
            RelacaoAcidosGraxosPorCalc := Ativa;
            RelacaoCaloriaNitrogenioPorRef := Ativa;
            RelacaoCaloriaNitrogenioPorCalc := Ativa;
         end
      else if pcCalcAli.ActivePage = teNutPesoDia then
         NutrientesPorPesoDia  := Ativa
      else if pcCalcAli.ActivePage = tePorcentagemEnergia then
         PorcentagemEnergiaCalculada := Ativa
      else if pcCalcAli.ActivePage = tePorcentagemNutValido then
         PorcentagemNutrientesValidos := Ativa
      else if pcCalcAli.ActivePage = teGruAliPorNut then
         with dmMotherBoard.dsDieGruAliPorNut, grNutPorGrupoAlimentar do
         begin
            GrupoAlimentarPorNutriente  := Ativa;
            if Ativa and DataSet.Active and ( DataSet.FieldList.Count >= 3 ) then
            begin
               // refresh
               DataSet.Close;
               DataSet.Open;

               Columns.Clear;
               For I := 3 to DataSet.FieldList.Count - 1 do
                  with Columns.Add do
                  begin
                     FieldName := ( DataSet.FieldList.Fields[I] ).FieldName;
                     Field := nil;
                  end;
            end;
         end
      else if pcCalcAli.ActivePage = teAliPorNut then
         with dmMotherBoard.dsDieAliPorNut, grNutPorAlimento do
         begin
            AlimentoPorNutriente  := Ativa;
            if Ativa and DataSet.Active and ( DataSet.FieldList.Count >= 20 ) then
            begin
               // refresh
               DataSet.Close;
               DataSet.Open;

               Columns.Clear;
               For I := 21 to DataSet.FieldList.Count - 1 do
                  with Columns.Add do
                  begin
                     FieldName := ( DataSet.FieldList.Fields[I] ).FieldName;
                     Field := nil;
                  end;
            end;
         end
      else if pcCalcAli.ActivePage = teEquEnergia then
         with dmMotherBoard do
              DieEquivalenteEnergia.Ativar := Ativa
      else if pcCalcAli.ActivePage = teEquProteina then
         with dmMotherBoard do
              DieEquivalenteProteina.Ativar := Ativa;
//*   finally
//*      Screen.Cursor := Save_Cursor;  { Always restore to normal }
//*   end;

end;

procedure TfmDieta01.pcCalcAliChange(Sender: TObject);
begin
   SetCalculoAlimentar( True );
   with TTabSheet( pcCalcAli.ActivePage ).Font do
   begin
      Color := clBlue;
      Style := [fsBold];
   end;
end;

procedure TfmDieta01.pcCalcAliChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
   SetCalculoAlimentar(False);
   with TTabSheet( pcCalcAli.ActivePage ).Font do
   begin
      Color := clWindowText;
      Style := [];
   end;
   AllowChange := True;
end;

procedure TfmDieta01.FormHide(Sender: TObject);
begin
   SetCalculoAlimentar( False );
end;

procedure TfmDieta01.DataChange(DataSet: TDataSet);
begin
      dmMotherBoard.CalcDieta.MsgRefeicoes;
      if dmMotherBoard.CalcDieta.RefeicaoIsEmpty <> '' then
         TForm((TPanel(Owner)).Owner).Tag := WZ_INVALIDNODE
      else
         TForm((TPanel(Owner)).Owner).Tag := 0;
      if Assigned( TForm((TPanel(Owner)).Owner).OnClick ) then
         TForm((TPanel(Owner)).Owner).OnClick(self);
end;

procedure TfmDieta01.grItensAlimentarEnter(Sender: TObject);
begin
   if Assigned(dmMotherBoard.ToolBarItemAli) then
      dmMotherBoard.ToolBarItemAli.Visible := True;
end;

procedure TfmDieta01.grItensAlimentarExit(Sender: TObject);
begin
   if Assigned(dmMotherBoard.ToolBarItemAli) then
      dmMotherBoard.ToolBarItemAli.Visible := False;
end;

procedure TfmDieta01.grNutPorAlimentoTitleBtnClick(Sender: TObject;
  ACol: Integer; Field: TField);
begin
   MyField := Field;
   MyCol := ACol;
   if MySortMarker = smUp then
      begin
         dmMotherBoard.CalcDieta.OrdenaAliNutPorNutriente( MyField, toDecrescente );
         MySortMarker := smDown;
      end
   else
      begin
         dmMotherBoard.CalcDieta.OrdenaAliNutPorNutriente( MyField, toCrescente );
         MySortMarker := smUp;
      end;
end;

procedure TfmDieta01.grNutPorAlimentoGetBtnParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor;
  var SortMarker: TSortMarker; IsDown: Boolean);
begin
  if Assigned( MyField ) and ( MyField.Name = Field.Name ) then
     SortMarker := MySortMarker;
end;

procedure TfmDieta01.DepoisDeOrdenaAliNutPorNutriente(Sender: TObject);
begin
   grNutPorAlimento.LeftCol := MyCol;
end;

end.


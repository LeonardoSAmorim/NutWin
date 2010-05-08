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




unit Prepar01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CalcAli, Grids, DBGrids, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  PAINELMEDIDA,measurement, Db, CCSListaLinks, CCSDBListaLinks, VisorCal;

type
  TfmPrepar01 = class(TForm)
    paPrepItemAlimentar: TPanel;
    paItensAli: TPanel;
    grPrepItensAlimentar: TDBGrid;
    paTotais: TPanel;
    pcCalcAli: TPageControl;
    teMacroNutrientes: TTabSheet;
    grMacroNutrientes: TDBGrid;
    teNutrientes: TTabSheet;
    grNutrientes: TDBGrid;
    tePorcentagemNutValido: TTabSheet;
    grNutValidos: TDBGrid;
    paPrepTitulo: TPanel;
    laPrepNome: TLabel;
    pmPrepPesoFinal: TPainelMedida;
    laPrepPesoFinalDescricao: TLabel;
    laPrepPesoFinalValor: TLabel;
    laPrepPesoFinalUnidade: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grPrepItensAlimentarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grPrepItensAlimentarDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pcCalcAliChange(Sender: TObject);
    procedure pcCalcAliChanging(Sender: TObject; var AllowChange: Boolean);
    procedure FormHide(Sender: TObject);
    procedure grNutValidosDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure grPrepItensAlimentarEnter(Sender: TObject);
    procedure grPrepItensAlimentarExit(Sender: TObject);
  private
    { Private declarations }
    procedure SetCalculoAlimentar(Ativa: Boolean);
    procedure DataChange(DataSet : TDataSet);
  public
    { Public declarations }
  end;

var
  fmPrepar01: TfmPrepar01;

implementation

uses DMMBoard, NutCalcAli, Wizard;

{$R *.DFM}

procedure TfmPrepar01.FormCreate(Sender: TObject);
var
//   FRec : TStringList;
   i : Integer;
begin

  with pcCalcAli do
    for i := 0 to PageCount - 1 do
    begin
       Pages[i].Hint := Pages[i].Caption;
       Pages[i].ShowHint := True;
    end;

with dmMotherBoard do
begin

   pmPrepPesoFinal.Medida := CalcPreparacao.PesoFinal;

   laPrepNome.Caption := TMedida( CalcPreparacao.DescricaoCalculo ).ValorNumerico;

   CalcPreparacao.Calcular;
end;

end;

procedure TfmPrepar01.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfmPrepar01.grPrepItensAlimentarKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if ( Key = VK_DELETE ) and ( not dmMotherBoard.CalcPreparacao.IsEmpty ) then
      begin
         if MessageDlg('Confirma exclusão deste ingrediente?',
                        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            dmMotherBoard.CalcPreparacao.Retirar;
         end
   else if Key = VK_RETURN then
      dmMotherBoard.AlteraItemAlimentar( dmMotherBoard.CalcPreparacao );
//   else if Key = VK_INSERT then
//      dmMotherBoard.CalcPreparacao.Adicionar;
end;

procedure TfmPrepar01.grPrepItensAlimentarDblClick(Sender: TObject);
begin
     dmMotherBoard.AlteraItemAlimentar( dmMotherBoard.CalcPreparacao );
end;

procedure TfmPrepar01.FormShow(Sender: TObject);
begin
   with dmMotherBoard do
   begin
      laPrepNome.Caption := TMedida( CalcPreparacao.DescricaoCalculo ).ValorNumerico;
      pmPrepPesoFinal.Refresh;
   end;
   pcCalcAliChange(Sender);

   grPrepItensAlimentar.DataSource.DataSet.AfterInsert := DataChange;
   grPrepItensAlimentar.DataSource.DataSet.AfterDelete := DataChange;

   DataChange(grPrepItensAlimentar.DataSource.DataSet);

end;

procedure TfmPrepar01.SetCalculoAlimentar(Ativa: Boolean);
//*var
//*   Save_Cursor:TCursor;
begin
//*   Save_Cursor := Screen.Cursor;
//*   Screen.Cursor := crHourglass;    { Show hourglass cursor }
//*   try
   dmMotherBoard.CalcPreparacao.MostraTodosNutrientes := dmMotherBoard.Nutrientes.VerTodos;
   with TAtivaCustomCalculoAlimentar( dmMotherBoard.CalcPreparacao.Ativar ) do
      if pcCalcAli.ActivePage = teMacroNutrientes then
         TotalMacroNutrientes := Ativa
      else if pcCalcAli.ActivePage = teNutrientes then
         TotalNutrientes := Ativa
      else if pcCalcAli.ActivePage = tePorcentagemNutValido then
         PorcentagemNutrientesValidos := Ativa;
//*   finally
//*      Screen.Cursor := Save_Cursor;  { Always restore to normal }
//*   end;

end;

procedure TfmPrepar01.pcCalcAliChange(Sender: TObject);
begin
   SetCalculoAlimentar( True );
   with TTabSheet( pcCalcAli.ActivePage ).Font do
   begin
      Color := clBlue;
      Style := [fsBold];
   end;
end;

procedure TfmPrepar01.pcCalcAliChanging(Sender: TObject;
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

procedure TfmPrepar01.FormHide(Sender: TObject);
begin

   grPrepItensAlimentar.DataSource.DataSet.AfterInsert := nil;
   grPrepItensAlimentar.DataSource.DataSet.AfterDelete := nil;

   SetCalculoAlimentar( False );
end;

procedure TfmPrepar01.grNutValidosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
   if ( Column.FieldName = 'NUTVALIDOREF' ) OR
      ( Column.FieldName = 'NUTVALIDOCALC' ) then
   begin
     if Column.Field.AsFloat < 100 then
        grNutValidos.Canvas.Font.Color := clRed
     else if Column.Field.AsFloat > 0 then
        grNutValidos.Canvas.Font.Color := clGreen;
   end;
   grNutValidos.Canvas.FillRect(Rect);
   grNutValidos.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfmPrepar01.DataChange(DataSet : TDataSet);
begin
      if dmMotherBoard.CalcPreparacao.IsEmpty then
         TForm((TPanel(Owner)).Owner).Tag := WZ_INVALIDNODE
      else
         TForm((TPanel(Owner)).Owner).Tag := 0;
      if Assigned( TForm((TPanel(Owner)).Owner).OnClick ) then
         TForm((TPanel(Owner)).Owner).OnClick(self);
end;

procedure TfmPrepar01.grPrepItensAlimentarEnter(Sender: TObject);
begin
   if Assigned(dmMotherBoard.ToolBarItemAli) then
      dmMotherBoard.ToolBarItemAli.Visible := True;
end;

procedure TfmPrepar01.grPrepItensAlimentarExit(Sender: TObject);
begin
   if Assigned(dmMotherBoard.ToolBarItemAli) then
      dmMotherBoard.ToolBarItemAli.Visible := False;
end;

end.

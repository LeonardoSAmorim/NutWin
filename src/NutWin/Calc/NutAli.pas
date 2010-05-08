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




unit NutAli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, DBGrids, Db, DBTables,
  Nutrientes, Mask, DBCtrls, NutCnst, FnpNumericEdit, CAlimento;

type
  TfmNutrientes = class(TForm)
    paFundo: TPanel;
    paNutMedidas: TPanel;
    grNutrientes: TDBGrid;
    sbOrdNome: TSpeedButton;
    sbOrdPadrao: TSpeedButton;
    sbOrdRefer: TSpeedButton;
    beOrdDivisao: TBevel;
    beDivisor: TBevel;
    sbOrdNutAcomp: TSpeedButton;
    deAlimento: TDBEdit;
    rgTipoMedida: TRadioGroup;
    dgMedNut: TDBGrid;
    fnpQtdeMed: TFnpNumericEdit;
    fnpGramas: TFnpNumericEdit;
    paProcuraNut: TPanel;
    laNutLocalizar: TLabel;
    edNutLocalizar: TEdit;
    procedure FormShow(Sender: TObject);
    procedure bbNutFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edNutLocalizarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbOrdNomeClick(Sender: TObject);
    procedure sbOrdPadraoClick(Sender: TObject);
    procedure sbOrdReferClick(Sender: TObject);
    procedure sbOrdNutAcompClick(Sender: TObject);
    procedure deAlimentoChange(Sender: TObject);
    procedure edNutLocalizarChange(Sender: TObject);
    procedure grNutrientesTitleClick(Column: TColumn);
    procedure rgTipoMedidaClick(Sender: TObject);
    procedure fnpGramasChange(Sender: TObject);
    procedure fnpQtdeMedChange(Sender: TObject);
  private
    FNutrientes: TNutrientes;
    FAlimentoCorrente: TAlimento;
    procedure SetNutrientes(const Value: TNutrientes);
    procedure SetAlimentoCorrente(const Value: TAlimento);
    { Private declarations }
  protected
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  public
    { Public declarations }
    property Nutrientes : TNutrientes read FNutrientes write SetNutrientes;
    property AlimentoCorrente : TAlimento read FAlimentoCorrente write SetAlimentoCorrente;
    procedure TrocaTipoOrdem;
  end;


implementation

uses DMMBoard;

{$R *.DFM}

// ATIVAR
procedure TfmNutrientes.FormShow(Sender: TObject);
begin
   if not Assigned( FNutrientes ) then
      exit;
   FNutrientes.OrdenarNutrientePor := onPadrao;
   // Ativa nutrientes
   if not FNutrientes.Ativar then
     begin
      FNutrientes.Ativar := True;
      // Valores Defaults
      fnpQtdeMed.Value := 1;
      rgTipoMedida.ItemIndex := 0;
      fnpGramas.Value := 100;
      fnpQtdeMed.Visible := False;
      fnpGramas.Visible := True;
      dgMedNut.Visible := False;

      FAlimentoCorrente := FNutrientes.Alimento;
      grNutrientes.DataSource := FNutrientes.ListaDeNutrientes;
      dgMedNut.DataSource := FNutrientes.ListaDeMedidasNutrientes;

      FNutrientes.QtdeMedidaAli := 1;
      FNutrientes.MedidaEmGramas := True;
      FNutrientes.PesoAli := 100;
      FNutrientes.Refresh;
      deAlimentoChange(Sender); // para fazer o caption pela primeira vez
     end;
end;

// FINALIZAR
procedure TfmNutrientes.bbNutFecharClick(Sender: TObject);
begin
   Close;
end;

procedure TfmNutrientes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   // Desativa nutrientes
      FNutrientes.Ativar := False;
end;

procedure TfmNutrientes.edNutLocalizarKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if Key = VK_DOWN then
      grNutrientes.SetFocus;
end;

procedure TfmNutrientes.sbOrdNomeClick(Sender: TObject);
begin
   if sbOrdNome.Down then
      FNutrientes.OrdenarNutrientePor := onNome;
end;

procedure TfmNutrientes.sbOrdPadraoClick(Sender: TObject);
begin
   if sbOrdPadrao.Down then
      FNutrientes.OrdenarNutrientePor := onPadrao;
end;

procedure TfmNutrientes.sbOrdReferClick(Sender: TObject);
begin
   if sbOrdRefer.Down then
//      FNutrientes.OrdenarNutrientePor := onPreferenciaUser;
end;

procedure TfmNutrientes.sbOrdNutAcompClick(Sender: TObject);
begin
      FNutrientes.VerTodos := ( not sbOrdNutAcomp.Down );
end;

procedure TfmNutrientes.deAlimentoChange(Sender: TObject);
begin
//   Caption := 'Nutrientes - ' + dmMotherBoard.ListaAlimento.ListaDeAlimentos.DataSet.FieldByName( 'NOME' ).AsString;
   if Assigned( FAlimentoCorrente ) then
      Caption := 'Nutrientes - ' + FAlimentoCorrente.DMUmAlimento.taAlimento.FieldByName( 'NOME' ).AsString
   else
      Caption := 'Nutrientes - Alimento Desconhecido';
end;

procedure TfmNutrientes.edNutLocalizarChange(Sender: TObject);
begin
//   FNutrientes.Localizar( edNutNome.Text, [loCaseInsensitive, loPartialKey] );
   FNutrientes.LocalizaNomeNutriente := edNutLocalizar.Text;
end;

procedure TfmNutrientes.grNutrientesTitleClick(Column: TColumn);
begin
   if Column.Index = 0 then
      TrocaTipoOrdem;
end;

procedure TfmNutrientes.TrocaTipoOrdem;
begin
   with FNutrientes do
      if TipoDeOrdem = toCrescente then
         TipoDeOrdem := toDecrescente
      else
         TipoDeOrdem := toCrescente;
end;

procedure TfmNutrientes.SetNutrientes(const Value: TNutrientes);
begin
  FNutrientes := Value;
end;

procedure TfmNutrientes.rgTipoMedidaClick(Sender: TObject);
begin
   if rgTipoMedida.ItemIndex = 0 then //gramas
   begin
      fnpQtdeMed.Visible := False;
      fnpGramas.Visible := True;
      dgMedNut.Visible := False;
      if Assigned( FNutrientes ) then
      begin
         FNutrientes.MedidaEmGramas := True;
         FNutrientes.PesoAli := fnpGramas.Value;
         FNutrientes.Refresh;
      end;
   end
   else
   begin
      fnpQtdeMed.Visible := True;
      fnpGramas.Visible := False;
      dgMedNut.Visible := True;
      if Assigned( FNutrientes ) then
         FNutrientes.MedidaEmGramas := False;
   end;
end;

procedure TfmNutrientes.fnpGramasChange(Sender: TObject);
begin
   if Assigned( FNutrientes ) then
      FNutrientes.PesoAli := fnpGramas.Value;
end;

procedure TfmNutrientes.fnpQtdeMedChange(Sender: TObject);
begin
   if Assigned( FNutrientes ) then
      FNutrientes.QtdeMedidaAli := fnpQtdeMed.Value;
end;

procedure TfmNutrientes.SetAlimentoCorrente(const Value: TAlimento);
begin
  FAlimentoCorrente := Value;
  if Assigned (Value) then
  begin
     Value.FreeNotification(self);
  end;
end;

procedure TfmNutrientes.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FAlimentoCorrente then
        FAlimentoCorrente := nil;
end;

end.

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




unit AliWizLista;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, DBCtrls, Grids, DBGrids, ToolWin, ExtCtrls, DB, Menus,
  nutcnst, CLstAli, SelGruAli, SelAliOrg, SelNut, RlListaAli, {NutAli,} MedCas;

type
  TfmAliWizLista = class(TForm)
    paListaAli: TPanel;
    paWizLista: TPanel;
    ckDoInicio: TCheckBox;
    laNomeAli: TLabel;
    beListaAli: TBevel;
    edNomeAli: TLabel;
    puListaAlimento: TPopupMenu;
    Nutrientes1: TMenuItem;
    MedidasCaseiras1: TMenuItem;
    N1: TMenuItem;
    Ordenarpor1: TMenuItem;
    Nome1: TMenuItem;
    Nutriente1: TMenuItem;
    MedidaPoro1: TMenuItem;
    Preo1: TMenuItem;
    Frequenciadeuso1: TMenuItem;
    Sentidodaordenao1: TMenuItem;
    Ascendente1: TMenuItem;
    Decrescente1: TMenuItem;
    N2: TMenuItem;
    Filtrarpor1: TMenuItem;
    GrupoAlimentar1: TMenuItem;
    Origem1: TMenuItem;
    N3: TMenuItem;
    Configurarimpresso1: TMenuItem;
    Imprimir1: TMenuItem;
    AlimentoCorrente1: TMenuItem;
    RestaurarDefaults: TMenuItem;
    tbAtribAli: TToolBar;
    btNut: TToolButton;
    btMedCas: TToolButton;
    grAlimento: TDBGrid;
    procedure grAlimentoKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure grAlimentoDblClick(Sender: TObject);
    procedure grAlimentoTitleClick(Column: TColumn);
    procedure puListaAlimentoPopup(Sender: TObject);
    procedure Ascendente1Click(Sender: TObject);
    procedure Decrescente1Click(Sender: TObject);
    procedure Nome1Click(Sender: TObject);
    procedure Nutriente1Click(Sender: TObject);
    procedure Frequenciadeuso1Click(Sender: TObject);
    procedure GrupoAlimentar1Click(Sender: TObject);
    procedure Origem1Click(Sender: TObject);
    procedure Configurarimpresso1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Imprimir1Click(Sender: TObject);
    procedure Nutrientes1Click(Sender: TObject);
    procedure MedidasCaseiras1Click(Sender: TObject);
    procedure RestaurarDefaultsClick(Sender: TObject);
    procedure grAlimentoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    qrRelLstAli : TfmRelListaAlimentos;
    fmMedCas : TfmMedidas;
    procedure MontaTitulo;
  public
    { Public declarations }
    procedure TrocaTipoOrdem;
    procedure ResetListaAli;
  end;

var
  fmAliWizLista: TfmAliWizLista;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmAliWizLista.grAlimentoKeyPress(Sender: TObject; var Key: Char);
begin
      dmMotherBoard.ListaAlimento.Localizar( Key,[loCaseInsensitive,loPartialKey]  );
end;

procedure TfmAliWizLista.FormShow(Sender: TObject);
begin
   // Desliga a lista de medidas, pois deixa lento o scroll da lista de alimentos
   dmMotherBoard.MedidasCaseiras.Ativar := False;
   // so para mostrar os resultados da tela anterior
   edNomeAli.Caption := dmMotherBoard.ListaAlimento.FiltrarNomeAlimento;
   ckDoInicio.Checked := dmMotherBoard.ListaAlimento.FiltrarDoInicio;

   grAlimento.SetFocus;
end;

procedure TfmAliWizLista.FormHide(Sender: TObject);
begin
   dmMotherBoard.mdAliQtde.AsFloat := 0;
   dmMotherBoard.mdAliPeso.AsFloat := 0;
    // Escolhe a proxima tela
    dmMotherBoard.MedidasCaseiras.Ativar := True;
    // Se houver medidas caseiras
    if dmMotherBoard.MedidasCaseiras.TemMedidaCaseira then
       Tag := 0  // Lista de Medidas
    else
       Tag := 1;  // PesoAlimento
    Click;
end;

procedure TfmAliWizLista.grAlimentoDblClick(Sender: TObject);
{var
   MyMess : TWMKey;}
begin
   // Vai para a proxima tela
      dmMotherBoard.AliWiz.Avancar
{   MyMess.Msg :=WM_CHAR;
   MyMess.CharCode :=VK_RETURN;
   Dispatch (MyMess);}
end;

//--------------------------------------------------------------

procedure TfmAliWizLista.TrocaTipoOrdem;
begin
   with dmMotherBoard.ListaAlimento do
      if TipoDeOrdem = toCrescente then
         TipoDeOrdem := toDecrescente
      else
         TipoDeOrdem := toCrescente;
end;

procedure TfmAliWizLista.MontaTitulo;
var
   Separador : String;
begin
   with dmMotherBoard.ListaAlimento do
   begin
      grAlimento.Columns[0].Title.Caption := '';
      if FiltrarPorGrupoAlimentar then
         begin
            grAlimento.Columns[0].Title.Caption := grAlimento.Columns[0].Title.Caption +
                         IDGrupoAlimentar.DataSet.FieldByName( 'NOMEGRU' ).AsString;
            Separador := '; ';
         end
      else
         Separador := '';
      if FiltrarPorOrigem then
         grAlimento.Columns[0].Title.Caption := grAlimento.Columns[0].Title.Caption +
                       Separador + IDOrigem.DataSet.FieldByName( 'DESCRICAO' ).AsString;
      if grAlimento.Columns[0].Title.Caption = '' then
         grAlimento.Columns[0].Title.Caption := 'ALIMENTO';
   end;

end;

procedure TfmAliWizLista.grAlimentoTitleClick(Column: TColumn);
begin
   TrocaTipoOrdem;
end;

procedure TfmAliWizLista.puListaAlimentoPopup(Sender: TObject);
begin
   with dmMotherBoard.ListaAlimento do
   begin
      Ascendente1.Checked := ( TipoDeOrdem = toCrescente );
      Decrescente1.Checked := ( TipoDeOrdem = toDecrescente );
      Nome1.Checked := ( OrdenarAlimentoPor = oaNome );
      Nutriente1.Checked := ( OrdenarAlimentoPor = oaNutrientes );
      Frequenciadeuso1.Checked := ( OrdenarAlimentoPor = oaFrequenciaUso );
      GrupoAlimentar1.Checked := FiltrarPorGrupoAlimentar;
      Origem1.Checked := FiltrarPorOrigem;
      MontaTitulo;
   end;
end;

procedure TfmAliWizLista.Ascendente1Click(Sender: TObject);
begin
   if not Ascendente1.Checked then
      TrocaTipoOrdem;
end;

procedure TfmAliWizLista.Decrescente1Click(Sender: TObject);
begin
   if not Decrescente1.Checked then
      TrocaTipoOrdem;
end;

procedure TfmAliWizLista.Nome1Click(Sender: TObject);
begin
   if not Nome1.Checked then
   begin
      dmMotherBoard.ListaAlimento.OrdenarAlimentoPor := oaNome;
      grAlimento.Columns[1].Width := 0;
   end;
end;

procedure TfmAliWizLista.Nutriente1Click(Sender: TObject);
var
   F : TfmSelNutriente;
begin
   dmMotherBoard.ListaAlimento.OrdenarAlimentoPor := oaNutrientes;
   F := TfmSelNutriente.Create( Self );
   F.ShowModal;
   if F.ModalResult = mrCancel then
      dmMotherBoard.ListaAlimento.OrdenarAlimentoPor := oaNome;
   F.Free;
   dmMotherBoard.ListaAlimento.Refresh;
   if dmMotherBoard.ListaAlimento.OrdenarAlimentoPor = oaNutrientes then
   begin
      grAlimento.Columns[1].Width := 100;
      with dmMotherBoard.ListaAlimento.IDNutriente.DataSet do
         grAlimento.Columns[1].Title.Caption := FieldByName( 'NOMENUT' ).AsString + ' (' +
                                                FieldByName( 'UNIDADE' ).AsString + ')';
   end;
end;

procedure TfmAliWizLista.Frequenciadeuso1Click(Sender: TObject);
begin
   if not Frequenciadeuso1.Checked then
   begin
      dmMotherBoard.ListaAlimento.OrdenarAlimentoPor := oaFrequenciaUso;
      grAlimento.Columns[1].Width := 70;
      grAlimento.Columns[1].Title.Caption := 'Freq. Uso';
   end;
end;

procedure TfmAliWizLista.GrupoAlimentar1Click(Sender: TObject);
var
   F : TfmSelGruAli;
begin
   dmMotherBoard.ListaAlimento.FiltrarPorGrupoAlimentar := True;
   F := TfmSelGruAli.Create( Self );
   F.ShowModal;
   if F.ModalResult = mrCancel then
      dmMotherBoard.ListaAlimento.FiltrarPorGrupoAlimentar := False;
   F.Free;
   dmMotherBoard.ListaAlimento.Refresh;
   MontaTitulo;
end;

procedure TfmAliWizLista.Origem1Click(Sender: TObject);
var
   F : TfmAliOrigem;
begin
   dmMotherBoard.ListaAlimento.FiltrarPorOrigem := True;
   F := TfmAliOrigem.Create( Self );
   F.ShowModal;
   if F.ModalResult = mrCancel then
      dmMotherBoard.ListaAlimento.FiltrarPorOrigem := False;
   F.Free;
   dmMotherBoard.ListaAlimento.Refresh;
   MontaTitulo;
end;

procedure TfmAliWizLista.Configurarimpresso1Click(Sender: TObject);
begin
   with qrRelLstAli do
   begin
      Report.ReportTitle := grAlimento.Columns[0].Title.Caption;
      qtValor.Enabled := ( grAlimento.Columns[1].Width > 0 );
      qlValor.Enabled := ( grAlimento.Columns[1].Width > 0 );
      qtValor.DataField := grAlimento.Columns[1].FieldName;
      qlValor.Caption := grAlimento.Columns[1].Title.Caption;
      Report.PreviewModal;
   end;
end;

procedure TfmAliWizLista.FormCreate(Sender: TObject);
begin
   ResetListaAli;
   // Configurando consulta às medidas
   fmMedCas := TfmMedidas.Create( Self );
   // Configurando relatório de alimentos
   qrRelLstAli := TfmRelListaAlimentos.Create(self);
   with qrRelLstAli do
   begin
      Report.DataSet := grAlimento.DataSource.DataSet;
      Report.ReportTitle := grAlimento.Columns[0].Title.Caption;
      qtNomeAli.DataSet := grAlimento.DataSource.DataSet;
      qtNomeAli.DataField := grAlimento.Columns[0].FieldName;
      qtValor.DataSet := grAlimento.DataSource.DataSet;
      if grAlimento.Columns[1].Width > 0 then
      begin
         qtValor.DataField := grAlimento.Columns[1].FieldName;
      end;
   end;
end;

procedure TfmAliWizLista.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   dmMotherBoard.Nutrientes.Ativar := False;
   fmMedCas.Free;
   qrRelLstAli.Free;
end;

procedure TfmAliWizLista.Imprimir1Click(Sender: TObject);
begin
   with qrRelLstAli do
   begin
      Report.ReportTitle := grAlimento.Columns[0].Title.Caption;
      qtValor.Enabled := ( grAlimento.Columns[1].Width > 0 );
      qlValor.Enabled := ( grAlimento.Columns[1].Width > 0 );
      qtValor.DataField := grAlimento.Columns[1].FieldName;
      qlValor.Caption := grAlimento.Columns[1].Title.Caption;
      Report.Print;
   end;
end;

procedure TfmAliWizLista.Nutrientes1Click(Sender: TObject);
begin
   dmMotherBoard.ConsultaNutrientes( dmMotherBoard.Nutrientes );
end;

procedure TfmAliWizLista.MedidasCaseiras1Click(Sender: TObject);
begin
   fmMedCas.Show;
end;

procedure TfmAliWizLista.RestaurarDefaultsClick(Sender: TObject);
begin
   ResetListaAli;
end;

procedure TfmAliWizLista.ResetListaAli;
begin
   with dmMotherBoard.ListaAlimento do
   begin
      OrdenarAlimentoPor := oaNome;
      FiltrarPorGrupoAlimentar := False;
      FiltrarPorOrigem := False;
      TipoDeOrdem := toCrescente;
   end;
   MontaTitulo;
   grAlimento.Columns[1].Width := 0;
end;

//*
procedure TfmAliWizLista.grAlimentoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if Column.Title.Caption = 'Equ.' then
  with grAlimento.Canvas do
  begin
     Font.Style := [fsBold];
     TextOut(Rect.Left + Font.Size, Rect.Top + 2, dmMotherBoard.ListaAlimento.PegaSubEP(''));
  end;
end;

end.

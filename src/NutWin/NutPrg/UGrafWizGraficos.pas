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




unit UGrafWizGraficos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ChartFaixas, GraficoFaixa, TeeProcs, TeEngine, Chart,
  ComCtrls, Mask,  fmRelGraficos, FnpNumericEdit;

type
  TfmGrafWizGraficos = class(TForm)
    paWiz: TPanel;
    Splitter1: TSplitter;
    ctGraficos: TChart;
    gfGraficos: TGraficoFaixa;
    paOpcoes: TPanel;
    btImprimir: TButton;
    laTit: TLabel;
    paLegenda: TPanel;
    lvAntrops: TListView;
    paEscala: TPanel;
    laYMax: TLabel;
    laYMin: TLabel;
    laIncY: TLabel;
    Label1: TLabel;
    fnpYMax: TFnpNumericEdit;
    fnpYMin: TFnpNumericEdit;
    fnpIncY: TFnpNumericEdit;
    btAplicar: TButton;
    btFitChart: TButton;
    procedure btFitChartClick(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure VisualizarGrafico;
    procedure FormHide(Sender: TObject);
    procedure btAplicarClick(Sender: TObject);
    procedure ctGraficosAfterDraw(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  fmGrafWizGraficos: TfmGrafWizGraficos;

implementation

uses DMGraf;

{$R *.DFM}

procedure TfmGrafWizGraficos.btFitChartClick(Sender: TObject);

begin

 with dmGraficos do begin
  GraficoFaixa := gfGraficos;
  with GraficoFaixa.Chart do
//   if ctGraficos.LeftAxis.Automatic then
//    begin
//       btFitChart.Caption := '&Normal';
//       FitChart;
//       Fit := True;
//    end
//   else
    begin
//       btFitChart.Caption := '&Ampliar linha';
       NormalChart;

//   fnpYMin.Value := ctGraficos.LeftAxis.Minimum;
//   fnpYMax.Value := ctGraficos.LeftAxis.Maximum;
   ctGraficos.LeftAxis.Increment := 1;

       Fit := False;
    end;
 end;
end;

procedure TfmGrafWizGraficos.btImprimirClick(Sender: TObject);
var
  P : TRelGraficos;
  SalvaCursor : TCursor;
begin
  SalvaCursor := Screen.Cursor;     { Salva cursor atual }
  Screen.Cursor := crHourglass;     { Mostra ampulheta }

 with dmGraficos do
 begin
//  Application.CreateForm( TRelGraficos, relGraficos );
  P := TRelGraficos.Create(self);

   // Seta variáveis
     quAntrops.DisableControls;
     GraficoFaixa := P.gfRelGraficos;
     MinDate := dmGraficos.DataInicialUsuario;
     MaxDate := dmGraficos.DataFinalUsuario;

   with taDescFaixas do begin
      NomeMedida := FieldByName( 'MEDIDA' ).AsString;
      NomeMedidaDiag := FieldByName( 'MEDIDADIAG' ).AsString;
      if not ShowChart( FieldByName( 'TABELA' ).AsString, FieldByName( 'FILTRO' ).AsString ) then
     begin
        btFitChart.Enabled := False;
        btImprimir.Enabled := False;
        lvAntrops.Visible := False;
        btFitChart.Enabled := False;
        btImprimir.Enabled := False;
        exit;
     end
     else
     begin
        lvAntrops.Visible := True;
        ctGraficos.Visible := True;
        btImprimir.Enabled := True;
        btFitChart.Enabled := True;
        btFitChart.Enabled := True;
        btImprimir.Enabled := True;
     end;
   end;
   P.AutoY := ctGraficos.LeftAxis.Automatic;
   P.YMax := ctGraficos.LeftAxis.Maximum;
   P.YMin := ctGraficos.LeftAxis.Minimum;
   P.IncY := ctGraficos.LeftAxis.Increment;
//   if Fit then
//      FitChart
//   else
//      NormalChart;
   quAntrops.EnableControls;
 end;

 Screen.Cursor := SalvaCursor;   { Restaura cursor inicial }

 P.Report.Preview;
 P.Free;
end;


procedure TfmGrafWizGraficos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmGrafWizGraficos.FormShow(Sender: TObject);
begin
   dmGraficos.quAntrops.Active := True;
   ctGraficos.Visible := False;
   lvAntrops.Visible := False;
//   btVisualizar.Enabled := True;
   btFitChart.Enabled := False;
   btImprimir.Enabled := False;
   VisualizarGrafico;
   if dmGraficos.ComFaixas then
      paEscala.Visible := False
   else
      paEscala.Visible := True;
end;

procedure TfmGrafWizGraficos.VisualizarGrafico;
var
  I: integer;
  ListItem: TListItem;
begin
 with dmGraficos do
 begin
   // Seta variáveis
   quAntrops.DisableControls;
   GraficoFaixa := gfGraficos;
   NormalChart;
   Fit := False;
   btFitChart.Caption := '&Padrão';
   MinDate := dmGraficos.DataInicialUsuario;
   MaxDate := dmGraficos.DataFinalUsuario;

   with taDescFaixas do begin
     NomeMedida := FieldByName( 'MEDIDA' ).AsString;
     NomeMedidaDiag := FieldByName( 'MEDIDADIAG' ).AsString;
     if not ShowChart( FieldByName( 'TABELA' ).AsString, FieldByName( 'FILTRO' ).AsString ) then
     begin
        btFitChart.Enabled := False;
        btImprimir.Enabled := False;
        lvAntrops.Visible := False;
        btFitChart.Enabled := False;
        btImprimir.Enabled := False;
        ShowMessage( 'Não posso fazer o gráfico por falta de dados válidos!' );
     end
     else
     begin
        lvAntrops.Visible := True;
        ctGraficos.Visible := True;
        btImprimir.Enabled := True;
        btFitChart.Enabled := True;
        btFitChart.Enabled := True;
        btImprimir.Enabled := True;
     end;
     quAntrops.EnableControls;
  end;
   // Preenche tabela de valores
   with lvAntrops do
   begin
     if taDescFaixas.FieldByName( 'BEGINUNIT' ).AsString <> '' then
        Columns[2].Caption := taDescFaixas.FieldByName( 'BEGINUNIT' ).AsString
     else
        Columns[2].Caption := 'Valor';
     Items.Clear;
     for I := (gfGraficos.Visitas.Count - 1) downto 0  do
      begin
        ListItem := Items.Add;
        ListItem.Caption := DateToStr(dmGraficos.DataInicial + StrToInt( gfGraficos.Visitas.Strings[I] )); //
        ListItem.SubItems.Add(gfGraficos.Visitas.Strings[I]);
        ListItem.SubItems.Add(gfGraficos.Resultados.Strings[I]);
        if dmGraficos.Diagnosticos.Strings[I] = '' then
           ListItem.SubItems.Add('-----------')
        else
           ListItem.SubItems.Add(dmGraficos.Diagnosticos.Strings[I]);
      end;
   end;
 end;
end;

procedure TfmGrafWizGraficos.FormHide(Sender: TObject);
begin
   dmGraficos.quAntrops.Active := False;
end;

procedure TfmGrafWizGraficos.btAplicarClick(Sender: TObject);
begin
   if ( fnpYMin.Value > fnpYMax.Value ) then
      ShowMessage( 'Valor mínimo deve ser menor que valor máximo.' )
   else if ( fnpIncY.Value <= 0 ) then
      ShowMessage( 'Incremento deve ser maior que zero.' )
   else if ( ABS( fnpYMax.Value - fnpYMin.Value ) > 1 ) and
           ( ABS( fnpYMax.Value - fnpYMin.Value ) < fnpIncY.Value ) then
      ShowMessage( 'Incremento deve ser menor ou igual a diferença entre o máximo e o mínimo, exceto quando 1.' )
   else
      gfGraficos.SetaEscalasXYInc( '', '', '1', FloatToStr(fnpYMin.Value), FloatToStr(fnpYMax.Value) , FloatToStr(fnpIncY.Value) );
end;

procedure TfmGrafWizGraficos.ctGraficosAfterDraw(Sender: TObject);
begin
   fnpYMin.Value := ctGraficos.LeftAxis.Minimum;
   fnpYMax.Value := ctGraficos.LeftAxis.Maximum;
   fnpIncY.Value := ctGraficos.LeftAxis.Increment;
end;

end.

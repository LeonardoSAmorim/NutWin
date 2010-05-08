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




unit UGrafAc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Measurement, ExtCtrls,TeeProcs, TeEngine, Chart, ChartFaixas, StdCtrls,
  FaixasTabela, MedidasBlobs, GraficoFaixa, Series, TeeFunci, Memoria,
  DBTables, Db, Grids, DBGrids, ROM, Buttons, Mask, ToolEdit, Spin,
  fmRelGraficos, DMGraf, DBIndex, RxDBComb, RXLookup, ComCtrls;

type
  TfmGrafAcomp = class(TForm)
    gfGraficos: TGraficoFaixa;
    paDados: TPanel;
    paOpcoes: TPanel;
    btFitChart: TButton;
    deInicio: TDateEdit;
    deFim: TDateEdit;
    spIdade: TSpinEdit;
    cbSexo: TComboBox;
    cbPessoa: TComboBox;
    btVisualizar: TButton;
    btImprimir: TButton;
    Splitter1: TSplitter;
    leMedidas: TRxLookupEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    bfFechar: TButton;
    Panel1: TPanel;
    ctGraficos: TChart;
    lvAntrops: TListView;
    procedure btFitChartClick(Sender: TObject);
    procedure btVisualizarClick(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bfFecharClick(Sender: TObject);
    procedure leMedidasCloseUp(Sender: TObject);
    procedure deInicioChange(Sender: TObject);
  private
    { Private declarations }
    P : TRelGraficos;
//    Fit : Boolean;
  public
    { Public declarations }
  end;

var
  fmGrafAcomp: TfmGrafAcomp;

implementation

{$R *.DFM}

procedure TfmGrafAcomp.btFitChartClick(Sender: TObject);
begin
 with dmGraficos do begin
  GraficoFaixa := gfGraficos;
  with GraficoFaixa.Chart do
   if ctGraficos.LeftAxis.Automatic then
    begin
       btFitChart.Caption := '&Normal';
       FitChart;
       Fit := True;
    end
   else
    begin
       btFitChart.Caption := '&Ampliar linha';
//       FitChart;
       NormalChart;
       Fit := False;
    end;
 end;
end;

procedure TfmGrafAcomp.btVisualizarClick(Sender: TObject);
var
  I: integer;
  ListItem: TListItem;
begin
 with dmGraficos do
 begin
   // Seta variáveis
   taAntrops.DisableControls;
   GraficoFaixa := gfGraficos;
   NormalChart;
   Fit := False;
   btFitChart.Caption := '&Ampliar linha';
   MinDate := deInicio.Date;
   MaxDate := deFim.Date;

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
     taAntrops.EnableControls;
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
        ListItem.SubItems.Add(dmGraficos.Diagnosticos.Strings[I]);
      end;
   end;
 end;
end;

procedure TfmGrafAcomp.btImprimirClick(Sender: TObject);
begin
 with dmGraficos do
 begin
   // Seta variáveis
   taAntrops.DisableControls;
   GraficoFaixa := P.gfRelGraficos;
   MinDate := deInicio.Date;
   MaxDate := deFim.Date;

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
   if Fit then
      FitChart
   else
      NormalChart;
   taAntrops.EnableControls;
 end;
 P.Report.Preview;
end;

procedure TfmGrafAcomp.FormCreate(Sender: TObject);
begin
   deInicio.Date := Date;
   deFim.Date := Date;

   with dmGraficos do begin
      dbGraficos.Connected := True;
      taDescFaixas.Open;
      Sexo := cbSexo.Text;
      Idade := spIdade.Value;
      IDPessoa := cbPessoa.Text;
      NomeIndividuo := 'Nome não informado';
   end;
   P := TRelGraficos.Create(self);
end;

procedure TfmGrafAcomp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   P.Free;
   with dmGraficos do
     dbGraficos.Connected := False;
end;

procedure TfmGrafAcomp.bfFecharClick(Sender: TObject);
begin
   Close;
end;

procedure TfmGrafAcomp.leMedidasCloseUp(Sender: TObject);
begin
   if leMedidas.EditText <> '' then
   begin
      ctGraficos.Visible := False;
      lvAntrops.Visible := False;
      btVisualizar.Enabled := True;
      btFitChart.Enabled := False;
      btImprimir.Enabled := False;
   end;
end;

procedure TfmGrafAcomp.deInicioChange(Sender: TObject);
begin
      ctGraficos.Visible := False;
      lvAntrops.Visible := False;
      btVisualizar.Enabled := True;
      btFitChart.Enabled := False;
      btImprimir.Enabled := False;

end;

end.

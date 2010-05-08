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




unit fmRelGraficos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  QREPFORM, TeeProcs, TeEngine, Chart, DBChart, QrTee, Qrctrls, QuickRpt,
  ExtCtrls, ChartFaixas, GraficoFaixa;

type
  TRelGraficos = class(TFormReport)
    QRBand1: TQRBand;
    QRDBChart1: TQRDBChart;
    ctQRGrafico: TQRChart;
    gfRelGraficos: TGraficoFaixa;
    QRBand2: TQRBand;
    QRBand3: TQRBand;
    qlTituloDias: TQRLabel;
    qlTituloValor: TQRLabel;
    qlDias: TQRLabel;
    qlValor: TQRLabel;
    qlTituloData: TQRLabel;
    qlData: TQRLabel;
    QRLabel1: TQRLabel;
    qlDiagnostico: TQRLabel;
    procedure ReportNeedData(Sender: TObject; var MoreData: Boolean);
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private
    { Private declarations }
    Ind : Integer;
  public
    { Public declarations }
    YMin, YMax, IncY : Double;
    AutoY : Boolean;
  end;

implementation

uses DMGraf;

{$R *.DFM}

procedure TRelGraficos.ReportNeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  inherited;
  with gfRelGraficos do begin
     if ( Ind < 0 ) then
        MoreData := False
     else
        begin
           qlData.Caption := DateToStr(dmGraficos.DataInicial + StrToInt( Visitas.Strings[Ind] ));
           qlDias.Caption := Visitas.Strings[Ind];
           qlValor.Caption := Resultados.Strings[Ind];
           if dmGraficos.Diagnosticos.Strings[Ind] = '' then
              qlDiagnostico.Caption := '-----------'
           else
              qlDiagnostico.Caption := dmGraficos.Diagnosticos.Strings[Ind];
           MoreData := True;
           Dec(Ind);
        end;
  end;
end;

procedure TRelGraficos.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  inherited;
  Ind := gfRelGraficos.Visitas.Count - 1;
  qlTituloValor.Caption := dmGraficos.taDescFaixas.FieldByName( 'BEGINUNIT' ).AsString;
  if qlTituloValor.Caption = '' then
     qlTituloValor.Caption := 'Valor';
  if not AutoY then
  begin
     ctQRGrafico.Chart.LeftAxis.Maximum := YMax;
     ctQRGrafico.Chart.LeftAxis.Minimum := YMin;
     ctQRGrafico.Chart.LeftAxis.Increment := IncY;
  end
  else
     ctQRGrafico.Chart.LeftAxis.Automatic := True;
  ctQRGrafico.Refresh;
end;

end.

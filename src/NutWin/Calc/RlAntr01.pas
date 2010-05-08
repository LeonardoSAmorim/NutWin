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




unit RlAntr01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VisorCal, VisorMedida, quickrpt, Qrctrls, ExtCtrls, QRPRNTR, Db, DBTables, QREPFORM,
  Memoria, Procedimento, jpeg, Measurement, DicNut, fmFormRelMedResult,
  fmFormRelIndividuo, TeeProcs, TeEngine, Chart, DBChart,
  QrTee, Series, NutCnst;

type
  TfmRelAntrop01 = class(TfmRepMedResult)
    qbVazio: TQRSubDetail;
    qbGrafAdequacao: TQRSubDetail;
    QRDBChart1: TQRDBChart;
    QRChart1: TQRChart;
    Series1: THorizBarSeries;
    qbGrafAdeqPesoDesejavel: TQRSubDetail;
    QRChart2: TQRChart;
    QRDBChart2: TQRDBChart;
    Series2: THorizBarSeries;
    QRSubDetail1: TQRSubDetail;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure QRChart1Print(Sender: TQRChart; var PaperRect,
      ChartRect: TRect);
  private
    { Private declarations }
    function MontaGraficoAdeqP50 : Boolean;
    function MontaGraficoAdeqPesoDesejavel : Boolean;
  public
    { Public declarations }
  end;


implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRelAntrop01.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

function TfmRelAntrop01.MontaGraficoAdeqP50 : Boolean;
var
   mdAdeq, mdDiagAdeq : TMedida;
   prProc : TProcedimento;
   I : Integer;
begin
   Result := False;
   I := 0;
   With dmMotherBoard.caProcessador.Memoria do
   begin
      if Acha( 'prAMB', TObject( prProc ) ) and
         ( prProc.Estado = psChecked ) and
         Acha( 'mdAdeqAMB', TObject( mdAdeq ) ) and
         Acha( 'mdDiagAMB', TObject( mdDiagAdeq ) ) and
         not mdAdeq.Empty then
         begin
            Series1.AddXY( mdAdeq.AsFloat, I, 'Área Musc. do Braço', clWhite );  //  mdDiagAdeq.ValorNumerico
            Inc( I );
            Result := True;
         end;
      if Acha( 'prCMB', TObject( prProc ) ) and
         ( prProc.Estado = psChecked ) and
         Acha( 'mdAdeqCMB', TObject( mdAdeq ) ) and
         Acha( 'mdDiagCMB', TObject( mdDiagAdeq ) ) and
         not mdAdeq.Empty then
         begin
            Series1.AddXY( mdAdeq.AsFloat, I, 'Circ. Musc. do Braço', clWhite );
            Inc( I );
            Result := True;
         end;
      if Acha( 'prCMB', TObject( prProc ) ) and
         ( prProc.Estado = psChecked ) and
         Acha( 'mdAdeqCB', TObject( mdAdeq ) ) and
         Acha( 'mdDiagCB', TObject( mdDiagAdeq ) ) and
         not mdAdeq.Empty then
         begin
            Series1.AddXY( mdAdeq.AsFloat, I, 'Circ. do Braço', clWhite );
            Inc( I );
            Result := True;
         end;
      if Acha( 'prCMB', TObject( prProc ) ) and
         ( prProc.Estado = psChecked ) and
         Acha( 'mdAdeqPCT', TObject( mdAdeq ) ) and
         Acha( 'mdDiagPCT', TObject( mdDiagAdeq ) ) and
         not mdAdeq.Empty then
         begin
            Series1.AddXY( mdAdeq.AsFloat, I, 'Prega Cut. do Tríceps', clWhite );
            Inc( I );
            Result := True;
         end;
      if Acha( 'prRPCPT', TObject( prProc ) ) and
         ( prProc.Estado = psChecked ) and
         Acha( 'mdAdeqPC', TObject( mdAdeq ) ) and
         Acha( 'mdDiagPC', TObject( mdDiagAdeq ) ) and
         not mdAdeq.Empty then
         begin
            Series1.AddXY( mdAdeq.AsFloat, I, 'Perímetro Cefálico', clWhite );
            Inc( I );
            Result := True;
         end;
  end;
end;

function TfmRelAntrop01.MontaGraficoAdeqPesoDesejavel: Boolean;
var
   mdAdeq : TMedida;
   prProc : TProcedimento;
   I : Integer;
begin
   Result := False;
   I := 0;
   With dmMotherBoard.caProcessador.Memoria do
   begin
      if Acha( 'prPDM', TObject( prProc ) ) and
         ( prProc.Estado = psChecked ) and
         Acha( 'mdAdeqPAPRM', TObject( mdAdeq ) ) and
         not mdAdeq.Empty then
         begin
            Series2.AddXY( mdAdeq.AsFloat, I, 'Peso Desejável '+#13+'por Metropolitan', clWhite );
            Inc( I );
            Result := True;
         end;
      if Acha( 'prPDIMC', TObject( prProc ) ) and
         ( prProc.Estado = psChecked ) and
         Acha( 'mdAdeqPAPDIMC', TObject( mdAdeq ) ) and
         not mdAdeq.Empty then
         begin
            Series2.AddXY( mdAdeq.AsFloat, I, 'Peso Desejável '+#13+'por IMC', clWhite );
            Inc( I );
            Result := True;
         end;
      if Acha( 'prPDCS', TObject( prProc ) ) and
         ( prProc.Estado = psChecked ) and
         Acha( 'mdAdeqPAPDCS', TObject( mdAdeq ) ) and
         not mdAdeq.Empty then
         begin
            Series2.AddXY( mdAdeq.AsFloat, I, 'Peso Desejável '+#13+'por Cálc. Simples', clWhite );
            Inc( I );
            Result := True;
         end;
  end;
end;

procedure TfmRelAntrop01.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
var
   mdMed : TMedida;
begin
  inherited;
  dmMotherBoard.caProcessador.EncheListas( 'cxcaAntrop', FProcedimentos, FMedidas, FResultados );
  if not dmMotherBoard.caProcessador.Memoria.Acha( 'mdEscopoCriado', TObject( mdMed ) ) then
     begin
        qbGrafAdequacao.Enabled := False;
        qbGrafAdeqPesoDesejavel.Enabled := False;
     end
  else
    begin
     qbGrafAdequacao.Enabled := MontaGraficoAdeqP50;
     qbGrafAdeqPesoDesejavel.Enabled := MontaGraficoAdeqPesoDesejavel;
    end;

  // Formata listas de medidas conforme listas de estilos
  if FileExists( ConfigPath + '\' + 'MedAntrop.sto' ) then
     FMedidaEstilo.LoadFromFile( ConfigPath + '\' + 'MedAntrop.sto' );
  if FileExists( ConfigPath + '\' + 'ResAntrop.sto' ) then
     FResultEstilo.LoadFromFile( ConfigPath + '\' + 'ResAntrop.sto' );
  FormataListaMedidas( FMedidas, FMedidaEstilo );
  FormataListaMedidas( FResultados, FResultEstilo );
end;

procedure TfmRelAntrop01.FormDestroy(Sender: TObject);
begin
  inherited;
// Isto precisa existir pra chamar o destroy do pai
end;

procedure TfmRelAntrop01.FormCreate(Sender: TObject);
begin
  inherited;
// Isto precisa existir pra chamar o create do pai
end;

procedure TfmRelAntrop01.QRChart1Print(Sender: TQRChart; var PaperRect,
  ChartRect: TRect);
begin
  inherited;
  // Gambiarra pra poder imprimir os gráficos
  ChartRect.Bottom := 260;
  ChartRect.Right := 730;
{  ShowMessage( Sender.Name + #13#10+
              'Paper Top: ' +IntToStr(PaperRect.Top) + ', Left: ' +
              IntToStr(PaperRect.Left) + ', Bottom: ' +
              IntToStr(PaperRect.Bottom) + ', Right: ' +
              IntToStr(PaperRect.Right) + #13#10 +
              'Chart Top: ' +IntToStr(ChartRect.Top) + ', Left: ' +
              IntToStr(ChartRect.Left) + ', Bottom: ' +
              IntToStr(ChartRect.Bottom) + ', Right: ' +
              IntToStr(ChartRect.Right));}
end;

end.
 
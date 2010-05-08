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




unit RlGrafRecNut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  qrepform, Qrctrls, QuickRpt, jpeg, ExtCtrls, TeEngine, Series, TeeProcs,
  Chart, DBChart, QrTee, CalcAli, Procedimento, Memoria, Measurement, RelConfig,
  VisorCal, VisorMedida;

type
  TfmRelGrafRecNut = class(TFormReport)
    qbSumario0: TQRBand;
    qcRecNut: TQRChart;
    QRDBChart1: TQRDBChart;
    Series1: THorizBarSeries;
    qrNovaPagina: TQRBand;
    qrCabecalho: TQRBand;
    qrCabecalho1: TQRChildBand;
    qrCabecalho2: TQRChildBand;
    QRLabel1: TQRLabel;
    vmNomeIndividuo: TVisorMedida;
    vcRelIndividuo: TVisorCalculo;
    qlNomeDescricao: TQRLabel;
    qlNomeValor: TQRLabel;
    qbSumario: TQRChildBand;
    qsTraco: TQRShape;
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qrNovaPaginaAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure qrCabecalhoBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure qbSumarioAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
  protected
    { Resets prop of component type if referenced component deleted }
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  private
    FImprimiuCabecalho : Boolean;
    FCalculoAlimentar: TCalculoDieta;
    FRelConfig : TRelatorio;
    procedure SetCalculoAlimentar(const Value: TCalculoDieta);
    { Private declarations }
  public
    { Public declarations }
    property CalculoAlimentar : TCalculoDieta read FCalculoAlimentar write SetCalculoAlimentar;
    function GetIDReport : String; override;
    procedure SetRelConfig( const Value : TRelatorio ); override;
  end;

var
  fmRelGrafRecNut: TfmRelGrafRecNut;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRelGrafRecNut.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FCalculoAlimentar then
        FCalculoAlimentar := nil;
     if AComponent = FRelConfig then
        FRelConfig := nil;
end;

procedure TfmRelGrafRecNut.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
var
  t, I : Integer;
  Valor : Double;
  cxRecCal : TCaixa;
  mdSelRecCal : TMedidaOrdinal;
begin
  inherited;
  qcSubTitulo.Enabled := FRelConfig.MostraTitulo;
  // Define se vai haver traço no final de cada relatório
  qbSumario.Height := FRelConfig.LinhaSeparadora;
  qsTraco.Height := qbSumario.Height;
  qsTraco.Enabled := (FRelConfig.LinhaSeparadora > 0);

  FImprimiuCabecalho := False;
  vcRelIndividuo.Refresh;
  if not Assigned( FCalculoAlimentar ) then
     exit;
  if dmMotherBoard.caProcessador.Memoria.Acha( 'cxcaRecCal', TObject(cxRecCal)) then
  with cxRecCal do
  begin
     for I := 0 to ComponentCount - 1 do
     begin
        if ( Components[I] is TProcedimento ) and ( TProcedimento(Components[I]).Estado = psChecked ) then
        begin
           if dmMotherBoard.caProcessador.Memoria.Acha( 'mdSelRecCal', TObject(mdSelRecCal)) then
           begin
              qcRecNut.Chart.Title.Text.Clear;
              qcRecNut.Chart.Title.Text.Add( 'Recomendação Nutricional' );
              if ( mdSelRecCal.AsFloat = 2 ) then
                 qcRecNut.Chart.Title.Text.Add( 'para ' + TProcedimento(Components[I]).Descricao )
              else if ( mdSelRecCal.AsFloat = 1 ) then
                 qcRecNut.Chart.Title.Text.Add( 'fornecida pelo usuário' )
           end;
        end;
     end;
  end;
  TAtivaCalculoDieta( FCalculoAlimentar.Ativar ).SaldoNutrientes := True;
  with FCalculoAlimentar.SaldoNutrientes do
  begin
     t := 0;
     DataSet.Last;
     while not DataSet.Bof do
     begin
        if DataSet.FieldByName( 'RECNUT').AsFloat > 0 then
        begin
           Valor := ( DataSet.FieldByName( 'VALORTOT').AsFloat / DataSet.FieldByName( 'RECNUT').AsFloat ) * 100;
           Series1.AddXY( Valor, t, DataSet.FieldByName( 'NOMENUT').AsString, clBlue );
           Inc(t);
        end;
        DataSet.Prior;
     end;
     if t <= 2 then
        qcRecNut.Height := 150 * t
     else
        qcRecNut.Height := 50 * t;
     if qcRecNut.Height > 700 then
        qcRecNut.Height := 700;
     qbSumario0.Height := qcRecNut.Height;
     qcRecNut.Top := 0;
  end;
end;

procedure TfmRelGrafRecNut.SetCalculoAlimentar(const Value: TCalculoDieta);
begin
  FCalculoAlimentar := Value;
  if Assigned( Value ) then
     Value.FreeNotification(self);
end;

procedure TfmRelGrafRecNut.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  TAtivaCalculoDieta( FCalculoAlimentar.Ativar ).SaldoNutrientes := False;
end;

function TfmRelGrafRecNut.GetIDReport: String;
begin
   Result := '{83294A6B-04B5-11D4-9DBF-000021609D7C}';
end;

procedure TfmRelGrafRecNut.qrNovaPaginaAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if NovaPagina then
     Report.NewPage;
end;

procedure TfmRelGrafRecNut.SetRelConfig(const Value: TRelatorio);
begin
   if (Value <> nil) then
   begin
      FRelConfig := Value;
      FRelConfig.Report := Report;
   end;
end;

procedure TfmRelGrafRecNut.qrCabecalhoBeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  inherited;
  // Seta os controls do relatório, vom as propriedades do TRelatr
  case (FRelConfig.TipoIdentificacao) of
     riCompleta:     begin
                     // não passou nenhuma vez na 1o
                     if (not FImprimiuCabecalho ) then
                     begin
                         qrCabecalho1.Enabled := False;
                     end
                     else
                     begin
                         qrCabecalho1.Enabled := True;
                     end;
                     FImprimiuCabecalho := True;
                     end;
     riSimplificada: begin
                         qrCabecalho1.Enabled := True;
                     end;
     riNenhuma:      begin
                         qrCabecalho1.Enabled := False;
                     end;
   end;

end;

procedure TfmRelGrafRecNut.qbSumarioAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if FRelConfig.NovaPagina then
     Report.NewPage;
end;

end.

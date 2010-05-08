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




unit RlNutPesoDia;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  qrepform, Qrctrls, QuickRpt, jpeg, ExtCtrls, CalcAli, Measurement,
  VisorMedida, VisorCal, RelConfig;

type
  TfmRelNutPesoDia = class(TFormReport)
    QRShape5: TQRShape;
    QRShape4: TQRShape;
    qtNutriente: TQRDBText;
    qtValorTot: TQRDBText;
    qtTotalNutPesoDia: TQRDBText;
    qtUnidade: TQRDBText;
    QRShape8: TQRShape;
    qbSumario: TQRBand;
    qrCabecalho: TQRBand;
    vcRelIndividuo: TVisorCalculo;
    vmNomeIndividuo: TVisorMedida;
    qrCabecalho1: TQRChildBand;
    qrCabecalho2: TQRChildBand;
    qlNomeDescricao: TQRLabel;
    qlNomeValor: TQRLabel;
    QRShape6: TQRShape;
    QRLabel2: TQRLabel;
    QRShape3: TQRShape;
    QRLabel1: TQRLabel;
    QRLabel3: TQRLabel;
    qsTraco: TQRShape;
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qbSumarioAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure qrCabecalhoBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
  protected
    { Resets prop of component type if referenced component deleted }
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  private
    FImprimiuCabecalho : Boolean;
    FCalculoAlimentar: TCalculoAlimentar;
    FRelConfig : TRelatorio;
    procedure SetCalculoAlimentar(const Value: TCalculoAlimentar);
    { Private declarations }
  public
    { Public declarations }
    property CalculoAlimentar : TCalculoAlimentar read FCalculoAlimentar write SetCalculoAlimentar;
    function GetIDReport : String; override;
    procedure SetRelConfig( const Value : TRelatorio ); override;
  end;

var
  fmRelNutPesoDia: TfmRelNutPesoDia;

implementation

uses DMMBoard;

{$R *.DFM}

{ TfmRelNutPesoDia }

procedure TfmRelNutPesoDia.Notification(AComponent: TComponent;
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

procedure TfmRelNutPesoDia.SetCalculoAlimentar(
  const Value: TCalculoAlimentar);
begin
  FCalculoAlimentar := Value;
  if Assigned( Value ) then
     Value.FreeNotification(self);
end;

procedure TfmRelNutPesoDia.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
var
   Tmp : TObject;
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

with dmMotherBoard do
begin

   // Pega peso corporal para calculo de NutPesoDia
   if not Assigned( CalcDieta.PesoCorporal ) then
      if caProcessador.Memoria.Acha( 'mdPeso', Tmp ) then
         TCalculoAlimentar( FCalculoAlimentar ).PesoCorporal := TMedida( Tmp );
end;

  TAtivaCalculoAlimentar( FCalculoAlimentar.Ativar ).NutrientesPorPesoDia := True;
  with FCalculoAlimentar.NutrientesPorPesoDia do
  begin
     Report.DataSet := DataSet;
     qtNutriente.DataSet := DataSet;
     qtNutriente.DataField := 'NOMENUT';
     qtTotalNutPesoDia.DataSet := DataSet;
     qtTotalNutPesoDia.DataField := 'VALORTOTPESODIA';
     qtValorTot.DataSet := DataSet;
     qtValorTot.DataField := 'VALORTOT';
     qtUnidade.DataSet := DataSet;
     qtUnidade.DataField := 'UNIDADE';
  end;

end;

procedure TfmRelNutPesoDia.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  TAtivaCalculoAlimentar( FCalculoAlimentar.Ativar ).NutrientesPorPesoDia := False;
end;

function TfmRelNutPesoDia.GetIDReport: String;
begin
   Result := '{83294A71-04B5-11D4-9DBF-000021609D7C}';
end;

procedure TfmRelNutPesoDia.qbSumarioAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if FRelConfig.NovaPagina then
     Report.NewPage;
end;

procedure TfmRelNutPesoDia.qrCabecalhoBeforePrint(Sender: TQRCustomBand;
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

procedure TfmRelNutPesoDia.SetRelConfig(const Value: TRelatorio);
begin
   if (Value <> nil) then
   begin
      FRelConfig := Value;
      FRelConfig.Report := Report;
   end;
end;

end.

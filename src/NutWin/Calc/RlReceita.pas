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




unit RlReceita;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  QREPFORM, Qrctrls, QuickRpt, jpeg, ExtCtrls, CalcAli, VisorMedida, measurement, RelConfig;

type
  TfmRelReceita = class(TFormReport)
    qrCabecalho: TQRBand;
    qbReceita: TQRBand;
    qeReceita: TQRDBRichText;
    qrCabecalho1: TQRChildBand;
    qrCabecalho2: TQRChildBand;
    qbSumario: TQRChildBand;
    qsTraco: TQRShape;
    qlTitulo: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure qrCabecalhoBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure ChildBand1AfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure ReportNeedData(Sender: TObject; var MoreData: Boolean);
  protected
    { Resets prop of component type if referenced component deleted }
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  private
    FMoreDataSimulation : Boolean;
    FImprimiuCabecalho : Boolean;
    FCalculoAlimentar: TCalculoPreparacao;
    FRelConfig : TRelatorio;
    procedure SetCalculoAlimentar(const Value: TCalculoPreparacao);
    { Private declarations }
  public
    { Public declarations }
    property CalculoAlimentar : TCalculoPreparacao read FCalculoAlimentar write SetCalculoAlimentar;
    function GetIDReport : String; override;
    procedure SetRelConfig( const Value : TRelatorio ); override;
  end;

var
  fmRelReceita: TfmRelReceita;

implementation

uses DMMBoard;

{$R *.DFM}

{ TfmRelReceita }

function TfmRelReceita.GetIDReport: String;
begin
   Result := '{C1A345C8-0645-11D4-9DBF-000021609D7C}';
end;

procedure TfmRelReceita.Notification(AComponent: TComponent;
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

procedure TfmRelReceita.SetCalculoAlimentar(
  const Value: TCalculoPreparacao);
begin
  FCalculoAlimentar := Value;
  if Assigned( Value ) then
     Value.FreeNotification(self);
end;

procedure TfmRelReceita.FormCreate(Sender: TObject);
begin
  inherited;
  with qeReceita do
  begin
     DataSet := dmMotherBoard.dsPrepReceita.DataSet;
     DataField := 'OBSERVACOES';
  end;
end;

procedure TfmRelReceita.SetRelConfig(const Value: TRelatorio);
begin
   if (Value <> nil) then
   begin
      FRelConfig := Value;
      FRelConfig.Report := Report;
   end;
end;

procedure TfmRelReceita.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  inherited;
  qcSubTitulo.Enabled := FRelConfig.MostraTitulo;
  // Define se vai haver traço no final de cada relatório
  qbSumario.Height := FRelConfig.LinhaSeparadora;
  qsTraco.Height := qbSumario.Height;
  qsTraco.Enabled := (FRelConfig.LinhaSeparadora > 0);
  FImprimiuCabecalho := False;
  FMoreDataSimulation := False;
end;

procedure TfmRelReceita.qrCabecalhoBeforePrint(Sender: TQRCustomBand;
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

procedure TfmRelReceita.ChildBand1AfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if FRelConfig.NovaPagina then
     Report.NewPage;
end;

procedure TfmRelReceita.ReportNeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  inherited;
  // Simula moredata para que o cabeçalho2 apareça
  if not FMoreDataSimulation then
  begin
     MoreData := True;
     FMoreDataSimulation := True;
  end
  else
     MoreData := False;

end;

end.

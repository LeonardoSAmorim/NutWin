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




unit RlIdentificacao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fmFormRelIndividuo, VisorMedida, VisorCal, Qrctrls, QuickRpt, jpeg,
  ExtCtrls, QRPRNTR, fmRelViewer, PRINTERS, RelConfig;

type
  TfmRelIdentificacao = class(TFormRepIndividuo)
    qbPesoEstatura: TQRBand;
    vmEstatura: TVisorMedida;
    qlEstaturaDescricao: TQRLabel;
    qlEstaturaValor: TQRLabel;
    qlEstaturaUnidade: TQRLabel;
    qlPesoDescricao: TQRLabel;
    qlPesoValor: TQRLabel;
    qlPesoUnidade: TQRLabel;
    vmPeso: TVisorMedida;
    qlNumDiasInqUnidade: TQRLabel;
    qlNumDiasInqValor: TQRLabel;
    qlNumDiasInqDescricao: TQRLabel;
    vmNumDiasInq: TVisorMedida;
    qbSumario: TQRBand;
    qsTraco: TQRShape;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ReportPreview(Sender: TObject);
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure qbSumarioAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
  protected
    { Resets prop of component type if referenced component deleted }
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  private
    { Private declarations }
     fmPreview : TRelViewer;
     FRelConfig: TRelatorio;
     procedure ConfigDefault;
  public
    { Public declarations }
    function GetIDReport : String; override;
    procedure SetVisorMedidaNumDiasInquerito( NomeMedida : String );
    procedure SetRelConfig( const Value : TRelatorio ); override;
end;

var
  fmRelIdentificacao: TfmRelIdentificacao;

implementation

{$R *.DFM}

procedure TfmRelIdentificacao.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FRelConfig then
        FRelConfig := nil;
end;

procedure TfmRelIdentificacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
   fmPreview.Free;
   Action := caFree;
end;

procedure TfmRelIdentificacao.FormCreate(Sender: TObject);
begin
  inherited;
  fmPreview := TRelViewer.Create(self);
  qbPesoEstatura.Height := 40; // para a maioria dos reports
end;

function TfmRelIdentificacao.GetIDReport: String;
begin
   Result := '{C523C5A8-04B3-11D4-9DBF-000021609D7C}';
end;

procedure TfmRelIdentificacao.SetVisorMedidaNumDiasInquerito( NomeMedida : String );
begin
   qlNumDiasInqValor.Enabled := True;
   qlNumDiasInqUnidade.Enabled := True;
   qlNumDiasInqDescricao.Enabled := True;
   vmNumDiasInq.NomeMedida := NomeMedida;
   qbPesoEstatura.Height := 80;
end;

procedure TfmRelIdentificacao.ReportPreview(Sender: TObject);
begin
  fmPreview.QRPreview.QRPrinter := TQRPrinter(Sender);
  fmPreview.ShowModal;
end;

procedure TfmRelIdentificacao.SetRelConfig(const Value: TRelatorio);
begin

   if (Value <> nil) then
   begin
      FRelConfig := Value;
      FRelConfig.Report := Report;
   end
   else
      ConfigDefault;
end;

procedure TfmRelIdentificacao.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  inherited;
  if (FRelConfig = nil) then
  begin
     ConfigDefault;
  end;

   // Define se vai haver traço no final de cada relatório
  qbSumario.Height := FRelConfig.LinhaSeparadora;
  qsTraco.Height := qbSumario.Height;
  qsTraco.Enabled := (FRelConfig.LinhaSeparadora > 0);
end;

procedure TfmRelIdentificacao.qbSumarioAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if FRelConfig.NovaPagina then
     Report.NewPage;
end;

procedure TfmRelIdentificacao.ConfigDefault;
begin
     FRelConfig := TRelatorio.Create(self);
     with FRelconfig do
     begin
        Descricao := 'Identificação';
        FormClassName := self.ClassName;
        ProcessadorClassName := '';
        Orientacao := poLandscape;
        NovaPagina := False;
        TipoIdentificacao := riNenhuma;
        IdentificacaoParaTodos := False;
        LinhaSeparadora := 0;
        Report := Report;
        MostraTitulo := True;
     end;
end;

end.

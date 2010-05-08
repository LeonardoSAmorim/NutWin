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




unit fmFormRelIndividuo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  qrepform, Measurement, VisorMedida, VisorCal, QuickRpt, Qrctrls, jpeg,
  ExtCtrls, QRPRNTR, RegConst2, RegEdit;

type
  TFormRepIndividuo = class(TFormReport)
    vcRelIndividuo: TVisorCalculo;
    qtIdentificacao: TQRBand;
    vmSexo: TVisorMedida;
    vmDataNascimento: TVisorMedida;
    vmNomeIndividuo: TVisorMedida;
    vmDataCalc: TVisorMedida;
    vmIdade: TVisorMedida;
    qlTituloIdentificacao: TQRLabel;
    qlNomeInqDescricao: TQRLabel;
    qlNomeInqValor: TQRLabel;
    qlSexoValor: TQRLabel;
    qlSexoDescricao: TQRLabel;
    qlDataCalcDescricao: TQRLabel;
    qlDataCalcValor: TQRLabel;
    qlDataNascimentoValor: TQRLabel;
    qlDataNascimentoDescricao: TQRLabel;
    qlIdadeDescricao: TQRLabel;
    qlIdadeValor: TQRLabel;
    qlIdadeUnidade: TQRLabel;
    qlDemo2: TQRLabel;
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
//!    procedure ReportPreview(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRepIndividuo: TFormRepIndividuo;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TFormRepIndividuo.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
var
   mdMed : TMedida;
begin
  inherited;
  // Se existir o calculo corrente e este usar escopo (não for preparação)
  if dmMotherBoard.PodeImprimir( dmMotherBoard.CalculoViewer.CalculoCorrente ) and
     dmMotherBoard.caProcessador.Memoria.Acha( 'mdEscopoCriado', TObject( mdMed ) ) and
     ( mdMed.AsFloat <> 0 ) then
     begin
        qlTituloIdentificacao.Enabled := True;
        qtIdentificacao.Enabled := True;
        vcRelIndividuo.Refresh;
     end
  else
     begin
        qlTituloIdentificacao.Enabled := False;
        qtIdentificacao.Enabled := False;
     end;


end;

{!procedure TFormRepIndividuo.ReportPreview(Sender: TObject);
begin
  inherited;
  if Assigned( dmMotherBoard.CurrentViewer ) and ( dmMotherBoard.CurrentViewer.QRPreview <> nil ) then
     begin
        dmMotherBoard.CurrentViewer.QRPreview.QRPrinter := TQRPrinter( Sender );
        dmMotherBoard.CurrentViewer.Show;
     end;
end; }

procedure TFormRepIndividuo.FormCreate(Sender: TObject);
var
   Valor : String;
begin
  inherited;
   if not CarregaChaveString( CFGROOT, CFGPath, CFGVersaoCalc, Valor ) then
     begin
      Valor := CFGVersaoCalcDefault;
      qlDemo2.Enabled := False;
     end;
   Valor := 'VERSÃO ' + Valor;
   qlDemo2.Caption := Valor;
end;

end.
  
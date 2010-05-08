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




unit fmFormRelMedResult;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fmFormRelIndividuo, VisorMedida, VisorCal, Qrctrls, QuickRpt, jpeg,
  ExtCtrls, Measurement;

const TAM_PAGINA = 26; // Número de linhas disponíveis do cabeçalho até o rodapé

type
  TfmRepMedResult = class(TFormRepIndividuo)
    qrMedidas: TQRSubDetail;
    qlMedidas: TQRLabel;
    qbMedidasAntrop2: TQRSubDetail;
    qlMedidaDescricao: TQRLabel;
    qlMedidaValor: TQRLabel;
    qlMedidaUnidade: TQRLabel;
    qbTituloCalcAntrop: TQRSubDetail;
    qrResultados: TQRLabel;
    qbResultados: TQRSubDetail;
    qlResultadoDescricao: TQRLabel;
    qlResultadoValor: TQRLabel;
    qlResultadoUnidade: TQRLabel;
    vcRelMedResult: TVisorCalculo;
    vmResultadoAntrop: TVisorMedida;
    vmMedidaAntrop: TVisorMedida;
    mdMedidaVazia: TMedida;
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure qbMedidasAntrop2NeedData(Sender: TObject;
      var MoreData: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure qbResultadosNeedData(Sender: TObject; var MoreData: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FNumMedidas : Integer;
    FNumResultados : Integer;
    FProcedimentos : TStringList;
    FMedidas : TStringList;
    FResultados : TStringList;
    FMedidaEstilo : TStringList;
    FResultEstilo : TStringList;
  end;

var
  fmRepMedResult: TfmRepMedResult;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRepMedResult.ReportBeforePrint(Sender: TCustomQuickRep;
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
        qrMedidas.Enabled := True;
        qbMedidasAntrop2.Enabled := True;
        qbTituloCalcAntrop.Enabled := True;
        qbResultados.Enabled := True;
//        vcRelMedResult.Refresh;
     end
  else
     begin
        qrMedidas.Enabled := False;
        qbMedidasAntrop2.Enabled := False;
        qbTituloCalcAntrop.Enabled := False;
        qbResultados.Enabled := False;
     end;

  FNumMedidas := 0;
  FNumResultados := 0;

end;

procedure TfmRepMedResult.qbMedidasAntrop2NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  inherited;
  if FNumMedidas < FMedidas.Count then
  begin
     if Assigned(FMedidas.Objects[FNumMedidas]) then
        vmMedidaAntrop.Medida := TMedida( FMedidas.Objects[FNumMedidas] )
     else
        begin
           mdMedidaVazia.Clear;
           mdMedidaVazia.Valid := True;
           vmMedidaAntrop.Medida := mdMedidaVazia;
           qlMedidaDescricao.Caption := FMedidas.Strings[FNumMedidas];
           qlMedidaValor.Caption := '';
           qlMedidaUnidade.Caption := '';
        end;
//     vmMedidaAntrop.Refresh;
     Inc(FNumMedidas);
     if ( (FNumMedidas+FNumResultados) mod TAM_PAGINA ) = 0 then
        Report.NewPage;
        MoreData := True;
  end
  else
     MoreData := False;
end;

procedure TfmRepMedResult.FormCreate(Sender: TObject);
begin
  inherited;
  FMedidas := TStringList.Create;
  FProcedimentos := TStringList.Create;
  FResultados := TStringList.Create;
  FMedidaEstilo := TStringList.Create;
  FResultEstilo := TStringList.Create;
end;

procedure TfmRepMedResult.qbResultadosNeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  inherited;
  if FNumResultados < FResultados.Count then
  begin
     if Assigned(FResultados.Objects[FNumResultados]) then
        vmREsultadoAntrop.Medida := TMedida( FResultados.Objects[FNumResultados] )
     else
        begin
           mdMedidaVazia.Clear;
           mdMedidaVazia.Valid := True;
           vmREsultadoAntrop.Medida := mdMedidaVazia;
           qlResultadoDescricao.Caption := FResultados.Strings[FNumResultados];
           qlResultadoValor.Caption := '';
           qlResultadoUnidade.Caption := '';
        end;
//     vmREsultadoAntrop.Refresh;
     Inc(FNumResultados);
     if ( (FNumMedidas+FNumResultados) mod TAM_PAGINA ) = 0 then
        Report.NewPage;
     MoreData := True;
  end
  else
     MoreData := False;
end;

procedure TfmRepMedResult.FormDestroy(Sender: TObject);
begin
  FMedidas.Free;
  FProcedimentos.Free;
  FResultados.Free;
  FResultEstilo.Free;
  FMedidaEstilo.Free;
  inherited;
end;

end.

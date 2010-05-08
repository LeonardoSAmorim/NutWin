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




unit RlItensAliEquEnergia;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  qrepform, Qrctrls, QuickRpt, jpeg, ExtCtrls, CalcAli, DBTables, Db, NutCnst,
  VisorMedida, VisorCal, RelConfig;

type
  TNotifyPesoAlimento = procedure (Sender: TObject; var Peso : Double ) of object;

  TfmRelItensAliEquEnergia = class(TFormReport)
    quRefItemsAli: TQuery;
    quRefItemsAliID_CALCALI: TStringField;
    quRefItemsAliID_REFEICAO: TStringField;
    quRefItemsAliID_ALI: TStringField;
    quRefItemsAliID_MEDIDA: TStringField;
    quRefItemsAliQUANT: TFloatField;
    quRefItemsAliPESO: TFloatField;
    quRefItemsAliFREQDIA: TFloatField;
    quRefItemsAliGUID_1: TStringField;
    quRefItemsAliID_CALCALI_1: TStringField;
    quRefItemsAliID_REFEICAO_1: TStringField;
    quRefItemsAliNOMEMED: TStringField;
    quRefItemsAliGUID: TStringField;
    quRefItemsAliIDALI: TStringField;
    quRefItemsAliNOME: TStringField;
    quRefItemsAliID_REFEICAO_2: TStringField;
    quRefItemsAliNOME_1: TStringField;
    taMedida: TTable;
    qbRefeicao: TQRGroup;
    qeRefeicao: TQRExpr;
    qlQtde: TQRLabel;
    qlMedida: TQRLabel;
    qlAlimento: TQRLabel;
    qbItemAlimentar: TQRBand;
    qlEquEnergia: TQRLabel;
    taGruCal: TTable;
    dsRefItemsAli: TDataSource;
    taAliGCal: TTable;
    taAliGCalIDALI: TStringField;
    taAliGCalIDGRUCAL: TStringField;
    taAliGCalIDMEDCAS: TStringField;
    taAliGCalQTDE: TStringField;
    taAliGCalMEDGR: TStringField;
    taAliGCalNOME: TStringField;
    taAliGCalEQUIVALENCIA: TStringField;
    quEquivalencia: TQRDBText;
    qbSumario: TQRBand;
    qeQuant: TQRExpr;
    qeMedida: TQRExpr;
    qeNome: TQRExpr;
    quRefItemsAliNOMESIMP: TStringField;
    taAliGCalSINALCAL: TStringField;
    taGruCalIDGRUCAL: TStringField;
    taGruCalNOME: TStringField;
    taGruCalCALORIAS: TFloatField;
    taGruCalREADONLY: TStringField;
    taAliGCalREADONLY: TStringField;
    taAliGCalCALORIAS: TFloatField;
    qrCabecalho: TQRBand;
    vcRelIndividuo: TVisorCalculo;
    vmNomeIndividuo: TVisorMedida;
    qlCalorias: TQRLabel;
    quTotCal: TQuery;
    quTotCalTOTCAL: TFloatField;
    dsTotCal: TDataSource;
    qrCabecalho1: TQRChildBand;
    qrCabecalho2: TQRChildBand;
    qlNomeDescricao: TQRLabel;
    qlNomeValor: TQRLabel;
    QRLabel1: TQRLabel;
    qsTraco: TQRShape;
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure qbSumarioAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure taAliGCalCalcFields(DataSet: TDataSet);
    procedure qrCabecalhoBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure qbRefeicaoBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
  protected
   { Resets prop of component type if referenced component deleted }
   procedure Notification(AComponent : TComponent; Operation : TOperation); override;

  private
    FCalculoAlimentar: TCalculoDieta;
    FImprimiuCabecalho : Boolean;
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
  fmRelItensAliEquEnergia: TfmRelItensAliEquEnergia;

implementation

uses DMMBoard;

{$R *.DFM}

{ TfmRelItensAliEquEnergia }

procedure TfmRelItensAliEquEnergia.Notification(AComponent: TComponent;
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

procedure TfmRelItensAliEquEnergia.SetCalculoAlimentar(
  const Value: TCalculoDieta);
begin
  FCalculoAlimentar := Value;
  if Assigned( Value ) then
     Value.FreeNotification(self);
end;

procedure TfmRelItensAliEquEnergia.ReportBeforePrint(
  Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
  inherited;
  qcSubTitulo.Enabled := FRelConfig.MostraTitulo;
  // Define se vai haver traço no final de cada relatório
  qbSumario.Height := FRelConfig.LinhaSeparadora;
  qsTraco.Height := qbSumario.Height;
  qsTraco.Enabled := (FRelConfig.LinhaSeparadora > 0);

  // Inversão Quant/Medida com Alimento
  //qeQuant.Left := 270;
  //qeMedida.Left := 310;
  //qeNome.Left := 9;
  //qeEquivalencia.Left := 444;
  FImprimiuCabecalho := False;
  vcRelIndividuo.Refresh;
  if not Assigned( FCalculoAlimentar ) then
     exit;
  taAliGCal.Open;
  taGruCal.Open;
  taMedida.Open;
  quRefItemsAli.ParamByName( 'ID_CALCALI' ).AsString := FCalculoAlimentar.IDCalcAli;
  quRefItemsAli.Open;
end;

function TfmRelItensAliEquEnergia.GetIDReport: String;
begin
   Result := '{83294A6E-04B5-11D4-9DBF-000021609D7C}';
end;

procedure TfmRelItensAliEquEnergia.qbSumarioAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if FRelConfig.NovaPagina then
     Report.NewPage;
end;

procedure TfmRelItensAliEquEnergia.taAliGCalCalcFields(DataSet: TDataSet);
begin
  inherited;
  dmMotherBoard.DieAlimentoCorrente.DMUmAlimento.GetEquEnergiaCalcFields(taAliGCal,quRefItemsAli.FieldByName( 'PESO' ).AsFloat  );
end;

procedure TfmRelItensAliEquEnergia.qrCabecalhoBeforePrint(
  Sender: TQRCustomBand; var PrintBand: Boolean);
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

procedure TfmRelItensAliEquEnergia.qbRefeicaoBeforePrint(
  Sender: TQRCustomBand; var PrintBand: Boolean);
var
   TotCal : integer;
begin
  inherited;
  quTotCal.ParamByName( 'ID_CALCALI' ).AsString := FCalculoAlimentar.IDCalcAli;
  quTotCal.ParamByName( 'ID_REFEICAO' ).AsString := quRefItemsAli.FieldByName('ID_REFEICAO').AsString;
  quTotCal.Open;
  TotCal := Trunc( StrToFloat(quTotCal.FieldByName('TOTCAL').AsString) );
  qlCalorias.Caption := '(' + IntToStr(TotCal) + ' kcal)';
  quTotCal.Close;
end;

procedure TfmRelItensAliEquEnergia.SetRelConfig(const Value: TRelatorio);
begin
   if (Value <> nil) then
   begin
      FRelConfig := Value;
      FRelConfig.Report := Report;
   end;
end;

end.

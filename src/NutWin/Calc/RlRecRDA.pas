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




unit RlRecRDA;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, VisorCal, quickrpt, Qrctrls, ExtCtrls, QRPRNTR, VisorMedida,qrepform,
  Measurement, jpeg, fmFormRelIndividuo, fmFormRelMedResult, Procedimento, CalcAli, NutCnst, RelConfig;

type
  TfmRelRecRDA = class(TfmRepMedResult)
    qbRecNutCabecalho: TQRSubDetail;
    qbRecNutDetalhe: TQRSubDetail;
    qlTitulo: TQRLabel;
    qlRecNutUnidade: TQRLabel;
    qlRecNutValor: TQRLabel;
    qlRecNutDescricao: TQRLabel;
    vmRecNut: TVisorMedida;
    qlSaldoPorcValor: TQRLabel;
    qlSaldoDifValor: TQRLabel;
    qlValorNut: TQRLabel;
    qlDescricao: TQRLabel;
    qlRecNut: TQRLabel;
    qlAcumulado: TQRLabel;
    qlDiferenca: TQRLabel;
    qlAdequado: TQRLabel;
    qbSumario: TQRBand;
    qsTraco: TQRShape;
    qrCabecalho: TQRBand;
    qrCabecalho1: TQRChildBand;
    qrCabecalho2: TQRChildBand;
    QRLabel1: TQRLabel;
    qlNomeDescricao: TQRLabel;
    qlNomeValor: TQRLabel;
    vmNomeIndividuo2: TVisorMedida;
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qbRecNutDetalheNeedData(Sender: TObject;
      var MoreData: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qbSumarioAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure qrCabecalhoBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
  protected
    { Resets prop of component type if referenced component deleted }
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  private
    { Private declarations }
    FImprimiuCabecalho : Boolean;
    FRelConfig : TRelatorio;
    FcxRecNut : TComponent;
    FNumNut : Integer;
    FIsRDA : Boolean;
    FRDADescricao : String;
    FCalculoAlimentar: TCalculoAlimentar;
    FOldVerTodos : Boolean;
    procedure SetCalculoAlimentar(const Value: TCalculoAlimentar);
  public
    { Public declarations }
    property CalculoAlimentar : TCalculoAlimentar read FCalculoAlimentar write SetCalculoAlimentar;
    procedure SetRelConfig( const Value : TRelatorio ); override;
  end;


implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRelRecRDA.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
//var
//   I : Integer;
begin
  inherited;
  qcSubTitulo.Enabled := FRelConfig.MostraTitulo;
  // Define se vai haver traço no final de cada relatório
  qbSumario.Height := FRelConfig.LinhaSeparadora;
  qsTraco.Height := qbSumario.Height;
  qsTraco.Enabled := (FRelConfig.LinhaSeparadora > 0);

  FImprimiuCabecalho := False;
   // Liga o ver todos os nutrientes para que os mesmos apareçam no relatório
  if Assigned( FCalculoAlimentar ) and not(FCalculoAlimentar.MostraTodosNutrientes) then
  begin
     FOldVerTodos := FCalculoAlimentar.MostraTodosNutrientes;
     FCalculoAlimentar.MostraTodosNutrientes := True;
  end;
  inherited;
  TAtivaCalculoDieta( FCalculoAlimentar.Ativar ).TotalNutrientes := True;
  // Enche lista de procedimentos de Recomendação de Nutrientes
//  dmMotherBoard.caProcessador.EncheListas( 'cxcaRecCal', FProcedimentos, FMedidas, FResultados );
  // Inicializa variáveis de RDA
//  FIsRDA := False;
  FRDADescricao := 'RDA';
  FcxRecNut := nil;
  FNumNut := 0;
  // Verifica se o procedimento checado é da RDA
//  for I := 0 to FProcedimentos.Count - 1 do
//  begin
//     if ( FProcedimentos.Objects[I] is TProcedimento ) and
//        ( TProcedimento( FProcedimentos.Objects[I] ).Estado = psChecked ) and
//        ( TProcedimento( FProcedimentos.Objects[I] ).Name = 'prRCRDA' ) then
//        begin
           // Seta variáveis do procedimento de RDA
           FIsRDA := True;
//           FRDADescricao := TProcedimento( FProcedimentos.Objects[I] ).Descricao;
//           if assigned( dmMotherBoard.ProcessadorAtual ) then
//              dmMotherBoard.caProcessador.Memoria.Acha( TCalculoAlimentar(dmMotherBoard.ProcessadorAtual).CaixaRecNut, TObject( FcxRecNut ))
//           else
              dmMotherBoard.caProcessador.Memoria.Acha( 'cxRDA', TObject( FcxRecNut ));
//        end;
//  end;
  // Se for RDA habilita bandas correspondentes
  if not FIsRDA then
     begin
        qbRecNutCabecalho.Enabled := False;
        qbRecNutCabecalho.PrintIfEmpty := False;
        qbRecNutDetalhe.Enabled := False;
        qrMedidas.Enabled := True;
        qbMedidasAntrop2.Enabled := True;
        qbResultados.Enabled := True;
        qbTituloCalcAntrop.Enabled := True;
     end
  else
     begin
        qbRecNutCabecalho.Enabled := True;
        qbRecNutCabecalho.PrintIfEmpty := True;
        qbRecNutDetalhe.Enabled := True;
        qrMedidas.Enabled := False;
        qbMedidasAntrop2.Enabled := False;
        qbResultados.Enabled := False;
        qbTituloCalcAntrop.Enabled := False;
     end;
end;

procedure TfmRelRecRDA.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  TAtivaCalculoDieta( FCalculoAlimentar.Ativar ).TotalNutrientes := False;
end;

procedure TfmRelRecRDA.qbRecNutDetalheNeedData(Sender: TObject;
  var MoreData: Boolean);
var
   MedidaValida : Boolean;
   Valor : Double;
   id : String;
begin
  inherited;
  // Se for RDA e existe caixa e nutrientes dentro desta
  if FIsRDA and Assigned( FcxRecNut ) and ( FNumNut < FcxRecNut.ComponentCount ) then
  begin
     // Pula os TMedidas vazios e invalidos
     MedidaValida := False;
     repeat

       if  ( FcxRecNut.Components[FNumNut] is TMedida ) and
           ( TMedida( FcxRecNut.Components[FNumNut] ).ValorNumerico <> '0' ) and
           ( TMedida( FcxRecNut.Components[FNumNut] ).Valornumerico <> ''  ) then
           MedidaValida := True
       else
         begin
           Inc(FNumNut);
           if ( FNumNut > ( FcxRecNut.ComponentCount - 1 ) ) then
              begin
                 MoreData := False;
                 // Restaura estado anterior
                 if Assigned( FCalculoAlimentar ) and ( FCalculoAlimentar.MostraTodosNutrientes <> FOldVerTodos ) then
                 begin
                    FCalculoAlimentar.MostraTodosNutrientes := FOldVerTodos;
                 end;
                 exit;
              end;
         end;
     until MedidaValida;
     vmRecNut.Medida := TMedida( FcxRecNut.Components[FNumNut] );

     with FCalculoAlimentar.TotalNutrientes do
     begin
        id := NameToGUID(vmRecNut.Medida.Name, 'cxRDA' );
        if DataSet.Locate( 'IDNUT', id , []) then
        begin
           qlValorNut.Caption := FormatFloat( '###0.000', DataSet.FieldByName( 'VALORTOT').AsFloat );
           Valor := ( DataSet.FieldByName( 'VALORTOT').AsFloat / vmRecNut.Medida.AsFloat ) * 100;
           qlSaldoPorcValor.Caption := FormatFloat( '###0.00%', Valor );
           Valor := ( DataSet.FieldByName( 'VALORTOT').AsFloat - vmRecNut.Medida.AsFloat );
           qlSaldoDifValor.Caption := FormatFloat( '######0.000', Valor );
        end
        else
        begin
           qlSaldoPorcValor.Caption := '----';
           qlSaldoDifValor.Caption := '----';
           qlValorNut.Caption := '----';
        end;
     end;

//     vmRecNut.Refresh;
     Inc(FNumNut);
     MoreData := True;
  end
  else
  begin
     MoreData := False;
     // Restaura estado anterior
     if Assigned( FCalculoAlimentar ) and ( FCalculoAlimentar.MostraTodosNutrientes <> FOldVerTodos ) then
     begin
        FCalculoAlimentar.MostraTodosNutrientes := FOldVerTodos;
     end;
  end;
end;

procedure TfmRelRecRDA.SetCalculoAlimentar(
  const Value: TCalculoAlimentar);
begin
  FCalculoAlimentar := Value;
end;

procedure TfmRelRecRDA.FormDestroy(Sender: TObject);
begin
  inherited;
// Isto precisa existir pra chamar o destroy do pai
end;

procedure TfmRelRecRDA.FormCreate(Sender: TObject);
begin
  inherited;
// Isto precisa existir pra chamar o create do pai
end;

procedure TfmRelRecRDA.qbSumarioAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if FRelConfig.NovaPagina then
     Report.NewPage;
end;

procedure TfmRelRecRDA.SetRelConfig(const Value: TRelatorio);
begin
   if (Value <> nil) then
   begin
      FRelConfig := Value;
      FRelConfig.Report := Report;
   end;
end;

procedure TfmRelRecRDA.Notification(AComponent: TComponent;
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

procedure TfmRelRecRDA.qrCabecalhoBeforePrint(Sender: TQRCustomBand;
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
                         qtIdentificacao.Enabled := True;
                     end
                     else
                     begin
                         qrCabecalho1.Enabled := True;
                         qtIdentificacao.Enabled := False;
                     end;
                     FImprimiuCabecalho := True;
                     end;
     riSimplificada: begin
                         qrCabecalho1.Enabled := True;
                         qtIdentificacao.Enabled := False;
                     end;
     riNenhuma:      begin
                         qrCabecalho1.Enabled := False;
                         qtIdentificacao.Enabled := False;
                     end;
   end;
end;

end.

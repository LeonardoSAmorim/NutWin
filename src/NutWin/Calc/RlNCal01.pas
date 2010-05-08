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




unit RlNCal01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, VisorCal, quickrpt, Qrctrls, ExtCtrls, QRPRNTR, VisorMedida,qrepform,
  Measurement, jpeg, fmFormRelIndividuo, fmFormRelMedResult, Procedimento, CalcAli, RelConfig, PRINTERS;

type
  TfmRelNecesCal01 = class(TfmRepMedResult)
    qbRecNutCabecalho: TQRSubDetail;
    qbRecNutDetalhe: TQRSubDetail;
    qlTitulo: TQRLabel;
    qlRecNutUnidade: TQRLabel;
    qlRecNutValor: TQRLabel;
    qlRecNutDescricao: TQRLabel;
    vmRecNut: TVisorMedida;
    qbSumario: TQRBand;
    qrCabecalho: TQRBand;
    qrCabecalho1: TQRChildBand;
    qrCabecalho2: TQRChildBand;
    qsTraco: TQRShape;
    qlNomeDescricao: TQRLabel;
    qlNomeValor: TQRLabel;
    vmNomeIndividuo2: TVisorMedida;
    QRLabel1: TQRLabel;
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
  public
    { Public declarations }
    procedure SetRelConfig( const Value : TRelatorio ); override;
  end;


implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRelNecesCal01.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
var
   I : Integer;
begin
  inherited;
  qcSubTitulo.Enabled := FRelConfig.MostraTitulo;
  // Define se vai haver traço no final de cada relatório
  qbSumario.Height := FRelConfig.LinhaSeparadora;
  qsTraco.Height := qbSumario.Height;
  qsTraco.Enabled := (FRelConfig.LinhaSeparadora > 0);

  FImprimiuCabecalho := False;
  // Enche lista de procedimentos de Recomendação de Nutrientes
  dmMotherBoard.caProcessador.EncheListas( 'cxcaRecCal', FProcedimentos, FMedidas, FResultados );
  // Inicializa variáveis de RDA
  FIsRDA := False;
  FRDADescricao := '';
  FcxRecNut := nil;
  FNumNut := 0;
  // Verifica se o procedimento checado é da RDA
  for I := 0 to FProcedimentos.Count - 1 do
  begin
     if ( FProcedimentos.Objects[I] is TProcedimento ) and
        ( TProcedimento( FProcedimentos.Objects[I] ).Estado = psChecked ) and
        ( TProcedimento( FProcedimentos.Objects[I] ).Name = 'prRCRDA' ) then
        begin
           // Seta variáveis do procedimento de RDA
           FIsRDA := True;
           FRDADescricao := TProcedimento( FProcedimentos.Objects[I] ).Descricao;
           if assigned( dmMotherBoard.ProcessadorAtual ) then
              dmMotherBoard.caProcessador.Memoria.Acha( TCalculoAlimentar(dmMotherBoard.ProcessadorAtual).CaixaRecNut, TObject( FcxRecNut ))
           else
              dmMotherBoard.caProcessador.Memoria.Acha( 'cxRecNut', TObject( FcxRecNut ));
        end;
  end;
  // Se for RDA habilita bandas correspondentes
  if not FIsRDA then
     begin
        qbRecNutCabecalho.Enabled := False;
        qbRecNutCabecalho.PrintIfEmpty := False;
        qbRecNutDetalhe.Enabled := False;
     end
  else
     begin
        qbRecNutCabecalho.Enabled := True;
        qbRecNutCabecalho.PrintIfEmpty := True;
        qbRecNutDetalhe.Enabled := True;
     end;
end;

procedure TfmRelNecesCal01.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfmRelNecesCal01.qbRecNutDetalheNeedData(Sender: TObject;
  var MoreData: Boolean);
var
   MedidaValida : Boolean;
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
                 exit;
              end;
         end;
     until MedidaValida;
     vmRecNut.Medida := TMedida( FcxRecNut.Components[FNumNut] );
//     vmRecNut.Refresh;
     Inc(FNumNut);
     MoreData := True;
  end
  else
     MoreData := False;
end;

procedure TfmRelNecesCal01.FormDestroy(Sender: TObject);
begin
  inherited;
// Isto precisa existir pra chamar o destroy do pai
end;

procedure TfmRelNecesCal01.FormCreate(Sender: TObject);
begin
// Isto precisa existir pra chamar o create do pai
  inherited;
  // Cria uma configuração default
  FRelConfig := TRelatorio.Create(self);
  with FRelConfig do
  begin
     Descricao := 'Recomendação Nutricional pela RDA';
     FormClassName := self.ClassName;
     ProcessadorClassName := '';
     Orientacao := poPortrait;
     NovaPagina := False;
     TipoIdentificacao := riNenhuma;
     IdentificacaoParaTodos := False;
     LinhaSeparadora := 0;
     Report := self.Report;
  end;
end;

procedure TfmRelNecesCal01.qbSumarioAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if FRelConfig.NovaPagina then
     Report.NewPage;
end;

procedure TfmRelNecesCal01.Notification(AComponent: TComponent;
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

procedure TfmRelNecesCal01.SetRelConfig(const Value: TRelatorio);
begin
   if (Value <> nil) then
   begin
      FRelConfig := Value;
      FRelConfig.Report := Report;
   end;
end;

procedure TfmRelNecesCal01.qrCabecalhoBeforePrint(Sender: TQRCustomBand;
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

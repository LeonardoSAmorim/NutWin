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




unit RlEquEnergia;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  QREPFORM, Qrctrls, QuickRpt, jpeg, ExtCtrls, CalcAli, Db, DBTables,
  VisorMedida, VisorCal, RelConfig;

type
  TfmRelEquEnergia = class(TFormReport)
    qbItemAlimentar: TQRBand;
    qlAlimento: TQRLabel;
    qlValorGr: TQRLabel;
    qlMedCas: TQRLabel;
    QRSubDetail1: TQRSubDetail;
    qlTitulo: TQRLabel;
    qtGrupoEnergia: TQRDBText;
    qtEnergiaGrupo: TQRDBText;
    qsAVontade: TQRBand;
    qtQtde: TQRDBText;
    qtAlimento: TQRDBText;
    qtMedCas: TQRDBText;
    qtMedGr: TQRDBText;
    qrCabecalho: TQRBand;
    qmAVontade: TQRMemo;
    qrCabecalho1: TQRChildBand;
    qrCabecalho2: TQRChildBand;
    QRLabel1: TQRLabel;
    qlNomeDescricao: TQRLabel;
    qlNomeValor: TQRLabel;
    qbSumario: TQRChildBand;
    qsTraco: TQRShape;
    vcRelIndividuo: TVisorCalculo;
    vmNomeIndividuo: TVisorMedida;
    QRShape1: TQRShape;
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QRSubDetail1AfterPrint(Sender: TQRCustomBand; BandPrinted: Boolean);
    procedure QRSubDetail1NeedData(Sender: TObject; var MoreData: Boolean);
    procedure ReportNeedData(Sender: TObject; var MoreData: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure qrCabecalhoBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure qbSumarioAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
  protected
    { Resets prop of component type if referenced component deleted }
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  private
    FImprimiuCabecalho : Boolean;
    FCalculoAlimentar: TCalculoDieta;
    ListaGruposPrinted : TStringList;
    FRelConfig : TRelatorio;
    procedure SetCalculoAlimentar(const Value: TCalculoDieta);
    function TemGrupoEquivalente : Boolean;
    { Private declarations }
  public
    { Public declarations }
    property CalculoAlimentar : TCalculoDieta read FCalculoAlimentar write SetCalculoAlimentar;
    function GetIDReport : String; override;
    function TemRelatoriosEquivalentesEnergia : Boolean;
    procedure SetRelConfig( const Value : TRelatorio ); override;
  end;

var
  fmRelEquEnergia: TfmRelEquEnergia;

implementation

uses DMMBoard;

{$R *.DFM}

{ TfmRelEquEnergia }

procedure TfmRelEquEnergia.Notification(AComponent: TComponent;
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

procedure TfmRelEquEnergia.SetCalculoAlimentar(const Value: TCalculoDieta);
begin
  FCalculoAlimentar := Value;
  if Assigned( Value ) then
     Value.FreeNotification(self);
end;

procedure TfmRelEquEnergia.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  inherited;
  qcSubTitulo.Enabled := False;
  // Define se vai haver traço no final de cada relatório
  qbSumario.Height := FRelConfig.LinhaSeparadora;
  qsTraco.Height := qbSumario.Height;
  qsTraco.Enabled := (FRelConfig.LinhaSeparadora > 0);

  FImprimiuCabecalho := False;
  vcRelIndividuo.Refresh;
  if not Assigned( FCalculoAlimentar ) then
     exit;
  ListaGruposPrinted.Clear;
  FCalculoAlimentar.RefeicoesEscolhidas.DataSet.First;
  FCalculoAlimentar.ItemsAlimentar.DataSet.First;
  dmMotherBoard.EquivalenteEnergia.Ativar := True;

  with dmMotherBoard.EquivalenteEnergia.ListaDeGruposEquivalentes do
  begin
        qtGrupoEnergia.DataSet := DataSet;
        qtGrupoEnergia.DataField := 'NOME';
        qtEnergiaGrupo.DataSet := DataSet;
        qtEnergiaGrupo.DataField := 'SINALCAL';

  end;

  with dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes do
  begin

        qtAlimento.DataSet := DataSet;
        qtAlimento.DataField := 'EENOME';
        qtQtde.DataSet := DataSet;
        qtQtde.DataField := 'EEQTDE';
        qtMedCas.DataSet := DataSet;
        qtMedCas.DataField := 'EEMEDIDA';
        qtMedGr.DataSet := DataSet;
        qtMedGr.DataField := 'EEMEDGR';

  end;

end;

procedure TfmRelEquEnergia.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  // nunca entra aqui, porque ninguem chama close
end;

procedure TfmRelEquEnergia.QRSubDetail1AfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.Next;
end;

procedure TfmRelEquEnergia.QRSubDetail1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  inherited;
  if not dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.Eof then
     MoreData := True
  else
     MoreData := False;
end;

procedure TfmRelEquEnergia.ReportNeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  inherited;
        if TemGrupoEquivalente then
        begin
           MoreData := True;
        end
        else
           MoreData := False;
end;

function TfmRelEquEnergia.TemGrupoEquivalente: Boolean;
var
   strAVontade, Separador : string;
begin
   Result := True;
   while Result do
   begin
      // Para sincronizar itensalimentares com gruposalimentares com equivalentes
      dmMotherBoard.EquivalenteEnergia.Alimento.DMUmAlimento.taAlimento.Locate( 'IDALI',
             FCalculoAlimentar.ItemsAlimentar.DataSet.FieldByName( 'ID_ALI' ).AsString,[] );
      // Se tem equivalentes e ainda não foi impresso
      if not dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.Eof
         and (ListaGruposPrinted.IndexOf(dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.FieldByName( 'IDGRUCAL' ).AsString) < 0) then
         begin
            // Se o alimento corrente for de qualquer outro grupo que não o de A Vontade
            if (dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.FieldByName( 'IDGRUCAL' ).AsString <> '{88DD9371-66F8-11D1-A6A0-008048B86BEE}') then
            begin
                ListaGruposPrinted.Add(dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.FieldByName( 'IDGRUCAL' ).AsString);
                Result := True;
                exit;
            end
            // É do grupo à vontade e o Sumário está vazio
            else if ( qmAVontade.Lines.Count <= 0 ) then
                begin
                   qmAVontade.Lines.Add('');
                   qmAVontade.Lines.Add('Estes alimentos podem ser ingeridos à vontade:');
                   qmAVontade.Lines.Add('');
                   // Preenche o sumário com os alimentos do grupo À Vontade
                   strAVontade := '';
                   dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.First;
                   while (not dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.Eof) do
                   begin
                       if ( strAVontade = '' ) then
                           Separador := ''
                       else
                           Separador := ', ';
                       strAVontade := strAVontade + Separador + dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.FieldByName( 'EENOME' ).AsString;
                       dmMotherBoard.EquivalenteEnergia.ListaDeAlimentosEquivalentes.DataSet.Next;
                   end;
                   qmAVontade.Lines.Add( strAVontade + '.');
                   qmAVontade.Lines.Add('');
                end;
         end;
      // vai para próximo itemalimentar
      FCalculoAlimentar.ItemsAlimentar.DataSet.Next;
      // acabaram os items da refeicao corrente
      if FCalculoAlimentar.ItemsAlimentar.DataSet.Eof then
         begin
            // passa para outra refeicao
            FCalculoAlimentar.RefeicoesEscolhidas.DataSet.Next;
            // não tem mais refeicoes
            if FCalculoAlimentar.RefeicoesEscolhidas.DataSet.Eof then
            begin
               Result := False;
               dmMotherBoard.EquivalenteEnergia.Ativar := False;
            end;
         end;
   end;
end;

procedure TfmRelEquEnergia.FormCreate(Sender: TObject);
begin
  inherited;
  ListaGruposPrinted := TStringList.Create;
end;

function TfmRelEquEnergia.GetIDReport: String;
begin
   Result := '{83294A69-04B5-11D4-9DBF-000021609D7C}';
end;

procedure TfmRelEquEnergia.qrCabecalhoBeforePrint(Sender: TQRCustomBand;
 var PrintBand: Boolean);
begin
  inherited;

  // É sempre nenhuma
  FRelConfig.TipoIdentificacao := riNenhuma;

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

// Só deve ser usado fora do relatório
function TfmRelEquEnergia.TemRelatoriosEquivalentesEnergia: Boolean;
begin
   // Alguem está usando e não pode
   if dmMotherBoard.EquivalenteEnergia.Ativar then
   begin
      Result := False;
      exit;
   end;
   // Preparação
   ListaGruposPrinted.Clear;
   FCalculoAlimentar.RefeicoesEscolhidas.DataSet.First;
   FCalculoAlimentar.ItemsAlimentar.DataSet.First;
   dmMotherBoard.EquivalenteEnergia.Ativar := True;
   // Verificação
   Result := TemGrupoEquivalente;
   // Termino
   dmMotherBoard.EquivalenteEnergia.Ativar := False;
   ListaGruposPrinted.Clear;

end;

procedure TfmRelEquEnergia.FormDestroy(Sender: TObject);
begin
  inherited;
  ListaGruposPrinted.Free;
end;

procedure TfmRelEquEnergia.SetRelConfig(const Value: TRelatorio);
begin
   if (Value <> nil) then
   begin
      FRelConfig := Value;
      FRelConfig.Report := Report;
   end;
end;

procedure TfmRelEquEnergia.qbSumarioAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if FRelConfig.NovaPagina then
     Report.NewPage;
end;

end.

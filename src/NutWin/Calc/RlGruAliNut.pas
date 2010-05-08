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




unit RlGruAliNut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  qrepform, Qrctrls, QuickRpt, jpeg, ExtCtrls, Db, DBTables, CalcAli,
  VisorMedida, VisorCal, RelConfig;

type
  TfmRelGruAliNut = class(TFormReport)
    QRSubDetail1: TQRSubDetail;
    qtAlimento: TQRDBText;
    qrCabecalho: TQRBand;
    vcRelIndividuo: TVisorCalculo;
    vmNomeIndividuo: TVisorMedida;
    qlNut1Valor: TQRLabel;
    qlNut2Valor: TQRLabel;
    qlNut3Valor: TQRLabel;
    qlNut4Valor: TQRLabel;
    qlNut5Valor: TQRLabel;
    qlNut6Valor: TQRLabel;
    qlNut7Valor: TQRLabel;
    qlNut8Valor: TQRLabel;
    qlNut9Valor: TQRLabel;
    qlNut10Valor: TQRLabel;
    qlNut11Valor: TQRLabel;
    qlNut12Valor: TQRLabel;
    qrCabecalho1: TQRChildBand;
    qrCabecalho2: TQRChildBand;
    Cabecalho3: TQRChildBand;
    qlNomeDescricao: TQRLabel;
    qlNomeValor: TQRLabel;
    QRLabel2: TQRLabel;
    qlAlimento: TQRLabel;
    qlNut1: TQRLabel;
    qlNut2: TQRLabel;
    qlNut3: TQRLabel;
    qlNut4: TQRLabel;
    qlNut5: TQRLabel;
    qlNut6: TQRLabel;
    qlNut7: TQRLabel;
    qlNut8: TQRLabel;
    qlNut9: TQRLabel;
    qlNut10: TQRLabel;
    qlNut11: TQRLabel;
    qlNut12: TQRLabel;
    qlNutContEsq: TQRLabel;
    qlNutContDir: TQRLabel;
    qbSumario: TQRBand;
    qsTraco: TQRShape;
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure ReportNeedData(Sender: TObject; var MoreData: Boolean);
    procedure QRSubDetail1NeedData(Sender: TObject; var MoreData: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure QRSubDetail1AfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure qrCabecalhoBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qbSumarioAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
  protected
    { Resets prop of component type if referenced component deleted }
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  private
    { Private declarations }
    FImprimiuCabecalho : Boolean;
    FCalculoAlimentar: TCalculoAlimentar;
    CamposNut : TStringList;
    EndOfCamposNut : Boolean;
    CamposNutInicio : Integer;
    FRelConfig : TRelatorio;
    procedure SetCalculoAlimentar(const Value: TCalculoAlimentar);
    procedure SetCamposNut;
  public
    { Public declarations }
    property CalculoAlimentar : TCalculoAlimentar read FCalculoAlimentar write SetCalculoAlimentar;
    function GetIDReport : String; override;
    procedure SetRelConfig( const Value : TRelatorio ); override;
  end;

var
  fmRelGruAliNut: TfmRelGruAliNut;

implementation

{$R *.DFM}

{ TfmRelGruAliNut }

procedure TfmRelGruAliNut.Notification(AComponent: TComponent;
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

procedure TfmRelGruAliNut.SetCalculoAlimentar(
  const Value: TCalculoAlimentar);
begin
  FCalculoAlimentar := Value;
  if Assigned( Value ) then
     Value.FreeNotification(self);
end;

procedure TfmRelGruAliNut.SetCamposNut;
begin
  // Seta os nomes dos nutrientes nas colunas do relatório
  with FCalculoAlimentar.GrupoAlimentarPorNutriente do
  begin
   qlNut1.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut1Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut1.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut1Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut2.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut2Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut2.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut2Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut3.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut3Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
      begin
          qlNut3.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut3Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
      end;
   qlNut4.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut4Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut4.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut4Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut5.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut5Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut5.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut5Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut6.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut6Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
      begin
          qlNut6.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut6Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
      end;
   qlNut7.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut7Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut7.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut7Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut8.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut8Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut8.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut8Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut9.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut9Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
      begin
          qlNut9.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut9Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
      end;
   qlNut10.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut10Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut10.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut10Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut11.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut11Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut11.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut11Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut12.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut12Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
      begin
          qlNut12.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut12Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
      end;
  // Se o início dos campos de nutrientes for maior
  // que o total de nutrientes
  if CamposNutInicio > ( CamposNut.Count - 1 ) then
  begin
     // Seta o fim da lista
     EndOfCamposNut := True;
     // Não indicar que as colunas continuam
     qlNutContDir.Enabled := False;
  end
  else // ainda existem colunas
     // Mostras indicador quer existem mais colunas (>>>)
     qlNutContDir.Enabled := True;
  end;
end;

procedure TfmRelGruAliNut.ReportBeforePrint(Sender: TCustomQuickRep;
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
  // Prepara setas que indicam se há mais colunas
  // a serem impressas
  qlNutContEsq.Enabled := False;
  qlNutContDir.Enabled := False;
  // Indica se a primeira página foi impressa
  FImprimiuCabecalho := False;
  // Atualiza os componentes TMedida do relatório
  vcRelIndividuo.Refresh;
  // Não monta relatório se não tiver processador associado
  if not Assigned( FCalculoAlimentar ) then
     exit;
  // Ativa (calcula) o cálculo Alimento por Nutriente
  // pocisionando, os datasets relacionados, no inicio
  TAtivaCalculoAlimentar( FCalculoAlimentar.Ativar ).GrupoAlimentarPorNutriente := True;
  FCalculoAlimentar.GrupoAlimentarPorNutriente.DataSet.First;
  // Este é o dataset principal
  with FCalculoAlimentar.GrupoAlimentarPorNutriente do
  begin
     // seta o dataset dos campos da linha de detalhe
     qtAlimento.DataSet := DataSet;
     qtAlimento.DataField := 'NOMEGRU';
     // refresh do dataset
     DataSet.Close;
     DataSet.Open;
     // Lista de nutrientes que viraram colunas
     CamposNut.Clear;
     // Define que chegou ao final da lista de campos de nutrientes
     EndOfCamposNut := True;
     // Índice que indicará qual é o nutriente da lista que será a
     // primeira coluna da página corrente
     CamposNutInicio := 0;
     // Enche a lista de nurientes a partir do dataset
     For I := 0 to DataSet.FieldList.Count - 1 do
        if ( DataSet.FindField( 'NUT' + IntToStr( I ) ) ) <> nil then
           CamposNut.AddObject( ( DataSet.FindField( 'NUT' + IntToStr( I ) ) ).DisplayLabel, TObject( ( DataSet.FindField( 'NUT' + IntToStr( I ) ) ) ) );
     // Se existe nutrientes na lista
     // marca como não estando no final
     if CamposNut.Count > 0 then
        EndOfCamposNut := False;
     // Seta os nutrientes da lista à linha de cabeçalho e detalhe
     SetCamposNut;
  end;
end;

procedure TfmRelGruAliNut.ReportNeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  inherited;
  // Se houver grupo corrente, sinalizar que existem mais dados
  if not (FCalculoAlimentar.GrupoAlimentarPorNutriente.DataSet.Eof) then
     MoreData := True
  else  // Verificar se há mais colunas de nutrientes pra imprimir
     begin
        // Se não chegou ao final da lista de nutrientes
        if not EndOfCamposNut then
        begin
           // Volta para o início do datasets
           FCalculoAlimentar.GrupoAlimentarPorNutriente.DataSet.First;
           // Mostra o indicador de que já foram
           // impressos as colunas anteriores (<<<)
           qlNutContEsq.Enabled := True;
           // Seta as novas colunas nos contros do relatório
           SetCamposNut;
           // Serve para imprimir novamente o cabeçalho das colunas
           Report.NewColumn;
           // Indica que existem mais dados
           MoreData := True;
        end
        else // acabaram os nutrientes da lista
        begin
           // Desativa dataset principal
           TAtivaCalculoAlimentar( FCalculoAlimentar.Ativar ).GrupoAlimentarPorNutriente := False;
           // Não existem mais dados
           MoreData := False;
        end;
     end;
end;

procedure TfmRelGruAliNut.QRSubDetail1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  inherited;
  // Seta o valor dos nutrientes correntes nas suas colunas
  if not FCalculoAlimentar.GrupoAlimentarPorNutriente.DataSet.Eof then
    begin
     qlNut1Valor.Caption := TField( CamposNut.Objects[qlNut1Valor.Tag] ).AsString;
     qlNut2Valor.Caption := TField( CamposNut.Objects[qlNut2Valor.Tag] ).AsString;
     qlNut3Valor.Caption := TField( CamposNut.Objects[qlNut3Valor.Tag] ).AsString;
     qlNut4Valor.Caption := TField( CamposNut.Objects[qlNut4Valor.Tag] ).AsString;
     qlNut5Valor.Caption := TField( CamposNut.Objects[qlNut5Valor.Tag] ).AsString;
     qlNut6Valor.Caption := TField( CamposNut.Objects[qlNut6Valor.Tag] ).AsString;
     qlNut7Valor.Caption := TField( CamposNut.Objects[qlNut7Valor.Tag] ).AsString;
     qlNut8Valor.Caption := TField( CamposNut.Objects[qlNut8Valor.Tag] ).AsString;
     qlNut9Valor.Caption := TField( CamposNut.Objects[qlNut9Valor.Tag] ).AsString;
     qlNut10Valor.Caption := TField( CamposNut.Objects[qlNut10Valor.Tag] ).AsString;
     qlNut11Valor.Caption := TField( CamposNut.Objects[qlNut11Valor.Tag] ).AsString;
     qlNut12Valor.Caption := TField( CamposNut.Objects[qlNut12Valor.Tag] ).AsString;
     MoreData := True;
    end
  else
     MoreData := False;
end;

procedure TfmRelGruAliNut.FormCreate(Sender: TObject);
begin
  inherited;
  // Cria lista de nutrientes
  CamposNut := TStringList.Create;
end;

procedure TfmRelGruAliNut.QRSubDetail1AfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  // Vai para o próximo grupo
  FCalculoAlimentar.GrupoAlimentarPorNutriente.DataSet.Next;
end;

function TfmRelGruAliNut.GetIDReport: String;
begin
   Result := '{83294A6C-04B5-11D4-9DBF-000021609D7C}';
end;

procedure TfmRelGruAliNut.qrCabecalhoBeforePrint(Sender: TQRCustomBand;
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

procedure TfmRelGruAliNut.FormDestroy(Sender: TObject);
begin
  inherited;
  // Libera lista de nutientes
  CamposNut.Free;
end;

procedure TfmRelGruAliNut.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfmRelGruAliNut.qbSumarioAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if FRelConfig.NovaPagina then
     Report.NewPage;
end;

procedure TfmRelGruAliNut.SetRelConfig(const Value: TRelatorio);
begin
   if (Value <> nil) then
   begin
      FRelConfig := Value;
      FRelConfig.Report := Report;
   end;
end;

end.

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




unit RlAliNut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  QREPFORM, Qrctrls, QuickRpt, jpeg, ExtCtrls, Db, DBTables, CalcAli,
  VisorMedida, VisorCal, NutCnst, RelConfig;

type
  TfmRelAliNutr = class(TFormReport)
    QRSubDetail1: TQRSubDetail;
    qtAlimento: TQRDBText;
    qtPeso: TQRDBText;
    qtNut1: TQRDBText;
    qtNut2: TQRDBText;
    qtNut3: TQRDBText;
    qlNut1Valor: TQRLabel;
    qlNut2Valor: TQRLabel;
    qlNut3Valor: TQRLabel;
    qrCabecalho: TQRBand;
    vcRelIndividuo: TVisorCalculo;
    qbItemAlimentar: TQRBand;
    qtRefeicao: TQRDBText;
    GroupFooterBand1: TQRBand;
    qlTotRef: TQRLabel;
    qlTotNut1: TQRLabel;
    qlTotNut2: TQRLabel;
    qlTotNut3: TQRLabel;
    qtNut7: TQRDBText;
    qtNut8: TQRDBText;
    qtNut9: TQRDBText;
    qtNut10: TQRDBText;
    qtNut11: TQRDBText;
    qtNut12: TQRDBText;
    qlNut4Valor: TQRLabel;
    qlNut5Valor: TQRLabel;
    qlNut6Valor: TQRLabel;
    qlNut7Valor: TQRLabel;
    qlNut8Valor: TQRLabel;
    qlNut9Valor: TQRLabel;
    qlNut10Valor: TQRLabel;
    qlNut11Valor: TQRLabel;
    qlNut12Valor: TQRLabel;
    qlTotNut5: TQRLabel;
    qlTotNut4: TQRLabel;
    qlTotNut6: TQRLabel;
    qlTotNut7: TQRLabel;
    qlTotNut8: TQRLabel;
    qlTotNut9: TQRLabel;
    qlTotNut10: TQRLabel;
    qlTotNut11: TQRLabel;
    qlTotNut12: TQRLabel;
    qtNut4: TQRDBText;
    qtNut5: TQRDBText;
    qtNut6: TQRDBText;
    qrCabecalho1: TQRChildBand;
    qrCabecalho2: TQRChildBand;
    qrCabecalho3: TQRChildBand;
    qrCabecalho4: TQRChildBand;
    qlRefeicaoCont: TQRLabel;
    qlCabecAlimento: TQRLabel;
    qlPeso: TQRLabel;
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
    qlTituloCalculo: TQRLabel;
    vmNomeIndividuo: TVisorMedida;
    qlNomeDescricao: TQRLabel;
    qlNomeValor: TQRLabel;
    qlNutContDir: TQRLabel;
    qlNutContEsq: TQRLabel;
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
    procedure GroupFooterBand1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure GroupFooterBand1AfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
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
    TotPeso : Double;
    TotNut1, TotNut2, TotNut3 : Double;
    TotNut4, TotNut5, TotNut6 : Double;
    TotNut7, TotNut8, TotNut9 : Double;
    TotNut10, TotNut11, TotNut12 : Double;
    FRelConfig: TRelatorio;
    procedure SetCalculoAlimentar(const Value: TCalculoAlimentar);
    procedure SetCamposNut;
  public
    { Public declarations }
    property CalculoAlimentar : TCalculoAlimentar read FCalculoAlimentar write SetCalculoAlimentar;
    function GetIDReport : String; override;
    procedure SetRelConfig( const Value : TRelatorio ); override;
  end;

var
  fmRelAliNutr: TfmRelAliNutr;

implementation

{$R *.DFM}

{ TfmRelAliNut }

procedure TfmRelAliNutr.Notification(AComponent: TComponent;
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

procedure TfmRelAliNutr.SetCalculoAlimentar(const Value: TCalculoAlimentar);
begin
  FCalculoAlimentar := Value;
  if Assigned( Value ) then
     Value.FreeNotification(self);
end;

procedure TfmRelAliNutr.ReportBeforePrint(Sender: TCustomQuickRep;
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
  TAtivaCalculoAlimentar( FCalculoAlimentar.Ativar ).AlimentoPorNutriente := True;
  FCalculoAlimentar.RefeicoesEscolhidas.DataSet.First;
  FCalculoAlimentar.AlimentoPorNutriente.DataSet.First;
  // Seta os datasets do relatório com os do processador
  qtRefeicao.DataSet := FCalculoAlimentar.RefeicoesEscolhidas.DataSet;
  qtRefeicao.DataField := 'NOMEREF';
  // Guarda o nome da refeição no label abaixo ***
  qlRefeicaoCont.Caption := qtRefeicao.DataSet.FieldbyName(qtRefeicao.DataField).AsString + ' (continuação)';
  // Este é o dataset principal
  with FCalculoAlimentar.AlimentoPorNutriente do
  begin
     // seta o dataset dos campos da linha de detalhe
     qtAlimento.DataSet := DataSet;
     qtAlimento.DataField := 'NOMEALI';
     qtPeso.DataSet := DataSet;
     qtPeso.DataField := 'PESO';
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

procedure TfmRelAliNutr.ReportNeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  inherited;
  // Se houver refeição corrente, sinalizar que existem mais dados
  if not (FCalculoAlimentar.RefeicoesEscolhidas.DataSet.Eof) then
     begin
        MoreData := True;
     end
  else // Verificar se há mais colunas de nutrientes pra imprimir
     begin
        // Se não chegou ao final da lista de nutrientes
        if not EndOfCamposNut then
        begin
           // Volta para o início dos datasets
           FCalculoAlimentar.RefeicoesEscolhidas.DataSet.First;
           FCalculoAlimentar.AlimentoPorNutriente.DataSet.First;
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
           TAtivaCalculoAlimentar( FCalculoAlimentar.Ativar ).AlimentoPorNutriente := False;
           // Não existem mais dados
           MoreData := False;
        end;
     end;
end;

procedure TfmRelAliNutr.QRSubDetail1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  inherited;
  // Seta o valor dos nutrientes correntes nas suas colunas
  if not FCalculoAlimentar.AlimentoPorNutriente.DataSet.Eof then
    begin
     TotPeso := TotPeso + FCalculoAlimentar.AlimentoPorNutriente.DataSet.FieldByName( 'PESO' ).AsFloat;
     if TField( CamposNut.Objects[qlNut1Valor.Tag] ).AsString <> '' then
     begin
        qlNut1Valor.Caption := TField( CamposNut.Objects[qlNut1Valor.Tag] ).AsString;
        TotNut1 := TotNut1 + TField( CamposNut.Objects[qlNut1Valor.Tag] ).AsFloat;
     end
     else
        qlNut1Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut2Valor.Tag] ).AsString <> '' then
     begin
        qlNut2Valor.Caption := TField( CamposNut.Objects[qlNut2Valor.Tag] ).AsString;
        TotNut2 := TotNut2 + TField( CamposNut.Objects[qlNut2Valor.Tag] ).AsFloat;
     end
     else
        qlNut2Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut3Valor.Tag] ).AsString <> '' then
     begin
        qlNut3Valor.Caption := TField( CamposNut.Objects[qlNut3Valor.Tag] ).AsString;
        TotNut3 := TotNut3 + TField( CamposNut.Objects[qlNut3Valor.Tag] ).AsFloat;
     end
     else
        qlNut3Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut4Valor.Tag] ).AsString <> '' then
     begin
        qlNut4Valor.Caption := TField( CamposNut.Objects[qlNut4Valor.Tag] ).AsString;
        TotNut4 := TotNut4 + TField( CamposNut.Objects[qlNut4Valor.Tag] ).AsFloat;
     end
     else
        qlNut4Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut5Valor.Tag] ).AsString <> '' then
     begin
        qlNut5Valor.Caption := TField( CamposNut.Objects[qlNut5Valor.Tag] ).AsString;
        TotNut5 := TotNut5 + TField( CamposNut.Objects[qlNut5Valor.Tag] ).AsFloat;
     end
     else
        qlNut5Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut6Valor.Tag] ).AsString <> '' then
     begin
        qlNut6Valor.Caption := TField( CamposNut.Objects[qlNut6Valor.Tag] ).AsString;
        TotNut6 := TotNut6 + TField( CamposNut.Objects[qlNut6Valor.Tag] ).AsFloat;
     end
     else
        qlNut6Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut7Valor.Tag] ).AsString <> '' then
     begin
        qlNut7Valor.Caption := TField( CamposNut.Objects[qlNut7Valor.Tag] ).AsString;
        TotNut7 := TotNut7 + TField( CamposNut.Objects[qlNut7Valor.Tag] ).AsFloat;
     end
     else
        qlNut7Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut8Valor.Tag] ).AsString <> '' then
     begin
        qlNut8Valor.Caption := TField( CamposNut.Objects[qlNut8Valor.Tag] ).AsString;
        TotNut8 := TotNut8 + TField( CamposNut.Objects[qlNut8Valor.Tag] ).AsFloat;
     end
     else
        qlNut8Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut9Valor.Tag] ).AsString <> '' then
     begin
        qlNut9Valor.Caption := TField( CamposNut.Objects[qlNut9Valor.Tag] ).AsString;
        TotNut9 := TotNut9 + TField( CamposNut.Objects[qlNut9Valor.Tag] ).AsFloat;
     end
     else
        qlNut9Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut10Valor.Tag] ).AsString <> '' then
     begin
        qlNut10Valor.Caption := TField( CamposNut.Objects[qlNut10Valor.Tag] ).AsString;
        TotNut10 := TotNut10 + TField( CamposNut.Objects[qlNut10Valor.Tag] ).AsFloat;
     end
     else
        qlNut10Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut11Valor.Tag] ).AsString <> '' then
     begin
        qlNut11Valor.Caption := TField( CamposNut.Objects[qlNut11Valor.Tag] ).AsString;
        TotNut11 := TotNut11 + TField( CamposNut.Objects[qlNut11Valor.Tag] ).AsFloat;
     end
     else
        qlNut11Valor.Caption := '---';
     if TField( CamposNut.Objects[qlNut12Valor.Tag] ).AsString <> '' then
     begin
        qlNut12Valor.Caption := TField( CamposNut.Objects[qlNut12Valor.Tag] ).AsString;
        TotNut12 := TotNut12 + TField( CamposNut.Objects[qlNut12Valor.Tag] ).AsFloat;
     end
     else
        qlNut12Valor.Caption := '---';
     MoreData := True;
    end
  else // se a refeição corrente acabou
     begin
        // vai pra próxima refeição
        FCalculoAlimentar.RefeicoesEscolhidas.DataSet.Next;
        // Não existem mais dados para esta refeição
        MoreData := False;
     end;
end;

procedure TfmRelAliNutr.FormCreate(Sender: TObject);
begin
  inherited;
  // Cria lista de nutrientes
  CamposNut := TStringList.Create;
end;

procedure TfmRelAliNutr.SetCamposNut;
begin
  // Seta os nomes dos nutrientes nas colunas do relatório
  with FCalculoAlimentar.AlimentoPorNutriente do
  begin
   qlNut1.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut1Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut1.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut1.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut1Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut2.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut2Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut2.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut2.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut2Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut3.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut3Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut3.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
      begin
          qlNut3.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut3Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
      end;
   qlNut4.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut4Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut4.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut4.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut4Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut5.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut5Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut5.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut5.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut5Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut6.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut6Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut6.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
      begin
          qlNut6.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut6Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
      end;
   qlNut7.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut7Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut7.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut7.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut7Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut8.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut8Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut8.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut8.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut8Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut9.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut9Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut9.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
      begin
          qlNut9.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut9Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
      end;
   qlNut10.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut10Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut10.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut10.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut10Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut11.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut11Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut11.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   if CamposNutInicio <= ( CamposNut.Count - 1 ) then
       begin
          qlNut11.Caption := CamposNut.Strings[CamposNutInicio];
          qlNut11Valor.Tag := CamposNutInicio;
          Inc(CamposNutInicio);
       end;
   qlNut12.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlNut12Valor.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
   qlTotNut12.Enabled := (CamposNutInicio <= ( CamposNut.Count - 1 ));
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

procedure TfmRelAliNutr.QRSubDetail1AfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  // Vai para o próximo alimento
  FCalculoAlimentar.AlimentoPorNutriente.DataSet.Next;
  // Guarda o nome da refeição no label abaixo ***
  qlRefeicaoCont.Caption := qtRefeicao.DataSet.FieldbyName(qtRefeicao.DataField).AsString + ' (continuação)';
  qrCabecalho4.Enabled := True;
end;

function TfmRelAliNutr.GetIDReport: String;
begin
   Result := '{83294A68-04B5-11D4-9DBF-000021609D7C}';
end;

procedure TfmRelAliNutr.qrCabecalhoBeforePrint(Sender: TQRCustomBand;
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

procedure TfmRelAliNutr.FormDestroy(Sender: TObject);
begin
  inherited;
  // Libera lista de nutientes
  CamposNut.Free;
end;

procedure TfmRelAliNutr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfmRelAliNutr.GroupFooterBand1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  inherited;
  // Seta os controls de totais com os acumuladores
  if TotNut1 = 0 then
     qlTotNut1.Caption := '---'
  else
     qlTotNut1.Caption := FormatFloat( '######0.00', TotNut1);
  if TotNut2 = 0 then
     qlTotNut2.Caption := '---'
  else
     qlTotNut2.Caption := FormatFloat( '######0.00', TotNut2);
  if TotNut3 = 0 then
     qlTotNut3.Caption := '---'
  else
     qlTotNut3.Caption := FormatFloat( '######0.00', TotNut3);
  if TotNut4 = 0 then
     qlTotNut4.Caption := '---'
  else
     qlTotNut4.Caption := FormatFloat( '######0.00', TotNut4);
  if TotNut5 = 0 then
     qlTotNut5.Caption := '---'
  else
     qlTotNut5.Caption := FormatFloat( '######0.00', TotNut5);
  if TotNut6 = 0 then
     qlTotNut6.Caption := '---'
  else
     qlTotNut6.Caption := FormatFloat( '######0.00', TotNut6);
   if TotNut7 = 0 then
     qlTotNut7.Caption := '---'
  else
     qlTotNut7.Caption := FormatFloat( '######0.00', TotNut7);
  if TotNut8 = 0 then
     qlTotNut8.Caption := '---'
  else
     qlTotNut8.Caption := FormatFloat( '######0.00', TotNut8);
  if TotNut9 = 0 then
     qlTotNut9.Caption := '---'
  else
     qlTotNut9.Caption := FormatFloat( '######0.00', TotNut9);
  if TotNut10 = 0 then
     qlTotNut10.Caption := '---'
  else
     qlTotNut10.Caption := FormatFloat( '######0.00', TotNut10);
  if TotNut11 = 0 then
     qlTotNut11.Caption := '---'
  else
     qlTotNut11.Caption := FormatFloat( '######0.00', TotNut11);
  if TotNut12 = 0 then
     qlTotNut12.Caption := '---'
  else
     qlTotNut12.Caption := FormatFloat( '######0.00', TotNut12);
  // Limpa acumuladore para outr refeição
  TotPeso := 0;
  TotNut1 := 0;
  TotNut2 := 0;
  TotNut3 := 0;
  TotNut4 := 0;
  TotNut5 := 0;
  TotNut6 := 0;
  TotNut7 := 0;
  TotNut8 := 0;
  TotNut9 := 0;
  TotNut10 := 0;
  TotNut11 := 0;
  TotNut12 := 0;
end;

procedure TfmRelAliNutr.GroupFooterBand1AfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  // Após imprimir os totais, imprimir o cabeçalho da refeição
  qrCabecalho4.Enabled := False;
end;

procedure TfmRelAliNutr.qbSumarioAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  inherited;
  if FRelConfig.NovaPagina then
     Report.NewPage;
end;

procedure TfmRelAliNutr.SetRelConfig(const Value: TRelatorio);
begin
   if (Value <> nil) then
   begin
      FRelConfig := Value;
      FRelConfig.Report := Report;
   end;
end;

end.

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




unit DMGraf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Measurement, Db, DBTables, Memoria, Math, GraficoFaixa, Series, Wizard, Procedimento;

type
  TdmGraficos = class(TDataModule)
    dbGraficos: TDatabase;
    CalcNut: TMemoria;
    dsAntrops: TDataSource;
    taAntrops: TTable;
    taAntropsIDPESSOA: TStringField;
    taAntropsDATA: TDateTimeField;
    taAntropsIMC: TStringField;
    taAntropsSEXO: TStringField;
    taAntropsIDADEANOS: TStringField;
    taAntropsIDADEMESES: TStringField;
    taAntropsTEMPOGESTANTE: TStringField;
    taAntropsDESCRICAO: TStringField;
    taAntropsANTROP: TMemoField;
    dsFaixas: TDataSource;
    dsDescFaixas: TDataSource;
    taDescFaixas: TTable;
    mrFaixas: TMeasurementRanges;
    taAntropsVALORAP: TStringField;
    taAntropsDIAGVALOR: TStringField;
    WizGraf: TNewWizard;
    taDescFaixasTABELA: TStringField;
    taDescFaixasBEGINPOINTDESC: TStringField;
    taDescFaixasBEGINUNIT: TStringField;
    taDescFaixasENDPOINTNDESC: TStringField;
    taDescFaixasENDUNIT: TStringField;
    taDescFaixasCAPTIONDESC: TStringField;
    taDescFaixasCAPTIONUNIT: TStringField;
    taDescFaixasMEDIDA: TStringField;
    taDescFaixasMEDIDADIAG: TStringField;
    taDescFaixasFILTRO: TStringField;
    taDescFaixasATIVO: TStringField;
    taAntropsValida: TTable;
    StringField1: TStringField;
    DateTimeField1: TDateTimeField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    MemoField1: TMemoField;
    StringField9: TStringField;
    procedure taAntropsCalcFields(DataSet: TDataSet);
    procedure dmGraficosCreate(Sender: TObject);
    procedure dmGraficosDestroy(Sender: TObject);
  private
    { Private declarations }
    MaxPoint,
    MinPoint : Double;
    TabelaFaixas : TQuery;
    FGraficoFaixa: TGRaficoFaixa;
    FDiagnosticos : TStringList;
    FMedidasUsadas : TStringList;
    FMedidasUsadasAtivado: Boolean;
    FComFaixas: Boolean;


    procedure CarregaFaixas( FFaixas : TMeasurementRanges; DataSet : TDataset );
    function IndiceFaixaValida(Medida: TMedida; Indice : Integer = 0 ): Integer;
    procedure SetGraficoFaixa(const Value: TGRaficoFaixa);
    procedure SetMedidasUsadasAtivado(const Value: Boolean);
    function ListaMedidasUsadas : String;
    procedure SetComFaixas(const Value: Boolean);
  public
    { Public declarations }
    DataInicialUsuario,
    DataFinalUsuario : TDate;
    DataInicial,
    DataFinal : TDate;
    MaxDate,
    MinDate : TDate;
    IDPessoa,
    NomeMedida,
    NomeMedidaDiag,
    NomeIndividuo,
    Sexo : String;
    Idade : Integer;
  //  P : TRelGraficos;
    Fit : Boolean;

    property ComFaixas : Boolean read FComFaixas write SetComFaixas;
    property MedidasUsadasAtivado : Boolean read FMedidasUsadasAtivado write SetMedidasUsadasAtivado;
    property Diagnosticos : TStringList read FDiagnosticos;
    property GraficoFaixa : TGRaficoFaixa read FGraficoFaixa write SetGraficoFaixa;
    function ShowChart( NomeTabelaFaixas : String; Filtro : String = '' ) : Boolean;
    procedure FitChart;
    procedure NormalChart;
    function MontaStrFiltroGraficos : String;
  end;

var
  dmGraficos: TdmGraficos;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TdmGraficos.FitChart;
begin
 // Adequa a linha as faixas
 if Assigned( GraficoFaixa.Chart ) then
   with GraficoFaixa.Chart do
//   if LeftAxis.Automatic then
     begin
//-      LeftAxis.Automatic := False;
//-      LeftAxis.Maximum := MaxPoint;
//-      LeftAxis.Minimum := MinPoint;
     end;
{   else
     begin
      LeftAxis.Automatic := True;
     end;}
end;

procedure TdmGraficos.NormalChart;
begin
 // Adequa a linha as faixas
 if Assigned( GraficoFaixa.Chart ) then
   with GraficoFaixa.Chart do
      LeftAxis.Automatic := True;
end;



function TdmGraficos.IndiceFaixaValida(Medida: TMedida; Indice : Integer = 0 ): Integer;
var
   I : Integer;
   Point : TMeasureLimit;
   Percent : Double;
begin
   // Retorno default
   Result := -1;
   // Indice inválido
   if ( Indice > mrFaixas.Ranges.Count ) or
       ( Indice < 0 ) then
      exit;
   // Procura a partir do Indice uma faixa onde a medida se encontra
   for I := Indice to mrFaixas.Ranges.Count - 1 do
      if mrFaixas.Ranges.Items[I].Has( Medida, Point, Percent ) then
      begin
         // Achando, retorma o Indice
         Result := I;
         exit;
      end;
end;

procedure TdmGraficos.CarregaFaixas( FFaixas : TMeasurementRanges; DataSet : TDataSet );
var
   Contador : Integer;
   AlturaMediaFaixa,
   Acumulador,
   Point0,
   Point1 : Double;
begin
   Point0 := 0;
   Point1 := 0;
   AlturaMediaFaixa := 0;
   Acumulador := 0;
   Contador := 1;
   // Parametros obricatórios
   if not Assigned( DataSet ) or not Assigned( FFaixas ) then
      exit;

   if (taDescFaixas.FieldByName( 'ATIVO' ).AsString = 'F') or not FComFaixas then
   begin
       FFaixas.Ranges.Clear;
       exit;
   end;


   // Começa carrega Faixas se existirem
   with DataSet do begin
    FFaixas.Ranges.Clear;
    if IsEmpty then
       Exit;
    First;
    while not EOF do begin
      with FFaixas.Ranges.Add do begin
         AutoName := True;
         with BeginPoint do begin
            Opened := ( FieldByName( 'BEGINOPENED' ).AsString = 'T' );
            Excluded := ( FieldByName( 'BEGINEXCLUDED' ).AsString = 'T' );
            if FindField( 'BEGINCAPTION' ) <> nil then
               Caption := FieldByName( 'BEGINCAPTION' ).AsString
            else
               Caption := FieldByName( 'CAPTION' ).AsString;
            with Point do begin
               Descricao := 'MeasurementBegin' + FieldByName( 'INTERVAL' ).AsString;
               ValorNumerico := FieldByName( 'BEGINPOINT' ).AsString;
               Point0 := AsFloat;
               Unidade := ''; //FieldByName( 'BEGINUNIT' ).AsString;
//               Empty := False;
            end;
         end;
         with EndPoint do begin
            Opened := ( FieldByName( 'ENDOPENED' ).AsString = 'T' );
            Excluded := ( FieldByName( 'ENDEXCLUDED' ).AsString = 'T' );
            if FindField( 'ENDCAPTION' ) <> nil then
               Caption := FieldByName( 'ENDCAPTION' ).AsString
            else
               Caption := FieldByName( 'CAPTION' ).AsString;
            with Point do begin
               Descricao := 'MeasurementEnd' + FieldByName( 'INTERVAL' ).AsString;
               if Opened then
                  ValorNumerico := FloatToStr( Max( (Point0 + AlturaMediaFaixa), MaxPoint ))
               else
                  ValorNumerico := FieldByName( 'ENDPOINT' ).AsString;
               Point1 := AsFloat;
               Unidade := ''; //FieldByName( 'ENDUNIT' ).AsString;
//               Empty := False;
            end;
         end;
         Caption := FieldByName( 'CAPTION' ).AsString;
         // Calcula a altura média da faixa aberta e inicial (descartar a faixa c/ 0 )
//         if Point0 <> 0 then
//         begin
            Acumulador := Acumulador + ( Point1 - Point0 );
            AlturaMediaFaixa := Acumulador / Contador;
            Inc(Contador);
//         end;
      end;
      Next;
    end;
    // Correção da primeira faixa quanto a sua altura
{    with FFaixas.Ranges.Items[0].BeginPoint do
    if Opened or ( Point.AsFloat = 0 ) then
       begin
          Point.ValorNumerico := FloatToStr( Min( AlturaMediaFaixa, MinPoint ));
       end; }
   end;
end;

procedure TdmGraficos.taAntropsCalcFields(DataSet: TDataSet);
var
   mdValor : TMedida;
   mdDiagValor,
   mdSexo : TMedidaOrdinal;
{   mdIdadeAnos,
   mdIdadeMeses,
   mdTempoGestante : TMedida;}
begin
   if NomeMedida = '' then
      exit;
//   CalcNut.Limpar;
   if CalcNut = nil then
      exit;
   CalcNut.SetMem( DataSet.FieldByName( 'ANTROP' ).AsString, False );
   // Pega todas as medidas necessárias
   if CalcNut.Acha( NomeMedida, TObject( mdValor ) ) then
      DataSet.FieldByName( 'VALOR' ).AsString := mdValor.ValorApresentacao //ValorNumerico
   else
      DataSet.FieldByName( 'VALOR' ).AsString := '';
   if CalcNut.Acha( NomeMedida, TObject( mdValor ) ) then
      DataSet.FieldByName( 'VALORAP' ).AsString := mdValor.ValorApresentacao
   else
      DataSet.FieldByName( 'VALORAP' ).AsString := '';

   if CalcNut.Acha( NomeMedidaDiag, TObject( mdDiagValor ) ) then
      DataSet.FieldByName( 'DIAGVALOR' ).AsString := mdDiagValor.ValorApresentacao
   else
      DataSet.FieldByName( 'VALORAP' ).AsString := '';

   if CalcNut.Acha( 'mdSexo', TObject( mdSexo ) ) then
      DataSet.FieldByName( 'SEXO' ).AsString := mdSexo.ValorNumerico
   else
      DataSet.FieldByName( 'SEXO' ).AsString := '';
{   if CalcNut.Acha( 'mdIdadeAnos', TObject( mdIdadeAnos ) ) then
      DataSet.FieldByName( 'IDADEANOS' ).AsString := mdIdadeAnos.ValorNumerico
   else
      DataSet.FieldByName( 'IDADEANOS' ).AsString := '';
   if CalcNut.Acha( 'mdIdadeMeses', TObject( mdIdadeMeses ) ) then
      DataSet.FieldByName( 'IDADEMESES' ).AsString := mdIdadeAnos.ValorNumerico
   else
      DataSet.FieldByName( 'IDADEMESES' ).AsString := '';
   if CalcNut.Acha( 'mdTempoGestante', TObject( mdTempoGestante ) ) then
      DataSet.FieldByName( 'TEMPOGESTANTE' ).AsString := mdTempoGestante.ValorNumerico
   else
      DataSet.FieldByName( 'TEMPOGESTANTE' ).AsString := '';}
   CalcNut.Limpar;
end;

function TdmGraficos.ShowChart( NomeTabelaFaixas : String; Filtro : String = '' ) : Boolean;
var
   mdMed : TMedida;
   Ind,
   I : Integer;
   sSQL : String;
begin
   Result := False;

   // Monta a configuração dos eixos
   if (GraficoFaixa.Chart <> nil) and (GraficoFaixa.FaixasY <> nil) then
   begin
      GraficoFaixa.MontaChart
   end
   else
      exit;

   GraficoFaixa.Chart.Visible := False;

   // Limpando linha anterior
   for I := GraficoFaixa.Chart.SeriesList.Count - 1 downto 0 do
       if ( GraficoFaixa.Chart.SeriesList.Series[I] is TLineSeries ) then
          GraficoFaixa.Chart.SeriesList.Delete(I);

   // Abre com filtro
   with taAntrops do
   begin
      Active := False;
      Filter := 'IDPESSOA=' + '''' + IDPessoa + '''' +
                ' AND DATA >= ' + '''' + DateToStr(MinDate) + '''' +
                ' AND DATA <= ' + '''' + DateToStr(MaxDate) + '''';
      Filtered := True;
      Active := True;
      if Eof then
         exit;
   end;

   // Prepara query de faixas
 if NomeTabelaFaixas <> '' then
   with taDescFaixas do begin
//    Open;
//    if Locate( 'TABELA', UpperCase(NomeTabelaFaixas), [] ) then
      begin
       if not Assigned( TabelaFaixas ) then
       begin
          TabelaFaixas := TQuery.Create(self);
          TabelaFaixas.DataBaseName := 'bdFaixas';
          dsFaixas.DataSet := TabelaFaixas;
       end;
       TabelaFaixas.Close;
       TabelaFaixas.SQL.Clear;
       if Filtro = '' then
          sSQL := 'SELECT * FROM ' + NomeTabelaFaixas + ' ORDER BY INTERVAL'
       else
          sSQL := 'SELECT * FROM ' + NomeTabelaFaixas + ' WHERE ' + Filtro + ' ORDER BY INTERVAL';
       TabelaFaixas.SQL.Add( sSQL );
       for I := 0 to TabelaFaixas.ParamCount - 1 do
         begin
            if UpperCase(TabelaFaixas.Params[I].Name) = 'PSEXO' then
               TabelaFaixas.Params[I].AsString := taAntrops.FieldByName( 'SEXO' ).AsString; // Sexo;
            if UpperCase(TabelaFaixas.Params[I].Name) = 'PIDADE' then
               TabelaFaixas.Params[I].AsInteger := Idade;
         end;
{
       TabelaFaixas.TableName := FieldByName( 'TABELA' ).AsString;
       TabelaFaixas.Filter := Filtro;
       TabelaFaixas.Filtered := (Filtro <> '');
}
       TabelaFaixas.Open;
      end;
//      else
//       exit;
   end;

   // Define datas de visitas válidas
   DataInicial := StrToDate( '01/01/1980' );
   DataFinal := Date;
   taAntrops.First;
   while not taAntrops.Eof do
   begin
    if taAntrops.FieldByName( 'VALOR' ).AsString <> '' then
    begin
      // Pega estas datas com valor não nulo
      if DataInicial = StrToDate( '01/01/1980' ) then
         DataInicial := StrToDate( taAntrops.FieldByName( 'DATA' ).AsString );
      DataFinal := StrToDate( taAntrops.FieldByName( 'DATA' ).AsString );
    end;
    taAntrops.Next;
   end;

   // Caso as datas de limite serem iguais
   if Trunc(DataFinal - DataInicial) = 0 then
      GraficoFaixa.XSize := 7
   else
      GraficoFaixa.XSize :=  Trunc(DataFinal - DataInicial);

   // Define os limites de Y pelos pontos da linha
   MaxPoint := 0;
   Minpoint := 9999999;
   GraficoFaixa.Visitas.Clear;
   GraficoFaixa.Resultados.Clear;
   FDiagnosticos.Clear;
   taAntrops.First;
   while not taAntrops.Eof do
   begin
    if taAntrops.FieldByName( 'VALOR' ).AsString <> '' then
    begin
      // Adicionando os pontos
      GraficoFaixa.Visitas.Insert(0, IntToStr ( Trunc( StrToDate( taAntrops.FieldByName( 'DATA' ).AsString ) - DataInicial ) ));
      GraficoFaixa.Resultados.Insert(0, taAntrops.FieldByName( 'VALOR' ).AsString );
      FDiagnosticos.Insert(0, taAntrops.FieldByName( 'DIAGVALOR' ).AsString );
      // Definido os limites de Y
      MaxPoint := Max( MaxPoint, taAntrops.FieldByName( 'VALOR' ).AsFloat );
      MinPoint := Min( MinPoint, taAntrops.FieldByName( 'VALOR' ).AsFloat );
    end;
    taAntrops.Next;
   end;

   // Não há dados válidos
   if GraficoFaixa.Visitas.Count = 0 then
      exit;

   // Monta faixa conforme tabela
   if TabelaFaixas.Active then
      CarregaFaixas( mrFaixas, TabelaFaixas );

   // Redefine os limites de Y pelas faixas
   Ind := -1;
   for I := 0 to GraficoFaixa.Resultados.Count - 1 do
   begin
      // Procura as faixas válidas
      repeat
         mdMed := TMedida.Create(self);
         try
           mdMed.AsFloat := StrToFloat( GraficoFaixa.Resultados.Strings[I] );
           Inc(Ind);
           Ind := IndiceFaixaValida( mdMed, Ind );
         finally
           mdMed.Free;
         end;
         // Verifica se o EndPoint desta faixa é um MaxPoint
         if ( Ind >= 0 ) and not ( mrFaixas.Ranges.Items[Ind].EndPoint.Opened ) then
            MaxPoint := Max( MaxPoint, mrFaixas.Ranges.Items[Ind].EndPoint.Point.AsFloat);
         // Verifica se o BeginPoint desta faixa é um MinPoint
         if ( Ind >= 0 ) and not ( mrFaixas.Ranges.Items[Ind].BeginPoint.Opened ) then
            MinPoint := Min( MinPoint, mrFaixas.Ranges.Items[Ind].BeginPoint.Point.AsFloat);
      Until Ind < 0;
   end;
   // Executa o show do gráfico
   GraficoFaixa.Execute;

   // tem que ser depois do execute senão não sai atualizado
   with taDescFaixas do begin
      with GraficoFaixa.Chart do begin
         with Title.Text do begin
            Clear;
//            Add( 'Gráfico de Acompanhamento' );
            Add( FieldByName( 'CAPTIONDESC' ).AsString );
            Add( NomeIndividuo );
         end;
         with LeftAxis.Title do begin
            Caption := FieldByName( 'BEGINUNIT' ).AsString;
         end;
         with BottomAxis.Title do begin
            Caption := 'Dias'
         end;
         with Foot.Text do begin
            Clear;
            Add( 'Período das visitas: ' + DateToStr( DataInicial ) +  ' a ' + DateToStr( DataFinal ) );
         end;
      end;
   end;
   Result := True;

   GraficoFaixa.Chart.Visible := True;
   GraficoFaixa.Chart.Refresh;

end;

procedure TdmGraficos.SetGraficoFaixa(const Value: TGRaficoFaixa);
begin
  FGraficoFaixa := Value;
  if Value <> nil then
     Value.FreeNotification(self);
end;

procedure TdmGraficos.dmGraficosCreate(Sender: TObject);
begin
   FDiagnosticos := TStringList.Create;
   FMedidasUsadas := TStringList.Create;
end;

procedure TdmGraficos.dmGraficosDestroy(Sender: TObject);
begin
   FMedidasUsadas.Free;
   FDiagnosticos.Free;
end;

procedure TdmGraficos.SetMedidasUsadasAtivado(const Value: Boolean);
begin
  FMedidasUsadasAtivado := Value;
end;

function TdmGraficos.MontaStrFiltroGraficos: String;
var
   Temp : TStringList;
   I : Integer;
   mdMedTemp : TMedida;
   MedUsadas : String;
begin
   Result := '';
   if CalcNut = nil then
      exit;
   // Abre com filtro
   FMedidasUsadas.Clear;
   FMedidasUsadas.Duplicates := dupIgnore;
   with taAntropsValida do
   begin
      Filter := 'IDPESSOA=' + '''' + IDPessoa + '''' +
                ' AND DATA >= ' + '''' + DateToStr(DataInicialUsuario) + '''' +
                ' AND DATA <= ' + '''' + DateToStr(DataFinalUsuario) + '''';
      Filtered := True;
      Active := True;
      taDescFaixas.Filtered := False;
      taDescFaixas.Active := True;
      while not Eof do
      begin
         CalcNut.SetMem( FieldByName( 'ANTROP' ).AsString, False );
         MedUsadas := ListaMedidasUsadas;
         if MedUsadas <> '' then
         begin
            Temp := TStringList.Create;
            try
               Temp.Text := MedUsadas;
               For I := 0 to Temp.Count - 1 do
               begin
                  if taDescFaixas.Locate( 'MEDIDA', Temp.Strings[I], [] ) then
                  begin
                     // Verifica se a medida tem todos os requisitos necessários
                     if CalcNut.Acha( Temp.Strings[I], TObject(mdMedTemp) ) and
                        ( mdMedTemp is TMedida ) and mdMedTemp.Valid and
                        not mdMedTemp.Empty then
                        FMedidasUsadas.Add( Temp.Strings[I] );
                  end
               end;
            finally
               Temp.Free;
            end;
         end;
         Next;
         CalcNut.Limpar;
      end;
      Filtered := False;
      Filter := '';
      Active := False;
      taDescFaixas.Active := False;
      if FMedidasUsadas.Count > 0 then
      begin
         Result := 'MEDIDA = ' + '''' + StringReplace( FMedidasUsadas.CommaText, ',', '''' + ' or MEDIDA = ' + '''', [rfReplaceAll]) + '''';
         taDescFaixas.Filter := Result;
         taDescFaixas.Filtered := True;
         taDescFaixas.Active := True;
      end;
  end;
end;

function TdmGraficos.ListaMedidasUsadas : String;
var
   I : Integer;
   AuxCx,
   AuxPr : TComponent;
   LstProcChecked : TStringList;
   LstMedidasChecked : TStringList;
begin
  Result := '';
  // para testar #######################################
  LstProcChecked := TStringList.Create;
  LstMedidasChecked := TStringList.Create;
try
  if Assigned (CalcNut) then
  begin
     AuxCx := CalcNut.FindComponent( 'cxcaAntrop' );
     if Assigned( AuxCx ) and ( AuxCx is TCaixa ) then
     with (AuxCx as TCaixa ) do
     begin
       // Cria as listas de procedimentos checked e não checked
       For I := 0 to ComponentCount - 1 do
          if ( Components[I] is TProcedimento ) then
          begin
             if TProcedimento( Components[I] ).Estado = psChecked then
                LstProcChecked.Add( TProcedimento( Components[I] ).Name );
          end;
     end;
     // Enche a lista de medidas checked
     dmMotherBoard.caProcessador.Procedimentos.Clear;
     dmMotherBoard.caProcessador.Procedimentos := LstProcChecked;
     if dmMotherBoard.caProcessador.ListaMedidasProcedimentos( LstMedidasChecked ) < 0 then
        exit;
     Result := LstMedidasChecked.Text;
  end;
finally
  LstProcChecked.Free;
  LstMedidasChecked.Free;
end;
end;

procedure TdmGraficos.SetComFaixas(const Value: Boolean);
begin
  FComFaixas := Value;
end;

end.

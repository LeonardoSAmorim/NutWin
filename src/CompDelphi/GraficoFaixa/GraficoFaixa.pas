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




unit GraficoFaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Chart, Series, TeEngine, MedidasBlobs, FaixasTabela, measurement,
  ChartFaixas;

type
  TGraficoFaixa = class(TChartFaixas)
  private
    FCorLinha: TColor;
    FFaixas: TStrings;
    FResultados: TStrings;
    FVisitas: TStrings;
    FNomeFaixas: TStrings;
    FRodape: TStrings;
    FTitulo: TStrings;
    FMedidasBlobs: TMedidasBlobs;
    FFaixasTabela: TFaixasTabela;
    procedure SetCorLinha(const Value: TColor);
    procedure SetFaixas(const Value: TStrings);
    procedure SetResultados(const Value: TStrings);
    procedure SetVisitas(const Value: TStrings);
    procedure SetNomeFaixas(const Value: TStrings);
    procedure SetRodape(const Value: TStrings);
    procedure SetTitulo(const Value: TStrings);
    procedure SetMedidasBlobs(const Value: TMedidasBlobs);
    procedure SetFaixasTabela(const Value: TFaixasTabela);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure Loaded; override;
    function Execute : boolean;
    procedure SetaEscalasXYInc( XMin, XMax, IncX, YMin, YMax, IncY : String );
  published
    { Published declarations }
    property Visitas : TStrings read FVisitas write SetVisitas;
    property Resultados : TStrings read FResultados write SetResultados;
    property Faixas : TStrings read FFaixas write SetFaixas;
    property NomeFaixas : TStrings read FNomeFaixas write SetNomeFaixas;
    property CorLinha : TColor read FCorLinha write SetCorLinha;
    property Titulo : TStrings read FTitulo write SetTitulo;
    property Rodape : TStrings read FRodape write SetRodape;
    property MedidasBlobs : TMedidasBlobs read FMedidasBlobs write SetMedidasBlobs;
    property FaixasTabela : TFaixasTabela read FFaixasTabela write SetFaixasTabela;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Miscelanea', [TGraficoFaixa]);
end;

{ TGraficoFaixa }

constructor TGraficoFaixa.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FVisitas := TStringList.Create;
   FResultados := TStringList.Create;
   FFaixas := TStringList.Create;
   FNomeFaixas := TStringList.Create;
   FTitulo := TStringList.Create;
   FRodape := TStringList.Create;
end;

destructor TGraficoFaixa.Destroy;
begin
   FVisitas.Free;
   FResultados.Free;
   FFaixas.Free;
   FNomeFaixas.Free;
   FTitulo.Free;
   FRodape.Free;
   inherited Destroy;
end;

function TGraficoFaixa.Execute: boolean;
var
   I : integer;
   LineSerie : TLineSeries;
begin

   if Assigned( FFaixasTabela ) and FFaixasTabela.Execute then
      begin
         FFaixas.Assign( FFaixasTabela.ListaFaixas );
         FNomeFaixas.Assign( FFaixasTabela.ListaNomeFaixas );
      end
   else
      begin
//         Result := False;
//         exit;
      end;

   if Assigned( FMedidasBlobs ) and FMedidasBlobs.Execute then
      begin
         For I := 0 to FMedidasBlobs.ListaMedidas.Count - 1 do
         begin
            if Assigned( FMedidasBlobs.ListaMedidas.Objects[I] ) and
               ( FMedidasBlobs.ListaMedidas.Objects[I] is TMedida ) and
               not( FMedidasBlobs.ListaMedidas.Objects[I] is TMedidaOrdinal ) then
               begin
                  FVisitas.Add( FMedidasBlobs.ListaMedidas.Strings[I] );
                  FResultados.Add( TMedida( FMedidasBlobs.ListaMedidas.Objects[I] ).ValorNumerico );
               end
         end;
      end
   else
      begin
//         Result := False;
//         exit;
      end;

   if Chart = nil then
     begin
      Result := False;
      exit;
     end;

   Chart.Title.Visible := True;
   Chart.Foot.Visible := True;
   Chart.Title.Text.Assign( FTitulo );
   Chart.Foot.Text.Assign( FRodape );

   MontaChart;

   LineSerie := TLineSeries.Create(self);
   LineSerie.ShowInLegend := False;
   LineSerie.LinePen.Width := 3;
//   LineSerie.LinePen.Color := FCorLinha;
   LineSerie.Pointer.HorizSize := 3;
   LineSerie.Pointer.VertSize := 3;
   LineSerie.Pointer.Style := psCircle;
   LineSerie.Pointer.Visible := True;

//   LineSerie.Marks.Style := smsValue;
//   LineSerie.Marks.Transparent := True;
//   LineSerie.Marks.Visible := True;

   for I := 0 to FVisitas.Count - 1 do
   begin
       LineSerie.AddXY( StrToFloat( FVisitas.Strings[I] ),
                        StrToFloat( FResultados.Strings[I] ),
                        FVisitas.Strings[I],FCorLinha);
   end;
   Chart.AddSeries( LineSerie );
   Result := True;
end;

procedure TGraficoFaixa.Loaded;
begin
     inherited Loaded;

end;

procedure TGraficoFaixa.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FMedidasBlobs then
        FMedidasBlobs := nil;
     if AComponent = FFaixasTabela then
        FFaixasTabela := nil;

end;

procedure TGraficoFaixa.SetaEscalasXYInc(XMin, XMax, IncX, YMin, YMax,
  IncY: String);
begin

   if Chart = nil then
      exit;

   Chart.BottomAxis.Automatic := ( XMin = '') and ( XMax = '' );
   Chart.BottomAxis.AutomaticMaximum := ( XMax = '' );
   Chart.BottomAxis.AutomaticMinimum := ( XMin = '');
   if not Chart.BottomAxis.AutomaticMaximum then
      Chart.BottomAxis.Maximum := StrToFloat(XMax);
   if not Chart.BottomAxis.AutomaticMinimum then
      Chart.BottomAxis.Minimum := StrToFloat(XMin);
   Chart.BottomAxis.Increment := StrToFloat(IncX);

   Chart.LeftAxis.Automatic := ( YMin = '') and ( YMax = '' );
   Chart.LeftAxis.AutomaticMaximum := ( YMax = '' );
   Chart.LeftAxis.AutomaticMinimum := ( YMin = '');

   if YMin<=YMax then
   Begin
    if not Chart.LeftAxis.AutomaticMinimum then
       Chart.LeftAxis.Minimum := StrToFloat(YMin);
    if not Chart.LeftAxis.AutomaticMaximum then
       Chart.LeftAxis.Maximum := StrToFloat(YMax);
   End
   else
   Begin
    if not Chart.LeftAxis.AutomaticMaximum then
       Chart.LeftAxis.Maximum := StrToFloat(YMax);
    if not Chart.LeftAxis.AutomaticMinimum then
       Chart.LeftAxis.Minimum := StrToFloat(YMin);
   End;
   Chart.LeftAxis.Increment := StrToFloat(IncY);
end;

procedure TGraficoFaixa.SetCorLinha(const Value: TColor);
begin
  FCorLinha := Value;
end;

procedure TGraficoFaixa.SetFaixas(const Value: TStrings);
begin
  FFaixas.Assign(Value);
end;

procedure TGraficoFaixa.SetFaixasTabela(const Value: TFaixasTabela);
begin
  FFaixasTabela := Value;
end;

procedure TGraficoFaixa.SetMedidasBlobs(const Value: TMedidasBlobs);
begin
  FMedidasBlobs := Value;
end;

procedure TGraficoFaixa.SetNomeFaixas(const Value: TStrings);
begin
  FNomeFaixas.Assign( Value );
end;

procedure TGraficoFaixa.SetResultados(const Value: TStrings);
begin
  FResultados.Assign(Value);
end;

procedure TGraficoFaixa.SetRodape(const Value: TStrings);
begin
  FRodape.Assign(Value);
end;

procedure TGraficoFaixa.SetTitulo(const Value: TStrings);
begin
  FTitulo.Assign(Value);
end;

procedure TGraficoFaixa.SetVisitas(const Value: TStrings);
begin
  FVisitas.Assign(Value);
end;

end.

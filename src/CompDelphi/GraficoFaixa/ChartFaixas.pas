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




unit ChartFaixas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeeShape, Chart, TeEngine, Measurement, Series;

type
  TMeasurementIntervalFriend = class (TMeasurementInterval);
  TChartFaixas = class(TComponent)
  private
    FChart: TCustomChart;
    FFaixasY: TMeasurementRanges;
    FXSize: Integer;
    procedure SetChart(const Value: TCustomChart);
    procedure SetFaixasY(const Value: TMeasurementRanges);
    procedure SetXSize(const Value: Integer);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create (AOwner : TComponent); override;
    procedure Loaded;override;
    procedure MontaChart;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
  published
    { Published declarations }
    property Chart: TCustomChart read FChart write SetChart;
    property FaixasY : TMeasurementRanges read FFaixasY write SetFaixasY;
    property XSize : Integer read FXSize write SetXSize default 100;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Medida', [TChartFaixas]);
end;

{ TChartFaixas }

procedure TChartFaixas.SetChart(const Value: TCustomChart);
begin
  if Value=nil then
     if Assigned(FChart) then FChart.FreeAllSeries;
  FChart := Value;

  if (FChart <> nil) then
  begin
  FChart.FreeNotification (self);
  if(FFaixasY <> nil) and (csDesigning in ComponentState) then
      begin
      MontaChart;
      end;
  end;

end;

procedure TChartFaixas.SetXSize(const Value: Integer);
var
I : integer;
begin
  FXSize := Value;
  if (FChart <> nil) then
     for I:=0 to  (FChart.SeriesCount-1) do
     begin
          if (FChart.Series[I] is TChartShape) then
          begin
              TChartShape(FChart.Series[I]).X0:=0;
              TChartShape(FChart.Series[I]).X1:=FXSize;
          end;
     end;
  if FXSize > 0 then
     FChart.Repaint;
end;

procedure TChartFaixas.SetFaixasY(const Value: TMeasurementRanges);
begin
  FFaixasY := Value;
  if (FFaixasY <> nil) then
  begin
  FFaixasY.FreeNotification (self);
  if (FChart <> nil) and not(csloading in ComponentState) then
      begin
      MontaChart;
      end;
  end;
end;

constructor TChartFaixas.Create(AOwner: TComponent);
begin
inherited;
FXSize := 100;
end;

procedure TChartFaixas.Loaded;
begin
  if (FChart <> nil) and (FFaixasY <> nil)then
  begin
  MontaChart;
  end;
end;

procedure TChartFaixas.MontaChart;
var
NovaSerie : TChartShape;
I : integer;
//LineSerie : TLineSeries;

begin
  I:=0;
  while I <> (FChart.SeriesCount) do
      if (FChart.Series[I] is TChartShape) then
          begin
          NovaSerie:=TChartShape(FChart.Series[I]);
          FChart.RemoveSeries (NovaSerie);
          NovaSerie.Free;
          end
      else
         Inc(I);

  for I:=0 to  (FFaixasY.Ranges.Count - 1)do
      begin
      NovaSerie := TChartShape.Create (FChart);
      NovaSerie.Style := chasRectangle;
      NovaSerie.Brush.Style := bsClear;
      NovaSerie.Pen.Width := 1;
      if ( I mod 2 ) = 0 then
         NovaSerie.Pen.Style := psSolid
      else
         NovaSerie.Pen.Style := psClear;
      NovaSerie.Y0 := FFaixasY.Ranges.Items[I].BeginPoint.Point.AsFloat;
      NovaSerie.Y1 := FFaixasY.Ranges.Items[I].EndPoint.Point.AsFloat;
      NovaSerie.XYStyle:=xysAxis;
      NovaSerie.Name:=TMeasurementIntervalFriend(FFaixasY.Ranges.Items[I]).GetDisplayName + 'Series';
      begin
          NovaSerie.X0:=0;
          NovaSerie.X1:=FXSize;
      end;
      NovaSerie.Text.Add (FFaixasY.Ranges.Items[I].Caption);
      FChart.AddSeries (NovaSerie);
      end;

      FChart.Repaint;
  end;

procedure TChartFaixas.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
if (Operation = opRemove) then
   begin
   if AComponent = FChart then FChart:=nil;
   if AComponent = FFaixasY then FFaixasY:=nil;
   end;
end;

end.

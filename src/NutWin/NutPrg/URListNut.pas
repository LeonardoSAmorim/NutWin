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




unit URListNut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, ExtCtrls, qrepform, RxGIF;

type
  TfmRelListNut = class(TFormReport)
    QRBand1: TQRBand;
    QRBand2: TQRBand;
    QRSubDetail1: TQRSubDetail;
    qlNutrientes: TQRLabel;
    qlValor: TQRLabel;
    qlUnidade: TQRLabel;
    qrNomeAli: TQRLabel;
    qrGramas: TQRLabel;
    procedure qrRelListNutNeedData(Sender: TObject; var MoreData: Boolean);
    procedure qrRelListNutBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private
    { Private declarations }
    Indice  : integer;

  public
    { Public declarations }
  end;

var
  fmRelListNut: TfmRelListNut;

implementation

uses DMNutrien, DMAliPrep, UListaNut ;


{$R *.DFM}

procedure TfmRelListNut.qrRelListNutNeedData(Sender: TObject;
  var MoreData: Boolean);
begin
    if Indice < fmListNut.lvNutCalc.Items.Count then
    begin

      qlNutrientes.Caption := fmListNut.lvNutCalc.Items.Item[Indice].Caption;
      qlValor.Caption      := fmListNut.lvNutCalc.Items.Item[Indice].SubItems.Strings[0];
      qlUnidade.Caption    := fmListNut.lvNutCalc.Items.Item[Indice].SubItems.Strings[1];
      Inc( Indice);
      MoreData := True;
    end
    else
      MoreData := False;

end;

procedure TfmRelListNut.qrRelListNutBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
   Indice := 0;
   qrNomeAli.Caption := DMAlimentos.TbAlimentoNOME.asString;
   qrGramas.Caption := fmListNut.edGramas.Text + ' gr'; 
end;

end.
 
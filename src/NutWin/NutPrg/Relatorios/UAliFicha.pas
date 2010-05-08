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




unit UAliFicha;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  quickrpt, Qrctrls, ExtCtrls, qrepform, RxGIF;

type
  TfmAliFicha = class(TFormReport)
    qbAlim: TQRBand;
    qtNome: TQRDBText;
    qtNomeSimpl: TQRDBText;
    qtGAlim: TQRDBText;
    qtOrig: TQRDBText;
    qlNome: TQRLabel;
    qlNomeSimpl: TQRLabel;
    qlGAli: TQRLabel;
    qlOrigem: TQRLabel;
    qgAli: TQRGroup;
    qeAli: TQRExpr;
    qbAliMed: TQRSubDetail;
    qtNomeMed: TQRDBText;
    qtValorMed: TQRDBText;
    qlgr: TQRLabel;
    qbTitMed: TQRBand;
    qlNomeMed: TQRLabel;
    qlValorMed: TQRLabel;
    qbAliNut: TQRSubDetail;
    qtNut: TQRDBText;
    qtValor: TQRDBText;
    qtUnidade: TQRDBText;
    qbTitNut: TQRBand;
    qlNomeNut: TQRLabel;
    qlValorNut: TQRLabel;
    qbSubsCal: TQRSubDetail;
    qtGrCal: TQRDBText;
    qtMedGr: TQRDBText;
    qtMed: TQRDBText;
    qtQtde: TQRDBText;
    qbTitSCal: TQRBand;
    qlGrSCal: TQRLabel;
    qlQtde: TQRLabel;
    qlMed: TQRLabel;
    qlMedGr: TQRLabel;
    qbAlipreco: TQRSubDetail;
    qtQtdePr: TQRDBText;
    qtMedPr: TQRDBText;
    qtMedgrPr: TQRDBText;
    qtPreco: TQRDBText;
    qtData: TQRDBText;
    qbTitPreco: TQRBand;
    qlQtdePr: TQRLabel;
    qlMedPr: TQRLabel;
    qlValorPr: TQRLabel;
    qlPreco: TQRLabel;
    qlDataPr: TQRLabel;
    QRLabel1: TQRLabel;
    qbTitSProt: TQRBand;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    qbSubsProt: TQRSubDetail;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel6: TQRLabel;
    QRDBText5: TQRDBText;
    procedure qrAliFichaAfterPreview(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAliFicha: TfmAliFicha;

implementation

uses DMRelat, DMRelMed, DMRElNut, DMRelSuCal, DMRelPrAli;


{$R *.DFM}

procedure TfmAliFicha.qrAliFichaAfterPreview(Sender: TObject);
begin
   DMRelatAli.TbAlim.Filter := '' ;
   DMRelatAli.TbAlim.Filtered := False;
end;

end.
 
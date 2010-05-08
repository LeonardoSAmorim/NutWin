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




unit URelAlim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  quickrpt, Qrctrls, ExtCtrls, qrepform, RxGIF;

type
  TfmRelAlimentar = class(TFormReport)
    qgAli: TQRGroup;
    QRExpr1: TQRExpr;
    qbDadosAli: TQRBand;
    qlAlimento: TQRLabel;
    qlSimplificado: TQRLabel;
    qlOrigem: TQRLabel;
    qlGruAli: TQRLabel;
    qtAlimento: TQRDBText;
    qtSimplificado: TQRDBText;
    qtOrigem: TQRDBText;
    qtGruAli: TQRDBText;
    qlAlimto: TQRLabel;
    qsMedCas: TQRSubDetail;
    qtMed: TQRDBText;
    qtValor: TQRDBText;
    qtGramas: TQRLabel;
    qbTitAliMed: TQRBand;
    qlMedidas: TQRLabel;
    qbTitAliNut: TQRBand;
    qlNutr: TQRLabel;
    qsNut: TQRSubDetail;
    qtNut: TQRDBText;
    qtValorNut: TQRDBText;
    qtUnidNut: TQRDBText;
    qbAliSubsCal: TQRBand;
    qlAliSubsCal: TQRLabel;
    qsSCal: TQRSubDetail;
    qlSubs: TQRLabel;
    qtGruCal: TQRDBText;
    qlSubsMed: TQRLabel;
    qtValorMed: TQRDBText;
    qtMedida: TQRDBText;
    qlUnidade: TQRLabel;
    qlValor: TQRLabel;
    qlValorNut: TQRLabel;
    qlUnidNut: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRelAlimentar: TfmRelAlimentar;

implementation

uses DMRelPrAli, DMRelat, DMRelMed, DMRElNut, DMRelSuCal;

{$R *.DFM}

end.
 
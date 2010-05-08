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




unit URTAGPro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, RxGIF, ExtCtrls, qrepform;

type
  TfmRTAGPro = class(TFormReport)
    qbCab: TQRBand;
    qlGPro: TQRLabel;
    qlNome: TQRLabel;
    qlProt: TQRLabel;
    QRLabel1: TQRLabel;
    qbTabGProt: TQRBand;
    qtNome: TQRDBText;
    qtProt: TQRDBText;
    qtEnerg: TQRDBText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRTAGPro: TfmRTAGPro;

implementation

uses DMRelSuCal;

{$R *.DFM}

end.
  
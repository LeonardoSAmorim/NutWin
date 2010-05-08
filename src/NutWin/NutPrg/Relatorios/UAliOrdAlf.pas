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




unit UAliOrdAlf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  quickrpt, Qrctrls, ExtCtrls, qrepform, RxGIF;

type
  TfmAliOrdAlf = class(TFormReport)
    QRBand1: TQRBand;
    qrGrupoAli: TQRGroup;
    qePorLetra: TQRExpr;
    QRBand2: TQRBand;
    qtNomeSimpl: TQRDBText;
    qtOrigem: TQRDBText;
    qtGruAli: TQRDBText;
    QRExpr1: TQRExpr;
    qlNomeSimpl: TQRLabel;
    qlOrigem: TQRLabel;
    qlGruAli: TQRLabel;
    QRExpr2: TQRExpr;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAliOrdAlf: TfmAliOrdAlf;

implementation

uses DMRelat;

{$R *.DFM}

end.
  
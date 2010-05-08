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




unit fmFormRelCalcAli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fmFormRelIndividuo, VisorMedida, VisorCal, QuickRpt, Qrctrls, jpeg,
  ExtCtrls, Db, DBTables;

type
  TfmRepCalcAli = class(TFormRepIndividuo)
    qbRefeicao: TQRGroup;
    qbItemAlimentar: TQRBand;
    qeRefeicao: TQRExpr;
    qtQtde: TQRDBText;
    qtMedida: TQRDBText;
    qtPeso: TQRDBText;
    qtAlimento: TQRDBText;
    quRefItemsAli: TQuery;
    taMedida: TTable;
    qlQtde: TQRLabel;
    qlMedida: TQRLabel;
    qlAlimento: TQRLabel;
    qlPeso: TQRLabel;
    quRefItemsAliID_CALCALI: TStringField;
    quRefItemsAliID_REFEICAO: TStringField;
    quRefItemsAliID_ALI: TStringField;
    quRefItemsAliID_MEDIDA: TStringField;
    quRefItemsAliQUANT: TFloatField;
    quRefItemsAliPESO: TFloatField;
    quRefItemsAliFREQDIA: TFloatField;
    quRefItemsAliGUID_1: TStringField;
    quRefItemsAliID_CALCALI_1: TStringField;
    quRefItemsAliID_REFEICAO_1: TStringField;
    quRefItemsAliNOMEMED: TStringField;
    quRefItemsAliGUID: TStringField;
    quRefItemsAliIDALI: TStringField;
    quRefItemsAliNOME: TStringField;
    quRefItemsAliID_REFEICAO_2: TStringField;
    quRefItemsAliNOME_1: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRepCalcAli: TfmRepCalcAli;

implementation

uses DMMBoard;

{$R *.DFM}

end.

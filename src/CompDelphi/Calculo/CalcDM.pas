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




unit CalcDM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, Formula, ROM, Measurement;

type
  TDMCalc = class(TDataModule)
    dsFmla: TDataSource;
    quFmla: TQuery;
    quTab: TQuery;
    dsTab: TDataSource;
    tbTabela: TTabela;
    flFormula: TFormula;
    dsMed: TDataSource;
    taMed: TTable;
    MedRanges: TMeasurementRanges;
    taDescritor: TTable;
    dsDescritor: TDataSource;
    quTabNAME: TStringField;
    quTabTIPO: TStringField;
    quTabEXPRESSAO: TStringField;
    quTabDATA: TDateTimeField;
    quTabDESCRICAO: TStringField;
    quTabDATABASENAME: TStringField;
    quTabNOMETABELA: TStringField;
    quTabCAMPORESULT: TStringField;
    quTabMODOPESQUISA: TStringField;
    quFmlaNAME: TStringField;
    quFmlaTIPO: TStringField;
    quFmlaEXPRESSAO: TStringField;
    quFmlaDATA: TDateTimeField;
    quFmlaDESCRICAO: TStringField;
    quFmlaACEITAPARAMINVALIDO: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMCalc: TDMCalc;

implementation

{$R *.DFM}

end.
 
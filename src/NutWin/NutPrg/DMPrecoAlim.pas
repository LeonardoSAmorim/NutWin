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




unit DMPrecoAlim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, NutCnst, DBTables, stdctrls;

type
  TDMPreco = class(TDataModule)
    TbPrecoAli: TTable;
    DSPrecoAli: TDataSource;
    DSNutrientes: TDataSource;
    DSListaPreco: TDataSource;
    TbListaPreco: TTable;
    TbPrecoAliIDMEDCAS: TStringField;
    TbPrecoAliQTDE: TFloatField;
    TbPrecoAliPRECO: TFloatField;
    TbPrecoAliDATA: TDateField;
    TbListaPrecoNomeLista: TStringField;
    TbListaPrecoIDListaPreco: TStringField;
    TbPrecoAliListaPreco: TStringField;
    TbPrecoAliIDLISTAPRECO: TStringField;
    TbPrecoAliIDALI: TStringField;
    TbPrecoAliMedidas: TStringField;
    TbPrecoAliMEDGR: TStringField;
    dbPreco: TDatabase;
    procedure TbListaPrecoNewRecord(DataSet: TDataSet);
    procedure DMPrecoCreate(Sender: TObject);
   private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  DMPreco: TDMPreco;

implementation

uses DMSubstCal, DMAliPrep, DMMedidas, uAliasName;


{$R *.DFM}

procedure TDMPreco.TbListaPrecoNewRecord(DataSet: TDataSet);
begin
   TbListaPrecoIDLISTAPRECO.AsString:=CreateNewGUID;
end;


procedure TDMPreco.DMPrecoCreate(Sender: TObject);
begin
dbPreco.AliasName := BDE_ALIAS_NAME;
end;

end.

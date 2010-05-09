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




unit DMRElNut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TDMRelNutrientes = class(TDataModule)
    TbNutrientes: TTable;
    TbNutrientesIDNUT: TStringField;
    TbNutrientesABREV: TStringField;
    TbNutrientesNOMENUT: TStringField;
    TbNutrientesUNIDADE: TStringField;
    TbTempAlinut: TTable;
    TbTempAlinutIDALI: TStringField;
    TbTempAlinutIDNUT: TStringField;
    TbTempAlinutVALOR: TFloatField;
    TbTempAlinutNutriente: TStringField;
    DSTempAliNut: TDataSource;
    DSAliNutAux: TDataSource;
    TbAliNutAux: TTable;
    TbAliNutAuxIDALI: TStringField;
    TbAliNutAuxIDNUT: TStringField;
    TbAliNutAuxVALOR: TFloatField;
    DSAliNut: TDataSource;
    TbAliNut: TTable;
    TbAliNutIDALI: TStringField;
    TbAliNutIDNUT: TStringField;
    TbAliNutVALOR: TFloatField;
    TbAliNutNutrientes: TStringField;
    DSNutrientes: TDataSource;
    TbAliNutUnidade: TStringField;
    DbRelNutrientes: TDatabase;
    qrAliNut: TQuery;
    procedure DMRelNutrientesCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMRelNutrientes: TDMRelNutrientes;

implementation

uses DMRelat, uAliasName;

{$R *.DFM}

procedure TDMRelNutrientes.DMRelNutrientesCreate(Sender: TObject);
begin
DbRelNutrientes.AliasName := BDE_ALIAS_NAME;
openAllTables(self);
end;

end.

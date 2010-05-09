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




unit DMRelat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TDMRelatAli = class(TDataModule)
    TbOrigem: TTable;
    TbOrigemIDORIG: TStringField;
    TbOrigemDESCRICAO: TStringField;
    DSIngredientes: TDataSource;
    DSSubIng: TDataSource;
    DSOrigem: TDataSource;
    DSGAlimentar: TDataSource;
    DSAlimGAlim: TDataSource;
    quAlimGAlim: TQuery;
    DSAlim: TDataSource;
    qrPreparac: TQuery;
    DSPreparac: TDataSource;
    DSAliPreco: TDataSource;
    TbAliPreco: TTable;
    TbAliPrecoIDALI: TStringField;
    TbAliPrecoIDMEDCAS: TStringField;
    TbAliPrecoQTDE: TFloatField;
    TbAliPrecoPRECO: TFloatField;
    TbAliPrecoMEDGR: TStringField;
    DBRelatAli: TDatabase;
    TbAliPrecoDATA: TDateTimeField;
    DSqrOrigem: TDataSource;
    qrOrigem: TQuery;
    qrOrigemNOME: TStringField;
    qrOrigemNOMESIMP: TStringField;
    qrOrigemDESCRICAO: TStringField;
    qrOrigemNOMEGRU: TStringField;
    TbAlim: TTable;
    TbAlimIDALI: TStringField;
    TbAlimNOME: TStringField;
    TbAlimNOMESIMP: TStringField;
    TbAlimIDORIG: TStringField;
    TbAlimIDGRUALI: TStringField;
    TbAlimTIPOALI: TStringField;
    TbAlimPREP: TStringField;
    TbAlimOBSALI: TStringField;
    TbGAlimentar: TTable;
    TbGAlimentarIDGRUALI: TStringField;
    TbGAlimentarNOMEGRU: TStringField;
    TbGAlimentarPROTAVB: TStringField;
    TbAlimGrupoAlimentar: TStringField;
    TbAlimOrigem: TStringField;
    procedure DMRelatAliCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMRelatAli: TDMRelatAli;

implementation

uses DMRelMed, uAliasName;

{$R *.DFM}

procedure TDMRelatAli.DMRelatAliCreate(Sender: TObject);
begin
  DBRelatAli.AliasName := BDE_ALIAS_NAME;
  openAllTables(self);
  qrPreparac.open;
  quAlimGAlim.open;
  qrOrigem.OPEN;
end;

end.

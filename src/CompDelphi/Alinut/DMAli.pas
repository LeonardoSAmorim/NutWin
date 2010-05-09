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




unit DMAli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, stdctrls;

type
  TDMAlimento = class(TDataModule)
    dsAlimento: TDataSource;
    dsGruAli: TDataSource;
    taAlimento: TTable;
    taGruAli: TTable;
    dsAliNut: TDataSource;
    taAliNut: TTable;
    taNut: TTable;
    dsNut: TDataSource;
    taNutIDNUT: TStringField;
    taNutABREV: TStringField;
    taNutNOMENUT: TStringField;
    taNutUNIDADE: TStringField;
    taGruAliIDGRUALI: TStringField;
    taGruAliNOMEGRU: TStringField;
    dsQAli: TDataSource;
    AliAux: TTable;
    dsOrigem: TDataSource;
    taOrigem: TTable;
    quNut: TQuery;
    quAli: TQuery;
    dsQNut: TDataSource;
    NutAux: TTable;
    StringField9: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    dsUsuario: TDataSource;
    taUsuario: TTable;
    taUsuarioUsername: TStringField;
    taUsuarioSenha: TStringField;
    dsQMed: TDataSource;
    quMed: TQuery;
    AliAuxIDALI: TStringField;
    AliAuxNOME: TStringField;
    AliAuxNOMESIMP: TStringField;
    AliAuxIDORIG: TStringField;
    AliAuxIDGRUALI: TStringField;
    AliAuxTIPOALI: TStringField;
    AliAuxPREP: TStringField;
    taAliNutIDALI: TStringField;
    taAliNutIDNUT: TStringField;
    taAliNutVALOR: TFloatField;
    quMedPESOTOTAL: TFloatField;
    quNutNOMENUT: TStringField;
    quNutVALOR: TFloatField;
    quNutUNIDADE: TStringField;
    quMedIDMEDCAS: TStringField;
    quMedMEDIDA: TStringField;
    quMedVALOR: TFloatField;
    taAliNutNOMEALI: TStringField;
    taAliNutNOMENUT: TStringField;
    taOrigemIDORIG: TStringField;
    taOrigemDESCRICAO: TStringField;
    dsAliMed: TDataSource;
    taAliMed: TTable;
    taAliMedIDALI: TStringField;
    taAliMedIDMEDCAS: TStringField;
    taAliMedVALOR: TFloatField;
    taAliMedORDPADRAO: TFloatField;
    taAlimentoIDALI: TStringField;
    taAlimentoNOME: TStringField;
    taAlimentoNOMESIMP: TStringField;
    taAlimentoIDORIG: TStringField;
    taAlimentoIDGRUALI: TStringField;
    taAlimentoTIPOALI: TStringField;
    taAlimentoPREP: TStringField;
    taAlimentoOBSALI: TStringField;
    DBAlimento: TDatabase;
    AliAuxOBSALI: TStringField;
    quAliIDALI: TStringField;
    quAliNOME: TStringField;
    quAliNOMESIMP: TStringField;
    quAliIDORIG: TStringField;
    quAliIDGRUALI: TStringField;
    quAliTIPOALI: TStringField;
    quAliPREP: TStringField;
    quAliOBSALI: TStringField;
    procedure quMedCalcFields(DataSet: TDataSet);
    procedure DMAlimentoCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    QtdeMedida : TEdit;
  end;

var
  DMAlimento: TDMAlimento;

implementation

{$R *.DFM}

uses uAliasName;

procedure TDMAlimento.quMedCalcFields(DataSet: TDataSet);
begin
   if QtdeMedida <> nil then
      quMed.FieldByName( 'PESOTOTAL' ).AsFloat := quMed.FieldByName( 'VALOR' ).AsFloat * StrToFloat( QtdeMedida.Text )
   else
      quMed.FieldByName( 'PESOTOTAL' ).AsFloat := 0;
end;

procedure TDMAlimento.DMAlimentoCreate(Sender: TObject);
//var
//   xDataBaseName : String;
begin
DBAlimento.AliasName := BDE_ALIAS_NAME;
{    xDataBaseName := 'DBCalculadora';
    taAlimento.DatabaseName := xDataBaseName;
    taGruAli.DatabaseName := xDataBaseName;
    taAliNut.DatabaseName := xDataBaseName;
    taNut.DatabaseName := xDataBaseName;
    AliAux.DatabaseName := xDataBaseName;
    taOrigem.DatabaseName := xDataBaseName;
    NutAux.DatabaseName := xDataBaseName;
    taUsuario.DatabaseName := xDataBaseName;
    quAli.DatabaseName := xDataBaseName;
    quNut.DatabaseName := xDataBaseName;
    quMed.DatabaseName := xDataBaseName;  }
end;

end.

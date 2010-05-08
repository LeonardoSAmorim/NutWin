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




unit DMRelSuCal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TDMRelSCAl = class(TDataModule)
    TbGAliCal: TTable;
    TbGAliCalIDGRUALI: TStringField;
    TbGAliCalIDGRUCAL: TStringField;
    TbGAliCalNomeGrupoAlim: TStringField;
    TbGAliCalNomeSubstitutoCal: TStringField;
    TbGruCal: TTable;
    TbGruCalNOME: TStringField;
    TbGruCalCALORIAS: TFloatField;
    TbGruCalIDGRUCAL: TStringField;
    TbGruCalNOMECAL: TStringField;
    TbAliGCal: TTable;
    TbAliGCalQTDE: TStringField;
    TbAliGCalIDALI: TStringField;
    TbAliGCalIDGRUCAL: TStringField;
    TbAliGCalIDMEDCAS: TStringField;
    TbAliGCalMEDGR: TStringField;
    TbGAlimentar: TTable;
    TbGAlimentarIDGRUALI: TStringField;
    TbGAlimentarNOMEGRU: TStringField;
    DSGAliCal: TDataSource;
    DSGruCal: TDataSource;
    DSAliGCal: TDataSource;
    TbGAliCalBk: TTable;
    StringField5: TStringField;
    TbGAliCalBkIDGRUALI: TStringField;
    TbGAliCalBkIDGRUCAL: TStringField;
    TbGAliCalBkNomeGrupoAlim: TStringField;
    DSGAlimentar: TDataSource;
    DSGAliCalbk: TDataSource;
    DSGruProt: TDataSource;
    DSAliGProt: TDataSource;
    DSGAliProt: TDataSource;
    DSGAliProtBk: TDataSource;
    DSGAlimentarProt: TDataSource;
    TbGruProt: TTable;
    TbGruProtIdGruProt: TStringField;
    TbGruProtNome: TStringField;
    TbGruProtProteinas: TFloatField;
    TbGruProtCalorias: TFloatField;
    TbGruProtNomeProt: TStringField;
    TbAliGProt: TTable;
    TbAliGProtIdali: TStringField;
    TbAliGProtIdGruProt: TStringField;
    TbAliGProtIdMedCas: TStringField;
    TbAliGProtQtde: TStringField;
    TbAliGProtMedGr: TStringField;
    TBGAlimentarProt: TTable;
    TBGAlimentarProtIDGRUALI: TStringField;
    TBGAlimentarProtNOMEGRU: TStringField;
    TbGAliProt: TTable;
    TbGAliProtIdGruAli: TStringField;
    TbGAliProtIdGruProt: TStringField;
    TbGAliProtNomeGruAlim: TStringField;
    TbGAliProtNomeGruProt: TStringField;
    TbGAliProtBk: TTable;
    TbGAliProtBkIdGruAli: TStringField;
    TbGAliProtBkIdGruProt: TStringField;
    TbGAliProtBkNomeGruAlim: TStringField;
    TbGAliProtBkNomeGruProt: TStringField;
    TbAliGCalNomeAli: TStringField;
    TbAliGCalNomeGruCal: TStringField;
    DSAlimento: TDataSource;
    TbAlimento: TTable;
    TbAlimentoNOME: TStringField;
    TbAlimentoNOMESIMP: TStringField;
    TbAlimentoIDGRUALI: TStringField;
    TbAlimentoTIPOALI: TStringField;
    DSMedidasCaseiras: TDataSource;
    TbMedidasCaseiras: TTable;
    TbMedidasCaseirasIDALI: TStringField;
    TbMedidasCaseirasIDMEDCAS: TStringField;
    TbMedidasCaseirasVALOR: TFloatField;
    TbMedidasCaseirasNomeMedida: TStringField;
    TbMedidas: TTable;
    TbMedidasMEDIDA: TStringField;
    DSMedidas: TDataSource;
    TbAliGCalMedidas: TStringField;
    TbAliGCalbk: TTable;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField9: TStringField;
    DSAliGCalbk: TDataSource;
    DSAliGProtbk: TDataSource;
    TbAliGProtbk: TTable;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    TbAliGProtbkNomeAli: TStringField;
    TbAliGProtbkNomeGruProt: TStringField;
    TbAliGProtbkMedidas: TStringField;
    TbAlimentoIDALI: TStringField;
    TbAlimentoIDORIG: TStringField;
    TbMedidasIDMEDCAS: TStringField;
    TbAlimentoPREP: TStringField;
    TbAlimentoOBSALI: TStringField;
    DBRelScal: TDatabase;
    TbAliGProtNomeGruProt: TStringField;
    DSqrsubscal: TDataSource;
    qrSubsCal: TQuery;
    qrSubsCalNOME: TStringField;
    qrSubsCalIDGRUCAL: TStringField;
    qrSubsCalNOME_1: TStringField;
    qrSubsCalMEDIDA: TStringField;
    qrSubsCalQTDE: TStringField;
    qrSubsCalMEDGR: TStringField;
    DSqrSubsProt: TDataSource;
    qrSubsProt: TQuery;
    qrSubsProtNOME: TStringField;
    qrSubsProtIDGRUPROT: TStringField;
    qrSubsProtNOME_1: TStringField;
    qrSubsProtMEDIDA: TStringField;
    qrSubsProtQTDE: TStringField;
    qrSubsProtMEDGR: TStringField;
    TbGruProtProtCalc: TStringField;
    TbGruCalREADONLY: TStringField;
    TbGruProtREADONLY: TStringField;
    TbGruCalCaloriaCalc: TStringField;
    qrSubsCalNOMESIMP: TStringField;
    qrSubsProtNOMESIMP: TStringField;
    qrSubsCalNomeCal: TStringField;
    qrSubsProtNomeProt: TStringField;
    procedure TbGruCalCalcFields(DataSet: TDataSet);
    procedure TbGruProtCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMRelSCAl: TDMRelSCAl;

implementation

uses DMRelMed, DMRelat;

{$R *.DFM}

procedure TDMRelSCAl.TbGruCalCalcFields(DataSet: TDataSet);
begin
    if TbGruCal.FieldByName('IDGRUCAL').asString = '{88DD9371-66F8-11D1-A6A0-008048B86BEE}' then  //	GRUPO A VONTADE
       begin
        TbGruCal.Fieldbyname('NOMECAL').asString := TbGruCal.Fieldbyname('NOME').asString +
                  ' (< ' + TbGruCal.Fieldbyname('CALORIAS').asString + ' kcal)';

        TbGruCal.Fieldbyname('CALORIACALC').asString := '< ' + TbGruCal.Fieldbyname('CALORIAS').asString ;
       end
    else
       begin
        TbGruCal.Fieldbyname('NOMECAL').asString := TbGruCal.Fieldbyname('NOME').asString +
                  ' (' + TbGruCal.Fieldbyname('CALORIAS').asString + ' kcal)';

        TbGruCal.Fieldbyname('CALORIACALC').asString := TbGruCal.Fieldbyname('CALORIAS').asString ;
       end;
end;

procedure TDMRelSCAl.TbGruProtCalcFields(DataSet: TDataSet);
var
 stProt : string;

begin
    if TbGruProt.Fieldbyname('Proteinas').asInteger < 0 then
       stProt := '< ' + InttoStr(ABS(TbGruProt.Fieldbyname('Proteinas').asInteger))
    else
       stProt := TbGruProt.Fieldbyname('Proteinas').asString ;

    TbGruProt.Fieldbyname('NomeProt').AsString := TbGruProt.Fieldbyname('Nome').AsString +
                  ' (' + stProt + 'g)/' +
                  ' (' + TbGruProt.Fieldbyname('Calorias').AsString + 'kcal)';

    TbGruProt.Fieldbyname('ProtCalc').asString := stProt;

end;

end.

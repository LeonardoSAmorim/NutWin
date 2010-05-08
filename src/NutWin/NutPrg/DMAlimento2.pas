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




unit DMAlimento2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, dbpersis;

type
  TDMAlim2 = class(TDataModule)
    TAlimento: TDSPersist;
    QAlimento: TQueryPersist;
    QAlimentoOUID: TStringField;
    QAlimentoNOME: TStringField;
    QAlimentoNOMESIMP: TStringField;
    QAlimentoIDORG: TStringField;
    QAlimentoIDGRUALI: TStringField;
    QAlimentoIDMEDPAD: TStringField;
    QAlimentoTIPOALI: TStringField;
    QAlimentoOUIDPai: TStringField;
    QAlimentoOrigem: TStringField;
    QAlimentoGrupoAlimentar: TStringField;
    UPAlimento: TUpdateObjectView;
    TbOrigem: TTable;
    TbOrigemIDORIG: TStringField;
    TbOrigemDESCRICAO: TStringField;
    DSOrigem: TDataSource;
    TbGAliCal: TTable;
    TbGAliCalID_GRUALI: TStringField;
    TbGAliCalID_GRUCAL: TStringField;
    TbGAliCalOLD_ID1: TIntegerField;
    TbGAliCalOLD_ID2: TStringField;
    TbGAliCalNomeGupoAlim: TStringField;
    TbGAliCalNomeSubstitutoCal: TStringField;
    TbGruCal: TTable;
    TbGruCalID_GRUCAL: TStringField;
    TbGruCalNOME: TStringField;
    TbGruCalCALORIAS: TFloatField;
    TbGruCalOLD_ID: TIntegerField;
    TbAliGCal: TTable;
    TbAliGCalQTDE: TStringField;
    TbAliGCalIDALI: TStringField;
    TbAliGCalIDGRUCAL: TStringField;
    TbAliGCalIDMEDCAS: TStringField;
    TbAliGCalGrposCal: TStringField;
    TbAliGCalMedidas: TStringField;
    TbGAlimentar: TTable;
    TbGAlimentarIDGRUALI: TStringField;
    TbGAlimentarNOMEGRU: TStringField;
    DSGAliCal: TDataSource;
    DSGruCal: TDataSource;
    DSGruAli: TDataSource;
    DSAliGCal: TDataSource;
    DSMedidasCaseiras: TDataSource;
    TbMedidasCaseiras: TTable;
    TbMedidasCaseirasIDALI: TStringField;
    TbMedidasCaseirasIDMEDCAS: TStringField;
    TbMedidasCaseirasVALOR: TFloatField;
    TbMedidasCaseirasNomeMedida: TStringField;
    TbMedidas: TTable;
    TbMedidasIDMED: TStringField;
    TbMedidasMEDIDA: TStringField;
    DSMedidas: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMAlim2: TDMAlim2;

implementation

uses DMAlim;

{$R *.DFM}

end.

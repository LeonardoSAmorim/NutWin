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




unit DMNutWin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, DB;

type
  TdmNut = class(TDataModule)
    taIndividuo: TTable;
    dsIndividuo: TDataSource;
    daTelefone: TDataSource;
    taTelefone: TTable;
    tb_Alimentos: TTable;
    tb_AlimentosCODALI: TAutoIncField;
    tb_AlimentosNOME: TStringField;
    tb_AlimentosNOMESIMP: TStringField;
    tb_AlimentosORIGEM: TStringField;
    tb_AlimentosGRUPO: TStringField;
    tb_AlimentosPREPARACAO: TBooleanField;
    tb_AlimentosCOR: TStringField;
    tb_AlimentosRECEITA: TMemoField;
    tb_AlimentosPESOFINAL: TFloatField;
    dsAlimentos: TDataSource;
    dsNutrientes: TDataSource;
    tb_Nutrientes: TTable;
    tb_NutrientesSIGLA: TStringField;
    tb_NutrientesDESCRICAO: TStringField;
    tb_NutrientesUNIDADE: TStringField;
    tb_NutrientesVALOR: TFloatField;
    tbMedidas: TTable;
    tbMedidasCODMED: TAutoIncField;
    tbMedidasNOME: TStringField;
    tbMedidasVALOR: TFloatField;
    tbMedidasUNIDADE: TStringField;
    dsMedidas: TDataSource;
    tbPreparacao: TTable;
    tbPreparacaoNOME: TStringField;
    tbPreparacaoQUANT: TFloatField;
    tbPreparacaoMEDIDA: TStringField;
    dsPreparacao: TDataSource;
    dsAvaliacao: TDataSource;
    taAvaliacao: TTable;
    taIndividuoCODIND: TAutoIncField;
    taIndividuoNOME: TStringField;
    taIndividuoSOBRENOME: TStringField;
    taIndividuoDATANASC: TDateField;
    taIndividuoNACIONALIDADE: TStringField;
    taIndividuoSEXO: TStringField;
    taIndividuoCOR: TStringField;
    taIndividuoENDERECO: TStringField;
    taIndividuoBAIRRO: TStringField;
    taIndividuoCEP: TStringField;
    taIndividuoCIDADE: TStringField;
    taIndividuoESTADO: TStringField;
    taIndividuoFOTO: TBlobField;
    taIndividuoATUALIZADO: TDateField;
    taIndividuoEMAIL: TStringField;
    taIndividuoOBS: TMemoField;
    taAvaliacaoCODIND: TIntegerField;
    taAvaliacaoTIPOPASTA: TStringField;
    taAvaliacaoDATA: TDateField;
    taAvaliacaoCONTEUDO: TMemoField;
    dsTabCor: TDataSource;
    taTabCor: TTable;
    taTabCorCOR: TStringField;
    taTabNacio: TTable;
    dsTabNacio: TDataSource;
    dsTabCidade: TDataSource;
    taTabCidade: TTable;
    taTabCidadeCIDADE: TStringField;
    taTabCidadeESTADO: TStringField;
    taTabNacioNACIONALIDADE: TStringField;
    taTabEstado: TTable;
    dsTabEstado: TDataSource;
    taTabEstadoESTADO: TStringField;
    taTelefoneCODIND: TIntegerField;
    taTelefoneCODTEL: TAutoIncField;
    taTelefoneTIPO: TStringField;
    taTelefoneTELEFONE: TStringField;
    taTelefoneRAMAL: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmNut: TdmNut;

implementation

{$R *.DFM}

end.

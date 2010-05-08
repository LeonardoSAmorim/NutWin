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





unit DMMedidas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, dbpersis, DBTables;

type
  TDMedidas = class(TDataModule)
    DSMedidasCaseiras: TDataSource;
    TbMedidasCaseiras: TTable;
    TbMedidasCaseirasIDALI: TStringField;
    TbMedidasCaseirasIDMEDCAS: TStringField;
    TbMedidasCaseirasVALOR: TFloatField;
    TbMedidasCaseirasNomeMedida: TStringField;
    TbMedidas: TTable;
    TbMedidasMEDIDA: TStringField;
    DSMedidas: TDataSource;
    DSMCIndexada: TDataSource;
    qrMedCIndexada: TQuery;
    qrMedCIndexadaMEDIDA: TStringField;
    qrMedCIndexadaVALOR: TFloatField;
    DSMCOrdPad: TDataSource;
    TbMCOrdPad: TTable;
    TbMCOrdPadIDALI: TStringField;
    TbMCOrdPadIDMEDCAS: TStringField;
    TbMCOrdPadVALOR: TFloatField;
    TbMCOrdPadORDPADRAO: TIntegerField;
    TbMCOrdPadNomeMedida: TStringField;
    TbMedidasIDMEDCAS: TStringField;
    qrMedCIndexadaIDALI: TStringField;
    qrMedCIndexadaIDMEDCAS: TStringField;
    procedure TbMedidasCaseirasNewRecord(DataSet: TDataSet);
    procedure TbMedidasNewRecord(DataSet: TDataSet);
    procedure TbMedidasCaseirasAfterPost(DataSet: TDataSet);
    procedure TbMedidasCaseirasBeforeDelete(DataSet: TDataSet);
    procedure DSMCIndexadaDataChange(Sender: TObject; Field: TField);
    procedure DSMCOrdPadDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMedidas: TDMedidas;

implementation

uses DMAliPrep, DMNutrien;



{$R *.DFM}

procedure TDMedidas.TbMedidasCaseirasNewRecord(DataSet: TDataSet);
begin
   TbMedidasCaseirasIDMEDCAS.AsString:=TDSPersist.CreateNewGUID;
end;

procedure TDMedidas.TbMedidasNewRecord(DataSet: TDataSet);
begin
    TbMedidasIDMEDCAS.AsString:=TDSPersist.CreateNewGUID;
end;

procedure TDMedidas.TbMedidasCaseirasAfterPost(DataSet: TDataSet);
begin
// O Refresh é dado nos bancos para que aparecam em Subst.Caloricos e Precos.
// Tudo relativo a Medidas Caseiras.
    DMNutrientes.TbMedNutr.Refresh;
    DMedidas.TbMedidasCaseiras.Refresh;
    DMAlimentos.TbMedidasCaseiras.Refresh;
    DMAlimentos.TbMCVisNut.Refresh;
    DMAlimentos.TbMCPreco.Refresh;
    DMAlimentos.TbMCSC.Refresh;
    DMAlimentos.TbMCSP.Refresh;
    DMedidas.TbMCOrdPad.Refresh;
end;

procedure TDMedidas.TbMedidasCaseirasBeforeDelete(DataSet: TDataSet);
begin
    DMAlimentos.ConfirmaDelecao ;
end;

procedure TDMedidas.DSMCIndexadaDataChange(Sender: TObject; Field: TField);
begin
if Field=nil then
   begin
   TbMedidasCaseiras.Locate ('IDMEDCAS',qrMedCIndexadaIDMEDCAS.AsString, []);
   end;
end;

procedure TDMedidas.DSMCOrdPadDataChange(Sender: TObject; Field: TField);
begin
   DMedidas.TbMedidasCaseiras.Locate('IDMEDCAS', DMedidas.TbMCOrdPadIDMEDCAS.asString,[]);
end;

end.

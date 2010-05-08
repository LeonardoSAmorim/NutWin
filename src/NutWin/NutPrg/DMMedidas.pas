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
  Db, NutCnst, DBTables;

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
    TbMCOrdPadNomeMedida: TStringField;
    TbMedidasIDMEDCAS: TStringField;
    qrMedCIndexadaIDALI: TStringField;
    qrMedCIndexadaIDMEDCAS: TStringField;
    DBMedidas: TDatabase;
    TbMCOrdPadORDPADRAO: TFloatField;
    TbMedidasCaseirasORDPADRAO: TFloatField;
    TbMedidasREADONLY: TStringField;
    TbMedidasCaseirasPORCAOPAD: TStringField;
    TbMedidasCaseirasREADONLY: TStringField;
    procedure TbMedidasCaseirasNewRecord(DataSet: TDataSet);
    procedure TbMedidasNewRecord(DataSet: TDataSet);
    procedure TbMedidasCaseirasAfterPost(DataSet: TDataSet);
    procedure DSMCIndexadaDataChange(Sender: TObject; Field: TField);
    procedure DSMCOrdPadDataChange(Sender: TObject; Field: TField);
    procedure TbMedidasCaseirasPostError(DataSet: TDataSet;
      E: EDatabaseError; var Action: TDataAction);
    procedure TbMedidasPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbMedidasBeforeDelete(DataSet: TDataSet);
    procedure TbMedidasCaseirasBeforeDelete(DataSet: TDataSet);
    procedure TbMedidasBeforeEdit(DataSet: TDataSet);
    procedure TbMedidasCaseirasBeforeEdit(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMedidas: TDMedidas;

 const
  {Declare constants we're interested in}
  eKeyViol = 9729;
  eRequiredFieldMissing = 9732;
  eForeignKey = 9733;
  eDetailsExist = 9734;



implementation

uses DMAliPrep, DMNutrien;



{$R *.DFM}

procedure TDMedidas.TbMedidasCaseirasNewRecord(DataSet: TDataSet);
begin
   TbMedidasCaseirasIDMEDCAS.AsString:=CreateNewGUID;
   TbMedidasCaseiras.Fieldbyname('READONLY').AsString  := 'F';
end;

procedure TDMedidas.TbMedidasNewRecord(DataSet: TDataSet);
begin
    TbMedidasIDMEDCAS.AsString:=CreateNewGUID;
    TbMedidas.Fieldbyname('READONLY').AsString  := 'F';
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

procedure TDMedidas.DSMCIndexadaDataChange(Sender: TObject; Field: TField);
begin
if Field=nil then
   begin
   DMedidas.TbMedidasCaseiras.Locate ('IDALI;IDMEDCAS', VarArrayOf([DMAlimentos.TbAlimento['IDALI'],DMedidas.qrMedCIndexada['IDMEDCAS']]), []);
   end;
end;

procedure TDMedidas.DSMCOrdPadDataChange(Sender: TObject; Field: TField);
begin
   DMedidas.TbMedidasCaseiras.Locate('IDALI;IDMEDCAS', VarArrayOf([DMAlimentos.TbAlimento['IDALI'],DMedidas.TbMCOrdPad['IDMEDCAS']]),[]);
end;

procedure TDMedidas.TbMedidasCaseirasPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);

var
 iDBIError: Integer;
begin
  if (E is EDBEngineError) then
  begin
    iDBIError := (E as EDBEngineError).Errors[0].Errorcode;
    case iDBIError of
      eKeyViol:
        begin

          MessageDlg(' A Medida ' + Dataset.FieldByName('NomeMedida').asString + ' já foi cadastrada. ', mtWarning,
            [mbOK], 0);

            Action := daAbort;

        end;
    end;
  end;
end;

procedure TDMedidas.TbMedidasPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
 ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMedidas.TbMedidasBeforeDelete(DataSet: TDataSet);
begin
   if TbMedidas.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Esta informação não pode ser apagada.');
       Abort;
      end;
end;

procedure TDMedidas.TbMedidasCaseirasBeforeDelete(DataSet: TDataSet);
begin
   if TbMedidasCaseiras.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Esta informação não pode ser apagada.');
       Abort;
      end;
end;

procedure TDMedidas.TbMedidasBeforeEdit(DataSet: TDataSet);
begin
   if TbMedidas.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Esta informação não pode ser editada.');
       Abort;
      end;
end;

procedure TDMedidas.TbMedidasCaseirasBeforeEdit(DataSet: TDataSet);
begin
   if TbMedidasCaseiras.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Esta informação não pode ser editada.');
       Abort;
      end;
end;

end.

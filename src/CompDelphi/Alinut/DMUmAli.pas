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




{ **********************************************************************}
{                                                                       }
{   Datamodule do TAlimento                                             }
{                                                                       }
{   Acesso as tabelas de Alimentos                                      }
{                                                                       }
{   Copyright © 1998 by DIS-EPM/UNIFESP                                 }
{                                                                       }
{ **********************************************************************}

unit DMUmAli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, NutCnst;

type
  TNotifyPesoAlimento = procedure (Sender: TObject; var Peso : Double ) of object;

  TDMUmAlimento = class(TDataModule)
    dsAlimento: TDataSource;
    taAlimento: TTable;
    taAlimentoIDALI: TStringField;
    taAlimentoNOME: TStringField;
    taAlimentoNOMESIMP: TStringField;
    taAlimentoIDORIG: TStringField;
    taAlimentoIDGRUALI: TStringField;
    taAlimentoTIPOALI: TStringField;
    taAlimentoPREP: TStringField;
    taAlimentoOBSALI: TStringField;
    quNut: TQuery;
    dsQNut: TDataSource;
    dsQMed: TDataSource;
    quMed: TQuery;
    dsGruEquEnergia: TDataSource;
    quGruEquEnergia: TQuery;
    quGruEquEnergiaNOME: TStringField;
    quGruEquEnergiaCALORIAS: TFloatField;
    quGruEquEnergiaIDGRUCAL: TStringField;
    quGruEquEnergiaVALOR: TFloatField;
    dsAliEquEnergia: TDataSource;
    quAliEquEnergia: TQuery;
    dsGruEquProteina: TDataSource;
    quGruEquProteina: TQuery;
    StringField1: TStringField;
    FloatField2: TFloatField;
    StringField2: TStringField;
    FloatField3: TFloatField;
    quAliEquProteina: TQuery;
    dsAliEquProteina: TDataSource;
    taCfgNut: TTable;
    dsCfgNut: TDataSource;
    taCfgNutIDNUT: TStringField;
    taCfgNutNOMENUT: TStringField;
    taCfgNutUNIDADE: TStringField;
    taCfgNutORDPADRAO: TFloatField;
    taCfgNutVISIVEL: TStringField;
    taCfgNutIDORIG: TStringField;
    taCfgNutABREV: TStringField;
    quNutABREV: TStringField;
    quNutNOMENUT: TStringField;
    quNutVALOR: TFloatField;
    quNutUNIDADE: TStringField;
    quNutVLRMED: TFloatField;
    quMedNut: TQuery;
    quAliEquEnergiaQTDE: TStringField;
    quAliEquEnergiaMEDGR: TStringField;
    quAliEquEnergiaMEDIDA: TStringField;
    quAliEquEnergiaIDGRUCAL: TStringField;
    quAliEquEnergiaIDALI: TStringField;
    quAliEquEnergiaNOME: TStringField;
    quAliEquEnergiaNOMESIMP: TStringField;
    quAliEquEnergiaEENOME: TStringField;
    quAliEquEnergiaEEMEDIDA: TStringField;
    quAliEquEnergiaEEQTDE: TStringField;
    quAliEquEnergiaEEMEDGR: TStringField;
    quGruEquEnergiaEQUIVALENCIA: TStringField;
    quGruEquEnergiaMEDGR: TStringField;
    quGruEquEnergiaSINALCAL: TStringField;
    quGruEquProteinaEQUIVALENCIA: TStringField;
    quGruEquProteinaSINALPROT: TStringField;
    quGruEquProteinaMEDGR: TStringField;
    quAliEquProteinaNOME: TStringField;
    quAliEquProteinaNOMESIMP: TStringField;
    quAliEquProteinaIDGRUPROT: TStringField;
    quAliEquProteinaMEDIDA: TStringField;
    quAliEquProteinaQTDE: TStringField;
    quAliEquProteinaMEDGR: TStringField;
    quAliEquProteinaIDALI: TStringField;
    quAliEquProteinaEPNOME: TStringField;
    quAliEquProteinaEPQTDE: TStringField;
    quAliEquProteinaEPMEDIDA: TStringField;
    quAliEquProteinaEPMEDGR: TStringField;
    quGruEquProteinaCALORIAS: TFloatField;
    DBUmAlimento: TDatabase;
    procedure quAliEquEnergiaCalcFields(DataSet: TDataSet);
    procedure quGruEquProteinaCalcFields(DataSet: TDataSet);
    procedure quAliEquProteinaCalcFields(DataSet: TDataSet);
    procedure quNutCalcFields(DataSet: TDataSet);
    procedure quGruEquEnergiaCalcFields(DataSet: TDataSet);
    procedure GruEquEnergiaCalcFields(DataSet: TDataSet);
    procedure GruEquProteinaCalcFields(DataSet: TDataSet);
    procedure DMUmAlimentoCreate(Sender: TObject);
  private
    FQtdeMedida: String;
    FPesoAli: Double;
    FQtdeMedidaAli: Double;
    FMedidaEmGramas: Boolean;
    FOnPesoAlimento: TNotifyPesoAlimento;
    procedure SetQtdeMedida(const Value: String);
    procedure SetPesoAli(const Value: Double);
    procedure SetQtdeMedidaAli(const Value: Double);
    procedure SetMedidaEmGramas(const Value: Boolean);
    procedure SetOnPesoAlimento(const Value: TNotifyPesoAlimento);
  public
    property OnPesoAlimento : TNotifyPesoAlimento read FOnPesoAlimento write SetOnPesoAlimento;
    property MedidaEmGramas : Boolean read FMedidaEmGramas write SetMedidaEmGramas;
    property QtdeMedida : String read FQtdeMedida write SetQtdeMedida;
    property PesoAli : Double read FPesoAli write SetPesoAli;
    property QtdeMedidaAli : Double read FQtdeMedidaAli write SetQtdeMedidaAli;
    procedure GetEquProteinaCalcFields(DataSet: TDataSet; Peso : Double);
    procedure GetEquEnergiaCalcFields(DataSet: TDataSet; Peso : Double);
  end;

var
  DMUmAlimento: TDMUmAlimento;

implementation

uses uAliasName;

{$R *.DFM}

procedure TDMUmAlimento.quGruEquEnergiaCalcFields(DataSet: TDataSet);
var
   Porcao, Peso : Double;
   Sinal : String;
begin
  if Assigned( OnPesoAlimento ) then
     OnPesoAlimento( self, Peso )
  else
     Peso := 0;

  GetEquEnergiaCalcFields(DataSet, Peso);

end;

procedure TDMUmAlimento.quAliEquEnergiaCalcFields(DataSet: TDataSet);
begin
     with DataSet do
     begin
        if FieldByName( 'NOMESIMP' ).AsString = '' then
           FieldByName( 'EENOME' ).AsString := FieldByName( 'NOME' ).AsString
        else
           FieldByName( 'EENOME' ).AsString := FieldByName( 'NOMESIMP' ).AsString;
        if FieldByName( 'IDGRUCAL' ).AsString <> '{88DD9371-66F8-11D1-A6A0-008048B86BEE}' then
           FieldByName( 'EEQTDE' ).AsString := FieldByName( 'QTDE' ).AsString
        else
           FieldByName( 'EEQTDE' ).AsString := '-----';
        if FieldByName( 'IDGRUCAL' ).AsString <> '{88DD9371-66F8-11D1-A6A0-008048B86BEE}' then
           FieldByName( 'EEMEDIDA' ).AsString := FieldByName( 'MEDIDA' ).AsString
        else
           FieldByName( 'EEMEDIDA' ).AsString := '--------------';
        if FieldByName( 'IDGRUCAL' ).AsString <> '{88DD9371-66F8-11D1-A6A0-008048B86BEE}' then
           FieldByName( 'EEMEDGR' ).AsString := FieldByName( 'MEDGR' ).AsString
        else
           FieldByName( 'EEMEDGR' ).AsString := '----';
     end;
end;

procedure TDMUmAlimento.quGruEquProteinaCalcFields(DataSet: TDataSet);
var
   Peso : Double;
begin
{   if Peso = 0 then
      Peso := 100;
   DataSet.FieldByName( 'PORCAOALI' ).AsFloat := Round5( Peso * ( DataSet.FieldByName( 'VALOR' ).AsFloat /
                                                                  DataSet.FieldByName( 'PROTEINAS' ).AsFloat ) / 100 );
}
  if Assigned( OnPesoAlimento ) then
     OnPesoAlimento( self, Peso )
  else
     Peso := 0;

  GetEquProteinaCalcFields(DataSet, Peso);

end;

procedure TDMUmAlimento.quAliEquProteinaCalcFields(DataSet: TDataSet);
begin
     with DataSet do
     begin
        if FieldByName( 'NOMESIMP' ).AsString = '' then
           FieldByName( 'EPNOME' ).AsString := FieldByName( 'NOME' ).AsString
        else
           FieldByName( 'EPNOME' ).AsString := FieldByName( 'NOMESIMP' ).AsString;
        FieldByName( 'EPQTDE' ).AsString := FieldByName( 'QTDE' ).AsString;
        FieldByName( 'EPMEDIDA' ).AsString := FieldByName( 'MEDIDA' ).AsString;
        FieldByName( 'EPMEDGR' ).AsString := FieldByName( 'MEDGR' ).AsString;
     end;
end;

procedure TDMUmAlimento.SetQtdeMedida(const Value: String);
begin
   FQtdeMedida := Value;
end;

procedure TDMUmAlimento.quNutCalcFields(DataSet: TDataSet);
begin
   if not FMedidaEmGramas then // não é em gramas
   begin
      if not quMedNut.IsEmpty then  // tem medidas
      begin
         FPesoAli := quMedNut.FieldByName('VALOR').AsFloat;
         DataSet.FieldByName( 'VLRMED' ).AsString := FormatFloat( '###0.00', DataSet.FieldByName( 'VALOR' ).AsFloat/100*FPesoAli*FQtdeMedidaAli );
      end;
   end
   else // em gramas
      if ( FPesoAli > 0 ) then
         DataSet.FieldByName( 'VLRMED' ).AsString := FormatFloat( '###0.00', DataSet.FieldByName( 'VALOR' ).AsFloat/100*FPesoAli );
end;

procedure TDMUmAlimento.SetPesoAli(const Value: Double);
begin
  FPesoAli := Value;
end;

procedure TDMUmAlimento.SetQtdeMedidaAli(const Value: Double);
begin
  FQtdeMedidaAli := Value;
end;

procedure TDMUmAlimento.SetMedidaEmGramas(const Value: Boolean);
begin
  FMedidaEmGramas := Value;
end;

procedure TDMUmAlimento.SetOnPesoAlimento(
  const Value: TNotifyPesoAlimento);
begin
  FOnPesoAlimento := Value;
end;

procedure TDMUmAlimento.GruEquEnergiaCalcFields(DataSet: TDataSet);
begin
   quGruEquEnergiaCalcFields(DataSet);
end;

procedure TDMUmAlimento.GruEquProteinaCalcFields(DataSet: TDataSet);
begin
   quGruEquProteinaCalcFields(DataSet);
end;

procedure TDMUmAlimento.GetEquEnergiaCalcFields(DataSet: TDataSet;
  Peso: Double);
var
   Porcao : Double;
   Sinal : String;
begin

  Sinal := '';
  if (DataSet.FieldByName( 'MEDGR' ).AsString <> '') and
     (DataSet.FieldByName( 'MEDGR' ).AsFloat > 0) then
     Porcao := Round5(Peso / DataSet.FieldByName( 'MEDGR' ).AsFloat)
  else
     Porcao := 0;
     if DataSet.FieldByName( 'IDGRUCAL' ).AsString = '{88DD9371-66F8-11D1-A6A0-008048B86BEE}' then
     begin
        DataSet.FieldByName( 'EQUIVALENCIA' ).AsString := 'ou o ' + DataSet.FieldByName( 'NOME' ).AsString;
        Sinal := '< ';
     end
     else if Porcao >= 2 then
        DataSet.FieldByName( 'EQUIVALENCIA' ).AsString := 'ou ' + FloatToStr( Porcao ) +
                                  ' porções do ' + DataSet.FieldByName( 'NOME' ).AsString
     else
        DataSet.FieldByName( 'EQUIVALENCIA' ).AsString := 'ou ' + FloatToStr( Porcao ) +
                                  ' porção do ' + DataSet.FieldByName( 'NOME' ).AsString;
     DataSet.FieldByName( 'SINALCAL' ).AsString := Sinal + DataSet.FieldByName( 'CALORIAS' ).AsString + ' kcal'
end;

procedure TDMUmAlimento.GetEquProteinaCalcFields(DataSet: TDataSet; Peso : Double);
var
   Porcao : Double;
begin
  DataSet.FieldByName( 'SINALPROT' ).AsString := ' ';
  if (DataSet.FieldByName( 'MEDGR' ).AsString <> '') and
     (DataSet.FieldByName( 'MEDGR' ).AsFloat > 0) then
     Porcao := Round5(Peso / DataSet.FieldByName( 'MEDGR' ).AsFloat)
  else
     Porcao := 0;
{  if Porcao <> Trunc( Porcao ) then
  begin
     if (( Porcao - Trunc( Porcao ) ) * 10 ) > 5 then
        Porcao := Trunc(Porcao) + 1
     else
        Porcao := Trunc(Porcao) + 0.5;
  end;}
     if DataSet.FieldByName( 'PROTEINAS' ).AsFloat < 0 then
        DataSet.FieldByName( 'SINALPROT' ).AsString := '< ' +  FloatToStr(ABS( DataSet.FieldByName( 'PROTEINAS' ).AsFloat ) )+ ' g / ' +
                                                       DataSet.FieldByName( 'CALORIAS' ).AsString + ' kcal'
     else
        DataSet.FieldByName( 'SINALPROT' ).AsString := FloatToStr(ABS( DataSet.FieldByName( 'PROTEINAS' ).AsFloat ) )+ ' g / ' +
                                                       DataSet.FieldByName( 'CALORIAS' ).AsString + ' kcal';
     if Porcao >= 2 then
        DataSet.FieldByName( 'EQUIVALENCIA' ).AsString := 'ou ' + FloatToStr( Porcao ) +
                                  ' porções do ' + DataSet.FieldByName( 'NOME' ).AsString
     else
        DataSet.FieldByName( 'EQUIVALENCIA' ).AsString := 'ou ' + FloatToStr( Porcao ) +
                                  ' porção do ' + DataSet.FieldByName( 'NOME' ).AsString;
end;

procedure TDMUmAlimento.DMUmAlimentoCreate(Sender: TObject);
begin
DBUmAlimento.AliasName := BDE_ALIAS_NAME;
openAllTables(Self);


end;

end.

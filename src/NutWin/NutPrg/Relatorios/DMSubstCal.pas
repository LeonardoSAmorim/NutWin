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




unit DMSubstCal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, dbpersis;

type
  TDMSubsCalorico = class(TDataModule)
    TbGAliCal: TTable;
    TbGruCal: TTable;
    TbGruCalNOME: TStringField;
    TbGruCalCALORIAS: TFloatField;
    TbGruCalOLD_ID: TIntegerField;
    TbAliGCal: TTable;
    TbAliGCalQTDE: TStringField;
    TbAliGCalIDALI: TStringField;
    TbAliGCalIDGRUCAL: TStringField;
    TbAliGCalIDMEDCAS: TStringField;
    TbGAlimentar: TTable;
    TbGAlimentarIDGRUALI: TStringField;
    TbGAlimentarNOMEGRU: TStringField;
    DSGAliCal: TDataSource;
    DSGruCal: TDataSource;
    DSAliGCal: TDataSource;
    TbGAliCalBk: TTable;
    StringField5: TStringField;
    DSGAlimentar: TDataSource;
    DSGAliCalbk: TDataSource;
    TbGAliCalIDGRUALI: TStringField;
    TbGAliCalIDGRUCAL: TStringField;
    TbGruCalIDGRUCAL: TStringField;
    TbGAliCalNomeGrupoAlim: TStringField;
    TbGAliCalBkIDGRUALI: TStringField;
    TbGAliCalBkIDGRUCAL: TStringField;
    TbGAliCalNomeSubstitutoCal: TStringField;
    TbGAliCalBkNomeGrupoAlim: TStringField;
    TbAliGCalMEDGR: TStringField;
    TbGruCalNOMECAL: TStringField;
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
    procedure TbMedidasNewRecord(DataSet: TDataSet);
    procedure TbAliGCalAfterInsert(DataSet: TDataSet);
    procedure TbGruCalCalcFields(DataSet: TDataSet);
    procedure TbAliGCalCalcFields(DataSet: TDataSet);
    procedure TbGruProtCalcFields(DataSet: TDataSet);
    procedure TbAliGProtxAfterInsert(DataSet: TDataSet);
    procedure TbGruProtNewRecord(DataSet: TDataSet);
    procedure TbAliGCalBeforeDelete(DataSet: TDataSet);
    procedure TbAliGProtxBeforeDelete(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    // para substitutos calóricos
    function SubstitutosCaloricos( CodGruAli : String ) : TStrings;

    function CalGruSubs( GrupoCalorico : String ) : String;
    function Equivalente( ValGrupo : String ; ValAli100 : String): String;
    function AproximaMedida( Equivalente : String; GrMedida : String ) : String;
    function AchaMedida(  Valor : String ) : TStringList ;
  end;

var
  DMSubsCalorico: TDMSubsCalorico;

implementation

uses DMAliPrep, DMMedidas, DMNutrien, Alimento;

{$R *.DFM}

procedure TDMSubsCalorico.TbMedidasNewRecord(DataSet: TDataSet);
begin
   DMedidas.TbMedidasIDMEDCAS.AsString:=TDSPersist.CreateNewGUID;
end;

function TDMSubsCalorico.SubstitutosCaloricos( CodGruAli : String ) : TStrings;
// Enche um stringlist com os nomes dos grupos substitutos para cada alimento.
// Tem a funcao de lookup
{var
   LsCodAli : String;
begin
    LsCodAli := CodGruAli;
    // A Tabela ja' esta' indexada pelo codigo do grupo alimentar
    Result := TStringList.Create;
    Result.Clear;
    With DMSubsCalorico.TbGAliCalBk do
    begin
      if Locate('IDGRUALI', CodGruAli,[]) then
         begin
          While LsCodAli = CodGruAli do
            begin
              Result.Add( Fieldbyname('NomeCal').asString );
              Next;
              LsCodAli := Fieldbyname('IDGRUCAL').asString ;
            end;
          end
      else
         Result.Add( '' );
    end;

end;}
begin
end;


function TDMSubsCalorico.CalGruSubs ( GrupoCalorico : String ) : String;
// Localiza o valor das calorias do grupo de substitutos caloricos.
begin
{  If DMSubsCalorico.TbGruCal.Locate( 'NOME', GrupoCalorico, []) then
     begin
        CalGruSubs := DMSubsCalorico.TbGruCal.FieldByName('CALORIAS').asString;
     end
  else
     begin
       CalGruSubs := '  ' ;
       ShowMessage('Cadastre as Energias para o grupo '+ GrupoCalorico);
     end; }
end;


function TDMSubsCalorico.Equivalente( ValGrupo : String ; ValAli100 : String): String;
// Calcula a Fórmula de Equivalencia, documentada no Formula.doc
// Gera a quantidade do alimento para pertencer ao grupo escolhido
begin
    if StrtoFloat(ValAli100) <> StrtoFloat('0') then
       Equivalente := FloattoStrF( StrtoFloat(ValGrupo) * 100 / StrtoFloat(ValAli100), ffGeneral, 3, 3)
    else
       Equivalente := '0' ;
end;

function TDMSubsCalorico.AproximaMedida ( Equivalente : String; GrMedida : String ) : String;
begin
   if (GrMedida <> '') and (Equivalente <> '') then
      AproximaMedida := FloattoStrF( StrtoFloat(Equivalente)/StrtoFloat(GrMedida),ffGeneral,3,3 )
   else
      AproximaMedida := '' ;
end;

function TDMSubsCalorico.AchaMedida (  Valor : String ) : TStringList;
// Acha qual a quantidade da medida caseira mais proxima para a substituicao calorica
var
flValor : Real;
begin
  // stIntervalo := TstIntervalo.Create;
  Result := TStringList.Create;
  if valor <> '' then
  begin
    flValor := StrtoFloat(Valor);

    If Frac(flValor) < StrtoFloat('0,6') then
       begin
         // Caso a medida seja menor que 0,6 arredondo para 0,5
         // Se o inteiro da medida for maior que 0, dou duas opcoes : 0,0 e 0,5
         If Int(flvalor) = StrtoFloat('0') then
            Result.Add( FloattoStr( STrtoFloat('0,5')))
         else  // para inteiro maior que zero
            begin
              if Frac(flValor) = StrtoFloat('0,0') then
                 Result.Add( FloattoStr(Int(flvalor) + STrtoFloat('0,0')))
              else
                 begin
                 Result.Add( FloattoStr(Int(flvalor) + STrtoFloat('0,0')));
                 Result.Add( FloattoStr(Int(flvalor) + STrtoFloat('0,5')));
                 end;
            end;
       end
    else   // para maior que 0,6
      Begin
        If Frac(flValor) > STrtoFloat('0,8') then
            Result.Add ( FloattoStr(Int(flvalor) + STrtoFloat('1,0')))
        else
           begin
             Result.Add( FloattoStr(Int(flvalor) + STrtoFloat('0,5')));
             Result.Add( FloattoStr(Int(flvalor) + STrtoFloat('1,0')));
           end;
      end;
   end
   else
      Result.Add( FloattoStr(STrtoFloat('0,0')));


end;

procedure TDMSubsCalorico.TbAliGCalAfterInsert(DataSet: TDataSet);
begin
   if TbAliGCal.RecordCount = 1 then
      begin
       ShowMessage('Só está disponível o cadastramento de 1 único registro para Equivalentes Energéticos');
       TbAliGCal.Cancel;
      end;
end;

procedure TDMSubsCalorico.TbGruCalCalcFields(DataSet: TDataSet);
begin
    DMSubsCalorico.TbGruCalNOMECAL.asString := DMSubsCalorico.TbGruCalNOME.asString +
                  ' (' + DMSubsCalorico.TbGruCalCALORIAS.asString + ' g)';
end;

procedure TDMSubsCalorico.TbAliGCalCalcFields(DataSet: TDataSet);

{var
  Nut : string;
 }
begin
 {  DMSubsCalorico.TbAliNutSCal.First;
   Nut := '0' ;
   While not DMSubsCalorico.TbAliNutSCal.EOF do
       begin
       if DMSubsCalorico.TbAliNutSCalNutrientes.asString = 'Calorias' then
          Nut := DMSubsCalorico.TbAliNutSCalVALOR.asString ;
       end;
   DMSubsCalorico.TbAliGCalCal100gr.asString := Nut;
  }
end;

procedure TDMSubsCalorico.TbGruProtCalcFields(DataSet: TDataSet);
begin
    DMSubsCalorico.TbGruProtNomeProt.AsString := DMSubsCalorico.TbGruProtNome.AsString +
                  ' (' + DMSubsCalorico.TbGruProtProteinas.AsString + ' g)';

end;

procedure TDMSubsCalorico.TbAliGProtxAfterInsert(DataSet: TDataSet);
begin
   if TbAliGProt.RecordCount = 1 then
      begin
       ShowMessage('Só está disponível o cadastramento de 1 único registro para Substitutos Proteicos');
       TbAliGProt.Cancel;
      end;
end;

procedure TDMSubsCalorico.TbGruProtNewRecord(DataSet: TDataSet);
begin
   TbGruProtIdGruProt.AsString  := TDSPersist.CreateNewGUID;
end;

procedure TDMSubsCalorico.TbAliGCalBeforeDelete(DataSet: TDataSet);
begin
    DMAlimentos.ConfirmaDelecao ;
end;

procedure TDMSubsCalorico.TbAliGProtxBeforeDelete(DataSet: TDataSet);
begin
    DMAlimentos.ConfirmaDelecao ;
end;

end.

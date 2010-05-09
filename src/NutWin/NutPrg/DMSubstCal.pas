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
  Db, DBTables, NutCnst, Wizard;

type
  TDMSubsCalorico = class(TDataModule)
    TbGAliCal: TTable;
    TbGruCal: TTable;
    TbGruCalNOME: TStringField;
    TbGruCalCALORIAS: TFloatField;
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
    DbSubsCalorica: TDatabase;
    TbAliGCalMedidaCaseira: TStringField;
    TbAliGCalNomeGruCal: TStringField;
    TbAliGProtNomeGruProt: TStringField;
    TbAliGProtMedidaCaseira: TStringField;
    EEWiz: TNewWizard;
    EPWiz: TNewWizard;
    TbGAliProtValorCaloria: TFloatField;
    TbGruProtProtCalc: TStringField;
    TbGruCalCaloriaCalc: TStringField;
    TbGruCalREADONLY: TStringField;
    TbAliGCalREADONLY: TStringField;
    TbGAliCalREADONLY: TStringField;
    TbGAliCalBkREADONLY: TStringField;
    TbGAlimentarPROTAVB: TStringField;
    TbGAlimentarREADONLY: TStringField;
    TbGruProtREADONLY: TStringField;
    TbAliGProtREADONLY: TStringField;
    TbGAliProtREADONLY: TStringField;
    TbGAliProtBkREADONLY: TStringField;
    TBGAlimentarProtPROTAVB: TStringField;
    TBGAlimentarProtREADONLY: TStringField;
    procedure TbMedidasNewRecord(DataSet: TDataSet);
    procedure TbGruCalCalcFields(DataSet: TDataSet);
    procedure TbGruProtCalcFields(DataSet: TDataSet);
    procedure TbAliGProtxAfterInsert(DataSet: TDataSet);
    procedure TbGruProtNewRecord(DataSet: TDataSet);
    procedure TbGruProtBeforeDelete(DataSet: TDataSet);
    procedure TbGruCalBeforeDelete(DataSet: TDataSet);
    procedure TbGruCalNewRecord(DataSet: TDataSet);
    procedure TbGAlimentarNewRecord(DataSet: TDataSet);
    procedure TbGruCalPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbGAlimentarPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbGAliCalBkPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbGruProtPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbGAliProtBkPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure TbGAliCalBkBeforeDelete(DataSet: TDataSet);
    procedure TbGAliProtBkBeforeDelete(DataSet: TDataSet);
    procedure TbGAliCalBkNewRecord(DataSet: TDataSet);
    procedure TbGAliProtBkNewRecord(DataSet: TDataSet);
    procedure TbAliGCalNewRecord(DataSet: TDataSet);
    procedure TbAliGProtNewRecord(DataSet: TDataSet);
    procedure TbGruCalBeforeEdit(DataSet: TDataSet);
    procedure TbGAliCalBkBeforeEdit(DataSet: TDataSet);
    procedure TbGruProtBeforeEdit(DataSet: TDataSet);
    procedure TbGAliProtBkBeforeEdit(DataSet: TDataSet);
    procedure DMSubsCaloricoCreate(Sender: TObject);
  private
    { Private declarations }

    stCalGr  : string;
    FEmGramas: boolean;
    procedure SetEmGramas(const Value: boolean);

  public
    { Public declarations }
    // para substitutos calóricos
    stCal    : string;
    stCalParaProteina : string;
    stMedCasCal : string;
    stMedCasProt : string ;
    stProt   : string;
    stProtGr : string;
    stEquivalente : string;

    function SubstitutosCaloricos( CodGruAli : String ) : TStrings;

    function Equivalente( ValGrupo : String ; ValAli100 : String): String;
    function AproximaMedida( Equivalente : String; GrMedida : String ) : String;
    function AchaMedida(  Valor : String ) : TStringList ;

    // Novas rotinas
    function Calorias100gr( stAlimento : string ) : string;

    // Equivalentes de Energia
    function SCEquiv : string;
    function SCEquivParaProteina : string;
    procedure SCMedCas;
    function SCTotal( stMedGr : String ; stQtde : String ) : String;
    function SPTotal( stMedGr : String ; stQtde : String ) : String;

    // Equivalentes de Proteina
    function SPEquiv : string;
    procedure SPMedCas;

   property EmGramas : boolean read FEmGramas write SetEmGramas;
  end;

var
  DMSubsCalorico: TDMSubsCalorico;

implementation

uses DMAliPrep, DMMedidas, DMNutrien, Alimento, uAliasName;

{$R *.DFM}

procedure TDMSubsCalorico.TbMedidasNewRecord(DataSet: TDataSet);
begin
   DMedidas.TbMedidasIDMEDCAS.AsString:=CreateNewGUID;
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

function TDMSubsCalorico.Equivalente( ValGrupo : String ; ValAli100 : String): String;
// Calcula a Fórmula de Equivalencia, documentada no Formula.doc
// Gera a quantidade do alimento para pertencer ao grupo escolhido

begin
    if StrtoFloat(ValAli100) <> StrtoFloat('0') then
//       Equivalente := FloattoStrF( StrtoFloat(ValGrupo) * 100 / StrtoFloat(ValAli100), ffGeneral, 5, 3)
       Equivalente := FormatFloat( '0.0', ABS( StrtoFloat(ValGrupo) * 100 / StrtoFloat(ValAli100)))
    else
       Equivalente := '0' ;
end;

function TDMSubsCalorico.AproximaMedida ( Equivalente : String; GrMedida : String ) : String;
begin
   if (GrMedida <> '') and (Equivalente <> '') then
//      AproximaMedida := FloattoStrF( StrtoFloat(Equivalente)/StrtoFloat(GrMedida),ffGeneral,3,3)
      AproximaMedida := FormatFloat( '0.0', StrtoFloat(Equivalente)/StrtoFloat(GrMedida))
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

procedure TDMSubsCalorico.TbGruCalCalcFields(DataSet: TDataSet);
begin
    if TbGruCal.FieldByName('IDGRUCAL').asString = '{88DD9371-66F8-11D1-A6A0-008048B86BEE}' then  //	GRUPO A VONTADE
       begin
        DMSubsCalorico.TbGruCal.Fieldbyname('NOMECAL').asString := DMSubsCalorico.TbGruCal.Fieldbyname('NOME').asString +
                  ' (< ' + DMSubsCalorico.TbGruCal.Fieldbyname('CALORIAS').asString + ' kcal)';

        DMSubsCalorico.TbGruCal.Fieldbyname('CALORIACALC').asString := '< ' + DMSubsCalorico.TbGruCal.Fieldbyname('CALORIAS').asString ;
       end
    else
       begin
        DMSubsCalorico.TbGruCal.Fieldbyname('NOMECAL').asString := DMSubsCalorico.TbGruCal.Fieldbyname('NOME').asString +
                  ' (' + DMSubsCalorico.TbGruCal.Fieldbyname('CALORIAS').asString + ' kcal)';

        DMSubsCalorico.TbGruCal.Fieldbyname('CALORIACALC').asString := DMSubsCalorico.TbGruCal.Fieldbyname('CALORIAS').asString ;
       end;
end;

procedure TDMSubsCalorico.TbGruProtCalcFields(DataSet: TDataSet);
var
 stProt : string;

begin


    if DMSubsCalorico.TbGruProt.Fieldbyname('Proteinas').asInteger < 0 then
       stProt := '< ' + InttoStr(ABS(DMSubsCalorico.TbGruProt.Fieldbyname('Proteinas').asInteger))
    else
       stProt := DMSubsCalorico.TbGruProt.Fieldbyname('Proteinas').asString ;

    DMSubsCalorico.TbGruProt.Fieldbyname('ProtCalc').asString := stProt;
    DMSubsCalorico.TbGruProt.Fieldbyname('NomeProt').AsString := DMSubsCalorico.TbGruProt.Fieldbyname('Nome').AsString +
                  ' (' + stProt + 'g)/' +
                  ' (' + DMSubsCalorico.TbGruProt.Fieldbyname('Calorias').AsString + 'kcal)';



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
   TbGruProt.Fieldbyname('IdGruProt').AsString  := CreateNewGUID;
   TbGruProt.Fieldbyname('READONLY').AsString  := 'F';
end;

procedure TDMSubsCalorico.TbGruProtBeforeDelete(DataSet: TDataSet);
begin
   if TbGruProt.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Este grupo não pode ser apagado.');
       Abort;
      end;
end;

procedure TDMSubsCalorico.TbGruCalBeforeDelete(DataSet: TDataSet);
begin
   if TbGruCal.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Este grupo não pode ser apagado.');
       Abort;
      end;
end;

procedure TDMSubsCalorico.TbGruCalNewRecord(DataSet: TDataSet);
begin
   TbGruCal.Fieldbyname('IDGRUCAL').AsString  := CreateNewGUID;
   TbGruCal.Fieldbyname('READONLY').AsString  := 'F';
end;

procedure TDMSubsCalorico.TbGAlimentarNewRecord(DataSet: TDataSet);
begin
   TbGAlimentar.Fieldbyname('IDGRUALI').AsString  := CreateNewGUID;
end;

function TDMSubsCalorico.SCEquiv : string;
begin
   // Controle das Calorias
   stCal := DMNutrientes.AchaValorNutriente(DMAlimentos.TbAlimento.Fieldbyname('IDALI').asString, '{B01C0044-AEE3-11D2-B4C0-00609723104C}'); // Calorias

   if DMSubsCalorico.TbGruCal.Locate('IDGRUCAL', DMSubsCalorico.TbAliGCal.Fieldbyname('IDGRUCAL').asString, []) then
      stCalGr :=  DMSubsCalorico.TbGruCal.Fieldbyname('CALORIAS').asString
   else
      stCalGr := '0';
   Result := DMSubsCalorico.Equivalente( stCalGr, stCal );
end;

procedure TDMSubsCalorico.SCMedCas;
begin
    // Traz o valor da medida caseira selecionada
    if  DMedidas.TbMedidasCaseiras.Locate( 'IDALI;IDMEDCAS', VarArrayOf([DMAlimentos.TbAlimento['IDALI'],DMSubsCalorico.TbAliGCal['IdMedCas']]), [])  then
         stMedCasCal := DMedidas.TbMedidasCaseiras.FieldbyName('VALOR').asString
    else
        stMedCasCal := '';
    // Controle das opcoes da Quantidade
     {   laQtdeMed.Caption := DMSubsCalorico.AproximaMedida( lbEquiv.Caption,
                               stMedCasCal );
        cbQtdeMed.Items := DMSubsCalorico.AchaMedida( laQtdeMed.caption);
      }
end;

function TDMSubsCalorico.SCTotal( stMedGr : String ; stQtde : String ) : String;
begin
   // Totaliza
  if stQtde = '' then
     Result :=  stMedCasCal
   else
     Result :=  FloattoStr(StrtoFloat(stMedCasCal) *  StrtoFloat(stQtde));

end;

function TDMSubsCalorico.Calorias100gr(stAlimento: string): string;
begin


end;

procedure TDMSubsCalorico.SetEmGramas(const Value: boolean);
begin
  FEmGramas := Value;
end;

function TDMSubsCalorico.SPEquiv: string;
begin
       // Controle das Proteinas
         stProt := DMNutrientes.AchaValorNutriente( DMAlimentos.TbAlimento.Fieldbyname('IDALI').asString, '{B01C0040-AEE3-11D2-B4C0-00609723104C}'); // Proteína

       // Controle do Equivalente
       if DMSubsCalorico.TbGruProt.Locate('IDGRUPROT', DMSubsCalorico.TbAliGProt.Fieldbyname('IDGRUPROT').asString,[] ) then
          stProtGr := DMSubsCalorico.TbGruProt.Fieldbyname('PROTEINAS').asString
       else
          stProtGr := '0'  ;
       Result := DMSubsCalorico.Equivalente( stProtGr, stProt );

end;

procedure TDMSubsCalorico.SPMedCas;
begin
      // Traz o valor da medida caseira selecionada
    if  DMedidas.TbMedidasCaseiras.Locate( 'IDALI;IDMEDCAS', VarArrayOf([DMAlimentos.TbAlimento['IDALI'],DMSubsCalorico.TbAliGProt['IdMedCas']]), [])  then
        stMedCasProt := DMedidas.TbMedidasCaseiras.Fieldbyname('VALOR').asString
    else
        stMedCasProt := '';

end;

function TDMSubsCalorico.SPTotal(stMedGr, stQtde: String): String;
begin
    // Totaliza
  if stQtde = '' then
     Result :=  stMedCasProt
   else
     Result :=  FloattoStr(StrtoFloat(stMedCasProt) *  StrtoFloat(stQtde));
end;

procedure TDMSubsCalorico.TbGruCalPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMSubsCalorico.TbGAlimentarPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMSubsCalorico.TbGAliCalBkPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMSubsCalorico.TbGruProtPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMSubsCalorico.TbGAliProtBkPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TDMSubsCalorico.TbGAliCalBkBeforeDelete(DataSet: TDataSet);
begin
   if TbGAliCalbk.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Este grupo não pode ser apagado.');
       Abort;
      end;
end;

procedure TDMSubsCalorico.TbGAliProtBkBeforeDelete(DataSet: TDataSet);
begin
   if TbGAliProtbk.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Este grupo não pode ser apagado.');
       Abort;
      end;
end;

function TDMSubsCalorico.SCEquivParaProteina: string;
begin
   // Controle das Calorias
   stCalParaProteina := DMNutrientes.AchaValorNutriente(DMAlimentos.TbAlimento.Fieldbyname('IDALI').asString, '{B01C0044-AEE3-11D2-B4C0-00609723104C}'); // Calorias

   if DMSubsCalorico.TbGruProt.Locate('IDGRUPROT', DMSubsCalorico.TbAliGProt.Fieldbyname('IDGRUPROT').asString, []) then
      stCalGr :=  DMSubsCalorico.TbGruProt.Fieldbyname('CALORIAS').asString
   else
      stCalGr := '0';
   Result := DMSubsCalorico.Equivalente( stCalGr, stCalParaProteina );
end;

procedure TDMSubsCalorico.TbGAliCalBkNewRecord(DataSet: TDataSet);
begin
   TbGAliCalbk.Fieldbyname('READONLY').AsString  := 'F';
end;

procedure TDMSubsCalorico.TbGAliProtBkNewRecord(DataSet: TDataSet);
begin
   TbGAliProtbk.Fieldbyname('READONLY').AsString  := 'F';
end;

procedure TDMSubsCalorico.TbAliGCalNewRecord(DataSet: TDataSet);
begin
   TbAliGCal.Fieldbyname('READONLY').AsString  := 'F';
end;

procedure TDMSubsCalorico.TbAliGProtNewRecord(DataSet: TDataSet);
begin
  TbAliGProt.Fieldbyname('READONLY').AsString  := 'F';
end;

procedure TDMSubsCalorico.TbGruCalBeforeEdit(DataSet: TDataSet);
begin
   if TbGruCal.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Este grupo não pode ser editado.');
       Abort;
      end;
end;

procedure TDMSubsCalorico.TbGAliCalBkBeforeEdit(DataSet: TDataSet);
begin
   if TbGAliCalbk.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Este grupo não pode ser editado.');
       Abort;
      end;
end;

procedure TDMSubsCalorico.TbGruProtBeforeEdit(DataSet: TDataSet);
begin
   if TbGruProt.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Este grupo não pode ser editado.');
       Abort;
      end;
end;

procedure TDMSubsCalorico.TbGAliProtBkBeforeEdit(DataSet: TDataSet);
begin
   if TbGAliProtbk.Fieldbyname('READONLY').asString = 'T' then
      begin
       ShowMessage('Este grupo não pode ser editado.');
       Abort;
      end;
end;

procedure TDMSubsCalorico.DMSubsCaloricoCreate(Sender: TObject);
begin
DbSubsCalorica.AliasName := BDE_ALIAS_NAME;
openAllTables(self);
end;

end.

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




unit DMNutrien;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, dbpersis, DBTables;

type
  TDMNutrientes = class(TDataModule)
    TbNutrientes: TTable;
    TbNutrientesIDNUT: TStringField;
    TbNutrientesABREV: TStringField;
    TbNutrientesNOMENUT: TStringField;
    TbNutrientesUNIDADE: TStringField;
    TbTempAlinut: TTable;
    TbTempAlinutIDALI: TStringField;
    TbTempAlinutIDNUT: TStringField;
    TbTempAlinutVALOR: TFloatField;
    TbTempAlinutNutriente: TStringField;
    DSTempAliNut: TDataSource;
    DSAliNutAux: TDataSource;
    TbAliNutAux: TTable;
    TbAliNutAuxIDALI: TStringField;
    TbAliNutAuxIDNUT: TStringField;
    TbAliNutAuxVALOR: TFloatField;
    DSAliNut: TDataSource;
    TbAliNut: TTable;
    TbAliNutIDALI: TStringField;
    TbAliNutIDNUT: TStringField;
    TbAliNutVALOR: TFloatField;
    TbAliNutNutrientes: TStringField;
    DSNutrientes: TDataSource;
    TbAliNutUnidNut: TStringField;
    DSMedNutr: TDataSource;
    TbMedNutr: TTable;
    TbMedNutrIDALI: TStringField;
    TbMedNutrIDMEDCAS: TStringField;
    TbMedNutrVALOR: TFloatField;
    DSMedidasNutr: TDataSource;
    TbMedidasNutr: TTable;
    TbMedidasNutrMEDIDA: TStringField;
    TbMedNutrNOMEMED: TStringField;
    TbMedNutrMEDVALOR: TStringField;
    TbAliNutAuxNutrientes: TStringField;
    TbNutrientesbk: TTable;
    DSNutrientesbk: TDataSource;
    TbNutrientesbkValorNut: TStringField;
    TbNutrientesbkIDNUT: TStringField;
    TbNutrientesbkABREV: TStringField;
    TbNutrientesbkNOMENUT: TStringField;
    TbNutrientesbkUNIDADE: TStringField;
    TbNutrientesbkORDPADRAO: TIntegerField;
    TbAliNutVisNut: TStringField;
    TbNutrientesORDPADRAO: TIntegerField;
    TbNutrientesVISIVEL: TBooleanField;
    TbNutrientesbkVISIVEL: TBooleanField;
    TbNutrientesIDORIG: TStringField;
    TbMedidasNutrIDMEDCAS: TStringField;
    TbNutrientesbkIDORIG: TStringField;
    procedure TbNutrientesNewRecord(DataSet: TDataSet);
    procedure TbMedNutrCalcFields(DataSet: TDataSet);
    procedure TbAliNutBeforeDelete(DataSet: TDataSet);
    procedure TbAliNutAfterPost(DataSet: TDataSet);

  private
    { Private declarations }

  public
    { Public declarations }
    function AchaValorNutriente( IdNut : string ) : string;
    function TodosNutrientes : TStrings;
    function NutrientesCadastrados : TStrings;
    function NutrienteNaoCadastrado : TStrings;
    function ListNutPesq ( stValor : String ) : TStrings ;
    procedure GeraNutrientes ( LstNut : TStrings );
    procedure GravaNutrporMedCas ( Valor : String );

  end;

var
  DMNutrientes: TDMNutrientes;

implementation

uses DMAliPrep, Alimento, NutMenu, UListaNut;

{$R *.DFM}

procedure TDMNutrientes.GravaNutrporMedCas ( Valor : String );
begin
   DMNutrientes.TbAliNut.First;
   While not DMNutrientes.TbAliNut.EOF do
   begin
      DMNutrientes.TbAliNut.Edit;
      DMNutrientes.TbAliNutVALOR.AsFloat := ( DMNutrientes.TbAliNutVALOR.AsFloat * 100 ) / StrtoFloat( valor );
      DMNutrientes.TbAliNut.Post;
      DMNutrientes.TbAliNut.Next;
   end;

end;

function TDMNutrientes.AchaValorNutriente( IdNut : string ) : string;
begin
// Os nutrientes ja estao filtrados por alimento, cadastrados na Tabela TbAliNut.

      DMNutrientes.TbAliNutAux.First;
       Result := '';
       While not DMNutrientes.TbAliNutAux.EOF do
         begin
          If DMNutrientes.TbAliNutAuxIdNut.asString = IdNut then
           Result := DMNutrientes.TbAliNutAuxVALOR.asString ;
           DMNutrientes.TbAliNutAux.Next;
         end;

end;

function TDMNutrientes.TodosNutrientes : TStrings ;
var
  LfControle : Boolean;

begin

   // Pego em Nutrientes, todos os nomes e encho no stringlist

    Result := TStringList.Create;
    LfControle := TbNutrientes.Active ;

    // Verifico se o banco ja estava aberto, senao abro e no final retorno para fechado
    if LfControle = False then
       TbNutrientes.Active := True;

          TbNutrientes.First;
          Result.Clear;
          While not TbNutrientes.EOF do
          begin
            Result.Add( TbNutrientes['NOMENUT'] );
            TbNutrientes.Next;
          end;
          (Result as TStringList).Sorted := True;
          if LfControle = False then
             TbNutrientes.Close;


end;

function TDMNutrientes.NutrientesCadastrados : TStrings;
// Visa verificar, atraves de um banco ja' filtrados, quais sao os Nutrientes do alimento posicionado
begin
   //TbTempAliNut.Active := True ;
   Result := TStringList.Create;
      TbTempAliNut.First;
      While not TbTempAliNut.EOF do
          begin
            Result.Add( TbTempAliNut['Nutriente'] );
            TbTempAliNut.Next;
          end;
          (Result as TStringList).Sorted := True;
     //TbTempAliNut.Active := False ;
end;

function TDMNutrientes.NutrienteNaoCadastrado : TStrings;
var
LiIndice1,
LiIndice2 : integer;
LslCadastrados : TStrings;

begin
   LslCadastrados := TStringList.Create;
   Result := (TodosNutrientes as TStringList);
   LslCadastrados.AddStrings( NutrientesCadastrados as TStringList );
   for LiIndice1 := 0 to LslCadastrados.Count - 1 do
       if TStringList( Result ).Find( LslCadastrados.Strings[LiIndice1], LiIndice2) then
          Result.Delete(LiIndice2);

end;

function TDMNutrientes.ListNutPesq ( stValor : String ) : TStrings ;
begin

     if stValor = '' then stValor := '0';
     Result := TStringList.Create;
     with TbAliNut do
     begin
       DisableControls ;
       First;
       While not EOF do
          begin
            Result.Add( Format( TbAliNutNutrientes.asString, [21] ) + ' ' + FloattoStr((TbAliNutVALOR.asFloat * StrtoFloat(stValor))/ 100 )+ ' ' +
                           TbAliNutUnidNut.asString );
            TbAliNut.Next;
          end;
       EnableControls;
       First;
       (Result as TStringList).Sorted := True;

     end;
end;



procedure TDMNutrientes.GeraNutrientes ( LstNut : TStrings );
var
LiInt : integer ;
begin
   //TbAliNutAux.Active := True;
   For LiInt := 0 to LstNut.count -1 do
     begin
          if TbNutrientes.Locate( 'NOMENUT', LstNut[ LiInt ], [] ) then
             begin

                TbAliNut.Insert;
                TbAliNutIDNUT.Value:=TbNutrientesIDNUT.Value;
                TbAliNutIDALI.Value:= DMAlimentos.TbAlimentoIDALI.Value;
                TbAliNutVALOR.Value:= StrtoFloat( '0,00');
                TbAliNut.Post;

             end;
    end;

 end;

procedure TDMNutrientes.TbNutrientesNewRecord(DataSet: TDataSet);
begin
   TbNutrientesIDNUT.AsString    := TDSPersist.CreateNewGUID;
   TbNutrientesVisivel.asBoolean := True;

end;

procedure TDMNutrientes.TbMedNutrCalcFields(DataSet: TDataSet);
begin
    DMNutrientes.TbMedNutrMEDVALOR.asString := DMNutrientes.TbMedNutrNOMEMED.asString +
                               ' ('+ DMNutrientes.TbMedNutrVALOR.asString + ')';
end;

procedure TDMNutrientes.TbAliNutBeforeDelete(DataSet: TDataSet);
begin
    DMAlimentos.ConfirmaDelecao ;
end;



procedure TDMNutrientes.TbAliNutAfterPost(DataSet: TDataSet);
begin
     (fm_MenuNut.ifAlimento.FormBuilded as TfmAlim).NutTrocaGrid;
end;



end.

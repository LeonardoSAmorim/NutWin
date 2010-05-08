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




unit DMPesq;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TDMPesquisa = class(TDataModule)
    DSPastas: TDataSource;
    TbPastas: TTable;
    DSCor: TDataSource;
    TbCor: TTable;
    DSSexo: TDataSource;
    TbSexo: TTable;
    TbPastasIdPasta: TStringField;
    TbPastasNomePasta: TStringField;
    TbPastasIcon: TIntegerField;
    TbCorCodCor: TStringField;
    TbCorDescCor: TStringField;
    TbSexoCodSexo: TStringField;
    TbSexoDescSexo: TStringField;
    DSNacionalidade: TDataSource;
    TbNacionalidade: TTable;
    TbNacionalidadeNACIONALIDADE: TStringField;
    TbNacionalidadeSIGLA: TStringField;
    TbNacionalidadeIDNAC: TStringField;
    DSNaturalidade: TDataSource;
    TbNaturalidade: TTable;
    TbNaturalidadeDescrCid: TStringField;
    TbNaturalidadeUF: TStringField;
    TbNaturalidadeIdCid: TStringField;
    TbNaturalidadeCepCid: TStringField;
    TbNaturalidadeDDD: TStringField;
    DSPessoa: TDataSource;
    DSAlimento: TDataSource;
    TbPessoa: TTable;
    TbAlimento: TTable;
    TbPessoaIDPessoa: TStringField;
    TbPessoaSobrPess: TStringField;
    TbPessoaNomePess: TStringField;
    TbPessoaDataNasc: TDateField;
    TbPessoaCodSexo: TStringField;
    TbPessoaSobrResp: TStringField;
    TbPessoaNomeResp: TStringField;
    TbPessoaDataCad: TDateField;
    TbPessoaFotoPess: TGraphicField;
    DSRefeicao: TDataSource;
    TbRefeicao: TTable;
    TbAlimentoOUID: TStringField;
    TbAlimentoNOME: TStringField;
    TbAlimentoNOMESIMP: TStringField;
    TbAlimentoIDORG: TStringField;
    TbAlimentoIDGRUALI: TStringField;
    TbAlimentoIDMEDPAD: TStringField;
    TbAlimentoTIPOALI: TStringField;
    TbAlimentoOUIDPai: TStringField;
    TbRefeicaoID_REFEICAO: TStringField;
    TbRefeicaoNOME: TStringField;
    TbRefeicaoHORARIO: TTimeField;
    DSNutrientes: TDataSource;
    TbNutrientes: TTable;
    TbNutrientesIDNUT: TStringField;
    TbNutrientesABREV: TStringField;
    TbNutrientesNOMENUT: TStringField;
    TbNutrientesUNIDADE: TStringField;
    TbNutrientesORDPADRAO: TIntegerField;
    TbPessoaIdadeAnos: TStringField;
    DSPesqTemp: TDataSource;
    qrPesqTemp: TQuery;
    DSPesqTemp1: TDataSource;
    TbPesqTemp1: TTable;
    TbPesqTemp1IdPessoa: TStringField;
    qrPesqTempIDPessoa: TStringField;
    DSCadPastas: TDataSource;
    TbCadPastas: TTable;
    TbCadPastasIdPasta: TStringField;
    TbCadPastasIdPessoa: TStringField;
    TbCadPastasDataCad: TDateField;
    TbPesqTemp1NomeCompleto: TStringField;
    TbPesqTemp1NOMEPESS: TStringField;
    TbPesqTemp1SOBRPESS: TStringField;
    DSGrupoAlim: TDataSource;
    TbGrupoAlim: TTable;
    TbGrupoAlimIDGRUALI: TStringField;
    TbGrupoAlimNOMEGRU: TStringField;
    TbNaturalidadeCidUF: TStringField;
    procedure DMPesquisaCreate(Sender: TObject);
    procedure DMPesquisaDestroy(Sender: TObject);
    procedure TbPessoaCalcFields(DataSet: TDataSet);
    procedure TbPesqTemp1CalcFields(DataSet: TDataSet);

  private
    { Private declarations }
  public
    { Public declarations }
    lsPastas        : TStrings;
    stIdade         : String ;
    stSexo          : String ;
    stCor           : String ;
    stNaturalidade  : String ;
    stNacionalidade : String ;
    stCEP           : String ;
    function IdadeAnos : string;
    procedure PesPastasSelec ;
    function ControlaSinais ( Sinal : String ) : TStrings ;

  end;

var
  DMPesquisa: TDMPesquisa;

implementation

{$R *.DFM}

function TDMPesquisa.ControlaSinais ( Sinal : String ) : TStrings ;
var
  Sinais1 : TStrings;
  Sinais2 : TStrings;

begin
   Result  := TStringList.create;
   Sinais1 := TStringList.create;
   Sinais1.Add('<') ;
   Sinais1.Add('<=');
   Sinais1.Add('<>');

   Sinais2 := TStringlist.create;
   Sinais2.Add('>') ;
   Sinais2.Add('>=');
   Sinais2.Add('<>');

  // Result.Clear;

   if (Sinal = '>') or (Sinal = '>=') then
      Result.AddStrings(Sinais1)
   else if (Sinal = '<') or (Sinal = '<=') then
      Result.AddStrings(Sinais2) ;

   Sinais1.Free;
   Sinais2.Free;

end;



procedure TDMPesquisa.PesPastasSelec  ;
var
  I : integer;
begin
   with DMPesquisa do
   begin
   // Limpa a tabela antes de usar novamente.
     TbPesqTemp1.Active := False;
     TbPesqTemp1.Exclusive := True;
     TbPesqTemp1.EmptyTable;
     TbPesqTemp1.Exclusive := False;
     TbPesqTemp1.Active := True;
     // Para cada código de Pastas, gravo os individuos que pertencem a elas, sem repetir.
   for I := 0 to lsPastas.Count - 1 do
   begin
     if TbPastas.Locate('NOMEPASTA', lsPastas.Strings[I], [] ) then
        begin
          While not TbCadPastas.EOF do
            begin
              if TbPesqTemp1.Locate('IDPESSOA',TbCadPastasIdPessoa.AsString, [] ) then
              begin
                 TbCadPastas.Next;
                 ShowMessage( 'Achei um individuo repetido ...'); 
              end
              else
              begin
                 TbPesqTemp1.Insert;
                 TbPesqTemp1IdPessoa.asString := TbCadPastasIdPessoa.AsString ;
                 TbCadPastas.Next;
             end;
            end;
        end;
   end;
   end;
end;

function TDMPesquisa.IdadeAnos : string;
// verificar como colocar a rotina de data.
// Isto e'um quebra-galho.

var
  Hoje : TDateTime;
  Year,  Month,  Day : Word;
  DataNasc : TDateTime ;
  Year2, Month2, Day2 : Word;
  Idade : TDateTime;
 begin
  Hoje := Now;
  DataNasc := DMPesquisa.TbPessoaDataNasc.AsDateTime;
  DecodeDate(Hoje, Year, Month, Day);
  DecodeDate(DataNasc, Year2, Month2, Day2);
  Idade := Hoje - DataNasc;
  if Month2 <  Month then
     Result := FloattoStr(Idade - 1)
  else
     Result := FloattoStr(Idade) ;
end;


procedure TDMPesquisa.DMPesquisaCreate(Sender: TObject);
begin
    lsPastas := TStringList.Create;
end;

procedure TDMPesquisa.DMPesquisaDestroy(Sender: TObject);
begin
    lsPastas.Free;
end;

procedure TDMPesquisa.TbPessoaCalcFields(DataSet: TDataSet);

begin
   TbPessoaIdadeAnos.AsString := DMPesquisa.IdadeAnos ;
end;

procedure TDMPesquisa.TbPesqTemp1CalcFields(DataSet: TDataSet);
begin
   With DMPesquisa do
   begin
     TbPesqTemp1NomeCompleto.asString := Trim(TbPesqTemp1NomePess.asString)
            + ' ' + TbPesqTemp1SobrPess.asString;
   end;
end;

end.

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




unit DMRelPess;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TDMRelPessoa = class(TDataModule)
    TbSexo: TTable;
    TbSexoCodSexo: TStringField;
    TbSexoDescSexo: TStringField;
    TbCidade: TTable;
    TbCidadeDescrCid: TStringField;
    TbCidadeIdCid: TStringField;
    TbCidadeCepCid: TStringField;
    TbCidadeUF: TStringField;
    TbCidadeDdd: TStringField;
    TbEndereco: TTable;
    TbEnderecoIDPessoa: TStringField;
    TbEnderecoNomeLograd: TStringField;
    TbEnderecoNumLograd: TStringField;
    TbEnderecoComplem: TStringField;
    TbEnderecoBairro: TStringField;
    TbEnderecoCep: TStringField;
    TbEnderecoEmail: TStringField;
    TbEstado: TTable;
    TbNacionalidade: TTable;
    TbNacionalidadeIdNac: TStringField;
    TbNacionalidadeNacionalidade: TStringField;
    TbTelefone: TTable;
    TbTelefoneIDPessoa: TStringField;
    TbTelefoneTipo: TStringField;
    TbTelefoneDDD: TStringField;
    TbTelefoneNumTel: TStringField;
    TbTelefoneRamal: TStringField;
    TbCor: TTable;
    TbCorDescCor: TStringField;
    TbCorCodCor: TStringField;
    TbProfissao: TTable;
    TbProfissaoCodProfis: TStringField;
    TbProfissaoDescProf: TStringField;
    TbInstrucao: TTable;
    TbInstrucaoCodInstruc: TStringField;
    TbInstrucaoDescInst: TStringField;
    TbPessoa: TTable;
    TbPessComp: TTable;
    TbPessCompIDPessoa: TStringField;
    TbPessCompCodNatural: TStringField;
    TbPessCompCodNacional: TStringField;
    TbPessCompCodEstCivil: TStringField;
    DSPessoa: TDataSource;
    DSSexo: TDataSource;
    DSCidade: TDataSource;
    DSEndereco: TDataSource;
    DSEstado: TDataSource;
    DSNacionalidade: TDataSource;
    DSPessComp: TDataSource;
    DSTelefone: TDataSource;
    DSCor: TDataSource;
    DSInstrucao: TDataSource;
    DSProfissao: TDataSource;
    DSUsuarios: TDataSource;
    TbUsuarios: TTable;
    TbUsuariosUsername: TStringField;
    TbUsuariosSenha: TStringField;
    TbTemp: TTable;
    TbPessCompNaturalidade: TStringField;
    TbPessCompNacionalidade: TStringField;
    TbPessCompProfissao: TStringField;
    TbPessCompCorlkp: TStringField;
    TbEnderecoCidade: TStringField;
    TbEnderecoDescCid: TStringField;
    TbEnderecoUF: TStringField;
    DSTipoAnam: TDataSource;
    TbTipoAnam: TTable;
    TbTipoAnamTipo: TStringField;
    TbTipoAnamDescr: TMemoField;
    TbEstadoIdEstado: TStringField;
    TbEstadoAbrevEstado: TStringField;
    TbEstadoNomeEstado: TStringField;
    TbPessoaIDPessoa: TStringField;
    TbPessoaSobrPess: TStringField;
    TbPessoaNomePess: TStringField;
    TbPessoaCodSexo: TStringField;
    TbPessoaSobrResp: TStringField;
    TbPessoaNomeResp: TStringField;
    TbPessoaFotoPess: TGraphicField;
    DSAnam: TDataSource;
    TbAnam: TTable;
    DSAntrop: TDataSource;
    TbAntrop: TTable;
    DSInquerito: TDataSource;
    TbInquerito: TTable;
    DSDieta: TDataSource;
    TbDieta: TTable;
    DSExames: TDataSource;
    TbExames: TTable;
    TbAnamIDPessoa: TStringField;
    TbAnamAnam: TMemoField;
    TbAntropIdPessoa: TStringField;
    TbAntropAntrop: TMemoField;
    TbInqueritoIdPessoa: TStringField;
    TbInqueritoInquerito: TMemoField;
    TbDietaIdPessoa: TStringField;
    TbDietaDieta: TMemoField;
    TbExamesIdPessoa: TStringField;
    TbExamesExames: TMemoField;
    TbPessCompObs: TMemoField;
    TbPessCompRegistro: TStringField;
    TbPessCompCODCOR: TStringField;
    TbPessCompCODPROFIS: TStringField;
    TbPessCompCODINSTRUC: TStringField;
    TbExamesDATA: TDateTimeField;
    TbDietaDATA: TDateTimeField;
    TbInqueritoDATA: TDateTimeField;
    TbAntropDATA: TDateTimeField;
    TbAnamDATA: TDateTimeField;
    TbTipoAnamDATA: TDateTimeField;
    TbPessoaDATANASC: TDateTimeField;
    TbPessoaDATACAD: TDateTimeField;
    TbPessoaFONETIZADO: TStringField;
    DBRelPessoa: TDatabase;
    TbPessoaNomeCompleto: TStringField;
    TbPessoaSexo: TStringField;
    DSCadPastasInd: TDataSource;
    TbCadPastasInd: TTable;
    DSPastas: TDataSource;
    TbPastas: TTable;
    TbPastasIDPASTA: TStringField;
    TbPastasNOMEPASTA: TStringField;
    TbPastasICON: TIntegerField;
    TbCadPastasIndIDPASTA: TStringField;
    TbCadPastasIndIDPESSOA: TStringField;
    TbCadPastasIndDATACAD: TDateTimeField;
    DSCadPastas: TDataSource;
    TbCadPastas: TTable;
    TbCadPastasNomePasta: TStringField;
    TbCadPastasIdPessoa: TStringField;
    TbCadPastasIdPasta: TStringField;
    TbCadPastasNomePess: TStringField;
    TbCadPastasSobrPess: TStringField;
    TbCadPastasDATACAD: TDateTimeField;
    DSCadPastasbk: TDataSource;
    TbCadPastasbk: TTable;
    TbCadPastasbkIDPASTA: TStringField;
    TbCadPastasbkIDPESSOA: TStringField;
    TbCadPastasbkDATACAD: TDateTimeField;
    TbPessoabk: TTable;
    TbPessoabkIDPessoa: TStringField;
    TbPessoabkSobrPess: TStringField;
    TbPessoabkNomePess: TStringField;
    TbPessoabkCodSexo: TStringField;
    TbPessoabkSobrResp: TStringField;
    TbPessoabkNomeResp: TStringField;
    TbPessoabkFotoPess: TGraphicField;
    TbPessoabkFonetizado: TStringField;
    TbPessoabkDATANASC: TDateTimeField;
    TbPessoabkDATACAD: TDateTimeField;
    DSPessoabk: TDataSource;
    TbPessoabkNomeCompleto: TStringField;
    TbCadPastasIndNomePastas: TStringField;
    TbCadPastasIndNomePess: TStringField;
    DSTipoAnamMod: TDataSource;
    TbTipoAnamMod: TTable;
    StringField1: TStringField;
    MemoField1: TMemoField;
    DateTimeField1: TDateTimeField;
    DSTipoExaMod: TDataSource;
    TbTipoExaMod: TTable;
    TbPessoaNomeResponsavelCompleto: TStringField;
    procedure TbPessoaCalcFields(DataSet: TDataSet);
    procedure TbPessoabkCalcFields(DataSet: TDataSet);
    procedure DMRelPessoaCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMRelPessoa: TDMRelPessoa;

implementation

uses uAliasName;

{$R *.DFM}

procedure TDMRelPessoa.TbPessoaCalcFields(DataSet: TDataSet);
begin
// Fazendo o nome ficar completo
   TbPessoa.Fieldbyname('NomeCompleto').AsString :=
       TbPessoa.Fieldbyname('NomePess').asString + ' ' + TbPessoa.Fieldbyname('SobrPess').asString ;

// Fazendo o nome do responsável ficar completo
   TbPessoa.Fieldbyname('NomeResponsavelCompleto').AsString :=
       TbPessoa.Fieldbyname('NomeResp').asString + ' ' + TbPessoa.Fieldbyname('SobrResp').asString ;


end;

procedure TDMRelPessoa.TbPessoabkCalcFields(DataSet: TDataSet);
begin
    TbPessoabk.Fieldbyname('NomeCompleto').asString := TbPessoabk.Fieldbyname('NomePess').asString + ' ' +
               TbPessoabk.Fieldbyname('SobrPess').asString ;
end;

procedure TDMRelPessoa.DMRelPessoaCreate(Sender: TObject);
begin
DBRelPessoa.AliasName :=  BDE_ALIAS_NAME;
openAllTables(self);
end;

end.
 
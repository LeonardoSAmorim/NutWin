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




unit DMIndex;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, DBiProcs;

type
  TDMIndexacao = class(TDataModule)
    TbSexo: TTable;
    TbCidade: TTable;
    TbEndereco: TTable;
    TbEstado: TTable;
    TbNacionalidade: TTable;
    TbTelefone: TTable;
    TbDDD: TTable;
    TbCep: TTable;
    TbCor: TTable;
    TbProfissao: TTable;
    TbInstrucao: TTable;
    TbPessoa: TTable;
    TbPessComp: TTable;
    DSDDD: TDataSource;
    DSPessoa: TDataSource;
    DSSexo: TDataSource;
    DSCidade: TDataSource;
    DSEndereco: TDataSource;
    DSEstado: TDataSource;
    DSNacionalidade: TDataSource;
    DSPessComp: TDataSource;
    DSTelefone: TDataSource;
    DSCor: TDataSource;
    DSCep: TDataSource;
    DSInstrucao: TDataSource;
    DSProfissao: TDataSource;
    DSUsuarios: TDataSource;
    TbUsuarios: TTable;
    DSAnamnese: TDataSource;
    TbAnamnese: TTable;
    DSTipoAnam: TDataSource;
    TbTipoAnam: TTable;
    DSPastas: TDataSource;
    DSCadPastas: TDataSource;
    TbCadPastas: TTable;
    DSInqueritos: TDataSource;
    DSDietas: TDataSource;
    DSMetas: TDataSource;
    TbInqueritos: TTable;
    TbDietas: TTable;
    TbMetas: TTable;
    DSAntrops: TDataSource;
    TbAntrops: TTable;
    TbOpcoes: TTable;
    DSOpcoes: TDataSource;
    DSTipoExa: TDataSource;
    TbTipoExa: TTable;
    DSExaPess: TDataSource;
    TbExaPess: TTable;
    TbPastas: TTable;
    TbOrigem: TTable;
    TbGAlimentar: TTable;
    DBOrganizador: TDatabase;
    DSOrigem: TDataSource;
    DSGAlimentar: TDataSource;
    DSAlimento: TDataSource;
    TbAlimento: TTable;
    DSPreparac: TDataSource;
    TbPreparac: TTable;
    TbPrecoAli: TTable;
    DSPrecoAli: TDataSource;
    DSMedidasCaseiras: TDataSource;
    TbMedidasCaseiras: TTable;
    TbMedidas: TTable;
    DSMedidas: TDataSource;
    TbNutrientes: TTable;
    DSAliNut: TDataSource;
    TbAliNut: TTable;
    DSNutrientes: TDataSource;
    TbGAliCal: TTable;
    TbGruCal: TTable;
    TbAliGCal: TTable;
    DSGAliCal: TDataSource;
    DSGruCal: TDataSource;
    DSAliGCal: TDataSource;
    DSGruProt: TDataSource;
    DSAliGProt: TDataSource;
    DSGAliProt: TDataSource;
    TbGruProt: TTable;
    TbAliGProt: TTable;
    TbGAliProt: TTable;
    procedure DMIndexacaoCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Indexar;

  end;

var
  DMIndexacao: TDMIndexacao;

implementation

uses uAliasName;

{$R *.DFM}

procedure TDMIndexacao.Indexar;
{var
I : integer;
begin
   for I := 0 to DMIndexacao.ComponentCount - 1 do
   begin
      if (DMIndexacao.Components[i] is TTable) then
      begin
        (DMIndexacao.Components[i] as TTable ).Exclusive := True;
        (DMIndexacao.Components[i] as TTable ).Open;
        dbiRegenIndexes((DMIndexacao.Components[i] as TTable).Handle );
        (DMIndexacao.Components[i] as TTable ).Close;
        (DMIndexacao.Components[i] as TTable ).Exclusive := False;
      end;
   end;
   ShowMessage('Os índices já foram refeitos.' );
end; }
begin
   Check(DbiRegenIndexes(TbMedidas.Handle));
end;



procedure TDMIndexacao.DMIndexacaoCreate(Sender: TObject);
begin
DBOrganizador.AliasName := BDE_ALIAS_NAME;
end;

end.
 
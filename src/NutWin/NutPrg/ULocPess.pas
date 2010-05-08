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




unit ULocPess;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Tabs, Grids, DBGrids, StdCtrls, ExtCtrls, DBMyNav, ActnList;

type
  TfmLocPess = class(TForm)
    Panel1: TPanel;
    laTitulo: TLabel;
    edBusca: TEdit;
    grPesqPess: TDBGrid;
    tsNav: TTabSet;
    btLocInd: TButton;
    dbLocPess: TDBMyNav;
    alLocPess: TActionList;
    LocPessoa: TAction;
    btLocCan: TButton;
    laIndice: TLabel;
    procedure edBuscaClick(Sender: TObject);
    procedure LocPessoaExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grPesqPessTitleClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmLocPess: TfmLocPess;

implementation

uses UCadPes, Pessoa, dmSemaf;

{$R *.DFM}

procedure TfmLocPess.edBuscaClick(Sender: TObject);
begin
  edBusca.Text := '';
end;

procedure TfmLocPess.LocPessoaExecute(Sender: TObject);
begin
  ModalResult := mrOk;
  if DMPessoa.TbPessoa.Locate('IDPESSOA', DMPessoa.TbPessoabkIDPESSOA.asString, []) then
  begin
    Close;
  end
  else // se não achou o correspondente é porque está vazio, então eu devo entrar direto em modo de inclusão
  begin
    ShowMessage('Banco de Dados vazio !! Cadastre um indivíduo.');
    Close;
  end;
end;

procedure TfmLocPess.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  (**
  Jair - Trava recurso escolhido, assim mais de uma pessoa NÃO pode acessar
         esse registro esteja ela na mesma máquina ou nao.
  **)
  if (self.ModalResult = mrok) then
  begin
    if not (dmSemaforo.TravaRecurso(DMPessoa.TbPessoabk.FieldByName('IDPESSOA').AsString,
      copy('Indivíduo: ' +
      DMPessoa.TbPessoabk.FieldByName('NomePess').AsString + ' ' +
      DMPessoa.TbPessoabk.FieldByName('SobrPess').AsString, 1, 50))) then
    begin
      ShowMessage('Registro em uso, favor tentar novamente mais tarde!');
      Action := caNone;
    end
  end;
end;

procedure TfmLocPess.grPesqPessTitleClick(Column: TColumn);
begin
  //  laIndice.Caption := 'Índice Ativo: ' + Column.Title.Caption;
  //  laIndice.Update;
end;

end.


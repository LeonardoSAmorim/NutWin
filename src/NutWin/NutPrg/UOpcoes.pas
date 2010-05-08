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




unit UOpcoes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, DBCtrls, ExtCtrls, DBMyNav, ComCtrls, Mask,
  ExtDlgs, jpeg, RegEdit, RegConst2, Grids, DBGrids, DBCGrids, MmLstBox,
  MoveItens, Buttons, DBActns, ActnList, RXLookup, InsFrm;

type
  TOpcoes = (opTodos, opCadastro, opMenu, opRelatorios, opNutrientes, opOrdemNutrientes);
  TfmOpcoesPess = class(TForm)
    pcOpcoes: TPageControl;
    teCadastro: TTabSheet;
    GroupBox1: TGroupBox;
    nvOpcoes: TDBMyNav;
    Label6: TLabel;
    paOpcoes: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    laEstado: TLabel;
    Label3: TLabel;
    lcCidade: TRxDBLookupCombo;
    RxDBLookupCombo1: TRxDBLookupCombo;
    lcSexo: TRxDBLookupCombo;
    lcCor: TRxDBLookupCombo;
    lcNacional: TRxDBLookupCombo;
    lcNatural: TRxDBLookupCombo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RxDBLookupCombo1Click(Sender: TObject);
    procedure nvOpcoesBeforeAction(Sender: TObject; Button: TMyNavigateBtn;
      var SkipAction: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    function Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
    function Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
  end;

var
  fmOpcoesPess: TfmOpcoesPess;

implementation

uses Pessoa, OpcSalas, NutMenu, DMNutrien, fmNutAcomp, DMSemaf;

{$R *.DFM}

procedure TfmOpcoesPess.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmOpcoesPess.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmOpcoesPess.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = CHR(VK_RETURN) then
  begin
    key := #0;
    if (Sender is TDBGrid) then
      TDBGrid(Sender).Perform(WM_KeyDown, VK_Tab, 0)
    else
      Perform(Wm_NextDlgCtl, 0, 0);
  end;

end;

procedure TfmOpcoesPess.RxDBLookupCombo1Click(Sender: TObject);
var
  Filtro: string;

begin
  // se estiver na edicao ou inserçao, pois no modo browse não altero nada)
  if (DMPessoa.TbOpcoes.State = dsEdit) or (DMPessoa.TbOpcoes.State = dsInsert) then
  begin
    // A cada mudança de Estado, limpa cidade
    DMPessoa.TbOpcoes.Fieldbyname('Cidade').asString := '';
    // Vou filtrar o banco Cidade aqui, baseado no escolhido pelo Estado
    Filtro := 'UF=' + '''' + DMPessoa.TbEstado.Fieldbyname('AbrevEstado').asString + '''';
    DMPessoa.TbCidade.Filter := Filtro;
    DMPessoa.TbCidade.Filtered := True;
  end
  else
    DMPessoa.TbCidade.Filtered := False;

end;

procedure TfmOpcoesPess.nvOpcoesBeforeAction(Sender: TObject;
  Button: TMyNavigateBtn; var SkipAction: Boolean);
var
  Filtro: string;
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paOpcoes.Enabled := True;
    Filtro := 'UF=' + '''' + DMPessoa.TbOpcoes.Fieldbyname('ESTADO').asString + '''';
    DMPessoa.TbCidade.Filter := Filtro;
    DMPessoa.TbCidade.Filtered := True;
  end
  else if (button = nbCancel) or (button = nbPost) then
  begin
    paOpcoes.Enabled := False;
    DMPessoa.TbCidade.Filtered := False;
  end;

end;

function TfmOpcoesPess.Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Trava pasta escolhida, assim mais de uma pessoa NÃO pode acessar
         essa pasta esteja ela na mesma máquina ou nao.
  **)
  Result := dmSemaforo.TravaRecurso('OpS_' + sNomeDaPasta, 'Tabelas de opções de Sistema');
  if not Result then
    ShowMessage('Pasta em uso, favor tentar novamente mais tarde!');
end;

function TfmOpcoesPess.Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Limpa recurso da tabela
  assim não fica preso para essa aplicação
  **)
  Result := dmSemaforo.LiberaRecurso('OpS_' + sNomeDaPasta);
end;

end.


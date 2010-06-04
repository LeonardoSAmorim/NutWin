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




unit Tabela;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, DBCtrls, ComCtrls, Mask, ExtCtrls, Grids, DBGrids,
  DBMyNav, Menus, db, ToolWin, Boxes, NutCnst;

type
  TfmTabPess = class(TForm)
    pa_Tabelas: TPanel;
    pnlTabTitulo: TPanel;
    pgcTabelas: TPageControl;
    tsNacionalidade: TTabSheet;
    tsInstruc: TTabSheet;
    tsCorPele: TTabSheet;
    tsCidade: TTabSheet;
    bb_Tab_Ok: TBitBtn;
    tsEstado: TTabSheet;
    Label5: TLabel;
    grGInst: TDBGrid;
    Label6: TLabel;
    Label3: TLabel;
    grEstado: TDBGrid;
    Label1: TLabel;
    grNac: TDBGrid;
    grCor: TDBGrid;
    Label8: TLabel;
    grCidade: TDBGrid;
    tsSenha: TTabSheet;
    Label28: TLabel;
    grSenha: TDBGrid;
    nvNac: TDBMyNav;
    nvGInst: TDBMyNav;
    nvCorPele: TDBMyNav;
    nvCidade: TDBMyNav;
    nvEstado: TDBMyNav;
    tsTipAnam: TTabSheet;
    tsPastas: TTabSheet;
    laTit: TLabel;
    grPastas: TDBGrid;
    tsExames: TTabSheet;
    nvSenha: TDBMyNav;
    dbAnam: TDBMyNav;
    nvPastas: TDBMyNav;
    nvExames: TDBMyNav;
    btVisualiza: TButton;
    btVisAnam: TButton;
    paExBioq: TPanel;
    laNomeExa: TLabel;
    deModExa: TDBEdit;
    drExames: TDBRichEdit;

    paAnam: TPanel;
    laNomeMod: TLabel;
    deNomeMod: TDBEdit;

    drMod: TDBRichEdit;
    tsProfissao: TTabSheet;
    grProf: TDBGrid;
    nvProf: TDBMyNav;
    paNacionalidade: TPanel;
    Label4: TLabel;
    deNacionalidade: TDBEdit;
    Label7: TLabel;
    deSigla: TDBEdit;
    paInstrucao: TPanel;
    deDescInst: TDBEdit;
    paCor: TPanel;
    deCor: TDBEdit;
    paCidades: TPanel;
    Label2: TLabel;
    edDescrCid: TDBEdit;
    EditCepCid: TDBEdit;
    Label11: TLabel;
    Label12: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    EditDdd: TDBEdit;
    Label10: TLabel;
    paEstados: TPanel;
    Label13: TLabel;
    deEstado: TDBEdit;
    Label15: TLabel;
    DBEdit5: TDBEdit;
    laUsername: TLabel;
    deUsername: TDBEdit;
    laSenha: TLabel;
    deSenha: TDBEdit;
    paSenha: TPanel;
    paPastas: TPanel;
    dePastas: TDBEdit;
    paOcupacao: TPanel;
    laTitProf: TLabel;
    deProf: TDBEdit;
    laOrdem: TLabel;
    deOrdem: TDBEdit;
    procedure bb_Tab_OkClick(Sender: TObject);
    procedure bb_Tab_CancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btVisualizaClick(Sender: TObject);
    procedure btVisAnamClick(Sender: TObject);
    procedure nvExamesClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure dbAnamClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvNacClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvGInstClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvCorPeleClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvCidadeClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvEstadoClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvSenhaClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvPastasClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvProfClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure pgcTabelasChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
    function Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
  public
    { Public declarations }
  end;

var
  fmTabPess: TfmTabPess;

implementation

uses Pessoa, NutMenu, URelTipExa, UfmRTipAnam, DMRelPess, DMSemaf;

{$R *.DFM}

procedure TfmTabPess.bb_Tab_OkClick(Sender: TObject);
begin
  // Caso o banco tenha alguma tabela sem gravar
  with DMPessoa do
  begin
    TbNacionalidade.Cancel;
    TbInstrucao.Cancel;
    TbCor.Cancel;
    TbCidade.Cancel;
    TbEstado.Cancel;
    TbUsuarios.Cancel;
    TbTipoAnam.Cancel;
    TbPastas.Cancel;
    TbTipoExa.Cancel;
    TbProfissao.Cancel;
  end;

  Close;
end;

procedure TfmTabPess.bb_Tab_CancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfmTabPess.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DMRelPessoa.free;
  //DMPessoa.FechaTabelasPessoas;
  fm_MenuNut.HabilitaMenu;
  if (fmRelTipAnam <> nil) then
    FreeAndNil(fmRelTipAnam);
  if (fmRelTipoExa <> nil) then
    FreeAndNil(fmRelTipoExa);
  Action := caFree;
  self.Liberapasta;
end;

procedure TfmTabPess.FormCreate(Sender: TObject);
begin
  Application.CreateForm(TDMRelPessoa, DMRelPessoa);
  DMPessoa.AbreTabelasPessoas;
  pgcTabelas.ActivePage := tsNacionalidade;
end;

procedure TfmTabPess.btVisualizaClick(Sender: TObject);
var
  Rel: TfmRelTipoExa;
begin
  if (DMPessoa.TbTipoExa.state = dsInsert) or (DMPessoa.TbTipoExa.state = dsEdit) then
    ShowMessage('Salve seus dados antes de pedir a visualização.')
  else
  begin
    Screen.Cursor := crHourGlass;
    // Crio o relatório
    Rel := TfmRelTipoExa.Create(nil);
    try
      DMRelPessoa.TbTipoExaMod.Locate('TIPO', DMPessoa.TbTipoExa.Fieldbyname('Tipo').AsString, []);
      Screen.Cursor := crDefault;
      Rel.Report.PreviewModal;
    finally
      Rel.Free;
    end;
  end;
end;

procedure TfmTabPess.btVisAnamClick(Sender: TObject);
var
  Rel: TfmRelTipAnam;
begin
  if (DMPessoa.TbTipoAnam.state = dsInsert) or (DMPessoa.TbTipoAnam.state = dsEdit) then
    ShowMessage('Salve seus dados antes de pedir a visualização.')
  else
  begin
    Screen.Cursor := crHourGlass;
    // Crio o relatório
    Rel := TfmRelTipAnam.Create(nil);
    try
      DMRelPessoa.TbTipoAnamMod.Locate('TIPO', DMPessoa.TbTipoAnam.Fieldbyname('Tipo').AsString, []);
      Screen.Cursor := crDefault;
      Rel.Report.PreviewModal;
    finally
      Rel.Free;
    end;
  end;
end;

procedure TfmTabPess.nvExamesClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paExBioq.Enabled := True;
    deModExa.SetFocus;
  end
  else
    paExBioq.Enabled := False;
end;

procedure TfmTabPess.dbAnamClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paAnam.Enabled := True;
    deNomeMod.SetFocus;
  end
  else
    paAnam.Enabled := False;
end;

procedure TfmTabPess.nvNacClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paNacionalidade.Enabled := True;
    deNacionalidade.SetFocus;
  end
  else
    paNacionalidade.Enabled := False;

end;

procedure TfmTabPess.nvGInstClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paInstrucao.Enabled := True;
    deDescInst.SetFocus;
  end
  else
    paInstrucao.Enabled := False;

end;

procedure TfmTabPess.nvCorPeleClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paCor.Enabled := True;
    deCor.SetFocus;
  end
  else
    paCor.Enabled := False;

end;

procedure TfmTabPess.nvCidadeClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paCidades.Enabled := True;
    edDescrCid.SetFocus;
  end
  else
    paCidades.Enabled := False;

end;

procedure TfmTabPess.nvEstadoClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paEstados.Enabled := True;
    deEstado.SetFocus;
  end
  else
    paEstados.Enabled := False;

end;

procedure TfmTabPess.nvSenhaClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paSenha.Enabled := True;
    deUsername.SetFocus;
  end
  else
    paSenha.Enabled := False;
end;

procedure TfmTabPess.nvPastasClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paPastas.Enabled := True;
    dePastas.SetFocus;
  end
  else
    paPastas.Enabled := False;

end;

procedure TfmTabPess.nvProfClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbEdit) or (button = nbInsert) then
  begin
    paOcupacao.Enabled := True;
    deProf.SetFocus;
  end
  else
    paOcupacao.Enabled := False;

end;

procedure TfmTabPess.pgcTabelasChange(Sender: TObject);
begin
  // Nacionalidade
  if (pgcTabelas.ActivePage <> tsNacionalidade) then
  begin
    if (DMPessoa.TbNacionalidade.State = dsInsert) or (DMPessoa.TbNacionalidade.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsNacionalidade;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Instrucao
  if (pgcTabelas.ActivePage <> tsInstruc) then
  begin
    if (DMPessoa.TbInstrucao.State = dsInsert) or (DMPessoa.TbInstrucao.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsInstruc;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Cor da Pele
  if (pgcTabelas.ActivePage <> tsCorPele) then
  begin
    if (DMPessoa.TbCor.State = dsInsert) or (DMPessoa.TbCor.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsCorPele;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Cidade
  if (pgcTabelas.ActivePage <> tsCidade) then
  begin
    if (DMPessoa.TbCidade.State = dsInsert) or (DMPessoa.TbCidade.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsCidade;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Estado
  if (pgcTabelas.ActivePage <> tsEstado) then
  begin
    if (DMPessoa.TbEstado.State = dsInsert) or (DMPessoa.TbEstado.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsEstado;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Senha
  if (pgcTabelas.ActivePage <> tsSenha) then
  begin
    if (DMPessoa.TbUsuarios.State = dsInsert) or (DMPessoa.TbUsuarios.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsSenha;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Tipo de Anamnese
  if (pgcTabelas.ActivePage <> tsTipAnam) then
  begin
    if (DMPessoa.TbTipoAnam.State = dsInsert) or (DMPessoa.TbTipoAnam.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTipAnam;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Pastas
  if (pgcTabelas.ActivePage <> tsPastas) then
  begin
    if (DMPessoa.TbPastas.State = dsInsert) or (DMPessoa.TbPastas.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsPastas;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Exames
  if (pgcTabelas.ActivePage <> tsExames) then
  begin
    if (DMPessoa.TbTipoExa.State = dsInsert) or (DMPessoa.TbTipoExa.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsExames;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Profissão
  if (pgcTabelas.ActivePage <> tsProfissao) then
  begin
    if (DMPessoa.TbProfissao.State = dsInsert) or (DMPessoa.TbProfissao.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsProfissao;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
end;

function TfmTabPess.Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Limpa recurso da tabela
  assim não fica preso para essa aplicação
  **)
  Result := dmSemaforo.LiberaRecurso('Pes_'+sNomeDaPasta);
end;

function TfmTabPess.Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Trava pasta escolhida, assim mais de uma pessoa NÃO pode acessar
         essa pasta esteja ela na mesma máquina ou nao.
  **)
  Result := dmSemaforo.TravaRecurso('Pes_'+sNomeDaPasta,'Tabelas Aux. de Indivíduos');
  if not Result then
    ShowMessage('Pasta em uso, favor tentar novamente mais tarde!');
end;

procedure TfmTabPess.FormShow(Sender: TObject);
begin
  (**
    Jair - Trava/libera a pasta para o usuário.
  **)
  if not (self.Travapasta) then
    bb_Tab_OkClick(self);
end;

end.


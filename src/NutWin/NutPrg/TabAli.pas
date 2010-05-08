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




unit TabAli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, DBCtrls, Mask, Grids, DBGrids, ComCtrls, ExtCtrls,
  DBMyNav, db, NutCnst, RxDBComb, RXDBCtrl, RXLookup, ToolEdit,
  DBListView98;

type
  TfmTabAli = class(TForm)
    pa_Tabelas: TPanel;
    pnlTabTitulo: TPanel;
    pgcTabelas: TPageControl;
    tsTANut: TTabSheet;
    tsTAOrig: TTabSheet;
    tsTAGCal: TTabSheet;
    tsTAMedCas: TTabSheet;
    btFechar: TButton;
    DBGrid6: TDBGrid;
    DBGrid9: TDBGrid;
    Label1: TLabel;
    grNut: TDBGrid;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    DBGrid10: TDBGrid;
    Label7: TLabel;
    tsTAGAlim: TTabSheet;
    Label13: TLabel;
    grGAlimentar: TDBGrid;
    dbNutrientes: TDBMyNav;
    DBOrigem: TDBMyNav;
    dbGrupoEnergia: TDBMyNav;
    nvMedidaCaseira: TDBMyNav;
    nvGAlim: TDBMyNav;
    tsTASubsCal: TTabSheet;
    grSubsCal: TDBGrid;
    nvSubsCal: TDBMyNav;
    tsTAgProt: TTabSheet;
    dbGrupoProteina: TDBMyNav;
    tsTASProt: TTabSheet;
    dbEquivProteina: TDBMyNav;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    tsTARefeicao: TTabSheet;
    pcRefeicao: TPageControl;
    tsRefeicao: TTabSheet;
    tsListaRef: TTabSheet;
    tsCadRefeicao: TTabSheet;
    grModRef: TDBGrid;
    Label10: TLabel;
    nvModRef: TDBMyNav;
    laCadRef: TLabel;
    nvCadRef: TDBMyNav;
    grCadRef: TDBGrid;
    DBGrid3: TDBGrid;
    nvRefeicao: TDBMyNav;
    tsVisualizacao: TTabSheet;
    grVer: TRxDBGrid;
    laVer: TLabel;
    lcVer: TRxDBLookupCombo;
    paGrupoEnergia: TPanel;
    dbNomeCal: TDBEdit;
    Label16: TLabel;
    Label17: TLabel;
    DBEdit9: TDBEdit;
    paEquivEnergia: TPanel;
    laGCal: TLabel;
    lcGCal: TDBLookupComboBox;
    laGAlim: TLabel;
    lcGAlim: TDBLookupComboBox;
    paGrupoProteina: TPanel;
    Label19: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label24: TLabel;
    Label20: TLabel;
    DBEdit4: TDBEdit;
    paEquivProteina: TPanel;
    Label23: TLabel;
    DBLookupComboBox2: TDBLookupComboBox;
    Label22: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    paOrigem: TPanel;
    Label14: TLabel;
    deDescr: TDBEdit;
    paNutrientes: TPanel;
    deNome: TDBEdit;
    laNomeNut: TLabel;
    deAbrev: TDBEdit;
    laAbrev: TLabel;
    laUnid: TLabel;
    deUnid: TDBEdit;
    deOrdPad: TDBEdit;
    laOrdPad: TLabel;
    dkVisivel: TDBCheckBox;
    laOrNut: TLabel;
    lcOrigem: TDBLookupComboBox;
    paCadRef: TPanel;
    laCadRefNome: TLabel;
    deCadRef: TDBEdit;
    paListaMod: TPanel;
    laModRef: TLabel;
    deModRef: TDBEdit;
    paRefeicao: TPanel;
    laNomeModelo: TLabel;
    deHorario: TDBEdit;
    paMedidaCaseira: TPanel;
    Label12: TLabel;
    dbMedida: TDBEdit;
    paGruposAlimentares: TPanel;
    Label15: TLabel;
    dbNGruAli: TDBEdit;
    laRefeicao: TLabel;
    laHorario: TLabel;
    lcModeloRef: TRxDBLookupCombo;
    lcRefeicao: TRxDBLookupCombo;
    edModelo: TEdit;
    edRefeicao: TEdit;
    buSalvar: TButton;
    buSalvar2: TButton;
    procedure btFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pgcTabelasChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dcVerChange(Sender: TObject);
    procedure dbGrupoEnergiaClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvSubsCalClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure dbGrupoProteinaClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure dbEquivProteinaClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure DBOrigemClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure dbNutrientesClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvCadRefClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvModRefClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvRefeicaoClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure nvMedidaCaseiraClick(Sender: TObject;
      Button: TMyNavigateBtn);
    procedure nvGAlimClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure lcModeloRefCloseUp(Sender: TObject);
    procedure lcRefeicaoCloseUp(Sender: TObject);
    procedure buSalvarClick(Sender: TObject);
    procedure buSalvar2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    IDModeloRefeicao: string;
    function Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
    function Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
  public
    { Public declarations }
  end;

var
  fmTabAli: TfmTabAli;

implementation

uses DMAliPrep, DMSubstCal, DMMedidas, DMPrecoAlim, DMNutrien, NutMenu,
  DMSemaf;

{$R *.DFM}

procedure TfmTabAli.btFecharClick(Sender: TObject);
begin
  DMNutrientes.TbNutrientes.Cancel;
  DMAlimentos.TbOrigem.Cancel;
  DMALimentos.tbRefeicao.Cancel;
  DMALimentos.tbModRefeicao.Cancel;
  DMALimentos.tbListaRefeicao.Cancel;
  DMedidas.TbMedidas.Cancel;
  DMALimentos.TbGAlimentar.Cancel;
  DMSubsCalorico.TbGruCal.Cancel;
  DMSubsCalorico.TbGAliCalBk.Cancel;
  DMSubsCalorico.TbGruProt.Cancel;
  DMSubsCalorico.TbGAliProtBk.Cancel;
  Close;
end;

procedure TfmTabAli.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fm_MenuNut.HabilitaMenu;
  Action := caFree;
  self.Liberapasta;
end;

procedure TfmTabAli.pgcTabelasChange(Sender: TObject);
begin
  // Nutrientes
  if (pgcTabelas.ActivePage <> tsTANut) then
  begin
    if (DMNutrientes.TbNutrientes.State = dsInsert) or (DMNutrientes.TbNutrientes.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTANut;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Origem
  if (pgcTabelas.ActivePage <> tsTAOrig) then
  begin
    if (DMAlimentos.TbOrigem.State = dsInsert) or (DMAlimentos.TbOrigem.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTAOrig;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Refeição
  if (pgcTabelas.ActivePage <> tsTARefeicao) then
  begin
    // Cadastro de Refeicoes
    if (DMALimentos.tbRefeicao.State = dsInsert) or (DMALimentos.tbRefeicao.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTARefeicao;
      pcRefeicao.ActivePage := tsCadRefeicao;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end
      // Lista de Refeicoes
    else if (DMALimentos.tbModRefeicao.State = dsInsert) or (DMALimentos.tbModRefeicao.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTARefeicao;
      pcRefeicao.ActivePage := tsListaRef;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end
      // Refeicoes
    else if (DMALimentos.tbListaRefeicao.State = dsInsert) or (DMALimentos.tbListaRefeicao.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTARefeicao;
      pcRefeicao.ActivePage := tsRefeicao;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;

  //Medidas Caseiras
  if (pgcTabelas.ActivePage <> tsTAMedCas) then
  begin
    if (DMedidas.TbMedidas.State = dsInsert) or (DMedidas.TbMedidas.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTAMedCas;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Grupo Alimentar
  if (pgcTabelas.ActivePage <> tsTAGAlim) then
  begin
    if (DMALimentos.TbGAlimentar.State = dsInsert) or (DMALimentos.TbGAlimentar.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTAGAlim;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Grupo de Energia
  if (pgcTabelas.ActivePage <> tsTAGCal) then
  begin
    if (DMSubsCalorico.TbGruCal.State = dsInsert) or (DMSubsCalorico.TbGruCal.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTAGCal;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Equivalente de Energia
  if (pgcTabelas.ActivePage <> tsTASubsCal) then
  begin
    if (DMSubsCalorico.TbGAliCalBk.State = dsInsert) or (DMSubsCalorico.TbGAliCalBk.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTASubsCal;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Grupos Proteicos
  if (pgcTabelas.ActivePage <> tsTAGProt) then
  begin
    if (DMSubsCalorico.TbGruProt.State = dsInsert) or (DMSubsCalorico.TbGruProt.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTAGProt;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;
  // Equivalentes de Proteina
  if (pgcTabelas.ActivePage <> tsTASProt) then
  begin
    if (DMSubsCalorico.TbGAliProtBk.State = dsInsert) or (DMSubsCalorico.TbGAliProtBk.State = dsEdit) then
    begin
      pgcTabelas.ActivePage := tsTASProt;
      ShowMessage('Salve ou Cancele seus dados antes de sair.');
    end;
  end;

end;

procedure TfmTabAli.FormCreate(Sender: TObject);
begin
  pgcTabelas.ActivePage := tsTANut;
  IDModeloRefeicao := '';
end;

procedure TfmTabAli.dcVerChange(Sender: TObject);
begin
  DMAlimentos.TbVerModRefeicao.Refresh;
  DMAlimentos.TbVerRefeicoes.Refresh;
end;

procedure TfmTabAli.dbGrupoEnergiaClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
  if (button = nbInsert) or (button = nbEdit) then
    paGrupoEnergia.Enabled := True
  else
    paGrupoEnergia.Enabled := False;
end;

procedure TfmTabAli.nvSubsCalClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
  if (button = nbInsert) or (button = nbEdit) then
    paEquivEnergia.Enabled := True
  else
    paEquivEnergia.Enabled := False;

end;

procedure TfmTabAli.dbGrupoProteinaClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbInsert) or (button = nbEdit) then
    paGrupoProteina.Enabled := True
  else
    paGrupoProteina.Enabled := False;
end;

procedure TfmTabAli.dbEquivProteinaClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbInsert) or (button = nbEdit) then
    paEquivProteina.Enabled := True
  else
    paEquivProteina.Enabled := False;
end;

procedure TfmTabAli.DBOrigemClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbInsert) or (button = nbEdit) then
    paOrigem.Enabled := True
  else
    paOrigem.Enabled := False;

end;

procedure TfmTabAli.dbNutrientesClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
  if (button = nbInsert) or (button = nbEdit) then
    paNutrientes.Enabled := True
  else
    paNutrientes.Enabled := False;

end;

procedure TfmTabAli.nvCadRefClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbInsert) or (button = nbEdit) then
    paCadRef.Enabled := True
  else
    paCadRef.Enabled := False;

end;

procedure TfmTabAli.nvModRefClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbInsert) or (button = nbEdit) then
    paListaMod.Enabled := True
  else
    paListaMod.Enabled := False;

end;

procedure TfmTabAli.nvRefeicaoClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin

  if ((buSalvar.Visible = True) or (buSalvar2.Visible = True)) and (button = nbCancel) then
  begin
    edModelo.Visible := False;
    buSalvar.Visible := False;
    lcModeloRef.Visible := True;
    edRefeicao.Visible := False;
    buSalvar2.Visible := False;
    lcRefeicao.Visible := True;
  end
  else if (button = nbInsert) or (button = nbEdit) then
  begin
    paRefeicao.Enabled := True;
    DMAlimentos.tbListaRefeicao.Fieldbyname('ID_MODREF').AsString := IDModeloRefeicao;
  end
  else if (button = nbPost) then
  begin
    paRefeicao.Enabled := False;
    IDModeloRefeicao := DMAlimentos.tbListaRefeicao.Fieldbyname('ID_MODREF').AsString;
  end
  else
    paRefeicao.Enabled := False;

end;

procedure TfmTabAli.nvMedidaCaseiraClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
  if (button = nbInsert) or (button = nbEdit) then
    paMedidaCaseira.Enabled := True
  else
    paMedidaCaseira.Enabled := False;

end;

procedure TfmTabAli.nvGAlimClick(Sender: TObject; Button: TMyNavigateBtn);
begin
  if (button = nbInsert) or (button = nbEdit) then
    paGruposAlimentares.Enabled := True
  else
    paGruposAlimentares.Enabled := False;
end;

procedure TfmTabAli.lcModeloRefCloseUp(Sender: TObject);
begin
  if lcModeloRef.Text = 'Novo Modelo' then
  begin
    lcModeloRef.Visible := False;
    edModelo.Visible := True;
    buSalvar.Visible := True;
    edModelo.Text := '';
    edModelo.SetFocus;
  end;
end;

procedure TfmTabAli.lcRefeicaoCloseUp(Sender: TObject);
begin
  if lcRefeicao.Text = 'Nova Refeicao' then
  begin
    lcRefeicao.Visible := False;
    edRefeicao.Visible := True;
    buSalvar2.Visible := True;
    edRefeicao.Text := '';
    edRefeicao.SetFocus;
  end;
end;

procedure TfmTabAli.buSalvarClick(Sender: TObject);
begin

  edModelo.Visible := False;
  buSalvar.Visible := False;
  lcModeloRef.Visible := True;

  // se nao achar o Modelo, grava um novo
  if edModelo.Text = '' then
  begin
    DMAlimentos.tbListaRefeicao.Edit;
    DMAlimentos.tbListaRefeicao.Fieldbyname('ModeloRef').asString := '';
  end
  else
  begin
    if not DMAlimentos.tbModRefeicao.Locate('NOME', edModelo.Text, [loCaseInsensitive]) then
    begin
      try
        DMAlimentos.tbModRefeicao.Insert;
        DMAlimentos.tbModRefeicao.Fieldbyname('NOME').asString := edModelo.Text;
        DMAlimentos.tbModRefeicao.Post;
      except
        on Exception do
          ShowMessage('Erro na Inserção!!');
      end;
    end;

    // se achei o Modelo, ele já estando cadastrado ...
    DMAlimentos.tbListaRefeicao.Edit;
    DMAlimentos.tbListaRefeicao.Fieldbyname('ID_MODREF').asString := DMAlimentos.tbModRefeicao.Fieldbyname('ID_MODREF').asString;

  end;

end;

procedure TfmTabAli.buSalvar2Click(Sender: TObject);
begin
  edRefeicao.Visible := False;
  buSalvar2.Visible := False;
  lcRefeicao.Visible := True;

  // se nao achar a Refeicao, grava uma nova
  if edRefeicao.Text = '' then
  begin
    DMAlimentos.tbListaRefeicao.Edit;
    DMAlimentos.tbListaRefeicao.Fieldbyname('REFEICAO').asString := '';
  end
  else
  begin
    if not DMAlimentos.tbRefeicao.Locate('NOME', edRefeicao.Text, [loCaseInsensitive]) then
    begin
      try
        DMAlimentos.tbRefeicao.Insert;
        DMAlimentos.tbRefeicao.Fieldbyname('NOME').asString := edRefeicao.Text;
        DMAlimentos.tbRefeicao.Post;
      except
        on Exception do
          ShowMessage('Erro na Inserção!!');
      end;
    end;

    // se achei o Modelo, ele já estando cadastrado ...
    DMAlimentos.tbListaRefeicao.Edit;
    DMAlimentos.tbListaRefeicao.Fieldbyname('ID_REFEICAO').asString := DMAlimentos.tbRefeicao.Fieldbyname('ID_REFEICAO').asString;

  end;

end;

function TfmTabAli.Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Trava pasta escolhida, assim mais de uma pessoa NÃO pode acessar
         essa pasta esteja ela na mesma máquina ou nao.
  **)
  Result := dmSemaforo.TravaRecurso('Ali_'+sNomeDaPasta,'Tabelas Aux. de Alimentos');
  if not Result then
    ShowMessage('Pasta em uso, favor tentar novamente mais tarde!');
end;

function TfmTabAli.Liberapasta(sNomeDaPasta: string): boolean;
begin
  (**
  Jair - Limpa recurso da tabela
  assim não fica preso para essa aplicação
  **)
  Result := dmSemaforo.LiberaRecurso('Ali_'+sNomeDaPasta);
end;

procedure TfmTabAli.FormShow(Sender: TObject);
begin
  (**
    Jair - Trava/libera a pasta para o usuário.
  **)
  if not (self.Travapasta) then
    btFecharClick(self);
end;

end.


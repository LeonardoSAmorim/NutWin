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




unit UOpAlim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, DBCtrls, ExtCtrls, DBMyNav, ComCtrls, Mask,
  ExtDlgs, jpeg, RegEdit, RegConst2, Grids, DBGrids, DBCGrids, MmLstBox,
  MoveItens, Buttons, DBActns, ActnList, RXLookup, InsFrm, HintListBox;

type
  TOpcoes = (opTodos, opCadastro, opMenu, opRelatorios, opNutrientes, opOrdemNutrientes);
  TfmOpcoesAlimentos = class(TForm)
    pcOpcoes: TPageControl;
    odOpcoes: TOpenPictureDialog;
    alCadSenha: TActionList;
    CadSenhaCancela: TDataSetCancel;
    CadSenhaDel: TDataSetDelete;
    CadSenhaEdit: TDataSetEdit;
    CadSenhaIns: TDataSetInsert;
    CadSenhaSal: TDataSetPost;
    CadSenhaUsuEdit: TDataSetEdit;
    CadSenhaUsuSal: TDataSetPost;
    CadSenhaUsuCanc: TDataSetCancel;
    teNuts: TTabSheet;
    pcNuts: TPageControl;
    taNut1: TTabSheet;
    taNut2: TTabSheet;
    ifNutrienteCalculadora: TInFormBuilder;
    paNutrienteCalculadora: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox3: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Image2: TImage;
    DBMyNav3: TDBMyNav;
    Button2: TButton;
    CheckBox1: TCheckBox;
    RxDBLookupCombo1: TRxDBLookupCombo;
    RxDBLookupCombo2: TRxDBLookupCombo;
    RxDBLookupCombo3: TRxDBLookupCombo;
    RxDBLookupCombo4: TRxDBLookupCombo;
    RxDBLookupCombo5: TRxDBLookupCombo;
    TabSheet2: TTabSheet;
    Image3: TImage;
    Image4: TImage;
    RadioGroup1: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    TabSheet3: TTabSheet;
    Panel2: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBImage1: TDBImage;
    DBMyNav4: TDBMyNav;
    Button4: TButton;
    TabSheet4: TTabSheet;
    Panel3: TPanel;
    Label21: TLabel;
    Button5: TButton;
    DBMyNav5: TDBMyNav;
    GroupBox4: TGroupBox;
    DBCtrlGrid1: TDBCtrlGrid;
    DBText2: TDBText;
    DBCheckBox2: TDBCheckBox;
    teOrdNut: TTabSheet;
    MoveItens1: TMoveItens;
    Label22: TLabel;
    mmOrdNut: TMmListBox;
    btSobe: TButton;
    btDesce: TButton;
    pbNut: TProgressBar;
    TabSheet6: TTabSheet;
    PageControl2: TPageControl;
    TabSheet7: TTabSheet;
    Label23: TLabel;
    Label24: TLabel;
    DBEdit11: TDBEdit;
    DBMyNav6: TDBMyNav;
    DBGrid1: TDBGrid;
    Button10: TButton;
    Button11: TButton;
    Panel4: TPanel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    TabSheet8: TTabSheet;
    Label28: TLabel;
    Label29: TLabel;
    DBEdit12: TDBEdit;
    Panel5: TPanel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Button12: TButton;
    Button13: TButton;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    TabSheet9: TTabSheet;
    PageControl3: TPageControl;
    TabSheet10: TTabSheet;
    Panel6: TPanel;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    bbOk: TBitBtn;
    bbCancela: TBitBtn;
    bbSair: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure bbSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
    function Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
  end;

var
  fmOpcoesAlimentos: TfmOpcoesAlimentos;

implementation

uses Pessoa, OpcSalas, NutMenu, DMNutrien, fmNutAcomp, DMSemaf;

{$R *.DFM}

procedure TfmOpcoesAlimentos.FormCreate(Sender: TObject);

begin
   // configura Os nutrientes chamados da Calculadora
   ifNutrienteCalculadora.CriaFormInterno(TfmNutrientesAcomp);
   ifNutrienteCalculadora.ShowInForm;

   // enche nutrientes
   DMNutrientes.TbNutrientesbk.First;
   mmOrdNut.Items.Clear;
   While not DMNutrientes.TbNutrientesbk.Eof do
   begin
      mmOrdNut.AddDescricaoGUID( DMNutrientes.TbNutrientesbkNOMENUT.asString, DMNutrientes.TbNutrientesbkIDNUT.asString);
      DMNutrientes.TbNutrientesbk.Next;
   end;

   DMNutrientes.TbNutrientesbk.First;

end;

procedure TfmOpcoesAlimentos.Button3Click(Sender: TObject);
begin
   Close;
end;

procedure TfmOpcoesAlimentos.btOkClick(Sender: TObject);
 var
I : integer ;
begin
   // grava os nutrientes na ordem de escolha.
   pbNut.Max := (mmOrdNut.Items.Count - 1);
   for I := 0 to (mmOrdNut.Items.Count - 1) do
   begin // procuro o nutriente e atualizo a posição dele
     pbNut.Position := I ;
     if DMNutrientes.TbNutrientesbk.Locate('IDNUT', mmOrdNut.GUID[I], [] ) then
     begin
        DMNutrientes.TbNutrientesbk.Edit;
//        DMNutrientes.TbNutrientesbkORDPADRAO.AsInteger :=  I ;
        DMNutrientes.TbNutrientesbk.FieldByName('ORDPADRAO').AsInteger :=  I ;
        DMNutrientes.TbNutrientesbk.Post;
     end;
   end;
   DMNutrientes.TbNutrientesbk.First;
   Close;
end;

procedure TfmOpcoesAlimentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfmOpcoesAlimentos.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if key = CHR(VK_RETURN) then
   begin
      key := #0 ;
      if (Sender is TDBGrid) then
         TDBGrid(Sender).Perform(WM_KeyDown, VK_Tab, 0)
      else
         Perform(Wm_NextDlgCtl,0,0);
   end;

end;

procedure TfmOpcoesAlimentos.bbSairClick(Sender: TObject);
begin
   Close;
end;

function TfmOpcoesAlimentos.Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Trava pasta escolhida, assim mais de uma pessoa NÃO pode acessar
         essa pasta esteja ela na mesma máquina ou nao.
  **)
  Result := dmSemaforo.TravaRecurso('OpA_'+sNomeDaPasta,'Tabelas de opções de Nutrientes');
  if not Result then
    ShowMessage('Pasta em uso, favor tentar novamente mais tarde!');
end;

function TfmOpcoesAlimentos.Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Limpa recurso da tabela
  assim não fica preso para essa aplicação
  **)
  Result := dmSemaforo.LiberaRecurso('OpA_'+sNomeDaPasta);
end;


end.

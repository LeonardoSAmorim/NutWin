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




unit frmFormulas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, TreeDic, StdCtrls, Mask, DBCtrls, ExtCtrls, Grids, DBGrids, db;

type
  TMainFrm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBEdit1: TDBEdit;
    DBText1: TDBText;
    LbPai: TLabel;
    Button1: TButton;
    lbCodigo: TLabel;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    pgTipos: TPageControl;
    tbshFrml: TTabSheet;
    tbshMedida: TTabSheet;
    grFormula: TDBGrid;
    grMedida: TDBGrid;
    grTabela: TDBGrid;
    Button2: TButton;
    Button3: TButton;
    DBEdit3: TDBEdit;
    Button4: TButton;
    DBComboBox1: TDBComboBox;
    DBComboBox2: TDBComboBox;
    TreeDicFrml: TTreeDic;
    PageControl1: TPageControl;
    tbShValores: TTabSheet;
    DBMemo1: TDBMemo;
    tbshUnidades: TTabSheet;
    DBMemo2: TDBMemo;
    btExportar: TButton;
    ckCodFonte: TCheckBox;
    procedure TreeDicFrmlClick(Sender: TObject; Code, Description: String);
    procedure NewItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeDicFrmlDblClick(Sender: TObject);
    procedure TreeDicFrmlChange(Sender: TObject; Node: TTreeNode);
    procedure btDeleteClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure TreeDicFrmlNewDescription(Sender: TObject; Code: String;
      var Description: WideString);
    procedure btExportarClick(Sender: TObject);
    procedure ckCodFonteClick(Sender: TObject);
  private
    { Private declarations }
    I : Integer;
  public
    { Public declarations }
    ActualNode, ActualParent : TTreeNode;
    ParentCode,NodeCode : WideString;
  end;

var
  MainFrm: TMainFrm;

implementation

uses DMFrml, TipFrm, DelForm;

{$R *.DFM}

procedure TMainFrm.TreeDicFrmlClick(Sender: TObject; Code,
  Description: String);
var
Count : smallint;
begin
ActualNode:=TreeDicFrml.Selected;
ActualParent:=ActualNode.Parent;
if ActualParent = nil then
   ActualParent:=ActualNode;

ParentCode:= PChar (ActualParent.Data^);
NodeCode:=PChar (ActualNode.Data^);

DMFormulas.Formulas.ExpandCode (ParentCode,Count);
DMFormulas.FlatPai.Locate('cod_CNUT',ParentCode,[]);
DMFormulas.Flat.Locate('cod_CNUT',Code,[]);
DMFormulas.PaisFilhos.Locate ('codpai_CNUT;codfilho_CNUT',VarArrayOf([ParentCode,Code]),[]);
if DMFormulas.TabMed.IsEmpty then
   begin
   if DMFormulas.TabFrml.IsEmpty then
      pgTipos.Enabled:=True //False
   else
      begin
      pgTipos.Enabled:=True;
      pgTipos.ActivePage:=pgTipos.Pages[0];
//      pgTipos.Pages[0].Enabled:=True;
//      pgTipos.Pages[1].Enabled:=False;
      end;
   end
else
      begin
      pgTipos.Enabled:=True;
      pgTipos.ActivePage:=pgTipos.Pages[1];
//      pgTipos.Pages[1].Enabled:=True;
//      pgTipos.Pages[0].Enabled:=False;
      end;
end;

procedure TMainFrm.NewItemClick(Sender: TObject);
var
ChildCount : smallint;
begin
DMFormulas.Formulas.GetChildrenCount(NodeCode,ChildCount);
if ChildCount = -1 then ChildCount:=0;
if SelTipo.ShowModal=mrOK then
   begin
     with DMFormulas.PaisFilhos do
          begin
          Insert;
          FieldByName ('codpai_CNUT').AsString:=NodeCode;
          FieldByName ('codfilho_CNUT').AsString:=SelTipo.edCodigo.Text;
          FieldByName ('ORDEM_CNUT').AsString:= inttostr (ChildCount);

          Post;
          end;

     with DMFormulas.Flat do
          begin
          if not Locate ('cod_CNUT',SelTipo.edCodigo.Text,[]) then
                 begin
                 Insert;
                 FieldByName('cod_CNUT').AsString:=SelTipo.edCodigo.Text;
                 FieldByName('descr_CNUT').AsString:=SelTipo.edDesc.Text;
                 Post;
                 end;
          end;

   case SelTipo.TipoEscolhido of
   0 :
     begin
     pgTipos.Enabled:=True;
     pgTipos.ActivePage:= pgTipos.Pages[0];
     tbshFrml.Enabled:=True;
     tbshMedida.Enabled:=True;//False;
     grTabela.Enabled:=True;//False;

     with DMFormulas.TabFrml do
       if not Locate ('Name',SelTipo.edCodigo.Text,[]) then
          begin
          Insert;
          FieldByName('Name').AsString:=SelTipo.edCodigo.Text;
          FieldByName('Tipo').AsString:='Fmla';
          FieldByName('Data').AsDateTime:=Date;
          Post;
          end;
     end;
   2 :
     begin
     pgTipos.Enabled:=True;
     pgTipos.ActivePage:= pgTipos.Pages[0];
     tbshFrml.Enabled:=True;
     tbshMedida.Enabled:=True;//False;
     grTabela.Enabled:=True;

     with DMFormulas.TabFrml do
       if not Locate ('Name',SelTipo.edCodigo.Text,[]) then
          begin
          Insert;
          FieldByName('Name').AsString:=SelTipo.edCodigo.Text;
          FieldByName('Tipo').AsString:='Tab';
          FieldByName('Data').AsDateTime:=Date;
          Post;
          end;

     with DMFormulas.TabTab do
       if not Locate ('Name',SelTipo.edCodigo.Text,[]) then
          begin
          Insert;
          FieldByName('Name').AsString:=SelTipo.edCodigo.Text;
          Post;
          end;
     end;
   1 :
     begin
     pgTipos.Enabled:=True;
     pgTipos.ActivePage:= pgTipos.Pages[1];
     tbshFrml.Enabled:=True;//False;
     tbshMedida.Enabled:=True;
     grTabela.Enabled:=False;

     with DMFormulas.TabMed do
       if not Locate ('Name',SelTipo.edCodigo.Text,[]) then
          begin
          Insert;
          FieldByName('Name').AsString:=SelTipo.edCodigo.Text;
          Post;
          end;
     end;
   3 :
     begin
     pgTipos.Enabled:=True;//False;
     tbshFrml.Enabled:=True;//False;
     tbshMedida.Enabled:=True;//False;

     end;
   end;
   ActualParent.DeleteChildren;
   ActualParent.Selected:=True;
   ActualParent.Collapse(False);
   end;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
var
Codigo,Desc : WideString;
begin
I := 1;
DMFormulas.Formulas.GetCurrentParent(Codigo,Desc);
DMFormulas.FlatPai.Locate('cod_CNUT',Codigo,[]);
end;

procedure TMainFrm.TreeDicFrmlDblClick(Sender: TObject);
begin
end;

{
procedure TForm1.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  AnItem: TTreeNode;
  AttachMode: TNodeAttachMode;
  HT: THitTests;
begin
  if TreeView1.Selected = nil then Exit;
  HT := TreeView1.GetHitTestInfoAt(X, Y);
  AnItem := TreeView1.GetNodeAt(X, Y);
  if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent] <> HT) then
  begin
    if (htOnItem in HT) or (htOnIcon in HT) then AttachMode := naAddChild

    else if htNowhere in HT then AttachMode := naAdd
    else if htOnIndent in HT then AttachMode := naInsert;
    TreeView1.Selected.MoveTo(AnItem, AttachMode);
  end;
end;
procedure TForm1.TreeView1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

var
  HT : THitTests;
begin
if (CheckBox1.Checked and (Sender is TTreeView)) then
  begin
  with Sender as TTreeView do
    begin
    HT := GetHitTestInfoAt(X,Y);
    if (htOnItem in HT) then
      Items.Delete(GetNodeAt(X,Y));
    end;
  end;
end;
procedure TForm1.Button1Click(Sender: TObject);

var
  I : Integer;
begin
  for I := 0 to (TreeView1.Selected.Count - 1) do
    ListBox1.Items.Add(TreeView1.Selected.Item[I].Text);
end;
var

  HasSibling: Boolean;
  SelNode: TTreeNode;
  ParentNode: TTreeNode;
begin
  SelNode := TTreeView1.Selected;
  ParentNode := SelNode.Parent;
  HasSibling := (ParentNode.GetPrevChild(SelNode) <> nil) or
                (ParentNode.GetNextChild(SelNode) <> nil);
end;
}
procedure TMainFrm.TreeDicFrmlChange(Sender: TObject; Node: TTreeNode);
begin
TreeDicFrmlClick(Sender,string(Node.Data^),Node.Text);
end;

procedure TMainFrm.btDeleteClick(Sender: TObject);
var
  frDelete: TfrDelete;
  ParentNode: TTreeNode;
begin
frDelete:=TfrDelete.Create(Owner);
if frDelete.ShowModal = mrOK then
   begin
   ParentNode := TreeDicFrml.Selected.Parent;
   ParentNode.DeleteChildren;
   ParentNode.Collapse(False);
   end;
frDelete.free;
end;


procedure TMainFrm.Button3Click(Sender: TObject);
begin
if DMFormulas.FlatPai.State in [dsEdit,dsInsert] then  DMFormulas.FlatPai.Post;
if DMFormulas.Flat.State in [dsEdit,dsInsert] then  DMFormulas.Flat.Post;
if DMFormulas.PaisFilhos.State in [dsEdit,dsInsert] then  DMFormulas.PaisFilhos.Post;
if DMFormulas.TabFrml.State in [dsEdit,dsInsert] then  DMFormulas.TabFrml.Post;
if DMFormulas.TabMed.State in [dsEdit,dsInsert] then  DMFormulas.TabMed.Post;
if DMFormulas.TabTab.State in [dsEdit,dsInsert] then  DMFormulas.TabTab.Post;

end;

procedure TMainFrm.Button4Click(Sender: TObject);
begin
TreeDicFrml.Active:=False;
TreeDicFrml.Active:=True;
end;

procedure TMainFrm.TreeDicFrmlNewDescription(Sender: TObject; Code: String;
  var Description: WideString);
var
  FExpressao : String;
  Aux : String;
begin
    if not ckCodFonte.Checked then
       Exit;
    if DMFormulas.TabfrmlBk.Locate( 'Name', Code, []) then
       begin
          FExpressao := DMFormulas.TabfrmlBk.FieldByName ('EXPRESSAO').AsString;
          if DMFormulas.TabTabBk.Locate( 'Name', Code, []) then
             Aux := ' >>> {' + DMFormulas.TabTabBk.FieldByName ('NOMETABELA').AsString + ', ' +
                    DMFormulas.TabTabBk.FieldByName ('CAMPORESULT').AsString + ', ' +
                    DMFormulas.TabTabBk.FieldByName ('MODOPESQUISA').AsString + '}'
          else
             Aux := '';
          Description :=  Code + ' = ' + FExpressao + Aux;
       end
    else if DMFormulas.TabMedBk.Locate( 'Name', Code, []) then
       begin
          FExpressao := Code +
                        ' = ' + DMFormulas.TabMedBk.FieldByName ('VALORDEFAULT').AsString +
                        ' ' + DMFormulas.TabMedBk.FieldByName ('UNIDADEDEFAULT').AsString +
                        ' ' + DMFormulas.TabMedBk.FieldByName ('DESCRIPTORNAME').AsString;
          Description :=  FExpressao;
       end;

end;

procedure TMainFrm.btExportarClick(Sender: TObject);
begin
   TreeDicFrml.SaveToFile( 'TreeCalcNut.txt' );
end;

procedure TMainFrm.ckCodFonteClick(Sender: TObject);
begin
TreeDicFrml.Active:=False;
TreeDicFrml.Active:=True;
end;

end.

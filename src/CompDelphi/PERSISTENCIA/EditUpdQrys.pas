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




unit EditUpdQrys;

interface

uses
    SysUtils, Classes, Forms, StdCtrls, DB, DBTables,  DsgnIntf, PersComp,
    Controls, BDEProv,BDEConst,Updsqled;
type
  TUpObjForm = class(TForm)
    LBTabelas: TListBox;
    BtAdd: TButton;
    BtDelete: TButton;
    BtEdit: TButton;
    GroupBox1: TGroupBox;
    SQLStrings: TMemo;
    RBModify: TRadioButton;
    RBDelete: TRadioButton;
    RBInsert: TRadioButton;
    BtOK: TButton;
    BtCancel: TButton;
    BtSave: TButton;
    BtQuit: TButton;
    UPDClone: TUpdateSQL;
    QryClone: TQuery;
    procedure BtAddClick(Sender: TObject);
    procedure LBTabelasClick(Sender: TObject);
    procedure BtDeleteClick(Sender: TObject);
    procedure RBModifyClick(Sender: TObject);
    procedure RBDeleteClick(Sender: TObject);
    procedure RBInsertClick(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
    procedure BtSaveClick(Sender: TObject);
    procedure BtQuitClick(Sender: TObject);
    procedure SQLStringsEnter(Sender: TObject);
  private
    { Private declarations }
    SelItem : TUpdateKind;
  protected
    UPDVParam: TUpdateObjectView;
  public
    { Public declarations }
    constructor Create (AOwner: TComponent;AUPOV : TUpdateObjectView);reintroduce;
  end;

  { TUpdateObjectViewEditor }

type
  TUpdateObjectViewEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure Register;


  procedure EditUpdateObjView (ObjViewParam : TUpdateObjectView);
var
  UpObjForm: TUpObjForm;

implementation

{$R *.DFM}

procedure Register;
begin
  RegisterComponentEditor(TUpdateObjectView, TUpdateObjectViewEditor);
end;

{ TUpdateObjectViewEditor }


procedure TUpdateObjectViewEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0:  EditUpdateObjView (TUpdateObjectView(Component));
  end;
end;

function TUpdateObjectViewEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit SQL Statements...'
  end;
end;

function TUpdateObjectViewEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ EditUpdateObjView }

procedure EditUpdateObjView (ObjViewParam : TUpdateObjectView);
begin
  UpObjForm:=TUpObjForm.Create(Application, ObjViewParam);
  UpObjForm.ShowModal;

end;

constructor TUpObjForm.Create(AOwner: TComponent;AUpOv : TUpdateObjectView);
var
Cnt : Integer;
NomeTabela : string;
begin
inherited Create(AOwner);

UPDVParam:=AUpOv;

if (UPDVParam.DataSet) is TQuery then
   begin
      QryClone.SessionName := TDBDataSet(UPDVParam.DataSet).SessionName;
      QryClone.DatabaseName := TDBDataSet(UPDVParam.DataSet).DataBaseName;
      QryClone.SQL.Assign (TQuery(UPDVParam.DataSet).SQL);
      QryClone.UpdateObject:=UPDClone;
   end;

LBTabelas.Items.Clear;

for Cnt := 0 to (UPDVParam.TableCount-1) do
    begin
    UPDVParam.TableIndex:=Cnt;
    if UPDVParam.ModifySQL.Count > 0 then
       begin
       NomeTabela:=UPDVParam.ModifySQL[0];
       Delete(NomeTabela,1,7);
       LBTabelas.Items.Add (NomeTabela);
       end;
    end;

LBTabelas.ItemIndex:=0;
SelItem :=ukModify;
RBModify.Checked:=True;
LBTabelasClick(self);

end;

procedure TUpObjForm.BtAddClick(Sender: TObject);
var
  NomeTabela : string;
  UpdateKind: TUpdateKind;
begin
  with UPDVParam do
       begin

       if LBTabelas.Items.Count = 0 then
          Begin
          BtEditClick(self);
          exit;
          end;

       AddStatement;
       if not(EditUpdateSQL(UPDClone)) then   //EditUpdateSQL
          begin
          DelStatement;
          exit;
          end;


       for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
           UPDVParam.SQL[UpdateKind]:=UPDClone.SQL[UpdateKind];

       if UPDClone.ModifySQL.Count > 0 then
          begin
          NomeTabela:=UPDClone.ModifySQL[0];
          Delete(NomeTabela,1,7);
          LBTabelas.Items.Add (NomeTabela);
          LBTabelas.ItemIndex := LBTabelas.ItemIndex + 1;
          TableIndex:=LBTabelas.ItemIndex;
          end;
       end;

    SelItem :=ukModify;
    RBModify.Checked:=True;
    LBTabelasClick(self);
end;



procedure TUpObjForm.LBTabelasClick(Sender: TObject);
begin
    UPDVParam.TableIndex:=LBTabelas.ItemIndex;
    SQLStrings.Lines :=UPDVParam.SQL[SelItem];
end;

procedure TUpObjForm.BtDeleteClick(Sender: TObject);
begin
if (LBTabelas.Items.Count <> 0) then
   begin
    UPDVParam.DelStatement;
    LBTabelas.Items.Delete(LBTabelas.ItemIndex);
    SQLStrings.Clear;
    if (LBTabelas.Items.Count > 0) then
       begin
       LBTabelas.ItemIndex:=0;
       UPDVParam.TableIndex:=0;
       SQLStrings.Lines :=UPDVParam.SQL[SelItem];
       end;
    end;
end;

procedure TUpObjForm.RBModifyClick(Sender: TObject);
begin
SelItem:=ukModify;
SQLStrings.Lines :=UPDVParam.SQL[SelItem];
end;

procedure TUpObjForm.RBDeleteClick(Sender: TObject);
begin
SelItem:=ukDelete;
SQLStrings.Lines :=UPDVParam.SQL[SelItem];
end;

procedure TUpObjForm.RBInsertClick(Sender: TObject);
begin
SelItem:=ukInsert;
SQLStrings.Lines :=UPDVParam.SQL[SelItem];
end;

procedure TUpObjForm.BtEditClick(Sender: TObject);
var
  NomeTabela : string;
  UpdateKind: TUpdateKind;
begin

    for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
        UPDClone.SQL[UpdateKind]:=UPDVParam.SQL[UpdateKind];

    if not(EditUpdateSQL(UPDClone)) then exit; 

    for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
        UPDVParam.SQL[UpdateKind]:=UPDClone.SQL[UpdateKind];

    if UPDClone.ModifySQL.Count > 0 then
       begin
       NomeTabela:=UPDClone.ModifySQL[0];
       Delete(NomeTabela,1,7);
       if LBTabelas.Items.Count = 0 then
          Begin
          LBTabelas.Items.Add (NomeTabela);
          LBTabelas.ItemIndex:=0;
          end
       else
           LBTabelas.Items.Strings[LBTabelas.ItemIndex]:= NomeTabela;

       LBTabelasClick(self);
       end;
end;

procedure TUpObjForm.BtSaveClick(Sender: TObject);
begin
BtSave.Enabled:=False;
BtQuit.Enabled:=False;

if (LBTabelas.ItemIndex = -1) then exit;

UPDVParam.SQL[SelItem] := SQLStrings.Lines;
end;

procedure TUpObjForm.BtQuitClick(Sender: TObject);
begin
BtSave.Enabled:=False;
BtQuit.Enabled:=False;

if (LBTabelas.ItemIndex = -1) then exit;

SQLStrings.Lines :=UPDVParam.SQL[SelItem];
end;

procedure TUpObjForm.SQLStringsEnter(Sender: TObject);
begin
BtSave.Enabled:=True;
BtQuit.Enabled:=True;
end;

end.

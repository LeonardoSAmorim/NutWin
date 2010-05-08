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




unit ItemsDefaultReg;

interface


uses Windows, Classes, Graphics, Forms, Controls, Buttons, DsgnIntf,
   StdCtrls, ComCtrls, CNSConnect, dialogs, ExtCtrls, checklst, CCSPreparar;

type
  TItemsDefaultEditorDlg = class(TForm)
    Panel1: TPanel;
    bbok: TBitBtn;
    bbcancel: TBitBtn;
    CBGrupo: TComboBox;
    Label1: TLabel;
    BBInsert: TBitBtn;
    BBDelete: TBitBtn;
    GroupBox1: TGroupBox;
    CheckListPermissoes: TCheckListBox;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    CheckListFuncional: TCheckListBox;
    CheckListCustom: TCheckListBox;
    procedure bbokClick(Sender: TObject);
    procedure bbcancelClick(Sender: TObject);
    procedure BBInsertClick(Sender: TObject);
    procedure BBDeleteClick(Sender: TObject);
    procedure CBGrupoClick(Sender: TObject);
    procedure CBGrupoChange(Sender: TObject);
  private
    { Private declarations }
    FItemsDefault : TItemsDefault;
    FPermissoes : string;
    FTratarNome : TCustomPreparar;
    FListaPermissoes : TStrings;
    FListaCustom : TStrings;
    FListaFuncional : TStrings;
    FEmClick : boolean;
    procedure SetItemsDefault(Value : TItemsDefault);
    procedure MontarCheckPermissoes;
    procedure StrToCheck(var xChk : TCheckListBox; Value : string);
    function CheckToStr(var xChk : TCheckListBox) : string;


  public
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    property EditorItemsDefault: TItemsDefault read FItemsDefault write SetItemsDefault;
  end;

  TItemsDefaultProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;
  { Component editor - brings up angle editor when double clicking on
    Angles property }

  TItemsDefaultEditor = class(TDefaultEditor)
  protected
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


procedure register;

implementation

uses SysUtils;

{$R *.DFM}

procedure TItemsDefaultProperty.Edit;
var
  ItemsDefault: TItemsDefault;
  ItemsDefaultEditor: TItemsDefaultEditorDlg;
  FComponent : TComponent;
begin
   //este metodo acontece sempre que preciona os ... do object inspector
   //o primeiro componente da lsita e o componente dona da property
   FComponent := TComponent(GetComponent(0));
//   try
    //devolve a instacia da classe de ItemsDefault criado pelo component editado
    ItemsDefault := TItemsDefault(GetOrdValue);
    ItemsDefaultEditor := TItemsDefaultEditorDlg.Create(Application);
//    try
      ItemsDefaultEditor.EditorItemsDefault := ItemsDefault;
      ItemsDefaultEditor.ShowModal;
//    finally
      // mesmo qdo ocorrer erro o finally sera executado para limpar a memoria
//      ItemsDefaultEditor.Free;
//    end;
//    except
//       begin
//        ShowMessage('Erro');
//       end;
//    end;
end;

function TItemsDefaultProperty.GetAttributes: TPropertyAttributes;
//defini o tipo de propriedade do objeto
begin
  Result := [paDialog, paSubProperties];
end;


//dlg

constructor TItemsDefaultEditorDlg.Create(AOwner : TComponent);
begin
   inherited create(AOWner);
   FTratarNome := TCustomPreparar.create(nil);
   FListaPermissoes := TStringList.create;
   FListaCustom := TStringList.create;
   FListaFuncional := TStringList.create;
end;

destructor  TItemsDefaultEditorDlg.Destroy;
begin
   FTratarNome.free;
   FListaPermissoes.free;
   FListaCustom.free;
   FListaFuncional.free;
   inherited destroy;
end;

procedure TItemsDefaultEditorDlg.SetItemsDefault(Value: TItemsDefault);
begin
  FItemsDefault := Value;
  //  pega a lista de permissoes do menucontrol
  FListaPermissoes.Assign(FItemsDefault.UserName.Grupo.ListaPermissoes);
  FListaCustom.Assign(FItemsDefault.MenuControl.ListaCustom);
  FListaFuncional.Assign(FItemsDefault.MenuControl.ListaFuncional);
  CheckListCustom.items.Assign(FItemsDefault.MenuControl.Custom);
  { pega lista de grupos se exisrtir no menucontrol e define um grupo do tipo
  Default para ser utilizado
  }
  with CBGrupo do
  begin
     items.Clear;
     items.Assign(FItemsDefault.UserName.Grupo.ListaGrupos);
     if Items.IndexOf('DEFAULT') = -1 then
     begin
        FListaPermissoes.add('');
        FListaCustom.add('');
        FListaFuncional.add('');
        items.Add('DEFAULT');
     end;
     ItemIndex := Items.IndexOf('DEFAULT');
  end;
  MontarCheckPermissoes;
end;

procedure TItemsDefaultEditorDlg.MontarCheckPermissoes;
var
   i : integer;
begin
    with CheckListPermissoes do
    begin
       items.Clear;
       if FItemsDefault.MenuControl.listaOpcoes.count > 0 then
       begin
          for i := 0 to FItemsDefault.MenuControl.ListaOpcoes.count - 1 do
          begin
             FTratarNome.Nome := FItemsDefault.MenuControl.ListaOpcoes[i];
             FTratarNome.TirarCaracteresInvalidos;
             items.add(FTratarNome.NomeTratado);
          end;
       end;
    end;
    strtocheck(CheckListPermissoes, FListaPermissoes[CBGrupo.ItemIndex]);
//    try
//       strtocheck(CheckListFuncional, FListaFuncional[CBGrupo.ItemIndex]);
//    except
//       strtocheck(CheckListFuncional, 'FFFF');
//    end;
//    strtocheck(CheckListCustom, FListaCustom[CBGrupo.ItemIndex]);
end;

procedure TItemsDefaultEditorDlg.StrToCheck(var xChk : TCheckListBox; Value : string);
var
   i : integer;
begin
   FPermissoes := Value;
   with xChk do
   begin
      if FPermissoes = '' then
         for i := 1 to items.Count do
            FPermissoes := FPermissoes + 'F';
       for i := 0 to items.Count - 1  do
           if FPermissoes[i + 1] = 'T' then
              Checked[i] := True
           else
              Checked[i] := False;
    end;
end;

function TItemsDefaultEditorDlg.CheckToStr(var xChk : TCheckListBox)  : string;
var
   i : integer;
begin
   FPermissoes := '';
    with xChk do
    begin
       for i := 1 to items.Count  do
          FPermissoes := FPermissoes + 'F';
       for i := 0 to items.Count - 1 do
          if Checked[i] = True then
             FPermissoes[i + 1] := 'T'
          else
             FPermissoes[i + 1] := 'F';
    end;
    Result := FPermissoes;
end;

procedure TItemsDefaultEditorDlg.bbokClick(Sender: TObject);
begin
   //atualiza menu control com novos valores
   FItemsDefault.MenuControl.PermissoesDefault := FListaPermissoes[CBGrupo.Items.IndexOf('DEFAULT')];
   FItemsDefault.UserName.Grupo.ListaPermissoes.assign(FListaPermissoes);
   FItemsDefault.UserName.Grupo.ListaGrupos.assign(CBGrupo.items);
   FItemsDefault.MenuControl.ListaCustom.assign(FListaCustom);
   FItemsDefault.MenuControl.ListaFuncional.assign(FListaFuncional);
   close;
end;

procedure TItemsDefaultEditorDlg.bbcancelClick(Sender: TObject);
begin
   //sai sem mecher no menu control
   close;
end;


procedure TItemsDefaultEditorDlg.BBInsertClick(Sender: TObject);
begin
    with CBGrupo do
    begin
       if Items.IndexOf(Text) = -1 then
       begin
          FListaPermissoes.Add(CheckToStr(CheckListPermissoes));
          FListaCustom.Add(CheckToStr(CheckListCustom));
          FListaFuncional.Add(CheckToStr(CheckListFuncional));
          CBGrupo.Items.Add(UpperCase(CBGrupo.Text));
       end else
       begin
          FListaPermissoes[ItemIndex] := CheckToStr(CheckListPermissoes);
          {
              esta dando erro no numero de items devera ser tratado,
          }
//          FListaCustom[ItemIndex] := CheckToStr(CheckListCustom);
//          FListaFuncional[ItemIndex] := CheckToStr(CheckListFuncional);
       end;
    end;
end;

procedure TItemsDefaultEditorDlg.BBDeleteClick(Sender: TObject);
begin
    with CBGrupo do
    begin
       if Text = 'DEFAULT' then
       begin
          showmessage('DEFAULT nao pode ser retirado.');
       end else
       begin
          FListaPermissoes.Delete(CBGrupo.ItemIndex);
          FListaCustom.Delete(CBGrupo.ItemIndex);
          FListaFuncional.Delete(CBGrupo.ItemIndex);
          CBGrupo.Items.Delete(CBGrupo.ItemIndex);
       end;
    end;
end;

procedure TItemsDefaultEditorDlg.CBGrupoClick(Sender: TObject);
begin
   FEmClick := True;
   strtocheck(CheckListPermissoes, FListaPermissoes[CBGrupo.ItemIndex]);
   strtocheck(CheckListCustom, FListaCustom[CBGrupo.ItemIndex]);
   strtocheck(CheckListFuncional, FListaFuncional[CBGrupo.ItemIndex]);
end;

procedure TItemsDefaultEditorDlg.CBGrupoChange(Sender: TObject);
begin
   if not FEmClick then
   begin
      StrToCheck(CheckListPermissoes, '');
      StrToCheck(CheckListCustom, '');
      StrToCheck(CheckListFuncional, '');
   end;
   FEmClick := False;
end;




{TItemsDefaultPieEditor}

procedure TItemsDefaultEditor.EditProperty(PropertyEditor: TPropertyEditor;var Continue, FreeEditor: Boolean);
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'Campo1') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;

function TItemsDefaultEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TItemsDefaultEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Edit ItemsDefault'
  else Result := '';
end;

procedure TItemsDefaultEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;



procedure Register;
begin
//  RegisterComponents('CCS-SIS',[TItemsDefault]);
//  RegisterComponentEditor(TCNSC1, TItemsDefaultEditor);
//  RegisterPropertyEditor(TypeInfo(TItemsDefault), TCNSC1, 'Campo1', TItemsDefaultProperty);
//  RegisterPropertyEditor(TypeInfo(TItemsDefault), TCNSC1, 'Campo2', TItemsDefaultProperty);
end;



end.

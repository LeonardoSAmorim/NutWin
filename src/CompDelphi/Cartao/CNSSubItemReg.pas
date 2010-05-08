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




unit CNSSubItemReg;

interface


uses Windows, Classes, Graphics, Forms, Controls, Buttons, DsgnIntf,
   StdCtrls, ComCtrls, CNSSubItem, dialogs;

type
  TCNSSubItemEditorDlg = class(TForm)
    LBItensRelacionados: TListBox;
    procedure LBItensRelacionadosDblClick(Sender: TObject);
  private
    { Private declarations }
    FCNSSubItem : TCNSSubItem;
    procedure SetCNSSubItem(Value : TCNSSubItem);
    procedure montar;
  public
    property EditorCNSSubItem: TCNSSubItem read FCNSSubItem write SetCNSSubItem;
  end;

  TCNSSubItemProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;
  { Component editor - brings up angle editor when double clicking on
    Angles property }

  TCNSSubItemEditor = class(TDefaultEditor)
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

procedure TCNSSubItemProperty.Edit;
var
  CNSSubItem: TCNSSubItem;
  CNSSubItemEditor: TCNSSubItemEditorDlg;
begin
  try
    CNSSubItem := TCNSSubItem(GetOrdValue);
    CNSSubItemEditor := TCNSSubItemEditorDlg.Create(Application);
    try
      CNSSubItemEditor.EditorCNSSubItem := CNSSubItem;
      CNSSubItemEditor.ShowModal;
    finally
      // mesmo qdo ocorrer erro o finally sera executado para limpar a memoria
      CNSSubItemEditor.Free;
    end;
    except
       if not assigned(CNSSubItem.MenuControl) then
       begin
          ShowMessage('E necessaria ativar os Campos.');
       end;
  end;
end;

function TCNSSubItemProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paSubProperties];
//  Result := [paDialog];
end;


procedure TCNSSubItemEditorDlg.SetCNSSubItem(Value: TCNSSubItem);
begin
  FCNSSubItem := Value;
  LBItensRelacionados.Clear;
  montar;
end;

procedure TCNSSubItemEditorDlg.LBItensRelacionadosDblClick(Sender: TObject);
begin
    FCNSSubItem.ItemRelacionado := LBItensRelacionados.Items[LBItensRelacionados.itemIndex];
    close;
end;
procedure TCNSSubItemEditorDlg.montar;
 var
 i : integer;
begin
   LBItensRelacionados.Items.assign(EditorCNSSubItem.MenuControl.ListaNomesOpcoes);
end;


{TCNSSubItemPieEditor}

procedure TCNSSubItemEditor.EditProperty(PropertyEditor: TPropertyEditor;var Continue, FreeEditor: Boolean);
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

function TCNSSubItemEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TCNSSubItemEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Edit CNSSubItem'
  else Result := '';
end;

procedure TCNSSubItemEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;



procedure Register;
begin
//  RegisterComponents('CCS-SIS',[TCNSSubItem]);
//  RegisterComponentEditor(TCCSC1, TCNSSubItemEditor);
//  RegisterPropertyEditor(TypeInfo(TCNSSubItem), TCCSC1, 'Campo1', TCNSSubItemProperty);
//  RegisterPropertyEditor(TypeInfo(TCNSSubItem), TCCSC1, 'Campo2', TCNSSubItemProperty);
end;


end.

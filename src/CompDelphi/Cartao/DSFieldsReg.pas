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




unit DSFieldsReg;

interface

//uses
//  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
//  StdCtrls, DSFields1, DsgnWnds, DsgnIntf;

uses Windows, Classes, Graphics, Forms, Controls, Buttons, DsgnIntf,
   StdCtrls, ComCtrls, dsfields, dialogs;

type
  TDSFieldsEditorDlg = class(TForm)
    LBFields: TListBox;
    procedure LBFieldsDblClick(Sender: TObject);
  private
    { Private declarations }
    FDSFields : TDSFields;
    procedure SetDsFields(Value : TDSFields);
    procedure montar;
  public
    property EditorDSFields: TDSFields read FDSFields write SetDSFields;
  end;

  TDSFieldsProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;
  { Component editor - brings up angle editor when double clicking on
    Angles property }

  TDSFieldsEditor = class(TDefaultEditor)
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

procedure TDSFieldsProperty.Edit;
var
  DSFields: TDSFields;
  DSFieldsEditor: TDSFieldsEditorDlg;
begin
  try
    DSFields := TDSFields(GetOrdValue);
    DSFieldsEditor := TDSFieldsEditorDlg.Create(Application);
    try
      DSFieldsEditor.EditorDSFields := DSFields;
      DSFieldsEditor.ShowModal;
    finally
      // mesmo qdo ocorrer erro o finally sera executado para limpar a memoria
      DSFieldsEditor.Free;
    end;
    except
       if not assigned(DSFields.DataSet) then
       begin
          ShowMessage('E necessaria ativar os Campos.');
       end;
  end;
end;

function TDSFieldsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paSubProperties];
//  Result := [paDialog];
end;


procedure TDSFieldsEditorDlg.SetDSFields(Value: TDSFields);
begin
  FDSFields := Value;
  lbFields.Clear;
  montar;
end;

procedure TDSFieldsEditorDlg.LBFieldsDblClick(Sender: TObject);
begin
    FDSFields.Field := LBFields.Items[LBFields.itemIndex];
    close;
end;

procedure TDSFieldsEditorDlg.montar;
 var
 i : integer;
begin
     for i := 0 to EditorDSFields.dataset.FieldCount - 1 do
     begin
        LBFields.Items.Add(EditorDSFields.dataset.Fields[i].FieldName);
     end;
end;


{TDSFieldsPieEditor}

procedure TDSFieldsEditor.EditProperty(PropertyEditor: TPropertyEditor;var Continue, FreeEditor: Boolean);
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

function TDSFieldsEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TDSFieldsEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Edit DSFields'
  else Result := '';
end;

procedure TDSFieldsEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;



procedure Register;
begin
//  RegisterComponents('CCS-SIS',[TDSFields]);
//  RegisterComponentEditor(TCCSC1, TDSFieldsEditor);
//  RegisterPropertyEditor(TypeInfo(TDSFields), TCCSC1, 'Campo1', TDSFieldsProperty);
//  RegisterPropertyEditor(TypeInfo(TDSFields), TCCSC1, 'Campo2', TDSFieldsProperty);
end;


end.

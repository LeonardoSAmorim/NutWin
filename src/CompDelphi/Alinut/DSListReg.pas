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




unit DSListReg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, DSList, DsgnIntf;

type
  //This is the form that appears when you edit a TDSs property
  TfmDSsEditor = class(TForm)
    lbItems: TListBox;
    pnlControl: TPanel;
    sbNew: TSpeedButton;
    sbDelete: TSpeedButton;
    procedure sbNewClick(Sender: TObject);
    procedure lbItemsClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation : TOperation); override;
  public
    FDSs: TDSs;
    FComponent: TComponent;

    TheDesigner: IFormDesigner;

    procedure Edit(AComponent: TComponent; ADSs: TDSs);
    procedure RefreshList;
  end;

  //This is the property editor for TDSs that envokes the above form
  TDSsProperty = class(TClassProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetDisplayName: string;
    procedure Edit; override;
  end;

var
  fmDSsEditor: TfmDSsEditor;

procedure Register;

implementation

{$R *.DFM}
type
  THackPersistent = class(TPersistent);

procedure Register;
begin
  RegisterNoIcon([TDSNut]);
  RegisterComponents('Nutricao', [TDSList]);
  RegisterPropertyEditor(TypeInfo(TDSs), TPersistent, '', TDSsProperty);
end;

{ TfmWavsEditor }

procedure TfmDSsEditor.Edit(AComponent: TComponent; ADSs: TDSs);
begin
  //First we need to remove notification for the current component
  if FComponent <> nil then
     FComponent.FreeNotification(Self);

  //Now we need to add notification for the current component
  FComponent := TComponent(AComponent);
  FComponent.FreeNotification(Self);


  FDSs := ADSs;
  lbItems.ItemIndex := -1;
  RefreshList;

  Show;
end;

procedure TfmDSsEditor.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then begin
    //If the owner component is destroyed
    //we should close our form
    if (AComponent = FComponent) then
      Close
    else
    //If the component that is destroyed
    //we refresh our list just incase it affects our component
    if (AComponent is TDSNut) then
      RefreshList;
  end;
end;

{ TDSsProperty }

procedure TDSsProperty.Edit;
var
  Component: TPersistent;
begin
  if fmDSsEditor = nil then
    fmDSsEditor := TfmDSsEditor.Create(Application);

  with fmDSsEditor do begin
    TheDesigner := Self.Designer;  //Don't forget SELF !!
    Caption := Self.GetName;

    Component := GetComponent(0);
    while not (Component is TComponent) and (Component <> nil) do
      Component := THackPersistent(Component).GetOwner;

    if not (Component is TComponent) then
      raise Exception.Create('Owner component not found.');

    Edit(TComponent(Component), TDSs(GetOrdValue));
  end;
end;

function TDSsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TDSsProperty.GetDisplayName: String;
begin
  Result := '(TDSs)';
end;

procedure TfmDSsEditor.RefreshList;
var
  I: Integer;
  Index: Integer;
begin
  Index := lbItems.ItemIndex;
  lbItems.Clear;
  for I:=0 to FDSs.Count-1 do
    lbItems.Items.Add(IntToStr(I) + ' - ' + FDSs[I].DisplayName);
  if Index < lbItems.Items.Count then
    lbItems.ItemIndex := Index;
end;

procedure TfmDSsEditor.sbNewClick(Sender: TObject);
var
  DS: TDS;
  DSNut: TDSNut;
begin
  //Add an item to the collection
  DS := FDSs.Add;

  //Ask TheDesigner to create a new TDSNut component for us
  DSNut := TDSNut(TheDesigner.CreateComponent(TDSNut, nil, 0, 0, 0, 0));

  //Set the DS (CollectionItem) to point to our new TDSNut component
  DS.DSNut := DSNut;

  //Select our new TNutComponent into the object inspector
  //so that it may be renamed if so desired
  TheDesigner.SelectComponent(DSNut);

  //Internally refresh the items in the listbox
  RefreshList;
  lbItems.ItemIndex := FDSs.Count-1;

  //Tell the IDE that something has changed
  TheDesigner.Modified;
end;

procedure TfmDSsEditor.lbItemsClick(Sender: TObject);
begin
  with lbItems do
    if ItemIndex >=0 then
      TheDesigner.SelectComponent(FDSs[ItemIndex].DSNut);
end;

procedure TfmDSsEditor.sbDeleteClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := lbItems.ItemIndex;
  if Index >= 0 then begin
    FDSs[Index].DSNut.Free;
    if Index = lbItems.Items.Count-1 then Dec(Index);
    RefreshList;
    lbItems.ItemIndex := Index;

    TheDesigner.Modified;
  end;
end;

end.

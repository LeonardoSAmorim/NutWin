{*******************************************************}
{                                                       }
{       Delphi Visual Component Library                 }
{       Composite Components Pack (CCPack)              }
{                                                       }
{       Copyright (c) 1997-99 Sergey Orlik              }
{                                                       }
{     Written by:                                       }
{       Sergey Orlik                                    }
{       product manager                                 }
{       Russia, C.I.S. and Baltic States (former USSR)  }
{       Inprise Moscow office                           }
{       Internet:  sorlik@inprise.ru                    }
{       www.geocities.com/SiliconValley/Way/9006/       }
{                                                       }
{*******************************************************}
{$WARNINGS OFF}
{$I BOXDEF.INC}

{$IFDEF VER_CB}
  {$ObjExportAll On}
{$ENDIF}

unit BoxFixEd;

interface
uses
  DsgnIntf, Classes, Boxes, BoxDsgn;

procedure Register;

implementation

uses
  SysUtils, Graphics, Menus, Forms, Controls, Dialogs, Buttons, StdCtrls,
  ComCtrls;

{ TNewActivePageProperty }
type
  TNewActivePageProperty = class(TComponentProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

function TNewActivePageProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TNewActivePageProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Component: TComponent;
begin
  for I := 0 to {*** bug: Designer.Form}TControl(GetComponent(0)).Owner.ComponentCount - 1 do //*** fixed
  begin
    Component := {*** bug: Designer.Form}TControl(GetComponent(0)).Owner.Components[I]; //*** fixed
    if (Component.Name <> '') and (Component is TTabSheet) and
      (TTabSheet(Component).PageControl = GetComponent(0)) then
      Proc(Component.Name);
  end;
end;

{ TNewPageControlEditor }
type
  TNewPageControlEditor = class(TDefaultEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

resourcestring
  SNewPage = 'Ne&w Page';
  SNextPage = 'Ne&xt Page';
  SPrevPage = '&Previous Page';

const
  PageControlVerbs: array[0..2] of string = (SNewPage, SNextPage, SPrevPage);

procedure TNewPageControlEditor.ExecuteVerb(Index: Integer);
var
  PageControl: TPageControl;
  Page: TTabSheet;
  {$IFDEF VER_VCL4}
  Designer: IFormDesigner;
  {$ELSE}
  Designer: TFormDesigner;
  {$ENDIF}
begin
  if Component is TTabSheet then
    PageControl := TTabSheet(Component).PageControl else
    PageControl := TPageControl(Component);
  if PageControl <> nil then
  begin
    Designer := Self.Designer;
    if Index = 0 then
    begin
      Page := TTabSheet.Create(Component.Owner); //*** fixed
      try
        Page.Name := Designer.UniqueName(TTabSheet.ClassName);
        Page.Parent := PageControl;
        Page.PageControl := PageControl;
      except
        Page.Free;
        raise;
      end;
      PageControl.ActivePage := Page;
      Designer.SelectComponent(Page);
      Designer.Modified;
    end else
    begin
      Page := PageControl.FindNextPage(PageControl.ActivePage,
        Index = 1, False);
      if (Page <> nil) and (Page <> PageControl.ActivePage) then
      begin
        PageControl.ActivePage := Page;
        if Component is TTabSheet then Designer.SelectComponent(Page);
        Designer.Modified;
      end;
    end;
  end;
end;

function TNewPageControlEditor.GetVerb(Index: Integer): string;
begin
  Result := PageControlVerbs[Index];
end;

function TNewPageControlEditor.GetVerbCount: Integer;
begin
  Result := High(PageControlVerbs) + 1;
end;

{ TNewToolBarEditor }
type
  TNewToolBarEditor = class(TDefaultEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure TNewToolBarEditor.ExecuteVerb(Index: Integer);
var
  ToolBar: TToolBar;
  Button: TToolButton;
  LastButton: TToolButton;
  {$IFDEF VER_VCL4}
  Designer: IFormDesigner;
  {$ELSE}
  Designer: TFormDesigner;
  {$ENDIF}
  i : integer;
begin
  if Component is TToolButton then
    ToolBar := TToolBar(TToolButton(Component).Parent) else
    ToolBar := TToolBar(Component);
  if ToolBar <> nil then
  begin
    Designer := Self.Designer;
    LastButton := nil;
    for i := ToolBar.ButtonCount - 1 downto 0 do
      if TControl(ToolBar.Buttons[I]) is TToolButton then
      begin
        LastButton := TToolButton(ToolBar.Buttons[I]);
        Break;
      end;
    Button := TToolButton.Create(Component.Owner); //*** fixed
    try
      Button.Name := Designer.UniqueName(TToolButton.ClassName);
      case Index of
        0 : begin
              Button.Style:=tbsButton;
              Button.Hint := Button.Caption;
              if Assigned(LastButton) then
                if LastButton.Style = tbsSeparator then
                  Button.ImageIndex := LastButton.ImageIndex
                else
                  Button.ImageIndex := LastButton.ImageIndex + 1;
            end;
        1 : begin
              Button.Style:=tbsSeparator;
              Button.Width:=8;
              if Assigned(LastButton) then
                Button.ImageIndex := LastButton.ImageIndex + 1;
            end;
        2 : begin
              Button.Style:=tbsDivider;
              Button.Width:=16;              
              if Assigned(LastButton) then
                if LastButton.Style = tbsSeparator then
                  Button.ImageIndex := LastButton.ImageIndex
                else
                  Button.ImageIndex := LastButton.ImageIndex + 1;
            end;
      end;
      if Assigned(LastButton) then
        Button.Left := LastButton.Left+LastButton.Width+1;
      Button.Parent := ToolBar;
    except
      Button.Free;
      raise;
    end;
    Designer.SelectComponent(Button);
    Designer.Modified;
  end;
end;

function TNewToolBarEditor.GetVerb(Index: Integer): string;
begin
  Result := ToolBarBoxVerbs[Index];
end;

function TNewToolBarEditor.GetVerbCount: Integer;
begin
  if (Component is TToolButton) and (TToolButton(Component).Parent is TToolBarBox) then
    Result:=0
  else
    Result := High(ToolBarBoxVerbs) + 1;
end;

{ TDesignAlignProperty }
type
  TDesignAlignProperty = class(TEnumProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

function TDesignAlignProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TDesignAlignProperty.GetValues(Proc: TGetStrProc);
begin
  if (TControl(GetComponent(0)).Parent<>nil) and (TControl(GetComponent(0)).Parent.ClassName='TWinControlForm') then
    Proc('alTop')  //*** fix for the design window behaviour for the WinControl's custom modules with Align<>alTop 
  else
    inherited GetValues(Proc);
end;

procedure Register;
begin
  RegisterComponentEditor(TPageControl, TNewPageControlEditor);
  RegisterComponentEditor(TTabSheet, TNewPageControlEditor);
  RegisterPropertyEditor(TypeInfo(TTabSheet), TPageControl, 'ActivePage', TNewActivePageProperty);
  RegisterComponentEditor(TToolBar, TNewToolBarEditor);
  RegisterComponentEditor(TToolButton, TNewToolBarEditor);
  RegisterPropertyEditor(TypeInfo(TAlign), TToolBarBox, 'Align', TDesignAlignProperty);
end;

end.

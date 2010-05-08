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
{$I BOXDEF.INC}

{$IFDEF VER_CB}
  {$ObjExportAll On}
{$ENDIF}

unit BoxDsgn;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Menus,
  ComCtrls, DsgnIntf, {$IFDEF VER_VCL4} {DsnConst, ColnEdit,} {$ENDIF} Boxes;

type
  TBoxCustomModule = class(TCustomModule)
  public
{$IFDEF VER_VCL4}
    procedure ValidateComponent(Component:IComponent); override;
{$ELSE}
    procedure ValidateComponent(Component:TComponent); override;
{$ENDIF}
  end;

  TToolBarBoxCustomModule = class(TBoxCustomModule)
  public
    procedure ExecuteVerb(Index:integer); override;
    function getVerb(Index:integer):string; override;
    function getVerbCount:integer; override;
  end;

procedure Register;

resourcestring
  sErrorCreateComponent = 'Component can not be added to a box';
  SNewBtn = 'New &Button';
  SNewSpr = 'New Se&parator';
  SNewDiv = 'New &Divider';
  SNewBtnName = 'TBoxToolButton';

const
  ToolBarBoxVerbs: array[0..2] of string = (SNewBtn, SNewSpr, SNewDiv);

implementation

{ TBoxCustomModule }

{$IFDEF VER_VCL4}
procedure TBoxCustomModule.ValidateComponent(Component:IComponent);
{$ELSE}
procedure TBoxCustomModule.ValidateComponent(Component:TComponent);
{$ENDIF}
begin
{$IFDEF VER_VCL4}
  if ExtractComponent(Component) is TMainMenu then
{$ELSE}
  if Component is TMainMenu then
{$ENDIF}
    raise Exception.Create(sErrorCreateComponent)
end;

{ TToolBarBoxCustomModule }

procedure TToolBarBoxCustomModule.ExecuteVerb(Index:integer);
var
  ToolBar: TToolBar;
  Button: TToolButton;
  LastButton: TToolButton;
  {$IFNDEF VER_VCL4}
  Designer: TFormDesigner;
  {$ELSE}
  Designer: IFormDesigner;
  {$ENDIF}
  i: integer;
begin
  {$IFNDEF VER_VCL4}
  if Root is TToolButton then
    ToolBar := TToolBar(TToolButton(Root).Parent) else
    ToolBar := TToolBar(Root);
  {$ELSE}
  if ExtractComponent(Root) is TToolButton then
    ToolBar := TToolBar(TToolButton(ExtractComponent(Root)).Parent) else
    ToolBar := TToolBar(ExtractComponent(Root));
  {$ENDIF}
  if ToolBar <> nil then
  begin
    {$IFNDEF VER_VCL4}
    Designer := TFormDesigner(TCustomForm(ToolBar.Parent).Designer);
    {$ELSE}
    Designer := IFormDesigner(TCustomForm(ToolBar.Parent).Designer);
   {$ENDIF}
    LastButton := nil;
    for i := ToolBar.ButtonCount - 1 downto 0 do
      if TControl(ToolBar.Buttons[I]) is TToolButton then
      begin
        LastButton := TToolButton(ToolBar.Buttons[I]);
        Break;
      end;
    Button := TToolButton.Create(ToolBar);
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

function TToolBarBoxCustomModule.getVerb(Index:integer):string;
begin
  Result := ToolBarBoxVerbs[Index];
end;

function TToolBarBoxCustomModule.getVerbCount:integer;
begin
  Result := High(ToolBarBoxVerbs) + 1;
end;

{ Register }

procedure Register;
begin
  RegisterCustomModule(TBox, TBoxCustomModule);
  RegisterCustomModule(TControlGroupBox, TBoxCustomModule);
  RegisterCustomModule(TControlScrollBox, TBoxCustomModule);
  RegisterCustomModule(TToolBarBox, TToolBarBoxCustomModule);
end;

end.

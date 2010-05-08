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

unit Boxes;

{$C PRELOAD}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, ComCtrls, ToolWin;

type
  TBox = class(TCustomPanel)
  private
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
  protected
    procedure Paint; override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure SetChildOrder(Child: TComponent; Order: Integer); override;
    property Align;
    property Caption;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    {$IFDEF VER_VCL4}
    property DockManager;
    {$ENDIF}
  published
    property Alignment;
    {$IFDEF VER_VCL4}
    property Anchors;
    {$ENDIF}
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    {$IFDEF VER_VCL4}
    property BiDiMode;
    {$ENDIF}
    property BorderWidth;
    property BorderStyle;
    {$IFDEF VER_VCL4}
    property DockSite;
    {$ENDIF}
    property DragCursor;
    {$IFDEF VER_VCL4}
    property DragKind;
    {$ENDIF}
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Color;
    {$IFDEF VER_VCL4}
    property Constraints;
    {$ENDIF}
    property Ctl3D;
    {$IFDEF VER_VCL4}
    property UseDockManager default True;
    {$ENDIF}
    property Font;
    property Locked;
    {$IFDEF VER_VCL4}
    property ParentBiDiMode;
    {$ENDIF}
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    {$IFDEF VER_VCL4}
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    {$IFDEF VER_VCL4}
    property OnEndDock;
    {$ENDIF}
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$IFDEF VER_VCL4}
    property OnGetSiteInfo;
    {$ENDIF}
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    {$IFDEF VER_VCL4}
    property OnStartDock;
    {$ENDIF}
    property OnStartDrag;
    {$IFDEF VER_VCL4}
    property OnUnDock;
    {$ENDIF}
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  end;

  TControlGroupBox = class(TCustomGroupBox)
  private
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
  protected
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure SetChildOrder(Child: TComponent; Order: Integer); override;
    property Align;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    {$IFDEF VER_VCL4}
    property Anchors;
    property BiDiMode;
    {$ENDIF}
    property Caption;
    property Color;
    {$IFDEF VER_VCL4}
    property Constraints;
    {$ENDIF}
    property Ctl3D;
    {$IFDEF VER_VCL4}
    property DockSite;
    {$ENDIF}
    property DragCursor;
    {$IFDEF VER_VCL4}
    property DragKind;
    {$ENDIF}
    property DragMode;
    property Enabled;
    property Font;
    {$IFDEF VER_VCL4}
    property ParentBiDiMode;
    {$ENDIF}
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    {$IFDEF VER_VCL4}
    property OnDockDrop;
    property OnDockOver;
    {$ENDIF}
    property OnDragOver;
    {$IFDEF VER_VCL4}
    property OnEndDock;
    {$ENDIF}
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$IFDEF VER_VCL4}
    property OnGetSiteInfo;
    {$ENDIF}
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    {$IFDEF VER_VCL4}
    property OnResize;
    property OnStartDock;
    {$ENDIF}
    property OnStartDrag;
    {$IFDEF VER_VCL4}
    property OnUnDock;
    {$ENDIF}
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  end;

  TControlScrollBox = class(TScrollBox)
  private
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
  protected
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure SetChildOrder(Child: TComponent; Order: Integer); override;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  end;

  TToolBarBox = class(TToolBar)
  private
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
  protected
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure SetChildOrder(Child: TComponent; Order: Integer); override;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published
    property EdgeBorders default [];
    property Wrapable default False;
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  end;


function IsCompositeDesign(const AControl: TControl): boolean;

implementation

resourcestring
  sResNotFound = 'Resource for %s is not found.';
  sCompositeDesignWindow = 'TWinControlForm';

function IsCompositeDesign(const AControl: TControl): boolean;
begin
  Result:=(AControl.Owner.ClassName=sCompositeDesignWindow);
end;

{ TBox }

constructor TBox.Create(AOwner:TComponent);
begin
  {$IFDEF VER_VCL4}
  GlobalNameSpace.BeginWrite;
  try
  {$ENDIF}
    inherited Create(AOwner);
    if AOwner is TWinControl then
      Parent:=AOwner as TWinControl;
    if (ClassType<>TBox) then
    begin
      if not InitInheritedComponent(Self, TBox) then
        raise EResNotFound.CreateFmt(sResNotFound, [ClassName]);
      if Assigned(FOnCreate) then
      try
        FOnCreate(Self);
      except
        Application.HandleException(Self);
      end;
    end;
  {$IFDEF VER_VCL4}
  finally
    GlobalNameSpace.EndWrite;
  end;
  {$ENDIF}
end;

destructor TBox.Destroy;
begin
  if Assigned(FOnDestroy) then
  try
    FOnDestroy(Self);
  except
    Application.HandleException(Self);
  end;
  inherited Destroy;
end;

procedure TBox.Paint;
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then BottomColor := clBtnHighlight;
  end;

begin
  Rect := GetClientRect;
  if BevelOuter <> bvNone then
  begin
    AdjustColors(BevelOuter);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  Frame3D(Canvas, Rect, Color, Color, BorderWidth);
  if BevelInner <> bvNone then
  begin
    AdjustColors(BevelInner);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  with Canvas do
  begin
    Brush.Color := Color;
    FillRect(Rect);
    Brush.Style := bsClear;
    Font := Self.Font;
  end;
end;

procedure TBox.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  OwnedComponent: TComponent;
begin
  inherited GetChildren(Proc, Root);
  if Root = Self then
  begin
    for I := 0 to ComponentCount - 1 do
    begin
      OwnedComponent := Components[I];
      if not OwnedComponent.HasParent then Proc(OwnedComponent);
    end;
  end;
end;

procedure TBox.SetChildOrder(Child: TComponent; Order: Integer);
var
  I, J: Integer;
begin
  if Child is TControl then
    inherited SetChildOrder(Child, Order)
  else
  begin
    Dec(Order, ControlCount);
    J := -1;
    for I := 0 to ComponentCount - 1 do
      if not Components[I].HasParent then
      begin
        Inc(J);
        if J = Order then
        begin
          Child.ComponentIndex := I;
          Exit;
        end;
      end;
  end;
end;

{ TControlGroupBox }

constructor TControlGroupBox.Create(AOwner:TComponent);
begin
  {$IFDEF VER_VCL4}
  GlobalNameSpace.BeginWrite;
  try
  {$ENDIF}
    inherited Create(AOwner);
    if AOwner is TWinControl then
      Parent:=AOwner as TWinControl;
    if (ClassType<>TControlGroupBox) then
    begin
      if not InitInheritedComponent(Self, TControlGroupBox) then
        raise EResNotFound.CreateFmt(sResNotFound, [ClassName]);
      if Assigned(FOnCreate) then
      try
        FOnCreate(Self);
      except
        Application.HandleException(Self);
      end;
    end;
  {$IFDEF VER_VCL4}
  finally
    GlobalNameSpace.EndWrite;
  end;
  {$ENDIF}
end;

destructor TControlGroupBox.Destroy;
begin
  if Assigned(FOnDestroy) then
  try
    FOnDestroy(Self);
  except
    Application.HandleException(Self);
  end;
  inherited Destroy;
end;

procedure TControlGroupBox.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  OwnedComponent: TComponent;
begin
  inherited GetChildren(Proc, Root);
  if Root = Self then
  begin
    for I := 0 to ComponentCount - 1 do
    begin
      OwnedComponent := Components[I];
      if not OwnedComponent.HasParent then Proc(OwnedComponent);
    end;
  end;
end;

procedure TControlGroupBox.SetChildOrder(Child: TComponent; Order: Integer);
var
  I, J: Integer;
begin
  if Child is TControl then
    inherited SetChildOrder(Child, Order)
  else
  begin
    Dec(Order, ControlCount);
    J := -1;
    for I := 0 to ComponentCount - 1 do
      if not Components[I].HasParent then
      begin
        Inc(J);
        if J = Order then
        begin
          Child.ComponentIndex := I;
          Exit;
        end;
      end;
  end;
end;

{ TControlScrollBox }

constructor TControlScrollBox.Create(AOwner:TComponent);
begin
  {$IFDEF VER_VCL4}
  GlobalNameSpace.BeginWrite;
  try
  {$ENDIF}
    inherited Create(AOwner);
    if AOwner is TWinControl then
      Parent:=AOwner as TWinControl;
    if (ClassType<>TControlScrollBox) then
    begin
      if not InitInheritedComponent(Self, TControlScrollBox) then
        raise EResNotFound.CreateFmt(sResNotFound, [ClassName]);
      if Assigned(FOnCreate) then
      try
        FOnCreate(Self);
      except
        Application.HandleException(Self);
      end;
    end;
  {$IFDEF VER_VCL4}
  finally
    GlobalNameSpace.EndWrite;
  end;
  {$ENDIF}
end;

destructor TControlScrollBox.Destroy;
begin
  if Assigned(FOnDestroy) then
  try
    FOnDestroy(Self);
  except
    Application.HandleException(Self);
  end;
  inherited Destroy;
end;

procedure TControlScrollBox.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  OwnedComponent: TComponent;
begin
  inherited GetChildren(Proc, Root);
  if Root = Self then
  begin
    for I := 0 to ComponentCount - 1 do
    begin
      OwnedComponent := Components[I];
      if not OwnedComponent.HasParent then Proc(OwnedComponent);
    end;
  end;
end;

procedure TControlScrollBox.SetChildOrder(Child: TComponent; Order: Integer);
var
  I, J: Integer;
begin
  if Child is TControl then
    inherited SetChildOrder(Child, Order)
  else
  begin
    Dec(Order, ControlCount);
    J := -1;
    for I := 0 to ComponentCount - 1 do
      if not Components[I].HasParent then
      begin
        Inc(J);
        if J = Order then
        begin
          Child.ComponentIndex := I;
          Exit;
        end;
      end;
  end;
end;

{ TToolBarBox }

constructor TToolBarBox.Create(AOwner:TComponent);
begin
  {$IFDEF VER_VCL4}
  GlobalNameSpace.BeginWrite;
  try
  {$ENDIF}
    inherited Create(AOwner);
    if AOwner is TWinControl then
      Parent:=AOwner as TWinControl;
    EdgeBorders:=[];
    Wrapable:=False;
    if (ClassType<>TToolBarBox) then
    begin
      if not InitInheritedComponent(Self, TToolBarBox) then
        raise EResNotFound.CreateFmt(sResNotFound, [ClassName]);
      if Assigned(FOnCreate) then
      try
        FOnCreate(Self);
      except
        Application.HandleException(Self);
      end;
    end;
  {$IFDEF VER_VCL4}
  finally
    GlobalNameSpace.EndWrite;
  end;
  {$ENDIF}
end;

destructor TToolBarBox.Destroy;
begin
  if Assigned(FOnDestroy) then
  try
    FOnDestroy(Self);
  except
    Application.HandleException(Self);
  end;
  inherited Destroy;
end;

procedure TToolBarBox.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  OwnedComponent: TComponent;
  Control: TControl;
begin
  if Root = Self then
    begin
      for I := 0 to ComponentCount - 1 do
      begin
        OwnedComponent := Components[I];
        if not OwnedComponent.HasParent then Proc(OwnedComponent);
      end;
      inherited GetChildren(Proc, Root);
    end
  else
    for I := 0 to ControlCount - 1 do
    begin
      Control := Controls[I];
      if (Control.Owner = Root) then Proc(Control);
    end;
end;

procedure TToolBarBox.SetChildOrder(Child: TComponent; Order: Integer);
var
  I, J: Integer;
begin
  if Child is TControl then
    inherited SetChildOrder(Child, Order)
  else
  begin
    Dec(Order, ControlCount);
    J := -1;
    for I := 0 to ComponentCount - 1 do
      if not Components[I].HasParent then
      begin
        Inc(J);
        if J = Order then
        begin
          Child.ComponentIndex := I;
          Exit;
        end;
      end;
  end;
end;

end.





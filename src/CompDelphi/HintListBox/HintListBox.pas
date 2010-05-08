{ ****************************************************************** }
{                                                                    }
{   Delphi component THintListBox                                    }
{                                                                    }
{   ListBox com hint nos textos longos ou com hint mult-line         }
{                                                                    }
{   Codigo adaptado do componente TWAIHintListBox retirado de um     }
{   artigo do site www.delphizine.com                                }
{                                                                    }
{   Copyright © 2001 by WAISS Systems' - http://www.waiss.com        }
{                                                                    }
{ ****************************************************************** }

unit HintListBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type

  TNotifyBeforeShowItemHint = procedure(Sender: TObject; Index : Integer; var Hint : String) of object;

  THintListBox = class(TListBox)
  private
    FHintText: Boolean;
    FOnMouseExit: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnBeforeShowItemHint: TNotifyBeforeShowItemHint;
    procedure SetHintText(const Value: Boolean);
    procedure SetOnMouseEnter(const Value: TNotifyEvent);
    procedure SetOnMouseExit(const Value: TNotifyEvent);
    procedure SetOnBeforeShowItemHint(
      const Value: TNotifyBeforeShowItemHint);
  protected
    { Private declarations }
  procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

  public
      HintWin:THintWindow;

      constructor Create(AOwner: TComponent); override;
      destructor  Destroy; override;
      procedure DefaultHandler(var Message); Override;
  published

   Property OnMouseEnter:TNotifyEvent read FOnMouseEnter write SetOnMouseEnter;
   Property OnMouseExit:TNotifyEvent read FOnMouseExit write SetOnMouseExit;
   Property HintText:Boolean read FHintText write SetHintText;
   Procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
   property OnBeforeShowItemHint: TNotifyBeforeShowItemHint read FOnBeforeShowItemHint write SetOnBeforeShowItemHint;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Miscelanea', [THintListBox]);
end;

{ THintListBox }
{-----------------------------------------------------------------------------}
procedure THintListBox.CMMouseEnter(var Message: TMessage);
begin
  inherited;

  If assigned(FOnMouseEnter) then fonmouseenter(self);
end;
{-----------------------------------------------------------------------------}
procedure THintListBox.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  HintWin.ReleaseHandle;
  If assigned(FOnMouseExit) then fonmouseexit(self);
end;
{-----------------------------------------------------------------------------}
constructor THintListBox.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  HintWin := THintWindow.Create(self);
  Hintwin.Color := clInfoBk;
  hintwin.Canvas.Font.Color := clInfoText;
end;
{-----------------------------------------------------------------------------}
procedure THintListBox.DefaultHandler(var Message);
var
   msgT:TMsg;
begin
  // convert message to TMsg
  MsgT.message := TMessage(Message).Msg;
  Inherited;
    if hintwin = nil then Exit;
    if (TMessage(Message).Msg = WM_VScroll) or
      (HintWin.IsHintMsg(MsgT) and
       //if it's WM_Mousemove then we don't want to hide the hint window
      (MsgT.message <> WM_MouseMove))
      then HintWin.ReleaseHandle
end;
{-----------------------------------------------------------------------------}
destructor THintListBox.Destroy;
begin
  Inherited;
end;
{-----------------------------------------------------------------------------}
procedure THintListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
Var Ind:integer;
rct:TRect;
  S : String;
begin
if Not(HintText) then
begin  //Item hinting is off
  HintWin.ReleaseHandle;
  inherited;
  exit;
end;
  // Get the index of the item under the mouse pointer
 Ind := ItemAtPos(Point(x,y),true);
 // Check if it is a legal item
 If ind = -1 then exit;


   if  Assigned(FOnBeforeShowItemHint) then
    begin
      S := '';
      FOnBeforeShowItemHint( self, ind, S );
      // Get the string's dimensions.
      rct := HintWin.CalcHintRect(Screen.Width, S, nil);
      // Add the Hint offsets to the rectangle. Note: This
      // can be problematic since the x, y represents the
      // cursor's hotspot which isn't always the top-left of
      // the cursor. The Application hint tests for this and
      // positions the window appropriately. However, this is
      // a complex test that cannot be implemented here.
      // Instead, we will risk it and position it at X and
      // Y + 16.
      OffsetRect(Rct, x, y + 20);
      Rct.Right := Rct.Right + 3;
      // Convert to screen coordinates, so
      // THintWindow can use them.
      Rct.TopLeft := ClientToScreen(Rct.TopLeft);
      Rct.BottomRight := ClientToScreen(rct.BottomRight);
       // And display.
      HintWin.ActivateHint(rct,S);
    end

 else


 // Check if the Item Text is wider then the cliprectangle
 if Canvas.textWidth(Items[ind]) >
   ((Canvas.ClipRect.Right - Canvas.ClipRect.Left) -3) then
 Begin
   // Get the default item coordinates
   rct := ItemRect(ind);
   // Stretch it to fit the whole item text
   Rct.Right := Rct.Left + Canvas.textWidth(Items[ind])+9;
   // Fine tune theses values for apperance
   Rct.Top := Rct.Top -3;
   Rct.Bottom := rct.Bottom -1;
   rct.Left := rct.left -1;
   // now convert to screen coordinates so that THintWindow can use them
   rct.TopLeft := ClientToScreen(rct.TopLeft);
   rct.BottomRight := ClientToScreen(rct.BottomRight);
   // And show
   HintWin.ActivateHint(rct,items[ind]);
 end
 else
 HintWin.ReleaseHandle;
Inherited;

end;
{-----------------------------------------------------------------------------}
procedure THintListBox.SetHintText(const Value: Boolean);
begin
  FHintText := Value;
end;
{-----------------------------------------------------------------------------}
procedure THintListBox.SetOnBeforeShowItemHint(
  const Value: TNotifyBeforeShowItemHint);
begin
  FOnBeforeShowItemHint := Value;
end;

procedure THintListBox.SetOnMouseEnter(const Value: TNotifyEvent);
begin
  FOnMouseEnter := Value;
end;
{-----------------------------------------------------------------------------}
procedure THintListBox.SetOnMouseExit(const Value: TNotifyEvent);
begin
  FOnMouseExit := Value;
end;

end.

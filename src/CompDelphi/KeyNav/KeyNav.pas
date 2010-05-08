unit KeyNav;

// This unit contains the source code for the TKeyNavigator component.
// It was written by Nokolai Botev (bono8106@hotmail.com). The component
// was described in the UNDU newsletter for July 1999.
// The original code contained 2 bugs, which have been fixed by Bill Gray
// (w.gray@clinmed.gla.ac.uk).
// The bug fixes are as follows:
//    (1) The function KeyboardHook, which detects when one of the target
//        keys has been pressed, originally had no code to deal with the
//        Enter key. I have added the required code.
//    (2) The Shift key was not processed properly. This processing is done
//        in the procedure FocusNextControl. I have simplified and corrected
//        the original code.
//  Modification date: 10 August 1999.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  EKeyNavigator = class(Exception);

  TMyWControl=class (TWinControl);

  TKeyNavigator = class(TComponent)
  private
    FActive: Boolean;
    FHandle: HHook;
    FLeftRightClasses: string;
    FUpDownClasses: string;
    FEnterClasses: string;
    procedure SetActive(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Handle: HHook read FHandle;
  published
    property Active: Boolean read FActive write SetActive default True;
    property EnterClasses: string read FEnterClasses write FEnterClasses;
    property LeftRightClasses: string read FLeftRightClasses
      write FLeftRightClasses;
    property UpDownClasses: string read FUpDownClasses write FUpDownClasses;
  end;

procedure FocusNextControl(GoForward: Boolean);
function IsOfClasses(AObject: TObject; const AClasses: string): Boolean;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Bufi', [TKeyNavigator]);
end;

{ TKeyNavigator }

var
  KeyNavigator: TKeyNavigator;

constructor TKeyNavigator.Create(AOwner: TComponent);
begin
  if Assigned(KeyNavigator) then
    raise EKeyNavigator.Create('Only one instance of TKeyNavigator per application allowed');
  inherited Create(AOwner);
  KeyNavigator := Self;
  Active := True;
end;

destructor TKeyNavigator.Destroy;
begin
  Active := False;
  KeyNavigator := nil;
  inherited Destroy;
end;

procedure FocusNextControl(GoForward: Boolean);
var
  Form: TCustomForm;
  Keyboard: TKeyboardState;
  OldShift: Byte;
begin
  Form := Screen.ActiveCustomForm;
  if Assigned(Form) then begin
    GetKeyboardState(Keyboard);
    OldShift := Keyboard[VK_SHIFT];
    if not GoForward then
      Keyboard[VK_SHIFT] := not Keyboard[VK_SHIFT];
//  The original form of this if statement was as follows:
//    if GoForward then
//      Keyboard[VK_SHIFT] := Keyboard[VK_SHIFT] and not 128
//    else
//      Keyboard[VK_SHIFT] := Keyboard[VK_SHIFT] or 128;
    SetKeyboardState(Keyboard);
    SendMessage(Form.Handle, CM_DIALOGKEY, VK_TAB, 0);
    Keyboard[VK_SHIFT] := OldShift;
    SetKeyboardState(Keyboard);
  end;
end;

function IsOfClasses(AObject: TObject; const AClasses: string): Boolean;
var
  AClassName: string;

  function IsOfClass: Boolean;
  var
    AClass: TClass;
  begin
    AClass := AObject.ClassType;
    repeat
      Result := AClass.ClassName = AClassName;
      AClass := AClass.ClassParent;
    until Result or (AClass = nil);
  end;

var
  StartPos, EndPos, Len: Integer;
begin
  Len := Length(AClasses);
  StartPos := 1;
  EndPos := 1;
  repeat
    while (EndPos <= Len) and (AClasses[EndPos] <> ';') do Inc(EndPos);
    AClassName := Trim(Copy(AClasses, StartPos, EndPos - StartPos));
    if IsOfClass then begin
      Result := True;
      Exit;
    end;
    if (EndPos <= Len) and (AClasses[EndPos] = ';') then Inc(EndPos);
    StartPos := EndPos;
  until (StartPos > Len);
  Result := False;
end;

function KeyboardHook(code: Integer; wParam: WPARAM;
  lParam: LPARAM): LRESULT; stdcall;
var
  Control: TMyWControl; //Pablo
  x : Char;
begin
//    Control := TMyWControl(Screen.ActiveControl); //Pablo
  if (code < 0) then // or (Assigned (Control.OnKeyPress )) then  //Pablo
    Result := CallNextHookEx(KeyNavigator.Handle, code, wParam, lParam)
  else begin
    Control := TMyWControl(Screen.ActiveControl);
    if (lParam and $80000000 = 0) and Assigned(Control) then begin
      if (IsOfClasses(Control, KeyNavigator.FLeftRightClasses) and
         ((wParam = VK_LEFT) or (wParam = VK_RIGHT))) or
         (IsOfClasses(Control, KeyNavigator.FUpDownClasses) and
         ((wParam = VK_UP) or (wParam = VK_DOWN))) or
         (IsOfClasses(Control, KeyNavigator.FEnterClasses) and
         ((wParam = VK_RETURN))) then
     begin

        x := chr( wparam ); //wgb
        if Assigned( Control ) and Assigned (Control.OnKeyPress ) then //wgb
           Control.OnKeyPress( KeyNavigator, x ); //wgb

        if x <> #0 then
           FocusNextControl((wParam = VK_DOWN) or (wParam = VK_RIGHT) or
                         (wParam = VK_RETURN));
//  The original form of this if statement was as follows:
//      if (IsOfClasses(Control, KeyNavigator.FLeftRightClasses) and
//         ((wParam = VK_LEFT) or (wParam = VK_RIGHT))) or
//         (IsOfClasses(Control, KeyNavigator.FUpDownClasses) and
//         ((wParam = VK_UP) or (wParam = VK_DOWN))) then
//      begin
//        FocusNextControl((wParam = VK_DOWN) or (wParam = VK_RIGHT));
        Result := 1;
      end else
        Result := 0
    end else
      Result := 0;
  end;
end;

procedure TKeyNavigator.SetActive(const Value: Boolean);
begin
  if (Value <> FActive) then begin
    FActive := Value;
    if not (csDesigning in ComponentState) then
      if FActive then begin
        FHandle := SetWindowsHookEx(WH_KEYBOARD, KeyboardHook, 0,
          GetCurrentThreadID);
        if (FHandle = 0) then
          raise EKeyNavigator.Create('Keyboard navigator cannot be activated.');
      end else
        if UnhookWindowsHookEx(FHandle) then FHandle := 0
        else raise EKeyNavigator.Create('Keyboard navigator cannot be deactivated.');
  end;
end;

end.

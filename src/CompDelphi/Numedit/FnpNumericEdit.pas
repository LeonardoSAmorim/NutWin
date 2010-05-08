{
  Author: Fredrik Nordbakke - FNProgramvare © 1997
  E-mail: fredrik.nordbakke@ostfoldnett.no
  WWW:	  http://www.prodat.no/fnp/delphi.html

  Changes made by Phillip G Cole (hhappy@hotmail.com) are indicated by PGC
  and are to

  1) prevent excessive onChange events being produced, especially for
     when Decimals = 0. Note: FnpNumericEdit still generates an erroneous
     onChange event when it is created.
  2) disabled OnChange events whilst deleting a multiple character selection
  3) stop the return key from zeroing the entry when pressed
  4) increased version number to 1.00.02

  1.00.03 - FN

  1) added test to prevent leading zero (f.ex. 0200)

  1.00.04 - PGC

  1) used a 'slicker' way of avoiding onChange event for multiple characters.
  2) allowed code to be used under Delphi 1.0.
  3) provided for the text edit height bug in Win 3.x
  4) increased version number to 1.00.04.
  KNOWN BUG: Say entry into FnpNumericEdit is 340001.2 and cursor is placed
             after the 4.  When backspace is pressed 4 will be deleted, leaving
             30001.2 as expected, if pressed again 0001.2 will be left.

  1.00.05 - PGC

  1) disabled the onChange event if the csLoading is in ComponentState

  1.00.06 - PGC

  1) Prevented the '-' key from doing anything if MinValue is not negative.

  1.00.07 - PGC

  1) Added ValidChange event property, this is exactly the same as the onChange
     event except it is only triggered when the value entered is between
     MinValue and MaxValue

  1.00.08 - PGC

  1) Added minor piece of code at top of KeyPress to check for return or escape
     keys, catching them and passing to the parent form so that they can be used
     for default buttons on modal forms.

  1.00.09 - FN

  1) Disabled OnChange event in SetFormatMask
}

unit FnpNumericEdit;

interface

uses
  WinTypes, WinProcs, Menus, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;

type
  TFnpNumericEdit = class(TCustomEdit)
  private
    { Private declarations }
    FAlignment: TAlignment;
    FDecimals: ShortInt;
    FInvalidEntry: TNotifyEvent;
    FValidChange: TNotifyEvent;
    FMaxValue: Double;
    FMinValue: Double;
    FVersion: String;
    FormatMask: String;
    {$IFDEF Win32}
    function GetAsCurrency: Currency;
    procedure SetAsCurrency(Value: Currency);
    {$ENDIF}
    function GetAsFloat: Double;
    function GetAsInteger: Integer;
    { PGC - added works with WMSize }
    function GetValue: Double;
    procedure SetAlignment(Value: TAlignment);
    procedure SetAsFloat(Value: Double);
    procedure SetAsInteger(Value: Integer);
    procedure SetDecimals(Value: ShortInt);
    procedure SetMaxValue(Value: Double);
    procedure SetMinValue(Value: Double);
    procedure SetValue(Value: Double);
    procedure SetVersion(Value: String);
    procedure DeleteKey(Key: Word);
    procedure DeleteSelection;
    procedure InvalidEntry;
    procedure SetFormatMask;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    {$IFNDEF Win32 }
    { PGC - added to stop text height but in Win 3.x }
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    {$ENDIF }
  protected
    { Protected declarations }
    procedure Change; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    {$IFDEF Win32}
    property AsCurrency: Currency read GetAsCurrency write SetAsCurrency;
    {$ENDIF}
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
  published
    { Published declarations }
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    {$IFDEF Win32}
    property OnStartDrag;
    {$ENDIF}
    { New properties }
    property Alignment: TAlignment read FAlignment write SetAlignment default taRightJustify;
    property Decimals: ShortInt read FDecimals write SetDecimals default 2;
    property MaxValue: Double read FMaxValue write SetMaxValue;
    property MinValue: Double read FMinValue write SetMinValue;
    property Value: Double read GetValue write SetValue;
    property Version: String read FVersion write SetVersion stored False;
    property OnInvalidEntry: TNotifyEvent read FInvalidEntry write FInvalidEntry;
    property OnValidChange: TNotifyEvent read FValidChange write FValidChange;
  end;

procedure Register;

implementation

uses Clipbrd;

constructor TFnpNumericEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 73;
  FAlignment := taRightJustify;
  FDecimals := 2;
  FMaxValue := 0;
  FMinValue := 0;
  FVersion := '1.00.08';
  Value := 0;
  Text:= FloatToStr(Value);
  SetFormatMask;
end;

procedure TFnpNumericEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array[TAlignment] of Word = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  { PGC - Added ES_Number style (v4.0 or later) }
  Params.Style:= Params.Style or ES_NUMBER or ES_MULTILINE or Alignments[FAlignment];
end;

procedure TFnpNumericEdit.Change;
var
  NumVal: extended;  { Save having to convert value twice - for speed }
begin
  inherited Change;
  NumVal:= Value;
  if (NumVal >= MinValue) and (NumVal <= MaxValue) then
    if Assigned(FValidChange) then
      FValidChange(Self);
end;

procedure TFnpNumericEdit.DoEnter;
begin
  { Need this since AutoSelect has no effect for multi-line controls }
  if AutoSelect and not (csLButtonDown in ControlState) then
    SelectAll;
  inherited DoEnter;
end;

procedure TFnpNumericEdit.DoExit;
begin
  if FMinValue <> FMaxValue then
    if (AsFloat < FMinValue) or (AsFloat > FMaxValue) then
      InvalidEntry;
  inherited DoExit;
end;

procedure TFnpNumericEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if not ReadOnly then        { Added 26.03.97 }
    if Key = VK_DELETE then
    begin
      if SelLength > 0 then
      begin
        DeleteSelection;
        { PGC - added to notify of change when select deleted }
        Change;
      end else
        DeleteKey(VK_DELETE);
      { "Eat" the keystroke here to prevent default handling }
      Key:= 0;
    end;
  inherited KeyDown(Key, Shift)
end;

procedure TFnpNumericEdit.KeyPress(var Key: Char);
var
  X: Integer;
  N: Boolean;
begin
  { PGC - Added 26/09/97 code snipped niced from Rx Components RxSpin }
  if (Key = Char(VK_RETURN)) or (Key = Char(VK_ESCAPE)) then
  begin
    { must catch and remove this, since is actually multi-line }
    GetParentForm(Self).Perform(CM_DIALOGKEY, Byte(Key), 0);
    if Key = Char(VK_RETURN) then Key := #0;
  end;

  inherited KeyPress(Key);

  if ReadOnly then exit;           { Added 26.03.97 }
  { Ctrl C, V and X. }
  if Key in [#3, #22, #24] then exit;
  if Key = DecimalSeparator then
    SelLength := 0
  else
    if (SelLength > 0) then DeleteSelection;
  N := (Pos('-', Text) > 0);
  { Only accept 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, -, decimal separator and backspace }
  if not (Key in ['0'..'9', DecimalSeparator, '-', #3, #8, #22, #24]) then
    Key := #0;
  { No leading zero - added v1.00.03}
  if (SelStart = 0) and (Key = '0') then
    Key := #0;
  { Is decimal separator pressed and no decimals? }
  if (Key = DecimalSeparator) and (FDecimals = 0) then Key := #0;
  if (Key = '-') then
  begin
    if MinValue < 0 then
    begin
      X:= SelStart;
      if Pos('-', Text) = 0 then
      begin
        Text:= '-' + Text;
        SelStart := X + 1;
      end else
      begin
        Text:= Copy(Text, 2, Length(Text) - 1);
        SelStart:= X - 1;
      end;
    end;
    Key := #0;
  end;
  if (SelStart = Length(Text)) and (Key <> #8) and (Key <> DecimalSeparator) and (FDecimals > 0) then
    Key := #0;
  if Key = DecimalSeparator then
  begin
    { Decimal separator is pressed }
    SelStart := Length(Text) - FDecimals;
    Key := #0;
  end;
  { Don't overwrite '-' }
  if N and (SelStart = 0) then SelStart := 1;
  if Key <> #0 then
    if Key = #8 then
    begin
      if SelLength > 0 then DeleteSelection else DeleteKey(VK_BACK);
      { "Eat" the keystroke here to prevent default handling }
      Key := #0;
    end else
      if FDecimals = 0 then
      begin
        { No decimals }
        if (SelStart <= 2) and (Copy(Text, 2, 1) = '0') and N then
        begin
          { Overwrite zero when negative }
          { PGC changed from
            SelStart := 1;
            SelLength := 1;
            to the below to eliminate onChange event when text = '' }
          Text:= '-' + Key;
          SelLength:= 0;
          SelStart:= 1;
          Key:= #0;
        end else
          if (SelStart <= 1) and (Copy(Text, 1, 1) = '0') then
          begin
            { Overwrite zero when not negative }
            { PGC changed from
              SelStart:= 0;
              SelLength:= 1;
              to below to eliminate onChange event when text ='' }
            Text:= Key;
            SelLength:= 0;
            SelStart:= 1;
            Key:= #0;
          end;
      end else
      begin
        { Decimals }
        if (SelStart <= 2) and (Copy(Text, 2, 1) = '0') and N then
        begin
          { Overwrite zero when negative }
          { PGC changed from
            SelStart:= 1;
            SelLength:= 1;
            to the below to remove extra OnChange events }
          Text:= '-' + Key + Copy(Text, 3, Length(Text) - 2);
          SelLength:= 0;
          SelStart:= 2;
          Key:= #0;
        end else
          if (SelStart <= 1) and (Copy(Text, 1, 1) = '0') then
          begin
            { Overwrite zero when not negative }
            { PGC changed from
              SelStart := 0;
              SelLength := 1;
              to the below to remove extra OnChange events }
            Text:= Key + Copy(Text, 2, Length(Text) - 1);
            SelLength:= 0;
            SelStart:= 1;
            Key:= #0;
          end else
            if SelStart >= (Length(Text) - FDecimals) then
            begin
              { Overwrite decimals }
              { PGC changed from
                SelLength := 1
                to the below to remove extra OnChange events }
                X:= SelStart;
                Text:= Copy(Text, 1, SelStart) + Key + Copy(Text, SelStart + 2, Length(Text));
                SelStart:= X + 1;
                SelLength:= 0;
                Key:= #0;
            end else
              if SelStart < (Length(Text) - FDecimals) - 1 then
              begin
                { Overwrite digit if left of decimal point }
                { PGC changed from
                  SelLength := 1;
                  to the below to remove extra OnChange events }
                X:= SelStart;
                if SelStart + SelLength > Length(Text) - FDecimals then
                  { If selection passes over decimal point }
                  dec(X);
                Text:= Copy(Text, 1, SelStart) + Key + Copy(Text, SelStart + 1, Length(Text));
                SelStart:= X + 1;
                SelLength:= 0;
                Key:= #0;
              end;
      end; 
end;

{$IFDEF Win32}
function TFnpNumericEdit.GetAsCurrency: Currency;
begin
  Result := StrToCurr(Text);
end;

procedure TFnpNumericEdit.SetAsCurrency(Value: Currency);
begin
  Text := FormatFloat(FormatMask, Value);
end;
{$ENDIF}

function TFnpNumericEdit.GetAsFloat: Double;
begin
  Result := StrToFloat(Text);
end;

function TFnpNumericEdit.GetAsInteger: Integer;
begin
  Result := trunc(StrToFloat(Text));
end;

function TFnpNumericEdit.GetValue: Double;
begin
  Result := StrToFloat(Text);
end;

procedure TFnpNumericEdit.SetAsFloat(Value: Double);
begin
  Text := FormatFloat(FormatMask, Value);
end;

procedure TFnpNumericEdit.SetAsInteger(Value: Integer);
begin
  Text := FormatFloat(FormatMask, Value);
end;

procedure TFnpNumericEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

procedure TFnpNumericEdit.SetDecimals(Value: ShortInt);
begin
  if FDecimals <> Value then
    if Value < 0 then
      Value := 0;
    if Value > 9 then
      Value := 9;
    begin
      FDecimals := Value;
      SetFormatMask;
    end;
end;

procedure TFnpNumericEdit.SetMaxValue(Value: Double);
begin
  if FMaxValue <> Value then begin
    FMaxValue := Value;
  end;
end;

procedure TFnpNumericEdit.SetMinValue(Value: Double);
begin
  if FMinValue <> Value then begin
    FMinValue := Value;
  end;
end;

procedure TFnpNumericEdit.SetValue(Value: Double);
var
  NewText: string;
  ChangeEvent: TNotifyEvent;
  DisabledOnChange: boolean;
begin
  { If loading from stream then don't want to issue change event }
  DisabledOnChange:= csReading in ComponentState;
  ChangeEvent:= onChange;
  if DisabledOnChange then onChange:= nil;
  { PGC added comparison to current text }
  NewText:= FormatFloat(FormatMask, Value);
  if Text <> NewText then
    Text:= NewText;
  { Re-Enable the change event  }
  onChange:= ChangeEvent;
end;

procedure TFnpNumericEdit.DeleteKey(Key: Word);
var
  P: Integer;
  N: Boolean;
begin
  { Always delete character to the left of P }
  if Key = VK_DELETE then
    P := SelStart + 1
  else
    P := SelStart;
  N := (Pos('-', Text) > 0);
  if (P = 0) or (P = Length(Text) + 1) then
    { Can't delete non-existent character }
    exit;
  if FDecimals = 0 then
  begin
    { No decimals }
    if (P = 2) and (Length(Text) = 2) and N then
    begin
      { Reset only digit to 0 when negative - no decimals }
      Text := '-0' + Copy(Text, 3, Length(Text) - 2);
      SelStart := 1;
    end else
      if (P = 1) and (Length(Text) = 1) then
      begin
        { Reset only digit to 0 - no decimals }
        Text := '0' + Copy(Text, 2, Length(Text) - 1);
        SelStart := 1;
      end else
      begin
        Text := Copy(Text, 1, P - 1) + Copy(Text, P + 1, Length(Text) - P);
        SelStart := P - 1;
      end
  end else
  begin
    { Decimals }
    if P > (Length(Text) - FDecimals) then
    begin
      { Delete decimal - reset to 0 }
      Text := Copy(Text, 1, P - 1) + Copy(Text, P + 1, Length(Text) - P) + '0';
      SelStart := P - 1;
    end else
      if (P = (Length(Text) - FDecimals)) then
        { Not possible to delete decimal point }
        if Key = VK_DELETE then
          SelStart := (Length(Text) - FDecimals)
        else
          SelStart := (Length(Text) - FDecimals) - 1
      else
        if (P = 2) and (P = (Length(Text) - FDecimals) - 1) and N then
        begin
          { Reset only digit to 0 when negative }
          Text := '-0' + Copy(Text, 3, Length(Text) - 2);
          SelStart := 1;
        end else
          if (P = 1) and (P = (Length(Text) - FDecimals) - 1) then
          begin
            { Reset only digit to 0 }
            Text := '0' + Copy(Text, 2, Length(Text) - 1);
            SelStart := 1;
          end else
            if P > 0 then
            begin
              { Delete digit left of decimal point }
              Text := Copy(Text, 1, P - 1) + Copy(Text, P + 1, Length(Text) - P);
              { SetText(Copy(Text, 1, P - 1) + Copy(Text, P + 1, Length(Text) - P)); }
              SelStart := P - 1;
            end;
  end;
end;

procedure TFnpNumericEdit.DeleteSelection;
var
  X: Integer;
  Y: Integer;
  ChangeEvent: TNotifyEvent;
begin
  { PGC - disable onChange event from occuring
    for each character in the selection }
  ChangeEvent:= onChange;
  onChange:= nil;
  { PGC - Delete selection }
  if SelLength = 0 then exit;
  Y := Length(SelText);
  SelStart := SelStart + Y;
  for X:= 1 to Y do begin
    DeleteKey(VK_BACK);
  end;
  { PGC - re-enable onChange events once more }
  onChange:= ChangeEvent;
end;

procedure TFnpNumericEdit.InvalidEntry;
begin
  if assigned(FInvalidEntry) then
    FInvalidEntry(Self);
end;

procedure TFnpNumericEdit.SetFormatMask;

{$IFNDEF Win32}
  function StringOfChar(const Character: Char; const StrLength: word): string;
  var
    OutString: String[255];
  begin
    FillChar(OutString, SizeOf(OutString), ord(Character));
    OutString[0]:= chr(StrLength);
    StringOfChar:= OutString;
  end;
{$ENDIF}

var
  ChangeEvent: TNotifyEvent;

begin
  if FDecimals = 0 then
    FormatMask := '0'
  else
    FormatMask := '0.' + StringOfChar('0', FDecimals);

  { Disable OnChange event - v1.00.09 }
  ChangeEvent:= onChange;
  onChange:= nil;
  try
    Text := FormatFloat(FormatMask, AsFloat);
  finally
    onChange:= ChangeEvent;
  end;
end;

procedure TFnpNumericEdit.SetVersion(Value: String);
begin
  { This property is read only! }
end;

procedure TFnpNumericEdit.WMCut(var Message: TMessage);
begin
  CopyToClipboard;
  DeleteSelection;
end;

procedure TFnpNumericEdit.WMPaste(var Message: TMessage);
var
  X: integer;
  S: String;
  W: Word;
begin
  DeleteSelection;
  S := Clipboard.AsText;
  for X := 1 to Length(S) do begin
    W := Ord(S[X]);
    Perform(WM_CHAR, W, 0);
  end;
end;

{$IFNDEF Win32 }
{ PGC - added to fix text edit bug in Win 3.x }
procedure TFnpNumericEdit.WMSize(var Message: TWMSize);

  { Code 'borrowed' from Delphi's Spin example }
  function GetMinHeight: Integer;
  var
    DC: HDC;
    SaveFont: HFont;
    I: Integer;
    SysMetrics, Metrics: TTextMetric;
  begin
    DC := GetDC(0);
    GetTextMetrics(DC, SysMetrics);
    SaveFont:= SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
    ReleaseDC(0, DC);
    I := SysMetrics.tmHeight;
    if I > Metrics.tmHeight then I := Metrics.tmHeight;
    Result:= Metrics.tmHeight + I div 4 + GetSystemMetrics(SM_CYBORDER) * 4 + 2;
  end;

var
  MinHeight: Integer;
begin
  inherited;
  MinHeight := GetMinHeight;
    { text edit bug: if size to less than minheight, then edit ctrl does
      not display the text }
  if Height < MinHeight then
    Height:= MinHeight;
end;
{$ENDIF}

procedure Register;
begin
  RegisterComponents('Sample', [TFnpNumericEdit]);
end;

end.


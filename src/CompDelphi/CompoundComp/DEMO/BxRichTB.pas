{*******************************************************}
{                                                       }
{       Delphi Visual Component Library                 }
{                                                       }
{       This Composite created with                     }
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
{$Warnings Off}
unit BxRichTB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Boxes, ExtCtrls, StdCtrls, ComCtrls, ImgList, ToolWin;

type
  TBxRichToolBar = class(TToolBarBox)
    ToolbarImages: TImageList;
    ColorDlg: TColorDialog;
    PrintButton: TToolButton;
    CutButton: TToolButton;
    CopyButton: TToolButton;
    PasteButton: TToolButton;
    UndoButton: TToolButton;
    FontName: TComboBox;
    FontSize: TEdit;
    FontUpDown: TUpDown;
    FontColorButton: TToolButton;
    BoldButton: TToolButton;
    ItalicButton: TToolButton;
    UnderlineButton: TToolButton;
    LeftAlignButton: TToolButton;
    CenterAlignButton: TToolButton;
    RightAlignButton: TToolButton;
    BulletButton: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    PrintDlg: TPrintDialog;
    procedure PrintButtonClick(Sender: TObject);
    procedure CutButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure PasteButtonClick(Sender: TObject);
    procedure UndoButtonClick(Sender: TObject);
    procedure FontNameChange(Sender: TObject);
    procedure FontSizeChange(Sender: TObject);
    procedure FontColorButtonClick(Sender: TObject);
    procedure BoldButtonClick(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure UnderlineButtonClick(Sender: TObject);
    procedure AlignButtonClick(Sender: TObject);
    procedure BulletButtonClick(Sender: TObject);
    procedure BxRichToolBarCreate(Sender: TObject);
  private
    FRichEdit: TCustomRichEdit;
    FUpdating: Boolean;
    procedure SetRichEdit(const Value: TCustomRichEdit);
    function CurrText: TTextAttributes;
    procedure GetFontNames;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure EnableButtons(const Value: boolean);
  published
    procedure SelectionChange(Sender: TObject);
    property RichEditor: TCustomRichEdit read FRichEdit write SetRichEdit;
  end;

implementation

{$R *.DFM}

procedure TBxRichToolBar.SetRichEdit(const Value: TCustomRichEdit);
begin
  if FRichEdit <> Value then
  begin
    FRichEdit := Value;
    if Assigned(FRichEdit) then
      begin
        FRichEdit.FreeNotification(Self);
        TRichEdit(FRichEdit).OnSelectionChange:=SelectionChange;
        GetFontNames;
        FontName.OnChange:=FontNameChange;
        FontSize.OnChange:=FontSizeChange;
        SelectionChange(Self);
        EnableButtons(True);
      end
    else
      begin
        FontName.OnChange:=nil;
        FontSize.OnChange:=nil;
        EnableButtons(False);
      end;
  end;
end;

procedure TBxRichToolBar.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) and (AComponent=FRichEdit) then
  begin
    TRichEdit(FRichEdit).OnSelectionChange:=nil;
    SetRichEdit(nil);
  end;
end;

procedure TBxRichToolBar.SelectionChange(Sender: TObject);
begin
  with FRichEdit.Paragraph do
  try
    FUpdating := True;
    BoldButton.Down := fsBold in FRichEdit.SelAttributes.Style;
    ItalicButton.Down := fsItalic in FRichEdit.SelAttributes.Style;
    UnderlineButton.Down := fsUnderline in FRichEdit.SelAttributes.Style;
    BulletButton.Down := Boolean(Numbering);
    FontSize.Text := IntToStr(FRichEdit.SelAttributes.Size);
    FontName.Text := FRichEdit.SelAttributes.Name;
    case Ord(Alignment) of
      0: LeftAlignButton.Down := True;
      1: RightAlignButton.Down := True;
      2: CenterAlignButton.Down := True;
    end;
  finally
    FUpdating := False;
  end;
end;

function TBxRichToolBar.CurrText: TTextAttributes;
begin
  if not Assigned(FRichEdit) then Exit;
  if FRichEdit.SelLength > 0 then
    Result := FRichEdit.SelAttributes
  else
    Result := FRichEdit.DefAttributes;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;

procedure TBxRichToolBar.GetFontNames;
var
  DC: HDC;
begin
  DC := GetDC(0);
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(FontName.Items));
  ReleaseDC(0, DC);
  FontName.Sorted := True;
end;

{ Button's event handlers }

procedure TBxRichToolBar.PrintButtonClick(Sender: TObject);
begin
  if PrintDlg.Execute then
    FRichEdit.Print(EmptyStr);
end;

procedure TBxRichToolBar.CutButtonClick(Sender: TObject);
begin
  FRichEdit.CutToClipboard;
end;

procedure TBxRichToolBar.CopyButtonClick(Sender: TObject);
begin
  FRichEdit.CopyToClipboard;
end;

procedure TBxRichToolBar.PasteButtonClick(Sender: TObject);
begin
  FRichEdit.PasteFromClipboard;
end;

procedure TBxRichToolBar.UndoButtonClick(Sender: TObject);
begin
  with FRichEdit do
    if HandleAllocated then SendMessage(Handle, EM_UNDO, 0, 0);
end;

procedure TBxRichToolBar.FontNameChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Name := FontName.Items[FontName.ItemIndex];
end;

procedure TBxRichToolBar.FontSizeChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Size := StrToInt(FontSize.Text);
end;

procedure TBxRichToolBar.FontColorButtonClick(Sender: TObject);
begin
  if ColorDlg.Execute then
    CurrText.Color:=ColorDlg.Color;
end;

procedure TBxRichToolBar.BoldButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if BoldButton.Down then
    CurrText.Style := CurrText.Style + [fsBold]
  else
    CurrText.Style := CurrText.Style - [fsBold];
end;

procedure TBxRichToolBar.ItalicButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if ItalicButton.Down then
    CurrText.Style := CurrText.Style + [fsItalic]
  else
    CurrText.Style := CurrText.Style - [fsItalic];
end;

procedure TBxRichToolBar.UnderlineButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if UnderlineButton.Down then
    CurrText.Style := CurrText.Style + [fsUnderline]
  else
    CurrText.Style := CurrText.Style - [fsUnderline];
end;

procedure TBxRichToolBar.AlignButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  FRichEdit.Paragraph.Alignment := TAlignment(TControl(Sender).Tag);
  SelectionChange(Self);  
end;

procedure TBxRichToolBar.BulletButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  FRichEdit.Paragraph.Numbering := TNumberingStyle(BulletButton.Down);
end;

procedure TBxRichToolBar.EnableButtons(const Value: boolean);
var
  i: integer;
begin
  if not IsCompositeDesign(Self) then
    for i:=0 to ControlCount-1 do
      Buttons[i].Enabled:=Value;
end;

procedure TBxRichToolBar.BxRichToolBarCreate(Sender: TObject);
begin
  EnableButtons(False);
end;

end.
      
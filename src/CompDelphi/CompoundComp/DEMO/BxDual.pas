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

unit BxDual;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Boxes, ExtCtrls, StdCtrls, ComCtrls, Buttons;

type
  TBxDualList = class(TControlGroupBox)
    SrcPanel: TPanel;
    SrcLabel: TLabel;
    SrcList: TListBox;
    BtnPanel: TPanel;
    DstPanel: TPanel;
    DstLabel: TLabel;
    DstList: TListBox;
    IncludeBtn: TSpeedButton;
    IncAllBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    ExAllBtn: TSpeedButton;
    procedure ExcAllBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure IncludeBtnClick(Sender: TObject);
    procedure BxDualListResize(Sender: TObject);
  private
  { SetXxx/GetXxx methods to publish sub-component's properties }
    function GetSrcItems: TStrings;
    function GetDstItems: TStrings;
    procedure SetSrcItems(const Value: TStrings);
    procedure SetDstItems(const Value: TStrings);
    function GetLabelSrc: string;
    procedure SetLabelSrc(const Value: string);
    function GetLabelDst: string;
    procedure SetLabelDst(const Value: string);
  public
    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
  published
    property Align;
  { Publishing sub-component's properties via SetXxx/GetXxx methods }
    property ItemsSrc: TStrings read GetSrcItems write SetSrcItems;
    property ItemsDst: TStrings read GetDstItems write SetDstItems;
    property LabelSrc: string read GetLabelSrc write SetLabelSrc;
    property LabelDst: string read GetLabelDst write SetLabelDst;    
  end;

implementation

{$R *.DFM}

const
  BtnPanelWidth = 40;
  
procedure TBxDualList.ExcAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to DstList.Items.Count - 1 do
    SrcList.Items.AddObject(DstList.Items[I], DstList.Items.Objects[I]);
  DstList.Items.Clear;
  SetItem(DstList, 0);
end;

procedure TBxDualList.ExcludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(DstList);
  MoveSelected(DstList, SrcList.Items);
  SetItem(DstList, Index);
end;

procedure TBxDualList.IncAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to SrcList.Items.Count - 1 do
    DstList.Items.AddObject(SrcList.Items[I], 
      SrcList.Items.Objects[I]);
  SrcList.Items.Clear;
  SetItem(SrcList, 0);
end;

procedure TBxDualList.IncludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(SrcList);
  MoveSelected(SrcList, DstList.Items);
  SetItem(SrcList, Index);
end;

procedure TBxDualList.MoveSelected(List: TCustomListBox; Items: TStrings);
var
  I: Integer;
begin
  for I := List.Items.Count - 1 downto 0 do
    if List.Selected[I] then
    begin
      Items.AddObject(List.Items[I], List.Items.Objects[I]);
      List.Items.Delete(I);
    end;
end;

procedure TBxDualList.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty;
  IncAllBtn.Enabled := not SrcEmpty;
  ExcludeBtn.Enabled := not DstEmpty;
  ExAllBtn.Enabled := not DstEmpty;
end;

function TBxDualList.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

procedure TBxDualList.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = LB_ERR then Index := 0
    else if Index > MaxIndex then Index := MaxIndex;
    Selected[Index] := True;
  end;
  SetButtons;
end;

{ SetXxx/GetXxx methods to publish sub-component's properties }

function TBxDualList.GetSrcItems: TStrings;
begin
  Result:=SrcList.Items;
end;

function TBxDualList.GetDstItems: TStrings;
begin
  Result:=DstList.Items;
end;

procedure TBxDualList.SetSrcItems(const Value: TStrings);
begin
  SrcList.Items.Assign(Value);
end;

procedure TBxDualList.SetDstItems(const Value: TStrings);
begin
  DstList.Items.Assign(Value);
end;

function TBxDualList.GetLabelSrc: string;
begin
  Result:=SrcLabel.Caption;
end;

procedure TBxDualList.SetLabelSrc(const Value: string);
begin
  SrcLabel.Caption:=Value;
end;

function TBxDualList.GetLabelDst: string;
begin
  Result:=DstLabel.Caption;
end;

procedure TBxDualList.SetLabelDst(const Value: string);
begin
  DstLabel.Caption:=Value;
end;

{ Don't replace this OnResize event handler when you use TBxDualList
  to prevent non-proportional resizing }

procedure TBxDualList.BxDualListResize(Sender: TObject);
var
  PanelWidth : integer;
begin
  PanelWidth:=(ClientWidth-BtnPanel.Width) div 2 - 2;
  SrcPanel.Width:=PanelWidth;
end;

end.
 
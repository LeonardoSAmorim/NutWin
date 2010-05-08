////////////////////////////////////////////////////////////////////////////////
// DBLISTVIEW98                                                               //
////////////////////////////////////////////////////////////////////////////////
// Virtual DB List view for D3                                                //
// * Icon, report, list, Hottracking, Column sorting, Column Hottracking,     //
//   Column dragging, SubItem bitmaps, new CustomDraw implementation,         //
//   Registry saving, ... and more                                            //
////////////////////////////////////////////////////////////////////////////////
// Version 1.70 Beta                                                          //
// Date de création           : 17/06/1997                                    //
// Date dernière modification : 26/08/1997                                    //
////////////////////////////////////////////////////////////////////////////////
// Jean-Luc Mattei                                                            //
// jlucm@club-internet.fr                                                     //
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// IMPORTANT NOTICE :                                                         //
//                                                                            //
//                                                                            //
// This program is FreeWare                                                   //
//                                                                            //
// Please do not release modified versions of this source code.               //
// If you've made any changes that you think should have been there,          //
// feel free to submit them to me at jlucm@club-internet.fr                   //
////////////////////////////////////////////////////////////////////////////////
// NOTES :                                                                    //
//                                                                            //
// * Entire table is in a buffer, it will be changed in next versions         //
// * With large fonts icon view is not very "pretty"                          //
// * Icon spacing will be added in next versions                              //
// * CheckBoxes will be implemented in the future                             //
////////////////////////////////////////////////////////////////////////////////
//  REVISIONS :                                                               //
//                                                                            //
//  0.6 :                                                                     //
//        * UpdateRowCount when ListView Resized                              //
//        * Changed KeyDown                                                   //
//        * VisibleRowCount removed (VisibleCount)                            //
//        * No Column Click if no index                                       //
//        * Added .DCR                                                        //
//        * Added property editors for fields and indexes                     //
//  0.7 :                                                                     //
//        * Removed a silly +TopItem                                          //
//        * Added Fieldtype validation                                        //
//        * Field verification to prevent errors on "mapping"                 //
//        * Item insertion (Insert Key) with notification "OnNewItem"         //
//        * Added GetColor (utilcolr.pas) color index compatible with         //
//          Borland's TColorGrid                                              //
//  0.8 :                                                                     //
//        * Added BeginUpdate / EndUpdate when ViewStyle changing             //
//        * Item n° verification in GetRecordNumber                           //
//        * ActiveRecord follows ActiveSelection                              //
//  0.9 :                                                                     //
//        * items Count verfification for empty tables error                  //
//        * All error messages are constants now                              //
//          Two langages supported french (define FRANCAIS) & english         //
//          (define ENGLISH) (not very hard to add more and to                //
//           correct my english)                                              //
//          thanks to Glen Verran he reminds me that french isn't universal :)//
//  1.0 :                                                                     //
//        * Added CanDelete & CanInsert properties                            //
//  1.1 :                                                                     //
//        * OnAskForColor, OnAskForIcon events added (thanks to Marc A. Hale) //
//  1.2 :                                                                     //
//        * Bug introduced with OnAskForColor fixed (Selection bug)           //
//        * Updates locked when Adding or removing fields from a table        //
//          (Access Violation)                                                //
//  1.3 : * DefaultIcon Property Added for Each columns                       //
//  1.4 : * If RegistryKey empty it uses Constantes Keys for Dynamic Registery//
//  1.5 : * Use of indexs modified for Master/Detail tables                   //
//        * DefaultSort is not reverse                                        //
//        * SetSort can be used to control sort order and IindexFieldname     //
//  1.6 : * Some Dataset Moving bugs corrected (whith HideSelection disabled) //
//        * No more error message when HideSelection is set to false with     //
//          a closed datasource                                               //
//  1.7 : * .Text is used instead of .AsString                                //
//        * Column alignment works now (not on the 1st column)                //
//          (thanks to Sibina)                                                //
////////////////////////////////////////////////////////////////////////////////

//{$DEFINE FRANCAIS}
{$DEFINE ENGLISH}

unit DBListView98;

{$R LISTVIEW98.RES}
{$R *.DCR}

interface

uses Messages, Windows, SysUtils, CommCtrl, Classes, Controls, Forms,
     Menus, Graphics, StdCtrls, RichEdit, ToolWin, ComCtrls, ImgList,
     DBCtrls, Db, DBTables, Constantes,dsgnintf;

type
  TListDBColumns = class;
  TCustomDBListView = class;

  TListViewDataLink = class(TDataLink)
  private
    FListView: TCustomDBListView;
    FFieldCount: Integer;
    FFieldMapSize: Integer;
    FFieldMap: Pointer;
    FModified: Boolean;
    FInUpdateData: Boolean;
    FSparseMap: Boolean;
    function GetDefaultFields: Boolean;
    function GetFields(I: Integer): TField;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure FocusControl(Field: TFieldRef); override;
    procedure EditingChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
    function  GetMappedIndex(ColIndex: Integer): Integer;
  public
    constructor Create(AListView: TCustomDBListView);
    destructor Destroy; override;
    function AddMapping(const FieldName: string): Boolean;
    procedure ClearMapping;
    procedure Modified;
    procedure Reset;
    property DefaultFields: Boolean read GetDefaultFields;
    property FieldCount: Integer read FFieldCount;
    property Fields[I: Integer]: TField read GetFields;
    property SparseMap: Boolean read FSparseMap write FSparseMap;
  end;

  TDBColumnValue = (cvColor, cvWidth, cvFont, cvAlignment, cvReadOnly, cvTitleColor,
    cvTitleCaption, cvTitleAlignment, cvTitleFont, cvImeMode, cvImeName);
  TDBColumnValues = set of TDBColumnValue;

  TListDBColumn = class(TCollectionItem)
  private
    FCaption: string;
    FColorField: TField;
    FColorFieldName: String;
    FAlignment: TAlignment;
    FWidth: TWidth;
    FField: TField;
    FFieldName: string;
    FFont: TFont;
    FIconField: TField;
    FIconFieldName: string;
    FDefaultIcon: Integer;
    FImeMode: TImeMode;
    FImeName: TImeName;
    FReadonly: Boolean;
    FIndexName: string;
    FAssignedValues: TDBColumnValues;
    procedure FontChanged(Sender: TObject);
    procedure DoChange;
    function  GetColorField: TField;
    function  GetField: TField;
    function  GetFont: TFont;
    function  GetIconField: TField;
    function  GetImeMode: TImeMode;
    function  GetImeName: TImeName;
    function  GetReadOnly: Boolean;
    function  GetOrder: Integer;
    function  GetWidth: TWidth;
    function  IsFontStored: Boolean;
    function  IsImeModeStored: Boolean;
    function  IsImeNameStored: Boolean;
    function  IsReadOnlyStored: Boolean;
    procedure ReadData(Reader: TReader);
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaption(const Value: string);
    procedure SetColorField(Value: TField);
    procedure SetColorFieldName(Value: string);
    procedure SetField(Value: TField); virtual;
    procedure SetFieldName(Value: String);
    procedure SetFont(Value: TFont);
    procedure SetIconField(Value: TField);
    procedure SetIconFieldName(Value: string);
    procedure SetImeMode(Value: TImeMode); virtual;
    procedure SetImeName(Value: TImeName); virtual;
    procedure SetIndexName(const Value: String);
    procedure SetReadOnly(Value: Boolean); virtual;
    procedure SetWidth(Value: TWidth);
    procedure WriteData(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function  GetDisplayName: string; override;
    function  GetListView: TCustomDBListView;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property  AssignedValues: TDBColumnValues read FAssignedValues;
    function  DefaultFont: TFont;
    function  DefaultImeMode: TImeMode;
    function  DefaultImeName: TImeName;
    function  DefaultReadOnly: Boolean;
    property  WidthType: TWidth read FWidth;
    property  ListView: TCustomDBListView read GetListView;
    property  Field: TField read GetField write SetField;
    property  ColorField: TField read GetColorField write SetColorField;
    property  IconField: TField read GetIconField write SetIconField;
    property  Order: Integer read GetOrder;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Caption: string read FCaption write SetCaption;
    property FieldName: String read FFieldName write SetFieldName;
    property ColorFieldName: String read FColorFieldName write SetColorFieldName;
    property IconFieldName: String read FIconFieldName write SetIconFieldName;
    property Font: TFont read GetFont write SetFont stored IsFontStored;
    property ImeMode: TImeMode read GetImeMode write SetImeMode stored IsImeModeStored;
    property ImeName: TImeName read GetImeName write SetImeName stored IsImeNameStored;
    property IndexName: String read FIndexName write SetIndexName;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly stored IsReadOnlyStored;
    property Width: TWidth read GetWidth write SetWidth default 50;
    property DefaultIcon: Integer read FDefaultIcon write FDefaultIcon default -1;
  end;

  TListDBColumns = class(TCollection)
  private
    FOwner: TCustomDBListView;
    function GetItem(Index: Integer): TListDBColumn;
    procedure SetItem(Index: Integer; Value: TListDBColumn);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TCustomDBListView);
    function Add: TListDBColumn;
    property ListView: TCustomDBListView read FOwner;
    function GetItemByPos(X: Integer): TListDBColumn;
    property Items[Index: Integer]: TListDBColumn read GetItem write SetItem; default;
  end;

{ TDBIconOptions }

  TDBIconOptions = class(TPersistent)
  private
    FListView: TCustomDBListView;
    FArrangement: TIconArrangement;
    FAutoArrange: Boolean;
    FWrapText: Boolean;
    procedure SetArrangement(Value: TIconArrangement);
    procedure SetAutoArrange(Value: Boolean);
    procedure SetWrapText(Value: Boolean);
  public
    constructor Create(AOwner: TCustomDBListView);
  published
    property Arrangement: TIconArrangement read FArrangement write SetArrangement default iaTop;
    property AutoArrange: Boolean read FAutoArrange write SetAutoArrange default False;
    property WrapText: Boolean read FWrapText write SetWrapText default True;
  end;

{ TCustomDBListView }

  TDBLVColumnClickEvent = procedure(Sender: TObject; Column: TListDBColumn) of object;
  TDBLVNewItemEvent = procedure(Sender: TObject; DataSet: TDataSet);
  TDBLVDeletedEvent = procedure(Sender: TObject; Item: Integer) of object;
  TDBLVEditingEvent = procedure(Sender: TObject; Item: Integer;
    var AllowEdit: Boolean) of object;
  TDBLVEditedEvent = procedure(Sender: TObject; Item: Integer; var S: string) of object;
  TDBLVChangeEvent = procedure(Sender: TObject; Item: Integer;
    Change: TItemChange) of object;
  TDBLVChangingEvent = procedure(Sender: TObject; Item: Integer;
    Change: TItemChange; var AllowChange: Boolean) of object;
  TDBLVCompareEvent = procedure(Sender: TObject; Item1, Item2: Integer;
    Data: Integer; var Compare: Integer) of object;
  TDBLVFindItemEvent = function(Sender: TObject; StartIndex: Integer; StrSearch: string; vkDirection, Flags : UINT) : Integer of Object;
  TDBLVAskForColor = function(Sender: TObject; Column: TListDBColumn): TColor of object;
  TDBLVAskForIcon  = function(Sender: TObject; Column: TListDBColumn): Integer of object;

  TCustomDBListView = class(TWinControl)
  private
    FAutoSave: Boolean;
    FDataLink: TListViewDataLink;
    FLayoutFromDataset: Boolean;
    FUpdateLock: Byte;
    FLayoutLock: Byte;
    FOldFrom: Integer;
    FOriginalImeName: TImeName;
    FOriginalImeMode: TImeMode;
    FKeepItem: Integer;
    FKeepSubItem: Integer;
    FBorderStyle: TBorderStyle;
    FViewStyle: TViewStyle;
    FReadOnly: Boolean;
    FLargeImages: TImageList;
    FSmallImages: TImageList;
    FStateImages: TImageList;
    FDragImage: TImageList;
    FMultiSelect: Boolean;
    FColumnClick: Boolean;
    FShowColumnHeaders: Boolean;
    FClicked: Boolean;
    FRClicked: Boolean;
    FIconOptions: TDBIconOptions;
    FHideSelection: Boolean;
    FListColumns: TListDBColumns;
    FMemStream: TMemoryStream;
    FColStream: TMemoryStream;
    FCheckStream: TMemoryStream;
    FEditInstance: Pointer;
    FDefEditProc: Pointer;
    FEditHandle: HWND;
    FHeaderInstance: Pointer;
    FDefHeaderProc: Pointer;
    FHeaderHandle: HWND;
    FDragIndex: Integer;
    FLastDropTarget: Integer;
    FCheckboxes: Boolean;
    FGridLines: Boolean;
    FHotTrack: Boolean;
    FHeaderHotTrack: Boolean;
    FRowSelect: Boolean;
    FLargeChangeLink: TChangeLink;
    FSmallChangeLink: TChangeLink;
    FStateChangeLink: TChangeLink;
    FForwardSort: Boolean;
    FCurrentSortCol: Integer;
    FSubItemImages: Boolean;
    FReading: Boolean;
    FOnNewItem: TDBLVNewItemEvent;
    FOnChange: TDBLVChangeEvent;
    FOnChanging: TDBLVChangingEvent;
    FOnColumnClick: TDBLVColumnClickEvent;
    FOnDeletion: TDBLVDeletedEvent;
    FOnEditing: TDBLVEditingEvent;
    FOnEdited: TDBLVEditedEvent;
    FOnInsert: TDBLVDeletedEvent;
    FOnCompare: TLVCompareEvent;
    FOnFindItem: TDBLVFindItemEvent;
    FOneClickActivate: Boolean;
    FHeaderDragDrop: Boolean;
    FBitmapUp: TBitmap;
    FBitmapDn: TBitmap;
    FBitmapNone: TBitmap;
    FRegistryKey: String;
    FCanDelete: Boolean;
    FCanInsert: Boolean;
    FOnAskForColor: TDBLVAskForColor;
    FOnAskForIcon: TDBLVAskForIcon;
    function  GetDataSource: TDataSource;
    function  AcquireFocus: Boolean;        // Ok
    procedure RecordChanged(Field: TField); // Ok
    procedure DataChanged;                  // Ok
    procedure SetDataSource(Value: TDataSource);
    procedure UpdateData;
    procedure UpdateRowCount;
    procedure UpdateActive;
    procedure InternalLayout;
    procedure EditingChanged;
    procedure ShowEditor;
    procedure HideEditor;
    function  GetVisibleCount: Integer;
    function  GetCount: Integer;
    procedure SetCount(Value: Integer);
    procedure DefineFieldMap; virtual;

    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMDrag(var Message: TCMDrag); message CM_DRAG;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure DoDragOver(Source: TDragObject; X, Y: Integer; CanDrop: Boolean);
    procedure EditWndProc(var Message: TMessage);
    function GetBoundingRect: TRect;
    function GetColumnFromIndex(Index: Integer): TListDBColumn;
    function GetDropTarget: Integer;
    function GetFocused: Integer;
    function GetOrder(Index: Integer): Integer;
    function GetIndex(Order: Integer): Integer;
    function GetRecordNumber(iItem: Integer): Integer;
    function GetSelCount: Integer;
    function GetSelection: Integer;
    function GetSelectedField: TField;
    function GetSelectedIndex: Integer;
    function GetTopItem: Integer;
    function GetViewOrigin: TPoint;
    //function GetVisibleRowCount: Integer;
    procedure HeaderWndProc(var Message: TMessage);
    procedure ImageListChange(Sender: TObject);
    procedure RestoreChecks;
    procedure SaveChecks;
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetColumnClick(Value: Boolean);
    procedure SetColumnHeaders(Value: Boolean);
    procedure SetDropTarget(Value: Integer);
    procedure SetFocused(Value: Integer);
    procedure SetHeaderDragDrop(Value: Boolean);
    procedure SetHideSelection(Value: Boolean);
    procedure SetIconOptions(Value: TDBIconOptions);
    procedure SetImageList(Value: HImageList; Flags: Integer);
    procedure SetIme;
    procedure SetLargeImages(Value: TImageList);
    procedure SetListColumns(Value: TListDBColumns);
    procedure SetMultiSelect(Value: Boolean);
    procedure SetOneClickActivate(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure SetSmallImages(Value: TImageList);
    procedure SetSelection(Value: Integer);
    procedure SetSelectedField(Value: TField);
    procedure SetSelectedIndex(Value: Integer);
    procedure SetStateImages(Value: TImageList);
    procedure SetTextBkColor(Value: TColor);
    procedure SetTextColor(Value: TColor);
    procedure SetViewStyle(Value: TViewStyle);
    procedure SetCheckboxes(Value: Boolean);
    procedure SetGridLines(Value: Boolean);
    procedure SetHotTrack(Value: Boolean);
    procedure SetHeaderHotTrack(Value: Boolean);
    procedure SetRowSelect(Value: Boolean);
    procedure SetSubItemImages(Value: Boolean);
    procedure ResetExStyles;
    function ValidHeaderHandle: Boolean;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMNotify(var Message: TWMNotify); message WM_NOTIFY;
    procedure WMParentNotify(var Message: TWMParentNotify); message WM_PARENTNOTIFY;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SetFOCUS;
    procedure WMKillFocus(var Message: TMessage); message WM_KillFocus;
    //procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    function ValidDataSet: Boolean;
    function GetActiveSortName : string;
  protected
    FAcquireFocus: Boolean;
    FUpdateFields: Boolean;
    procedure LayoutChanged; virtual;
    procedure LinkActive(Value: Boolean); virtual;
    procedure Loaded; override;
    function  AcquireLayoutLock: Boolean;
    procedure BeginLayout;
    procedure BeginUpdate;
    procedure CancelLayout;
    procedure EndLayout;
    procedure EndUpdate;
    function  GetEditText: String;
    procedure ScrollData(Distance: Integer);
    function CanChange(Item: Integer; Change: Integer): Boolean; dynamic;
    function CanEdit(Item: Integer): Boolean; dynamic;
    procedure Change(Item: Integer; Change: Integer); dynamic;
    procedure ColClick(Column: TListDBColumn); dynamic;
    function ColumnsShowing: Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Delete(Item: Integer); dynamic;
    procedure NewItem; dynamic;
    procedure DestroyWnd; override;
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
    procedure DoStartDrag(var DragObject: TDragObject); override;
    procedure Edit(const Item: TLVItem); dynamic;
    function GetDragImages: TDragImageList; override;
    procedure InsertItem(Item: Integer); dynamic;
    function  IsItemSelected(Value: Integer): Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpdateColumn(Index: Integer);
    procedure UpdateColumns;
    procedure WndProc(var Message: TMessage); override;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property CanDelete: Boolean read FCanDelete write FCanDelete;
    property CanInsert: Boolean read FCanInsert write FCanInsert;
    property Columns: TListDBColumns read FListColumns write SetListColumns;
    property ColumnClick: Boolean read FColumnClick write SetColumnClick default True;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default True;
    property IconOptions: TDBIconOptions read FIconOptions write SetIconOptions;
    property LargeImages: TImageList read FLargeImages write SetLargeImages;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect default False;
    property OnChange: TDBLVChangeEvent read FOnChange write FOnChange;
    property OnChanging: TDBLVChangingEvent read FOnChanging write FOnChanging;
    property OnColumnClick: TDBLVColumnClickEvent read FOnColumnClick
      write FOnColumnClick;
    property OnCompare: TLVCompareEvent read FOnCompare write FOnCompare;
    property OnDeletion: TDBLVDeletedEvent read FOnDeletion write FOnDeletion;
    property OnEdited: TDBLVEditedEvent read FOnEdited write FOnEdited;
    property OnEditing: TDBLVEditingEvent read FOnEditing write FOnEditing;
    property OnFindItem: TDBLVFindItemEvent read FOnFindItem write FOnFindItem;
    property OnNewtem: TDBLVNewItemEvent read FOnNewItem write FOnNewItem;
    property OnInsert: TDBLVDeletedEvent read FOnInsert write FOnInsert;
    property ShowColumnHeaders: Boolean read FShowColumnHeaders write
      SetColumnHeaders default True;
    property SmallImages: TImageList read FSmallImages write SetSmallImages;
    property StateImages: TImageList read FStateImages write SetStateImages;
    property ViewStyle: TViewStyle read FViewStyle write SetViewStyle default vsReport;
    property Order[Index: Integer]: Integer read GetOrder;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadPosition;
    procedure SavePosition;
    procedure SetSort(Index: Integer; IsForward: Boolean);
    procedure Arrange(Code: TListArrangement);
    procedure Clear;
    function GetItemAt(X, Y: Integer): Integer;
    function GetNearestItem(Point: TPoint;
      Direction: TSearchDirection): Integer;
    function GetNextItem(StartItem: Integer;
       Direction: TSearchDirection; States: TItemStates): Integer;
    function GetSearchString: string;
    function IsEditing: Boolean;
    procedure Scroll(DX, DY: Integer);

    property AutoSave: Boolean read FAutoSave write FAutoSave;
    property Count: Integer read GetCount write SetCount;
    property VisibleCount: Integer read GetVisibleCount;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataLink: TListViewDataLink read FDataLink;
    property SelectedField: TField read GetSelectedField write SetSelectedField;
    property SelectedIndex: Integer read GetSelectedIndex write SetSelectedIndex;
    property UpdateLock: Byte read FUpdateLock;

    property Checkboxes: Boolean read FCheckboxes write SetCheckboxes default False;
    property Column[Index: Integer]: TListDBColumn read GetColumnFromIndex;
    property DropTarget: Integer read GetDropTarget write SetDropTarget;
    property GridLines: Boolean read FGridLines write SetGridLines default False;
    property HeaderDragDrop: Boolean read FHeaderDragDrop write SetHeaderDragDrop default True;
    property HotTrack: Boolean read FHotTrack write SetHotTrack default False;
    property HeaderHotTrack: Boolean read FHeaderHotTrack write SetHeaderHotTrack default False;
    property ItemFocused: Integer read GetFocused write SetFocused;
    property OneClickActivate: Boolean read FOneClickActivate write SetOneClickActivate default True;
    property RowSelect: Boolean read FRowSelect write SetRowSelect default False;
    property RegistryKey: String read FRegistryKey write FRegistryKey;
    property SubItemImages: Boolean read FSubItemImages write SetSubItemImages default False;
    property SelCount: Integer read GetSelCount;
    property Selected: Integer read GetSelection write SetSelection;
    function CustomSort(SortProc: TLVCompare; lParam: Longint): Boolean;
    function StringWidth(S: string): Integer;
    procedure UpdateItems(FirstIndex, LastIndex: Integer);
    property TopItem: Integer read GetTopItem;
    property ViewOrigin: TPoint read GetViewOrigin;
    //property VisibleRowCount: Integer read GetVisibleRowCount;
    property BoundingRect: TRect read GetBoundingRect;
    property ActiveSortName: String read GetActiveSortName;
    property OnAskForColor: TDBLVAskForColor read FOnAskForColor write FOnAskForColor;
    property OnAskForIcon: TDBLVAskForIcon read FOnAskForIcon write FOnAskForIcon;
  end;

{ TDbListView }

  TDbListView = class(TCustomDBListView)
  published
    property AutoSave;
    property Align;
    property BorderStyle;
    property CanDelete;
    property CanInsert;
    property Color;
    property ColumnClick;
    property OnClick;
    property OnDblClick;
    property Checkboxes;
    property Columns;
    property Ctl3D;
    property DataSource;
    property DragMode;
    property ReadOnly default False;
    property Enabled;
    property Font;
    property GridLines;
    property HeaderDragDrop;
    property HideSelection;
    property HotTrack;
    property HeaderHotTrack;
    property IconOptions;
    property MultiSelect;
    property OneClickActivate;
    property RowSelect;
    property OnChange;
    property OnChanging;
    property OnColumnClick;
    property OnCompare;
    property OnDeletion;
    property OnEdited;
    property OnEditing;
    property OnEnter;
    property OnExit;
    property OnInsert;
    property OnDragDrop;
    property OnDragOver;
    property DragCursor;
    property OnStartDrag;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property RegistryKey;
    property ShowHint;
    property PopupMenu;
    property ShowColumnHeaders;
    property SubItemImages;
    property TabOrder;
    property TabStop default True;
    property ViewStyle;
    property Visible;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property LargeImages;
    property SmallImages;
    property StateImages;
    property OnAskForColor;
    property OnAskForIcon;
  end;

  type
  TDbListViewEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

type

  TDBStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual; abstract;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

procedure Register;

implementation

uses Printers, Consts, ComStrs, Dialogs, DBConsts, DBGrids, ComCtl98, Registry,
     TypInfo, Utilcolr;

const
{$ifdef FRANCAIS}
  StrColumnEditor        = 'Editeur de colonnes';
  StrNoSort              = 'pas de tri';
  StrColorFieldNameError = 'Le champ "ColorFieldName" doit être de type entier';
  StrIconFieldNameError  = 'Le champ "IconFieldName" doit être de type entier';
{$endif}
{$ifdef ENGLISH}
  StrColumnEditor        = 'Columns editor';
  StrNoSort              = 'no sort';
  StrColorFieldNameError = 'Field "ColorFieldName" must be integer type';
  StrIconFieldNameError  = 'Field "IconFieldName" must be integer type';
{$endif}

  MaxMapSize = (MaxInt div 2) div SizeOf(Integer);  { 250 million }
  rvHeaderCaption = 'HeaderCaption';
  rvHeaderOrder   = 'HeaderOrder';
  rvHeaderWidth   = 'HeaderWidth';
  rvViewStyle     = 'ViewStyle';
  rvCurrentSortCol= 'SortColumn';
  rvForwardSort   = 'ForwardSort';

{ TDbListViewEditor }

procedure TDbListViewEditor.ExecuteVerb(Index: Integer);
begin
  Designer.Modified;
end;

function TDbListViewEditor.GetVerb(Index: Integer): string;
begin
  Result := StrColumnEditor;
end;

function TDbListViewEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TDBStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TDBStringProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

type

  TDataFieldProperty = class(TDBStringProperty)
  public
    function GetDataSourcePropName: string; virtual;
    procedure GetValueList(List: TStrings); override;
  end;

function TDataFieldProperty.GetDataSourcePropName: string;
begin
  Result := 'DataSource';
end;

procedure TDataFieldProperty.GetValueList(List: TStrings);
var
  Instance: TListDBColumn;
  PropInfo: PPropInfo;
  DataSource: TDataSource;
begin
  if Not ( GetComponent(0) is TListDBColumn ) then Exit;
  Instance := GetComponent(0) as TListDBColumn;
  PropInfo := TypInfo.GetPropInfo(Instance.ListView.ClassInfo, GetDataSourcePropName);
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
  begin
    DataSource := TObject(GetOrdProp(Instance.ListView, PropInfo)) as TDataSource;
    if (DataSource <> nil) and (DataSource.DataSet <> nil) then
      DataSource.DataSet.GetFieldNames(List);
  end;
end;

  { TIndexFieldNamesProperty }

Type
  TIndexFieldNamesProperty = class(TDBStringProperty)
  public
    function GetDataSourcePropName: string; virtual;
    procedure GetValueList(List: TStrings); override;
  end;

function TIndexFieldNamesProperty.GetDataSourcePropName: string;
begin
  Result := 'DataSource';
end;

procedure TIndexFieldNamesProperty.GetValueList(List: TStrings);
var
  Instance: TListDBColumn;
  PropInfo: PPropInfo;
  DataSource: TDataSource;
  i: Integer;
begin
  if Not ( GetComponent(0) is TListDBColumn ) then Exit;
  Instance := GetComponent(0) as TListDBColumn;
  PropInfo := TypInfo.GetPropInfo(Instance.ListView.ClassInfo, GetDataSourcePropName);
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
  begin
    DataSource := TObject(GetOrdProp(Instance.ListView, PropInfo)) as TDataSource;
    if (DataSource <> nil) and (DataSource.DataSet <> nil) and ( DataSource.DataSet is TTable ) then begin
      with (DataSource.DataSet as TTable) do begin
        GetIndexNames(List);
        IndexDefs.Update;
        for I := 0 to IndexDefs.Count - 1 do
          with IndexDefs[I] do
            if not (ixExpression in Options) then List.Add(Fields);
      end;
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('Exemples', [TDbListView]);
  RegisterPropertyEditor(TypeInfo(string), TListDBColumn, 'ColorFieldName', TDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TListDBColumn, 'IconFieldName', TDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TListDBColumn, 'FieldName', TDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TListDBColumn, 'IndexName', TIndexFieldNamesProperty);
  //RegisterComponentEditor(TDbListView, TDbListViewEditor);
end;

procedure KillMessage(Wnd: HWnd; Msg: Integer);
// Delete the requested message from the queue, but throw back
// any WM_QUIT msgs that PeekMessage may also return
var
  M: TMsg;
begin
  M.Message := 0;
  if PeekMessage(M, Wnd, Msg, Msg, pm_Remove) and (M.Message = WM_QUIT) then
    PostQuitMessage(M.wparam);
end;

{ Error reporting }

procedure RaiseListViewError(const S: string);
begin
  raise EInvalidOperation.Create(S);
end;

{ TListViewDataLink }

type
  TIntArray = array[0..MaxMapSize] of Integer;
  PIntArray = ^TIntArray;

constructor TListViewDataLink.Create(AListView: TCustomDBListView);
begin
  inherited Create;
  FListView := AListView;
end;

destructor TListViewDataLink.Destroy;
begin
  ClearMapping;
  inherited Destroy;
end;

function TListViewDataLink.GetDefaultFields: Boolean;
var
  I: Integer;
begin
  Result := True;
  if DataSet <> nil then Result := DataSet.DefaultFields;
  if Result and SparseMap then
  for I := 0 to FFieldCount-1 do
    if PIntArray(FFieldMap)^[I] < 0 then
    begin
      Result := False;
      Exit;
    end;
end;

function TListViewDataLink.GetFields(I: Integer): TField;
begin
  if (0 <= I) and (I < FFieldCount) and (PIntArray(FFieldMap)^[I] >= 0) then
    Result := DataSet.Fields[PIntArray(FFieldMap)^[I]]
  else
    Result := nil;
end;

function TListViewDataLink.AddMapping(const FieldName: string): Boolean;
var
  Field: TField;
  NewSize: Integer;
begin
  Result := True;
  if FFieldCount >= MaxMapSize then RaiseListViewError(STooManyColumns);
  if SparseMap then
    Field := DataSet.FindField(FieldName)
  else
    Field := DataSet.FieldByName(FieldName);

  if FFieldCount = FFieldMapSize then
  begin
    NewSize := FFieldMapSize;
    if NewSize = 0 then
      NewSize := 8
    else
      Inc(NewSize, NewSize);
    if (NewSize < FFieldCount) then
      NewSize := FFieldCount + 1;
    if (NewSize > MaxMapSize) then
      NewSize := MaxMapSize;
    ReallocMem(FFieldMap, NewSize * SizeOf(Integer));
    FFieldMapSize := NewSize;
  end;
  if Assigned(Field) then
  begin
    PIntArray(FFieldMap)^[FFieldCount] := Field.Index;
    Field.FreeNotification(FListView);
  end
  else
    PIntArray(FFieldMap)^[FFieldCount] := -1;
  Inc(FFieldCount);
end;

procedure TListViewDataLink.ActiveChanged;
begin
  FListView.LinkActive(Active);
end;

procedure TListViewDataLink.ClearMapping;
begin
  if FFieldMap <> nil then
  begin
    FreeMem(FFieldMap, FFieldMapSize * SizeOf(Integer));
    FFieldMap := nil;
    FFieldMapSize := 0;
    FFieldCount := 0;
  end;
end;

procedure TListViewDataLink.Modified;
begin
  FModified := True;
end;

procedure TListViewDataLink.DataSetChanged;
begin
  FListView.DataChanged;
  FModified := False;
end;

procedure TListViewDataLink.DataSetScrolled(Distance: Integer);
begin
  FListView.ScrollData(Distance);
end;

procedure TListViewDataLink.LayoutChanged;
var
  SaveState: Boolean;
begin
  { FLayoutFromDataset determines whether default column width is forced to
    be at least wide enough for the column title.  }
  SaveState := FListView.FLayoutFromDataset;
  FListView.FLayoutFromDataset := True;
  try
    FListView.LayoutChanged;
  finally
    FListView.FLayoutFromDataset := SaveState;
  end;
  inherited LayoutChanged;
end;

procedure TListViewDataLink.FocusControl(Field: TFieldRef);
begin
  if Assigned(Field) and Assigned(Field^) then
  begin
    if (FListView.SelectedField = Field^) and FListView.AcquireFocus then
    begin
      Field^ := nil;
      FListView.ShowEditor;
    end;
  end;
end;

procedure TListViewDataLink.EditingChanged;
begin
  FListView.EditingChanged;
end;

procedure TListViewDataLink.RecordChanged(Field: TField);
begin
  FListView.RecordChanged(Field);
  FModified := False;
end;

procedure TListViewDataLink.UpdateData;
begin
  FInUpdateData := True;
  try
    if FModified then FListView.UpdateData;
    FModified := False;
  finally
    FInUpdateData := False;
  end;
end;

function TListViewDataLink.GetMappedIndex(ColIndex: Integer): Integer;
begin
  if (0 <= ColIndex) and (ColIndex < FFieldCount) then
    Result := PIntArray(FFieldMap)^[ColIndex]
  else
    Result := -1;
end;

procedure TListViewDataLink.Reset;
begin
  if FModified then RecordChanged(nil) else Dataset.Cancel;
end;

{ TListDBColumn }

constructor TListDBColumn.Create(Collection: TCollection);
var
  Column: TLVColumn;
begin
  inherited Create(Collection);
  FAssignedValues:= [];
  FFieldName:= '';
  FColorFieldName:= '';
  FDefaultIcon:= -1;
  FIconFieldName:= '';
  FIndexName:= '';
  FWidth := 50;
  FFont := TFont.Create;
  FFont.Assign(DefaultFont);
  FFont.OnChange := FontChanged;
  FAlignment := taLeftJustify;
  with Column do
  begin
    mask := LVCF_FMT or LVCF_WIDTH;
    fmt := LVCFMT_LEFT;
    cx := FWidth;
  end;
  ListView_InsertColumn(TListDBColumns(Collection).ListView.Handle, Index, Column);
end;

destructor TListDBColumn.Destroy;
begin
  FFont.Free;
  if TListDBColumns(Collection).ListView.HandleAllocated then
    ListView_DeleteColumn(TListDBColumns(Collection).ListView.Handle, Index);
  inherited Destroy;
end;

function TListDBColumn.DefaultFont: TFont;
var
  LV: TCustomDBListView;
begin
  LV := GetListView;
  if Assigned(LV) then
    Result := LV.Font
  else
    Result := FFont;
end;

function TListDBColumn.DefaultImeMode: TImeMode;
var
  ListV: TCustomDBListView;
begin
  ListV := GetListView;
  if Assigned(ListV) then
    Result := ListV.ImeMode
  else
    Result := FImeMode;
end;

function TListDBColumn.DefaultImeName: TImeName;
var
  ListV: TCustomDBListView;
begin
  ListV := GetListView;
  if Assigned(ListV) then
    Result := ListV.ImeName
  else
    Result := FImeName;
end;

function TListDBColumn.DefaultReadOnly: Boolean;
var
  ListV: TCustomDBListView;
begin
  ListV := GetListView;
  Result := (Assigned(ListV) and ListV.ReadOnly) or (Assigned(Field) and FField.ReadOnly);
end;

procedure TListDBColumn.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('WidthType', ReadData, WriteData,
    WidthType <= ColumnTextWidth);
end;

procedure TListDBColumn.FontChanged;
begin
  Include(FAssignedValues, cvFont);
  Changed(False);
end;

function TListDBColumn.GetColorField: TField;
var
  ListV: TCustomDBListView;
begin    { Returns Nil if FieldName can't be found in dataset }
  ListV := GetListView;
  if (FColorField = nil) and (Length(FColorFieldName) > 0) and Assigned(ListV) and ListV.ValidDataSet then
  with ListV.Datalink.Dataset do
    if Active or (not DefaultFields) then
      SetColorField(FindField(ColorFieldName));
  Result := FColorField;
end;

function TListDBColumn.GetField: TField;
var
  ListV: TCustomDBListView;
begin    { Returns Nil if FieldName can't be found in dataset }
  ListV := GetListView;
  if (FField = nil) and (Length(FFieldName) > 0) and Assigned(ListV) and ListV.ValidDataSet then
  with ListV.Datalink.Dataset do
    if Active or (not DefaultFields) then
      SetField(FindField(FieldName));
  Result := FField;
end;

function TListDBColumn.GetIconField: TField;
var
  ListV: TCustomDBListView;
begin    { Returns Nil if FieldName can't be found in dataset }
  ListV := GetListView;
  if (FIconField = nil) and (Length(FIconFieldName) > 0) and Assigned(ListV) and ListV.ValidDataSet then
  with ListV.Datalink.Dataset do
    if Active or (not DefaultFields) then
      SetIconField(FindField(IconFieldName));
  Result := FIconField;
end;

function TListDBColumn.GetFont: TFont;
var
  Save: TNotifyEvent;
begin
  if not (cvFont in FAssignedValues) and (FFont.Handle <> DefaultFont.Handle) then
  begin
    Save := FFont.OnChange;
    FFont.OnChange := nil;
    FFont.Assign(DefaultFont);
    FFont.OnChange := Save;
  end;
  Result := FFont;
end;

function TListDBColumn.GetImeMode: TImeMode;
begin
  if cvImeMode in FAssignedValues then
    Result := FImeMode
  else
    Result := DefaultImeMode;
end;

function TListDBColumn.GetImeName: TImeName;
begin
  if cvImeName in FAssignedValues then
    Result := FImeName
  else
    Result := DefaultImeName;
end;

function TListDBColumn.GetReadOnly: Boolean;
begin
  if cvReadOnly in FAssignedValues then
    Result := FReadOnly
  else
    Result := DefaultReadOnly;
end;

function TListDBColumn.GetOrder: Integer;
Var
  ListV: TCustomDBListView;
begin
  ListV:= GetListView;
  Result:= -1;
  if Assigned(ListV) and not (csLoading in ListV.ComponentState) then begin
    Result:=ListV.GetOrder(Index);
  end
end;

function TListDBColumn.GetListView: TCustomDBListView;
begin
  if Assigned(Collection) and (Collection is TListDBColumns) then
    Result := TListDBColumns(Collection).ListView
  else
    Result := nil;
end;

function TListDBColumn.IsFontStored: Boolean;
begin
  Result := (cvFont in FAssignedValues);
end;

function TListDBColumn.IsImeModeStored: Boolean;
begin
  Result := (cvImeMode in FAssignedValues) and (FImeMode <> DefaultImeMode);
end;

function TListDBColumn.IsImeNameStored: Boolean;
begin
  Result := (cvImeName in FAssignedValues) and (FImeName <> DefaultImeName);
end;

function TListDBColumn.IsReadOnlyStored: Boolean;
begin
  Result := (cvReadOnly in FAssignedValues) and (FReadOnly <> DefaultReadOnly);
end;

procedure TListDBColumn.ReadData(Reader: TReader);
begin
  with Reader do
  begin
    ReadListBegin;
    Width := TWidth(ReadInteger);
    ReadListEnd;
  end;
end;

procedure TListDBColumn.WriteData(Writer: TWriter);
begin
  with Writer do
  begin
    WriteListBegin;
    WriteInteger(Ord(WidthType));
    WriteListEnd;
  end;
end;

procedure TListDBColumn.SetColorField(Value: TField);
begin
  if FColorField = Value then Exit;
  FColorField := Value;
  if Assigned(Value) then
    FColorFieldName := Value.FieldName;
  Changed(False);
end;

procedure TListDBColumn.SetColorFieldName(Value: String);
var
  AField: TField;
  ListV: TCustomDBListView;
begin
  AField := nil;
  ListV := GetListView;
  if Assigned(ListV) and ListV.ValidDataSet and
    not (csLoading in ListV.ComponentState) and (Length(Value) > 0) then
      AField := ListV.DataLink.DataSet.FindField(Value); { no exceptions }
  if ( AField <> nil ) and Not ( AField.DataType in [ftFloat, ftSmallInt, ftInteger, ftWord] ) then begin
    MessageDlg(StrColorFieldNameError, mtWarning, [mbOk], 0 );
    Value:= '';
    AField:= nil;
  end;
  FColorFieldName := Value;
  SetColorField(AField);
  Changed(False);
end;

procedure TListDBColumn.SetIconField(Value: TField);
begin
  if FIconField = Value then Exit;
  FIconField := Value;
  if Assigned(Value) then
    FIconFieldName := Value.FieldName;
  Changed(False);
end;

procedure TListDBColumn.SetIconFieldName(Value: String);
var
  AField: TField;
  ListV: TCustomDBListView;
begin
  AField := nil;
  ListV := GetListView;
  if Assigned(ListV) and ListV.ValidDataSet and
    not (csLoading in ListV.ComponentState) and (Length(Value) > 0) then
      AField := ListV.DataLink.DataSet.FindField(Value); { no exceptions }
  if ( AField <> nil ) and Not ( AField.DataType in [ftAutoInc, ftFloat, ftSmallInt, ftInteger, ftWord] ) then begin
    MessageDlg(StrIconFieldNameError, mtWarning, [mbOk], 0 );
    Value:= '';
    AField:= nil;
  end;
  FIconFieldName := Value;
  SetIconField(AField);
  Changed(False);
end;

procedure TListDBColumn.SetField(Value: TField);
begin
  if FField = Value then Exit;
  FField := Value;
  if Assigned(Value) then
    FFieldName := Value.FieldName;
  Changed(False);
end;

procedure TListDBColumn.SetFieldName(Value: String);
var
  AField: TField;
  ListV: TCustomDBListView;
begin
  AField := nil;
  ListV := GetListView;
  if Assigned(ListV) and ListV.ValidDataSet and
    not (csLoading in ListV.ComponentState) and (Length(Value) > 0) then
      AField := ListV.DataLink.DataSet.FindField(Value); { no exceptions }
  FFieldName := Value;
  SetField(AField);
  Changed(False);
end;

procedure TListDBColumn.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  Include(FAssignedValues, cvFont);
  Changed(False);
end;

procedure TListDBColumn.SetImeMode(Value: TImeMode);
begin
  if (cvImeMode in FAssignedValues) or (Value <> DefaultImeMode) then
  begin
    FImeMode := Value;
    Include(FAssignedValues, cvImeMode);
  end;
  Changed(False);
end;

procedure TListDBColumn.SetImeName(Value: TImeName);
begin
  if (cvImeName in FAssignedValues) or (Value <> DefaultImeName) then
  begin
    FImeName := Value;
    Include(FAssignedValues, cvImeName);
  end;
  Changed(False);
end;

procedure TListDBColumn.SetIndexName(const Value: String);
var
  ListV: TCustomDBListView;
begin
  ListV := GetListView;
  FIndexName := Value;
  if Assigned(ListV) and ListV.ValidDataSet and
    not (csLoading in ListV.ComponentState) and (Length(Value) > 0) then
      ListV.UpdateData; { no exceptions }
  Changed(False);
end;

procedure TListDBColumn.SetReadOnly(Value: Boolean);
begin
  if (cvReadOnly in FAssignedValues) and (Value = FReadOnly) then Exit;
  FReadOnly := Value;
  Include(FAssignedValues, cvReadOnly);
  Changed(False);
end;

procedure TListDBColumn.DoChange;

  procedure WriteCols;
  var
    Writer: TWriter;
    LV: TCustomDBListView;
  begin
    LV := TListDBColumns(Collection).ListView;
    if LV.HandleAllocated or ([csLoading, csReading] * LV.ComponentState <> []) or
      LV.FReading then Exit;
    if LV.FColStream = nil then LV.FColStream := TMemoryStream.Create
    else LV.FColStream.Size := 0;
    Writer := TWriter.Create(LV.FColStream, 1024);
    try
      Writer.WriteCollection(Collection);
    finally
      Writer.Free;
      LV.FColStream.Position := 0;
    end;
  end;

var
  I: Integer;
begin
  for I := 0 to Collection.Count - 1 do
    if TListDBColumn(Collection.Items[I]).WidthType <= ColumnTextWidth then Break;
  Changed(I <> Collection.Count);
  WriteCols;
end;

procedure TListDBColumn.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    DoChange;
  end;
end;

function TListDBColumn.GetWidth: TWidth;
var
  Column: TLVColumn;
  ListV: TCustomDBListView;
begin
  ListV := TListDBColumns(Collection).ListView;
  if ListV.HandleAllocated then
  begin
    Column.mask := LVCF_WIDTH;
    ListView_GetColumn(ListV.Handle, Index, Column);
    Result := Column.cx;
    if WidthType > ColumnTextWidth then FWidth := Result;
  end
  else Result := FWidth;
end;

procedure TListDBColumn.SetWidth(Value: TWidth);
Var
  Column: TLVColumn;
  ListV: TCustomDBListView;
begin
  if FWidth <> Value then begin
    FWidth := Value;
    ListV := TListDBColumns(Collection).ListView;
    if ListV.HandleAllocated then begin
      Column.mask := LVCF_WIDTH;
      Column.cx:= Value;
      ListView_SetColumn(ListV.Handle, Index, Column);
    end;
    DoChange;
  end;
end;

procedure TListDBColumn.SetAlignment(Value: TAlignment);
begin
  if (Alignment <> Value) and (Index <> 0) then
  begin
    FAlignment := Value;
    Changed(False);
    TListDBColumns(Collection).ListView.Repaint;
  end;
end;

procedure TListDBColumn.Assign(Source: TPersistent);
var
  Column: TListDBColumn;
begin
  if Source is TListDBColumn then
  begin
    Column := TListDBColumn(Source);
    Alignment := Column.Alignment;
    Width := Column.Width;
    Caption := Column.Caption;
    FieldName := Column.FieldName;
    Field := Column.Field;
    if cvImeMode in TListDBColumn(Source).AssignedValues then
      ImeMode := Column.ImeMode;
    if cvImeName in TListDBColumn(Source).AssignedValues then
      ImeName := Column.ImeName;
    if cvReadOnly in TListDBColumn(Source).AssignedValues then
      ReadOnly := Column.ReadOnly;
    if cvTitleFont in TListDBColumn(Source).AssignedValues then
      Font := TColumnTitle(Source).Font;
  end
  else inherited Assign(Source);
end;

function TListDBColumn.GetDisplayName: string;
begin
  Result := Caption;
  if Result = '' then Result := inherited GetDisplayName;
end;

{ TListDBColumns }

constructor TListDBColumns.Create(AOwner: TCustomDBListView);
begin
  inherited Create(TListDBColumn);
  FOwner := AOwner;
end;

function TListDBColumns.GetItem(Index: Integer): TListDBColumn;
begin
  Result := TListDBColumn(inherited GetItem(Index));
end;

procedure TListDBColumns.SetItem(Index: Integer; Value: TListDBColumn);
begin
  inherited SetItem(Index, Value);
end;

function TListDBColumns.Add: TListDBColumn;
begin
  Result := TListDBColumn(inherited Add);
end;

function TListDBColumns.GetItemByPos(X: Integer): TListDBColumn;

Var i, W: Integer;

begin
  if ( Count = 0 ) then begin
    Result:= nil;
    Exit;
  end;
  i:= 1;
  W:= Items[0].Width;
  while (i < Count) And ( W > X ) do begin
    W:= W + Items[i].Width;
    Inc(i);
  end;
  if ( W <= X ) then
    result:= Items[i]
  else
    result:= Items[0];
end;

function TListDBColumns.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TListDBColumns.Update(Item: TCollectionItem);
begin
  if Item <> nil then
    ListView.UpdateColumn(Item.Index) else
    ListView.UpdateColumns;
end;



{ TDBIconOptions }

constructor TDBIconOptions.Create(AOwner: TCustomDBListView);
begin
  inherited Create;
  if AOwner = nil then raise Exception.Create(sInvalidOwner);
  FListView := AOwner;
  Arrangement := iaTop;
  AutoArrange := False;
  WrapText := True;
end;

procedure TDBIconOptions.SetArrangement(Value: TIconArrangement);
begin
  if Value <> Arrangement then
  begin;
    FArrangement := Value;
    FListView.RecreateWnd;
  end;
end;

procedure TDBIconOptions.SetAutoArrange(Value: Boolean);
begin
  if Value <> AutoArrange then
  begin
    FAutoArrange := Value;
    FListView.RecreateWnd;
  end;
end;

procedure TDBIconOptions.SetWrapText(Value: Boolean);
begin
  if Value <> WrapText then
  begin
    FWrapText := Value;
    FListView.RecreateWnd;
  end;
end;


{ TCustomDBListView }

constructor TCustomDBListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoSave:= False;
  FCanDelete:= False;
  FCanInsert:= True;
  FRegistryKey:= '';
  ControlStyle := ControlStyle - [csCaptureMouse] + [csDisplayDragImage, csReflector];
  FAcquireFocus := True;
  FDataLink := TListViewDataLink.Create(Self);
  FHeaderDragDrop:= true;
  FKeepItem:= 0;
  FKeepSubItem:= 0;
  FOldFrom:= 0;
  FOneClickActivate:= True;
  FUpdateFields := True;
  Width := 250;
  Height := 150;
  BorderStyle := bsSingle;
  ViewStyle := vsReport;
  ParentColor := False;
  TabStop := True;
  HideSelection := True;
  ShowColumnHeaders := True;
  ColumnClick := True;
  FDragIndex := -1;
  FListColumns := TListDBColumns.Create(Self);
  FIconOptions := TDBIconOptions.Create(Self);
  FDragImage := TImageList.CreateSize(32, 32);
  FEditInstance := MakeObjectInstance(EditWndProc);
  FHeaderInstance := MakeObjectInstance(HeaderWndProc);
  FLargeChangeLink := TChangeLink.Create;
  FLargeChangeLink.OnChange := ImageListChange;
  FSmallChangeLink := TChangeLink.Create;
  FSmallChangeLink.OnChange := ImageListChange;
  FStateChangeLink := TChangeLink.Create;
  FStateChangeLink.OnChange := ImageListChange;
  FBitmapUp:= TBitmap.Create;
  FBitmapUp.Monochrome:= False;
  FBitmapUp.LoadFromResourceName(HInstance, 'UP');
  FBitmapUp.TransparentMode:= tmFixed;
  FBitmapUp.TransparentColor:= clWhite;
  FBitmapDn:= TBitmap.Create;
  FBitmapDn.Monochrome:= False;
  FBitmapDn.LoadFromResourceName(HInstance, 'DOWN');
  FBitmapDn.TransparentMode:= tmFixed;
  FBitmapDn.TransparentColor:= clWhite;
  FBitmapNone:= TBitmap.Create;
  FBitmapNone.Monochrome:= False;
  FBitmapNone.LoadFromResourceName(HInstance, 'NONE');
  FBitmapNone.TransparentMode:= tmFixed;
  FBitmapNone.TransparentColor:= clWhite;
end;

destructor TCustomDBListView.Destroy;
begin
  if ( ValidDataSet ) then
    FDataLink.ActiveRecord:= 0;
  if ( FAutoSave ) then
    SavePosition;
  FBitmapUp.Free;
  FBitmapDn.Free;
  FBitmapNone.Free;
  FListColumns.Free;
  FListColumns:= nil;
  FDataLink.Free;
  FDataLink := nil;
  DestroyWindowHandle;
  FDragImage.Free;
  FIconOptions.Free;
  FSubItemImages:= False;
  FMemStream.Free;
  FColStream.Free;
  FCheckStream.Free;
  FreeObjectInstance(FEditInstance);
  if FHeaderHandle <> 0 then
    SetWindowLong(FHeaderHandle, GWL_WNDPROC, LongInt(FDefHeaderProc));
  FreeObjectInstance(FHeaderInstance);
  FLargeChangeLink.Free;
  FSmallChangeLink.Free;
  FStateChangeLink.Free;
  inherited Destroy;
end;

procedure TCustomDBListView.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of Integer = (0, WS_BORDER);
  EditStyles: array[Boolean] of Integer = (LVS_EDITLABELS, 0);
  MultiSelections: array[Boolean] of Integer = (LVS_SINGLESEL, 0);
  HideSelections: array[Boolean] of Integer = (LVS_SHOWSELALWAYS, 0);
  Arrangements: array[TIconArrangement] of Integer = (LVS_ALIGNTOP,
    LVS_ALIGNLEFT);
  AutoArrange: array[Boolean] of Integer = (0, LVS_AUTOARRANGE);
  WrapText: array[Boolean] of Integer = (LVS_NOLABELWRAP, 0);
  ViewStyles: array[TViewStyle] of Integer = (LVS_ICON, LVS_SMALLICON,
    LVS_LIST, LVS_REPORT);
  ShowColumns: array[Boolean] of Integer = (LVS_NOCOLUMNHEADER, 0);
  ColumnClicks: array[Boolean] of Integer = (LVS_NOSORTHEADER, 0);
begin
  InitCommonControl(ICC_LISTVIEW_CLASSES);
  inherited CreateParams(Params);
  CreateSubClass(Params, WC_LISTVIEW);
  with Params do
  begin
    Style := Style or WS_CLIPCHILDREN or ViewStyles[ViewStyle] or
      BorderStyles[BorderStyle] or Arrangements[IconOptions.Arrangement] or
      EditStyles[ReadOnly] or MultiSelections[MultiSelect] or
      HideSelections[HideSelection] or
      AutoArrange[IconOptions.AutoArrange] or
      WrapText[IconOptions.WrapText] or
      ShowColumns[ShowColumnHeaders] or
      ColumnClicks[ColumnClick] or
      LVS_SHAREIMAGELISTS or LVS_OWNERDATA;
    if Ctl3D and NewStyleControls and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
    end;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TCustomDBListView.CreateWnd;
  procedure ReadCols;
  var
    Reader: TReader;
  begin
    FOriginalImeName := ImeName;
    FOriginalImeMode := ImeMode;
    if FColStream = nil then Exit;
    Columns.Clear;
    Reader := TReader.Create(FColStream, 1024);
    try
      Reader.ReadValue;
      Reader.ReadCollection(Columns);
    finally
      Reader.Free;
    end;
    FColStream.Destroy;
    FColStream := nil;
  end;

begin
  inherited CreateWnd;
  ResetExStyles;
  SetTextBKColor(Color);
  SetTextColor(Font.Color);
  if FMemStream <> nil then
  begin
    FReading := True;
    try
      Columns.Clear;
      FMemStream.ReadComponent(Self);
      FMemStream.Destroy;
      FMemStream := nil;
      if FCheckboxes then RestoreChecks;
      ReadCols;
      Font := Font;
    finally
      FReading := False;
    end;
  end;
  if (LargeImages <> nil) and LargeImages.HandleAllocated then
    SetImageList(LargeImages.Handle, LVSIL_NORMAL);
  if (SmallImages <> nil) and SmallImages.HandleAllocated then
    SetImageList(SmallImages.Handle, LVSIL_SMALL);
  if (StateImages <> nil) and StateImages.HandleAllocated then
    SetImageList(StateImages.Handle, LVSIL_STATE);
  Count:= 1;
end;

procedure TCustomDBListView.DestroyWnd;
begin
  if FMemStream = nil then FMemStream := TMemoryStream.Create
  else FMemStream.Size := 0;
  FMemStream.WriteComponent(Self);
  FMemStream.Position := 0;
  if FCheckboxes then SaveChecks;
  inherited DestroyWnd;
end;

procedure TCustomDBListView.SetImageList(Value: HImageList; Flags: Integer);
begin
  if HandleAllocated then ListView_SetImageList(Handle, Value, Flags);
end;

procedure TCustomDBListView.ImageListChange(Sender: TObject);
var
  ImageHandle: HImageList;
begin
  if HandleAllocated then
  begin
    ImageHandle := TImageList(Sender).Handle;
    if Sender = LargeImages then SetImageList(ImageHandle, LVSIL_NORMAL)
    else if Sender = SmallImages then SetImageList(ImageHandle, LVSIL_SMALL)
    else if Sender = StateImages then SetImageList(ImageHandle, LVSIL_STATE);
  end;
end;

procedure TCustomDBListView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = LargeImages then LargeImages := nil;
    if AComponent = SmallImages then SmallImages := nil;
    if AComponent = StateImages then StateImages := nil;
  end;
end;

procedure TCustomDBListView.HeaderWndProc(var Message: TMessage);
Var
  Info: THDHitTestInfo;
  Index: Integer;
begin
  try
    with Message do
    begin
      case Msg of
        WM_LBUTTONDOWN :
          with TWMLButtonDown(Message) do begin
            Info.Point.X:= Pos.X;
            Info.Point.Y:= Pos.Y;
            Index := SendMessage(FHeaderHandle, HDM_HITTEST, 0, Integer(@Info));
            if ( Index >= 0 ) And ( Not FHeaderDragDrop ) then
              if ( Columns[Index].IndexName = '' ) then Exit;
          end;
        WM_NCHITTEST:
          with TWMNCHitTest(Message) do
            if csDesigning in ComponentState then
            begin
              Result := Windows.HTTRANSPARENT;
              Exit;
            end;
        WM_NCDESTROY:
          begin
            Result := CallWindowProc(FDefHeaderProc, FHeaderHandle, Msg, WParam, LParam);
            FHeaderHandle := 0;
            FDefHeaderProc := nil;
            Exit;
          end;
      end;
      Result := CallWindowProc(FDefHeaderProc, FHeaderHandle, Msg, WParam, LParam);
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TCustomDBListView.EditWndProc(var Message: TMessage);
begin
  try
    with Message do
    begin
      case Msg of
        WM_KEYDOWN,
        WM_SYSKEYDOWN: if DoKeyDown(TWMKey(Message)) then Exit;
        WM_CHAR: if DoKeyPress(TWMKey(Message)) then Exit;
        WM_KEYUP,
        WM_SYSKEYUP: if DoKeyUp(TWMKey(Message)) then Exit;
        CN_KEYDOWN,
        CN_CHAR, CN_SYSKEYDOWN,
        CN_SYSCHAR:
          begin
            WndProc(Message);
            Exit;
          end;
      end;
      Result := CallWindowProc(FDefEditProc, FEditHandle, Msg, WParam, LParam);
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TCustomDBListView.UpdateItems(FirstIndex, LastIndex: Integer);
begin
  ListView_RedrawItems(Handle, FirstIndex, LastIndex);
end;

procedure TCustomDBListView.ResetExStyles;
var
  Styles: DWORD;
begin
  Styles := 0;
  if FCheckboxes then Styles := LVS_EX_CHECKBOXES;
  if FGridLines then Styles := Styles or LVS_EX_GRIDLINES;
  if FHotTrack then Styles := Styles or LVS_EX_TRACKSELECT;
  if FRowSelect then Styles := Styles or LVS_EX_FULLROWSELECT;
  if FSubItemImages then Styles := Styles or LVS_EX_SUBITEMIMAGES;
  if FHeaderDragDrop then Styles := Styles or LVS_EX_HEADERDRAGDROP;
  if FOneClickActivate then
    Styles := Styles or LVS_EX_ONECLICKACTIVATE
  else
    Styles := Styles or LVS_EX_TWOCLICKACTIVATE;
  ListView_SetExtendedListViewStyle(Handle, Styles);
end;

procedure TCustomDBListView.RestoreChecks;
begin
  {for i := 0 to Items.Count - 1 do
  begin
    if FCheckStream <> nil then
    begin
      FCheckStream.Read(Value, SizeOf(Value));
      Items[i].Checked := Value;
    end
    else
      Items[i].Checked := False;
  end;
  FCheckStream.Free;
  FCheckStream := nil;}
end;

procedure TCustomDBListView.SaveChecks;
begin
  {if FCheckStream = nil then FCheckStream := TMemoryStream.Create
  else FCheckStream.Size := 0;
  for i := 0 to Items.Count - 1 do
  begin
    Value := Items[i].Checked;
    FCheckStream.Write(Value, SizeOf(Value));
  end;
  FCheckStream.Position := 0;}
end;

procedure TCustomDBListView.SetCheckboxes(Value: Boolean);
begin
  if FCheckboxes <> Value then
  begin
    FCheckboxes := Value;
    ResetExStyles;
    if FCheckboxes then RestoreChecks;
  end;
end;

procedure TCustomDBListView.SetGridLines(Value: Boolean);
begin
  if FGridLines <> Value then
  begin
    FGridLines := Value;
    ResetExStyles;
  end;
end;

procedure TCustomDBListView.SetHotTrack(Value: Boolean);
begin
  if FHotTrack <> Value then
  begin
    FHotTrack := Value;
    ResetExStyles;
  end;
end;

procedure TCustomDBListView.SetHeaderHotTrack(Value: Boolean);
begin
  if FHeaderHotTrack <> Value then
  begin
    FHeaderHotTrack := Value;
    RecreateWnd;
  end;
end;

procedure TCustomDBListView.SetRowSelect(Value: Boolean);
begin
  if FRowSelect <> Value then
  begin
    FRowSelect := Value;
    ResetExStyles;
  end;
end;

procedure TCustomDBListView.SetSubItemImages(Value: Boolean);
begin
  if FSubItemImages <> Value then
  begin
    FSubItemImages := Value;
    ResetExStyles;
    Repaint;
  end;
end;

procedure TCustomDBListView.SetBorderStyle(Value: TBorderStyle);
begin
  if BorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TCustomDBListView.SetColumnClick(Value: Boolean);
begin
  if ColumnClick <> Value then
  begin
    FColumnClick := Value;
    RecreateWnd;
  end;
end;

procedure TCustomDBListView.SetMultiSelect(Value: Boolean);
begin
  if Value <> MultiSelect then
  begin
    FMultiSelect := Value;
    RecreateWnd;
  end;
end;

procedure TCustomDBListView.SetColumnHeaders(Value: Boolean);
begin
  if Value <> ShowColumnHeaders then
  begin
    FShowColumnHeaders := Value;
    RecreateWnd;
  end;
end;

procedure TCustomDBListView.SetTextColor(Value: TColor);
begin
  ListView_SetTextColor(Handle, ColorToRGB(Font.Color));
end;

procedure TCustomDBListView.SetTextBkColor(Value: TColor);
begin
  ListView_SetTextBkColor(Handle, ColorToRGB(Color));
end;

procedure TCustomDBListView.CMColorChanged(var Message: TMessage);
begin
  inherited;
  SetTextBkColor(Color);
end;

procedure TCustomDBListView.CMCtl3DChanged(var Message: TMessage);
begin
  if FBorderStyle = bsSingle then RecreateWnd;
  inherited;
end;

procedure TCustomDBListView.WMNotify(var Message: TWMNotify);
begin
  inherited;
  if ValidHeaderHandle then
    with Message.NMHdr^ do
      if (hWndFrom = FHeaderHandle) and (code = HDN_BEGINTRACK) then
        with PHDNotify(Pointer(Message.NMHdr))^, PItem^ do
          if (Mask and HDI_WIDTH) <> 0 then
            Column[Item].Width := cxy;
end;

function TCustomDBListView.ColumnsShowing: Boolean;
begin
  Result := (ViewStyle = vsReport);
end;

function TCustomDBListView.ValidHeaderHandle: Boolean;
begin
  Result := FHeaderHandle <> 0;
end;

procedure TCustomDBListView.CMFontChanged(var Message: TMessage);
begin
  inherited;
  if HandleAllocated then
  begin
    SetTextColor(Font.Color);
    if ValidHeaderHandle then
      InvalidateRect(FHeaderHandle, nil, True);
  end;
end;

procedure TCustomDBListView.SetHideSelection(Value: Boolean);
begin
  if Value <> HideSelection then
  begin
    FHideSelection := Value;
    RecreateWnd;
  end;
end;

procedure TCustomDBListView.SetReadOnly(Value: Boolean);
begin
  if Value <> ReadOnly then
  begin
    FReadOnly := Value;
    RecreateWnd;
  end;
end;

procedure TCustomDBListView.SetIconOptions(Value: TDBIconOptions);
begin
  with FIconOptions do
  begin
    Arrangement := Value.Arrangement;
    AutoArrange := Value.AutoArrange;
    WrapText := Value.WrapText;
  end;
end;

procedure TCustomDBListView.SetViewStyle(Value: TViewStyle);
const
  ViewStyles: array[TViewStyle] of Integer = (LVS_ICON, LVS_SMALLICON,
    LVS_LIST, LVS_REPORT);
var
  Style: Longint;
begin
  BeginUpdate;
  if Value <> FViewStyle then
  begin
    if ( FAutoSave ) And ( FViewStyle = vsReport ) then begin
      SavePosition;
    end;
    FViewStyle := Value;
    if HandleAllocated then
    begin
      Style := GetWindowLong(Handle, GWL_STYLE);
      Style := Style and (not LVS_TYPEMASK);
      Style := Style or ViewStyles[FViewStyle];
      SetWindowLong(Handle, GWL_STYLE, Style);
      UpdateColumns;
      case ViewStyle of
        vsIcon,
        vsSmallIcon:
          if IconOptions.Arrangement = iaTop then
            Arrange(arAlignTop) else
            Arrange(arAlignLeft);
      end;
    end;
    if ( FAutoSave ) And ( FViewStyle = vsReport ) then begin
      LoadPosition;
    end;
  end;
  EndUpdate;
end;

procedure TCustomDBListView.WMParentNotify(var Message: TWMParentNotify);
begin
  with Message do
    if (Event = WM_CREATE) and (FHeaderHandle = 0) then
    begin
      FHeaderHandle := ChildWnd;
      if FHeaderHotTrack then
        SetWindowLong(FHeaderHandle, GWL_STYLE, GetWindowLong(FHeaderHandle, GWL_STYLE) Or HDS_HOTTRACK);
      FDefHeaderProc := Pointer(GetWindowLong(FHeaderHandle, GWL_WNDPROC));
      SetWindowLong(FHeaderHandle, GWL_WNDPROC, LongInt(FHeaderInstance));
    end;
  inherited;
end;

function TCustomDBListView.GetSelCount: Integer;
begin
  Result := ListView_GetSelectedCount(Handle);
end;

function TCustomDBListView.AcquireFocus: Boolean;
begin
  Result := True;
  if FAcquireFocus and CanFocus and not (csDesigning in ComponentState) then
  begin
    SetFocus;
    Result := Focused;// or (InplaceEditor <> nil) and InplaceEditor.Focused;
  end;
end;

function TCustomDBListView.AcquireLayoutLock: Boolean;
begin
  Result := (FUpdateLock = 0) and (FLayoutLock = 0);
  if Result then BeginLayout;
end;

procedure TCustomDBListView.LayoutChanged;
begin
  if AcquireLayoutLock then
    EndLayout;
end;

procedure TCustomDBListView.BeginLayout;
begin
  BeginUpdate;
  if FLayoutLock = 0 then Columns.BeginUpdate;
  Inc(FLayoutLock);
end;

procedure TCustomDBListView.BeginUpdate;
begin
  Inc(FUpdateLock);
end;

procedure TCustomDBListView.CancelLayout;
begin
  if FLayoutLock > 0 then
  begin
    if FLayoutLock = 1 then
      Columns.EndUpdate;
    Dec(FLayoutLock);
    EndUpdate;
  end;
end;

procedure TCustomDBListView.LinkActive(Value: Boolean);
begin
  if not Value then HideEditor;
  LayoutChanged;
end;

procedure TCustomDBListView.DataChanged;
begin
  if not HandleAllocated then Exit;
  if ( FUpdateLock = 0 ) then begin
    if ( ValidDataSet and (dsInsert = FDataLink.DataSet.State)) then Exit;
    UpdateRowCount;
    UpdateActive;
    ValidateRect(Handle, nil);
    Invalidate;
  end;
end;

procedure TCustomDBListView.UpdateRowCount;

begin
  if Not ValidDataSet then Exit;
  if Count <= 1 then Count:= 1;
  with FDataLink do
    if not Active or (RecordCount = 0) or not HandleAllocated then
      Count := 0
    else
    begin
      Count := FDataLink.DataSet.RecordCount;
      FDataLink.BufferCount := Count; //VisibleCount;
      UpdateActive;
    end;
end;

procedure TCustomDBListView.RecordChanged(Field: TField);
var
  CField: TField;
begin
  if not HandleAllocated then Exit;
  Invalidate;
  CField := SelectedField;
  if ((Field = nil) or (CField = Field)) and
    (Assigned(CField) and (CField.Text <> GetEditText)) then
  begin
    (*InvalidateEditor;
    if InplaceEditor <> nil then InplaceEditor.Deselect;*)
  end;
end;

procedure TCustomDBListView.CNNotify(var Message: TWMNotify);
var
  OldActive: Integer;
begin
  with Message.NMHdr^ do
    case code of
      NM_CUSTOMDRAW:
        begin
          if ( Not ValidDataSet ) or ( FUpdateLock > 0 ) or ( FLayoutLock > 0 ) then Exit;
          with PNMLVCustomDraw(Pointer(Message.NMHdr))^ do begin
            if ( nmcd.dwDrawStage and CDDS_PREPAINT ) = CDDS_PREPAINT then begin
                Message.Result:= CDRF_NOTIFYITEMDRAW or CDRF_NEWFONT;
                if ( FListColumns.Count >= FKeepSubItem + 1 ) And ( ( nmcd.dwDrawStage and CDDS_ITEM ) = CDDS_ITEM ) and ( Count > 0 ) then begin
                  //if ( FListColumns[FKeepSubItem].ColorField <> Nil ) then begin
                  OldActive:= FDataLink.ActiveRecord;
                  try
                    BeginUpdate;
                    FDataLink.DataSet.DisableControls;
                    if (( nmcd.dwDrawStage and CDDS_ITEM ) = CDDS_ITEM ) and ( nmcd.dwItemspec >= 0 ) And ( nmcd.dwItemspec < Count ) then begin
                      FDataLink.ActiveRecord:= GetRecordNumber(nmcd.dwItemspec);
                      if ( ( nmcd.uItemstate AND ( CDIS_SELECTED or CDIS_FOCUS ) ) = ( CDIS_SELECTED or CDIS_FOCUS ) ) then begin
                        OldActive:= FDataLink.ActiveRecord;
                        //BeginUpdate;
                        //FDataLink.DataSet.DisableControls;
                        FDataLink.DataSet.First;
                        FDataLink.DataSet.MoveBy(OldActive);
                        //FDataLink.DataSet.EnableControls;
                        //EndUpdate;
                      end;
                      //if ( FListColumns.Count >= FKeepSubItem + 1 ) then begin
                      if ( Not ( csDesigning in ComponentState ) ) and Assigned ( OnAskForColor ) then
                        clrText:= OnAskForColor(Self, FListColumns[FKeepSubItem])
                      else
                        if ( FListColumns[FKeepSubItem].ColorField <> Nil ) then
                          clrText:= GetColor(FListColumns[FKeepSubItem].ColorField.AsInteger)
                        else
                          clrText:= Font.Color;
                      //end;
                    end;
                  finally
                    FDataLink.ActiveRecord:= OldActive;
                    FDataLink.DataSet.EnableControls;
                    EndUpdate;
                  end;
                  //end
                  //else
                  //  clrText:= Font.Color;
                  //if Assigned ( OnAskForColor ) then clrText:= OnAskForColor(Self, FListColumns[FKeepSubItem]);
                  Windows.SelectObject(nmcd.hdc, FListColumns[FKeepSubItem].Font.Handle);
                end;
            end;
          end;
        end;
      LVN_BEGINDRAG:
        with PNMListView(Pointer(Message.NMHdr))^ do
          FDragIndex := iItem;
      LVN_DELETEITEM:
        with PNMListView(Pointer(Message.NMHdr))^ do
          Delete(lParam);
      {LVN_DELETEALLITEMS:
        for I := Items.Count - 1 downto 0 do Delete(Items[I]);}
      LVN_GETDISPINFO:
        begin
          with PLVDispInfo(Pointer(Message.NMHdr))^.item do
          begin
            if ( FUpdateLock > 0 ) or ( FLayoutLock > 0 ) then Exit;
            if ValidDataSet and ( Count > 0 ) then begin
              OldActive:= FDataLink.ActiveRecord;
              FKeepSubItem:= iSubItem;
              FKeepItem:= GetRecordNumber(iItem);
              try
                BeginUpdate;
                FDataLink.DataSet.DisableControls;
                FDataLink.ActiveRecord:= FKeepItem;
                if (mask and LVIF_TEXT) <> 0 then begin
                  if ( FListColumns.Count >= iSubItem + 1 ) and ( FListColumns[iSubItem].Field <> nil ) then
                    StrPLCopy(pszText, FListColumns[iSubItem].Field.Text, cchTextMax)
                  else
                    StrPLCopy(pszText, '?', cchTextMax);
                end;
                if (mask and LVIF_IMAGE) <> 0 then begin
                  iImage:= -1;
                  if ( FListColumns.Count >= iSubItem + 1 ) then begin
                    if ( FListColumns[iSubItem].IconField <> Nil ) then
                      iImage:= FListColumns[iSubItem].IconField.AsInteger
                    else
                      iImage:= FListColumns[iSubItem].DefaultIcon;
                    if ( Not ( csDesigning in ComponentState ) ) and Assigned ( OnAskForIcon ) then
                      iImage:= OnAskForIcon(Self, FListColumns[iSubItem]);
                  end
                end;
                {if (mask and LVIF_INDENT) <> 0 then
                  iIndent := 0;}
              finally
                FDataLink.ActiveRecord:= OldActive;
                FDataLink.DataSet.EnableControls;
                EndUpdate;
              end;
            end
            else begin
              pszText:= '-';
              iImage:= -1;
            end;
            Message.Result:= 0;
          end;
        end;
      LVN_BEGINLABELEDIT:
        begin
          if not CanEdit(PLVDispInfo(Pointer(Message.NMHdr))^.item.iItem) then Message.Result := 1;
          if Message.Result = 0 then
          begin
            FEditHandle := ListView_GetEditControl(Handle);
            FDefEditProc := Pointer(GetWindowLong(FEditHandle, GWL_WNDPROC));
            SetWindowLong(FEditHandle, GWL_WNDPROC, LongInt(FEditInstance));
          end;
        end;
      LVN_ENDLABELEDIT:
        with PLVDispInfo(Pointer(Message.NMHdr))^ do
          if (item.pszText <> nil) and (item.IItem <> -1) then
            Edit(item);
      LVN_COLUMNCLICK:
        with PNMListView(Pointer(Message.NMHdr))^ do
          ColClick(Column[iSubItem]);
      LVN_INSERTITEM:
        with PNMListView(Pointer(Message.NMHdr))^ do
          InsertItem(iItem);
      LVN_ITEMCHANGING:
        with PNMListView(Pointer(Message.NMHdr))^ do
          if not CanChange(iItem, uChanged) then Message.Result := 1;
      LVN_ITEMCHANGED:
        with PNMListView(Pointer(Message.NMHdr))^ do
          Change(iItem, uChanged);
      NM_CLICK: FClicked := True;
      NM_RCLICK: FRClicked := True;
      LVN_ODCACHEHINT : begin
          // Here the list informs of the next items it'll have to draw on te screen
          // for buffering - not implemented for the moment.
          Message.Result:= 0;
        end;
      LVN_ODFINDITEM  :
        begin
          Message.Result:= 0;
          if ( Count > 0 ) then
            with PNMFindItem(Pointer(Message.NMHdr))^ do begin
              if Assigned ( OnFindItem ) then begin
                Message.Result:= OnFindItem(Self, iStart, StrPAS(lvfi.psz), lvfi.vkDirection, lvfi.Flags);
                exit;
              end;
              if ValidDataSet then begin
                if ( FListColumns.Count > GetIndex(0) ) then begin
                  OldActive:= FDataLink.ActiveRecord;
                  try
                    if ( FDataLink.DataSet.Locate(FListColumns[GetIndex(0)].FieldName, StrPas(lvfi.psz), [loPartialKey, loCaseInsensitive]) ) then
                      Message.Result:= GetRecordNumber(FDataLink.ActiveRecord);
                  except
                    FDataLink.ActiveRecord:= OldActive;
                    Message.Result:= OldActive;
                  end;
                end;
              end;
            end;
        end;
    end;
end;

procedure TCustomDBListView.ColClick(Column: TListDBColumn);
begin
  SetSort(Column.Index, Not FForwardSort);
  if Assigned(FOnColumnClick) then FOnColumnClick(Self, Column);
  Repaint;
end;

procedure TCustomDBListView.InsertItem(Item: Integer);
begin
  if Assigned(FOnInsert) then FOnInsert(Self, Item);
end;

function TCustomDBListView.CanChange(Item: Integer; Change: Integer): Boolean;
var
  ItemChange: TItemChange;
begin
  Result := True;
  case Change of
    LVIF_TEXT: ItemChange := ctText;
    LVIF_IMAGE: ItemChange := ctImage;
    LVIF_STATE: ItemChange := ctState;
  else
    Exit;
  end;
  if Assigned(FOnChanging) then FOnChanging(Self, Item, ItemChange, Result);
end;

procedure TCustomDBListView.Change(Item: Integer; Change: Integer);
var
  ItemChange: TItemChange;
begin
  case Change of
    LVIF_TEXT: ItemChange := ctText;
    LVIF_IMAGE: ItemChange := ctImage;
    LVIF_STATE: ItemChange := ctState;
  else
    Exit;
  end;
  if Assigned(FOnChange) then FOnChange(Self, Item, ItemChange);
end;

procedure TCustomDBListView.Delete(Item: Integer);
begin
  if (Item <> -1) And ValidDataSet then
  begin
    if ( ReadOnly ) then Exit;
    if Assigned(FOnDeletion) then FOnDeletion(Self, Item);
    FDataLink.ActiveRecord:= GetRecordNumber(Item);
    FDataLink.DataSet.Delete;
  end;
end;

function TCustomDBListView.CanEdit(Item: Integer): Boolean;
begin
  Result := True;
  if Assigned(FOnEditing) then
    FOnEditing(Self, Item, Result)
  else begin
    if ( FListColumns.Count > GetIndex(0) ) then
      Result:= Not FListColumns[GetIndex(0)].ReadOnly;
  end;
end;

procedure TCustomDBListView.Edit(const Item: TLVItem);
var
  S: string;
begin
  with Item do begin
    S := pszText;
    with FDataLink do begin
      ActiveRecord:= GetRecordNumber(iItem);
      if Assigned(FOnEdited) then FOnEdited(Self, Item.iItem, S);
      if ( S <> GetSelectedField.Text ) then begin
        DataSet.Edit;
        GetSelectedField.Text:= S;
        DataSet.Post;
      end;
    end;
  end;
end;

function TCustomDBListView.IsEditing: Boolean;
var
  ControlHand: HWnd;
begin
  ControlHand := ListView_GetEditControl(Handle);
  Result := (ControlHand <> 0) and IsWindowVisible(ControlHand);
end;

function TCustomDBListView.GetDragImages: TDragImageList;
begin
  if SelCount = 1 then
    Result := FDragImage else
    Result := nil;
end;

procedure TCustomDBListView.WndProc(var Message: TMessage);
begin
  if not (csDesigning in ComponentState) and ((Message.Msg = WM_LBUTTONDOWN) or
    (Message.Msg = WM_LBUTTONDBLCLK)) and not Dragging and (DragMode = dmAutomatic) then
  begin
    if not IsControlMouseMsg(TWMMouse(Message)) then
    begin
      ControlState := ControlState + [csLButtonDown];
      Dispatch(Message);
    end;
  end;
  inherited WndProc(Message);
end;

procedure TCustomDBListView.DoStartDrag(var DragObject: TDragObject);
const
  Codes: array[TDisplayCode] of Longint = (LVIR_BOUNDS, LVIR_ICON, LVIR_LABEL,
    LVIR_SELECTBOUNDS);
var
  P, P1: TPoint;
  ImageHandle: HImageList;
  DragItem: Integer;
  R: TRect;
begin
  inherited DoStartDrag(DragObject);
  FLastDropTarget := -1;
  GetCursorPos(P);
  P := ScreenToClient(P);
  if FDragIndex <> -1 then
    DragItem := FDragIndex
    else DragItem := -1;
  FDragIndex := -1;
  if DragItem = -1 then
    with P do DragItem := GetItemAt(X, Y);
  if DragItem <> -1 then
  begin
    Selected:= DragItem;
    ImageHandle := ListView_CreateDragImage(Handle, DragItem, P1);
    if ImageHandle <> 0 then
      with FDragImage do
      begin
        Handle := ImageHandle;
        ListView_GetItemRect(Self.Handle, DragItem, R, Codes[drBounds]);
        with P, R do
          SetDragImage(0, X - Left , Y - Top);
      end;
  end;
end;

procedure TCustomDBListView.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  inherited DoEndDrag(Target, X, Y);
  FLastDropTarget := -1;
end;

procedure TCustomDBListView.CMDrag(var Message: TCMDrag);
begin
  inherited;
  with Message, DragRec^ do
    case DragMessage of
      dmDragMove: with ScreenToClient(Pos) do DoDragOver(Source, X, Y, Message.Result <> 0);
      dmDragLeave:
        begin
          TDragObject(Source).HideDragImage;
          FLastDropTarget := DropTarget;
          DropTarget := -1;
          Update;
          TDragObject(Source).ShowDragImage;
        end;
      dmDragDrop: FLastDropTarget := -1;
    end
end;

procedure TCustomDBListView.DoDragOver(Source: TDragObject; X, Y: Integer; CanDrop: Boolean);
var
  Item: Integer;
  Target: Integer;
begin
  Item := GetItemAt(X, Y);
  if Item <> -1 then
  begin
    Target := DropTarget;
    if (Item <> Target) or (Item = FLastDropTarget) then
    begin
      FLastDropTarget := -1;
      TDragObject(Source).HideDragImage;
      Update;
      if Target <> -1 then
        ListView_SetItemState(Handle, Target, 0, LVIS_DROPHILITED);
      if ( CanDrop ) then
        ListView_SetItemState(Handle, Item, LVIS_DROPHILITED, LVIS_DROPHILITED)
      else
        ListView_SetItemState(Handle, Item, 0, LVIS_DROPHILITED);
      Update;
      TDragObject(Source).ShowDragImage;
    end;
  end;
end;

procedure TCustomDBListView.SetListColumns(Value: TListDBColumns);
begin
  FListColumns.Assign(Value);
end;

function TCustomDBListView.CustomSort(SortProc: TLVCompare; lParam: Longint): Boolean;
begin
  Result := False;
end;

{function TCustomDBListView.AlphaSort: Boolean;
begin
  Result := False;
end;

procedure TCustomDBListView.SetSortType(Value: TSortType);
begin
  if SortType <> Value then
  begin
    FSortType := Value;
    if ((SortType in [stData, stBoth]) and Assigned(OnCompare)) or
      (SortType in [stText, stBoth]) then
      AlphaSort;
  end;
end;}

function TCustomDBListView.GetViewOrigin: TPoint;
begin
  ListView_GetOrigin(Handle, Result);
end;

function TCustomDBListView.GetTopItem: Integer;
begin
  Result := -1;
  if not (ViewStyle in [vsSmallIcon, vsIcon]) then
  begin
    Result:= ListView_GetTopIndex(Handle);
  end;
end;

function TCustomDBListView.GetBoundingRect: TRect;
begin
  ListView_GetViewRect(Handle, Result);
end;

procedure TCustomDBListView.Scroll(DX, DY: Integer);
begin
  ListView_Scroll(Handle, DX, DY);
end;

procedure TCustomDBListView.SetLargeImages(Value: TImageList);
begin
  if LargeImages <> nil then
    LargeImages.UnRegisterChanges(FLargeChangeLink);
  FLargeImages := Value;
  if LargeImages <> nil then
  begin
    LargeImages.RegisterChanges(FLargeChangeLink);
    SetImageList(LargeImages.Handle, LVSIL_NORMAL)
  end
  else SetImageList(0, LVSIL_NORMAL);
end;

procedure TCustomDBListView.SetSmallImages(Value: TImageList);
begin
  if SmallImages <> nil then
    SmallImages.UnRegisterChanges(FSmallChangeLink);
  FSmallImages := Value;
  if SmallImages <> nil then
  begin
    SmallImages.RegisterChanges(FSmallChangeLink);
    SetImageList(SmallImages.Handle, LVSIL_SMALL)
  end
  else SetImageList(0, LVSIL_SMALL);
end;

procedure TCustomDBListView.SetStateImages(Value: TImageList);
begin
  if StateImages <> nil then
    StateImages.UnRegisterChanges(FStateChangeLink);
  FStateImages := Value;
  if StateImages <> nil then
  begin
    StateImages.RegisterChanges(FStateChangeLink);
    SetImageList(StateImages.Handle, LVSIL_STATE)
  end
  else SetImageList(0, LVSIL_STATE);
end;

function TCustomDBListView.GetColumnFromIndex(Index: Integer): TListDBColumn;
begin
  Result := FListColumns[Index];
end;

function TCustomDBListView.GetSelection: Integer;
begin
  Result := GetNextItem(-1, sdAll, [isSelected]);
end;

procedure TCustomDBListView.SetSelection(Value: Integer);
var
  I: Integer;
begin
  if Value <> -1 then begin
    ListView_SetItemState(Handle, Value, LVIS_SELECTED, LVIS_SELECTED);
    FDataLink.ActiveRecord:= GetRecordNumber(Value);
  end
  else begin
    Value := Selected;
    for I := 0 to SelCount - 1 do
      if Value <> -1 then
      begin
        ListView_SetItemState(Handle, Value, 0, LVIS_SELECTED);
        Value := GetNextItem(Value, sdAll, [isSelected]);
      end;
  end;
end;

function TCustomDBListView.GetDropTarget: Integer;
begin
  Result := GetNextItem(-1, sdAll, [isDropHilited]);
  if Result = -1 then Result := FLastDropTarget;
end;

procedure TCustomDBListView.SetDropTarget(Value: Integer);
begin
  if HandleAllocated then
    if Value <> -1 then ListView_SetItemState(Handle, Value, LVIS_DROPHILITED, LVIS_DROPHILITED)
    else begin
      Value := DropTarget;
      if Value <> -1 then ListView_SetItemState(Handle, Value, 0, LVIS_DROPHILITED);
    end;
end;

function TCustomDBListView.GetFocused: Integer;
begin
  Result := GetNextItem(-1, sdAll, [isFocused]);
end;

procedure TCustomDBListView.SetFocused(Value: Integer);
begin
  if HandleAllocated then
    if Value <> -1 then ListView_SetItemState(Handle, Value, LVIS_SELECTED, LVIS_SELECTED)
    else begin
      Value := ItemFocused;
      if Value <> -1 then ListView_SetItemState(Handle, Value, 0, LVIS_SELECTED);
    end;
end;

function TCustomDBListView.GetNextItem(StartItem: Integer;
  Direction: TSearchDirection; States: TItemStates): Integer;
var
  Flags, Index: Integer;
begin
  Result := -1;
  if HandleAllocated then
  begin
    Flags := 0;
    case Direction of
      sdAbove: Flags := LVNI_ABOVE;
      sdBelow: Flags := LVNI_BELOW;
      sdLeft: Flags := LVNI_TOLEFT;
      sdRight: Flags := LVNI_TORIGHT;
      sdAll: Flags := LVNI_ALL;
    end;
    Index := StartItem;
    if isCut in States then Flags := Flags or LVNI_CUT;
    if isDropHilited in States then Flags := Flags or LVNI_DROPHILITED;
    if isFocused in States then Flags := Flags or LVNI_FOCUSED;
    if isSelected in States then Flags := Flags or LVNI_SELECTED;
    Index := ListView_GetNextItem(Handle, Index, Flags);
    Result := Index;
  end;
end;

function TCustomDBListView.GetNearestItem(Point: TPoint;
  Direction: TSearchDirection): Integer;
const
  Directions: array[TSearchDirection] of Integer = (VK_LEFT, VK_RIGHT,
    VK_UP, VK_DOWN, 0);
var
  Info: TLVFindInfo;
  Index: Integer;
begin
  with Info do
  begin
    flags := LVFI_NEARESTXY;
    pt := Point;
    vkDirection := Directions[Direction];
  end;
  Index := ListView_FindItem(Handle, -1, Info);
  Result := Index;
end;

function TCustomDBListView.GetItemAt(X, Y: Integer): Integer;
var
  Info: TLVHitTestInfo;
var
  Index: Integer;
begin
  Result := -1;
  if HandleAllocated then
  begin
    Info.pt := Point(X, Y);
    Index := ListView_HitTest(Handle, Info);
    Result:= Index;
  end;
end;

procedure TCustomDBListView.Arrange(Code: TListArrangement);
const
  Codes: array[TListArrangement] of Longint = (LVA_ALIGNBOTTOM, LVA_ALIGNLEFT,
    LVA_ALIGNRIGHT, LVA_ALIGNTOP, LVA_DEFAULT, LVA_SNAPTOGRID);
begin
  ListView_Arrange(Handle, Codes[Code]);
end;

function TCustomDBListView.StringWidth(S: string): Integer;
begin
  Result := ListView_GetStringWidth(Handle, PChar(S));
end;

procedure TCustomDBListView.UpdateColumns;
var
  I: Integer;
begin
  if HandleAllocated then
    for I := 0 to Columns.Count - 1 do UpdateColumn(I);
end;

procedure TCustomDBListView.UpdateColumn(Index: Integer);
var
  Column: TLVColumn;
  Colx: THDItemEx;
begin
  if HandleAllocated then begin
    with Column, Columns.Items[Index] do
    begin
      mask := LVCF_TEXT or LVCF_FMT;
      pszText := PChar(Caption);
      if Index <> 0 then
        case Alignment of
          taLeftJustify: fmt := LVCFMT_LEFT;
          taCenter: fmt := LVCFMT_CENTER;
          taRightJustify: fmt := LVCFMT_RIGHT;
        end
      else fmt := LVCFMT_LEFT;
      if WidthType > ColumnTextWidth then
      begin
        mask := mask or LVCF_WIDTH;
        cx := FWidth;
        ListView_SetColumn(Handle, Index, Column);
      end
      else begin
        ListView_SetColumn(Handle, Index, Column);
        if ViewStyle = vsList then
          ListView_SetColumnWidth(Handle, -1, WidthType)
        else if ViewStyle = vsReport then
          ListView_SetColumnWidth(Handle, Index, WidthType);
      end;
      if ( IndexName = '' ) then begin
        Colx.Mask:= HDI_BITMAP or HDI_FORMAT;
        Colx.hbm:= FBitmapNone.MaskHandle;
        Colx.fmt:=  HDF_BITMAP_ON_RIGHT or HDF_BITMAP or HDF_STRING;
        Header_SetItemEx(FHeaderHandle, Index, Colx);
      end
      else begin
        if ( FCurrentSortCol = Index ) then begin
          Colx.Mask:= HDI_BITMAP or HDI_FORMAT;
          if ( FForwardSort ) then
            Colx.hbm:= FBitmapDn.MaskHandle
          else
            Colx.hbm:= FBitmapUp.MaskHandle;
          Colx.fmt:=  HDF_BITMAP_ON_RIGHT or HDF_BITMAP or HDF_STRING;
          Header_SetItemEx(FHeaderHandle, Index, Colx);
        end;
      end;
    end;
  end;
end;

procedure TCustomDBListView.WMRButtonDown(var Message: TWMRButtonDown);
var
  MousePos: TPoint;
begin
  FRClicked := False;
  inherited;
  if FRClicked then
  begin
    GetCursorPos(MousePos);
    with PointToSmallPoint(ScreenToClient(MousePos)) do
      Perform(WM_RBUTTONUP, 0, MakeLong(X, Y));
  end;
end;

procedure TCustomDBListView.WMLButtonDown(var Message: TWMLButtonDown);
var
  Item: Integer;
  MousePos: TPoint;
  ShiftState: TShiftState;
begin
  SetFocus;
  ShiftState := KeysToShiftState(Message.Keys);
  FClicked := False;
  FDragIndex := -1;
  inherited;
  if (DragMode = dmAutomatic) and MultiSelect then
  begin
    if not (ssShift in ShiftState) and not (ssCtrl in ShiftState) then
    begin
      if not FClicked then
      begin
        Item := GetItemAt(Message.XPos, Message.YPos);
        if (Item <> -1) and IsItemSelected(Item) then
        begin
          BeginDrag(False);
          Exit;
        end;
      end;
    end;
  end;
  if FClicked then
  begin
    GetCursorPos(MousePos);
    with PointToSmallPoint(ScreenToClient(MousePos)) do
      if not Dragging then Perform(WM_LBUTTONUP, 0, MakeLong(X, Y))
      else SendMessage(GetCapture, WM_LBUTTONUP, 0, MakeLong(X, Y));
  end
  else if (DragMode = dmAutomatic) and not (MultiSelect and
    ((ssShift in ShiftState) or (ssCtrl in ShiftState))) then
  begin
    Item := GetItemAt(Message.XPos, Message.YPos);
    if (Item <> -1) and IsItemSelected(Item) then
      BeginDrag(False);
  end;
end;

function TCustomDBListView.GetSearchString: string;
var
  Buffer: array[0..1023] of char;
begin
  Result := '';
  if HandleAllocated and ListView_GetISearchString(Handle, Buffer) then
    Result := Buffer;
end;

procedure TCustomDBListView.ShowEditor;
begin
  ListView_EditLabel(Handle, Selected);
end;

procedure TCustomDBListView.EditingChanged;
begin
end;

procedure TCustomDBListView.EndLayout;
begin
  if FLayoutLock > 0 then
  begin
    try
      try
        if FLayoutLock = 1 then
          InternalLayout;
      finally
        if FLayoutLock = 1 then
          FListColumns.EndUpdate;
      end;
    finally
      Dec(FLayoutLock);
      EndUpdate;
    end;
  end;
end;

procedure TCustomDBListView.EndUpdate;
begin
  if FUpdateLock > 0 then
    Dec(FUpdateLock);
end;

function TCustomDBListView.GetVisibleCount: Integer;
begin
  Result:= ListView_GetCountPerPage(Handle);
end;

function TCustomDBListView.GetCount: Integer;
begin
  Result:= ListView_GetItemCount(Handle);
end;

procedure TCustomDBListView.SetCount(Value: Integer);
begin
  SendMessage(Handle, LVM_SETITEMCOUNT, Value, LPARAM(LVSICF_NOINVALIDATEALL or LVSICF_NOSCROLL));
end;

procedure TCustomDBListView.Clear;
begin
  SendMessage(Handle, LVM_DELETEALLITEMS, 0, 0);
end;

function TCustomDBListView.GetEditText: String;
begin
  SendMessage(FEditHandle, WM_GETTEXT, 40, lparam(PChar(Result)));
end;

procedure TCustomDBListView.UpdateActive;
var
  NewRow: Integer;
begin
  if FDatalink.Active and HandleAllocated and not (csLoading in ComponentState) then
  begin
    NewRow := GetRecordNumber(FDatalink.ActiveRecord);
    if Selected <> NewRow then
    begin
      HideEditor;
      SetSelection(NewRow{+TopItem});
    end;
  end;
end;

{ InternalLayout is called with layout locks and column locks in effect }
procedure TCustomDBListView.InternalLayout;
var
  I: Integer;

  function FieldIsMapped(F: TField): Boolean;
  var
    X: Integer;
  begin
    Result := False;
    if F = nil then Exit;
    for X := 0 to FDatalink.FieldCount-1 do
      if FDatalink.Fields[X] = F then
      begin
        Result := True;
        Exit;
      end;
  end;

begin
  if (csLoading in ComponentState) then Exit;

  if HandleAllocated then KillMessage(Handle, cm_DeferLayout);

  FDatalink.ClearMapping;
  if FDatalink.Active then DefineFieldMap;
  begin
    { Force columns to reaquire fields (in case dataset has changed) }
    for I := 0 to FListColumns.Count-1 do
      FListColumns[I].Field := nil;
  end;
  UpdateRowCount;
  UpdateActive;
  SetSort(FCurrentSortCol, FForwardSort);
  if ( ValiddataSet ) then
    if Not FForwardSort then
      FDataLink.DataSet.Last
    else
      FDataLink.DataSet.First;
  Invalidate;
end;

procedure TCustomDBListView.DefineFieldMap;
var
  I: Integer;
begin
  begin   { Build the column/field map from the column attributes }
    DataLink.SparseMap := True;
    for I := 0 to FListColumns.Count-1 do
      FDataLink.AddMapping(FListColumns[I].FieldName);
  end;
end;

function TCustomDBListView.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TCustomDBListView.SetDataSource(Value: TDataSource);
begin
  if Value = FDatalink.Datasource then Exit;
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
  LinkActive(FDataLink.Active);
end;

function TCustomDBListView.GetSelectedField: TField;
var
  Index: Integer;
begin
  Index := SelectedIndex;
  if Index <> -1 then
    Result := Columns[0].Field
  else
    Result := nil;
end;

function TCustomDBListView.IsItemSelected(Value: Integer): Boolean;
begin
  Result:= ( ListView_GetItemState(Handle, Value, LVIS_SELECTED) <> 0 );
end;

function TCustomDBListView.GetSelectedIndex: Integer;
begin
  Result := 0;
end;

procedure TCustomDBListView.SetSelectedField(Value: TField);
begin
end;

procedure TCustomDBListView.SetSelectedIndex(Value: Integer);
begin
end;

procedure TCustomDBListView.UpdateData;
begin
end;

procedure TCustomDBListView.ScrollData(Distance: Integer);
begin
  UpdateActive;
  ListView_EnsureVisible(Handle, Selected, TRUE);
  if UpdateLock = 0 then Update;
end;

procedure TCustomDBListView.WMKeyDown(var Message: TWMKeyDown);
begin
  {case Message.CharCode of
    VK_F2     :  if ( Selected <> -1 ) and ( Not ReadOnly ) then
                   ShowEditor;
    VK_INSERT :  if ( Selected <> -1 ) and ( Not ReadOnly ) then
                   NewItem;
    VK_DELETE :  if ( Selected <> -1 ) and ( Not ReadOnly ) then
                   Delete(Selected);
  end;}
  inherited;
end;

procedure TCustomDBListView.HideEditor;
begin
  SendMessage(Handle, WM_CANCELMODE, 0, 0);
end;

procedure TCustomDBListView.NewItem;
begin
  if ( ValidDataSet ) then begin
    FDataLink.DataSet.Insert;
    if Assigned(FOnNewItem) then FOnNewItem(Self, FDataLink.DataSet);
    FDataLink.DataSet.Post;
  end;
end;

function TCustomDBListView.GetRecordNumber(iItem: Integer): Integer;
begin
  {if ( ValidDataSet ) then
    if iItem >= FDataLink.DataSet.RecordCount then iItem:= FDataLink.DataSet.RecordCount-1;}
  if ( FForwardSort ) then
    Result:= iItem//iItem - TopItem
  else begin
    Result:= Count - iItem - 1;//VisibleCount - ( iItem - TopItem ) - 1;//Count - iItem - 1 - TopItem;
  end;
  if Result <= 0 then Result:= 0;
  if ( Result >= Count ) then Result:= Count-1;
end;

procedure TCustomDBListView.SetHeaderDragDrop(Value: Boolean);
begin
  if FHeaderDragDrop <> Value then
  begin
    FHeaderDragDrop := Value;
    ResetExStyles;
  end;
end;

procedure TCustomDBListView.SetOneClickActivate(Value: Boolean);
begin
  if FOneClickActivate <> Value then
  begin
    FOneClickActivate := Value;
    ResetExStyles;
  end;
end;

function TCustomDBListView.GetOrder(Index: Integer): Integer;
Var
  i: Integer;
begin
  Result:= -1;
  if ( ViewStyle <> vsReport ) then Exit;
  for i:= 0 to FListColumns.Count - 1 do begin
    if (  Header_OrderToIndex(FHeaderHandle, i) = Index ) then begin
      Result:= i;
      Exit;
    end;
  end;
end;

function TCustomDBListView.GetIndex(Order: Integer): Integer;
begin
  Result:= Header_OrderToIndex(FHeaderHandle, Order);
end;

procedure TCustomDBListView.LoadPosition;
var
  Reg: TRegIniFile;
  OrderArray : Array[0..50] of Integer;

  procedure ReadColumnValues (Index: Integer);
  Var
    j: Integer;
  begin
    j:= Reg.ReadInteger (Name, rvHeaderOrder+IntToStr(Index), Index);
    OrderArray[j]:= Index;
    FListColumns[Index].Width:= Reg.ReadInteger (Name, rvHeaderWidth+IntToStr(Index), FListColumns[Index].Width);
    FListColumns[Index].Caption:= Reg.ReadString (Name, rvHeaderCaption+IntToStr(Index), FListColumns[Index].Caption);
  end;

  procedure ReadValues;
  Var
    i: Integer;
  begin
    ViewStyle:= TViewStyle(Reg.ReadInteger (Name, rvViewStyle, Integer(ViewStyle)));
    if ( ViewStyle = vsReport ) then begin
      for i:= 0 to FListColumns.Count - 1 do
        ReadColumnValues(i);
      ListView_SetColumnOrderArray(Handle, FListColumns.Count, PInteger(@OrderArray));
      SetSort(Reg.ReadInteger(Name, rvCurrentSortCol, FCurrentSortCol),
              Reg.ReadBool(Name, rvForwardSort, FForwardSort));
    end;
  end;

begin
  if ( FRegistryKey = '' ) then begin
    Reg := TRegIniFile.Create('Software');
    Reg.RootKey:= RootKey;
    Reg.OpenKey(
      'Software\' + CompanyName + '\' + ProgramName + '\' + VersionNumber + '\' + CurrentUser + 'Listes', True);
  end
  else
    Reg := TRegIniFile.Create(FRegistryKey);
  try
    ReadValues;
    Repaint;
  finally
    Reg.Free;
  end;
end;

procedure TCustomDBListView.SavePosition;
var
  Reg: TRegIniFile;

  procedure WriteColumnValues (Column: TListDBColumn);
  begin
    Reg.WriteString  (Name, rvHeaderCaption+IntToStr(Column.Index), Column.Caption);
    Reg.WriteInteger (Name, rvHeaderOrder+IntToStr(Column.Index), Column.Order);
    Reg.WriteInteger (Name, rvHeaderWidth+IntToStr(Column.Index), Column.Width);
  end;

  procedure WriteValues;
  Var
    i : Integer;
  begin
    if ( ViewStyle = vsReport ) then begin
      Reg.WriteInteger(Name, rvCurrentSortCol, FCurrentSortCol);
      Reg.WriteBool(Name, rvForwardSort, FForwardSort);
      for i:= 0 to FListColumns.Count - 1 do
        WriteColumnValues(FListColumns[i]);
    end;
    Reg.WriteInteger (Name, rvViewStyle, Integer(ViewStyle));
  end;

begin
  if ( FRegistryKey = '' ) then begin
    Reg := TRegIniFile.Create('Software');
    Reg.RootKey:= RootKey;
    Reg.OpenKey(
      'Software\' + CompanyName + '\' + ProgramName + '\' + VersionNumber + '\' + CurrentUser + 'Listes', True);
  end
  else
    Reg := TRegIniFile.Create(FRegistryKey);
  try
    WriteValues;
  finally
    Reg.Free;
  end;
end;

procedure TCustomDBListView.SetSort(Index: Integer; IsForward: Boolean);
Var
  Cx: THDItemEx;
begin
  if ValidDataSet And ( FListColumns.Count > Index ) then begin
    if ( FListColumns[Index].IndexName <> '' ) then begin
      if ( DataLink.DataSet is TTable ) and ((DataLink.DataSet as TTable).MasterFields = '') then
        (DataLink.DataSet as TTable).IndexFieldNames:= FListColumns[Index].IndexName;
      Cx.Mask:= HDI_FORMAT;
      Cx.fmt:=  HDF_STRING;
      Header_SetItemEx(FHeaderHandle, FCurrentSortCol, Cx);
      FCurrentSortCol:= Index;
      FForwardSort:= IsForward;
      Cx.Mask:= HDI_BITMAP or HDI_FORMAT;
      if ( IsForward ) then
        Cx.hbm:= FBitmapDn.MaskHandle
      else
        Cx.hbm:= FBitmapUp.MaskHandle;
      Cx.fmt:=  HDF_BITMAP_ON_RIGHT or HDF_BITMAP or HDF_STRING;
      Header_SetItemEx(FHeaderHandle, Index, Cx);
    end;
  end;
end;

procedure TCustomDBListView.Loaded;
begin
  inherited Loaded;
  FForwardSort:= True;
  if ( FAutoSave ) then
    LoadPosition
  else
    SetSort(0, FForwardSort);
  if ( ValiddataSet ) then
    if Not FForwardSort then
      FDataLink.DataSet.Last
    else
      FDataLink.DataSet.First;
end;

function TCustomDBListView.ValidDataSet: Boolean;
begin
  Result:= False;
  if ( DataLink <> nil ) And Assigned(DataLink.DataSet) And DataLink.DataSet.Active then
    Result:= True;
end;

procedure TCustomDBListView.WMSize(var Message: TWMSize);
begin
  inherited;
  if UpdateLock = 0 then UpdateRowCount;
end;

procedure TCustomDBListView.SetIme;
var
  Column: TListDBColumn;
begin
  if not SysLocale.Fareast then Exit;

  if FDataLink.FInUpdateData then
  begin
    ImeName := Screen.DefaultIme;
    ImeMode := imDontCare;
  end
  else
  begin
    Column := Columns[SelectedIndex];
    ImeName := FOriginalImeName;
    ImeMode := FOriginalImeMode;
    if cvImeMode in Column.FAssignedValues then
    begin
      ImeName := Column.ImeName;
      ImeMode := Column.ImeMode;
    end;
  end;
end;

procedure TCustomDBListView.WMSetFocus(var Message: TWMSetFocus);
begin
  SetIme;
  inherited;
end;

procedure TCustomDBListView.WMKillFocus(var Message: TMessage);
begin
  ImeName := Screen.DefaultIme;
  ImeMode := imDontCare;
  inherited;
end;

(*procedure TCustomDBListView.WMVScroll(var Message: TWMVScroll);
var
  SI: TScrollInfo;
begin
  if not AcquireFocus then Exit;
  if FDatalink.Active then
    with Message, FDataLink.DataSet do
      case ScrollCode of
        SB_LINEUP: if FForwardSort then
                     MoveBy(-FDatalink.ActiveRecord - 1)
                   else
                     MoveBy(FDatalink.RecordCount - FDatalink.ActiveRecord);
        SB_LINEDOWN: if FForwardSort then
                       MoveBy(FDatalink.RecordCount - FDatalink.ActiveRecord)
                     else
                       MoveBy(-FDatalink.ActiveRecord - 1);
        SB_PAGEUP: if FForwardSort then MoveBy(-VisibleCount+1) else MoveBy(VisibleCount-1);
        SB_PAGEDOWN: if FForwardSort then MoveBy(VisibleCount-1) else MoveBy(-VisibleCount+1);
        SB_THUMBPOSITION:
          begin
            if IsSequenced then
            begin
              SI.cbSize := sizeof(SI);
              SI.fMask := SIF_ALL;
              GetScrollInfo(Self.Handle, SB_VERT, SI);
              if SI.nTrackPos <= 1 then First
              else if SI.nTrackPos >= RecordCount then Last
              else RecNo := SI.nTrackPos;
            end
            else
              case Pos of
                0: if FForwardSort then First else Last;
                1: if FForwardSort then MoveBy(-VisibleCount+1) else MoveBy(VisibleCount-1);
                2: Exit;
                3: if FForwardSort then MoveBy(VisibleCount-1) else MoveBy(-VisibleCount+1);
                4: if FForwardSort then Last else First;
              end;
          end;
        SB_BOTTOM: if FForwardSort then Last else First;
        SB_TOP: if FForwardSort then First else Last;
      end;
  inherited;
end;*)

procedure TCustomDBListView.KeyDown(var Key: Word; Shift: TShiftState);
var
  KeyDownEvent: TKeyEvent;

  procedure ClearSelection;
  begin
  end;

  procedure DoSelection(Select: Boolean; Direction: Integer);
  begin
    BeginUpdate;
    try
      FDatalink.Dataset.MoveBy(Direction);
    finally
      EndUpdate;
    end;
  end;

  procedure NextRow(Select: Boolean);
  begin
    with FDatalink.Dataset do
    begin
      if (State = dsInsert) and not Modified and not FDatalink.FModified then
        if EOF then Exit else Cancel
      else
        DoSelection(Select, 1);
    end;
  end;

  procedure PriorRow(Select: Boolean);
  begin
    with FDatalink.Dataset do
      if (State = dsInsert) and not Modified and EOF and
        not FDatalink.FModified then
        Cancel
      else
        DoSelection(Select, -1);
  end;

  function DeletePrompt: Boolean;
  var
    Msg: string;
  begin
  Msg := SDeleteRecordQuestion;
    Result := {not (dgConfirmDelete in Options) or}
      (MessageDlg(Msg, mtConfirmation, mbOKCancel, 0) <> idCancel);
  end;

const
  RowMovementKeys = [VK_UP, VK_PRIOR, VK_DOWN, VK_NEXT, VK_HOME, VK_END];

begin
  KeyDownEvent := OnKeyDown;
  if Assigned(KeyDownEvent) then KeyDownEvent(Self, Key, Shift);
  if not FDatalink.Active then Exit;
  with FDatalink.DataSet do
    if ssCtrl in Shift then
    begin
      if (Key in RowMovementKeys) then ClearSelection;
      case Key of
        VK_DELETE:
          if (not ReadOnly) and not IsEmpty and CanDelete
            and CanModify and DeletePrompt then
            Delete;
      end
    end
    else
      case Key of
        {VK_UP: if FForwardSort then PriorRow(True) else NextRow(True);
        VK_DOWN: if FForwardSort then NextRow(True) else PriorRow(True);
        VK_HOME:
          begin
            ClearSelection;
            if FForwardSort then First else Last;
          end;
        VK_END:
          begin
            ClearSelection;
            if FForwardSort then Last else First;
          end;
        VK_NEXT:
          begin
            ClearSelection;
            if FForwardSort then
              MoveBy(VisibleCount-1)
            else
              MoveBy(-VisibleCount+1)
          end;
        VK_PRIOR:
          begin
            ClearSelection;
            if FForwardSort then
              MoveBy(-VisibleCount+1)
            else
              MoveBy(VisibleCount-1)
          end;}
        VK_INSERT:
          if CanModify and (not ReadOnly) and CanInsert then
          begin
            ClearSelection;
            NewItem;
          end;
        VK_ESCAPE:
          begin
            FDatalink.Reset;
            ClearSelection;
            HideEditor;
          end;
        VK_F2: ShowEditor;
      end;
  inherited;
end;

procedure TCustomDBListView.KeyPress(var Key: Char);
begin
  if (Key = #13) then
    FDatalink.UpdateData;
  inherited KeyPress(Key);
end;

(*procedure TCustomDBListView.ScrollData(Distance: Integer);
var
  OldRect, NewRect: TRect;
  RowHeight: Integer;
begin
  if not HandleAllocated then Exit;
  if (FDataLink.ActiveRecord >= VisibleCount) then UpdateRowCount;
  UpdateActive;
  if Distance <> 0 then begin
    HideEditor;
    if Abs(Distance) > VisibleCount then begin
      Invalidate;
      Exit;
    end
  end;
  if UpdateLock = 0 then Update;
end;*)

function TCustomDBListView.GetActiveSortName : string;
begin
  Result:= StrNoSort;
  if ( FCurrentSortCol >= 0 ) And ( FCurrentSortCol < Columns.Count ) then begin
    Result:= Columns[FCurrentSortCol].Caption;
  end;
end;

end.

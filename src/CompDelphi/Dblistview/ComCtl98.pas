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




////////////////////////////////////////////////////////////////////////////////
// COMCTL98                                                                   //
////////////////////////////////////////////////////////////////////////////////
// Enhanced COMMCTRL for D3                                                   //
// * some constants and functions forgoten by Borland,...                     //
////////////////////////////////////////////////////////////////////////////////
// Version 1.2                                                                //
// Date de création           : 10/03/1997                                    //
// Date dernière modification : 25/06/1997                                    //
////////////////////////////////////////////////////////////////////////////////
// Jean-Luc Mattei                                                            //
// jlucm@club-internet.fr  / jlucm@mygale.org                                 //
////////////////////////////////////////////////////////////////////////////////
//  REVISIONS :                                                               //
//                                                                            //
//  1.1 :                                                                     //
//        * Added enhanced TreeView style                                     //
//  1.2 :                                                                     //
//        * Added (some) IE4 TabControl constants                             //
//        * Added IE4 ListView Constants and Functions                        //
//          (Background images)                                               //
//        * Added IE4 DateTime Extended functions                             //
////////////////////////////////////////////////////////////////////////////////

unit ComCtl98;

interface

uses Messages, Windows, ActiveX, CommCtrl;

const

  // IE4 ONLY
  ICC_INTERNET_CLASSES = $00000800;

  NM_CUSTOMDRAW        = (NM_FIRST-12);
  NM_HOVER             = (NM_FIRST-13);

  // IE4 ONLY
  NM_NCHITTEST         = (NM_FIRST-14);

  IPN_FIRST             = (0-860); // internet address
  IPN_LAST              = (0-879); // internet address

//================ DATETIMEPICK CONTROL =====================================
//                   IE4 EXTENSIONS

const

  DTM_SETMCFONT    = (DTM_FIRST + 9);
  DTM_GETMCFONT    = (DTM_FIRST + 10);

   procedure DateTime_SetMonthCalFont(hdp: HWND; hfont: HFONT; fRedraw: Bool);
   //SNDMSG(hdp, DTM_SETMCFONT, (WPARAM)hfont, (LPARAM)fRedraw)
   procedure DateTime_GetMonthCalFont(hdp: HWND);
   //SNDMSG(hdp, DTM_GETMCFONT, 0, 0)

//==================== TAB CONTROL ==========================================

const

  TCS_MULTISELECT       = $0004;
  // IE4 ONLY
  TCS_FLATBUTTONS       = $0008;
  // IE4 ONLY
  TCS_EX_FLATSEPARATORS = $00000001;
  // IE4 ONLY
  TCS_EX_REGISTERDROP   = $00000002;

  // IE4 ONLY
  TCIS_HIGHLIGHTED      = $0002;

  // IE4 ONLY
  TCM_HIGHLIGHTITEM     = (TCM_FIRST + 51);
  TCM_SETEXTENDEDSTYLE  = (TCM_FIRST + 52);  // optional wParam == mask
  TCM_GETEXTENDEDSTYLE  = (TCM_FIRST + 53);

  function TabCtrl_HighlightItem(hwnd: HWND; i : Cardinal; fHighlight : Bool): Bool;
  // (BOOL)SNDMSG((hwnd), TCM_HIGHLIGHTITEM, (WPARAM)i, (LPARAM)MAKELONG (fHighlight, 0))

  function TabCtrl_SetExtendedStyle(hwnd: HWND; dw: Longint): Longint;
  // (DWORD)SNDMSG((hwnd), TCM_SETEXTENDEDSTYLE, 0, dw)

  function TabCtrl_GetExtendedStyle(hwnd: HWND): Longint;
  // (DWORD)SNDMSG((hwnd), TCM_GETEXTENDEDSTYLE, 0, 0)

  function TabCtrl_GetItemRect(hwnd: HWND; i: Integer; Var prc: TRect): Boolean;
  // (BOOL)SNDMSG((hwnd), TCM_GETITEMRECT, (WPARAM)(int)(i), (LPARAM)(RECT FAR*)(prc))

Const

  // IE4 ONLY
  TCN_GETOBJECT         = (TCN_FIRST - 3);

  //==================== TREE VIEW ==========================================

  TVS_NOTOOLTIPS        = $0080;
  TVS_CHECKBOXES        = $0100;
  TVS_HOTTRACK          = $0200;

  TVS_SHAREDIMAGELISTS  = $0000;
  TVS_PRIVATEIMAGELISTS = $0400;

  //==================== HEADER CONTROL ==========================================

type
  PHDItemExA = ^THDItemExA;
  PHDItemExW = ^THDItemExW;
  THDItemExA = packed record
    Mask: Cardinal;
    cxy: Integer;
    pszText: PAnsiChar;
    hbm: HBITMAP;
    cchTextMax: Integer;
    fmt: Integer;
    lParam: LPARAM;
    iImage: Integer;
    iOrder: Integer;
  end;
  THDItemExW = packed record
    Mask: Cardinal;
    cxy: Integer;
    pszText: PWideChar;
    hbm: HBITMAP;
    cchTextMax: Integer;
    fmt: Integer;
    lParam: LPARAM;
    iImage: Integer;
    iOrder: Integer;
  end;
  THDItemEx = THDItemExA;
  PHDItemEx = PHDItemExA;

const
  HDI_IMAGE      = $0020;
  HDI_DI_SETITEM = $0040;
  HDI_ORDER      = $0080;

  HDF_BITMAP_ON_RIGHT = $01000;
  HDF_IMAGE  = $0800;

  function Header_InsertItemEx(Header: HWnd; Index: Integer;
  const Item: THDItemEx): Integer;
  function Header_GetItemEx(Header: HWnd; Index: Integer;
  var Item: THDItemEx): Bool;
  function Header_SetItemEx(Header: HWnd; Index: Integer; const Item: THDItemEx): Bool;

const
  HDM_GETITEMRECT = (HDM_FIRST + 7);
  HDM_SETIMAGELIST = (HDM_FIRST + 8);
  HDM_GETIMAGELIST = (HDM_FIRST + 9);
  HDM_ORDERTOINDEX = (HDM_FIRST + 15);
  HDM_CREATEDRAGIMAGE = (HDM_FIRST + 16);  // wparam = which item (by index)
  HDM_GETORDERARRAY = (HDM_FIRST + 17);
  HDM_SETORDERARRAY = (HDM_FIRST + 18);
  HDM_SETHOTDIVIDER = (HDM_FIRST + 19);

  function Header_GetItemRect(Header: HWnd; Index: Integer; var Rect: TRect): BOOL;
       // (BOOL)SNDMSG((hwnd), HDM_GETITEMRECT, (WPARAM)iItem, (LPARAM)lprc)

  function Header_SetImageList(Header: HWnd; iImageList: Integer): HImageList;
       // (HIMAGELIST)SNDMSG((hwnd), HDM_SETIMAGELIST, 0, (LPARAM)himl)

  function Header_GetImageList(Header: HWnd): HImageList;
       // (HIMAGELIST)SNDMSG((hwnd), HDM_GETIMAGELIST, 0, 0)

  function Header_OrderToIndex(Header: HWnd; Order: Integer): Integer;
       // (int)SNDMSG((hwnd), HDM_ORDERTOINDEX, (WPARAM)i, 0)

  function Header_CreateDragImage(Header: HWnd; Index: Integer): HImageList;
       // (HIMAGELIST)SNDMSG((hwnd), HDM_CREATEDRAGIMAGE, (WPARAM)i, 0)

  function Header_GetOrderArray(Header: HWnd; iCount: Integer; pi: PInteger): BOOL;
       // (BOOL)SNDMSG((hwnd), HDM_GETORDERARRAY, (WPARAM)iCount, (LPARAM)lpi)

  function Header_SetOrderArray(Header: HWnd; iCount: Integer; pi: PInteger): BOOL;
       // (BOOL)SNDMSG((hwnd), HDM_SETORDERARRAY, (WPARAM)iCount, (LPARAM)lpi)
// lparam = int array of size HDM_GETITEMCOUNT
// the array specifies the order that all items should be displayed.
// e.g.  { 2, 0, 1}
// says the index 2 item should be shown in the 0ths position
//      index 0 should be shown in the 1st position
//      index 1 should be shown in the 2nd position

   function Header_SetHotDivider(Header: HWnd; fPos: BOOL; dw: Longint): Integer;
       // (int)SNDMSG((hwnd), HDM_SETHOTDIVIDER, (WPARAM)fPos, (LPARAM)dw)
// convenience message for external dragdrop
// wParam = BOOL  specifying whether the lParam is a dwPos of the cursor
//              position or the index of which divider to hotlight
// lParam = depends on wParam  (-1 and wParm = FALSE turns off hotlight)

  //==================== LIST VIEW ============================================
  //                  IE 4 EXTENSIONS
const

  LVS_EX_FLATSB          = $00000100; // cannot be cleared
  LVS_EX_REGIONAL        = $00000200;
  LVS_EX_INFOTIP         = $00000400; // listview does InfoTips for you

  // these flags only apply to LVS_OWNERDATA listviews in report or list mode
  LVSICF_NOINVALIDATEALL = $00000001;
  LVSICF_NOSCROLL        = $00000002;
  LVIF_INDENT            = $0010;
  LVIF_NORECOMPUTE       = $0800;

  LVM_GETSELECTIONMARK   = (LVM_FIRST + 66);
  LVM_SETSELECTIONMARK   = (LVM_FIRST + 67);
  LVM_GETWORKAREA        = (LVM_FIRST + 70);
  LVM_SETHOVERTIME       = (LVM_FIRST + 71);
  LVM_GETHOVERTIME       = (LVM_FIRST + 72);

  function ListView_GetSelectionMark(hwnd: HWND): Integer;
  //  (int)SNDMSG((hwnd), LVM_GETSELECTIONMARK, 0, 0)

  function ListView_SetSelectionMark(hwnd: HWND; i: Cardinal): Integer;
  //  (int)SNDMSG((hwnd), LVM_GETSELECTIONMARK, 0, (LPARAM)i)

  function ListView_GetWorkArea(hwnd: HWND; Var prc: TRect): Bool;
  //  (BOOL)SNDMSG((hwnd), LVM_GETWORKAREA, 0, (LPARAM)(RECT FAR*)(prc))

  function ListView_SetHoverTime(hwndLV: HWND; dwHoverTimeMs: Longint): Longint;
  //  (DWORD)SendMessage((hwndLV), LVM_SETHOVERTIME, 0, dwHoverTimeMs)

  function ListView_GetHoverTime(hwndLV: HWND): Longint;
  //  (DWORD)SendMessage((hwndLV), LVM_GETHOVERTIME, 0, 0)

type

  PLVBkImageA = ^TLVBkImageA;
  TLVBkImageA = packed record
    ulFlags: Longint;              // LVBKIF_*
    hbm: HBITMAP;
    pszImage: PAnsiChar;
    cchImageMax: Cardinal;
    xOffsetPercent: Integer;
    yOffsetPercent: Integer;
  end;

  PLVBkImageW = ^TLVBkImageW;
  TLVBkImageW = packed record
    ulFlags: Longint;              // LVBKIF_*
    hbm: HBITMAP;
    pszImage: PWideChar;
    cchImageMax: Cardinal;
    xOffsetPercent: Integer;
    yOffsetPercent: Integer;
  end;
  TLvBkImage = TLvBkImageA;
  PLvBkImage = PLvBkImageA;

const

  LVBKIF_SOURCE_NONE     = $00000000;
  LVBKIF_SOURCE_HBITMAP  = $00000001;
  LVBKIF_SOURCE_URL      = $00000002;
  LVBKIF_SOURCE_MASK     = $00000003;
  LVBKIF_STYLE_NORMAL    = $00000000;
  LVBKIF_STYLE_TILE      = $00000010;
  LVBKIF_STYLE_MASK      = $00000010;

  LVM_SETBKIMAGEA        = (LVM_FIRST + 68);
  LVM_SETBKIMAGEW        = (LVM_FIRST + 138);
  LVM_GETBKIMAGEA        = (LVM_FIRST + 69);
  LVM_GETBKIMAGEW        = (LVM_FIRST + 139);

  {$ifdef UNICODE}
  LVM_SETBKIMAGE         = LVM_SETBKIMAGEW;
  LVM_GETBKIMAGE         = LVM_GETBKIMAGEW;
  {$else}
  LVM_SETBKIMAGE         = LVM_SETBKIMAGEA;
  LVM_GETBKIMAGE         = LVM_GETBKIMAGEA;
  {$endif}

  function ListView_SetBkImage(hwnd: HWND; plvbki: Longint): Bool;
  //  (BOOL)SNDMSG((hwnd), LVM_SETBKIMAGE, 0, (LPARAM)plvbki)

  function ListView_GetBkImage(hwnd: HWND; Var plvbki: Longint): Bool;
  //  (BOOL)SNDMSG((hwnd), LVM_GETBKIMAGE, 0, (LPARAM)plvbki)


  //==================== CUSTOM DRAW ==========================================

// custom draw return flags
// values under 0x00010000 are reserved for global custom draw values.
// above that are for specific controls

const
	CDRF_DODEFAULT        = $00000000;
        CDRF_NEWFONT          = $00000002;
	CDRF_SKIPDEFAULT      = $00000004;

	CDRF_NOTIFYPOSTPAINT  = $00000010;
	CDRF_NOTIFYITEMDRAW   = $00000020;
        CDRF_NOTIFYPOSTERASE  = $00000040;
        CDRF_NOTIFYITEMERASE  = $00000080;
        // IE4 Only
        CDRF_NOTIFYSUBITEMDRAW = $00000020;  // flags are the same, we can distinguish by context

// drawstage flags
// values under 0x00010000 are reserved for global custom draw values.
// above that are for specific controls

	CDDS_PREPAINT         = $000000001;
	CDDS_POSTPAINT        = $000000002;
        CDDS_PREERASE         = $000000003;
        CDDS_POSTERASE        = $000000004;

// the 0x000010000 bit means it's individual item specific

	CDDS_ITEM             = $000010000;
	CDDS_ITEMPREPAINT     = (CDDS_ITEM OR CDDS_PREPAINT);
	CDDS_ITEMPOSTPAINT    = (CDDS_ITEM OR CDDS_POSTPAINT);
        CDDS_ITEMPREERASE     = (CDDS_ITEM OR CDDS_PREERASE);
        CDDS_ITEMPOSTERASE    = (CDDS_ITEM OR CDDS_POSTERASE);
        // IE4 Only
        CDDS_SUBITEM          = $00020000;

// itemState flags

	CDIS_SELECTED  =  $0001;
	CDIS_GRAYED    =  $0002;
	CDIS_DISABLED  =  $0004;
	CDIS_CHECKED   =  $0008;
	CDIS_FOCUS     =  $0010;
	CDIS_DEFAULT   =  $0020;
        CDIS_HOT       =  $0040;

Type
         PNMCustomDrawInfo = ^TNMCustomDrawInfo;
	 TNMCustomDrawInfo = packed record
		hdr : TNMHDR;
		dwDrawStage : LONGINT;
		hdc : HDC;
		rc : TRect;
		dwItemSpec : LONGINT;  // this is control specific, but it's how to specify an item.  valid only with CDDS_ITEM bit set
		uItemState : Cardinal;
                lItemlParam : Longint;
	 end;

         PNMLVCustomDraw = ^TNMLVCustomDraw;
         TNMLVCustomDraw = packed record
            nmcd : TNMCustomDrawInfo;
            clrText : COLORREF;
            clrTextBk : COLORREF;
         end;

implementation

function TabCtrl_HighlightItem(hwnd: HWND; i : Cardinal; fHighlight : Bool): Bool;
begin
  Result:= Bool(SendMessage(hwnd, TCM_HIGHLIGHTITEM, i, Longint(fHighlight)));
end;

function TabCtrl_SetExtendedStyle(hwnd: HWND; dw: Longint): Longint;
begin
  Result:= SendMessage(hwnd, TCM_SETEXTENDEDSTYLE, 0, dw);
end;

function TabCtrl_GetExtendedStyle(hwnd: HWND): Longint;
begin
  Result:= SendMessage(hwnd, TCM_GETEXTENDEDSTYLE, 0, 0);
end;

function TabCtrl_GetItemRect(hwnd: HWND; i: Integer; Var prc: TRect): Boolean;
begin
  Result:= Boolean(SendMessage(hwnd, TCM_GETITEMRECT, i, Longint(@prc)));
end;

function Header_InsertItemEx(Header: HWnd; Index: Integer;
  const Item: THDItemEx): Integer;
begin
  Result := SendMessage(Header, HDM_INSERTITEM, Index, Longint(@Item));
end;

function Header_GetItemEx(Header: HWnd; Index: Integer; var Item: THDItemEx): Bool;
begin
  Result := Bool( SendMessage(Header, HDM_GETITEM, Index, Longint(@Item)) );
end;

function Header_SetItemEx(Header: HWnd; Index: Integer; const Item: THDItemEx): Bool;
begin
  Result := Bool( SendMessage(Header, HDM_SETITEM, Index, Longint(@Item)) );
end;

function Header_GetItemRect(Header: HWnd; Index: Integer; var Rect: TRect): Bool;
begin
  Result:= Bool(SendMessage(Header, HDM_GETITEMRECT, Index, Longint(@Rect)));
end;

function Header_GetImageList(Header: HWnd): HImageList;
begin
  Result:= HImageList(SendMessage(Header, HDM_GETIMAGELIST, 0, 0));
end;

function Header_SetImageList(Header: HWnd; iImageList: Integer): HImageList;
begin
  Result:= HImageList(SendMessage(Header, HDM_SETIMAGELIST, 0, iImageList));
end;

function Header_OrderToIndex(Header: HWnd; Order: Integer): Integer;
begin
  Result:= Integer(SendMessage(Header, HDM_ORDERTOINDEX, Order, 0));
end;

function Header_CreateDragImage(Header: HWnd; Index: Integer): HImageList;
begin
  Result:= HImageList(SendMessage(Header, HDM_CREATEDRAGIMAGE, Index, 0));
end;

function Header_GetOrderArray(Header: HWnd; iCount: Integer; pi: PInteger): BOOL;
begin
  Result:= Bool(SendMessage(Header, HDM_GETORDERARRAY, iCount, Longint(pi)));
end;

function Header_SetOrderArray(Header: HWnd; iCount: Integer; pi: PInteger): BOOL;
begin
  Result:= Bool(SendMessage(Header, HDM_SETORDERARRAY, iCount, Longint(pi)));
end;
function Header_SetHotDivider(Header: HWnd; fPos: BOOL; dw: Longint): Integer;
begin
  Result:= Integer(SendMessage(Header, HDM_SETHOTDIVIDER, Integer(fPos), dw));
end;

function ListView_GetSelectionMark(hwnd: HWND): Integer;
begin
  Result:= Integer(SendMessage(hwnd, LVM_GETSELECTIONMARK, 0, 0));
end;

function ListView_SetSelectionMark(hwnd: HWND; i: Cardinal): Integer;
begin
  Result:= Integer(SendMessage(hwnd, LVM_GETSELECTIONMARK, 0, Longint(i)));
end;

function ListView_GetWorkArea(hwnd: HWND; Var prc: TRect): Bool;
begin
  Result:= Bool(SendMessage(hwnd, LVM_GETWORKAREA, 0, Longint(@prc)));
end;

function ListView_SetHoverTime(hwndLV: HWND; dwHoverTimeMs: Longint): Longint;
begin
  Result:= SendMessage(hwndLV, LVM_SETHOVERTIME, 0, dwHoverTimeMs);
end;

function ListView_GetHoverTime(hwndLV: HWND): Longint;
begin
  Result:= SendMessage(hwndLV, LVM_GETHOVERTIME, 0, 0);
end;

function ListView_SetBkImage(hwnd: HWND; plvbki: Longint): Bool;
begin
  Result:= Bool(SendMessage(hwnd, LVM_SETBKIMAGE, 0, Longint(plvbki)));
end;

function ListView_GetBkImage(hwnd: HWND; Var plvbki: Longint): Bool;
begin
  Result:= Bool(SendMessage(hwnd, LVM_GETBKIMAGE, 0, Longint(plvbki)));
end;

procedure DateTime_SetMonthCalFont(hdp: HWND; hfont: HFONT; fRedraw: Bool);
begin
  SendMessage(hdp, DTM_SETMCFONT, wParam(hfont), Longint(fRedraw));
end;

procedure DateTime_GetMonthCalFont(hdp: HWND);
begin
  SendMessage(hdp, DTM_GETMCFONT, 0, 0);
end;

end.

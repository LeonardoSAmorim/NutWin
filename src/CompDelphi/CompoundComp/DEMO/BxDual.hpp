// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'BxDual.pas' rev: 4.00

#ifndef BxDualHPP
#define BxDualHPP

#pragma delphiheader begin
#pragma option push -w-
#include <Buttons.hpp>	// Pascal unit
#include <ComCtrls.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <ExtCtrls.hpp>	// Pascal unit
#include <Boxes.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Bxdual
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TBxDualList;
#pragma pack(push, 4)
class PASCALIMPLEMENTATION TBxDualList : public Boxes::TControlGroupBox 
{
	typedef Boxes::TControlGroupBox inherited;
	
__published:
	Extctrls::TPanel* SrcPanel;
	Stdctrls::TLabel* SrcLabel;
	Stdctrls::TListBox* SrcList;
	Extctrls::TPanel* BtnPanel;
	Extctrls::TPanel* DstPanel;
	Stdctrls::TLabel* DstLabel;
	Stdctrls::TListBox* DstList;
	Buttons::TSpeedButton* IncludeBtn;
	Buttons::TSpeedButton* IncAllBtn;
	Buttons::TSpeedButton* ExcludeBtn;
	Buttons::TSpeedButton* ExAllBtn;
	void __fastcall ExcAllBtnClick(System::TObject* Sender);
	void __fastcall ExcludeBtnClick(System::TObject* Sender);
	void __fastcall IncAllBtnClick(System::TObject* Sender);
	void __fastcall IncludeBtnClick(System::TObject* Sender);
	void __fastcall BxDualListResize(System::TObject* Sender);
	
private:
	Classes::TStrings* __fastcall GetSrcItems(void);
	Classes::TStrings* __fastcall GetDstItems(void);
	void __fastcall SetSrcItems(const Classes::TStrings* Value);
	void __fastcall SetDstItems(const Classes::TStrings* Value);
	AnsiString __fastcall GetLabelSrc();
	void __fastcall SetLabelSrc(const AnsiString Value);
	AnsiString __fastcall GetLabelDst();
	void __fastcall SetLabelDst(const AnsiString Value);
	
public:
	void __fastcall MoveSelected(Stdctrls::TCustomListBox* List, Classes::TStrings* Items);
	void __fastcall SetItem(Stdctrls::TListBox* List, int Index);
	int __fastcall GetFirstSelection(Stdctrls::TCustomListBox* List);
	void __fastcall SetButtons(void);
	
__published:
	__property Align ;
	__property Classes::TStrings* ItemsSrc = {read=GetSrcItems, write=SetSrcItems};
	__property Classes::TStrings* ItemsDst = {read=GetDstItems, write=SetDstItems};
	__property AnsiString LabelSrc = {read=GetLabelSrc, write=SetLabelSrc};
	__property AnsiString LabelDst = {read=GetLabelDst, write=SetLabelDst};
public:
	#pragma option push -w-inl
	/* TControlGroupBox.Create */ inline __fastcall virtual TBxDualList(Classes::TComponent* AOwner) : 
		Boxes::TControlGroupBox(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TControlGroupBox.Destroy */ inline __fastcall virtual ~TBxDualList(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TBxDualList(HWND ParentWindow) : Boxes::TControlGroupBox(
		ParentWindow) { }
	#pragma option pop
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------

}	/* namespace Bxdual */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Bxdual;
#endif
#pragma option pop	// -w-

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// BxDual

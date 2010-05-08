// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'BxRichTB.pas' rev: 4.00

#ifndef BxRichTBHPP
#define BxRichTBHPP

#pragma delphiheader begin
#pragma option push -w-
#include <ToolWin.hpp>	// Pascal unit
#include <ImgList.hpp>	// Pascal unit
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

namespace Bxrichtb
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TBxRichToolBar;
#pragma pack(push, 4)
class PASCALIMPLEMENTATION TBxRichToolBar : public Boxes::TToolBarBox 
{
	typedef Boxes::TToolBarBox inherited;
	
__published:
	Controls::TImageList* ToolbarImages;
	Dialogs::TColorDialog* ColorDlg;
	Comctrls::TToolButton* PrintButton;
	Comctrls::TToolButton* CutButton;
	Comctrls::TToolButton* CopyButton;
	Comctrls::TToolButton* PasteButton;
	Comctrls::TToolButton* UndoButton;
	Stdctrls::TComboBox* FontName;
	Stdctrls::TEdit* FontSize;
	Comctrls::TUpDown* FontUpDown;
	Comctrls::TToolButton* FontColorButton;
	Comctrls::TToolButton* BoldButton;
	Comctrls::TToolButton* ItalicButton;
	Comctrls::TToolButton* UnderlineButton;
	Comctrls::TToolButton* LeftAlignButton;
	Comctrls::TToolButton* CenterAlignButton;
	Comctrls::TToolButton* RightAlignButton;
	Comctrls::TToolButton* BulletButton;
	Comctrls::TToolButton* ToolButton1;
	Comctrls::TToolButton* ToolButton2;
	Comctrls::TToolButton* ToolButton3;
	Comctrls::TToolButton* ToolButton4;
	Dialogs::TPrintDialog* PrintDlg;
	void __fastcall PrintButtonClick(System::TObject* Sender);
	void __fastcall CutButtonClick(System::TObject* Sender);
	void __fastcall CopyButtonClick(System::TObject* Sender);
	void __fastcall PasteButtonClick(System::TObject* Sender);
	void __fastcall UndoButtonClick(System::TObject* Sender);
	void __fastcall FontNameChange(System::TObject* Sender);
	void __fastcall FontSizeChange(System::TObject* Sender);
	void __fastcall FontColorButtonClick(System::TObject* Sender);
	void __fastcall BoldButtonClick(System::TObject* Sender);
	void __fastcall ItalicButtonClick(System::TObject* Sender);
	void __fastcall UnderlineButtonClick(System::TObject* Sender);
	void __fastcall AlignButtonClick(System::TObject* Sender);
	void __fastcall BulletButtonClick(System::TObject* Sender);
	void __fastcall BxRichToolBarCreate(System::TObject* Sender);
	
private:
	Comctrls::TCustomRichEdit* FRichEdit;
	bool FUpdating;
	void __fastcall SetRichEdit(const Comctrls::TCustomRichEdit* Value);
	Comctrls::TTextAttributes* __fastcall CurrText(void);
	void __fastcall GetFontNames(void);
	
protected:
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation
		);
	
public:
	void __fastcall EnableButtons(const bool Value);
	
__published:
	void __fastcall SelectionChange(System::TObject* Sender);
	__property Comctrls::TCustomRichEdit* RichEditor = {read=FRichEdit, write=SetRichEdit};
public:
	#pragma option push -w-inl
	/* TToolBarBox.Create */ inline __fastcall virtual TBxRichToolBar(Classes::TComponent* AOwner) : Boxes::TToolBarBox(
		AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TToolBarBox.Destroy */ inline __fastcall virtual ~TBxRichToolBar(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TBxRichToolBar(HWND ParentWindow) : Boxes::TToolBarBox(
		ParentWindow) { }
	#pragma option pop
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------

}	/* namespace Bxrichtb */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Bxrichtb;
#endif
#pragma option pop	// -w-

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// BxRichTB

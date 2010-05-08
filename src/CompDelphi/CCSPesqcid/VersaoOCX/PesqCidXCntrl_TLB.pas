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




unit PesqCidXCntrl_TLB;

// ************************************************************************ //
// WARNING                                                                  //
// -------                                                                  //
// The types declared in this file were generated from data read from a     //
// Type Library. If this type library is explicitly or indirectly (via      //
// another type library referring to this type library) re-imported, or the //
// 'Refresh' command of the Type Library Editor activated while editing the //
// Type Library, the contents of this file will be regenerated and all      //
// manual modifications will be lost.                                       //
// ************************************************************************ //

// PASTLWTR : $Revision:   1.11.1.75  $
// File generated on 09/11/1999 4:10:32 PM from Type Library described below.

// ************************************************************************ //
// Type Lib: D:\Dados\Componentes\Delphi\CursoDSUS99\VersaoOCX\PesqCidXCntrl.tlb
// IID\LCID: {A8A4FAA0-8936-11D3-8576-006008DF8A1A}\0
// Helpfile: D:\Dados\Componentes\Delphi\CursoDSUS99\VersaoOCX\PesqCid.hlp
// HelpString: PesqCidXCntrl Library - Pesquisa em CID10
// Version:    1.0
// ************************************************************************ //

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:      //
//   Type Libraries     : LIBID_xxxx                                    //
//   CoClasses          : CLASS_xxxx                                    //
//   DISPInterfaces     : DIID_xxxx                                     //
//   Non-DISP interfaces: IID_xxxx                                      //
// *********************************************************************//
const
  LIBID_PesqCidXCntrl: TGUID = '{A8A4FAA0-8936-11D3-8576-006008DF8A1A}';
  IID_IPesqCidX: TGUID = '{A8A4FAA1-8936-11D3-8576-006008DF8A1A}';
  DIID_IPesqCidXEvents: TGUID = '{A8A4FAA3-8936-11D3-8576-006008DF8A1A}';
  CLASS_PesqCidX: TGUID = '{A8A4FAA5-8936-11D3-8576-006008DF8A1A}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                  //
// *********************************************************************//
// TxWindowState constants
type
  TxWindowState = TOleEnum;
const
  wsNormal = $00000000;
  wsMinimized = $00000001;
  wsMaximized = $00000002;

// TxPosition constants
type
  TxPosition = TOleEnum;
const
  poDesigned = $00000000;
  poDefault = $00000001;
  poDefaultPosOnly = $00000002;
  poDefaultSizeOnly = $00000003;
  poScreenCenter = $00000004;
  poDesktopCenter = $00000005;

// TxAlignment constants
type
  TxAlignment = TOleEnum;
const
  taLeftJustify = $00000000;
  taRightJustify = $00000001;
  taCenter = $00000002;

// TxBiDiMode constants
type
  TxBiDiMode = TOleEnum;
const
  bdLeftToRight = $00000000;
  bdRightToLeft = $00000001;
  bdRightToLeftNoAlign = $00000002;
  bdRightToLeftReadingOnly = $00000003;

type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  IPesqCidX = interface;
  IPesqCidXDisp = dispinterface;
  IPesqCidXEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  PesqCidX = IPesqCidX;


// *********************************************************************//
// Interface: IPesqCidX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A8A4FAA1-8936-11D3-8576-006008DF8A1A}
// *********************************************************************//
  IPesqCidX = interface(IDispatch)
    ['{A8A4FAA1-8936-11D3-8576-006008DF8A1A}']
    function Execute: WordBool; safecall;
    function Get_FormWindowState: TxWindowState; safecall;
    procedure Set_FormWindowState(Value: TxWindowState); safecall;
    function Get_FormPosition: TxPosition; safecall;
    procedure Set_FormPosition(Value: TxPosition); safecall;
    function Get_FormTop: Integer; safecall;
    procedure Set_FormTop(Value: Integer); safecall;
    function Get_FormLeft: Integer; safecall;
    procedure Set_FormLeft(Value: Integer); safecall;
    function Get_FormWidth: Integer; safecall;
    procedure Set_FormWidth(Value: Integer); safecall;
    function Get_FormHeight: Integer; safecall;
    procedure Set_FormHeight(Value: Integer); safecall;
    function Get_PesquisaAutomatica: WordBool; safecall;
    procedure Set_PesquisaAutomatica(Value: WordBool); safecall;
    function Get_CodigoCID: WideString; safecall;
    procedure Set_CodigoCID(const Value: WideString); safecall;
    function Get_DescricaoCID: WideString; safecall;
    procedure Set_DescricaoCID(const Value: WideString); safecall;
    function Get_DetalheCID: WideString; safecall;
    procedure Set_DetalheCID(const Value: WideString); safecall;
    function Get_DiretorioCID: WideString; safecall;
    procedure Set_DiretorioCID(const Value: WideString); safecall;
    function Get_PesquisaInicial: WideString; safecall;
    procedure Set_PesquisaInicial(const Value: WideString); safecall;
    procedure Paint; safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    procedure FlipChildren(AllLevels: WordBool); safecall;
    function DrawTextBiDiModeFlags(Flags: Integer): Integer; safecall;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    function GetControlsAlignment: TxAlignment; safecall;
    procedure InitiateAction; safecall;
    function IsRightToLeft: WordBool; safecall;
    function UseRightToLeftAlignment: WordBool; safecall;
    function UseRightToLeftReading: WordBool; safecall;
    function UseRightToLeftScrollBar: WordBool; safecall;
    function Get_BiDiMode: TxBiDiMode; safecall;
    procedure Set_BiDiMode(Value: TxBiDiMode); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_Cursor: Smallint; safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    function ClassNameIs(const Name: WideString): WordBool; safecall;
    procedure AboutBox; safecall;
    function Get_ArquivosCID: WideString; safecall;
    procedure Set_ArquivosCID(const Value: WideString); safecall;
    property FormWindowState: TxWindowState read Get_FormWindowState write Set_FormWindowState;
    property FormPosition: TxPosition read Get_FormPosition write Set_FormPosition;
    property FormTop: Integer read Get_FormTop write Set_FormTop;
    property FormLeft: Integer read Get_FormLeft write Set_FormLeft;
    property FormWidth: Integer read Get_FormWidth write Set_FormWidth;
    property FormHeight: Integer read Get_FormHeight write Set_FormHeight;
    property PesquisaAutomatica: WordBool read Get_PesquisaAutomatica write Set_PesquisaAutomatica;
    property CodigoCID: WideString read Get_CodigoCID write Set_CodigoCID;
    property DescricaoCID: WideString read Get_DescricaoCID write Set_DescricaoCID;
    property DetalheCID: WideString read Get_DetalheCID write Set_DetalheCID;
    property DiretorioCID: WideString read Get_DiretorioCID write Set_DiretorioCID;
    property PesquisaInicial: WideString read Get_PesquisaInicial write Set_PesquisaInicial;
    property DoubleBuffered: WordBool read Get_DoubleBuffered write Set_DoubleBuffered;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property BiDiMode: TxBiDiMode read Get_BiDiMode write Set_BiDiMode;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Cursor: Smallint read Get_Cursor write Set_Cursor;
    property ArquivosCID: WideString read Get_ArquivosCID write Set_ArquivosCID;
  end;

// *********************************************************************//
// DispIntf:  IPesqCidXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A8A4FAA1-8936-11D3-8576-006008DF8A1A}
// *********************************************************************//
  IPesqCidXDisp = dispinterface
    ['{A8A4FAA1-8936-11D3-8576-006008DF8A1A}']
    function Execute: WordBool; dispid 1;
    property FormWindowState: TxWindowState dispid 2;
    property FormPosition: TxPosition dispid 3;
    property FormTop: Integer dispid 4;
    property FormLeft: Integer dispid 5;
    property FormWidth: Integer dispid 6;
    property FormHeight: Integer dispid 7;
    property PesquisaAutomatica: WordBool dispid 8;
    property CodigoCID: WideString dispid 9;
    property DescricaoCID: WideString dispid 10;
    property DetalheCID: WideString dispid 11;
    property DiretorioCID: WideString dispid 12;
    property PesquisaInicial: WideString dispid 13;
    procedure Paint; dispid 14;
    property DoubleBuffered: WordBool dispid 18;
    procedure FlipChildren(AllLevels: WordBool); dispid 19;
    function DrawTextBiDiModeFlags(Flags: Integer): Integer; dispid 22;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; dispid 23;
    property Enabled: WordBool dispid -514;
    function GetControlsAlignment: TxAlignment; dispid 24;
    procedure InitiateAction; dispid 26;
    function IsRightToLeft: WordBool; dispid 27;
    function UseRightToLeftAlignment: WordBool; dispid 32;
    function UseRightToLeftReading: WordBool; dispid 33;
    function UseRightToLeftScrollBar: WordBool; dispid 34;
    property BiDiMode: TxBiDiMode dispid 35;
    property Visible: WordBool dispid 36;
    property Cursor: Smallint dispid 37;
    function ClassNameIs(const Name: WideString): WordBool; dispid 41;
    procedure AboutBox; dispid -552;
    property ArquivosCID: WideString dispid 15;
  end;

// *********************************************************************//
// DispIntf:  IPesqCidXEvents
// Flags:     (4096) Dispatchable
// GUID:      {A8A4FAA3-8936-11D3-8576-006008DF8A1A}
// *********************************************************************//
  IPesqCidXEvents = dispinterface
    ['{A8A4FAA3-8936-11D3-8576-006008DF8A1A}']
    procedure OnCanClose(const NewCID: WideString; var CanClose: WordBool); dispid 1;
    procedure OnClose; dispid 2;
    procedure OnShow; dispid 3;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TPesqCidX
// Help String      : PesqCidX Control
// Default Interface: IPesqCidX
// Def. Intf. DISP? : No
// Event   Interface: IPesqCidXEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TPesqCidXOnCanClose = procedure(Sender: TObject; const NewCID: WideString; var CanClose: WordBool) of object;

  TPesqCidX = class(TOleControl)
  private
    FOnCanClose: TPesqCidXOnCanClose;
    FOnClose: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FIntf: IPesqCidX;
    function  GetControlInterface: IPesqCidX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function Execute: WordBool;
    procedure Paint;
    procedure FlipChildren(AllLevels: WordBool);
    function DrawTextBiDiModeFlags(Flags: Integer): Integer;
    function DrawTextBiDiModeFlagsReadingOnly: Integer;
    function GetControlsAlignment: TxAlignment;
    procedure InitiateAction;
    function IsRightToLeft: WordBool;
    function UseRightToLeftAlignment: WordBool;
    function UseRightToLeftReading: WordBool;
    function UseRightToLeftScrollBar: WordBool;
    function ClassNameIs(const Name: WideString): WordBool;
    procedure AboutBox;
    property  ControlInterface: IPesqCidX read GetControlInterface;
    property DoubleBuffered: WordBool index 18 read GetWordBoolProp write SetWordBoolProp;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp;
    property BiDiMode: TOleEnum index 35 read GetTOleEnumProp write SetTOleEnumProp;
    property Visible: WordBool index 36 read GetWordBoolProp write SetWordBoolProp;
  published
    property FormWindowState: TOleEnum index 2 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property FormPosition: TOleEnum index 3 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property FormTop: Integer index 4 read GetIntegerProp write SetIntegerProp stored False;
    property FormLeft: Integer index 5 read GetIntegerProp write SetIntegerProp stored False;
    property FormWidth: Integer index 6 read GetIntegerProp write SetIntegerProp stored False;
    property FormHeight: Integer index 7 read GetIntegerProp write SetIntegerProp stored False;
    property PesquisaAutomatica: WordBool index 8 read GetWordBoolProp write SetWordBoolProp stored False;
    property CodigoCID: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property DescricaoCID: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property DetalheCID: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property DiretorioCID: WideString index 12 read GetWideStringProp write SetWideStringProp stored False;
    property PesquisaInicial: WideString index 13 read GetWideStringProp write SetWideStringProp stored False;
    property Cursor: Smallint index 37 read GetSmallintProp write SetSmallintProp stored False;
    property ArquivosCID: WideString index 15 read GetWideStringProp write SetWideStringProp stored False;
    property OnCanClose: TPesqCidXOnCanClose read FOnCanClose write FOnCanClose;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
  end;

procedure Register;

implementation

uses ComObj;

procedure TPesqCidX.InitControlData;
const
  CEventDispIDs: array [0..2] of DWORD = (
    $00000001, $00000002, $00000003);
  CControlData: TControlData2 = (
    ClassID: '{A8A4FAA5-8936-11D3-8576-006008DF8A1A}';
    EventIID: '{A8A4FAA3-8936-11D3-8576-006008DF8A1A}';
    EventCount: 3;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil;
    Flags: $00000008;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnCanClose) - Cardinal(Self);
end;

procedure TPesqCidX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IPesqCidX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TPesqCidX.GetControlInterface: IPesqCidX;
begin
  CreateControl;
  Result := FIntf;
end;

function TPesqCidX.Execute: WordBool;
begin
  Result := ControlInterface.Execute;
end;

procedure TPesqCidX.Paint;
begin
  ControlInterface.Paint;
end;

procedure TPesqCidX.FlipChildren(AllLevels: WordBool);
begin
  ControlInterface.FlipChildren(AllLevels);
end;

function TPesqCidX.DrawTextBiDiModeFlags(Flags: Integer): Integer;
begin
  Result := ControlInterface.DrawTextBiDiModeFlags(Flags);
end;

function TPesqCidX.DrawTextBiDiModeFlagsReadingOnly: Integer;
begin
  Result := ControlInterface.DrawTextBiDiModeFlagsReadingOnly;
end;

function TPesqCidX.GetControlsAlignment: TxAlignment;
begin
  Result := ControlInterface.GetControlsAlignment;
end;

procedure TPesqCidX.InitiateAction;
begin
  ControlInterface.InitiateAction;
end;

function TPesqCidX.IsRightToLeft: WordBool;
begin
  Result := ControlInterface.IsRightToLeft;
end;

function TPesqCidX.UseRightToLeftAlignment: WordBool;
begin
  Result := ControlInterface.UseRightToLeftAlignment;
end;

function TPesqCidX.UseRightToLeftReading: WordBool;
begin
  Result := ControlInterface.UseRightToLeftReading;
end;

function TPesqCidX.UseRightToLeftScrollBar: WordBool;
begin
  Result := ControlInterface.UseRightToLeftScrollBar;
end;

function TPesqCidX.ClassNameIs(const Name: WideString): WordBool;
begin
  Result := ControlInterface.ClassNameIs(Name);
end;

procedure TPesqCidX.AboutBox;
begin
  ControlInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TPesqCidX]);
end;

end.

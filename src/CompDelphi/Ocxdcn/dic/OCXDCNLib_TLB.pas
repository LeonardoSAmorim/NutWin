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




unit OCXDCNLib_TLB;

{ This file contains pascal declarations imported from a type library.
  This file will be written during each import or refresh of the type
  library editor.  Changes to this file will be discarded during the
  refresh process. }

{ OCXDcn OLE Control module }
{ Version 1.0 }

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

const
  LIBID_OCXDCNLib: TGUID = '{98D3A6A1-1493-11D0-B467-444553540000}';

const

{ Component class GUIDs }
  Class_OCXDcn: TGUID = '{98D3A6A4-1493-11D0-B467-444553540000}';

type

{ Forward declarations: Interfaces }
  _DOCXDcn = dispinterface;
  _DOCXDcnEvents = dispinterface;

{ Forward declarations: CoClasses }
  OCXDcn = _DOCXDcn;

{ Dispatch interface for OCXDcn Control }

  _DOCXDcn = dispinterface
    ['{98D3A6A2-1493-11D0-B467-444553540000}']
    property DataSourceName: WideString dispid 1;
    property TipoDicionario: WideString dispid 2;
    property SiglaDicionario: WideString dispid 3;
    property NroFilhosMax: Smallint dispid 5;
    property NroNiveisMax: Smallint dispid 6;
    property NomeDicionario: WideString dispid 7;
    property DataCriacao: TDateTime dispid 8;
    property DataAlteracao: TDateTime dispid 9;
    property FonteDicionario: WideString dispid 10;
    property VersaoDicionario: WideString dispid 11;
    property IDUsuario: WideString dispid 12;
    property SenhaUsuario: WideString dispid 13;
    property Connected: WordBool dispid 14;
    property DSNPropertyAtiva: WordBool dispid 4;
    function GetFirstSon(var Code, Description: WideString): WordBool; dispid 15;
    function GetNextBrother(var Code, Description: WideString): WordBool; dispid 16;
    function NextBrotherIsDone: WordBool; dispid 17;
    function GetLastSon(var Code, Description: WideString): WordBool; dispid 18;
    function GetPreviousBrother(var Code, Description: WideString): WordBool; dispid 19;
    function PreviousBrotherIsDone: WordBool; dispid 20;
    function GetCurrentParent(var Code, Description: WideString): WordBool; dispid 21;
    function GetCurrentSon(var Code, Description: WideString): Smallint; dispid 22;
    function FindParents(const SonCode: WideString; var FirstFatherCode: WideString): Smallint; dispid 23;
    function GetFirstParent(var Code, Description: WideString): WordBool; dispid 24;
    function GetNextParent(var Code, Description: WideString): WordBool; dispid 25;
    function FindDescriptionByCode(const Code: WideString; var Description: WideString): WordBool; dispid 26;
    function ConnectDictionary(const UserID, UserPassword: WideString): WordBool; dispid 27;
    function ExpandCode(const Code: WideString; var ChildrenNumber: Smallint): WordBool; dispid 28;
    procedure DisconnectDictionary; dispid 29;
    function GetFirstCodeByDesc(var Code, Description: WideString): WordBool; dispid 30;
    function GetNextCodeByDesc(var Code, Description: WideString): WordBool; dispid 31;
    function FindCodeByDescription(var Code: WideString; const Description: WideString): Smallint; dispid 32;
    function GetChildrenCount(const Code: WideString; var ChildrenNumber: Smallint): WordBool; dispid 33;
    function HasChilds(const Code: WideString): WordBool; dispid 34;
    function CollapseCode(const Code: WideString; var ChildrenNumber: Smallint): WordBool; dispid 35;
    procedure AboutBox; dispid -552;
  end;

{ Event interface for OCXDcn Control }

  _DOCXDcnEvents = dispinterface
    ['{98D3A6A3-1493-11D0-B467-444553540000}']
  end;

{ OCXDcn Control }

  TDicionario = class(TOleControl)
  private
    FIntf: _DOCXDcn;
    function GetControlInterface: _DOCXDcn;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function GetTOleEnumProp(Index: Integer): TOleEnum;
    procedure SetTOleEnumProp(Index: Integer; Value: TOleEnum);
  public
    function GetFirstSon(var Code, Description: WideString): WordBool;
    function GetNextBrother(var Code, Description: WideString): WordBool;
    function NextBrotherIsDone: WordBool;
    function GetLastSon(var Code, Description: WideString): WordBool;
    function GetPreviousBrother(var Code, Description: WideString): WordBool;
    function PreviousBrotherIsDone: WordBool;
    function GetCurrentParent(var Code, Description: WideString): WordBool;
    function GetCurrentSon(var Code, Description: WideString): Smallint;
    function FindParents(const SonCode: WideString; var FirstFatherCode: WideString): Smallint;
    function GetFirstParent(var Code, Description: WideString): WordBool;
    function GetNextParent(var Code, Description: WideString): WordBool;
    function FindDescriptionByCode(const Code: WideString; var Description: WideString): WordBool;
    function ConnectDictionary(const UserID, UserPassword: WideString): WordBool;
    function ExpandCode(const Code: WideString; var ChildrenNumber: Smallint): WordBool;
    procedure DisconnectDictionary;
    function GetFirstCodeByDesc(var Code, Description: WideString): WordBool;
    function GetNextCodeByDesc(var Code, Description: WideString): WordBool;
    function FindCodeByDescription(var Code: WideString; const Description: WideString): Smallint;
    function GetChildrenCount(const Code: WideString; var ChildrenNumber: Smallint): WordBool;
    function HasChilds(const Code: WideString): WordBool;
    function CollapseCode(const Code: WideString; var ChildrenNumber: Smallint): WordBool;
    procedure AboutBox;
    property ControlInterface: _DOCXDcn read GetControlInterface;
  published
    property DataSourceName: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property TipoDicionario: WideString index 2 read GetWideStringProp write SetWideStringProp stored False;
    property SiglaDicionario: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property NroFilhosMax: Smallint index 5 read GetSmallintProp write SetSmallintProp stored False;
    property NroNiveisMax: Smallint index 6 read GetSmallintProp write SetSmallintProp stored False;
    property NomeDicionario: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property DataCriacao: TDateTime index 8 read GetTDateTimeProp write SetTDateTimeProp stored False;
    property DataAlteracao: TDateTime index 9 read GetTDateTimeProp write SetTDateTimeProp stored False;
    property FonteDicionario: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property VersaoDicionario: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property IDUsuario: WideString index 12 read GetWideStringProp write SetWideStringProp stored False;
    property SenhaUsuario: WideString index 13 read GetWideStringProp write SetWideStringProp stored False;
    property Connected: WordBool index 14 read GetWordBoolProp write SetWordBoolProp stored False;
    property DSNPropertyAtiva: WordBool index 4 read GetWordBoolProp write SetWordBoolProp stored False;
  end;

procedure Register;

implementation

uses ComObj;

procedure TDicionario.InitControlData;
const
  CLicenseKey: array[0..19] of Word = (
    $0043, $006F, $0070, $0079, $0072, $0069, $0067, $0068, $0074, $0020,
    $0028, $0063, $0029, $0020, $0031, $0039, $0039, $0036, $0020, $0000);
  CControlData: TControlData = (
    ClassID: '{98D3A6A4-1493-11D0-B467-444553540000}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 300);
begin
  ControlData := @CControlData;
end;

procedure TDicionario.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DOCXDcn;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TDicionario.GetControlInterface: _DOCXDcn;
begin
  CreateControl;
  Result := FIntf;
end;

function TDicionario.GetTOleEnumProp(Index: Integer): TOleEnum;
begin
  Result := GetIntegerProp(Index);
end;

procedure TDicionario.SetTOleEnumProp(Index: Integer; Value: TOleEnum);
begin
  SetIntegerProp(Index, Value);
end;

function TDicionario.GetFirstSon(var Code, Description: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.GetFirstSon(Code, Description);
end;

function TDicionario.GetNextBrother(var Code, Description: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.GetNextBrother(Code, Description);
end;

function TDicionario.NextBrotherIsDone: WordBool;
begin
  CreateControl;
  Result := FIntf.NextBrotherIsDone;
end;

function TDicionario.GetLastSon(var Code, Description: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.GetLastSon(Code, Description);
end;

function TDicionario.GetPreviousBrother(var Code, Description: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.GetPreviousBrother(Code, Description);
end;

function TDicionario.PreviousBrotherIsDone: WordBool;
begin
  CreateControl;
  Result := FIntf.PreviousBrotherIsDone;
end;

function TDicionario.GetCurrentParent(var Code, Description: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.GetCurrentParent(Code, Description);
end;

function TDicionario.GetCurrentSon(var Code, Description: WideString): Smallint;
begin
  CreateControl;
  Result := FIntf.GetCurrentSon(Code, Description);
end;

function TDicionario.FindParents(const SonCode: WideString; var FirstFatherCode: WideString): Smallint;
begin
  CreateControl;
  Result := FIntf.FindParents(SonCode, FirstFatherCode);
end;

function TDicionario.GetFirstParent(var Code, Description: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.GetFirstParent(Code, Description);
end;

function TDicionario.GetNextParent(var Code, Description: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.GetNextParent(Code, Description);
end;

function TDicionario.FindDescriptionByCode(const Code: WideString; var Description: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.FindDescriptionByCode(Code, Description);
end;

function TDicionario.ConnectDictionary(const UserID, UserPassword: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.ConnectDictionary(UserID, UserPassword);
end;

function TDicionario.ExpandCode(const Code: WideString; var ChildrenNumber: Smallint): WordBool;
begin
  CreateControl;
  Result := FIntf.ExpandCode(Code, ChildrenNumber);
end;

procedure TDicionario.DisconnectDictionary;
begin
  CreateControl;
  FIntf.DisconnectDictionary;
end;

function TDicionario.GetFirstCodeByDesc(var Code, Description: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.GetFirstCodeByDesc(Code, Description);
end;

function TDicionario.GetNextCodeByDesc(var Code, Description: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.GetNextCodeByDesc(Code, Description);
end;

function TDicionario.FindCodeByDescription(var Code: WideString; const Description: WideString): Smallint;
begin
  CreateControl;
  Result := FIntf.FindCodeByDescription(Code, Description);
end;

function TDicionario.GetChildrenCount(const Code: WideString; var ChildrenNumber: Smallint): WordBool;
begin
  CreateControl;
  Result := FIntf.GetChildrenCount(Code, ChildrenNumber);
end;

function TDicionario.HasChilds(const Code: WideString): WordBool;
begin
  CreateControl;
  Result := FIntf.HasChilds(Code);
end;

function TDicionario.CollapseCode(const Code: WideString; var ChildrenNumber: Smallint): WordBool;
begin
  CreateControl;
  Result := FIntf.CollapseCode(Code, ChildrenNumber);
end;

procedure TDicionario.AboutBox;
begin
  CreateControl;
  FIntf.AboutBox;
end;


procedure Register;
begin
  RegisterComponents('OCX', [TDicionario]);
end;

end.

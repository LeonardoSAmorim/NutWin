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




unit PesqCidImp;

interface

uses
  Windows, ActiveX, Classes, Controls, Graphics, Menus, Forms, StdCtrls,
  ComServ, StdVCL, AXCtrls, PesqCidXCntrl_TLB, UPesqCid, registry,SysUtils;

type
  TPesqCidX = class(TActiveXControl, IPesqCidX)
  private
    { Private declarations }
    FDelphiControl: TPesqCid;
    FEvents: IPesqCidXEvents;
    procedure CanCloseEvent(Sender: TComponent; NewCID: String;
      var CanClose: Boolean);
    procedure CloseEvent(Sender: TObject);
    procedure ShowEvent(Sender: TObject);
  protected
    { Protected declarations }
    procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    procedure InitializeControl; override;
    function ClassNameIs(const Name: WideString): WordBool; safecall;
    function DrawTextBiDiModeFlags(Flags: Integer): Integer; safecall;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; safecall;
    function Execute: WordBool; safecall;
    function Get_BiDiMode: TxBiDiMode; safecall;
    function Get_CodigoCID: WideString; safecall;
    function Get_Cursor: Smallint; safecall;
    function Get_DescricaoCID: WideString; safecall;
    function Get_DetalheCID: WideString; safecall;
    function Get_DiretorioCID: WideString; safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_FormHeight: Integer; safecall;
    function Get_FormLeft: Integer; safecall;
    function Get_FormPosition: TxPosition; safecall;
    function Get_FormTop: Integer; safecall;
    function Get_FormWidth: Integer; safecall;
    function Get_FormWindowState: TxWindowState; safecall;
    function Get_PesquisaAutomatica: WordBool; safecall;
    function Get_PesquisaInicial: WideString; safecall;
    function Get_Visible: WordBool; safecall;
    function GetControlsAlignment: TxAlignment; safecall;
    function IsRightToLeft: WordBool; safecall;
    function UseRightToLeftAlignment: WordBool; safecall;
    function UseRightToLeftReading: WordBool; safecall;
    function UseRightToLeftScrollBar: WordBool; safecall;
    procedure AboutBox; safecall;
    procedure FlipChildren(AllLevels: WordBool); safecall;
    procedure InitiateAction; safecall;
    procedure Paint; safecall;
    procedure Set_BiDiMode(Value: TxBiDiMode); safecall;
    procedure Set_CodigoCID(const Value: WideString); safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure Set_DescricaoCID(const Value: WideString); safecall;
    procedure Set_DetalheCID(const Value: WideString); safecall;
    procedure Set_DiretorioCID(const Value: WideString); safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_FormHeight(Value: Integer); safecall;
    procedure Set_FormLeft(Value: Integer); safecall;
    procedure Set_FormPosition(Value: TxPosition); safecall;
    procedure Set_FormTop(Value: Integer); safecall;
    procedure Set_FormWidth(Value: Integer); safecall;
    procedure Set_FormWindowState(Value: TxWindowState); safecall;
    procedure Set_PesquisaAutomatica(Value: WordBool); safecall;
    procedure Set_PesquisaInicial(const Value: WideString); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_ArquivosCID: WideString; safecall;
    procedure Set_ArquivosCID(const Value: WideString); safecall;
  end;

implementation

uses ComObj, AboutPesqCid;

{ TPesqCidX }

procedure TPesqCidX.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
  { Define property pages here.  Property pages are defined by calling
    DefinePropertyPage with the class id of the page.  For example,
      DefinePropertyPage(Class_PesqCidXPage); }
end;

procedure TPesqCidX.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IPesqCidXEvents;
end;

procedure TPesqCidX.InitializeControl;
var
  Reg: TRegistry;
begin
  FDelphiControl := Control as TPesqCid;
  FDelphiControl.OnCanClose := CanCloseEvent;
  FDelphiControl.OnClose := CloseEvent;
  FDelphiControl.OnShow := ShowEvent;

  Reg:=TRegistry.Create;
  try
    begin
      Reg.RootKey:=HKEY_CLASSES_ROOT; // Section to look for within the registry
      if not Reg.OpenKey('\CLSID\{A8A4FAA5-8936-11D3-8576-006008DF8A1A}\InprocServer32',False) then
        exit
      else
      FDelphiControl.DiretorioCID:=copy (Reg.ReadString(''),1,LastDelimiter('\',Reg.ReadString('')));
    end;
  finally
    Reg.Free;
  end;

end;

function TPesqCidX.ClassNameIs(const Name: WideString): WordBool;
begin
  Result := FDelphiControl.ClassNameIs(Name);
end;

function TPesqCidX.DrawTextBiDiModeFlags(Flags: Integer): Integer;
begin
  Result := FDelphiControl.DrawTextBiDiModeFlags(Flags);
end;

function TPesqCidX.DrawTextBiDiModeFlagsReadingOnly: Integer;
begin
  Result := FDelphiControl.DrawTextBiDiModeFlagsReadingOnly;
end;

function TPesqCidX.Execute: WordBool;
begin
  Result := FDelphiControl.Execute;
end;

function TPesqCidX.Get_BiDiMode: TxBiDiMode;
begin
  Result := Ord(FDelphiControl.BiDiMode);
end;

function TPesqCidX.Get_CodigoCID: WideString;
begin
  Result := WideString(FDelphiControl.CodigoCID);
end;

function TPesqCidX.Get_Cursor: Smallint;
begin
  Result := Smallint(FDelphiControl.Cursor);
end;

function TPesqCidX.Get_DescricaoCID: WideString;
begin
  Result := WideString(FDelphiControl.DescricaoCID);
end;

function TPesqCidX.Get_DetalheCID: WideString;
begin
  Result := WideString(FDelphiControl.DetalheCID);
end;

function TPesqCidX.Get_DiretorioCID: WideString;
begin
  Result := WideString(FDelphiControl.DiretorioCID);
end;

function TPesqCidX.Get_DoubleBuffered: WordBool;
begin
  Result := FDelphiControl.DoubleBuffered;
end;

function TPesqCidX.Get_Enabled: WordBool;
begin
  Result := FDelphiControl.Enabled;
end;

function TPesqCidX.Get_FormHeight: Integer;
begin
  Result := FDelphiControl.FormHeight;
end;

function TPesqCidX.Get_FormLeft: Integer;
begin
  Result := FDelphiControl.FormLeft;
end;

function TPesqCidX.Get_FormPosition: TxPosition;
begin
  Result := Ord(FDelphiControl.FormPosition);
end;

function TPesqCidX.Get_FormTop: Integer;
begin
  Result := FDelphiControl.FormTop;
end;

function TPesqCidX.Get_FormWidth: Integer;
begin
  Result := FDelphiControl.FormWidth;
end;

function TPesqCidX.Get_FormWindowState: TxWindowState;
begin
  Result := Ord(FDelphiControl.FormWindowState);
end;

function TPesqCidX.Get_PesquisaAutomatica: WordBool;
begin
  Result := FDelphiControl.PesquisaAutomatica;
end;

function TPesqCidX.Get_PesquisaInicial: WideString;
begin
  Result := WideString(FDelphiControl.PesquisaInicial);
end;

function TPesqCidX.Get_Visible: WordBool;
begin
  Result := FDelphiControl.Visible;
end;

function TPesqCidX.GetControlsAlignment: TxAlignment;
begin
 Result := TxAlignment(FDelphiControl.GetControlsAlignment);
end;

function TPesqCidX.IsRightToLeft: WordBool;
begin
  Result := FDelphiControl.IsRightToLeft;
end;

function TPesqCidX.UseRightToLeftAlignment: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftAlignment;
end;

function TPesqCidX.UseRightToLeftReading: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftReading;
end;

function TPesqCidX.UseRightToLeftScrollBar: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftScrollBar;
end;

procedure TPesqCidX.AboutBox;
begin
  ShowPesqCidXAbout;
end;

procedure TPesqCidX.FlipChildren(AllLevels: WordBool);
begin
  FDelphiControl.FlipChildren(AllLevels);
end;

procedure TPesqCidX.InitiateAction;
begin
  FDelphiControl.InitiateAction;
end;

procedure TPesqCidX.Paint;
begin
  FDelphiControl.Paint;
end;

procedure TPesqCidX.Set_BiDiMode(Value: TxBiDiMode);
begin
  FDelphiControl.BiDiMode := TBiDiMode(Value);
end;

procedure TPesqCidX.Set_CodigoCID(const Value: WideString);
begin
  FDelphiControl.CodigoCID := String(Value);
end;

procedure TPesqCidX.Set_Cursor(Value: Smallint);
begin
  FDelphiControl.Cursor := TCursor(Value);
end;

procedure TPesqCidX.Set_DescricaoCID(const Value: WideString);
begin
  FDelphiControl.DescricaoCID := String(Value);
end;

procedure TPesqCidX.Set_DetalheCID(const Value: WideString);
begin
  FDelphiControl.DetalheCID := String(Value);
end;

procedure TPesqCidX.Set_DiretorioCID(const Value: WideString);
begin
  FDelphiControl.DiretorioCID := String(Value);
end;

procedure TPesqCidX.Set_DoubleBuffered(Value: WordBool);
begin
  FDelphiControl.DoubleBuffered := Value;
end;

procedure TPesqCidX.Set_Enabled(Value: WordBool);
begin
  FDelphiControl.Enabled := Value;
end;

procedure TPesqCidX.Set_FormHeight(Value: Integer);
begin
  FDelphiControl.FormHeight := Value;
end;

procedure TPesqCidX.Set_FormLeft(Value: Integer);
begin
  FDelphiControl.FormLeft := Value;
end;

procedure TPesqCidX.Set_FormPosition(Value: TxPosition);
begin
  FDelphiControl.FormPosition := TPosition(Value);
end;

procedure TPesqCidX.Set_FormTop(Value: Integer);
begin
  FDelphiControl.FormTop := Value;
end;

procedure TPesqCidX.Set_FormWidth(Value: Integer);
begin
  FDelphiControl.FormWidth := Value;
end;

procedure TPesqCidX.Set_FormWindowState(Value: TxWindowState);
begin
  FDelphiControl.FormWindowState := TWindowState(Value);
end;

procedure TPesqCidX.Set_PesquisaAutomatica(Value: WordBool);
begin
  FDelphiControl.PesquisaAutomatica := Value;
end;

procedure TPesqCidX.Set_PesquisaInicial(const Value: WideString);
begin
  FDelphiControl.PesquisaInicial := String(Value);
end;

procedure TPesqCidX.Set_Visible(Value: WordBool);
begin
  FDelphiControl.Visible := Value;
end;

procedure TPesqCidX.CanCloseEvent(Sender: TComponent; NewCID: String;
  var CanClose: Boolean);
var
  TempCanClose: WordBool;
begin
  TempCanClose := WordBool(CanClose);
  if FEvents <> nil then FEvents.OnCanClose(WideString(NewCID), TempCanClose);
  CanClose := Boolean(TempCanClose);
end;

procedure TPesqCidX.CloseEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnClose;
end;

procedure TPesqCidX.ShowEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnShow;
end;

function TPesqCidX.Get_ArquivosCID: WideString;
begin
  Result := WideString(FDelphiControl.ArquivosCID);
end;

procedure TPesqCidX.Set_ArquivosCID(const Value: WideString);
begin
  FDelphiControl.ArquivosCID := String(Value);
end;

initialization
  TActiveXControlFactory.Create(
    ComServer,
    TPesqCidX,
    TPesqCid,
    Class_PesqCidX,
    1,
    '',
    OLEMISC_INVISIBLEATRUNTIME,
    tmApartment);
end.

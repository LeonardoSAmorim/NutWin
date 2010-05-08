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




unit CalculoEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TCalculoEditor = class(TForm)
  private
    FOnAfterTerminate: TNotifyEvent;
    FOnAfterCancel: TNotifyEvent;
    FOnBeforeTerminate: TNotifyEvent;
    FOnTerminate: TNotifyEvent;
    FOnBeforeCancel: TNotifyEvent;
    FOnCancel: TNotifyEvent;
    procedure SetOnAfterTerminate(const Value: TNotifyEvent);
    procedure SetOnAfterCancel(const Value: TNotifyEvent);
    procedure SetOnBeforeCancel(const Value: TNotifyEvent);
    procedure SetOnBeforeTerminate(const Value: TNotifyEvent);
    procedure SetOnCancel(const Value: TNotifyEvent);
    procedure SetOnTerminate(const Value: TNotifyEvent);
    { Private declarations }
  protected
    FModal : boolean;
  public
    { Public declarations }
  constructor Create(Container: TWinControl; Modal: Boolean); reintroduce; overload;
  class function AtivaWizard (Container: TWinControl; Sequencia: string; Parent: Boolean = True) : TCalculoEditor;virtual;
  procedure AtivaW (Sequencia: string);virtual;
  published
    property OnBeforeCancel : TNotifyEvent read FOnBeforeCancel write SetOnBeforeCancel;
    property OnCancel : TNotifyEvent read FOnCancel write SetOnCancel;
    property OnAfterCancel : TNotifyEvent read FOnAfterCancel write SetOnAfterCancel;
    property OnBeforeTerminate : TNotifyEvent read FOnBeforeTerminate write SetOnBeforeTerminate;
    property OnTerminate : TNotifyEvent read FOnTerminate write SetOnTerminate;
    property OnAfterTerminate : TNotifyEvent read FOnAfterTerminate write SetOnAfterTerminate;
  end;
  TEditorReference = class of  TCalculoEditor;

implementation

{$R *.DFM}

{ TCalculoEditor }

procedure TCalculoEditor.AtivaW(Sequencia: string);
begin
//
end;

class function TCalculoEditor.AtivaWizard( Container: TWinControl; Sequencia: string; Parent: Boolean = True):TCalculoEditor;
begin
   if Parent then
      begin
         Result:= Create(Container);
//         Result.BorderStyle := bsNone;
         Result.Parent:=Container ;
         Result.WindowState := wsMaximized;
      end
   else
      begin
         Result:= Create(Container);
//         Result.BorderStyle := bsDialog;
         Result.WindowState := wsNormal;
         Result.Position := poScreenCenter;
//         Result.BorderIcons := [];
         Result.Height := 422;
      end;
end;

constructor TCalculoEditor.Create(Container: TWinControl; Modal: Boolean);
begin
   if Modal then
      begin
         Create(Container);
//         self.BorderStyle := bsNone;
         self.Parent:=Container ;
         self.WindowState := wsMaximized;
      end
   else
      begin
         Create(Container);
//         self.BorderStyle := bsDialog;
         self.WindowState := wsNormal;
         self.Position := poScreenCenter;
//         self.BorderIcons := [];
         self.Height := 422;
      end;

   if Assigned(self) then
      self.FModal:=Modal;
end;


procedure TCalculoEditor.SetOnAfterCancel(const Value: TNotifyEvent);
begin
  FOnAfterCancel := Value;
end;

procedure TCalculoEditor.SetOnAfterTerminate(const Value: TNotifyEvent);
begin
  FOnAfterTerminate := Value;
end;

procedure TCalculoEditor.SetOnBeforeCancel(const Value: TNotifyEvent);
begin
  FOnBeforeCancel := Value;
end;

procedure TCalculoEditor.SetOnBeforeTerminate(const Value: TNotifyEvent);
begin
  FOnBeforeTerminate := Value;
end;

procedure TCalculoEditor.SetOnCancel(const Value: TNotifyEvent);
begin
  FOnCancel := Value;
end;

procedure TCalculoEditor.SetOnTerminate(const Value: TNotifyEvent);
begin
  FOnTerminate := Value;
end;

end.

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




unit ErrConsis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfmErrConsistencia = class(TForm)
    MemoExp: TMemo;
    lbIncons: TLabel;
    btOK: TButton;
    btCancel: TButton;
    btDetail: TButton;
    lbCons: TLabel;
    beLinha: TBevel;
    procedure btDetailClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}
procedure FitRectToScreen(var Rect: TRect);
var
  X, Y, Delta: Integer;
begin
  X := GetSystemMetrics(SM_CXSCREEN);
  Y := GetSystemMetrics(SM_CYSCREEN);
  with Rect do begin
    if Right > X then begin
      Delta := Right - Left;
      Right := X;
      Left := Right - Delta;
    end;
    if Left < 0 then begin
      Delta := Right - Left;
      Left := 0;
      Right := Left + Delta;
    end;
    if Bottom > Y then begin
      Delta := Bottom - Top;
      Bottom := Y;
      Top := Bottom - Delta;
    end;
    if Top < 0 then begin
      Delta := Bottom - Top;
      Top := 0;
      Bottom := Top + Delta;
    end;
  end;
end;
procedure CenterWindow(Wnd: HWnd);
var
  R: TRect;
begin
  GetWindowRect(Wnd, R);
  R := Rect((GetSystemMetrics(SM_CXSCREEN) - R.Right + R.Left) div 2,
    (GetSystemMetrics(SM_CYSCREEN) - R.Bottom + R.Top) div 2,
    R.Right - R.Left, R.Bottom - R.Top);
  FitRectToScreen(R);
  SetWindowPos(Wnd, 0, R.Left, R.Top, 0, 0, SWP_NOACTIVATE or
    SWP_NOSIZE or SWP_NOZORDER);
end;


procedure TfmErrConsistencia.btDetailClick(Sender: TObject);
begin
if MemoExp.Visible then
   begin
   btDetail.Caption:='Mais Detalhes...';
   MemoExp.Visible:=False;
   CenterWindow(Handle);
   end
else
    begin
    btDetail.Caption:='Menos Detalhes...';
    MemoExp.Visible:=True;
    CenterWindow(Handle);
    end;
end;

procedure TfmErrConsistencia.btOKClick(Sender: TObject);
begin
ModalResult :=mrOK;
end;

procedure TfmErrConsistencia.FormCreate(Sender: TObject);
begin
CenterWindow(Handle);
end;

procedure TfmErrConsistencia.FormShow(Sender: TObject);
begin
// força apertar o botão + detalhes
if MemoExp.Lines.Count > 0 then
   btDetailClick(self);
//else
   btDetail.visible := False;    
end;

end.

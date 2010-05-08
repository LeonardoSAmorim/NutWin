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




unit UCSUSConect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, RXCtrls, ExtCtrls, RXClock, Mask, ToolEdit;

type
  TFCSUSConectar = class(TForm)
    RxLabel1: TRxLabel;
    RxLabel2: TRxLabel;
    EdtIdent: TEdit;
    EdSenha: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ProgramIcon: TImage;
    DtEdtConect: TDateEdit;
    RxClock1: TRxClock;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCSUSConectar: TFCSUSConectar;

implementation

{$R *.DFM}

procedure TFCSUSConectar.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
     CanClose := True;
end;




procedure TFCSUSConectar.FormActivate(Sender: TObject);
begin
     DtEdtConect.Date:=Now;
end;

end.

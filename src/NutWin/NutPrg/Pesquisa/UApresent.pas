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




unit UApresent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfmPApresent = class(TForm)
    rgIndiv: TRadioGroup;
    Label1: TLabel;
    procedure rgIndivClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPApresent: TfmPApresent;

implementation

uses UPesqWiz;

{$R *.DFM}

procedure TfmPApresent.rgIndivClick(Sender: TObject);
begin
    fmPesq.Todos  := ( rgIndiv.ItemIndex = 0 ) ;
end;

procedure TfmPApresent.FormCreate(Sender: TObject);
begin

    fmPesq.Todos  := ( rgIndiv.ItemIndex = 0 ) ;
end;

end.

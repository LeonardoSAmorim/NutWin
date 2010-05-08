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




unit UFreqNut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfmPFrqNut = class(TForm)
    Label2: TLabel;
    rgFrqNut: TRadioGroup;
    procedure rgFrqNutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPFrqNut: TfmPFrqNut;

implementation

uses UPesqWiz;

{$R *.DFM}

procedure TfmPFrqNut.rgFrqNutClick(Sender: TObject);
begin
   fmPesq.PesqAlim  := ( rgFrqNut.ItemIndex = 0 ) ;
end;

procedure TfmPFrqNut.FormCreate(Sender: TObject);
begin
   fmPesq.PesqAlim  := ( rgFrqNut.ItemIndex = 0 ) ;
end;

end.

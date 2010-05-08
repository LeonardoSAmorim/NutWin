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




unit UPastas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfmCadPastas = class(TForm)
    GroupBox1: TGroupBox;
    lvPastas: TListView;
    ilPastas: TImageList;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AtualizaListView;
  end;

var
  fmCadPastas: TfmCadPastas;

implementation

{$R *.DFM}

procedure TfmCadPastas.Button1Click(Sender: TObject);
begin
        Close;
end;

procedure TfmCadPastas.AtualizaListView;
begin

end;


procedure TfmCadPastas.Button2Click(Sender: TObject);

const

 Names: array[0..5] of String = (
    ('Rubble'  ),
    ('Michael' ),
    ('Bunny'   ),
    ('Silver'  ),
    ('Simpson' ),
    ('Squirrel')
    );
   

var


  I: integer;
  ListItem: TListItem;

begin

  with lvPastas do

  begin
    Parent := Self;

    for I := 0 to High(Names) do
    begin
      ListItem := Items.Add;
      ListItem.Caption := Names[I];

    end;
  end;
end;

end.

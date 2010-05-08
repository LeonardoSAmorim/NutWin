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




unit MenPes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, Mask,db;

type
  TfmPes = class(TForm)
    Button2: TButton;
    Button9: TButton;
    Button13: TButton;
    Button14: TButton;

    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPes: TfmPes;

implementation

uses UPessoa, UCadPes;

{$R *.DFM}

procedure TfmPes.Button13Click(Sender: TObject);
var
F : TfmPessoa;
begin
    F := TfmPessoa.Create(self);
    F.Show;
end;
procedure TfmPes.Button14Click(Sender: TObject);
var
F : TfmCadPes;
begin
    F := TfmCadPes.Create(self);
    F.Show;
end;
procedure TfmPes.Button2Click(Sender: TObject);
begin
     Close;
end;

end.

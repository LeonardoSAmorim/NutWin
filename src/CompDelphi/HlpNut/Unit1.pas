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




unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  hhcomponent, StdCtrls, HtmlHlp, ExtCtrls, InsFrm, DBCtrls, Grids, DBGrids,
  ComCtrls, Buttons;

type
  TfmMenu = class(TForm)
    btPlanoAlimentarOut: TButton;
    InFormBuilder1: TInFormBuilder;
    paPlanoAlimentar: TPanel;
    btPlanoAlimentarIn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Edit1: TEdit;
    procedure btPlanoAlimentarOutClick(Sender: TObject);
    procedure btPlanoAlimentarInClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMenu: TfmMenu;

implementation

uses Unit2, dmHelp;

{$R *.DFM}

procedure TfmMenu.btPlanoAlimentarOutClick(Sender: TObject);
var
   F : TfmPlanoAlimentar;
begin
   F := TfmPlanoAlimentar.Create(self);
   F.ShowModal;
   F.Free;

end;

procedure TfmMenu.btPlanoAlimentarInClick(Sender: TObject);
begin
   InFormBuilder1.CriaFormInterno( TfmPlanoAlimentar );
   InFormBuilder1.ShowInForm;
end;

end.

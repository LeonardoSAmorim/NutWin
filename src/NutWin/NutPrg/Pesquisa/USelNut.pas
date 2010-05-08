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




unit USelNut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MmLstBox, ExtCtrls, MontaLst;

type
  TfmPSelNut = class(TForm)
    mlRefeicao: TMontaLista;
    lbEntr: TMmListBox;
    lbSaida: TMmListBox;
    bbSaida: TBitBtn;
    bbEntr: TBitBtn;
    bbTudoSai: TBitBtn;
    bbTudoEnt: TBitBtn;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPSelNut: TfmPSelNut;

implementation

uses DMPesq;

{$R *.DFM}

procedure TfmPSelNut.FormCreate(Sender: TObject);
begin
   DMPesquisa.TbNutrientes.First;
   While not DMPesquisa.TbNutrientes.EOF do
       begin
        lbEntr.items.add( DMPesquisa.TbNutrientesNOMENUT.asString);
        DMPesquisa.TbNutrientes.Next;
       end;
end;
end.

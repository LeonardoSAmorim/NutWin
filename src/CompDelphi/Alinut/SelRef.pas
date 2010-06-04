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




unit SelRef;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MmLstBox, ExtCtrls, MontaLst, HintListBox;

type
  TfmSelRef = class(TForm)
    mlSelRef: TMontaLista;
    lbSaida: TMmListBox;
    lbEntrada: TMmListBox;
    bbRefAdd: TBitBtn;
    bbRefDel: TBitBtn;
    bbRefDelAll: TBitBtn;
    bbRefOk: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    bbRefCalcela: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSelRef: TfmSelRef;

implementation

{$R *.DFM}

end.

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




unit USelAlim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MmLstBox, ExtCtrls, MontaLst, DBCtrls, HintListBox;

type
  TfmPSelAlim = class(TForm)
    mlSelAlim: TMontaLista;
    lbEntr: TMmListBox;
    lbSaida: TMmListBox;
    bbSaida: TBitBtn;
    bbEntr: TBitBtn;
    bbTudoSai: TBitBtn;
    bbTudoEnt: TBitBtn;
    rgAliGrup: TRadioGroup;
    DBLookupComboBox1: TDBLookupComboBox;
    procedure DBLookupComboBox1CloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPSelAlim: TfmPSelAlim;

implementation

uses DMPesq;

{$R *.DFM}

procedure TfmPSelAlim.DBLookupComboBox1CloseUp(Sender: TObject);
begin
   // caso seja Grupo Alimentar ...
    if rgAliGrup.ItemIndex = 1 then
    begin
      DMPesquisa.TbAlimento.Filter := 'IdGruAli = ' + ''''+ DMPesquisa.TbGrupoAlimIDGRUALI.asString + '''';
      DMPesquisa.TbAlimento.Filtered := True;
    end;

    
    lbEntr.Clear;
    DMPesquisa.TbAlimento.First;
    While not DMPesquisa.TbAlimento.EOF do
    begin
      lbEntr.AddDescricaoGUID( DMPesquisa.TbAlimentoNome.asString,DMPesquisa.TbAlimentoOUID.asString );
      DMPesquisa.TbAlimento.Next;
    end;
    DMPesquisa.TbAlimento.Filtered := False;
end;

end.

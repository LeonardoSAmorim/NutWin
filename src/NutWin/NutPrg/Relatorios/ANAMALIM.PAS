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




unit AnamAlim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  Tfm_Anam_Alim = class(TForm)
    pqcAnamAlim: TPageControl;
    tbsHabAlim: TTabSheet;
    pnlAnamAlim: TPanel;
    pnlAnamAlimTitulo: TPanel;
    GroupBox2: TGroupBox;
    Memo2: TMemo;
    tbsPreferencias: TTabSheet;
    tbsAnorexia: TTabSheet;
    tbsAliPermProib: TTabSheet;
    tbsReforcoNut: TTabSheet;
    tbsPartAlim: TTabSheet;
    tbsRestricoes: TTabSheet;
    tbsIngestAlim: TTabSheet;
    tbsHabIntestinal: TTabSheet;
    GroupBox3: TGroupBox;
    Memo3: TMemo;
    GroupBox6: TGroupBox;
    Memo6: TMemo;
    tbsOrienDietet: TTabSheet;
    tbsPrepCompAli: TTabSheet;
    TabSheet14: TTabSheet;
    GroupBox8: TGroupBox;
    Memo8: TMemo;
    GroupBox9: TGroupBox;
    Memo9: TMemo;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    GroupBox11: TGroupBox;
    Memo11: TMemo;
    RadioGroup1: TRadioGroup;
    GroupBox12: TGroupBox;
    Memo13: TMemo;
    RadioGroup2: TRadioGroup;
    GroupBox13: TGroupBox;
    Edit5: TEdit;
    GroupBox23: TGroupBox;
    Memo22: TMemo;
    GroupBox14: TGroupBox;
    Memo12: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fm_Anam_Alim: Tfm_Anam_Alim;

implementation

{$R *.DFM}

procedure Tfm_Anam_Alim.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

end.

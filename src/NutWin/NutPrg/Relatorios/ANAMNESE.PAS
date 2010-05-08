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




unit Anamnese;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TForm1 = class(TForm)
    pa_Anamnese_Medica: TPanel;
    pgcAnamMed: TPageControl;
    tbsDiagnosticos: TTabSheet;
    GroupBox15: TGroupBox;
    Memo14: TMemo;
    tbsDoencasAss: TTabSheet;
    GroupBox16: TGroupBox;
    Memo15: TMemo;
    tbsAnteFamiliar: TTabSheet;
    GroupBox17: TGroupBox;
    Memo16: TMemo;
    tbsCicloMenstrual: TTabSheet;
    GroupBox18: TGroupBox;
    Memo17: TMemo;
    tbsFumo: TTabSheet;
    GroupBox19: TGroupBox;
    Memo18: TMemo;
    tbsDentMastig: TTabSheet;
    GroupBox20: TGroupBox;
    Memo19: TMemo;
    tbsExercFisico: TTabSheet;
    GroupBox22: TGroupBox;
    Memo21: TMemo;
    tbsAtivFisica: TTabSheet;
    GroupBox21: TGroupBox;
    Memo20: TMemo;
    tbsMedicacao: TTabSheet;
    GroupBox27: TGroupBox;
    ListBox8: TListBox;
    Edit14: TEdit;
    tbsSintomas: TTabSheet;
    GroupBox25: TGroupBox;
    Label50: TLabel;
    ListBox9: TListBox;
    Edit15: TEdit;
    Edit16: TEdit;
    TabSheet11: TTabSheet;
    bb_AnamMed_Ok: TBitBtn;
    bb_AnamNut_Cancelar: TBitBtn;
    pnlAnamMedTitulo: TPanel;
    pa_Anamnese_Alimentar: TPanel;
    pqcAnamAlim: TPageControl;
    tbsHabAlim: TTabSheet;
    GroupBox3: TGroupBox;
    Memo4: TMemo;
    tbsPreferencias: TTabSheet;
    GroupBox4: TGroupBox;
    Memo5: TMemo;
    tbsAnorexia: TTabSheet;
    GroupBox6: TGroupBox;
    Memo6: TMemo;
    tbsAliPermProib: TTabSheet;
    TabSheet14: TTabSheet;
    GroupBox8: TGroupBox;
    Memo8: TMemo;
    tbsReforcoNut: TTabSheet;
    GroupBox9: TGroupBox;
    Memo9: TMemo;
    tbsPartAlim: TTabSheet;
    GroupBox5: TGroupBox;
    Memo7: TMemo;
    tbsRestricoes: TTabSheet;
    GroupBox11: TGroupBox;
    Memo11: TMemo;
    tbsIngestAlim: TTabSheet;
    RadioGroup1: TRadioGroup;
    GroupBox12: TGroupBox;
    Memo13: TMemo;
    tbsHabIntestinal: TTabSheet;
    RadioGroup2: TRadioGroup;
    GroupBox13: TGroupBox;
    Edit17: TEdit;
    tbsOrienDietet: TTabSheet;
    GroupBox23: TGroupBox;
    Memo22: TMemo;
    tbsPrepCompAli: TTabSheet;
    GroupBox14: TGroupBox;
    Memo12: TMemo;
    pnlAnamAlimTitulo: TPanel;
    bb_AnamAli_Ok: TBitBtn;
    bb_AnamAli_Cancelar: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.

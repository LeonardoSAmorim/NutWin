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




unit USelDados;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls, Buttons, MmLstBox, ExtCtrls, MontaLst, Spin;

type
  TfmPSelDados = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbIdade1: TComboBox;
    sdIdade1: TSpinEdit;
    cbIdade2: TComboBox;
    sdIdade2: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lcSexo: TDBLookupComboBox;
    lcCor: TDBLookupComboBox;
    lcNaturalidade: TDBLookupComboBox;
    lcNacionalidade: TDBLookupComboBox;
    cbIMC1: TComboBox;
    sdIMC1: TSpinEdit;
    cbIMC2: TComboBox;
    sdIMC2: TSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    cbPD1: TComboBox;
    sdPD1: TSpinEdit;
    cbPD2: TComboBox;
    sdPD2: TSpinEdit;
    cbPA1: TComboBox;
    sdPA1: TSpinEdit;
    cbPA2: TComboBox;
    sdPA2: TSpinEdit;
    cbAA1: TComboBox;
    sdAA1: TSpinEdit;
    cbAA2: TComboBox;
    sdAA2: TSpinEdit;
    procedure FormHide(Sender: TObject);
    procedure cbIdade1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPSelDados: TfmPSelDados;

implementation

uses DMPesq;

{$R *.DFM}

procedure TfmPSelDados.FormHide(Sender: TObject);
begin

    DMPesquisa.stIdade :=  cbIdade1.Text + sdIdade1.Text + cbIdade2.Text + sdIdade2.Text ;
    DMPesquisa.stSexo  := lcSexo.Text;
    DMPesquisa.stCor   := lcCor.Text;
    DMPesquisa.stNaturalidade := lcNaturalidade.Text;
    DMPesquisa.stNacionalidade := lcNacionalidade.Text;

end;

procedure TfmPSelDados.cbIdade1Exit(Sender: TObject);
begin
   cbIdade2.Items := DMPesquisa.ControlaSinais(cbIdade1.Text);
end;

end.

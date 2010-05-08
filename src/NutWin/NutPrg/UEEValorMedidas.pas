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




unit UEEValorMedidas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FnpNumericEdit, FnpNEditBlank, ExtCtrls, PAINELMEDIDA, DBCtrls,
  Wizard, db;

type
  TfmEEValorMedidas = class(TForm)
    paValorMedidas: TPanel;
    beQtdeAli: TBevel;
    pmEEQtdeAli: TPainelMedida;
    laDescricaoQtdeAli: TLabel;
    imQtdeAli: TImage;
    qbEEQtdeAli: TGroupBox;
    laQtdeAli: TLabel;
    Label1: TLabel;
    deAlim: TDBText;
    DBText1: TDBText;
    Label2: TLabel;
    DBText2: TDBText;
    cbQtdeMed: TDBComboBox;
    laQtdeMed: TLabel;
    procedure FormShow(Sender: TObject);
    procedure cbQtdeMedChange(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEEValorMedidas: TfmEEValorMedidas;

implementation

uses DMSubstCal;

{$R *.DFM}

procedure TfmEEValorMedidas.FormShow(Sender: TObject);
begin
    // Controle das opcoes da Quantidade
        laQtdeMed.Caption := DMSubsCalorico.AproximaMedida( DMSubsCalorico.SCEquiv,
                               DMSubsCalorico.stMedCasCal );
        cbQtdeMed.Items := DMSubsCalorico.AchaMedida( laQtdeMed.caption);

    cbQtdeMed.SetFocus;
    if DMSubsCalorico.TbAliGCal.Fieldbyname('QTDE').asString = '' then
       begin
          // Faz com que só apareça o botão cancelar do wizard, pois
          // não foi digitada o valor em gramas
          Tag := WZ_INVALIDNODE;
          Click;
       end;
end;

procedure TfmEEValorMedidas.cbQtdeMedChange(Sender: TObject);
begin
   if not( cbQtdeMed.Text = '' ) then
      begin
         // Habilita o botão de avançar, pois foi valor está preenchido
         Tag := 0;
         Click;
      end;
end;

procedure TfmEEValorMedidas.FormHide(Sender: TObject);
begin
  // gravo no campo das gramas o valor relativo a multiplicacao da quantidade pelo valor
  // das medidas

  // *** como o Wizard sai antes do hide deste form, gravo aqui somente se for salvar, se não,
  // vai já ter dado Cancelar e o banco estará em Browse.

  with  DMSubsCalorico.TbAliGCal do
  begin
   if (State = dsInsert) or (State = dsEdit) then
      begin
        FieldByName('MEDGR').asString := DMSubsCalorico.SCTotal( DMSubsCalorico.stMedCasCal, cbQtdeMed.text)  ;
      end;
  end;
end;

end.

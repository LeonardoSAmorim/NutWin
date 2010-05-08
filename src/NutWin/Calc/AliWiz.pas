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




unit AliWiz;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Wizard, ComCtrls, ToolWin, ImgList;

type
  TfmAliWiz = class(TForm)
    paAliWiz: TPanel;
    toWizard: TToolBar;
    tbVoltar: TToolButton;
    tbAvancar: TToolButton;
    tbCancelar: TToolButton;
    tbTerminar: TToolButton;
    ilWizard: TImageList;
    procedure FormShow(Sender: TObject);
    procedure AliWizCancel(Sender: TObject; CurrentForm: TForm;
      CurrentOption: Integer);
    procedure AliWizTerminate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Teste : String;
  end;

var
  fmAliWiz: TfmAliWiz;

implementation

uses AliWizLista, AliWizMedida, AliWizPeso, AliWizQtde,
  DMMBoard;

{$R *.DFM}

procedure TfmAliWiz.FormShow(Sender: TObject);
begin
   dmMotherBoard.AliWiz.ShowCurrentForm;
end;

procedure TfmAliWiz.AliWizCancel(Sender: TObject; CurrentForm: TForm;
  CurrentOption: Integer);
begin
   Teste := '';
   Close;
end;

procedure TfmAliWiz.AliWizTerminate(Sender: TObject);
begin
   with dmMotherBoard do
   begin
      Teste := mdAliQtde.ValorNumerico + ' x ' +
               MedidasCaseiras.ListaDeMedidas.DataSet.FieldByName( 'MEDIDA' ).AsString + ' de ' +
               ListaAlimento.ListaDeAlimentos.DataSet.FieldByName( 'NOME' ).AsString + ' = ' +
               mdAliPeso.ValorNumerico + ' g'
   end;
   Close;
end;

initialization

    RegisterClass(TfmAliWizLista);
    RegisterClass(TfmAliWizMedida);
    RegisterClass(TfmAliWizQtde);
    RegisterClass(TfmAliWizPeso);

end.



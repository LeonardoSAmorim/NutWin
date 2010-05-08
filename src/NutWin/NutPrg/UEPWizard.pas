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




unit UEPWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, ExtCtrls, Wizard, ImgList;

type
  TfmEPWizard = class(TForm)
    paEPWiz: TPanel;
    toWizard: TToolBar;
    tbVoltar: TToolButton;
    tbAvancar: TToolButton;
    tbCancelar: TToolButton;
    tbTerminar: TToolButton;
    ilWizard: TImageList;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure EPWizAfterCancel(Sender: TObject);
    procedure EPWizAfterTerminate(Sender: TObject);
  public
    { Public declarations }
  end;

var
  fmEPWizard: TfmEPWizard;

implementation

uses DMSubstCal, UEPSelecGrupo, UEPSelecMedidas, UEPValorGramas,
  UEPValorMedidas;

{$R *.DFM}

procedure TfmEPWizard.FormShow(Sender: TObject);
begin
   DMSubsCalorico.EPWiz.Iniciar('EquivProt');
   DMSubsCalorico.EPWiz.ShowCurrentForm;

end;
procedure TfmEPWizard.FormCreate(Sender: TObject);
begin
    DMSubsCalorico.EPWiz.BotaoAvancar  := tbAvancar;
    DMSubsCalorico.EPWiz.BotaoVoltar   := tbVoltar;
    DMSubsCalorico.EPWiz.BotaoTerminar := tbTerminar;
    DMSubsCalorico.EPWiz.BotaoCancelar := tbCancelar;
    DMSubsCalorico.EPWiz.PainelWizard  := paEPWiz;
    DMSubsCalorico.EPWiz.OnAfterCancel    := EPWizAfterCancel;
    DMSubsCalorico.EPWiz.OnAfterTerminate := EPWizAfterTerminate ;
end;

procedure TfmEPWizard.EPWizAfterCancel(Sender: TObject);
begin
    DMSubsCalorico.TbAliGProt.Cancel;
    Close;
end;

procedure TfmEPWizard.EPWizAfterTerminate(Sender: TObject);
begin
   DMSubsCalorico.TbAliGProt.Post;
   Close;
end;

initialization

    RegisterClass(TfmEPSelecaoGrupo);
    RegisterClass(TfmEPSelecMedidas);
    RegisterClass(TfmEPValorMedidas);
    RegisterClass(TfmEPValorGramas);
end.

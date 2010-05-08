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




unit UEEWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, ToolWin, Wizard, ImgList;

type
  TfmEEWizard = class(TForm)
    toEEWizard: TToolBar;
    paEEWiz: TPanel;
    ilWizard: TImageList;
    tbVoltar: TToolButton;
    tbAvancar: TToolButton;
    tbCancelar: TToolButton;
    tbTerminar: TToolButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure EEWizCancel(Sender: TObject; CurrentForm: TForm;CurrentOption: Integer);
    procedure EEWizTerminate(Sender: TObject);
    procedure EEWizAfterTerminate(Sender: TObject);
    procedure EEWizAfterCancel(Sender: TObject);
  public
    { Public declarations }
  end;

var
  fmEEWizard: TfmEEWizard;

implementation

uses UEESelecaoGrupo, UEESelecMedidas, UEEValorGramas, UEEValorMedidas,
  DMSubstCal;

{$R *.DFM}

procedure TfmEEWizard.FormShow(Sender: TObject);
begin
   DMSubsCalorico.EEWiz.Iniciar('EquivEnerg');
   DMSubsCalorico.EEWiz.ShowCurrentForm;
end;

procedure TfmEEWizard.FormCreate(Sender: TObject);
begin
    DMSubsCalorico.EEWiz.BotaoAvancar  := tbAvancar;
    DMSubsCalorico.EEWiz.BotaoVoltar   := tbVoltar;
    DMSubsCalorico.EEWiz.BotaoTerminar := tbTerminar;
    DMSubsCalorico.EEWiz.BotaoCancelar := tbCancelar;
    DMSubsCalorico.EEWiz.PainelWizard  := paEEWiz;
    DMSubsCalorico.EEWiz.OnAfterCancel    := EEWizAfterCancel;
    DMSubsCalorico.EEWiz.OnAfterTerminate := EEWizAfterTerminate ;

end;

procedure TfmEEWizard.EEWizCancel(Sender: TObject; CurrentForm: TForm;
  CurrentOption: Integer);
begin
end;

procedure TfmEEWizard.EEWizTerminate(Sender: TObject);
begin
end;

procedure TfmEEWizard.EEWizAfterTerminate(Sender: TObject);
begin
  DMSubsCalorico.TbAliGCal.Post;
  Close;
end;

procedure TfmEEWizard.EEWizAfterCancel(Sender: TObject);
begin
  DMSubsCalorico.TbAligCal.Cancel;
  Close;
end;

initialization

    RegisterClass(TfmEESelecaoGrupo);
    RegisterClass(TfmEESelecMedidas);
    RegisterClass(TfmEEValorMedidas);
    RegisterClass(TfmEEValorGramas);

end.

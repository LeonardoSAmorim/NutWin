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




unit UGrafWiz;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ComCtrls, ToolWin, ExtCtrls;

type
  TfmGrafWiz = class(TForm)
    paGrafWiz: TPanel;
    ilWizard: TImageList;
    toEEWizard: TToolBar;
    tbVoltar: TToolButton;
    tbAvancar: TToolButton;
    tbCancelar: TToolButton;
    tbTerminar: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure GrafWizAfterCancel(Sender: TObject);
    procedure GrafWizAfterTerminate(Sender: TObject);

  public
    { Public declarations }
  end;

var
  fmGrafWiz: TfmGrafWiz;

implementation

uses UGrafWizData, UGrafWizFormulas, UGrafWizGraficos, DMGraf;

{$R *.DFM}

{ TfmGrafWiz }

procedure TfmGrafWiz.GrafWizAfterCancel(Sender: TObject) ;
begin
   Close;
end;

procedure TfmGrafWiz.GrafWizAfterTerminate(Sender: TObject);
begin
   Close;
end;

procedure TfmGrafWiz.FormCreate(Sender: TObject);
begin
    dmGraficos.WizGraf.BotaoAvancar  := tbAvancar;
    dmGraficos.WizGraf.BotaoVoltar   := tbVoltar;
    dmGraficos.WizGraf.BotaoTerminar := tbTerminar;
    dmGraficos.WizGraf.BotaoCancelar := tbCancelar;
    dmGraficos.WizGraf.PainelWizard  := paGrafWiz;
    dmGraficos.WizGraf.OnAfterCancel    := GrafWizAfterCancel;
    dmGraficos.WizGraf.OnAfterTerminate := GrafWizAfterTerminate ;
end;

procedure TfmGrafWiz.FormShow(Sender: TObject);
begin
   dmGraficos.WizGraf.Iniciar('GraficosAntropometria');
   dmGraficos.WizGraf.ShowCurrentForm;

end;
procedure TfmGrafWiz.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

initialization
    RegisterClass(TfmGrafWizData);
    RegisterClass(TfmGrafWizFormulas);
    RegisterClass(TfmGrafWizGraficos);

end.

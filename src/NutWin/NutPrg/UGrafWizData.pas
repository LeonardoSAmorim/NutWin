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




unit UGrafWizData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask,  Wizard,  ComCtrls;

type
  TfmGrafWizData = class(TForm)
    paGrafData: TPanel;
    laTit: TLabel;
    laDataInicial: TLabel;
    laDataFinal: TLabel;
//    deInicio: TDateEdit;
//    deFim: TDateEdit;

    paNome: TPanel;
    laNomeIndividuo: TLabel;
    dtInicio: TDateTimePicker;
    dtFim: TDateTimePicker;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    function  ControlaData : boolean;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    procedure BeforeAvancar(Sender: TObject; var Next: Boolean);
  public
    { Public declarations }
  end;

var
  fmGrafWizData: TfmGrafWizData;

implementation

uses DMGraf, Pessoa;

{$R *.DFM}

procedure TfmGrafWizData.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
      Action := caFree;
end;

procedure TfmGrafWizData.FormCreate(Sender: TObject);
begin
     laNomeIndividuo.Caption := dmgraficos.NomeIndividuo ;

//     deInicio.Date := dmGraficos.DataInicialUsuario;
     dtInicio.Date := dmGraficos.DataInicialUsuario;
//     deFim.Date    := dmGraficos.DataFinalUsuario;
     dtFim.Date    := dmGraficos.DataFinalUsuario;

end;

function TfmGrafWizData.ControlaData : boolean;
begin
//   deInicio.CheckValidDate;
//   dtInicio.CheckValidDate;
//   deFim.CheckValidDate;
//   dtFim.CheckValidDate;

//   if (deInicio.Date > deFim.Date ) and
//      ((deInicio.Text <> '  /  /    ') or (deFim.Text <> '  /  /    ')) then
   if (dtInicio.Date > dtFim.Date ) and
      ((DateToStr(dtInicio.date) <> '  /  /    ') or (DateToStr(dtFim.date) <> '  /  /    ')) then

   begin
      ShowMessage('A Data Final é menor que a Data Inicial.');
      Result := False;
   end
//   else if ((deInicio.Text = '  /  /    ') or (deFim.Text = '  /  /    ')) then
   else if ((DateToStr(dtInicio.date) = '  /  /    ') or (DateToStr(dtFim.date) = '  /  /    ')) then
    begin
      ShowMessage('Não pode existir data vazia.');
      Result := False;
    end
   else
    begin
        dmGraficos.IDPessoa := DMPessoa.TbPessoa.FieldByName( 'IDPESSOA' ).AsString;
//        dmGraficos.DataInicialUsuario := deInicio.Date;
//        dmGraficos.DataFinalUsuario   := deFim.Date  ;
        dmGraficos.DataInicialUsuario := dtInicio.Date;
        dmGraficos.DataFinalUsuario   := dtFim.Date  ;

        if dmGraficos.MontaStrFiltroGraficos = '' then
           begin
              ShowMessage('Não existem valores neste período para criar um gráfico.');
              Result := False;
           end
        else
           begin
              Result := True;
           end;
    end;

end;

procedure TfmGrafWizData.BeforeAvancar(Sender: TObject; var Next: Boolean);
begin
   // Se controlaData for True pode avançar
   Next := ControlaData
end;

procedure TfmGrafWizData.FormShow(Sender: TObject);
begin
    dmGraficos.WizGraf.OnBeforeAvancar := BeforeAvancar;
end;

procedure TfmGrafWizData.FormHide(Sender: TObject);
begin
    dmGraficos.WizGraf.OnBeforeAvancar := nil;
end;

end.

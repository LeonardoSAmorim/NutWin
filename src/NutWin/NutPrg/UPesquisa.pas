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




unit UPesquisa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wizard, StdCtrls, Buttons, ExtCtrls;

type
  TfmPesquisa = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    bbVoltar: TBitBtn;
    bbAvancar: TBitBtn;
    bbCancelar: TBitBtn;
    bbTerminar: TBitBtn;
    Wizard: TNewWizard;
    procedure WizardCancel(Sender: TObject; CurrentForm: TForm;
      CurrentOption: Integer);
    procedure WizardTerminate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar;

  end;

var
  fmPesquisa: TfmPesquisa;

implementation

uses UIndiv, UPrinc, USelDados, USelecInqueritos, DMPesq, USelDadosInq,
  UConfDados;

{$R *.DFM}

{ TfmPesquisa }

procedure TfmPesquisa.Iniciar;
begin
   Wizard.Iniciar (DMPesquisa.Sequencia);
   Wizard.ShowCurrentForm;
end;


procedure TfmPesquisa.WizardCancel(Sender: TObject; CurrentForm: TForm;
  CurrentOption: Integer);
begin
   DMPesquisa.LimpaTabeladePesquisa;
   Close;
end;

procedure TfmPesquisa.WizardTerminate(Sender: TObject);
var
  SalvaCursor:TCursor;
  ArquivoCorreto : boolean;

begin
   SalvaCursor := Screen.Cursor;     { Salva cursor atual }
   Screen.Cursor := crHourglass;     { Mostra ampulheta }

   // Gera arquivo de pesquisa:
   if DMPesquisa.Sequencia = 'Pesquisa' then
      ArquivoCorreto := DMPesquisa.GeraArquivoSDF
   else if DMPesquisa.Sequencia = 'PesqInq' then
      ArquivoCorreto := DMPesquisa.GeraArquivoSDFInq;

   // Devo apagar do banco PesqTemp os dados calculados anteriormente.
   DMPesquisa.LimpaTabeladePesquisa;

   // Aviso ao usuário o que aconteceu.
   if ArquivoCorreto then
      begin
       Showmessage('Sua pesquisa foi gerada entre a data inicial: '+ DatetoStr(DMPesquisa.DataAntInicial)
                  + ' e data final :' + DatetoStr(DMPesquisa.DataAntFinal)+ '.' + #13#10 +
                  'Os dados foram gravados no arquivo ' + DMPesquisa.stPath + '.' + #13#10 +
                  'Utilize-o no programa de estatistica de sua preferência.');
      end
   else
      begin
       ShowMessage('Ocorreu algum erro na geração do arquivo de pesquisa. '+ #13#10 +
                   'Por favor, verifique se os dados preenchidos estão corretos, se possui direito de gravação ou se o arquivo já está em uso.');
      end;
   Screen.Cursor := SalvaCursor;  { Sempre retorna ao normal }

   Close;
end;

procedure TfmPesquisa.FormShow(Sender: TObject);
begin
//#   DMPesquisa.EncheListaAntropometrica;
//   Sequencia := 'Pesquisa';
   Iniciar; // coloquei aqui para poder setar a sequencia depois do create
end;

initialization

    RegisterClass(TfmTelaPrincipal);
    RegisterClass(TfmPPastas);
    RegisterClass(TfmPSelDados);
    RegisterClass(TfmSelecionaInqueritos);
    RegisterClass(TfmSelDadosInq);
    RegisterClass(TfmConfDados);

end.
 
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




unit USelDadosInq;
            
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls, Buttons, MmLstBox, ExtCtrls, MontaLst, Spin, ComCtrls,DB,
  Measurement, dmMBoard, Grids, DBGrids, HintListBox;

type
  TfmSelDadosInq = class(TForm)
    GroupBox1: TGroupBox;
    Label10: TLabel;
    dtAntInicial: TDateTimePicker;
    Label11: TLabel;
    dtAntFinal: TDateTimePicker;
    mlAntrop: TMontaLista;
    lbListaAnt1: TMmListBox;
    lbListaAnt2: TMmListBox;
    btFrente: TButton;
    btVolta: TButton;
    btFrenteTudo: TButton;
    btVoltaTudo: TButton;
    Label1: TLabel;
    edPesq: TEdit;
    btDialog: TButton;
    sdPesq: TSaveDialog;
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btDialogClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PesquisaDadosPessoais;
  end;

var
  fmSelDadosInq: TfmSelDadosInq;

implementation

uses DMPesq, Pessoa;

{$R *.DFM}

procedure TfmSelDadosInq.FormHide(Sender: TObject);

begin
   DMPesquisa.DataAntInicial := dtAntInicial.DateTIme;
   DMPesquisa.DataAntFinal := dtAntFinal.DateTime;
   DMPesquisa.stPath := edPesq.text;
   DMPesquisa.ListaAnt1 := lbListaAnt1.Items;
   DMPesquisa.ListaAnt2 := lbListaAnt2.Items;


end;

procedure TfmSelDadosInq.PesquisaDadosPessoais;
var


  stSQL: string;
begin

// Devo verificar se a pesquisa e' por pastas ou por todos os individuos. A variavel que controla isso
// e´ a stOpcaoSelecaoInicial. quando o valor for 0 sao as Pastas, 1 sao todos os individuos.

// montagem da SQL
  stSQL := '' ;
  if DMPesquisa.stOpcaoSelecaoInicial = '0' then
     stSQL := 'SELECT PESQTEMP.IDPESSOA, PESSOA.SOBRPESS, PESSOA.NOMEPESS, PESSOA.DATANASC,'
  else
     stSQL := 'SELECT PESSOA.IDPESSOA,PESSOA.SOBRPESS, PESSOA.NOMEPESS, PESSOA.DATANASC,';

  stSQL := stSQL + ' PESSOA.CODSEXO,PESSOA.DATACAD, PESSCOMP.CODNATURAL,PESSCOMP.CODNACIONAL,';

 if DMPesquisa.stOpcaoSelecaoInicial = '0' then
    begin
     stSQL := stSQL + ' PESSCOMP.CODCOR FROM PESQTEMP , PESSOA ,PESSCOMP';
    // stSQL := stSQL + ' WHERE (PESQTEMP.IDPESSOA = ' + ':stCodControleUsuario' + ') AND (PESQTEMP.IDPESSOA = PESSCOMP.IDPESSOA)';
     stSQL := stSQL + ' WHERE (PESQTEMP.CODIGO = ' + '''' + DMPesquisa.stCodigoControleUsuario + ''''+ ') AND (PESQTEMP.IDPESSOA = PESSCOMP.IDPESSOA) AND (PESQTEMP.IDPESSOA = PESSOA.IDPESSOA)';

  end
 else
    begin
    stSQL := stSQL + ' PESSCOMP.CODCOR FROM PESSOA ,PESSCOMP';
    stSQL := stSQL + ' WHERE (PESSOA.IDPESSOA = PESSCOMP.IDPESSOA)';
    end;

  stSQL := stSQL + ' AND ';


end;

procedure TfmSelDadosInq.FormShow(Sender: TObject);
begin
   lbListaAnt1.Items := DMPesquisa.ListaAnt1;
   lbListaAnt2.Items := DMPesquisa.ListaAnt2;
   dtAntInicial.DateTIme := DMPesquisa.DataAntInicial;
   dtAntFinal.DateTime  := DMPesquisa.DataAntFinal;
   edPesq.Text := DMPesquisa.stPath;
end;

procedure TfmSelDadosInq.btDialogClick(Sender: TObject);
begin
    sdPesq.FileName := edPesq.Text;
    sdPesq.Execute;
    edPesq.Text := sdPesq.FileName;
    DMPesquisa.stPath := edPesq.Text;
end;

procedure TfmSelDadosInq.FormCreate(Sender: TObject);
begin
   DMPesquisa.EncheListaNutInqueritos;
//   dtAntInicial.MaxDate := Now();
//  dtAntFinal.MaxDate := Now();
end;

end.


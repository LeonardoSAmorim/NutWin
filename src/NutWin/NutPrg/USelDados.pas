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
  DBCtrls, StdCtrls, Buttons, MmLstBox, ExtCtrls, MontaLst, Spin, ComCtrls,DB,
  Measurement, dmMBoard, Grids, DBGrids, HintListBox;

type
  TfmPSelDados = class(TForm)
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
  fmPSelDados: TfmPSelDados;

implementation

uses DMPesq, Pessoa;

{$R *.DFM}

procedure TfmPSelDados.FormHide(Sender: TObject);

begin
   DMPesquisa.DataAntInicial := dtAntInicial.DateTIme;
   DMPesquisa.DataAntFinal := dtAntFinal.DateTime;
   DMPesquisa.stPath := edPesq.text;
   DMPesquisa.ListaAnt1 := lbListaAnt1.Items;
   DMPesquisa.ListaAnt2 := lbListaAnt2.Items;

//DMPesquisa.qrPesqTemp.Open;

    {    // Monta a query das opções escolhidas no form.
        PesquisaDadosPessoais;
       // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        try
         DMPesquisa.qrPesqTemp.Open;


        finally
          // Limpa a query se não deu certo ...
          // showmessage()
          // exit;
        end;


// Tem que ser verificado com o Wagner como fazer para colocar na query os dados de IMC, Peso Atual, etc,etc,etc.

// Tendo em mãos o banco de dados já filtrado, faço um while para pegar o inquerito de todos eles
       // Posiciono no primeiro indivíduo
       DMPesquisa.qrPesqTemp.First;
       While not DMPesquisa.qrPesqTemp.Eof do
       begin
       // Mando localizar no banco de inquéritos o que tem a data igual ou mais próxima
          if DMPesquisa.TbInqueritos.Locate('IDPESSOA;DATA',VarArrayOf([DMPesquisa.qrPesqTemp['IDPESSOA'],dtInqueritoInicio.date ]), [loPartialKey]) then
          begin
            // Se achou, deve fazer um loop dentro dos inquéritos analisados na devida data. Caso
            // satisfaça os dados antropométricos guardo para imprimir em formato para ser lido em outros softwares.
             while (not DMPesquisa.TbInqueritos.Eof) and
                   (DMPesquisa.TbInqueritos.Fieldbyname('IDPESSOA').asString = DMPesquisa.qrPesqTemp.Fieldbyname('IDPESSOA').asString) and
                   (DMPesquisa.TbInqueritos.Fieldbyname('DATA').asString <= DatetoStr(dtInqueritoFinal.date)) do
             begin
                   // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                   // Devo gravar as informações num arquivo qualquer ...
                   // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                   DMPesquisa.TbInqueritos.Next;
             end;
             // Vai para o proximo indivíduo selecionado pela pesquisa
             DMPesquisa.qrPesqTemp.Next;
          end;
       end;

       // Esta rotina deve gerar um banco de dados com as informações dos inquéritos
       // Eles devem ser impressos de forma a ser lido por outros softwares.

       // GeraInquéritos;
     }

end;

procedure TfmPSelDados.PesquisaDadosPessoais;
var

//  inSQL : integer;
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

  // configurando a data de nascimento em variavel stIdade
   { if cbIdade1.Text = '' then
       begin
         if cbIdade2.Text <> '' then
            begin
            DMPesquisa.stIdade := ' PESSOA.DATANASC ' + cbIdade2.Text + ' ' + ':AnoFim';
            stSQL := stSQL + ' ' + DMPesquisa.stIdade + ' AND ' ;
            end ;
       end
    else
       begin
         if cbIdade2.Text <> '' then
            begin
            DMPesquisa.stIdade :=  ' PESSOA.DATANASC ' + cbIdade1.Text + ' ' + ':AnoInicio' + ' AND ' + 'PESSOA.DATANASC ' + cbIdade2.Text + ' ' + ':AnoFim';
            end
         else
            DMPesquisa.stIdade :=  ' PESSOA.DATANASC ' + cbIdade1.Text + ' ' + ':AnoInicio';
        stSQL := stSQL +  ' ' + DMPesquisa.stIdade + ' AND ';
       end;

    // Configurando o sexo
    if lcSexo.Text <> '' then
     begin
      DMPesquisa.stSexo  := ' PESSOA.CODSEXO = ' + '''' + DMPesquisa.TbSexo.Fieldbyname('CodSexo').asString + '''';
      stSQL := stSQL + ' ' + DMPesquisa.stSexo + ' AND ';
     end;

    // Configurando a cor
    if lcCor.Text <> '' then
     begin
      DMPesquisa.stCor  := ' PESSCOMP.CODCOR = ' + '''' + DMPesquisa.TbCor.Fieldbyname('CodCor').asString + '''';
      stSQL := stSQL + ' ' + DMPesquisa.stCor + ' AND ';
     end;

    // Configurando a naturalidade
    if lcNaturalidade.Text <> '' then
     begin
      DMPesquisa.stNaturalidade  := ' PESSCOMP.CODNATURAL = ' + '''' + DMPesquisa.TbNaturalidade.Fieldbyname('IdCid').asString + '''';
      stSQL := stSQL + ' ' + DMPesquisa.stNaturalidade + ' AND ';
     end;

    // Configurando a nacionalidade
    if lcNacionalidade.Text <> '' then
     begin
      DMPesquisa.stNacionalidade := ' PESSCOMP.CODNACIONAL = ' + '''' + DMPesquisa.TbNacionalidade.Fieldbyname('IDNAC').asString + '''';
      stSQL := stSQL + ' ' + DMPesquisa.stNacionalidade + ' AND ';
     end;
     // Depois dos parametros prontos, tiro o  AND do final
     Delete( stSQL ,  Length( stSQL) - 3 , 3);
}
     // Colocar na ordem de nome e sobrenome
     stSQL := stSQL + ' ORDER BY PESSOA.NOMEPESS,PESSOA.SOBRPESS';
     DMPesquisa.qrPesqTemp.Close;
     DMPesquisa.qrPesqTemp.SQL.Clear;
     DMPesquisa.qrPesqTemp.SQL.Add( stSQL ) ;

   {  if cbIdade1.Text <> '' then
     begin
        DMPesquisa.qrPesqTemp.ParamByName ('AnoInicio').DataType:=ftDateTime;
        DMPesquisa.qrPesqTemp.ParamByName ('AnoInicio').AsDate:=dtIdade1.date;
     end;

     if cbIdade2.Text <> '' then
     begin
        DMPesquisa.qrPesqTemp.ParamByName ('AnoFim').DataType:=ftDateTime;
        DMPesquisa.qrPesqTemp.ParamByName ('AnoFim').AsDate:=dtIdade2.date;
     end;
    }

end;

procedure TfmPSelDados.FormShow(Sender: TObject);
begin
   lbListaAnt1.Items := DMPesquisa.ListaAnt1;
   lbListaAnt2.Items := DMPesquisa.ListaAnt2;
   dtAntInicial.DateTIme := DMPesquisa.DataAntInicial;
   dtAntFinal.DateTime  := DMPesquisa.DataAntFinal;
   edPesq.Text := DMPesquisa.stPath;
end;

procedure TfmPSelDados.btDialogClick(Sender: TObject);
begin
    sdPesq.FileName := edPesq.Text;
    sdPesq.Execute;
    edPesq.Text := sdPesq.FileName;
    DMPesquisa.stPath := edPesq.Text;
end;

procedure TfmPSelDados.FormCreate(Sender: TObject);
begin
   DMPesquisa.EncheListaAntropometrica;
   DMPesquisa.stPath := 'c:\Pesquisa.txt' ;

end;

end.
 
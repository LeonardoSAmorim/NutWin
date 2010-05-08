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




unit UIndiv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MmLstBox, ExtCtrls, MontaLst, DBCtrls, Wizard,
  HintListBox;

type
  TfmPPastas = class(TForm)
    mlPastas: TMontaLista;
    lbEntr: TMmListBox;
    lbSaida: TMmListBox;
    bbSaida: TBitBtn;
    bbEntr: TBitBtn;
    bbTudoSai: TBitBtn;
    bbTudoEnt: TBitBtn;
    Label1: TLabel;
    paMsgPastas: TPanel;
    laAguarde: TLabel;
    laPasta: TLabel;
    laPastas: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mlPastasDepoisDeMover(Sender: TObject);
  private
    { Private declarations }
    procedure AtualizaBotoesWizard;
  public
    { Public declarations }
    procedure PesPastasSelec  ;
  end;

var
  fmPPastas: TfmPPastas;

implementation

uses DMPesq;

{$R *.DFM}

procedure TfmPPastas.FormCreate(Sender: TObject);
begin
   DMPesquisa.TbPastas.Refresh;
   // Encher a lista com o nome das pastas
   DMPesquisa.TbPastas.First;
   While not DMPesquisa.TbPastas.EOF do
       begin
        lbEntr.items.add( DMPesquisa.TbPastas.Fieldbyname('NomePasta').asString);
        DMPesquisa.TbPastas.Next;
       end;
end;

procedure TfmPPastas.FormHide(Sender: TObject);
begin
     DMPesquisa.lsPastas.Assign(lbSaida.Items);
     paMsgPastas.Visible := True;
     PesPastasSelec;
     paMsgPastas.Visible := False;
end;


procedure TfmPPastas.PesPastasSelec  ;
var
  I : integer;
  sSexo : String;
  codPessoa : string;

begin
  DMPesquisa.TbPessoabk.Refresh;
  DMPesquisa.TbCadPastas.Refresh;

   with DMPesquisa do
   begin
    LimpaTabeladePesquisa;
    TbPesqTemp1.Active := True;
     // Para cada código de Pastas, gravo os individuos que pertencem a elas, sem repetir.
   for I := 0 to lsPastas.Count - 1 do
   begin

     if TbPastas.Locate('NOMEPASTA', lsPastas.Strings[I], [] ) then
        begin
          // colocar o nome da pasta no form de mensagem
          laPastas.Caption := TbPastas.Fieldbyname('NomePasta').asString;

          TbCadPastas.First;
          While not TbCadPastas.EOF do
            begin
            codPessoa := TbCadPastas.Fieldbyname('IdPessoa').AsString;
            if TbPesqTemp1.Locate('CODIGO;IDPESSOA', VarArrayOf([ stCodigoControleUsuario,codPessoa ]), [] ) then
              begin
                 TbCadPastas.Next;
                 //ShowMessage( 'Achei um individuo repetido ...');
              end
              else
              begin
                // grava novo individuo
                 TbPesqTemp1.Append;
                 TbPesqTemp1.Fieldbyname('CODIGO').asString :=  stCodigoControleUsuario;
                 TbPesqTemp1.Fieldbyname('IdPessoa').asString := codPessoa ;

               //   Localizo a pessoa e pego seus dados para gerar o arquivo
                    if tbPessoabk.Locate('IDPESSOA', CodPessoa, []) then
                       begin
                         tbPesqTemp1.Fieldbyname('DATANASC').AsDateTime := tbPessoabk.Fieldbyname('DATANASC').AsDateTime;
                         tbPesqTemp1.Fieldbyname('CODSEXO').AsString    := tbPessoabk.Fieldbyname('CODSEXO').AsString;
                         tbPesqTemp1.Fieldbyname('DATACAD').AsDateTime  := tbPessoabk.Fieldbyname('DATACAD').AsDateTime ;
                         tbPesqTemp1.Fieldbyname('SOBRPESS').AsString    := tbPessoabk.Fieldbyname('SOBRPESS').AsString;
                         tbPesqTemp1.Fieldbyname('NOMEPESS').AsString    := tbPessoabk.Fieldbyname('NOMEPESS').AsString;
                      end;

                 TbPesqTemp1.Post;
                 TbCadPastas.Next;

             end;
            end;
        end;
   end;
   end;
end;


procedure TfmPPastas.FormShow(Sender: TObject);
begin
   AtualizaBotoesWizard;
end;

procedure TfmPPastas.mlPastasDepoisDeMover(Sender: TObject);
begin
   AtualizaBotoesWizard;
end;

procedure TfmPPastas.AtualizaBotoesWizard;
begin
   //Acerta os botoes do wizard
   if mlPastas.Saida.Items.Count = 0 then
      // não foi escolhida nenhuma medida, portanto, não dá para terminar
      Tag:=WZ_INVALIDNODE
   else if DMPesquisa.Sequencia = 'Pesquisa' then
        Tag := 0
   else if DMPesquisa.Sequencia = 'PesqInq' then
        Tag := 1;
   Click;
end;

end.

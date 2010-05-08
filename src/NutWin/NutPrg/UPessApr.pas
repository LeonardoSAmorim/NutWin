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




unit UPessApr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TfmPessApresent = class(TForm)
    paIndividuo: TPanel;
    beFundo: TBevel;
    TabControl1: TTabControl;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    bbIncluir: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    btPessAlt: TBitBtn;
    paInd: TPanel;
    btNovoIndiv: TBitBtn;
    btLocPess: TBitBtn;
    btNavAnterior: TBitBtn;
    btNavProximo: TBitBtn;
    btFechar: TBitBtn;
    pn_Atalhos: TPanel;
    sb_Termina: TSpeedButton;
    sb_Dica: TSpeedButton;
    sb_Ajuda: TSpeedButton;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    btNavLocalizar: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    procedure btFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btNavLocalizarClick(Sender: TObject);
    procedure btNavNovaClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure btNavExcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btPessAltClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure btLocPessClick(Sender: TObject);
    procedure bbFecharClick(Sender: TObject);
    procedure btNovoIndivClick(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    FControle: string;
    procedure SetControle(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property Controle : string read FControle write SetControle;
  end;

var
  fmPessApresent: TfmPessApresent;

implementation

uses Pessoa;

{$R *.DFM}

procedure TfmPessApresent.btFecharClick(Sender: TObject);
begin
    Controle := 'Fechar';
    Close;
end;

procedure TfmPessApresent.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;

end;

procedure TfmPessApresent.SetControle(const Value: string);
begin
  FControle := Value;
end;

procedure TfmPessApresent.btNavLocalizarClick(Sender: TObject);
begin
  if DMPessoa.TbPessoabk.RecordCount = 0 then
     ShowMessage('Não existem dados cadastrados. Utilize o botão Novo.')
  else
     begin
      Controle := 'Localizar';
      Close;
     end;
end;

procedure TfmPessApresent.btNavNovaClick(Sender: TObject);
begin
    Controle := 'Inserir';
    Close;
end;

procedure TfmPessApresent.SpeedButton4Click(Sender: TObject);
begin
    Controle := 'Localizar';
    Close;
end;

procedure TfmPessApresent.btNavExcluirClick(Sender: TObject);
begin
    Controle := 'Localizar';
    Close;
end;

procedure TfmPessApresent.FormCreate(Sender: TObject);
begin
    Controle := 'Localizar';

end;

procedure TfmPessApresent.btPessAltClick(Sender: TObject);
begin
  if DMPessoa.TbPessoabk.RecordCount = 0 then
     ShowMessage('Não existem dados cadastrados. Utilize o botão Novo.')
  else
     begin
      Controle := 'Localizar';
      Close;
     end;
end;

procedure TfmPessApresent.BitBtn3Click(Sender: TObject);
begin
  if DMPessoa.TbPessoabk.RecordCount = 0 then
     ShowMessage('Não existem dados cadastrados. Utilize o botão Novo.')
  else
     begin
      Controle := 'Localizar';
      Close;
     end;
end;

procedure TfmPessApresent.btLocPessClick(Sender: TObject);
begin
  if DMPessoa.TbPessoabk.RecordCount = 0 then
     ShowMessage('Não existem dados cadastrados. Utilize o botão Novo.')
  else
     begin
      Controle := 'Localizar';
      Close;
     end;
end;

procedure TfmPessApresent.bbFecharClick(Sender: TObject);
begin
    Controle := 'Fechar';
    Close;
end;

procedure TfmPessApresent.btNovoIndivClick(Sender: TObject);
begin
   Controle := 'Inserir';
   Close;
end;

procedure TfmPessApresent.BitBtn7Click(Sender: TObject);
begin
   Controle := 'Fechar';
   Close;
end;

procedure TfmPessApresent.BitBtn8Click(Sender: TObject);
begin
  if DMPessoa.TbPessoabk.RecordCount = 0 then
     ShowMessage('Não existem dados cadastrados. Utilize o botão Novo.')
  else
     begin
      Controle := 'Localizar';
      Close;
     end;
end;

procedure TfmPessApresent.BitBtn11Click(Sender: TObject);
begin
    Controle := 'Fechar';
    Close;
end;

procedure TfmPessApresent.BitBtn1Click(Sender: TObject);
begin
   Controle := 'Inserir';
   Close;
end;

end.

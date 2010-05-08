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




unit NutLogin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, jpeg, NutCnst, RegEdit, RegConst2;

type
  Tfm_Login = class(TForm)
    laUsuario: TLabel;
    laSenha: TLabel;
    edUsuario: TEdit;
    edSenha: TEdit;
    btOk: TBitBtn;
    btCancela: TBitBtn;
    imNutWin: TImage;
    procedure btCancelaClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure edSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure edUsuarioKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fm_Login: Tfm_Login;

implementation

uses Pessoa, DMMBoard, DMDBNut, DMSemaf;

{$R *.DFM}

procedure Tfm_Login.btCancelaClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfm_Login.btOkClick(Sender: TObject);
begin
  DMPessoa.UsuarioLogado := '';
  //  Verifico se existe já este cadastro ...
  if DMPessoa.TbUsuarios.Locate('Username;Senha', VarArrayOf([edUsuario.text, DMPessoa.Cript(edSenha.text)]), []) then
  begin
    DMPessoa.UsuarioLogado := DMPessoa.TbUsuarios.fieldbyname('Username').asString;
    // seta as constantes para os relatórios
    with TConstantes( GetConstantes ) do
    begin
       CabecLinha := DMPessoa.TbUsuarios.fieldbyname('CABEC_LINHA').asInteger;
       CabecTexto := DMPessoa.TbUsuarios.fieldbyname('CABEC_TEXTO').asString;
    end;
    if Assigned(dmSemaforo) then
      dmSemaforo.UsuarioDono:= DMPessoa.UsuarioLogado;
    ModalResult := mrOk;
  end
  else
  begin
    ShowMessage('Registro não encontrado. Tente novamente.');
    if Assigned(dmSemaforo) then
      dmSemaforo.UsuarioDono := '-';
    edUsuario.SetFocus;
  end;

  // por enquanto aco isso, depois apagarei estas linhas e habilitarei o controle de senha
  //   DMPessoa.UsuarioLogado := DMPessoa.TbUsuarios.fieldbyname('Username').asString;
  //   ModalResult := mrOk;

end;

procedure Tfm_Login.edSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if key = CHR(VK_RETURN) then
    btOkClick(self);
end;

procedure Tfm_Login.edUsuarioKeyPress(Sender: TObject; var Key: Char);
begin
  if key = CHR(VK_RETURN) then
  begin
    key := #0;
    Perform(Wm_NextDlgCtl, 0, 0);
  end;
end;

procedure Tfm_Login.FormCreate(Sender: TObject);
//var
//   MainPath : String;
begin

  DMPessoa.TbUsuarios.Open;

  // Seta Individuos como opção não liberada
 { if not CarregaChaveString(CFGRoot, CFGPath, 'Path', MainPath ) then
  begin
     ShowMessage( 'Erro de leitura da Chave: Path'  );
     exit;
  end;
  }
  //Application.HelpFile := MainPath + '\Help\NutWin.hlp';

end;

procedure Tfm_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //  DMPessoa.TbUsuarios.Close;
end;

end.


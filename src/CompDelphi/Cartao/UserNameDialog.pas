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




unit UserNameDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CNSCriptografia, StdCtrls, Buttons, CNS, CCSListaLinks; 

type
  TFrmUserNameDialog = class(TForm)
    LBUserName: TListBox;
    CBGrupo: TComboBox;
    ESenha: TCNSEditLabel;
    CNSEditLabel1Nome1: TLabel;
    ERedSenha: TCNSEditLabel;
    CNSEditLabel2Nome1: TLabel;
    EUserName: TCNSEditLabel;
    CNSEditLabel3Nome1: TLabel;
    Label1: TLabel;
    BBInsert: TBitBtn;
    BBDelete: TBitBtn;
    bbok: TBitBtn;
    bbcancel: TBitBtn;
    CNSCriptografia1: TCNSCriptografia;
    procedure FormCreate(Sender: TObject);
    procedure BBInsertClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BBDeleteClick(Sender: TObject);
    procedure LBUserNameClick(Sender: TObject);
    procedure EUserNameChange(Sender: TObject);
  private
    { Private declarations }
    FListaSenha : TStrings;
    FListaGrupo : TStrings;
    FEmClick : boolean;
  public
    { Public declarations }
    property ListaSenha : TStrings read FListaSenha write FListaSenha;
    property ListaGrupo : TStrings read FListaGrupo write FListaGrupo;

  end;

var
  FrmUserNameDialog: TFrmUserNameDialog;

implementation

{$R *.DFM}


procedure TFrmUserNameDialog.FormCreate(Sender: TObject);
begin
   FListaSenha := TStringList.create;
   FListaGrupo := TStringList.create;
end;

procedure TFrmUserNameDialog.BBInsertClick(Sender: TObject);
var
   i : integer;
begin
   i := LBUserName.Items.IndexOf(EUserName.Text);
   if i = -1 then
   begin
      LbUserName.items.add(EUserName.Text);
      ListaSenha.Add(ERedSenha.Text);
      FListaGrupo.Add(CBGrupo.text);
   end else
   begin
      ListaSenha[i] :=  ERedSenha.Text;
      FListaGrupo[i] := CBGrupo.Text;
   end;
end;

procedure TFrmUserNameDialog.FormDestroy(Sender: TObject);
begin
   FListaSenha.free;
   FListaGrupo.free;
end;

procedure TFrmUserNameDialog.BBDeleteClick(Sender: TObject);
var
   i : integer;
begin
   if EUserName.Text = 'DEFAULT' then
   begin
      showmessage('DEFAULT nao pode ser retirado.');
   end else
   begin
      i := LBUserName.Items.IndexOf(EUserName.Text);
      if i > -1 then
      begin
         LbUserName.Items.Delete(i);
         ListaSenha.Delete(i);
         FListaGrupo.Delete(i);
      end;
   end;
end;

procedure TFrmUserNameDialog.LBUserNameClick(Sender: TObject);
begin
   FEmClick := true;
   EUserName.Text := LBUserName.Items[LbUserName.itemindex];
   ESenha.text := FListaSenha[LbUserName.itemindex];
   ERedSenha.text := FListaSenha[LbUserName.itemindex];
   CBGrupo.Text := FListaGrupo[LbUserName.itemindex];
end;

procedure TFrmUserNameDialog.EUserNameChange(Sender: TObject);
begin
   if not FEmClick  then
   begin
      ESenha.text := '';
      ERedSenha.text := '';
      CBGrupo.Text := '';
   end;
   FEmClick := False;
end;

end.

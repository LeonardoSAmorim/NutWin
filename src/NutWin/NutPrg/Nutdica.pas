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




unit NutDica;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, RegEdit, RegConst2, jpeg, DBCtrls;

type
  Tfm_Dica = class(TForm)
    c: TGroupBox;
    Image1: TImage;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    mDica: TDBMemo;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Ramdomiza ;
  end;

var
  fm_Dica: Tfm_Dica;

implementation

uses NutMenu, Pessoa;

{$R *.DFM}

procedure Tfm_Dica.BitBtn1Click(Sender: TObject);
begin
   Close;
end;

procedure Tfm_Dica.BitBtn2Click(Sender: TObject);
begin
    Ramdomiza;

end;

procedure Tfm_Dica.Ramdomiza;
var
  I : integer;
  ValorRam : integer;
begin
  Randomize;
   for I := 0 to (DMPessoa.TbDica.RecordCount - 1) do
   begin
      DMPessoa.TbDica.First;
      ValorRam := random(I) ;
      if ValorRam = 0 then
         DMPessoa.TbDica.MoveBy(1)
      else
         DMPessoa.TbDica.MoveBy(ValorRam);
   end;
end;

procedure Tfm_Dica.CheckBox1Click(Sender: TObject);
begin
  // if not GravaChaveBoolean( CFGRoot, CFGPath, OPCDica, CheckBox1.Checked ) then
     if DMPessoa.TbUsuarios.Locate('USERNAME',DMPessoa.UsuarioLogado,[]) then
        begin // 0 = False e 1 = True
          DMPessoa.TbUsuarios.Edit;
          if CheckBox1.Checked then
            DMPessoa.TbUsuarios.FieldByName('Mostra_Dica').AsInteger := 1
          else
            DMPessoa.TbUsuarios.FieldByName('Mostra_Dica').AsInteger := 0 ;
          DMPessoa.TbUsuarios.Post;
        end;
end;

procedure Tfm_Dica.FormCreate(Sender: TObject);
//var
//   Valor : Boolean;
begin
{  if CarregaChaveBoolean( CFGRoot, CFGPath, OPCDica, Valor ) then
  CheckBox1.Checked := Valor
      if not CriaChaveBoolean( CFGRoot, CFGPath, OPCDica, OPCDicaDefault ) then
         ShowMessage( 'Erro de criação da Chave: ' + OPCDica )
      else
         CheckBox1.Checked := OPCDicaDefault; }

     DMPessoa.TbUsuarios.Active := True ; 
     if DMPessoa.TbUsuarios.Locate('USERNAME',DMPessoa.UsuarioLogado,[]) then
        CheckBox1.Checked := not(DMPessoa.TbUsuarios.FieldByName('Mostra_Dica').AsInteger = 0 )
     else
        CheckBox1.Checked := OPCDicaDefault;

   Ramdomiza;
end;


procedure Tfm_Dica.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action := caFree;
end;

procedure Tfm_Dica.FormShow(Sender: TObject);
begin
     c.SetFocus;
end;

end.

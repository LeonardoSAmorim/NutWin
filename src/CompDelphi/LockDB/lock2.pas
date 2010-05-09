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




unit lock2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ExtCtrls, DBCtrls, Grids, DBGrids, DBTables, StdCtrls;

type
  TfmLockDemo = class(TForm)
    btTrava: TButton;
    grTeste: TDBGrid;
    btLibera: TButton;
    edApp: TEdit;
    dbnTeste: TDBNavigator;
    dsTeste: TDataSource;
    taTeste: TTable;
    dbTeste: TDatabase;
    procedure btTravaClick(Sender: TObject);
    procedure btLiberaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmLockDemo: TfmLockDemo;

implementation

uses dmlock, uAliasName;

{$R *.dfm}

procedure TfmLockDemo.btTravaClick(Sender: TObject);
begin
   if dmlockbd.TravaBancoDados then
   begin
      btTrava.Visible := false;
      btLibera.Visible := true;
      taTeste.Refresh;
      grTeste.Enabled := true;
      dbnTeste.Enabled := true;
   end
   else
      ShowMessage( 'Já existe uma aplicação usando o banco em modo exclusivo!' );
end;

procedure TfmLockDemo.btLiberaClick(Sender: TObject);
begin
   if dmlockbd.LiberaBancoDados then
   begin
      btTrava.Visible := true;
      btLibera.Visible := false;
      taTeste.Refresh;
      grTeste.Enabled := false;
      dbnTeste.Enabled := false;
   end
   else
      ShowMessage( 'Não foi possível liberar o banco. Faça shutdown do banco!' );

end;

procedure TfmLockDemo.FormCreate(Sender: TObject);
begin
dbTeste.AliasName := BDE_ALIAS_NAME;
   edApp.Text := DateTimeToStr(now);
end;

end.


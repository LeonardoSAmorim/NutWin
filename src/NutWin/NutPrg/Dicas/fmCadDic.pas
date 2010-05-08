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




unit fmCadDic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBMyNav, ExtCtrls, Db, DBTables, Mask, DBCtrls, LstNut,
  ComCtrls, Grids, DBGrids, Tabs;

type
  TfmCadDicas = class(TForm)
    Button1: TButton;
    PageControl1: TPageControl;
    tsPesquisa: TTabSheet;
    tsCadastro: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    dbDica: TDBMyNav;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Panel1: TPanel;
    Label1: TLabel;
    edPesq: TEdit;
    DBGrid1: TDBGrid;
    TabSet1: TTabSet;
    procedure Button1Click(Sender: TObject);
    procedure edPesqClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCadDicas: TfmCadDicas;

implementation

uses DMDica1;

{$R *.DFM}

procedure TfmCadDicas.Button1Click(Sender: TObject);
begin
   Close;
end;

procedure TfmCadDicas.edPesqClick(Sender: TObject);
begin
    edPesq.Text := ''; 
end;

procedure TfmCadDicas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree ;
end;

end.

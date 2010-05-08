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




unit fmDicas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus;

type
  TfmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    Cadastro1: TMenuItem;
    Dicas1: TMenuItem;
    Apresentao1: TMenuItem;
    Dicas2: TMenuItem;
    Relatrios1: TMenuItem;
    Dicas3: TMenuItem;
    procedure Sair1Click(Sender: TObject);
    procedure Dicas1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Dicas2Click(Sender: TObject);
    procedure Dicas3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPrincipal: TfmPrincipal;

implementation

uses fmCadDic, fmMDicas, fmRelDicas, DMDica1, fmROpc;

{$R *.DFM}

procedure TfmPrincipal.Sair1Click(Sender: TObject);
begin
    Close;
end;

procedure TfmPrincipal.Dicas1Click(Sender: TObject);
var
 fmDic : TfmCadDicas;

begin
    fmDic := TfmCadDicas.Create(self);
    fmDic.ShowModal;
    DMDica.TbDicas.IndexFieldNames := 'PalPort';
    fmDic.Free;
end;

procedure TfmPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
      Action := caFree;
end;

procedure TfmPrincipal.Dicas2Click(Sender: TObject);
var
 fmMDic : TfmMostraDica;

begin
    fmMDic := TfmMostraDica.Create(self);
    fmMDic.ShowModal;
    fmMDic.Free;
end;

procedure TfmPrincipal.Dicas3Click(Sender: TObject);
var
 fmRelOpc : TfmRelOpc;

begin
    fmRelOpc := TfmRelOpc.Create(self);
    fmRelOpc.ShowModal;
    fmRelOpc.Free;
end;

end.

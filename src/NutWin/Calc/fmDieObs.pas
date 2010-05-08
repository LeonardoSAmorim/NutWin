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




unit fmDieObs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, DBCtrls, ToolWin, Boxes, BxRichTB, ExtCtrls, db;

type
  TfmDieObservacoes = class(TForm)
    paDieObs: TPanel;
    laDieObsTitulo2: TLabel;
    paEditor: TPanel;
    BxRichToolBar1: TBxRichToolBar;
    reDieObs: TDBRichEdit;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDieObservacoes: TfmDieObservacoes;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmDieObservacoes.FormShow(Sender: TObject);
begin

with dmMotherBoard do
begin
    dsDieObservacoes.DataSet.Edit;
    reDieObs.SetFocus;
end;

end;

procedure TfmDieObservacoes.FormHide(Sender: TObject);
begin
   with dmMotherBoard.dsDieObservacoes do
   if ( State = dsInsert ) or ( State = dsEdit ) then
      DataSet.Post;
end;

procedure TfmDieObservacoes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

end.

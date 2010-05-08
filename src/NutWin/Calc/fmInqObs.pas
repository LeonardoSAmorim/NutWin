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




unit fmInqObs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, DBCtrls, ToolWin, Boxes, BxRichTB, ExtCtrls, db;

type
  TfmInqObservacoes = class(TForm)
    paInqObs: TPanel;
    paEditor: TPanel;
    BxRichToolBar1: TBxRichToolBar;
    reInqObs: TDBRichEdit;
    laInqObsTitulo2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmInqObservacoes: TfmInqObservacoes;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmInqObservacoes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfmInqObservacoes.FormShow(Sender: TObject);
begin
with dmMotherBoard do
begin
    dsInqObservacoes.DataSet.Edit;
    reInqObs.SetFocus;
end;
end;

procedure TfmInqObservacoes.FormHide(Sender: TObject);
begin
   with dmMotherBoard.dsInqObservacoes do
   if ( State = dsInsert ) or ( State = dsEdit ) then
      DataSet.Post;
end;

end.

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




unit fmReceita;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolWin, ComCtrls, Boxes, BxRichTB, StdCtrls, ExtCtrls, Measurement,
  DBCtrls, db;

type

  TTeste = class( TStream );

  TfmPrepReceita = class(TForm)
    paReceita: TPanel;
    paEditor: TPanel;
    BxRichToolBar1: TBxRichToolBar;
    laPrepNome: TLabel;
    reReceita: TDBRichEdit;
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPrepReceita: TfmPrepReceita;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmPrepReceita.FormHide(Sender: TObject);
//var
//   Aux : TObject;
begin
{   if (dmMotherBoard.caProcessador.Memoria.Acha (dmMotherBoard.CalcPreparacao.NomeCalculo + 'Receita',Aux)) and (Aux is TStringList) then
    begin
      TStrings( Aux ).Assign( reReceita.Lines );
    end;}
   with dmMotherBoard.dsPrepReceita do
   if ( State = dsInsert ) or ( State = dsEdit ) then
      DataSet.Post;
end;

procedure TfmPrepReceita.FormShow(Sender: TObject);
//var
//   FRec : TStringList;
begin

with dmMotherBoard do
begin
   laPrepNome.Caption := TMedida( CalcPreparacao.DescricaoCalculo ).ValorNumerico;
{   if caProcessador.Memoria.Acha( CalcPreparacao.NomeCalculo + 'Receita', TObject( FRec ) ) and ( FRec is TStringList) then
    begin
      reReceita.Lines.Assign( FRec );
    end;}
    dsPrepReceita.DataSet.Edit;
    reReceita.SetFocus;
end;
end;

procedure TfmPrepReceita.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

end.

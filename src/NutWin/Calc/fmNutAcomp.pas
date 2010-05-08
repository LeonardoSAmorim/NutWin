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




unit fmNutAcomp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, DBCGrids, Grids, DBGrids, db, dbtables;

type
  TfmNutrientesAcomp = class(TForm)
    paNutAcomp: TPanel;
    grNutAcomp: TDBCtrlGrid;
    dkVisivel: TDBCheckBox;
    teNomeNut: TDBText;
    ckVerTodos: TCheckBox;
    laNutAcomp: TLabel;
    rgTipoOrdem: TRadioGroup;
    ckShowEscolhidos: TCheckBox;
    procedure ckVerTodosClick(Sender: TObject);
    procedure rgTipoOrdemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ckShowEscolhidosClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grNutAcompPaintPanel(DBCtrlGrid: TDBCtrlGrid;
      Index: Integer);
    procedure grNutAcompKeyPress(Sender: TObject; var Key: Char);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNutrientesAcomp: TfmNutrientesAcomp;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmNutrientesAcomp.ckVerTodosClick(Sender: TObject);
begin
   with dmMotherBoard do
   begin
      if Assigned( Nutrientes ) then
         Nutrientes.VerTodos := ckVerTodos.Checked;
      if Assigned( CalcPreparacao ) then
         CalcPreparacao.MostraTodosNutrientes := ckVerTodos.Checked;
      if Assigned( CalcInquerito ) then
         CalcInquerito.MostraTodosNutrientes := ckVerTodos.Checked;
      if Assigned( CalcDieta ) then
         CalcDieta.MostraTodosNutrientes := ckVerTodos.Checked;
   end;
   grNutAcomp.Visible := not ckVerTodos.Checked;
   rgTipoOrdem.Visible := not ckVerTodos.Checked;
   ckShowEscolhidos.Visible := not ckVerTodos.Checked;
end;

procedure TfmNutrientesAcomp.rgTipoOrdemClick(Sender: TObject);
begin
with TTable( dmMotherBoard.dsCfgNut.DataSet ) do
begin
   case rgTipoOrdem.ItemIndex of
        0 : IndexName := 'IDXORDPADRAO';
        1 : IndexName := 'IDNOMENUT';
        else
          IndexName := '';
   end;
   First;
end;
end;

procedure TfmNutrientesAcomp.FormShow(Sender: TObject);
begin
   ckVerTodos.Checked := dmMotherBoard.Nutrientes.VerTodos;
   with dmMotherBoard.dsCfgNut.DataSet do
       if not Active then
          Open;
   rgTipoOrdemClick(Sender);
end;

procedure TfmNutrientesAcomp.ckShowEscolhidosClick(Sender: TObject);
begin
with dmMotherBoard.dsCfgNut.DataSet do
begin
   if ckShowEscolhidos.Checked then
      Filter := 'VISIVEL = ''' + 'T' + ''''
   else
      Filter := '';
//   dkVisivel.Enabled := not ckShowEscolhidos.Checked;
   Filtered := ckShowEscolhidos.Checked;
end;
end;

procedure TfmNutrientesAcomp.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   with dmMotherBoard.dsCfgNut.DataSet do
      if State = dsEdit then
         Post;
      if Active then
         Close;
end;

procedure TfmNutrientesAcomp.grNutAcompPaintPanel(DBCtrlGrid: TDBCtrlGrid;
  Index: Integer);
begin
{
if dmMotherBoard.dsCfgNut.DataSet.FieldByName( 'VISIVEL' ).AsString = 'T' then
   teNomeNut.Font.Style := [fsBold]
else
   teNomeNut.Font.Style := []; }
end;

procedure TfmNutrientesAcomp.grNutAcompKeyPress(Sender: TObject;
  var Key: Char);
begin
with dmMotherBoard.dsCfgNut.DataSet do
   if Key = chr(VK_SPACE) then
      begin
         Edit;
         if dkVisivel.Checked then
            FieldByName( 'VISIVEL' ).AsString := 'F'
         else
            FieldByName( 'VISIVEL' ).AsString := 'T';
         Post;
      end
   else
      Locate( 'NOMENUT', Key, [loCaseInsensitive, loPartialKey] );
end;

procedure TfmNutrientesAcomp.FormHide(Sender: TObject);
begin
{*with dmMotherBoard.Nutrientes.ConfigListaDeNutrientes do
   if State = dsEdit  then
      begin
//*         DataSet.DisableControls;
//*         DataSet.Post;
      end;}
   // Forçando um refresh
   with TTable( dmMotherBoard.dsCfgNut.DataSet ) do
   if Active then
      First;
end;

end.

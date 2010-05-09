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




unit UGrafWizFormulas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, DBGrids, Wizard, db;

type
  TfmGrafWizFormulas = class(TForm)
    paWiz: TPanel;
    Label1: TLabel;
    grFormulas: TDBGrid;
    paNome: TPanel;
    laNomeIndividuo: TLabel;
    ckComFaixa: TCheckBox;
    dsComFaixas: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure grFormulasCellClick(Column: TColumn);
    procedure ckComFaixaClick(Sender: TObject);
    procedure dsComFaixasDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmGrafWizFormulas: TfmGrafWizFormulas;

implementation

uses DMGraf;

{$R *.DFM}

procedure TfmGrafWizFormulas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmGrafWizFormulas.FormCreate(Sender: TObject);
begin
   dmGraficos.ComFaixas := False;
  dmGraficos.taDescFaixas.Active := True;
  laNomeIndividuo.Caption := dmgraficos.NomeIndividuo ;
end;


procedure TfmGrafWizFormulas.grFormulasCellClick(Column: TColumn);
begin
     Tag := 0 ;
     Click;
end;

procedure TfmGrafWizFormulas.ckComFaixaClick(Sender: TObject);
begin
 with dmGraficos do
 begin
   if ckComFaixa.Checked then
       ComFaixas := True
   else
       ComFaixas := False;
 end;
end;

procedure TfmGrafWizFormulas.dsComFaixasDataChange(Sender: TObject;
  Field: TField);
begin
   ckComFaixa.Visible := ( dmGraficos.taDescFaixas.FieldByName( 'ATIVO' ).AsString = 'T' )
end;

end.
 
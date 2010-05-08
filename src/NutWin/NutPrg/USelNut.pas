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




unit USelNut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, MontaLst, db, ComCtrls;

type
  TfmSelecNut = class(TForm)
    MontaLista1: TMontaLista;
    Label1: TLabel;
    lbDir: TListBox;
    lbEsq: TListBox;
    btMoveDir: TButton;
    btMoveTudoDir: TButton;
    btMoveEsq: TButton;
    btMoveTudoEsq: TButton;
    Button1: TButton;
    Button2: TButton;
    anNut: TAnimate;
    laNut: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FDatasource : TDataSource;
  public
    { Public declarations }
    property Datasource : TDatasource read FDataSource write FDataSource;
  end;
var
  fmSelecNut: TfmSelecNut;

implementation

uses DMAliPrep, DMNutrien;

{$R *.DFM}

procedure TfmSelecNut.FormShow(Sender: TObject);
begin
   FDataSource := DMAlimentos.DSAlimento;
   lbEsq.items.Clear;
   lbDir.items.Clear;
   lbEsq.Items.AddStrings(DMNutrientes.NutrienteNaoCadastrado);

end;

procedure TfmSelecNut.Button2Click(Sender: TObject);
begin
     Close;
end;

procedure TfmSelecNut.Button1Click(Sender: TObject);
begin
   // chama o cadastramento de nutrientes
   anNut.Visible := True;
   anNut.Active := True;
   DMNutrientes.GeraNutrientes( lbDir.Items );
   anNut.Active := False;
   anNut.Visible := False;
   Close;
end;

end.

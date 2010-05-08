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




unit UConfDados;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Grids, DBGrids, Mask, DBCtrls;

type
  TfmConfDados = class(TForm)
    laInf1: TLabel;
    laInf2: TLabel;
    laInf3: TLabel;
    laInf4: TLabel;
    laInf5: TLabel;
    laInf6: TLabel;
    laInf7: TLabel;
    laInf8: TLabel;
    lbPesq: TListBox;
    paConfDados: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmConfDados: TfmConfDados;

implementation

uses DMPesq;

{$R *.DFM}

procedure TfmConfDados.FormShow(Sender: TObject);
begin
   //  DMPesquisa.qrPesqTemp.Active := True;
  laInf3.Caption := DatetoStr(DMPesquisa.DataAntInicial);
  laInf5.Caption := DatetoStr(DMPesquisa.DataAntFinal);
  laInf7.Caption := DMPesquisa.stPath;
  
  lbPesq.Items := DMPesquisa.ListaAnt2 ;

end;



procedure TfmConfDados.FormCreate(Sender: TObject);
begin
  laInf3.Caption := DatetoStr(DMPesquisa.DataAntInicial);
  laInf5.Caption := DatetoStr(DMPesquisa.DataAntFinal);
  laInf7.Caption := DMPesquisa.stPath;
  
  lbPesq.Items := DMPesquisa.ListaAnt2 ;
end;

end.


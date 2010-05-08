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




unit UFonetPess;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls, Grids, DBGrids, ExtCtrls;

type
  TfmFonetPess = class(TForm)
    paFon: TPanel;
    laSemel: TLabel;
    laDados: TLabel;
    grFon: TDBGrid;
    paDados: TPanel;
    teCad: TDBText;
    teNasc: TDBText;
    teNResp: TDBText;
    teSResp: TDBText;
    laCad: TLabel;
    laNasc: TLabel;
    laNResp: TLabel;
    laSResp: TLabel;
    laNSResp: TLabel;
    btOk: TButton;
    ckFon: TCheckBox;
    diFotog: TDBImage;
    procedure btOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmFonetPess: TfmFonetPess;

implementation

uses Pessoa;

{$R *.DFM}

procedure TfmFonetPess.btOkClick(Sender: TObject);
begin
   Close;
end;

procedure TfmFonetPess.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

end.

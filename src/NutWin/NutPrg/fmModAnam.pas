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




unit fmModAnam;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Mask, DBMyNav, ComCtrls, Grids, DBGrids;

type
  TfmTipoAnam = class(TForm)
    paTipoAnam: TPanel;
    DBGrid1: TDBGrid;
    reModelo: TDBRichEdit;
    nvTipoAnam: TDBMyNav;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DBREdDestino : TDBRichEdit;

  end;

var
  fmTipoAnam: TfmTipoAnam;

implementation

uses Pessoa, CadAnam;

{$R *.DFM}

procedure TfmTipoAnam.Button1Click(Sender: TObject);
begin
    Close;
end;

procedure TfmTipoAnam.Button2Click(Sender: TObject);
begin
// Copiar modelo para o banco de dados de anamnese
    fmTipoAnam.reModelo.SelectAll;
    fmTipoAnam.reModelo.CopyToClipboard;
    if Assigned (DBREdDestino) then
       begin
         DBREdDestino.SelectAll;
         DBREdDestino.PasteFromClipboard ;
         DBREdDestino.SetFocus;
       end;

       Close;
end;

end.

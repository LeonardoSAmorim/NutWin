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




unit CadAnam;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, db, DBCtrls, DBMyNav, Mask;

type
  TfmAnam = class(TForm)
    paAnam: TPanel;
    deData: TDBEdit;
    laData: TLabel;
    dbAnamnese: TDBMyNav;
    Label1: TLabel;
    reAnam: TDBRichEdit;
    btFechar: TButton;
    Button1: TButton;
    procedure btFecharClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAnam: TfmAnam;

implementation

uses Pessoa, fmModAnam;

{$R *.DFM}

procedure TfmAnam.btFecharClick(Sender: TObject);
begin
    if (dbAnamnese.DataSource.State = dsEdit) or
       (dbAnamnese.DataSource.State = dsInsert) then
       dbAnamnese.DataSource.DataSet.Post;
       
    Close;
end;

procedure TfmAnam.Button1Click(Sender: TObject);
begin
   Application.CreateForm(TfmTipoAnam, fmTipoAnam);
   fmTipoAnam.DBREdDestino:=reAnam;
   fmTipoAnam.ShowModal;
   fmTipoAnam.Free;
end;

end.

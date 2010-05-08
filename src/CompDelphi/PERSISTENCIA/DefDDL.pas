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




unit DefDDL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Db, DBTables;

type
  TFrmDefDDL = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter2: TSplitter;
    Panel4: TPanel;
    MMDDL: TMemo;
    MMJoin: TMemo;
    QryDDLJoin: TQuery;
    Pbotoes: TPanel;
    BitBtn3: TBitBtn;
    BBOk: TBitBtn;
    BBCancel: TBitBtn;
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDefDDL: TFrmDefDDL;

implementation

{$R *.DFM}

procedure TFrmDefDDL.BitBtn3Click(Sender: TObject);
var
   i : integer;
begin
   QryDDLJoin.Close;
   QryDDLJoin.Sql.Clear;
   for i := 0 to MMDDL.Lines.Count - 1 do
   begin
      if not ((MMDDL.Lines[i] = 'end.////////////////////////////////') or
         (copy(MMDDL.Lines[i],1, 13) = 'Object Name: ')) then
         QryDDLJoin.Sql.Add(MMDDL.Lines[i])
      else
      begin
        if not (copy(MMDDL.Lines[i],1, 13) = 'Object Name: ') then
        begin
          try
             QryDDLJoin.ExecSQL;
             QryDDLJoin.Close;
             QryDDLJoin.Sql.Clear;
          except
             Showmessage('Erro executando ' + QryDDLJoin.Text);
             QryDDLJoin.Close;
             QryDDLJoin.Sql.Clear;
          end;
        end;
      end;
   end;
end;

end.

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




unit fmMDicas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, DBCtrls;

type
  TfmMostraDica = class(TForm)
    cbMostraDica: TCheckBox;
    btProx: TBitBtn;
    btFecha: TBitBtn;
    Panel1: TPanel;
    ImPort: TImage;
    dmMostra: TDBMemo;
    cbIngl: TCheckBox;
    lbIngl: TLabel;
    procedure btFechaClick(Sender: TObject);
    procedure btProxClick(Sender: TObject);
    procedure cbInglClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMostraDica: TfmMostraDica;

implementation

uses DMDica1;

{$R *.DFM}

procedure TfmMostraDica.btFechaClick(Sender: TObject);
begin
   Close;
end;

procedure TfmMostraDica.btProxClick(Sender: TObject);
begin
   with DMDica.TbDicas do
      begin
        Next;
        if EOF then First;
      end;
end;

procedure TfmMostraDica.cbInglClick(Sender: TObject);
begin
   if cbIngl.Checked then
      begin
        dmMostra.DataField := 'DicaIngl';
        lbIngl.Visible     :=  True;
      end
   else
      begin
        dmMostra.DataField := 'DicaPort';
        lbIngl.Visible     :=  False;
      end;
end;
procedure TfmMostraDica.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     Action := caFree; 
end;

end.

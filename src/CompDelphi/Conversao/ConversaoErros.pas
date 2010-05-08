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




unit ConversaoErros;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TfmConversaoErros = class(TForm)
    paBottom: TPanel;
    paRight: TPanel;
    buFechar: TButton;
    buImprimir: TButton;
    paClient: TPanel;
    reErrosConv: TRichEdit;
    SaveDialog: TSaveDialog;
    laOBS: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    procedure buFecharClick(Sender: TObject);
    procedure buImprimirClick(Sender: TObject);
    procedure buExcluirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmConversaoErros: TfmConversaoErros;

implementation

uses Procedures;

{$R *.DFM}

procedure TfmConversaoErros.buFecharClick(Sender: TObject);
begin
   Close;
end;

procedure TfmConversaoErros.buImprimirClick(Sender: TObject);
begin
   reErrosConv.Print('Erros de conversão');
end;

procedure TfmConversaoErros.buExcluirClick(Sender: TObject);
begin
   if saveDialog.Execute then
      reErrosConv.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TfmConversaoErros.FormClose(Sender: TObject;
var
   Action: TCloseAction);
begin
   Action := caFree;
end;

end.

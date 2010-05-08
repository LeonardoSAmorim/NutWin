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





unit qrselect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, printers;

type
  TfrmSelectPrinter = class(TForm)
    Label1: TLabel;
    cbPrinters: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Printer : TPrinter;
    PrinterIndex: integer;
  end;

var
  frmSelectPrinter: TfrmSelectPrinter;

implementation

{$R *.DFM}

procedure TfrmSelectPrinter.FormDestroy(Sender: TObject);
begin
  // All done, free the printer object
  printer.free;
end;

procedure TfrmSelectPrinter.FormShow(Sender: TObject);
var
  nIdx: integer;
begin
  // create a printer to get the list of printers
  Printer := TPrinter.Create;

  // Now populate the combobox with the list of printer names
  try
    with Printer do
      for nIdx := 0 to Printers.Count - 1 do
        cbPrinters.Items.Add(printers[nIdx]);
  except
    raise;
  end;

  // Set the combo box to the current printer as defined
  // by the caller.  It may not be the default printer
  cbPrinters.ItemIndex := PrinterIndex;
end;

procedure TfrmSelectPrinter.BitBtn3Click(Sender: TObject);
begin
  // reset the printer index back to the default
  Printer.PrinterIndex := -1;
  cbPrinters.ItemIndex := Printer.PrinterIndex;
end;

end.

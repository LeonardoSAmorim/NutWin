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




unit testebk;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses BackupCM, RestoreCM;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
   Application.CreateForm(TfmBackup, fmBackup);
   fmBackup.pListaDeArquivos.Add('C:\PROJETO\NUTWIN\IBDADOS\BDADOS.GDB'); //Default
   fmBackup.edTitulo.text := 'Cópia feita por Ione em '+DateToStr(Date);
   fmBackup.edArquivo.text := 'a:\nutwin.bcm';
   fmBackup.ShowModal;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   Application.CreateForm(TfmRestore, fmRestore);
   fmRestore.ShowModal;

end;

end.

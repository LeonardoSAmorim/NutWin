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




unit PersonaDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl;

type
  TfmDialogPersonaDir = class(TForm)
    bbOk: TButton;
    Label1: TLabel;
    flArquivos: TFileListBox;
    dlDiretorios: TDirectoryListBox;
    dcDrive: TDriveComboBox;
    bbCancela: TButton;
    procedure dcDriveChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDialogPersonaDir: TfmDialogPersonaDir;

implementation

{$R *.DFM}

procedure TfmDialogPersonaDir.dcDriveChange(Sender: TObject);
var
   OldDrive : char;
begin
   OldDrive := 'C';
   try
      OldDrive := dlDiretorios.Drive;
      dlDiretorios.Drive := dcDrive.Drive
   except
      MessageDlg('Drive ''' + dcDrive.Drive + ''' não está disponível.',mtError,[mbOk],0);
      dlDiretorios.Drive := OldDrive;
      dcDrive.Drive := OldDrive;
   end;
end;

end.

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




unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  backup, StdCtrls, ExtCtrls, ComCtrls, FileCtrl;

type
  TForm1 = class(TForm)
    OpenDialog: TOpenDialog;
    Backupfile1: TBackupFile;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    FileListBox: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Panel1: TPanel;
    Button3: TButton;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    rgBackupMode: TRadioGroup;
    Label2: TLabel;
    EdBackupTitle: TEdit;
    BtnCancel: TButton;
    SaveDialog: TSaveDialog;
    Button5: TButton;
    Button6: TButton;
    FileListBox1: TFileListBox;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Edit2: TEdit;
    rgRestoreMode: TRadioGroup;
    Label3: TLabel;
    rgCompressionLevel: TRadioGroup;
    gbRestorepath: TGroupBox;
    rbOrigpath: TRadioButton;
    rbOtherPath: TRadioButton;
    EdPath: TEdit;
    CbFullPath: TCheckBox;
    Edit1: TEdit;
    Label4: TLabel;
    CbSaveFileID: TCheckBox;
    MeFiles: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Backupfile1Progress(Sender: TObject; Filename: String;
      Percent: TPercentage; var Continue: Boolean);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure rbOrigpathClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
   I: Integer;
begin
   if OpenDialog.execute then with FileListbox.items do
   begin
     beginupdate;
     for I := 0 to OpenDialog.files.count-1 do
       if indexof(lowercase(OpenDialog.files[i])) = -1 then
          add(lowercase(OpenDialog.files[i]));
     endupdate;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     if Filelistbox.items.count = 0 then Showmessage('No files added')
     else with SaveDialog do if execute then
     begin
          if uppercase(copy(filename, 1, 1)) = 'A' then
          begin
               Showmessage('Drive A indicates a floppy drive - please a new empty disk');
               BackupFile1.maxSize := 1400000;  //backup to floppy
          end
          else BackupFile1.maxSize := 0;

          backupfile1.backuptitle      := EdBackupTitle.text;
          backupfile1.backupmode       := TBackupMode(rgBackupmode.itemindex);
          backupfile1.compressionLevel := TCompressionLevel(rgCompressionLevel.itemindex);
          backupfile1.SaveFileID       := CbSaveFileID.checked;

          if backupfile1.backup(filelistbox.items, filename)
           then Showmessage('Backup sucessful. Compression rate = '+inttostr(BackupFile1.compressionrate)+' %')
           else Showmessage('Backup failed or aborted');
     end;
end;

procedure TForm1.Backupfile1Progress(Sender: TObject; Filename: String;
  Percent: TPercentage; var Continue: Boolean);
begin
     with Progressbar1 do
     begin
          visible := Percent < 100;
          if visible then position := Percent;
     end;
     if Percent < 100 then Label1.caption := Filename else Label1.caption := '';
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   S: string;
begin
     S := extractFilepath(application.exename)+'*.*';
     if InputQuery('Add files with wildcards', 'Enter path + file mask', S) then FileListBox.items.add(S);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     filelistbox.items.clear;
end;

procedure TForm1.BtnCancelClick(Sender: TObject);
begin
     if not BackupFile1.busy then close
     else if MessageDlg('Do you want to abort the operation',mtConfirmation, [mbYes,mbNo], 0) = mrYes then Backupfile1.Stop;
end;

procedure TForm1.FileListBox1Click(Sender: TObject);
var
   files: tstringlist;
   I: integer;
   S, FA, SZ: string;
begin
     files := TStringlist.create;
     MeFiles.lines.clear;
     Edit2.text := backupfile1.getArchiveTitle(Filelistbox1.filename, files);
     if Edit2.text = '' then Edit1.text := ''
     else begin
       Edit1.text := inttostr(backupfile1.FilesTotal)+' files, '+inttostr(round(backupfile1.SizeTotal/1024))+' KB total';
       MeFiles.lines.beginupdate;
       for I := 0 to files.count-1 do
       begin
            S  := copy(files[i],1,pos(#9,Files[i])-1);  //file name
            FA := copy(files[i],pos(#9,Files[i])+1,pos('=',Files[i])-pos(#9,Files[i])-1);  //file age
            FA := DateToStr(
                  FileDateToDateTime(
                  StrtoInt(FA)       //integer file date is system + language independent!
                  ));
            SZ := copy(files[i],pos('=',Files[i])+1, length(Files[i])-pos('=',Files[i]));  //file size in Bytes
            MeFiles.lines.add(S + ' from ' + FA + ', ' + SZ + ' bytes');
       end;
       if files.count = 0 then MeFiles.lines.add('No extended file information in this archive');
       MeFiles.lines.endupdate;
     end;
     files.free;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   S: string;
begin
     backupfile1.Restoremode  := TRestoreMode(rgRestoreMode.itemindex);
     if rbOrigpath.checked then S := ''
     else begin
          S := EdPath.text;
          if trim(s) = '' then
          begin
               showmessage('Please enter a target path');
               exit;
          end;
     end;
     backupfile1.restoreFullpath := cbFullpath.enabled and cbFullpath.checked;
     if backupfile1.restore(filelistbox1.filename, S)
       then showmessage('Restore successfully finished, '+inttostr(backupfile1.FilesProcessed)+' files of '+inttostr(backupfile1.FilesTotal)+' restored')
       else showmessage('Restore failed or user has canceled');
end;

procedure TForm1.rbOrigpathClick(Sender: TObject);
begin
     EdPath.enabled     := rbOtherPath.checked;
     cbFullPath.enabled := rbOtherPath.checked;
end;

end.

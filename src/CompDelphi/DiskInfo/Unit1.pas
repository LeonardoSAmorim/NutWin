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
  Windows, Classes, Controls, Forms, StdCtrls, SysUtils,
  DiskInfo;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Serial: TLabel;
    Volume: TLabel;
    System: TLabel;
    DiskInfo: TDiskInfo;
    Label5: TLabel;
    DriveType: TLabel;
    Label6: TLabel;
    DiskSize: TLabel;
    Label7: TLabel;
    DiskFree: TLabel;
    Label8: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormActivate(Sender: TObject);
var
  DriveNum: Integer;
  DriveBits: set of 0..25;
  DriveType: TDriveType;
  St: String;
begin
  Integer(DriveBits) := GetLogicalDrives;
  for DriveNum := 0 to 25 do
   begin
    if not (DriveNum in DriveBits) then Continue;
    
// optional    
    DriveType := TDriveType(GetDriveType(PChar(Char(DriveNum + 65) + ':\')));
    case DriveType of
       dtFloppy: St := ' - [Floppy]';
        dtFixed: St := ' - [Fixed]';
      dtNetwork: St := ' - [Network]';
        dtCDROM: St := ' - [CD-ROM]';
          dtRAM: St := ' - [RAM]';
     end;

    ComboBox1.Items.Add(Char(DriveNum + 65) + St);
   end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  DiskInfo.Disk := ComboBox1.Items[ComboBox1.ItemIndex][1];

// Error
  if DiskInfo.SerialNumber = 0 then
   Application.MessageBox('Error reading disk parameters.', 'Error', mb_Ok or mb_IconStop);

  Serial.Caption := DiskInfo.SerialNumberStr;
  Volume.Caption := DiskInfo.VolumeLabel;
  System.Caption := DiskInfo.FileSystem;
  DiskSize.Caption := IntToStr(DiskInfo.DiskSize) + ' bytes';
  DiskFree.Caption := IntToStr(DiskInfo.DiskFree) + ' bytes';

  case DiskInfo.DriveType of
     dtFloppy: DriveType.Caption := 'Floppy';
      dtFixed: DriveType.Caption := 'Fixed';
    dtNetwork: DriveType.Caption := 'Network';
      dtCDROM: DriveType.Caption := 'CD-ROM';
        dtRAM: DriveType.Caption := 'RAM';
   end;
end;

end.

{*************************************************************}
{            DiskInfo component for Delphi 32                 }
{ Version:   1.0                                              }
{ Author:    Aleksey Kuznetsov, Kiev, Ukraine                 }
{            Алексей Кузнецов (Xacker), Киев, Украина         }
{ E-Mail:    xacker@phreaker.net                              }
{ Home Page: xacker.phiberoptix.com                           }
{ Created:   May, 4, 1999                                     }
{ Modified:  May, 4, 1999                                     }
{ Legal:     Copyright (c) 1999 by Aleksey Xacker             }
{*************************************************************}
{  TDiskInfo (English):                                       }
{ Component determines the information about specified local  }
{ or a network disk - Serial number, Volume label, type of    }
{ file system, type of a disk, size of free and engaged space }
{*************************************************************}
{  TDiskInfo (Russian):                                       }
{ Компонента определяет информацию об указанном локальном или }
{ сетевом диске - Серийный номер, метку тома, тип файловой    }
{ системы, тип диска, размер свободного и занятого            }
{ пространства.                                               }
{*************************************************************}
{ PROPERTIES:                                                 }
{   Disk: Char - Drive letter                                 }
{                                                             }
{ READ-ONLY PROPERTIES (results)                              }
{   SerialNumberStr: String                                   }
{   SerialNumber: LongInt                                     }
{   VolumeLabel: String                                       }
{   FileSystem: String                                        }
{   DriveType: TDriveType                                     }
{   DiskSize: LongInt                                         }
{   DiskFree: LongInt                                         }
{*************************************************************}
{ Please see demo program for more information.               }
{*************************************************************}
{                     IMPORTANT NOTE:                         }
{ This software is provided 'as-is', without any express or   }
{ implied warranty. In no event will the author be held       }
{ liable for any damages arising from the use of this         }
{ software.                                                   }
{ Permission is granted to anyone to use this software for    }
{ any purpose, including commercial applications, and to      }
{ alter it and redistribute it freely, subject to the         }
{ following restrictions:                                     }
{ 1. The origin of this software must not be misrepresented,  }
{    you must not claim that you wrote the original software. }
{    If you use this software in a product, an acknowledgment }
{    in the product documentation would be appreciated but is }
{    not required.                                            }
{ 2. Altered source versions must be plainly marked as such,  }
{    and must not be misrepresented as being the original     }
{    software.                                                }
{ 3. This notice may not be removed or altered from any       }
{    source distribution.                                     }
{*************************************************************}

unit DiskInfo;

interface

uses
  Windows, Classes, SysUtils;

type
  TDriveType = (dtUnknown, dtNoDrive, dtFloppy, dtFixed, dtNetwork, dtCDROM, dtRAM);

  TDiskInfo = class(TComponent)
  private
    FDisk: Char;
    FSerialNumberStr: String;
    FSerialNumber: LongInt;
    FVolumeLabel: String;
    FFileSystem: String;
    FDriveType: TDriveType;
    FDiskSize: LongInt;
    FDiskFree: LongInt;

    procedure SetDisk(Value: Char);
    procedure SetNothing(Value: String);
    procedure SetNothingLong(Value: LongInt);
    procedure SetNothingDT(Value: TDriveType);
  protected
  public
    constructor Create(aOwner: TComponent); override;
  published
    property Disk: Char read FDisk write SetDisk;
    property SerialNumberStr: String read FSerialNumberStr write SetNothing;
    property SerialNumber: LongInt read FSerialNumber write SetNothingLong;
    property VolumeLabel: String read FVolumeLabel write SetNothing;
    property FileSystem: String read FFileSystem write SetNothing;
    property DriveType: TDriveType read FDriveType write SetNothingDT;
    property DiskSize: LongInt read FDiskSize write SetNothingLong;
    property DiskFree: LongInt read FDiskFree write SetNothingLong;
  end;

procedure Register;

implementation

constructor TDiskInfo.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FDisk := 'C';
end;

procedure TDiskInfo.SetDisk(Value: Char);
var
  VolumeLabel, FileSystem: Array[0..$FF] of Char;
  {$IFDEF Ver120} // Delphi4 requires DWord !
  SerialNumber, Comps, SysFlags: DWord;
  {$ELSE}
  SerialNumber, Comps, SysFlags: Integer;
  {$ENDIF}

  function DecToHex(aValue: LongInt): String;
  var
    w: Array[1..2] of Word absolute aValue;

    function HexByte(b: Byte): String;
    const
     Hex: Array[$0..$F] of Char = '0123456789ABCDEF';
    begin
      HexByte := Hex[b shr 4] + Hex[b and $F];
    end;

    function HexWord(w: Word): String;
    begin
      HexWord := HexByte(Hi(w)) + HexByte(Lo(w));
    end;

  begin
    Result := HexWord(w[2]) + HexWord(w[1]);
  end;

begin
  Value := UpCase(Value);
  if (Value >= 'A') and (Value <= 'Z') then
   begin
    FDisk := Value;
    GetVolumeInformation(PChar(Value + ':\'), VolumeLabel, SizeOf(VolumeLabel),
                         @SerialNumber, Comps, SysFlags,
                         FileSystem, SizeOf(FileSystem));
    FSerialNumber := SerialNumber;
    FSerialNumberStr := DecToHex(SerialNumber);
    Insert('-', FSerialNumberStr, 5);
    FVolumeLabel := VolumeLabel;
    FFileSystem := FileSystem;
    FDriveType := TDriveType(GetDriveType(PChar(Value + ':\')));
    FDiskSize := SysUtils.DiskSize(Byte(Value) - 64);
    FDiskFree := SysUtils.DiskFree(Byte(Value) - 64);
   end
end;

procedure TDiskInfo.SetNothing(Value: String); begin {} end;
procedure TDiskInfo.SetNothingLong(Value: LongInt); begin {} end;
procedure TDiskInfo.SetNothingDT(Value: TDriveType); begin {} end;

procedure Register;
begin
  RegisterComponents('Backup', [TDiskInfo]);
end;

end.

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




unit Crc2;
interface
uses wintypes,winprocs,sysutils,classes;
{
  Author: Jeff Ewing JSEwing@compuserve.com
  this unit depends on Value OverFlow to calculate Checksums. Be sure
  to disable overflow checking  $Q- Otherwise you will have reported errors
  on iterations that overflow (alot of EM!)}

{ GIVING CREDIT WHERE ITS DUE....
 This code was adapted from C++ Source listings contained in
 PRACTICAL ALGORITHMS FOR PROGRAMMERS
 (Addison Wesley ISBN: 0-201-63208-X)
  by Andrew Binstock &  John Rex

CRC-CCITT: Used with XMODEM-CRC protocol and IBM's early SDLC/HDLC protocols.
CRC-16: Quick and Samll
CRC-32: More accurate
}

{ ******* USE THESE CALLS**********
These are the functions that you can use in YOUR code. The rest of this unit
is really an exercise in resource handling on my part. I wanted to use this unit
in main stream programs, but in the prev release all CRC data was stored in
const arrays that hung around in memory. This unit overcomes that problem by
loading the arrays at run time from resources... on demand.. and freeing them on
destroy.
 ******* USE THESE CALLS**********}
Function GetCRC32ForStr(Const Str:String):LongInt;

Function GetCRC32ForFile(Const Filename:String):LongInt;
Function GetCRC16ForFile(Const Filename:String):Word;
Function GetCCITTForFile(Const Filename:String):Word;
{ this line adds the data file rcdata.res to your project, NOTE THAT IF
 this file is not found you will not run
vvvvvvvvvvvvvvv}
{$R crcdata.res}


type TCRCType=(crcCCITT,crc16,crc32);
{ Base class for Resource loading CRCTaable class}
type CRCData=class(Tobject)
 private
   RcId:Integer;      { the integer id of the resource}
   RcSize:Word;       { The total size to alloc for storage in array }
   RcIsWord:Boolean;  { Is this resource word based on lingint based }
   RcData:Pointer;    { The actual data read from resource           }
   RcCount:Integer;   { the Array[XX] number non zero based          }
 protected
  function GetValue32(Index:Integer):LongInt;  { get a long int from array}
  function GetValue16(Index:Integer):Word;     { get a word from array }

 public
   property Values32 [index:integer]:Longint read GetValue32;
   property Values16 [index:integer]:Word read GetValue16;

   constructor create(CRCTYPE:TCrcType);virtual;
   destructor destroy;override;
end;

type TCRCCCITT=class(CRCData)
 public
   { We override this property so we can make it look like an array
     to the code}
   property Values[index:integer]:Word read GetValue16 ;default;
   constructor create;
 end;

type TCRC16=class(CRCData)
 public
   { We override this property so we can make it look like an array
    to the code}
   property Values[index:integer]:Word read GetValue16 ;default;
   constructor create;
end;

type TCRC32=class(CRCData)
 public
   { We override this property so we can make it look like an array
     to the code}
   property Values[index:integer]:LongINt read GetValue32 ;default;
   constructor create;
end;

implementation

constructor TCrc16.create;
begin
 inherited create(crc16);
end;
constructor TCrc32.create;
begin
 inherited create(crc32);
end;
constructor TCrcCCITT.create;
begin
 inherited create(crcCCITT);
end;

procedure CopyResToDst(Buff:Pointer;Size:Word;RCID:Integer);
{ This function copies a global resource memory block to a buffer pointed
 to by Buff.}
Var
 P:Pointer;
 RHandle:Thandle;
 DHandle:Thandle;
begin
 { 1st get a handle to the resource if 0 then not found. Be sure to
   add the ->$R  rcdata.res<- to your project}
 Rhandle:=FindResource(Hinstance,makeintresource(RCID),RT_RCDATA);
 if RHandle<> 0 then
 begin
  { next we have to actually load the resource (not the data.. yet.}
  Dhandle:=LoadResource(Hinstance,Rhandle);
  if Dhandle <> 0 then
   begin
     try
      { if we got it then lock (for windows to load it to a global buffer
        that will be pointed to by P}
      P:=LockResource(Dhandle);
      { yes, you could just use this global pointer as the
        buffer, but I was too lazy to do that tonight...}
      move(P^,buff^,Size);
     finally
      { since we now have a copy of it in ram let the resource go}
      FreeResource(Dhandle);
     end;
   end;
 end;
end;

constructor CRCData.create(CRCTYPE:TCrcType);
begin
 inherited create;
 RcCount:=0;
 RcData:=nil;
 RcIsWord:=True;
 RcSize:=0;

 case CRCType of
 crcCCITT: begin
             RcIsWord:=True; { Rc values array is Word sized}
             RcCount:=254;   { there are 254 items in the resource}
             RcSize:=(RcCount+1)*SizeOf(word);    { array is 0 based so add 1}
             RcId:=1;
           end;
 crc16:    begin
             RcIsWord:=True; { Rc values array is Word sized}
             RcCount:=15;   { there are 254 items in the resource}
             RcSize:=(RcCount+1)*SizeOf(word);  { array is 0 based so add 1}
             RcId:=2;
             Getmem(RcData,RcSize);
           end;
 crc32:    begin
             RcIsWord:=False; { Rc values array is Word sized}
             RcCount:=254;   { there are 254 items in the resource}
             RcSize:=(RcCount+1)*SizeOf(LongINt);  { array is 0 based so add 1}
             RcId:=3;
           end;
 else
  raise EComponentError.create('tipo de CRC desconhecido!');
 end;

 Getmem(RcData,RcSize);
 CopyResToDst(RcData,RcSize,RCID);
end;

destructor CRCData.destroy;
begin
 if RcData<> nil then
   begin
     if RcIsWord then
        Freemem(RcData,(RcCount+1)* SizeOf(word))
     else
        Freemem(RcData,(RcCount+1)* SizeOf(LongINt));
   end;
 inherited destroy;
end;

function CRCData.GetValue32(Index:Integer):LongInt;
type AlArray=array[0..255] of LongInt;
begin
 result:=0;
 if RcisWord then exit; { avoid returning bogus data}
 if ((Index > -1) and (Index < RcCount+1)) then
  begin
    Result:= AlArray(RcData^)[Index];
  end
 else
  { didnt raise here since its called so many times}
  result:=0;

end;
function CRCData.GetValue16(Index:Integer):Word;
type AWArray=array[0..255] of Word;
begin
 Result:=0;
 if Not RcisWord then exit; { avoid returning bogus data}
 if ((Index > -1) and (Index < RcCount+1)) then
  begin
    Result:= AWArray(RcData^)[Index];
  end
 else
  { didnt raise here since its called so many times}
  result:=0;
end;


{//////////////////////////////////////////////////////////////////////////////}
Function GetCCITTForFile(Const Filename:String):Word;
Const ReadBufSize=32766;
Var
 CCItTable:TCRCCCitt;
 F:TfileStream;
 Buff:Pointer;
 Bread:Word;
{//////////////////////////////////////////////////////////////////////////////}
Function CalculateCCIT(Start:Integer;const Buff:Pchar;BuffSz:Integer):Word;
Var
Count:Integer;
Total:Word;
R1:Integer;
begin
{ Start : Starting CRC value should be 0 if this is the first pass
 OR if a multip-pass calculation the last result from this function.
 Buff   : The buffer to Calculate the CRC for.
 Buffsz : The size of the buffer;
 }
 Count:=-1;
 Total:=Start;
 while Count < BuffSz do
 begin
  { Advance to Next Byte}
  Inc(Count);
  Total:= (Total SHL 8) XOR CCitTable[Total SHR 8] XOR ORD(buff[Count]);
 End;
 Result:=Total;
End;
{//////////////////////////////////////////////////////////////////////////////}
 begin
  if Not(FileExists(Filename)) then
     Raise EFOpenError.Create('Não posso abrit o arquivo: '+Filename);
   CCitTable:=TCRCCCitt.Create;
   GetMem(Buff,ReadBufSize);
   Try
     F:=TfileStream.Create(Filename,0);
       Try
         Result:=$0;
         repeat
          Bread:=F.REad(Buff^,ReadBufSize);
          If Bread > 0 then
          Result:=CalculateCCIT(Result,Pchar(Buff),Bread);
         Until Bread < ReadBufSize;
       finally
         F.Free;
       End;
   Finally
      CCitTable.Free;
      FreeMem(Buff,ReadBufSize);
   End;
End;
{//////////////////////////////////////////////////////////////////////////////}

{//////////////////////////////////////////////////////////////////////////////}
Function GetCRC16ForFile(Const Filename:String):Word;
Const ReadBufSize=32766;
Var
 Crc16Table:TCRC16;
 F:TfileStream;
 Buff:Pointer;
 Bread:Word;
 {//////////////////////////////////////////////////////////////////////////////}
Function CalculateCRC16(Start:Integer;const Buff:Pchar;BuffSz:Integer):Word;
Var
Count:Integer;
Total:Word;
R1:Integer;
begin
{ Start : Starting CRC value should be 0 if this is the first pass
 OR if a multip-pass calculation the last result from this function.
 Buff   : The buffer to Calculate the CRC for.
 Buffsz : The size of the buffer;
 }
 Count:=-1;
 Total:=Start;
 while Count < BuffSz do
 begin
  { Advance to Next Byte}
  Inc(Count);

  { Do the lower 4 bits}
  R1:=Crc16Table[Total AND $0f];
  Total:=(Total SHR 4) AND $0FFF;
  Total:=Total XOR r1 XOR Crc16Table[ORD(Buff[Count]) AND $F];
  { Do th upper 4 Bits}
  r1:=Crc16Table[Total AND $0f];
  Total:=(total SHR 4) AND $0FFF;
  Total:=Total XOR r1 XOR Crc16Table[((ORD(Buff[Count])SHR 4) AND $F)];
 End;
 Result:=Total;
End;
{//////////////////////////////////////////////////////////////////////////////}
begin
  if Not(FileExists(Filename)) then
   Raise EFOpenError.Create('Não posso abrit o arquivo: '+Filename);
   Crc16Table:=TCRC16.Create;
   GetMem(Buff,ReadBufSize);
  try
    F:=TfileStream.Create(Filename,0);
    Try
      Result:=$0;
      repeat
        Bread:=F.REad(Buff^,ReadBufSize);
        If Bread > 0 then
        Result:=CalculateCRC16(REsult,Pchar(Buff),Bread);
      Until Bread < ReadBufSize;
    finally
     F.Free;
    End;
  Finally
   Crc16Table.Free;
   FreeMem(Buff,ReadBufSize);
  End;
End;
{//////////////////////////////////////////////////////////////////////////////}

{//////////////////////////////////////////////////////////////////////////////}
Function GetCRC32ForFile(Const Filename:String):LongInt;
Const ReadBufSize=32766;
Var
 Crc32Table:TCRC32;
 F:TfileStream;
 Buff:Pointer;
 Bread:LongINt;
{//////////////////////////////////////////////////////////////////////////////}
Function CalculateCRC32(Start:LongInt;const Buff:Pchar;BuffSz:Integer):LongInt;
var
 T1,R1:LongInt;
 Count:Integer;
 Loop:Integer;
Begin
{ Start : Starting CRC value should be $FFFFFFFF if this is the first pass
 OR if a multip-pass calculation the last result from this function.
 Buff   : The buffer to Calculate the CRC for.
 Buffsz : The size of the buffer;
 }

 R1:=Start;
 For Count:=0 to BuffSz-1 do
  begin
   T1:=(R1 XOR ORD(buff[Count])) AND $000000FF;
   r1:=((R1 SHR 8) AND $00FFFFFF) XOR Crc32Table[T1];
 End;
 Result:=R1;
End;
{//////////////////////////////////////////////////////////////////////////////}
 begin
  if Not(FileExists(Filename)) then
   Raise EFOpenError.Create('Não posso abrit o arquivo: '+Filename);
   GetMem(Buff,ReadBufSize);
   Crc32Table:=TCRC32.create;
   try
    F:=TfileStream.Create(Filename,0);
    Try
      { Pre-Condition the CRC to Trap Dup leading 0 values on
       buffer (if needed)}
      Result:=$FFFFFFFF;
      repeat
        Bread:=F.REad(Buff^,ReadBufSize);
        If Bread > 0 then
        Result:=CalculateCRC32(REsult,Pchar(Buff),Bread);
      Until Bread < ReadBufSize;
      { Post condition the buffer INVERT bits of the CRC}
      Result:=NOT(Result);
    finally
     F.Free;
    End;
  Finally
   CRC32Table.Free;
   FreeMem(Buff,ReadBufSize);
  End;
End;
{//////////////////////////////////////////////////////////////////////////////}

{//////////////////////////////////////////////////////////////////////////////}

{//////////////////////////////////////////////////////////////////////////////}
Function GetCRC32ForStr(Const Str:String):LongInt;
//Const ReadBufSize=32766;
Var
 Crc32Table:TCRC32;
// F:TfileStream;
// Buff:Pointer;
 Bread:LongINt;
{//////////////////////////////////////////////////////////////////////////////}
Function CalculateCRC32(Start:LongInt;const Buff:Pchar;BuffSz:Integer):LongInt;
var
 T1,R1:LongInt;
 Count:Integer;
 Loop:Integer;
Begin
{ Start : Starting CRC value should be $FFFFFFFF if this is the first pass
 OR if a multip-pass calculation the last result from this function.
 Buff   : The buffer to Calculate the CRC for.
 Buffsz : The size of the buffer;
 }

 R1:=Start;
 For Count:=0 to BuffSz-1 do
  begin
   T1:=(R1 XOR ORD(buff[Count])) AND $000000FF;
   r1:=((R1 SHR 8) AND $00FFFFFF) XOR Crc32Table[T1];
 End;
 Result:=R1;
End;
{//////////////////////////////////////////////////////////////////////////////}
 begin
//  if Not(FileExists(Filename)) then
//   Raise EFOpenError.Create('Não posso abrir o arquivo: '+Filename);
//   GetMem(Buff,ReadBufSize);
   Crc32Table:=TCRC32.create;
   try
//    F:=TfileStream.Create(Filename,0);
//    Try
      { Pre-Condition the CRC to Trap Dup leading 0 values on
       buffer (if needed)}
      Result:=$FFFFFFFF;
//      repeat
        Bread:=Length(Str);
        If Bread > 0 then
        Result:=CalculateCRC32(REsult,Pchar(Str),Bread);
//      Until Bread < ReadBufSize;
      { Post condition the buffer INVERT bits of the CRC}
      Result:=NOT(Result);
//    finally
//     F.Free;
//    End;
  Finally
   CRC32Table.Free;
//   FreeMem(Buff,ReadBufSize);
  End;
End;
{//////////////////////////////////////////////////////////////////////////////}





end.

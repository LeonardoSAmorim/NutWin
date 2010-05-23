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




unit Person;

interface

uses
  Windows, SysUtils, Classes, RegEdit, RegConst2, Crc2;

const
   HD_INVALIDO        = 'HD inválido. Impossível recuperar personalização.';
   SERIAL_INVALIDO    = 'Serial inválido. Impossível recuperar personalização.';
   ARQUIVO_DANIFICADO = 'Arquivo danificado. Impossível recuperar personalização.';

type
   TEncryptOutput = ( cyChar, cyHexa, cyDecimal );

   function Encrypt(S : String; SeedVal : Integer; OutPut : TEncryptOutput) : String;
   function SeedSerial( S : String ) : LongInt;
   function SerialSemVersao( S : String ) : String;
   function MyRandom( Limite : longInt ) : longInt;
   function SerialNumber(FDrive:String) :String;
   function LoadPersona(FileName: String; P : TStringList; Serial : String; Desenv : Boolean=False): Integer;
   function Ancorar(FileName: String; Serial : String): Boolean;
   function PersonaFileName( Serial : String ) : String;   overload;
      function PersonaFileName(  ) : String;   overload;
var
   MyRandSeed : longInt;

implementation

function SerialNumber(FDrive:String) :String;
var
  Serial:DWord;
  DirLen,Flags: DWord;
  DLabel : Array[0..11] of Char;
begin
  Try
    GetVolumeInformation(PChar(FDrive+':\'),dLabel,12,@Serial,DirLen,Flags,nil,0);
    Result := IntToHex(Serial,8);
  Except
    Result :='';
  end;
end;

function Encrypt(S : String; SeedVal : Integer; OutPut : TEncryptOutput) : String;
var
    i, k : integer;
    j : Byte;
begin
     { Seed our generator to give an infininte key }
     Result := '';
     if S = ''then
        exit;
     k := 0;
     MyRandSeed := ( seedval );
     for i :=1 to Length( S ) do
     begin
       if Output = cyChar then
          Result := Result + chr(ord(S[i]) XOR MyRandom(256))
       else if Output = cyHexa then
          Result := Result + IntToHex((ord(S[i]) XOR MyRandom(256)), 2)
       else if ( Output = cyDecimal ) and ( i <= (Length(S) div 2) ) then
         begin
          j := StrToInt( '$' + S[i+k]+S[i+k+1]);
          inc(K);
          Result := Result + chr(j XOR MyRandom(256));
         end;
     end;
end;

function SerialSemVersao( S : String ) : String;
var
   cont, num, i, j, v, numant : Integer;
   prod : Int64;
   Serial, Edit2, Edit3, Edit6 : String;
begin
   if Length(S) < 16 then
   begin
      Result := '';
      exit;
   end
   else
      Serial := S[2] + S[4] + S[10] + S[12] + S[14] + S[16];
   prod := 1;
   for cont := 1 to Length(Serial) do
      prod := prod*Ord(Serial[cont]);
   i := 2;
   j := 3;
   v := 5;
   Edit2 := '';
   Edit3 := '';
   Edit6 := '';
   for cont := 1 to Length(Serial) do
   begin
      num := 256-cont-Ord(Serial[cont]);
      numant := num;
      while (chr(num) < '0') or ((chr(num) > '9') and (chr(num) < 'A')) or (chr(num) > 'Z') do
      begin
         if chr(num) < '0' then
            i := i+1;
         if (chr(num) > '9') and (chr(num) < 'A') then
            j := j+1;
         if chr(num) > 'Z' then
            v := v+1;
         num := num-(prod mod (i*j*v));
         if num < 0 then
            num := num*-1;
         if num = numant then
            num := num-1;
      end;
      while num > 255 do
         num := num-256;
      Edit2 := Edit2 + chr(num);
      Edit3 := Edit3 + IntToStr(num) + ' ';
      Edit6 := Edit6 + Edit2[cont] + Serial[cont];
   end;
   Result := Edit6 ;
end;

function SeedSerial( S : String ) : LongInt;
var
   i : Integer;
begin
   S := SerialSemVersao(S);
   Result := 0 ;
   for i := 1 to Length( S ) do
   begin
      Result :=  Result + ( ord(S[i]) * i );
   end;
end;

function MyRandom(Limite: Integer): longInt;
begin
   Result := ( MyRandSeed mod Limite );
end;

function LoadPersona(FileName: String; P : TStringList; Serial : String; Desenv : Boolean=False): Integer;
var
   Drive, Texto : String;
   Persona : TStringList;
   i : Integer;
begin
     Persona := TStringList.Create;
     Persona.Add('Universidade Federal de São Paulo'); // cabec_1
     Persona.Add('Campus São José dos Campos');        // cabec_2
     Persona.Add('Prof. Dr. Meide Silva Anção');       // cabec_3
     Persona.Add('');                                  // rodap_1
     Persona.Add('');                                  // rodap_2
     Persona.Add('');                                  // fExpira
     Persona.Add('');                                  // validade
     Persona.Add('');                                  // serial
     Persona.Add('');                                  // ancora
     Persona.Add('');                                  // nr licenca
     Persona.Add('');                                  // crc


     P.Clear;
     P.LoadFromFile( FileName );
     for i := P.Count to 10 do
         p.Add(Persona.Strings[i]);

     result := 0;
end;

function Ancorar(FileName: String; Serial : String): Boolean;
var
   Drive, Texto : String;
   i : Integer;
   P : TStringList;
begin
   Result := False;
   P := TStringList.Create;
   try
      P.LoadFromFile( FileName );
      Drive := ExtractFileDrive(FileName);
      P.Strings[8] := Encrypt(SerialNumber(Drive[1]), SeedSerial(Serial), cyHexa);
      Texto := '';
      for i := 0 to P.Count - 2 do
         Texto := Texto + P.Strings[i];
      P.Strings[10] := (IntToHex(GetCRC32ForStr(Texto),8));
      P.SaveToFile( FileName );
      Result := True;
   finally
      P.Free;
   end;
end;

function PersonaFileName( Serial : String ) : String; overload;
var
   NumVer : Integer;
begin
   Result := '';
   if Length( Serial ) = 16 then
   begin
      Result := 'Persona';
      NumVer := StrToInt( Serial[10] + Serial[12] + Serial[14] + Serial[16] );
      if NumVer > 0 then
         Result := Result + Trim(IntToStr( NumVer ));
   end
end;

function PersonaFileName( ) : String; overload;
var
   NumVer : Integer;
begin
      Result := 'Persona';
end;


end.

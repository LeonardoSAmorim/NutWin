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




{*******************************************************}
{                                                       }
{       Componentes de apoio                            }
{                                                       }
{       Copyright © 2000 by DIS-EPM/UNIFESP             }
{                                                       }
{*******************************************************}

unit xmlclasses;

interface

uses SysUtils, Classes, Consts;

type

  TFiler = class(Classes.TFiler);
  TWriter = class(Classes.TWriter);
  TReader = class(Classes.TReader)
  private
     procedure CheckValue(Value: TValueType);
     procedure SkipValue;
     procedure SkipProperty;
     procedure SkipSetBody;
  end;

  { Object conversion routines }
  procedure PropValueError;
  procedure XMLObjectBinaryToText(Input, Output: TStream;DocType : string; StyleSheet : string);
  procedure XMLObjectTextToBinary(Input, Output: TStream);
  function XMLComponentToString(Component: TComponent;DocType : string; StyleSheet : string): string;
  function XMLStringToComponent(Value: string;Componente:TComponent): TComponent;
  procedure ConvertStr2Entities(var S : String );
  procedure ConvertEntities2Str(var S : String );
  procedure ConvertWStr2Entities(var WS : WideString );
  procedure ConvertEntities2WStr(var WS : WideString );

  // Funcao auxiliar
  function ConverteFileNameExtTo(const FileName, Ext : String) : String;

implementation

function XMLComponentToString(Component: TComponent;DocType : string; StyleSheet : string): string;
var
  BinStream :TMemoryStream;
  StrStream : TStringStream;
  s : string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      XMLObjectBinaryToText(BinStream, StrStream, DocType, StyleSheet);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

function XMLStringToComponent(Value: string;Componente:TComponent): TComponent;
var
  StrStream :TStringStream;
  BinStream : TMemoryStream;
  BgnIdx : Integer;
begin
  if Value = '' then
     begin
        Result := nil;
        exit;
     end;
  BgnIdx := Pos('<', Value);
  while (Value[BgnIdx+1] = '!') or (Value[BgnIdx+1] = '?') do
     begin
        Inc(BgnIdx);
        while (Value[BgnIdx] <> '<') do
           Inc(BgnIdx);
     end;
  if BgnIdx > 0 then
     begin
        Value := Copy (Value, BgnIdx, Length(Value)-BgnIdx);
        StrStream := TStringStream.Create(Value);
        try
           BinStream := TMemoryStream.Create;
           try
              XMLObjectTextToBinary(StrStream, BinStream);
              BinStream.Seek(0, soFromBeginning);
              Result := BinStream.ReadComponent(Componente);
           finally
              BinStream.Free;
           end;
        finally
           StrStream.Free;
        end;
     end
  else
     begin
        StrStream := TStringStream.Create(Value);
        try
           BinStream := TMemoryStream.Create;
           try
              ObjectTextToBinary(StrStream, BinStream);
              BinStream.Seek(0, soFromBeginning);
              Result := BinStream.ReadComponent(Componente);
           finally
              BinStream.Free;
           end;
        finally
           StrStream.Free;
        end;
     end;
end;

{ Binary to text conversion }

procedure XMLObjectBinaryToText(Input, Output: TStream;DocType : string; StyleSheet : string);
var
  NestingLevel : Integer;
  SaveSeparator : Char;
  Reader : TReader;
  Writer : TWriter;
  ClassName, ObjectName : string;

  procedure WriteIndent;
  const
    Blanks: array[0..1] of Char = '  ';
  var
    I : Integer;
  begin
    for I := 1 to NestingLevel do Writer.Write(Blanks, SizeOf(Blanks));
  end;

  procedure WriteStr(const S: string);
  begin
    Writer.Write(S[1], Length(S));
  end;

  procedure NewLine;
  begin
    WriteStr(#13#10);
    WriteIndent;
  end;

  procedure ConvertValue; forward;

  function ConvertHeader : String;
  var
    XMLTag : String;
    Flags : TFilerFlags;
    Position : Integer;
  begin
    Reader.ReadPrefix(Flags, Position);
    ClassName := Reader.ReadStr;
    ObjectName := Reader.ReadStr;
    WriteIndent;
    if ffInherited in Flags then
      begin
        XMLTag := 'inherited.';
        WriteStr('<inherited.');
      end
    else
      begin
        XMLTag := '';
        WriteStr('<' + ClassName);
      end;
    XMLTag := XMLTag + ClassName;
    if ffChildPos in Flags then
    begin
      WriteStr(' Position = "');
      WriteStr('[');
      WriteStr(IntToStr(Position));
      WriteStr(']');
      WriteStr('"');
    end;
    WriteStr(#13#10);
    Result := XMLTag;
  end;

  procedure ConvertBinary;
  const
    BytesPerLine = 32;
  var
    MultiLine: Boolean;
    I: Integer;
    Count: Longint;
    Buffer: array[0..BytesPerLine - 1] of Char;
    Text: array[0..BytesPerLine * 2 - 1] of Char;
  begin
    Reader.ReadValue;
    WriteStr('{');
    Inc(NestingLevel);
    Reader.Read(Count, SizeOf(Count));
    MultiLine := Count >= BytesPerLine;
    while Count > 0 do
    begin
      if MultiLine then NewLine;
      if Count >= 32 then I := 32 else I := Count;
      Reader.Read(Buffer, I);
      BinToHex(Buffer, Text, I);
      Writer.Write(Text, I * 2);
      Dec(Count, I);
    end;
    Dec(NestingLevel);
    WriteStr('}');
  end;

  procedure ConvertProperty; forward;

  procedure ConvertValue;
  const
    LineLength = 64;
  var
    I, J, K, L: Integer;
    S: string;
    W: WideString;
    LineBreak: Boolean;
  begin
    case Reader.NextValue of
      vaList:
        begin
          Reader.ReadValue;
          WriteStr('(');
          Inc(NestingLevel);
          while not Reader.EndOfList do
          begin
            NewLine;
            ConvertValue;
          end;
          Reader.ReadListEnd;
          Dec(NestingLevel);
          WriteStr(')');
        end;
      vaInt8, vaInt16, vaInt32:
        WriteStr(IntToStr(Reader.ReadInteger));
      vaExtended:
        WriteStr(FloatToStr(Reader.ReadFloat));
      vaSingle:
        WriteStr(FloatToStr(Reader.ReadSingle) + 's');
      vaCurrency:
        WriteStr(FloatToStr(Reader.ReadCurrency * 10000) + 'c');
      vaDate:
        WriteStr(FloatToStr(Reader.ReadDate) + 'd');
      vaWString:
        begin
          W := Reader.ReadWideString;
          // Converte Str para Entidades
          ConvertWStr2Entities(W);
          L := Length(W);
          if L = 0 then WriteStr('''''') else
          begin
            I := 1;
            Inc(NestingLevel);
            try
              if L > LineLength then NewLine;
              K := I;
              repeat
                LineBreak := False;
                if (W[I] >= ' ') and (W[I] <> '''') and (Ord(W[i]) <= 255) then
                begin
                  J := I;
                  repeat
                    Inc(I)
                  until (I > L) or (W[I] < ' ') or (W[I] = '''') or
                    ((I - K) >= LineLength) or (Ord(W[i]) > 255);
                  if ((I - K) >= LineLength) then
                  begin
                    LineBreak := True;
                    if ByteType(W, I) = mbTrailByte then Dec(I);
                  end;
                  WriteStr('''');
                  while J < I do
                  begin
                    WriteStr( Char(W[J]) );
                    Inc(J);
                  end;
                  WriteStr('''');
                end else
                begin
                  WriteStr('#');
                  WriteStr(IntToStr(Ord(W[I])));
                  Inc(I);
                  if ((I - K) >= LineLength) then LineBreak := True;
                end;
                if LineBreak and (I <= L) then
                begin
                  WriteStr(' +'); // wgb - não preciso disso
                  NewLine;
                  K := I;
                end;
              until I > L;
            finally
              Dec(NestingLevel);
            end;
          end;
        end;
      vaString, vaLString:
        begin
          S := Reader.ReadString;
          // Converte Str para Entidades
          ConvertStr2Entities(S);
          L := Length(S);
          if L = 0 then WriteStr('''''') else
          begin
            I := 1;
            Inc(NestingLevel);
            try
              if L > LineLength then NewLine;
              K := I;
              repeat
                LineBreak := False;
                if (S[I] >= ' ') and (S[I] <> '''') then
                begin
                  J := I;
                  repeat
                    Inc(I)
                  until (I > L) or (S[I] < ' ') or (S[I] = '''') or
                    ((I - K) >= LineLength);
                  if ((I - K) >= LineLength) then
                  begin
                    LIneBreak := True;
                    if ByteType(S, I) = mbTrailByte then Dec(I);
                  end;
                  WriteStr('''');
                  Writer.Write(S[J], I - J);
                  WriteStr('''');
                end else
                begin
                  WriteStr('#');
                  WriteStr(IntToStr(Ord(S[I])));
                  Inc(I);
                  if ((I - K) >= LineLength) then LineBreak := True;
                end;
                if LineBreak and (I <= L) then
                begin
                  WriteStr(' +');  // wgb - não preciso disto
                  NewLine;
                  K := I;
                end;
              until I > L;
            finally
              Dec(NestingLevel);
            end;
          end;
        end;
      vaIdent, vaFalse, vaTrue, vaNil, vaNull:
        WriteStr(Reader.ReadIdent);
      vaBinary:
        ConvertBinary;
      vaSet:
        begin
          Reader.ReadValue;
          WriteStr('[');
          I := 0;
          while True do
          begin
            S := Reader.ReadStr;
            if S = '' then Break;
            if I > 0 then WriteStr(', ');
            WriteStr(S);
            Inc(I);
          end;
          WriteStr(']');
        end;
      vaCollection:
        begin
          Reader.ReadValue;
          WriteStr('<');
          Inc(NestingLevel);
          while not Reader.EndOfList do
          begin
            NewLine;
            WriteStr('item');
            if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then
            begin
              WriteStr(' [');
              ConvertValue;
              WriteStr(']');
            end;
            WriteStr(#13#10);
            Reader.CheckValue(vaList);
            Inc(NestingLevel);
            while not Reader.EndOfList do ConvertProperty;
            Reader.ReadListEnd;
            Dec(NestingLevel);
            WriteIndent;
            WriteStr('end');
          end;
          Reader.ReadListEnd;
          Dec(NestingLevel);
          WriteStr('>');
        end;
    end;
  end;

  procedure ConvertProperty;
  begin
    WriteIndent;
    WriteStr(Reader.ReadStr);
    WriteStr(' = "');
    ConvertValue;
    WriteStr('"');
  end;

  procedure ConvertObject;
  var
     XMLTag : String;
  begin
    XMLTag := ConvertHeader;
    Inc(NestingLevel);
    while not Reader.EndOfList do
          begin
          ConvertProperty;
          if not Reader.EndOfList then
             WriteStr (#13#10)
          end;
    WriteStr('>'+#13#10);
    Reader.ReadListEnd;

    WriteStr('<ObjectName>'+ObjectName + '</ObjectName>'+#13#10);

    while not Reader.EndOfList do ConvertObject;
    Reader.ReadListEnd;
    Dec(NestingLevel);
    WriteIndent;
    WriteStr('</'+XMLTag+'>' + #13#10);
  end;

begin
  NestingLevel := 0;
  Reader := TReader.Create(Input, 4096);
  SaveSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Writer := TWriter.Create(Output, 4096);
    try
      Reader.ReadSignature;

      WriteStr( '<?xml version = "1.0" encoding = "ISO-8859-1"?>' + #13#10 + DocType + #13#10 + StyleSheet + #13#10 );

      ConvertObject;
    finally
      Writer.Free;
    end;
  finally
    DecimalSeparator := SaveSeparator;
    Reader.Free;
  end;
end;

{ Text to binary conversion }

procedure XMLObjectTextToBinary(Input, Output: TStream);
var
  SaveSeparator: Char;
  Parser: TParser;
  Writer: TWriter;

  function ConvertOrderModifier: Integer;
  begin
    Result := -1;
    if Parser.TokenString = 'Position' then
    begin
    Parser.NextToken; //Toma conta do =
    Parser.NextToken; //Toma conta das aspas
    Parser.NextToken;
      if Parser.Token = '[' then
      begin
        Parser.NextToken;
        Parser.CheckToken(toInteger);
        Result := Parser.TokenInt;
        Parser.NextToken;
        Parser.CheckToken(']');
        Parser.NextToken;
      end;
      Parser.NextToken; //Toma conta das aspas
    end;
  end;


  function FindObjectName (SearchStr : string) : string;
  var
  BgnPos, I : integer;
  begin
    BgnPos := Pos ('<ObjectName>',SearchStr)+ Length ('<ObjectName>');
    Result:='';
    I:=BgnPos;
    while SearchStr[I] <> '<' do Inc(I);
    Result:= Copy (SearchStr,BgnPos,I-BgnPos);
  end;

  procedure ConvertHeader(IsInherited: Boolean);
  var
    ClassName, ObjectName: string;
    Flags: TFilerFlags;
    Position: Integer;
    StreamPos : Integer;
  begin
    Parser.CheckToken(toSymbol);
    ClassName := Parser.TokenString;
    Parser.NextToken;
    StreamPos:=Parser.SourcePos;
    ObjectName:= FindObjectName (copy(TStringStream(Input).DataString,StreamPos,TStringStream(Input).Size-StreamPos));
    Flags := [];
    Position := ConvertOrderModifier;
    if IsInherited then
      Include(Flags, ffInherited);
    if Position >= 0 then
      Include(Flags, ffChildPos);
    Writer.WritePrefix(Flags, Position);
    Writer.WriteStr(ClassName);
    Writer.WriteStr(ObjectName);
  end;

  procedure ConvertProperty; forward;

  procedure ConvertValue;
  var
    Order: Integer;

    function CombineString: string;
    begin
      Result := Parser.TokenString;
      while Parser.NextToken = '+' do
      begin
        Parser.NextToken;
        Parser.CheckToken(toString);
        Result := Result + Parser.TokenString;
      end;
      // Converte Entidades em Str
      ConvertEntities2Str(Result);
    end;

    function CombineWideString: WideString;
    begin
      Result := Parser.TokenWideString;
      while Parser.NextToken = '+' do
      begin
        Parser.NextToken;
        Parser.CheckToken(toWString);
        Result := Result + Parser.TokenWideString;
      end;
      // Converte Entidades em Entidades
      ConvertEntities2WStr(Result);
    end;

  begin
    if Parser.Token = toString then
      Writer.WriteString(CombineString)
    else if Parser.Token = toWString then
      Writer.WriteWideString(CombineWideString)
    else
    begin
      case Parser.Token of
        toSymbol:
          Writer.WriteIdent(Parser.TokenComponentIdent);
        toInteger:
          Writer.WriteInteger(Parser.TokenInt);
        toFloat:
          begin
            case Parser.FloatType of
              's', 'S': Writer.WriteSingle(Parser.TokenFloat);
              'c', 'C': Writer.WriteCurrency(Parser.TokenFloat / 10000);
              'd', 'D': Writer.WriteDate(Parser.TokenFloat);
            else
              Writer.WriteFloat(Parser.TokenFloat);
            end;
          end;
        '[':
          begin
            Parser.NextToken;
            Writer.WriteValue(vaSet);
            if Parser.Token <> ']' then
              while True do
              begin
                Parser.CheckToken(toSymbol);
                Writer.WriteStr(Parser.TokenString);
                if Parser.NextToken = ']' then Break;
                Parser.CheckToken(',');
                Parser.NextToken;
              end;
            Writer.WriteStr('');
          end;
        '(':
          begin
            Parser.NextToken;
            Writer.WriteListBegin;
            while Parser.Token <> ')' do ConvertValue;
            Writer.WriteListEnd;
          end;
        '{':
          Writer.WriteBinary(Parser.HexToBinary);
        '<':
          begin
            Parser.NextToken;
            Writer.WriteValue(vaCollection);
            while Parser.Token <> '>' do
            begin
              Parser.CheckTokenSymbol('item');
              Parser.NextToken;
              Order := ConvertOrderModifier;
              if Order <> -1 then Writer.WriteInteger(Order);
              Writer.WriteListBegin;
              while not Parser.TokenSymbolIs('end') do ConvertProperty;
              Writer.WriteListEnd;
              Parser.NextToken;
            end;
            Writer.WriteListEnd;
          end;
      else
        Parser.Error(SInvalidProperty);
      end;
      Parser.NextToken;
    end;
  end;

  procedure ConvertProperty;
  var
    PropName: string;
  begin
    Parser.CheckToken(toSymbol);
    PropName := Parser.TokenString;
    Parser.NextToken;
    while Parser.Token = '.' do
    begin
      Parser.NextToken;
      Parser.CheckToken(toSymbol);
      PropName := PropName + '.' + Parser.TokenString;
      Parser.NextToken;
    end;
    Writer.WriteStr(PropName);
    Parser.CheckToken('=');
    Parser.NextToken;
    Parser.NextToken; // Toma conta das aspas '"'
    ConvertValue;
    Parser.NextToken; // Toma conta das aspas '"'
  end;

  procedure ConvertObject;
  var
    InheritedObject: Boolean;
  begin
    InheritedObject := False;
    while Parser.TokenString <> '<' do
       Parser.NextToken;
    Parser.NextToken;
    if Parser.TokenString = '/' then
       exit;
    if Parser.TokenSymbolIs('INHERITED') then
      InheritedObject := True else
    //Pula <ObjectName>XXX</ObjectName>
    if Parser.TokenString = 'ObjectName' then
       begin
       Parser.NextToken;
       while Parser.TokenString <> 'ObjectName' do
             Parser.NextToken;
       Parser.NextToken;
       exit;
       end;
//    else
//      Parser.CheckTokenSymbol('OBJECT');
//    Parser.NextToken;
//    Parser.NextToken; // Toma conta do '.'
    ConvertHeader(InheritedObject);
    while (Parser.TokenString <> '>') do
          ConvertProperty;

    Writer.WriteListEnd;
    while Parser.TokenString <> '/' do
        ConvertObject;
    Writer.WriteListEnd;
    while Parser.TokenString <> '>' do
       Parser.NextToken;
  end;

begin
  Parser := TParser.Create(Input);
  SaveSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Writer := TWriter.Create(Output, 4096);
    try
      Writer.WriteSignature;
      ConvertObject;
    finally
      Writer.Free;
    end;
  finally
    DecimalSeparator := SaveSeparator;
    Parser.Free;
  end;
end;

procedure TReader.CheckValue(Value: TValueType);
begin
inherited;
end;

procedure TReader.SkipValue;

  procedure SkipList;
  begin
    while not EndOfList do SkipValue;
    ReadListEnd;
  end;

  procedure SkipBytes(Count: Longint);
  var
    Bytes: array[0..255] of Char;
  begin
    while Count > 0 do
      if Count > SizeOf(Bytes) then
      begin
        Read(Bytes, SizeOf(Bytes));
        Dec(Count, SizeOf(Bytes));
      end
      else
      begin
        Read(Bytes, Count);
        Count := 0;
      end;
  end;

  procedure SkipBinary;
  var
    Count: Longint;
  begin
    Read(Count, SizeOf(Count));
    SkipBytes(Count);
  end;

  procedure SkipCollection;
  begin
    while not EndOfList do
    begin
      if NextValue in [vaInt8, vaInt16, vaInt32] then SkipValue;
      SkipBytes(1);
      while not EndOfList do SkipProperty;
      ReadListEnd;
    end;
    ReadListEnd;
  end;

begin
  case ReadValue of
    vaNull: begin end;
    vaList: SkipList;
    vaInt8: SkipBytes(1);
    vaInt16: SkipBytes(2);
    vaInt32: SkipBytes(4);
    vaExtended: SkipBytes(SizeOf(Extended));
    vaString, vaIdent: ReadStr;
    vaFalse, vaTrue: begin end;
    vaBinary: SkipBinary;
    vaSet: SkipSetBody;
    vaCollection: SkipCollection;
  end;
end;

procedure TReader.SkipProperty;
begin
  ReadStr; { Skips property name }
  SkipValue;
end;

procedure TReader.SkipSetBody;
begin
  while ReadStr <> '' do begin end;
end;

procedure ReadError(const Ident: string);
begin
  raise EReadError.Create(Ident);
end;

procedure PropValueError;
begin
  ReadError(SInvalidPropertyValue);
end;

function ConverteFileNameExtTo(const FileName, Ext : String) : String;
begin
   if Pos('.', FileName) = 0 then
      Result := FileName + '.' + Ext
   else
      Result := Copy ( FileName, 1, Pos('.', FileName) ) + Ext;
end;

procedure ConvertStr2Entities(var S : String );
begin
   // tem que ser o primeiro
   S := StringReplace( S, '&', '&amp;', [rfReplaceAll] );

   S := StringReplace( S, '<', '&lt;', [rfReplaceAll] );
   S := StringReplace( S, '>', '&gt;', [rfReplaceAll] );
   S := StringReplace( S, '"', '&quote;', [rfReplaceAll] );
   S := StringReplace( S, '''', '&apos;', [rfReplaceAll] );
   S := StringReplace( S, '®', '&copy;', [rfReplaceAll] );
end;

procedure ConvertEntities2Str(var S : String );
begin
   S := StringReplace( S, '&lt;', '<', [rfReplaceAll] );
   S := StringReplace( S, '&gt;', '>',  [rfReplaceAll] );
   S := StringReplace( S, '&quote;', '"', [rfReplaceAll] );
   S := StringReplace( S, '&apos;', '''', [rfReplaceAll] );
   S := StringReplace( S, '&copy;', '®', [rfReplaceAll] );

   // tem que ser o último
   S := StringReplace( S, '&amp;', '&', [rfReplaceAll] );
end;

procedure ConvertWStr2Entities(var WS : WideString );
begin
   // tem que ser o primeiro
   WS := StringReplace( WS, '&', '&amp;', [rfReplaceAll] );

   WS := StringReplace( WS, '<', '&lt;', [rfReplaceAll] );
   WS := StringReplace( WS, '>', '&gt;', [rfReplaceAll] );
   WS := StringReplace( WS, '"', '&quote;', [rfReplaceAll] );
   WS := StringReplace( WS, '''', '&apos;', [rfReplaceAll] );
   WS := StringReplace( WS, '®', '&copy;', [rfReplaceAll] );

end;

procedure ConvertEntities2WStr(var WS : WideString );
begin
   WS := StringReplace( WS, '&lt;', '<', [rfReplaceAll] );
   WS := StringReplace( WS, '&gt;', '>',  [rfReplaceAll] );
   WS := StringReplace( WS, '&quote;', '"', [rfReplaceAll] );
   WS := StringReplace( WS, '&apos;', '''', [rfReplaceAll] );
   WS := StringReplace( WS, '&copy;', '®', [rfReplaceAll] );

   // tem que ser o último
   WS := StringReplace( WS, '&amp;', '&', [rfReplaceAll] );
end;

end.

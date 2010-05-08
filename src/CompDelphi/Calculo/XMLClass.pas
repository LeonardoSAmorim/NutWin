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




unit XMLClass;

interface

uses
  SysUtils, Classes, Consts,TypInfo,Dialogs;

type

  TMyWriter = class(Classes.TWriter);
  TMyReader = class(Classes.TReader)
    private
     procedure CheckValue(Value: TValueType);
    end;
  { Object conversion routines }
  procedure XMLObjectBinaryToText(Input, Output: TStream;DocType : string; StyleSheet : string);
  procedure XMLObjectTextToBinary(Input, Output: TStream);

  procedure XMLComponentToTextFile(TxtFileName : string;Component: TComponent;DocType : string; StyleSheet : string);
  function XMLTextFileToComponent (TxtFileName : string;Component:TComponent): TComponent;

  function XMLComponentToString(Component: TComponent;DocType : string; StyleSheet : string): string;
  function XMLStringToComponent(Value: string;Component:TComponent): TComponent;

  // Funcao auxiliar
  function ConverteFileNameExtTo(const FileName, Ext : String) : String;

implementation

procedure XMLComponentToTextFile(TxtFileName : string;Component: TComponent;DocType : string; StyleSheet : string);
var
  BinStream:TMemoryStream;
  TxtStream : TFileStream;
begin
  BinStream := TMemoryStream.Create;
  try
    TxtStream := TFileStream.Create (TxtFileName,(fmCreate or fmShareCompat));
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      XMLObjectBinaryToText(BinStream, TxtStream, DocType, StyleSheet);
    finally
      TxtStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

function XMLTextFileToComponent (TxtFileName : string;Component:TComponent): TComponent;
var
  BinStream: TMemoryStream;
  TxtStream : TFileStream;
  DateTime : TDateTime;
begin
  Result:=nil;
  TxtStream := TFileStream.Create (TxtFileName,(fmOpenRead or fmShareCompat));
  if ((not Assigned (TxtStream)) or (TxtStream.Size = 0)) then exit;

  try
    BinStream := TMemoryStream.Create;
    try
      DateTime:=Time;
      XMLObjectTextToBinary(TxtStream, BinStream);
      ShowMessage ('Fim do TextToBinary - Tempo : '+TimeToStr (Time - DateTime));
      DateTime:=Time;
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(Component);
      ShowMessage ('Fim do ReadComponent - Tempo : '+TimeToStr (Time - DateTime));
    finally
      BinStream.Free;
    end;
  finally
    TxtStream.Free;
  end;

end;

function XMLComponentToString(Component: TComponent;DocType : string; StyleSheet : string): string;

var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
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

function XMLStringToComponent(Value: string;Component:TComponent): TComponent;
var
  StrStream:TStringStream;
  BinStream: TMemoryStream;
begin
  if Value='' then
     begin
     Result:=nil;
     exit;
     end;
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      XMLObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(Component);

    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;


//=============================================================


{ Binary to text conversion }

procedure XMLObjectBinaryToText(Input, Output: TStream;DocType : string; StyleSheet : string);
var
  NestingLevel: Integer;
  SaveSeparator: Char;
  Reader: TMyReader;
  Writer: TWriter;
  ClassName, ObjectName: string;

  procedure WriteIndent;
  const
    Blanks: array[0..1] of Char = '  ';
  var
    I: Integer;
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
    Flags: TFilerFlags;
    Position: Integer;
  begin
    Reader.ReadPrefix(Flags, Position);
    ClassName := Reader.ReadStr;
    ObjectName := Reader.ReadStr;
    WriteIndent;
    if ffInherited in Flags then
      begin
      XMLTag := 'inherited.';
      WriteStr('<inherited.')  // wgb - era 'inherited '
      end
    else
      begin
      XMLTag := ''; //object.
      WriteStr('<' + ClassName + ' ObjectName="'+ObjectName+'"'); // Pablo : nao tinha ObjectName
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
//    WriteStr(#13#10);
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
          L := Length(W);
//          if L = 0 then WriteStr('''''') else
          if L > 0 then
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
//                  WriteStr('''');
                  while J < I do
                  begin
                    WriteStr( Char(W[J]) );
                    Inc(J);
                  end;
//                  WriteStr('''');
                end else
                begin
                  WriteStr('#');
                  WriteStr(IntToStr(Ord(W[I])));
                  Inc(I);
                  if ((I - K) >= LineLength) then LineBreak := True;
                end;
                if LineBreak and (I <= L) then
                begin
//                  WriteStr(' +'); // wgb - não preciso disso
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
          L := Length(S);
//          if L = 0 then WriteStr('''''') else
          if L > 0 then
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
//                  WriteStr('''');
                  Writer.Write(S[J], I - J);
//                  WriteStr('''');
                end else
                begin
                  WriteStr('#');
                  WriteStr(IntToStr(Ord(S[I])));
                  Inc(I);
                  if ((I - K) >= LineLength) then LineBreak := True;
                end;
                if LineBreak and (I <= L) then
                begin
//                  WriteStr(' +');  // wgb - não preciso disto
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
    ConvertValue;         // wgb - tirei o =
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
//          if not Reader.EndOfList then
//             WriteStr (#13#10);
          end;
    WriteStr('>'+#13#10);
    Reader.ReadListEnd;
//    WriteIndent; //Pablo
//    WriteStr('<ObjectName>'+ObjectName + '</ObjectName>'+#13#10); //Pablo

    while not Reader.EndOfList do ConvertObject;
    Reader.ReadListEnd;
    Dec(NestingLevel);
    WriteIndent;
    WriteStr('</'+XMLTag+'>' + #13#10);  // wgb - era 'end'
  end;

begin
  NestingLevel := 0;
  Reader := TMyReader.Create(Input, 4096);
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

//******************************************************************************

{ Text to binary conversion }

procedure XMLObjectTextToBinary(Input, Output: TStream);
var
  SaveSeparator: Char;
  Parser: TParser;
  Writer: TWriter;
  ClassRef : TPersistentClass;
  ClassName, ObjectName: string;

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
    Flags: TFilerFlags;
    Position: Integer;
//    StreamPos : Integer;
  begin
    Parser.CheckToken(toSymbol);
    ClassName := Parser.TokenString;
    Parser.NextToken;
    ObjectName:='';
    if (CompareText(Parser.TokenString,'ObjectName')=0) then
       begin
       // Pular o =
       Parser.NextToken;
       //Pular Aspas duplas
       Parser.NextToken;
       //Pegar o nome do objeto
       Parser.NextToken;
       ObjectName:=Parser.TokenString;
       //Pular Aspas duplas
       Parser.NextToken;
       Parser.NextToken;
       end;
//    StreamPos:=Parser.SourcePos;
//    ObjectName:= FindObjectName (copy(TStringStream(Input).DataString,StreamPos,TStringStream(Input).Size-StreamPos));
    Flags := [];
    Position := ConvertOrderModifier;
    if IsInherited then
      Include(Flags, ffInherited);
    if Position >= 0 then
      Include(Flags, ffChildPos);
    TMyWriter(Writer).WritePrefix(Flags, Position);
    Writer.WriteStr(ClassName);
    Writer.WriteStr(ObjectName);
    ClassRef:=FindClass(ClassName);
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
            TMyWriter(Writer).WriteValue(vaSet);
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
          TMyWriter(Writer).WriteBinary(Parser.HexToBinary);
        '<':
          begin
            Parser.NextToken;
            TMyWriter(Writer).WriteValue(vaCollection);
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
    PropTyp : TTypeKind;
    AuxStr : string;
    PropInfo: PPropInfo;
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
    if Assigned(ClassRef) then
      begin
      PropInfo := GetPropInfo(PTypeInfo(ClassRef.ClassInfo), PropName);
      if PropInfo = nil then
        raise Exception.CreateFmt(SUnknownProperty,[]);
      PropTyp:=PropInfo^.PropType^^.Kind;
      if (PropTyp in [tkChar,tkString,tkWChar,tkLString,tkWString]) then
        begin
        AuxStr:='';
        Parser.NextToken; // Toma conta das aspas '"'
        while (Parser.Token <>'"') do
          begin
          AuxStr:=AuxStr + Parser.TokenString;
          Parser.NextToken;
          end;
        Writer.WriteString (AuxStr);
        Parser.NextToken;
        end
      else
       begin
        Parser.NextToken; // Toma conta das aspas '"'
        ConvertValue;
        Parser.NextToken; // Toma conta das aspas '"'
       end;
      end
   else
     begin
      Parser.NextToken; // Toma conta das aspas '"'
      ConvertValue;
      Parser.NextToken; // Toma conta das aspas '"'
     end;
  end;

  procedure ConvertObject;
  var
    InheritedObject: Boolean;
  begin
    InheritedObject := False;

    repeat
    while Parser.TokenString <> '<' do
       Parser.NextToken;
    Parser.NextToken;
    if Parser.TokenString = '/' then
       exit;
    until ((Parser.TokenString <> '!') and
           (Parser.TokenString <> '?'));

    if Parser.TokenSymbolIs('INHERITED') then   // wgb - era 'INHERITED'
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

    ConvertHeader(InheritedObject);
    while (Parser.TokenString <> '/') and (Parser.TokenString <> '>') do
          ConvertProperty;

    Writer.WriteListEnd;
    while Parser.TokenString <> '/' do
        ConvertObject;  // wgb - era 'END'
    Writer.WriteListEnd;
    while Parser.TokenString <> '>' do
       Parser.NextToken;
    Writer.FlushBuffer;
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

//******************************************************************************

procedure TMyReader.CheckValue(Value: TValueType);
begin
inherited;
end;

function ConverteFileNameExtTo(const FileName, Ext : String) : String;
begin
   if Pos('.', FileName) = 0 then
      Result := FileName + '.' + Ext
   else
      Result := Copy ( FileName, 1, Pos('.', FileName) ) + Ext;
end;


end.

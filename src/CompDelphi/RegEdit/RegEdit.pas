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




unit RegEdit;

interface

uses Windows, Registry;

  function CriaChaveString(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : String = '' ) : Boolean;
  function GravaChaveString(const Root : HKEY; const PathKey, KeyName, KeyValue : String ) : Boolean;
  function CarregaChaveString(const Root : HKEY; const PathKey, KeyName : String; var  KeyValue : String ) : Boolean;

  function CriaChaveBoolean(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : Boolean = False ) : Boolean;
  function GravaChaveBoolean(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : Boolean ) : Boolean;
  function CarregaChaveBoolean(const Root : HKEY; const PathKey, KeyName : String; var  KeyValue : Boolean ) : Boolean;

  function CriaChaveInteger(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : Integer = 0 ) : Boolean;
  function GravaChaveInteger(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : Integer ) : Boolean;
  function CarregaChaveInteger(const Root : HKEY; const PathKey, KeyName : String; var  KeyValue : Integer ) : Boolean;

  function CriaChaveFloat(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : Double = 0 ) : Boolean;
  function GravaChaveFloat(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : Double ) : Boolean;
  function CarregaChaveFloat(const Root : HKEY; const PathKey, KeyName : String; var  KeyValue : Double ) : Boolean;

  function CriaChaveDateTime(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : TDateTime = 0 ) : Boolean;
  function GravaChaveDateTime(const Root : HKEY; const PathKey, KeyName : String; const KeyValue :TDateTime ) : Boolean;
  function CarregaChaveDateTime(const Root : HKEY; const PathKey, KeyName : String; var  KeyValue :TDateTime ) : Boolean;

  function CriaChaveDate(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : TDateTime = 0 ) : Boolean;
  function GravaChaveDate(const Root : HKEY; const PathKey, KeyName : String; const KeyValue :TDateTime ) : Boolean;
  function CarregaChaveDate(const Root : HKEY; const PathKey, KeyName : String; var  KeyValue :TDateTime ) : Boolean;

  function CriaChaveTime(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : TDateTime = 0 ) : Boolean;
  function GravaChaveTime(const Root : HKEY; const PathKey, KeyName : String; const KeyValue :TDateTime ) : Boolean;
  function CarregaChaveTime(const Root : HKEY; const PathKey, KeyName : String; var  KeyValue :TDateTime ) : Boolean;

  function CriaChaveCurrency(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : Currency = 0 ) : Boolean;
  function GravaChaveCurrency(const Root : HKEY; const PathKey, KeyName : String; const KeyValue : Currency ) : Boolean;
  function CarregaChaveCurrency(const Root : HKEY; const PathKey, KeyName : String; var  KeyValue : Currency ) : Boolean;

implementation

//======================= STRING ========================

function CriaChaveString(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue : String): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, True) ) then
  begin
    reg.WriteString(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function GravaChaveString(const Root: HKEY; const PathKey, KeyName,
  KeyValue: String): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  begin
    reg.WriteString(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function CarregaChaveString(const Root: HKEY; const PathKey,
  KeyName: String; var KeyValue: String): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  if reg.ValueExists( KeyName ) then
  begin
    KeyValue := reg.ReadString(KeyName);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

//======================= BOOLEAN ========================

function CriaChaveBoolean(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue : Boolean): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, True) ) then
  begin
    reg.WriteBool(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function GravaChaveBoolean(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue: Boolean): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  begin
    reg.WriteBool(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function CarregaChaveBoolean(const Root: HKEY; const PathKey,
  KeyName: String; var KeyValue: Boolean): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  if reg.ValueExists( KeyName ) then
  begin
    KeyValue := reg.ReadBool(KeyName);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

//======================= INTEGER ========================

function CriaChaveInteger(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue : Integer): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, True) ) then
  begin
    reg.WriteInteger(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function GravaChaveInteger(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue: Integer): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  begin
    reg.WriteInteger(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function CarregaChaveInteger(const Root: HKEY; const PathKey,
  KeyName: String; var KeyValue: Integer): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  if reg.ValueExists( KeyName ) then
  begin
    KeyValue := reg.ReadInteger(KeyName);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

//======================= FLOAT ========================

function CriaChaveFloat(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue : Double): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, True) ) then
  begin
    reg.WriteFloat(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function GravaChaveFloat(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue: Double): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  begin
    reg.WriteFloat(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function CarregaChaveFloat(const Root: HKEY; const PathKey,
  KeyName: String; var KeyValue: Double): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  if reg.ValueExists( KeyName ) then
  begin
    KeyValue := reg.ReadFloat(KeyName);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

//======================= TDATETIME ========================

function CriaChaveDateTime(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue :TDateTime): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, True) ) then
  begin
    reg.WriteDateTime(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function GravaChaveDateTime(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue:TDateTime): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  begin
    reg.WriteDateTime(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function CarregaChaveDateTime(const Root: HKEY; const PathKey,
  KeyName: String; var KeyValue: TDateTime): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  if reg.ValueExists( KeyName ) then
  begin
    KeyValue := reg.ReadDateTime(KeyName);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

//======================= DATE ========================

function CriaChaveDate(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue :TDateTime): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, True) ) then
  begin
    reg.WriteDate(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function GravaChaveDate(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue:TDateTime): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  begin
    reg.WriteDate(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function CarregaChaveDate(const Root: HKEY; const PathKey,
  KeyName: String; var KeyValue: TDateTime): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  if reg.ValueExists( KeyName ) then
  begin
    KeyValue := reg.ReadDate(KeyName);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

//======================= TIME ========================

function CriaChaveTime(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue :TDateTime): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, True) ) then
  begin
    reg.WriteTime(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function GravaChaveTime(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue:TDateTime): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  begin
    reg.WriteTime(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function CarregaChaveTime(const Root: HKEY; const PathKey,
  KeyName: String; var KeyValue: TDateTime): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  if reg.ValueExists( KeyName ) then
  begin
    KeyValue := reg.ReadTime(KeyName);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

//======================= CURRENCY ========================

function CriaChaveCurrency(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue :Currency): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, True) ) then
  begin
    reg.WriteCurrency(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function GravaChaveCurrency(const Root: HKEY; const PathKey, KeyName : String;
  const KeyValue: Currency): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  begin
    reg.WriteCurrency(KeyName, KeyValue);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

function CarregaChaveCurrency(const Root: HKEY; const PathKey,
  KeyName: String; var KeyValue: Currency): Boolean;
var
  reg : TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  reg.RootKey := Root;
  if ( reg.OpenKey( PathKey, False) ) then
  if reg.ValueExists( KeyName ) then
  begin
    KeyValue := reg.ReadCurrency(KeyName);
    reg.CloseKey;
    Result := True;
  end;
  reg.Destroy;
end;

end.

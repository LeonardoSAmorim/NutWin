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
{       Copyright © 1997 by DIS-EPM/UNIFESP             }
{                                                       }
{*******************************************************}

unit LofStrings;

interface

uses classes, DsgnIntf, dialogs, Forms;

type

  TStringListOfStrings = class(TStringList)
  private
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    procedure Clear;override;
    procedure AssignTo( Dest : TPersistent );override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TSLOfStringsProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure Register;

implementation

procedure Register;
begin
   { Register TMemoria with Nutricao as its
     default page on the Delphi component palette }
   RegisterPropertyEditor (TypeInfo(TStringListOfStrings), nil, '', TSLOfStringsProperty);
end;

{ TStringListOfStrings }

procedure TStringListOfStrings.ReadData(Reader: TReader);
var
  ObjString : TStringList;
begin
  Reader.ReadListBegin;
  BeginUpdate;
  try
    Clear;
    while not Reader.EndOfList do
     begin
     ObjString := TStringList.Create;
     AddObject(Reader.ReadString,ObjString);
     Reader.ReadListBegin;
     BeginUpdate;
     try
        ObjString.Clear;
        while not Reader.EndOfList do
              ObjString.Add(Reader.ReadString);
     finally
        EndUpdate;
     end;
     Reader.ReadListEnd;

     end;
  finally
    EndUpdate;
  end;
  Reader.ReadListEnd;
end;

procedure TStringListOfStrings.WriteData(Writer: TWriter);
var
  I : Integer;
  J : Integer;
  ObjString : TStringList;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do
      begin
      Writer.WriteString(Get(I));
      ObjString := (Objects[I] as TStringList);
      Writer.WriteListBegin;
      for J := 0 to ObjString.Count - 1 do
          Writer.WriteString(TStringListOfStrings(ObjString).Get(J));
      Writer.WriteListEnd;
      end;
  Writer.WriteListEnd;
end;

procedure TStringListOfStrings.DefineProperties(Filer: TFiler);
  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> nil then
    begin
      Result := True;
      if Filer.Ancestor is TStrings then
        Result := not Equals(TStrings(Filer.Ancestor))
    end
    else Result := Count > 0;
  end;
begin
  Filer.DefineProperty('Strings', ReadData, WriteData, DoWrite);
end;

procedure TStringListOfStrings.LoadFromStream(Stream: TStream);
var
  Reader: TReader;
begin
   Reader := TReader.Create(Stream, 4096);
   try
      ReadData(Reader);
   finally
      Reader.Free;
   end;
end;

procedure TStringListOfStrings.SaveToStream(Stream: TStream);
var
   Writer:TWriter;
begin
   Writer := TWriter.Create(Stream, 4096);
   try
      WriteData(Writer);
   finally
      Writer.Free;
   end;
end;

procedure TStringListOfStrings.Clear;
var
   I: Integer;
begin
   for I := 0 to Count - 1 do
      Objects[I].Free;
   inherited;
end;

// TSLOfStringsProperty

procedure TSLOfStringsProperty.Edit;
var
  SLOFSFileOpen : TOpenDialog;
  NewList : TStringListOfStrings;
begin
  SLOFSFileOpen := TOpenDialog.Create(Application);
  SLOFSFileOpen.Filename := '';
  SLOFSFileOpen.Filter := 'Path files (*.pth)|*.pth';
  SLOFSFileOpen.HelpContext := 0;
  SLOFSFileOpen.Options := SLOFSFileOpen.Options + [ofShowHelp, ofPathMustExist,
    ofFileMustExist];
  try
    if SLOFSFileOpen.Execute then
       begin
       NewList := TStringListOfStrings(GetOrdValue);
       NewList.LoadFromFile(SLOFSFileOpen.Filename);
       Modified;
       end;
  finally
    SLOFSFileOpen.Free;
  end;
end;

function TSLOfStringsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;

procedure TStringListOfStrings.AssignTo(Dest: TPersistent);
var
   I : Integer;
   Aux : TStringList;
begin
  if Dest is TStringListOfStrings then
     begin
        for I := 0 to Count - 1 do
           begin
              Aux := TStringList.Create;
              Aux.Assign(TStringListOfStrings(Objects[i]));
              TStringListOfStrings(Dest).AddObject(Strings[i], Aux);
           end;
     end
  else
     inherited AssignTo(Dest);
end;

initialization
   RegisterClass(TStringListOfStrings);

end.

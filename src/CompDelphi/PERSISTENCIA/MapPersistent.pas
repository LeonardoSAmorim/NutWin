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




unit MapPersistent;
{ ****************************************************************** }
{                                                                    }
{   MapPersistent.pas                                      }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   21/Marco/1999                                                    }
{                                                                    }
{ ****************************************************************** }
{
      Esta Unit foi montada para poder separar o editor de propriedade  do  per-
sistenteCollection, e com isso evitar as referencias circulares que ocorriam.  E
tambem para poder organizar de uma forma melhor os objetos.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  //Define a class do editor de propriedade
  TMapPersistent = Class(TPersistent)
  private
    FListProperty : TStrings;
    FListField    : TStrings;
    FListObject   : TStrings;
    FListFieldLen : TStrings;
    FListFieldKey : TStrings;
    FListFieldType: TStrings;
    FMapDDL : TStrings;
    FMapJoin : TStrings;
    FMapIndex: Tstrings;
    FMapOrder: TStrings;
    FMapWhere: TStrings;
    function GetListProperty : TStrings;
    procedure SetListProperty(Value : TStrings);
    function GetListField : TStrings;
    procedure SetListField(Value : TStrings);
    function GetListObject : TStrings;
    procedure SetListObject(Value : TStrings);
    function GetListFieldLen : TStrings;
    procedure SetListFieldLen(Value : TStrings);
    function GetListFieldKey : TStrings;
    procedure SetListFieldKey(Value : TStrings);
    function GetListFieldType : TStrings;
    procedure SetListFieldType(Value : TStrings);
    function GetMapDDL : TStrings;
    procedure SetMapDDL(Value : TStrings);
    function GetMapJoin : TStrings;
    procedure SetMapJoin(Value : TStrings);
    procedure SetMapIndex(const Value: Tstrings);
    procedure SetMapOrder(const Value: TStrings);
    procedure SetMapWhere(const Value: TStrings);

  public
    constructor Create;
    destructor Destroy;
    procedure Clear;
    function FieldOfProperty(xProperty : String) : String;
  published
    property ListProperty : TStrings read GetListProperty write SetListProperty;
    property ListField : TStrings read GetListField write SetListField;
    property ListObject : TStrings read GetListObject write SetListObject;
    property ListFieldLen : TStrings read GetListFieldLen write SetListFieldLen;
    property ListFieldKey : TStrings read GetListFieldKey write SetListFieldKey;
    property ListFieldType : TStrings read GetListFieldType write SetListFieldType;
    property MapDDL : TStrings read GetMapDDL write SetMapDDL;
    property MapJoin : TStrings read GetMapJoin write SetMapJoin;
    property MapOrder : TStrings read FMapOrder write SetMapOrder;
    property MapIndex : Tstrings read FMapIndex write SetMapIndex;
    property MapWhere : TStrings read FMapWhere write SetMapWhere;
  end;

procedure Register;

implementation

procedure Register;
begin
end;

constructor TMapPersistent.Create;
begin
   //esta forma de persistir o mapiamente devera ser alterado por algo melhor talves
   //a caixa do Pablo
   FListProperty := TStringList.Create;
   FListField := TStringList.Create;
   FListObject := TStringList.Create;
   FListFieldLen := TStringList.Create;
   FListFieldKey := TStringList.Create;
   FListFieldType := TStringList.Create;
   FMapDDL := TStringList.Create;
   FMapJoin := TStringList.Create;
   FMapIndex := TStringList.Create;
   FMapOrder := TStringList.Create;
   FMapWhere := TStringList.Create;
end;

destructor TMapPersistent.Destroy;
begin
   FListProperty.free;
   FListField.free;
   FListObject.Free;
   FListFieldLen.Free;
   FListFieldKey.Free;
   FListFieldType.Free;
   FMapDDL.Free;
   FMapJoin.Free;
   FMapIndex.Free;
   FMapOrder.Free;
   FMapWhere.Free;

   inherited Destroy;
end;


function TMapPersistent.GetListProperty : TStrings;
begin
     Result := FListProperty;
end;

procedure TMapPersistent.SetListProperty(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListProperty.Assign(Value);
end;

function TMapPersistent.GetListField : TStrings;
begin
     Result := FListField;
end;

procedure TMapPersistent.SetListField(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListField.Assign(Value);
end;

function TMapPersistent.GetListObject : TStrings;
begin
     Result := FListObject;
end;

procedure TMapPersistent.SetListObject(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListObject.Assign(Value);
end;


function TMapPersistent.GetListFieldLen : TStrings;
begin
     Result := FListFieldLen;
end;

procedure TMapPersistent.SetListFieldLen(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListFieldLen.Assign(Value);
end;

function TMapPersistent.GetListFieldkey : TStrings;
begin
     Result := FListFieldKey;
end;

procedure TMapPersistent.SetListFieldKey(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListFieldkey.Assign(Value);
end;

function TMapPersistent.GetListFieldType : TStrings;
begin
     Result := FListFieldType;
end;

procedure TMapPersistent.SetListFieldType(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListFieldType.Assign(Value);
end;

function TMapPersistent.GetMapDDL : TStrings;
begin
     Result := FMapDDL;
end;

procedure TMapPersistent.SetMapDDL(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FMapDDL.Assign(Value);
end;

function TMapPersistent.GetMapJoin : TStrings;
begin
     Result := FMapJoin;
end;

procedure TMapPersistent.SetMapJoin(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FMapJoin.Assign(Value);
end;

procedure TMapPersistent.SetMapIndex(const Value: Tstrings);
begin
  FMapIndex.Assign(Value);
end;

procedure TMapPersistent.SetMapOrder(const Value: TStrings);
begin
  FMapOrder.Assign(Value);
end;

procedure TMapPersistent.SetMapWhere(const Value: TStrings);
begin
  FMapWhere.assign(Value);
end;

procedure TMapPersistent.Clear;
begin
  FListProperty.Clear;
  FListField.Clear;
  FListObject.Clear;
  FListFieldLen.Clear;
  FListFieldKey.Clear;
  FListFieldType.Clear;
  FMapDDL.Clear;
  FMapJoin.Clear;
  FMapIndex.Clear;
  FMapOrder.Clear;
  FMapWhere.Clear;
end;

function TMapPersistent.FieldOfProperty(xProperty: String): String;
var
  i : integer;
begin
  Result := '';
  for i := 0 to FListProperty.Count - 1 do
    if UpperCase(FListProperty[i]) = UpperCase(xProperty) then
       Result := FListField[i];
end;

end.

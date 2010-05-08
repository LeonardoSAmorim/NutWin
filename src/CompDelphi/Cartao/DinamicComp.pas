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




unit DinamicComp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TDinamicComp = class(TComponent)
  private
    { Private declarations }
    FListNamesComps : TStrings;
    FListValuesComps : TStrings;
    procedure ReadStringChekd(Reader: TReader);
    procedure WriteStringChekd(Writer: TWriter);
  protected
    { Protected declarations }
    constructor Create(AOwner : TComponent); override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TDinamicComp]);
end;

constructor TDinamicComp.Create(AOwner : TComponent);
begin
   inherited create(AOwner);
   FListNamesComps := TStringList.create;
   FListValuesComps := TStringList.create;
end;

procedure TDinamicComp.DefineProperties(Filer: TFiler);
var
   i : integer;
begin
   inherited;
   FListNamesComps.add('a');
   FListNamesComps.add('b');
   FListNamesComps.add('c');
   FListNamesComps.add('d');
   FListValuesComps.add('1');
   FListValuesComps.add('2');
   FListValuesComps.add('3');
   FListValuesComps.add('4');
   for i := 0 to FListNamesComps.Count - 1 do
   begin
      Filer.DefineProperty(FListNamesComps[i], ReadStringChekd, WriteStringChekd,True);
   end;
end;

procedure TDinamicComp.ReadStringChekd(Reader: TReader);
var
   i : integer;
begin
   for i := 0 to FListValuesComps.Count - 1 do
   begin
      FListValuesComps[i] := Reader.ReadString;
   end;
end;

procedure TDinamicComp.WriteStringChekd(Writer: TWriter);
var
   i : integer;
begin
   for i := 0 to FListValuesComps.Count - 1 do
   begin
      Writer.WriteString(FListValuesComps[i]);
   end;
end;




end.

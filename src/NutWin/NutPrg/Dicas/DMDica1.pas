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




unit DMDica1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, ActiveX;

type
  TDMDica = class(TDataModule)
    DSDicas: TDataSource;
    TbDicas: TTable;
    TbDicasCodDica: TStringField;
    TbDicasDicaPort: TMemoField;
    TbDicasDicaIngl: TMemoField;
    TbDicasDataCad: TDateField;
    TbDicasPalPort: TStringField;
    TbDicasPalIngl: TStringField;
    procedure TbDicasNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function CreateNewGUID: string;
  end;

var
  DMDica: TDMDica;

implementation

{$R *.DFM}

function TDMDica.CreateNewGUID: string;
var
NewGUID: TGUID;
NewString : array [0..49] of WideChar;
begin
 if Succeeded (CoCreateGuid(NewGUID)) then
   begin
   StringFromGUID2 (NewGUID, @NewString, 40);
   Result:= WideCharToString (NewString);
   end
 else
    Result:='';
end;

procedure TDMDica.TbDicasNewRecord(DataSet: TDataSet);
begin
   TbDicasCodDica.asString   := CreateNewGUID;
   TbDicasDATACAD.AsDateTime := Date ;
end;

end.

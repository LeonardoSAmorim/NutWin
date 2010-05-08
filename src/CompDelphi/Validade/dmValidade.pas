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




unit dmValidade;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TdmValida = class(TDataModule)
    dsValidade: TDataSource;
    dbValidade: TDatabase;
    taValidade: TTable;
    taValidadeDESENVOLVIMENTO: TStringField;
    taValidadeVERSAO_AVALIACAO: TStringField;
    taValidadeDATA_INSTALACAO: TDateTimeField;
    taValidadeDATA_ULTIMO_ACESSO: TDateTimeField;
    taValidadeRETROCESSO: TStringField;
    taValidadeCONTADOR: TIntegerField;
    taValidadeVALIDADE: TIntegerField;
    taValidadeSERIAL: TStringField;
    taValidadeLICENCAS: TIntegerField;
  private
    FDataBaseName: String;
    procedure SetDataBaseName(const Value: String);
    { Private declarations }
  public
    { Public declarations }
    property DataBaseName : String read FDataBaseName write SetDataBaseName;
  end;

var
  dmValida: TdmValida;

implementation


{$R *.DFM}

procedure TdmValida.SetDataBaseName(const Value: String);
begin
   FDataBaseName := Value;
   dbValidade.Connected := False;
   if FDataBaseName = '' then
      taValidade.DatabaseName := dbValidade.DatabaseName
   else
      taValidade.DatabaseName := FDataBaseName;
   dbValidade.Connected := True;
   taValidade.Open;
end;

end.

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




unit dmlock;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db;

const APP_LOCK_LABEL = 'ORGNUT ATIVO';

type
  Tdmlockbd = class(TDataModule)
    qryLock: TQuery;
    dbLock: TDatabase;
    procedure dmlockbdCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function TravaAplicacao( AplicID : String='' ): Boolean;
    function LiberaAplicacao : Boolean;
  end;

var
  dmLockBD: TdmLockBD;

implementation

uses uAliasName;

{$R *.dfm}

{ Tdmlockbd }

function TdmLockBD.LiberaAplicacao: Boolean;
begin
   Result := True;
   try
      dbLock.Rollback;
   Except
      Result := False;
   end
end;

function TdmLockBD.TravaAplicacao( AplicID : String='' ): Boolean;
begin
   Result := True;
   dbLock.StartTransaction;
   with qryLock do
    try
      Params.ParamByName('RECURSO').AsString := AplicID;
      ExecSQL;
    except
      dbLock.Rollback;
      Result := False;
    end;
end;

procedure Tdmlockbd.dmlockbdCreate(Sender: TObject);
begin
 dbLock.AliasName := BDE_ALIAS_NAME;
 dbLock.Open;
end;

end.


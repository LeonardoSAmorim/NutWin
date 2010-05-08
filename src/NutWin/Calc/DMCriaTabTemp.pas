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




unit DMCriaTabTemp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RxQuery, db, DBTables;

type
  TdmCriaTabelasTemp = class(TDataModule)
    ssCriaTabelas: TSQLScript;
    quDropTab: TQuery;
    tbIsOpened: TTable;
    dbCriaTabTemp: TDatabase;
    procedure ssCriaTabelasScriptError(Sender: TObject; E: EDatabaseError;
      LineNo, StatementNo: Integer; var Action: TScriptAction);
  private
    { Private declarations }
  public
    { Public declarations }
    function DelphiRodando : Boolean;
    function CriaTabelasTemporarias : Boolean;
    function IsTableOpened( sTableName : String ) : Boolean;
  end;

var
  dmCriaTabelasTemp: TdmCriaTabelasTemp;

implementation

{$R *.DFM}

function TdmCriaTabelasTemp.CriaTabelasTemporarias: Boolean;
var
   Tabelas : TStringList;
begin
   // Não consigo criá-las pois quando o Delphi está rodando, elas estão abertas
   if dmCriaTabelasTemp.DelphiRodando then
      begin
         // Finge que criou
         Result := True;
         exit;
      end;
   try
      Tabelas := TStringList.Create;
      if ( Session.GetAliasDriverName( dbCriaTabTemp.DatabaseName ) = 'STANDARD' ) and
         ( not IsTableOpened( 'CALCALI' ) ) then
         begin
            // Cria tabelas, pois é local e monousuário
            Session.GetTableNames( dbCriaTabTemp.DatabaseName,'*.*', False, False, Tabelas );
            if ( Tabelas.IndexOf( 'CALCALI' ) > -1 ) then
               begin
                  quDropTab.SQL.Clear;
                  quDropTab.SQL.Add( 'DROP TABLE CALCALI' );
                  quDropTab.ExecSQL;
               end;
            if ( Tabelas.IndexOf( 'REFCALCALI' ) > -1 ) then
               begin
                  quDropTab.SQL.Clear;
                  quDropTab.SQL.Add( 'DROP TABLE REFCALCALI' );
                  quDropTab.ExecSQL;
               end;
            if ( Tabelas.IndexOf( 'ITENSALI' ) > -1 ) then //Drop Table
               begin
                  quDropTab.SQL.Clear;
                  quDropTab.SQL.Add( 'DROP TABLE ITENSALI' );
                  quDropTab.ExecSQL;
               end;
//               ssDropTabelas.ExecSQL;
               ssCriaTabelas.DatabaseName := quDropTab.DatabaseName;
               ssCriaTabelas.ExecSQL;
            Result := True;
         end
      else
         // Não precisa criar pois elas estão no servidor de arquivos ou já forão criadas
         Result := True;
      Tabelas.Free;
   except
      // há mais de um usuário ou houve um erro na criação
      on E : EDataBaseError do
      begin
         Tabelas.Free;
         Result := False;
         ShowMessage( E.Message );
      end;
   end;
end;

function TdmCriaTabelasTemp.DelphiRodando: Boolean;
begin
   Result := (FindWindow( 'TAppBuilder', nil  ) <> 0 ) and
             (FindWindow( 'TApplication', nil  ) <> 0 ) and
             (FindWindow( 'TPropertyInspector', 'Object Inspector' ) <> 0 ) and
             (FindWindow( 'TMenuBuilder', 'Menu Designer'  ) <> 0 ) and
             (FindWindow( 'TAlignPalette', 'Align'  ) <> 0 );
end;

function TdmCriaTabelasTemp.IsTableOpened(sTableName : String): Boolean;
begin
   with tbIsOpened do
   Try
      if Active then
         Active := False;
      TableName := sTableName;
      Exclusive := True;
      Active := True;
      // Não deu erro, portanto continua
      Active := False;
      Exclusive := False;
      Result := False;
   except
      on E : EDataBaseError do
      begin
         Exclusive := False;
         Result := True;
      end;   
   end;
end;

procedure TdmCriaTabelasTemp.ssCriaTabelasScriptError(Sender: TObject;
  E: EDatabaseError; LineNo, StatementNo: Integer;
  var Action: TScriptAction);
begin
   ShowMessage( E.Message );
end;

end.

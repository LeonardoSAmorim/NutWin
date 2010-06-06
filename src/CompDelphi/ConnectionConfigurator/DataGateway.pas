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

unit DataGateway;

interface

uses Classes,
    Db,
    ZConnection,
    ConnectionParameters;

type
    TCreateNotifyEvent = procedure (Description: string; progress: integer) of object;
    TDataGateway = class (TObject)
    private
        FConnectionParameters: TConnectionParameters;
        FZConnection: TZConnection;
        FonExecute: TCreateNotifyEvent;

        property ConnectionParameters: TConnectionParameters read FConnectionParameters write FConnectionParameters;

        function getConnection: TZConnection;
        procedure resetConnection;
        procedure SetonExecute (const Value: TCreateNotifyEvent) ;

    public
        property onExecute: TCreateNotifyEvent read FonExecute write SetonExecute;
        constructor Create (ConnParam: TConnectionParameters) ; virtual;
        destructor Destroy; override;
        function executeQuery (stmt: string) : TDataset;
        function executeSQL (stmt: string) : integer;
        procedure executeScript (fileName: string) ;
        procedure executeScriptList (fileList: TStrings) ;

        procedure createDatabaseUser;
        procedure createDatabaseTables;
        procedure createDatabaseSchema;
        procedure createDatabaseRecords;

        function pingConnection: boolean;
        class function testConfiguration: boolean;

    end;

implementation

uses Registry, ZDataset,
    ZSQLProcessor,
    ZSQLStrings,
    Sysutils,
    SQL_STMT, RegConst2;

function listFilePattern (filePattern: string) : TStrings;
var
    FileNameList: TStrings;
    SearchRec: TSearchRec;
    path: string;
begin
    FileNameList := TStringList.create;
    path := ExtractFilePath (filePattern) ;
    if FindFirst (filePattern, faAnyFile, SearchRec) = 0 then
        while FindNext (SearchRec) = 0 do
            begin
                FileNameList.Add (path + SearchRec.Name) ;
            end;
    FindClose (SearchRec) ;
    result := FileNameList;

end;

{ TDataGateway }

constructor TDataGateway.Create (ConnParam: TConnectionParameters) ;
begin
    ConnectionParameters := ConnParam;
end;

destructor TDataGateway.Destroy;
begin

end;

function TDataGateway.executeQuery (stmt: string) : TDataset;
var
    Query: TZReadOnlyQuery;

begin
    Query := TZReadOnlyQuery.create (nil) ;
    Query.Connection := getConnection;
    Query.SQL.Add (stmt) ;
    Query.Open;
    result := Query;
end;

procedure TDataGateway.executeScript (fileName: string) ;
var
    SQLProcessor: TZSQLProcessor;
begin
    SQLProcessor := TZSQLProcessor.Create (nil) ;
    try
        SQLProcessor.Connection := getConnection;
        (SQLProcessor.Script as TZSQLStrings) .MultiStatements := false;
        (SQLProcessor.Script as TZSQLStrings) .ParamCheck := false;
        SQLProcessor.LoadFromFile (fileName) ;
        SQLProcessor.Execute;
    finally;
        SQLProcessor.free;
    end;

end;

procedure TDataGateway.executeScriptList (fileList: TStrings) ;
var
    index: integer;
begin
    for index := 0 to fileList.Count - 1 do
        executeScript (fileList[index])

end;

function TDataGateway.executeSQL (stmt: string) : integer;
var
    Query: TZReadOnlyQuery;

begin
    Query := TZReadOnlyQuery.create (nil) ;
    try

        Query.Connection := getConnection;
        Query.SQL.Add (stmt) ;
        Query.ExecSQL;
        result := 0;
    finally
        Query.free;
    end;
end;

function TDataGateway.pingConnection: boolean;
var
    Connection: TZConnection;
begin
    result := false;
    try
        Connection := getConnection;
        if Connection.Connected then
            Result := Connection.Ping
        else
            begin

                Connection.Connect;
                Result := Connection.Ping;
                Connection.Disconnect;
            end;
    except
    end;
end;

procedure TDataGateway.createDatabaseUser;
var
    stmt: string;
    index: integer;
    DataSet: TDataSet;
    UserName: string;
    Password: string;

begin

    UserName := 'NUTRICAO';
    Password := '*C4FA1D6B9185FD0DCD13B990F5489735252CC210';
    stmt := 'select count(1) from mysql.user where user = "' + UserName + '"';
    DataSet := nil;
    try
        DataSet := executeQuery (stmt) ;
        index := Dataset.Fields[0].asInteger;
    finally
        DataSet.free;
    end;

    if index < 1 then
        begin
            stmt := format (CREATE_USER_STMT, [UserName, Password]) ;
            executeSQL (stmt) ;
        end;
    stmt := format (CREATE_GRANT_STMT, [ConnectionParameters.Database, UserName]) ;
    executeSQL (stmt) ;
end;

procedure TDataGateway.createDatabaseSchema;
var
    stmt: string;
    Connection: TZConnection;

begin
    Connection := getConnection () ;
    Connection.database := '';
    stmt := format (CREATE_DATABASE_STMT, [ConnectionParameters.Database]) ;

    executeSQL (stmt) ;
    Connection.database := ConnectionParameters.Database;
    Connection.Disconnect;

end;

procedure TDataGateway.createDatabaseTables;
var
    index: integer;
    stmt: string;

begin
    for index := 0 to length (CREATE_STMT_MAP) - 1 do
        begin
            stmt := format (DROP_TABLE_STMT, [CREATE_STMT_MAP[index][0]]) ;
            executeSQL (stmt) ;
            stmt := CREATE_STMT_MAP[index][1];
            executeSQL (stmt) ;

        end;

end;

procedure TDataGateway.createDatabaseRecords;
var
    FileNameList: TStrings;
    index: integer;
    registry: TRegistry;
    DefaultDataPath: String;
begin

  registry := TRegistry.Create;
  registry.RootKey := CFGRoot;
 if (not registry.OpenKey (CFGPath, False) ) then
            raise ERegistryException.CreateFmt ('Falha ao abrir a chave %s', [CFGPath]) ;
 if not registry.ValueExists (CFGDefaultDataPath) then

               raise ERegistryException.CreateFmt ('Falha ao abrir a chave %s', [CFGDefaultDataPath]);


DefaultDataPath := registry.ReadString (CFGDefaultDataPath);
   FileNameList := listFilePattern (DefaultDataPath+'\*.sql') ;
    if FileNameList.Count = 0 then
        exit;
    for index := 0 to FileNameList.Count - 1 do
        begin
            if Assigned (onExecute) then
                onExecute (ExtractFileName (FileNameList[index]) , index * 100 div FileNameList.Count) ;
            executeScript (FileNameList[index]) ;

        end;

end;

function TDataGateway.getConnection: TZConnection;
begin

    if not assigned (FZConnection) then
        begin
            FZConnection := TZConnection.create (nil) ;
            resetConnection;
        end;

    result := FZConnection;

end;

procedure TDataGateway.resetConnection;
begin
    FZConnection.User := ConnectionParameters.UserName;
    FZConnection.Password := ConnectionParameters.Password;
    FZConnection.Protocol := ConnectionParameters.Protocol;
    FZConnection.HostName := ConnectionParameters.HostName;
    FZConnection.Port := ConnectionParameters.Port;
//    FZConnection.Catalog := ConnectionParameters.Database;
    FZConnection.Database := ConnectionParameters.Database;

end;

procedure TDataGateway.SetonExecute (const Value: TCreateNotifyEvent) ;
begin
    FonExecute := Value;
end;

class function TDataGateway.testConfiguration: boolean;
var
    ConnectionParameters: TConnectionParameters;
begin

    ConnectionParameters := TConnectionParameters.Create;
    ConnectionParameters.read;
    ConnectionParameters.UserName := 'NUTRICAO';
    ConnectionParameters.Password := 'NUTRICAO';

    with TDataGateway.Create (ConnectionParameters) do
        begin
            result := pingConnection;
            free;
        end;
    ConnectionParameters.Free;

end;

end.


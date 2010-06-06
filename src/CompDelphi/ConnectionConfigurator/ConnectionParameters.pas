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

unit ConnectionParameters;

interface
type
    TConnectionParameters = class
    private

        //    private state : (stUnknow, stNew, stClean, stDirty, stDeleted);
    private
        state: (stNew, stClean, stDirty) ;
        FDatabase: string;
        FUserName: string;
        FPassword: string;
        FHostName: string;
        FProtocol: string;
        FPort: integer;
        procedure SetProtocol (const Value: string) ;
        procedure SetHostName (const Value: string) ;
        procedure SetPort (const Value: integer) ;
        procedure SetDatabase (const Value: string) ;
        procedure SetUserName (const Value: string) ;
        procedure SetPassword (const Value: string) ;
        procedure changed;

    public

        constructor Create; virtual;
        destructor Destroy; override;
        procedure read;
        procedure write;
        function isNew: boolean;
        function isDirty: boolean;
        function isClean: boolean;

        procedure setDefault;

        property Protocol: string read FProtocol write SetProtocol;
        property HostName: string read FHostName write SetHostName;
        property Database: string read FDatabase write SetDatabase;
        property UserName: string read FUserName write SetUserName;
        property Password: string read FPassword write SetPassword;
        property Port: integer read FPort write SetPort;

    end;

implementation

uses Sysutils,
    registry,
    RegConst2;

{ TConnectionParameters }

procedure TConnectionParameters.changed;
begin
    if (state = stClean) then
        state := stDirty;
end;

constructor TConnectionParameters.Create;
begin

    inherited Create;
    setDefault;
    state := stNew;

end;

destructor TConnectionParameters.Destroy;
begin
    inherited Destroy;
end;

function TConnectionParameters.isClean: boolean;
begin
    result := state = stClean;
end;

function TConnectionParameters.isDirty: boolean;
begin
    result := state = stDirty;
end;

function TConnectionParameters.isNew: boolean;
begin
    result := state = stNew;
end;

procedure TConnectionParameters.write;
var
    registry: TRegistry;
    ConnectionKeyValue: string;
begin

    if isClean then
        exit;
    registry := TRegistry.Create;
    try

        registry.RootKey := CFGRoot;
        if (not registry.OpenKey (CFGPath, False) ) then
            raise ERegistryException.CreateFmt ('Falha ao abrir a chave %s', [CFGPath]) ;

        if not registry.ValueExists (CFGConnection) then
            begin
                ConnectionKeyValue := CFGConnectionKeyValue;
                registry.WriteString (CFGConnection, ConnectionKeyValue) ;
            end
        else
            ConnectionKeyValue := registry.ReadString (CFGConnection) ;

        if registry.OpenKey (ConnectionKeyValue, true) then
            begin
                registry.WriteString (CFGProtocol, Protocol) ;
                registry.WriteString (CFGHostname, HostName) ;
                registry.WriteString (CFGPort, IntToStr (Port) ) ;
                registry.WriteString (CFGDatabase, Database) ;
            end;

        registry.CloseKey;

        if not registry.OpenKey (CFGPathODBC, false) then
            raise ERegistryException.CreateFmt ('Falha ao abrir a chave %s', ['\SOFTWARE\ODBC\ODBC.INI\My_NutWin-1.6']) ;

        registry.WriteString ('DATABASE', Database) ;
                // registry.WriteString('DESCRIPTION', 'NutWin ODBC Data Source');
                // registry.WriteString('Driver', 'C:\Arquivos de programas\MySQL\Connector ODBC 5.1\myodbc5.dll');
        registry.WriteString ('PORT', IntToStr (Port) ) ;
        //        registry.WriteString( 'PWD', Password );
        //        registry.WriteString( 'UID', User );
        registry.WriteString ('SERVER', HostName) ;
        state := stClean;

    finally
        registry.Free;
    end;

end;

procedure TConnectionParameters.read;
var
    registry: TRegistry;
    ConnectionKeyValue: string;
begin
    registry := TRegistry.Create;

    try
        registry.RootKey := CFGRoot;

        if (not registry.OpenKey (CFGPath, False) ) then
            raise ERegistryException.CreateFmt ('Falha ao abrir a chave %s', [CFGPath]) ;

        if not registry.ValueExists (CFGConnection) then
            begin
                setDefault;
                State := stNew;
            end
        else
            begin

                ConnectionKeyValue := registry.ReadString (CFGConnection) ;

                if registry.OpenKey (ConnectionKeyValue, false) then
                    begin
                        Protocol := registry.ReadString (CFGProtocol) ;
                        Hostname := registry.ReadString (CFGHostname) ;
                        Port := StrToInt (registry.ReadString (CFGPort) ) ;
                        Database := registry.ReadString (CFGDatabase) ;
                        State := stClean
                    end
                else
                    begin
                        setDefault;
                        State := stNew;
                    end;
            end;
        registry.CloseKey;
    finally
        registry.Free;
    end;

end;

procedure TConnectionParameters.SetDatabase (const Value: string) ;
begin
    changed;
    FDatabase := Trim (Value) ;
end;

procedure TConnectionParameters.setDefault;
begin
    Protocol := 'mysql';
    HostName := 'localhost';
    UserName := 'NUTRICAO';
    Database := 'mynutwin';
    Port := 3306;
end;

procedure TConnectionParameters.SetHostName (const Value: string) ;
begin

    FHostName := Trim (Value) ;
    changed;
end;

procedure TConnectionParameters.SetPassword (const Value: string) ;
begin
    // password is not persistent
    FPassword := Trim (Value) ;

end;

procedure TConnectionParameters.SetPort (const Value: integer) ;
begin

    FPort := Value;
    changed;
end;

procedure TConnectionParameters.SetProtocol (const Value: string) ;
begin

    FProtocol := Trim (Value) ;
    changed;
end;

procedure TConnectionParameters.SetUserName (const Value: string) ;
begin
   //user name is not persistent
    FUserName := Trim (Value) ;

end;

end.


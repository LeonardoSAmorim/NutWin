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

unit ConnectionConfigurator;

interface

uses
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    ZConnection,
    StdCtrls,
    ZSqlMonitor,
    Db,
    ZAbstractRODataset,
    ZSqlMetadata,
    ZDataset,
    ZAbstractDataset,
    ZAbstractTable,
    ExtCtrls,
    GIFImage,
    ZScriptParser,
    ZSqlProcessor,
    ZSqlStrings,
    ComCtrls,
    ConnectionParameters;

type
    TFormConnectionConfigurator = class( TForm )
        Button7: TButton;
        btnCancel: TButton;
        Image1: TImage;
        Image2: TImage;
        Shape1: TShape;
        Image3: TImage;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        lblDatabase: TLabel;
        lblHostName: TLabel;
        lblProtocol: TLabel;
        lblPort: TLabel;
        edtDatabase: TEdit;
        edtHostName: TEdit;
        cbxProtocol: TComboBox;
        edtPort: TEdit;
        btnDefault: TButton;
        btnRestaurar: TButton;
        btnSave: TButton;
        lblPassword: TLabel;
        lblUserName: TLabel;
        edtPassword: TEdit;
        edtUserName: TEdit;
        btnTestRoot: TButton;
        GroupBox2: TGroupBox;
        lblDataBaseAdv: TLabel;
        btnCreateDatabase: TButton;
        ProgressBar1: TProgressBar;
        btnTestUser: TButton;

        procedure PropertiesChange( Sender: TObject );
        procedure FormCreate( Sender: TObject );
        procedure btnDefaultClick( Sender: TObject );

        procedure btnRestaurarClick( Sender: TObject );
        procedure btnTestRootClick( Sender: TObject );
        procedure btnSaveClick( Sender: TObject );
        procedure btnCreateDatabaseClick( Sender: TObject );
        procedure btnCancelClick( Sender: TObject );
        procedure edtPasswordChange( Sender: TObject );
        procedure btnTestUserClick( Sender: TObject );
    private
        procedure SetConnectionParameters( const Value: TConnectionParameters );
        procedure refresh;
        procedure refreshFields;
        procedure refreshButtons;
        procedure reset;
        procedure initComponents;
        function pingTest: boolean;

    private
        { Private declarations }
        FConnectionParameters: TConnectionParameters;
        FConnection: TZConnection;
        FUserTestSuccessful: boolean;

        property ConnectionParameters: TConnectionParameters read FConnectionParameters write SetConnectionParameters;
        property Connection: TZConnection read FConnection write FConnection;
        property UserTestSuccessful: boolean read FUserTestSuccessful write FUserTestSuccessful;

    public
        { Public declarations }

    end;

    TDataGateway = class( TObject )
    private
        FConnectionParameters: TConnectionParameters;
        FZConnection: TZConnection;
        property ConnectionParameters: TConnectionParameters read FConnectionParameters write FConnectionParameters;

        function getConnection: TZConnection;

    public
        constructor Create( ConnParam: TConnectionParameters ); virtual;
        destructor Destroy; override;
        function executeQuery( stmt: string ): TDataset;
        function executeSQL( stmt: string ): integer;
        procedure executeScript( fileName: string );
        procedure executeScriptList( fileList: TStrings );

        procedure createDatabaseUser;
        procedure createDatabaseTables;
        procedure createDatabaseSchema;
        procedure createDatabaseRecords;

        function pingConnection: boolean;

    end;

var
    FormConnectionConfigurator: TFormConnectionConfigurator;

implementation

uses Unit2,
    registry,
    RegConst2;

{$R *.DFM}

function listFilePattern( filePattern: string ): TStrings;
var
    FileNameList: TStrings;
    SearchRec: TSearchRec;
    path: string;
begin
    FileNameList := TStringList.create;
    path := ExtractFilePath( filePattern );
    if FindFirst( filePattern, faAnyFile, SearchRec ) = 0 then
        while FindNext( SearchRec ) = 0 do
            begin
                FileNameList.Add( path + SearchRec.Name );
            end;
    FindClose( SearchRec );
    result := FileNameList;

end;

{ TDataGateway }

constructor TDataGateway.Create( ConnParam: TConnectionParameters );
begin
    ConnParam := ConnectionParameters;
end;

destructor TDataGateway.Destroy;
begin

end;

function TDataGateway.executeQuery( stmt: string ): TDataset;
var
    Query: TZReadOnlyQuery;

begin
    Query := TZReadOnlyQuery.create( nil );
    Query.Connection := getConnection;
    Query.SQL.Add( stmt );
    Query.Open;
    result := Query;
end;

procedure TDataGateway.executeScript( fileName: string );
var
    SQLProcessor: TZSQLProcessor;
begin
    try
        SQLProcessor := TZSQLProcessor.Create( nil );
        SQLProcessor.Connection := getConnection;
        ( SQLProcessor.Script as TZSQLStrings ).MultiStatements := false;
        ( SQLProcessor.Script as TZSQLStrings ).ParamCheck := false;
        SQLProcessor.LoadFromFile( fileName );
        SQLProcessor.Execute;
    finally;
        SQLProcessor.free;
    end;

end;

procedure TDataGateway.executeScriptList( fileList: TStrings );
var
    index: integer;
begin
    for index := 0 to fileList.Count - 1 do
        executeScript( fileList[index] )

end;

function TDataGateway.executeSQL( stmt: string ): integer;
var
    Query: TZReadOnlyQuery;

begin
    try
        Query := TZReadOnlyQuery.create( nil );
        Query.Connection := getConnection;
        Query.SQL.Add( stmt );
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
    Connection := getConnection;
    if Connection.Connected then
        Result := Connection.Ping
    else
        begin
            Connection.Connect;
            Result := Connection.Ping;
            Connection.Disconnect;
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
    try
        DataSet := executeQuery( stmt );
        index := Dataset.Fields[0].asInteger;
    finally
        DataSet.free;
    end;

    if index < 1 then
        begin
            stmt := format( CREATE_USER_STMT, [UserName, Password] );
            executeSQL( stmt );
        end;
    stmt := format( CREATE_GRANT_STMT, [ConnectionParameters.Database, UserName] );
    executeSQL( stmt );
end;

procedure TDataGateway.createDatabaseSchema;
var
    stmt: string;

begin
    stmt := format( CREATE_DATABASE_STMT, [ConnectionParameters.Database] );
    executeSQL( stmt );

end;

procedure TDataGateway.createDatabaseTables;
var
    index: integer;
    stmt: string;

begin
    for index := 0 to length( CREATE_STMT_MAP ) - 1 do
        begin
            stmt := format( DROP_TABLE_STMT, [CREATE_STMT_MAP[index][0]] );
            executeSQL( stmt );
            stmt := CREATE_STMT_MAP[index][1];
            executeSQL( stmt );

        end;

end;

{ TForm1 }

procedure TFormConnectionConfigurator.FormCreate( Sender: TObject );
begin
    initComponents;
    reset;

end;

procedure TFormConnectionConfigurator.PropertiesChange( Sender: TObject );
begin
    ConnectionParameters.Database := edtDatabase.text;
    ConnectionParameters.HostName := edtHostName.text;
    ConnectionParameters.Protocol := cbxProtocol.text;
    if length( edtPort.text ) = 0 then
        ConnectionParameters.Port := 0
    else
        ConnectionParameters.Port := StrToInt( edtPort.text );
    refreshButtons;
end;

procedure TFormConnectionConfigurator.btnDefaultClick( Sender: TObject );
begin
    ConnectionParameters.setDefault;
    refresh;
    btnDefault.enabled := false;
end;

procedure TFormConnectionConfigurator.btnRestaurarClick( Sender: TObject );
begin

    reset;
    btnRestaurar.Enabled := false;
end;

procedure TFormConnectionConfigurator.btnTestRootClick( Sender: TObject );
var
    success: boolean;
begin
    Connection.User := edtUserName.Text;
    Connection.Password := edtPassword.Text;
    Connection.Protocol := ConnectionParameters.Protocol;
    Connection.HostName := ConnectionParameters.HostName;
    Connection.Port := ConnectionParameters.Port;
    Connection.Database := ConnectionParameters.Database;
    success := pingTest;

    if success then
        begin
            MessageDlg( 'Conexão realizada com Sucesso', mtInformation, [mbOk], 0 );
        end
    else
        begin
            MessageDlg( 'Não foi possivel se conectar ao servidor', mtError, [mbOk], 0 );
        end;
end;

procedure TFormConnectionConfigurator.btnSaveClick( Sender: TObject );
var
    registry: TRegistry;
    KeyValue: string;
begin

    ConnectionParameters.write;

    refreshButtons;
end;

procedure TFormConnectionConfigurator.btnCreateDatabaseClick( Sender: TObject );
var
    FileNameList: TStrings;

    DataGateway: TDataGateway;
begin

    DataGateway := TDataGateway.create( ConnectionParameters );
    try
        if not DataGateway.pingConnection then
            begin
                showmessage( 'Falha na criação do banco de dados. Não foi possivel se conectar ao servidor' );
                exit;
            end;

        DataGateway.createDatabaseSchema;
        DataGateway.createDatabaseUser;
        DataGateway.createDatabaseSchema;
        DataGateway.createDatabaseRecords;
    finally
        DataGateway.Free;
    end;

end;

procedure TFormConnectionConfigurator.btnCancelClick( Sender: TObject );
begin
    exit;
end;

procedure TFormConnectionConfigurator.edtPasswordChange( Sender: TObject );
begin
    btnTestRoot.Enabled :=
        ( length( edtPassword.Text ) > 0 ) and ( length( edtUserName.Text ) > 0 );
    btnCreateDatabase.Enabled := btnTestRoot.Enabled;

end;

procedure TFormConnectionConfigurator.btnTestUserClick( Sender: TObject );
var
    success: boolean;
begin

    Connection.User := 'NUTRICAO';
    Connection.Password := 'NUTRICAO';
    Connection.Protocol := ConnectionParameters.Protocol;
    Connection.HostName := ConnectionParameters.HostName;
    Connection.Port := ConnectionParameters.Port;
    Connection.Database := ConnectionParameters.Database;
    success := pingTest;

    if success then
        begin
            MessageDlg( 'Conexão realizada com Sucesso', mtInformation, [mbOk], 0 );
        end
    else
        begin
            MessageDlg( 'Não foi possivel se conectar ao servidor', mtError, [mbOk], 0 );
        end;
end;

function TFormConnectionConfigurator.pingTest: boolean;
var
    success: boolean;
begin
    success := false;
    try
        if Connection.Connected then
            success := Connection.Ping
        else
            Connection.Connect;
        success := Connection.Ping;
        Connection.Disconnect;

    except
        on E: Exception do {doNothing}
            ;
    end;
    result := success;
end;

procedure TFormConnectionConfigurator.SetConnectionParameters(
    const Value: TConnectionParameters );
begin
    FConnectionParameters := Value;
end;

procedure TFormConnectionConfigurator.initComponents;
begin

    Connection := TZConnection.Create( Self );
    ConnectionParameters := TConnectionParameters.create;

end;

procedure TFormConnectionConfigurator.refresh;
begin

    refreshFields;
    refreshButtons;

end;

procedure TFormConnectionConfigurator.reset;
begin

    ConnectionParameters.read;
    if ConnectionParameters.isNew then
        btnSaveClick( nil );
    refresh;

end;

procedure TFormConnectionConfigurator.refreshButtons;
begin
    if ConnectionParameters.isNew then
        begin
            btnSave.Enabled := true;
            btnRestaurar.Enabled := false;
            btnDefault.Enabled := false;
        end
    else if ConnectionParameters.isDirty then
        begin
            btnSave.Enabled := true;
            btnRestaurar.Enabled := true;
            btnDefault.Enabled := true;
        end
    else
        begin
            btnSave.Enabled := false;
            btnRestaurar.Enabled := false;
            btnDefault.Enabled := true;
        end

end;

procedure TFormConnectionConfigurator.refreshFields;
begin
    cbxProtocol.OnChange := nil;
    edtHostName.OnChange := nil;
    edtPort.OnChange := nil;
    edtDatabase.OnChange := nil;

    cbxProtocol.Text := ConnectionParameters.Protocol;
    edtHostName.Text := ConnectionParameters.HostName;
    edtPort.Text := IntToStr( ConnectionParameters.Port );
    edtDatabase.text := ConnectionParameters.Database;

    cbxProtocol.OnChange := PropertiesChange;
    edtHostName.OnChange := PropertiesChange;
    edtPort.OnChange := PropertiesChange;
    edtDatabase.OnChange := PropertiesChange;

end;

procedure TDataGateway.createDatabaseRecords;
var
    FileNameList: TStrings;
    index: integer;
begin
    FileNameList := listFilePattern( 'C:\Arquivos de programas\DIS-EPM\NutWin-1.6\DefaultData\*.sql' );

    for index := 0 to FileNameList.Count - 1 do
        begin
            executeScript( FileNameList[index] );
            
        end;

end;

function TDataGateway.getConnection: TZConnection;
begin
    if not assigned( Connection ) then
        begin
            result := TZConnection.create( nil );
            result.User := ConnectionParameters.UserName;
            result.Password := ConnectionParameters.Password;
            result.Protocol := ConnectionParameters.Protocol;
            result.HostName := ConnectionParameters.HostName;
            result.Port := ConnectionParameters.Port;
            result.Database := ConnectionParameters.Database;
            ZConnection := result;
        end;
end;

end.


unit ConnectionConfigurator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ZConnection, StdCtrls, ZSqlMonitor, Db, ZAbstractRODataset, ZSqlMetadata,
  ZDataset, ZAbstractDataset, ZAbstractTable, ExtCtrls, GIFImage,
  ZSqlProcessor;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    lblPassword: TLabel;
    lblUserName: TLabel;
    lblDatabase: TLabel;
    lblHostName: TLabel;
    lblProtocol: TLabel;
    lblPort: TLabel;
    edtPassword: TEdit;
    edtUserName: TEdit;
    edtDatabase: TEdit;
    edtHostName: TEdit;
    cbxProtocol: TComboBox;
    edtPort: TEdit;
    btnDefault: TButton;
    btnTest: TButton;
    btnRestaurar: TButton;
    btnSave: TButton;
    Button7: TButton;
    btnCancel: TButton;
    GroupBox2: TGroupBox;
    btnCreateDatabase: TButton;
    lblDataBaseAdv: TLabel;
    Image1: TImage;
    Image2: TImage;
    Shape1: TShape;
    Image3: TImage;
    ZSQLProcessor1: TZSQLProcessor;

    procedure PropertiesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);


    procedure btnRestaurarClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCreateDatabaseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FConnection: TZConnection;
    FInitialProtocol: String;
    FInitialHostname: String;
    FInitialPort: String;
    FInitialDatabase: String;
    FInitialUserName: String;
    FInitialPassword: String;
    FHasInitialConfiguration:boolean;
    FTestSuccessful: boolean;


    property Connection: TZConnection read FConnection write FConnection;
    property InitialProtocol: String read FInitialProtocol write FInitialProtocol;
    property InitialHostname: String read FInitialHostname write FInitialHostname;
    property InitialPort: String read FInitialPort write FInitialPort;
    property InitialDatabase: String read FInitialDatabase write FInitialDatabase;
    property InitialUserName: String read FInitialUserName write FInitialUserName;
    property InitialPassword: String read FInitialPassword write FInitialPassword;
    property HasInitialConfiguration: boolean read FHasInitialConfiguration write FHasInitialConfiguration;
    property TestSuccessful: boolean read FTestSuccessful write FTestSuccessful;

    procedure initialParameters;
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

uses Unit2, registry, RegConst2;


{$R *.DFM}

procedure TForm1.initialParameters;
var registry: TRegistry;
    KeyValue: String;
begin
registry:= TRegistry.Create;
registry.RootKey := CFGRoot;

if ( not registry.OpenKey( CFGPath, False) ) then
        begin
        MessageDlg('Ocorreu um durante a execução do programa: Configuração Inválida.', mtError, [mbOk], 0);
        close;
        end;


if registry.ValueExists('Connection') then
        HasInitialConfiguration := true
else
        HasInitialConfiguration := false;


if HasInitialConfiguration then
        begin
        KeyValue := registry.ReadString('Connection');
        if registry.OpenKey(KeyValue, false) then
                begin

                InitialProtocol := registry.ReadString('Protocol');
                InitialHostname := registry.ReadString('Hostname');
                InitialPort     := registry.ReadString('Port');
                InitialDatabase := registry.ReadString('Database');
                InitialUserName := registry.ReadString('UserName');
                InitialPassword := registry.ReadString('password');
                btnRestaurarClick(nil);
                btnSave.Enabled := false;


                end
        else
                begin
                HasInitialConfiguration := false;
                end;
        end;

if not HasInitialConfiguration then
        begin
        btnDefaultClick(nil);
        //btnSaveClick(nil);
        btnRestaurar.Enabled := false;

        lblDataBaseAdv.Caption :=
                lblDataBaseAdv.Caption+#13#10#13#10'    Nenhuma conexão foi configurada ainda';
        end
else
        begin
        lblDataBaseAdv.Caption :=
                lblDataBaseAdv.Caption+#13#10'ATENÇÃO:'#13#10'    Esta operação removerá TODOS os dados existentes!';
        end;

TestSuccessful := false;
registry.Destroy;


end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Connection := TZConnection.Create(Self);
initialParameters;


end;



procedure TForm1.PropertiesChange(Sender: TObject);
begin

  Connection.Protocol := Trim(cbxProtocol.Text);
  Connection.HostName := Trim(edtHostName.Text);
//  Connection.Database := Trim(edtDatabase.Text);
  Connection.User := Trim(edtUserName.Text);
  Connection.Password := Trim(edtPassword.Text);
  Connection.Port := StrToInt(Trim(edtPort.Text));

  btnSave.Enabled := true;
  btnDefault.Enabled := true;
  TestSuccessful := false;
  btnCreateDatabase.Enabled := false;
  if HasInitialConfiguration then
        btnRestaurar.Enabled := true;


end;

procedure TForm1.btnDefaultClick(Sender: TObject);
begin
  cbxProtocol.Text := 'mysql';
  edtHostName.Text := 'localhost';
  edtDatabase.Text := 'mynutwin';
  edtUserName.Text := 'root';
  edtPassword.Text := 'masterkey';
  edtPort.Text := '3306';

  PropertiesChange(nil);
  btnDefault.Enabled := false;


end;

procedure TForm1.btnRestaurarClick(Sender: TObject);
begin
  cbxProtocol.Text := InitialProtocol;
  edtHostName.Text := InitialHostname;
  edtDatabase.Text := InitialDatabase;
  edtUserName.Text := InitialUserName;
  edtPassword.Text := InitialPassword;
  edtPort.Text     := InitialPort;
  btnRestaurar.Enabled := false;
end;

procedure TForm1.btnTestClick(Sender: TObject);
var success: boolean;
begin
success := false;
try
        Connection.Connect;
        success := Connection.Ping;
        Connection.Disconnect;

except
        on E: Exception do ;
end;

if success then
        begin
        MessageDlg( 'Conexão realizada com Sucesso', mtInformation, [mbOk], 0);
        TestSuccessful := true;
        end
else
        begin
        MessageDlg( 'Não foi possivel se conectar ao servidor', mtError, [mbOk], 0);
        TestSuccessful := false;
        end;

end;

procedure TForm1.btnSaveClick(Sender: TObject);
var registry: TRegistry;
    KeyValue: String;
begin


if ( TestSuccessful ) or
        (MessageDlg( 'A Conexão não foi testada ou não obteve sucesso.'#13#10'Salvar assim mesmo?',mtConfirmation, mbOKCancel, 0) = mrOk) then
        begin
        btnSave.Enabled := false;
        btnCreateDatabase.Enabled := true;
        end
else
        exit;


registry:= TRegistry.Create;
registry.RootKey := CFGRoot;

if ( not registry.OpenKey( CFGPath, False) ) then
        begin
        MessageDlg('Ocorreu um durante a execução do programa: Configuração Inválida.', mtError, [mbOk], 0);
        close;
        end;

if HasInitialConfiguration then
        begin
        KeyValue := registry.ReadString('Connection');

        if not registry.OpenKey(KeyValue, false) then
                begin
                MessageDlg('Ocorreu um durante a execução do programa: Não foi possível gravar conexão.', mtError, [mbOk], 0);
                close;
                end;
        end
else
        begin
        KeyValue := 'MyNutWin1006000';
        registry.WriteString('Connection',KeyValue);
        if not registry.OpenKey(KeyValue, true) then
                begin
                MessageDlg('Ocorreu um durante a execução do programa: Não foi possível gravar conexão.', mtError, [mbOk], 0);
                close;
                end;

        end;

registry.WriteString('Protocol', Connection.Protocol);
registry.WriteString('Hostname', Connection.HostName);
registry.WriteString('Port', IntToStr(Connection.Port) );
registry.WriteString('Database', trim(edtDatabase.Text));
registry.WriteString('UserName', Connection.User);
registry.WriteString('password', Connection.Password);

registry.CloseKey;

if not registry.OpenKey('\SOFTWARE\ODBC\ODBC.INI\My_NutWin-1.6', false ) then
        begin
        MessageDlg('Ocorreu um durante a execução do programa: Erro na configuração do ODBC.', mtError, [mbOk], 0);
        close;
        end;

registry.WriteString('DATABASE', trim(edtDatabase.Text));
// registry.WriteString('DESCRIPTION', 'NutWin ODBC Data Source');
// registry.WriteString('Driver', 'C:\Arquivos de programas\MySQL\Connector ODBC 5.1\myodbc5.dll');
registry.WriteString('PORT', IntToStr(Connection.Port));
registry.WriteString('PWD', Connection.Password);
registry.WriteString('SERVER', Connection.HostName);
registry.WriteString('UID', Connection.User);

end;

procedure TForm1.btnCreateDatabaseClick(Sender: TObject);
var registry: TRegistry;
    KeyValue: String;
    Query: TZReadOnlyQuery;
    UserName: String;
    DatabaseName: String;
    Password: String;
    stmt:String;
    index: integer;

    SQLProcessor: TZSQLProcessor;
    SearchRec :TSearchRec;
begin
if not TestSuccessful then
        btnTestClick(nil);

if not TestSuccessful then
        begin
        exit;
        end;

Connection.Connect;
Query:= TZReadOnlyQuery.Create(self);
Query.Connection := Connection;

    UserName:= 'NUTRICAO';
    DatabaseName:= Trim(edtDatabase.Text);
    Password := '*C4FA1D6B9185FD0DCD13B990F5489735252CC210';


stmt := format(CREATE_DATABASE_STMT, [DatabaseName]);
Query.SQL.Clear;
Query.SQL.Add(stmt);
Query.ExecSQL;

Connection.Disconnect;
Connection.Database := DatabaseName;
Connection.Connect;



try

stmt := 'select count(1) from mysql.user where user = "'+UserName+'"';
Query.SQL.Clear;
Query.SQL.Add(stmt);
Query.Open;
index := Query.RowsAffected;
Query.Close;

if index < 1 then
        begin
        stmt := format(CREATE_USER_STMT, [UserName, Password]);
        Query.SQL.Clear;
        Query.SQL.Add(stmt);
        Query.ExecSQL;
        end;
except
on E:Exception do ;
end;

try
stmt := format(CREATE_GRANT_STMT, [DatabaseName, UserName]);
Query.SQL.Clear;
Query.SQL.Add(stmt);
Query.ExecSQL;
except
on E:Exception do ;
end;

try
for index := 0 to length(CREATE_STMT_MAP)-1 do
        begin
        stmt := format(DROP_TABLE_STMT, [CREATE_STMT_MAP[index][0]]);
        Query.SQL.Clear;
        Query.SQL.Add(stmt);
        Query.ExecSQL;
        stmt := CREATE_STMT_MAP[index][1];
        Query.SQL.Clear;
        Query.SQL.Add(stmt);
        Query.ExecSQL;

        end;
except
on E:Exception do ;
end;


SQLProcessor:= TZSQLProcessor.Create(self);
SQLProcessor.Connection := Connection;





// NÃO GUARDAR A SENHA
// ACERTAR O TAB ORDER
// ACERTAR AS CHAVES DO REGISTRO

//function DirectoryExists(Name: string): Boolean;
if FindFirst('C:\Arquivos de programas\DIS-EPM\NutWin-1.6\DefaultData\*.sql', faAnyFile, SearchRec) = 0 then
        while FindNext(SearchRec) = 0 do
                begin
                SQLProcessor.LoadFromFile('C:\Arquivos de programas\DIS-EPM\NutWin-1.6\DefaultData\'+SearchRec.Name);
                SQLProcessor.Execute;
                end;
FindClose(SearchRec);


Query.free;
SQLProcessor.free;
Connection.Disconnect;

end;

procedure TForm1.btnCancelClick(Sender: TObject);
begin
exit;
end;

end.

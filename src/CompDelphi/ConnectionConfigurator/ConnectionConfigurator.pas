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
    StdCtrls,
    ComCtrls,
    ExtCtrls,
    Controls,
    GIFImage,
    Graphics,

    Forms,
    Dialogs,

    ConnectionParameters;

type
    TFormConnectionConfigurator = class (TForm)
        Button7: TButton;
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
        GroupBox1: TGroupBox;
        Label1: TLabel;
        lblStatusSvc: TLabel;
        Label3: TLabel;
        btnChkSvcStatus: TButton;
        lblNameSvc: TLabel;
        Label2: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;

        procedure PropertiesChange (Sender: TObject) ;
        procedure FormCreate (Sender: TObject) ;
        procedure btnDefaultClick (Sender: TObject) ;

        procedure btnRestaurarClick (Sender: TObject) ;
        procedure btnTestRootClick (Sender: TObject) ;
        procedure btnSaveClick (Sender: TObject) ;
        procedure btnCreateDatabaseClick (Sender: TObject) ;
        procedure edtPasswordChange (Sender: TObject) ;
        procedure btnTestUserClick (Sender: TObject) ;
        procedure btnChkSvcStatusClick (Sender: TObject) ;
        procedure LinkTo (Sender: TObject) ;
    procedure Button7Click(Sender: TObject);
    private
        procedure SetConnectionParameters (const Value: TConnectionParameters) ;
        procedure refresh;
        procedure refreshFields;
        procedure refreshButtons;
        procedure reset;
        procedure initComponents;
        function pingTest: boolean;
        procedure CreateNotifyEvent (Description: string; progress: integer) ;
    private
        { Private declarations }
        FConnectionParameters: TConnectionParameters;
        property ConnectionParameters: TConnectionParameters read FConnectionParameters write SetConnectionParameters;

    public
        { Public declarations }
        class procedure Execute;

    end;

var
    FormConnectionConfigurator: TFormConnectionConfigurator;

implementation

uses
    DataGateway,
    services,
    SHELLAPI;

{$R *.DFM}

{ TForm1 }

procedure TFormConnectionConfigurator.FormCreate (Sender: TObject) ;
begin
    initComponents;
    reset;

end;

procedure TFormConnectionConfigurator.PropertiesChange (Sender: TObject) ;
begin
    ConnectionParameters.Database := edtDatabase.text;
    ConnectionParameters.HostName := edtHostName.text;
    ConnectionParameters.Protocol := cbxProtocol.text;
    if length (edtPort.text) = 0 then
        ConnectionParameters.Port := 0
    else
        ConnectionParameters.Port := StrToInt (edtPort.text) ;
    refreshButtons;
end;

procedure TFormConnectionConfigurator.btnDefaultClick (Sender: TObject) ;
begin
    ConnectionParameters.setDefault;
    refresh;
    btnDefault.enabled := false;
end;

procedure TFormConnectionConfigurator.btnRestaurarClick (Sender: TObject) ;
begin

    reset;
    btnRestaurar.Enabled := false;
end;

procedure TFormConnectionConfigurator.btnTestRootClick (Sender: TObject) ;
var
    success: boolean;
    SavedDatabase:String;
begin
    ConnectionParameters.UserName := edtUserName.Text;
    ConnectionParameters.Password := edtPassword.Text;
    SavedDatabase := ConnectionParameters.Database;
    ConnectionParameters.Database := '';

    success := pingTest;

    ConnectionParameters.Database := SavedDatabase;

    if success then
        begin
            MessageDlg ('Conexão realizada com Sucesso', mtInformation, [mbOk], 0) ;
        end
    else
        begin
            MessageDlg ('Não foi possivel se conectar ao servidor', mtError, [mbOk], 0) ;
        end;
end;

procedure TFormConnectionConfigurator.btnSaveClick (Sender: TObject) ;
begin

    ConnectionParameters.write;

    refreshButtons;
end;

procedure TFormConnectionConfigurator.btnCreateDatabaseClick (Sender: TObject) ;
var

    DataGateway: TDataGateway;
begin

    if MessageDlg ('Esta operação substituirá a base de dados existentes pela base de dados inicial do sistema.'#13#10 +
        'Todos os dados do sistema serão removidos.'#13#10#13#10'Deseja continuar?', mtWarning, [mbYes, mbNo], 0) <> mrYes then
        exit;

    ConnectionParameters.UserName := edtUserName.Text;
    ConnectionParameters.Password := edtPassword.Text;
    PageControl1.Enabled := false;
    Button7.Enabled := false;
        Screen.Cursor := crHourGlass;
        Application.ProcessMessages;
    DataGateway := TDataGateway.create (ConnectionParameters) ;
    try

        DataGateway.createDatabaseSchema;

        lblDataBaseAdv.Caption := 'Criando Usuário';
        Application.ProcessMessages;
        DataGateway.createDatabaseUser;

        lblDataBaseAdv.Caption := 'Criando Tabelas';
        Application.ProcessMessages;

        DataGateway.createDatabaseTables;

        lblDataBaseAdv.Caption := 'Criando Registros';
        Application.ProcessMessages;
        DataGateway.onExecute := CreateNotifyEvent;
        ProgressBar1.Visible := true;
        DataGateway.createDatabaseRecords;



        lblDataBaseAdv.Caption := 'Concluido';
        btnCreateDatabase.Enabled := false;



    finally
        ConnectionParameters.read;
        DataGateway.Free;
        PageControl1.Enabled := true;
         Button7.Enabled := true;
        Screen.Cursor := crDefault;
    end;

end;

procedure TFormConnectionConfigurator.edtPasswordChange (Sender: TObject) ;
begin
    btnTestRoot.Enabled :=
        (length (edtPassword.Text) > 0) and (length (edtUserName.Text) > 0) ;
    btnCreateDatabase.Enabled := btnTestRoot.Enabled;

end;

procedure TFormConnectionConfigurator.btnTestUserClick (Sender: TObject) ;
var
    success: boolean;
begin

    ConnectionParameters.UserName := 'NUTRICAO';
    ConnectionParameters.Password := 'NUTRICAO';
    

    success := pingTest;

    if success then
        begin
            MessageDlg ('Conexão realizada com Sucesso', mtInformation, [mbOk], 0) ;
        end
    else
        begin
            MessageDlg ('Não foi possivel se conectar ao servidor', mtError, [mbOk], 0) ;
        end;
end;

function TFormConnectionConfigurator.pingTest: boolean;
var

    DataGateway: TDataGateway;
begin

    DataGateway := TDataGateway.create (ConnectionParameters) ;

    result := DataGateway.pingConnection;

    DataGateway.Free;

end;

procedure TFormConnectionConfigurator.SetConnectionParameters (
    const Value: TConnectionParameters) ;
begin
    FConnectionParameters := Value;
end;

procedure TFormConnectionConfigurator.initComponents;
begin

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
        btnSaveClick (nil) ;
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
    else
        if ConnectionParameters.isDirty then
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
    edtPort.Text := IntToStr (ConnectionParameters.Port) ;
    edtDatabase.text := ConnectionParameters.Database;

    cbxProtocol.OnChange := PropertiesChange;
    edtHostName.OnChange := PropertiesChange;
    edtPort.OnChange := PropertiesChange;
    edtDatabase.OnChange := PropertiesChange;

end;

procedure TFormConnectionConfigurator.btnChkSvcStatusClick (Sender: TObject) ;
var
    ServiceCurrState: TServiceCurrState;
begin
//StopSvc('MySql', '');
//StartSvc('MySql', '');

    try
        ServiceCurrState := StatusSvc ('MySql', '') ;
    except
    end;

    case ServiceCurrState of

        scsStopped:
            lblStatusSvc.Caption := 'Parado';
        scsStarting:
            lblStatusSvc.Caption := 'Iniciando';
        scsStopping:
            lblStatusSvc.Caption := 'Parando';
        scsRunning:
            lblStatusSvc.Caption := 'Executando';
        scsContinuePending:
            lblStatusSvc.Caption := 'Pendente';
        scsPausing:
            lblStatusSvc.Caption := 'Pausando';
        scsPaused:
            lblStatusSvc.Caption := 'Pausado';
        else
            lblStatusSvc.Caption := 'Não encontrado';
    end;
end;

procedure TFormConnectionConfigurator.CreateNotifyEvent (
    Description: string; progress: integer) ;
begin
    lblDataBaseAdv.Caption := Description;
    ProgressBar1.Position := progress;
    Application.ProcessMessages;
end;

procedure TFormConnectionConfigurator.LinkTo (Sender: TObject) ;
begin
    if (Sender is TControl) then
        with (Sender as TControl) do
            ShellExecute (Application.Handle,
                PChar ('open') ,
                PChar (Hint) ,
                PChar (0) ,
                nil,
                SW_NORMAL) ;

end;

class procedure TFormConnectionConfigurator.Execute;
var
    FormConnectionConfigurator: TFormConnectionConfigurator;
begin
    FormConnectionConfigurator := TFormConnectionConfigurator.Create (application) ;

    FormConnectionConfigurator.ShowModal;
    FormConnectionConfigurator.free;
end;

procedure TFormConnectionConfigurator.Button7Click(Sender: TObject);
begin
close;
end;

end.


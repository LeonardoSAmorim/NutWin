program ConnectionConfiguratorTest;

uses
  Forms,
  ConnectionConfigurator in 'ConnectionConfigurator.pas' {FormConnectionConfigurator},
  SQL_STMT in 'SQL_STMT.pas',
  RegConst2 in '..\Calculo\RegConst2.pas',
  Services in '..\servicos\Services.pas',
  ConnectionParameters in 'ConnectionParameters.pas',
  DataGateway in 'DataGateway.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
    Application.Initialize;
//  Application.CreateForm(TFormConnectionConfigurator, FormConnectionConfigurator);
    Application.CreateForm(TForm1, Form1);
  Application.Run;
end.


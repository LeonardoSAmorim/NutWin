program ConnectionConfiguratorTest;

uses
  Forms,
  ConnectionConfigurator in 'ConnectionConfigurator.pas' {Form1},
  Unit2 in 'Unit2.pas',
  RegConst2 in '..\Calculo\RegConst2.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

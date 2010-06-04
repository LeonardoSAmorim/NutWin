program ConnectionConfiguratorTest;

uses
  Forms,
  ConnectionConfigurator in 'ConnectionConfigurator.pas' {FormConnectionConfigurator},
  Unit2 in 'Unit2.pas',
  RegConst2 in '..\Calculo\RegConst2.pas',
  ConnectionParameters in 'ConnectionParameters.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormConnectionConfigurator, FormConnectionConfigurator);
  Application.Run;
end.

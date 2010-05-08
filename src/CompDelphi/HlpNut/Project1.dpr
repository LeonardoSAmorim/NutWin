program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {fmMenu},
  HtmlHlp in 'HtmlHlp.pas',
  hhcomponent in 'hhcomponent.pas',
  Unit2 in 'Unit2.pas' {fmPlanoAlimentar},
  dmHelp in 'dmHelp.pas' {dmHlp: TDataModule},
  fmCadHelp in 'fmCadHelp.pas' {fmCadHlp};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdmHlp, dmHlp);
  Application.CreateForm(TfmMenu, fmMenu);
  Application.CreateForm(TfmCadHlp, fmCadHlp);
  Application.Run;
end.

program PValidade;

uses
  Forms,
  Registro in 'Registro.pas' {fmRegistro},
  dmValidade in 'dmValidade.pas' {dmValida: TDataModule},
  Validade in 'Validade.pas' {fmValidade};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdmValida, dmValida);
  Application.CreateForm(TfmValidade, fmValidade);
  Application.Run;
end.

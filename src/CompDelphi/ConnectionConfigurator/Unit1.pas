unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ConnectionConfigurator,DataGateway,ConnectionParameters;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin


TFormConnectionConfigurator.Execute;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if TDataGateway.testConfiguration then
        showmessage('success')
else
        showmessage('fail');
end;

end.

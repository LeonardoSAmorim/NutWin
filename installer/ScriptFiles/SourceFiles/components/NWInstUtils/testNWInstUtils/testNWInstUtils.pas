unit testNWInstUtils;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
Function Testa_NS(LsSerial,LsSistema,LsVersao: PAnsiChar): Integer;stdcall;
external '..\NWInstUtils.dll';

procedure TForm1.Button1Click(Sender: TObject);
begin

showMessage(IntToStr(Testa_NS(PAnsiChar(Edit1.Text),PAnsiChar('NU'),PAnsiChar('01'))));

end;




end.

unit ErrorReport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GIFImage, ExtCtrls, StdCtrls;

type
  TFormErrorReport = class(TForm)
    Shape1: TShape;
    Image2: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Button1: TButton;
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormErrorReport: TFormErrorReport;

implementation
uses shellapi;
{$R *.DFM}

procedure TFormErrorReport.Label1Click(Sender: TObject);
begin
If (Sender is TLabel) then
  with (Sender as Tlabel) do
 ShellExecute(Application.Handle,
             PChar('open'),
             PChar(Hint),
             PChar(0),
             nil,
             SW_NORMAL);


end;

end.

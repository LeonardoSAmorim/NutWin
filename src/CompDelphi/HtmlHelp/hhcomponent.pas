{*******************************************************}
{                                                       }
{       hhcomponent.pas                                 }
{       THtmlHelp component                             }
{       Drop on your form to work                       }
{                                                       }
{       But you must create a .chm file                 }
{       To build this file use the Microsoft tools at   }
{       http://msdn.microsoft.com/library/              }
{       tools/htmlhelp/chm/HH1Start.htm                 }
{                                                       }
{       Author: Toni Martir                             }
{       email: techni-web@pala.com                      }
{       http://www.serveisgirona.com/delphi             }
{                                                       }
{       This file is under MPL license:                 }
{       You can use it on commercial applications       }
{       but this component an his enhacements           }
{       must be allways public                          }
{*******************************************************}

unit hhcomponent;

interface

uses Classes,Windows,htmlhlp,forms,sysutils,axctrls;

type

  THtmlHelpContextEvent = procedure (Sender: TObject; var Data : Longint) of object;

  THtmlHelp = class(TComponent)
  private
    FOldHelpEvent: THelpEvent;
    FChmFile: String;
    FWinDef: String;
    FDefaultFile:Boolean;
    FOnHtmlHelpContext: THtmlHelpContextEvent;
    function HelpFunc(Command : Word; Data : Longint; Var CallHelp : Boolean) : Boolean;
    procedure SetDefaultFile(value:boolean);
    function GetHHString(Topic: String): String;
    procedure SetOnHtmlHelpContext(const Value: THtmlHelpContextEvent);
  protected
   procedure Loaded;override;
  public
   constructor Create(AOwner:TComponent);override;
   destructor Destroy; override;

   function HelpContext(ContextId: DWord): Integer;
   function HelpTopic(Topic: String): Integer;
   function ShowIndex:integer;
   function ShowTableofContents:integer;
   function ShowSearch:integer;
  published
   property ChmFile:string read FChmFile write fChmFile;
   property WinDef:string read FWindef write fWindef;
   property DefaultFile:Boolean read FDefaultFile write SetDefaultFile default true;
   property OnHtmlHelpContext : THtmlHelpContextEvent read FOnHtmlHelpContext write SetOnHtmlHelpContext;
  end;

procedure Register;

implementation


constructor THTMLHelp.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FChmFile := '';
  FWinDef := '';
  FDefaultFile:=True;

  FOldHelpEvent := Application.OnHelp;
  if not (csdesigning in ComponentState) then
   Application.OnHelp := HelpFunc;
end;

destructor THTMLHelp.Destroy;
begin
  Application.OnHelp := FOldHelpEvent;
  inherited destroy;
end;

function THtmlHelp.getHHString(Topic: String): String;
begin
 Result:=ChmFile;
 if Length(Topic)>0 then
 begin
  result := result+'::' +topic;
 end;
 if Length(WinDef)>0 then
  result := result + '>' + WinDef;
end;

function THTMLHelp.HelpFunc(Command : Word; Data : Longint; Var CallHelp : Boolean) : Boolean;
begin
 if Assigned(FOnHtmlHelpContext) then
    FOnHtmlHelpContext( self, Data );
 CallHelp := False;
 if (Command in [Help_Context, Help_ContextPopup]) then
 begin
  CallHelp := false;
  HelpContext( Data );
 end
 else
 begin
  if Command=HELP_Finder then
  begin
   HtmlHelp(Screen.ActiveForm.handle, PChar(GetHHString('')), HH_DISPLAY_TOC, 0);
  end;
 end;
 result := true;
end;

procedure THTMLHelp.SetDefaultFile(value:boolean);
begin
 if value then
 begin
  FChmFile:='';
 end;
 FDefaultFile:=Value;
end;

procedure THTMLHelp.Loaded;
begin
 inherited Loaded;
 if not (csdesigning in componentstate) then
 begin
  if FDefaultFile then
  begin
   FChmFile:=application.helpfile;
   if ExtractFilePath(FChmFile)='' then
   begin
    FChmFile:=ExtractFilePath(Application.Exename)+FChmFile;
   end;
  end;
 end;
end;

function THTMLHelp.HelpContext(ContextId: DWord): Integer;
begin
 Result:=HtmlHelp(Screen.ActiveForm.handle, PChar(GetHHString('')), HH_HELP_CONTEXT, ContextID);
end;

function THTMLHelp.HelpTopic(Topic: String): Integer;
begin
 Result:=HtmlHelp(Screen.ActiveForm.handle, PChar(GetHHString(Topic)), HH_DISPLAY_TOPIC, 0);
end;

function THTMLHelp.ShowIndex:integer;
begin
 Result:=HtmlHelp(Screen.ActiveForm.handle, PChar(GetHHString('')), HH_DISPLAY_INDEX, 0);
end;

function THTMLHelp.ShowTableofContents:integer;
begin
 Result:=HtmlHelp(Screen.ActiveForm.handle, Pchar(GetHHString('')), HH_DISPLAY_TOC, 0);
end;

function THTMLHelp.ShowSearch:integer;
var
 q:THHFTSQUERY;
begin
 q.cbStruct:=sizeof(q);
 q.fUniCodeStrings:=false;
 q.pszSearchQuery:=nil;
 q.iProximity:=HH_FTS_DEFAULT_PROXIMITY;
 q.fStemmedSearch   := FALSE ;
 q.fTitleOnly       := FALSE ;
 q.fExecute         := True ;
 q.pszWindow        := nil ;


 Result:=HtmlHelp(Screen.ActiveForm.handle, PChar(GetHHString('')), HH_DISPLAY_SEARCH, DWord(@q));
end;

procedure THtmlHelp.SetOnHtmlHelpContext(
  const Value: THtmlHelpContextEvent);
begin
  FOnHtmlHelpContext := Value;
end;

procedure Register;
begin
 RegisterComponents('HTML Help', [THTMLHelp]);
end;

end.

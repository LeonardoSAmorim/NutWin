{*******************************************************}
{                                                       }
{       Delphi Visual Component Library                 }
{       Composite Components Pack (CCPack)              }
{                                                       }
{       Copyright (c) 1997-99 Sergey Orlik              }
{                                                       }
{     Written by:                                       }
{       Sergey Orlik                                    }
{       product manager                                 }
{       Russia, C.I.S. and Baltic States (former USSR)  }
{       Inprise Moscow office                           }
{       Internet:  sorlik@inprise.ru                    }
{       www.geocities.com/SiliconValley/Way/9006/       }
{                                                       }
{*******************************************************}
{$I BOXDEF.INC}

{$IFDEF VER_CB}
  {$ObjExportAll On}
{$ENDIF}

{$Warnings Off}

unit BoxExpt;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Menus,
  ComCtrls, ExtCtrls, StdCtrls,
  DsgnIntf, ExptIntf, ToolIntf, EditIntf, VirtIntf, TypInfo, Boxes;

type
  { TBoxExpert }

  TBoxExpert = class(TIExpert)
  public
    function GetName: string; override;
    function GetComment: string; override;
    function GetGlyph: HICON; override;
    function GetStyle: TExpertStyle; override;
    function GetState: TExpertState; override;
    function GetIDString: string; override;
    function GetAuthor: string; override;
    function GetPage: string; override;
    procedure Execute; override;
  end;

  TNewBoxDlg = class(TForm)
    Bevel1: TBevel;
    BtnCancel: TButton;
    BtnCreate: TButton;
    Label1: TLabel;
    Label2: TLabel;
    EdClass: TEdit;
    EdPage: TComboBox;
    Label3: TLabel;
    EdAncestor: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure ClassChange(Sender: TObject);
  end;

var
  NewBoxDlg: TNewBoxDlg;

procedure Register;

implementation

{$R *.DFM}
{$R *.RES}

const
  CRLF = #13#10;
  CRLF2 = #13#10#13#10;
  DefaultModuleFlags = [cmShowSource, cmShowForm, cmMarkModified, cmUnNamed];

  { kind of box}
  bkBox = 0;
  bkControlGroupBox = 1;
  bkControlScrollBox = 2;
  bkToolBarBox = 3;

  BoxKind : array[0..3] of string
          = ('Box','ControlGroupBox','ControlScrollBox',
             'ToolBarBox');

  { initial size parameters for boxes }
  isBoxWidth : integer = 300;
  isBoxHeight : integer = 200;
  isToolBarBoxWidth : integer = 500;   
  isToolBarBoxHeight : integer = 52; 

resourcestring
  sBoxExpertAuthor = 'Sergey Orlik';
  sBoxExpertName   = 'Composite Component';
  sBoxExpertDesc   = 'Creates a new composite component';

{ TBoxModuleCreator }

type
  {$IFDEF VER_VCL4}
  TBoxModuleCreator = class(TIModuleCreatorEx)
  {$ELSE}
  TBoxModuleCreator = class(TIModuleCreator)
  {$ENDIF}
  private
    FClass   : string;
    FPage    : string;
    FBoxKind : integer;
  public
    function Existing: Boolean; override;
    function GetFileName: string; override;
    function GetFileSystem: string; override;
    function GetFormName: string; override;
    function GetAncestorName: string; override;
  {$IFNDEF VER100}
    {$IFDEF VER_CB}
    function GetIntfName: string; override;
    function NewIntfSource(const UnitIdent, FormIdent,
      AncestorIdent: string): string; override;
    {$ENDIF}
    function NewModuleSource(const UnitIdent, FormIdent,
      AncestorIdent: string): string; override;
  {$ELSE}
    function NewModuleSource(UnitIdent, FormIdent,
      AncestorIdent: string): string; override;
  {$ENDIF}
    procedure FormCreated(Form: TIFormInterface); override;
  end;

function TBoxModuleCreator.Existing: boolean;
begin
  Result:=False;
end;

function TBoxModuleCreator.GetFileName:string;
begin
  Result:='';
end;

function TBoxModuleCreator.GetFileSystem:string;
begin
  Result:='';
end;

function TBoxModuleCreator.GetFormName:string;
var
  s : string;
begin
  s:=FClass;
  if s<>EmptyStr then
    System.Delete(s,1,1);
  Result:=s;
end;

function TBoxModuleCreator.GetAncestorName:string;
begin
  Result:=BoxKind[FBoxKind];
end;

{$IFDEF VER_CB}
function UnitName2Namespace(const Value:string):string;
var
  s1,s2 : string;
begin
  s1:=Value[1];
  s2:=LowerCase(Value);
  System.Delete(s2,1,1);
  Result:=UpperCase(s1)+s2;
end;

function TBoxModuleCreator.GetIntfName: string;
begin
  Result:='';
end;

function TBoxModuleCreator.NewIntfSource(const UnitIdent, FormIdent,
      AncestorIdent: string): string;
begin
  Result:='//---------------------------------------------------------------------------'+
      CRLF+
      '#ifndef '+UnitIdent+'H'+CRLF+
      '#define '+UnitIdent+'H'+CRLF+
      '//---------------------------------------------------------------------------'+
      CRLF+
      '#include <SysUtils.hpp>'+CRLF+
      '#include <Classes.hpp>'+CRLF+
      '#include <Controls.hpp>'+CRLF+
      '#include <StdCtrls.hpp>'+CRLF+
      '#include <Forms.hpp>'+CRLF+
      '#include "Boxes.hpp"'+CRLF+
      '//---------------------------------------------------------------------------'+
      CRLF;

  if FClass<>EmptyStr then
    Result:=Result+
      'class '+FClass
  else
    Result:=Result+
      'class T'+FormIdent;

    Result:=Result+' : public T'+BoxKind[FBoxKind]+CRLF+
      '{'+CRLF+
      '__published:     // IDE-managed Components'+CRLF;

    Result:=Result+
      'private:         // User declarations'+CRLF+
      'protected:       // User declarations'+CRLF+
      'public:          // User declarations'+CRLF;

  if FClass<>EmptyStr then
    Result:=Result+
      '        __fastcall '+FClass+'(TComponent* Owner);'+CRLF
  else
    Result:=Result+
      '        __fastcall T'+FormIdent+'(TComponent* Owner);'+CRLF;

    Result:=Result+
      '__published:     // User declarations'+CRLF;
      
  if not (FBoxKind in [bkToolBarBox]) then
    Result:=Result+
      '    __property Align;'+CRLF;

    Result:=Result+
      '};'+CRLF+
      '//---------------------------------------------------------------------------'+
      CRLF+
      '#endif';
end;

function TBoxModuleCreator.NewModuleSource(const UnitIdent, FormIdent,
      AncestorIdent: string): string;
begin
  Result:=
     '//---------------------------------------------------------------------------'+
     CRLF+
     '#include <vcl.h>'+CRLF+
     '#pragma hdrstop'+CRLF2+
     '#include "'+UnitIdent+'.h"'+CRLF+
     '//---------------------------------------------------------------------------'+
     CRLF+
     '#pragma package(smart_init)'+CRLF+
     '#pragma resource "*.dfm"'+CRLF+
     '//---------------------------------------------------------------------------'+
     CRLF+
     '// ValidCtrCheck is used to assure that the components created do not have'+CRLF+
     '// any pure virtual functions.'+CRLF+
     '//'+CRLF+
     'static inline void ValidCtrCheck(T'+FormIdent+' *)'+CRLF+
     '{'+CRLF+
     '        new T'+FormIdent+'(NULL);'+CRLF+
     '}'+CRLF+
     '//---------------------------------------------------------------------------'+
     CRLF+
     '__fastcall T'+FormIdent+'::T'+FormIdent+'(TComponent* Owner)'+CRLF+
     '        : T'+BoxKind[FBoxKind]+'(Owner)'+CRLF+
     '{'+CRLF+
     '}'+CRLF+
     '//---------------------------------------------------------------------------'+
     CRLF;                                             

  if FPage<>EmptyStr then
    Result:=Result+
     'namespace '+UnitName2Namespace(UnitIdent)+CRLF+
     '{'+CRLF+
     '        void __fastcall PACKAGE Register()'+CRLF+
     '        {'+CRLF+
     '                 TComponentClass classes[1] = {__classid(T'+FormIdent+')};'+CRLF+
     '                 RegisterComponents("'+FPage+'", classes, 0);'+CRLF+
     '        }'+CRLF+
     '}'+CRLF+
     '//---------------------------------------------------------------------------'+
     CRLF;
end;
{$ELSE}
  {$IFDEF VER100}
function TBoxModuleCreator.NewModuleSource(UnitIdent,FormIdent,AncestorIdent:string):string;
  {$ELSE}
function TBoxModuleCreator.NewModuleSource(const UnitIdent,FormIdent,AncestorIdent:string):string;
  {$ENDIF}
begin
    Result:='unit '+UnitIdent+';'+CRLF2+
      'interface'+CRLF2+
      'uses'+CRLF+
      '  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,'+CRLF+
      '  Boxes, ExtCtrls, StdCtrls, ComCtrls;'+CRLF2+
      'type'+CRLF;

  if FClass<>EmptyStr then
    Result:=Result+'  '+FClass
  else
    Result:=Result+'  T'+FormIdent;

    Result:=Result+' = class(T'+BoxKind[FBoxKind]+')'+CRLF+
      '  private'+CRLF+
      '    { Private declarations }'+CRLF+
      '  protected'+CRLF+
      '    { Protected declarations }'+CRLF+
      '  public'+CRLF+
      '    { Public declarations }'+CRLF+
      '  published'+CRLF+
      '    { Published declarations }'+CRLF;

  if not (FBoxKind in [bkToolBarBox]) then
    Result:=Result+
      '    property Align;'+CRLF;

    Result:=Result+
      '  end;'+CRLF2;

  if FPage<>EmptyStr then Result:=Result+
      'procedure Register;'+CRLF2;

    Result:=Result+
      'implementation'+CRLF2+
      '{$R *.DFM}'+CRLF2;

  if FPage<>EmptyStr then
  begin
    Result:=Result+
      'procedure Register;'+CRLF+
      'begin'+CRLF+
      '  RegisterComponents('''+FPage+''',[';

    if FClass<>EmptyStr then
      Result:=Result+FClass
    else
      Result:=Result+'T'+FormIdent;

      Result:=Result+']);'+CRLF+
      'end;'+CRLF2;
  end;

    Result:=Result+
      'end.'+CRLF;
end;
{$ENDIF}

procedure TBoxModuleCreator.FormCreated(Form:TIFormInterface);
var
  Comp: TIComponentInterface;
begin
  Comp:=Form.GetFormComponent;
  if FBoxKind=bkToolBarBox then
    begin
      Comp.SetPropByName('Height',isToolBarBoxHeight);
      Comp.SetPropByName('Width',isToolBarBoxWidth);
    end
  else
    begin
      Comp.SetPropByName('Height',isBoxHeight);
      Comp.SetPropByName('Width',isBoxWidth);
    end;  
  Comp.Free;
  Form.Free;
end;

{ HandleException }

procedure HandleException;
begin
  ToolServices.RaiseException(ReleaseException);
end;

{ BoxExpert }

procedure BoxExpert(ToolServices: TIToolServices);
var
  IModuleCreator : TBoxModuleCreator;
  IModule : TIModuleInterface;
begin
  NewBoxDlg:=TNewBoxDlg.Create(Application);
  if NewBoxDlg.ShowModal=mrCancel then
  begin
    NewBoxDlg.Free;
    Exit;
  end;
  IModuleCreator:=TBoxModuleCreator.Create;
  IModuleCreator.FBoxKind:=NewBoxDlg.EdAncestor.ItemIndex;
  IModuleCreator.FClass:=NewBoxDlg.EdClass.Text;
  if IModuleCreator.FClass[1]<>'T' then
    IModuleCreator.FClass:='T'+IModuleCreator.FClass;
  IModuleCreator.FPage:=NewBoxDlg.EdPage.Text;
  try
    {$IFDEF VER_CB}
    IModule:=ToolServices.ModuleCreateEx(IModuleCreator,DefaultModuleFlags);
    {$ELSE}
    IModule:=ToolServices.ModuleCreate(IModuleCreator,DefaultModuleFlags);
    {$ENDIF}
    IModule.Free;
  finally
    IModuleCreator.Free;
    NewBoxDlg.Free;
  end;
end;

{ TBoxExpert }

function TBoxExpert.GetName: string;
begin
  try
    Result := sBoxExpertName;
  except
    HandleException;
  end;
end;

function TBoxExpert.GetComment: string;
begin
  try
    Result := sBoxExpertDesc;
  except
    HandleException;
  end;
end;

function TBoxExpert.GetGlyph: HICON;
begin
  try
    Result := LoadIcon(HInstance, 'NEWBOX');
  except
    HandleException;
  end;
end;

function TBoxExpert.GetStyle: TExpertStyle;
begin
  try
    Result := esForm;
  except
    HandleException;
  end;
end;

function TBoxExpert.GetState: TExpertState;
begin
  try
    Result := [esEnabled];
  except
    HandleException;
  end;
end;

function TBoxExpert.GetIDString: string;
begin
  try
    Result := 'Borland.'+sBoxExpertName;
  except
    HandleException;
  end;
end;

function TBoxExpert.GetAuthor: string;
begin
  try
    Result := sBoxExpertAuthor;
  except
    HandleException;
  end;
end;

function TBoxExpert.GetPage: string;
begin
  try
    Result := 'New';
  except
    HandleException;
  end;
end;

procedure TBoxExpert.Execute;
begin
  try
    BoxExpert(ToolServices);
  except
    HandleException;
  end;
end;

procedure TNewBoxDlg.FormCreate(Sender: TObject);
var
  IDEMainForm : TForm;
  IDEPalTabs  : TTabControl;
  i : integer;
begin
  IDEMainForm:=TForm(Application.MainForm);
  IDEPalTabs:=TTabControl(IDEMainForm.FindComponent('TabControl'));
    for i:=0 to IDEPalTabs.Tabs.Count-1 do
      EdPage.Items.Add(IDEPalTabs.Tabs[i]);
  for i:=0 to High(BoxKind) do
    EdAncestor.Items.Add(BoxKind[i]);
  EdAncestor.ItemIndex:=0;
  EdPage.ItemIndex:=EdPage.Items.IndexOf('Standard');
end;

procedure TNewBoxDlg.ClassChange(Sender: TObject);
begin
  if (EdClass.Text=EmptyStr) or not IsValidIdent(EdClass.Text) then
    BtnCreate.Enabled:=False
  else
    BtnCreate.Enabled:=True;
end;

{ Register }

procedure Register;
begin
  RegisterLibraryExpert(TBoxExpert.Create);
end;

end.

// NutWin - Programa de Apoio a Nutrição(R)
// Copyright (C) 2002-2010 Departamento de Informática em Saúde
// Universidade Federal de São Paulo - UNIFESP <www.unifesp.br>
//
// This file is part of NutWin.
//
// NutWin is free software:  you  can  redistribute  it  and/or
// modify it under the terms of the GNU General Public  License
// as published by the Free Software Foundation, either version
// 3 of the License, or (at your option) any later version.
//
// Nutwin is distributed in the hope that it  will  be  useful,
// but WITHOUT ANY WARRANTY; without even the implied  warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
// the GNU General Public License for more details.
//
// You should have received a copy of the  GNU  General  Public
// License along with Foobar.
// If not, see <http://www.gnu.org/licenses/>.




unit MainFormrtti;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CCSListaLinks, CNSDBSUS, CNSConnect, Conector;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    Edit1: TEdit;
    Add: TButton;
    Clear: TButton;
    Execute: TButton;
    Button1: TButton;
    CNSGrupo1: TCNSGrupo;
    CNSUserName1: TCNSUserName;
    Conector1: TConector;
    procedure AddClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure ExecuteClick(Sender: TObject);
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

Uses TypInfo;

procedure TForm1.AddClick(Sender: TObject);
begin
  ListBox1.Items.Add(Edit1.Text);
end;

procedure TForm1.ClearClick(Sender: TObject);
begin
  ListBox1.Items.Clear;
end;

Procedure ExecuteTFormScript(Instance : TForm; Script : TStringList);
Var
  I,J : Integer;
  S,T : String;
  PI  : PPropInfo;

Begin
  For I := 0 to Script.Count-1 do Begin
    S := Script[I];    { assume exact "property = value" format }
    T := S;
    J := Pos(' = ',S);
    SetLength(S,J-1);
    Delete(T,1,J+2);   { S is left part, T right part }
    PI := GetPropInfo(TypeInfo(TForm),S); { S must be a TForm property name }
    If (PI <> nil) Then Begin
      Case PI^.PropType^.Kind of
        tkInteger,tkChar,
        tkEnumeration      : SetOrdProp(Instance,PI,StrToInt(T));
        tkFloat            : SetFloatProp(Instance,PI,StrToFloat(T));
        tkString,tkLString : SetStrProp(Instance,PI,T);
      End;
    End
    Else ShowMessage('Invalid line: '+Script[I]);
  End;
End;



procedure TForm1.ExecuteClick(Sender: TObject);
begin
  ExecuteTFormScript(Self,TStringList(ListBox1.Items));
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  I,J : Integer;
  S,T, k : String;
  PI  : PPropInfo;

Begin
    S := '';
    T := 'kelvis';
    PI := GetPropInfo(TypeInfo(TCNSUserName),S); { S must be a TForm property name }
    If (PI <> nil) Then
    Begin
      k := GetStrProp(CNSUserName1,PI);
      Case PI^.PropType^.Kind of
        tkInteger,tkChar,
        tkEnumeration      : SetOrdProp(CNSUserName1,PI,StrToInt(T));
        tkFloat            : SetFloatProp(CNSUserName1,PI,StrToFloat(T));
        tkString,tkLString : SetStrProp(CNSUserName1,PI,T);
      End;
    End;
End;

end.

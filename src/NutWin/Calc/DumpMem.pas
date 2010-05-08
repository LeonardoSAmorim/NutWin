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




unit DumpMem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, CalculoViewer,
  CalculoTextViewer;

type
  TDump = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TButton;
    btCalcLog: TButton;
    SpeedButton1: TSpeedButton;
    CalculoTextViewer1: TCalculoTextViewer;
    ListBox1: TListBox;
    RichEdit1: TRichEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btCalcLogClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dump: TDump;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TDump.BitBtn2Click(Sender: TObject);
begin
   self.WindowState := wsMinimized;
end;

procedure TDump.BitBtn1Click(Sender: TObject);
begin
if Assigned( dmMotherBoard.caProcessador.Memoria ) then
  begin
   self.Caption := dmMotherBoard.caProcessador.Memoria.NomeArquivo;
   dmMotherBoard.caProcessador.Memoria.Viewer := ListBox1;
   dmMotherBoard.caProcessador.Memoria.UpdateViewer;
   RichEdit1.Lines := ListBox1.Items;
  end; 
end;

procedure TDump.Button1Click(Sender: TObject);
var
I : Integer;
aux : string;
begin

     RichEdit1.Clear;
     RichEdit1.Lines.Add('------Components-----');
     for i:=0 to Screen.ComponentCount -1 do
         begin
         aux:=Screen.Components[i].ClassName + '= ';
         if (Screen.Components[i]) is TComponent then
            aux:=aux + TComponent(Screen.Components[i]).Name;
         RichEdit1.Lines.Add (aux);
         end;
     RichEdit1.Lines.Add('-------DataModules-----');
     for i:=0 to Screen.DataModuleCount -1 do
         begin
         aux:=Screen.DataModules[i].ClassName + '= ';
         if (Screen.DataModules[i]) is TComponent then
            aux:=aux + TComponent(Screen.DataModules[i]).Name;
         RichEdit1.Lines.Add (aux);
         end;

     RichEdit1.Lines.Add('------CustomForms------');
     for i:=0 to Screen.CustomFormCount  -1 do
         begin
         aux:=Screen.CustomForms[i].ClassName + '= ';
         if (Screen.CustomForms[i]) is TComponent then
            aux:=aux + TComponent(Screen.CustomForms[i]).Name;
         RichEdit1.Lines.Add (aux);
         end;

     RichEdit1.Lines.Add('--------Forms--------');
     for i:=0 to Screen.FormCount   -1 do
         begin
         aux:=Screen.Forms[i].ClassName + '= ';
         if (Screen.Forms[i]) is TComponent then
            aux:=aux + TComponent(Screen.Forms[i]).Name;
         RichEdit1.Lines.Add (aux);
         end;
{     for i:=0 to Screen.CustomFormCount  -1 do
         begin
         if (Screen.CustomForms[i].ClassType = TFormRelatorios ) then
            begin
             TForm(Screen.CustomForms[i]).Release;
             break;
             end;
         end; }
    // if Assigned(xLixo) then xLixo.Free;
    // xLixo:=nil;
     //fmRelAntrop01.Close;
end;

procedure TDump.btCalcLogClick(Sender: TObject);
var
   I : Integer;
begin
    dmMotherBoard.caProcessador.ActiveLog := True;
    RichEdit1.Clear;
    btCalcLog.Caption := 'CalcLog On';
    for I := 0 to dmMotherBoard.caProcessador.Log.Count - 1 do
    begin
       RichEdit1.Lines.Add (dmMotherBoard.caProcessador.Log.Strings[I]);
    end;
end;

procedure TDump.SpeedButton1Click(Sender: TObject);
begin
   CalculoTextViewer1.Execute;
end;

end.

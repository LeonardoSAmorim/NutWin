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




unit fmCadHelp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, Buttons, db, Mask,
  DBCGrids, RXDBCtrl;

type
  TfmCadHlp = class(TForm)
    paCadHelp: TPanel;
    rgEmFoco: TRadioGroup;
    gbTopAjuda: TGroupBox;
    ListBox1: TListBox;
    gbArgAjuda: TGroupBox;
    dgHlpFiles: TDBGrid;
    DBNavigator2: TDBNavigator;
    paAjuda: TPanel;
    DBNavigator1: TDBNavigator;
    spAjuda: TSplitter;
    Panel1: TPanel;
    bbAtrib: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    RxDBGrid1: TRxDBGrid;
    edItemEscolhido: TEdit;
    procedure bbAtribClick(Sender: TObject);
    procedure rgEmFocoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCadHlp: TfmCadHlp;

implementation

uses dmHelp;

{$R *.DFM}

procedure TfmCadHlp.bbAtribClick(Sender: TObject);
var
   TopicText, Texto : String;
   TopicID : Integer;
   Ac : String;
   I : Integer;
begin
   TopicID := 0;
   Texto := ListBox1.Items.Strings[ListBox1.ItemIndex];
   I := 1;
   Ac := '';
   while I <= Length( Texto ) do
   begin
      if Ord(Texto[I]) = 32 then
         Ac := ''
      else if Ord(Texto[I]) = 9 then
      begin
         TopicText := Ac;
         Ac := '';
      end
      else if I = Length( Texto ) then
         TopicID := StrToInt( Trim(Ac + Texto[I]) );
      Ac := Ac + Texto[I];
      Inc(I);
   end;
   with dmHlp.taHlp do
   begin
      if (State <> dsEdit) and (State <> dsInsert) then
         Edit;
      FieldByName( 'TOPICID' ).AsString := rgEmFoco.Items.Strings[rgEmFoco.ItemIndex];
      FieldByName( 'MAP' ).AsInteger := TopicID;
      FieldByName( 'FILEID' ).AsInteger := dmHlp.taHlpFiles.FieldByName( 'FILEID' ).AsInteger ;
      FieldByName( 'TOPICNAME' ).AsString := TopicText;
   end

end;

procedure TfmCadHlp.rgEmFocoClick(Sender: TObject);
begin
   edItemEscolhido.Text := rgEmFoco.Items.Strings[rgEmFoco.itemIndex];
end;

end.

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




unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  hhcomponent, DBTables, Db;

type
  TdmHlp = class(TDataModule)
    HtmlHelp: THtmlHelp;
    taHlp: TTable;
    dsHlp: TDataSource;
    dbHlp: TDatabase;
    taHlpFiles: TTable;
    dsHlpFiles: TDataSource;
    procedure HtmlHelpHtmlHelpContext(Sender: TObject; var Data: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmHlp: TdmHlp;

implementation

{$R *.DFM}

procedure TdmHlp.HtmlHelpHtmlHelpContext(Sender: TObject;
  var Data: Integer);
begin
   if Assigned( Screen.ActiveForm.ActiveControl) and
     ( Screen.ActiveForm.ActiveControl.ClassName = 'TForm2') then
      Data := 101
   else if Assigned( Screen.ActiveForm.ActiveControl) and
     ( Screen.ActiveForm.ActiveControl.Name = 'Edit1') then
      Data := 101
   else if Screen.ActiveForm.Name = 'Form1' then
      Data := 101
   else
      Data := 102;


   with dmPessoa.tbHelp do
    if  Locate( 'NomeDoForm', Screen.ActiveForm.ActiveControl.ClassName, [] ) then
        Data := FieldByName( 'Codigo').AsInteger
    else if Locate( 'NomeDoForm', Screen.ActiveForm.Name, [] ) then
        Data := FieldByName( 'Codigo').AsInteger
    else
       ShowMessage( 'Help não disponível' );

end;

end.

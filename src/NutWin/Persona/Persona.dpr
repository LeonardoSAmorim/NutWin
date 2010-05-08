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




program Persona;

uses
  Forms,
  UPersona in 'UPersona.pas' {Form1},
  qrepform in '..\..\CompDelphi\Calculo\QREPFORM.pas' {FormReport},
  fmTestPersona in 'fmTestPersona.pas' {fmTestePersona},
  RegEdit in '..\..\CompDelphi\regEdit\RegEdit.pas' {DMWinRegKey: TDataModule},
  Person in '..\..\CompDelphi\Calculo\Person.pas',
  Crc2 in '..\..\CompDelphi\Calculo\CRC2.PAS';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  with Form1 do
  begin
     if ParamCount() >=6 then
     begin
      Edit9.Text := ParamStr(1);
      Edit1.Text := ParamStr(2);
      Edit2.Text := ParamStr(3);
      Edit3.Text := ParamStr(4);
      Edit4.Text := ParamStr(5);
      Edit5.Text := ParamStr(6);
     end;
     if ParamCount()= 10 then
     begin
      Edit6.Text := ParamStr(7); //'T';
      Edit7.Text := ParamStr(8); //'30';
      Edit8.Text := ParamStr(9); //'NENHUMA';
      Silent := True;
      Button1Click(nil);
      Form1.Free;
     end
     else
      Application.Run;
  end;
end.

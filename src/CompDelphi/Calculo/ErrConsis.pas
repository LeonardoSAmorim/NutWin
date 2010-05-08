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




unit ErrConsis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,VCLUtils;

type
  TfmErrConsistencia = class(TForm)
    MemoExp: TMemo;
    lbIncons: TLabel;
    btOK: TButton;
    btCancel: TButton;
    btDetail: TButton;
    lbCons: TLabel;
    beLinha: TBevel;
    procedure btDetailClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

procedure TfmErrConsistencia.btDetailClick(Sender: TObject);
begin
if MemoExp.Visible then
   begin
   btDetail.Caption:='Mais Detalhes...';
   MemoExp.Visible:=False;
   CenterWindow(Handle);
   end
else
    begin
    btDetail.Caption:='Menos Detalhes...';
    MemoExp.Visible:=True;
    CenterWindow(Handle);
    end;
end;

procedure TfmErrConsistencia.btOKClick(Sender: TObject);
begin
ModalResult :=mrOK;
end;

procedure TfmErrConsistencia.FormCreate(Sender: TObject);
begin
CenterWindow(Handle);
end;

procedure TfmErrConsistencia.FormShow(Sender: TObject);
begin
// força apertar o botão + detalhes
if MemoExp.Lines.Count > 0 then
   btDetailClick(self);
//else
   btDetail.visible := False;    
end;

end.

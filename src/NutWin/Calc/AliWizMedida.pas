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




unit AliWizMedida;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, DBCtrls, ExtCtrls, ComCtrls, ToolWin, Buttons, DB;

type
  TfmAliWizMedida = class(TForm)
    paWizMedCas: TPanel;
    teNomeAli: TDBText;
    Panel2: TPanel;
    grMedidasCaseiras: TDBGrid;
    bbEmGramas: TBitBtn;
    beListaMed: TBevel;
    procedure grMedidasCaseirasKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure bbEmGramasClick(Sender: TObject);
    procedure bbEmGramasEnter(Sender: TObject);
    procedure bbEmGramasExit(Sender: TObject);
    procedure grMedidasCaseirasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grMedidasCaseirasDblClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAliWizMedida: TfmAliWizMedida;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmAliWizMedida.grMedidasCaseirasKeyPress(Sender: TObject; var Key: Char);
begin
      dmMotherBoard.MedidasCaseiras.Localizar( Key,[loCaseInsensitive,loPartialKey]  );
end;

procedure TfmAliWizMedida.FormShow(Sender: TObject);
begin
   grMedidasCaseiras.SetFocus;
   Tag := 0;  // Qtde Medida
end;

procedure TfmAliWizMedida.bbEmGramasClick(Sender: TObject);
{var
   MyMess : TWMKey;   }
begin
   Tag := 1;  // Peso Alimento
   // Vai para a proxima tela
      dmMotherBoard.AliWiz.Avancar
{   MyMess.Msg :=WM_CHAR;
   MyMess.CharCode :=VK_RETURN;
   Dispatch (MyMess);  }
end;

procedure TfmAliWizMedida.bbEmGramasEnter(Sender: TObject);
begin
   Tag := 1; // Peso Alimento
   bbEmGramas.Font.Color := clRed;
   grMedidasCaseiras.Options := grMedidasCaseiras.Options - [dgAlwaysShowSelection];
end;

procedure TfmAliWizMedida.bbEmGramasExit(Sender: TObject);
begin
   bbEmGramas.Font.Color := clWindowText;
   grMedidasCaseiras.Options := grMedidasCaseiras.Options + [dgAlwaysShowSelection];
end;

procedure TfmAliWizMedida.grMedidasCaseirasKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if ( Key = VK_DOWN ) and grMedidasCaseiras.DataSource.DataSet.Eof then
      bbEmGramas.SetFocus
   else
      Tag := 0;  // Qtde Medida;
end;

procedure TfmAliWizMedida.grMedidasCaseirasDblClick(Sender: TObject);
{var
   MyMess : TWMKey;}
begin
   Tag := 0;  // Qtde Medida
   // Vai para a proxima tela
      dmMotherBoard.AliWiz.Avancar
{   MyMess.Msg :=WM_CHAR;
   MyMess.CharCode :=VK_RETURN;
   Dispatch (MyMess); }
end;

procedure TfmAliWizMedida.FormHide(Sender: TObject);
begin
   dmMotherBoard.mdAliQtde.AsFloat := 0;
   dmMotherBoard.mdAliPeso.AsFloat := 0;
   Click;
end;

end.

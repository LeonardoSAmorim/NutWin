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




unit UAlimApresent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, DBMyNav, Mask, DBCtrls, Grids,
  DBGrids;

type
  TfmAlimApresent = class(TForm)
    pcBotAlim: TPageControl;
    teAlimento: TTabSheet;
    sbNovAlim: TBitBtn;
    sbCanAlim: TBitBtn;
    sbExcAlim: TBitBtn;
    sbAltAlim: TBitBtn;
    sbSalAlim: TBitBtn;
    pcAlimentos: TPageControl;
    teDadosAli: TTabSheet;
    pnAli: TPanel;
    teAliPreparacao: TTabSheet;
    paPrep: TPanel;
    Label11: TLabel;
    Label6: TLabel;
    Label15: TLabel;
    DBGrid2: TDBGrid;
    DBMemo1: TDBMemo;
    DBEdit1: TDBEdit;
    DBMyNav4: TDBMyNav;
    DBMyNav5: TDBMyNav;
    teAliNutrientes: TTabSheet;
    teAliMedidas: TTabSheet;
    teAliSubstitutos: TTabSheet;
    teAliSubsProt: TTabSheet;
    teAliPreco: TTabSheet;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    btLocAlim: TBitBtn;
    btNavAnterior: TBitBtn;
    btNavProximo: TBitBtn;
    btFechar: TBitBtn;
    procedure btLocAlimClick(Sender: TObject);
    procedure sbAltAlimClick(Sender: TObject);
    procedure sbExcAlimClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btFecharClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    Fcontrole: string;
    procedure Setcontrole(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property controle : string read Fcontrole write Setcontrole;
  end;

var
  fmAlimApresent: TfmAlimApresent;

implementation

{$R *.DFM}

{ TfmAlimApresent }

procedure TfmAlimApresent.Setcontrole(const Value: string);
begin
  Fcontrole := Value;
end;

procedure TfmAlimApresent.btLocAlimClick(Sender: TObject);
begin

    Controle := 'Localizar';
    Close;
end;

procedure TfmAlimApresent.sbAltAlimClick(Sender: TObject);
begin
    Controle := 'Localizar';
    Close;
end;

procedure TfmAlimApresent.sbExcAlimClick(Sender: TObject);
begin
    Controle := 'Localizar';
    Close;
end;

procedure TfmAlimApresent.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfmAlimApresent.btFecharClick(Sender: TObject);
begin
    Controle := 'Fechar';
    Close;
end;

procedure TfmAlimApresent.BitBtn1Click(Sender: TObject);
begin
    Controle := 'Inserir';
    Close;
end;

end.

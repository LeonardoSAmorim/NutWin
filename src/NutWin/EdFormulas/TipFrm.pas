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




unit TipFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DBCtrls;

type
  TSelTipo = class(TForm)
    RadioGroup1: TRadioGroup;
    btOk: TButton;
    Button2: TButton;
    edCodigo: TEdit;
    Label1: TLabel;
    edDesc: TEdit;
    Label2: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    Label3: TLabel;
    Label4: TLabel;
    procedure btOkClick(Sender: TObject);
  private
    { Private declarations }
    FTipoEscolhido : integer;
  public
    { Public declarations }
  published
    property TipoEscolhido : integer read FTipoEscolhido write FTipoEscolhido;
  end;

var
  SelTipo: TSelTipo;

implementation

uses DMFrml;

{$R *.DFM}

procedure TSelTipo.btOkClick(Sender: TObject);
begin
TipoEscolhido:=RadioGroup1.ItemIndex;
if DMFormulas.PaisFilhos.Locate('codpai_CNUT;codfilho_CNUT',VarArrayOf([DMFormulas.FlatPai.FieldByName ('cod_CNUT').AsString,edCodigo.Text]),[]) then
   begin
   ShowMessage ('Código Invalido');
   ModalResult:= mrNone;
   end
else
   ModalResult:= mrOk;

end;

end.

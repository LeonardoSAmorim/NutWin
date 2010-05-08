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




unit NutOpc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Buttons;

type
  Tfm_Opcoes = class(TForm)
    pgcOpcoes: TPageControl;
    tbsOpcIndividuos: TTabSheet;
    tbsOpcAlimentos: TTabSheet;
    tbsMenuVisual: TTabSheet;
    rdColorido: TRadioGroup;
    tbsOpcRelatorios: TTabSheet;
    btOk: TBitBtn;
    btCancelar: TBitBtn;
    btAplicar: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rdColoridoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fm_Opcoes: Tfm_Opcoes;

implementation

{$R *.DFM}

// Minhas procedures

Procedure CarregaImagem( Colorido : integer );
begin
     if ( Colorido = 0 )then
        begin
       //    frmMenuVisual.imgRecepcao.Picture.LoadFromFile('RECE256c.BMP');
        end
     else
        begin
         //  frmMenuVisual.imgRecepcao.Picture.LoadFromFile('RECE24b.BMP');
        end;
end;

// Fim das minhas procedures

procedure Tfm_Opcoes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//    Action := caFree;
end;

procedure Tfm_Opcoes.rdColoridoClick(Sender: TObject);
begin
    CarregaImagem( rdColorido.ItemIndex );
end;

end.

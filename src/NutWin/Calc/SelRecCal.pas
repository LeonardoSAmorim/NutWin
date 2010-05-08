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




unit SelRecCal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, PAINELMEDIDA, FnpNumericEdit, Measurement,
  VisorCal, memoria;

type
  TfmSelRecCal = class(TForm)
    paRecCal: TPanel;
    rgRecCalOrigem: TRadioGroup;
    procedure rgRecCalOrigemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmSelRecCal.rgRecCalOrigemClick(Sender: TObject);
var
   mdSelRC : TMedida;
begin
   with dmMotherBoard.caProcessador.Memoria do
      if not Acha('mdSelRecCal', TObject( mdSelRC ) ) then
         ShowMessage( 'Houve um erro na carga do tipo de Recomendação de Energia.' )
      else
         begin
            if mdSelRC.ValorNumerico <> IntToStr( rgRecCalOrigem.ItemIndex ) then
            begin
               if not dmMotherBoard.LimpaRecNut( 'cxRecNut' ) then
                  ShowMessage( 'Houve um erro na inicialização dos nutrientes' );
//@               AddModified;
            end;
            mdSelRC.Descricao := rgRecCalOrigem.Items.Strings[rgRecCalOrigem.ItemIndex];
            mdSelRC.ValorNumerico := IntToStr( rgRecCalOrigem.ItemIndex );
         end;
   if rgRecCalOrigem.ItemIndex = 0 then // Nenhuma
      begin
         Tag := 0;
      end
   else if rgRecCalOrigem.ItemIndex = 1 then // Entrada pelo usuario
      begin
         Tag := 2;
      end
   else if rgRecCalOrigem.ItemIndex = 2 then  // Calcular por
      begin
         Tag := 1;
      end;

   //Refresh do Wizard
   Click;

end;

procedure TfmSelRecCal.FormShow(Sender: TObject);
var
   mdSelRC : TMedida;
begin
   with dmMotherBoard.caProcessador.Memoria do
      if not Acha('mdSelRecCal', TObject( mdSelRC ) ) then
         ShowMessage( 'Não achei a medida: mdSelRecCal' )
      else
         rgRecCalOrigem.ItemIndex := StrToInt( mdSelRC.ValorNumerico );
end;

end.

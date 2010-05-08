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




unit fmInquND;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FnpNumericEdit, FnpNEditBlank, PAINELMEDIDA, ExtCtrls, Wizard;

type
  TfmInqNumDias = class(TForm)
    paNumDias: TPanel;
    laNumDiasInstrucoes: TLabel;
    pmNumDias: TPainelMedida;
    laNumDiasDescricao: TLabel;
    laNumDiasUnidade: TLabel;
    fpNumDiasValor: TFnpNEditBlank;
    pmNomeInquerito: TPainelMedida;
    laNomeInqueritoDescricao: TLabel;
    laNomeInqueritoUnidade: TLabel;
    edNomeInqueritoEntrada: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure VerificaEntradasChange(Sender: TObject);
    procedure edNomeInqueritoEntradaKeyPress(Sender: TObject;
      var Key: Char);
    procedure fpNumDiasValorKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    function PodeAvancar : Boolean;
  end;

var
  fmInqNumDias: TfmInqNumDias;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmInqNumDias.FormCreate(Sender: TObject);
begin
//*   pmNomeInquerito.Medida := dmMotherBoard.CalcInquerito.DescricaoCalculo;
   pmNumDias.Medida := dmMotherBoard.CalcInquerito.DiasDeConsumo;

    // Seta o co-processador de RDA
    with dmMotherBoard do
    begin
       RDA.Memoria := caProcessador.memoria;
       if Assigned( ProcessadorAtual ) then
       begin
          RDA.CaixaRDA := CalcInquerito.CaixaRecNut;
       end;
    end;

end;

procedure TfmInqNumDias.FormShow(Sender: TObject);
begin
//*   edNomeInqueritoEntrada.SetFocus;

   Try
      dmMotherBoard.RDA.CriaRDA;
   except
     on E: Exception do begin
      Tag := WZ_INVALIDNODE;
      Click;
      ShowMessage( E.Message );
      exit;
     end;
   end;

end;

procedure TfmInqNumDias.FormHide(Sender: TObject);
begin
   //Atualizar o valor do TMedida
   //pois este control nao vai perder o foco
//*   pmNomeInquerito.Update;
   pmNumDias.Update;
   // garantir que o valor será considerado para o cálculo, pois o set da medida faz isto
   dmMotherBoard.CalcInquerito.DiasDeConsumo := pmNumDias.Medida ;
   self.Tag:=1 // unico caminho válido
end;

procedure TfmInqNumDias.VerificaEntradasChange(Sender: TObject);
begin
    if PodeAvancar then
       self.Tag := 1
    else
       self.Tag := WZ_INVALIDNODE;
    Click;
end;

function TfmInqNumDias.PodeAvancar: Boolean;
begin
    // as vezes vem em branco ou incompleto
   if ( fpNumDiasValor.Text = '' ) or
      ( fpNumDiasValor.Text = '-' ) then
       begin
          Result := False;
       end
   // preciso de um nome (retirado a pedido da Lilian em 9/7/02) e todos com //* ou {*
{   else if ( edNomeInqueritoEntrada.Text = '' ) then
       begin
          Result := False;
       end  }
   else if ( StrToFloat( fpNumDiasValor.Text ) <= 0 ) then
        begin
          Result := False;
        end
   else
      Result := True;
end;

procedure TfmInqNumDias.edNomeInqueritoEntradaKeyPress(Sender: TObject;
  var Key: Char);
begin
{*   if Key = #27 then
      begin
         dmMotherBoard.Wizard.Cancelar;
         Key := #0;
      end; }
end;

procedure TfmInqNumDias.fpNumDiasValorKeyPress(Sender: TObject;
  var Key: Char);
begin
   if Key = #27 then
      begin
         dmMotherBoard.Wizard.Cancelar;
         Key := #0;
      end
   else if Key = #13 then
      begin
         if PodeAvancar then
            dmMotherBoard.Wizard.Avancar;
         Key := #0;
      end;
end;

end.






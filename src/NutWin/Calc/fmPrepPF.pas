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




unit fmPrepPF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VisorCal, StdCtrls, FnpNumericEdit, FnpNEditBlank, PAINELMEDIDA, ExtCtrls, Wizard;

type
  TfmPrepPesoFinal = class(TForm)
    paPesoFinal: TPanel;
    pmPesoFinal: TPainelMedida;
    laPesoFinalDescricao: TLabel;
    laPesoFinalUnidade: TLabel;
    fpPesoFinalValor: TFnpNEditBlank;
    laPesoFinalInstrucoes: TLabel;
    pmNomePreparacao: TPainelMedida;
    laNomePreparacaoDescricao: TLabel;
    edNomePreparacaoEntrada: TEdit;
    laNomePreparacaoUnidade: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure VerificaEntradasChange(Sender: TObject);
    procedure fpPesoFinalValorKeyPress(Sender: TObject; var Key: Char);
    procedure edNomePreparacaoEntradaKeyPress(Sender: TObject;
      var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    function PodeAvancar : Boolean;
  end;

var
  fmPrepPesoFinal: TfmPrepPesoFinal;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmPrepPesoFinal.FormCreate(Sender: TObject);
begin
   // conecta as propriedades do CalcPreparacao com os paineis medida
   pmNomePreparacao.Medida := dmMotherBoard.CalcPreparacao.DescricaoCalculo;
   pmPesoFinal.Medida := dmMotherBoard.CalcPreparacao.PesoFinal;
   VerificaEntradasChange(Sender);

   // wgb - seta enabled := false se a medida for readonly
   // isto deveria ser automatico
   pmNomePreparacao.EntradaNumerica.Enabled := not pmNomePreparacao.Medida.ReadOnly;

end;

procedure TfmPrepPesoFinal.FormShow(Sender: TObject);
begin
   // seta o foco no primeiro control
   if edNomePreparacaoEntrada.Enabled then
      edNomePreparacaoEntrada.SetFocus
   else
      fpPesoFinalValor.SetFocus;
end;

procedure TfmPrepPesoFinal.FormHide(Sender: TObject);
begin
   //Atualizar o valor do TMedida
   //pois este control nao vai perder o foco
   pmNomePreparacao.Update;
   pmPesoFinal.Update;
   self.Tag:=1; // unico caminho válido
end;

procedure TfmPrepPesoFinal.VerificaEntradasChange(Sender: TObject);
begin
    if PodeAvancar then
       self.Tag := 1
    else
       self.Tag := WZ_INVALIDNODE;
    Click;
end;

procedure TfmPrepPesoFinal.fpPesoFinalValorKeyPress(Sender: TObject;
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

function TfmPrepPesoFinal.PodeAvancar: Boolean;
begin
    // as vezes vem em branco ou incompleto
   if ( fpPesoFinalValor.Text = '' ) or
      ( fpPesoFinalValor.Text = '-' ) then
       begin
          Result := False;
       end
   // preciso de um nome de preparação
   else if ( edNomePreparacaoEntrada.Text = '' ) then
       begin
          Result := False;
       end
   else if ( StrToFloat( fpPesoFinalValor.Text ) <= 0 ) then
        begin
          Result := False;
        end
   else
      Result := True;
end;

procedure TfmPrepPesoFinal.edNomePreparacaoEntradaKeyPress(Sender: TObject;
  var Key: Char);
begin
   if Key = #27 then
      begin
         dmMotherBoard.Wizard.Cancelar;
         Key := #0;
      end;
end;

end.

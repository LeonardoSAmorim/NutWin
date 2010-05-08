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




unit fmPrepVerifPF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FnpNumericEdit, FnpNEditBlank, PAINELMEDIDA, ExtCtrls, Wizard;

type
  TfmVerificaPesoFinal = class(TForm)
    paVerfiPesoFinal: TPanel;
    laPesoFinalInstrucoes: TLabel;
    pmPesoFinal: TPainelMedida;
    laPesoFinalDescricao: TLabel;
    laPesoFinalUnidade: TLabel;
    laPesoFinalValor: TLabel;
    pmPesoPrep: TPainelMedida;
    laPesoPrepDescricao: TLabel;
    laPesoPrepUnidade: TLabel;
    laPesoPrepValor: TLabel;
    pmSaldoPesoFinalPrep: TPainelMedida;
    laSaldoPFPrepDescricao: TLabel;
    laPesoPFPrepUnidade: TLabel;
    laSaldoPFPrepValor: TLabel;
    beTraco1: TBevel;
    pmTotalAgua: TPainelMedida;
    laTotalAguaDescricao: TLabel;
    laTotalAguaUnidade: TLabel;
    laTotalAguaValor: TLabel;
    pmAguaRestante: TPainelMedida;
    laAguaRestanteDescricao: TLabel;
    laAguaRestanteUnidade: TLabel;
    laAguaRestanteValor: TLabel;
    beTraco2: TBevel;
    laPesoFinalObs: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmVerificaPesoFinal: TfmVerificaPesoFinal;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmVerificaPesoFinal.FormCreate(Sender: TObject);
begin
   with dmMotherBoard.CalcPreparacao do
   begin
      pmPesoFinal.Medida := PesoFinal;
      pmPesoPrep.Medida := PesoIngredientes;
      pmSaldoPesoFinalPrep.Medida := SaldoPeso;
      pmTotalAgua.Medida := TotalAgua;
      pmAguaRestante.Medida := AguaRestante;
   end;
end;
{
procedure TfmVerificaPesoFinal.FormShow(Sender: TObject);
var
   Texto : String;
begin
   with dmMotherBoard.CalcPreparacao do
   begin
      if not SaldoPesoValido( Texto ) then
         begin
            TLabel(pmSaldoPesoFinalPrep.EntradaNumerica).Font.Color := clRed;
            laPesoFinalInstrucoes.Font.Color := clRed;
            Self.Tag := WZ_INVALIDNODE;
         end
      else
         begin
             TLabel(pmSaldoPesoFinalPrep.EntradaNumerica).Font.Color := clBlue;
             laPesoFinalInstrucoes.Font.Color := clBlue;
             Self.Tag := 0;
         end;
      Click;
      // Atualiza tela
      pmPesoFinal.Refresh;
      pmPesoPrep.Refresh;
      pmSaldoPesoFinalPrep.Refresh;
      pmTotalAgua.Refresh;
      pmAguaRestante.Refresh;
      laPesoFinalInstrucoes.Caption := Texto;
      laPesoFinalInstrucoes.Update;
   end;
end;
} // mudado a pedido da Lilian em 28/10/2002

procedure TfmVerificaPesoFinal.FormShow(Sender: TObject);
var
   Texto : String;
begin
   with dmMotherBoard.CalcPreparacao do
   begin
      SaldoPesoValido( Texto );
      if  pmPesoFinal.Medida.AsFloat > pmPesoPrep.Medida.AsFloat then
      begin
          Texto := 'ATENÇÃO: o Peso Final desta preparação é maior que o ' +
                   'Peso dos Ingredientes. Se estiver certo disto, prossiga ' +
                   'clicando em avançar.';
            laPesoFinalInstrucoes.Font.Color := clRed;
      end
      else if  pmPesoFinal.Medida.AsFloat < pmPesoPrep.Medida.AsFloat then
      begin
          Texto := 'ATENÇÃO: o Peso dos Ingredientes desta preparação é maior que o ' +
                   'Peso Final. Se estiver certo disto, prossiga clicando em avançar.';
          laPesoFinalInstrucoes.Font.Color := clRed;
      end
      else if  pmPesoFinal.Medida.AsFloat = pmPesoPrep.Medida.AsFloat then
      begin
          Texto := 'Prossiga clicando em avançar.';
          laPesoFinalInstrucoes.Font.Color := clBlue;
      end;
      Self.Tag := 0;
      Click;
      // Atualiza tela
      pmPesoFinal.Refresh;
      pmPesoPrep.Refresh;
      laPesoFinalInstrucoes.Caption := Texto;
      laPesoFinalInstrucoes.Update;
   end;
end;

end.

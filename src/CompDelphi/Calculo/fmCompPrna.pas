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




unit fmCompPrna;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FnpNumericEdit, PAINELMEDIDA, VisorCal, VisorMedida, Measurement,
  Calculo;
type
  TfmCompPerna = class(TForm)
    pmCompPerna: TPainelMedida;
    fnpValNumPerna: TFnpNumericEdit;
    lbUnidPerna: TLabel;
    lbDescPerna: TLabel;
    rgEscolaridade: TRadioGroup;
    rgCorPele: TRadioGroup;
    btOK: TButton;
    btCancel: TButton;
    paResultado: TPainelMedida;
    lbUnidRes: TLabel;
    lbResultado: TLabel;
    fnpResultado: TFnpNumericEdit;
    btCalcula: TButton;
    vcCompPerna: TVisorCalculo;
    vmEscolaridade: TVisorMedida;
    vmBranco: TVisorMedida;
    vmAmarelo: TVisorMedida;
    vmPardo: TVisorMedida;
    procedure btCalculaClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pmCompPernaChangeValue(Sender: TObject);
    procedure rgEscolaridadeClick(Sender: TObject);
    procedure rgCorPeleClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
  private
    FCalculo: TCalculo;
    procedure SetCalculo(const Value: TCalculo);
    procedure LimpaResultado;
    { Private declarations }
  public
    { Public declarations }
  published
    property Calculo : TCalculo read FCalculo write SetCalculo;
  end;


implementation

//+ uses DMMBoard;

{$R *.DFM}

procedure TfmCompPerna.btCalculaClick(Sender: TObject);
begin

  case rgCorPele.ItemIndex of
     0 :
        begin
        vmBranco.Medida.ValorNumerico:='1';
        vmAmarelo.Medida.ValorNumerico:='0';
        vmPardo.Medida.ValorNumerico:='0';
        end;
     1 :
        begin
        vmBranco.Medida.ValorNumerico:='0';
        vmAmarelo.Medida.ValorNumerico:='1';
        vmPardo.Medida.ValorNumerico:='0';
        end;

     2 :
        begin
        vmBranco.Medida.ValorNumerico:='0';
        vmAmarelo.Medida.ValorNumerico:='0';
        vmPardo.Medida.ValorNumerico:='1';
        end;

     3 :
        begin
        vmBranco.Medida.ValorNumerico:='0';
        vmAmarelo.Medida.ValorNumerico:='0';
        vmPardo.Medida.ValorNumerico:='0';
        end;

     end;

  vmEscolaridade.Medida.ValorNumerico:=IntToStr(rgEscolaridade.ItemIndex );

  with Calculo do
  begin
     Procedimentos.Clear;
     Procedimentos.Add('prECCP');
     Execute;
  end;
 vcCompPerna.Refresh;
end;

procedure TfmCompPerna.btOKClick(Sender: TObject);
var
NovaEstatura : TMedida;
NomeMedida : String;
begin
btCalculaClick(self);
paResultado.Medida.Estimated:=True;
if FCalculo.Memoria.Acha ('mdEstatura',TObject(NovaEstatura)) then
begin
   NomeMedida := NovaEstatura.Descricao;
   NovaEstatura.Assign(paResultado.Medida);
   NovaEstatura.Descricao := NomeMedida;
end;
end;

procedure TfmCompPerna.SetCalculo(const Value: TCalculo);
begin
  FCalculo := Value;
end;

procedure TfmCompPerna.FormShow(Sender: TObject);
var
//Descricao : WideString;
mdCompPerna : TMedida;
begin

with FCalculo do
     begin
     Procedimentos.Clear;
     Procedimentos.Add('prECCP');
     CriaMedidas;
     end;

// é preciso setar esta propriedade, pois este form não pode ver a MotherBoard
vcCompPerna.Calculo := FCalculo;
// O refresh vai precisar de um valor nesta medida
if FCalculo.Memoria.Acha( 'mdCompPerna', TObject( mdCompPerna ) ) and
   mdCompPerna.Empty then
   mdCompPerna.AsFloat := 0;

vcCompPerna.Refresh;

rgEscolaridade.ItemIndex := StrToInt(vmEscolaridade.Medida.ValorNumerico);

rgCorPele.ItemIndex := 3;

if vmBranco.Medida.ValorNumerico='1' then
   rgCorPele.ItemIndex := 0;

if vmAmarelo.Medida.ValorNumerico='1' then
   rgCorPele.ItemIndex := 1;

if vmPardo.Medida.ValorNumerico='1' then
   rgCorPele.ItemIndex := 2;

paResultado.Medida.Empty:=True;

end;

procedure TfmCompPerna.pmCompPernaChangeValue(Sender: TObject);
begin
   LimpaResultado;
end;

procedure TfmCompPerna.LimpaResultado;
begin
  if assigned( paResultado.Medida ) then
  begin
     paResultado.Medida.AsFloat := 0;
     paResultado.Medida.Empty := True;
     paResultado.Refresh;
  end;
end;

procedure TfmCompPerna.rgEscolaridadeClick(Sender: TObject);
begin
   LimpaResultado;
end;

procedure TfmCompPerna.rgCorPeleClick(Sender: TObject);
begin
   LimpaResultado;
end;

procedure TfmCompPerna.btCancelClick(Sender: TObject);
begin
   vmBranco.Medida.ValorNumerico:='0';
   vmAmarelo.Medida.ValorNumerico:='0';
   vmPardo.Medida.ValorNumerico:='0';
   vmEscolaridade.Medida.ValorNumerico:='0';
   paResultado.Medida.AsFloat := 0;
end;

end.

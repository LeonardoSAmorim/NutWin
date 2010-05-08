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




unit RecCal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PAINELMEDIDA, Buttons, ExtCtrls;

type
  TfmRecCal = class(TForm)
    paRecCal: TPanel;
    bbRecCalOK: TBitBtn;
    bbRecCalCancela: TBitBtn;
    gbRecCal: TGroupBox;
    pmRecCal: TPainelMedida;
    laRecCalDescricao: TLabel;
    laRecCalUnidade: TLabel;
    edRecCalValor: TEdit;
    rgRecCalOrigem: TRadioGroup;
    bbRecCalCalcular: TBitBtn;
    procedure rgRecCalOrigemClick(Sender: TObject);
    procedure bbRecCalCalcularClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SelecionaOrigem;
  end;

var
  fmRecCal: TfmRecCal;

implementation

{$R *.DFM}

procedure TfmRecCal.SelecionaOrigem;
begin
   if rgRecCalOrigem.ItemIndex = 0 then // Nenhuma
      begin
         gbRecCal.Caption := '';
         pmRecCal.Visible := False;
         bbRecCalCalcular.Visible := False;
      end
   else if rgRecCalOrigem.ItemIndex = 1 then // Entrada pelo usuario
      begin
         gbRecCal.Caption := 'Entrada pelo usuário';
         pmRecCal.Visible := True;
         bbRecCalCalcular.Visible := False;
         edRecCalValor.Text := '0';
         edRecCalValor.ReadOnly := False;
      end
   else if rgRecCalOrigem.ItemIndex = 2 then  // Calcular por
      begin
         // Aqui entra o wizard de recomendacao calorica.
         gbRecCal.Caption := 'Calculada';
         pmRecCal.Visible := True;
         bbRecCalCalcular.Visible := True;
         edRecCalValor.Text := '0';
         edRecCalValor.ReadOnly := True;
      end;
end;


procedure TfmRecCal.rgRecCalOrigemClick(Sender: TObject);
begin
      SelecionaOrigem;
end;

procedure TfmRecCal.bbRecCalCalcularClick(Sender: TObject);
begin
         // Aqui entra o wizard de recomendacao calorica.
         ShowMessage( 'Aqui entra o wizard de recomendacao calorica. Supondo que foi escolhido Atividade Física - Moderada');
         gbRecCal.Caption := 'Atividade Física - Moderada';
         edRecCalValor.Text := '2500';
end;

procedure TfmRecCal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   pmRecCal.Refresh;
end;

end.

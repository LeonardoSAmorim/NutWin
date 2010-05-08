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




unit RecCal04;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, measurement;

type
  TfmRecCal04 = class(TForm)
    pa_RCAFD01: TPanel;
    GroupBox3: TGroupBox;
    meAtivFisDiaDescricao: TMemo;
    rgRCAtivFisDia: TRadioGroup;
    procedure rgRCAtivFisDiaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    AtivFisDesc : TStringList;
  end;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRecCal04.rgRCAtivFisDiaClick(Sender: TObject);
var
   mdTemp : TMedida;
begin
   meAtivFisDiaDescricao.Clear;
{   case rgRCAtivFisDia.ItemIndex of
      0 : meAtivFisDiaDescricao.Text := 'Muito Leve';
      1 : meAtivFisDiaDescricao.Text := 'Leve';
      2 : meAtivFisDiaDescricao.Text := 'Moderada';
      3 : meAtivFisDiaDescricao.Text := 'Pesada';
      4 : meAtivFisDiaDescricao.Text := 'Excepcional';
   end;}
   meAtivFisDiaDescricao.Text := AtivFisDesc.Strings[rgRCAtivFisDia.ItemIndex];
   if dmMotherBoard.caProcessador.Memoria.Acha( 'mdAFDia', TObject( mdTemp ) ) then
      mdTemp.ValorNumerico := rgRCAtivFisDia.Items.Strings[rgRCAtivFisDia.ItemIndex];
end;

procedure TfmRecCal04.FormShow(Sender: TObject);
var
   mdTemp : TMedida;
   I : Integer;
begin
   if dmMotherBoard.caProcessador.Memoria.Acha( 'mdAFDia', TObject( mdTemp ) ) then
      for I := 0 to rgRCAtivFisDia.Items.Count - 1 do
          if mdTemp.ValorNumerico = rgRCAtivFisDia.Items.Strings[I] then
             rgRCAtivFisDia.ItemIndex := I;
   rgRCAtivFisDiaClick(Sender);
end;

procedure TfmRecCal04.FormCreate(Sender: TObject);
begin
   AtivFisDesc := TStringList.Create;
   with AtivFisDesc do
   begin
      Add( 'Atividades sentado ou em pé, parado, dirigir, trabalho de laboratório, datilografar, costurar, passar roupa, cozinhar, jogar cartas, tocar instrumento musical.' );
      Add( 'Andar  5 a 6 km/h. Trabalhos como: eletricista, carpintaria, em restaurantes, limpeza de casa, cuidar de criança, golf, velejar, tênis de mesa.' );
      Add( 'Andar 7 a 8 km/h, capinar e cavar, carregando peso, andando de bicicleta, esquiar, jogar tênis, dançar.' );
      Add( 'Trabalho em usina, atletas, soldados em atividades, agricultores não mecanizados.' );
      Add( 'Lenhadores, pedreiros, ferreiros.' );
   end;
end;

procedure TfmRecCal04.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   AtivFisDesc.Free;
end;

end.

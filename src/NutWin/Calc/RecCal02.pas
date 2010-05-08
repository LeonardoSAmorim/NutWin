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




unit RecCal02;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, measurement;

type
  TfmRecCal02 = class(TForm)
    pa_RCAF01: TPanel;
    rgRCAtivFisFreq: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure rgRCAtivFisFreqClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRecCal02.FormShow(Sender: TObject);
var
   mdRCAtivFisFreq : TMedida;
begin
   with dmMotherBoard.caProcessador.Memoria do
      if not Acha('mdRCAtivFisFreq', TObject( mdRCAtivFisFreq ) ) then
         begin
            rgRCAtivFisFreq.ItemIndex := 0;
            mdRCAtivFisFreq := TMedida.Create(self);
            mdRCAtivFisFreq.Name := 'mdRCAtivFisFreq';
            mdRCAtivFisFreq.Descricao := rgRCAtivFisFreq.Items.Strings[rgRCAtivFisFreq.ItemIndex];
            mdRCAtivFisFreq.ValorNumerico := '0';
            mdRCAtivFisFreq.Unidade := 'ItemIndex';
            mdRCAtivFisFreq.Valid := True;
            Adiciona('mdRCAtivFisFreq', mdRCAtivFisFreq, 'cxcaRecCal');
            mdRCAtivFisFreq.Free;
         end
      else
         rgRCAtivFisFreq.ItemIndex := StrToInt( mdRCAtivFisFreq.ValorNumerico );
   Tag:=rgRCAtivFisFreq.ItemIndex;
end;

procedure TfmRecCal02.rgRCAtivFisFreqClick(Sender: TObject);
var
   mdRCAtivFisFreq : TMedida;
begin
   if rgRCAtivFisFreq.ItemIndex = 1 then
      begin
         ShowMessage( 'Cálculo não implementado!' );
         rgRCAtivFisFreq.ItemIndex := 0;
      end;
   with dmMotherBoard.caProcessador.Memoria do
      if not Acha('mdRCAtivFisFreq', TObject( mdRCAtivFisFreq ) ) then
         ShowMessage( 'Houve um erro na carga do tipo de cálculo' )
      else
         begin
//@            if mdRCAtivFisFreq.ValorNumerico <> IntToStr( rgRCAtivFisFreq.ItemIndex ) then
//@               AddModified;
            mdRCAtivFisFreq.Descricao := rgRCAtivFisFreq.Items.Strings[rgRCAtivFisFreq.ItemIndex];
            mdRCAtivFisFreq.ValorNumerico := IntToStr( rgRCAtivFisFreq.ItemIndex );
//@            AddModified;
         end;
   Tag:=rgRCAtivFisFreq.ItemIndex;
   //Refresh do Wizard
   Click;
end;

procedure TfmRecCal02.FormCreate(Sender: TObject);
var
   mdRCAtivFisFreq : TMedida;
begin
   with dmMotherBoard.caProcessador.Memoria do
      if not Acha('mdRCAtivFisFreq', TObject( mdRCAtivFisFreq ) ) then
         begin
            rgRCAtivFisFreq.ItemIndex := 0;
            mdRCAtivFisFreq := TMedida.Create(self);
            mdRCAtivFisFreq.Name := 'mdRCAtivFisFreq';
            mdRCAtivFisFreq.Descricao := rgRCAtivFisFreq.Items.Strings[rgRCAtivFisFreq.ItemIndex];
            mdRCAtivFisFreq.ValorNumerico := '0';
            mdRCAtivFisFreq.Unidade := 'ItemIndex';
            mdRCAtivFisFreq.Valid := True;
            Adiciona('mdRCAtivFisFreq', mdRCAtivFisFreq, 'cxcaRecCal');
            mdRCAtivFisFreq.Free;
         end
      else
         rgRCAtivFisFreq.ItemIndex := StrToInt( mdRCAtivFisFreq.ValorNumerico );
   Tag:=rgRCAtivFisFreq.ItemIndex;
end;

end.

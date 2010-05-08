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




unit UEPValorGramas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FnpNumericEdit, FnpNEditBlank, ExtCtrls, PAINELMEDIDA, DBCtrls,
  Mask, Wizard, db;

type
  TfmEPValorGramas = class(TForm)
    paEEValorGramas: TPanel;
    bePesoAli: TBevel;
    deAlim: TDBText;
    Label1: TLabel;
    DBText1: TDBText;
    pmEPPeso: TPainelMedida;
    laDescricaoPesoAli: TLabel;
    laUnidadePesoAli: TLabel;
    imPesoAli: TImage;
    gbEPPeso: TGroupBox;
    laPesoAli: TLabel;
    FnpEqProt: TFnpNEditBlank;
    procedure FormShow(Sender: TObject);
    procedure FnpEqProtExit(Sender: TObject);
    procedure FnpEqProtChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEPValorGramas: TfmEPValorGramas;

implementation

uses DMSubstCal;

{$R *.DFM}

procedure TfmEPValorGramas.FormShow(Sender: TObject);
begin
// Simulação de um db. O fnp recebe o valor e depois grava no banco de dados.

   if DMSubsCalorico.TbAliGProt.FieldbyName('MedGr').asString = '' then
      begin
         FnpEqProt.Value := 0;
      end
   else
      begin
         FnpEqProt.Value := DMSubsCalorico.TbAliGProt.FieldbyName('MedGr').asFloat;
      end;

   FnpEqProt.SetFocus;
   if not ( FnpEqProt.Value = 0 ) then
      begin
         // Habilita o botão de avançar, pois o peso foi preenchido
         Tag := 0;
      end
   else
      begin
         // Faz com que só apareça o botão cancelar do wizard, pois
         // não foi digitada o valor em gramas
         Tag := WZ_INVALIDNODE;
      end;
   Click;

end;

procedure TfmEPValorGramas.FnpEqProtExit(Sender: TObject);
begin

 if (DMSubsCalorico.TbAliGProt.State = dsInsert) or (DMSubsCalorico.TbAliGProt.State = dsEdit) then
 begin
  DMSubsCalorico.TbAliGProt.Fieldbyname('MedGr').asFloat := FnpEqProt.Value ;

 end;

end;

procedure TfmEPValorGramas.FnpEqProtChange(Sender: TObject);
begin
   if not ( FnpEqProt.Value = 0 ) then
      begin
         // Habilita o botão de avançar, pois o peso foi preenchido
         Tag := 0;
      end
   else
      begin
         // Faz com que só apareça o botão cancelar do wizard, pois
         // não foi digitada o valor em gramas
         Tag := WZ_INVALIDNODE;
      end;   
   Click;
end;

end.

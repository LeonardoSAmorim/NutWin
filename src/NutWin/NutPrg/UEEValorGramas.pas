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




unit UEEValorGramas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FnpNumericEdit, FnpNEditBlank, ExtCtrls, PAINELMEDIDA, DBCtrls,
  Mask, Wizard, db;

type
  TfmEEValorGramas = class(TForm)
    paEEValorGramas: TPanel;
    bePesoAli: TBevel;
    pmPesoAli: TPainelMedida;
    laDescricaoPesoAli: TLabel;
    laUnidadePesoAli: TLabel;
    imPesoAli: TImage;
    gbPesoAli: TGroupBox;
    laPesoAli: TLabel;
    deAlim: TDBText;
    Label1: TLabel;
    DBText1: TDBText;
    FnpEEValorGramas: TFnpNEditBlank;
    procedure FormShow(Sender: TObject);
    procedure FnpEEValorGramasExit(Sender: TObject);
    procedure FnpEEValorGramasChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEEValorGramas: TfmEEValorGramas;

implementation

uses DMSubstCal;

{$R *.DFM}

procedure TfmEEValorGramas.FormShow(Sender: TObject);
begin

// Simulação de um db. O fnp recebe o valor e depois grava no banco de dados.

   if DMSubsCalorico.TbAliGCal.FieldbyName('MedGr').asString = '' then
      begin
         FnpEEValorGramas.Value := 0;
      end
   else
      begin
         fnpEEValorGramas.Value := DMSubsCalorico.TbAliGCal.FieldbyName('MedGr').asFloat;
      end;

   fnpEEValorGramas.SetFocus;
   if not ( FnpEEValorGramas.Value = 0 ) then
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

procedure TfmEEValorGramas.FnpEEValorGramasExit(Sender: TObject);
begin
 if (DMSubsCalorico.TbAliGCal.State = dsInsert) or (DMSubsCalorico.TbAliGCal.State = dsEdit) then
 begin
  DMSubsCalorico.TbAliGCal.FieldbyName('MedGr').asFloat := FnpEEValorGramas.Value ;
//  DMSubsCalorico.TbAliGCal.Post;
 end;
end;

procedure TfmEEValorGramas.FnpEEValorGramasChange(Sender: TObject);
begin
 if not ( FnpEEValorGramas.Value = 0 ) then
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

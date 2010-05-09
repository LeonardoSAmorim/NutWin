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




unit UEPSelecMedidas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Buttons, DBCtrls, ExtCtrls, db;

type
  TfmEPSelecMedidas = class(TForm)
    paSelecMedidas: TPanel;
    beListaMed: TBevel;
    deAlim: TDBText;
    Label1: TLabel;
    DBText1: TDBText;
    bbEmGramas: TBitBtn;
    grMedidas: TDBGrid;
    lbEquiv: TLabel;
    lbEquivTela2: TLabel;
    lbGr: TLabel;
    procedure bbEmGramasClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grMedidasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bbEmGramasEnter(Sender: TObject);
    procedure bbEmGramasExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grMedidasDblClick(Sender: TObject);
    procedure grMedidasEnter(Sender: TObject);
    procedure grMedidasExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEPSelecMedidas: TfmEPSelecMedidas;

implementation

uses DMSubstCal, DMAliPrep;

{$R *.DFM}

procedure TfmEPSelecMedidas.bbEmGramasClick(Sender: TObject);
begin
   DMSubsCalorico.EmGramas := True;
   DMSubsCalorico.EPWiz.Avancar;
end;

procedure TfmEPSelecMedidas.FormHide(Sender: TObject);
begin

 if (DMSubsCalorico.TbAliGProt.State = dsInsert) or (DMSubsCalorico.TbAliGProt.State = dsEdit) then
 begin
   if DMSubsCalorico.EmGramas = True then
     begin
      Tag := 1;            // em gramas
      DMSubsCalorico.TbAliGProt.Fieldbyname('QTDE').asString := '';
      // se mudou de medida para em gramas, limpa o campo peso em gramas
      if DMSubsCalorico.TbAliGProt.FieldByName('IDMEDCAS').asString <> '' then
         DMSubsCalorico.TbAliGProt.Fieldbyname('MEDGR').asString := '';
      DMSubsCalorico.TbAliGProt.FieldByName('IDMEDCAS').asString;
     end
   else
     begin
      Tag := 0  ;         // medida caseira escolhida
   DMSubsCalorico.TbAliGProt.FieldByName('IDMEDCAS').asString :=  DMAlimentos.TbMCSP.Fieldbyname('IDMEDCAS').asString;
   // devo limpar o campo da quantidade para que o usuario escolha o valor correto
   DMSubsCalorico.TbAliGProt.Fieldbyname('QTDE').asString  := '';
   DMSubsCalorico.TbAliGProt.Fieldbyname('MEDGR').asString := '';
   DMSubsCalorico.SPMedCas;
     end;
 end;
 Click;
end;

procedure TfmEPSelecMedidas.FormCreate(Sender: TObject);
begin
   DMSubsCalorico.EmGramas := ( DMSubsCalorico.TbAliGProt.FieldByName('IDMEDCAS').asString = '' )
end;

procedure TfmEPSelecMedidas.grMedidasKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    if (Key = VK_DOWN) and grMedidas.DataSource.DataSet.Eof then
        bbEmGramas.SetFocus;
end;

procedure TfmEPSelecMedidas.bbEmGramasEnter(Sender: TObject);
begin
   DMSubsCalorico.EmGramas := True;
   bbEmGramas.Font.Color := clBlue;
end;

procedure TfmEPSelecMedidas.bbEmGramasExit(Sender: TObject);
begin
   bbEmGramas.Font.Color := clWindowText;
end;

procedure TfmEPSelecMedidas.FormShow(Sender: TObject);

begin

 // DMSubsCalorico.stEquivalente := DMSubsCalorico.SPEquiv;   // qtde alimento p/ equiv. ao grupo

   if DMSubsCalorico.stEquivalente = '0' then // quando não tiver valor de aquivalente proteico uso o de calorico
       lbEquivTela2.caption := DMSubsCalorico.SCEquivParaProteina  // 1- Preciso do valor do alimento para equivaler em Calorias
   else
       lbEquivTela2.caption := DMSubsCalorico.stEquivalente;

   if DMSubsCalorico.EmGramas then
      bbEmGramas.SetFocus
   else
      grMedidas.SetFocus;
end;

procedure TfmEPSelecMedidas.grMedidasDblClick(Sender: TObject);
begin
// Se a medida estiver vazia, entro somente em gramas
   if DMAlimentos.TbMCSP.IsEmpty then
      DMSubsCalorico.EmGramas := True
   else
      DMSubsCalorico.EmGramas := False;
   DMSubsCalorico.EPWiz.Avancar;
end;

procedure TfmEPSelecMedidas.grMedidasEnter(Sender: TObject);
begin
// Se a medida estiver vazia, entro somente em gramas
   if DMAlimentos.TbMCSP.IsEmpty then
      DMSubsCalorico.EmGramas := True
   else
      DMSubsCalorico.EmGramas := False;

   grMedidas.Options := grMedidas.Options + [dgAlwaysShowSelection];
end;

procedure TfmEPSelecMedidas.grMedidasExit(Sender: TObject);
begin
   grMedidas.Options := grMedidas.Options - [dgAlwaysShowSelection];
end;

end.
 
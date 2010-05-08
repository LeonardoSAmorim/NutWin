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




unit UEESelecMedidas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, RXDBCtrl, DBCtrls, db;

type
  TfmEESelecMedidas = class(TForm)
    paSelecMedidas: TPanel;
    beListaMed: TBevel;
    bbEmGramas: TBitBtn;
    grMedidas: TRxDBGrid;
    deAlim: TDBText;
    Label1: TLabel;
    DBText1: TDBText;
    lbEquivTela2: TLabel;
    laGr: TLabel;
    lbEquiv: TLabel;
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grMedidasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bbEmGramasEnter(Sender: TObject);
    procedure bbEmGramasExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbEmGramasClick(Sender: TObject);
    procedure grMedidasDblClick(Sender: TObject);
    procedure grMedidasEnter(Sender: TObject);
    procedure grMedidasExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEESelecMedidas: TfmEESelecMedidas;

implementation

uses  DMAliPrep, DMSubstCal;

{$R *.DFM}

procedure TfmEESelecMedidas.FormHide(Sender: TObject);
begin
if (DMSubsCalorico.TbAliGCal.State = dsInsert) or (DMSubsCalorico.TbAliGCal.State = dsEdit) then
  begin
   if DMSubsCalorico.EmGramas = True then
     begin
      Tag := 1;            // em gramas
      DMSubsCalorico.TbAliGCal.Fieldbyname('QTDE').asString := '';
      // se mudou de medida para em gramas, limpa o campo peso em gramas
      if DMSubsCalorico.TbAliGCal.Fieldbyname('IDMEDCAS').asString <> '' then
         DMSubsCalorico.TbAliGCal.Fieldbyname('MEDGR').asString := '';
      DMSubsCalorico.TbAliGCal.Fieldbyname('IDMEDCAS').asString := '';
     end
   else
     begin
      Tag := 0  ;         // medida caseira escolhida
      DMSubsCalorico.TbAliGCal.FieldByName('IDMEDCAS').asString :=
                            DMAlimentos.TbMCSC.Fieldbyname('IDMEDCAS').asString;
      // devo limpar o campo da quantidade para que o usuario escolha o valor correto
      DMSubsCalorico.TbAliGCal.Fieldbyname('QTDE').asString  := '';
      DMSubsCalorico.TbAliGCal.Fieldbyname('MEDGR').asString := '';
      DMSubsCalorico.SCMedCas;
     end;
  end;
   Click;
end;

procedure TfmEESelecMedidas.FormCreate(Sender: TObject);
begin
   DMSubsCalorico.EmGramas := ( DMSubsCalorico.TbAliGCal.FieldByName('IDMEDCAS').asString = '' )
end;

procedure TfmEESelecMedidas.grMedidasKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    if (Key = VK_DOWN) and grMedidas.DataSource.DataSet.Eof then
        bbEmGramas.SetFocus;
end;

procedure TfmEESelecMedidas.bbEmGramasEnter(Sender: TObject);
begin
   DMSubsCalorico.EmGramas := True;
   bbEmGramas.Font.Color := clBlue;
end;

procedure TfmEESelecMedidas.bbEmGramasExit(Sender: TObject);
begin
   bbEmGramas.Font.Color := clWindowText;
end;

procedure TfmEESelecMedidas.FormShow(Sender: TObject);
begin
   lbEquivTela2.Caption := DMSubsCalorico.SCEquiv;
   if DMSubsCalorico.EmGramas then
      bbEmGramas.SetFocus
   else
      grMedidas.SetFocus;

end;

procedure TfmEESelecMedidas.bbEmGramasClick(Sender: TObject);
begin
   DMSubsCalorico.EmGramas := True;
   DMSubsCalorico.EEWiz.Avancar;
end;

procedure TfmEESelecMedidas.grMedidasDblClick(Sender: TObject);
begin
// Se a medida estiver vazia, entro somente em gramas
   if DMAlimentos.TbMCSC.IsEmpty then
      DMSubsCalorico.EmGramas := True
   else
      DMSubsCalorico.EmGramas := False;
   DMSubsCalorico.EEWiz.Avancar;
end;

procedure TfmEESelecMedidas.grMedidasEnter(Sender: TObject);
begin
// Se a medida estiver vazia, entro somente em gramas
   if DMAlimentos.TbMCSC.IsEmpty then
      DMSubsCalorico.EmGramas := True
   else
      DMSubsCalorico.EmGramas := False;

   grMedidas.Options := grMedidas.Options + [dgAlwaysShowSelection];
end;

procedure TfmEESelecMedidas.grMedidasExit(Sender: TObject);
begin
   grMedidas.Options := grMedidas.Options - [dgAlwaysShowSelection];
end;

end.

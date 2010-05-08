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




unit MedAli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DBCtrls, Mask, Buttons, ComCtrls, Grids, DBGrids, Db,
  DBTables, LstMed, QtdAli;

type
  TfmMedCas = class(TForm)
    lstMedida: TListaMedida;
    Panel1: TPanel;
    laMCFiltrarNome: TLabel;
    edMCFiltrarPor: TEdit;
    ckMCDoInicio: TCheckBox;
    rgMCOrdenarPor: TRadioGroup;
    rgMCTipoOrdem: TRadioGroup;
    Panel2: TPanel;
    paMCLocalizar: TPanel;
    laMCLocalizar: TLabel;
    edMCLocalizar: TEdit;
    grMedidasCaseiras: TDBGrid;
    paMCQtde: TPanel;
    laMCQtde: TLabel;
    laMCTotal: TLabel;
    laMCTotalUnidade: TLabel;
    edMCQtde: TEdit;
    deMCPesoTotal: TDBEdit;
    paMCBotoes: TPanel;
    bbMCOk: TBitBtn;
    bbMCCancelar: TBitBtn;
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    sbOrdCrescente: TSpeedButton;
    sbOrdDecrescente: TSpeedButton;
    beOrdDivisao: TBevel;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    procedure edMCLocalizarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure sbOrdCrescenteClick(Sender: TObject);
    procedure sbOrdDecrescenteClick(Sender: TObject);
    procedure bbMCOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    QuantMed : Double;
    PesoMed,
    IDMed : String;

  end;

implementation

{$R *.DFM}

procedure TfmMedCas.edMCLocalizarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_DOWN then
      grMedidasCaseiras.SetFocus;
end;

procedure TfmMedCas.SpeedButton1Click(Sender: TObject);
begin
   if SpeedButton1.Down then
      lstMedida.OrdenarMedidaPor.ItemIndex := 0
   else
      lstMedida.OrdenarMedidaPor.ItemIndex := 1;
end;

procedure TfmMedCas.sbOrdCrescenteClick(Sender: TObject);
begin
   if sbOrdCrescente.Down then
      lstMedida.TipoDeOrdem.ItemIndex := 0;
end;

procedure TfmMedCas.sbOrdDecrescenteClick(Sender: TObject);
begin
   if sbOrdDecrescente.Down then
      lstMedida.TipoDeOrdem.ItemIndex := 1;
end;

procedure TfmMedCas.bbMCOkClick(Sender: TObject);
begin
   IDMed := lstMedida.ListaDeMedidas.DataSource.DataSet.FieldByName( 'IDMEDCAS' ).AsString;
   QuantMed := StrToFloat( edMCQtde.Text );
   PesoMed := deMCPesoTotal.Text;
end;

end.

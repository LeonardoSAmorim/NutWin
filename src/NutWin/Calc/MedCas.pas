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




unit MedCas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Mask, DBCtrls, Grids, DBGrids, MedidasCaseiras,
  NutCnst;

type
  TfmMedidas = class(TForm)
    Panel2: TPanel;
    paMCLocalizar: TPanel;
    laMCLocalizar: TLabel;
    edMCLocalizar: TEdit;
    grMedidasCaseiras: TDBGrid;
    SpeedButton1: TSpeedButton;
    deAlimento: TDBEdit;
    procedure edMCLocalizarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure deAlimentoChange(Sender: TObject);
    procedure edMCLocalizarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grMedidasCaseirasTitleClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure TrocaTipoOrdem;
  end;

var
  fmMedidas: TfmMedidas;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmMedidas.edMCLocalizarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_DOWN then
      grMedidasCaseiras.SetFocus;
end;

procedure TfmMedidas.SpeedButton1Click(Sender: TObject);
begin
   if SpeedButton1.Down then
      dmMotherBoard.MedidasCaseiras.OrdenarMedidaPor := omNome
   else
      dmMotherBoard.MedidasCaseiras.OrdenarMedidaPor := omPreferenciaUser;
end;

procedure TfmMedidas.FormShow(Sender: TObject);
begin
   // Ativa MedidasCaseiras
   if not dmMotherBoard.MedidasCaseiras.Ativar then
     begin
      dmMotherBoard.MedidasCaseiras.Ativar := True;
     end;
end;

procedure TfmMedidas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   dmMotherBoard.MedidasCaseiras.Ativar := False;
end;

procedure TfmMedidas.deAlimentoChange(Sender: TObject);
begin
   Caption := 'Medidas Caseiras - ' + dmMotherBoard.ListaAlimento.ListaDeAlimentos.DataSet.FieldByName( 'NOME' ).AsString;
end;

procedure TfmMedidas.edMCLocalizarChange(Sender: TObject);
begin
   dmMotherBoard.MedidasCaseiras.LocalizaNomeMedida := edMCLocalizar.Text;
end;

procedure TfmMedidas.FormCreate(Sender: TObject);
begin
   dmMotherBoard.MedidasCaseiras.OrdenarMedidaPor := omNome;
end;

procedure TfmMedidas.grMedidasCaseirasTitleClick(Column: TColumn);
begin
   TrocaTipoOrdem;
end;

procedure TfmMedidas.TrocaTipoOrdem;
begin
   with dmMotherBoard.MedidasCaseiras do
      if TipoDeOrdem = toCrescente then
         TipoDeOrdem := toDecrescente
      else
         TipoDeOrdem := toCrescente;
end;

end.

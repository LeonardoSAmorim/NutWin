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




unit RlPrep01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VisorMedida, Db, DBTables, VisorCal, quickrpt, Qrctrls, ExtCtrls, QRPRNTR,
  CalcAli,qrepform, Measurement, jpeg, fmFormRelCalcAli;

type
  TfmRelPrep01 = class(TfmRepCalcAli)
    QRBand1: TQRBand;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReportPreview(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRelPrep01.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfmRelPrep01.ReportPreview(Sender: TObject);
begin
  inherited;
  if dmMotherBoard.CurrentViewer.QRPreview <> nil then
     begin
        dmMotherBoard.CurrentViewer.QRPreview.QRPrinter := TQRPrinter( Sender );
        dmMotherBoard.CurrentViewer.Show;
     end;
end;

procedure TfmRelPrep01.FormCreate(Sender: TObject);
begin
  inherited;
  taMedida.Open;
  quRefItemsAli.ParamByName( 'ID_CALCALI' ).AsString := dmMotherBoard.CalcPreparacao.IDCalcAli;
  quRefItemsAli.Open;
  // Preparação não tem refeição
  qeRefeicao.Enabled := False;
end;

end.

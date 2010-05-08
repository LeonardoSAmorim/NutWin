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




unit RlEsp01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VisorMedida, Db, DBTables, VisorCal, quickrpt, Qrctrls, ExtCtrls, QRPRNTR,
  qrepform, Measurement, jpeg, fmFormRelMedResult, fmFormRelIndividuo;

type
  TfmRelEspeciais01 = class(TfmRepMedResult)
    qbVazio: TQRSubDetail;
    procedure ReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRelEspeciais01.ReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  inherited;
  dmMotherBoard.caProcessador.EncheListas( 'cxcaEspecial', FProcedimentos, FMedidas, FResultados );
end;

procedure TfmRelEspeciais01.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmRelEspeciais01.FormDestroy(Sender: TObject);
begin
  inherited;
// Isto precisa existir pra chamar o destroy do pai
end;

procedure TfmRelEspeciais01.FormCreate(Sender: TObject);
begin
  inherited;
// Isto precisa existir pra chamar o create do pai
end;

end.


 
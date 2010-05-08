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




unit RelTot;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, ExtCtrls, StdCtrls, Db, DBTables, qrepform, RxGIF;

type
  TfmRelTotALI = class(TFormReport)
    QRBand1: TQRBand;
    qlAlim: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    qlPrep: TQRLabel;
    qlNut: TQRLabel;
    qlMed: TQRLabel;
    qlSCal: TQRLabel;
    qlSProt: TQRLabel;
    qlPreco: TQRLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRelTotALI: TfmRelTotALI;

implementation

uses DMRelat, DMRElNut, DMRelMed, DMRelSuCal;

{$R *.DFM}

procedure TfmRelTotALI.Button1Click(Sender: TObject);
begin
   //label1.Caption := InttoStr(DSAlimento.DataSet.recordCount) ;
   //label2.caption := InttoStr(DSNutrientes.DataSet.RecordCount) ;
   //label3.Caption := InttoStr(DSPreparac.DataSet.RecordCount);

end;

procedure TfmRelTotALI.FormCreate(Sender: TObject);
begin
    inherited;
    qlAlim.Caption  := InttoStr(DMRelatAli.TbAlim.RecordCount);
    qlPrep.Caption  := InttoStr(DMRelatAli.qrPreparac.RecordCount);
    // Desabilito os Mastersources para poder contar quantos registros tem em cada banco.
  //  DMRelNutrientes.TbAliNut.MasterSource.Enabled:=False;
    qlNut.Caption   := InttoStr(DMRelNutrientes.TbNutrientes.RecordCount);
 //   DMRelNutrientes.TbAliNut.MasterSource.Enabled:=True;

//    DMRelMedidas.TbMedidasCaseiras.MasterSource.Enabled  := False;
    qlMed.Caption   := InttoStr(DMRelMedidas.TbMedidas.RecordCount);
//    DMRelMedidas.TbMedidasCaseiras.MasterSource.Enabled  := True;

    DMRelSCal.TbAliGCal.MasterSource.Enabled  := False;
    qlSCal.Caption  := InttoStr(DMRelSCal.TbAliGCal.RecordCount);
    DMRelSCal.TbAliGCal.MasterSource.Enabled  := True;

    DMRelSCal.TbAliGProt.MasterSource.Enabled  := False;
    qlSProt.Caption := InttoStr(DMRelSCal.TbAliGProt.RecordCount);
    DMRelSCal.TbAliGProt.MasterSource.Enabled  := True;

    DMRelatAli.TbAliPreco.MasterSource.Enabled  := False;
    qlPreco.Caption := InttoStr(DMRelatAli.TbAliPreco.RecordCount);
    DMRelatAli.TbAliPreco.MasterSource.Enabled  := True;


end;

end.

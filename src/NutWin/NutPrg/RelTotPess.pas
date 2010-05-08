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




unit RelTotPess;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  QuickRpt, Qrctrls, ExtCtrls, qrepform, RxGIF;

type
  TfmRelTotPess = class(TFormReport)
    QRBand2: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    qlPess: TQRLabel;
    qlAnam: TQRLabel;
    qlAntrop: TQRLabel;
    qlInquerito: TQRLabel;
    qlDieta: TQRLabel;
    qlExame: TQRLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRelTotPess: TfmRelTotPess;

implementation

uses DMRelPess;

{$R *.DFM}

procedure TfmRelTotPess.FormCreate(Sender: TObject);
begin
    inherited;
     // Configura as totalizacoes para o Cadastro de Pessoa
     qlPess.Caption      := InttoStr(DMRelPessoa.TbPessoa.RecordCount);

     DMRelPessoa.TbAnam.MasterSource.Enabled := False ;
     qlAnam.Caption      := InttoStr(DMRelPessoa.TbAnam.RecordCount);
     DMRelPessoa.TbAnam.MasterSource.Enabled := True ; ;

     DMRelPessoa.TbAntrop.MasterSource.Enabled := False ;
     qlAntrop.Caption    := InttoStr(DMRelPessoa.TbAntrop.RecordCount);
     DMRelPessoa.TbAntrop.MasterSource.Enabled := True ;

     DMRelPessoa.TbInquerito.MasterSource.Enabled := False ;
     qlInquerito.Caption := InttoStr(DMRelPessoa.TbInquerito.RecordCount);
     DMRelPessoa.TbInquerito.MasterSource.Enabled := True ;

     DMRelPessoa.TbDieta.MasterSource.Enabled := False ;
     qlDieta.Caption     := InttoStr(DMRelPessoa.TbDieta.RecordCount);
     DMRelPessoa.TbDieta.MasterSource.Enabled := True ;

     DMRelPessoa.TbExames.MasterSource.Enabled := False ;
     qlExame.Caption     := InttoStr(DMRelPessoa.TbExames.RecordCount);
     DMRelPessoa.TbExames.MasterSource.Enabled := True ;
end;

end.
  
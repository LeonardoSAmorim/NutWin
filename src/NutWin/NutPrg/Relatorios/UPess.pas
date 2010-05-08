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




unit UPess;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, quickrpt, ExtCtrls, dbgrids, qrepform, RxGIF;

type
  TfmRelPess = class(TFormReport)
    qgNomePess: TQRGroup;
    qrNomePess: TQRExpr;
    qbDadosPess: TQRBand;
    qlNomePess: TQRLabel;
    qtNomePess: TQRDBText;
    qiFotoPess: TQRDBImage;
    qlDataNasc: TQRLabel;
    qtDataNasc: TQRDBText;
    qlResponsavel: TQRLabel;
    qtNomeResp: TQRDBText;
    qlDataCad: TQRLabel;
    qtDataCad: TQRDBText;
    qlDadosPessoais: TQRLabel;
    qlDadosCompl: TQRLabel;
    qlNatural: TQRLabel;
    qlNacional: TQRLabel;
    qlCor: TQRLabel;
    qtNatural: TQRDBText;
    qtNacional: TQRDBText;
    qtCor: TQRDBText;
    qlObs: TQRLabel;
    qtObs: TQRDBText;
    qlEndereco: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    qlRua: TQRLabel;
    qlNumLog: TQRLabel;
    qlCompl: TQRLabel;
    qlBairro: TQRLabel;
    qlCidade: TQRLabel;
    qlCep: TQRLabel;
    qlEstado: TQRLabel;
    qlEmail: TQRLabel;
    qbTelCab: TQRBand;
    qlFones: TQRLabel;
    qlTipo: TQRLabel;
    qlDDD: TQRLabel;
    qlNumero: TQRLabel;
    qlRamal: TQRLabel;
    qtTipo: TQRDBText;
    qtDDD: TQRDBText;
    qtNumTel: TQRDBText;
    qtRamal: TQRDBText;
    QRDBText14: TQRDBText;
    QRDBRichText1: TQRDBRichText;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRDBText15: TQRDBText;
    QRDBRichText2: TQRDBRichText;
    QRLabel3: TQRLabel;
    QRDBText16: TQRDBText;
    qr: TQRDBRichText;
    QRLabel4: TQRLabel;
    QRDBText17: TQRDBText;
    QRDBRichText4: TQRDBRichText;
    QRLabel5: TQRLabel;
    QRDBText18: TQRDBText;
    QRDBRichText5: TQRDBRichText;
    qlSexo: TQRLabel;
    QRDBText10: TQRDBText;
    qlRegistro: TQRLabel;
    QRDBText9: TQRDBText;
    QRLabel6: TQRLabel;
    QRDBText11: TQRDBText;
    qsdDadosCompl: TQRSubDetail;
    qrAnamNutr: TQRSubDetail;
    qrAntrop: TQRSubDetail;
    qsdEnd: TQRSubDetail;
    qrTelefone: TQRSubDetail;
    qrInqAlim: TQRSubDetail;
    qrPlanoAlim: TQRSubDetail;
    qrExLab: TQRSubDetail;
    qrPastas: TQRSubDetail;
    QRDBText12: TQRDBText;
    QRLabel7: TQRLabel;
    procedure qrPessAfterPreview(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRelPess: TfmRelPess;

implementation

uses DMRelPess, Nutrelat, Pessoa;

{$R *.DFM}

procedure TfmRelPess.qrPessAfterPreview(Sender: TObject);
begin
   DMRelPessoa.TbPessoa.Filter := '' ;
   DMRelPessoa.TbPessoa.Filtered := False;

end;

end.
  
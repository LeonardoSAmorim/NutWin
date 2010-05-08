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




unit Individuo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, Tabs, StdCtrls, Buttons, Grids, DBGrids, Mask, ComCtrls, DB,
  ExtCtrls;

type
  TfmIndividuo = class(TForm)
    paIndividuo: TPanel;
    deDadosPessoais: TBevel;
    Label37: TLabel;
    lblAnos: TLabel;
    Label36: TLabel;
    Label29: TLabel;
    Label28: TLabel;
    Label27: TLabel;
    Label14: TLabel;
    pcIndividuo: TPageControl;
    tsEndereco: TTabSheet;
    Bevel8: TBevel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label38: TLabel;
    deEndereco: TDBEdit;
    DBEdit15: TDBEdit;
    deCEP: TDBEdit;
    GroupBox24: TGroupBox;
    grTelefone: TDBGrid;
    GroupBox26: TGroupBox;
    deEMail: TDBEdit;
    BitBtn3: TBitBtn;
    deAtualizado: TDBEdit;
    tbsAvaliacao: TTabSheet;
    GroupBox2: TGroupBox;
    dmObs: TDBMemo;
    tbsConsulta: TTabSheet;
    TabSet5: TTabSet;
    DBMemo2: TDBMemo;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn12: TBitBtn;
    tbsAval: TTabSheet;
    TabSet2: TTabSet;
    DBMemo3: TDBMemo;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn13: TBitBtn;
    TabSheet2: TTabSheet;
    TabSet1: TTabSet;
    DBMemo4: TDBMemo;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn14: TBitBtn;
    TabSheet3: TTabSheet;
    TabSet3: TTabSet;
    DBMemo5: TDBMemo;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn15: TBitBtn;
    TabSheet4: TTabSheet;
    TabSet4: TTabSet;
    DBMemo6: TDBMemo;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn16: TBitBtn;
    diFoto: TDBImage;
    deNome: TDBEdit;
    deDataNasc: TDBEdit;
    deSobrenome: TDBEdit;
    dcSexo: TDBComboBox;
    BitBtn17: TBitBtn;
    dlgAbreFoto: TOpenDialog;
    DBLookupComboBox1: TDBLookupComboBox;
    lcNacionalidade: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBLookupComboBox3: TDBLookupComboBox;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    naTelefone: TDBNavigator;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn17Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure diFotoClick(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmIndividuo: TfmIndividuo;

implementation

uses DMNutWin;

{$R *.DFM}

procedure TfmIndividuo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfmIndividuo.BitBtn17Click(Sender: TObject);
begin
   if (dmNut.taIndividuo.State = dsEdit) or
      (dmNut.taIndividuo.State = dsInsert) then
      dmNut.taIndividuo.Post;
   dmNut.taIndividuo.Close;
   dmNut.taTelefone.Close;
   dmNut.taAvaliacao.Close;
   dmNut.taTabNacio.Close;
   dmNut.taTabCor.Close;
   Close;
end;

procedure TfmIndividuo.FormCreate(Sender: TObject);
begin
   dmNut.taIndividuo.Open;
   dmNut.taTelefone.Open;
   dmNut.taAvaliacao.Open;
   dmNut.taTabNacio.Open;
   dmNut.taTabCor.Open;
   pcIndividuo.ActivePage := tsEndereco;
end;

procedure TfmIndividuo.diFotoClick(Sender: TObject);
begin
  dlgAbreFoto.FileName := '*.bmp';
  if dlgAbreFoto.Execute then
    begin
     fmIndividuo.diFoto.Picture.LoadFromFile(dlgAbreFoto.FileName);
     dmNut.taIndividuo.Edit;
    end;
end;

procedure TfmIndividuo.BitBtn19Click(Sender: TObject);
begin
   naTelefone.BtnClick(nbDelete);
end;

procedure TfmIndividuo.BitBtn18Click(Sender: TObject);
begin
   naTelefone.BtnClick(nbInsert);
   with dmNut do
      taTelefone.FieldByName('CODIND').AsInteger := taIndividuo.FieldByName('CODIND').Value;
   naTelefone.BtnClick(nbEdit);
end;

end.

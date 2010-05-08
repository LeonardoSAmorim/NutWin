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




unit fmROpc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, ExtCtrls, QUICKRPT, db;

type
  TfmRelOpc = class(TForm)
    Panel1: TPanel;
    rgRelTipo: TRadioGroup;
    dgDica: TDBGrid;
    gbDica: TGroupBox;
    edPesq: TEdit;
    btSair: TButton;
    rgRelOrd: TRadioGroup;
    btImpr: TButton;
    procedure btSairClick(Sender: TObject);
    procedure btImprClick(Sender: TObject);
    procedure rgRelOrdClick(Sender: TObject);
    procedure rgRelTipoClick(Sender: TObject);
    procedure edPesqClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edPesqChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FReport  : TQuickRep ;
    procedure SetReport(Value : TQuickRep);
  public
    { Public declarations }
     property Report : TQuickRep read FReport write SetReport;
  end;

var
  fmRelOpc: TfmRelOpc;

implementation

uses DMDica1, fmRelDicas;

{$R *.DFM}

procedure TfmRelOpc.SetReport(Value : TQuickRep);
begin
  FReport:=Value;

end;

procedure TfmRelOpc.btSairClick(Sender: TObject);
begin
   Close;
end;

procedure TfmRelOpc.btImprClick(Sender: TObject);
begin
    fmRelDic := TfmRelDic.Create(self);
    Report   := fmRelDic.qrDicas;
    if rgRelTipo.ItemIndex = 0 then
       begin
         DMDica.TbDicas.Filter := 'CodDica=''' + DMDica.TbDicasCodDica.AsString + '''';
         DMDica.TbDicas.Filtered := True;
       end
     else
         DMDica.TbDicas.Filtered := False;

     Report.Preview;
     DMDica.TbDicas.Filter   := '';
     DMDica.TbDicas.Filtered := False;
     edPesq.Text := ''; 
     fmRelDic.Free;

end;

procedure TfmRelOpc.rgRelOrdClick(Sender: TObject);
begin
    if rgRelOrd.ItemIndex = 0 then
       DMDica.TbDicas.IndexFieldNames := 'PalPort'
    else
       DMDica.TbDicas.IndexFieldNames := 'PalIngl';
end;

procedure TfmRelOpc.rgRelTipoClick(Sender: TObject);
begin
    if rgRelTipo.ItemIndex = 0 then
       gbDica.Visible := True
    else
       gbDica.Visible := False;
end;

procedure TfmRelOpc.edPesqClick(Sender: TObject);
begin
    edPesq.Text := ''; 
end;

procedure TfmRelOpc.FormCreate(Sender: TObject);
begin
    DMDica.TbDicas.First;
end;

procedure TfmRelOpc.edPesqChange(Sender: TObject);
begin
   if rgRelOrd.ItemIndex = 0 then
      DMDica.TbDicas.Locate('PalPort', edPesq.text,[loPartialkey])
   else
      DMDica.TbDicas.Locate('PalIngl', edPesq.text,[loPartialkey]);
end;

procedure TfmRelOpc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action := caFree;
end;

end.

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




unit RecCal03;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, measurement;

type
  TfmRecCal03 = class(TForm)
    pa_RCFS01: TPanel;
    gbTempCorp: TGroupBox;
    rgAFPac: TRadioGroup;
    rgLesaoPac: TRadioGroup;
    paTempCorp: TPanel;
    tbTempCorpPac: TTrackBar;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    rgTemFebre: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure rgAFPacClick(Sender: TObject);
    procedure rgLesaoPacClick(Sender: TObject);
    procedure tbTempCorpPacChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgTemFebreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRecCal03.FormShow(Sender: TObject);
var
   mdTemp : TMedida;
   I : Integer;
begin
   if dmMotherBoard.caProcessador.Memoria.Acha( 'mdAFPac', TObject( mdTemp ) ) then
      for I := 0 to rgAFPac.Items.Count - 1 do
          if mdTemp.ValorNumerico = rgAFPac.Items.Strings[I] then
             rgAFPac.ItemIndex := I;
   rgAFPacClick(Sender);
   if dmMotherBoard.caProcessador.Memoria.Acha( 'mdLesaoPac', TObject( mdTemp ) ) then
      for I := 0 to rgLesaoPac.Items.Count - 1 do
          if mdTemp.ValorNumerico = rgLesaoPac.Items.Strings[I] then
             rgLesaoPac.ItemIndex := I;
   rgLesaoPacClick(Sender);
   if dmMotherBoard.caProcessador.Memoria.Acha( 'mdTempCorpPac', TObject( mdTemp ) ) then
      if mdTemp.ValorNumerico = 'Normal' then
      begin
         tbTempCorpPac.Position := 38;
         rgTemFebre.ItemIndex := 1;
      end
      else
      begin
         tbTempCorpPac.Position := StrToInt( mdTemp.ValorNumerico );
         rgTemFebre.ItemIndex := 0;
      end;
   rgTemFebreClick(Sender);

end;

procedure TfmRecCal03.rgAFPacClick(Sender: TObject);
var
   mdTemp : TMedida;
begin
   if dmMotherBoard.caProcessador.Memoria.Acha( 'mdAFPac', TObject( mdTemp ) ) then
      mdTemp.ValorNumerico := rgAFPac.Items.Strings[rgAFPac.ItemIndex];
end;

procedure TfmRecCal03.rgLesaoPacClick(Sender: TObject);
var
   mdTemp : TMedida;
begin
   if dmMotherBoard.caProcessador.Memoria.Acha( 'mdLesaoPac', TObject( mdTemp ) ) then
      mdTemp.ValorNumerico := rgLesaoPac.Items.Strings[rgLesaoPac.ItemIndex];
end;

procedure TfmRecCal03.tbTempCorpPacChange(Sender: TObject);
var
   mdTemp : TMedida;
begin
 if dmMotherBoard.caProcessador.Memoria.Acha( 'mdTempCorpPac', TObject( mdTemp ) ) then
 begin
   if rgTemFebre.ItemIndex = 0 then
   begin
       mdTemp.ValorNumerico := IntToStr( tbTempCorpPac.Position );
       mdTemp.Unidade := 'oC';
   end
   else
   begin
       mdTemp.ValorNumerico := 'Normal';
       mdTemp.Unidade := '';
   end;
 end;      

end;

procedure TfmRecCal03.FormCreate(Sender: TObject);
begin
Tag:=0;
end;

procedure TfmRecCal03.rgTemFebreClick(Sender: TObject);
//var
//   mdTemp : TMedida;
begin
if rgTemFebre.ItemIndex = 1 then
begin
   gbTempCorp.Visible := False;
end
else if rgTemFebre.ItemIndex = 0 then
begin
   gbTempCorp.Visible := True;
end;
tbTempCorpPacChange(Sender);
end;

end.

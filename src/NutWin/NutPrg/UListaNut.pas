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




unit UListaNut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DBCtrls, Spin, Grids, DBGrids, ComCtrls, NutCnst;

type
  TfmListNut = class(TForm)
    paVNut2: TPanel;
    rgVisNut: TRadioGroup;
    btVisualiza: TButton;
    Label1: TLabel;
    btFecha: TButton;
    edGramas: TSpinEdit;
    Label2: TLabel;
    lcMCVisNut: TDBLookupListBox;
    Button1: TButton;
    btSelec: TButton;
    paVNut1: TPanel;
    lvNutCalc: TListView;
    procedure btVisualizaClick(Sender: TObject);
    procedure btFechaClick(Sender: TObject);
    procedure rgVisNutClick(Sender: TObject);
    procedure edGramasChange(Sender: TObject);
    procedure lcMCVisNutClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btSelecClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure EncheListaNutrientes ( SoVisiveis : boolean ) ;
  end;

var
  fmListNut: TfmListNut;

implementation

uses DMNutrien, Alimento, DMAliPrep, URListNut;

{$R *.DFM}

procedure TfmListNut.EncheListaNutrientes ( SoVisiveis : boolean )  ;

var
   ListItem: TListItem;
   controle : boolean;

begin
   with lvNutCalc do
   begin
   controle := True ;
   DMNutrientes.DSNutrientesbk.DataSet.DisableControls;
   DMNutrientes.TbNutrientesbk.First;
   lvNutCalc.Items.Clear;
   // adiciono os dados dos nutrientes ...
    while controle do
    begin

      // Se SoVisiveis for False, pego tudo, se True, vejo se o campo esta´ marcado ...
      if SoVisiveis = True then
       begin
//kelvis        if DMNutrientes.TbNutrientesbkVISIVEL.asBoolean = True  then
        if DMNutrientes.TbNutrientesbk.FieldByName('VISIVEL').AsString = 'T' then
           // campo está marcado com True, pego os dados ...
           begin
             ListItem := Items.Add;
             ListItem.Caption := DMNutrientes.TbNutrientesbk.FieldByName('NOMENUT').asString;
             if (DMNutrientes.TbNutrientesbk.FieldByName('ValorNut').asString = '') or (edGramas.Text = '') then
                ListItem.SubItems.Add( '' )
             else
                ListItem.SubItems.Add(FloattoStr((DMNutrientes.TbNutrientesbk.FieldByName('ValorNut').asFloat * StrtoFloat(edGramas.Text))/ 100 ));
             ListItem.SubItems.Add(DMNutrientes.TbNutrientesbk.FieldByName('Unidade').asString);
           end
       end
      else
       begin
        ListItem := Items.Add;
        ListItem.Caption := DMNutrientes.TbNutrientesbk.FieldByName('NOMENUT').asString;
        if (DMNutrientes.TbNutrientesbk.FieldByName('ValorNut').asString = '') or (edGramas.Text = '') then
           ListItem.SubItems.Add( '' )
        else
           ListItem.SubItems.Add(FloattoStr((DMNutrientes.TbNutrientesbk.FieldByName('ValorNut').asFloat * StrtoFloat(edGramas.Text))/ 100 ));
        ListItem.SubItems.Add(DMNutrientes.TbNutrientesbk.FieldByName('Unidade').asString);
       end;

      DMNutrientes.TbNutrientesbk.Next;
      if DMNutrientes.TbNutrientesbk.EOF then
         controle := False ;

    end;
       DMNutrientes.DSNutrientesbk.DataSet.EnableControls;
       DMNutrientes.TbNutrientesbk.First;
  end;
end;

procedure TfmListNut.btVisualizaClick(Sender: TObject);
var
   SalvaCursor:TCursor;
begin
 SalvaCursor := Screen.Cursor;     { Salva cursor atual }
 Screen.Cursor := crHourglass;     { Mostra ampulheta }
 EncheListaNutrientes( False );
 Screen.Cursor := SalvaCursor ;  { Retorna a ampulheta para estado original }
end;

procedure TfmListNut.btFechaClick(Sender: TObject);
begin
   Close;
end;

procedure TfmListNut.rgVisNutClick(Sender: TObject);
begin
        edGramas.Text := '0' ;
    if  rgVisNut.ItemIndex = 1 then
        begin
        lcMCVisNut.Visible := True;
        edGramas.Text := DMAlimentos.TbMCVisNut.Fieldbyname('VALOR').AsString;
        edGramas.Enabled  := False;
        end
    else   // quando for em gramas
        begin
        lcMCVisNut.Visible := False;
        edGramas.Enabled  := True;
        end;

end;

procedure TfmListNut.edGramasChange(Sender: TObject);
begin
   //lbNutCalc.Items.Clear;
end;

procedure TfmListNut.lcMCVisNutClick(Sender: TObject);
begin
   edGramas.Text := DMAlimentos.TbMCVisNutVALOR.AsString;
end;

procedure TfmListNut.Button1Click(Sender: TObject);
var
   SalvaCursor:TCursor;
   Rel : TfmRelListNut;
begin
   SalvaCursor := Screen.Cursor;     { Salva cursor atual }
   Screen.Cursor := crHourglass;     { Mostra ampulheta }
   // Crio o relatório
   Rel := TfmRelListNut.Create(nil);
   Try
      Rel.Report.PreviewModal;
   finally
      Rel.Free;
      Screen.Cursor := SalvaCursor ;  { Retorna a ampulheta para estado original }
      Screen.Cursor := crDefault;     { Mostra default }
   end;
end;

procedure TfmListNut.btSelecClick(Sender: TObject);
var
   SalvaCursor:TCursor;
begin
 SalvaCursor := Screen.Cursor;     { Salva cursor atual }
 Screen.Cursor := crHourglass;     { Mostra ampulheta }
 EncheListaNutrientes( True );
 Screen.Cursor := SalvaCursor ;  { Retorna a ampulheta para estado original }
end;

procedure TfmListNut.FormShow(Sender: TObject);
begin
     EncheListaNutrientes( False );
end;

procedure TfmListNut.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if ( fmRelListNut <> nil ) and ( fmRelListNut.Report.Printer <> nil ) and  not ( fmRelListNut.Report.Printer.ShowingPreview ) then
      FreeAndNil( fmRelListNut );

end;

end.

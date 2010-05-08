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




unit DMFrml;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Db, DBTables, DicNut, OCXDCNLib_TLB;

type
  TDMFormulas = class(TDataModule)
    DSFlat: TDataSource;
    Flat: TTable;
    PaisFilhos: TTable;
    DSPF: TDataSource;
    TabFrml: TTable;
    DSFrml: TDataSource;
    TabTab: TTable;
    DSTab: TDataSource;
    TabMed: TTable;
    DSMed: TDataSource;
    FlatPai: TTable;
    DSFPai: TDataSource;
    TabFrmlName: TStringField;
    TabFrmlTipo: TStringField;
    TabFrmlExpressao: TStringField;
    TabFrmlData: TDateTimeField;
    TabFrmlDescricao: TStringField;
    Formulas: TNewDic;
    TabFrmlBk: TTable;
    TabFrmlBkNAME: TStringField;
    TabFrmlBkTIPO: TStringField;
    TabFrmlBkEXPRESSAO: TStringField;
    TabFrmlBkDATA: TDateTimeField;
    TabFrmlBkDESCRICAO: TStringField;
    TabMedBk: TTable;
    TabMedBkNAME: TStringField;
    TabMedBkDESCRICAO: TStringField;
    TabMedBkUNIDADEDEFAULT: TStringField;
    TabMedBkVALORDEFAULT: TStringField;
    TabMedBkLISTANUMEROS: TStringField;
    TabMedBkLISTAUNIDADES: TStringField;
    TabMedBkPRECISAO: TFloatField;
    TabMedBkDESCRIPTORNAME: TStringField;
    TabTabBk: TTable;
    TabTabBkNAME: TStringField;
    TabTabBkDATABASENAME: TStringField;
    TabTabBkNOMETABELA: TStringField;
    TabTabBkCAMPORESULT: TStringField;
    TabTabBkMODOPESQUISA: TStringField;
    procedure TabFrmlTipoChange(Sender: TField);
    procedure TabFrmlTipoValidate(Sender: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMFormulas: TDMFormulas;

implementation

{$R *.DFM}

procedure TDMFormulas.TabFrmlTipoChange(Sender: TField);
begin
if Sender.AsString = 'Tab' then
   begin
   if not TabTab.Locate ('Name',TabFrmlName.AsString,[]) then
      begin
      TabTab.Insert;
      TabTab.FieldByName ('Name').AsString:=TabFrmlName.AsString;
      end;
   end;

end;

procedure TDMFormulas.TabFrmlTipoValidate(Sender: TField);
begin
   if (TabFrmlName.AsString <> '') and TabTab.Locate ('Name',TabFrmlName.AsString,[])
      and (Sender.AsString='Fmla') then
      begin
      if MessageDlg('Mudar o tipo vai apagar o registro relacionado da Tabela.'+ #13#10+'Quer continuar?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          TabTab.Delete
      else
          TabFrml.Cancel;

      end;

end;

end.

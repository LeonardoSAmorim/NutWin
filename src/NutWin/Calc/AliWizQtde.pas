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




unit AliWizQtde;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FnpNumericEdit, ComCtrls, ToolWin, DBCtrls, ExtCtrls,
  PAINELMEDIDA, Measurement, Buttons, Clipbrd, FnpNEditBlank, Wizard, NutAli,
  InsFrm;

type
  TfmAliWizQtde = class(TForm)
    paQtdeAli: TPanel;
    teNomeAli: TDBText;
    teNomeMedida: TDBText;
    pmQtdeAli: TPainelMedida;
    laDescricaoQtdeAli: TLabel;
    laUnidadeQtdeAli: TLabel;
    tePesoMed: TDBText;
    Label3: TLabel;
    beQtdeAli: TBevel;
    imQtdeAli: TImage;
    fbValorNumericoQtdeAli: TFnpNEditBlank;
    paNutrientes: TPanel;
    IfNut: TInFormBuilder;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure pmQtdeAliChangeValue(Sender: TObject);
    procedure IfNutNovoForm(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAliWizQtde: TfmAliWizQtde;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmAliWizQtde.FormShow(Sender: TObject);
begin
   // Seta o foco no localizar
   fbValorNumericoQtdeAli.SetFocus;
   if fbValorNumericoQtdeAli.Value = 0 then
      Tag := WZ_INVALIDNODE
   else
      Tag := 0;
   Click;
   if Assigned(IfNut.FormBuilded) then
      IfNut.ShowInForm
   else
      IfNut.CriaFormInterno( TfmNutrientes );
   if Assigned( TfmNutrientes(IfNut.FormBuilded ).Nutrientes ) then
   begin
      if not TfmNutrientes(IfNut.FormBuilded ).Nutrientes.ListaDeMedidasNutrientes.DataSet.Locate( 'IDMEDCAS', dmMotherBoard.dsMedCas.DataSet.FieldByName( 'IDMEDCAS' ).AsString, [] ) then
         ShowMessage('Medida não localizada!');
      TfmNutrientes(IfNut.FormBuilded ).Nutrientes.MedidaEmGramas := False;
      TfmNutrientes(IfNut.FormBuilded ).Nutrientes.QtdeMedidaAli := fbValorNumericoQtdeAli.Value;
   end;
end;

procedure TfmAliWizQtde.FormHide(Sender: TObject);
begin
   IfNut.CloseInForm;
   pmQtdeAli.Refresh;
   with dmMotherBoard do
   begin
      mdAliPeso.AsFloat := mdAliQtde.AsFloat * MedidasCaseiras.ListaDeMedidas.DataSet.FieldByName( 'VALOR' ).AsFloat;
   end;
   Click;
end;

procedure TfmAliWizQtde.pmQtdeAliChangeValue(Sender: TObject);
begin
   if fbValorNumericoQtdeAli.Value = 0 then
      Tag := WZ_INVALIDNODE
   else
      Tag := 0;
   Click;
   if Assigned( TfmNutrientes(IfNut.FormBuilded ).Nutrientes ) then
   begin
      TfmNutrientes(IfNut.FormBuilded ).Nutrientes.MedidaEmGramas := False;
      TfmNutrientes(IfNut.FormBuilded ).Nutrientes.QtdeMedidaAli := fbValorNumericoQtdeAli.Value;
   end;
end;

procedure TfmAliWizQtde.IfNutNovoForm(Sender: TObject);
begin
   TfmNutrientes(IfNut.FormBuilded ).paNutMedidas.Height := 0;
   TfmNutrientes(IfNut.FormBuilded ).Height := paNutrientes.Height;
   TfmNutrientes(IfNut.FormBuilded ).Position := poDesigned;
   TfmNutrientes(IfNut.FormBuilded ).Nutrientes := dmMotherBoard.Nutrientes;
end;

end.


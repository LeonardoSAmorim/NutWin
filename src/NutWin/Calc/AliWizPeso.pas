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




unit AliWizPeso;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FnpNumericEdit, DBCtrls, ExtCtrls, PAINELMEDIDA, Measurement,
  FnpNEditBlank, Wizard, NutAli, InsFrm;

type
  TfmAliWizPeso = class(TForm)
    paPesoAli: TPanel;
    teNomeAli: TDBText;
    pmPesoAli: TPainelMedida;
    laDescricaoPesoAli: TLabel;
    laUnidadePesoAli: TLabel;
    bePesoAli: TBevel;
    imPesoAli: TImage;
    fbValorNumericoPesoAli: TFnpNEditBlank;
    paNutrientes: TPanel;
    IfNut: TInFormBuilder;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure pmPesoAliChangeValue(Sender: TObject);
    procedure IfNutNovoForm(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAliWizPeso: TfmAliWizPeso;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmAliWizPeso.FormShow(Sender: TObject);
begin
   fbValorNumericoPesoAli.SetFocus;
   if fbValorNumericoPesoAli.Value = 0 then
      Tag := WZ_INVALIDNODE
   else
      Tag := 0;
   Click;
   if Assigned(IfNut.FormBuilded) then
      IfNut.ShowInForm
   else
      IfNut.CriaFormInterno( TfmNutrientes );
   if Assigned( TfmNutrientes(IfNut.FormBuilded ).Nutrientes ) then
      TfmNutrientes(IfNut.FormBuilded ).Nutrientes.PesoAli := fbValorNumericoPesoAli.Value;
end;

procedure TfmAliWizPeso.FormHide(Sender: TObject);
begin
      IfNut.CloseInForm;
      pmPesoAli.Refresh;
      Click;
end;

procedure TfmAliWizPeso.pmPesoAliChangeValue(Sender: TObject);
begin
   if fbValorNumericoPesoAli.Value = 0 then
      Tag := WZ_INVALIDNODE
   else
      Tag := 0;
   Click;
   if Assigned( TfmNutrientes(IfNut.FormBuilded ).Nutrientes ) then
      TfmNutrientes(IfNut.FormBuilded ).Nutrientes.PesoAli := fbValorNumericoPesoAli.Value;
end;

procedure TfmAliWizPeso.IfNutNovoForm(Sender: TObject);
begin
   TfmNutrientes(IfNut.FormBuilded ).paNutMedidas.Height := 0;
   TfmNutrientes(IfNut.FormBuilded ).Height := paNutrientes.Height;
   TfmNutrientes(IfNut.FormBuilded ).Position := poDesigned;
   TfmNutrientes(IfNut.FormBuilded ).Nutrientes := dmMotherBoard.Nutrientes;
end;

end.

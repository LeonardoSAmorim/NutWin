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




unit UEESelecaoGrupo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, RXLookup, DBCtrls, Wizard;

type
  TfmEESelecaoGrupo = class(TForm)
    paEESelecaoGrupo: TPanel;
    Label1: TLabel;
    llEquivEnerg: TRxDBLookupList;
    deAlim: TDBText;
    DBText1: TDBText;
    paEquiv: TPanel;
    lbQtdeEquiv: TLabel;
    lbEquiv: TLabel;
    Label20: TLabel;
    laCal: TLabel;
    procedure FormShow(Sender: TObject);
    procedure llEquivEnergClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  fmEESelecaoGrupo: TfmEESelecaoGrupo;

implementation

uses Alimento, DMSubstCal;

{$R *.DFM}

procedure TfmEESelecaoGrupo.FormShow(Sender: TObject);
begin
    llEquivEnerg.SetFocus;

    if llEquivEnerg.Value = '' then
       begin
          // Faz com que só apareça o botão cancelar do wizard, pois
          // não foi selecionado nenhum grupo
          Tag := WZ_INVALIDNODE;
          Click;
       end;

end;

procedure TfmEESelecaoGrupo.llEquivEnergClick(Sender: TObject);
begin
// Se for grupo a vontade o selecionado
    if (DMSubsCalorico.TbAliGCal.Fieldbyname('IDGRUCAL').asString = '{88DD9371-66F8-11D1-A6A0-008048B86BEE}') then
     begin
       // se o alimento tiver mais de 25 calorias, não pode aceitar o alimento
       if (StrtoFloat(DMSubsCalorico.stCal) > 25 ) then
         begin
          ShowMessage('Este alimento não pode fazer parte deste Grupo de Equivalentes, pois tem mais que 25 kcal em 100 gr.');
          // Faz com que só apareça o botão cancelar do wizard, pois
          // não foi selecionado nenhum grupo
          Tag := WZ_INVALIDNODE;
          Click;
          Exit;
         end
       else
         // casos que são a vontade, nem preciso mostrar as demais telas
         begin
         // gravo algum valor, escolhi o de medidas indicado, para não ficar em branco, senão dá erro.
          DMSubsCalorico.TbAliGCal.FieldbyName('MedGr').asFloat := StrToFloat(DMSubsCalorico.SCEquiv) ;
          // desabilito os valores de equivalentes ao grupo
         paEquiv.Visible := False;

          Tag := 1; // habilita somente o cancelar e adicionar
          Click;
          Exit;
         end;

       //
     end
   else if DMSubsCalorico.SCEquiv <> '0' then
      begin
         // limpo o campo, porque pode ter ficado registrado o valor em gramas do grupo a vontade
         DMSubsCalorico.TbAliGCal.FieldbyName('MedGr').asFloat := StrToFloat('0') ;

         lbEquiv.caption := DMSubsCalorico.SCEquiv;   // qtde alimento p/ equiv. ao grupo
         // Habilita o botão de avançar, pois foi escolhido um grupo
         Tag := 0;
         Click;
      end;
   // Volto para a configuração inicial
   paEquiv.Visible := True;
   laCal.Caption := '100 g deste alimento contêm ' + Trim( DMSubsCalorico.stCal ) + ' calorias'; // caloria em 100 gr

end;

end.

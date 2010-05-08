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




unit UEPSelecGrupo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXLookup, DBCtrls, StdCtrls, ExtCtrls, Wizard;

type
  TfmEPSelecaoGrupo = class(TForm)
    paEESelecaoGrupo: TPanel;
    Label1: TLabel;
    deAlim: TDBText;
    laProt: TLabel;
    lbEquiv: TLabel;
    lbQtdeEquiv: TLabel;
    Label20: TLabel;
    llEquivProt: TRxDBLookupList;
    DBText1: TDBText;
    lbEquivCal: TLabel;
    procedure llEquivProtClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEPSelecaoGrupo: TfmEPSelecaoGrupo;

implementation

uses DMSubstCal;

{$R *.DFM}

procedure TfmEPSelecaoGrupo.llEquivProtClick(Sender: TObject);
var
 stSPEquivCalorias : string;
 stValorCalorico : string;
begin
  lbEquivCal.Caption := ''; // limpando um campo informativo
//  Controla se o Grupo selecionado está dentro do padrão de calorias e de proteínas definido
// 1- Preciso do valor do alimento para equivaler em Proteinas
  DMSubsCalorico.stEquivalente := DMSubsCalorico.SPEquiv;


 // como calculei o stProt (proteinas em 100gr) na funcao acima , vejo se ele é menor que 0 e então passoa a controlar por calorias
//    Grupo Doces/Bebidas = {9A77FF41-8F40-11D2-8C95-00609723109D}
//    Grupo Gorduras = {9A77FF42-8F40-11D2-8C95-00609723109D}
  if (DMSubsCalorico.TbAliGProt.FieldByName('IDGRUPROT').AsString = '{9A77FF41-8F40-11D2-8C95-00609723109D}') or
     (DMSubsCalorico.TbAliGProt.FieldByName('IDGRUPROT').AsString = '{9A77FF42-8F40-11D2-8C95-00609723109D}') then
      begin
        // alimento em 100gr é maior que 1 gr de proteina ? Não posso aceitar
        if DMSubsCalorico.stProt > '1' then
           begin
             if MessageDlg('Para este grupo selecionado, o alimento em 100g deve ter menos que 1g de Proteína. Deseja sair ?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                  begin
                    DMSubsCalorico.EPWiz.Cancelar;
                    Exit;
                  end;
           end
        else   // Calcula para energia, igual ao Equivalente Calorico
           begin
             // 1- Preciso do valor do alimento para equivaler em Calorias
             DMSubsCalorico.stEquivalente := DMSubsCalorico.SCEquivParaProteina;
              // Mudo o label para falar que o calculo esta sendo feito por calorias
             lbQtdeEquiv.caption := 'Quant. do Alimento para equivaler ao Grupo Energético: ';
           end;
      end
  else // para qualquer outro grupo diferente do Doces/Beb ou Gorduras
      begin
       if DMSubsCalorico.stEquivalente = '0' then  // então faço por caloria
          begin
           // 1- Preciso do valor do alimento para equivaler em Calorias
            DMSubsCalorico.stEquivalente := DMSubsCalorico.SCEquivParaProteina;
           // Mudo o label para falar que o calculo esta sendo feito por calorias
            lbQtdeEquiv.caption := 'Quant. do Alimento para equivaler ao Grupo Energético: ';
          end
       else
          begin
           // Mudo o label para falar que o calculo esta sendo feito por proteinas
           lbQtdeEquiv.caption := 'Quant. do Alimento para equivaler ao Grupo Proteico: ';

           // Preciso do valor de calorias em 100 gr. Pego o stCal do DMSubstCalorico e aplico a seguinte formula para
           // descobrir o valor da equivalencia nas gramas apropriadas (que sao equivalentes em proteina)

           stSPEquivCalorias := FloatToStr(Int(( StrtoFloat(DMSubsCalorico.stEquivalente) * StrtoFloat(DMSubsCalorico.stCal) )/100));
           lbEquivCal.Caption := 'Valor energético na porção: ' + stSPEquivCalorias + ' kcal';
           lbEquiv.Caption := '';
           
           // Verifica a equivalencia em calorias, avisa, mas não trava
           if StrtoFloat(stSPEquivCalorias) > DMSubsCalorico.TbGAliProt.Fieldbyname('ValorCaloria').asFloat  then
            begin
             if MessageDlg('Este alimento contêm ' + stSPEquivCalorias + ' kcal na quantidade que equivale ao valor de proteína do grupo e portanto ultrapassa o valor de energia do grupo que é de '+ DMSubsCalorico.TbGAliProt.Fieldbyname('ValorCaloria').asString + ' kcal . Deseja continuar?', mtConfirmation,
               [mbYes, mbNo], 0) = mrNo then
               begin
                 DMSubsCalorico.EPWiz.Cancelar;
                 Exit;
               end
            end;

          end;
  end;

   if DMSubsCalorico.stEquivalente <> '0' then
      begin
         lbEquiv.caption := DMSubsCalorico.stEquivalente;   // qtde alimento p/ equiv. ao grupo
         // Habilita o botão de avançar, pois foi escolhido um grupo
         Tag := 0;
         Click;
      end;

   laProt.Caption := 'Em 100g do Alimento temos ' + Trim( DMSubsCalorico.stProt ) + 'g de Proteína'; // proteina em 100 gr

end;

procedure TfmEPSelecaoGrupo.FormShow(Sender: TObject);
begin
    llEquivProt.SetFocus;
    if llEquivProt.Value = '' then
       begin
          // Faz com que só apareça o botão cancelar do wizard, pois
          // não foi selecionado nenhum grupo
          Tag := WZ_INVALIDNODE;
          Click;
       end;
end;

end.

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




unit RecCal01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Spin, ComCtrls, measurement, Memoria, Procedimento;

type
  TfmRecCal01 = class(TForm)
    pa_RC01: TPanel;
    rgRecCal: TRadioGroup;
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgRecCalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOldItemIndex : Integer;
    procedure SetaAtivFisFreqIndex(const Indice : Integer; const Texto : String);
  public
    { Public declarations }
     function EncheListas: Boolean;
  end;

implementation

uses DMMBoard;

{$R *.DFM}

function TfmRecCal01.EncheListas: Boolean;
var
   AuxCx,
   AuxPr : TComponent;
   I : Integer;
   TemChecked : Boolean;
begin
   TemChecked := False;
   rgRecCal.Items.Clear;
   Result := False;
   AuxCx := dmMotherBoard.caProcessador.Memoria.FindComponent( 'cxcaRecCal' );
   if Assigned( AuxCx ) then
    if ( AuxCx is TCaixa ) then
     with (AuxCx as TCaixa ) do
     begin
        For I := 0 to AuxCx.ComponentCount - 1 do
        begin
           AuxPr := AuxCx.Components[I];
           if ( AuxPr is TProcedimento ) then
           with (AuxPr as TProcedimento ) do
           begin
              Tag := I; // Para que o wizard use
              if Estado = psChecked then
                begin
                 rgRecCal.Items.AddObject( Descricao, AuxPr );
                 rgRecCal.ItemIndex := I;
                 Tag := AuxPr.Tag;
                 TemChecked := True;
                end
              else if Estado = psNone then
                 rgRecCal.Items.AddObject( Descricao, AuxPr );
              Result := True;
           end;
        end;
     end;
     if rgRecCal.ItemIndex < 0 then
        rgRecCal.ItemIndex := 0;
     if not TemChecked then
        TProcedimento(rgRecCal.Items.Objects[rgRecCal.ItemIndex]).Estado := psChecked;
end;

procedure TfmRecCal01.FormHide(Sender: TObject);
begin
   with dmMotherBoard.caProcessador do
   begin
      // Criacao das medidas da lista de calculos de saida
      Procedimentos.Clear;
      Procedimentos.Add( TProcedimento(rgRecCal.Items.Objects[rgRecCal.ItemIndex]).Name );
      CriaMedidas;
   end;
end;

procedure TfmRecCal01.FormShow(Sender: TObject);
begin
   Tag:=TProcedimento(rgRecCal.Items.Objects[rgRecCal.ItemIndex]).Tag;
end;

procedure TfmRecCal01.rgRecCalClick(Sender: TObject);
begin
    if FOldItemIndex <> rgRecCal.ItemIndex then
      begin
       if not dmMotherBoard.LimpaRecNut( 'cxRecNut' ) then
          ShowMessage( 'Houve um erro na inicialização dos nutrientes' );
       TProcedimento(rgRecCal.Items.Objects[FOldItemIndex]).Estado := psNone;
       FOldItemIndex := rgRecCal.ItemIndex;
       TProcedimento(rgRecCal.Items.Objects[rgRecCal.ItemIndex]).Estado := psChecked;
//@       dmMotherBoard.caProcessador.Memoria.AddModified;
      end;

   //Duas linhas necessarias para que o Wizard funcione
   Tag:= TProcedimento(rgRecCal.Items.Objects[rgRecCal.ItemIndex]).Tag;
   //Refresh do Wizard
   Click;

end;

procedure TfmRecCal01.FormCreate(Sender: TObject);
begin
   FOldItemIndex := 0;
   rgRecCal.ItemIndex := 0;
   EncheListas;
   FOldItemIndex := rgRecCal.ItemIndex;
   Tag:=TProcedimento(rgRecCal.Items.Objects[rgRecCal.ItemIndex]).Tag;
   // Estou chamando isto, pois em algum lugar
   // Pode-se fazer acesso a medida criada/alterada aqui
   SetaAtivFisFreqIndex( 0, 'Por Dia' );
end;

// Esta rotina é para simular o que o form TfmRecCal02 estava fazendo
// Se precisar chamá-lo. A net em CNut.net foi alterada pra isto, também
procedure TfmRecCal01.SetaAtivFisFreqIndex(const Indice : Integer; const Texto : String);
var
   mdRCAtivFisFreq : TMedida;
begin
   with dmMotherBoard.caProcessador.Memoria do
   begin
      if not Acha('mdRCAtivFisFreq', TObject( mdRCAtivFisFreq )) then
         begin
            mdRCAtivFisFreq := TMedida.Create(self);
            mdRCAtivFisFreq.Name := 'mdRCAtivFisFreq';
            mdRCAtivFisFreq.Descricao := Texto;
            mdRCAtivFisFreq.ValorNumerico := IntToStr(Indice);
            mdRCAtivFisFreq.Unidade := 'ItemIndex';
            mdRCAtivFisFreq.Valid := True;
            Adiciona('mdRCAtivFisFreq', mdRCAtivFisFreq, 'cxcaRecCal');
            mdRCAtivFisFreq.Free;
         end
      else
         begin
            if not Acha('mdRCAtivFisFreq', TObject( mdRCAtivFisFreq )) then
               ShowMessage( 'Houve um erro na carga do tipo de cálculo' )
            else
               begin
                  mdRCAtivFisFreq.Descricao := Texto;
                  mdRCAtivFisFreq.ValorNumerico := IntToStr(Indice);
               end;
         end;
   end;
   Tag := Indice;
end;

end.

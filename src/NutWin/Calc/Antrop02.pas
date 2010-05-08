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




unit Antrop02;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, MmLstBox, MontaLst, DMMBoard, VisorCal,Measurement,
  cxLstBox, Procedimento, Wizard, HintListBox;

type
  TfmAntrop01 = class(TForm)
    moAntropometria: TMontaLista;
    gbAntropEscolha: TGroupBox;
    laAntropExplicaEscolha: TLabel;
    laTipoCalculos: TLabel;
    laCalculosEscolhidos: TLabel;
    bbAntropAdicionar: TBitBtn;
    bbAntropExcluir: TBitBtn;
    bbAntropTodos: TBitBtn;
    bbAntropLimpar: TBitBtn;
    vcAntrop01: TVisorCalculo;
    clAntropSaida: TCxListBox;
    clAntropEntrada: TCxListBox;
    cbAtivaHint: TCheckBox;
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure moAntropometriaDepoisDeMover(Sender: TObject);
    procedure cbAtivaHintClick(Sender: TObject);
    procedure clAntropEntradaBeforeShowItemHint(Sender: TObject;
      Index: Integer; var Hint: String);
    procedure clAntropSaidaBeforeShowItemHint(Sender: TObject;
      Index: Integer; var Hint: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TfmAntrop01.FormHide(Sender: TObject);
var
   I : Integer;
begin
   // Atualiza lista de entrada e saida na memoria
   moAntropometria.EncheListas;

   with dmMotherBoard.caProcessador do
   begin
      // Criacao das medidas da lista de calculos de saida
      Procedimentos.Clear;
      For I := 0 to moAntropometria.Saida.Items.Count - 1 do
          Procedimentos.Add( TProcedimento(moAntropometria.Saida.Items.Objects[I]).Name );
      CriaMedidas;
   end;
end;

procedure TfmAntrop01.FormShow(Sender: TObject);
begin
   // Atualiza medidas do form
   vcAntrop01.Refresh;
   // Atualiza listas na memoria
   moAntropometria.EncheListas;

   FormHide(self);
   dmMotherBoard.CorpoHumano.SelecionaPontosCalculo (dmMotherBoard.caProcessador.ListaParametro);
   if moAntropometria.Saida.Items.Count = 0 then
      // não foi escolhida nenhuma medida, portanto, não dá para terminar
      Tag:=WZ_INVALIDNODE
   // Verifica se tem alguma medida para entrar
   else if dmMotherBoard.CorpoHumano.PontosCalculo.Count = 0 then
      begin
      //Nao existem medidas para este calculo
      //Pode terminar direto
      Tag:=0;
      end
   else
      Tag:=1;
   //Refresh do Wizard, que esta conectado no OnClick
   Click;

end;

procedure TfmAntrop01.FormCreate(Sender: TObject);
begin
   // Seta memoria e nome da caixa onde o montalista vai pegar os procedimentos
   moAntropometria.Memoria := dmMotherBoard.caProcessador.Memoria;
   moAntropometria.NomeCaixa := 'cxcaAntrop';
   // Estou forcando,pois vive perdendo esta referencia
   vcAntrop01.Calculo := dmMotherBoard.caProcessador;
   Tag:=0;
end;

procedure TfmAntrop01.moAntropometriaDepoisDeMover(Sender: TObject);
begin
   // Se moveu algo, poe em modo de memoria modificada
//@   dmMotherBoard.caProcessador.Memoria.AddModified;
   FormHide(self);
   dmMotherBoard.CorpoHumano.SelecionaPontosCalculo (dmMotherBoard.caProcessador.ListaParametro);
   //Acerta os botoes do wizard
   if moAntropometria.Saida.Items.Count = 0 then
      // não foi escolhida nenhuma medida, portanto, não dá para terminar
      Tag:=WZ_INVALIDNODE
   else if dmMotherBoard.CorpoHumano.PontosCalculo.Count > 0  then
      self.Tag:=1
   else
      begin
      //Nao existem medidas para este calculo
      //Pode terminar direto
      self.Tag:=0;
      end;
   //Refresh do Wizard, que esta conectado no OnClick
   Click;
end;


procedure TfmAntrop01.cbAtivaHintClick(Sender: TObject);
begin
   if cbAtivaHint.Checked then
   begin
      clAntropSaida.OnBeforeShowItemHint := clAntropSaidaBeforeShowItemHint;
      clAntropEntrada.OnBeforeShowItemHint := clAntropEntradaBeforeShowItemHint;
   end
   else
   begin
      clAntropSaida.OnBeforeShowItemHint := nil;
      clAntropEntrada.OnBeforeShowItemHint := nil;
   end
end;

procedure TfmAntrop01.clAntropEntradaBeforeShowItemHint(Sender: TObject;
  Index: Integer; var Hint: String);
begin
   with TProcedimento( clAntropEntrada.Items.Objects[Index] ) do
   begin
      Hint := Descricao + #13 +
              'Escopo: ' + Escopo;
   end;
end;

procedure TfmAntrop01.clAntropSaidaBeforeShowItemHint(Sender: TObject;
  Index: Integer; var Hint: String);
begin
   with TProcedimento( clAntropSaida.Items.Objects[Index] ) do
   begin
      Hint := Descricao + #13 +
              'Escopo: ' + Escopo;
   end;
end;

end.


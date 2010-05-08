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




unit SelRefCalcAli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MmLstBox, ExtCtrls, MontaLst, CalcAli, Wizard, DBCtrls,
  Grids, DBGrids, RXLookup, HintListBox, NutCnst;

type
  TfmSelRefCalcAli = class(TForm)
    mlSelRef: TMontaLista;
    Label1: TLabel;
    Label2: TLabel;
    lbSaida: TMmListBox;
    lbEntrada: TMmListBox;
    bbRefExcluir: TBitBtn;
    bbRefTodos: TBitBtn;
    bbRefLimpar: TBitBtn;
    bbRefAdicionar: TBitBtn;
    lcModRefeicao: TRxDBLookupCombo;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure mlSelRefDepoisDeMoverItem(Sender: TObject; Item: String;
      Destino: TDestino);
    procedure mlSelRefDepoisDeMover(Sender: TObject);
    procedure lbSaidaKeyPress(Sender: TObject; var Key: Char);
    procedure lbEntradaKeyPress(Sender: TObject; var Key: Char);

    procedure KeyPress( Sender : TObject; var Key : Char ); reintroduce;
    procedure mlSelRefErroAoMover(Sender: TObject; Item: String;
      Destino: TDestino);
    procedure lcModRefeicaoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure DefineCaminhoWizard;
  public
    { Public declarations }
  end;

var
  fmSelRefCalcAli: TfmSelRefCalcAli;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmSelRefCalcAli.FormShow(Sender: TObject);
begin
   with TCalculoAlimentar( dmMotherBoard.ProcessadorAtual ) do
   begin
   PegaRefeicoesSelecionadas;
   lbEntrada.Items.Assign( EntradaRefeicao );
   lbSaida.Items.Assign( SaidaRefeicao );
   end;
   DefineCaminhoWizard;
end;

procedure TfmSelRefCalcAli.FormHide(Sender: TObject);
//*****var
//*****   I, J : Integer;
//*****   JaPasseiAqui : Boolean;
begin
//*****   JaPasseiAqui := False;
   with TCalculoAlimentar( dmMotherBoard.ProcessadorAtual ) do
   begin
{ ********************* INTERDITADO POIS NÃO FUNCIONOU **************************
      // verifica que foi tirado da entrada para pedir confirmação de exclusão
      for I := 0 to EntradaRefeicao.Count - 1 do
      begin
         if lbEntrada.Items.IndexOf( EntradaRefeicao.Strings[I] ) < 0 then
         begin
             if MessageDlg('A refeição: ' + EntradaRefeicao.Strings[I] + ' foi retirada da lista de escolhidas. ' + #13#10 +
                           'Portanto, todos os alimentos escolhidos para ela serão retirados também.' + #13#10 +
                           'Confirma exclusão desta refeição?', mtWarning, [mbYes, mbNo], 0) = mrNo then
             begin
                 // Se global foi escolhida, tem que tirar para a outra entrar
                 if ( lbEntrada.Items.Count = 1 ) and
                    Assigned( lbEntrada.Items.Objects[0] ) and
                    ( lbEntrada.Items.Objects[0] is TGUIDItem ) and
                    ( TGUIDItem(lbEntrada.Items.Objects[0]).Exclusive ) and
                    ( TGUIDItem(lbEntrada.Items.Objects[0]).Guid = IDREFGLOBAL ) and
                    not JaPasseiAqui then
                 begin
                    JaPasseiAqui := True;
                    lbSaida.Items.AddObject( lbEntrada.Items.Strings[0], lbEntrada.Items.Objects[0] );
                    lbEntrada.Items.Delete(0);
                 end;
                 // Coloca na entrada a refeição
                 J := lbSaida.Items.IndexOf( EntradaRefeicao.Strings[I] );
                 if J >= 0 then
                 begin
                    lbEntrada.Items.AddObject( lbSaida.Items.Strings[J], lbSaida.Items.Objects[J] );
                    lbSaida.Items.Delete(J);
                 end
                 else
                   ShowMessage( 'Não consegui recuperar refeição.' );
             end;
         end;
      end;
**********************NÃO FUNCIONOU*************************************}
      EntradaRefeicao.Assign( lbEntrada.Items );
      SaidaRefeicao.Assign( lbSaida.Items );
      SetaRefeicoesSelecionadas;
   end;
end;

procedure TfmSelRefCalcAli.mlSelRefDepoisDeMoverItem(Sender: TObject;
  Item: String; Destino: TDestino);
begin
   DefineCaminhoWizard;
end;

procedure TfmSelRefCalcAli.mlSelRefDepoisDeMover(Sender: TObject);
begin
   DefineCaminhoWizard;
end;

procedure TfmSelRefCalcAli.DefineCaminhoWizard;
begin
   //Precisa escolher uma refeição, ao menos, para continuar
   if lbEntrada.Items.Count = 0 then
      Tag := WZ_INVALIDNODE // terminar

// Desligar temporariamente - fica para uma outra versão
{   else if Assigned( dmMotherBoard.ProcessadorAtual ) and
           ( dmMotherBoard.ProcessadorAtual is TCalculoDieta ) and
           ( lbEntrada.Items.Count > 1 ) then
      Tag := 1 // distribuicao de energia }

   // Continuar   
   else
      Tag := 0;
   //Refresh do Wizard
   Click;
end;

procedure TfmSelRefCalcAli.lbSaidaKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #32 then
      mlSelRef.MoveParaEntrada
   else if Key = chr(VK_RETURN) then
      KeyPress( Sender, Key );
end;

procedure TfmSelRefCalcAli.lbEntradaKeyPress(Sender: TObject;
  var Key: Char);
begin
   if Key = #32 then
      mlSelRef.MoveParaSaida
   else if Key = chr(VK_RETURN) then
      KeyPress( Sender, Key );
end;

procedure TfmSelRefCalcAli.KeyPress(Sender: TObject; var Key: Char);
begin
   if Key = chr(VK_ESCAPE) then
      dmMotherBoard.Wizard.Voltar
   else if Key = chr(VK_RETURN) then
      dmMotherBoard.Wizard.Avancar;
end;

procedure TfmSelRefCalcAli.mlSelRefErroAoMover(Sender: TObject;
  Item: String; Destino: TDestino);
begin
   ShowMessage( 'Você não pode mover a refeição ' + Item + ', pois a refeição global não pode se misturar às demais como escolhida.' );
end;

procedure TfmSelRefCalcAli.lcModRefeicaoChange(Sender: TObject);
begin
    FormShow(Sender);
end;

procedure TfmSelRefCalcAli.FormCreate(Sender: TObject);
begin
   if ( dmMotherBoard.ProcessadorAtual = nil ) then
      lcModRefeicao.LookupSource := nil
   else if ( dmMotherBoard.ProcessadorAtual is TCalculoDieta ) then
      lcModRefeicao.LookupSource := dmMotherBoard.dsDieModRefeicoes
   else if ( dmMotherBoard.ProcessadorAtual is TCalculoInquerito ) then
      lcModRefeicao.LookupSource := dmMotherBoard.dsInqModRefeicoes;
end;

end.

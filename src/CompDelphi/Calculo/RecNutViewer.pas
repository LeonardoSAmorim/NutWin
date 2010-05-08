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




unit RecNutViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MemoriaViewer, calculo, Memoria, PainelMedida, Measurement, stdctrls, comctrls;

type
  TAlterWincontrol = class (TWinControl)
    end;
type
  TRecNutViewer = class(TMemoriaViewer)
  private
    FEntradaMedida: TPainelMedida;
    FCaixaRecNut: String;
    procedure SetEntradaMedida(const Value: TPainelMedida);
    procedure SetCaixaRecNut(const Value: String);
    { Private declarations }
  protected
    { Protected declarations }
    procedure SetViewer(const Value: TWinControl);override;
  public
    { Public declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Refresh(Sender:TObject);
    procedure lvViewerSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure lvViewerEnter(Sender: TObject);
    procedure EntradaValorKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
  published
    { Published declarations }
    property CaixaRecNut : String read FCaixaRecNut write SetCaixaRecNut;
    property EntradaMedida : TPainelMedida read FEntradaMedida write SetEntradaMedida;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Calculadora', [TRecNutViewer]);
end;

{ TRecNutViewer }

procedure TRecNutViewer.EntradaValorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   lView : TListView;
begin
if not Assigned( EntradaMedida ) then
   exit;
if Viewer is TListView then
   lView:=(Viewer as TListView)
else
    exit;

case Key of
     VK_RETURN,VK_DOWN:
             begin
             EntradaMedida.Update;
             Refresh(self);
             with lView do
                  begin
                  if Selected.Index < (Items.Count-1) then
                     Items[Selected.Index + 1].Selected:=True;
                  Setfocus;
                  end;
             end;
     VK_UP:
             begin
             EntradaMedida.Update;
             Refresh(self);
             with lView do
                  begin
                  if Selected.Index > 0 then
                     Items[Selected.Index - 1].Selected:=True;
                  Setfocus;
                  end;
             end;
     end;
end;

procedure TRecNutViewer.lvViewerEnter(Sender: TObject);
begin
   if not Assigned( EntradaMedida ) then
      exit;
   if (Assigned (EntradaMedida.EntradaNumerica)) and (EntradaMedida.EntradaNumerica is TWinControl)
      and (EntradaMedida.EntradaNumerica as TWinControl).CanFocus then
        (EntradaMedida.EntradaNumerica as TWinControl).SetFocus;

end;

procedure TRecNutViewer.lvViewerSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
if not Assigned( EntradaMedida ) then
   exit;
//Gambiarra para evitar problemas no FormClose
//PS: recebe duas vezes a mensagem, primeiro o item antigo
//com selected=false, outra o novo com selected = true
//
if not Selected then
   begin
   //   showmessage('Olha so que acontece');
   Item.SubItems[0]:=TMedida(Item.Data).ValorNumerico;
   if (Assigned (EntradaMedida.EntradaNumerica)) and (EntradaMedida.EntradaNumerica is TWinControl)
      and Assigned(EntradaMedida.Parent) then
        SetFocus((EntradaMedida.EntradaNumerica as TWinControl).Handle );
   exit;
   end;

EntradaMedida.Medida := TMedida( Item.Data );

if (Assigned (EntradaMedida.EntradaNumerica)) and (EntradaMedida.EntradaNumerica is TWinControl)
   and (EntradaMedida.EntradaNumerica as TWinControl).CanFocus then
     (EntradaMedida.EntradaNumerica as TWinControl).SetFocus;

end;

procedure TRecNutViewer.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FEntradaMedida then
        FEntradaMedida := nil;
end;

procedure TRecNutViewer.Refresh(Sender: TObject);
var
   i : Integer;
   mdMed : TMedida;
   lView : TListView;
   NewItem : TListItem;
   cxRecNut : TCaixa;
begin
if Viewer is TListView then
   lView:=(Viewer as TListView)
else
    exit;

  if (lView.Items.Count <> 0) and (Assigned (lView.Selected)) then
     begin
     lView.Selected.SubItems[0]:=TMedida(lView.Selected.Data).ValorNumerico;
     end
  else
      begin
      // Limpa lista de medidas
      lView.Items.Clear;
      // Monta lista de medidas com os pontos de click do corpo humano
      if not self.Processador.Memoria.Acha( FCaixaRecNut, TObject( cxRecNut ) ) then
         exit;
      for i := 0 to cxRecNut.ComponentCount - 1 do
        if ( cxRecNut.Components[i] is TMedida ) then
           begin
           mdMed := TMedida( cxRecNut.Components[i] );
           if mdMed.Valid then
           begin
              NewItem:=lView.Items.Add;
              NewItem.Caption:= mdMed.Descricao;
              NewItem.Data := mdMed;
              if (mdMed.ValorNumerico = '0') then
                 NewItem.SubItems.Add ('')
              else
                 NewItem.SubItems.Add (mdMed.ValorNumerico);
              NewItem.SubItems.Add (mdMed.Unidade) ;
           end;
           end
        else
           // Caso ocorra este erro, ver se a medida existe no banco de dados do
           // Corpo humano ou na memoria ou se está com o nome certo
           ShowMessage( 'Erro: não achei medida!' );

      lView.Items[0].Selected:=True;
      end;
end;

procedure TRecNutViewer.SetCaixaRecNut(const Value: String);
begin
  FCaixaRecNut := Value;
end;

procedure TRecNutViewer.SetEntradaMedida(const Value: TPainelMedida);
var
Alternate : TAlterWincontrol;
begin
  FEntradaMedida := Value;
  if Assigned(Value) then
     begin
     if (Assigned(Value.EntradaNumerica) and
        (Value.EntradaNumerica is TWinControl)) then
         begin
         TWinControl(Alternate):=(Value.EntradaNumerica as TWinControl);
         Alternate.OnKeyUp:=EntradaValorKeyUp;
         end;
     end;
end;

procedure TRecNutViewer.SetViewer(const Value: TWinControl);
begin
inherited;
if (Assigned (Viewer)) and (Viewer is TListView) then
   begin
   (Viewer as TListView).OnSelectItem:= lvViewerSelectItem;
   (Viewer as TListView).OnEnter:=lvViewerEnter;
   end;


end;

end.

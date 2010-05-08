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




unit GlueAntrop;

interface

uses
  Windows, Messages, SysUtils, ObjVis, Classes, Graphics, Controls, Forms,
  Dialogs, comctrls, calculo, PainelMedida, MemoriaViewer, Measurement, stdctrls;

type
  TAlterWincontrol = class (TWinControl)
    end;
  TAntropInputControl = class(TMemoriaViewer)
  private
    FCorpoHumano: TObjetoVisual;
    FEntradaMedida: TPainelMedida;
    procedure SetCorpoHumano(const Value: TObjetoVisual);
    procedure SetEntradaMedida(const Value: TPainelMedida);
    { Private declarations }
  protected
    { Protected declarations }
    procedure SetViewer(const Value: TWinControl);override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  public
    { Public declarations }
    function TemMedidaVazia : Boolean;
    function TemMedidaInvalida : Boolean;
    procedure IndicaMedidasVista;
    procedure Refresh(Sender:TObject);
    procedure CorpoHumanoAreaClick(Sender: TObject);
    procedure lvViewerSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure lvViewerEnter(Sender: TObject);
    procedure EntradaValorKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
  published
    { Published declarations }
    property CorpoHumano : TObjetoVisual read FCorpoHumano write SetCorpoHumano;
    property EntradaMedida : TPainelMedida read FEntradaMedida write SetEntradaMedida;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Calculadora', [TAntropInputControl]);
end;

{ TAntropInputControl }

procedure TAntropInputControl.CorpoHumanoAreaClick(Sender: TObject);
var
   SelItem:TListItem;
   lView : TListView;
begin

if Viewer is TListView then
   lView:=(Viewer as TListView)
else
    exit;

  EntradaMedida.Update;
  Refresh(self);
  SelItem:=lView.FindCaption (0,TLabel( Sender ).Hint,False,True,False);
  // conforme posicao clicada na figura (Hint do label), posicionar na lista a medida
  if (Assigned (SelItem)) then
     SelItem.Selected:=True
  else
      ShowMessage ('Medida nao foi achada no ListView : '+ TLabel( Sender ).Hint);
  lView.SetFocus;

end;

procedure TAntropInputControl.EntradaValorKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
   lView : TListView;
begin
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
                  if ( Selected.Index < (Items.Count-1) ) and EntradaMedida.Medida.Valid then
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
                  if ( Selected.Index > 0 ) and EntradaMedida.Medida.Valid then
                     Items[Selected.Index - 1].Selected:=True;
                  Setfocus;
                  end;
             end;
     end;
end;

procedure TAntropInputControl.IndicaMedidasVista;
var
   i : Integer;
   mdMed : TMedida;
   lView : TListView;
   SelItem: TListItem;
begin
if Viewer is TListView then
   lView:=(Viewer as TListView)
else
    exit;
      //Limpa os bonequinhos
      for i:= 0 to lView.Items.Count - 1 do
          lView.Items [i].StateIndex :=-1;

      // Monta lista de medidas com os pontos de click do corpo humano
      for i := 0 to CorpoHumano.Corpo.PontosSensiveisPorFace.Count - 1 do
        if Processador.Memoria.Acha( CorpoHumano.Corpo.PontosSensiveisPorFace.Strings[i], TObject( mdMed ) ) then
           begin
           SelItem:=lView.FindCaption (0,mdMed.Descricao,False,True,False);//TMedida(CorpoHumano.Corpo.PontosSensiveisPorFace.Objects[i]).Name
           if Assigned (SelItem) then
              SelItem.StateIndex :=0
           end;

end;

procedure TAntropInputControl.lvViewerEnter(Sender: TObject);
begin
   if (Assigned (EntradaMedida.EntradaNumerica)) and (EntradaMedida.EntradaNumerica is TWinControl)
      and (EntradaMedida.EntradaNumerica as TWinControl).CanFocus then
        (EntradaMedida.EntradaNumerica as TWinControl).SetFocus;
end;

procedure TAntropInputControl.lvViewerSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin

// Pra não dar erro se a medida já foi destruída
if not Assigned( Item.Data ) then
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
      and (EntradaMedida.EntradaNumerica as TWinControl).CanFocus then
        (EntradaMedida.EntradaNumerica as TWinControl).SetFocus;
   exit;
   end;

EntradaMedida.Medida := TMedida( Item.Data );

if (Assigned (EntradaMedida.EntradaNumerica)) and (EntradaMedida.EntradaNumerica is TWinControl)
   and (EntradaMedida.EntradaNumerica as TWinControl).CanFocus then
     (EntradaMedida.EntradaNumerica as TWinControl).SetFocus;
end;

procedure TAntropInputControl.Notification(AComponent: TComponent;
  Operation: TOperation);
var
   I : Integer;
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FCorpoHumano then
        FCorpoHumano := nil;
     if AComponent = FEntradaMedida then
        FEntradaMedida := nil;
     // Estou verificando no Viewer para o caso dele ser um TListView
     // e ter ponteiros a serem removidos no Atributo Data
     if Assigned( Viewer ) and ( Viewer is TListView ) then
        with TListView( Viewer ).Items do
        for I := 0 to Count - 1 do
           if Assigned( Item[I].Data ) and ( AComponent = TComponent( Item[I].Data )) then
              Item[I].Data := nil;
end;

procedure TAntropInputControl.Refresh(Sender:TObject);
var
   i : Integer;
   mdMed : TMedida;
   lView : TListView;
   NewItem : TListItem;
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
      for i := 0 to CorpoHumano.Corpo.PontosCalculo.Count - 1 do
        if Processador.Memoria.Acha( CorpoHumano.Corpo.PontosCalculo.Strings[i], TObject( mdMed ) ) then
           begin
           NewItem:=lView.Items.Add;
           NewItem.Caption:= mdMed.Descricao;//TLabel( CorpoHumano.Corpo.AreaClick.Items[i] ).Hint;
           NewItem.Data := mdMed;
           // Para remover do TListView quando for destruido
           mdMed.FreeNotification(self);
           NewItem.SubItems.Add (mdMed.ValorNumerico);
           NewItem.SubItems.Add (mdMed.Unidade) ;
           end
        else
           // Caso ocorra este erro, ver se a medida existe no banco de dados do
           // Corpo humano ou na memoria ou se está com o nome certo
           ShowMessage( 'Erro: não achei medida - TfmAntrop02.FormShow' );

      lView.Items[0].Selected:=True;
      end;
end;

procedure TAntropInputControl.SetCorpoHumano(const Value: TObjetoVisual);
begin
  FCorpoHumano := Value;
  if Assigned(Value) then
     Value.OnLabelClick := CorpoHumanoAreaClick;
end;

procedure TAntropInputControl.SetEntradaMedida(const Value: TPainelMedida);
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


procedure TAntropInputControl.SetViewer(const Value: TWinControl);
begin
inherited;
if (Assigned (Viewer)) and (Viewer is TListView) then
   begin
   (Viewer as TListView).OnSelectItem:= lvViewerSelectItem;
   (Viewer as TListView).OnEnter:=lvViewerEnter;
   end;

end;

function TAntropInputControl.TemMedidaInvalida: Boolean;
var
   i : Integer;
   mdMed : TMedida;
begin
   Result := False;
   for i := 0 to CorpoHumano.Corpo.PontosCalculo.Count - 1 do
     if Processador.Memoria.Acha( CorpoHumano.Corpo.PontosCalculo.Strings[i], TObject( mdMed ) ) then
        begin
           if not (mdMed.Valid) then
              begin
                 Result := True;
                 exit;
              end;
        end;
end;

function TAntropInputControl.TemMedidaVazia: Boolean;
var
   i : Integer;
   mdMed : TMedida;
begin
   Result := False;
   for i := 0 to CorpoHumano.Corpo.PontosCalculo.Count - 1 do
     if Processador.Memoria.Acha( CorpoHumano.Corpo.PontosCalculo.Strings[i], TObject( mdMed ) ) then
        begin
           if Trim(mdMed.ValorNumerico)  = '' then
              begin
                 Result := True;
                 exit;
              end;
        end;
end;

end.

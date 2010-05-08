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




unit MoveItens;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, stdctrls;

type
  TMoveItens = class(TPanel)
  private
    { Private declarations }
    FDesceItem: TButton;
    FSobeItem: TButton;
    FListaItem: TListBox;
    procedure SetBotaoDesceItem(const Value: TButton);
    procedure SetListaItem(const Value: TListBox);
    procedure SetBotaoSobeItem(const Value: TButton);
    procedure SobeItem( Sender : TObject) ;
    procedure DesceItem( Sender : TObject) ;
    procedure ListaItemDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListaItemDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    { Method to set variable and property values and create objects }
    procedure AutoInitialize;
    { Method to free any objects created by AutoInitialize }
    procedure AutoDestroy;
  protected
    { Protected declarations }
    { Resets prop of component type if referenced component deleted }
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  public
    { Public declarations }
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
  published
    { Published declarations }
    property BotaoSobeItem  :  TButton read FSobeItem write SetBotaoSobeItem;
    property BotaoDesceItem :  TButton read FDesceItem write SetBotaoDesceItem;
    property ListaItem : TListBox read FListaItem write SetListaItem;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Miscelanea', [TMoveItens]);
end;

{ TMoveItens }

procedure TMoveItens.DesceItem( Sender : TObject);
var
  Indice : integer;

begin
  Indice := FListaItem.ItemIndex ;
  // Diz o indice atual
  if  (Indice < ( FListaItem.Items.Count - 1)) and (Indice >= 0 )  then
     begin
     FListaItem.Items.Move( Indice, Indice+1 );
     FListaItem.ItemIndex := Indice+1;
     end;

end;

procedure TMoveItens.SetBotaoDesceItem(const Value: TButton);
begin
     { Use Assign method because TButton is an object type }
     FDesceItem := Value;
     if Value <> nil then
        Value.OnClick := DesceItem;

     { If changing this property affects the appearance of
       the component, call Invalidate here so the image will be
       updated. }
     { Invalidate; }
end;

procedure TMoveItens.SetListaItem(const Value: TListBox);
begin
     { Use Assign method because TButton is an object type }
     FListaItem := Value;
     if Value <> nil then
     begin
        Value.OnDragDrop  := ListaItemDragDrop;
        Value.OnDragOver  := ListaItemDragOver;
        Value.MultiSelect := False;
        Value.DragMode    := dmAutomatic ;
        Value.ItemIndex   := 0 ;
     end;
     { If changing this property affects the appearance of
       the component, call Invalidate here so the image will be
       updated. }
     { Invalidate; }
end;

procedure TMoveItens.SetBotaoSobeItem(const Value: TButton);
begin
     { Use Assign method because TButton is an object type }
     FSobeItem := Value;
     if Value <> nil then
        Value.OnClick := SobeItem;

     { If changing this property affects the appearance of
       the component, call Invalidate here so the image will be
       updated. }
     { Invalidate; }
end;

procedure TMoveItens.SobeItem( Sender : TObject);
var
  Indice : integer;

begin
  Indice := FListaItem.ItemIndex ;
  // Diz o indice atual
  if  Indice > 0 then
     begin
     FListaItem.Items.Move( Indice, Indice-1 );
     FListaItem.ItemIndex := Indice-1;
     end;

end;

procedure TMoveItens.AutoDestroy;
begin

end;

procedure TMoveItens.AutoInitialize;
begin
    FDesceItem := nil ;
    FSobeItem  := nil ;
    FListaItem := nil ;
end;

constructor TMoveItens.Create(AOwner: TComponent);
begin
     { Call the Create method of the container's parent class       }
     inherited Create(AOwner);

     { AutoInitialize sets the initial values of variables          }
     { (including subcomponent variables) and properties;           }
     { also, it creates objects for properties of standard          }
     { Delphi object types (e.g., TFont, TTimer, TPicture)          }
     { and for any variables marked as objects.                     }
     { AutoInitialize method is generated by Component Create.      }
     AutoInitialize;

     { Code to perform other tasks when the container is created    }


end;

destructor TMoveItens.Destroy;
begin
     { AutoDestroy, which is generated by Component Create, frees any   }
     { objects created by AutoInitialize.                               }
     AutoDestroy;

     { Here, free any other dynamic objects that the component methods  }
     { created but have not yet freed.  Also perform any other clean-up }
     { operations needed before the component is destroyed.             }

     { Last, free the component by calling the Destroy method of the    }
     { parent class.                                                    }
     inherited Destroy;

end;

procedure TMoveItens.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FSobeItem then
        FSobeItem := nil;
     if AComponent = FDesceItem then
        FDesceItem := nil;
     if AComponent = FListaItem then
        FListaItem := nil;
end;

procedure TMoveItens.ListaItemDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
 Posicao, Posicao2 : integer;
 Ponto : TPoint;
begin
   if (Sender is TListBox) and (Source is TListBox) then
   begin
     Ponto.X := X;
     Ponto.y := Y;

     Posicao2 := (Source as TListBox).ItemAtPos(Ponto, False);
     if Posicao2 > ((Source as TListBox).Items.Count -1 )  then
        Dec(Posicao2);
     Posicao  := (Source as TListBox).ItemIndex;
     (Source as TListBox).Items.Move( Posicao, Posicao2 );
     (Source as TListBox).ItemIndex := Posicao2;
  end;


end;

procedure TMoveItens.ListaItemDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TListBox;
end;

end.

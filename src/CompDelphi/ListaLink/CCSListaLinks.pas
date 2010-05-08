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




unit CCSListaLinks;
{ ****************************************************************** }
{                                                                    }
{   CCSListaLinks.pas                                                }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Agosto/1998                                                   }
{                                                                    }
{ ****************************************************************** }

interface

uses
  CompControl, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  {
       TLinkState serve para indicar o tipo de notificacao que esta sendo
  enviada, para os conectores ou por quem possui o TLink.

  State           Descricao
  --------        -------------------------------------------------------------
  lInit           algum procedimento foi iniciacdo
  lChange         control foi modificado
  lUpDate         os conectores deven ler os viewers e gravar nos contros
  lLoad           os conectores devem ler os contros e gravar nos viewers
  lRefresh        vai deixar de ser usado
  lRefreshViewer  o mesmo que lLoad
  lRefreshControl o mesmo que lUpDate
  }
  TLinkState = (lInit, lChange, lUpdate, lLoad, lRefresh, lRefreshControl, lRefreshViewer, lRefreshTarget, lRefreshSource);

  //Strutura que podera ser utilizado pelos outros  componetes para mapear o TLink
  TNotifyLinkEvent = procedure (Sender : TObject; lState : TLinkState) of Object;

  //Definicao da interface de um conector
  IVinculo = interface (IUnknown)
  ['{5CDFD720-C1F8-11D3-8577-006008DF8A1A}']
    procedure SetOnLinkEvent(const Value: TNotifyLinkEvent);
    function GetOnLinkEvent : TNotifyLinkEvent;
    procedure LinkEvent (Sender: TObject; lState : TLinkState);
    property OnLinkEvent : TNotifyLinkEvent  read GetOnLinkEvent write SetOnLinkEvent;
  end;

  //componente para servir de ligacao ao outros componentes
  TCCSLink = class(TCompControl,IVinculo)
  private
    { Private declarations }
    FOnLinkEvent : TNotifyLinkEvent;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetOnLinkEvent(const Value: TNotifyLinkEvent);virtual;
    function GetOnLinkEvent : TNotifyLinkEvent;virtual;
    procedure LinkEvent(Sender : TObject; lState : TLinkState);virtual;
  published
    { Published declarations }
    property OnLinkEvent : TNotifyLinkEvent read GetOnLinkEvent write SetOnLinkEvent;
  end;

  TCCSLinkComponent = class(TComponent,IVinculo)
  private
    { Private declarations }
    FOnLinkEvent : TNotifyLinkEvent;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetOnLinkEvent(const Value: TNotifyLinkEvent);virtual;
    function GetOnLinkEvent : TNotifyLinkEvent;virtual;
    procedure LinkEvent(Sender : TObject; lState : TLinkState);virtual;
  published
    { Published declarations }
    property OnLinkEvent : TNotifyLinkEvent read GetOnLinkEvent write SetOnLinkEvent;
  end;



  TCCSListaLinks = class(TComponent)
  private
    { Private declarations }
    //Lista com os ponteiros para o componente
    FListaLinks : TList;
    FListaDescendents : TList;
    FOnChangeViewer : TNotifyEvent;
  protected
    { Protected declarations }
    //Lista de ObjectSet referenciados
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init;
    procedure Add(Ponteiro : Pointer);
    procedure AddDescendent(Ponteiro : Pointer);
    procedure Delete(Ponteiro : Pointer);
    procedure DeleteDescendent(Ponteiro : Pointer);
    procedure NotifyLinks(Sender : TObject; lState : TLinkState); virtual;
    procedure NotifyDescendents(Sender : TObject; lState : TLinkState);
    procedure DescendentEvent(Sender : TObject; lState : TLinkState); virtual;
    procedure Refresh;virtual;
    property OnChangeViewer : TNotifyEvent read FOnChangeViewer write FOnChangeViewer;
  published
    { Published declarations }
    procedure ChangeViewer; //(Sender : TObject; xProperty : string);
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('BASICOS', [TCCSListaLinks]);
  RegisterComponents('BASICOS', [TCCSLink]);
end;


///////////TCCsLink //////////////////////////////////////////////////

constructor TCCSLink.Create(AOwner : TComponent);
begin
  inherited Create(Aowner);
//  Parent :=  TWinControl(AOwner);
end;

destructor TCCSLink.Destroy;
begin
  inherited Destroy;
end;

function TCCSLink.GetOnLinkEvent: TNotifyLinkEvent;
begin
Result := FOnLinkEvent;
end;

procedure TCCSLink.LinkEvent(Sender : TObject; lState : TLinkState);
{
       Este metodo sera chamado pelo ListaLink, sempre que uma notificacao for
   disparada, e ele podera ser dispara pelos em diversas situacoes tais como
   no momento da carga das propertyes ou no memento de atualizar o bco em que
   o componente precisa da propriedade setada ou por outros componetes que
   que queiram que suas propriedades possam ser visualizadas com a utilizacao de
   conector que ira avaliar o lState
}
begin
   if assigned(FOnLinkEvent) then FOnLinkEvent(sender, lState);
end;

procedure TCCSLink.SetOnLinkEvent(const Value: TNotifyLinkEvent);
begin
  FOnLinkEvent := Value;
end;

///////////TCCsLinkComponent //////////////////////////////////////////////////

constructor TCCSLinkComponent.Create(AOwner : TComponent);
begin
  inherited Create(Aowner);
//  Parent :=  TWinControl(AOwner);
end;

destructor TCCSLinkComponent.Destroy;
begin
  inherited Destroy;
end;

function TCCSLinkComponent.GetOnLinkEvent: TNotifyLinkEvent;
begin
Result := FOnLinkEvent;
end;

procedure TCCSLinkComponent.LinkEvent(Sender : TObject; lState : TLinkState);
{
       Este metodo sera chamado pelo ListaLink, sempre que uma notificacao for
   disparada, e ele podera ser dispara pelos em diversas situacoes tais como
   no momento da carga das propertyes ou no memento de atualizar o bco em que
   o componente precisa da propriedade setada ou por outros componetes que
   que queiram que suas propriedades possam ser visualizadas com a utilizacao de
   conector que ira avaliar o lState
}
begin
   if assigned(FOnLinkEvent) then FOnLinkEvent(sender, lState);
end;

procedure TCCSLinkComponent.SetOnLinkEvent(const Value: TNotifyLinkEvent);
begin
  FOnLinkEvent := Value;
end;


////TCCSListaLinks/////////////////////////////////////
constructor TCCSListaLinks.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListaLinks := TList.Create;
  FListaDescendents := TList.Create;
//Init;
end;

destructor TCCSListaLinks.Destroy;
begin
  while FListaLinks.Count > 0 do Delete(FListaLinks.Last);
  while FListaDescendents.Count > 0 do Delete(FListaDescendents.Last);
  FListaLinks.Free;
  FListaDescendents.Free;
  inherited Destroy;
end;

procedure TCCSListaLinks.Init;
begin
   FListaLinks.Clear;
end;
procedure TCCSListaLinks.Add(Ponteiro : Pointer);
{
          Adiciona o Ponteiro do componete na lista este ponteiro e do tipo
    TLink, que poder ser um aspecializacao do TLink ou uma especializacao de
    outro componente que agrege o TLink e mapei o seu evento OnLinkEvent e trate
    as notificacoes como quizer;
}
begin
   FListaLinks.Add(Ponteiro);
end;

procedure TCCSListaLinks.AddDescendent(Ponteiro : Pointer);
{
          Adiciona o Ponteiro do componete na lista este ponteiro e do tipo
    TListaLinks, que poder ser um aspecializacao do TListaLinks.
}
begin
   FListaDescendents.Add(Ponteiro);
end;

procedure TCCSListaLinks.Delete(Ponteiro : Pointer);
{
          Retira o ponteiro de TLink da Lista procurando pelo seu pointer;
}
var
Index: integer;
begin
   Index:= FListaLinks.IndexOf(Ponteiro);
   if Index >=0 then
      FListaLinks.Delete(Index);
end;

procedure TCCSListaLinks.DeleteDescendent(Ponteiro : Pointer);
{
          Retira o ponteiro de TListaLinks da Lista procurando pelo seu pointer;
}
begin
   FListaDescendents.Delete(FListaDescendents.IndexOf(Ponteiro));
end;

procedure TCCSListaLinks.NotifyLinks(Sender : TObject; lState : TLinkState);
{
          Varre a lista de ponteiros para links e dispara o  metodo LinkEvent
    dos Links que estao sendo apontados por estes ponteiros.

        Para poder criar um conector que nao seja do tipo TGraphicControl, tive de
    criar o TCCSLinkAll, e com isso terei de verificar qual e o tipo de conector
    para poder enviar a notificacao.
}

var
   i : integer;
   AuxObj : IVinculo;
begin
   for i := 0 to FListaLinks.Count - 1 do
   begin
      if (TObject(FListaLinks[i]).GetInterface (IVinculo,AuxObj)) then
         begin
            AuxObj.LinkEvent(Sender, lState);
         end;
   end;
end;


procedure TCCSListaLinks.NotifyDescendents(Sender : TObject; lState : TLinkState);
{
          Varre a lista de ponteiros para links e dispara o  metodo LinkEvent
    dos Links que estao sendo apontados por estes ponteiros.
}

var
   i : integer;
begin
   for i := 0 to FListaDescendents.Count - 1 do
   begin
      with TCCSListaLinks(FListaDescendents[i]) do
      begin
         DescendentEvent(Sender, lState);
      end;
   end;
end;

procedure TCCSListaLinks.Refresh;
begin
   NotifyLinks(self, lRefresh);
end;
procedure TCCSListaLinks.ChangeViewer;//(Sender: TObject; xProperty: string);
begin
   NotifyLinks(self, lRefreshControl);
   if assigned(FOnChangeViewer) then FOnChangeViewer(self);
end;


procedure TCCSListaLinks.DescendentEvent(Sender: TObject;
  lState: TLinkState);
begin
// era abstract
end;

end.

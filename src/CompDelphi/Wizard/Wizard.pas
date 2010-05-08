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




unit Wizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, extctrls,DsgnIntf,LofStrings;

  const NodeElements = 8;
  const WZ_INVALIDNODE = 99;

type
    TWizardBeforeCancelEvent = procedure (Sender: TObject; var Abort : Boolean ) of object;
    TWizardEvent = procedure (Sender: TObject; CurrentForm: TForm; CurrentOption: integer) of object;
    TWizardBeforeAvancar = procedure (Sender: TObject; var Next : Boolean ) of object;
    TWizardBeforeVoltar = procedure (Sender: TObject; var Previous : Boolean ) of object;

    PLink = ^TLink;
    PNode = ^TNode;
    TLink = record
        Node1    : PNode;
        Node2    : PNode;
        Ordem     : Integer;
        Selected  : Boolean;
        NextLink : PLink;   // Next link in the node's list of links.
        InTree   : Boolean; // Is it in the shortest path tree?
    end;
    TNode = record
        Id           : Integer;
        X            : Integer;
        Y            : Integer;
        LinkSentinel : TLink; // Links out of this node.
        NextNode     : PNode; // Next node in list of all nodes.
        Name         : string[10];
        ClassName    : string[30];
        TipoForm     : Boolean;
        Modal        : Boolean;
        Terminar     : Boolean;
    end;

  TMyControl = class(TControl)
  end;

  TWizNavKeys = class( TPersistent )
  private
    FAvancar: Char;
    FVoltar: Char;
    FAtivado: Boolean;
    FShowChildCaption : Boolean;
    procedure SetAvancar(const Value: Char);
    procedure SetVoltar(const Value: Char);
    procedure SetAtivado(const Value: Boolean);
    procedure SetShowChildCaption(const Value: Boolean);
  protected
  public
  published
     property Ativado : Boolean read FAtivado write SetAtivado;
     property Avancar : Char read FAvancar write SetAvancar default #0;
     property Voltar : Char read FVoltar write SetVoltar default #0;
     property ShowChildCaption : Boolean read FShowChildCaption write SetShowChildCaption;
  end;

  TNewWizard = class(TComponent)
  private
    FNet: TStrings;
    FBotaoCancelar: TControl;
    FBotaoAvancar: TControl;
    FBotaoVoltar: TControl;
    FBotaoTerminar: TControl;
    FPainelWizard: TPanel;
    NodeSentinel : TNode;     // List of all nodes.
    MaxId        : Integer;   // Largest node Id.
    FPaths: TStringListOfStrings;
    FPilhaForms : TList;
    CurrentPath : TStringList;
    CurrentForm : TForm;
    CurrentNode : PNode;
    CurrentOption : Integer;
    StackPointer : Integer;
    FAutoShow: boolean;
    FOnCancel: TWizardEvent;
    FOnTerminate: TNotifyEvent;
    FLeftMargin: Integer;
    FRightMargin: Integer;
    FBottonMargin: Integer;
    FTopMargin: Integer;
    FNavigationKeys: TWizNavKeys;
    FOnBeforeCancel: TWizardBeforeCancelEvent;
    FShowChildCaption: Boolean;
    FOnBeforeTerminate: TNotifyEvent;
    FOnAfterCancel: TNotifyEvent;
    FOnAfterTerminate: TNotifyEvent;
    FOldResizeContainer : TNotifyEvent;
    FAutoSize: Boolean;
    FOnBeforeAvancar: TWizardBeforeAvancar;
    FOnBeforeVoltar: TWizardBeforeVoltar;
    procedure SetNet(const Value: TStrings);
    procedure SetBotaoAvancar(const Value: TControl);
    procedure SetBotaoCancelar(const Value: TControl);
    procedure SetBotaoTerminar(const Value: TControl);
    procedure SetBotaoVoltar(const Value: TControl);
    procedure SetPaths(const Value: TStringListOfStrings);
    procedure LimpaPilha;
    procedure SetAutoShow(const Value: boolean);
    procedure SetOnCancel(const Value: TWizardEvent);
    procedure SetOnTerminate(const Value: TNotifyEvent);
    procedure SetNavigationKeys(const Value: TWizNavKeys);
    procedure SetOnBeforeCancel(const Value: TWizardBeforeCancelEvent);
    procedure SetShowChildCaption(const Value: Boolean);
    procedure SetOnAfterCancel(const Value: TNotifyEvent);
    procedure SetOnBeforeTerminate(const Value: TNotifyEvent);
    procedure SetOnAfterTerminate(const Value: TNotifyEvent);
    procedure OnContainerResize( Sender : TObject );
    procedure SetAutoSize(const Value: Boolean);
    function Resize : Boolean;
    procedure SetOnBeforeAvancar(const Value: TWizardBeforeAvancar);
    procedure SetOnBeforeVoltar(const Value: TWizardBeforeVoltar);
    { Private declarations }
  protected
    { Protected declarations }
    FOldKeyPress:TKeyPressEvent;

    // Resets prop of component type if referenced component deleted
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;

    { Method to generate OnClickVoltar event }
    procedure ClickVoltar( Sender : TObject );
    { Method to generate OnClickAvancar event }
    procedure ClickAvancar( Sender : TObject );
    { Method to generate OnClickCancelar event }
    procedure ClickCancelar( Sender : TObject );
    { Method to generate OnClickTerminar event }
    procedure ClickTerminar( Sender : TObject );
    procedure CheckButtons;
    procedure ConstructNetwork;
    procedure FreeNetwork;
    procedure Loaded;override;
    procedure CriaForm;
  public
    { Public declarations }
    constructor Create (Owner:TComponent);override;
    destructor Destroy;override;
    procedure Avancar;
    procedure Voltar;
    procedure Terminar;
    procedure Cancelar;
    procedure Iniciar(PathName: string);
    function FindNodeById(id : Integer) : PNode;
    function FindNodeByName(Name : string) : PNode;
    function ShowCurrentForm : Boolean;
    procedure OptionChange (Sender: TObject);
    procedure KeyPress(Sender: TObject; var Key: Char);
  published
    { Published declarations }
    property Net :TStrings read FNet write SetNet;
    property Paths : TStringListOfStrings read FPaths write SetPaths;
    property BotaoAvancar : TControl read FBotaoAvancar write SetBotaoAvancar;
    property BotaoVoltar : TControl read FBotaoVoltar write SetBotaoVoltar;
    property BotaoTerminar : TControl read FBotaoTerminar write SetBotaoTerminar;
    property BotaoCancelar : TControl read FBotaoCancelar write SetBotaoCancelar;
    property PainelWizard : TPanel read FPainelWizard write FPainelWizard;
    property AutoShow : boolean read FAutoShow write SetAutoShow default True;
    property TopMargin : Integer read FTopMargin write FTopMargin;
    property LeftMargin : Integer read FLeftMargin write FLeftMargin;
    property BottonMargin : Integer read FBottonMargin write FBottonMargin;
    property RightMargin : Integer read FRightMargin write FRightMargin;
    property OnBeforeCancel : TWizardBeforeCancelEvent read FOnBeforeCancel write SetOnBeforeCancel;
    property OnCancel : TWizardEvent read FOnCancel write SetOnCancel;
    property OnAfterCancel : TNotifyEvent read FOnAfterCancel write SetOnAfterCancel;
    property OnBeforeTerminate : TNotifyEvent read FOnBeforeTerminate write SetOnBeforeTerminate;
    property OnBeforeAvancar : TWizardBeforeAvancar read FOnBeforeAvancar write SetOnBeforeAvancar;
    property OnBeforeVoltar : TWizardBeforeVoltar read FOnBeforeVoltar write SetOnBeforeVoltar;
    property OnTerminate : TNotifyEvent read FOnTerminate write SetOnTerminate;
    property OnAfterTerminate : TNotifyEvent read FOnAfterTerminate write SetOnAfterTerminate;
    property NavigationKeys : TWizNavKeys read FNavigationKeys write SetNavigationKeys;
    property ShowChildCaption : Boolean read FShowChildCaption write SetShowChildCaption;
    property AutoSize : Boolean read FAutoSize write SetAutoSize;
  end;

  TNetProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Miscelanea', [TNewWizard]);
  RegisterPropertyEditor (TypeInfo(TStrings),TNewWizard,'Net',TNetProperty);
end;

{ TNewWizard }

procedure TNewWizard.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FBotaoAvancar then
        FBotaoAvancar := nil
     else if AComponent = FBotaoVoltar then
        FBotaoVoltar := nil
     else if AComponent = FBotaoTerminar then
        FBotaoTerminar := nil
     else if AComponent = FBotaoCancelar then
        FBotaoCancelar := nil;
end;

constructor TNewWizard.Create(Owner: TComponent);
begin
   inherited;
   // Criando objetos
   FNavigationKeys := TWizNavKeys.Create;
   FNet := TStringList.Create;
   FPaths := TStringListOfStrings.Create;
   FPilhaForms := TList.Create;
   // "zerando" variáveis
   NodeSentinel.NextNode := nil;
   StackPointer := 0;
   AutoShow := True;
   CurrentOption := 0;
   FTopMargin := 0;
   FLeftMargin := 0;
   FBottonMargin := 0;
   FRightMargin := 0;
   FOldKeyPress := nil;
end;

destructor TNewWizard.Destroy;
var
   I : Integer;
begin
   // Não armazena objetos, portanto só free
   FNet.Free;
   // destroi lista de nodes
   FreeNetwork;
   // antes de destruir FPaths, deve destruir seus TStrings
   For I := 0 To FPaths.Count - 1 do
       FPaths.Objects[I].Free;
   FPaths.Free;
   // Antes de destruir a FPilhaForms, deve destruir seus forms
   LimpaPilha;
   FPilhaForms.Free;
   // Destruindo configuração das teclas de navegação do wizard
   if Assigned( FNavigationKeys ) then
      FNavigationKeys.Free;
   inherited;
end;

procedure TNewWizard.FreeNetwork;
var
    node, next_node : PNode;
    link, next_link : PLink;
begin
    // Free all the nodes.
    node := NodeSentinel.NextNode;
    while (node <> nil) do
    begin
        // Free the node's links.
        link := node^.LinkSentinel.NextLink;
        while (link <> nil) do
        begin
            next_link := link^.NextLink;
            FreeMem(link);
            link := next_link;
        end;
        // Free the node itself.
        next_node := node^.NextNode;
        FreeMem(node);
        node := next_node;
    end;
    NodeSentinel.NextNode := nil;
end;

procedure TNewWizard.Avancar;
var
   link : PLink;
   lNext : Boolean;
begin
   // Se não tem form corrente pra que avançar?
   if not Assigned(CurrentForm) then
      exit;
   // continua se houver um Node corrente
   if not Assigned(CurrentNode) then
      exit;
   // Ação do usuário durante o voltar
   if Assigned(OnBeforeAvancar) then
   begin
      lNext := True;
      OnBeforeAvancar(self, lNext);
      if not lNext then
         exit;
   end;
   // Esconde o form atual
   CurrentForm.Hide;
   // Pega a opção, ou seja, o caminho para o próximo form que está no Tag do atual
   CurrentOption:=CurrentForm.Tag;
   // Pega o próximo Node navegando na lista de links
   link := CurrentNode.LinkSentinel.NextLink;
   while link <> nil do
   begin
      if (link^.Ordem =CurrentOption) and (link^.Selected =True)
         and (CurrentPath.IndexOf(link^.Node2.Name) > -1) then
         begin
            CurrentNode:=link^.Node2;
            Break;
         end;
      link:=link^.NextLink;
   end;
   //Atualiza o estado dos botões do wizard
   CheckButtons;
   // Atualiza ponteiro da pilha
   if StackPointer > 0 then
      Dec(StackPointer);
   // se autoshow ativo, mostra o form setado acima
   if FAutoShow then
      ShowCurrentForm;
end;

procedure TNewWizard.Cancelar;
var
   Abort : Boolean;
begin
   // Não cancela se não tiver form corrente
   if not Assigned(CurrentForm) then
      exit;
   // abortando a ação de cancelar se o chamador assim desejar
   Abort := False;
   if Assigned(OnBeforeCancel) then
      OnBeforeCancel(self,Abort);
   if Abort then
      exit;
   // Pega a próxima opção (mas não está sendo usada aqui
   CurrentOption := CurrentForm.Tag;
   // o form ainda não foi destruído
   if Assigned(OnCancel) then
      OnCancel(self,CurrentForm,CurrentForm.Tag);
   // Já que vai acabar o wizard, então limpa a pilha
   LimpaPilha;
   // tudo já foi destruído
   if Assigned(OnAfterCancel) then
      OnAfterCancel(self);
end;

procedure TNewWizard.Terminar;
begin
   // Se não tem form corrente não termina
   if not Assigned(CurrentForm) then
      exit;
   // Antes de terminar (tá igual ao OnTerminar)
   if Assigned(OnBeforeTerminate) then
      OnBeforeTerminate(self);
   // pega a opção do próximo form se houver (mas está sem utilizade aqui)
   CurrentOption := CurrentForm.Tag;
   // Ação do usuário durante o terminar
   if Assigned(OnTerminate) then
      OnTerminate(self);
   // Já que vai acabar o wizard, então limpa a pilha
   LimpaPilha;
   // tudo já foi destruído
   if Assigned(OnAfterTerminate) then
      OnAfterTerminate(self);
end;

procedure TNewWizard.Voltar;
var
   lPrevious : Boolean;
begin
   // Não volta se não houver form corrente
   if not Assigned(CurrentForm) then
      exit;
   // Ação do usuário durante o voltar
   if Assigned(OnBeforeVoltar) then
   begin
      lPrevious := True;
      OnBeforeVoltar(self, lPrevious);
      if not lPrevious then
         exit;
   end;
   // Esconde form corrente
   CurrentForm.Hide;
   // atualiza ponteiro da pilha
   if StackPointer < FPilhaForms.Count then
      Inc(StackPointer);
   // pega form anterior
   CurrentForm := TForm(FPilhaForms.Items [StackPointer]);
   // Pega o tag para o próximo form
   CurrentOption := CurrentForm.Tag;
   // Pega o node também pelo nome do form
   CurrentNode := FindNodeByName(CurrentForm.Name);
   // Se não tiver o node é problema
   if not Assigned(CurrentNode) then
      exit;
   //Seta o estados dos botões do wizard
   CheckButtons;
   //mostra o form se o autoshow esta ligado
   if FAutoShow then
      ShowCurrentForm;
end;

procedure TNewWizard.Iniciar(PathName: string);
begin
   // guardando o evento antigo para não perdê-lo
   FOldKeyPress := TForm(FPainelWizard.Parent ).OnKeyPress;
   // Evento de KeyPress do wizard
   TForm(FPainelWizard.Parent ).OnKeyPress := KeyPress;
   TForm(FPainelWizard.Parent ).KeyPreview := True;
   // Pega o path corrente da propriedade
   CurrentPath := TStringList(FPaths.Objects[FPaths.IndexOf(PathName)]);
   // Limpa a pilha pra começar
   LimpaPilha;
   // Pega o primeiro node
   CurrentNode := FindNodeByName(CurrentPath.Strings[0]);
   // Precisa dar um erro se não conseguir achar o node
   if not Assigned(CurrentNode) then
      exit;
end;

procedure TNewWizard.LimpaPilha;
var
   I: Integer;
begin
   //A pilha vai ser limpa, tem que zerar o stackpointer
   //para nao apagar elementos da pilha no hide
   StackPointer:=0;
   with FPilhaForms do
     for I:=0 to Count-1 do
         begin
            TForm(Items[0]).Close;
            TForm(Items[0]).Free;
            Delete(0);
         end;
         // Estou colocando nil, pois esta propriedade apontava
         // para algum dos items adima, o qual já não existe mais
         CurrentForm := nil;
end;

procedure TNewWizard.CheckButtons;
var
    link : PLink;
    NextNode : PNode;
begin
   // Se não tiver form corrente não faz nada
   if not Assigned(CurrentForm) then
      exit;
   // Sem node corrente também não dá
   if not Assigned(CurrentNode) then
      exit;
   //Pega o próximo node do node atual pra descobrir o estado dos botões,
   //mas não muda o node atual
   NextNode := nil;
   link := CurrentNode.LinkSentinel.NextLink;
   while link <> nil do
   begin
      if (link^.Ordem =CurrentOption) and (link^.Selected =True)
         and (CurrentPath.IndexOf(link^.Node2.Name) > -1) then
      begin
         NextNode:=link^.Node2;
         Break;
      end;
      link:=link^.NextLink;
   end;
   // cuida do estado do botão terminar
   if Assigned (FBotaoTerminar) then
   begin
      FBotaoTerminar.Enabled:=(((NextNode = nil) or CurrentNode.Terminar) and (CurrentForm.Tag <> WZ_INVALIDNODE ));
   end;
   // cuida do estado do botão avançar
   if Assigned (FBotaoAvancar) then
   begin
      FBotaoAvancar.Enabled:=((NextNode <> nil) and (CurrentForm.Tag <> WZ_INVALIDNODE ));
   end;
   // cuida do estado do botão voltar
   if Assigned (FBotaoVoltar) then
   begin
   if CurrentNode.Name = CurrentPath.Strings [0] then
      FBotaoVoltar.Enabled:=False
   else
       FBotaoVoltar.Enabled:=True;
   end;
end;

function TNewWizard.ShowCurrentForm : Boolean;
begin
   //Verifique se o form ja foi instanciado
   //Quer dizer: Se dei Avancar depois de Voltar
   Result:=False;
   // Se não tenho um node corrente não pode mostrar form
   if not Assigned(CurrentNode) then
      exit;
   // Só mostra se estiver na pilha
   if FPilhaForms.Count > 0 then
      begin
      // Pega o form corrente da pilha
      CurrentForm := TForm(FPilhaForms.Items [StackPointer]);
      // E se não bater o form corrente com o node corrente?
      if (CurrentNode.Name <> CurrentForm.Name ) then
         begin
            // Erro se a pilha não está vazia
            if StackPointer <> 0 then
               ShowMessage('Erro na pilha de Forms');
            // Cria pois o que está em CurrentForm não é válido
            CriaForm;
         end;
      end
   else
      begin
         // Cria o form e zera o ponteiro da pilha, pois a mesma está vazia
         StackPointer := 0;
         CriaForm;
      end;
   // algo deu errado na criação do form, portando não mostra nada
   if not Assigned(CurrentForm) then
      exit;
   // Pega opção para próximo form
   CurrentOption := CurrentForm.Tag;
   // Atualiza estado dos botões conforme opção acima
   CheckButtons;
   // Resultado ok
   Result:=True;
   // form principal herda título do form corrente
   if ( FPainelWizard.Owner is TForm ) and FShowChildCaption then
      TForm( FPainelWizard.Owner ).Caption := CurrentForm.Caption;
   // Finalmente vamos mostra, mas antes tem que ver se é modal ou não
   if CurrentNode.TipoForm  then
      if CurrentNode.Modal then
      begin
         // Se a resposta for ok, avança
         if CurrentForm.ShowModal = mrOK then
         begin
            Avancar;
         end
         else // qualquer outro resultado, volta
         begin
            Voltar;
            Result := False;
         end;
      end
   else // Não modal -> MOSTRAR!!!!!
      begin
         CurrentForm.Visible := True;
      end;
end;

procedure TNewWizard.CriaForm;
begin
 // Se o node for de um form
 if (CurrentNode.TipoForm) then
 begin
   // Não modal (pode ser filho de panel
   if (not CurrentNode.Modal) then
      begin
         // Tem um panel pra criar
         if Assigned(FPainelWizard) then
            begin
               // Cria e seta principais propriedades do form
               CurrentForm := TFormClass(GetClass(CurrentNode.ClassName)).Create(FPainelWizard);
               CurrentForm.Parent := FPainelWizard;
               CurrentForm.BorderStyle := bsNone;

{               CurrentForm.Left := FLeftMargin;
               CurrentForm.Top := FTopMargin;
               CurrentForm.Height := FPainelWizard.Height-FBottonMargin;
               CurrentForm.Width := FPainelWizard.Width-FRightMargin;
}
               if Assigned( FPainelWizard ) and
                  (FPainelWizard is TPanel) and
                  not Assigned( TPanel(FPainelWizard).OnResize ) then
               begin
                  FOldResizeContainer := TPanel(FPainelWizard).OnResize;
                  TPanel(FPainelWizard).OnResize := OnContainerResize;
               end;
               if not Resize then
               begin
                  CurrentForm.Left := FLeftMargin;
                  CurrentForm.Top := FTopMargin;
                  if Assigned(FPainelWizard) then
                  begin
                     CurrentForm.Height:=FPainelWizard.Height-FBottonMargin;
                     CurrentForm.Width:=FPainelWizard.Width-FRightMargin;
                  end;
               end;

            end
            else
            begin
               // Não dá pra criar
               CurrentForm := nil;
               exit;
            end;
      end
   else
      begin
         // Cria filho de TApplication pra não travar os controls
         Application.CreateForm (TFormClass(GetClass(CurrentNode.ClassName)),CurrentForm);
      end;
 end;
 // Seta propriedades restantes do form
 CurrentForm.Name := CurrentNode.Name;
 CurrentForm.OnClick := OptionChange;
 // Insere na pilha de forms
 FPilhaForms.Insert (StackPointer,CurrentForm);
end;

procedure TNewWizard.OptionChange(Sender: TObject);
var
   I: Integer;
begin
   if StackPointer <> 0 then
   begin
     with FPilhaForms do
        for I:=0 to StackPointer - 1 do
            begin
               TForm(Items[0]).Close;
               TForm(Items[0]).Free;
               Delete(0);
            end;
   end;
   StackPointer:=0;
   if Assigned(CurrentForm) then
      CurrentOption := CurrentForm.Tag;
   CheckButtons;
end;

procedure TNewWizard.KeyPress(Sender: TObject; var Key: Char);
begin
  //Executar evento antigo
  if Assigned(FOldKeyPress) then
     FOldKeyPress(Sender,Key);
  // O sistema de navegação por teclas está ativado
  if FNavigationKeys.Ativado then
  begin
   // Avança se houver uma tecla igual a key e diferente de #0
   if ( FNavigationKeys.Avancar <> #0 ) and
      ( Key = FNavigationKeys.Avancar ) then  // Avancar
      begin
         // Mas só se tiver um botão associado
         if Assigned( FBotaoAvancar ) then
            begin
              // Se habilitado avança
              if FBotaoAvancar.Enabled then
                 ClickAvancar( Sender )
              // senão termina
              else if FBotaoTerminar.Enabled then
                 ClickTerminar( Sender );
              // Pra ignorar a tecla já processada
              Key := #0;
            end;
      end
   // Volta se houver uma tecla igual a key e diferente de #0
   else if ( FNavigationKeys.Voltar <> #0 ) and
           ( Key = FNavigationKeys.Voltar ) then  // Voltar
      begin
         // Mas só se tiver um botão associado
         if Assigned( FBotaoVoltar ) then
            begin
              // Se habilitado volta
              if FBotaoVoltar.Enabled then
                 ClickVoltar( Sender )
              // senão cancela
              else if FBotaoCancelar.Enabled then
                 ClickCancelar( Sender );
              // Pra ignorar a tecla já processada
              Key := #0;
            end;
      end;
  end;
end;

procedure TNewWizard.ClickAvancar(Sender: TObject);
begin
   Avancar;
end;

procedure TNewWizard.ClickCancelar(Sender: TObject);
begin
   Cancelar;
end;

procedure TNewWizard.ClickTerminar(Sender: TObject);
begin
   Terminar;
end;

procedure TNewWizard.ClickVoltar(Sender: TObject);
begin
   Voltar;
end;

procedure TNewWizard.SetAutoShow(const Value: boolean);
begin
  FAutoShow := Value;
end;

procedure TNewWizard.Loaded;
begin
   inherited;
   ConstructNetwork;
end;

procedure TNewWizard.SetOnCancel(const Value: TWizardEvent);
begin
   FOnCancel := Value;
end;

procedure TNewWizard.SetOnTerminate(const Value: TNotifyEvent);
begin
   FOnTerminate := Value;
end;

procedure TNewWizard.SetNavigationKeys(const Value: TWizNavKeys);
begin
  FNavigationKeys := Value;
end;

procedure TNewWizard.SetOnBeforeCancel(
  const Value: TWizardBeforeCancelEvent);
begin
  FOnBeforeCancel := Value;
end;

procedure TNewWizard.SetShowChildCaption(const Value: Boolean);
begin
  FShowChildCaption := Value;
end;

procedure TNewWizard.SetBotaoAvancar(const Value: TControl);
var
   X : TMyControl;
begin
   // Aproveita e seta os eventos de click
   FBotaoAvancar := Value;
   if Assigned(Value) then
      begin
         X := TMyControl(Value);
         X.OnClick := ClickAvancar;
      end;
end;

procedure TNewWizard.SetBotaoCancelar(const Value: TControl);
var
   X : TMyControl;
begin
   // Aproveita e seta os eventos de click
   FBotaoCancelar := Value;
   if Assigned(Value) then
      begin
         X := TMyControl(Value);
         X.OnClick := ClickCancelar;
      end;
end;

procedure TNewWizard.SetBotaoTerminar(const Value: TControl);
var
   X : TMyControl;
begin
   // Aproveita e seta os eventos de click
   FBotaoTerminar := Value;
   if Assigned(Value) then
      begin
        X := TMyControl(Value);
        X.OnClick := ClickTerminar;
      end;
end;

procedure TNewWizard.SetBotaoVoltar(const Value: TControl);
var
   X : TMyControl;
begin
   // Aproveita e seta os eventos de click
   FBotaoVoltar := Value;
   if Assigned(Value) then
      begin
         X := TMyControl(Value);
         X.OnClick := ClickVoltar;
      end;
end;

// Falando sobre a Net

procedure TNewWizard.SetNet(const Value: TStrings);
begin
   if Assigned(Value) then
      FNet.Assign( Value);
   ConstructNetwork;
end;

procedure TNewWizard.ConstructNetwork;
var
    i,j, num_nodes, num_links, to_node, offset, lnk : Integer;
    node                             : PNode;
    link                             : PLink;
    Comment : string;
begin
    if FNet.Count = 0 then
       exit;

    FreeNetwork;

    // Read the number of nodes and links.
    num_nodes:=StrToInt(FNet[1]);

    // Read the nodes' Id, X, and Y.
    MaxId := 0;
    node := @NodeSentinel;
    for i := 1 to num_nodes do
    begin
        GetMem(node^.NextNode, SizeOf(TNode));
        node := node^.NextNode;
        with node^ do
        begin
            offset:=(i-1)*NodeElements;
            Id:=StrToInt(FNet[2 + offset]);
            X:=StrToInt(FNet[3 + offset]);
            Y:=StrToInt(FNet[4 + offset]);
            node^.Name:=FNet[5 + offset];
            node^.ClassName:=FNet[6 + offset];
            node^.TipoForm:=(FNet[7 + offset]='TRUE');
            node^.Modal:=(FNet[NodeElements + offset]='TRUE');
            node^.Terminar:=(FNet[9 + offset]='TRUE');
            LinkSentinel.NextLink := nil;
            if (MaxId < Id) then MaxId := Id;
        end;
    end;
    node^.NextNode := nil;

    // Read the link information.
    node := NodeSentinel.NextNode;
    lnk:=0;
    for i := 1 to num_nodes do
    begin
        node^.LinkSentinel.NextLink := nil;
        offset:=2+(num_nodes*NodeElements)+((i-1)*2)+lnk;
        Comment:=FNet[offset];
        num_links:=StrToInt(FNet[1+offset]);

        for j := 1 to num_links do
        begin
            offset:=2+(num_nodes*NodeElements)+(i*2)+((j-1)*3)+lnk;
            GetMem(link, SizeOf(TLink));
            link^.NextLink := node^.LinkSentinel.NextLink;
            node^.LinkSentinel.NextLink := link;
            to_node:=StrToInt(FNet[offset]);
            link^.Ordem:=StrToInt(FNet[1+offset]);
            link^.Selected:= (FNet[2+offset]='TRUE');
            link^.Node2 := FindNodeById(to_node);
            link^.Node1 := node;
        end;
        lnk:=lnk+num_links*3;
        // Get the link info for the next node.
        node := node^.NextNode;
    end;

end;

// Find a node given its Id.
function TNewWizard.FindNodeById(id : Integer) : PNode;
var
    node : PNode;
begin
    node := NodeSentinel.NextNode;
    while (node <> nil) do
    begin
        if (node^.Id = id) then break;
        node := node^.NextNode;
    end;
    if (node <> nil) then
        Result := node
    else
        Result := nil;
end;

// Find a node given its Name.
function TNewWizard.FindNodeByName(Name : String) : PNode;
var
    node : PNode;
begin
    node := NodeSentinel.NextNode;
    while (node <> nil) do
    begin
        if (node^.Name = Name) then break;
        node := node^.NextNode;
    end;
    if (node <> nil) then
        Result := node
    else
        Result := nil;
end;

procedure TNewWizard.SetPaths(const Value: TStringListOfStrings);
begin
  if Value <> nil then
     begin
        FPaths.Assign (Value);
     end;
end;

// TSLOfStringsProperty

procedure TNetProperty.Edit;
var
  NetFileOpen: TOpenDialog;
  NewNetList : TStringList;
begin
  NetFileOpen := TOpenDialog.Create(Application);
  NetFileOpen.Filename := '';
  NetFileOpen.Filter := 'Path files (*.net)|*.net';
  NetFileOpen.HelpContext := 0;
  NetFileOpen.Options := NetFileOpen.Options + [ofShowHelp, ofPathMustExist,
    ofFileMustExist];
  try
    if NetFileOpen.Execute then
       begin
       NewNetList:=TStringList.Create;
       NewNetList.LoadFromFile (NetFileOpen.Filename);
       TNewWizard(GetComponent(0)).SetNet(NewNetList);
       Modified;
       NewNetList.Free;
       end;
  finally
    NetFileOpen.Free;
  end;
end;

function TNetProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;

procedure TNewWizard.SetOnAfterCancel(const Value: TNotifyEvent);
begin
  FOnAfterCancel := Value;
end;

procedure TNewWizard.SetOnBeforeTerminate(const Value: TNotifyEvent);
begin
  FOnBeforeTerminate := Value;
end;

procedure TNewWizard.SetOnAfterTerminate(const Value: TNotifyEvent);
begin
  FOnAfterTerminate := Value;
end;

procedure TNewWizard.OnContainerResize(Sender: TObject);
begin
   Resize;
   if assigned( FOldResizeContainer ) then
      FOldResizeContainer( Sender );
end;

procedure TNewWizard.SetAutoSize(const Value: Boolean);
begin
  FAutoSize := Value;
end;

function TNewWizard.Resize: Boolean;
begin
   Result := False;
   if Assigned( CurrentForm ) and FAutoSize then
   begin
      CurrentForm.Top := FPainelWizard.Top;
      CurrentForm.Left := FPainelWizard.Left;
      CurrentForm.Width := FPainelWizard.Width;
      CurrentForm.Height := FPainelWizard.Height;
      Result := True;
   end;
end;

procedure TNewWizard.SetOnBeforeAvancar(const Value: TWizardBeforeAvancar);
begin
  FOnBeforeAvancar := Value;
end;

procedure TNewWizard.SetOnBeforeVoltar(const Value: TWizardBeforeVoltar);
begin
  FOnBeforeVoltar := Value;
end;

{ TWizNavKeys }

procedure TWizNavKeys.SetAtivado(const Value: Boolean);
begin
   FAtivado := Value;
end;

procedure TWizNavKeys.SetAvancar(const Value: Char);
begin
  FAvancar := Value;
end;

procedure TWizNavKeys.SetVoltar(const Value: Char);
begin
  FVoltar := Value;
end;

procedure TWizNavKeys.SetShowChildCaption(const Value: Boolean);
begin
  FShowChildCaption := Value;
end;


end.

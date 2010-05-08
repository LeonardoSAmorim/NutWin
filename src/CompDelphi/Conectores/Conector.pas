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




unit Conector;
{ ****************************************************************** }
{                                                                    }
{   Conector.pas                                                     }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Setembro/1998                                                 }
{                                                                    }
{ ****************************************************************** }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CCSListaLinks, stdctrls,  checklst, Tabs, dbtables, RTTI,
  DsgnIntf, typInfo, CCSPreparar;

type
  //Foward ref
  TProxyNotificador=class;

  TMethodAll = procedure (v1, v2, v3, v4, v5, v6 : variant) of object;

  TCustomConector = class(TCCSLink)
  protected
    { Private declarations }
    FControl : TCCSListaLinks;
    FControlMethod : string;
    FControlPropertyPut : string;
    FControlPropertyGet : string;
    FViewer : TComponent;
    FViewerMethod : string;
    FViewerPropertyPut : string;
    FViewerPropertyGet : string;
    //Variavel para indicar que o metodo de change pode disparar uma atuliazao do Control
    //pelo conteudo do viewer
    FRefreshChange : boolean;
    FCanMontar : boolean;
    FRTTIControl : TRTTI;
    FRTTIViewer : TRTTI;
    FOnChange : TNotifyEvent;
    procedure SetViewer(Value : TComponent);
    procedure SetControl(Value : TCCSListaLinks);
    procedure SetControlPropertyPut(Value : string);
    procedure SetControlPropertyGet(Value : string);
    procedure SetViewerPropertyPut(Value : string);
    procedure SetViewerPropertyGet(Value : string);
    procedure SetRefreshChange(Value : boolean);
    procedure SetViewerMethod(xMethod : string);
  protected
    { Protected declarations }
    FAuxMethod : TMethod;
    FAuxMethod2 : TMethod;
    FCountParam : integer;
    FAuxViewerMethod : string;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure ExecViewerControl; virtual;
    property Control : TCCSListaLinks read FControl write SetControl;
    property ControlMethod : string read FControlMethod write FControlMethod;
    property ControlPropertyPut : string read FControlPropertyPut write SetControlPropertyPut;
    property ControlPropertyGet : string read FControlPropertyGet write SetControlPropertyGet;
    property Viewer : TComponent read FViewer write SetViewer;
    property ViewerMethod : string read FViewerMethod write SetViewerMethod;
    property ViewerPropertyPut : string read FViewerPropertyPut write SetViewerPropertyPut;
    property ViewerPropertyGet : string read FViewerPropertyGet write SetViewerPropertyGet;
    property RTTIControl : TRTTI read FRTTIControl write FRTTIControl;
    property RTTIViewer : TRTTI read FRTTIViewer write FRTTIViewer;
    procedure MapEnderecamento; virtual;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure LinkEvent(Sender : TObject; lState : TLinkState); override;
    property RefreshChange : boolean read FRefreshChange write SetRefreshChange;
  published
    { Published declarations }
    //Estes metodos tem de ser publicados para que possam ser avaliados via RTTI
    procedure DoChangeMethodAll;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;


  TCustomJumper = class(TCCSLinkComponent)
  protected
    { Private declarations }
    FSource : TCCSListaLinks;
    FSourceMethod : string;
    FSourcePropertyPut : string;
    FSourcePropertyGet : string;
    FTarget : TComponent;
    FTargetMethod : string;
    FTargetPropertyPut : string;
    FTargetPropertyGet : string;
    //Variavel para indicar que o metodo de change pode disparar uma atuliazao do Source
    //pelo conteudo do Target
    FRefreshChange : boolean;
    FCanMontar : boolean;
    FRTTISource : TRTTI;
    FRTTITarget : TRTTI;
    FOnChange : TNotifyEvent;
    procedure SetTarget(Value : TComponent);
    procedure SetSource(Value : TCCSListaLinks);
    procedure SetSourcePropertyPut(Value : string);
    procedure SetSourcePropertyGet(Value : string);
    procedure SetTargetPropertyPut(Value : string);
    procedure SetTargetPropertyGet(Value : string);
    procedure SetRefreshChange(Value : boolean);
    procedure SetTargetMethod(xMethod : string);
  protected
    { Protected declarations }
    FAuxMethod : TMethod;
    FAuxMethod2 : TMethod;
    FCountParam : integer;
    FAuxTargetMethod : string;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure ExecTargetSource; virtual;
    property Source : TCCSListaLinks read FSource write SetSource;
    property SourceMethod : string read FSourceMethod write FSourceMethod;
    property SourcePropertyPut : string read FSourcePropertyPut write SetSourcePropertyPut;
    property SourcePropertyGet : string read FSourcePropertyGet write SetSourcePropertyGet;
    property Target : TComponent read FTarget write SetTarget;
    property TargetMethod : string read FTargetMethod write SetTargetMethod;
    property TargetPropertyPut : string read FTargetPropertyPut write SetTargetPropertyPut;
    property TargetPropertyGet : string read FTargetPropertyGet write SetTargetPropertyGet;
    property RTTISource : TRTTI read FRTTISource write FRTTISource;
    property RTTITarget : TRTTI read FRTTITarget write FRTTITarget;
    procedure MapEnderecamento; virtual;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure LinkEvent(Sender : TObject; lState : TLinkState); override;
    property RefreshChange : boolean read FRefreshChange write SetRefreshChange;
  published
    { Published declarations }
    //Estes metodos tem de ser publicados para que possam ser avaliados via RTTI
    procedure DoChangeMethodAll;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;

  TJumper = class(TCustomJumper)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Source;
    property Target;
  end;

  TConector = class(TCustomConector)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Control;
    property ControlMethod;
    property ControlPropertyPut;
    property ControlPropertyGet;
    property RefreshChange;
    property Viewer;
    property ViewerMethod;
    property ViewerPropertyPut;
    property ViewerPropertyGet;
  end;

  TConectorProxy = class(TCustomConector)
  private
    { Private declarations }
    FControl : TProxyNotificador;
    procedure SetControl(Value : TProxyNotificador);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure ExecViewerControl; override;
    procedure MapEnderecamento; override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure LinkEvent(Sender : TObject; lState : TLinkState); override;
  published
    { Published declarations }
    property Control : TProxyNotificador read FControl write SetControl;
    property ControlPropertyPut;
    property ControlPropertyGet;
    property RefreshChange;
    property Viewer; // : TComponent read FViewer write SetViewer;
    property ViewerMethod;
    property ViewerPropertyPut;
    property ViewerPropertyGet;
    procedure DoChangeMethodAll;
  end;




  TControlPropProperty = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;


  TViewerPropProperty = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;

  TControlConectorMethod = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;


  TViewerConectorMethod = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;

{ ****************************************************************** }
{                                                                    }
{   ProxyNotificador.pas                                             }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Setembro/1998                                                 }
{                                                                    }
{ ****************************************************************** }

  TProxyNotificador = class(TCCSListaLinks)
  private
    { Private declarations }
    FControl : TComponent;
    FRTTIControl : TRTTI;
    FControlMethod : string;
    procedure SetControl(Value : TComponent);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded ; override;
    property RTTIControl : TRTTI read FRTTIControl write FRTTIControl;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Control : TComponent read FControl write SetControl;
    property ControlMethod : string read FControlMethod write FControlMethod;
    procedure DoMethod(sender : TObject);
  end;

  TControlPropMethod = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;

procedure Register;

var
  m1, m2 : TMethod;  //variaveis para conter o endereco dos methods a serem mapiamdos
  CountParamEvent : integer;

implementation

procedure Register;
begin
  RegisterComponents('Conectores', [TConector]);
  RegisterComponents('Conectores', [TConectorProxy]);
  RegisterComponents('Conectores', [TProxyNotificador]);
  RegisterComponents('Conectores', [TJumper]);
  RegisterPropertyEditor(TypeInfo(string), TProxyNotificador, 'ControlMethod', TControlPropMethod);
  RegisterPropertyEditor(TypeInfo(string), TConector, 'ControlPropertyPut', TControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConector, 'ControlPropertyGet', TControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConector, 'ControlMethod', TControlConectorMethod);
  RegisterPropertyEditor(TypeInfo(string), TConector, 'ViewerPropertyPut', TViewerPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConector, 'ViewerPropertyGet', TViewerPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConector, 'ViewerMethod', TViewerConectorMethod);
  RegisterPropertyEditor(TypeInfo(string), TConectorProxy, 'ControlPropertyPut', TControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorProxy, 'ControlPropertyGet', TControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorProxy, 'ViewerPropertyPut', TViewerPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorProxy, 'ViewerPropertyGet', TViewerPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorProxy, 'ViewerMethod', TViewerConectorMethod);
end;

{ TCustomConector }
/////////////////////////////////////////////////////////////

constructor TCustomConector.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FRTTIControl := TRTTI.Create(nil);
  FRTTIViewer := TRTTI.Create(nil);
  FControl := nil;
  FViewer := nil;
  FCanMontar := True;
  FAuxMethod.Code := nil;
  FAuxMethod.Data := nil;
end;

destructor TCustomConector.Destroy;
begin
  if assigned(FControl) then
  begin
     FControl.Delete(self);
  end;
  if assigned(Viewer) then
  begin
     FRTTIViewer.PutMethod(FAuxViewerMethod, FAuxMethod);
  end;
  FControl := nil;
  FViewer := nil;
  FRTTIControl.Destroy;
  FRTTIViewer.Destroy;
  inherited Destroy;
end;

procedure TCustomConector.Loaded;
begin
   inherited loaded;
   if assigned(FControl) then
      FRTTIControl.Control := FControl;
   if assigned(FViewer) then
      FRTTIViewer.Control := FViewer;
   if not (csLoading in ComponentState) then
   begin
      ExecViewerControl;
   end;
   MapEnderecamento;
end;

procedure TCustomConector.SetControl(Value : TCCSListaLinks);
begin
   FControl := Value;
   if assigned(value) then
   begin
      FControl.add(self);
      FRTTIControl.Control := FControl;
      if not (csLoading in ComponentState) then
      begin
         ExecViewerControl;
      end;
      Value.freenotification(self);
      //Salva o endereco do metodo para usar no cod. em assembler
      FAuxMethod2.Code := Fcontrol.MethodAddress('ChangeViewer');
      FAuxMethod2.Data := FControl;
   end;
end;

procedure TCustomConector.SetViewer(Value : TComponent);
begin
   FViewer := Value;
   if assigned(value) then
   begin
      FRTTIViewer.Control := FViewer;
      if not (csLoading in ComponentState) then
      begin
         ExecViewerControl;
      end;
      Value.freenotification(self);
   end;
end;

procedure TCustomConector.SetViewerMethod(xMethod: string);
begin
  FViewerMethod := xMethod;
  //MapEnderecamento;
end;

procedure TCustomConector.MapEnderecamento;
var
   Method : TMethod;
begin
  if assigned(FViewer) then
  begin
    //restaura mapiamento do metodo
    FRTTIViewer.PutMethod(FAuxViewerMethod, FAuxMethod);

    //Salva  mapiamento e nome do evento
    FAuxMethod := FRTTIViewer.GetMethod(FViewerMethod);
    FAuxViewerMethod := FViewerMethod;

    //faz novo mapiamento com DoChangeMethodAll
    Method.Code := MethodAddress('DoChangeMethodAll');
    Method.Data := self;
    FRTTIViewer.PutMethod(FViewerMethod, Method);

    //Pega o numero de parametros do evento
    FCountParam := FRTTIViewer.GetMethodCount(FViewerMethod);
  end;
end;

procedure TCustomConector.SetControlPropertyPut(Value : string);
begin
   FControlPropertyPut := Value;
   if FControlPropertyGet = '' then
      FControlPropertyGet := Value;
   if not (csLoading in ComponentState) then
   begin
      ExecViewerControl;
   end;
end;
procedure TCustomConector.SetControlPropertyGet(Value : string);
begin
   FControlPropertyGet := Value;
   if FControlPropertyPut = '' then
      FControlPropertyPut := Value;
   if not (csLoading in ComponentState) then
   begin
      ExecViewerControl;
   end;
end;

procedure TCustomConector.SetViewerPropertyPut(Value : string);
begin
   FViewerPropertyPut := Value;
   if FViewerPropertyGet = '' then
      FViewerPropertyGet := Value;
   if not (csLoading in ComponentState) then
   begin
      ExecViewerControl;
   end;
end;

procedure TCustomConector.SetViewerPropertyGet(Value : string);
begin
   FViewerPropertyGet := Value;
   if FViewerPropertyPut = '' then
      FViewerPropertyPut := Value;
   if not (csLoading in ComponentState) then
   begin
      ExecViewerControl;
   end;
end;

procedure TCustomConector.SetRefreshChange(Value : boolean);
begin
   FRefreshChange := Value;
   ExecViewerControl;
end;

procedure TCustomConector.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FControl <> nil) and (AComponent = Control) then
       Control := nil;
    if (FViewer <> nil) and (AComponent = Viewer) then
       Viewer := nil;
  end;
end;


procedure TCustomConector.LinkEvent(Sender : TObject; lState : TLinkState);
begin
  inherited LinkEvent(Sender, lState);
  if assigned(FOnChange) then
     FOnChange(Self);
  if assigned(Viewer) and assigned(Control) then
  begin
     case  lState of
        //Atualiza Viewer
        lLoad, lRefresh, lRefreshViewer : FRTTIViewer.PutProperty(ViewerPropertyPut, FRTTIControl.GetProperty(ControlPropertyGet));
        //Atualiza Control
        lUpDate, lRefreshControl : FRTTIControl.PutProperty(ControlPropertyPut, FRTTIViewer.GetProperty(ViewerPropertyGet));
     end;
  end;
end;

procedure TCustomConector.ExecViewerControl;
begin
  if assigned(Viewer) and assigned(Control) then
  begin
    LinkEvent(self, lRefresh);
  end;
end;

procedure TCustomConector.DoChangeMethodAll; assembler;
begin
     asm
       //Preserva o stack
       push ebp
       mov  ebp,esp

       //O eax aponta para o conector (self)
       push eax

       //Vai usar o ebp para apontar ao conector
       push ebp
       mov  ebp,eax

       //coloca em eax o self do Control onde esta o ChangeViewer
       mov eax, eax + offset [FControl]

       //salva registradores que podem ser alterados livremente pelo metodos
       push ecx
       push edx

       //Chama o metodo ChangeViewer para avisar que ocorreu o evento
       call TMethod(ebp + offset [FAuxMethod2]).code
       pop edx
       pop ecx
       pop ebp
       pop eax

       // verifica se o usuario esta ocupando o evento em algum lugar do form
       cmp TMethod(eax + offset [FAuxMethod]).code, 0
       je @SemEvento

       //Deixa a pilha do jeito que estava antes de comecar a rotina
       mov esp,ebp
       pop ebp

       //salta para o tratamento do evento no form
       //o proprio evento retorna corretamente
       jmp TMethod(eax + offset [FAuxMethod]).code

@SemEvento:

       {
            Caso nao exista mapiamento do evento pelo form ou outro objeto entao
       esta rotina devera tratar o retorn da chamada do evento, que foi  montada
       de acordo com a quantidade de paramentros do eveento, seguindo o criterio
       de passagem de parametros do tipo REGISTER, pela qual os paramentros  sao
       passados os primeiros tres me EAX, EDX e ECX, e se houver mais parametros
       serao colocados na pilha, no caso especifico de um objeto o primeiro para
       metro e o self, portanto, ele sera colocado em EAX, e os outros  seguiram
       conforme a convencao REGISTER, neste caso um evento que posui ate 2 para-
       metros serao podera retornar dando um simples RET, mas eventos que possui
       3 ou mais parametros deverao retirar da pilha a difereneca no caso de   3
       parametros usara o RET $0004, com 4 RET $0008, com 5 RET $000C,  e  assim
       por diante com multiplos de 4 bytes por parametros a mais do que 2.
       }

       cmp  BYTE PTR (eax + offset [FCountParam]),2
       jg @TiraParametros
       mov  esp,ebp
       pop ebp
       ret

@TiraParametros:
       push ecx
       push ebx
       mov  ecx, eax + offset [FCountParam]
       dec  ecx
       dec  ecx
       shl  ecx,2
       mov  ebx, [ebp]
       mov  [ebp + ecx], ebx
       mov  ebx, [ebp+4]
       add  ebp,ecx
       mov  [ebp+4], ebx
       pop  ebx
       pop  ecx
       mov  esp,ebp
       pop ebp
       ret

     end;
end;

{ TConectorProxy }
/////////////////////////////////////////////////////////////////
constructor TConectorProxy.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FControl := nil;
end;

destructor TConectorProxy.Destroy;
begin
  if assigned(FControl) then
  begin
     FControl.Delete(self);
  end;
  FControl := nil;
  inherited Destroy;
end;

procedure TConectorProxy.Loaded;
var
   Method : TMethod;
begin
   if assigned(FControl) and assigned(FControl.Control) then
   begin
      RTTIControl.Control := FControl.Control;
      if (FControl.ControlMethod <> '') then
      begin
         if RTTIControl.HasProperty(FControl.ControlMethod) then
         begin
            //mapea endereco do evento do objeto para o DoMethod
            Method.Code := FControl.MethodAddress('DoMethod');
            Method.Data := FControl;
            RTTIControl.PutMethod(FControl.ControlMethod, Method);
         end;
      end;
   end;
   ExecViewerControl;
   inherited loaded;
end;

procedure TConectorProxy.SetControl(Value : TProxyNotificador);
var
   Method : TMethod;
begin
   FControl := Value;
   if assigned(value) then
   begin
      FControl.add(self);
      if assigned(FControl.Control) then
      begin
         RTTIControl.Control := FControl.Control;
         if (FControl.ControlMethod <> '') then
         begin
            if RTTIControl.HasProperty(FControl.ControlMethod) then
            begin
               Method.Code := FControl.MethodAddress('DoMethod');
               Method.Data := FControl;
               RTTIControl.PutMethod(FControl.ControlMethod, Method);
            end;
         end;
      end;
      if not (csLoading in ComponentState) then
      begin
         ExecViewerControl;
      end;
      //pega endereco do ChangeViewer para usar no cod. em assembler
      FAuxMethod2.Code := Fcontrol.MethodAddress('ChangeViewer');
      FAuxMethod2.Data := FControl;
      Value.freenotification(self);
   end;
end;

procedure TConectorProxy.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FControl <> nil) and (AComponent = Control) then
       Control := nil;
  end;
end;

{
    este metodo esta duplicado porque o conector proxy tem um control diferente o do
conector
}

procedure TConectorProxy.DoChangeMethodAll; assembler;
begin
     asm
       //Passa endereco do evento metodo mapiado para a variavel m1
       push ebx
       mov ebx, eax + offset [FAuxMethod]
       mov dword ptr [m1], ebx

       //Passa endereco do metodo ChangeViewer mapiado para a variavel m2
       mov ebx, eax + offset [FAuxMethod2]
       mov dword ptr [m2], ebx
       pop ebx

       push eax
       //coloca em eax o self do Control onde esta o ChangeViewer
       mov eax, eax + offset [FControl]

       //salva registradores que podem ser alterados livremente pelo metodos
       push ecx
       push edx

       //Chama o metodo ChangeViewer para avisar que ocorreu o evento
       call m2.code
       pop edx
       pop ecx
       pop eax

       // verifica se existe mapiamento para o evento em algum lugar ger. form
       cmp m1.code, 0
       je @SemMapEvent1

       //salta para o tratamento do evento ger. form
       jmp m1.code

@SemMapEvent1:
       {
            Caso nao exista mapiamento do evento pelo form ou outro objeto entao
       esta rotina devera tratar o retorn da chamada do evento, que foi  montada
       de acordo com a quantidade de paramentros do eveento, seguindo o criterio
       de passagem de parametros do tipo REGISTER, pela qual os paramentros  sao
       passados os primeiros tres me EAX, EDX e ECX, e se houver mais parametros
       serao colocados na pilha, no caso especifico de um objeto o primeiro para
       metro e o self, portanto, ele sera colocado em EAX, e os outros  seguiram
       conforme a convencao REGISTER, neste caso um evento que posui ate 2 para-
       metros serao podera retornar dando um simples RET, mas eventos que possui
       3 ou mais parametros deverao retirar da pilha a difereneca no caso de   3
       parametros usara o RET $0004, com 4 RET $0008, com 5 RET $000C,  e  assim
       por diante com multiplos de 4 bytes por parametros a mais do que 2.
       }
       push ebx
       mov ebx, eax + offset [FCountParam]
       mov dword ptr [CountParamEvent], ebx
       pop ebx
       //verifica a quantidade de parametros para acertar o ret
       cmp CountParamEvent, 1
       jne @SemMapEvent2
       ret
@SemMapEvent2:
       cmp CountParamEvent, 2
       jne @SemMapEvent3
       ret
@SemMapEvent3:
       cmp CountParamEvent, 3
       jne @SemMapEvent4
       ret $0004
@SemMapEvent4:
       cmp CountParamEvent, 4
       jne @SemMapEvent5
       ret $0008
@SemMapEvent5:
       cmp CountParamEvent, 5
       jne @SemMapEvent6
       ret $000C
@SemMapEvent6:
       cmp CountParamEvent, 6
       jne @SemMapEvent0
       ret $0010
@SemMapEvent0:
       ret
     end;
end;

procedure TConectorProxy.MapEnderecamento;
begin
   inherited MapEnderecamento;
end;

procedure TConectorProxy.ExecViewerControl;
begin
  if assigned(Viewer) and assigned(Control) and assigned(FControl.Control) then
  begin
    LinkEvent(self, lRefresh);
  end;
end;

procedure TConectorProxy.LinkEvent(Sender : TObject; lState : TLinkState);
begin
//  inherited LinkEvent(Sender, lState);
  if assigned(Viewer) and assigned(Control) and assigned(FControl.Control) then
  begin
     case  lState of
        //Atualiza Viewer
        lLoad, lRefresh, lRefreshViewer : FRTTIViewer.PutProperty(ViewerPropertyPut, FRTTIControl.GetProperty(ControlPropertyGet));
        //Atualiza Control
        lUpDate, lRefreshControl : FRTTIControl.PutProperty(ControlPropertyPut, FRTTIViewer.GetProperty(ViewerPropertyGet));
     end;
  end;
end;

{ TControlPropProperty }
///Editor de propriedade para as properties////
function TControlPropProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TControlPropProperty.GetValues(PROC : TGetStrProc);
var
   ListaPropriedades : TStringList;
   i : integer;
begin
   ListaPropriedades := TStringList.create;
   ListaPropriedades.assign(TCustomConector(GetComponent(0)).RTTIControl.GetPropertys);
   for i := 0 to  ListaPropriedades.Count - 1 do
   begin
      Proc(ListaPropriedades[i]);
   end;
   ListaPropriedades.Free;
end;

{ TViewerPropProperrty }
///Editor de propriedade para as properties////
function TViewerPropProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TViewerPropProperty.GetValues(PROC : TGetStrProc);
var
   ListaPropriedades : TStringList;
   i : integer;
begin
   ListaPropriedades := TStringList.create;
   ListaPropriedades.assign(TCustomConector(GetComponent(0)).RTTIViewer.GetPropertys);
   for i := 0 to  ListaPropriedades.Count - 1 do
   begin
      Proc(ListaPropriedades[i]);
   end;
   ListaPropriedades.Free;
end;

{ TControlConectorMethod }
///Editor de propriedade para as properties////
function TControlConectorMethod.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TControlConectorMethod.GetValues(PROC : TGetStrProc);
var
   ListaPropriedades : TStringList;
   i : integer;
begin
   ListaPropriedades := TStringList.create;
   ListaPropriedades.assign(TCustomConector(GetComponent(0)).RTTIControl.GetMethods);
   for i := 0 to  ListaPropriedades.Count - 1 do
   begin
      Proc(ListaPropriedades[i]);
   end;
   ListaPropriedades.Free;
end;



{ TViewerConectorMethod }
///Editor de propriedade para as properties////
function TViewerConectorMethod.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TViewerConectorMethod.GetValues(PROC : TGetStrProc);
var
   ListaPropriedades : TStringList;
   i : integer;
begin
   ListaPropriedades := TStringList.create;
   ListaPropriedades.assign(TCustomConector(GetComponent(0)).RTTIViewer.GetMethods);
   for i := 0 to  ListaPropriedades.Count - 1 do
   begin
      Proc(ListaPropriedades[i]);
   end;
   ListaPropriedades.Free;
end;

{ TProxyNotificador }

constructor TProxyNotificador.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FRTTIControl := TRTTI.Create(nil);
end;

destructor TProxyNotificador.Destroy;
begin
  FRTTIControl.Destroy;
  inherited Destroy;
end;

procedure TProxyNotificador.Loaded;
begin
   inherited loaded;
end;

procedure TProxyNotificador.SetControl(Value : TComponent);
begin
   FControl := Value;
   if assigned(value) then
   begin
      FRTTIControl.Control := FControl;
      if not (csLoading in ComponentState) then
      begin
      end;
      Value.freenotification(self);
   end;
end;

procedure TProxyNotificador.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FControl <> nil) and (AComponent = Control) then
       Control := nil;
  end;
end;

procedure TProxyNotificador.DoMethod(sender : TObject);
begin
    NotifyLinks(self, lRefreshViewer);
end;

{ TControlPropMethod }
///Editor de propriedade para os methodos ///
function TControlPropMethod.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TControlPropMethod.GetValues(PROC : TGetStrProc);
var
   ListaPropriedades : TStringList;
   i : integer;
begin
   ListaPropriedades := TStringList.create;
   ListaPropriedades.assign(TProxyNotificador(GetComponent(0)).RTTIControl.GetMethods);
   for i := 0 to  ListaPropriedades.Count - 1 do
   begin
      Proc(ListaPropriedades[i]);
   end;
   ListaPropriedades.Free;
end;

{ TCustomJumper }
/////////////////////////////////////////////////////////////

constructor TCustomJumper.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FRTTISource := TRTTI.Create(nil);
  FRTTITarget := TRTTI.Create(nil);
  FSource := nil;
  FTarget := nil;
  FCanMontar := True;
  FAuxMethod.Code := nil;
  FAuxMethod.Data := nil;
end;

destructor TCustomJumper.Destroy;
begin
  if assigned(FSource) then
  begin
     FSource.Delete(self);
  end;
  if assigned(Target) then
  begin
     FRTTITarget.PutMethod(FAuxTargetMethod, FAuxMethod);
  end;
  FSource := nil;
  FTarget := nil;
  FRTTISource.Destroy;
  FRTTITarget.Destroy;
  inherited Destroy;
end;

procedure TCustomJumper.Loaded;
begin
   inherited loaded;
   if assigned(FSource) then
      FRTTISource.Control := FSource;
   if assigned(FTarget) then
      FRTTITarget.Control := FTarget;
   if not (csLoading in ComponentState) then
   begin
      ExecTargetSource;
   end;
   MapEnderecamento;
end;

procedure TCustomJumper.SetSource(Value : TCCSListaLinks);
begin
   FSource := Value;
   if assigned(value) then
   begin
      FSource.add(self);
      FRTTISource.Control := FSource;
      if not (csLoading in ComponentState) then
      begin
         ExecTargetSource;
      end;
      Value.freenotification(self);
      //Salva o endereco do metodo para usar no cod. em assembler
      FAuxMethod2.Code := FSource.MethodAddress('ChangeTarget');
      FAuxMethod2.Data := FSource;
   end;
end;

procedure TCustomJumper.SetTarget(Value : TComponent);
begin
   FTarget := Value;
   if assigned(value) then
   begin
      FRTTITarget.Control := FTarget;
      if not (csLoading in ComponentState) then
      begin
         ExecTargetSource;
      end;
      Value.freenotification(self);
   end;
end;

procedure TCustomJumper.SetTargetMethod(xMethod: string);
begin
  FTargetMethod := xMethod;
  //MapEnderecamento;
end;

procedure TCustomJumper.MapEnderecamento;
var
   Method : TMethod;
begin
  if assigned(FTarget) then
  begin
    //restaura mapiamento do metodo
    FRTTITarget.PutMethod(FAuxTargetMethod, FAuxMethod);

    //Salva  mapiamento e nome do evento
    FAuxMethod := FRTTITarget.GetMethod(FTargetMethod);
    FAuxTargetMethod := FTargetMethod;

    //faz novo mapiamento com DoChangeMethodAll
    Method.Code := MethodAddress('DoChangeMethodAll');
    Method.Data := self;
    FRTTITarget.PutMethod(FTargetMethod, Method);

    //Pega o numero de parametros do evento
    FCountParam := FRTTITarget.GetMethodCount(FTargetMethod);
  end;
end;

procedure TCustomJumper.SetSourcePropertyPut(Value : string);
begin
   FSourcePropertyPut := Value;
   if FSourcePropertyGet = '' then
      FSourcePropertyGet := Value;
   if not (csLoading in ComponentState) then
   begin
      ExecTargetSource;
   end;
end;
procedure TCustomJumper.SetSourcePropertyGet(Value : string);
begin
   FSourcePropertyGet := Value;
   if FSourcePropertyPut = '' then
      FSourcePropertyPut := Value;
   if not (csLoading in ComponentState) then
   begin
      ExecTargetSource;
   end;
end;

procedure TCustomJumper.SetTargetPropertyPut(Value : string);
begin
   FTargetPropertyPut := Value;
   if FTargetPropertyGet = '' then
      FTargetPropertyGet := Value;
   if not (csLoading in ComponentState) then
   begin
      ExecTargetSource;
   end;
end;

procedure TCustomJumper.SetTargetPropertyGet(Value : string);
begin
   FTargetPropertyGet := Value;
   if FTargetPropertyPut = '' then
      FTargetPropertyPut := Value;
   if not (csLoading in ComponentState) then
   begin
      ExecTargetSource;
   end;
end;

procedure TCustomJumper.SetRefreshChange(Value : boolean);
begin
   FRefreshChange := Value;
   ExecTargetSource;
end;

procedure TCustomJumper.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FSource <> nil) and (AComponent = Source) then
       Source := nil;
    if (FTarget <> nil) and (AComponent = Target) then
       Target := nil;
  end;
end;


procedure TCustomJumper.LinkEvent(Sender : TObject; lState : TLinkState);
begin
  inherited LinkEvent(Sender, lState);
  if assigned(FOnChange) then
     FOnChange(Self);
  if assigned(Target) and assigned(Source) then
  begin
     case  lState of
        //Atualiza Target
        lLoad, lRefresh, lRefreshTarget :
               begin
                 FRTTITarget.PutProperty(TargetPropertyPut, FRTTISource.GetProperty(SourcePropertyGet));
                 if (Target is TCCSListaLinks) then
                    TCCSListaLinks (Target).NotifyLinks (Sender, lState);
               end;
        //Atualiza Source
        lUpDate, lRefreshSource : FRTTISource.PutProperty(SourcePropertyPut, FRTTITarget.GetProperty(TargetPropertyGet));
     end;
  end;
end;

procedure TCustomJumper.ExecTargetSource;
begin
  if assigned(Target) and assigned(Source) then
  begin
    LinkEvent(self, lRefresh);
  end;
end;

procedure TCustomJumper.DoChangeMethodAll; assembler;
begin
     asm
       //Preserva o stack
       push ebp
       mov  ebp,esp

       //O eax aponta para o conector (self)
       push eax

       //Vai usar o ebp para apontar ao conector
       push ebp
       mov  ebp,eax

       //coloca em eax o self do Source onde esta o ChangeTarget
       mov eax, eax + offset [FSource]

       //salva registradores que podem ser alterados livremente pelo metodos
       push ecx
       push edx

       //Chama o metodo ChangeTarget para avisar que ocorreu o evento
       call TMethod(ebp + offset [FAuxMethod2]).code
       pop edx
       pop ecx
       pop ebp
       pop eax

       // verifica se o usuario esta ocupando o evento em algum lugar do form
       cmp TMethod(eax + offset [FAuxMethod]).code, 0
       je @SemEvento

       //Deixa a pilha do jeito que estava antes de comecar a rotina
       mov esp,ebp
       pop ebp

       //salta para o tratamento do evento no form
       //o proprio evento retorna corretamente
       jmp TMethod(eax + offset [FAuxMethod]).code

@SemEvento:

       {
            Caso nao exista mapiamento do evento pelo form ou outro objeto entao
       esta rotina devera tratar o retorn da chamada do evento, que foi  montada
       de acordo com a quantidade de paramentros do eveento, seguindo o criterio
       de passagem de parametros do tipo REGISTER, pela qual os paramentros  sao
       passados os primeiros tres me EAX, EDX e ECX, e se houver mais parametros
       serao colocados na pilha, no caso especifico de um objeto o primeiro para
       metro e o self, portanto, ele sera colocado em EAX, e os outros  seguiram
       conforme a convencao REGISTER, neste caso um evento que posui ate 2 para-
       metros serao podera retornar dando um simples RET, mas eventos que possui
       3 ou mais parametros deverao retirar da pilha a difereneca no caso de   3
       parametros usara o RET $0004, com 4 RET $0008, com 5 RET $000C,  e  assim
       por diante com multiplos de 4 bytes por parametros a mais do que 2.
       }

       cmp  BYTE PTR (eax + offset [FCountParam]),2
       jg @TiraParametros
       mov  esp,ebp
       pop ebp
       ret

@TiraParametros:
       push ecx
       push ebx
       mov  ecx, eax + offset [FCountParam]
       dec  ecx
       dec  ecx
       shl  ecx,2
       mov  ebx, [ebp]
       mov  [ebp + ecx], ebx
       mov  ebx, [ebp+4]
       add  ebp,ecx
       mov  [ebp+4], ebx
       pop  ebx
       pop  ecx
       mov  esp,ebp
       pop ebp
       ret

     end;
end;

end.

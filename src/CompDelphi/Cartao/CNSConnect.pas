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




unit CNSConnect;
{ ****************************************************************** }
{                                                                    }
{   CNSConnect.pas                                                   }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Julho/1998                                                    }
{                                                                    }
{ ****************************************************************** }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,  stdctrls, dbctrls, DB,
  ccslistalinks, CNSDBSUS, DsgnIntf, checklst, menus, CNSCriptografia, dbtables, cnserros, CNSPessoa, CCSPreparar, CCSPilhas,Conector;

type

  TTipoListaOpcoes = (oCaption, oName);
  TFuncional = set of(Incluir, Excluir, Alterar, Imprimir);
  TCustomMenuControl = class;
  TCustomUserName = class;
  TCustomGrupo = class;
  TUserName = class;
  //Classe de execao
  EGrupo = class(ECNSExcecoes);
  EUserName = class(ECNSExcecoes);

  //Classe para intermediar a property default
  TItemsDefault = class(TPersistent)
  private
    FMenuControl : TCustomMenuControl;
    FUserName : TCustomUserName;
    procedure SetMenuControl(Value : TCustomMenuControl);
    procedure SetUserName(Value : TCustomUserName);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create;
    property MenuControl : TCustomMenuControl read FMenuControl write SetMenuControl;
    property UserName : TCustomUserName read FUserName write FUserName;
  published
    { Published declarations }
  end;

  TCustomMenuControl = class(TCCSListaLinks)
  private
    { Private declarations }
    FMainMenu : TMainMenu;
    FPilha : TCustomPilhaStatica;
    FItemExiste : boolean;
    FListaOpcoes : TStrings;
    FListaNomesOpcoes : TStrings;
    FListaFuncional : TStrings;
    FCustom : TStrings;
    FListaCustom : TStrings;
    FMontarLista : Boolean;
    FNumeroOpcoes : integer;
    FFuncional : TFuncional;
    FPermissoesDefault : string;
    function SubItens(Value : TMenuItem; xIdentar : string; TipoOpcoes : TTipoListaOpcoes) : string;
    procedure SetMontarLista(Value : boolean);
    procedure SetMainMenu(Value : TMainmenu);

    procedure SetListaOpcoes(Value : TStrings);
    function GetListaOpcoes : TStrings;

    procedure SetListaNomesOpcoes(Value : TStrings);
    function GetListaNomesOpcoes : TStrings;


    procedure SetListaFuncional(Value : TStrings);
    function GetListaFuncional : TStrings;

    procedure SetListaCustom(Value : TStrings);
    function GetListaCustom : TStrings;

    procedure SetCustom(Value : TStrings);
    function GetCustom : TStrings;


  protected
    { Protected declarations }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MenuToList;
    function itemByName(Value : string) : TMenuItem;
    function ComparaItens(xName : string; Value : TMenuItem) : TMenuItem;
    procedure HabilitarItens(xPermissoes : string);
    procedure HabilitarDefault;
  published
    { Published declarations }
    property Menu : TMainmenu read FmainMenu write SetMainMenu;
    property ItemExiste : boolean read FItemExiste write FItemExiste;
    property MontarLista : boolean read FMontarLista write SetMontarLista;
    property NumeroOpcoes : integer read FNumeroOpcoes write FNumeroOpcoes;
    property ListaOpcoes : TStrings read GetListaOpcoes write SetListaOpcoes;
    property ListaNomesOpcoes : TStrings read GetListaNomesOpcoes write SetListaNomesOpcoes;
    property ListaFuncional : TStrings read GetListaFuncional write SetListaFuncional;
    property Custom : TStrings read GetCustom write SetCustom;
    property ListaCustom : TStrings read GetListaCustom write SetListaCustom;
    property Funcional : TFuncional read FFuncional write FFuncional;
    property PermissoesDefault : string read FPermissoesDefault write FPermissoesDefault;
  end;

  TCNSMenuControl = class(TCustomMenuControl)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Menu : TMainmenu read FmainMenu write SetMainMenu;
    property ItemExiste : boolean read FItemExiste write FItemExiste;
    property MontarLista : boolean read FMontarLista write SetMontarLista;
    property NumeroOpcoes : integer read FNumeroOpcoes write FNumeroOpcoes;

    property ListaOpcoes : TStrings read GetListaOpcoes write SetListaOpcoes;
    property ListaNomesOpcoes : TStrings read GetListaNomesOpcoes write SetListaNomesOpcoes;
    property ListaFuncional : TStrings read GetListaFuncional write SetListaFuncional;
    property Custom : TStrings read GetCustom write SetCustom;
    property ListaCustom : TStrings read GetListaCustom write SetListaCustom;
    property Funcional : TFuncional read FFuncional write FFuncional;
  end;

  TMenuControl = class(TCustomMenuControl)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Menu : TMainmenu read FmainMenu write SetMainMenu;
    property ItemExiste : boolean read FItemExiste write FItemExiste;
    property MontarLista : boolean read FMontarLista write SetMontarLista;
    property NumeroOpcoes : integer read FNumeroOpcoes write FNumeroOpcoes;

    property ListaOpcoes : TStrings read GetListaOpcoes write SetListaOpcoes;
    property ListaNomesOpcoes : TStrings read GetListaNomesOpcoes write SetListaNomesOpcoes;
    property ListaFuncional : TStrings read GetListaFuncional write SetListaFuncional;
    property Custom : TStrings read GetCustom write SetCustom;
    property ListaCustom : TStrings read GetListaCustom write SetListaCustom;
    property Funcional : TFuncional read FFuncional write FFuncional;
  end;

  TConectorCheck = class(TCustomConector)
  private
    { Private declarations }
    FMenuControl : TCustomMenuControl;
    FStringCheck : string;
    FViewer : TCheckListBox;
    FTratarNome : TCustomPreparar;
    procedure SetMenuControl(Value : TCustomMenuControl);
    procedure SetViewer(Value : TCheckListBox);
    procedure MontarCheckPermissoes;
    procedure StrToCheck;
    procedure CheckToStr;
    procedure ReadStringChekd(Reader: TReader);
    procedure WriteStringChekd(Writer: TWriter);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure ExecViewerControl; override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure LinkEvent(Sender : TObject; lState : TLinkState); override;
    procedure DefineProperties(Filer: TFiler); override;
  published
    { Published declarations }
    property Control;
    property ControlPropertyPut;
    property ControlPropertyGet;
    property RefreshChange;
    property Viewer : TCheckListBox read FViewer write SetViewer;
    property ViewerPropertyPut;
    property ViewerPropertyGet;
    property MenuControl : TCustomMenuControl read FMenuControl write SetMenuControl;
  end;


  TCustomGrupoState = (fsInsert, fsBrowse, fsNull);

  TCustomGrupo = class(TCustomDB)
  private
    { Private declarations }
    FActive : boolean;
    FGrupo : string;
    FDescricao : string;
    FPermissoes : String;
    FListaGrupos : TStrings;
    FListaPermissoes : TStrings;
    FTratarNome : TCustomPreparar;
    FErroGrupo : EGrupo;
    procedure SetListaGrupos(Value : TStrings);
    function GetListaGrupos : TStrings;
    procedure SetListaPermissoes(Value : TStrings);
    function GetListaPermissoes : TStrings;
    procedure SetActive(Value : boolean);
  protected
    { Protected declarations }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetarParametrosBanco; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateTable; override;
    procedure DropTable; override;
    procedure Novo; override;
    procedure Excluir; override;
    function GetPermissoes(xGrupo : string) : string;
    procedure SelectAll ; override;
    procedure Carregar(P1, P2, P3, P4 : string); override;
    procedure Atualizar; override;
    procedure CarregarGrupo(xGrupo : string); virtual;
    function ObterPermissoes : string;
    procedure BancoToProperty; override;
    property Active : boolean read FActive write SetActive;
    property Grupo : string read FGrupo write FGrupo;
    property Descricao : string read FDescricao write FDescricao;
    property Permissoes : string read FPermissoes write FPermissoes;
    property ListaGrupos : TStrings read GetListaGrupos write SetListaGrupos;
    property ListaPermissoes : TStrings read GetListaPermissoes write SetListaPermissoes;
  published
    { Published declarations }
  end;


  TCNSGrupo = class(TCustomGrupo)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    { from CNSDBSUS }
    property AtivarFields;
    property DataSource;
    property CNSDataBase;

    property Active;
    property Grupo;
    property Descricao;
    property ListaGrupos;
    property ListaPermissoes;
    property Permissoes;
  end;

  TGrupo = class(TCustomGrupo)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure CarregarGrupo(xGrupo : string); override;
  published
    { Published declarations }
    { from CNSDBSUS }
    property AtivarFields;
    property DataSource;
    property CNSDataBase;
    property Banco;

    property Grupo;
    property Descricao;
    property ListaGrupos;
    property ListaPermissoes;
    property Permissoes;
  end;

  TipoFuncionario = (Administrador, Digitador, Supervisor, Recenseador);
  TCustomUserName = class(TCustomDB)
  private
    { Private declarations }
        { Storage for property DataSource }
        FActive : boolean;
        FSenha : string;
        FSenhaAux : string;
        FCNSGrupo : TCustomGrupo;
        FHabilitado : string;
        FTipoFunc : string;
        FUserName : string;
        FCriptografia : TCNSCriptografia;
        FOnChange: TNotifyEvent;
        FListaUserName : TStrings;
        FListaSenha : TStrings;
        FListaGrupo : TStrings;
        FShowDialog : boolean;
        FErroUserName : EUserName;
        FFuncionario : TCNSPessoa;
        procedure SeTCNSCriptografia(Value : TCNSCriptografia);
        procedure SeTCustomGrupo(Value : TCustomGrupo);
        procedure SetActive(Value : boolean);
        procedure SetListaUserName(Value : TStrings);
        function GetListaUserName : TStrings;
        procedure SetListaSenha(Value : TStrings);
        function GetListaSenha : TStrings;
        procedure SetListaGrupo(Value : TStrings);
        function GetListaGrupo : TStrings;
        procedure SetShowDialog(Value : boolean);
        procedure SetFuncionario(Value : TCNSPessoa);
    protected
        procedure Notification(AComponent : TComponent; Operation : TOperation); override;
        procedure Loaded; override;
        property Active : boolean read FActive write SetActive;
        procedure SetarParametrosBanco; override;
    public
        procedure SelectAll ; override;
        procedure ExecuteUserNameDialog;
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure CreateTable; override;
        procedure DropTable; override;
        procedure Novo; override;
        procedure Carregar(P1, P2, P3, P4 : string); override;
        procedure CarregarUserName; virtual;
        procedure BancoToProperty; override;
        procedure Excluir; override;
        procedure Atualizar; override;
        function ValidarUserName(LoginUser, SenhaUser : string) : boolean; virtual;
        //Caregar UserName com as propriedades setadas
        property Criptografia : TCNSCriptografia read FCriptografia write SeTCNSCriptografia;
        property Grupo : TCustomGrupo read FCNSGrupo write SeTCustomGrupo;
        property OnChange : TNotifyEvent read FOnChange write FOnChange;
        property Senha : string read FSenha write FSenha;
        property Habilitado : string read FHabilitado write FHabilitado;
        property TipoFunc : string read FTipoFunc write FTipofunc;
        property UserName : string read FUserName write FUserName;
        property ListaUserName : TStrings read GetListaUserName write SetListaUserName;
//        property ListaSenha : TStrings read GetListaSenha write SetListaSenha;
//        property ListaGrupo : TStrings read GetListaGrupo write SetListaGrupo;
        property ShowDialog : boolean read FShowDialog write SetShowDialog;
        property Funcionario : TCNSPessoa read FFuncionario write SetFuncionario;
     published
  end;

  TUserName = class(TCustomUserName)
  private
       FErroUserName : EUserName;
  public
        procedure Excluir; override;
  published
        { from CNSDBSUS}
        property AtivarFields;
        property DataSource;
        property CNSDataBase;
        property Banco;

        property Active;
        property Criptografia;
        property Grupo;
        property OnChange;
        property Senha;
        property Habilitado;
        property TipoFunc;
        property UserName;
  end;


  TCNSUserName = class(TCustomUserName)
  private
        FPis : string;
        FErroUserName : EUserName;
  protected
        procedure SetarParametrosBanco; override;

  public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure CreateTable; override;
        procedure DropTable; override;
        procedure Carregar(P1, P2, P3, P4 : string); override;
        procedure CarregarUserName;override;
        procedure BancoToProperty; override;
        procedure Excluir; override;
        procedure Novo; override;
        procedure Atualizar; override;
        function ValidarUserName(LoginUser, SenhaUser : string) : boolean; override;

  published
        { from CNSDBSUS}
        property AtivarFields;
        property DataSource;
        property CNSDataBase;
        property Banco;

        property Active;
        property Criptografia;
        property Grupo;
        property OnChange;
        property Senha;
        property Habilitado;
        property Pis : string read FPis write FPis;
        property TipoFunc;
        property UserName;
        property ListaUserName;
        property Funcionario;
  end;


  TCustomLogin = class(TComponent)
  private
    { Private declarations }
    FUserName : TCustomUserName;
    FMenuControl : TCustomMenuControl;
    FTentativas : integer;
    FFalhas : integer;
    FOnLoginErrado : TNotifyEvent;
    FItemsDefault : TItemsDefault;
    procedure SeTCustomUserName(Value : TCustomUserName);
    procedure SetMenuControl(Value : TCustomMenuControl);
    procedure SetItensDefault(Value : TItemsDefault);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Show : boolean; virtual;
    property Falhas : integer read FFalhas;
    property UserName : TCustomUserName  read  FUserName write SeTCustomUserName;
    property MenuControl : TCustomMenuControl read FMenuControl write SetMenuControl;
    property Tentativas : integer read FTentativas write FTentativas;
    property ItemsDefault : TItemsDefault read FItemsDefault write FItemsDefault;
    property OnLoginErrado : TNotifyEvent read FOnLoginErrado write FOnLoginErrado;
  published
    { Published declarations }
  end;

  TCNSLogin = class(TCustomLogin)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Falhas;
    property ItemsDefault;
    property UserName;
    property MenuControl;
    property Tentativas;
    property OnLoginErrado;
  end;

  TLogin = class(TCustomLogin)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Falhas;
    property UserName;
    property MenuControl;
    property ItemsDefault;
    property Tentativas;
    property OnLoginErrado;
  end;

procedure register;
implementation
uses ItemsdefaultReg, login01; //, UserNameDialog;

procedure Register;
begin
//  RegisterComponents('Cartao', [TCustomMenuControl]);
//  RegisterComponents('Cartao', [TCustomGrupo]);
//  RegisterComponents('Cartao', [TCustomUserName]);
//  RegisterComponents('Cartao', [TCustomLogin]);
  RegisterPropertyEditor(TypeInfo(string), TConectorCheck, 'ControlPropertyPut', TControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorCheck, 'ControlPropertyGet', TControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorCheck, 'ViewerPropertyPut', TViewerPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorCheck, 'ViewerPropertyGet', TViewerPropProperty);
  RegisterPropertyEditor(TypeInfo(TItemsDefault), TCustomLogin, 'ItemsDefault', TItemsDefaultProperty);
  RegisterPropertyEditor(TypeInfo(TItemsDefault), TLogin, 'ItemsDefault', TItemsDefaultProperty);
end;

////Items Default///////////////////////////////
constructor TItemsDefault.Create;
begin
  inherited Create;
end;
procedure TItemsDefault.SetMenuControl(Value: TCustomMenuControl);
begin
  if assigned(VAlue) then
  begin
     FMenuControl := Value;
  end;
end;

procedure TItemsDefault.SetUserName(Value: TCustomUserName);
begin
  if assigned(VAlue) then
  begin
     FUserName := Value;
  end;
end;

/////////////////Menu Control ///////
constructor TCustomMenuControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPilha := TCustomPilhaStatica.Create(nil);
  FListaOpcoes := TStringList.Create;
  FListaNomesOpcoes := TStringList.Create;
  FListaFuncional := TStringList.Create;
  FListaCustom := TStringList.Create;
  FCustom := TStringList.Create;
end;

destructor TCustomMenuControl.Destroy;
begin
  FListaFuncional.free;
  FListaCustom.free;
  FCustom.free;
  FListaOpcoes.Free;
  FListaNomesOpcoes.Free;
  FPilha.Destroy;
  inherited Destroy;
end;



procedure TCustomMenuControl.Loaded;
begin
  inherited Loaded;
end;


procedure TCustomMenuControl.SetMainMenu(Value : TMainMenu);
begin
   FMainMenu := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(self);
      //Setar MenuControl da Classe intermediaria para passar para o editor
   end;
end;

function TCustomMenuControl.GetListaOpcoes : TStrings;
begin
     Result := FListaOpcoes;
end;

procedure TCustomMenuControl.SetListaOpcoes(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListaOpcoes.Assign(Value);
end;

function TCustomMenuControl.GetListaNomesOpcoes : TStrings;
begin
     Result := FListaNomesOpcoes;
end;


function TCustomMenuControl.GetListaFuncional : TStrings;
begin
     Result := FListaFuncional;
end;

function TCustomMenuControl.GetListaCustom : TStrings;
begin
     Result := FListaCustom;
end;

function TCustomMenuControl.GetCustom : TStrings;
begin
     Result := FCustom;
end;

procedure TCustomMenuControl.SetListaNomesOpcoes(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListaNomesOpcoes.Assign(Value);
end;

procedure TCustomMenuControl.SetListaFuncional(Value : TStrings);
begin
     FListaFuncional.Assign(Value);
end;

procedure TCustomMenuControl.SetListaCustom(Value : TStrings);
begin
     FListaCustom.Assign(Value);
end;

procedure TCustomMenuControl.SetCustom(Value : TStrings);
begin
     FCustom.Assign(Value);
end;

procedure TCustomMenuControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FMainMenu <> nil) and (AComponent = Menu) then
       Menu := nil;
//    if (FGrupo <> nil) and (AComponent = Grupo) then
//       Grupo := nil;
  end;
end;



procedure TCustomMenuControl.MenuToList;
{
    Metodo para pegar o menu que estiver setado e passar seus item para um
  duas lista uma de nomes e outra caption
}
var
   i, j, NumElementos, NumElementosPilha : integer;
begin
   if assigned(FMainMenu) then
   begin
      FListaOpcoes.clear;
      FListaNomesOpcoes.Clear;

      //Encher Lista de Caption
      FPilha.Init;
      NumElementos := FMainMenu.Items.Count - 1;
      for i := 0 to NumElementos do
      begin
         FPilha.Push(SubItens(FMainMenu.items[i], '', oCaption));
         NumElementosPilha := FPilha.Posicao;
         for j := 1 to  NumElementosPilha do
         begin
            FListaOpcoes.Add(FPilha.Pop);
         end
      end;

      //Encher Lista com Nome
      FPilha.Init;
      NumElementos := FMainMenu.Items.Count - 1;
      for i := 0 to NumElementos do
      begin
         FPilha.Push(SubItens(FMainMenu.items[i], '', oName));
         NumElementosPilha := FPilha.Posicao;
         for j := 1 to  NumElementosPilha do
         begin
            FListaNomesOpcoes.Add(Trim(FPilha.Pop));
         end
      end;
      //Indica o Numero de Opcoes no Menu
      FNumeroOpcoes := FListaNomesOpcoes.count - 1;
   end;
end;

function TCustomMenuControl.SubItens(Value : TMenuItem; xIdentar : string; TipoOpcoes : TTipoListaOpcoes) : string;
var
   i : integer;
   NumSubItens : integer;
begin
   xIdentar := xIdentar + #32 + #32 + #32;
   NumSubItens := Value.Count - 1;
   for i := NumSubItens downto 0 do
   begin
      FPilha.Push( xIdentar + SubItens(Value.Items[i], xIdentar, TipoOpcoes));
   end;
   if TipoOpcoes = oCaption then
      Result := Value.Caption
   else
      Result := Value.Name;
end;

function TCustomMenuControl.ItemByName(Value : string) : TMenuItem;
{
         metodo para devolver o item referente ao nome passado se nao existir
   devolve nil
}
var
   i, NumElementos : integer;
begin
   result := nil;
   if assigned(FMainMenu) then
   begin
      NumElementos := FMainMenu.Items.Count - 1;
      for i := 0 to NumElementos do
      begin
        Result := ComparaItens(Value, FMainMenu.items[i]);
        if result <> nil then exit;
      end;
   end;
end;


function TCustomMenuControl.ComparaItens(xName : string; Value : TMenuItem) : TMenuItem;
{
   Funcao recursiva para procurar dentro da estrutura do menu se um item existe
   Verifica se o nome passado corresponde a algum item do menu se corresponder
devolve o item achado
}
var
   i : integer;
   NumSubItens : integer;
begin
   result := nil;
   if Value.Name = xName then
   begin
      Result := Value;
   end else
   begin
      NumSubItens := Value.Count - 1;
      if NumSubItens > -1 then
      begin
         for i := 0 to NumSubItens do
         begin
            Result := ComparaItens(xName, Value.Items[i]);
            if Result <> nil then exit;
         end
      end else
      begin
         Result := nil;
      end;
   end;
end;

procedure TCustomMenuControl.SetMontarLista(Value : Boolean);
begin
   FMontarLista := Value;
   if Value = True then
      MenuToList
   else
      FListaOpcoes.Clear;
end;


procedure TCustomMenuControl.HabilitarDefault;
begin
   // colocar a execao para trabat default vazio
   try
     HabilitarItens(PermissoesDefault);
   except
      showmessage('chamra a excecao correta');
   end;
end;

procedure TCustomMenuControl.HabilitarItens(xPermissoes : string);
var
   xMenu : TMenuItem;
   I : integer;
begin
   ///colocar a execao para tratar vazio
   if assigned(Menu) then
   begin
      for i := 0 to FListaNomesOpcoes.Count - 1 do
      begin
          xMenu := ItemByName(FListaNomesOpcoes[i]);
          if ItemExiste  then
             xMenu.Enabled := (xPermissoes[i + 1] = 'T')
          else
             xMenu.Visible := (xPermissoes[i + 1] = 'T');

      end;
   end;
end;


/////Grupo///////////////////////////////////////////////////////////

constructor TCustomGrupo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListaGrupos := TStringList.Create;
  FListaPermissoes := TStringList.Create;
  FTratarNome := TCustomPreparar.Create(nil);
  TableName := 'TipoFuncionario';
  ObjectView.Clear;
  ObjectView.Add('Select * From TipoFuncionario');
end;

destructor TCustomGrupo.Destroy;
begin
  FListaPermissoes.free;
  FListaGrupos.free;
  FTratarNome.Destroy;
{   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('select * from ' + TableName);
         open
      end;
   end;
   except
 }
  inherited Destroy;
end;

procedure TCustomGrupo.Loaded;
begin
  inherited Loaded;
end;

procedure TCustomGrupo.SetListaGrupos(Value : TStrings);
begin
     FListaGrupos.Assign(Value);
end;

procedure TCustomGrupo.SetListaPermissoes(Value : TStrings);
begin
     FListaPermissoes.Assign(Value);
end;

function TCustomGrupo.GetListaGrupos : TStrings;
begin
     Result := FListaGrupos;
end;

function TCustomGrupo.GetListaPermissoes : TStrings;
begin
     Result := FListaPermissoes;
end;

procedure TCustomGrupo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
  end;
end;

procedure TCustomGrupo.SetarParametrosBanco;
begin
   case Banco of
      Paradox : TableName := '''TipoFuncionario''';
   else
      TableName := 'TipoFuncionario';
   end;
end;

procedure TCustomGrupo.CreateTable;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('CREATE TABLE ' + TableName);
         sql.add('( ');
         sql.add('TipoFunc     varchar(04) ' + ISNotNUll + ', ');
         sql.add('Descricao    varchar(20), ');
         sql.add('Grupo        varchar(04),');
         sql.add('Permissoes   varchar(255),');
         sql.add('PRIMARY KEY (TipoFunc)');
         sql.add(' )');
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
         except
            FErroGrupo := EGrupo.Create('Erro Criando Tabela');
            raise FErroGrupo;
            CNSDataBase.RollBack;
            FErroGrupo.Free;
         end;
      end;
   end;
end;

procedure TCustomGrupo.DropTable;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('DROP TABLE ' + TableName);
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
         except
            FErroGrupo := EGrupo.Create('Erro Destruindo Tabela');
            raise FErroGrupo;
            CNSDataBase.RollBack;
            FErroGrupo.Free;
         end;
      end;
   end;
end;


procedure TCustomGrupo.Novo;
{
         Metodo para iniciar propriedades com vazios;
}
var
   i : integer;
begin
   FGrupo := '';
   FDescricao := '';
   FPermissoes := '';
   for i := 1 to 255 do
      FPermissoes := FPermissoes + 'F';
   CanUpdate := False;
   NotifyLinks(self, lRefreshViewer);
end;

procedure TCustomGrupo.Excluir;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         if CanUpdate then
         begin
            sql.add('DELETE FROM ' + TableName);
            sql.add(' where TipoFunc = :TipoFunc');
         end;
         NotifyLinks(self, lUpDate);
         ParamByName('Tipofunc').AsString := FGrupo;
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
            //Atualizar os componetes
            NotifyLinks(self, lRefreshViewer);
         except
            CNSDataBase.RollBack;
            FErroGrupo := EGrupo.Create('Erro Excluindo Registro');
            raise FErroGrupo;
            FErroGrupo.Free;
         end;
      end;
   end;
end;


procedure TCustomGrupo.CarregarGrupo(xGrupo : string);
{
         Metodo para caregar um grupo, de acordo com o grupo mas nao faz a notificacao
de que este grupo foi carregado;
         Para que a carga de um grupo seja notificada use o metodo carregar;
}
var
   i : integer;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('select * from TipoFuncionario where TipoFunc = :Grupo');
         ParamByName('Grupo').AsString := xGrupo;
         Open;
         if not eof then
         begin
             FDescricao := FieldByName('Descricao').AsString;
             FPermissoes := FieldByName('Permissoes').AsString;
             CanUpdate := True;
         end else
         begin
             FDescricao := '';
             FPermissoes := '';
             for i := 1 to 255 do
                 FPermissoes := FPermissoes + 'F';
             CanUpdate := False;
         end;
         FGrupo := xGrupo;
      end;
   end;
end;

procedure TCustomGrupo.Atualizar;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         if not CanUpdate then
         begin
            sql.add('INSERT INTO TipoFuncionario (TipoFunc,    Descricao,  Permissoes)');
            sql.add('VALUES            (:Grupo,     :Descricao, :Permissoes)');
            CanUpdate := True;
         end else
         begin
            sql.add(' UPDATE  TipoFuncionario   SET Permissoes = :Permissoes, Descricao = :Descricao');
            sql.add(' where TipoFunc = :Grupo');
            CanUpdate := True;
         end;
         //Dispara a notificacao para pedir as prop
         NotifyLinks(self, lUpDate);
         ParamByName('Grupo').AsString := FGrupo;
         ParamByName('Descricao').AsString := FDescricao;
         ParamByName('Permissoes').AsString := FPermissoes;
         //Avisa a componentes para passar os dados que eles estao tratando se ele existir;
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
            //Atulizar os componetes visuais que usam estas properties
            NotifyLinks(self, lRefreshViewer)
         except
            on h2 : EDBEngineError do
               begin
               ShowMessage('E0021 - Erro ao Atualizar Grupo - ' + Grupo);
               CNSDataBase.RollBack;
               end;
            on h1 : EDatabaseError do
               begin
               ShowMessage('E0021 - Erro ao Atualizar Grupo - ' + Grupo);
               CNSDatabase.RollBack;
               end;
         end;
      end;
   end;
end;


function TCustomGrupo.ObterPermissoes : string;
begin
  Result := FPermissoes;
end;

function TCustomGrupo.GetPermissoes(xGrupo : string) : string;
{
   Metodo para achar as permissoes de um Grupo qualquer desde esteja na lista
}
var
  lPosicao : integer;
begin
   lPosicao := FListaGrupos.IndexOf(xGrupo);
   if lPosicao = -1 then
   begin
      //gerar except
      Result := '';
   end else
   begin
      Result := FListaPermissoes[lPosicao];
   end;
end;

procedure TCustomGrupo.SetActive(Value : boolean);
begin
   if FActive <> Value then
   begin
      FActive := Value;
      if not (csLoading in ComponentState) then
         if FActive then
             SelectAll;
   end;
end;


procedure TCustomGrupo.Carregar(P1, P2, P3, P4 : string);
var
   i : integer;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('select * from TipoFuncionario where TipoFunc = :Grupo');
         ParamByName('Grupo').AsString := P1;
         Open;
         if not eof then
         begin
             FDescricao := FieldByName('Descricao').AsString;
             FPermissoes := FieldByName('Permissoes').AsString;
             CanUpdate := True;
         end else
         begin
             FPermissoes := '';
             FDescricao := '';
             for i := 1 to 255 do
                 FPermissoes := FPermissoes + 'F';
             CanUpdate := False;
         end;
         FGrupo := P1;
         NotifyLinks(self, lLoad);
      end;
   end;
end;

procedure TCustomGrupo.SelectAll;
begin
   inherited;
   BancoToProperty;
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      ListaGrupos.Clear;
      ListaPermissoes.Clear;
      with DataSource.Dataset as TQuery do
      begin
         first;
         while not Eof do
         begin
            ListaGrupos.Add(FieldByName('TipoFunc').Asstring);
            ListaPermissoes.Add(FieldByName('Permissoes').ASstring);
            next;
         end;
      end;
   end;
end;

procedure TCustomGrupo.BancoToProperty;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      try
      with TQuery(DataSource.DataSet) do
      begin
         FGrupo := FieldByName('TipoFunc').AsString;
         FDescricao := FieldByName('Descricao').AsString;
         FPermissoes := FieldByName('Permissoes').AsString;
      end;
      except
        FGrupo := FGrupo;
      end;
   end;
end;


///TGrupo
procedure TGrupo.CarregarGrupo(xGrupo : string);
{
         Metodo para caregar um grupo, de acordo com o grupo mas nao faz a notificacao
de que este grupo foi carregado;
         Para que a carga de um grupo seja notificada use o metodo carregar;
}
begin
  inherited CarregarGrupo(xGrupo);
{
   i := FListaGrupos.IndexOf(xGrupo);
   if i > - 1 then
   begin
       FDescricao := '';
       FPermissoes := FListaPermissoes[i]
   end else
   begin
       FDescricao := '';
       FPermissoes := '';
       for i := 1 to 255 do
           FPermissoes := FPermissoes + 'F';
   end;
   FGrupo := xGrupo;
}
end;



//////TCustomUserName/////////////////////////////////////////////////////////////
constructor TCustomUserName.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FListaUserName := TStringList.Create;
//   FListaSenha := TStringList.Create;
//   FListaGrupo := TStringList.Create;
   TableName := 'UserName';
   ObjectView.Clear;
   ObjectView.Add('Select * From UserName');
end;

destructor TCustomUserName.Destroy;
begin
   FListaUserName.Free;
//   FListaSenha.free;
//   FListaGrupo.free;
{   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('select * from ' + TableName);
         open
      end;
   end;
}   inherited Destroy;
end;

procedure TCustomUserName.Loaded;
begin
{
   try
     FListaUserName.LoadFromFile('UserName.txt');
     FListaSenha.LoadFromFile('Senha.txt');
     FListaGrupo.LoadFromFile('Grupo.txt');
   except
     FListaUserName.clear;
     FListaSenha.clear;
     FListaGrupo.clear;
     FListaUserName.Add('DEFAULT');
     FListaSenha.Add('DEFAULT');
     FListaGrupo.Add('DEFAULT');
   end;
}
   inherited Loaded;
end;



procedure TCustomUserName.SeTCNSCriptografia(Value : TCNSCriptografia);
begin
   FCriptografia := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCustomUserName.SeTCustomGrupo(Value : TCustomGrupo);
begin
   FCNSGrupo := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;


procedure TCustomUserName.SetFuncionario(Value : TCNSPessoa);
begin
   FFuncionario := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;


procedure TCustomUserName.SetActive(Value : boolean);
begin
   if FActive <> Value then
   begin
      FActive := Value;
      if not (csLoading in ComponentState) then
         if FActive then
             SelectAll;
   end;

end;

function TCustomUserName.GetListaUserName : TStrings;
begin
     Result := FListaUserName;
end;

procedure TCustomUserName.SetListaUserName(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListaUserName.Assign(Value);
end;

function TCustomUserName.GetListaSenha : TStrings;
begin
     Result := FListaSenha;
end;

procedure TCustomUserName.SetListaSenha(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListaSenha.Assign(Value);
end;

function TCustomUserName.GetListaGrupo : TStrings;
begin
     Result := FListaGrupo;
end;

procedure TCustomUserName.SetListaGrupo(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FListaGrupo.Assign(Value);
end;

procedure TCustomUserName.SetShowDialog(Value : boolean);
begin
{   if not (csLoading in ComponentState) then
      ExecuteUserNameDialog;
}
end;
procedure TCustomUserName.Notification(AComponent : TComponent; Operation : TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
    if (FCNSGrupo <> nil) and (AComponent = Grupo) then
       Grupo := nil;
    if (FFuncionario <> nil) and (AComponent = Funcionario) then
       Funcionario := nil;
end;

procedure TCustomUserName.SetarParametrosBanco;
begin
   case Banco of
      Paradox : TableName := '''UserName''';
      Oracle  : TableName := 'UserName';
   end;
end;

procedure TCustomUserName.CreateTable;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('CREATE TABLE ' + TableName);
         sql.add('( ');
         sql.add('UserName      varchar(10) ' + ISNotNUll + ', ');
         sql.add('TipoFunc      varchar(10), ');
         sql.add('Senha         varchar(10), ');
         sql.add('DT_ValSenha   Date, ');
         sql.add('Habilitado    varchar(01), ');
         sql.add('PRIMARY KEY (UserName)');
         sql.add(' )');
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
         except
            FErroUserName := EUserName.Create('Erro Criando Tabela');
            raise FErroUserName;
            CNSDataBase.RollBack;
            FErroUserName.Free;
         end;
      end;
   end;
end;

procedure TCustomUserName.DropTable;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('Drop TABLE ' + TableName);
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
         except
            FErroUserName := EUserName.Create('Erro Destruindo Tabela');
            raise FErroUserName;
            CNSDataBase.RollBack;
            FErroUserName.Free;
         end;
      end;
   end;
end;


procedure TCustomUserName.Novo;
{
          Metodo para iniciar as propriedades na e efetivado enquando nao for dado
    o atualizar;
}
begin
   FUserName := '';
   FSenha := '';
   FSenhaAux := '';
   FHabilitado := '';
   FTipoFunc := '';
   CanUpdate := False;
   if assigned(FCNSGrupo) then
      FCNSGrupo.CarregarGrupo(TipoFunc);
   NotifyLinks(self, lRefreshViewer);
end;



procedure TCustomUserName.CarregarUserName;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         NotifyLinks(self, lUpDate);  //le valores das variaveis
         close;
         sql.clear;
         sql.add('select * from UserName where UserName = :UserName');
         ParamByName('UserName').AsString := FUserName;
         Open;
         if not eof then
         begin
             FSenha := FieldByName('Senha').AsString;
             FSenhaAux := FSenha;
             FHabilitado := FieldByName('Habilitado').AsString;
             FTipoFunc := FieldByName('TipoFunc').AsString;
             CanUpdate := True;
         end else
         begin
             FSenha := '';
             FSenhaAux := '';
             FHabilitado := '';
             FTipoFunc := '';
             CanUpdate := False;
         end;
         FUserName := FUserName;
      end;
      if assigned(FCriptografia) then
         FCriptografia.Cripto := FSenha;
      if Assigned(FOnChange) then FOnChange(Self);
      if assigned(FCNSGrupo) then
         FCNSGrupo.CarregarGrupo(TipoFunc);
      NotifyLinks(self, lLoad);
   end;
end;

procedure TCustomUserName.Atualizar;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         if not CanUpdate then
         begin
            sql.add('INSERT INTO UserName (TipoFunc,   UserName,   Senha,   Habilitado)');
            sql.add('VALUES               (:TipoFunc, :UserName, :Senha, :Habilitado)');
            CanUpdate := True;
         end else
         begin
            sql.add(' UPDATE  UserName   SET TipoFunc = :TipoFunc, Senha = :Senha, Habilitado = :Habilitado');
            sql.add(' where UserName = :UserName');
            CanUpdate := True;
         end;
         //Le o conteudo as propriedades nos visualizadores
         NotifyLinks(self, lUpDate);
         ParamByName('TipoFunc').AsString := FTipoFunc;
         ParamByName('UserName').AsString := FUserName;
         //Verifica se component de criptografia esta setado
         if assigned(FCriptografia) then
         begin
            if Criptografia.Cripto = '' then
               Criptografia.Senha := FSenha;
            ParamByName('Senha').AsString := Criptografia.Cripto;
         end else
         begin
            ParamByName('Senha').AsString := FSenha;
         end;
//         ParamByName('Senha').AsString := FSenha;
         ParamByName('Habilitado').AsString := FHabilitado;
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
            //Atualizar os componetes
            NotifyLinks(self, lRefreshViewer);
         except
            on h2 : EDBEngineError do
               begin
               //ShowMessage('E0021 - Erro ao Atualizar UserName - ' + UserName);
               CNSDataBase.RollBack;
               end;
            on h1 : EDatabaseError do
               begin
               //ShowMessage('E0021 - Erro ao Atualizar UserName - ' + UserName);
               CNSDatabase.RollBack;
               end;
         end;
      end;
      if Assigned(FOnChange) then FOnChange(Self);
   end;
end;


function TCustomUserName.ValidarUserName(LoginUser, SenhaUser : string) : boolean;
begin
   Result := False;
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('select * from UserName where UserName = :xUserName and Senha = :xSenha');
         ParamByName('xUserName').AsString := LoginUser;
         //disparar os metodos para criptografia no metodo set da senha
         if assigned(FCriptografia) then
         begin
            FCriptografia.Senha := SenhaUser;
            ParamByName('xSenha').AsString := Criptografia.Cripto;
         end else
         begin
            ParamByName('xSenha').AsString := SenhaUser;
         end;
         Open;
         if not eof then
         begin
            //posicionar grupo para quem precisar ler grupo
            FCNSGrupo.CarregarGrupo(FieldByname('TipoFunc').AsString);
            Result := true;
         end;
      end;
   end;
end;


procedure TCustomUserName.Carregar(P1, P2, P3, P4 : string);
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with TQuery(DataSource.Dataset) do
      begin
         close;
         sql.clear;
         sql.add('select * from UserName where UserName = :UserName');
         ParamByName('UserName').AsString := P1;
         Open;
         if not eof then
         begin
             FSenha := FieldByName('Senha').AsString;
             FHabilitado := FieldByName('Habilitado').AsString;
             FTipoFunc := FieldByName('TipoFunc').AsString;
             CanUpdate := True;
         end else
         begin
             FSenha := '';
             FHabilitado := '';
             FTipoFunc := '';
             CanUpdate := False;
         end;
         FUserName := P1;
      end;
      if Assigned(FOnChange) then FOnChange(Self);
      if assigned(FCNSGrupo) then
         FCNSGrupo.CarregarGrupo(TipoFunc);
      if assigned(FCriptografia) then
         FCriptografia.Cripto := FSenha;
      NotifyLinks(self, lLoad);
   end;
end;

procedure TCustomUserName.Excluir;
begin
   inherited;
end;

procedure TCustomUserName.SelectAll;
begin
   inherited;
   BancoToProperty;
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      ListaUserName.Clear;
      with DataSource.Dataset as TQuery do
      begin
         first;
         while not Eof do
         begin
            ListaUserName.Add(FieldByName('TipoFunc').Asstring);
            next;
         end;
      end;
   end;
end;

procedure TCustomUserName.BancoToProperty;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with TQuery(DataSource.DataSet) do
      begin
         FUserName := FieldByName('UserName').AsString;
         FSenha := FieldByName('Senha').AsString;
         FHabilitado := FieldByName('Habilitado').AsString;
         FTipoFunc := FieldByName('TipoFunc').AsString;
      end;
      if assigned(FCNSGrupo) then
         FCNSGrupo.CarregarGrupo(TipoFunc);
   end;
end;

procedure TCustomUserName.ExecuteUserNameDialog;
//var
//  xUserName : TFrmUserNameDialog;
begin
{
   if assigned(Grupo) then
   begin
      xUserName := TFrmUserNameDialog.Create(self);
      xUserName.LBUserName.Items.Assign(FListaUserName);
      xUserName.ListaSenha.Assign(FListaSenha);
      xUserName.ListaGrupo.Assign(FListaGrupo);
      xUserName.CBGrupo.Items.Assign(Grupo.ListaGrupos);
      xUserName.ShowModal;
      if xUserName.ModalResult = mrOk then
      begin
         FListaUserName.Assign(xUserName.LBUserName.Items);
         FListaSenha.Assign(xUserName.ListaSenha);
         FListaGrupo.Assign(xuserName.ListaGrupo);
         FListaUserName.SaveToFile('UserName.txt');
         FListaSenha.SaveToFile('Senha.txt');
         FListaGrupo.SaveToFile('Grupo.txt');
      end;
      xUserName.Destroy;
   end;
}
end;



//////TCNSUserName/////////////////////////////////////////////////////////////
constructor TCNSUserName.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   TableName := 'UserFunc';
   ObjectView.Clear;
   ObjectView.Add('Select * From UserFunc');
end;

destructor TCNSUserName.Destroy;
begin
   inherited Destroy;
end;

procedure TCNSUserName.SetarParametrosBanco;
begin
   case Banco of
      Paradox : TableName := '''UserFunc''';
      Oracle  : TableName := 'UserFunc';
   end;
end;


procedure TCNSUserName.CreateTable;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('CREATE TABLE ' + TableName);
         sql.add('( ');
         sql.add('UserName      varchar(10) ' + ISNotNUll + ', ');
         sql.add('Pis           varchar(11), ');
         sql.add('TipoFunc      varchar(10), ');
         sql.add('Senha         varchar(10), ');
         sql.add('DT_ValSenha   Date, ');
         sql.add('Habilitado    varchar(01), ');
         sql.add('PRIMARY KEY (UserName, PIS)');
         sql.add(' )');
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
         except
            FErroUserName := EUserName.Create('Erro Criando Tabela');
            raise FErroUserName;
            CNSDataBase.RollBack;
            FErroUserName.Free;
         end;
      end;
   end;
end;

procedure TCNSUserName.DropTable;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('Drop TABLE ' + TableName);
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
         except
            FErroUserName := EUserName.Create('Erro Destruindo Tabela');
            raise FErroUserName;
            CNSDataBase.RollBack;
            FErroUserName.Free;
         end;
      end;
   end;
end;

procedure TCNSUserName.CarregarUserName;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         NotifyLinks(self, lUpDate);  //le valores das variaveis
         close;
         sql.clear;
         sql.add('select * from UserFunc where UserName = :UserName and Pis = :Pis');
         ParamByName('UserName').AsString := FUserName;
         ParamByName('Pis').AsString := FPis;
         Open;
         if not eof then
         begin
             FSenha := FieldByName('Senha').AsString;
             FSenhaAux := FSenha;
             FHabilitado := FieldByName('Habilitado').AsString;
             FTipoFunc := FieldByName('TipoFunc').AsString;
             CanUpdate := True;
         end else
         begin
             FSenha := '';
             FSenhaAux := '';
             FHabilitado := '';
             FTipoFunc := '';
             CanUpdate := False;
         end;
         FUserName := FUserName;
         FPis := FPis;
      end;
      if Assigned(FOnChange) then FOnChange(Self);
      if assigned(FCNSGrupo) then
         FCNSGrupo.CarregarGrupo(TipoFunc);
      if assigned(FFuncionario) then
         FFuncionario.Carregar(FPis, '', '', '');
      if assigned(FCriptografia) then
         FCriptografia.Cripto := FSenha;
      NotifyLinks(self, lLoad);
   end;
end;

procedure TCNSUserName.Novo;
begin
   FPis := '';
   inherited Novo; // sobe na hierarquia e notifica
end;
procedure TCNSUserName.Atualizar;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         if not CanUpdate then
         begin
            sql.add('INSERT INTO UserFunc (TipoFunc,    Pis,   UserName,   Senha,   Habilitado)');
            sql.add('VALUES               (:TipoFunc, :Pis, :UserName, :Senha, :Habilitado)');
            CanUpdate := True;
         end else
         begin
            sql.add(' UPDATE  UserFunc   SET TipoFunc = :TipoFunc, Senha = :Senha, Habilitado = :Habilitado');
            sql.add(' where Pis = :Pis and UserName = :UserName');
            CanUpdate := True;
         end;
         //Le o conteudo as propriedades nos visualizadores
         NotifyLinks(self, lUpDate);
         if assigned(FCNSGrupo) then
            ParamByName('TipoFunc').AsString := FCNSGrupo.Grupo
         else
            MessageDlg('E necessario setar Grupo.', mtError, [mbOK],0);
         if assigned(FFuncionario) then
            ParamByName('Pis').AsString := FFuncionario.PIS
         else
            MessageDlg('E necessario setar Funcionario.', mtError, [mbOK],0);
         ParamByName('UserName').AsString := FUserName;
         //Verifica se component de criptografia esta setado
         if assigned(FCriptografia) then
         begin
            ParamByName('Senha').AsString := Criptografia.Cripto;
         end else
         begin
            ParamByName('Senha').AsString := FSenha;
         end;
//         ParamByName('Senha').AsString := FSenha;
         ParamByName('Habilitado').AsString := FHabilitado;
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
            //Atualizar os componetes
            NotifyLinks(self, lRefreshViewer);
         except
            CNSDataBase.RollBack;
            FErroUserName := EUserName.Create('Erro Atualizando Tabela');
             raise FErroUserName;
            FErroUserName.Free;
         end;
      end;
      if Assigned(FOnChange) then FOnChange(Self);
   end;
end;


function TCNSUserName.ValidarUserName(LoginUser, SenhaUser : string) : boolean;
begin
   Result := False;
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('select * from UserFunc where UserName = :xUserName and Senha = :xSenha');
         ParamByName('xUserName').AsString := LoginUser;
         //disparar os metodos para criptografia no metodo set da senha
         if assigned(FCriptografia) then
         begin
            FCriptografia.Senha := SenhaUser;
            ParamByName('xSenha').AsString := Criptografia.Cripto;
         end else
         begin
            ParamByName('xSenha').AsString := SenhaUser;
         end;
         Open;
         if not eof then
         begin
            //posicionar grupo para quem precisar ler grupo
            FHabilitado := FieldByName('Habilitado').AsString;
            FTipoFunc := FieldByName('TipoFunc').AsString;
            FPis := FieldByName('PIS').AsString;
            FUserName := FieldByName('UserName').AsString;
            FCNSGrupo.CarregarGrupo(FieldByname('TipoFunc').AsString);
            Result := true;
         end;
      end;
   end;
end;


procedure TCNSUserName.Carregar(P1, P2, P3, P4 : string);
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with TQuery(DataSource.Dataset) do
      begin
         close;
         sql.clear;
         sql.add('select * from UserFunc where UserName = :UserName and Pis = :Pis');
         ParamByName('UserName').AsString := P1;
         ParamByName('Pis').AsString := P2;
         Open;
         if not eof then
         begin
             FSenha := FieldByName('Senha').AsString;
             FHabilitado := FieldByName('Habilitado').AsString;
             FTipoFunc := FieldByName('TipoFunc').AsString;
             CanUpdate := True;
         end else
         begin
             FSenha := '';
             FHabilitado := '';
             FTipoFunc := '';
             CanUpdate := False;
         end;
         FUserName := P1;
         FPis := P2;
      end;
      if Assigned(FOnChange) then FOnChange(Self);
      if assigned(FCNSGrupo) then
         FCNSGrupo.CarregarGrupo(TipoFunc);
      if assigned(FFuncionario) then
         FFuncionario.Carregar(FPis, '', '', '');
      if assigned(FCriptografia) then
         FCriptografia.Cripto := FSenha;
      NotifyLinks(self, lLoad);
   end;
end;


procedure TCNSUserName.BancoToProperty;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with TQuery(DataSource.DataSet) do
      begin
         FUserName := FieldByName('UserName').AsString;
         FPis := FieldByName('Pis').AsString;
         FSenha := FieldByName('Senha').AsString;
         FHabilitado := FieldByName('Habilitado').AsString;
         FTipoFunc := FieldByName('TipoFunc').AsString;
      end;
      if assigned(FCNSGrupo) then
         FCNSGrupo.CarregarGrupo(TipoFunc);
   end;
end;

procedure TCNSUserName.Excluir;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         if CanUpdate then
         begin
            sql.add('DELETE FROM ' + TableName);
            sql.add(' where Pis = :Pis and UserName = :UserName');
         end;
         NotifyLinks(self, lUpDate);
         ParamByName('Pis').AsString := FPis;
         ParamByName('UserName').AsString := FUserName;
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
            //Atualizar os componetes
            NotifyLinks(self, lRefreshViewer);
         except
            FErroUserName := EUserName.Create('Erro Atualizando Tabela');
            raise FErroUserName;
            CNSDataBase.RollBack;
            FErroUserName.Free;
         end;
      end;
   end;
end;


////////login///////////////////////////////////////////////////////
constructor TCustomLogin.create(AOwner : Tcomponent);
begin
   inherited create(AOwner);
   FItemsDefault := TItemsDefault.Create;
end;

destructor TCustomLogin.destroy;
begin
   FitemsDefault.free;
   inherited destroy;
end;

procedure TCustomLogin.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FUserName <> nil) and (AComponent = UserName) then
       UserName := nil;
    if (FMenuControl <> nil) and (AComponent = MenuControl) then
       MenuControl := nil;
  end;
end;

function TCustomLogin.Show : boolean;
var
  i : integer;
  xLog : TFCSUSConectar;
begin
   xLog := TFCSUSConectar.Create(self);
   Result := False;
   FFalhas := 0;
   for i := 1 to Tentativas do
   begin
      xLog.ShowModal;
      if xlog.ModalResult = mrOk then
      begin
         if (UserName.ValidarUserName(uppercase(xLog.EdtIdent.Text), xLog.EdSenha.Text)) then
         begin
             FMenuControl.HabilitarItens(FUserName.FCNSGrupo.Permissoes);
             Result := True;
             break;
         end else
         begin
             inc(FFalhas);
             if assigned(FOnLoginErrado) then FOnLoginErrado(self);
         end;
      end else
      begin
         Result := True;
         break;
      end;
   end;
   xLog.Destroy;
end;

procedure TCustomLogin.SeTCustomUserName(Value : TCustomUserName);
begin
   FUserName := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
      FItemsDefault.UserName := FUserName;
   end;
end;


procedure TCustomLogin.SetMenuControl(Value : TCustomMenuControl);
begin
   FMenuControl := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
      FItemsDefault.MenuControl := FMenuControl;
   end;
end;

procedure TCustomLogin.SetItensDefault(Value : TItemsDefault);
begin
    FitemsDefault.Assign(Value);
end;



{ TUserName }

procedure TUserName.Excluir;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         if CanUpdate then
         begin
            sql.add('DELETE FROM ' + TableName);
            sql.add('WHERE UserName = :UserName');
         end;
         NotifyLinks(self, lUpDate);
         ParamByName('UserName').AsString := FUserName;
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
            //Atualizar os componetes
            NotifyLinks(self, lRefreshViewer);
         except
            FErroUserName := EUserName.Create('Erro Atualizando Tabela');
            raise FErroUserName;
            CNSDataBase.RollBack;
            FErroUserName.Free;
         end;
      end;
   end;

end;
//////TConectorCheck/////////////////////////////////////////////////////////
constructor TConectorCheck.Create(AOwner : TComponent);
begin
   inherited create(AOwner);
   FTratarNome := TCustomPreparar.Create(nil);
end;

destructor TConectorCheck.Destroy;
begin
   FTratarNome.Destroy;
   inherited;
end;

procedure TConectorCheck.Loaded;
begin
   inherited loaded;
end;

procedure TConectorCheck.DefineProperties(Filer: TFiler);
begin
   inherited;
   Filer.DefineProperty('StringChekd', ReadStringChekd, WriteStringChekd,True);
end;

procedure TConectorCheck.ReadStringChekd(Reader: TReader);
begin
   FStringCheck := Reader.ReadString;
end;

procedure TConectorCheck.WriteStringChekd(Writer: TWriter);
begin
   Writer.WriteString(FStringCheck);
end;


procedure TConectorCheck.SetMenuControl(Value : TCustomMenuControl);
begin
   FMenuControl := Value;
   if Value <> nil then
   begin
      if not (csLoading in ComponentState) then
      begin
         ExecViewerControl;
      end;
      Value.FreeNotification(self);
   end;
end;

procedure TConectorCheck.SetViewer(Value : TCheckListBox);
begin
   FViewer := Value;
   if assigned(value) then
   begin
      if not (csLoading in ComponentState) then
      begin
         ExecViewerControl;
      end;
      StrToCheck;
      Value.freenotification(self);
   end;
end;

procedure TConectorCheck.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FMenuControl <> nil) and (AComponent = MenuControl) then
       MenuControl := nil;
    if (FViewer <> nil) and (AComponent = Viewer) then
       Viewer := nil;
  end;
end;

procedure TConectorCheck.LinkEvent(Sender : TObject; lState : TLinkState);
begin
   case  lState of
      //Atualiza Viewer
      lLoad, lRefresh, lRefreshViewer :
      begin
         FStringCheck := RTTIControl.GetProperty(ControlPropertyGet);
         StrToCheck
      end;
      //Atualiza Control
      lUpDate, lRefreshControl :
      begin
         CheckToStr;
         RTTIControl.PutProperty(ControlPropertyPut, FStringCheck);
      end;
   end;
end;

procedure TConectorCheck.ExecViewerControl;
begin
//  inherited;
  if assigned(Viewer) and assigned(Control) and assigned(MenuControl) then
  begin
     with Viewer do
     begin
        FStringCheck := RTTIControl.GetProperty(ControlPropertyGet);
        MontarCheckPermissoes;
        StrToCheck;
     end;
  end;
end;

procedure TConectorCheck.MontarCheckPermissoes;
var
   i : integer;
begin
   with Viewer do
   begin
     items.Clear;
     if FMenuControl.ListaOpcoes.count > 0 then
        for i := 0 to FMenuControl.ListaOpcoes.count - 1 do
        begin
           FTratarNome.Nome := FMenuControl.ListaOpcoes[i];
           FTratarNome.TirarCaracteresInvalidos;
           items.add(FTratarNome.NomeTratado);
        end;
   end;
end;

procedure TConectorCheck.StrToCheck;
var
   i : integer;
begin
   IF FStringCheck = '' then
      for i := 1 to 255 do
          FStringCheck := FStringCheck + 'F';
   for i := 0 to FViewer.items.Count - 1  do
      if FStringCheck[i + 1] = 'T' then
         FViewer.Checked[i] := True
      else
         FViewer.Checked[i] := False;
   FViewer.Repaint;
end;

procedure TConectorCheck.CheckToStr;
var
   i : integer;
begin
   FStringCheck := '';
   for i := 1 to 255 do
       FStringCheck := FStringCheck + 'F';
   for i := 0 to FViewer.items.Count - 1 do
      if FViewer.Checked[i] = True then
         FStringCheck[i + 1] := 'T'
      else
         FStringCheck[i + 1] := 'F';
end;


end.

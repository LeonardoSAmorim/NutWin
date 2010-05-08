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




unit CNS;
     {
         CNS.pas
         Unit Referente ao componetes que foram criados no periodo do desenvolvimento
     do cartao SUS
     }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, extctrls, stdctrls, dbctrls, DB,
  checklst, menus, dbtables, CCSListaLinks, CompOCX;


type
  TElemento = string;
  //Indica para que direcao seque a compactacao
  TDirecao = (Direita, Esquerda);
  TPadrao = (CEF, TSE, PIS, MPAS, CUSTOM);

  TCusTomPilha = class(TComponent)
  private
    { Private declarations }
    FPosicao : integer;
  protected
    { Protected declarations }
    function IsFull : boolean; virtual; abstract;
    function IsEmpty : boolean; virtual; abstract;
    procedure Init; virtual; abstract;
    function Pop : TElemento; virtual; abstract;
    function View(PosicaoPilha : integer) : TElemento; virtual; abstract;
    procedure Push(Elemento : TElemento); virtual; abstract;
    function IndexOf(Elemento : TElemento): integer; virtual; abstract;
    property Posicao : integer read FPosicao write FPosicao;
  public
    { Public declarations }
  published
    { Published declarations }
  end;


  TCusTomPilhaStatica = class(TCustomPilha)
  private
    { Private declarations }
    FArrayElementos : array [1..100] of TElemento;
    FPosicao : integer;
  protected
    { Protected declarations }
    procedure Loaded; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy ; override;
    function IsFull : boolean; override;
    function IsEmpty : boolean; override;
    procedure Init; override;
    function Pop : TElemento; override;
    function View(PosicaoPilha : integer) : TElemento; override;
    procedure Push(Elemento : TElemento); override;
    function IndexOf(Elemento : TElemento) : integer; override;
    property Posicao : integer read FPosicao write FPosicao;

  published
    { Published declarations }
  end;

  TCCSPilhaStatica = class(TCustomPilhaStatica)
  private
    { Private declarations }
  protected
    { Protected declarations }

  public
    { Public declarations }
  published
    { Published declarations }
  end;


  TElementoVariante = Variant;
  PPratoDinamico = ^TPratoDinamico;
  TPratoDinamico = record
                 PriorPrato : PPratoDinamico;
                 Elemento   : TElementoVariante;
                 NextPrato  : PPratoDinamico;
  end;


  TCusTomPilhaDinamica = class(TCustomPilha)
  private
    { Private declarations }
    FirstPrato : pointer;
    LastPrato : pointer;
    FPrato : PPratoDinamico;
    FPosicao : integer;
  protected
    { Protected declarations }
    procedure Loaded; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsFull : boolean; override;
    function IsEmpty : boolean; override;
    procedure Init; override;
    function Pop : TElementoVariante;
    function View(PosicaoPilha : integer) : TElementoVariante;
    procedure Push(Elemento : TElementoVariante);
    property Posicao : integer read FPosicao write FPosicao;
  published
    { Published declarations }
end;

  TCCSPilhaDinamica = class(TCusTomPilhaDinamica)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
end;



  TCNSInteiro = class(TComponent)
  private
    { Private declarations }
    FValue : integer;
    function GetPar : boolean;
  protected
    { Protected declarations }
    procedure Loaded; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  public
    { Public declarations }
    function IsPar(Value : integer) : boolean;
    property Par : boolean read GetPar;
{    property IsImpar : boolean;
    property IsPositivo : boolean;
    property IsNegativo : boolean;
}
  published
     property Valor : integer read FValue write FValue;
    { Published declarations }
  end;


  TTiposPermitidos = set of char;
  TConsoantes = set of char;
  TVogais = set of char;
  TConsoantesInvalidas = set of char;
  TTipoX = set of char;



  TCustomPreparar = Class(TCompOCX)
  private
     FNome : string;
     FNomeTratado : string;
     FOnTratado : TNotifyEvent;
     procedure SetNome(Value : string);
  protected
    { Protected declarations }
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure TratarNome; virtual;
    procedure TirarSinasDiacriticos; virtual;
    procedure TirarEspacosDuplicados; virtual;
    procedure TirarCaracteresInvalidos; virtual;
    property Nome : string read FNome write SetNome;
    property NomeTratado : string read FNomeTratado write FNomeTratado;
    property OnTratado : TNotifyEvent read FOnTratado write FOnTratado;
  published
    { Published declarations }
  end;

  TCNSPreparar = Class(TCustomPreparar)
  private
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property OnTratado : TNotifyEvent read FOnTratado write FOnTratado;
  end;


  TCustomAbreviar = class(TCompOCX)
  private
    { Private declarations }
    FOnAntesAbreviar: TNotifyEvent;
    FOnDepoisAbreviar: TNotifyEvent;
    //variavel para receber o nome natural
    FNome : string;
    //Variavel para receber o nome abreviado
    FNomeAbreviado : string;
    //Variavel para indicar se abrevidado ou nao (s/n)
    FIndicador : char;
    //Indica o tamanho maximo do nome abreviado
    FTamanhoSaida : integer;
    //Indica quantidade de nomes no inicio e no fim do Nome se couper
    FNomesExternos : integer;
    FNomesExternosEsquerda : integer;
    FNomesExternosDireita : integer;
    //Indicador da direcao da saida;
    FDirecao : TDirecao;
    //Pilha para conter nomes separados
    FPilhaNomes : TCusTomPilhaStatica;
    FPilhaNomes2 : TCusTomPilhaStatica;
    Stack        : TCusTomPilhaStatica;
    //Image para poder conter o bitmap de apresentacao
    Image : TImage;
    //Tratar nome
    FTratarNome : TCustomPreparar;
    //Indicador se exite paraente
    FExisteParente : boolean;
    FTratarParente : boolean;
    //Variavel para indicar quantas palavras retirar do topo da pilha
    FTirarTopo : integer;
    //Variavel para indicar quantas palavras montar na base da pilha
    FManterBase : integer;
    FPadrao : TPadrao;

    //Metodos
    procedure AjustarPadrao;
    procedure SetPadrao(Value : TPadrao);
    procedure SetAbreviar(Value : String);
    function GetExisteParente : boolean;
    function GetLenNomeDigitado : integer;
    function GetLenNomeAbreviado : integer;
    procedure Change;

  protected
    { Protected declarations }
    procedure Loaded; override;
    procedure paint; override;
    property ExisteParente : boolean read GetExisteParente write FExisteParente;
    property Indicador : char read FIndicador;
    property NomeAbreviado : string read FNomeAbreviado;
    property Nome : string read FNome write SetAbreviar;
    property TamanhoSaida : integer read FTamanhoSaida write FTamanhoSaida;
    property NomesExternos : integer read FNomesExternos write FNomesExternos;
    property NomesExternosEsquerda : integer read FNomesExternosEsquerda write FNomesExternosEsquerda;
    property NomesExternosDireita : integer read FNomesExternosDireita write FNomesExternosDireita;
    property Padrao : TPadrao read FPadrao write SetPadrao default CEF;
    property TratarParente : boolean read FTratarParente write FTratarParente;
    property DirecaoAbreviacao : TDirecao read FDirecao write FDirecao;
    property LenNomeDigitado : integer read GetLenNomeDigitado;
    property LenNomeAbreviado : integer read GetlenNomeAbreviado;
    property OnAntesAbreviar: TNotifyEvent read FOnAntesAbreviar write FOnAntesAbreviar;
    property OnDepoisAbreviar: TNotifyEvent read FOnDepoisAbreviar write FOnDepoisAbreviar;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AbreviarNome; virtual;
    procedure AbreviarNomesIntermediarios; virtual;
    procedure AbreviarParentes; virtual;
    procedure SepararNomes(NomePilha : TCusTomPilhaStatica; Value : string; Separador : char; Direcao : TDirecao);
    function JuntarNomes(NomePilha : TCusTomPilhaStatica; Separador : char; Direcao : TDirecao) : string;
    function JuntarPilhasNomes(PilhaNomes1, PilhaNomes2 : TCusTomPilhaStatica; separador : char; Direcao : TDirecao) : string;
    function VerificarPreposicao(Value : string) : boolean; virtual;
    procedure TirarPreposicoes; virtual;
    procedure TirarPatentes; virtual;
    procedure TirarTodasPreposicoes; virtual;
  published
    { Published declarations }
  end;


  TCNSAbreviar = class(TCustomAbreviar)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property ExisteParente;
    property Indicador;
    property NomeAbreviado;
    property Nome;
    property TamanhoSaida;
    property NomesExternosEsquerda;
    property NomesExternosDireita;
    property Padrao;
    property TratarParente;
    property DirecaoAbreviacao;
    property LenNomeDigitado;
    property LenNomeAbreviado;
    property OnAntesAbreviar;
    property OnDepoisAbreviar;
  end;

  TOrigemFonemas = (ofCEF, ofCUSTOM);

  TCustomFonemas = class(TCompOCX)
  private
    //Indica o token a ser avalidado
    FToken: string;
    //Indica o token de saida
    FNewToken : string;
    //Indica o fonema a ser utilizado na nome
    FFonema : string;
    //Nome a ser fonetizado
    FNome : string;
    //Lista para conter os tokens
    FItems : TStrings;
    //Lista para token de substituicao
    FListaFonemas : TStrings;
    FListaTokens : TStrings;
    //Indica posicao da tabela;
    FPosicao : integer;
    //Indica o deslocamento dentro do nome
    FIdxNome : integer;
    FLenToken : integer;
    FLenNewToken : integer;
    FLenNome : integer;
    //Tamanho do segmento a ser retirado do Nome para inclusao do novo
    FLenSeg : integer;
    FOrigemFonemas : TOrigemFonemas;
    procedure SetOrigemFonemas(Value : TOrigemFonemas);
    procedure SetListaFonemas(Value : TStrings);
    function GetListaFonemas : TStrings;

    procedure SetListaTokens(Value : TStrings);
    function GetListaTokens : TStrings;

    function GetCount : integer;
    procedure SetToken(Value : String);
    procedure SetNewToken(Value : String);
    procedure SetNome(Value : String);
    function  AddSpacesToRight(Str : string; QtdSpc : integer) : string;
    procedure AjustarFonemas;
  protected
    procedure Loaded; override;
    property Nome : string read FNome write SetNome;
    property Token : string read FToken write SetToken;
    property NewToken : string read FNewToken write SetNewToken;
    property Fonema : string read FFonema write FFonema;
    property Posicao : integer read FPosicao write FPosicao;
    property IdxNome : integer read FIdxNome write FIdxNome;
    property Count : integer read GetCount;
    property LenToken : integer read FLenToken write FLenToken;
    property LenNewToken : integer read FLenNewToken write FLenNewToken;
    property LenNome : integer read FLenNome write FLenNome;
    property LenSeg : integer read FLenSeg write FLenSeg;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function TrocarToken : Boolean;
    function AddTokens(SegStr : string; IndSegStr, IndToken : integer) : string;
    procedure First;
    function Prior : boolean;
    function Next  : boolean;
    procedure Last;
    function view(Idx : integer) : boolean;
    property ListaFonemas : TStrings read GetListaFonemas write SetListaFonemas;
    property ListaTokens : TStrings read GetListaTokens write SetListaTokens;
    property OrigemFonemas : TOrigemFonemas read FOrigemFonemas write SetOrigemFonemas default ofCEF;
  published
  end;

  TCNSFonemas = class(TCustomFonemas)
  private
  protected
  public
    property Nome : string read FNome write SetNome;
    property Token : string read FToken write SetToken;
    property NewToken : string read FNewToken write SetNewToken;
    property Fonema : string read FFonema write FFonema;
    property Posicao : integer read FPosicao write FPosicao;
    property IdxNome : integer read FIdxNome write FIdxNome;
    property Count : integer read GetCount;
    property LenToken : integer read FLenToken write FLenToken;
    property LenNewToken : integer read FLenNewToken write FLenNewToken;
    property LenNome : integer read FLenNome write FLenNome;
    property LenSeg : integer read FLenSeg write FLenSeg;
  published
    property ListaFonemas;
    property ListaTokens;
    property OrigemFonemas;
  end;



  TCustomFonetizar = class(TCompOCX)
  private
    { Private declarations }
    FOnAntesFonetizar: TNotifyEvent;
    FOnDepoisFonetizar: TNotifyEvent;
    //Objeto para abreviar o nome a ser abreviado
    FAbreviar : TCustomAbreviar;
    //Indica o tamanho maximo do nome abreviado
    FTamanhoSaida : integer;
    //Objeto que contem a tabela de tokens para trocas
    FFonemas : TCustomFonemas;
    //Indica o nome fonetizado
    FNomeFonetizado : string;
    //Nome a ser fonetizado
    FNome : string;
    FPadrao : TPadrao;
    //Pilha com o nome fonetico segmentado
    FPilhaNomeFonetico : TCusTomPilhaStatica;
    procedure SetAbreviar(Value : TCustomAbreviar);
    procedure SetFonemas(Value : TCustomFonemas);
    procedure AjustarPadrao;
    procedure SetPadrao(Value : TPadrao);

  protected
    { Protected declarations }
     procedure Loaded; override;
     procedure Notification(AComponent: TComponent; Operation: TOperation); override;
     function ConcatenarFonema(xFonema : string) : string;

     property Abreviar : TCustomAbreviar read FAbreviar write SetAbreviar;
     property Fonemas : TCustomFonemas read FFonemas write SetFonemas;
     property Nome : string read FNome write FNome;
     property NomeFonetico : string read FNomeFonetizado;
     property Padrao : TPadrao read FPadrao write SetPadrao default CEF;
     property TamanhoSaida : integer read FTamanhoSaida write FTamanhoSaida;
     property OnAntesFonetizar: TNotifyEvent read FOnAntesFonetizar write FOnAntesFonetizar;
     property OnDepoisFonetizar: TNotifyEvent read FOnDepoisFonetizar write FOnDepoisFonetizar;

  public
    { Public declarations }
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
     procedure Fonetizar;
     function Fonetizacao(Value: string) : string;
  published
    { Published declarations }
  end;

  TCNSFonetizar = class(TCustomFonetizar)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
     property Abreviar;
     property Fonemas;
     property Nome;
     property Padrao;
     property NomeFonetico;
     property TamanhoSaida;
     property OnAntesFonetizar;
     property OnDepoisFonetizar;
  end;


  TPosicaoLabel = (pTop, pLeft);

  TCNSEditLabel = class(TCustomEdit)
  private
    { Private declarations }
    FCountLabel : integer;
    FLabel : TLabel;
    FAssociarLabel : Boolean;
    FAOwner: TComponent;
    FCaptionLabel : string;
    FPosicaoLabel : TPosicaoLabel;
    procedure AjustarLabel;
    procedure CriarLabel;
    procedure SetAssociarLabel(Value : boolean);
    procedure SetLabel(Value : TLabel);
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure SetCaptionLabel(Value : string);
    procedure SetPosicaolabel(Value : TPosicaoLabel);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property AssociarLabel : Boolean read FAssociarLabel write SetAssociarLabel default True;
    property LabelAssociado : TLabel read FLabel write SetLabel;
    property CaptionLabel : string read FCaptionLabel write SetCaptionLabel;
    property PosicaoLabel : TPosicaoLabel read FPosicaoLabel write SetPosicaoLabel;
    //Do edit
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

  TCNSDBEditLabel = class(TDBEdit)
  private
    { Private declarations }
    FCountLabel : integer;
    FLabel : TLabel;
    FAssociarLabel : Boolean;
    FAOwner: TComponent;
    FCaptionLabel : string;
    FPosicaoLabel : TPosicaoLabel;
    procedure AjustarLabel;
    procedure CriarLabel;
    procedure SetAssociarLabel(Value : boolean);
    procedure SetLabel(Value : TLabel);
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure SetCaptionLabel(Value : string);
    procedure SetPosicaolabel(Value : TPosicaoLabel);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property AssociarLabel : Boolean read FAssociarLabel write SetAssociarLabel default True;
    property LabelAssociado : TLabel read FLabel write SetLabel;
    property CaptionLabel : string read FCaptionLabel write SetCaptionLabel;
    property PosicaoLabel : TPosicaoLabel read FPosicaoLabel write SetPosicaoLabel;
  end;



  TCNSNomeFonetizado = class(TCNSEditLabel)
  private
    { Private declarations }
    //Objeto para fonetizar
    FFonetizar : TCustomFonetizar;
    procedure SetFonetizar(Value : TCustomFonetizar);
    procedure DoDepoisFonetizar(Value : TObject);

  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Fonetizar : TCustomFonetizar read FFonetizar write SetFonetizar;
  end;

  TCNSDBNomeFonetizado = class(TCNSDBEditLabel)
  private
    { Private declarations }
    //Objeto para fonetizar
    FFonetizar : TCustomFonetizar;
    procedure SetFonetizar(Value : TCustomFonetizar);
    procedure DoDepoisFonetizar(Value : TObject);

  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Fonetizar : TCustomFonetizar read FFonetizar write SetFonetizar;
  end;




  TCNSDBNomeAbreviado = class(TCNSDBEditLabel)
  private
    { Private declarations }
    //Objeto para fonetizar
    FAbreviar : TCustomAbreviar;
    FLabel : TLabel;
    procedure SetAbreviar(Value : TCustomAbreviar);
    procedure DoDepoisAbreviar(Value : TObject);

  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Abreviar : TCustomAbreviar read FAbreviar write SetAbreviar;
  end;


  TCNSNome = class(TCCSListaLinks)
  private
    { Private declarations }
    FAbreviar : TCustomAbreviar;
    Ffonetizar : TCustomFonetizar;
    FOnChange : TNotifyEvent;
    FValue: string;
    procedure SetAbreviar(Value : TCustomAbreviar); virtual;
    procedure SetFonetizar(Value : TCustomFonetizar);
    procedure SetValue(const xValue: string);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Abreviar : TCustomAbreviar read FAbreviar write SetAbreviar;
    property Fonetizar : TCustomFonetizar read FFonetizar write SetFonetizar;
    property OnChange : TNotifyEvent read FOnchange write FOnChange;
    property Value : string read FValue write SetValue;
  end;

  TCNSDBNome = class(TCNSDBEditLabel)
  private
    { Private declarations }
    FAbreviar : TCustomAbreviar;
    Ffonetizar : TCustomFonetizar;
    procedure SetAbreviar(Value : TCustomAbreviar);
    procedure SetFonetizar(Value : TCustomFonetizar);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Change; override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Abreviar : TCustomAbreviar read FAbreviar write SetAbreviar;
    property Fonetizar : TCustomFonetizar read FFonetizar write SetFonetizar;
  end;

  TCNSNomeAbreviado = class(TCNSEditlabel)
  private
    { Private declarations }
    //Objeto para fonetizar
    FAuxOnDepoisAbreviar: TNotifyEvent;
    FAbreviado : TCustomAbreviar;
    FTamanhoSaida : integer;
    procedure SetAbreviado(Value : TCustomAbreviar);
    procedure DoAntesAbreviar(Value : TObject);
    procedure DoDepoisAbreviar(Value : TObject);

  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Abreviado : TCustomAbreviar read FAbreviado write SetAbreviado;
    property TamanhoSaida : integer read FTamanhoSaida write FTamanhoSaida;
  end;

const
  //Tipos de caracteres de separa
  cBranco : char = #32;
  cPonto : char = '.';

procedure Register;
{$R cns}
implementation
const
  //Tipos permitidos no nome
  CaracteresPermitidos : TTiposPermitidos =
  [#39, ' ', '0'..'9',  'a'..'z', 'A'..'Z', 'à'..'ã', 'À'..'Ã', 'é', 'ê', 'É', 'Ê', 'í', 'Í', 'ó', 'ô', 'õ', 'Ó', 'Ô', 'Õ', 'ù'..'ü', 'Ù'..'Ü', 'ç', 'Ç'];
  Consoantes : TConsoantes =  ['B'..'D', 'G'..'H', 'J'..'N', 'P'..'T', 'V'..'Z'];
  Vogais : TVogais = ['A','E','I','O','U'];
  ConsoantesInvalidas : TConsoantesInvalidas = ['R', 'L', 'H', ' '];
  TiposExtranhos : TTipoX = ['P'];
  TiposDescartaveis : TTipoX = ['H'];
  TiposRepetidosPermitidos : TTipoX = ['S', 'R'];
  //Array com as abreviacoes de fim de nome
  ArrayParentes: array[1..32] of Pchar =
  ('JUNIOR',      'JÚNIOR',
   'BISNETA',     'BISNETO',
   'NETO',        'NETOS',     'NETA',          'NETAS',
   'FILHA',       'FILHAS',
   'FILHO',       'FILHOS',
   'SOBRINHO',    'SOBRINHOS', 'SOBRINHA',      'SOBRINHAS',
   'PRIMO',       'PRIMOS',    'PRIMA',         'PRIMAS',
   'PRIMEIRO',    'PRIMEIROS', 'PRIMEIRA',      'PRIMEIRAS',
   'SEGUNDO',     'SEGUNDOS',  'SEGUNDA',       'SEGUNDAS',
   'TERCEIRO',    'TERCEIROS', 'TERCEIRA',      'TERCEIRAS'
  );

  //Array de Siglas para parentes relacionados acima
  ArraySiglaParentes: array[1..32] of Pchar =
  ('JR',          'JR',
   'BIS',         'BIS',
   'NT',          'NT',        'NT',            'NT',
   'FA',          'FA',
   'FO',          'FO',
   'SB',          'SB',        'SB',            'SB',
   'PM',          'PM',        'PM',            'PM',
   'PRI',         'PRI',       'PRI',           'PRI',
   'SEG',         'SEG',       'SEG',           'SEG',
   'TER',         'TER',       'TER',           'TER'
  );

  //Array para auxiliar na retirada de patentes
  ArrayPatentes: array[1..15] of Pchar =
  ('BEL',
   'CEL',
   'ENG',
   'MAJ',
   'MIN',
   'PROF',
   'TEN',
   'CAP',
   'DR',
   'DRA',
   'GAL',
   'MED',
   'PE',
   'SARG',
   'VVA'
  );

  //Array para auxiliar na retirada de patentes
  ArrayNomesInter : array[1..16] of Pchar =
  ('DA',
   'DE',
   'DI',
   'DO',
   'DU',
   'DAS',
   'DOS',
   'DEL',
   'DER',
   'LA.',
   'LE',
   'LES',
   'LOS',
   'VAN',
   'VON',
   'EL'
  );

  MAXTOKENS = 64;
  MAXPlatos = 100;
  {
  Array de tokens para auxiliar na fonetizacao
  ! indica qualquer vogal
  ? indica qualquer consoante
  . indica as consoantes R, L, H -
  % indica caracter reptido fora o invalidos
  & serve para ignorar o caracter na posicao
  * indica que devera ser utilizado o caracter do new token para almentar
  @ Serve para pegar o caracter que for
  + indica caracter reptido fora o invalidos para qualquer repticao
  }
  ArrayTokens : array [1..MAXTOKENS] of Pchar =
  ('PH',        // 10
   'INNG ',     // 20
   'INNG?',     // 30
   'ING ',      // 40
   'ING?',      // 50
   'NN ',       // 60
   'NM ',       // 70
   'W',         // 80
   'Y',         // 90
   'GI',        // 100
   'GE',        // 110
   'QUA',       // 120
   'QUO',       // 130
   'CA',        // 140
   'CO',        // 150
   'CU',        // 160
   ' H',        // 170
   '?D ',       // 180
   '?F ',       // 190
   '?P ',       // 200
   '?B ',       // 210
   '?T ',       // 220
   '!D *',      // 230
   '!F *',      // 240
   '!P *',      // 250
   '!B *',      // 260
   '!T *',      // 270
   '!&?',       // 280
   '?%%',       // 290
   '?%',        // 300
   '?% ',       // 310
   '!%%',       // 290
   '!%',        // 300
   '!% ',       // 310
   'QUA',       // 320
   'QUE',       // 330
   'QUI',       // 340
   'N?',        // 350
   'N ',        // 360
   'SCH',       // 370
   'SH',        // 380
   'C&!',       // 390
   'C&?',       // 400
   'CH ',       // 410
   'LHA',       // 420
   'LHO',       // 430
   'LHU',       // 440
   'VID ',      // 450
   'D.@',        // 460
   'F.@',        // 480
   'P.@',        // 490
   'B.@',        // 500
   'T.@',        // 510
   '!&?',       // 520
   'H',         // 530
   '!S!',       // 540
   ' S*?',      // 550
   'GUE',       // 560
   'GUI',       // 570
   'CE',        // 580
   'CI',        // 590
   'UEL',       // 600
   '!&?',       // 610
   '?+'         // 620
  );
  //Array para trocar tokens
  ArrayNewTokens : array [1..MAXTOKENS] of Pchar =
  ('F',
   'IM ',
   'IM?',
   'IM ',
   'IM?',
   'MM ',
   'MM ',
   'V',
   'I',
   'JI',
   'JE',
   'KUA',
   'KUO',
   'KA',
   'KO',
   'KU',
   ' ',
   '? ',
   '? ',
   '? ',
   '? ',
   '? ',
   '!DI ',
   '!FI ',
   '!PI ',
   '!BI ',
   '!TI ',
   '!&? ', // caso 32
   '%%',
   '%',
   '% ',
   '%%',
   '%',
   '% ',
   'KA',
   'KE',
   'KI',
   'M?',
   'M ',
   'X',
   'X',
   'X&!',
   'K&?',
   'K ',
   'LIA',
   'LIO',
   'LIU',
   'VI ',
   'DI@',
   'FI@',
   'PI@',
   'BI@',
   'TI@',
   '!&?',
   '',
   '!Z!',
   ' ES?',
   'GE',
   'GI',
   'SE',
   'SI',
   'OEL',
   '!&?',
   '?'
  );


procedure Register;
begin
  RegisterComponents('CNS-SIS', [TCNSAbreviar]);
  RegisterComponents('CNS-SIS', [TCNSPreparar]);
  RegisterComponents('CNS-SIS', [TCNSFonetizar]);
  RegisterComponents('CNS-SIS', [TCNSFonemas]);
  RegisterComponents('CNS-SIS', [TCNSEditLabel]);
  RegisterComponents('CNS-SIS', [TCNSNome]);
  RegisterComponents('CNS-SIS', [TCNSNomeAbreviado]);
  RegisterComponents('CNS-SIS', [TCNSNomeFonetizado]);
  RegisterComponents('CNS-SIS', [TCNSDBEditLabel]);
  RegisterComponents('CNS-SIS', [TCNSDBNome]);
  RegisterComponents('CNS-SIS', [TCNSDBNomeAbreviado]);
  RegisterComponents('CNS-SIS', [TCNSDBNomeFonetizado]);
  RegisterComponents('CNS-SIS', [TCCSPilhaStatica]);
  RegisterComponents('CNS-SIS', [TCCSPilhaDinamica]);
  RegisterComponents('CNS-SIS', [TCNSInteiro]);
end;

//////////////////////////////////TTratar Nome///////////////////////
constructor TCustomPreparar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TCustomPreparar.Loaded;
begin
  inherited Loaded;
end;

destructor TCustomPreparar.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomPreparar.SetNome(Value : string);
begin
   FNome := Value;
   FNomeTratado := Value;
end;
procedure TCustomPreparar.TratarNome;
begin
   FNomeTratado := UpperCase(Trim(FNome));
   TirarCaracteresInvalidos;
   TirarEspacosDuplicados;
   if assigned(FOnTratado) then FOnTratado(Self);
end;

procedure TCustomPreparar.TirarSinasDiacriticos;
begin
end;
procedure TCustomPreparar.TirarEspacosDuplicados;
{
         Eliminar Bracos a mais no meio do Nome
}
var
   NomeAux : string;
   j    : integer;
begin
   j := 1;
   NomeAux := '';
   while (j <= Length(FNomeTratado)) do
   begin
      while (FNomeTratado[j] = #32) and  (FNomeTratado[j + 1] = #32) and (j < Length(FNomeTratado))  do Inc(j);
      NomeAux := NomeAux + FNomeTratado[j];
      inc(j)
   end;
   FNomeTratado := NomeAux;
end;

procedure TCustomPreparar.TirarCaracteresInvalidos;
{
          Este metodo ira retirar os caracteres nao numereicos e nao alfanumericos
permitido somente os caracteres da lista de caracteres permitidos
}
var
   NomeAux : string;
   j    : integer;
begin
   NomeAux := '';
   for j := 1 to Length(FNomeTratado) do
      if (FNomeTratado[j] in  CaracteresPermitidos) then
          NomeAux := NomeAux + FNomeTratado[j];
   FNomeTratado := NomeAux;
end;

////////////////////////////Abreviar//////////////////////////////////////

constructor TCustomAbreviar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Image := TImage.Create(self);
  FTratarNome := TCustomPreparar.Create(nil);
  FPadrao := CEF;
  AjustarPadrao;
//  FTratarNome.name := 'TratarNome';
//  InitImage;
//  Width := 28;
//  Height := 28;
//  Inicia Pilha Nomes
  FPilhaNomes := TCusTomPilhaStatica.Create(nil);
  FPilhaNomes2 := TCusTomPilhaStatica.Create(nil);
  Stack := TCusTomPilhaStatica.Create(nil);
  Stack.Init;
end;

procedure TCustomAbreviar.Paint;
begin
   inherited paint;
end;

procedure TCustomAbreviar.Loaded;
begin
  inherited Loaded;
  AjustarPadrao;
end;

destructor TCustomAbreviar.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomAbreviar.SetAbreviar(Value : String);
begin
   FNome := Value;
end;

procedure TCustomAbreviar.SetPadrao(Value : TPadrao);
begin
   FPadrao := Value;
   AjustarPadrao;
end;

procedure TCustomAbreviar.AjustarPadrao;
begin
   if not(csLoading in ComponentState) then
   begin
      case Padrao of
         CEF, TSE  :
         begin
            TamanhoSaida := 70;
            NomesExternosDireita := 2;
            NomesExternosEsquerda := 2;
            TratarParente := True;
            DirecaoAbreviacao := Direita;
         end;
         MPAS  :
         begin
            TamanhoSaida := 60;
            NomesExternosDireita := 1;
            NomesExternosEsquerda := 1;
            TratarParente := True;
            DirecaoAbreviacao := Direita;
         end;
{         CUSTOM :
         begin
            TamanhoSaida := 40;
            NomesExternosDireita := 1;
            NomesExternosEsquerda := 1;
            TratarParente := False;
            DirecaoAbreviacao := Esquerda;
         end;
}      end;
   end;
end;


procedure TCustomAbreviar.Change;
begin
//   NotifyLinks(Self, lChange);
end;

procedure TCustomAbreviar.AbreviarNome;
{
          Este metodo ira disparar os metodos para Abreviar Nome
}
begin
   if Assigned(FOnAntesAbreviar) then FOnAntesAbreviar(Self);
   if Length(FNome) <> 0 then
   begin
      FIndicador := 'N';
      // 0
      FNomeAbreviado := uppercase(FNome);
      // 4
      TirarPatentes;
      // 1, 2, 3, 5
      FTratarNome.Nome := FNomeAbreviado;
      FTratarNome.TratarNome;
      FNomeAbreviado :=  FTratarNome.NomeTratado;
      // 6
      //Indica se exite parente a ser abreviado
      ExisteParente := False;

      AbreviarParentes;

      SepararNomes(FPilhaNomes, FNomeAbreviado, cBranco, Esquerda);

      if FPilhaNomes.Posicao > 2 then
      begin
         TirarPreposicoes;
         // 7
         AbreviarNomesIntermediarios;
      end;
   end;
   if Assigned(FOnDepoisAbreviar) then FOnDepoisAbreviar(Self);
//   NotifyLinks(self, lLoad);
end;

procedure TCustomAbreviar.TirarPatentes;
{
    Rotina para tirar patentes do inicio do nome se abreviada
}
var
   i         : integer;
   Patente   : string;
begin
  SepararNomes(FPilhaNomes, FNomeAbreviado, cBranco, Direita);
  Patente := FPilhaNomes.View(FPilhaNomes.Posicao);
  for i := 1 to 15 do
  begin
     if (Patente = string(ArrayPatentes[i])) or (Patente = (string(ArrayPatentes[i]+ '.'))) then
     begin
        //Substitui Parente pela Sigla do Parente
        Patente := FPilhaNomes.Pop;
        FNomeAbreviado := JuntarNomes(FPilhaNomes, cBranco, Direita);
        FIndicador := 'S';
        break;
     end;
  end;
end;

function TCustomAbreviar.GetLenNomeDigitado : integer;
begin
   Result := length(FNome);
end;

function TCustomAbreviar.GetLenNomeAbreviado : integer;
begin
   Result := length(FNomeAbreviado);
end;


function TCustomAbreviar.GetExisteParente : boolean;
{
         Mesmo que existe parente se propriedade indicar que nao e para tratar
   parente ira prevalecer o valo da propriedade que indica se trata ou nao o
   parente.
}
begin
   if FTratarParente and FExisteParente then
      Result := true
   else
      Result := false;
end;

procedure TCustomAbreviar.AbreviarParentes;
{
          Rotina para abreviar nomes de parentes, nao sera usada por definicao da
reuniao de 11/05/98 CEF RJ
}
var
   i : integer;
   Parente   : string;
begin
   SepararNomes(FPilhaNomes, FNomeAbreviado, cBranco, Esquerda);
   if FPilhaNomes.Posicao > 0 then
   begin
      Parente := FPilhaNomes.view(FPilhaNomes.Posicao);
      //Procura por Parente no Nome
      for i := 1 to 32 do
      begin
         if Parente = string(ArrayParentes[i]) then
         begin
            //Substitui Parente pela Sigla do Parente
            ExisteParente := True;
            Parente := FPilhaNomes.Pop;
            FPilhaNomes.Push(string(ArraySiglaParentes[i]));
            FNomeAbreviado := JuntarNomes(FPilhaNomes, cBranco, esquerda);
            FIndicador := 'S';
            break;
         end;
      end;
   end;
end;

procedure TCustomAbreviar.TirarTodasPreposicoes;
{
         Metodo publico para retinar nomes intermediarios tipo do da dos
}
begin
   Stack.Push(IntToStr(FTamanhoSaida));
   Stack.Push(FNome);
   FTamanhoSaida := 0;
   TirarPreposicoes;
   FNome := Stack.Pop;
   FTamanhoSaida := StrToInt(Stack.Pop);
end;

procedure TCustomAbreviar.TirarPreposicoes;
var
   NomeInter  : string;
begin
  // Monta Nova Pilha
  SepararNomes(FPilhaNomes, FNomeAbreviado, cBranco, Esquerda);
  if FPilhaNomes.Posicao < 3 then exit;
  //Tirar Nomes Intermediarios tal como da, de di e etc ver table NomesIntermedirario
  FPilhaNomes2.Init;
  FPilhaNomes2.Push(FPilhaNomes.Pop);
  while (FPilhaNomes.Posicao > 1) and (Length(FNomeAbreviado) > FTamanhoSaida) do
  begin
     NomeInter := FPilhaNomes.Pop;
     if not (VerificarPreposicao(NomeInter)) then
        FPilhaNomes2.Push(NomeInter);
     FNomeAbreviado := JuntarPilhasNomes(FPilhaNomes, FPilhaNomes2, cBranco, Esquerda);
  end;
end;

procedure TCustomAbreviar.AbreviarNomesIntermediarios;
{
          Metodo para abreviar os nomes intermediarios da Esquerda para Direita
}
var
   i : integer;
   FDirecaoAux : TDirecao;
begin
  {
    Condicao para determinar a direcao da abreviacao e se existe parente pois
  deacordo com a especificacao da caixa se existir Parente o antepenultima nome
  nao deve ser alterado
  }
  FDirecaoAux := FDirecao;
  if (FDirecao = esquerda) then
  begin
     FDirecaoAux := Direita;
     FTirarTopo := FNomesExternosEsquerda;
     if (NomesExternosDireita < 3) and ExisteParente  then
        FManterBase := 3
     else
        FManterBase := FNomesExternosDireita;
  end else
  if (FDirecao = Direita) then
  begin
     FDirecaoAux := Esquerda;
     FManterBase := FNomesExternosEsquerda;
     if (NomesExternosDireita < 3)  and ExisteParente then
        FTirarTopo := 3
     else
        FTirarTopo := FNomesExternosDireita;
  end;
  while (Length(FNomeAbreviado) > FTamanhoSaida)  and (FTirarTopo > 0) do
  begin
     // Monta Nova Pilha
     SepararNomes(FPilhaNomes, FNomeAbreviado, cBranco, FDirecaoAux);

     //verifica a validade dos parametros
     if FPilhaNomes.Posicao < FTirarTopo then
     begin
       ShowMessage('Nomes externos nao pode ser maior que Numero de subNomes.');
       exit;
     end;
     FPilhaNomes2.Init;
     //Tira os primeiros nomes da lista
     for i := 1 to FTirarTopo do
       FPilhaNomes2.Push(FPilhaNomes.Pop);
     //Abreviar nomes
     while (FPilhaNomes.Posicao > FManterBase) and (Length(FNomeAbreviado) > FTamanhoSaida) do
     begin
 ///    estou com erro aqui quando coloco porcaria
        FPilhaNomes2.Push(FPilhaNomes.Pop[1]);
        FNomeAbreviado := JuntarPilhasNomes(FPilhaNomes, FPilhaNomes2, cBranco, FDirecaoAux);
     end;
     {
          Caso o nome nao tenha ficado no tamanho desejado com os nomes esternos
      comeca a diminuir o numero de nomes esternos tentanto sempre manter o parente
     }
     if FDirecao = Esquerda then
     begin
        Dec(FTirarTopo);
        if (FTirarTopo = 0) and (FManterBase - 1 > 0) then
        begin
           Dec(FManterBase);
           FTirarTopo := 1;
        end
     end else
     if FDirecao = Direita then
     begin
        Dec(FManterBase);
        if (FManterBase = 0) and (FTirarTopo - 1 >= 0) then
        begin
           Dec(FTirarTopo);
           FManterBase := 1;
        end
     end;
  end;
end;

function TCustomAbreviar.VerificarPreposicao(Value : string) : boolean;
{
         Metodo para procurar no arry de nomes inter valor passado
}
var
   i : integer;
begin
   Result := False;
   for i := 1 to 15 do
   begin
      if Value = string(ArrayNomesInter[i]) then
      begin
         Result := True;
         break;
      end;
   end;
end;

procedure TCustomAbreviar.SepararNomes(NomePilha : TCusTomPilhaStatica; Value : string; Separador : char; Direcao : TDirecao);
{
          Metodo para Separar Nomes e coloca-lo em um pilha
          parametros Descricao
          ---------- ------------------------------------------------------
          NomePilha  Pilha que ira contar o Nome flagmentado
          Value      Nome a ser falgamento
          Separador  Caracter de separacao
          Direcao    Sentido da flamenetacao 1 - esq p/ dir  2 - dir p/ esq
}
var
  k , j, i: integer;
begin
  k :=  Length(Value);
  j := 1;
  i := j;
  NomePilha.Init;
  // Separa  palavras
  if Direcao = Esquerda then //indica que a direcao e da esquerda para direita
  begin
      while (k >= j) do
      begin
         while (k > j) and (Value[j] <> Separador) do
         inc(j);
         if k = j then
            inc(j);
         NomePilha.Push(copy(Value,i ,j - i));
        i := J + 1;
        inc(j);
      end;
  end else
  if Direcao = Direita then // indica que a direcao a da direita para esquerda
  begin
      i := k;
      J := K;
      while (j >= 1) do
      begin
         while (j > 1) and (Value[j] <> separador) do
         dec(j);
         if j = 1 then
            dec(j);
         NomePilha.Push(copy(Value,j + 1 ,i - j));
        i := J - 1;
        dec(j);
      end;
  end else
      ShowMessage('Direcao Invalida.');

end;

function TCustomAbreviar.JuntarNomes(NomePilha : TCusTomPilhaStatica; Separador : char; Direcao : TDirecao) : string;
{
         metodo para montar um nome atravez de uma pilha de palavras
          parametros Descricao
          ---------- ------------------------------------------------------
          NomePilha  Pilha que  contem o Nome flagmentado
          Result     Nome Montado
          Separador  Caracter de separacao
          Direcao    Sentido da flamenetacao 1 - esq p/ dir  2 - dir p/ esq

}
var
   NomeAux : string;
   i       : integer;
begin
    NomeAux := ' ';
    if Direcao = Esquerda then
       for i := 1 to NomePilha.Posicao do
          NomeAux := NomeAux + NomePilha.View(i) + Separador
    else
      if Direcao = Direita then
         for i := NomePilha.Posicao downto 1 do
           NomeAux := NomeAux + NomePilha.View(i) + Separador
      else
         ShowMessage('Direcao Invalida');
   Result :=  Trim(NomeAux);
   //olhar depois e cortar so o ultimo separardor
   Result := copy(result, 1, length(result) -1);
end;

function TCustomAbreviar.JuntarPilhasNomes(PilhaNomes1, PilhaNomes2 : TCusTomPilhaStatica; separador : char; Direcao : TDirecao) : string;
{
         metodo para montar um nome atravez de duas pilhas de palavras
         parametros Descricao
         ---------- ------------------------------------------------------
         NomePilha  Pilha que  contem o  inicio do Nome flagmentado
         NomePilha2 Pilha que  contem o  fim do Nome flagmentado
         Separador  Caracter de separacao
         Result     Nome Montado

}
var
   NomeAux : string;
   i       : integer;
   PilhaAux : TCusTomPilhaStatica;
begin
   if Direcao = Direita then
   begin
      PilhaAux := TCusTomPilhaStatica.Create(nil);
      PilhaAux := PilhaNomes1;
      PilhaNomes1 := PilhaNomes2;
      PilhaNomes2 := PilhaAux;
   end;
   NomeAux := ' ';
   for i := 1 to PilhaNomes1.Posicao  do
     NomeAux := NomeAux +  separador + PilhaNomes1.View(i);
   for i := PilhaNomes2.Posicao downto 1 do
     NomeAux := NomeAux +  separador + PilhaNomes2.View(i);
   Result :=  Trim(NomeAux);
end;




//TPilha Estatica /////////////////////////////////////


constructor TCusTomPilhaStatica.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
//  init;
end;

destructor TCusTomPilhaStatica.Destroy;
begin
  inherited Destroy;
end;

procedure TCusTomPilhaStatica.Loaded;
begin
  inherited Loaded;
  Init;
end;

procedure TCusTomPilhaStatica.Init;
begin
   FPosicao := 0;
end;


function TCusTomPilhaStatica.Pop : TElemento;
begin
   if not IsEmpty then
   begin
      Result := FArrayElementos[FPosicao];
      dec(FPosicao);
   end
   else
      ShowMessage('Pilha Vazia');
end;

function TCusTomPilhaStatica.View(PosicaoPilha : integer) : TElemento;
begin
   if (PosicaoPilha > 0) and (PosicaoPilha <= FPosicao) then
   begin
      Result := FArrayElementos[PosicaoPilha];
   end
   else
      ShowMessage('Fora da Faixa da Pilha');
end;


procedure TCusTomPilhaStatica.Push(Elemento : TElemento);
begin
   if not IsFull then
   begin
      inc(FPosicao);
      FArrayElementos[FPosicao] := Elemento;
   end
   else
      ShowMessage('Pilha Cheia');

end;

function TCusTomPilhaStatica.IsEmpty : boolean;
begin
   Result := (FPosicao = 0);
end;

function TCusTomPilhaStatica.IsFull : boolean;
begin
   Result := (FPosicao = MAXPLATOS);
end;

function TCusTomPilhaStatica.IndexOf(Elemento : TElemento) : integer;
var
   i : integer;
begin
   Result := -1;
   for i := 1 to FPosicao do
   begin
      if FArrayElementos[i] = Elemento then
      begin
         Result := i;
         break;
      end
   end;
end;


///////////////////////////////////////////TCusTomPilhaDinamica//////////////////////////////////////////////////////////////


constructor TCusTomPilhaDinamica.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FPosicao := 0;
 init;
end;

destructor TCusTomPilhaDinamica.Destroy;
begin
  inherited Destroy;
end;

procedure TCusTomPilhaDinamica.Loaded;
begin
  inherited Loaded;
  FPosicao := 0;
  Init;
end;

procedure TCusTomPilhaDinamica.Init;
{
          Inicia uma nova pilha se a pilha ja possuir informacoes entao estas informacoes
serao destruidas e a pilha reiniciada.
}
var
   PratoAux : PPratoDinamico;
begin
   if FirstPrato <> nil then
   begin
      FPrato := FirstPrato;
      while FPrato <> nil do
      begin
           PratoAux := FPrato;
           FPrato := FPrato^.NextPrato;
           dispose(PratoAux);
      end;
   end;
   FPosicao := 0;
   FirstPrato := nil;
   FPrato := nil;
end;


function TCusTomPilhaDinamica.Pop : TElementoVariante;
{
         Retira o ultimo elemento  a entrar na pilha e destroe esta posicao de memoria
}
var
   PosAux : PPratoDinamico;
begin
   if not IsEmpty then
   begin
      PosAux := FPrato;
      Result := FPrato^.Elemento;
      FPrato := FPrato^.PriorPrato;
      if FPrato <> nil then
      begin
         FPrato^.NextPrato := nil;
      end;
      dispose(PosAux);
      LastPrato := FPrato;
      dec(FPosicao);
   end else
      ShowMessage('Pilha Vazia');
end;

function TCusTomPilhaDinamica.View(PosicaoPilha : integer) : TElementoVariante;
{
         Metodo para ler um elemento dentro do deslocamento da pilha sem que
a posicao do ponteriro.
}
var
   PosAux : PPratoDinamico;
   i : integer;
begin
   try
      if (PosicaoPilha > 0) and (PosicaoPilha <= FPosicao) then
      begin
         PosAux := FirstPrato;
         for i := 1 to PosicaoPilha - 1  do
             PosAux := PosAux^.NextPrato;
         Result := PosAux^.Elemento;
      end;
   except
      ShowMessage('Fora da Faixa da Pilha');
   end;
end;


procedure TCusTomPilhaDinamica.Push(Elemento : TElementoVariante);
var
   NewPrato : PPratoDinamico;
begin
   try
      //Cria ponteiro para prato
      new(NewPrato);
      //aponta nova prato para prato anteriror
      NewPrato^.PriorPrato := FPrato;
      //Verifica se pilha vazia se nao se ponteiros
      if isEmpty then
         FirstPrato := NewPrato
      else
        //aponta prato anteiro para novo prato
        FPrato^.NextPrato := NewPrato;
      //faz novo prato ser o prato corrente
      FPrato := NewPrato;
      //indica topo da pilha
      FPrato^.NextPrato := nil;
      //coloca elemento no top da pilha
      FPrato.Elemento := Elemento;
      //atualiza ponteiro para o topo da lista
      LastPrato := FPrato;
      //atualiza quantidade de elementos
      inc(FPosicao);
   except
      //se occorer algum erro indica na execao
      ShowMessage('Pilha Cheia');
   end;
end;

function TCusTomPilhaDinamica.IsEmpty : boolean;
begin
   Result := (LastPrato = nil);
end;

function TCusTomPilhaDinamica.IsFull : boolean;
begin
   Result := (FPosicao = 30);
end;

//TCNSInteiro    /////////////////////////////////////////
constructor TCNSInteiro.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCNSInteiro.Destroy;
begin
  inherited Destroy;
end;

procedure TCNSInteiro.Loaded;
begin
  inherited Loaded;
end;

function TCNSInteiro.IsPar(Value : integer) : boolean;
begin
   Result := (value - (value div 2) = 0);
end;

function TCNSInteiro.GetPar : boolean;
begin
   Result := IsPar(Valor);
end;

//TCustomFonetizar    /////////////////////////////////////////

constructor TCustomFonetizar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPilhaNomeFonetico := TCusTomPilhaStatica.Create(nil);
  FPadrao := CEF;
  AjustarPadrao;
end;

procedure TCustomFonetizar.Loaded;
begin
  inherited Loaded;
end;


destructor TCustomFonetizar.Destroy;
begin
  FPilhaNomeFonetico.Free;
  if assigned(Fonemas) then
     if FFonemas.Owner = nil then
        FFonemas.Destroy;
  if assigned(abreviar) then
     if FAbreviar.Owner = nil then
        FAbreviar.Destroy;
  inherited Destroy;
end;

procedure TCustomFonetizar.SetAbreviar(Value : TCustomAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCustomFonetizar.SetPadrao(Value : TPadrao);
begin
   FPadrao := Value;
   AjustarPadrao;
end;

procedure TCustomFonetizar.AjustarPadrao;
begin
   case Padrao of
      CEF, TSE  :
      begin
         TamanhoSaida := 28;
      end;
   end;
end;


procedure TCustomFonetizar.Fonetizar;
var
  TamanhoSaidaAux1, TamanhoSaidaAux2 : integer;
  strFonema : string;
  xPadrao : TPadrao;
begin
   if Assigned(FOnAntesFonetizar) then FOnAntesFonetizar(Self);
   if not assigned(FAbreviar) then
      FAbreviar := TCustomAbreviar.Create(nil);
   if FAbreviar <> nil  then
   begin
      if FNome <> '' then
      begin
         with FAbreviar do
         begin
           //oolhar com cuidado
            TamanhoSaidaAux1 := FAbreviar.TamanhoSaida;
            xPadrao := FAbreviar.Padrao;
            FAbreviar.Padrao := Custom;
            strFonema := self.FNome;
            repeat
               FAbreviar.Nome := self.FNome;
               AbreviarNome;
               TirarTodasPreposicoes;
               if FAbreviar.TamanhoSaida  < length(FAbreviar.NomeAbreviado) then
                  break;
               FAbreviar.TamanhoSaida := FAbreviar.TamanhoSaida - 1;
               strFonema := #32 + FAbreviar.NomeAbreviado;
               strFonema := Fonetizacao(strFonema);
            until length(strFonema) <= self.TamanhoSaida;
            FAbreviar.TamanhoSaida := TamanhoSaidaAux1;
            FAbreviar.Padrao := xPadrao;
            FNomeFonetizado := strFonema;
            if Assigned(FOnDepoisFonetizar) then FOnDepoisFonetizar(Self);
         end;
      end;
   end;
end;

function TCustomFonetizar.Fonetizacao(Value: string) : string;
begin
   if not Assigned(Fonemas) then
      FFonemas := TCustomFonemas.Create(nil);
   Fonemas.Nome := string(Value);
   Fonemas.First;
   repeat
      Fonemas.IdxNome := 1;
      while (Fonemas.IdxNome <= Length(Fonemas.Nome)) do
      begin
         if (Fonemas.Nome[Fonemas.IdxNome] = Fonemas.Token[1]) or (Fonemas.Token[1] = '!') or (Fonemas.Token[1] = '?') or (Fonemas.Token[1] = '@') then
            if Fonemas.TrocarToken then
               FFonemas.Nome := copy(FFonemas.Nome, 1, Fonemas.IdxNome - 1) + Fonemas.Fonema + copy(FFonemas.Nome, (Fonemas.IdxNome + Fonemas.LenSeg), ((Fonemas.LenNome) - (Fonemas.IdxNome + (Fonemas.LenSeg) -1)));

         inc(Fonemas.FIdxNome);
      end;
   until not (Fonemas.Next);
   Result := Trim(Fonemas.Nome);
   Result := ConcatenarFonema(Result);
end;

function TCustomFonetizar.ConcatenarFonema(xFonema : string) : string;
var
   ChaveFonetica1, ChaveFonetica2, ChaveFonetica3 : string;
   i : integer;
begin
   Result := '';
   ChaveFonetica1 := '';
   ChaveFonetica2 := '';
   ChaveFonetica3 := '';
   FPilhaNomeFonetico.Init;
   if not assigned(FAbreviar) then
      FAbreviar := TCustomAbreviar.Create(nil);
   if assigned(FAbreviar) then
   begin
      FAbreviar.SepararNomes(FPilhaNomeFonetico, xFonema, #32, direita);
      if FPilhaNomeFonetico.Posicao >= 1 then
         ChaveFonetica1 := FPilhaNomeFonetico.Pop;
      while FPilhaNomeFonetico.Posicao > 1 do
      begin
          ChaveFonetica2 := ChaveFonetica2 + FPilhaNomeFonetico.Pop;
      end;
      if FPilhaNomeFonetico.Posicao = 1 then
         ChaveFonetica3 := FPilhaNomeFonetico.Pop;
         Result := ChaveFonetica1 + ChaveFonetica3 +  ChaveFonetica2;  
   end;
end;


procedure TCustomFonetizar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FAbreviar <> nil) and (AComponent = Abreviar) then
       Abreviar := nil;
    if (FFonemas <> nil) and (AComponent = Fonemas) then
       Fonemas := nil;
  end;
end;


procedure TCustomFonetizar.SetFonemas(Value : TCustomFonemas);
begin
  FFonemas := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;


///////TTabela de Tokens////////////////////////////////////////

constructor TCustomFonemas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListaFonemas := TStringList.Create;
  FListaTokens := TStringList.Create;
  FOrigemFonemas := ofCEF;
  AjustarFonemas;
end;

procedure TCustomFonemas.Loaded;
begin
  inherited Loaded;
end;


destructor TCustomFonemas.Destroy;
begin
  FListaFonemas.Free;
  FListaTokens.Free;
  inherited Destroy;
end;

procedure TCustomFonemas.SetOrigemFonemas(Value : TOrigemFonemas);
begin
   FOrigemFonemas := Value;
   AjustarFonemas;
end;

procedure TCustomFonemas.AjustarFonemas;
var
   i : integer;
begin
   if FOrigemFonemas = ofCEF then
   begin
      FListaFonemas.clear;
      FListaTokens.clear;
      for i := 1 to MAXTOKENS do
      begin
         FListaFonemas.add(string(ArrayTokens[i]));
         FListaTokens.add(string(ArrayNewTokens[i]));
      end;
   end;
   if (FOrigemFonemas = ofCUSTOM) and ((FListaFonemas.Count - 1) = 0) then
   begin
      FListaFonemas.clear;
      FListaTokens.clear;
   end;
end;
function TCustomFonemas.GetListaFonemas : TStrings;
begin
     Result := FListaFonemas;
end;

function TCustomFonemas.GetListaTokens : TStrings;
begin
     Result := FListaTokens;
end;

procedure TCustomFonemas.SetListaFonemas(Value : TStrings);
begin
     FListaFonemas.Assign(Value);
end;

procedure TCustomFonemas.SetListaTokens(Value : TStrings);
begin
     FListaTokens.Assign(Value);
end;

procedure TCustomFonemas.First;
begin
   FPosicao := 0;
   Token := FListaFonemas[0];
   NewToken := FListaTokens[0];
end;

function TCustomFonemas.Prior : boolean;
begin
   Result := True;
   if FPosicao > 0 then
      dec(FPosicao)
   else
      Result := False;
   Token := FListaFonemas[FPosicao];
   NewToken := FListaTokens[FPosicao];
end;

function TCustomFonemas.Next : boolean;
begin
   Result := True;
   if FPosicao < FListaFonemas.count -1 then
      inc(Fposicao)
   else
      Result := false;
   Token := FListaFonemas[FPosicao];
   NewToken := FListaTokens[FPosicao];
end;

procedure TCustomFonemas.Last;
begin
   FPosicao := FListaFonemas.count -1;
   Token := FListaFonemas[FPosicao];
   NewToken := FListaTokens[FPosicao];
end;

function TCustomFonemas.view(idx : integer): boolean;
begin
   if not ((idx < 0) or (idx > FListaFonemas.count -1)) then
   begin
      Result := true;
      Token := FListaFonemas[idx];
      NewToken := FListaTokens[idx];
   end else
      Result := False;
end;

function TCustomFonemas.GetCount : integer;
begin
   Result := FListaFonemas.Count - 1;
end;

procedure TCustomFonemas.SetToken(Value : string);
begin
   FToken := Value;
   FLenToken := length(Value);
end;

procedure TCustomFonemas.SetNewToken(Value : string);
begin
   FNewToken := Value;
   FLenNewToken := length(Value);
end;

procedure TCustomFonemas.SetNome(Value : string);
begin
   FNome := Value;
   FLenNome := length(Value);
end;


function TCustomFonemas.TrocarToken : Boolean;
{
         Metodo para pesquizar se token e valido e montar token para troca

         Parametro   Descricao
         -------------------------------------------------------------------
         FNome        Nomes a ser fonetizado
         FToken       Token a ser avalidado para troca
         FNewToken    O token que devera ser trocado
         FIdxNome     indica a posicao do ponteiro dentro do nome
         FFonema      Token formado para troca se result = true

}
var
   i, j : integer;  // indice para o token e para o nome
   RepCons : char;
   FlentokenAux : integer;
   FNomeAux : string; //para conter o nome aumentado se necessario
begin
   i := 0;
   j := 0;
   FLenTokenAux := FLenToken;
   Result := True;
   RepCons := FNome[i + FIdxNome];
   FFonema := '';
   FNomeAux := AddSpacesToRight(FNome, ((FIdxNome + FLenToken)- FLenNome));
// estava embaixo antes acho que nao preciso mais ((FLenNome >= (FIdxNome + i)) or (FToken[i + 1] = '*')) and
   while ((FLenToken > i) and (Result)) do
   begin
      if FToken[i + 1] = FNomeAux[j + FIdxNome] then
         FFonema := FFonema + AddTokens(FNewToken, (i + 1), (i + 1))
      else
         if ((FToken[i + 1] = '?') and (FNomeAux[j + FIdxNome] in Consoantes)) or
            ((FToken[i + 1] = '!') and (FNomeAux[j + FIdxNome] in Vogais)) or
            ((FToken[i + 1] = '%') and (FNomeAux[j + FIdxNome] = RepCons) and not (RepCons in TiposRepetidosPermitidos)) or
            ((FToken[i + 1] = '+') and (FNomeAux[j + FIdxNome] = RepCons)) or
            ((FToken[i + 1] = '&') and (FNomeAux[j + FIdxNome] in TiposExtranhos)) or
            (FToken[i + 1] = '@') then
            FFonema := FFonema + AddTokens(FNomeAux, (j + FIdxNome), (i + 1))
         else
            if ((FToken[i + 1] = '.') and (FNomeAux[j + FIdxNome] in Consoantes) and not (FNomeAux[j + FIdxNome] in ConsoantesInvalidas)) or
                (FToken[i + 1] = '*') then
            begin
               FFonema := FFonema + FNewToken[i + 1];
               Dec(FLenTokenAux);
               Dec(j); // para indicar a posicao no nome que nao deslocou
            end else
               Result := False;
      inc(i);
      inc(j);
   end;
   //esta linha e para os casos em que o fonema e mairo que o token
   FLenSeg := FLentokenAux;
end;


function TCustomFonemas.AddTokens(SegStr : string; IndSegStr, IndToken : integer) : string;
{
          Metodo para devolver o caracter do fonema se existir
          parametros Descricao
          ---------- ------------------------------------------------------
          SegStr     Segmento do string a ser avaliado
          IndSegStr  Posicao do token a ser retirado o caracter
          IndToken   Posicao do token onde esta o char
}

begin
   // O & indica que o caracter na posicao devera ser ignorado
   if ((FLenNewToken >= IndToken) and (FToken[IndToken] <> '&') and (SegStr <> '')) then
      Result := SegStr[IndSegStr]
   else
      Result := '';
end;

function TCustomFonemas.AddSpacesToRight(Str : string; QtdSpc : integer) : string;
{
         Funcao para aumentar o tamanho do nome para fonetizacao de aumento
}
var
  i : integer;
begin
   if QtdSpc > 0 then
      for i := 1 to QtdSpc do
          Str := Str + #32;
   Result := Str;
end;


//TCNSNomeFonetizado    /////////////////////////////////////////

constructor TCNSNomeFonetizado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaptionLabel := 'Nome Fonetizado';
end;

procedure TCNSNomeFonetizado.Loaded;
begin
  inherited Loaded;
end;


destructor TCNSNomeFonetizado.Destroy;
begin
  inherited Destroy;
end;


procedure TCNSNomeFonetizado.SetFonetizar(Value : TCustomFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.OnDepoisFonetizar := DoDepoisFonetizar;
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSNomeFonetizado.DoDepoisFonetizar(Value : TObject);
begin
   if FFonetizar = nil then exit;
   Text := FFonetizar.NomeFonetico;
end;

procedure TCNSNomeFonetizado.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FFonetizar <> nil) and (AComponent = Fonetizar) then
       Fonetizar := nil;
  end;
end;


//TCNSDBNomeFonetizado    /////////////////////////////////////////

constructor TCNSDBNomeFonetizado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaptionLabel := 'Nome Fonetizado';
end;

procedure TCNSDBNomeFonetizado.Loaded;
begin
  inherited Loaded;
end;


destructor TCNSDBNomeFonetizado.Destroy;
begin
  inherited Destroy;
end;


procedure TCNSDBNomeFonetizado.SetFonetizar(Value : TCustomFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.OnDepoisFonetizar := DoDepoisFonetizar;
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSDBNomeFonetizado.DoDepoisFonetizar(Value : TObject);
begin
   if FFonetizar <> nil then
      if DataSource <> nil then
         if DataSource.State in [dsEdit, dsInsert] then
            if DataField <> '' then
               DataSource.DataSet.FieldByName(DataField).AsString := FFonetizar.NomeFonetico;
end;

procedure TCNSDBNomeFonetizado.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FFonetizar <> nil) and (AComponent = Fonetizar) then
       Fonetizar := nil;
  end;
end;



//TCNSNomeAbreviado    /////////////////////////////////////////

constructor TCNSNomeAbreviado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaptionLabel := 'Nome Abreviado';
end;

procedure TCNSNomeAbreviado.Loaded;
begin
  inherited Loaded;
   if assigned(FAbreviado) then
   begin
      FAbreviado.OnAntesAbreviar := DoAntesAbreviar;
      FAuxOnDepoisAbreviar := FAbreviado.OnDepoisAbreviar;
      FAbreviado.OnDepoisAbreviar := DoDepoisAbreviar;
   end;
end;


destructor TCNSNomeAbreviado.Destroy;
begin
  inherited Destroy;
end;


procedure TCNSNomeAbreviado.SetAbreviado(Value : TCustomAbreviar);
begin
   FAbreviado := Value;
   if Value <> nil then
   begin
//      Value.OnAntesAbreviar := DoAntesAbreviar;
//      FAuxOnDepoisAbreviar := Value.OnDepoisAbreviar;
//      Value.OnDepoisAbreviar := DoDepoisAbreviar;
      Value.FreeNotification(Self);
   end;
end;


procedure TCNSNomeAbreviado.DoAntesAbreviar(Value : TObject);
begin
   if FAbreviado = nil then exit;
//   AuxDoAntesAbreviar(Value);
end;

procedure TCNSNomeAbreviado.DoDepoisAbreviar(Value : TObject);
begin
   if FAbreviado = nil then exit;
      Text := FAbreviado.NomeAbreviado;
   if assigned(FAuxOnDepoisAbreviar) then FAuxOnDepoisAbreviar(Value);
end;


procedure TCNSNomeAbreviado.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FAbreviado <> nil) and (AComponent = Abreviado) then
       Abreviado := nil;
  end;
end;


//TCNSDBNomeAbreviado    /////////////////////////////////////////

constructor TCNSDBNomeAbreviado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaptionLabel := 'Nome Abreviado';
end;

procedure TCNSDBNomeAbreviado.Loaded;
begin
  inherited Loaded;
end;


destructor TCNSDBNomeAbreviado.Destroy;
begin
  inherited Destroy;
end;


procedure TCNSDBNomeAbreviado.SetAbreviar(Value : TCustomAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.OnDepoisAbreviar := DoDepoisAbreviar;
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSDBNomeAbreviado.DoDepoisAbreviar(Value : TObject);
begin
   if FAbreviar <> nil then
      if DataSource <> nil then
         if DataSource.State in [dsEdit, dsInsert] then
            if DataField <> '' then
               DataSource.DataSet.FieldByName(DataField).AsString := FAbreviar.NomeAbreviado;
end;

procedure TCNSDBNomeAbreviado.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FAbreviar <> nil) and (AComponent = Abreviar) then
       Abreviar := nil;
  end;
end;


////TCNSEditLabel///////////////////////////////////
constructor TCNSEditLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAOwner := AOwner;
  FCountLabel := 0;
end;

procedure TCNSEditLabel.Loaded;
begin
  inherited Loaded;
end;

destructor TCNSEditLabel.Destroy;
begin
  inherited Destroy;
end;

procedure TCNSEditLabel.Notification(AComponent: TComponent; Operation: TOperation);
{
  metodo para acertar ponteiros
}
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FLabel <> nil) and (AComponent = LabelAssociado) then
    begin
       LabelAssociado := nil;
       AssociarLabel := False;
    end;
  end;
end;

procedure TCNSEditLabel.SetLabel(Value : TLabel);
begin
   FLabel := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
      AssociarLabel := True;
   end;
end;

procedure TCNSEditLabel.SetAssociarLabel(Value : boolean);
{
   metodo para avisar a entrada do label e setar sua posicao junto ao edit
}
begin
   FAssociarLabel := Value;
   if Value = true then
      CriarLabel;
end;

procedure TCNSEditLabel.CriarLabel;
{
          metodo para criar um label e associalo ao edit recebera um nome formado pelo
          nome do edit para evitar duplicacao o seu Paent sero o do edit que e  a janela onde
          else estao contidos podria ser um panel
}
begin
  if (Flabel = nil) then
  begin
     FLabel := TLabel.Create(FAOwner);
     FLabel.Width := 40;
     Flabel.height := 20;
     FLabel.CAption := CaptionLabel;
     inc(FCountLabel);
     FLabel.Name := self.Name +  'Nome' + IntToStr(FCountLabel);
     Flabel.parent := self.parent;
  end;
  AjustarLabel;
end;

procedure TCNSEditLabel.WMMove(var Message: TWMMove);
{
   este medodo sempre ocorre qd os a janela e movimentada
}
begin
  inherited;
  if (FLabel <> nil) and (AssociarLabel) then
     AjustarLabel;
end;


procedure TCNSEditLabel.AjustarLabel;
{
   Este metodo ajustara a posicao do label de acordo com a posicao do Edit
   e a sua posicao em realcao ao edit
}
begin
     if (Flabel <> nil) and (AssociarLabel) then
     begin
        if FPosicaoLabel = pTop then
        begin
           FLabel.Top := Top - 15;
           FLabel.Left := Left;
        end else
        begin
           FLabel.Top := Top;
           FLabel.Left := Left - FLabel.width - 5;
        end;
     end;
end;

procedure TCNSEditLabel.SetCaptionLabel(Value : string);
begin
   FCaptionLabel := Value;
   if (FLabel <> nil)  and (AssociarLabel) then
   begin
       FLabel.Caption := CaptionLabel;
       Ajustarlabel;
   end;
end;
procedure TCNSEditLabel.SetPosicaoLabel(Value : TPosicaoLabel);
begin
   if (Value = pTop) or (Value = pLeft) then
   begin
      FPosicaoLabel := Value;
      AjustarLabel;
   end;
end;


////TCNSDBEditLabel///////////////////////////////////
constructor TCNSDBEditLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAOwner := AOwner;
  FCountLabel := 0;
end;

procedure TCNSDBEditLabel.Loaded;
begin
  inherited Loaded;
end;

destructor TCNSDBEditLabel.Destroy;
begin
  inherited Destroy;
end;

procedure TCNSDBEditLabel.Notification(AComponent: TComponent; Operation: TOperation);
{
  metodo para acertar ponteiros
}
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FLabel <> nil) and (AComponent = LabelAssociado) then
    begin
       LabelAssociado := nil;
       AssociarLabel := False;
    end;
  end;
end;

procedure TCNSDBEditLabel.SetLabel(Value : TLabel);
begin
   FLabel := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
      AssociarLabel := True;
   end;
end;

procedure TCNSDBEditLabel.SetAssociarLabel(Value : boolean);
{
   metodo para avisar a entrada do label e setar sua posicao junto ao edit
}
begin
   FAssociarLabel := Value;
   if Value = true then
      CriarLabel;
end;

procedure TCNSDBEditLabel.CriarLabel;
{
          metodo para criar um label e associalo ao edit recebera um nome formado pelo
          nome do edit para evitar duplicacao o seu Paent sero o do edit que e  a janela onde
          else estao contidos podria ser um panel
}
begin
  if (Flabel = nil) then
  begin
     FLabel := TLabel.Create(FAOwner);
     FLabel.Width := 40;
     Flabel.height := 20;
     FLabel.CAption := CaptionLabel;
     inc(FCountLabel);
     FLabel.Name := self.Name +  'Nome' + IntToStr(FCountLabel);
     Flabel.parent := self.parent;
  end;
  AjustarLabel;
end;

procedure TCNSDBEditLabel.WMMove(var Message: TWMMove);
{
   este medodo sempre ocorre qd os a janela e movimentada
}
begin
  inherited;
  if (FLabel <> nil) and (AssociarLabel) then
     AjustarLabel;
end;


procedure TCNSDBEditLabel.AjustarLabel;
{
   Este metodo ajustara a posicao do label de acordo com a posicao do Edit
   e a sua posicao em realcao ao edit
}
begin
     if (Flabel <> nil) and (AssociarLabel) then
     begin
        if FPosicaoLabel = pTop then
        begin
           FLabel.Top := Top - 15;
           FLabel.Left := Left;
        end else
        begin
           FLabel.Top := Top;
           FLabel.Left := Left - FLabel.width - 5;
        end;
     end;
end;

procedure TCNSDBEditLabel.SetCaptionLabel(Value : string);
begin
   FCaptionLabel := Value;
   if (FLabel <> nil)  and (AssociarLabel) then
   begin
       FLabel.Caption := CaptionLabel;
       Ajustarlabel;
   end;
end;
procedure TCNSDBEditLabel.SetPosicaoLabel(Value : TPosicaoLabel);
begin
   if (Value = pTop) or (Value = pLeft) then
   begin
      FPosicaoLabel := Value;
      AjustarLabel;
   end;
end;



////TCNSNome///////////////////////////////////
constructor TCNSNome.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TCNSNome.Loaded;
begin
  inherited Loaded;
end;

destructor TCNSNome.Destroy;
begin
  inherited Destroy;
end;

procedure TCNSNome.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FAbreviar <> nil) and (AComponent = Abreviar) then
       Abreviar := nil;
    if (FFonetizar <> nil) and (AComponent = Fonetizar) then
       Abreviar := nil;
  end;
end;

procedure TCNSNome.SetAbreviar(Value : TCustomAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSNome.SetFonetizar(Value : TCustomFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSNome.SetValue(const xValue: string);
begin
   FValue := xValue;
   if assigned(FOnChange) then FOnChange(Self);
   if FAbreviar <> nil then
   begin
      Abreviar.Nome := FValue;
      Abreviar.AbreviarNome;
   end;
   if FFonetizar <> nil then
   begin
      FFonetizar.Nome := FValue;
      FFonetizar.Fonetizar;
   end;
   NotifyLinks(self, lRefreshViewer);
end;

////TCNSDBNome///////////////////////////////////
constructor TCNSDBNome.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CaptionLabel := 'Nome';
end;

procedure TCNSDBNome.Loaded;
begin
  inherited Loaded;
end;

destructor TCNSDBNome.Destroy;
begin
  inherited Destroy;
end;


procedure TCNSDBNome.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FAbreviar <> nil) and (AComponent = Abreviar) then
       Abreviar := nil;
    if (FFonetizar <> nil) and (AComponent = Fonetizar) then
       Abreviar := nil;
  end;
end;

procedure TCNSDBNome.SetAbreviar(Value : TCustomAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSDBNome.SetFonetizar(Value : TCustomFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSDBNome.Change;
{
    Metodo para disparar a abreviacao e a fonetizacao
}
begin
  inherited Change;
  if FAbreviar <> nil then
  begin
     Abreviar.Nome := Text;
     Abreviar.AbreviarNome;
  end;
  if FFonetizar <> nil then
  begin
     FFonetizar.Nome := Text;
     FFonetizar.Fonetizar;
  end;
end;



end.


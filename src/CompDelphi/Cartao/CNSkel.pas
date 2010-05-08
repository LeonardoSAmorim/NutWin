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

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, extctrls, stdctrls, dbctrls, DB,
  checklst, menus, dbtables;

type
  TElemento = string;
  //Indica para que direcao seque a compactacao
  TDirecao = (Direita, Esquerda);
  TCNSPilhaStatica = class(TComponent)
  private
    { Private declarations }
    FArrayElementos : array [1..50] of TElemento;
    FPosicao : integer;
  protected
    { Protected declarations }
    procedure Loaded; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent);
    destructor Destroy;
    function IsFull : boolean;
    function IsEmpty : boolean;
    procedure Init;
    function Pop : TElemento;
    function View(PosicaoPilha : integer) : TElemento;
    procedure Push(Elemento : TElemento);
    property Posicao : integer read FPosicao write FPosicao;

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


  TCNSPilhaDinamica = class(TComponent)
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
    constructor Create(AOwner: TComponent);
    destructor Destroy;
    function IsFull : boolean;
    function IsEmpty : boolean;
    procedure Init;
    function Pop : TElementoVariante;
    function View(PosicaoPilha : integer) : TElementoVariante;
    procedure Push(Elemento : TElementoVariante);
    property Posicao : integer read FPosicao write FPosicao;


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

  TCNSTratarNome = Class(Tcomponent)
    FNome : string;
    FNomeIntermediario : string;
    FNomeTratado : string;
    procedure Tratar;
  protected
    { Protected declarations }
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure TratarNome;
  published
    { Published declarations }
    property Nome : string                read FNome write SeTCNSAbreviar;
  end;

  TCNSAbreviar = class(TComponent)
  private
    { Private declarations }
    FOnAntesAbreviar: TNotifyEvent;
    //variavel para receber o nome natural
    FNome : string;
    //Variavel para receber o nome abreviado
    FNomeAbreviado : string;
    //Variavel para manipular o nome fonetico
    FNomeFonetico : string;
    //Variavel para indicar se abrevidado ou nao (s/n)
    FIndicador : char;
    //Indica o tamanho maximo do nome abreviado
    FTamanhoSaida : integer;
    //Indica quantidade de nomes no inicio e no fim do Nome se couper
    FNomesExternos : integer;
    //Indicador da direcao da saida;
    FDirecao : TDirecao;
    //Pilha para conter nomes separados
    FPilhaNomes : TCNSPilhaStatica;
    FPilhaNomes2 : TCNSPilhaStatica;
    FInteiro : TCNSInteiro;
    //Determina o tamanho do retangulo
    MinImageSize: TPoint;
    //Image para poder conter o bitmap de apresentacao
    Image : TImage;
    //Variavel para conter os nomes durante a abreviacao
    FNomeIntermediario : string;
    //Variavel para conter a posicao Intermediaria
    FPosicaoIntermediaria : integer;
    //Tratar nome
    FTratarNome : TCNSTratarNome;

    //Metodos
    function VerificarNomeInter(Value : string) : boolean;
    procedure SeTCNSAbreviar(Value : String);
    procedure InitImage;
    procedure AbreviarParentes;
    procedure AbreviarNomesIntermediarios;
    procedure SetTratarNome(const Value: TCNSTratarNome);

//    procedure SepararAsm(Str: PChar; Chr: Char); pascal;

  protected
    { Protected declarations }
    //metodo para pintar o retangulo
    procedure Paint; //override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AbreviarNome;
    procedure TirarPatentes;
    procedure SepararNomes(NomePilha : TCNSPilhaStatica; Value : string; Direcao : TDirecao);
    function JuntarNomes(NomePilha : TCNSPilhaStatica; Direcao : TDirecao) : string;
    function JuntarPilhasNomes(PilhaNomes1, PilhaNomes2 : TCNSPilhaStatica; Direcao : TDirecao) : string;
    procedure TirarNomesIntermediarios;
    property NomeAbreviado : string       read FNomeAbreviado;
    property Indicador : char             read FIndicador;
  published
    { Published declarations }
    property OnAntesAbreviar: TNotifyEvent read FOnAntesAbreviar write FOnAntesAbreviar;
    property Nome : string                read FNome write SeTCNSAbreviar;
    property TamanhoSaida : integer       read FTamanhoSaida write FTamanhoSaida;
    property NomesExternos : integer      read FNomesExternos write FNomesExternos;
    property DirecaoAbreviacao : TDirecao read FDirecao write FDirecao;
    property TratarNome : TCNSTratarNome  read FTratarNome write SetTratarNome;
  end;


  TCNSTabelaTokens = class(TComponent)
  private
    //Determina o tamanho do retangulo
    MinImageSize: TPoint;
    //Indica de quanto o ponteiro deve andar no string
    FStep : integer;
    //Indica o token a ser avalidado
    FToken: string;
    //Indica o token de saida
    FNewToken : string;
    //Indica o fonema a ser utilizado na nome
    FFonema : string;
    //Image para poder conter o bitmap de apresentacao
    Image : TImage;
    //Nome a ser fonetizado
    FNome : string;
    //Lista para conter os tokens
    FItems : TStrings;
    //Lista para token de substituicao
    FListaFonemas : TStringList;
    //Indica posicao da tabela;
    FPosicao : integer;
    //Indica o deslocamento dentro do nome
    FIdxNome : integer;
    FLenToken : integer;
    FLenNewToken : integer;
    FLenNome : integer;
    //Tamanho do segmento a ser retirado do Nome para inclusao do novo
    FLenSeg : integer;
    function GetCount : integer;
    procedure InitImage;
    procedure SetToken(Value : String);
    procedure SetNewToken(Value : String);
    procedure SetNome(Value : String);
    function  AddSpacesToRight(Str : string; QtdSpc : integer) : string;


  protected
    procedure Paint; //override;
    procedure Loaded; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function TrocarToken : Boolean;
    function AddTokens(SegStr : string; IndSegStr, IndToken : integer) : string;
//    function AddTokens(NewToken : string; IndChar : integer) : string; esta era a antuiga
    procedure First;
    function Prior : boolean;
    function Next  : boolean;
    procedure Last;
    function view(Idx : integer) : boolean;
    property Nome : string read FNome write SetNome;
    property Token : string read FToken write SetToken;
    property NewToken : string read FNewToken write SetNewToken;
    property Fonema : string read FFonema write FFonema;
    property Step : integer read FStep write FStep;
    property Posicao : integer read FPosicao write FPosicao;
    property IdxNome : integer read FIdxNome write FIdxNome;
    property Count : integer read GetCount;
    property LenToken : integer read FLenToken write FLenToken;
    property LenNewToken : integer read FLenNewToken write FLenNewToken;
    property LenNome : integer read FLenNome write FLenNome;
    property LenSeg : integer read FLenSeg write FLenSeg;
  published
  end;


  TCNSFonetizar = class(TComponent)
  private
    { Private declarations }
    FOnAntesFonetizar: TNotifyEvent;
    //Objeto para abreviar o nome a ser abreviado
    FAbreviar : TCNSAbreviar;
    //Indica o tamanho maximo do nome abreviado
    FTamanhoSaida : integer;
    //Determina o tamanho do retangulo
    MinImageSize: TPoint;
    //Objeto que contem a tabela de tokens para trocas
    FTabelaTokens : TCNSTabelaTokens;
    //Image para poder conter o bitmap de apresentacao
    Image : TImage;
    //Indica o nome fonetizado
    FNomeFonetizado : string;
    //Nome a ser fonetizado
    FNome : string;
    procedure InitImage;
    procedure SeTCNSAbreviar(Value : TCNSAbreviar);
    procedure SetTabelaTokens(Value : TCNSTabelaTokens);
    procedure SetAbreviar(Value : TCNSAbreviar);

  protected
    { Protected declarations }
    procedure Paint;// override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Fonetizar;
    function Fonetizacao(Value: string) : string;
    property NomeFonetico : string read FNomeFonetizado;
  published
     property OnAntesFonetizar: TNotifyEvent read FOnAntesFonetizar write FOnAntesFonetizar;
     property Abreviar : TCNSAbreviar read FAbreviar write SetAbreviar;
     property TabelaTokens : TCNSTabelaTokens read FTabelaTokens write SetTabelaTokens;
     property TamanhoSaida : integer read FTamanhoSaida write FTamanhoSaida;
     property Nome : string read FNome write FNome;
    { Published declarations }
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
    FFonetizar : TCNSFonetizar;
    procedure SetFonetizar(Value : TCNSFonetizar);
    procedure DoAntesFonetizar(Value : TObject);

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
    property Fonetizar : TCNSFonetizar read FFonetizar write SetFonetizar;
  end;

  TCNSDBNomeFonetizado = class(TCNSDBEditLabel)
  private
    { Private declarations }
    //Objeto para fonetizar
    FFonetizar : TCNSFonetizar;
    procedure SetFonetizar(Value : TCNSFonetizar);
    procedure DoAntesFonetizar(Value : TObject);

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
    property Fonetizar : TCNSFonetizar read FFonetizar write SetFonetizar;
  end;



  TCNSNomeAbreviado = class(TCNSEditLabel)
  private
    { Private declarations }
    //Objeto para fonetizar
    FAbreviar : TCNSAbreviar;
    procedure SetAbreviar(Value : TCNSAbreviar);
    procedure DoAntesAbreviar(Value : TObject);

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
    property Abreviar : TCNSAbreviar read FAbreviar write SetAbreviar;
  end;


  TCNSDBNomeAbreviado = class(TCNSDBEditLabel)
  private
    { Private declarations }
    //Objeto para fonetizar
    FAbreviar : TCNSAbreviar;
    FLabel : TLabel;
    procedure SetAbreviar(Value : TCNSAbreviar);
    procedure DoAntesAbreviar(Value : TObject);

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
    property Abreviar : TCNSAbreviar read FAbreviar write SetAbreviar;
  end;


  TCNSNome = class(TCNSEditLabel)
  private
    { Private declarations }
    FAbreviar : TCNSAbreviar;
    Ffonetizar : TCNSFonetizar;
    procedure SetAbreviar(Value : TCNSAbreviar);
    procedure SetFonetizar(Value : TCNSFonetizar);
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
    property Abreviar : TCNSAbreviar read FAbreviar write SetAbreviar;
    property Fonetizar : TCNSFonetizar read FFonetizar write SetFonetizar;
  end;

  TCNSDBNome = class(TCNSDBEditLabel)
  private
    { Private declarations }
    FAbreviar : TCNSAbreviar;
    Ffonetizar : TCNSFonetizar;
    procedure SetAbreviar(Value : TCNSAbreviar);
    procedure SetFonetizar(Value : TCNSFonetizar);
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
    property Abreviar : TCNSAbreviar read FAbreviar write SetAbreviar;
    property Fonetizar : TCNSFonetizar read FFonetizar write SetFonetizar;
  end;


procedure Register;

implementation
{$R CNS}

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
  ('BEL.',
   'CEL.',
   'ENG.',
   'MAJ.',
   'MIN.',
   'PROF.',
   'TEN.',
   'CAP.',
   'DR.',
   'DRA.',
   'GAL.',
   'MED.',
   'PE.',
   'SARG.',
   'VVA.'
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
  RegisterComponents('CNS-SIS', [TCNSFonetizar]);
  RegisterComponents('CNS-SIS', [TCNSTabelaTokens]);
  RegisterComponents('CNS-SIS', [TCNSEditLabel]);
  RegisterComponents('CNS-SIS', [TCNSNome]);
  RegisterComponents('CNS-SIS', [TCNSNomeAbreviado]);
  RegisterComponents('CNS-SIS', [TCNSNomeFonetizado]);
  RegisterComponents('CNS-SIS', [TCNSDBEditLabel]);
  RegisterComponents('CNS-SIS', [TCNSDBNome]);
  RegisterComponents('CNS-SIS', [TCNSDBNomeAbreviado]);
  RegisterComponents('CNS-SIS', [TCNSDBNomeFonetizado]);
  RegisterComponents('CNS-SIS', [TCNSPilhaStatica]);
  RegisterComponents('CNS-SIS', [TCNSPilhaDinamica]);
  RegisterComponents('CNS-SIS', [TCNSInteiro]);
end;

//////////////////////////////////TTratar Nome///////////////////////
constructor TCNSTratarNome.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TCNSTratarNome.Loaded;
begin
  inherited Loaded;
end;

destructor TCNSTratarNome.Destroy;
begin
  inherited Destroy;
end;

function TCNSTratarNome.TratarNome(xNome : string);
begin
   //retira espacos iniciais
   FNomeIntermediario := UpperCase(Trim(FNome));
   Tratar;
   FNomeTratado := FNomeIntermediario;
end;

procedure TCNSTratarNome.Tratar;
{
          Este metodo ira retirar os caracteres nao numereicos e nao alfanumericos
permitido somente os caracteres da lista de caracteres permitidos
}
var
   NomeAux, NomeAux2 : string;
   j    : integer;
begin
   NomeAux2 := FNomeIntermediario;
   //Eliminar Bracos a mais no meio do Nome
   j := 1;
   NomeAux := '';
   while (j <= Length(NomeAux2)) do
   begin
      while (NomeAux2[j] = #32) and
            ((NomeAux2[j + 1] = #32) or not(NomeAux2[j + 1] in  CaracteresPermitidos)) and
            (j < Length(NomeAux2))  do
            Inc(j);
      // retirar caracteres invalidos
      if (NomeAux2[j] in  CaracteresPermitidos) then
          NomeAux := NomeAux + NomeAux2[j];
      Inc(j);
   end;
   //Seta Nome Intermediario para refletir como nome esta
   FNomeIntermediario := NomeAux;
end;



////////////////////////////Abreviar//////////////////////////////////////

constructor TCNSAbreviar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Image := TImage.Create(self);
//  InitImage;
//  Width := 28;
//  Height := 28;
  //Inicia Pilha Nomes
  FPilhaNomes := TCNSPilhaStatica.Create(nil);
  FPilhaNomes2 := TCNSPilhaStatica.Create(nil);
end;


procedure TCNSAbreviar.Paint;
{
          Metodo para pintar o quadro do bitmap
}
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
  FontHeight: Integer;
  BitMap : TPicture;
begin
//  inherited Paint;
{  Rect := GetClientRect;
  with Canvas do
  begin
    Brush.Color := clwhite;
    FillRect(Rect);
    Brush.Style := bscross ;
    Font := Self.Font;
    FontHeight := TextHeight('W');
    with Rect do
    begin
      Top := ((Bottom + Top) - FontHeight) div 2;
      Bottom := Top + FontHeight;
    end;
    DrawText(Handle, PChar('Abreviar'), -1, Rect, (DT_VCENTER));
  end;
  InitImage;
}
end;


procedure TCNSAbreviar.Loaded;
begin
  inherited Loaded;
//  visible := false;
end;



destructor TCNSAbreviar.Destroy;
begin
  inherited Destroy;
end;

procedure TCNSAbreviar.InitImage;
var
  ResName: string;
begin
{  MinImageSize := Point(20, 18);
  Image.Visible := true;
  Image.Stretch := True;
  Image.Align := alClient;
  Image.SetBounds(0, 0, MinImageSize.X, MinImageSize.Y);
  Image.Picture.Bitmap.Handle := LoadBitmap(HInstance, 'Abreviar');
  Image.Parent := Self;
 }
end;

procedure TCNSAbreviar.SeTCNSAbreviar(Value : String);
begin
   FNome := Value;
   FNomeIntermediario := Value;
end;

procedure TCNSAbreviar.AbreviarNome;
{
          Este metodo ira disparar os metodos para Abreviar Nome
}
begin
   if Assigned(FOnAntesAbreviar) then FOnAntesAbreviar(Self);
   if Length(FNome) <> 0 then
   begin
      SepararNomes(FPilhaNomes, FNome, Esquerda);
      // 1
      TirarPatentes;
      // 2
      //colocar a camada a tratar nomeTratarNome;
      if FPilhaNomes.Posicao > 2 then
      begin
         TirarNomesIntermediarios;
         AbreviarNomesIntermediarios;
      end;
   end;
//tESTAR QUEDO TIVER TEMP   SepararAsm('LUIZ QUELVES DA SILVA', ' ');
//AbreviarParentes; definiu-se nao tirar parentes
end;

procedure TCNSAbreviar.TirarPatentes;
{
    Rotina para tirar patentes do inicio do nome se abreviada
}
var
   i, j, k   : integer;
   Patente   : string;
   NomeAux   : string;
begin
  //Determina tamanho do Nome
  k :=  Length(FNomeIntermediario);
  j := 1;

  // Separa primeira palavra
  while (k > j) and (FNomeIntermediario[j] <> '.') do
     inc(j);
  if (FNomeIntermediario[j] = '.') and (FNomeIntermediario[j + 1] = #32) then
  begin
     Patente := string(copy(FNomeIntermediario,1 ,j));

     //Procura por Parente no Nome
     for i := 1 to 15 do
     begin
        if Patente = string(ArrayPatentes[i]) then
        begin
           //Substitui Parente pela Sigla do Parente
           FNomeIntermediario := copy(FNomeIntermediario, j + 2, k - j);
           break;
        end;
     end;
  end;
end;


procedure TCNSAbreviar.AbreviarParentes;
{
          Rotina para abreviar nomes de parentes, nao sera usada por definicao da
reuniao de 11/05/98 CEF RJ
}
var
   i, j     : integer;
   Parente   : string;
begin
  //Determina tamanho do Nome
  j :=  Length(FNomeIntermediario);
  i := j;

  //Indica a posicao em que o ponteiro para esse nome ficou definido
  FPosicaoIntermediaria := j;

  // Separa ultima palavra
  while (j > 1) and (FNomeIntermediario[j] <> #32) do
     dec(j);
  if j > 1 then
  begin
     parente := string(copy(FNomeIntermediario, j + 1, i - j + 1));
     //Indica a posicao em que o ponteiro para esse nome ficou definido
     FPosicaoIntermediaria := j;
     //Procura por Parente no Nome
     for i := 1 to 32 do
     begin
        if Parente = string(ArrayParentes[i]) then
        begin
           //Substitui Parente pela Sigla do Parente
           FNomeIntermediario := copy(FNomeIntermediario, 1 , j) + string(ArraySiglaParentes[i]);
           break;
        end;
     end;
  end;
  FNomeAbreviado := FNomeIntermediario;
end;

procedure TCNSAbreviar.TirarNomesIntermediarios;
var
   NomeInter  : string;
   i : integer;
begin
  // Monta Nova Pilha
  SepararNomes(FPilhaNomes, FNomeIntermediario, Esquerda);
  if FPilhaNomes.Posicao < 3 then exit;
  //Tirar Nomes Intermediarios tal como da, de di e etc ver table NomesIntermedirario
  FPilhaNomes2.Init;
  FPilhaNomes2.Push(FPilhaNomes.Pop);
  while (FPilhaNomes.Posicao > 1) and (Length(FNomeIntermediario) > FTamanhoSaida) do
  begin
     NomeInter := FPilhaNomes.Pop;
     if not (VerificarNomeInter(NomeInter)) then
        FPilhaNomes2.Push(NomeInter);
     FNomeIntermediario := JuntarPilhasNomes(FPilhaNomes, FPilhaNomes2, Esquerda);
  end;
end;

procedure TCNSAbreviar.AbreviarNomesIntermediarios;
{
          Metodo para abreviar os nomes intermediarios da Esquerda para Direita
}
var
   NomeInter  : string;
   i : integer;
   NomesExternosAux : integer;
begin
  //Abrevia nomes da esquerda para a direita ate que Length se menor que Tamanho saida ou se nao der mais para abreviar
  NomesExternosAux := FNomesExternos;
  while (Length(FNomeIntermediario) > FTamanhoSaida)  and (NomesExternosAux > 0) do
  begin
     // Monta Nova Pilha
     SepararNomes(FPilhaNomes, FNomeIntermediario, FDirecao);
     //verifica a validade dos parametros
     if FPilhaNomes.Posicao < NomesExternosAux then
     begin
       ShowMessage('Nomes externos nao pode ser maior que Numero de subNomes.');
       NomesExternosAux := 0;
       exit;
     end;
     FPilhaNomes2.Init;
     //Tira os primeiros nomes da lista
     for i := 1 to NomesExternosAux do
       FPilhaNomes2.Push(FPilhaNomes.Pop);
     //Abreviar nomes
     while (FPilhaNomes.Posicao > NomesExternosAux) and (Length(FNomeIntermediario) > FTamanhoSaida) do
     begin
        FPilhaNomes2.Push(FPilhaNomes.Pop[1]);
        FNomeIntermediario := JuntarPilhasNomes(FPilhaNomes, FPilhaNomes2, FDirecao);
     end;
     Dec(NomesExternosAux);
  end;
  FNomeAbreviado := FNomeIntermediario;
end;

function TCNSAbreviar.VerificarNomeInter(Value : string) : boolean;
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

procedure TCNSAbreviar.SepararNomes(NomePilha : TCNSPilhaStatica; Value : string; Direcao : TDirecao);
{
          Metodo para Separar Nomes e coloca-lo em um pilha
          parametros Descricao
          ---------- ------------------------------------------------------
          NomePilha  Pilha que ira contar o Nome flagmentado
          Value      Nome a ser falgamento
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
      while (k > j) do
      begin
         while (k > j) and (Value[j] <> #32) do
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
      while (j > 1) do
      begin
         while (j > 1) and (Value[j] <> #32) do
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

function TCNSAbreviar.JuntarNomes(NomePilha : TCNSPilhaStatica; Direcao : TDirecao) : string;
{
         metodo para montar um nome atravez de uma pilha de palavras
          parametros Descricao
          ---------- ------------------------------------------------------
          NomePilha  Pilha que  contem o Nome flagmentado
          Result     Nome Montado
          Direcao    Sentido da flamenetacao 1 - esq p/ dir  2 - dir p/ esq

}
var
   NomeAux : string;
   i       : integer;
begin
    NomeAux := ' ';
    if Direcao = Esquerda then
       for i := 1 to NomePilha.Posicao do
          NomeAux := NomeAux + NomePilha.View(i)
    else
      if Direcao = Direita then
         for i := NomePilha.Posicao downto 1 do
           NomeAux := NomeAux + NomePilha.View(i)
      else
         ShowMessage('Direcao Invalida');
   Result :=  Trim(NomeAux);
end;

function TCNSAbreviar.JuntarPilhasNomes(PilhaNomes1, PilhaNomes2 : TCNSPilhaStatica; Direcao : TDirecao) : string;
{
         metodo para montar um nome atravez de duas pilhas de palavras
         parametros Descricao
         ---------- ------------------------------------------------------
         NomePilha  Pilha que  contem o  inicio do Nome flagmentado
         NomePilha2 Pilha que  contem o  fim do Nome flagmentado
         Result     Nome Montado

}
var
   NomeAux : string;
   i       : integer;
   PilhaAux : TCNSPilhaStatica;
begin
   if Direcao = Direita then
   begin
      PilhaAux := TCNSPilhaStatica.Create(nil);
      PilhaAux := PilhaNomes1;
      PilhaNomes1 := PilhaNomes2;
      PilhaNomes2 := PilhaAux;
   end;
   NomeAux := ' ';
   for i := 1 to PilhaNomes1.Posicao  do
     NomeAux := NomeAux +  ' ' + PilhaNomes1.View(i);
   for i := PilhaNomes2.Posicao downto 1 do
     NomeAux := NomeAux +  ' ' + PilhaNomes2.View(i);
   Result :=  Trim(NomeAux);
end;


//TPilha Estatica /////////////////////////////////////


constructor TCNSPilhaStatica.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
//  init;
end;

destructor TCNSPilhaStatica.Destroy;
begin
  inherited Destroy;
end;

procedure TCNSPilhaStatica.Loaded;
begin
  inherited Loaded;
  Init;
end;

procedure TCNSPilhaStatica.Init;
begin
   FPosicao := 0;
end;


function TCNSPilhaStatica.Pop : TElemento;
begin
   if not IsEmpty then
   begin
      Result := FArrayElementos[FPosicao];
      dec(FPosicao);
   end
   else
      ShowMessage('Pilha Vazia');
end;

function TCNSPilhaStatica.View(PosicaoPilha : integer) : TElemento;
begin
   if (PosicaoPilha > 0) and (PosicaoPilha <= FPosicao) then
   begin
      Result := FArrayElementos[PosicaoPilha];
   end
   else
      ShowMessage('Fora da Faixa da Pilha');
end;


procedure TCNSPilhaStatica.Push(Elemento : TElemento);
begin
   if not IsFull then
   begin
      inc(FPosicao);
      FArrayElementos[FPosicao] := Elemento;
   end
   else
      ShowMessage('Pilha Cheia');

end;

function TCNSPilhaStatica.IsEmpty : boolean;
begin
   Result := (FPosicao = 0);
end;

function TCNSPilhaStatica.IsFull : boolean;
begin
   Result := (FPosicao = 30);
end;

///////////////////////////////////////////TCNSPilhaDinamica//////////////////////////////////////////////////////////////


constructor TCNSPilhaDinamica.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FPosicao := 0;
 init;
end;

destructor TCNSPilhaDinamica.Destroy;
begin
  inherited Destroy;
end;

procedure TCNSPilhaDinamica.Loaded;
begin
  inherited Loaded;
  FPosicao := 0;
  Init;
end;

procedure TCNSPilhaDinamica.Init;
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


function TCNSPilhaDinamica.Pop : TElementoVariante;
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

function TCNSPilhaDinamica.View(PosicaoPilha : integer) : TElementoVariante;
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


procedure TCNSPilhaDinamica.Push(Elemento : TElementoVariante);
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

function TCNSPilhaDinamica.IsEmpty : boolean;
begin
   Result := (LastPrato = nil);
end;

function TCNSPilhaDinamica.IsFull : boolean;
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

//TCNSFonetizar    /////////////////////////////////////////

constructor TCNSFonetizar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Image := TImage.Create(self);
//  InitImage;
//  Width := 28;
//  Height := 28;
end;

procedure TCNSFonetizar.Paint;
{
          Metodo para pintar o quadro do bitmap
}
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
  FontHeight: Integer;
  BitMap : TPicture;
begin
//  inherited Paint;
{  Rect := GetClientRect;
  with Canvas do
  begin
    Brush.Color := clwhite;
    FillRect(Rect);
    Brush.Style := bscross ;
    Font := Self.Font;
    FontHeight := TextHeight('W');
    with Rect do
    begin
      Top := ((Bottom + Top) - FontHeight) div 2;
      Bottom := Top + FontHeight;
    end;
    DrawText(Handle, PChar('Fonetizar'), -1, Rect, (DT_VCENTER));
  end;
  InitImage;
 }
end;


procedure TCNSFonetizar.Loaded;
begin
  inherited Loaded;
//  visible := false;
end;


destructor TCNSFonetizar.Destroy;
begin
  inherited Destroy;
end;

procedure TCNSFonetizar.InitImage;
var
  ResName: string;
begin
{  MinImageSize := Point(20, 18);
  Image.Visible := true;
  Image.Stretch := True;
  Image.Align := alClient;
  Image.SetBounds(0, 0, MinImageSize.X, MinImageSize.Y);
  Image.Picture.Bitmap.Handle := LoadBitmap(HInstance, 'Fonetizar');
  Image.Parent := Self;
  }
end;

procedure TCNSFonetizar.SeTCNSAbreviar(Value : TCNSAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSFonetizar.Fonetizar;
var LenSaida : integer;
begin
   if FAbreviar <> nil  then
   begin
      if FNome <> '' then
      begin
         FAbreviar.Nome := FNome;
         FAbreviar.AbreviarNome;
         LenSaida := FAbreviar.TamanhoSaida;
         FAbreviar.TamanhoSaida := 0;
         FAbreviar.TirarNomesIntermediarios;
         FAbreviar.TamanhoSaida := LenSaida;
         FNomeFonetizado := Fonetizacao(#32 + FAbreviar.NomeAbreviado);
         if Assigned(FOnAntesFonetizar) then FOnAntesFonetizar(Self);
      end;
   end;
end;

function TCNSFonetizar.Fonetizacao(Value: string) : string;
begin
   if not Assigned(TabelaTokens) then
      FTabelaTokens := TCNSTabelaTokens.Create(nil);
   TabelaTokens.Nome := string(Value);
   TabelaTokens.First;
   repeat
      TabelaTokens.IdxNome := 1;
      while (TabelaTokens.IdxNome <= Length(TabelaTokens.Nome)) do
      begin
         if (TabelaTokens.Nome[TabelaTokens.IdxNome] = TabelaTokens.Token[1]) or (TabelaTokens.Token[1] = '!') or (TabelaTokens.Token[1] = '?') or (TabelaTokens.Token[1] = '@') then
            if TabelaTokens.TrocarToken then
               FTabelaTokens.Nome := copy(FTabelaTokens.Nome, 1, TabelaTokens.IdxNome - 1) + TabelaTokens.Fonema + copy(FTabelaTokens.Nome, (TabelaTokens.IdxNome + TabelaTokens.LenSeg), ((TabelaTokens.LenNome) - (TabelaTokens.IdxNome + (TabelaTokens.LenSeg) -1)));

         inc(TabelaTokens.FIdxNome);
      end;
   until not (TabelaTokens.Next);
   Result := Trim(TabelaTokens.Nome);
end;


procedure TCNSFonetizar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FAbreviar <> nil) and (AComponent = Abreviar) then
       Abreviar := nil;
    if (FTabelaTokens <> nil) and (AComponent = TabelaTokens) then
       TabelaTokens := nil;
  end;
end;

procedure TCNSFonetizar.SetAbreviar(Value : TCNSAbreviar);
begin
  FAbreviar := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSFonetizar.SetTabelaTokens(Value : TCNSTabelaTokens);
begin
  FTabelaTokens := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;


///////TTabela de Tokens////////////////////////////////////////

constructor TCNSTaBelaTokens.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Image := TImage.Create(self);
//  InitImage;
//  Width := 28;
//  Height := 28;
end;

procedure TCNSTaBelaTokens.Paint;
{
          Metodo para pintar o quadro do bitmap
}
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
  FontHeight: Integer;
  BitMap : TPicture;
begin
//  inherited Paint;
 { Rect := GetClientRect;
  with Canvas do
  begin
    Brush.Color := clwhite;
    FillRect(Rect);
    Brush.Style := bscross ;
    Font := Self.Font;
    FontHeight := TextHeight('W');
    with Rect do
    begin
      Top := ((Bottom + Top) - FontHeight) div 2;
      Bottom := Top + FontHeight;
    end;
    DrawText(Handle, PChar('TabelaToekns'), -1, Rect, (DT_VCENTER));
  end;
  InitImage;
  }
end;


procedure TCNSTaBelaTokens.Loaded;
begin
  inherited Loaded;
//  visible := false;
end;


destructor TCNSTaBelaTokens.Destroy;
begin
  inherited Destroy;
end;

procedure TCNSTaBelaTokens.InitImage;
var
  ResName: string;
begin
{  MinImageSize := Point(20, 18);
  Image.Visible := true;
  Image.Stretch := True;
  Image.Align := alClient;
  Image.SetBounds(0, 0, MinImageSize.X, MinImageSize.Y);
  Image.Picture.Bitmap.Handle := LoadBitmap(HInstance, 'TaBelaTokens');
  Image.Parent := Self;
  }
end;



procedure TCNSTabelaTokens.First;
begin
   FPosicao := 1;
   Token := string(ArrayTokens[1]);
   NewToken := string(ArrayNewTokens[1]);
end;

function TCNSTabelaTokens.Prior : boolean;
begin
   Result := True;
   if FPosicao > 1 then
      dec(FPosicao)
   else
      Result := False;
   Token := string(ArrayTokens[FPosicao]);
   NewToken := string(ArrayNewTokens[FPosicao]);
end;

function TCNSTabelaTokens.Next : boolean;
begin
   Result := True;
   if FPosicao < MAXTOKENS then
      inc(Fposicao)
   else
      Result := false;
   Token := string(ArrayTokens[FPosicao]);
   NewToken := string(ArrayNewTokens[FPosicao]);
end;

procedure TCNSTabelaTokens.Last;
begin
   FPosicao := MAXTOKENS;
   Token := string(ArrayTokens[MAXTOKENS]);
   NewToken := string(ArrayNewTokens[MAXTOKENS]);
end;

function TCNSTabelaTokens.view(idx : integer): boolean;
begin
   if not ((idx < 1) or (idx > MAXTOKENS)) then
   begin
      Token := string(ArrayTokens[idx]);
      NewToken := string(ArrayNewTokens[idx]);
   end else
      Result := False;
end;

function TCNSTabelaTokens.GetCount : integer;
begin
   Result := MAXTOKENS;
end;

procedure TCNSTabelaTokens.SetToken(Value : string);
begin
   FToken := Value;
   FLenToken := length(Value);
end;

procedure TCNSTabelaTokens.SetNewToken(Value : string);
begin
   FNewToken := Value;
   FLenNewToken := length(Value);
end;

procedure TCNSTabelaTokens.SetNome(Value : string);
begin
   FNome := Value;
   FLenNome := length(Value);
end;


function TCNSTaBelaTokens.TrocarToken : Boolean;
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
   LenNewToken : integer;
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


function TCNSTaBelaTokens.AddTokens(SegStr : string; IndSegStr, IndToken : integer) : string;
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

function TCNSTaBelaTokens.AddSpacesToRight(Str : string; QtdSpc : integer) : string;
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


procedure TCNSNomeFonetizado.SetFonetizar(Value : TCNSFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.OnAntesFonetizar := DoAntesFonetizar;
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSNomeFonetizado.DoAntesFonetizar(Value : TObject);
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
//    if (FAbreviar <> nil) and (AComponent = Abreviar) then
//       Abreviar := nil;
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


procedure TCNSDBNomeFonetizado.SetFonetizar(Value : TCNSFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.OnAntesFonetizar := DoAntesFonetizar;
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSDBNomeFonetizado.DoAntesFonetizar(Value : TObject);
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
//    if (FAbreviar <> nil) and (AComponent = Abreviar) then
//       Abreviar := nil;
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
end;


destructor TCNSNomeAbreviado.Destroy;
begin
  inherited Destroy;
end;


procedure TCNSNomeAbreviado.SetAbreviar(Value : TCNSAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.OnAntesAbreviar := DoAntesAbreviar;
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSNomeAbreviado.DoAntesAbreviar(Value : TObject);
begin
   if FAbreviar = nil then exit;
   Text := FAbreviar.NomeAbreviado;
end;

procedure TCNSNomeAbreviado.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FAbreviar <> nil) and (AComponent = Abreviar) then
       Abreviar := nil;
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


procedure TCNSDBNomeAbreviado.SetAbreviar(Value : TCNSAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.OnAntesAbreviar := DoAntesAbreviar;
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSDBNomeAbreviado.DoAntesAbreviar(Value : TObject);
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
  CaptionLabel := 'Nome';
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

procedure TCNSNome.SetAbreviar(Value : TCNSAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSNome.SetFonetizar(Value : TCNSFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;


procedure TCNSNome.Change;
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

procedure TCNSDBNome.SetAbreviar(Value : TCNSAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSDBNome.SetFonetizar(Value : TCNSFonetizar);
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

procedure TCNSAbreviar.SetTratarNome(const Value: TCNSTratarNome);
begin
  FTratarNome := Value;
  if value <> nil then
  begin
     Value.FreeNotification(Self);
  end;
end;

end.


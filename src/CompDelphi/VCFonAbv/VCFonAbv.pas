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




unit VCFonAbv;
{ ****************************************************************** }
{                                                                    }
{   CNS.pas                                                          }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Maio/1998                                                     }
{                                                                    }
{ ****************************************************************** }
     {
         CNS.pas
         Unit Referente ao componetes que foram criados no periodo do desenvolvimento
     do cartao SUS
     }

interface

uses   Classes, stdctrls, SysUtils, messages, db, dbctrls, CCSListaLinks, CCSAbreviar, CCSFonetizar;


type
  TPosicaoLabel = (pTop, pLeft);

  TCCSEditLabel = class(TCustomEdit)
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

  TCCSDBEditLabel = class(TDBEdit)
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



  TCCSNomeFonetizado = class(TCCSEditLabel)
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

  TCCSDBNomeFonetizado = class(TCCSDBEditLabel)
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




  TCCSDBNomeAbreviado = class(TCCSDBEditLabel)
  private
    { Private declarations }
    //Objeto para fonetizar
    FAbreviar : TCustomAbreviar;
//    FLabel : TLabel;
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


  TCCSNome = class(TCCSListaLinks)
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

  TCCSDBNome = class(TCCSDBEditLabel)
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

  TCCSNomeAbreviado = class(TCCSEditlabel)
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
//  cPonto : char = '.';

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('CCS-SIS', [TCCSEditLabel]);
  RegisterComponents('CCS-SIS', [TCCSNome]);
  RegisterComponents('CCS-SIS', [TCCSNomeAbreviado]);
  RegisterComponents('CCS-SIS', [TCCSNomeFonetizado]);
  RegisterComponents('CCS-SIS', [TCCSDBEditLabel]);
  RegisterComponents('CCS-SIS', [TCCSDBNome]);
  RegisterComponents('CCS-SIS', [TCCSDBNomeAbreviado]);
  RegisterComponents('CCS-SIS', [TCCSDBNomeFonetizado]);
end;


//TCCSNomeFonetizado    /////////////////////////////////////////

constructor TCCSNomeFonetizado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaptionLabel := 'Nome Fonetizado';
end;

procedure TCCSNomeFonetizado.Loaded;
begin
  inherited Loaded;
end;


destructor TCCSNomeFonetizado.Destroy;
begin
  inherited Destroy;
end;


procedure TCCSNomeFonetizado.SetFonetizar(Value : TCustomFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.OnDepoisFonetizar := DoDepoisFonetizar;
      Value.FreeNotification(Self);
   end;
end;

procedure TCCSNomeFonetizado.DoDepoisFonetizar(Value : TObject);
begin
   if FFonetizar = nil then exit;
   Text := FFonetizar.NomeFonetico;
end;

procedure TCCSNomeFonetizado.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FFonetizar <> nil) and (AComponent = Fonetizar) then
       Fonetizar := nil;
  end;
end;


//TCCSDBNomeFonetizado    /////////////////////////////////////////

constructor TCCSDBNomeFonetizado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaptionLabel := 'Nome Fonetizado';
end;

procedure TCCSDBNomeFonetizado.Loaded;
begin
  inherited Loaded;
end;


destructor TCCSDBNomeFonetizado.Destroy;
begin
  inherited Destroy;
end;


procedure TCCSDBNomeFonetizado.SetFonetizar(Value : TCustomFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.OnDepoisFonetizar := DoDepoisFonetizar;
      Value.FreeNotification(Self);
   end;
end;

procedure TCCSDBNomeFonetizado.DoDepoisFonetizar(Value : TObject);
begin
   if FFonetizar <> nil then
      if DataSource <> nil then
         if DataSource.State in [dsEdit, dsInsert] then
            if DataField <> '' then
               DataSource.DataSet.FieldByName(DataField).AsString := FFonetizar.NomeFonetico;
end;

procedure TCCSDBNomeFonetizado.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FFonetizar <> nil) and (AComponent = Fonetizar) then
       Fonetizar := nil;
  end;
end;



//TCCSNomeAbreviado    /////////////////////////////////////////

constructor TCCSNomeAbreviado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaptionLabel := 'Nome Abreviado';
end;

procedure TCCSNomeAbreviado.Loaded;
begin
  inherited Loaded;
   if assigned(FAbreviado) then
   begin
      FAbreviado.OnAntesAbreviar := DoAntesAbreviar;
      FAuxOnDepoisAbreviar := FAbreviado.OnDepoisAbreviar;
      FAbreviado.OnDepoisAbreviar := DoDepoisAbreviar;
   end;
end;


destructor TCCSNomeAbreviado.Destroy;
begin
  inherited Destroy;
end;


procedure TCCSNomeAbreviado.SetAbreviado(Value : TCustomAbreviar);
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


procedure TCCSNomeAbreviado.DoAntesAbreviar(Value : TObject);
begin
   if FAbreviado = nil then exit;
//   AuxDoAntesAbreviar(Value);
end;

procedure TCCSNomeAbreviado.DoDepoisAbreviar(Value : TObject);
begin
   if FAbreviado = nil then exit;
      Text := FAbreviado.NomeAbreviado;
   if assigned(FAuxOnDepoisAbreviar) then FAuxOnDepoisAbreviar(Value);
end;


procedure TCCSNomeAbreviado.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FAbreviado <> nil) and (AComponent = Abreviado) then
       Abreviado := nil;
  end;
end;


//TCCSDBNomeAbreviado    /////////////////////////////////////////

constructor TCCSDBNomeAbreviado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaptionLabel := 'Nome Abreviado';
end;

procedure TCCSDBNomeAbreviado.Loaded;
begin
  inherited Loaded;
end;


destructor TCCSDBNomeAbreviado.Destroy;
begin
  inherited Destroy;
end;


procedure TCCSDBNomeAbreviado.SetAbreviar(Value : TCustomAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.OnDepoisAbreviar := DoDepoisAbreviar;
      Value.FreeNotification(Self);
   end;
end;

procedure TCCSDBNomeAbreviado.DoDepoisAbreviar(Value : TObject);
begin
   if FAbreviar <> nil then
      if DataSource <> nil then
         if DataSource.State in [dsEdit, dsInsert] then
            if DataField <> '' then
               DataSource.DataSet.FieldByName(DataField).AsString := FAbreviar.NomeAbreviado;
end;

procedure TCCSDBNomeAbreviado.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FAbreviar <> nil) and (AComponent = Abreviar) then
       Abreviar := nil;
  end;
end;


////TCCSEditLabel///////////////////////////////////
constructor TCCSEditLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAOwner := AOwner;
  FCountLabel := 0;
end;

procedure TCCSEditLabel.Loaded;
begin
  inherited Loaded;
end;

destructor TCCSEditLabel.Destroy;
begin
  inherited Destroy;
end;

procedure TCCSEditLabel.Notification(AComponent: TComponent; Operation: TOperation);
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

procedure TCCSEditLabel.SetLabel(Value : TLabel);
begin
   FLabel := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
      AssociarLabel := True;
   end;
end;

procedure TCCSEditLabel.SetAssociarLabel(Value : boolean);
{
   metodo para avisar a entrada do label e setar sua posicao junto ao edit
}
begin
   FAssociarLabel := Value;
   if Value = true then
      CriarLabel;
end;

procedure TCCSEditLabel.CriarLabel;
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

procedure TCCSEditLabel.WMMove(var Message: TWMMove);
{
   este medodo sempre ocorre qd os a janela e movimentada
}
begin
  inherited;
  if (FLabel <> nil) and (AssociarLabel) then
     AjustarLabel;
end;


procedure TCCSEditLabel.AjustarLabel;
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

procedure TCCSEditLabel.SetCaptionLabel(Value : string);
begin
   FCaptionLabel := Value;
   if (FLabel <> nil)  and (AssociarLabel) then
   begin
       FLabel.Caption := CaptionLabel;
       Ajustarlabel;
   end;
end;
procedure TCCSEditLabel.SetPosicaoLabel(Value : TPosicaoLabel);
begin
   if (Value = pTop) or (Value = pLeft) then
   begin
      FPosicaoLabel := Value;
      AjustarLabel;
   end;
end;


////TCCSDBEditLabel///////////////////////////////////
constructor TCCSDBEditLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAOwner := AOwner;
  FCountLabel := 0;
end;

procedure TCCSDBEditLabel.Loaded;
begin
  inherited Loaded;
end;

destructor TCCSDBEditLabel.Destroy;
begin
  inherited Destroy;
end;

procedure TCCSDBEditLabel.Notification(AComponent: TComponent; Operation: TOperation);
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

procedure TCCSDBEditLabel.SetLabel(Value : TLabel);
begin
   FLabel := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
      AssociarLabel := True;
   end;
end;

procedure TCCSDBEditLabel.SetAssociarLabel(Value : boolean);
{
   metodo para avisar a entrada do label e setar sua posicao junto ao edit
}
begin
   FAssociarLabel := Value;
   if Value = true then
      CriarLabel;
end;

procedure TCCSDBEditLabel.CriarLabel;
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

procedure TCCSDBEditLabel.WMMove(var Message: TWMMove);
{
   este medodo sempre ocorre qd os a janela e movimentada
}
begin
  inherited;
  if (FLabel <> nil) and (AssociarLabel) then
     AjustarLabel;
end;


procedure TCCSDBEditLabel.AjustarLabel;
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

procedure TCCSDBEditLabel.SetCaptionLabel(Value : string);
begin
   FCaptionLabel := Value;
   if (FLabel <> nil)  and (AssociarLabel) then
   begin
       FLabel.Caption := CaptionLabel;
       Ajustarlabel;
   end;
end;
procedure TCCSDBEditLabel.SetPosicaoLabel(Value : TPosicaoLabel);
begin
   if (Value = pTop) or (Value = pLeft) then
   begin
      FPosicaoLabel := Value;
      AjustarLabel;
   end;
end;



////TCCSNome///////////////////////////////////
constructor TCCSNome.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TCCSNome.Loaded;
begin
  inherited Loaded;
end;

destructor TCCSNome.Destroy;
begin
  inherited Destroy;
end;

procedure TCCSNome.Notification(AComponent: TComponent;
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

procedure TCCSNome.SetAbreviar(Value : TCustomAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCCSNome.SetFonetizar(Value : TCustomFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCCSNome.SetValue(const xValue: string);
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

////TCCSDBNome///////////////////////////////////
constructor TCCSDBNome.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CaptionLabel := 'Nome';
end;

procedure TCCSDBNome.Loaded;
begin
  inherited Loaded;
end;

destructor TCCSDBNome.Destroy;
begin
  inherited Destroy;
end;


procedure TCCSDBNome.Notification(AComponent: TComponent;
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

procedure TCCSDBNome.SetAbreviar(Value : TCustomAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCCSDBNome.SetFonetizar(Value : TCustomFonetizar);
begin
   FFonetizar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCCSDBNome.Change;
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


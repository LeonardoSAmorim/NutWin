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






unit DBMyNav;

{$R-}

interface

uses SysUtils, Windows, Messages, Classes, Controls, Forms,
  Graphics, Menus, StdCtrls, ExtCtrls, DB, DBTables, Mask,
  Buttons, DBCtrls, DBGrids, Tabs, OleCtrls  ;


const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}
  SpaceSize       =  5;   { size of space between special buttons }

type
  TMyNavButton = class;
  TMyNavDataLink = class;

  TNavState = (nFirst, nNext, nCarregando, nLocate, nNull);

  TMyNavGlyph = (ngEnabled, ngDisabled);

  TMyNavigateBtn = (nbFirst,  nbPrior,  nbNext, nbLast,
                    nbInsert, nbPost,   nbLer,  nbEdit,
                    nbDelete, nbCancel, nbFim);
  TButtonSet = set of TMyNavigateBtn;
  TMyNavButtonStyle = set of (nsAllowTimer, nsFocusRect);

  ENavClick = procedure (Sender: TObject; Button: TMyNavigateBtn) of object;
  EBeforeNavClick = procedure (Sender: TObject; Button: TMyNavigateBtn; var SkipAction : Boolean ) of object; // Wagner 20/04/2000

{ TDBMyNav }

  TDBMyNav = class (TCustomPanel)
  private
    FDataLink: TMyNavDataLink;
    FFieldDataLink: TFieldDataLink;
    FVisibleButtons: TButtonSet;
    FHints: TStrings;
    ButtonWidth: Integer;
    MinBtnSize: TPoint;
    FOnNavClick: ENavClick;
    FocusedButton: TMyNavigateBtn;
    FConfirmDelete: Boolean;

    // Componentes para auxiliar novo navigator
    FELer          : TEdit;
    FDBFoco        : TDbEdit;
    FDBGLista      : TDBGrid;
    FShowCaption   : Boolean;
    FTSAlfabeto    : TTabSet;
//    FFDLChave      : TFieldDataLink;
//    TFrm           : TForm;
//    FDBDataSet     : TBDEDataSet;
    FTable          : TTable;
    FQuery          : TQuery;
    FExcluir       : Boolean;
    State          : TNavState;
    FOnBeforeAction: EBeforeNavClick;
    FCaptions: TStrings;
    FNavButtonsStates: Boolean; 
    function GetField: TField;
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure InitHints;
    procedure InitCaptions; // wgb 14/02/2001
    procedure InitFonts; // wgb 14/02/2001
    procedure FontChanged( Sender : TObject ); // wgb 14/02/2001
    procedure Click(Sender: TObject); reintroduce;
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetVisible(Value: TButtonSet);
    procedure AdjustSize (var W: Integer; var H: Integer); reintroduce;
    procedure SetHints(Value: TStrings);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;

    // Procedimentos para setar novos componentes
    procedure SetELer(Value : TEdit);
    procedure ElerChange(Sender : TObject);
    procedure SetDBFoco(Value : TDBEdit);
    procedure SetDBGLista(Value : TDBGrid);
    procedure SetarIndex(Column: TColumn);
    procedure SetShowCaption(Value : Boolean);
    procedure ExibirCaption;
    procedure Pesquisar(Value : string);
    procedure SetTSAlfabeto(Value : TTabSet);
    procedure TSAlfabetoClick(Sender : TObject);
    procedure SetDFChave(const Value: string);
    function  GetDFChave: string;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    procedure Fim;
    procedure SetCaptions(const Value: TStrings);
    procedure SetNavButtonsStates(const Value: Boolean);
//    procedure SetTable(const Value : TTable);
//    procedure SetQuery(const Value : TQuery);

  protected
    Buttons: array[TMyNavigateBtn] of TMyNavButton;
    procedure InitButtons;
    procedure DataChanged;
    procedure EditingChanged;
    procedure ActiveChanged;
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
//    procedure GetChildren(Proc: TGetChildProc); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure BtnClick(Index: TMyNavigateBtn);
    procedure TrocarIndice(Value : string);
    property Field: TField read GetField;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property VisibleButtons: TButtonSet read FVisibleButtons write SetVisible
      default [nbFirst, nbPrior,   nbNext, nbLast,
               nbInsert, nbPost,   nbLer,  nbEdit,
               nbDelete, nbCancel, nbFim];
    property Align;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Ctl3D;
    property Hints: TStrings read FHints write SetHints;
    property Captions: TStrings read FCaptions write SetCaptions; // wgb 14/02/2001
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Font;
    property NavButtonsStates : Boolean read FNavButtonsStates write SetNavButtonsStates default True; // wgb em 15/02/2001
    property OnClick: ENavClick read FOnNavClick write FOnNavClick;
    property OnBeforeAction : EBeforeNavClick read FOnBeforeAction write FOnBeforeAction; // Wagner 20/04/2000
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnStartDrag;
    property EditLer         : TEdit       read FELer     write SetELer;
    property DBFoco          : TDbEdit     read FDBFoco   write SetDbFoco;
    property DBGLista        : TDBGrid     read FDBGLista write SetDBGLista;
    property ShowCaption     : Boolean     read FShowCaption write SetShowCaption default False;
    property TSAlfabeto      : TTabSet     read FTSAlfabeto  write SetTSAlfabeto;
    property DataField       : string      read GetDFChave   write SetDFChave;
    property Table           : TTable      read FTable       write FTable;
    property Query           : TQuery      read FQuery       write FQuery;
    property Excluir         : Boolean     read FExcluir write FExcluir default True;

 end;

{ TMyNavButton }

  TMyNavButton = class(TSpeedButton)
  private
    FIndex: TMyNavigateBtn;
    FNavStyle: TMyNavButtonStyle;
    FRepeatTimer: TTimer;
    procedure TimerExpired(Sender: TObject);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    destructor Destroy; override;
    property NavStyle: TMyNavButtonStyle read FNavStyle write FNavStyle;
    property Index : TMyNavigateBtn read FIndex write FIndex;
  end;

{ TMyNavDataLink }

  TMyNavDataLink = class(TDataLink)
  private
    FNavigator: TDBMyNav;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
  public
    constructor Create(ANav: TDBMyNav);
    destructor Destroy; override;
  end;

procedure Register;

implementation

uses DBConsts, Dialogs;

{$R BTNMYNAV}



{ TDBMyNav }

const
//  BtnStateName: array[TMyNavGlyph] of PChar = ('EN', 'DI');

  BtnTypeName: array[TMyNavigateBtn] of PChar = ('FIRST', 'PRIOR', 'NEXT',
    'LAST', 'NOVO', 'GRAVA', 'LER', 'ALTERAR', 'EXCLUI', 'CANCEL', 'FECHAR');
  TabAlfabeto : PChar = ('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

//  BtnTypeName: array[TMyNavigateBtn] of PChar = ('FIRST', 'PRIOR', 'NEXT',
//    'LAST', 'INSERT', 'POST', 'LER', 'EDIT', 'DELETE', 'CANCEL', 'FIM');

//  BtnHintId: array[TMyNavigateBtn] of Word = (SFirstRecord, SPriorRecord,
//    SNextRecord, SLastRecord, SInsertRecord, SPostEdit, SLerRecord,
//    SEditRecord, SDeleteRecord, SCancelEdit, SFimRecord);

{  BtnBitMapName: array[TMyNavigateBtn] of PChar = ('k-First', 'k-Prior', 'k-Next',
    'k-Last', 'k-Novo', 'k-grava','k-ler', 'k-altera', 'k-exclui', 'k-cancel', 'k-fechar');
}  BtnCaption: array[TMyNavigateBtn] of PChar = ('&Primeiro', 'Ante&rior', 'Pró&ximo',
    'Úl&timo', '&Incluir', '&Salvar', '&Localizar', 'E&ditar', '&Excluir', '&Cancelar', '&Fim');
  BtnHints: array[TMyNavigateBtn] of PChar = ('Primeiro Registro', 'Registro Anterior', 'Proximo Registro',
    'Ultimo Registro', 'Gera Novo Registro', 'Salva Novo Registro', 'Procura Registro', 'Edita Registro', 'Exclui Registro', 'Cancela Operacao', 'Finaliza');

{
Inicio do codigo para Novo Navigator
}

procedure Register;
begin
  RegisterComponents('Kelvis', [TDBMyNav]);
end;

  constructor TDBMyNav.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FNavButtonsStates := True; // wgb em 15/02/2001

  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  if not NewStyleControls then ControlStyle := ControlStyle + [csFramed];
  FDataLink := TMyNavDataLink.Create(Self);
  FVisibleButtons := [nbFirst,  nbPrior,  nbNext, nbLast,
                      nbInsert, nbPost,   nbLer,  nbEdit,
                      nbDelete, nbCancel, nbFim];
  FHints := TStringList.Create;
  FCaptions := TStringList.Create; // wgb em 14/02/2001
  FShowCaption := False;
  InitButtons;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  Width := 241;
  Height := 25;
  ButtonWidth := 0;
  FocusedButton := nbFirst;
  FConfirmDelete := True;
  FFieldDataLink := TFieldDataLink.Create;
  FFieldDataLink.Control := Self;
end;

destructor TDBMyNav.Destroy;
begin
  FDataLink.Free;
  FFieldDataLink.Free;
  FHints.Free;
  FCaptions.Free; // wgb em 14/02/2001
  FDataLink := nil;
  FFieldDataLink := nil;
  FTSAlfabeto := nil;
//  FFDLChave.Free;
//  FFDLChave := nil;
  inherited Destroy;
end;

procedure TDBMyNav.InitButtons;
var
  I: TMyNavigateBtn;
  Btn: TMyNavButton;
  X: Integer;
  ResName: string;
begin
  MinBtnSize := Point(20, 18);
  X := 0;
  for I := Low(Buttons) to High(Buttons) do
  begin
    Btn := TMyNavButton.Create (Self);
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);
    FmtStr(ResName, 'K-%s', [BtnTypeName[I]]);
    Btn.Glyph.Handle := LoadBitmap(HInstance, PChar(ResName));
    //ResName := 'K_NOVO';
    //Btn.Glyph.Handle := LoadBitmap(HInstance, PChar(ResName));
    //Btn.Glyph.LoadFromFile('c:\componentes\mynav\' + BtnBitMapName[I] + '.BMP');
{    Btn.Font.Name := 'Smallfonts';
    Btn.Font.Size := 6;  } // retirado por wgb 14/02/2001
    Btn.NumGlyphs := 2;
    btn.Layout := blGlyphTop;
    Btn.Enabled := False;
    Btn.Enabled := True;
    Btn.OnClick := Click;
    Btn.OnMouseDown := BtnMouseDown;
    Btn.Parent := Self;
    Buttons[I] := Btn;
    X := X + MinBtnSize.X;
  end;
  InitHints;
  InitCaptions; // wgb em 14/02/2001
  Font.Name := 'Smallfonts'; // default por wgb 14/02/2001
  Font.Size := 6; // default por wgb 14/02/2001
  InitFonts; //  wgb em 14/02/2001
  Buttons[nbPrior].NavStyle := Buttons[nbPrior].NavStyle + [nsAllowTimer];
  Buttons[nbNext].NavStyle  := Buttons[nbNext].NavStyle + [nsAllowTimer];
end;

procedure TDBMyNav.InitHints;
var
  I: Integer;
  J: TMyNavigateBtn;
begin
{
  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].Hint := LoadStr (BtnHintId[J]);
 }
  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].Hint := BtnHints[J];


  J := Low(Buttons);
  for I := 0 to (FHints.Count - 1) do
  begin
    // preenche hints com o hint de uma lista se for preenchida
    if FHints.Strings[I] <> '' then Buttons[J].Hint := FHints.Strings[I];
    if J = High(Buttons) then Exit;
    Inc(J);
  end;
end;

procedure TDBMyNav.SetHints(Value: TStrings);
begin
  FHints.Assign(Value);
  InitHints;
end;
{
procedure TDBMyNav.GetChildren(Proc: TGetChildProc);
begin
end;
}
procedure TDBMyNav.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
//  if (Operation = opRemove) and (FDataLink <> nil) and
//    (AComponent = DataSource) then DataSource := nil;
  if Operation = opRemove then
  begin
    if (FDataLink <> nil) and (AComponent = DataSource) then
       DataSource := nil;
    if (FELer <> nil) and (AComponent = EditLer) then
       EditLer := nil;
    if (FDBFoco <> nil) and (AComponent = DBFoco) then
       DBFoco := nil;
    if (FDBGLista <> nil) and (AComponent = DBGLista) then
       DBGLista := nil;
    if (FTSAlfabeto <> nil) and (AComponent = TSAlfabeto) then
       TSAlfabeto := nil;
  end;
end;

procedure TDBMyNav.SetVisible(Value: TButtonSet);
var
  I: TMyNavigateBtn;
  W, H: Integer;
begin
  W := Width;
  H := Height;
  FVisibleButtons := Value;
  for I := Low(Buttons) to High(Buttons) do
    Buttons[I].Visible := I in FVisibleButtons;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  Invalidate;
end;

procedure TDBMyNav.AdjustSize (var W: Integer; var H: Integer);
var
  Count: Integer;
  MinW: Integer;
  I: TMyNavigateBtn;
  Space, Temp, Remain: Integer;
  X: Integer;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
  begin
    if Buttons[I].Visible then
    begin
      Inc(Count);
    end;
  end;
  if Count = 0 then Inc(Count);

  MinW := Count * MinBtnSize.X;
  if W < MinW then W := MinW;
  if H < MinBtnSize.Y then H := MinBtnSize.Y;

  ButtonWidth := W div Count;
  Temp := Count * ButtonWidth;
  if Align = alNone then W := Temp;

  X := 0;
  Remain := W - Temp;
  Temp := Count div 2;
  for I := Low(Buttons) to High(Buttons) do
  begin
    if Buttons[I].Visible then
    begin
      Space := 0;
      if Remain <> 0 then
      begin
        Dec(Temp, Remain);
        if Temp < 0 then
        begin
          Inc(Temp, Count);
          Space := 1;
        end;
      end;
      Buttons[I].SetBounds(X, 0, ButtonWidth + Space, Height);
      Inc(X, ButtonWidth + Space);
    end
    else
      Buttons[I].SetBounds (Width + 1, 0, ButtonWidth, Height);
  end;
end;

procedure TDBMyNav.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TDBMyNav.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;

  { check for minimum size }
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds(Left, Top, W, H);
  Message.Result := 0;
end;

procedure TDBMyNav.Click(Sender: TObject);
begin
  BtnClick (TMyNavButton (Sender).Index);
end;

procedure TDBMyNav.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldFocus: TMyNavigateBtn;
begin
  OldFocus := FocusedButton;
  FocusedButton := TMyNavButton (Sender).Index;
  if TabStop and (GetFocus <> Handle) and CanFocus then
  begin
    SetFocus;
    if (GetFocus <> Handle) then
      Exit;
  end
  else if TabStop and (GetFocus = Handle) and (OldFocus <> FocusedButton) then
  begin
    Buttons[OldFocus].Invalidate;
    Buttons[FocusedButton].Invalidate;
  end;
end;

procedure TDBMyNav.BtnClick(Index: TMyNavigateBtn);
var // Wagner 20/04/2000 - inicio
   SkipAction : Boolean;
begin
  SkipAction := False;
  if not (csDesigning in ComponentState) and Assigned(FOnBeforeAction) then
     FOnBeforeAction(Self, Index, SkipAction);
  if (DataSource <> nil) and (DataSource.State <> dsInactive) and not(SkipAction) then // Wagner 20/04/2000 - fim
  begin
    with DataSource.DataSet do
    begin
      case Index of
        nbPrior: Prior;
        nbNext: Next;
        nbFirst: First;
        nbLast: Last;
        nbInsert: begin
                     if FDBFoco <> nil then
                        begin
                        if DBFoco.CanFocus then DBFoco.SetFocus;
                        end
                     else
                        if CanFocus then SetFocus;
                     Insert;
                  end;
        nbPost:  begin
                    Post;
//                    if (FDBGLista <> nil) and (FDBGLista.Visible = true) then
//                       DBGLista.SetFocus
//                    else
                       if CanFocus then SetFocus;
                  end;

        nbLer:   FELer.SetFocus; //Pesquisar(FELer.Text);
        nbEdit: begin
                   if FDBFoco <> nil  then
                      begin;
                      if FDBFoco.CanFocus then FDBFoco.SetFocus
                      end
                   else
                      if CanFocus then SetFocus;
                   Edit;
                end;
        nbDelete:
          if not FConfirmDelete or
            (MessageDlg('Deseja Excluir o Registro?', mtConfirmation,
            mbOKCancel, 0) <> idCancel) then Delete;
        nbCancel: Cancel;
        nbFim: Fim;
      end;
    end;
  end;
  if not (csDesigning in ComponentState) and Assigned(FOnNavClick) then
    FOnNavClick(Self, Index);
end;

procedure TDBMyNav.Fim;
begin

end;

procedure TDBMyNav.WMSetFocus(var Message: TWMSetFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TDBMyNav.WMKillFocus(var Message: TWMKillFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TDBMyNav.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewFocus: TMyNavigateBtn;
  OldFocus: TMyNavigateBtn;
begin
  OldFocus := FocusedButton;
  case Key of
    VK_RIGHT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus < High(Buttons) then
            NewFocus := Succ(NewFocus);
        until (NewFocus = High(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_LEFT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus > Low(Buttons) then
            NewFocus := Pred(NewFocus);
        until (NewFocus = Low(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_SPACE:
      begin
        if Buttons[FocusedButton].Enabled then
          Buttons[FocusedButton].Click;
      end;
  end;
end;

procedure TDBMyNav.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TDBMyNav.DataChanged;  // Alterado por wgb em 14/02/2001
var
  CanModify: Boolean;
  UpEnable, DnEnable: Boolean;
begin
  // Verifica se o ponteiro de leitura e gravacao esta no inico ou fim
  UpEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.BOF and not FDataLink.Editing;;
  DnEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.EOF and not FDataLink.Editing;;
  CanModify := Enabled and FDataLink.Active and FDataLink.DataSet.CanModify;

if FNavButtonsStates then
begin
  Buttons[nbFirst].Enabled := UpEnable;
  Buttons[nbPrior].Enabled := UpEnable;
  Buttons[nbNext].Enabled := DnEnable;
  Buttons[nbLast].Enabled := DnEnable;

  Buttons[nbDelete].Enabled := Enabled and FDataLink.Active and
    FDataLink.DataSet.CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF);
  Buttons[nbLer].Enabled := Enabled and FDataLink.Active and
    FDataLink.DataSet.CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF);
  Buttons[nbFim].Enabled := True;
end
else
begin
  Buttons[nbFirst].Enabled := UpEnable;
  Buttons[nbPrior].Enabled := UpEnable;
  Buttons[nbNext].Enabled := DnEnable;
  Buttons[nbLast].Enabled := DnEnable;

  Buttons[nbEdit].Enabled   := CanModify and not FDataLink.DataSet.IsEmpty and not FDataLink.Editing;;
  Buttons[nbInsert].Enabled := CanModify and not FDataLink.Editing;
  Buttons[nbDelete].Enabled := CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF)
    and not FDataLink.Editing;
  Buttons[nbLer].Enabled := CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF)
    and not FDataLink.Editing;
  Buttons[nbFim].Enabled := CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF)
    and not FDataLink.Editing;
end;

end;

procedure TDBMyNav.EditingChanged; // Alterado por wgb em 14/02/2001
var
  CanModify: Boolean;
  UpEnable, DnEnable: Boolean;
begin

  // Verifica se o ponteiro de leitura e gravacao esta no inico ou fim
  UpEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.BOF and not FDataLink.Editing;;
  DnEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.EOF and not FDataLink.Editing;;
  CanModify := Enabled and FDataLink.Active and FDataLink.DataSet.CanModify;

if FNavButtonsStates then
begin
  Buttons[nbInsert].Enabled := CanModify;
  Buttons[nbEdit].Enabled   := CanModify and not FDataLink.Editing;
  Buttons[nbPost].Enabled   := CanModify and FDataLink.Editing;
  Buttons[nbCancel].Enabled := CanModify and FDataLink.Editing;
end
else
begin
  Buttons[nbFirst].Enabled := UpEnable;
  Buttons[nbPrior].Enabled := UpEnable;
  Buttons[nbNext].Enabled := DnEnable;
  Buttons[nbLast].Enabled := DnEnable;

  Buttons[nbInsert].Enabled := CanModify and not FDataLink.Editing;
  Buttons[nbEdit].Enabled   := CanModify and not FDataLink.Editing and not FDataLink.DataSet.IsEmpty;
  Buttons[nbPost].Enabled   := CanModify and FDataLink.Editing;
  Buttons[nbCancel].Enabled := CanModify and FDataLink.Editing;

  Buttons[nbDelete].Enabled := CanModify and not FDataLink.Editing and not FDataLink.DataSet.IsEmpty;
  Buttons[nbLer].Enabled := CanModify and not FDataLink.Editing and not FDataLink.DataSet.IsEmpty;
  Buttons[nbFim].Enabled := CanModify and not FDataLink.Editing and not FDataLink.DataSet.IsEmpty;
end;

end;

procedure TDBMyNav.ActiveChanged;
var
  I: TMyNavigateBtn;
begin
  if not (Enabled and FDataLink.Active) then
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Enabled := False
  else
  begin
    DataChanged;
    EditingChanged;
  end;
end;

procedure TDBMyNav.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    ActiveChanged;
end;

procedure TDBMyNav.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  FFieldDataLink.DataSource := Value;
//  FFDLChave.DataSource := Value;
  if not (csLoading in ComponentState) then
    ActiveChanged;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDBMyNav.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBMyNav.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  InitHints;
  InitCaptions; // wgb em 14/02/2001
  ActiveChanged;
end;



procedure TDBMyNav.SetELer(Value : TEdit);
{
Procedimento para setar o novo campo edit para ser utilizado na pesquisa
}
begin
  FEler := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
      Value.OnChange := ELerChange;
   end;
end;

procedure TDBMyNav.ELerChange(Sender : TObject);
{
Esta procedure sera excultada sempre que o conteudo do eidt for alterado
}
begin
   Pesquisar(FEler.Text);
end;

procedure TDBMyNav.SetDBFoco(Value : TDBEdit);
{
Procedimento para setar o novo campo edit para ser utilizado na pesquisa
}
begin
  FDBFoco := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TDBMyNav.SetDBGLista(Value : TDBGrid);
{
Procedimento para setar o novo campo edit para ser utilizado na pesquisa
}
begin
  FDBGLista := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
      Value.OnTitleClick := SetarIndex; //para mudar o campo chave

   end;
end;

procedure TDBMyNav.SetarIndex(Column: TColumn);
{
    Metodo para trocar o indice para pesquiza apartir de um TColumn
}
begin
   TrocarIndice(Column.FieldName);
end;

procedure TDBMyNav.TrocarIndice(Value : string);
begin
   FFieldDataLink.FieldName := Value;
   if (DataSource <> nil) and  (DataSource.DataSet is TTable) then
   begin
      try
        (DataSource.DataSet as TTable).IndexFieldNames := Value;
      except
        (DataSource.DataSet as TTable).Cancel;
      end;
   end;
end;
procedure TDBMyNav.SetShowCaption(Value : Boolean);
{
Procedimento para setar o se sera exibido os captions dos botoes ou nao
}
begin
  FShowCaption := Value;
  InitCaptions;
  InitFonts;
  ExibirCaption;
end;

procedure TDBMyNav.ExibirCaption;
var
  I: TMyNavigateBtn;
begin
  for I := Low(Buttons) to High(Buttons) do
  begin
    if ShowCaption then
       Buttons[i].Caption := BtnCaption[I]
    else
       Buttons[i].Caption := '';
{    Buttons[i].Font.Name := 'Smallfonts';
    Buttons[i].Font.Size := 6; } // retirado por wgb 14/02/2001
  end;
  InitFonts;
end;

procedure TDBMyNav.SetTSAlfabeto(Value : TTabSet);
{
Procedimento para setar o novo campo edit para ser utilizado na pesquisa
}
var
   IndAlfabeto : integer;
begin
  FTSAlfabeto := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
      Value.OnClick := TSAlfabetoClick;
      Value.Tabs.Clear;
      for IndAlfabeto := 0 to 25 do
      begin
          Value.Tabs.add(TabAlfabeto[IndAlfabeto]);
      end;
      State := nCarregando;
      Value.TabIndex := 0;
      State := nNull;
      //      Value.Tabs.LoadFromFile('c:\componentes\mynav\alfabeto.txt');
   end;

end;

procedure TDBMyNav.TSAlfabetoClick(Sender : TObject);
{
Esta procedure sera sempre execultada quando ocorrer um click no TabSet
}
var
   LetraInicial : string;
   PointLetra   : integer;
begin
   PointLetra := TSAlfabeto.TabIndex;
   LetraInicial := TSAlfabeto.Tabs [PointLetra];
   Pesquisar(LetraInicial);
end;


procedure TDBMyNav.Pesquisar(Value : string);
var
//  LocateSuccess: Boolean;
  SearchOptions: TLocateOptions;
//  xChave       : String;
begin
   if State = nCarregando then exit;
   SearchOptions := [loPartialKey, loCaseInsensitive];
   if DataSource.DataSet <> nil then
   begin
      with DataSource.DataSet do
      begin
         // try para verificar se o conteudo do campo e valido
         try
           //LocateSuccess :=
           Locate(DataField, Value,  SearchOptions);
           if DBGLista <> nil then
              DBGLista.Refresh;
         except
           ShowMessage('Dados Invalidos para Consulta!');
         end;
      end;
   end;
end;

procedure TDBMyNav.SetDFChave(const Value: string);
begin
   // Chama rotina para corrigir novo indice para os dataware
   TrocarIndice(Value);
end;

function TDBMyNav.GetDFChave: string;
begin
   Result := FFieldDataLink.FieldName;
end;

procedure TDBMyNav.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FFieldDataLink);
end;

function TDBMyNav.GetField: TField;
begin
  Result := FFieldDataLink.Field;
end;


{ Não está sendo usado, quem sabe no futuro...
procedure TDBMyNav.SetTable(const Value : TTable);
begin
  if FQuery = nil then
  begin
     FTable := Value;
     if Value <> nil then
     begin
        Value.FreeNotification(Self);
     end;
  end;
end;

procedure TDBMyNav.SetQuery(const Value : TQuery);
begin
  if FTable = nil then
  begin
     FQuery := Value;
     if Value <> nil then
     begin
        Value.FreeNotification(Self);
     end;
  end;
end; }



{--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--}



procedure TDBMyNav.InitCaptions; // wgb em 14/02/2001
var
  I: Integer;
  J: TMyNavigateBtn;
begin

  if not ShowCaption then
     exit;

  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].Caption := BtnCaption[J];


  J := Low(Buttons);
  for I := 0 to (FCaptions.Count - 1) do
  begin
    // preenche hints com o hint de uma lista se for preenchida
    if FCaptions.Strings[I] <> '' then Buttons[J].Caption := FCaptions.Strings[I];
    if J = High(Buttons) then Exit;
    Inc(J);
  end;
end;

procedure TDBMyNav.SetCaptions(const Value: TStrings);
begin
  FCaptions.Assign(Value);
  InitCaptions;
end;

procedure TDBMyNav.InitFonts;
var
  I: TMyNavigateBtn;
begin
  if not Assigned( Font.OnChange ) then
     Font.OnChange := FontChanged;
  for I := Low(Buttons) to High(Buttons) do
  begin
    Buttons[I].Font.Assign( Font );
  end;
end;

procedure TDBMyNav.FontChanged(Sender: TObject);
begin
   InitFonts;
end;

procedure TDBMyNav.SetNavButtonsStates(const Value: Boolean);
begin
  FNavButtonsStates := Value;
  DataChanged;
  EditingChanged;
end;

{TMyNavButton}

destructor TMyNavButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TMyNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  if nsAllowTimer in FNavStyle then
  begin
    if FRepeatTimer = nil then
      FRepeatTimer := TTimer.Create(Self);

    FRepeatTimer.OnTimer := TimerExpired;
    FRepeatTimer.Interval := InitRepeatPause;
    FRepeatTimer.Enabled  := True;
  end;
end;

procedure TMyNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
end;

procedure TMyNavButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := RepeatPause;
  if (FState = bsDown) and MouseCapture then
  begin
    try
      Click;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

procedure TMyNavButton.Paint;
var
  R: TRect;
begin
  inherited Paint;
  if (GetFocus = Parent.Handle) and
     (FIndex = TDBMyNav (Parent).FocusedButton) then
  begin
    R := Bounds(0, 0, Width, Height);
    InflateRect(R, -3, -3);
    if FState = bsDown then
      OffsetRect(R, 1, 1);
    DrawFocusRect(Canvas.Handle, R);
  end;
end;

{ TMyNavDataLink }

constructor TMyNavDataLink.Create(ANav: TDBMyNav);
begin
  inherited Create;
  FNavigator := ANav;
end;

destructor TMyNavDataLink.Destroy;
begin
  FNavigator := nil;
  inherited Destroy;
end;

procedure TMyNavDataLink.EditingChanged;
begin
  if FNavigator <> nil then FNavigator.EditingChanged;
end;

procedure TMyNavDataLink.DataSetChanged;
begin
  if FNavigator <> nil then FNavigator.DataChanged;
end;

procedure TMyNavDataLink.ActiveChanged;
begin
  if FNavigator <> nil then FNavigator.ActiveChanged;
end;


end.

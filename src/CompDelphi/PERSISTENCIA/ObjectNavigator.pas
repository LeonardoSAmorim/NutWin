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




unit ObjectNavigator;
{ ****************************************************************** }
{                                                                    }
{   ObjectNavigator.pas                                              }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Marco/1999                                                    }
{                                                                    }
{ ****************************************************************** }

{$R-}

interface

uses SysUtils, Windows, Messages, Classes, Controls, Forms,
  Graphics, Menus, StdCtrls, ExtCtrls, DB, DBTables, Mask,
  Buttons, DBCtrls, DBGrids, Tabs, OleCtrls, PersistentCollection, CompFactExcept;


const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}
  SpaceSize       =  5;   { size of space between special buttons }

type
  TObjectNavButton = class;
  TObjectNavDataLink = class;

  TObjectNavState = (nFirst, nNext, nCarregando, nLocate, nNull);

  TObjectNavGlyph = (ngEnabled, ngDisabled);

  TObjectNavigateBtn = (nbFirst,  nbPrior,  nbNext, nbLast,
                    nbInsert, nbPost,   nbLer,  nbEdit,
                    nbDelete, nbCancel, nbApplyUpdates, nbCancelUpdates, nbFim);
  TButtonSet = set of TObjectNavigateBtn;
  TObjectNavButtonStyle = set of (nsAllowTimer, nsFocusRect);

  EObjectNavClick = procedure (Sender: TObject; Button: TObjectNavigateBtn) of object;

{ TObjectNavigator }

  TObjectNavigator = class (TCustomPanel)
  private
    FDataLink: TObjectNavDataLink;
    FFieldDataLink: TFieldDataLink;
    FVisibleButtons: TButtonSet;
    FHints: TStrings;
    ButtonWidth: Integer;
    MinBtnSize: TPoint;
    FOnNavClick: EObjectNavClick;
    FocusedButton: TObjectNavigateBtn;
    FConfirmDelete: Boolean;
    // Componentes para auxiliar novo navigator
    FELer          : TEdit;
    FDBFoco        : TDbEdit;
    FDBGLista      : TDBGrid;
    FShowCaption   : Boolean;
    FTSAlfabeto    : TTabSet;
    FFDLChave      : TFieldDataLink;
    TFrm           : TForm;
    FDBDataSet     : TBDEDataSet;
    FTable          : TTable;
    FQuery          : TQuery;
    FExcluir       : Boolean;
    State          : TObjectNavState;
    FOnFim: TNotifyEvent;
    FDataChangeAux : TDataChangeEvent;
    FChangeExterno: Boolean;
    function GetField: TField;
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure InitButtons;
    procedure InitHints;
    procedure Click(Sender: TObject);
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetVisible(Value: TButtonSet);
    procedure AdjustSize (var W: Integer; var H: Integer);
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
    procedure SetTable(const Value : TTable);
    procedure SetQuery(const Value : TQuery);
    procedure DSChange(Sender: TObject; Field: TField);
    procedure SetOnFim(const Value: TNotifyEvent);
    procedure SetChangeExterno(const Value: Boolean);


  protected
    Buttons: array[TObjectNavigateBtn] of TObjectNavButton;
    procedure DataChanged;
    procedure EditingChanged;
    procedure ActiveChanged;
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property ChangeExterno : Boolean read FChangeExterno write SetChangeExterno;
//    procedure GetChildren(Proc: TGetChildProc); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure BtnClick(Index: TObjectNavigateBtn);
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
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick: EObjectNavClick read FOnNavClick write FOnNavClick;
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
    property OnFim : TNotifyEvent read FOnFim write SetOnFim;

 end;

{ TObjectNavButton }

  TObjectNavButton = class(TSpeedButton)
  private
    FIndex: TObjectNavigateBtn;
    FNavStyle: TObjectNavButtonStyle;
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
    property NavStyle: TObjectNavButtonStyle read FNavStyle write FNavStyle;
    property Index : TObjectNavigateBtn read FIndex write FIndex;
  end;

{ TObjectNavDataLink }

  TObjectNavDataLink = class(TDataLink)
  private
    FNavigator: TObjectNavigator;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
  public
    constructor Create(ANav: TObjectNavigator);
    destructor Destroy; override;
  end;

procedure Register;

implementation

uses DBConsts, Dialogs;

{$R BTNObjectNavigator}



{ TObjectNavigator }

const
  BtnStateName: array[TObjectNavGlyph] of PChar = ('EN', 'DI');

  BtnTypeName: array[TObjectNavigateBtn] of PChar = ('FIRST', 'PRIOR', 'NEXT',
    'LAST', 'NOVO', 'GRAVA', 'LER', 'ALTERA', 'EXCLUI', 'CANCELA', 'APPLYUPDATES', 'CANCELUPDATES', 'FECHAR');
  TabAlfabeto : PChar = ('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

//  BtnTypeName: array[TObjectNavigateBtn] of PChar = ('FIRST', 'PRIOR', 'NEXT',
//    'LAST', 'INSERT', 'POST', 'LER', 'EDIT', 'DELETE', 'CANCEL', 'FIM');

//  BtnHintId: array[TObjectNavigateBtn] of Word = (SFirstRecord, SPriorRecord,
//    SNextRecord, SLastRecord, SInsertRecord, SPostEdit, SLerRecord,
//    SEditRecord, SDeleteRecord, SCancelEdit, SFimRecord);

  BtnCaption: array[TObjectNavigateBtn] of PChar = ('', '', '',
    '', '&Novo', '&Salva', '&Ler', '&Altera', '&Exclui', '&Cancela', 'Apl. Update', 'Can. Update', '&Fechar');
  BtnHints: array[TObjectNavigateBtn] of PChar = ('Primeiro Registro', 'Registro Anterior', 'Proximo Registro',
    'Ultimo Registro', 'Gera Novo Registro', 'Salva Novo Registro', 'Procura Registro', 'Altera Registro', 'Exclui Registro', 'Cancela Operacao', 'ATUALIZAR ALTERACOES', 'CANCELAR ALTERACOES', 'Finaliza');

{
Inicio do codigo para Novo Navigator
}

procedure Register;
begin
  RegisterComponents('Persistencia', [TObjectNavigator]);
end;

  constructor TObjectNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  if not NewStyleControls then ControlStyle := ControlStyle + [csFramed];
  FDataLink := TObjectNavDataLink.Create(Self);
  FVisibleButtons := [nbFirst,  nbPrior,  nbNext, nbLast,
                      nbInsert, nbPost,   nbLer,  nbEdit,
                      nbDelete, nbCancel, nbFim];
  FHints := TStringList.Create;
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

destructor TObjectNavigator.Destroy;
begin
  if assigned(FFieldDataLink) and assigned(FFieldDataLink.DataSource) then
     FFieldDataLink.DataSource.OnDataChange :=  FDataChangeAux;
  FDataLink.Free;
  FFieldDataLink.Free;
  FHints.Free;
  FDataLink := nil;
  FFieldDataLink := nil;
  FTSAlfabeto := nil;

//  FFDLChave.Free;
//  FFDLChave := nil;
  inherited Destroy;
end;

procedure TObjectNavigator.InitButtons;
var
  I: TObjectNavigateBtn;
  Btn: TObjectNavButton;
  X: Integer;
  ResName: string;
begin
  MinBtnSize := Point(20, 18);
  X := 0;
  for I := Low(Buttons) to High(Buttons) do
  begin
    Btn := TObjectNavButton.Create (Self);
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);
    FmtStr(ResName, 'ON-%s', [BtnTypeName[I]]);
    Btn.Glyph.Handle := LoadBitmap(HInstance, PChar(ResName));
    //ResName := 'K_NOVO';
    //Btn.Glyph.Handle := LoadBitmap(HInstance, PChar(ResName));
    //Btn.Glyph.LoadFromFile('c:\componentes\ObjectNav\' + BtnBitMapName[I] + '.BMP');
    Btn.Font.Name := 'Smallfonts';
    Btn.Font.Size := 6;
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
  Buttons[nbPrior].NavStyle := Buttons[nbPrior].NavStyle + [nsAllowTimer];
  Buttons[nbNext].NavStyle  := Buttons[nbNext].NavStyle + [nsAllowTimer];
end;

procedure TObjectNavigator.InitHints;
var
  I: Integer;
  J: TObjectNavigateBtn;
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

procedure TObjectNavigator.SetHints(Value: TStrings);
begin
  FHints.Assign(Value);
  InitHints;
end;
{
procedure TObjectNavigator.GetChildren(Proc: TGetChildProc);
begin
end;
}
procedure TObjectNavigator.Notification(AComponent: TComponent;
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

procedure TObjectNavigator.SetVisible(Value: TButtonSet);
var
  I: TObjectNavigateBtn;
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

procedure TObjectNavigator.AdjustSize (var W: Integer; var H: Integer);
var
  Count: Integer;
  MinW: Integer;
  I: TObjectNavigateBtn;
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

procedure TObjectNavigator.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TObjectNavigator.WMSize(var Message: TWMSize);
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

procedure TObjectNavigator.Click(Sender: TObject);
begin
  BtnClick (TObjectNavButton (Sender).Index);
end;

procedure TObjectNavigator.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldFocus: TObjectNavigateBtn;
begin
  OldFocus := FocusedButton;
  FocusedButton := TObjectNavButton (Sender).Index;
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

procedure TObjectNavigator.BtnClick(Index: TObjectNavigateBtn);
begin
  if (DataSource <> nil) and (DataSource.State <> dsInactive) then
  begin
    with TBDEDataSet(DataSource.DataSet) do
    begin
      case Index of
        nbPrior: Prior;
        nbNext: Next;
        nbFirst: First;
        nbLast: Last;
        nbInsert: begin
                     if FDBFoco <> nil then
                        DBFoco.SetFocus
                     else
                        SetFocus;
                     Insert;
                  end;
        nbPost:  begin
                    Post;
//                    if (FDBGLista <> nil) and (FDBGLista.Visible = true) then
//                       DBGLista.SetFocus
//                    else
                       SetFocus;
                  end;

        nbLer:   FELer.SetFocus; //Pesquisar(FELer.Text);
        nbEdit: begin
                   if FDBFoco <> nil  then
                      FDBFoco.SetFocus
                   else
                      SetFocus;
                   Edit;
                end;
        nbDelete:
          if not FConfirmDelete or
            (MessageDlg('Deseja Excluir o Registro?', mtConfirmation,
            mbOKCancel, 0) <> idCancel) then Delete;
        nbCancel: Cancel;
        nbFim: if Assigned(FOnFim) then FOnFim(self);
        nbApplyUpdates :
        begin
          try
            ApplyUpdates;
            CommitUpdates;
          except
            on h2 : TEGeral do
            begin
              ShowMessage('Erro ao Atualizar objeto com erro ' + h2.message);
              CancelUpdates;
              edit;
            end;
          end;
        end;
        nbCancelUpdates : CancelUpdates;
      end;
    end;
  end;
  if not (csDesigning in ComponentState) and Assigned(FOnNavClick) then
    FOnNavClick(Self, Index);
end;

procedure TObjectNavigator.Fim;
begin

end;

procedure TObjectNavigator.WMSetFocus(var Message: TWMSetFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TObjectNavigator.WMKillFocus(var Message: TWMKillFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TObjectNavigator.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewFocus: TObjectNavigateBtn;
  OldFocus: TObjectNavigateBtn;
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

procedure TObjectNavigator.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TObjectNavigator.DataChanged;
var
  UpEnable, DnEnable: Boolean;
begin
  // Ferifica se o ponteiro de leitura e gravacao esta no inico ou fim
  UpEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.BOF;
  DnEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.EOF;
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
  Buttons[nbApplyUpdates].Enabled := True;
  Buttons[nbCAncelUpdates].Enabled := True;

end;

procedure TObjectNavigator.EditingChanged;
var
  CanModify: Boolean;
begin
  CanModify := Enabled and FDataLink.Active and FDataLink.DataSet.CanModify;
  Buttons[nbInsert].Enabled := CanModify;
  Buttons[nbEdit].Enabled   := CanModify and not FDataLink.Editing;
  Buttons[nbPost].Enabled   := CanModify and FDataLink.Editing;
  Buttons[nbCancel].Enabled := CanModify and FDataLink.Editing;
end;

procedure TObjectNavigator.ActiveChanged;
var
  I: TObjectNavigateBtn;
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

procedure TObjectNavigator.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    ActiveChanged;
end;

procedure TObjectNavigator.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  FFieldDataLink.DataSource := Value;
  if assigned(Value) then
  begin
    FDataChangeAux := FFieldDataLink.DataSource.OnDataChange;
    FFieldDataLink.DataSource.OnDataChange := DSChange;
    if not (csLoading in ComponentState) then
       ActiveChanged;
    Value.FreeNotification(Self);
  end;
end;

function TObjectNavigator.GetDataSource: TDataSource;
begin
  if Assigned(FDataLink) then
     Result := FDataLink.DataSource
  else
     Result := nil;
end;

procedure TObjectNavigator.DSChange(Sender: TObject; Field: TField);
var
  FieldAux : string;
  TabIndexAux : integer;
  TabIndexAux2 : integer;
begin
    if assigned(DataSource) and assigned(DataSource.DataSet) then
    begin
      ChangeExterno := True;
      if assigned(TSAlfabeto) then
      begin
         if not ((DataSource.State = dsInsert) or (DataSource.State = dsEdit)) then
         begin
            TabIndexAux2 := TSAlfabeto.TabIndex;
            if DataField <> '' then
            begin
              FieldAux := DataSource.DataSet.FieldByName(DataField).AsString;
              if FieldAux <> '' then
              begin
                 try
                    TabIndexAux := TSAlfabeto.Tabs.IndexOf(FieldAux[1]);
                    if TabIndexAux <> -1 then
                       TSAlfabeto.TabIndex := TSAlfabeto.Tabs.IndexOf(FieldAux[1]);
                 except
                    TSAlfabeto.TabIndex := TabIndexAux2;
                 end;
              end;
            end;
         end;
      end;
      ChangeExterno := False;
    end;
end;

procedure TObjectNavigator.Loaded;
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
  ActiveChanged;
end;



procedure TObjectNavigator.SetELer(Value : TEdit);
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

procedure TObjectNavigator.ELerChange(Sender : TObject);
{
Esta procedure sera excultada sempre que o conteudo do eidt for alterado
}
begin
   Pesquisar(FEler.Text);
end;

procedure TObjectNavigator.SetDBFoco(Value : TDBEdit);
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

procedure TObjectNavigator.SetDBGLista(Value : TDBGrid);
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

procedure TObjectNavigator.SetarIndex(Column: TColumn);
{
    Metodo para trocar o indice para pesquiza apartir de um TColumn
}
begin
   TrocarIndice(Column.FieldName);
end;

procedure TObjectNavigator.TrocarIndice(Value : string);
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
procedure TObjectNavigator.SetShowCaption(Value : Boolean);
{
Procedimento para setar o se sera exibido os captions dos botoes ou nao
}
begin
  FShowCaption := Value;
  ExibirCaption;
end;

procedure TObjectNavigator.ExibirCaption;
var
  I: TObjectNavigateBtn;
begin
  for I := Low(Buttons) to High(Buttons) do
  begin
    if ShowCaption then
       Buttons[i].Caption := BtnCaption[I]
    else
       Buttons[i].Caption := '';
    Buttons[i].Font.Name := 'Smallfonts';
    Buttons[i].Font.Size := 6;
  end;
end;

procedure TObjectNavigator.SetTSAlfabeto(Value : TTabSet);
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
      //      Value.Tabs.LoadFromFile('c:\componentes\ObjectNav\alfabeto.txt');
   end;

end;

procedure TObjectNavigator.TSAlfabetoClick(Sender : TObject);
{
Esta procedure sera sempre execultada quando ocorrer um click no TabSet
}
var
   LetraInicial : string;
   PointLetra   : integer;
   PointLetraAux : integer;
begin
   PointLetraAux := TSAlfabeto.TabIndex;
   PointLetra := TSAlfabeto.TabIndex;
   try
     LetraInicial := TSAlfabeto.Tabs [PointLetra];
   except
     TSAlfabeto.TabIndex :=  PointLetraAux;
     LetraInicial := TSAlfabeto.Tabs [PointLetraAux];
   end;
   if not ChangeExterno then
      Pesquisar(LetraInicial);
end;


procedure TObjectNavigator.Pesquisar(Value : string);
var
  LocateSuccess: Boolean;
  SearchOptions: TLocateOptions;
  xChave       : String;
begin
   if State = nCarregando then exit;
   SearchOptions := [loPartialKey, loCaseInsensitive];
   if DataSource.DataSet <> nil then
   begin
      with DataSource.DataSet do
      begin
         // try para verificar se o conteudo do campo e valido
         try
           LocateSuccess := Locate(DataField, Value,  SearchOptions);
           if DBGLista <> nil then
              DBGLista.Refresh;
         except
           ShowMessage('Dados Invalidos para Consulta!');
         end;
      end;
   end;
end;

procedure TObjectNavigator.SetDFChave(const Value: string);
begin
   // Chama rotina para corrigir novo indice para os dataware
   TrocarIndice(Value);
end;

function TObjectNavigator.GetDFChave: string;
begin
   Result := FFieldDataLink.FieldName;
end;

procedure TObjectNavigator.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FFieldDataLink);
end;

function TObjectNavigator.GetField: TField;
begin
  Result := FFieldDataLink.Field;
end;


procedure TObjectNavigator.SetTable(const Value : TTable);
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

procedure TObjectNavigator.SetQuery(const Value : TQuery);
begin
  if FTable = nil then
  begin
     FQuery := Value;
     if Value <> nil then
     begin
        Value.FreeNotification(Self);
     end;
  end;
end;



{--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--}



procedure TObjectNavigator.SetOnFim(const Value: TNotifyEvent);
begin
  FOnFim := Value;
end;

procedure TObjectNavigator.SetChangeExterno(const Value: Boolean);
begin
  FChangeExterno := Value;
end;

{TObjectNavButton}

destructor TObjectNavButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TObjectNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

procedure TObjectNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
end;

procedure TObjectNavButton.TimerExpired(Sender: TObject);
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

procedure TObjectNavButton.Paint;
var
  R: TRect;
begin
  inherited Paint;
  if (GetFocus = Parent.Handle) and
     (FIndex = TObjectNavigator (Parent).FocusedButton) then
  begin
    R := Bounds(0, 0, Width, Height);
    InflateRect(R, -3, -3);
    if FState = bsDown then
      OffsetRect(R, 1, 1);
    DrawFocusRect(Canvas.Handle, R);
  end;
end;

{ TObjectNavDataLink }

constructor TObjectNavDataLink.Create(ANav: TObjectNavigator);
begin
  inherited Create;
  FNavigator := ANav;
end;

destructor TObjectNavDataLink.Destroy;
begin
  FNavigator := nil;
  inherited Destroy;
end;

procedure TObjectNavDataLink.EditingChanged;
begin
  if FNavigator <> nil then FNavigator.EditingChanged;
end;

procedure TObjectNavDataLink.DataSetChanged;
begin
  if FNavigator <> nil then FNavigator.DataChanged;
end;

procedure TObjectNavDataLink.ActiveChanged;
begin
  if FNavigator <> nil then FNavigator.ActiveChanged;
end;


end.

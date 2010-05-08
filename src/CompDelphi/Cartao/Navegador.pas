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




unit Navegador;
{ ****************************************************************** }
{                                                                    }
{   Navegador.pas                                                    }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Outubro/1998                                                  }
{                                                                    }
{ ****************************************************************** }

{$R-}

interface

uses SysUtils, Windows, Messages, Classes, Controls, Forms, Graphics, Menus,
     StdCtrls, ExtCtrls, DB, DBTables, Mask, Buttons, DBCtrls, DBGrids, Tabs,
     OleCtrls, CCSListaLinks,VCFonAbv, CNSDBSUS, DsgnIntf, CNSConnect, conector;


const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}
  SpaceSize       =  5;   { size of space between special buttons }

type
  TCustomNavegadorButton = class;

  TNavegadorState = (nFirst, nNext, nCarregando, nLocate, nNull);

  TCustomNavegadorGlyph = (ngEnabled, ngDisabled);

  TCustomNavegadorBtn = (nbFirst,  nbPrior,  nbNext, nbLast,
                         nbInsert, nbPost,   nbLer,  nbEdit,
                         nbDelete, nbCancel, nbImprimir, nbFim);

  TNavegadorButtonSet = set of TCustomNavegadorBtn;

  TCustomNavegadorButtonStyle = set of (nsAllowTimer, nsFocusRect);

  ENavegadorClick = procedure (Sender: TObject; Button: TCustomNavegadorBtn) of object;

{ TCustomNavegador }

  TCustomNavegador = class (TCustomPanel)
  private
    FLink : TCCSLink;
    FDataLink: TDataLink;
    FVisibleButtons: TNavegadorButtonSet;
    FHints: TStrings;
    ButtonWidth: Integer;
    MinBtnSize: TPoint;
    FOnNavClick: ENavegadorClick;
    FocusedButton: TCustomNavegadorBtn;
    FConfirmDelete: Boolean;
    // Componentes para auxiliar novo navigator
    FParam1 : string;
    FParam2 : string;
    FParam3 : string;
    FParam4 : string;
    FkeyField : string;
    FKeySelecionado : string;
    FControl : TCustomDB;
    FDataSource : TDataSource;
    FProcurar : TCustomEdit;
    FFoco : TCustomEdit;
    FListaPesquiza : TDBGrid;
    FShowCaption : Boolean;
    FAlfabeto : TTabSet;
    FTable : TTable;
    FQuery : TQuery;
    FExcluir : Boolean;
    State : TNavegadorState;
    FOnFim : TNotifyEvent;
    FOnImprimir : TNotifyEvent;
    FMenuControl : TCustomMenuControl;
    procedure InitDataSource;
    procedure SetContros;
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure InitButtons;
    procedure InitHints;
    procedure Click(Sender: TObject);
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetVisible(Value: TNavegadorButtonSet);
    procedure AdjustSize (var W: Integer; var H: Integer);
    procedure SetHints(Value: TStrings);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;

    // Procedimentos para setar novos componentes
    procedure SetProcurar(Value : TCustomEdit);
    procedure ProcurarChange(Sender : TObject);
    procedure SetFoco(Value : TCustomEdit);
    procedure SetListaPesquiza(Value : TDBGrid);
    procedure SetarIndex(Column: TColumn);
    procedure SetShowCaption(Value : Boolean);
    procedure ExibirCaption;
    procedure Pesquisar(Value : string);
    procedure SetAlfabeto(Value : TTabSet);
    procedure AlfabetoClick(Sender : TObject);
    procedure Fim;
    procedure DSChange(Sender: TObject; Field: TField);
    procedure SetControl(Value : TCustomDB);
    procedure RefazQuery;
    procedure SetkeyField(Value : string);
    procedure SetMenuControl(Value : TCustomMenuControl);

  protected
    Buttons: array[TCustomNavegadorBtn] of TCustomNavegadorButton;
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
    procedure BtnClick(Index: TCustomNavegadorBtn);
    procedure TrocarIndice(Value : string);
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  published
    property VisibleButtons: TNavegadorButtonSet read FVisibleButtons write SetVisible
      default [nbFirst, nbPrior,   nbNext, nbLast,
               nbInsert, nbPost,   nbLer,  nbEdit,
               nbDelete, nbCancel, nbImprimir, nbFim];
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
    property OnClick: ENavegadorClick read FOnNavClick write FOnNavClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnStartDrag;
    property Procurar : TCustomEdit read FProcurar write SetProcurar;
    property Foco : TCustomEdit read FFoco write SetFoco;
    property ListaPesquiza : TDBGrid read FListaPesquiza write SetListaPesquiza;
    property ShowCaption : Boolean read FShowCaption write SetShowCaption default False;
    property Alfabeto : TTabSet read FAlfabeto  write SetAlfabeto;
    property Excluir : Boolean read FExcluir write FExcluir default True;
    property Control : TCustomDB read FControl write SetControl;
    property Param1 : string read FParam1 write FParam1;
    property Param2 : string read FParam2 write FParam2;
    property Param3 : string read FParam3 write FParam3;
    property Param4 : string read FParam4 write FParam4;
    property KeyField : string read FkeyField write SetKeyField;
    property OnFim : TNotifyEvent read FOnFim write FOnFim;
    property OnImprimir : TNotifyEvent read FOnImprimir write FOnImprimir;
    property MenuControl : TCustomMenuControl read FMenuControl write FMenuControl;

 end;

{ TCustomNavegadorButton }

  TCustomNavegadorButton = class(TSpeedButton)
  private
    FIndex: TCustomNavegadorBtn;
    FNavStyle: TCustomNavegadorButtonStyle;
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
    property NavStyle: TCustomNavegadorButtonStyle read FNavStyle write FNavStyle;
    property Index : TCustomNavegadorBtn read FIndex write FIndex;
  end;


  TCustomDBProperty = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;

procedure Register;

implementation

uses DBConsts, Dialogs;


{$R BTNNAVEGADOR}

{ TCustomNavegador }

const
  BtnStateName: array[TCustomNavegadorGlyph] of PChar = ('EN', 'DI');

  BtnTypeName: array[TCustomNavegadorBtn] of PChar = ('FIRST', 'PRIOR', 'NEXT',
    'LAST', 'NOVO', 'GRAVA', 'LER', 'ALTERA', 'EXCLUI', 'CANCELA', 'IMPRIME', 'FECHAR');
  TabAlfabeto : PChar = ('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

//  BtnTypeName: array[TCustomNavegadorBtn] of PChar = ('FIRST', 'PRIOR', 'NEXT',
//    'LAST', 'INSERT', 'POST', 'LER', 'EDIT', 'DELETE', 'CANCEL', 'FIM');

//  BtnHintId: array[TCustomNavegadorBtn] of Word = (SFirstRecord, SPriorRecord,
//    SNextRecord, SLastRecord, SInsertRecord, SPostEdit, SLerRecord,
//    SEditRecord, SDeleteRecord, SCancelEdit, SFimRecord);

  BtnBitMapName: array[TCustomNavegadorBtn] of PChar = ('k-First', 'k-Prior', 'k-Next',
    'k-Last', 'k-Novo', 'k-grava','k-ler', 'k-altera', 'k-exclui', 'k-cancel', 'k-fechar', 'k-Imprimir');
  BtnCaption: array[TCustomNavegadorBtn] of PChar = ('', '', '',
    '', '&Novo', '&Salva', '&Ler', '&Altera', '&Exclui', '&Cancela', '&Imprimir', '&Fim');
  BtnHints: array[TCustomNavegadorBtn] of PChar = ('Primeiro Registro', 'Registro Anterior', 'Proximo Registro',
    'Ultimo Registro', 'Gera Novo Registro', 'Salva Novo Registro', 'Procura Registro', 'Altera Registro', 'Exclui Registro', 'Cancela Operacao', 'Imprime', 'Finaliza');

{
Inicio do codigo para Novo Navigator
}

procedure Register;
begin

  RegisterComponents('CCS-SIS', [TCustomNavegador]);
  RegisterPropertyEditor(TypeInfo(string), TCustomNavegador, 'Param1', TCustomDBProperty);
  RegisterPropertyEditor(TypeInfo(string), TCustomNavegador, 'Param2', TCustomDBProperty);
  RegisterPropertyEditor(TypeInfo(string), TCustomNavegador, 'Param3', TCustomDBProperty);
  RegisterPropertyEditor(TypeInfo(string), TCustomNavegador, 'Param4', TCustomDBProperty);
  RegisterPropertyEditor(TypeInfo(string), TCustomNavegador, 'KeyField', TCustomDBProperty);
end;

constructor TCustomNavegador.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  if not NewStyleControls then ControlStyle := ControlStyle + [csFramed];
  FLink := TCCSLink.Create(nil);
  FVisibleButtons := [nbFirst,  nbPrior,  nbNext, nbLast,
                      nbInsert, nbPost,  nbler, nbcancel,  nbDelete, nbImprimir, nbFim];
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
  FDataLink := TDataLink.Create;
  //Tabelas para manipulacao da visualizacao
  FDataSource := TDataSource.create(nil);
  FDataSource.Name := 'CustomSource';
  FTable := TTable.create(nil);
  FTable.name := 'CustomDBTable';
  FQuery := TQuery.create(nil);
  FQuery.Name := 'CustomDBQuery';

end;

destructor TCustomNavegador.Destroy;
begin
  FDataLink.Free;
  FHints.Free;
  FDataLink := nil;
  FAlfabeto := nil;
  FLink.Free;
  FQuery.free;
  FTable.free;
  FDataSource.free;
//  FFDLChave.Free;
//  FFDLChave := nil;
  inherited Destroy;
end;

procedure TCustomNavegador.InitButtons;
var
  I: TCustomNavegadorBtn;
  Btn: TCustomNavegadorButton;
  X: Integer;
  ResName: string;
begin
  MinBtnSize := Point(20, 18);
  X := 0;
  for I := Low(Buttons) to High(Buttons) do
  begin
    Btn := TCustomNavegadorButton.Create (Self);
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);
    FmtStr(ResName, 'CN-%s', [BtnTypeName[I]]);
    Btn.Glyph.Handle := LoadBitmap(HInstance, PChar(ResName));
//    Btn.Glyph.LoadFromResourceName(HInstance, PChar(ResName));
    //ResName := 'K_NOVO';
    //Btn.Glyph.Handle := LoadBitmap(HInstance, PChar(ResName));
    //Btn.Glyph.LoadFromFile('c:\componentes\CustomNavegador\' + BtnBitMapName[I] + '.BMP');
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

procedure TCustomNavegador.InitHints;
var
  I: Integer;
  J: TCustomNavegadorBtn;
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

procedure TCustomNavegador.SetHints(Value: TStrings);
begin
  FHints.Assign(Value);
  InitHints;
end;
{
procedure TCustomNavegador.GetChildren(Proc: TGetChildProc);
begin
end;
}

procedure TCustomNavegador.SetContros;
begin
   if Assigned(DataSource) and Assigned(ListaPesquiza) Then
   begin
      ListaPesquiza.DataSource := DataSource;
   end;
end;

procedure TCustomNavegador.SetMenuControl(Value : TCustomMenuControl);
begin
   FMenuControl := Value;
   if assigned(Value) then
   begin
      Value.FreeNotification(Self);
   end;
end;
procedure TCustomNavegador.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FProcurar <> nil) and (AComponent = Procurar) then
       Procurar := nil;
    if (FFoco <> nil) and (AComponent = Foco) then
       Foco := nil;
    if (FListaPesquiza <> nil) and (AComponent = ListaPesquiza) then
       ListaPesquiza := nil;
    if (FAlfabeto <> nil) and (AComponent = Alfabeto) then
       Alfabeto := nil;
    if (FControl <> nil) and (AComponent = Control) then
       Control := nil;
    if (FMenuControl <> nil) and (AComponent = MenuControl) then
       MenuControl := nil;
  end;
end;

procedure TCustomNavegador.SetVisible(Value: TNavegadorButtonSet);
var
  I: TCustomNavegadorBtn;
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

procedure TCustomNavegador.AdjustSize (var W: Integer; var H: Integer);
var
  Count: Integer;
  MinW: Integer;
  I: TCustomNavegadorBtn;
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

procedure TCustomNavegador.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TCustomNavegador.WMSize(var Message: TWMSize);
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

procedure TCustomNavegador.Click(Sender: TObject);
begin
  BtnClick (TCustomNavegadorButton (Sender).Index);
end;

procedure TCustomNavegador.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldFocus: TCustomNavegadorBtn;
begin
  OldFocus := FocusedButton;
  FocusedButton := TCustomNavegadorButton (Sender).Index;
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

procedure TCustomNavegador.BtnClick(Index: TCustomNavegadorBtn);
begin
  if (DataSource <> nil) and (DataSource.State <> dsInactive) then
  begin
    with DataSource.DataSet do
    begin
      case Index of
        nbPrior: Prior;
        nbNext: Next;
        nbFirst: First;
        nbLast: Last;
        nbInsert:
        begin
           if assigned(FFoco) then
              Foco.SetFocus
          else
             SetFocus;
          Control.Novo;
        end;
        nbPost:
        begin
           Control.Atualizar;
           RefazQuery;
           SetFocus;
        end;
        nbLer:   if assigned(FProcurar) then FProcurar.SetFocus; //Pesquisar(FProcurar.Text);
        nbDelete:
        begin
            if not FConfirmDelete or (MessageDlg('Deseja Excluir o Registro?', mtConfirmation, mbOKCancel, 0) <> idCancel) then
            begin
               Control.Excluir;
               RefazQuery;
            end;
        end;
        nbFim: if assigned(FOnFim) then FOnFim(self);
        nbImprimir: if assigned(FOnImprimir) then FOnImprimir(self);
      end;
    end;
  end;
  if not (csDesigning in ComponentState) and Assigned(FOnNavClick) then
    FOnNavClick(Self, Index);
end;

procedure TCustomNavegador.Fim;
begin

end;

procedure TCustomNavegador.RefazQuery;
begin
   FQuery.Active := False;
   FQuery.Active := True;
end;

procedure TCustomNavegador.WMSetFocus(var Message: TWMSetFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TCustomNavegador.WMKillFocus(var Message: TWMKillFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TCustomNavegador.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewFocus: TCustomNavegadorBtn;
  OldFocus: TCustomNavegadorBtn;
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

procedure TCustomNavegador.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TCustomNavegador.DataChanged;
var
  UpEnable, DnEnable: Boolean;
  lParam1, lParam2, lParam3, lParam4 : string;

begin
  // Ferifica se o ponteiro de leitura e gravacao esta no inico ou fim
  if assigned(Control) then
  begin
     EditingChanged;
     UpEnable := Enabled and not DataSource.DataSet.BOF;
     DnEnable := Enabled and not DataSource.DataSet.EOF;
     Buttons[nbFirst].Enabled := UpEnable;
     Buttons[nbPrior].Enabled := UpEnable;
     Buttons[nbNext].Enabled := DnEnable;
     Buttons[nbLast].Enabled := DnEnable;

     Buttons[nbDelete].Enabled := Enabled and Control.CanUpdate and
       not (DataSource.DataSet.BOF and DataSource.DataSet.EOF);
     Buttons[nbLer].Enabled := Enabled and Control.CanUpDate and
       not (DataSource.DataSet.BOF and DataSource.DataSet.EOF);
     Buttons[nbFim].Enabled := True;
     Buttons[nbImprimir].Enabled := True;
     if Param1 <> '' then
        lParam1 := DataSource.DataSet.FieldByName(Param1).AsString;
     if Param2 <> '' then
        lParam2 := DataSource.DataSet.FieldByName(Param2).AsString;
     if Param3 <> '' then
        lParam3 := DataSource.DataSet.FieldByName(Param3).AsString;
     if Param4 <> '' then
        lParam4 := DataSource.DataSet.FieldByName(Param4).AsString;
//     showmessage(lparam1);
     try
     if (Param1 <> '') or (Param2 <> '') or (Param3 <> '') or (Param4 <> '') then
        Control.Carregar(lParam1, lParam2, lParam3, lParam4)
     except
        showmessage('parametro invalido');
     end;
  end;
end;

procedure TCustomNavegador.EditingChanged;
var
  CanModify: Boolean;
begin
  CanModify := Enabled and DataSource.DataSet.Active and Control.CanUpDate;
  Buttons[nbInsert].Enabled := True;
  Buttons[nbEdit].Enabled   := CanModify;// and not FDataLink.Editing;
  Buttons[nbPost].Enabled   := True;// and FDataLink.Editing;
  Buttons[nbCancel].Enabled := CanModify;// and FDataLink.Editing;

end;

procedure TCustomNavegador.ActiveChanged;
var
  I: TCustomNavegadorBtn;
begin
  if assigned(DataSource) and assigned(DataSource.DataSet) then
  begin
     if not (Enabled and DataSource.DataSet.Active) then
       for I := Low(Buttons) to High(Buttons) do
         Buttons[I].Enabled := False
     else
     begin
       DataChanged;
       EditingChanged;
     end;
  end;
end;

procedure TCustomNavegador.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    ActiveChanged;
end;


procedure TCustomNavegador.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  FDataLink.DataSource.OnDataChange := DSChange;
  if not (csLoading in ComponentState) then
    ActiveChanged;
  if Value <> nil then Value.FreeNotification(Self);
  setContros;
end;

function TCustomNavegador.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TCustomNavegador.DSChange(Sender: TObject; Field: TField);
var
  FieldAux : string;
  TabIndexAux : integer;
  TabIndexAux2 : integer;
begin
    DataChanged;
    if assigned(Alfabeto) then
    begin
       if not ((DataSource.State = dsInsert) or (DataSource.State = dsEdit)) then
       begin
          TabIndexAux2 := Alfabeto.TabIndex;

          FieldAux := DataSource.DataSet.FieldByName(Param1).AsString;
          if FieldAux <> '' then
          begin
             try
                TabIndexAux := Alfabeto.Tabs.IndexOf(FieldAux[1]);
                if TabIndexAux <> -1 then
                   Alfabeto.TabIndex := Alfabeto.Tabs.IndexOf(FieldAux[1]);
             except
                Alfabeto.TabIndex := TabIndexAux2;
             end;
          end;
       end;
    end;
end;

procedure TCustomNavegador.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  initDataSource;
  InitHints;
  ActiveChanged;
  SetContros;
end;



procedure TCustomNavegador.SetProcurar(Value : TCustomEdit);
{
Procedimento para setar o novo campo edit para ser utilizado na pesquisa
}
begin
  FProcurar := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
      if (Value is TEdit) then
         TEdit(Value).OnChange := ProcurarChange;
      if (Value is TCCSEditLabel) then
         TCCSEditLabel(Value).OnChange := ProcurarChange;
   end;
end;

procedure TCustomNavegador.ProcurarChange(Sender : TObject);
{
Esta procedure sera excultada sempre que o conteudo do eidt for alterado
}
begin
   Pesquisar(FProcurar.Text);
end;

procedure TCustomNavegador.SetFoco(Value : TCustomEdit);
{
Procedimento para setar o novo campo edit para ser utilizado na pesquisa
}
begin
  FFoco := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCustomNavegador.SetListaPesquiza(Value : TDBGrid);
{
Procedimento para setar o novo campo edit para ser utilizado na pesquisa
}
begin
  FListaPesquiza := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
      Value.OnTitleClick := SetarIndex; //para mudar o campo chave
      SetContros;
   end;
end;

procedure TCustomNavegador.SetarIndex(Column: TColumn);
{
    Metodo para trocar o indice para pesquiza apartir de um TColumn
}
begin
   TrocarIndice(Column.FieldName);
end;

procedure TCustomNavegador.TrocarIndice(Value : string);
begin
   if assigned(DataSource) and assigned(Control) then
   begin
      FKeySelecionado := Value;
      if (DataSource.DataSet is TTable) then
      begin
         try
           (DataSource.DataSet as TTable).IndexFieldNames := Value;
         except
           (DataSource.DataSet as TTable).Cancel;
         end;
      end;
      if (DataSource.DataSet is TQuery) then
      begin
         with (DataSource.DataSet as TQuery) do
         begin
            try
               Active := False;
               sql.clear;
//               sql.add('Select * from '+ Control.TableName);
               sql.Assign(Control.ObjectView);
               sql.add('order by '  + Value);
               Active := True;
            except
               Active := False;
               sql.clear;
               sql.add('Select * from '+ Control.TableName);
               Active := True;
            end;
         end;
      end;
   end;
end;

procedure TCustomNavegador.SetShowCaption(Value : Boolean);
{
Procedimento para setar o se sera exibido os captions dos botoes ou nao
}
begin
  FShowCaption := Value;
  ExibirCaption;
end;

procedure TCustomNavegador.ExibirCaption;
var
  I: TCustomNavegadorBtn;
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

procedure TCustomNavegador.SetAlfabeto(Value : TTabSet);
{
Procedimento para setar o novo campo edit para ser utilizado na pesquisa
}
var
   IndAlfabeto : integer;
begin
  FAlfabeto := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
      Value.OnClick := AlfabetoClick;
      Value.Tabs.Clear;
      for IndAlfabeto := 0 to 25 do
      begin
          Value.Tabs.add(TabAlfabeto[IndAlfabeto]);
      end;
      State := nCarregando;
      Value.TabIndex := 0;
      State := nNull;
      //      Value.Tabs.LoadFromFile('c:\componentes\CustomNavegador\alfabeto.txt');
   end;

end;

procedure TCustomNavegador.AlfabetoClick(Sender : TObject);
{
Esta procedure sera sempre execultada quando ocorrer um click no TabSet
}
var
   LetraInicial : string;
   PointLetra   : integer;
   PointLetraAux : integer;
begin
   PointLetraAux := Alfabeto.TabIndex;
   PointLetra := Alfabeto.TabIndex;
   try
     LetraInicial := Alfabeto.Tabs [PointLetra];
   except
     Alfabeto.TabIndex :=  PointLetraAux;
     LetraInicial := Alfabeto.Tabs [PointLetraAux];
   end;
   Pesquisar(LetraInicial);
end;

procedure TCustomNavegador.SetkeyField(Value : string);
begin
   FkeyField := Value;
   FkeySelecionado := Value;
   TrocarIndice(Value);
end;
procedure TCustomNavegador.Pesquisar(Value : string);
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
           if FkeySelecionado = '' then
              showmessage('A property KeyField nao esta setada - colocar except aqui');
           LocateSuccess := Locate(FkeySelecionado, Value,  SearchOptions);
           if ListaPesquiza <> nil then
              ListaPesquiza.Refresh;
         except
            MessageDlg('Dados Invalidos para Consulta!', mtError, [mbOK], 0);
         end;
      end;
   end;
end;


procedure TCustomNavegador.SetControl(Value : TCustomDB);
{
          Seta Control e passa os dados da query para montar um query de
   movimentacao;
          E Seta o DataSoruce com essa query
}
begin
   FControl := Value;
   if assigned(Value) then
   begin
      Value.FreeNotification(Self);
      if not (csLoading in ComponentState) then
      begin
         if assigned(Control.DataSource) and
            assigned(Control.DataSource.DataSet) then
         begin
            InitDataSource;
         end
         else
            MessageDlg('DataSource nao definido.', mtError, [mbOK], 0);
      end;

   end;
end;
procedure TCustomNavegador.InitDataSource;
begin
  if csLoading in ComponentState then exit;
  if assigned(Control) then
  begin
     FQuery.sql.Clear;
     FQuery.sql.Assign(Control.ObjectView);
     FQuery.DatabaseName := TQuery(Control.DataSource.DataSet).DataBaseName;
     if fquery.Text = '' then exit;
     FQuery.Active := True;
     FDataSource.DataSet := FQuery;
     DataSource := FDataSource;
  end;
end;
{--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--}



{TCustomNavegadorButton}

destructor TCustomNavegadorButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TCustomNavegadorButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
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

procedure TCustomNavegadorButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
end;

procedure TCustomNavegadorButton.TimerExpired(Sender: TObject);
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

procedure TCustomNavegadorButton.Paint;
var
  R: TRect;
begin
  inherited Paint;
  if (GetFocus = Parent.Handle) and
     (FIndex = TCustomNavegador (Parent).FocusedButton) then
  begin
    R := Bounds(0, 0, Width, Height);
    InflateRect(R, -3, -3);
    if FState = bsDown then
      OffsetRect(R, 1, 1);
    DrawFocusRect(Canvas.Handle, R);
  end;
end;

{--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--}

function TCustomDBProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TCustomDBProperty.GetValues(PROC : TGetStrProc);
var
   ListaFields : TStrings;
   i : integer;
   lDataSet : TDataSet;
   lQuery : TQuery;
   lTable : TTable;
   lCustomDB : TCustomDB;
begin
   ListaFields := TStringList.create;
   lCustomDB := TCustomNavegador(GetComponent(0)).Control;
   if assigned(lCustomDB.DataSource.DataSet) then
   begin
      if lCustomDB.DataSource.DataSet is TQuery then
      begin
         lQuery := TQuery.create(nil);
         lQuery.sql.Assign(lCustomDB.ObjectView);
         lQuery.DatabaseName := TQuery(lCustomDB.DataSource.DataSet).DataBaseName;
         lQuery.Active := True;
         for i := 0 to lquery.FieldCount - 1 do
         begin
            ListaFields.Add(lquery.Fields[i].FieldName);
         end;
         lQuery.Active := False;
         lQuery.destroy;
      end else
      if lCustomDB.DataSource.DataSet is TTable then
      begin
         lTable := TTable.create(nil);
         lTable.DatabaseName := TTable(lCustomDB.DataSource.DataSet).DataBaseName;
         lTable.TableName := TTable(lCustomDB.DataSource.DataSet).TableName;
         lTable.Active := True;
         for i := 0 to lTable.FieldCount - 1 do
         begin
            ListaFields.Add(lTable.Fields[i].FieldName);
         end;
         lTable.Active := False;
         lTable.destroy;
      end;
   end;
   for i := 0 to  ListaFields.Count - 1 do
   begin
      Proc(ListaFields[i]);
   end;
   ListaFields.Free;
end;

end.

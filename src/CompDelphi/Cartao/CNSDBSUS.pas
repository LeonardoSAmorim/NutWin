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




unit CNSDBSUS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DsFields, db, DBTables, CCSListaLinks, DsgnIntf, rtti, Conector,stdctrls,  checklst, Tabs;

type
  {
    Editor de Componente utilizado para executar o metodo para criar a tabela
  que o componente esta utilizando
  }
  TBanco = (Paradox, Oracle, MSSQL, ACCESS, Interbase);
  TCustomDBEditor = class(TDefaultEditor)
  private
    FIndex : integer;
  protected
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TCustomDB = class(TCCSListaLinks)
  private
    { Private declarations }
    //Definios Campos do tipo TCNSDSFields
    FDataLink: TDataLink;
    FAtivarFields : boolean;
    FCNSDataBase : TDataBase;
    FCanUpdate : boolean;
    FQueryAux : TQuery;
    FTableName : string;
    FBanco : TBanco;
    FObjectView : TStrings;
    FExcluirHeranca : boolean;
    FRTTIDB : TRTTI;
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure SetAtivarFields(Value : Boolean);
    procedure SetCNSDataBase(const Value: TDataBase);
    procedure SetBanco(Value : TBanco);
  protected
    { Protected declarations }
    procedure DSChange(Sender: TObject; Field: TField); virtual;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetarDataSetFields; virtual;
    procedure ResetarDataSetFields; virtual;
    procedure SetarParametrosBanco; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SelectAll; virtual;
    procedure CreateTable; virtual; abstract;
    procedure DropTable; virtual; abstract;
    procedure Novo; virtual; abstract;
    procedure SelecionarTodos; virtual;
    procedure Atualizar; virtual; abstract;
    procedure Carregar(P1, P2, P3, P4 : string); virtual;
    procedure Excluir; virtual; abstract;
    procedure BancoToProperty; virtual; abstract;
    procedure PropertyToBanco; virtual; abstract;
    function GetField(Field : string) : string; virtual;
    procedure PutField(Field, Value : string); virtual;
    function ISNotNUll : string;
    property CanUpdate : boolean read FCanUpdate write FCanUpdate;
    property QueryAux : TQuery read FQueryAux;
    property TableName : string read FTableName write FTableName;
    property AtivarFields : boolean read FAtivarFields write SetAtivarFields;
    property DataSource      : TDataSource    read GetDataSource    write SetDataSource;
    property CNSDataBase : TDataBase read FCNSDataBase write SetCNSDataBase;
    property Banco : TBanco read FBanco write SetBanco;
    property ObjectView : TStrings read FObjectView write FObjectView;
    property ExcluirHeranca : boolean read FExcluirHeranca write FExcluirHeranca;

  published
    { Published declarations }
  end;

  TCNSDBSUS = class(TCustomDB)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property AtivarFields;
    property DataSource;
    property CNSDataBase;

  end;

  TCNSConector = class(TCustomConector)
  private
    { Private declarations }
    FControl : TCustomDB;
    FControlField : string;
    procedure SetControl(Value : TCustomDB);
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
  published
    { Published declarations }
    property Control : TCustomDB read FControl write SetControl;
    property ControlPropertyPut;
    property ControlPropertyGet;
    property ControlField : string read FControlField write FControlField;
    property RefreshChange;
    property Viewer;
    property ViewerPropertyPut;
    property ViewerPropertyGet;
    procedure DoChange(Sender: TObject);
    procedure DoClick(Sender: TObject);
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Conectores', [TCNSConector]);
  RegisterPropertyEditor(TypeInfo(string), TCNSConector, 'ControlPropertyPut', TControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TCNSConector, 'ControlPropertyGet', TControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TCNSConector, 'ViewerPropertyPut', TViewerPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TCNSConector, 'ViewerPropertyGet', TViewerPropProperty);
  RegisterComponentEditor(TCustomDB, TCustomDBEditor);
end;


procedure TCustomDBEditor.EditProperty(PropertyEditor: TPropertyEditor;
  var Continue, FreeEditor: Boolean);
begin
    case FIndex of
       0 : TCustomDB(component).CreateTable;
       1 : TCustomDB(component).DropTable;
    end;
    FIndex := 0;
    Continue := False;
    MessageDlg('Operacao Comcluida.', mtInformation, [mbOK], 0);
end;

function TCustomDBEditor.GetVerbCount: Integer;
// indica o numero de opcoes no menu
begin
  Result := 2;
end;

function TCustomDBEditor.GetVerb(Index: Integer): string;
//opcao a ser colocada no menu
begin
  if Index = 0 then
    Result := 'Criar Tabela'
  else
    if Index = 1 then
       Result := 'Destruir Tabela'
    else Result := '';
end;

procedure TCustomDBEditor.ExecuteVerb(Index: Integer);
//e chamado a cada click no popmenu
begin
  if (Index = 0) or (index = 1) then
  begin
     FIndex := index;
     edit;
  end;
end;





constructor TCustomDB.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FDataLink := TDataLink.Create();
   FObjectView := TStringList.Create;
   FRTTIDB := TRTTI.Create(nil);
   FRTTIDB.Control := self;
//   FQueryAux := TQuery.Create(Application);
   //Criar os campos aqui.
end;
destructor TCustomDB.Destroy;
begin
//   FQueryAux.Destroy;
   FDataLink.Free;
   FDataLink := nil;
   FObjectView.Free;
   FRTTIDB.Free;
   inherited Destroy;
end;

procedure TCustomDB.SetarParametrosBanco;
begin
end;

procedure TCustomDB.SetBanco(Value : TBanco);
begin
   FBanco := Value;
   SetarParametrosBanco;
end;
procedure TCustomDB.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
//  if (Operation = opRemove) and (FDataLink <> nil) and
//    (AComponent = DataSource) then DataSource := nil;
  if Operation = opRemove then
  begin
    if (FDataLink <> nil) and (AComponent = DataSource) then
       DataSource := nil;
    if (FCNSDataBase <> nil) and (AComponent = CNSDataBase)then
       CNSDataBase := nil;
  end;
end;


procedure TCustomDB.SetAtivarFields(Value : Boolean);
begin
   if not (csLoading in ComponentState) then
   begin
      FAtivarFields := Value;
      if assigned(DataSource.DataSet) then
      begin
         if Value = True then
            SetarDataSetFields
         else
            ResetarDataSetFields;
      end else
      begin
         ShowMessage('DataSet deve ser Definido Antes!');
         FAtivarFields := False;
         ResetarDataSetFields;
      end;
   end;
end;

procedure TCustomDB.SetarDataSetFields;
begin
   //Setar o DataSet dos fields aqui
   //FDSFields1.DataSet := DataSet;
end;

procedure TCustomDB.ResetarDataSetFields;
begin
   //Limpar o DataSet dos fields aqui
   //FDSFields1.DataSet := nil;
end;

procedure TCustomDB.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  FDataLink.DataSource.OnDataChange := DSChange;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TCustomDB.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TCustomDB.DSChange(Sender: TObject; Field: TField);
begin

end;
procedure TCustomDB.SetCNSDataBase(const Value: TDataBase);
begin
  FCNSDataBase := Value;
  if Value <> nil then
  begin
     Value.freeNotification(Self);
  end;
end;

procedure TCustomDB.SelecionarTodos;
{
          metodo abstrato e ser implementa nos filhos para obter a lista de todas as instancias
}
begin
end;

function TCustomDB.GetField(Field : string) : string;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with TQuery(DataSource.Dataset) do
      begin
         Result := FieldByName(Field).AsString;
      end;
   end else
      Result := '';
end;

procedure TCustomDB.PutField(Field, Value : string);
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with TQuery(DataSource.Dataset) do
      begin
         ParamByName(Field).AsString := Value;
      end;
   end;
end;

procedure TCustomDB.SelectAll;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with TQuery(DataSource.Dataset) do
      begin
         close;
         sql.clear;
         sql.add('select * from ' + TableName);
         Open;
      end;
   end;
end;

procedure TCustomDB.Carregar(P1, P2, P3, P4 : string);
begin
end;


function  TCustomDB.ISNotNUll : string;
begin
  SHOWMESSAGE(Result);
  if Banco = INTERBASE then
     Result := 'NOT NULL'
  else
     Result := '';
  SHOWMESSAGE(Result);
end;

////////TCNSConector/////////////////////////////////////////////////////////
constructor TCNSConector.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCNSConector.Destroy;
begin
  if assigned(FControl) then
  begin
     FControl.Delete(self);
  end;
  FControl := nil;
  inherited Destroy;
end;

procedure TCNSConector.Loaded;
begin
   inherited loaded;
end;

procedure TCNSConector.SetControl(Value : TCustomDB);
begin
   FControl := Value;
   if assigned(value) then
   begin
      RTTIControl.Control := FControl;
      FControl.add(self);
      if not (csLoading in ComponentState) then
      begin
         ExecViewerControl;
      end;
      Value.freenotification(self);
   end;
end;

procedure TCNSConector.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FControl <> nil) and (AComponent = Control) then
       Control := nil;
  end;
end;


procedure TCNSConector.DoChange(Sender : TObject);
begin
   if RefreshChange then
   begin
      if Viewer is TComboBox then
      begin
         TCustomDB(FControl).Carregar(TComboBox(Viewer).Text, '', '', '');
      end else
      begin
         if (not (FViewer is TListBox) and not (FViewer is TTabSet)) then
         begin
             LinkEvent(self, lUpDate);
         end;
      end;
   end;
end;

procedure TCNSConector.DoClick(Sender : TObject);
begin
   if FRefreshChange then
   begin
      if Viewer is TListBox then
      begin
         with TListBox(Viewer) do
         begin
            TCustomDB(FControl).Carregar(Items[ItemIndex], '', '', '');
         end;
      end;
      if Viewer is TTabSet then
      begin
         with TTabSet(Viewer) do
         begin
            TCustomDB(FControl).Carregar(Tabs[TabIndex], '', '', '');
         end;
      end;
   end;
end;

procedure TCNSConector.ExecViewerControl;
begin
  if assigned(Viewer) and assigned(Control) then
  begin
    LinkEvent(self, lRefresh);
  end;
end;

procedure TCNSConector.LinkEvent(Sender : TObject; lState : TLinkState);
begin
  inherited LinkEvent(Sender, lState);
  if assigned(Viewer) and assigned(Control) then
  begin
    case lState of
       //Atualiza Viewer
       lLoad, lRefresh, lRefreshViewer : RTTIViewer.PutProperty(ViewerPropertyPut, FRTTIControl.GetProperty(ControlPropertyGet));
       //Atualiza Control
       lUpDate, lRefreshControl : FRTTIControl.PutProperty(ControlPropertyPut, FRTTIViewer.GetProperty(ViewerPropertyGet));
    end;
  end;
end;


end.

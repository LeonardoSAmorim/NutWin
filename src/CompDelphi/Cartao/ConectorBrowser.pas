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




unit ConectorBrowser;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CCSListaLinks, CNSDBSUS, rtti, db, dbctrls, dbtables, DsgnIntf, conector;

type
  TConectorBrowserState = (cbsLocate, cbsNull);

  TConectorBrowser = class (TCCSLink)
  private
    // Componentes para auxiliar novo navigator
    FDataLink: TDataLink;
    FParam1 : string;
    FParam2 : string;
    FParam3 : string;
    FParam4 : string;
    FkeyField : string;
    FListField : string;
    FListProperty : string;
    FKeySelecionado : string;
    FControl : TCustomDB;
    FControlPropertyPut : string;
    FControlPropertyGet : string;
    FLookControl : TCustomDB;
    FRTTIControl : TRTTI;
    FRTTILookControl : TRTTI;
    FLookControlProperty : string;
    FDataSource : TDataSource;
    FViewer : TDBLookupComboBox;
    FTable : TTable;
    FQuery : TQuery;
    FStatus : TConectorBrowserState;
    procedure InitDataSource;
    procedure SetContros;
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure SetViewer(Value : TDBLookupComboBox);
    procedure DSChange(Sender: TObject; Field: TField);
    procedure SetControl(Value : TCustomDB);
    procedure RefazQuery;
    procedure SetkeyField(Value : string);
    procedure SetLookControl(Value : TCustomDB);
    procedure SetControlPropertyPut(Value : string);
    procedure SetControlPropertyGet(Value : string);

  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure ExecViewerControl;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure TrocarIndice(Value : string);
    procedure PosicionarControl;
    procedure LinkEvent(Sender : TObject; lState : TLinkState); override;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property RTTILookControl : TRTTI read FRTTILookControl write FRTTILookControl;
    property RTTIControl : TRTTI read FRTTIControl write FRTTIControl;
  published
    property Viewer : TDBLookupComboBox read FViewer write SetViewer;
    property Control : TCustomDB read FControl write SetControl;
    property ControlPropertyPut : string read FControlPropertyPut write SetControlPropertyPut;
    property ControlPropertyGet : string read FControlPropertyGet write SetControlPropertyGet;
    property Param1 : string read FParam1 write FParam1;
    property Param2 : string read FParam2 write FParam2;
    property Param3 : string read FParam3 write FParam3;
    property Param4 : string read FParam4 write FParam4;
    property KeyField : string read FkeyField write SetKeyField;
    property ListField : string read FListField write FListField;
    property ListProperty : string read FListProperty write FListProperty;
    property LookControl : TCustomDB read FLookControl write SetLookControl;
    property LookControlProperty : string read FLookControlProperty write FLookControlProperty;
 end;

  TConectorLookup = class (TConectorBrowser)
  published
    property Viewer;
    property Control;
    property ControlPropertyPut;
    property ControlPropertyGet;
    property Param1;
    property Param2;
    property Param3;
    property Param4;
    property KeyField;
    property ListField;
    property ListProperty;
    property LookControl;
    property LookControlProperty;
 end;

  TConectorBrowserProperty = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;

  TLkControlPropProperty = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;
  TCtControlPropProperty = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;

  TConectorBrowserFieldProperty = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TConectorBrowser]);
  RegisterComponents('Conectores', [TConectorLookup]);
  RegisterPropertyEditor(TypeInfo(string), TConectorBrowser, 'LookControlProperty', TLkControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorBrowser, 'ListProperty', TLkControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorBrowser, 'ControlPropertyPut', TCtControlPropProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorBrowser, 'ControlPropertyGet', TCtControlPropProperty);

  RegisterPropertyEditor(TypeInfo(string), TConectorBrowser, 'Param1', TConectorBrowserFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorBrowser, 'Param2', TConectorBrowserFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorBrowser, 'Param3', TConectorBrowserFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorBrowser, 'Param4', TConectorBrowserFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorBrowser, 'KeyField', TConectorBrowserFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TConectorBrowser, 'ListField', TConectorBrowserFieldProperty);

end;

{--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*}
{TCustomBrowser}
constructor TConectorBrowser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRTTIControl := TRTTI.Create(nil);
  FRTTILookControl := TRTTI.Create(nil);
  FDataLink := TDataLink.Create;
  //Tabelas para manipulacao da visualizacao
  FDataSource := TDataSource.create(nil);
  FDataSource.Name := 'CustomBrowserSource';
  FTable := TTable.create(nil);
  FTable.name := 'CustomBrowserDBTable';
  FQuery := TQuery.create(nil);
  FQuery.Name := 'CustomBrowserDBQuery';
  FStatus := cbsnull;

end;

destructor TConectorBrowser.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FQuery.free;
  FTable.free;
  FDataSource.free;
  FRTTIControl.Free;
  FRTTILookControl.Free;
  if assigned(FControl) then
  begin
     FControl.Delete(self);
  end;
  inherited Destroy;
end;

procedure TConectorBrowser.Loaded;
begin
  inherited Loaded;
  initDataSource;
  SetContros;
end;


procedure TConectorBrowser.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FViewer <> nil) and (AComponent = Viewer) then
       Viewer := nil;
    if (FControl <> nil) and (AComponent = Control) then
       Control := nil;
  end;
end;


procedure TConectorBrowser.RefazQuery;
begin
   FQuery.Active := False;
   FQuery.Active := True;
end;



procedure TConectorBrowser.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  FDataLink.DataSource.OnDataChange := DSChange;
  if not (csLoading in ComponentState) then
    DSChange(self, nil);
  if Value <> nil then Value.FreeNotification(Self);
  setContros;
end;

function TConectorBrowser.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TConectorBrowser.DSChange(Sender: TObject; Field: TField);
var
  lParam1, lParam2, lParam3, lParam4 : string;
begin
   if FStatus = cbsNull then
   begin
      if Param1 <> '' then
         lParam1 := DataSource.DataSet.FieldByName(Param1).AsString;
      if Param2 <> '' then
         lParam2 := DataSource.DataSet.FieldByName(Param2).AsString;
      if Param3 <> '' then
         lParam3 := DataSource.DataSet.FieldByName(Param3).AsString;
      if Param4 <> '' then
         lParam4 := DataSource.DataSet.FieldByName(Param4).AsString;
      if (Param1 <> '') or (Param2 <> '') or (Param3 <> '') or (Param4 <> '') then
         LookControl.Carregar(lParam1, lParam2, lParam3, lParam4)
   end;
end;


procedure TConectorBrowser.SetViewer(Value : TDBLookupComboBox);
begin
  FViewer := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
      SetContros;
   end;
end;

procedure TConectorBrowser.SetContros;
begin
   if Assigned(DataSource) and Assigned(Viewer) Then
   begin
      Viewer.ListSource := DataSource;
      Viewer.ListField := ListField;
      Viewer.keyField := KeyField;
   end;
end;

procedure TConectorBrowser.SetkeyField(Value : string);
begin
   FkeyField := Value;
   FkeySelecionado := Value;
   TrocarIndice(Value);
end;


procedure TConectorBrowser.TrocarIndice(Value : string);
begin
   if assigned(DataSource) and assigned(Control) then
   begin
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
               sql.Assign(LookControl.ObjectView);
               sql.add('order by '  + Value);
               Active := True;
            except
               Active := False;
               sql.clear;
               sql.add('Select * from '+ LookControl.TableName);
               Active := True;
            end;
         end;
      end;
      FKeySelecionado := Value;
   end;
end;

procedure TConectorBrowser.SetControl(Value : TCustomDB);
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
      FControl.add(self);
      FRTTIControl.Control := FControl;
      if not (csLoading in ComponentState) then
      begin
         if assigned(FControl.DataSource) and
            assigned(FControl.DataSource.DataSet) then
         begin
             InitDataSource;
         end
         else
            MessageDlg('DataSource nao definido.', mtError, [mbOK], 0);
      end;
   end;
end;

procedure TConectorBrowser.SetControlPropertyPut(Value : string);
begin
   FControlPropertyPut := Value;
   if FControlPropertyGet = '' then
      FControlPropertyGet := Value;
   if not (csLoading in ComponentState) then
   begin
      ExecViewerControl;
   end;
end;
procedure TConectorBrowser.SetControlPropertyGet(Value : string);
begin
   FControlPropertyGet := Value;
   if FControlPropertyPut = '' then
      FControlPropertyPut := Value;
   if not (csLoading in ComponentState) then
   begin
      ExecViewerControl;
   end;
end;


procedure TConectorBrowser.InitDataSource;
begin
  if assigned(FLookControl) then
  begin
     FQuery.sql.Clear;
     FQuery.sql.Assign(FLookControl.ObjectView);
     FQuery.DatabaseName := TQuery(FLookControl.DataSource.DataSet).DataBaseName;
     if fquery.Text = '' then exit;
     FQuery.Active := True;
     FDataSource.DataSet := FQuery;
     DataSource := FDataSource;
  end;
end;

procedure TConectorBrowser.PosicionarControl;
var
  LocateSuccess: Boolean;
  SearchOptions: TLocateOptions;
  xChave       : String;
begin
{
   if csLoading in componentState then exit;
   SearchOptions := [loPartialKey, loCaseInsensitive];
   if DataSource.DataSet <> nil then
   begin
      with DataSource.DataSet do
      begin
         // try para verificar se o conteudo do campo e valido
         try
           LocateSuccess := Locate(FkeySelecionado, FieldByName(FkeySelecionado).ASString,  SearchOptions);
           if Viewer <> nil then
              Viewer.Refresh
         except
            MessageDlg('Dados Invalidos para Consulta!', mtError, [mbOK], 0);
         end;
      end;
   end;
   FBrowseState := cbsNull;
}
end;

procedure TConectorBrowser.ExecViewerControl;
begin
  if assigned(Viewer) and assigned(Control) then
  begin
    LinkEvent(self, lRefresh);
  end;
end;

procedure TConectorBrowser.LinkEvent(Sender : TObject; lState : TLinkState);
begin
   {
     pega o conteudo do controle que possui a chave de ligacao e seta o lookup
   }
   case  lState of
      lLoad, lRefresh, lRefreshViewer :
      begin
         if assigned(FViewer) then
            FViewer.KeyValue :=  RTTILookControl.GetProperty(ListProperty)
         else
            MessageDlg('E necessario setar Viewer.', mtError, [mbOK],0)
      end;
      lUpDate, lRefreshControl :
      begin
         RTTIControl.PutProperty(ControlPropertyPut, RTTILookControl.GetProperty(LookControlProperty));
      end;
   end;
end;

procedure TConectorBrowser.SetLookControl(Value : TCustomDB);
begin
   FLookControl := Value;
   if assigned(value) then
   begin
//      FLookControl.add(self);
      FRTTILookControl.Control := FLookControl;
      if not (csLoading in ComponentState) then
      begin
         if assigned(FLookControl.DataSource) and
            assigned(FLookControl.DataSource.DataSet) then
         begin
             InitDataSource;
         end
         else
            MessageDlg('DataSource nao definido.', mtError, [mbOK], 0);
      end;
      Value.freenotification(self);
   end;
end;



{--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--}

function TConectorBrowserProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TConectorBrowserProperty.GetValues(PROC : TGetStrProc);
var
   ListaFields : TStrings;
   i : integer;
   lDataSet : TDataSet;
   lQuery : TQuery;
   lTable : TTable;
   lCustomDB : TCustomDB;
begin
   ListaFields := TStringList.create;
   //lDataSet := TCustomNavegador(GetComponent(0)).db.DataSource.DataSet;
   lCustomDB := TConectorBrowser(GetComponent(0)).Control;
   if assigned(lCustomDB.DataSource.DataSet) then
   begin
      if lCustomDB.DataSource.DataSet is TQuery then
      begin
         lQuery := TQuery.create(nil);
//         lQuery.sql.add('Select * from ' + lCustomDB.TableName);
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

///Editor de propriedade para as properties////
function TLkControlPropProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TLkControlPropProperty.GetValues(PROC : TGetStrProc);
var
   ListaPropriedades : TStringList;
   i : integer;
begin
   ListaPropriedades := TStringList.create;
   ListaPropriedades.assign(TConectorBrowser(GetComponent(0)).RTTILookControl.GetPropertys);
   for i := 0 to  ListaPropriedades.Count - 1 do
   begin
      Proc(ListaPropriedades[i]);
   end;
   ListaPropriedades.Free;
end;

///Editor de propriedade para as properties////
function TCtControlPropProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TCtControlPropProperty.GetValues(PROC : TGetStrProc);
var
   ListaPropriedades : TStringList;
   i : integer;
begin
   ListaPropriedades := TStringList.create;
   ListaPropriedades.assign(TConectorBrowser(GetComponent(0)).RTTIControl.GetPropertys);
   for i := 0 to  ListaPropriedades.Count - 1 do
   begin
      Proc(ListaPropriedades[i]);
   end;
   ListaPropriedades.Free;
end;

{--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--}

function TConectorBrowserFieldProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TConectorBrowserFieldProperty.GetValues(PROC : TGetStrProc);
var
   ListaFields : TStrings;
   i : integer;
   lDataSet : TDataSet;
   lQuery : TQuery;
   lTable : TTable;
   lCustomDB : TCustomDB;
begin
   ListaFields := TStringList.create;
   //lDataSet := TCustomNavegador(GetComponent(0)).db.DataSource.DataSet;
   lCustomDB := TConectorBrowser(GetComponent(0)).LookControl;
   if assigned(lCustomDB.DataSource.DataSet) then
   begin
      if lCustomDB.DataSource.DataSet is TQuery then
      begin
         lQuery := TQuery.create(nil);
//         lQuery.sql.add('Select * from ' + lCustomDB.TableName);
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

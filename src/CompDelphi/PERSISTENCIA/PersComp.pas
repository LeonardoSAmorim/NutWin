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




unit PersComp;

interface

uses
  SysUtils, Classes, Messages, Controls, StdCtrls, ExtCtrls, DBTables, DB, DBConsts, Dialogs, ActiveX, BDEConst, dsgnintf;

type
  //Tipos para  informar no evento OnTermineteApply o que o TUpdateObjectView em 21/07/199
  TApplyEvent = procedure(Sender : TObject; UpdateKind : TUpdateKind) of Object;

  TMoveKind = (mvUp, mvDown, mvNone);
  TUpdateObjectView = class;
  TSQLStatement = class(TCollectionItem)
  private
    FStatement: TStrings;
    function  GetStatement: TStrings;
    procedure SetStatement(Value: TStrings);
  protected
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure RestoreDefaults; virtual;
  published
    property  Statement: TStrings read GetStatement write SetStatement;
  end;



  TStatementClass = class of TSQLStatement;

  TDBUpdateStatements = class(TCollection)
  private
    FUpdCmp : TUpdateObjectView;
    function GetStatement(Index: Integer): TSQLStatement;
    procedure SetStatement(Index: Integer; Value: TSQLStatement);
  protected
  public
    function GetOwner: TPersistent;override;
    constructor Create(UpdCmp: TUpdateObjectView; StatementClass: TStatementClass);
    function  Add: TSQLStatement;
    procedure LoadFromFile(const Filename: string);
    procedure LoadFromStream(S: TStream);
    procedure RestoreDefaults;
    procedure SaveToFile(const Filename: string);
    procedure SaveToStream(S: TStream);
    property UpdMaker : TUpdateObjectView read FUpdCmp;
    property Items[Index: Integer]: TSQLStatement read GetStatement write SetStatement; default;
 end;



  TDSPersist = class(TDataSource)
  private
    // Private declarations
    //FDataSet : TDBDataSet;
    FActiveDescendant: TDSPersist;
    FDataAncestor: TDataSource;
    FDataDescendents: TList;
    FAbstrata : Boolean;
    FMultipleIntf : Boolean;
    FOneOf : Boolean;
    FCampo:string;

    //TipoUpdate : array [TUpdateKind] of string;

  protected
    FMoveKind: TMoveKind;
    NewObjectID : string;
    Scrolling : Boolean;
    procedure SetDataSet(ADataSet: TDBDataSet);
    function GetDataSet: TDBDataSet;
    procedure SetDataAncestor(ADataAncestor: TDataSource);
    procedure Loaded; override;
    //Detecta se deletaram o dicionario do Form: ver Nota 1
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DSDataChange(Sender: TObject; Field: TField);
    procedure SetDescendant (Value : TDSPersist);
    procedure SetActiveDescendant ( Index : integer);
    procedure SetMultipleInterfaceDescendant ( ChildName : string);
    procedure ReSetMultipleInterfaceDescendant ( ChildName : string);
    procedure SetSingleActiveDescendant ( ChildName : string);

  public
    // Public declarations

    InTopDown : Boolean;
    class function CreateNewGUID: string;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddDescendent(Descendent: TDSPersist);
    function  CheckNoChilds (CurrentChild: TDSPersist) : Boolean;
    procedure RemoveDescendent(Descendent: TDSPersist);
    property Descendents : TList read FDataDescendents write FDataDescendents;
    property ActiveDescendant : TDSPersist read FActiveDescendant write SetDescendant;
    property OnDataChange;
  published
    property DataSet: TDBDataSet read GetDataSet write SetDataSet;
    property DataAncestor : TDataSource read FDataAncestor write SetDataAncestor;
    property Abstrata : Boolean read  FAbstrata write FAbstrata;
    property MultipleIntf : Boolean read FMultipleIntf write FMultipleIntf default False;
    property OneOf : Boolean read FOneOf write FOneOf default False;
  end;



  TQueryPersist = class(TQuery)
  private
    // Private declarations
    FLinkedDataObject: TDSPersist;
    //Estados : array [TDataSetState] of string;

  protected
    CampoID : string;
    CampoPai : string;
    IDPai : string;
    CampoOUID : string;

    procedure SetDataObject(ADataObject: TDSPersist);
    function GetDataObject: TDSPersist;
    procedure Loaded; override;
    //Detecta se deletaram o dicionario do Form: ver Nota 1
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoBeforeCancel; override;
    procedure DoBeforeClose; override;
    procedure DoBeforeDelete; override;
    procedure DoAfterDelete; override;
    procedure DoBeforeEdit; override;
    procedure DoBeforeInsert; override;
    procedure DoAfterInsert; override;
    procedure DoBeforeOpen; override;
    procedure DoAfterOpen; override;
    procedure DoBeforePost; override;
    procedure DoOnNewRecord; override;
    procedure DataEvent(Event: TDataEvent; Info: Longint);override;

  public
    // Public declarations
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property LkedDataObject : TDSPersist read GetDataObject write SetDataObject stored True;
  published
  end;



// TUpdateObjectView

  TUpdateObjectView = class(TDataSetUpdateObject)
  private
    FDataSet: TBDEDataSet;
    FStmts: TDBUpdateStatements;
    FStmtsCount : Integer;
    FTableIndex : Integer;
    FQueries: array[TUpdateKind] of TQuery;
    FSQLText: array[TUpdateKind] of TStrings;
    FOnTerminateApply: TApplyEvent;
    function GetQuery(UpdateKind: TUpdateKind): TQuery;
    function GetSQL(UpdateKind: TUpdateKind): TStrings;
    function GetSQLIndex(Index: Integer): TStrings;
    procedure SetSQL(UpdateKind: TUpdateKind; Value: TStrings);
    procedure SetSQLIndex(Index: Integer; Value: TStrings);
    procedure SetCount(Val : integer);
    procedure SetOnTerminateApply(const Value: TApplyEvent);
  protected
    function GetDataSet: TBDEDataSet; override;
    procedure SetDataSet(ADataSet: TBDEDataSet); override;
    function  CreateStatements: TDBUpdateStatements; dynamic;
    procedure SetTableIndex ( TableIndex : Integer);
    procedure Loaded;override;
//    procedure ReadUPDSt(Reader: TReader);
//    procedure WriteUPDSt(Writer: TWriter);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Apply(UpdateKind: TUpdateKind); override;
    procedure ExecSQL(UpdateKind: TUpdateKind);
    procedure SetParams(UpdateKind: TUpdateKind);
    procedure AddStatement;
    procedure DelStatement;
    property DataSet;
    property Query[UpdateKind: TUpdateKind]: TQuery read GetQuery;
    property SQL[UpdateKind: TUpdateKind]: TStrings read GetSQL write SetSQL;
//    procedure DefineProperties(Filer: TFiler); override;
  published
    property ModifySQL: TStrings index 0 read GetSQLIndex write SetSQLIndex;
    property InsertSQL: TStrings index 1 read GetSQLIndex write SetSQLIndex;
    property DeleteSQL: TStrings index 2 read GetSQLIndex write SetSQLIndex;
    property TableIndex : Integer read FTableIndex write SetTableIndex;
    property TableCount : Integer read FStmtsCount write SetCount;
    property UPDStatements: TDBUpdateStatements read FStmts write FStmts ;
    property OnTerminateApply : TApplyEvent read FOnTerminateApply write SetOnTerminateApply;
  end;

{ TDSPersistRadioGroup }
  TDSPersistLink=class;

  TDSPersistChild = string;

  TListOfChildsProperty = class(TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes;override;
    procedure GetValues(Proc: TGetStrProc);override;
    function GetValue: string;override;
    procedure SetValue(const Value: string);override;
  end;


  TDSPersistRButton = class(TRadioButton)
  private
    FDataLink: TDSPersistLink;
    FOnChange: TNotifyEvent;
    FSelChild : TDSPersistChild;
    function GetDataSource: TDataSource;
    function GetReadOnly: Boolean;
    procedure SetDataSource(ADataSource: TDataSource);
    procedure SetReadOnly(Value: Boolean);
  protected
    FInSetValue: Boolean;
    procedure Change; dynamic;
    procedure Click; override;
    procedure KeyPress(var Key: Char); override;
    function CanModify: Boolean;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property DataLink: TDSPersistLink read FDataLink;
    procedure DataLinkActiveChanged;
    procedure DataLinkRecordChanged(Field: TField);
    procedure Loaded;override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property DataSrcChild : TDSPersistChild read FSelChild write FSelChild;
  end;

  TDSPersistCheckBox= class(TCheckBox)
  private
    FDataLink: TDSPersistLink;
    FOnChange: TNotifyEvent;
    FSelChild : TDSPersistChild;
    function GetDataSource: TDataSource;
    function GetReadOnly: Boolean;
    procedure SetDataSource(ADataSource: TDataSource);
    procedure SetReadOnly(Value: Boolean);
  protected
    FInSetValue: Boolean;
    procedure Change; dynamic;
    procedure Click; override;
    procedure KeyPress(var Key: Char); override;
    function CanModify: Boolean;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property DataLink: TDSPersistLink read FDataLink;
    procedure DataLinkActiveChanged;
    procedure DataLinkRecordChanged(Field: TField);
    procedure Loaded;override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property DataSrcChild : TDSPersistChild read FSelChild write FSelChild;
  end;


  TDSPersistRadioGroup = class(TCustomRadioGroup)
  private
    FDataLink: TDSPersistLink;
    FValue: string;
    FValues: TStrings;
    FInSetValue: Boolean;
    FOnChange: TNotifyEvent;
    //procedure UpdateData(Sender: TObject);
    function GetDataSource: TDataSource;
    function GetReadOnly: Boolean;
    function GetButtonValue(Index: Integer): string;
    procedure SetDataSource(ADataSource: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure SetValue(const Value: string);
    procedure SetItems(Value: TStrings);
    procedure SetValues(Value: TStrings);
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  protected
    procedure Change; dynamic;
    procedure Click; override;
    procedure KeyPress(var Key: Char); override;
    function CanModify: Boolean; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property DataLink: TDSPersistLink read FDataLink;
    procedure DataLinkActiveChanged;
    procedure DataLinkRecordChanged(Field: TField);
    procedure Loaded;override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Value: string read FValue write SetValue;
    property ItemIndex;

  published
    property Align;
    property Caption;
    property Color;
    property Columns;
    property Ctl3D;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Items write SetItems;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Values: TStrings read FValues write SetValues;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDrag;
  end;

  TDSPersistLink = class(TDataLink)
  private
    FDSPersistControl: TWinControl;
  protected
    procedure ActiveChanged; override;
    procedure RecordChanged(Field: TField); override;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Persistencia', [TUpdateObjectView]);
//  RegisterComponents('Persistencia', [TDSPersist]);
//  RegisterComponents('Persistencia', [TQueryPersist]);
//  RegisterComponents('Persistencia', [TDSPersistRadioGroup]);
//  RegisterComponents('Persistencia', [TDSPersistCheckBox]);
//  RegisterComponents('Persistencia', [TDSPersistRButton]);
  RegisterPropertyEditor(TypeInfo(TDSPersistChild),nil,'',TListOfChildsProperty);
end;

{ TQueryPersist }

constructor TQueryPersist.Create(AOwner: TComponent);
begin
//showmessage (self.name + '-> QPersist Begin Create');
  inherited Create(AOwner);
  //FLinkedDataObject:=TDSPersist.Create (self);
//showmessage (self.name + '-> QPersist End Create');
end;

destructor TQueryPersist.Destroy;
begin
  inherited Destroy;
end;

procedure TQueryPersist.SetDataObject(ADataObject: TDSPersist);
begin
//showmessage (self.name + '-> QPersist.SetDataObject Begin ');
FLinkedDataObject := ADataObject;
if ADataObject <> nil then ADataObject.FreeNotification(Self);
end;

function TQueryPersist.GetDataObject : TDSPersist;
begin
//showmessage (self.name + '-> QPersist.GetDataObject Begin ');
     Result:= FLinkedDataObject;
end;

procedure TQueryPersist.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
//showmessage (self.name + '-> QPersist.Notification Begin ');
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FLinkedDataObject <> nil) and
     (AComponent = FLinkedDataObject) and (csDesigning	in ComponentState) then
     begin
     FLinkedDataObject := nil;
     end;
end;

procedure TQueryPersist.Loaded;
var
NomeCampo : string;
I,Posicao : integer;
Campos : TStringList;
begin
     inherited Loaded;
//showmessage (self.name + '-> QPersist Loaded Begin');
     CampoID:='';
     CampoPai:='';
     IDPai:='';
     CampoOUID:='';

     if SQL.Count = 0 then
        begin
        exit;
        end;

     Campos:= TStringList.Create;
     GetFieldNames (Campos);

     if (Pos ('.', Campos[0]) = 0) then
        begin
        Campos.Sort;
        I:=1;
        NomeCampo:='OUID_' + IntToStr(I);
        while Campos.Find (NomeCampo,Posicao) do
           begin
           Inc(I);
           NomeCampo:='OUID_' + IntToStr(I);
           end;

        if (I > 1) then
           begin
           Dec (I);
           CampoID:='OUID_' + IntToStr(I);
           CampoPai:='OUIDPai_' + IntToStr(I);
           Dec (I);
           if (I > 0) then
              IDPai:='OUID_' + IntToStr(I)
           else
               IDPai:='OUID';

           end
        else
            begin
            CampoID:='OUID';
            CampoPai:='OUIDPai';
            IDPai:='';
            end;
        CampoOUID:='OUID';
        end
     else
        begin
        for I:=0 to Campos.Count - 1 do
            begin
            if Pos('.OUID', Campos[I]) <> 0 then
               begin
               CampoOUID:=Campos[I];
               break;
               end;
            end;

        if CampoOUID='' then
           begin
           CampoID:='OUID';
           CampoPai:='OUIDPai';
           IDPai:='';
           CampoOUID:='OUID';
           Campos.Free;
           exit;
           end;

        for I:=Campos.Count - 1 downto 0 do
            begin
            if CampoPai='' then
               if Pos ('.OUIDPai', Campos[I]) <> 0 then
                  begin
                  CampoPai:=Campos[I];
                  Continue;
                  end;

            if CampoID='' then
               if Pos ('.OUID', Campos[I]) <> 0 then
                  begin
                  CampoID:=Campos[I];
                  Continue;
                  end;

            if IDPai='' then
               if Pos ('.OUID', Campos[I]) <> 0 then
                  begin
                  IDPai:=Campos[I];
                  break;
                  end;
            end;
        end;



     Campos.Free;


//showmessage (self.name + '-> QPersist Loaded End');

//     ShowMessage('Carregou');
{
Estados[dsInactive]:='dsInactive';
Estados[dsBrowse]:='dsBrowse';
Estados[dsEdit]:='dsEdit';
Estados[dsInsert]:='dsInsert';
Estados[dsSetKey]:='dsSetKey';
Estados[dsCalcFields]:='dsCalcFields';
Estados[dsUpdateNew]:='dsUpdateNew';
Estados[dsUpdateOld]:='dsUpdateOld';
Estados[dsFilter]:='dsFilter';
}
end;

procedure TQueryPersist.DoBeforePost;
var
Campo : string;
I : integer;
begin
//showmessage (self.name + '-> QPersist.DoBeforePost Begin ');
if not Assigned (LkedDataObject) then exit;

if Assigned (LkedDataObject.DataAncestor) and
            (LkedDataObject.FMoveKind in [mvUp,mvNone]) and
            (LkedDataObject.DataAncestor.DataSet.State <> dsBrowse) then
            begin
            (LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvUp;

            if Assigned (LkedDataObject.DataAncestor.DataSet) then
                        LkedDataObject.DataAncestor.DataSet.Post;

            LkedDataObject.FMoveKind:=mvDown;
             for I := 0 to LkedDataObject.DataAncestor.DataSet.FieldCount - 1 do
                 begin
                 Campo:=LkedDataObject.DataAncestor.DataSet.Fields[i].FieldName;
                 if Assigned (FindField (Campo)) then             
                           if (LkedDataObject.DataAncestor.DataSet.Fields[i].FieldKind =fkData) then
                               if (FieldValues [Campo] <> LkedDataObject.DataAncestor.DataSet.FieldValues[Campo]) then
                                  FieldValues [Campo]:= (LkedDataObject.DataAncestor.DataSet.FieldValues[Campo]); //Campo
                 end;
            LkedDataObject.FMoveKind:=mvNone;

            (LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvNone;
            end;
end;

procedure TQueryPersist.DoBeforeCancel;
var
I:integer;
ADescendant : TDSPersist;
begin

//showmessage (self.name + '-> QPersist.DoBeforeCancel Begin ');
if not Assigned (LkedDataObject) then exit;

//ShowMessage('Cancel : ' +Name+'  '+ Estados[LkedDataObject.State]);


if Assigned (LkedDataObject.DataAncestor) and
            (LkedDataObject.FMoveKind in [mvUp,mvNone]) and
            ((LkedDataObject.DataAncestor as TDSPersist).Abstrata = True) and
            (LkedDataObject.DataAncestor.DataSet.State <> dsBrowse) then
            begin
            (LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvUp;

            if Assigned (LkedDataObject.DataAncestor.DataSet) then
                        //LkedDataObject.DataAncestor.DataSet.Cancel;
                        LkedDataObject.DataAncestor.DataSet.Post;

            (LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvNone;
            end;


if  ((LkedDataObject.Descendents.Count > 0) and (LkedDataObject.FMoveKind in [mvDown,mvNone]))  then
    begin
    for I:=0 to (LkedDataObject.Descendents.Count - 1) do
        begin
        ADescendant:= TDSPersist(LkedDataObject.Descendents.Items[I]);
        if  Assigned(ADescendant) then
            begin
            ADescendant.FMoveKind:=mvDown;
            if Assigned (ADescendant.DataSet) then
               begin
               ADescendant.DataSet.Cancel;
               end;
            ADescendant.FMoveKind:=mvNone;
            end;
        end;
    end;


  inherited DoBeforeCancel;
end;

procedure TQueryPersist.DoBeforeClose;
var
I:integer;
ADescendant : TDSPersist;
begin

//showmessage (self.name + '-> QPersist.DoBeforeClose Begin ');
if not Assigned (LkedDataObject) then exit;

//ShowMessage('Cancel : ' +Name+'  '+ Estados[LkedDataObject.State]);

if Assigned (LkedDataObject.DataAncestor) and
            (LkedDataObject.FMoveKind in [mvUp,mvNone]) and
            Assigned ((LkedDataObject.DataAncestor as TDSPersist).ActiveDescendant) and
            Assigned ((LkedDataObject.DataAncestor as TDSPersist).ActiveDescendant.DataSet) and
            ((LkedDataObject.DataAncestor as TDSPersist).ActiveDescendant.DataSet=self) then
            begin
            (LkedDataObject.DataAncestor as TDSPersist).ActiveDescendant:=nil;

            end;

if  ((LkedDataObject.Descendents.Count > 0) and (LkedDataObject.FMoveKind in [mvDown,mvNone]))  then
    begin
    for I:=0 to (LkedDataObject.Descendents.Count - 1) do
        begin
        ADescendant:= TDSPersist(LkedDataObject.Descendents.Items[I]);
        if  Assigned(ADescendant) then
            begin
            ADescendant.FMoveKind:=mvDown;
            if Assigned (ADescendant.DataSet) then
               begin
               ADescendant.DataSet.Close;
               end;
            ADescendant.FMoveKind:=mvNone;
            end;
        end;
    end;

  inherited DoBeforeClose;
end;



procedure TQueryPersist.DoBeforeDelete;
var
I:integer;
ADescendant,MyAncestor : TDSPersist;
Campo: string;
begin

//showmessage (self.name + '-> QPersist.DoBeforeDelete Begin ');
if not Assigned (LkedDataObject) then exit;

//ShowMessage('Cancel : ' +Name+'  '+ Estados[LkedDataObject.State]);

MyAncestor:=nil;

if Assigned (LkedDataObject.DataAncestor) then
   MyAncestor:= LkedDataObject.DataAncestor as TDSPersist;

if Assigned (MyAncestor) and
            (LkedDataObject.FMoveKind in [mvUp,mvNone]) and
            (MyAncestor.Abstrata=True) then
            begin
            MyAncestor.FMoveKind:=mvUp;

            if Assigned (MyAncestor.DataSet) and MyAncestor.CheckNoChilds(LkedDataObject) then
                        MyAncestor.DataSet.Delete;

            MyAncestor.FMoveKind:=mvNone;
            end;

if  ((LkedDataObject.Descendents.Count > 0) and (LkedDataObject.FMoveKind in [mvDown,mvNone]))  then
    begin
    Campo:=FieldByName(CampoOUID).AsString;
    for I:=0 to (LkedDataObject.Descendents.Count - 1) do
        begin
        ADescendant:= TDSPersist(LkedDataObject.Descendents.Items[I]);
        if  Assigned(ADescendant) then
            begin
            ADescendant.FMoveKind:=mvDown;
            if Assigned (ADescendant.DataSet) then
               begin
               if ((ADescendant.DataSet.BOF or ADescendant.DataSet.EOF)=True) then
                  ADescendant.DataSet.First;
               if (ADescendant.DataSet.Locate(CampoOUID,Campo,[])) then //OUIDPai
                  begin
                  ADescendant.DataSet.Delete;
                  ADescendant.Enabled:=False;
                  end;
               end;
            ADescendant.FMoveKind:=mvNone;
            end;
        end;
    end;

  inherited DoBeforeDelete;
end;

procedure TQueryPersist.DoAfterDelete;
var
MyAncestor : TDSPersist;
begin

//showmessage (self.name + '-> QPersist.DoAfterDelete Begin ');
if not Assigned (LkedDataObject) or
   not Assigned (LkedDataObject.DataAncestor) then exit;

MyAncestor:= LkedDataObject.DataAncestor as TDSPersist;
//Campo := MyAncestor.DataSet.FieldByName('OUID').AsString;
//MyAncestor.DataSet.Locate('OUID',Campo,[]);
if (MyAncestor.FMoveKind = mvNone) and
   (LkedDataObject.FMoveKind <> mvDown) then
   MyAncestor.DataSet.Next;

if Assigned (LkedDataObject.DataAncestor) and
   ((LkedDataObject.DataAncestor as TDSPersist).Abstrata=False) and
   (LkedDataObject.OneOf = False) then
      begin
      LkedDataObject.Enabled:=True;
      if (LkedDataObject.FMoveKind = mvNone) then
         Refresh;
      end;
end;

procedure TQueryPersist.DoBeforeEdit;
var
I:integer;
ADescendant : TDSPersist;
Campo: string;
begin

//showmessage (self.name + '-> QPersist.DoBeforeEdit Begin ');
if not Assigned (LkedDataObject) then exit;

//ShowMessage('Cancel : ' +Name+'  '+ Estados[LkedDataObject.State]);

if Assigned (LkedDataObject.DataAncestor) and
            (LkedDataObject.FMoveKind in [mvUp,mvNone]) then
            begin
            (LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvUp;

            if Assigned (LkedDataObject.DataAncestor.DataSet) then
                        LkedDataObject.DataAncestor.DataSet.Edit;

            (LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvNone;
            end;

if  ((LkedDataObject.Descendents.Count > 0) and (LkedDataObject.FMoveKind in [mvDown,mvNone]))  then
    begin
    Campo:=FieldByName(CampoOUID).AsString;
    for I:=0 to (LkedDataObject.Descendents.Count - 1) do
        begin
        ADescendant:= TDSPersist(LkedDataObject.Descendents.Items[I]);
        if  Assigned(ADescendant) then
            begin
            ADescendant.FMoveKind:=mvDown;
            if Assigned (ADescendant.DataSet) then
               begin
               if (ADescendant.DataSet.Locate(CampoOUID,Campo,[])) then //OUIDPai
                  begin
                  ADescendant.DataSet.Edit;
                  ADescendant.Enabled:=True;
                  end;
               end;
            ADescendant.FMoveKind:=mvNone;
            end;
        end;
    end;

  inherited DoBeforeEdit;
end;

procedure TQueryPersist.DoBeforeInsert;
begin

//showmessage (self.name + '-> QPersist.DoBeforeInsert Begin ');
if not Assigned (LkedDataObject) then exit;
if LkedDataObject.InTopDown then
   begin
   inherited DoBeforeInsert;
   exit;
   end;
//ShowMessage('Cancel : ' +Name+'  '+ Estados[LkedDataObject.State]);

if Assigned (LkedDataObject) then LkedDataObject.NewObjectID:=TDSPersist.CreateNewGUID;

if Assigned (LkedDataObject.DataAncestor) and
            (LkedDataObject.FMoveKind in [mvUp,mvNone]) then
            if ((LkedDataObject.DataAncestor as TDSPersist).Abstrata = True) then
               begin
               (LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvUp;

               if Assigned (LkedDataObject.DataAncestor.DataSet) then
                        LkedDataObject.DataAncestor.DataSet.Insert;

               (LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvNone;
               end
            else
                if Assigned (LkedDataObject.DataAncestor.DataSet) and
                   (LkedDataObject.DataAncestor.DataSet.FieldByName (CampoOUID).AsString =
                   FieldByName(CampoOUID).AsString) then
                   begin
                        //(LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvUp;
                        LkedDataObject.DataAncestor.DataSet.Insert;
                        //(LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvDown;
                   end;




if Assigned (LkedDataObject.ActiveDescendant)  and
            (LkedDataObject.FMoveKind in [mvDown,mvNone]) then

            if (LkedDataObject.Abstrata = True) then
               begin
               LkedDataObject.ActiveDescendant.FMoveKind:=mvDown;

               if Assigned (LkedDataObject.ActiveDescendant.DataSet) then
                           LkedDataObject.ActiveDescendant.DataSet.Insert;

               LkedDataObject.ActiveDescendant.Enabled:=True;
               LkedDataObject.ActiveDescendant.FMoveKind:=mvNone;
               end;
//            else
//                LkedDataObject.ActiveDescendant:=nil;


  inherited DoBeforeInsert;
end;

procedure TQueryPersist.DoAfterInsert;
var
Campo : string;
I : integer;
begin
//So pra setar FModified = True
//OUID := FieldByName('OUID').AsString;
//FieldByName('OUID').AsString := OUID;


//showmessage (self.name + '-> QPersist.DoAfterInsert Begin ');
if Assigned (LkedDataObject) then
   begin
   FieldByName(CampoID).AsString := LkedDataObject.NewObjectID;

   if (LkedDataObject.FMoveKind = mvUp) then
            begin

            if Assigned (LkedDataObject.DataAncestor) and
               Assigned (LkedDataObject.DataAncestor.DataSet) then

               FieldByName(CampoPai).AsString:=
                    LkedDataObject.DataAncestor.DataSet.FieldByName(IDPai).AsString;
            end;

   if (LkedDataObject.FMoveKind = mvDown) then
//      if (LkedDataObject.Abstrata = True) then
               begin

               if Assigned (LkedDataObject.DataAncestor) then
                  if Assigned (LkedDataObject.DataAncestor.DataSet) and
                     (LkedDataObject.DataAncestor.DataSet.State <> dsBrowse) then
                     FieldByName(CampoPai).AsString := TDSPersist(LkedDataObject.DataAncestor).NewObjectID
                  else
                      FieldByName(CampoPai).AsString:=
                                 LkedDataObject.DataAncestor.DataSet.FieldByName(IDPai).AsString;


               end;

   if (LkedDataObject.FMoveKind = mvNone) then
               begin

               if Assigned (LkedDataObject.DataAncestor) then
                  begin
                  FieldByName(CampoPai).AsString := TDSPersist(LkedDataObject.DataAncestor).NewObjectID;
                  if ((LkedDataObject.DataAncestor as TDSPersist).Abstrata = True) then
                     FieldByName(IDPai).AsString := TDSPersist(LkedDataObject.DataAncestor).NewObjectID
                  else
                      begin
                      for I := 0 to LkedDataObject.DataAncestor.DataSet.FieldCount - 1 do
                          begin
                          Campo:=LkedDataObject.DataAncestor.DataSet.Fields[i].FieldName;
                          if Assigned (FindField (Campo)) then
                           if (LkedDataObject.DataAncestor.DataSet.Fields[i].FieldKind =fkData) then
                             if (FieldValues[Campo] <> LkedDataObject.DataAncestor.DataSet.FieldValues[Campo]) then
                                FieldValues [Campo]:=(LkedDataObject.DataAncestor.DataSet.FieldValues[Campo]);//Campo
                          end;
                      end;
                  end;

               end;
               
    if Assigned (LkedDataObject.DataAncestor) and
       ((LkedDataObject.DataAncestor as TDSPersist).Abstrata=False) and
       (LkedDataObject.OneOf = False) then
            begin
            LkedDataObject.Enabled:=True;
            if (LkedDataObject.FMoveKind = mvNone) then
               Refresh;
            end;


   end;
end;

procedure TQueryPersist.DoOnNewRecord;
begin
//     ShowMessage('NewRecord');
{  FieldByName(CampoID).AsString := TDSPersist.CreateNewGUID;

  if Assigned (LkedDataObject.DataAncestor) and
     Assigned (LkedDataObject.DataAncestor.DataSet) then

     FieldByName(CampoPai).AsString:=
             LkedDataObject.DataAncestor.DataSet.FieldByName(IDPai).AsString;
}
  inherited DoOnNewRecord;
end;

procedure TQueryPersist.DoAfterOpen;
begin
//First;
end;

procedure TQueryPersist.DoBeforeOpen;
var
I:integer;
ADescendant : TDSPersist;
begin
exit;
//showmessage (self.name + '-> QPersist.DoBeforeOpen Begin ');
if not Assigned (LkedDataObject) then exit;

//ShowMessage('Open : ' +Name+'  '+ Estados[LkedDataObject.State]);

if Assigned (LkedDataObject.DataAncestor) and
            (LkedDataObject.FMoveKind in [mvUp,mvNone]) then
            begin
            (LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvUp;

            if Assigned (LkedDataObject.DataAncestor.DataSet) then
                        LkedDataObject.DataAncestor.DataSet.Open;

            (LkedDataObject.DataAncestor as TDSPersist).FMoveKind:=mvNone;
            end;

 if  ((LkedDataObject.Descendents.Count > 0) and
     (LkedDataObject.Abstrata = True) and
     (LkedDataObject.FMoveKind in [mvDown,mvNone]))  then
    begin
    for I:=0 to (LkedDataObject.Descendents.Count - 1) do
        begin
        ADescendant:= TDSPersist(LkedDataObject.Descendents.Items[I]);
        if  Assigned(ADescendant) then
            begin
            ADescendant.FMoveKind:=mvDown;
            if Assigned (ADescendant.DataSet) then
               begin
               ADescendant.DataSet.Open;
               end;
            ADescendant.FMoveKind:=mvNone;
            end;
        end;
    end;

  inherited DoBeforeOpen;
end;


{ TDSPersist }

class function TDSPersist.CreateNewGUID: string;
var
NewGUID: TGUID;
NewString : array [0..49] of WideChar;
begin
if Succeeded (CoCreateGuid(NewGUID)) then
   begin
   StringFromGUID2 (NewGUID, @NewString, 40);
   Result:= WideCharToString (NewString);
   end
else
    Result:='';
end;

procedure TDSPersist.SetDescendant (Value : TDSPersist);
var
OldDescendant : TDSPersist;
begin

OldDescendant:= FActiveDescendant;

FActiveDescendant:=Value;

if Assigned (OldDescendant) and
   (OldDescendant <> FActiveDescendant) and
   OldDescendant.OneOf then
   begin
   if (OldDescendant.Enabled) then
      if (OldDescendant.DataSet.State <> dsBrowse) then
         begin
         OldDescendant.FMoveKind:=mvDown;
         OldDescendant.DataSet.Cancel;
         OldDescendant.FMoveKind:=mvNone;
         end

      else
          if not Scrolling then
             begin
             FMoveKind:=mvDown;
             OldDescendant.FMoveKind:=mvDown;
             OldDescendant.DataSet.Delete;
             OldDescendant.FMoveKind:=mvNone;
             FMoveKind:=mvNone;
             end;
       OldDescendant.Enabled:=False;
{             while Assigned (OldDescendant) do
                   begin
                   OldDescendant.Enabled:=False;
                   OldDescendant:= OldDescendant.ActiveDescendant;
                   end;
 }
   end;

if Assigned(FActiveDescendant.DataSet) and
   (FActiveDescendant.DataSet.State=dsInactive) then
          FActiveDescendant.DataSet.Open;

end;


procedure TDSPersist.SetActiveDescendant ( Index : integer);
var
Campo : string;
I : integer;
begin

if Index > Descendents.Count then exit;

if not (TDSPersist(Descendents.Items[Index]).OneOf) then exit;
if not Assigned(TDSPersist(Descendents.Items[Index]).DataSet) then exit;

ActiveDescendant:=TDSPersist(Descendents.Items[Index]);

if Assigned (FActiveDescendant) then
   begin

//   FActiveDescendant.InTopDown:=True;

   if (DataSet.BOF and DataSet.EOF) and (DataSet.State = dsBrowse) then
      begin
//      InTopDown:=True;
      DataSet.Insert;
      exit;
//      InTopDown:=False;
      end;

   Campo:=DataSet.FieldByName((DataSet as TQueryPersist).CampoOUID).AsString;


   if not (FActiveDescendant.DataSet.Locate((FActiveDescendant.DataSet as TQueryPersist).CampoOUID,Campo,[])) then
      begin
      FActiveDescendant.FMoveKind:=mvDown;
      FActiveDescendant.DataSet.Insert;

      for I := 0 to DataSet.FieldCount - 1 do
          begin
          Campo:=DataSet.Fields[i].FieldName;
          if Assigned (FActiveDescendant.DataSet.FindField (Campo)) then
             if (DataSet.Fields[i].FieldKind =fkData) then
                if (FActiveDescendant.DataSet.FieldValues [Campo] <> DataSet.FieldValues[Campo]) then
                 FActiveDescendant.DataSet.FieldValues [Campo]:=(DataSet.FieldValues[Campo]);//Campo
          end;
       FActiveDescendant.FMoveKind:=mvNone;

      end;

   FActiveDescendant.Enabled:=True;

   FActiveDescendant.InTopDown:=False;

   end;
end;

procedure TDSPersist.SetSingleActiveDescendant ( ChildName : string);
var
NomeFilho : string;
I : integer;
ADescendant: TDSPersist;
begin

ADescendant:=nil;

for I:=0 to (Descendents.Count - 1) do
    if (TDSPersist(Descendents[I]).OneOf = False) then
       begin
       ADescendant:= TDSPersist(Descendents[I]);
       NomeFilho:= ADescendant.Name;
       Delete (NomeFilho,1,1);
       if (NomeFilho = ChildName) then
          break
       else
           ADescendant:=nil;
       end;

if (ADescendant = nil) or
   not Assigned(ADescendant.DataSet) then
   exit;

SetActiveDescendant (I);

end;


procedure TDSPersist.SetMultipleInterfaceDescendant ( ChildName : string);
var
Campo, NomeFilho : string;
I : integer;
ADescendant: TDSPersist;
begin

ADescendant:=nil;

for I:=0 to (Descendents.Count - 1) do
    if (TDSPersist(Descendents[I]).OneOf = False) then
       begin
       ADescendant:= TDSPersist(Descendents[I]);
       NomeFilho:= ADescendant.Name;
       Delete (NomeFilho,1,1);
       if (NomeFilho = ChildName) then
          break
       else
           ADescendant:=nil;
       end;

if (ADescendant = nil) or
   not Assigned(ADescendant.DataSet) then
   exit;

if Assigned(ADescendant.DataSet) and
   (ADescendant.DataSet.State=dsInactive) then
          ADescendant.DataSet.Open;

if (DataSet.BOF and DataSet.EOF) and (DataSet.State = dsBrowse) then
   begin
   DataSet.Insert;
   exit;
   end;

Campo:=DataSet.FieldByName((DataSet as TQueryPersist).CampoOUID).AsString;


if not (ADescendant.DataSet.Locate((ADescendant.DataSet as TQueryPersist).CampoOUID,Campo,[])) then
   begin
   ADescendant.FMoveKind:=mvDown;
   ADescendant.DataSet.Insert;

   for I := 0 to DataSet.FieldCount - 1 do
       begin
       Campo:=DataSet.Fields[i].FieldName;
       if Assigned (ADescendant.DataSet.FindField (Campo)) then
          if (DataSet.Fields[i].FieldKind =fkData) then
             if (ADescendant.DataSet.FieldValues [Campo] <> DataSet.FieldValues[Campo]) then
             ADescendant.DataSet.FieldValues [Campo]:=(DataSet.FieldValues[Campo]); //Campo
       end;
   ADescendant.FMoveKind:=mvNone;

   end;

ADescendant.Enabled:=True;

ADescendant.InTopDown:=False;

end;

procedure TDSPersist.ReSetMultipleInterfaceDescendant ( ChildName : string);
var
I : integer;
ADescendant: TDSPersist;
NomeFilho : string;
begin

ADescendant:=nil;

for I:=0 to (Descendents.Count - 1) do
    if (TDSPersist(Descendents[I]).OneOf = False) then
       begin
       ADescendant:= TDSPersist(Descendents[I]);
       NomeFilho:= ADescendant.Name;
       Delete (NomeFilho,1,1);
       if (NomeFilho = ChildName) then
          break
       else
           ADescendant:=nil;
       end;

if (ADescendant = nil) or
   not Assigned(ADescendant.DataSet) or
   not ADescendant.Enabled then
   exit;


if (ADescendant.DataSet.State <> dsBrowse) then
   begin
   ADescendant.FMoveKind:=mvDown;
   ADescendant.DataSet.Cancel;
   ADescendant.FMoveKind:=mvNone;
   end
else
    if not Scrolling then
       begin
       FMoveKind:=mvDown;
       ADescendant.FMoveKind:=mvDown;
       ADescendant.DataSet.Delete;
       ADescendant.DataSet.First;//1703
       ADescendant.FMoveKind:=mvNone;
       FMoveKind:=mvNone;
       end;

//ADescendant.Enabled:=False;

end;

procedure TQueryPersist.DataEvent(Event: TDataEvent; Info: Longint);
begin
if Assigned (LkedDataObject) then
   begin
      case Event of
        deFieldChange:
          LkedDataObject.DSDataChange(Self, TField(Info));
        deRecordChange, deDataSetChange, deDataSetScroll, deLayoutChange:
          LkedDataObject.DSDataChange(Self, nil);
      end;
   end;
inherited;
end;



procedure TDSPersist.DSDataChange(Sender: TObject; Field: TField);
var
SearchOptions: TLocateOptions;
Campo : string;
I : integer;
ADescendant : TDSPersist;
RefreshField : TField;

begin
SearchOptions:=[loCaseInsensitive];

//showmessage (self.name + '-> TDSPersist.DSDataChange Begin ');

if InTopDown then exit;

if (Field=nil) and
   (DataSet.State=dsBrowse) and
   not (csLoading in ComponentState)then //and (DataSet.State = dsBrowse)
   begin
   Campo:=DataSet.FieldByName((DataSet as TQueryPersist).CampoOUID).AsString; //OUIDPai
   //ShowMessage('DataChange: Moveu DataSet ->' + ClassName +' '+Name+' '+Campo);
   if Assigned (DataAncestor) and
   Assigned (DataAncestor.DataSet) and
   (DataAncestor.DataSet.State <> dsInactive) and
   (FMoveKind in [mvUp,mvNone]) then
      begin
      (DataAncestor as TDSPersist).FMoveKind:=mvUp;
      DataAncestor.DataSet.Locate((DataAncestor.DataSet as TQueryPersist).CampoOUID,Campo,SearchOptions);
      (DataAncestor as TDSPersist).FMoveKind:=mvNone;
      end;

   if  ((Descendents.Count > 0) and (FMoveKind in [mvDown,mvNone]))  then
     begin
     if (FMoveKind=mvNone) then
        FCampo:=DataSet.FieldByName((DataSet as TQueryPersist).CampoOUID).AsString
     else
        FCampo:=(DataAncestor as TDSPersist).FCampo;

     for I:=0 to (Descendents.Count - 1) do
       begin
       ADescendant:= TDSPersist(Descendents.Items[I]);
       if  Assigned(ADescendant) and
           Assigned (ADescendant.DataSet) and
           (ADescendant.DataSet.State <> dsInactive) then
          begin
          ADescendant.FMoveKind:=mvDown;
          if ((ADescendant.DataSet.BOF or ADescendant.DataSet.EOF)=True) then
             ADescendant.DataSet.First;
          ADescendant.Enabled:=(ADescendant.DataSet.Locate((ADescendant.DataSet as TQueryPersist).CampoOUID,FCampo,SearchOptions));//OUIDPai
          if ADescendant.Enabled and ADescendant.OneOf then
             begin
             Scrolling:=True;
	     ActiveDescendant:=ADescendant;
             Scrolling:=False;
             end;
          ADescendant.FMoveKind:=mvNone;
          end;
       end;
     end;
   end;

   if (Field<>nil) and
   ((DataSet.State=dsEdit) or(DataSet.State=dsInsert)) and
   not (csLoading in ComponentState) then
   begin

   //ShowMessage('DataChange: DataChange : ' + ClassName +' '+ Name+' '+Field.Name +'  '+ Estados[State]);

   if Assigned (DataAncestor) and Assigned (DataAncestor.DataSet)
   and (FMoveKind in [mvUp,mvNone]) then
      begin
      (DataAncestor as TDSPersist).FMoveKind:=mvUp;
      RefreshField:=DataAncestor.DataSet.FindField(Field.FieldName);
      if Assigned (RefreshField) and
         (RefreshField.Value <> Field.Value) then
                 begin
                 if (DataAncestor.DataSet.State <> dsEdit) then     //23/03
                    DataAncestor.DataSet.Edit;                      //23/03
                 RefreshField.Assign(Field);
                 end;
      (DataAncestor as TDSPersist).FMoveKind:=mvNone;
      end;

   if  ((Descendents.Count > 0) and (FMoveKind in [mvDown,mvNone]))  then
     begin
     for I:=0 to (Descendents.Count - 1) do
       begin
       ADescendant:= TDSPersist(Descendents.Items[I]);
       if  Assigned(ADescendant) then
          begin
          ADescendant.FMoveKind:=mvDown;
          if Assigned (ADescendant.DataSet) and ADescendant.Enabled then
             begin
             RefreshField:=ADescendant.DataSet.FindField(Field.FieldName);

             if Assigned (RefreshField) then
                begin
                ADescendant.DataSet.Edit;
                RefreshField.Assign(Field);
                end;
             end;
          ADescendant.FMoveKind:=mvNone;
          end;
       end;
     end;

   end;


end;

constructor TDSPersist.Create(AOwner: TComponent);
begin
//showmessage (self.name + '-> TDSPersist Begin Create');
  inherited Create(AOwner);
  FDataAncestor:=nil;
  FDataDescendents := TList.Create;
  FMoveKind:=mvNone;
  FActiveDescendant:=nil;
  Enabled := False;
  FOneOf:=False;
  Scrolling:=False;
//showmessage (self.name + '-> TDSPersist End Create');
end;

destructor TDSPersist.Destroy;
begin
//showmessage (self.name + '-> TDSPersist.Destroy Begin ');
  while FDataDescendents.Count > 0 do RemoveDescendent(FDataDescendents.Last);
  FDataDescendents.Free;
  inherited Destroy;
end;

function  TDSPersist.CheckNoChilds (CurrentChild: TDSPersist) : Boolean;
var
I : integer;
ADescendent : TDSPersist;
begin
Result:=True;
//showmessage (self.name + '-> TDSPersist.CheckNoChilds Begin ');

     for I:=0 to FDataDescendents.Count -1 do
         begin
         ADescendent:= FDataDescendents[I];
         if (ADescendent <> CurrentChild) and
            (ADescendent.Enabled) then
            begin
            Result:=False;
            break;
            end;
         end;
end;


procedure TDSPersist.AddDescendent(Descendent: TDSPersist);
begin
//showmessage (self.name + '-> TDSPersist.AddDescendent Begin ');
//and not(csLoading in ComponentState)
  if Assigned (Descendent)  then
     begin
     FDataDescendents.Add(Descendent);

     if not Assigned (FActiveDescendant) and
            (Descendent.OneOf=True) then
            begin
            FActiveDescendant:= Descendent;

            if (Abstrata=True) then
               FActiveDescendant.Enabled:=True;
            end;

     Descendent.FDataAncestor := self;
     Descendent.FreeNotification(Self);
     end;
end;

procedure TDSPersist.RemoveDescendent(Descendent: TDSPersist);
begin
//showmessage (self.name + '-> TDSPersist.RemoveDescendent Begin ');
  Descendent.FDataAncestor := nil;
  FDataDescendents.Remove(Descendent);
end;

procedure TDSPersist.SetDataSet(ADataSet: TDBDataSet);

begin
  if Assigned (ADataSet) and not(csLoading in ComponentState) then
     begin

     if (ADataSet is TQueryPersist) then
        (ADataSet as TQueryPersist).FLinkedDataObject:=self;

     if not Assigned(ADataSet.UpdateObject) then
        begin
        ShowMessage (' Defina a propriedade UpdateObject');
        exit;
        end;

     if Assigned (DataAncestor) and (DataAncestor is TDSPersist) then
        begin
        if Assigned(TDBDataSet(FDataAncestor.DataSet)) and
           Assigned(TDBDataSet(FDataAncestor.DataSet).UpdateObject)then
           (ADataSet.UpdateObject as TUpdateObjectView).TableIndex:=
            (TDBDataSet(FDataAncestor.DataSet).UpdateObject as TUpdateObjectView).TableCount;
        end
     else
          (ADataSet.UpdateObject as TUpdateObjectView).TableIndex:=0;

     end;
  inherited DataSet:=ADataSet;
end;

function TDSPersist.GetDataSet : TDBDataSet;
begin
//showmessage (self.name + '-> TDSPersist.GetDataSet Begin ');
  Result:=TDBDataSet (inherited DataSet);
end;

procedure TDSPersist.SetDataAncestor(ADataAncestor: TDataSource);
var
MyAncestor : TDSPersist;
begin
//showmessage (self.name + '-> TDSPersist.SetDataAncestor Begin ');

if (not Assigned (ADataAncestor)) or
   (not(ADataAncestor is TDSPersist)) or
   (ADataAncestor = self) then
   exit;

MyAncestor := ADataAncestor as TDSPersist;

if not(csLoading in ComponentState) then
   begin

   if (not Assigned (MyAncestor.DataSet)) or
      (not Assigned(MyAncestor.DataSet.UpdateObject))or
      (not (MyAncestor.DataSet.UpdateObject is TUpdateObjectView)) then
      begin
           ShowMessage (' Defina um dataset com UpdateObject no ancestro e tente novamente');
           exit;
      end;

   if Assigned (FDataAncestor) then
      begin
      (FDataAncestor as TDSPersist).RemoveDescendent(self);
      if Assigned(DataSet.UpdateObject) then
             (DataSet.UpdateObject as TUpdateObjectView).TableIndex:=0;
      end;

   MyAncestor.AddDescendent(self);

   if Assigned(FDataAncestor) then
      begin
      if Assigned(DataSet) and
         Assigned(DataSet.UpdateObject) then
              (DataSet.UpdateObject as TUpdateObjectView).TableIndex:=
              (TDBDataSet(FDataAncestor.DataSet).UpdateObject as TUpdateObjectView).TableCount;

      MyAncestor.FreeNotification(Self);
      end
   else
       begin
       FDataAncestor:=nil;
       if Assigned(DataSet) and Assigned(DataSet.UpdateObject) then
          (DataSet.UpdateObject as TUpdateObjectView).TableIndex:=0;
       end;
   end
else
    FDataAncestor:=MyAncestor;
end;



procedure TDSPersist.Loaded;
var
AnAncestor : TDSPersist;
var
MyQuery : TQueryPersist;
begin
     inherited Loaded;
//showmessage (self.name + '-> DSPersist Loaded Begin');
     if Assigned (DataSet) then
        begin
        MyQuery:=(DataSet as TQueryPersist);
        MyQuery.LkedDataObject:=self;
        end;

     //OnDataChange:=DSDataChange;

     if not Assigned (FDataAncestor) then
         begin

         Enabled:=True;
         if Assigned (DataSet) and (DataSet.State <> dsInactive) then
            DataSet.First;
         end
     else
         begin
         (FDataAncestor as TDSPersist).AddDescendent(self);


         AnAncestor:=(FDataAncestor as TDSPersist);
         while Assigned(AnAncestor.FDataAncestor) do
               AnAncestor:=(AnAncestor.FDataAncestor as TDSPersist);

         if Assigned (AnAncestor.DataSet) then AnAncestor.DataSet.First;

         end;


    {
TipoUpdate[ukModify]:='ukModify';
TipoUpdate[ukInsert]:='ukInsert';
TipoUpdate[ukDelete]:='ukDelete';
}
//showmessage (self.name + '-> DSPersist Loaded End');
end;

procedure TDSPersist.Notification(AComponent: TComponent;
  Operation: TOperation);
var
I : integer;
begin
//showmessage (self.name + '-> TDSPersist.SetDataAncestor Begin ');
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataAncestor <> nil) and
     (AComponent = FDataAncestor) and (csDesigning in ComponentState) then
     begin
     FDataAncestor := nil;
     end;
  if (Operation = opRemove) and (csDesigning in ComponentState) then
     for I:=0 to Descendents.Count -1 do
          if Descendents[I] = AComponent then
             begin
             RemoveDescendent (AComponent as TDSPersist);
             break;
             end;
end;


{ TSQLStatement }

constructor TSQLStatement.Create(Collection: TCollection);
begin
//showmessage ('-> TSQLStatement Begin Create');
    inherited Create(Collection);
  if FStatement = nil then
    FStatement := TStringList.Create;
//showmessage ( '-> TSQLStatement End Create');
end;

destructor TSQLStatement.Destroy;
begin
  FStatement.Free;
  inherited Destroy;
end;

procedure TSQLStatement.Assign(Source: TPersistent);
begin
  if Source is TSQLStatement then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      RestoreDefaults;
      FStatement := TSQLStatement(Source).FStatement;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;


function TSQLStatement.GetStatement: TStrings;
begin
  if FStatement = nil then
    FStatement := TStringList.Create;
  Result := FStatement;
end;


procedure TSQLStatement.RestoreDefaults;
begin
  FStatement.Free;
  FStatement := nil;
end;


procedure TSQLStatement.SetStatement(Value: TStrings);
begin
  if Value = nil then
  begin
    FStatement.Free;
    FStatement := nil;
    Exit;
  end;
  FStatement.Assign(Value);
end;


{ TDBUpdateStatements }


function TDBUpdateStatements.GetOwner: TPersistent;
begin
  Result := FUpdCmp;
end;

constructor TDBUpdateStatements.Create(UpdCmp: TUpdateObjectView; StatementClass: TStatementClass);//TDBPersist
begin
//showmessage ( '-> TDBUpdateStatements Begin Create');
  inherited Create(StatementClass);
  FUpdCmp := UpdCmp;
//showmessage ( '-> TDBUpdateStatements End Create');
end;

function TDBUpdateStatements.Add: TSQLStatement;
begin
  Result := TSQLStatement(inherited Add);
end;

function TDBUpdateStatements.GetStatement(Index: Integer): TSQLStatement;
begin
  Result := TSQLStatement(inherited Items[Index]);
end;


procedure TDBUpdateStatements.LoadFromFile(const Filename: string);
var
  S: TFileStream;
begin
  S := TFileStream.Create(Filename, fmOpenRead);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

type
  TStatementsWrapper = class(TComponent)
  private
    FStatements: TDBUpdateStatements;
  published
    property Statements: TDBUpdateStatements read FStatements write FStatements;
  end;

procedure TDBUpdateStatements.LoadFromStream(S: TStream);
var
  Wrapper: TStatementsWrapper;
begin
  Wrapper := TStatementsWrapper.Create(nil);
  try
    Wrapper.Statements := FUpdCmp.CreateStatements;
    S.ReadComponent(Wrapper);
    Assign(Wrapper.Statements);
  finally
    Wrapper.Statements.Free;
    Wrapper.Free;
  end;
end;


procedure TDBUpdateStatements.RestoreDefaults;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Count-1 do
      Items[I].RestoreDefaults;
  finally
    EndUpdate;
  end;
end;


procedure TDBUpdateStatements.SetStatement(Index: Integer; Value: TSQLStatement);
begin
  Items[Index].Assign(Value);
end;


procedure TDBUpdateStatements.SaveToFile(const Filename: string);
var
  S: TStream;
begin
  S := TFileStream.Create(Filename, fmCreate);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TDBUpdateStatements.SaveToStream(S: TStream);
var
  Wrapper: TStatementsWrapper;
begin
  Wrapper := TStatementsWrapper.Create(nil);
  try
    Wrapper.Statements := Self;
    S.WriteComponent(Wrapper);
  finally
    Wrapper.Free;
  end;
end;


{ TUpdateObjectView }

{
procedure TUpdateObjectView.DefineProperties(Filer: TFiler);
  function DoWriteUPDSt: Boolean;
  begin
    if Filer.Ancestor <> nil then
    begin
      Result := True;
      if Filer.Ancestor is TUpdateObjectView then
        Result := not (FStmts.Items[0].Statement.Equals(TUpdateObjectView(Filer.Ancestor).FStmts.Items[0].Statement));
    end
    else Result := (FStmts.Count > 0);
  end;
begin
  inherited;
  Filer.DefineProperty('UPDSt',ReadUPDSt,WriteUPDSt,True);
end;

procedure TUpdateObjectView.ReadUPDSt(Reader: TReader);
begin
Reader.ReadCollection (FStmts);
end;

procedure TUpdateObjectView.WriteUPDSt(Writer: TWriter);
begin
Writer.WriteCollection (FStmts);
end;
}

procedure TUpdateObjectView.Loaded;
var
UpdateKind: TUpdateKind;
begin
  inherited Loaded;	{ always call the inherited Loaded first! }
  //Atualize as SQL
//showmessage (self.name + '-> UpdateObjectView Loaded Begin');
  for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
      SQL[UpdateKind];
//showmessage (self.name + '-> UpdateObjectView Loaded End');
end;

procedure TUpdateObjectView.SetTableIndex (TableIndex : Integer);
var
UpdateKind: TUpdateKind;
begin
//Aceite o valor sem validar pois estamos carregandos as variaveis
if (csLoading in ComponentState) or (csReading in ComponentState) or (csUpdating in ComponentState) then
   begin
   FTableIndex:=TableIndex;
   exit;
   end;

if ((TableIndex < 0) or (FStmtsCount=0) or (TableIndex > FStmtsCount)) then exit;
if (TableIndex = FStmtsCount) then AddStatement;
FTableIndex:=TableIndex;
for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
  SQL[UpdateKind];

end;

function TUpdateObjectView.CreateStatements: TDBUpdateStatements;
begin
  Result := TDBUpdateStatements.Create(  self, TSQLStatement);
  FStmtsCount:=0;
  FTableIndex:=0;
end;

procedure TUpdateObjectView.AddStatement;
var
  UpdateKind: TUpdateKind;
  NewStatement: TSQLStatement;
begin
  FStmts.BeginUpdate;
  for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
    begin
    NewStatement:=FStmts.Add;
    NewStatement.Statement := TStringList.Create;
    end;
  FStmtsCount:=FStmtsCount+1;
  SetTableIndex (FStmtsCount-1);
  FStmts.EndUpdate;
end;

procedure TUpdateObjectView.DelStatement;
var
  UpdateKind: TUpdateKind;
begin

if FStmtsCount = 1 then
   begin
    FStmts.BeginUpdate;
    for UpdateKind := High(TUpdateKind) downto Low(TUpdateKind) do
           FStmts.Items[FTableIndex*3+ ord(UpdateKind)].Statement.Clear;

    FStmts.EndUpdate;
    SetTableIndex(0);
    exit;
   end;


FStmts.BeginUpdate;

for UpdateKind := High(TUpdateKind) downto Low(TUpdateKind) do
     FStmts.Items[FTableIndex*3+ ord(UpdateKind)].Collection:=nil;

FStmts.EndUpdate;

FStmtsCount:=FStmtsCount-1;
SetTableIndex (FTableIndex-1);

end;


constructor TUpdateObjectView.Create(AOwner: TComponent);
var
  UpdateKind: TUpdateKind;
  NewStatement: TSQLStatement;
begin
//showmessage (self.name + '-> TUpdateObjectView Begin Create');
  inherited Create(AOwner);
  FStmts := CreateStatements;
  FStmts.BeginUpdate;
  for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
    begin
    FSQLText[UpdateKind] := TStringList.Create;
    NewStatement:=FStmts.Add;
    NewStatement.Statement := TStringList.Create;
    NewStatement.Statement.Assign (FSQLText[UpdateKind]);
    end;
  FStmtsCount:=1;
  FStmts.EndUpdate;
//showmessage (self.name + '-> TUpdateObjectView End Create');
end;



destructor TUpdateObjectView.Destroy;
var
  UpdateKind: TUpdateKind;
begin
  if Assigned(FDataSet) and (TDBDataSet(FDataSet).UpdateObject = Self) then
    TDBDataSet(FDataSet).UpdateObject := nil;

  for UpdateKind := Low(TUpdateKind) to High(TUpdateKind) do
    begin
    FSQLText[UpdateKind].Free;
    FQueries[UpdateKind].Free;
    end;

  FStmts.Free;
  FStmtsCount:=0;
  inherited Destroy;
end;


procedure TUpdateObjectView.SetCount(Val : integer);
begin
if (csLoading in ComponentState) or (csReading in ComponentState) or (csUpdating in ComponentState) then
   FStmtsCount:=Val;

end;

procedure TUpdateObjectView.ExecSQL(UpdateKind: TUpdateKind);
begin
  with Query[UpdateKind] do
  begin
    Prepare;
    ExecSQL;
    if RowsAffected > 1 then DatabaseError(SUpdateFailed);
  end;
end;

function TUpdateObjectView.GetQuery(UpdateKind: TUpdateKind): TQuery;
begin
  if not Assigned(FQueries[UpdateKind]) then
  begin
    FQueries[UpdateKind] := TQuery.Create(Self);
    if (FDataSet is TDBDataSet) then
    begin
      FQueries[UpdateKind].SessionName := TDBDataSet(FDataSet).SessionName;
      FQueries[UpdateKind].DatabaseName := TDBDataSet(FDataSet).DataBaseName;
    end;
  end;
  FQueries[UpdateKind].SQL.Assign(SQL[UpdateKind]);
  Result := FQueries[UpdateKind];
end;

function TUpdateObjectView.GetSQL(UpdateKind: TUpdateKind): TStrings;
begin
  FSQLText[UpdateKind].Assign(FStmts.Items[FTableIndex*3+ ord(UpdateKind)].Statement);
  Result := FSQLText[UpdateKind];
end;

function TUpdateObjectView.GetSQLIndex(Index: Integer): TStrings;
begin
  FSQLText[TUpdateKind(Index)].Assign(FStmts.Items[FTableIndex*3+ord (TUpdateKind(Index))].Statement);
  Result := FSQLText[TUpdateKind(Index)];
end;

function TUpdateObjectView.GetDataSet: TBDEDataSet;
begin
  Result := FDataSet;
end;

procedure TUpdateObjectView.SetDataSet(ADataSet: TBDEDataSet);
begin
  FDataSet := ADataSet;
end;

procedure TUpdateObjectView.SetSQL(UpdateKind: TUpdateKind; Value: TStrings);
begin
  FSQLText[UpdateKind].Assign(Value);
  FStmts.Items[FTableIndex*3+ ord(UpdateKind)].Statement.Assign(Value);
  if Assigned(FQueries[UpdateKind]) then
  begin
    FQueries[UpdateKind].Params.Clear;
    FQueries[UpdateKind].SQL.Assign(Value);
  end;
end;

procedure TUpdateObjectView.SetSQLIndex(Index: Integer; Value: TStrings);
begin
  SetSQL(TUpdateKind(Index), Value);
end;

procedure TUpdateObjectView.SetParams(UpdateKind: TUpdateKind);
var
  I: Integer;
  Old: Boolean;
  Param: TParam;
  PName: string;
  Field: TField;
  Campo:string;
begin
  if not Assigned(FDataSet) then Exit;
  with Query[UpdateKind] do
  begin
    if FSQLText[UpdateKind].Text <> Query[UpdateKind].SQL.Text then
      Query[UpdateKind].SQL.Assign(FSQLText[UpdateKind]);
    for I := 0 to Params.Count - 1 do
    begin
      Param := Params[I];
      PName := Param.Name;
      Old := CompareText(Copy(PName, 1, 4), 'OLD_') = 0;
      if Old then System.Delete(PName, 1, 4);
      Campo:=PName;
{
      if (FDataSet is TQueryPersist) then
         begin
         if (PName='OUID') then
            Campo:= (FDataSet as TQueryPersist).CampoID
            else
                if (PName='OUIDPai') then
                   Campo:=(FDataSet as TQueryPersist).CampoPai
                   else
                   Campo:=PName;
          end;
 }
      Field := FDataSet.FindField(Campo);
      if not Assigned(Field) then Continue;
      if Old then
        Param.AssignFieldValue(Field, Field.OldValue) else
        Param.AssignFieldValue(Field, Field.NewValue);
      Param.GetDataSize;
    end;
  end;
end;

procedure TUpdateObjectView.Apply(UpdateKind: TUpdateKind);
var
Cnt : Integer;
begin
  if FStmtsCount=0 then
    exit;
//for Cnt:=FTableIndex to FStmtsCount - 1 do
  for Cnt:= 0 to FStmtsCount - 1 do
  begin
    TableIndex:=Cnt;
    SetParams(UpdateKind);
    //ShowMessage ('ExecSQL -> '+ FSQLText[UpdateKind].Text);
    ExecSQL(UpdateKind);
  end;

  {
     Dispara o evento sempre ao final do processamento no banco
  }
  if assigned(FOnTerminateApply) then
     FOnTerminateApply(Self, UpdateKind);
end;


{ TDSPersistLink }


procedure TDSPersistLink.ActiveChanged;
begin
//showmessage ('-> TDSPersistLink.ActiveChanged Begin ');

  if FDSPersistControl <> nil then
  begin
  if (FDSPersistControl is TDSPersistRadioGroup) then (FDSPersistControl as TDSPersistRadioGroup).DataLinkActiveChanged;
  if (FDSPersistControl is TDSPersistCheckBox) then (FDSPersistControl as TDSPersistCheckBox).DataLinkActiveChanged;
  if (FDSPersistControl is TDSPersistRButton) then (FDSPersistControl as TDSPersistRButton).DataLinkActiveChanged;
  end;
end;

procedure TDSPersistLink.RecordChanged(Field: TField);
begin
//showmessage ('-> TDSPersistLink.RecordChanged Begin ');
  if FDSPersistControl <> nil then
  begin
  if (FDSPersistControl is TDSPersistRadioGroup) then
     (FDSPersistControl as TDSPersistRadioGroup).DataLinkRecordChanged(Field);
  if (FDSPersistControl is TDSPersistCheckBox) then
     (FDSPersistControl as TDSPersistCheckBox).DataLinkRecordChanged(Field);
  if (FDSPersistControl is TDSPersistRButton) then
     (FDSPersistControl as TDSPersistRButton).DataLinkRecordChanged(Field);
  end;
end;


{ TDSPersistRadioGroup }

constructor TDSPersistRadioGroup.Create(AOwner: TComponent);
begin
//showmessage (self.name + '-> TDSPersistRadioGroup Begin Create');
  inherited Create(AOwner);
  FDataLink := TDSPersistLink.Create;
  FDataLink.FDSPersistControl := Self;
  FValues := TStringList.Create;
//showmessage (self.name + '-> TDSPersistRadioGroup End Create');
end;

destructor TDSPersistRadioGroup.Destroy;
begin
  FDataLink.FDSPersistControl := nil;
  FDataLink.Free;
  FDataLink := nil;
  FValues.Free;
  inherited Destroy;
end;

procedure TDSPersistRadioGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) and (csDesigning in ComponentState) then DataSource := nil;
end;

procedure TDSPersistRadioGroup.DataLinkActiveChanged;
var
NomeFilho: string;
LkdSource : TDSPersist;
begin
//ShowMessage ('DataLinkActiveChanged');
if not Assigned (FDataLink.DataSource) then exit;
LkdSource := (FDataLink.DataSource as TDSPersist);
Visible:=FDataLink.Active;
     if Assigned(LkdSource.ActiveDescendant) and
        LkdSource.ActiveDescendant.Enabled then
        begin
        NomeFilho:=LkdSource.ActiveDescendant.Name;
        Delete (NomeFilho,1,1);
        Value:=NomeFilho;
        end
     else
        Value:='nil';
end;

procedure TDSPersistRadioGroup.DataLinkRecordChanged(Field: TField);
var
NomeFilho: string;
LkdSource : TDSPersist;
begin
//showmessage (self.name + '-> TDSPersistRadioGroup.DataLinkRecordChanged Begin ');
if not Assigned (FDataLink.DataSource) then exit;
LkdSource := (FDataLink.DataSource as TDSPersist);
  if (Field = nil)  then
     if Assigned(LkdSource.ActiveDescendant) and
        LkdSource.ActiveDescendant.Enabled then
        begin
        NomeFilho:=LkdSource.ActiveDescendant.Name;
        Delete (NomeFilho,1,1);
        Value:=NomeFilho;
        end
     else
        Value:='nil';
end;

{procedure TDSPersistRadioGroup.UpdateData(Sender: TObject);
begin
ShowMessage ('Update data');

//  if FDataLink.Field <> nil then FDataLink.Field.Text := Value;
end;
}

function TDSPersistRadioGroup.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDSPersistRadioGroup.SetDataSource(ADataSource: TDataSource);
var
NomePai: string;
NomeFilho: string;
I: integer;
begin
//showmessage (self.name + '-> TDSPersistRadioGroup.SetDataSource Begin ');
  if not (ADataSource is TDSPersist) then
     begin
     FDataLink.DataSource := nil;
     exit;
     end;

  FDataLink.DataSource := ADataSource;

  if ADataSource <> nil then ADataSource.FreeNotification(Self) else exit;

  if (csDesigning in ComponentState) and
     not (csLoading in ComponentState) then
     begin

     Items.Clear;
     Values.Clear;

     with ADataSource as TDSPersist do
       begin
       NomePai:=Name;
       Delete (NomePai,1,1);
       Caption:='Tipo de ' + NomePai;
       for I:=0 to Descendents.Count-1 do
        if (TDSPersist(Descendents[I]).OneOf = True) then
           begin
           NomeFilho:= TDSPersist(Descendents[I]).Name;
           Delete (NomeFilho,1,1);
           Items.Add (NomeFilho);
           Values.Add (NomeFilho);
           end;

       end;
     end;
end;

function TDSPersistRadioGroup.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDSPersistRadioGroup.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;


function TDSPersistRadioGroup.GetButtonValue(Index: Integer): string;
begin
  if (Index < FValues.Count) and (FValues[Index] <> '') then
    Result := FValues[Index]
  else if Index < Items.Count then
    Result := Items[Index]
  else
    Result := '';
end;

procedure TDSPersistRadioGroup.SetValue(const Value: string);
var
  I, Index: Integer;
begin
  if FValue <> Value then
  begin
    FInSetValue := True;
    try
      Index := -1;
      for I := 0 to Items.Count - 1 do
        if Value = GetButtonValue(I) then
        begin
          Index := I;
          Break;
        end;
      ItemIndex := Index;
    finally
      FInSetValue := False;
    end;
    FValue := Value;
    Change;
  end;
end;

procedure TDSPersistRadioGroup.CMExit(var Message: TCMExit);
begin
{  try
    FDataLink.UpdateRecord;
  except
    if ItemIndex >= 0 then
      TRadioButton(Controls[ItemIndex]).SetFocus else
      TRadioButton(Controls[0]).SetFocus;
    raise;
  end;}
  inherited;
end;

procedure TDSPersistRadioGroup.Click;
begin
if not Assigned (FDataLink.DataSource) then exit;
  if not FInSetValue then
  begin
    inherited Click;
    if ItemIndex >= 0 then Value := GetButtonValue(ItemIndex);
    (FDataLink.DataSource as TDSPersist).SetActiveDescendant (ItemIndex);
    //if FDataLink.Editing then FDataLink.Modified;
//ShowMessage ('Click data');
  end;
end;

procedure TDSPersistRadioGroup.SetItems(Value: TStrings);
begin
  Items.Assign(Value);
//  DataChange(Self);
end;

procedure TDSPersistRadioGroup.SetValues(Value: TStrings);
begin
  FValues.Assign(Value);
//  DataChange(Self);
end;

procedure TDSPersistRadioGroup.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDSPersistRadioGroup.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
{  case Key of
    #8, ' ': FDataLink.Edit;
    #27: FDataLink.Reset;
  end;}
end;

function TDSPersistRadioGroup.CanModify: Boolean;
begin
  //Result := FDataLink.Edit;
  Result:=True;
end;

procedure TDSPersistRadioGroup.Loaded;
var
I : integer;
NomeFilho : string;
begin
//showmessage (self.name + '-> TDSPersistRadioGroup Loaded Begin');

  if Assigned (FDataLink) and
     Assigned(FDataLink.DataSource) and
     (csDesigning in ComponentState)  then
     begin

     Items.Clear;
     Values.Clear;

     with (FDataLink.DataSource as TDSPersist) do
       begin
       for I:=0 to Descendents.Count-1 do
         if (TDSPersist(Descendents[I]).OneOf = True) then
           begin
           NomeFilho:= TDSPersist(Descendents[I]).Name;
           Delete (NomeFilho,1,1);
           Items.Add (NomeFilho);
           Values.Add (NomeFilho);
           end;

       end;
     end;
//showmessage (self.name + '-> TDSPersistRadioGroup Loaded End');
end;

 { TListOfChildsProperty }

function TListOfChildsProperty.GetAttributes: TPropertyAttributes;
begin
    Result:= [paValueList];
end;

procedure TListOfChildsProperty.GetValues(Proc: TGetStrProc);
var
APersistDS : TDSPersist;
AComponent : TPersistent;
I : integer;
NomeFilho : string;

begin
AComponent := GetComponent(0);
if (AComponent is TDSPersistCheckBox) then
   begin
   if Assigned ((AComponent as TDSPersistCheckBox).DataSource) then
               APersistDS:= ((AComponent as TDSPersistCheckBox).DataSource as TDSPersist)
   else
       exit;
   if APersistDS.FDataDescendents.Count > 0 then
      begin
      with (APersistDS) do
       begin
       for I:=0 to Descendents.Count-1 do
         if (TDSPersist(Descendents[I]).OneOf = False) then
           begin
           NomeFilho:= TDSPersist(Descendents[I]).Name;
           Delete (NomeFilho,1,1);
           Proc (NomeFilho);
           end;
       exit;
       end;
      end
   else
    exit;
   end
else
    if (AComponent is TDSPersistRButton) then
       begin
       if Assigned ((AComponent as TDSPersistRButton).DataSource) then
               APersistDS:= ((AComponent as TDSPersistRButton).DataSource as TDSPersist)
       else
           exit;
       if APersistDS.FDataDescendents.Count > 0 then
          begin
          with (APersistDS) do
               begin
               for I:=0 to Descendents.Count-1 do
                   if (TDSPersist(Descendents[I]).OneOf = True) then
                      begin
                      NomeFilho:= TDSPersist(Descendents[I]).Name;
                      Delete (NomeFilho,1,1);
                      Proc (NomeFilho);
                      end;
               exit;
               end;
          end
       else
           exit;
       end
    else
       exit;


end;

function TListOfChildsProperty.GetValue: string;
begin
Result:= GetStrValue;
end;

procedure TListOfChildsProperty.SetValue(const Value: string);
var
AComponent : TButtonControl;
begin
SetStrValue (Value);
AComponent := TButtonControl (GetComponent(0));

if Assigned (AComponent) then
   if (AComponent is TCheckBox) then
      (AComponent as TCheckBox).Caption:=Value
   else
       if (AComponent is TRadioButton) then
       (AComponent as TRadioButton).Caption:=Value;

end;

{ TDSPersistCheckBox }

constructor TDSPersistCheckBox.Create(AOwner: TComponent);
begin
//showmessage (self.name + '-> TDSPersistCheckBox Begin Create');
  inherited Create(AOwner);
  FDataLink := TDSPersistLink.Create;
  FDataLink.FDSPersistControl := Self;
//showmessage (self.name + '-> TDSPersistCheckBox End Create');
end;

destructor TDSPersistCheckBox.Destroy;
begin
  FDataLink.FDSPersistControl := nil;
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TDSPersistCheckBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) and (csDesigning in ComponentState) then DataSource := nil;
end;

procedure TDSPersistCheckBox.DataLinkActiveChanged;
begin
//ShowMessage ('DataLinkActiveChanged');
Visible:=FDataLink.Active;
end;

procedure TDSPersistCheckBox.DataLinkRecordChanged(Field: TField);
var
NomeFilho: string;
LkdSource : TDSPersist;
I : integer;

begin
if not Assigned (FDataLink.DataSource) then exit;
LkdSource := (FDataLink.DataSource as TDSPersist);

FInSetValue:=True;
//State:=cbUnchecked;

  if (Field = nil)  then
     with (LkdSource) do
       for I:=0 to Descendents.Count-1 do
         if (TDSPersist(Descendents[I]).OneOf = False) then
           begin
           NomeFilho:= TDSPersist(Descendents[I]).Name;
           Delete (NomeFilho,1,1);
           if (NomeFilho = FSelChild ) then
           begin
           if TDSPersist(Descendents[I]).Enabled then
              begin
              if (LkdSource.DataSet.State = dsInsert) then
                 begin
                 TDSPersist(Descendents[I]).Enabled:=False;
                 self.State:=cbUnChecked;
                 end
              else
                  self.State:=cbChecked;
              end
           else
               self.State:=cbUnChecked;

           Change;
           end;
           end;

FInSetValue:=False;
end;

function TDSPersistCheckBox.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDSPersistCheckBox.SetDataSource(ADataSource: TDataSource);
begin
  if not (ADataSource is TDSPersist) then
     begin
     FDataLink.DataSource := nil;
     exit;
     end;

  FDataLink.DataSource := ADataSource;

  if ADataSource <> nil then ADataSource.FreeNotification(Self);

end;

function TDSPersistCheckBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDSPersistCheckBox.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;


procedure TDSPersistCheckBox.Click;
begin
if not Assigned (FDataLink.DataSource) then exit;
  if not FInSetValue then
    begin
//    if not CanModify then exit;
    inherited Click;
    if State=cbChecked then
       (FDataLink.DataSource as TDSPersist).SetMultipleInterfaceDescendant ( FSelChild)
    else
        (FDataLink.DataSource as TDSPersist).ReSetMultipleInterfaceDescendant ( FSelChild );
    Change;
    end;
end;

procedure TDSPersistCheckBox.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDSPersistCheckBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
{  case Key of
    #8, ' ': FDataLink.Edit;
    #27: FDataLink.Reset;
  end;}
end;

function TDSPersistCheckBox.CanModify: Boolean;
begin
  Result := FDataLink.Edit;
end;

procedure TDSPersistCheckBox.Loaded;
begin
{
  if Assigned (FDataLink) and
     Assigned(FDataLink.DataSource) and
     (csDesigning in ComponentState)  then
     begin

     Items.Clear;
     Values.Clear;

     with (FDataLink.DataSource as TDSPersist) do
       begin
       for I:=0 to Descendents.Count-1 do
         if (TDSPersist(Descendents[I]).OneOf = True) then
           begin
           NomeFilho:= TDSPersist(Descendents[I]).Name;
           Delete (NomeFilho,1,1);
           Items.Add (NomeFilho);
           Values.Add (NomeFilho);
           end;

       end;
     end;
  }
end;


{ TDSPersistRButton }

constructor TDSPersistRButton.Create(AOwner: TComponent);
begin
//showmessage (self.name + '-> TDSPersistRButton Begin Create');
  inherited Create(AOwner);
  FDataLink := TDSPersistLink.Create;
  FDataLink.FDSPersistControl := Self;
//showmessage (self.name + '-> TDSPersistRButton End Create');
end;

destructor TDSPersistRButton.Destroy;
begin
  FDataLink.FDSPersistControl := nil;
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TDSPersistRButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) and (csDesigning in ComponentState) then DataSource := nil;
end;

procedure TDSPersistRButton.DataLinkActiveChanged;
begin
//ShowMessage ('DataLinkActiveChanged');
Visible:=FDataLink.Active;
end;

procedure TDSPersistRButton.DataLinkRecordChanged(Field: TField);
var
NomeFilho: string;
LkdSource : TDSPersist;
I : integer;

begin
if not Assigned (FDataLink.DataSource) then exit;

LkdSource := (FDataLink.DataSource as TDSPersist);

FInSetValue:=True;
//Checked:=False;

  if (Field = nil)  then
     with (LkdSource) do
       for I:=0 to Descendents.Count-1 do
         if (TDSPersist(Descendents[I]).OneOf = True) then
           begin
           NomeFilho:= TDSPersist(Descendents[I]).Name;
           Delete (NomeFilho,1,1);
           if (NomeFilho = FSelChild ) then
              Checked:=TDSPersist(Descendents[I]).Enabled;
           end;

FInSetValue:=False;
end;

function TDSPersistRButton.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDSPersistRButton.SetDataSource(ADataSource: TDataSource);
begin
  if not (ADataSource is TDSPersist) then
     begin
     FDataLink.DataSource := nil;
     exit;
     end;

  FDataLink.DataSource := ADataSource;

  if ADataSource <> nil then ADataSource.FreeNotification(Self);

end;


function TDSPersistRButton.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDSPersistRButton.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;


procedure TDSPersistRButton.Click;
begin

if not Assigned (FDataLink.DataSource) then exit;
  if not FInSetValue then
    begin
    if not CanModify then exit;
    inherited Click;
    if not Checked then
       (FDataLink.DataSource as TDSPersist).SetSingleActiveDescendant (FSelChild);
    Change;
    end;
end;

procedure TDSPersistRButton.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDSPersistRButton.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
{  case Key of
    #8, ' ': FDataLink.Edit;
    #27: FDataLink.Reset;
  end;}
end;

function TDSPersistRButton.CanModify: Boolean;
begin
  //Result := FDataLink.Edit;
  Result:=True;
end;

procedure TDSPersistRButton.Loaded;
//var
//NomeFilho : string;
begin
{
  if Assigned (FDataLink) and
     Assigned(FDataLink.DataSource) and
     (csDesigning in ComponentState)  then
     begin

     Items.Clear;
     Values.Clear;

     with (FDataLink.DataSource as TDSPersist) do
       begin
       for I:=0 to Descendents.Count-1 do
         if (TDSPersist(Descendents[I]).OneOf = True) then
           begin
           NomeFilho:= TDSPersist(Descendents[I]).Name;
           Delete (NomeFilho,1,1);
           Items.Add (NomeFilho);
           Values.Add (NomeFilho);
           end;

       end;
     end;
  }
end;

procedure TUpdateObjectView.SetOnTerminateApply(const Value: TApplyEvent);
begin
  FOnTerminateApply := Value;
end;

end.

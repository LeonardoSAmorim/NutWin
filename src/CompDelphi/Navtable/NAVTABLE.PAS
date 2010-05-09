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




unit NavTable;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, dbctrls, DBTables, DB, tabs, comctrls;

type
  TNavTableState = (ntFirst, ntNext, ntCarregando, ntLocate, ntNull);

type
  TNavTable = class(TComponent)
  private
    { Private declarations }
    FDataLink: TDataLink;
    FFieldDataLink: TFieldDataLink;
    FVisualizador    : TWinControl;
    State :  TNavTableState;
    FOnNavChange: TNotifyEvent;
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure SetVisualizador(Value : TWinControl);
    procedure DSChangeVisualizador(Sender: TObject; Field: TField);
    procedure VisualizadorClick(Sender : TObject);
    procedure SetDFChave(const Value: string);
    function  GetDFChave: string;
    procedure SetOnNavChange(const Value: TNotifyEvent);
  protected
    { Protected declarations }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Pesquisar(Value : string);
    Procedure MyLocate(DataField: String; Value: String);
    procedure CarregarVisualizador;
  published
    { Published declarations }
    property DataField       : string         read GetDFChave       write SetDFChave;
    property DataSource      : TDataSource    read GetDataSource    write SetDataSource;
    property Visualizador   : TWinControl    read FVisualizador   write SetVisualizador;
    property OnNavChange : TNotifyEvent read FOnNavChange write SetOnNavChange;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Nutricao', [TNavTable]);
end;

  constructor TNavTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  //Definir istancia para DataLink
  FDataLink := TDataLink.Create();
  FFieldDataLink := TFieldDataLink.Create;
  FFieldDataLink.Control := Self;
  State := ntNull;

end;

destructor TNavTable.Destroy;
begin
  FFieldDataLink.DataSource.OnDataChange := nil;
  FDataLink.Free;
  FFieldDataLink.Free;
  FDataLink := nil;
  FFieldDataLink := nil;
  FVisualizador := nil;
  inherited Destroy;
end;

procedure TNavTable.Loaded;
begin
inherited;
CarregarVisualizador;
end;

procedure TNavTable.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
{    if (FDataLink <> nil) and (AComponent = DataSource) then
       DataSource := nil;
    if (FFieldDataLink <> nil) and (AComponent = DataField) then
       DataField := nil;
 }   if (FVisualizador <> nil) and (AComponent = Visualizador) then
       Visualizador := nil;
  end;
end;

procedure TNavTable.SetDataSource(Value: TDataSource);
begin
//  showmessage(Value.name);
  FDataLink.DataSource := Value;
  FFieldDataLink.DataSource := Value;
  FFieldDataLink.DataSource.OnDataChange := DSChangeVisualizador;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TNavTable.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;


procedure TNavTable.SetVisualizador(Value : TWinControl);
{
Procedimento para setar o novo campo edit para ser utilizado na pesquisa
}
begin
  FVisualizador := Value;
  if Value <> nil then
  begin
      Value.FreeNotification(Self);
      if Value is TTabSet then
      begin
        (Value as TTabSet).OnClick := VisualizadorClick;
         CarregarVisualizador;
         exit;
      end;
      if Value is TListView then
        (Value as TListView).OnClick := VisualizadorClick;
      //AtualizarVisualizador();
  end;

end;
procedure TNavTable.DSChangeVisualizador(Sender: TObject; Field: TField);
begin
   if not(State = ntCarregando) and not (State = ntLocate) then
      if (Field = nil) and not(FFieldDataLink.DataSource.State in [dsEdit, dsInsert]) then
         CarregarVisualizador;
end;

procedure TNavTable.CarregarVisualizador;
var
   FieldCorrente : string;
   CountRecord   : integer;
   PosicaoAtual : TBookmark;
begin
   if ((not (csLoading in ComponentState)) and
      (Assigned(Visualizador)) and
      (Assigned(FDataLink.DataSource)) and
      (Assigned(FDataLink.DataSource.DataSet))) then
   begin
      CountRecord := 0;
      State := ntCarregando;
      (Visualizador as TTabSet).Tabs.Clear;
      FieldCorrente:='';
      with TTable (FDataLink.DataSource.DataSet) do
      begin
         PosicaoAtual:=GetBookmark;
         FieldCorrente:=FieldByName(DataField).AsString;
//         ShowMessage (inttostr(ord(State)) + Name + inttostr(RecordCount));
         if PosicaoAtual = nil then
         begin
            self.State := ntNull;
            exit;
         end;
         DisableControls;
         First;
         while not(Eof) do
         begin
            (Visualizador as TTabSet).Tabs.Add(FieldByName(DataField).AsString);
            if (FieldByName(DataField).AsString = FieldCorrente) then
                   if (Visualizador is TTabSet) then
                       (Visualizador as TTabSet).TabIndex := CountRecord;
            CountRecord:=CountRecord+1;
            next;
         end;
         GotoBookmark(PosicaoAtual);
         FreeBookmark(PosicaoAtual);
         EnableControls;
       end;


   {
        with DataSource.DataSet do
        begin
           FieldCorrente :=  FieldByName(DataField).AsString;
           Refresh;
           First;
           while not(Eof) do
           begin
             (Visualizador as TTabSet).Tabs.Add(FieldByName(DataField).AsString);

              if FieldCorrente = FieldByName(DataField).AsString then
                 (Visualizador as TTabSet).TabIndex := CountRecord
              else
                 inc(CountRecord);
             next;
           end;
        end;
        Pesquisar(FieldCorrente);
        State := ntNull;
   }
      State := ntNull;
   end;
end;

procedure TNavTable.VisualizadorClick(Sender : TObject);
{
Esta procedure sera sempre execultada quando ocorrer um click no TabSet
}
var
   LetraInicial : string;
   PointLetra   : integer;
begin
//         ShowMessage ('Click');
   // codigo para o visualizador tabset
   if State = ntCarregando then exit;
   if Sender is TTabSet then
   begin
      with (Visualizador as TTabSet) do
      begin
         PointLetra     := TabIndex;
         LetraInicial   := Tabs [PointLetra];
         Pesquisar(LetraInicial);
      end;
   end;
   if Sender is TListView then
   begin
      with (Visualizador as TListView) do
      begin
         //controle do click do listview
         Pesquisar(LetraInicial);
      end;
   end;

   // codigo para outros visualizador criar um case SENDER of
   {
     case Sender of
     TTabSet     : ...
     TListView   : ...
     .
     .
     .
   }
   if Assigned (FOnNavChange) then
      FOnNavChange(self);

end;


procedure TNavTable.Pesquisar(Value : string);
{
          codigo para fazer pesquisa parcial dentro da tabela pelo indice
que estiver corrente, sera utilizado mais tarde
}
var
//  LocateSuccess: Boolean;
  SearchOptions: TLocateOptions;
//  xChave       : String;
begin
   State := ntLocate;
   SearchOptions := [loPartialKey, loCaseInsensitive];
//   ShowMessage ('Pesquisar');
   with FDataLink.DataSource.DataSet do
   begin

      //Locate(DataField, Value,  SearchOptions);
      MyLocate(DataField, Value)
   end;
   State := ntNull;
end;

procedure TNavTable.SetDFChave(const Value: string);
begin
   FFieldDataLink.FieldName := Value;
end;

function TNavTable.GetDFChave: string;
begin
   Result := FFieldDataLink.FieldName;
end;

procedure TNavTable.SetOnNavChange(const Value: TNotifyEvent);
begin
  FOnNavChange := Value;
end;

procedure TNavTable.MyLocate(DataField, Value: String);
Var
   MyBookMark: TBookmark;
begin
with FDataLink.DataSource.DataSet do
     begin

     DisableControls;
     MyBookMark := GetBookmark;
     first;
     while (Trim(UpperCase(FieldByName(DataField).asString)) <> Trim(UpperCase(value))) and not Eof do
           begin
           Next;
           end;

     if Eof then
        GotoBookmark(MyBookMark);

     FreeBookmark(MyBookMark);
     EnableControls;
     end;

end;

end.

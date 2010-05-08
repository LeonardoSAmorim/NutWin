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




unit FaixasTabela;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, DsgnIntf, DbTables;

type
  TFaixasTabela = class(TComponent)
  private
    FDiagDataField: string;
    FMaxDataField: string;
    FMinDataField: string;
    FDataSource: TDataSource;
    FListaFaixas: TStrings;
    FListaNomeFaixas: TStrings;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetDiagDataField(const Value: string);
    procedure SetMaxDataField(const Value: string);
    procedure SetMinDataField(const Value: string);
    procedure SetListaFaixas(const Value: TStrings);
    procedure SetListaNomeFaixas(const Value: TStrings);
    { Private declarations }
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(Aowmer : TComponent) ; override;
    destructor destroy; override;
    function Execute : boolean;
  published
    { Published declarations }
    property DataSource : TDataSource read FDataSource write SetDataSource;
    property MinDataField : string read FMinDataField write SetMinDataField;
    property MaxDataField : string read FMaxDataField write SetMaxDataField;
    property DiagDataField : string read FDiagDataField write SetDiagDataField;
    property ListaFaixas : TStrings read FListaFaixas write SetListaFaixas;
    property ListaNomeFaixas : TStrings read FListaNomeFaixas write SetListaNomeFaixas;
  end;

  TEditDataField= class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure GetValues(PROC : TGetStrProc); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('miscelanea', [TFaixasTabela]);
  RegisterPropertyEditor(TypeInfo(string), TFaixasTabela, 'MinDataField', TEditDataField);
  RegisterPropertyEditor(TypeInfo(string), TFaixasTabela, 'MaxDataField', TEditDataField);
  RegisterPropertyEditor(TypeInfo(string), TFaixasTabela, 'DiagDataField', TEditDataField);
end;


constructor TFaixasTabela.Create(Aowmer: TComponent);
begin
  inherited Create(Aowmer);
   FListaFaixas := TStringList.Create;
   FListaNomeFaixas := TStringList.Create;
end;

destructor TFaixasTabela.destroy;
begin
   FListaFaixas.Free;
   FListaNomeFaixas.Free;
  inherited Destroy;
end;

function TFaixasTabela.Execute: boolean;
var
   Minimo : Double;
begin
   Minimo := 0;
   Result := True;
   if ( FDataSource <> nil ) and
      ( FMaxDataField <> '' ) and ( FDiagDataField <> '' )then
   begin
      if not FDataSource.DataSet.Active then
         FDataSource.DataSet.Open;
         begin
            FListaFaixas.Clear;
            FListaNomeFaixas.Clear;
            FDataSource.DataSet.First;
            while not FDataSource.DataSet.Eof do
            begin
               if FMinDataField = '' then
                 begin
                  FListaFaixas.Add( FloatToStr( ABS( FDataSource.DataSet.FieldByName( FMaxDataField ).AsFloat -
                                                Minimo)) );
                  Minimo := FDataSource.DataSet.FieldByName( FMaxDataField ).AsFloat;
                 end
               else
                  FListaFaixas.Add( FloatToStr( ABS( FDataSource.DataSet.FieldByName( FMaxDataField ).AsFloat -
                                                FDataSource.DataSet.FieldByName( FMinDataField ).AsFloat)) );
               FListaNomeFaixas.Add( FDataSource.DataSet.FieldByName( FDiagDataField ).AsString );
               FDataSource.DataSet.Next;
            end;
         end;
   end
   else
      Result := False;
end;

procedure TFaixasTabela.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FDataSource <> nil) and (AComponent = DataSource) then
       DataSource := nil;
  end;
end;


{--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--}


function TEditDataField.GetAttributes : TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TEditDataField.GetValues(PROC : TGetStrProc);
var
   ListaFields : TStrings;
   i : integer;
   lQuery : TQuery;
   lTable : TTable;
   lComp : TFaixasTabela;
begin
   ListaFields := TStringList.create;
   lComp := TFaixasTabela(GetComponent(0));
   if assigned(lComp.DataSource.DataSet) then
   begin
      if lComp.DataSource.DataSet is TQuery then
      begin
         lQuery := TQuery.create(nil);
         lQuery.sql.Assign(TQuery(lComp.DataSource.DataSet).Sql);
         lQuery.DatabaseName := TQuery(lComp.DataSource.DataSet).DataBaseName;
         lQuery.Active := True;
         for i := 0 to lquery.FieldCount - 1 do
         begin
            ListaFields.Add(lquery.Fields[i].FieldName);
         end;
         lQuery.Active := False;
         lQuery.destroy;
      end else
      if lComp.DataSource.DataSet is TTable then
      begin
         lTable := TTable.create(nil);
         lTable.DatabaseName := TTable(lComp.DataSource.DataSet).DataBaseName;
         lTable.TableName := TTable(lComp.DataSource.DataSet).TableName;
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

{ TFaixasTabela }

procedure TFaixasTabela.SetDataSource(const Value: TDataSource);
begin
  FDataSource := Value;
end;

procedure TFaixasTabela.SetDiagDataField(const Value: string);
begin
  FDiagDataField := Value;
end;

procedure TFaixasTabela.SetListaFaixas(const Value: TStrings);
begin
  FListaFaixas.Assign( Value );
end;

procedure TFaixasTabela.SetListaNomeFaixas(const Value: TStrings);
begin
  FListaNomeFaixas.Assign( Value );
end;

procedure TFaixasTabela.SetMaxDataField(const Value: string);
begin
  FMaxDataField := Value;
end;

procedure TFaixasTabela.SetMinDataField(const Value: string);
begin
  FMinDataField := Value;
end;

end.

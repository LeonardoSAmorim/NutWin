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




unit MedidasBlobs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Measurement, Memoria, db;

type
  TMedidasBlobs = class(TComponent)
  private
    FMemoria : TMemoria;
    FPoeMedidasVazias: Boolean;
    FNomeMedida: String;
    FDataField: String;
    FDataSource: TDataSource;
    FListaMedidas: TStrings;
    FMemTemp: TMemoria;
    procedure SetDataField(const Value: String);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetListaMedidas(const Value: TStrings);
    procedure SetNomeMedida(const Value: String);
    procedure SetPoeMedidasVazias(const Value: Boolean);
    procedure SetMemTemp(const Value: TMemoria);
    { Private declarations }
  protected
    { Protected declarations }
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute : boolean;
  published
    { Published declarations }
    property DataSource : TDataSource read FDataSource write SetDataSource;
    property DataField : String read FDataField write SetDataField;
    property NomeMedida : String read FNomeMedida write SetNomeMedida;
    property ListaMedidas : TStrings read FListaMedidas write SetListaMedidas;
    property PoeMedidasVazias : Boolean read FPoeMedidasVazias write SetPoeMedidasVazias;
    property MemTemp : TMemoria read FMemTemp write SetMemTemp;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Miscelanea', [TMedidasBlobs]);
end;

{ TMedidasBlobs }

constructor TMedidasBlobs.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FListaMedidas := TStringList.Create;
   FMemoria := TMemoria.Create(self);
end;

destructor TMedidasBlobs.Destroy;
begin
   FListaMedidas.Free;
   FMemoria.Free;
   inherited Destroy;
end;

function TMedidasBlobs.Execute: boolean;
var
   MemTempCriada : Boolean;
   Med,
   MedData : TMedida;
begin
   MemTempCriada := False;
   Result := True;
   if ( FDataSource <> nil ) and ( FDataField <> '' ) then
   begin
      if not FDataSource.DataSet.Active then
         FDataSource.DataSet.Open;
         begin
            FListaMedidas.Clear;
            if FMemTemp = nil then
              begin
               FMemTemp := TMemoria.Create( Application );
               MemTempCriada := True;
              end
            else
              FMemTemp.Limpar;   
            FDataSource.DataSet.First;
            while not FDataSource.DataSet.Eof do
            begin
               FMemTemp.SetMem( FDataSource.DataSet.FieldByName( FDataField ).AsString );
               FMemTemp.Acha( 'mdDataCalc', TObject( MedData ) );
               if FMemTemp.Acha( FNomeMedida, TObject( Med ) ) then
                  begin
                     FMemTemp.Adiciona( Med.Name + MedData.ValorNumerico, TObject( Med ) );
                     FMemTemp.Acha( Med.Name, TObject( Med ) );
                     ListaMedidas.AddObject( MedData.ValorNumerico, Med );
                  end
               else
                  if FPoeMedidasVazias then
                     ListaMedidas.AddObject( MedData.ValorNumerico, nil );
               FDataSource.DataSet.Next;
            end;
            if MemTempCriada then
               FMemTemp.Free;
         end;
   end
   else
      Result := False;
end;

procedure TMedidasBlobs.Loaded;
begin
     inherited Loaded;

end;

procedure TMedidasBlobs.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FDataSource then
        FDataSource := nil;
     if AComponent = FMemTemp then
        FMemTemp := nil;
end;

procedure TMedidasBlobs.SetDataField(const Value: String);
begin
  FDataField := Value;
end;

procedure TMedidasBlobs.SetDataSource(const Value: TDataSource);
begin
  FDataSource := Value;
end;

procedure TMedidasBlobs.SetListaMedidas(const Value: TStrings);
begin
  FListaMedidas.Assign( Value );
end;

procedure TMedidasBlobs.SetMemTemp(const Value: TMemoria);
begin
  FMemTemp := Value;
end;

procedure TMedidasBlobs.SetNomeMedida(const Value: String);
begin
  FNomeMedida := Value;
end;

procedure TMedidasBlobs.SetPoeMedidasVazias(const Value: Boolean);
begin
  FPoeMedidasVazias := Value;
end;

end.

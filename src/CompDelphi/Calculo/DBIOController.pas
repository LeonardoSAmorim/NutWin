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




unit DBIOController;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IOController, db;

type
  TDBIOController = class(TIOController)
  private
    FDataField: String;
    FDataSource: TDataSource;
    FGUIDField: String;
    FDateField: String;
    { Private declarations }
    { Method to set variable and property values and create objects }
    procedure AutoInitialize;
    { Method to free any objects created by AutoInitialize }
    procedure AutoDestroy;
    procedure SetDataField(const Value: String);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetGUIDField(const Value: String);
    procedure SetDateField(const Value: String);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure Loaded; override;

    procedure Novo; override;  //nao muda nada
    procedure Atualizado; override;
    function Abrir( StartApp : Boolean = False ) : Boolean; override;
    function AbrirDe( Arquivo : String ) : Boolean; override;
    function Gravar : Boolean; override;
    function GravarComo : Boolean; override;
    function Fechar : Boolean; override;

  published
    { Published declarations }
    property DataSource : TDataSource read FDataSource write SetDataSource;
    property DataField : String read FDataField write SetDataField;
    property GUIDField : String read FGUIDField write SetGUIDField;
    property DateField : String read FDateField write SetDateField;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Calculadora', [TDBIOController]);
end;

{ TDBIOController }

procedure TDBIOController.Novo;
begin
   inherited Novo;
end;

function TDBIOController.Abrir(StartApp: Boolean): Boolean;
begin
   Result := True;
   if Assigned( FDataSource ) and ( DataField <> '' ) and
      Assigned( Calculo ) and FDataSource.DataSet.Active then
      with Calculo do
      begin
         if not Memoria.SetMem( FDataSource.DataSet.FieldByName( DataField ).AsString ) then
            begin
//               ShowMessage( 'O registro não é válido!' );
               Result := False;
               exit;
            end;
         AbreCoProcessadores;
      end
   else
      Result := False;
end;

function TDBIOController.AbrirDe(Arquivo: String): Boolean;
begin
   Result := False;
   if Arquivo = '' then
      begin
         OpenDialog.FileName := Arquivo;
         if OpenDialog.Execute then
            if OpenDialog.Files.Count > 0 then
               Result := inherited AbrirDe(OpenDialog.Files.Strings[0]);
      end
   else
      Result := inherited AbrirDe(Arquivo);
end;

function TDBIOController.Fechar: Boolean;
begin
   Result := True;
   with Calculo do
   begin
      if Memoria.Modified > 0 then
         begin
            // Gravar;
         end;
         FechaCoProcessadores;
         Memoria.Limpar;
   end;
//   Result := inherited Fechar;
end;

function TDBIOController.Gravar: Boolean;
var
   Str : String;
begin
   Result := True;
   if Assigned( FDataSource ) and ( DataField <> '' ) and
      Assigned( Calculo ) and FDataSource.DataSet.Active and
      ( DataSource.State in [dsEdit, dsInsert] ) then
      with Calculo do
      begin
         if Memoria.GetMem( Str, False ) then // pega conteúdo da memória no formato .NUT
            begin
               FDataSource.DataSet.FieldByName( DataField ).AsString := Str;
               Atualizado;
            end
         else
            Result := False;
      end
   else
      Result := False;
end;

function TDBIOController.GravarComo: Boolean;
begin
   Result := inherited GravarComo;
end;

procedure TDBIOController.Atualizado;
begin
   inherited Atualizado;
end;

procedure TDBIOController.AutoDestroy;
begin

end;

procedure TDBIOController.AutoInitialize;
begin

end;

constructor TDBIOController.Create(AOwner: TComponent);
begin
     { Call the Create method of the parent class }
     inherited Create(AOwner);

     { AutoInitialize sets the initial values of variables and      }
     { properties; also, it creates objects for properties of       }
     { standard Delphi object types (e.g., TFont, TTimer,           }
     { TPicture) and for any variables marked as objects.           }
     { AutoInitialize method is generated by Component Create.      }
     AutoInitialize;

     { Code to perform other tasks when the component is created }
end;

destructor TDBIOController.Destroy;
begin
     { AutoDestroy, which is generated by Component Create, frees any   }
     { objects created by AutoInitialize.                               }
     AutoDestroy;

     { Here, free any other dynamic objects that the component methods  }
     { created but have not yet freed.  Also perform any other clean-up }
     { operations needed before the component is destroyed.             }

     { Last, free the component by calling the Destroy method of the    }
     { parent class.                                                    }
     inherited Destroy;
end;

procedure TDBIOController.Loaded;
begin
     inherited Loaded;

     { Perform any component setup that depends on the property
       values having been set }
end;

procedure TDBIOController.Notification(AComponent: TComponent;
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
end;

procedure TDBIOController.SetDataField(const Value: String);
begin
  FDataField := Value;
end;

procedure TDBIOController.SetDataSource(const Value: TDataSource);
begin
  FDataSource := Value;
end;

procedure TDBIOController.SetGUIDField(const Value: String);
begin
  FGUIDField := Value;
end;

procedure TDBIOController.SetDateField(const Value: String);
begin
  FDateField := Value;
end;

end.

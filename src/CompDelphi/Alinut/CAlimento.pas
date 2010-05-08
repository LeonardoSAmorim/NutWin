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




{ **********************************************************************}
{                                                                       }
{   Delphi component TAlimento                                          }
{                                                                       }
{   Representa um Alimento da Lista de Alimentos                        }
{                                                                       }
{   Copyright © 1998 by DIS-EPM/UNIFESP                                 }
{                                                                       }
{ **********************************************************************}

unit CAlimento;

interface

uses SysUtils, Classes, Dialogs, Forms, CCSListaLinks, CCSDBListaLinks, DMUmAli;

type
   TAlimento = class(TCCSDBListaLinks)
   private
      FDMUmAlimento : TDMUmAlimento;
      FIDAlimento: String;
      FPeso: Double;
      procedure SetIDAlimento(const Value: String);
      procedure SetDMUmAlimento(const Value: TDMUmAlimento);
      procedure SetPeso(const Value: Double);
   protected
      procedure Loaded; override;
      procedure OpenTables; override;
      procedure GetPesoAlimento( Sender : TObject; var PesoAlimento : Double );
   public
      property DMUmAlimento : TDMUmAlimento read FDMUmAlimento write SetDMUmAlimento;
      property Peso : Double read FPeso write SetPeso;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Notification(AComponent : TComponent; Operation : TOperation); override;
   published
      property IDAlimento : String read FIDAlimento write SetIDAlimento;
   end;

procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('Nutricao', [TAlimento]);
end;

procedure TAlimento.Notification(AComponent : TComponent; Operation : TOperation);
begin
   inherited Notification(AComponent, Operation);
   if Operation <> opRemove then
      Exit;
   if AComponent = FDMUmAlimento then
      FDMUmAlimento := nil;
end;

constructor TAlimento.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   Application.CreateForm(TDMUmAlimento,FDMUmAlimento);
   if FDMUmAlimento <> nil then
   begin
      FDMUmAlimento.FreeNotification(Self);
      FDMUmAlimento.OnPesoAlimento := GetPesoAlimento;
   end;
end;

destructor TAlimento.Destroy;
begin
   if Assigned (FDMUmAlimento) then
      FDMUmAlimento.Free;
   inherited Destroy;
end;

procedure TAlimento.Loaded;
begin
   inherited Loaded;
   DM:= FDMUmAlimento;
   with FDMUmAlimento.taAlimento do
   begin
      Open;
   end;
end;

procedure TAlimento.SetIDAlimento(const Value: String);
begin
   FIDAlimento := Value;
   if ( FIDAlimento <> '') and FDMUmAlimento.taAlimento.Active then
   begin
      if not FDMUmAlimento.taAlimento.Locate( 'IDALI', FIDAlimento, [] ) then
         ShowMessage( 'Não consegui achar alimento' )
//+      else
//+         NotifyLinks(self, lChange);
   end;
end;

procedure TAlimento.SetDMUmAlimento(const Value: TDMUmAlimento);
begin
   FDMUmAlimento := Value;
   if Value <> nil then
      Value.FreeNotification(Self);
end;

procedure TAlimento.OpenTables;
begin
   // Eu não quero que ative as tabelas na definicao do database
end;

procedure TAlimento.SetPeso(const Value: Double);
begin
  FPeso := Value;
//+  if Assigned( FDMUmAlimento ) then
//+     FDMUmAlimento.Peso := Value;
end;

procedure TAlimento.GetPesoAlimento(Sender: TObject; var PesoAlimento: Double);
begin
   PesoAlimento := FPeso;
end;

end.

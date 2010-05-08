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




unit CNSEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CCSListaLinks, CNSConnect, DB, DBTables, CNSDBSUS;

type
  TCNSEdit = class(TEdit)
  private
    { Private declarations }
    FLink : TCCSLink;
    FCNSDBSUS : TCNSDBSUS;
    FNomeCampo: string;
    // FCanCarregar Indica se foi eu quem emitiu a solicitacao de notify
    FCanMontar : boolean;
    procedure DoLinkEvent(Sender : TObject; lState : TLinkState);
    procedure SetCNSDBSUS(Value : TCNSDBSUS);
    procedure SetNomeCampo(const Value: string);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Change; override;
  public
    { Public declarations }
    constructor create(AOwner : TComponent); override;
    destructor destroy; override;
    procedure loaded; override;
  published
    { Published declarations }
    property CNSDBSUS : TCNSDBSUS read FCNSDBSUS write SetCNSDBSUS;
    property NomeCampo : string read FNomeCampo write SetNomeCampo;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Teste', [TCNSEdit]);
end;

constructor TCNSEdit.create(AOwner : TComponent);
begin
   inherited create(AOwner);
   FLink := TCCSLink.Create(self);
   FLink.OnLinkEvent := DoLinkEvent;
   FCanMontar := True;
end;

destructor TCNSEdit.destroy;
begin
  if assigned(FCNSDBSUS) then
     FCNSDBSUS.Delete(FLink);
   FLink.OnLinkEvent := nil;
   FLink.Free;
   inherited destroy;
end;


procedure TCNSEdit.Loaded;
begin
   inherited Loaded;
end;
procedure TCNSEdit.SetCNSDBSUS(Value : TCNSDBSUS);
begin
   FCNSDBSUS := Value;
   if assigned(value) then
   begin
      FCNSDBSUS.add(FLink);
     if not (csLoading in ComponentState) then
     begin
        Text := FCNSDBSUS.Getfield(NomeCampo);
     end;
      Value.freenotification(self);
   end;
end;

procedure TCNSEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FCNSDBSUS <> nil) and (AComponent = CNSDBSUS) then
       CNSDBSUS := nil;
  end;
end;

procedure TCNSEdit.DoLinkEvent(Sender : TObject; lState : TLinkState);
begin
   if assigned(FCNSDBSUS) then
   begin
      with FCNSDBSUS do
      begin
         case  lState of
            lLoad   : Text := Getfield(NomeCampo);
            lUpDate : PutField(NomeCampo, Text);
         end;
      end;
   end;
end;


procedure TCNSEdit.Change;

begin
end;

procedure TCNSEdit.SetNomeCampo(const Value: string);
begin
  FNomeCampo := Value;
end;

end.


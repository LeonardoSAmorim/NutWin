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




unit NewLookCombo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CCSListaLinks, CNSConnect, DB, DBTables, CNSDBSUS, NewCombo;

type
  TNewLookCombo = class(TNewCombo)
  private
    { Private declarations }
    FLink : TCCSLink;
    FCNSDBSUSLook : TCNSDBSUS;
    FNomeCampoLook: string;
    FDataCorrente : string;
    // FCanCarregar Indica se foi eu quem emitiu a solicitacao de notify
    FCanMontar : boolean;
    procedure SetCNSDBSUSLook(Value : TCNSDBSUS);
    procedure SetNomeCampoLook(const Value: string);
  protected
    { Protected declarations }
    procedure DoLinkEvent(Sender : TObject; lState : TLinkState); override;
    procedure MontarCombo; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Change; override;
  public
    { Public declarations }
    constructor create(AOwner : TComponent); override;
    destructor destroy; override;
    procedure loaded; override;
  published
    { Published declarations }
    property CNSDBSUSLook : TCNSDBSUS read FCNSDBSUSLook write SetCNSDBSUSLook;
    property NomeCampoLook : string read FNomeCampoLook write SetNomeCampoLook;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Teste', [TNewLookCombo]);
end;

constructor TNewLookCombo.create(AOwner : TComponent);
begin
   inherited create(AOwner);
   FLink := TCCSLink.Create(self);
   FLink.OnLinkEvent := DoLinkEvent;
   FCanMontar := True;
   FCNSDBSUSLook := nil;
end;

destructor TNewLookCombo.destroy;
begin
   if assigned(FCNSDBSUSLook) then
   begin
      FCNSDBSUSLook.Delete(FLink);
   end;
   FLink.OnLinkEvent := nil;
   FLink.Free;
   inherited destroy;
end;

procedure TNewLookCombo.Loaded;
begin
end;

procedure TNewLookCombo.SetCNSDBSUSLook(Value : TCNSDBSUS);
begin
   FCNSDBSUSLook := Value;
   if assigned(value) then
   begin
      FCNSDBSUSLook.add(FLink);
      if not (csLoading in ComponentState) then
      begin
         MontarCombo;
      end;
      Value.freenotification(self);
   end;
end;

procedure TNewLookCombo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FCNSDBSUSLook <> nil) and (AComponent = CNSDBSUSLook) then
       CNSDBSUSLook := nil;
  end;
end;

procedure TNewLookCombo.DoLinkEvent(Sender : TObject; lState : TLinkState);
begin
   if (lState = lLoad) and FCanMontar then
   begin
      MontarCombo;
      Text := CNSDBSUS.GetField(NomeCampo);
   end else
      if lState = lUpDate then
         FCNSDBSUSLook.PutField(NomeCampoLook, Text);
end;

procedure TNewLookCombo.Change;
begin
end;

procedure TNewLookCombo.MontarCombo;
begin
   inherited MontarCombo;
end;

procedure TNewLookCombo.SetNomeCampoLook(const Value: string);
begin
  FNomeCampoLook := Value;
end;

end.


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




unit CNSCheckedListaBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CCSListaLinks, CNSConnect, DB, DBTables, CNSDBSUS, checklst;

type
  TCNSCheckedListaBox = class(TCheckListBox)
  private
    { Private declarations }
    FLink : TCCSLink;
    FCNSDBSUS : TCNSDBSUS;
    FNomeCampo: string;
    FDataCorrente : string;
    FMenuControl : TCNSMenuControl;
    FStringChekd : string;
    FTratarNome : TCNSPreparar;
    // FCanCarregar Indica se foi eu quem emitiu a solicitacao de notify
    FCanMontar : boolean;
    procedure DoLinkEvent(Sender : TObject; lState : TLinkState);
    procedure SetCNSDBSUS(Value : TCNSDBSUS);
    procedure SetNomeCampo(const Value: string);
    procedure SetMenuControl(Value : TCNSMenuControl);
    procedure MontarCheckPermissoes;
    procedure StrToCheck;
    procedure CheckToStr;
    procedure ReadStringChekd(Reader: TReader);
    procedure WriteStringChekd(Writer: TWriter);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor create(AOwner : TComponent); override;
    destructor destroy; override;
    procedure loaded; override;
    procedure DefineProperties(Filer: TFiler); override;
//    property StringChekd : string read FStringChekd write FStringChekd;
  published
    { Published declarations }
    property CNSDBSUS : TCNSDBSUS read FCNSDBSUS write SetCNSDBSUS;
    property NomeCampo : string read FNomeCampo write SetNomeCampo;
    property MenuControl : TCNSMenuControl read FMenuControl write SetMenuControl;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Teste', [TCNSCheckedListaBox]);
end;

constructor TCNSCheckedListaBox.create(AOwner : TComponent);
var
   i : integer;
begin
   inherited create(AOwner);
   FLink := TCCSLink.Create(self);
   FLink.OnLinkEvent := DoLinkEvent;
   FTratarNome := TCNSPreparar.Create(nil);
   FDataCorrente := ' ';
   FCanMontar := True;
   FStringChekd := '';
   for i := 1 to 255 do
       FStringChekd := FStringChekd + 'F';
end;

destructor TCNSCheckedListaBox.destroy;
begin
  if assigned(FCNSDBSUS) then
     FCNSDBSUS.Delete(FLink);
   FLink.OnLinkEvent := nil;
   FLink.Free;
   FTratarNome.Destroy;
   inherited destroy;
end;


procedure TCNSCheckedListaBox.Loaded;
begin
   inherited Loaded;
end;

procedure TCNSCheckedListaBox.DefineProperties(Filer: TFiler);
begin
   inherited;
   Filer.DefineProperty('StringChekd', ReadStringChekd, WriteStringChekd,True);
end;

procedure TCNSCheckedListaBox.ReadStringChekd(Reader: TReader);
begin
   FStringChekd := Reader.ReadString;
end;

procedure TCNSCheckedListaBox.WriteStringChekd(Writer: TWriter);
begin
   Writer.WriteString(FStringChekd);
end;

procedure TCNSCheckedListaBox.SetCNSDBSUS(Value : TCNSDBSUS);
begin
   FCNSDBSUS := Value;
   if assigned(value) then
   begin
      FCNSDBSUS.add(FLink);
      if not (csLoading in ComponentState) then
      begin
         FStringChekd := FCNSDBSUS.Getfield(NomeCampo);
         Value.freenotification(self);
      end;
      MontarCheckPermissoes;
      StrToCheck;
   end;
end;

procedure TCNSCheckedListaBox.SetNomeCampo(const Value: string);
begin
  FNomeCampo := Value;
end;

procedure TCNSCheckedListaBox.SetMenuControl(Value : TCNSMenuControl);
begin
   FMenuControl := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(self);
   end;
end;

procedure TCNSCheckedListaBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FCNSDBSUS <> nil) and (AComponent = CNSDBSUS) then
       CNSDBSUS := nil;
    if (FMenuControl <> nil) and (AComponent = MenuControl) then
       MenuControl := nil;
  end;
end;

procedure TCNSCheckedListaBox.DoLinkEvent(Sender : TObject; lState : TLinkState);
begin
   if (lState = lLoad) and FCanMontar then
   begin
      FStringChekd := FCNSDBSUS.Getfield(NomeCampo);
      StrToCheck
   end;
   if lState = lUpDate then
   begin
      CheckToStr;
      FCNSDBSUS.PutField(NomeCampo, FStringChekd);
   end;
end;


procedure TCNSCheckedListaBox.MontarCheckPermissoes;
var
   i : integer;
begin
    if assigned(MenuControl) then
    begin
       items.Clear;
       if FMenuControl.ListaOpcoes.count > 0 then
          for i := 0 to FMenuControl.ListaOpcoes.count - 1 do
          begin
             FTratarNome.Nome := FMenuControl.ListaOpcoes[i];
             FTratarNome.TirarCaracteresInvalidos;
             items.add(FTratarNome.NomeTratado);
          end;
    end;
end;

procedure TCNSCheckedListaBox.StrToCheck;
var
   i : integer;
begin
   IF FStringChekd = '' then
      for i := 1 to 255 do
          FStringChekd := FStringChekd + 'F';
   for i := 0 to items.Count - 1  do
      if FStringChekd[i + 1] = 'T' then
         Checked[i] := True
      else
         Checked[i] := False;
   Repaint;
end;

procedure TCNSCheckedListaBox.CheckToStr;
var
   i : integer;
begin
   FStringChekd := '';
   for i := 1 to 255 do
       FStringChekd := FStringChekd + 'F';
   for i := 0 to items.Count - 1 do
      if Checked[i] = True then
         FStringChekd[i + 1] := 'T'
      else
         FStringChekd[i + 1] := 'F';
end;

end.


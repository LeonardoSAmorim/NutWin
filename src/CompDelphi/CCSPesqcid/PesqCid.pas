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




unit PesqCid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, UBusca;

type
  TCloseCIDQueryEvent = procedure (Sender: TComponent; NewCID : string ; var CanClose: Boolean)  of object ;
  TPesqCid = class(TComponent)
  private
    FHelpContext: integer;
    FDiretorioCID: string;
    FCodigoCID: string;
    FPesquisaInicial: string;
    FDescricaoCID: string;

    FOnCanClose: TCloseCIDQueryEvent;
    FOnClose: TnotifyEvent;
    FOnShow: TnotifyEvent;
    FDetalheCID: Tstrings;
    procedure SetCodigoCID(const Value: string);
    procedure SetDescricaoCID(const Value: string);
    procedure SetDiretorioCID(const Value: string);
    procedure SetHelpContext(const Value: integer);
    procedure SetOnCanClose(const Value: TCloseCIDQueryEvent);
    procedure SetOnClose(const Value: TnotifyEvent);
    procedure SetOnShow(const Value: TnotifyEvent);
    procedure SetPesquisaInicial(const Value: string);
    procedure SetDetalheCID(const Value: Tstrings);
    { Private declarations }
  protected
    { Protected declarations }
    FTelaCid : TBuscaCodigo;
  public
    { Public declarations }

    property CodigoCID : string read FCodigoCID write SetCodigoCID;
    property DescricaoCID :  string read FDescricaoCID write SetDescricaoCID;
    property DetalheCID : Tstrings read FDetalheCID write SetDetalheCID;
    Constructor Create(AOwner:TComponent);override;
    Function Execute : boolean;
    Destructor Destroy ; override;

 // Obs : Os filhos : Vão Ter filtros de CID ( por capítulos, etc).


  published
    { Published declarations }
    property DiretorioCID : string read FDiretorioCID write SetDiretorioCID;
           // Se branco usa diretório corrente da aplicação,
           // Se ActiveX, usa o diretório de instalação do ActiveX.
    property HelpContext : integer read FHelpContext write SetHelpContext;
    property PesquisaInicial : string read FPesquisaInicial write SetPesquisaInicial;
    property OnCanClose  : TCloseCIDQueryEvent  read FOnCanClose write SetOnCanClose;
    property OnClose : TnotifyEvent read FOnClose write SetOnClose;
    property OnShow : TnotifyEvent read FOnShow write SetOnShow;

 end;
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TPesqCid]);
end;

{ TPesqCid }

constructor TPesqCid.Create(AOwner: TComponent);
begin
  inherited;
  FDetalheCID:=TStringList.Create;

//  FTelaCid := TBuscaCodigo.create(Application);
end;

destructor TPesqCid.Destroy;
begin
  inherited;
  FDetalheCID.Free;

//  if Assigned(FTelaCid) then
//  FTelaCid.free;

end;

function TPesqCid.Execute: boolean;
var
f1:TBuscaCodigo;
CanClose : Boolean;
begin
   F1:=TBuscaCodigo.create(self);
   f1.cbChave.Text := FPesquisaInicial;
   f1.bProcura.Click;

repeat
 begin
 if Assigned (OnShow) then
    OnShow(self);
 F1.ShowModal;
 if F1.ModalResult = mrOk then
    begin
      CanClose:=True;
      if Assigned(OnCanClose) then
         OnCanClose(self,f1.Label3.Caption,CanClose);
      if CanClose then
         begin
         FCodigoCID := f1.Label3.Caption ;
         FDescricaoCID:= TextDescrCID;
         FDetalheCID.Assign (f1.Detalhe.Lines);
         result := true
         end
      else
         result := false; 
    end
   else
    begin
    result := false;
    CanClose:=True;
    end;
 end;
until (CanClose);

 if Assigned (OnClose) then
    OnClose(self);

   F1.free;
end;

procedure TPesqCid.SetCodigoCID(const Value: string);
begin
  FCodigoCID := Value;
end;

procedure TPesqCid.SetDescricaoCID(const Value: string);
begin
  FDescricaoCID := Value;
end;

procedure TPesqCid.SetDiretorioCID(const Value: string);
var
  tam : integer;
begin
  FDiretorioCID := Value;
  Rota := Value;
  tam := length(rota);
  if copy (rota,tam,1) <> '\' then
     rota := rota + '\';
end;

procedure TPesqCid.SetHelpContext(const Value: integer);
begin
  FHelpContext := Value;
end;

procedure TPesqCid.SetOnCanClose(const Value: TCloseCIDQueryEvent);
begin
  FOnCanClose := Value;
end;

procedure TPesqCid.SetOnClose(const Value: TnotifyEvent);
begin
  FOnClose := Value;
end;

procedure TPesqCid.SetOnShow(const Value: TnotifyEvent);
begin
  FOnShow := Value;
end;

procedure TPesqCid.SetPesquisaInicial(const Value: string);
begin
  FPesquisaInicial := Value;
end;

procedure TPesqCid.SetDetalheCID(const Value: Tstrings);
begin
  FDetalheCID := Value;
end;

end.

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




unit CCSFonetizar;

interface

uses Classes, SysUtils, CCSListaLinks, CCSFonemas, CCSAbreviar, CCSPilhas;

type

//  TCustomFonetizar = class(TCompOCX) tirei para poder entrar  no DM
  TCustomFonetizar = class(TCCSListaLinks)
  private
    { Private declarations }
    FOnAntesFonetizar: TNotifyEvent;
    FOnDepoisFonetizar: TNotifyEvent;
    //Objeto para abreviar o nome a ser abreviado
    FAbreviar : TCustomAbreviar;
    //Indica o tamanho maximo do nome abreviado
    FTamanhoSaida : integer;
    //Objeto que contem a tabela de tokens para trocas
    FFonemas : TCustomFonemas;
    //Indica o nome fonetizado
    FNomeFonetizado : string;
    //Nome a ser fonetizado
    FNome : string;
    FPadrao : TPadrao;
    //Pilha com o nome fonetico segmentado
    FPilhaNomeFonetico : TCusTomPilhaStatica;
//    procedure SetAbreviar(Value : TCustomAbreviar);
    procedure SetFonemas(Value : TCustomFonemas);
    procedure AjustarPadrao;
    procedure SetPadrao(Value : TPadrao);

  protected
    { Protected declarations }
     procedure Loaded; override;
     procedure Notification(AComponent: TComponent; Operation: TOperation); override;
     function ConcatenarFonema(xFonema : string) : string;
     property Abreviar : TCustomAbreviar read FAbreviar;


  public
    { Public declarations }
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
     procedure Fonetizar;
     function Fonetizacao(Value: string) : string;
     property Fonemas : TCustomFonemas read FFonemas write SetFonemas;
     property Nome : string read FNome write FNome;
     property NomeFonetico : string read FNomeFonetizado;
     property Padrao : TPadrao read FPadrao write SetPadrao default CEF;
     property TamanhoSaida : integer read FTamanhoSaida write FTamanhoSaida;
     property OnAntesFonetizar: TNotifyEvent read FOnAntesFonetizar write FOnAntesFonetizar;
     property OnDepoisFonetizar: TNotifyEvent read FOnDepoisFonetizar write FOnDepoisFonetizar;
  published
    { Published declarations }
  end;

  TCCSFonetizar = class(TCustomFonetizar)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
//     property Abreviar;
     property Fonemas;
     property Nome;
     property Padrao;
     property NomeFonetico;
     property TamanhoSaida;
     property OnAntesFonetizar;
     property OnDepoisFonetizar;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TCCSFonetizar]);
end;

//TCustomFonetizar    /////////////////////////////////////////

constructor TCustomFonetizar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPilhaNomeFonetico := TCusTomPilhaStatica.Create(nil);
  FAbreviar := TCustomAbreviar.Create(nil);
  FPadrao := CEF;
  AjustarPadrao;
end;

procedure TCustomFonetizar.Loaded;
begin
  inherited Loaded;
end;


destructor TCustomFonetizar.Destroy;
begin
  FPilhaNomeFonetico.Free;
  if assigned(Fonemas) then
     if FFonemas.Owner = nil then
        FFonemas.Destroy;
  FAbreviar.Destroy;
  inherited Destroy;
end;

{ Não está sendo usado, por enquanto
procedure TCustomFonetizar.SetAbreviar(Value : TCustomAbreviar);
begin
   FAbreviar := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;}

procedure TCustomFonetizar.SetPadrao(Value : TPadrao);
begin
   FPadrao := Value;
   AjustarPadrao;
end;

procedure TCustomFonetizar.AjustarPadrao;
begin
   case Padrao of
      CEF, TSE  :
      begin
         TamanhoSaida := 28;
      end;
   end;
end;


procedure TCustomFonetizar.Fonetizar;
var
  TamanhoSaidaAux1 : integer;
  strFonema : string;
  xPadrao : TPadrao;
begin
   if Assigned(FOnAntesFonetizar) then FOnAntesFonetizar(Self);
//   if not assigned(FAbreviar) then
//      FAbreviar := TCustomAbreviar.Create(nil);
   if FAbreviar <> nil  then
   begin
      if FNome <> '' then
      begin
         with FAbreviar do
         begin
           //oolhar com cuidado
            TamanhoSaidaAux1 := FAbreviar.TamanhoSaida;
            xPadrao := FAbreviar.Padrao;
            FAbreviar.Padrao := Custom;
            strFonema := self.FNome;
            repeat
               FAbreviar.Nome := self.FNome;
               AbreviarNome;
               TirarTodasPreposicoes;
               if FAbreviar.TamanhoSaida  < length(FAbreviar.NomeAbreviado) then
                  break;
               FAbreviar.TamanhoSaida := FAbreviar.TamanhoSaida - 1;
               strFonema := #32 + FAbreviar.NomeAbreviado;
               strFonema := Fonetizacao(strFonema);
            until length(strFonema) <= self.TamanhoSaida;
            FAbreviar.TamanhoSaida := TamanhoSaidaAux1;
            FAbreviar.Padrao := xPadrao;
            FNomeFonetizado := strFonema;
            if Assigned(FOnDepoisFonetizar) then FOnDepoisFonetizar(Self);
         end;
      end;
   end;
end;

function TCustomFonetizar.Fonetizacao(Value: string) : string;
begin
   if not Assigned(Fonemas) then
      FFonemas := TCustomFonemas.Create(nil);
   Fonemas.Nome := string(Value);
   Fonemas.First;
   repeat
      Fonemas.IdxNome := 1;
      while (Fonemas.IdxNome <= Length(Fonemas.Nome)) do
      begin
         if (Fonemas.Nome[Fonemas.IdxNome] = Fonemas.Token[1]) or (Fonemas.Token[1] = '!') or (Fonemas.Token[1] = '?') or (Fonemas.Token[1] = '@') then
            if Fonemas.TrocarToken then
               FFonemas.Nome := copy(FFonemas.Nome, 1, Fonemas.IdxNome - 1) + Fonemas.Fonema + copy(FFonemas.Nome, (Fonemas.IdxNome + Fonemas.LenSeg), ((Fonemas.LenNome) - (Fonemas.IdxNome + (Fonemas.LenSeg) -1)));

         Fonemas.IdxNome := Fonemas.IdxNome + 1;
      end;
   until not (Fonemas.Next);
   Result := Trim(Fonemas.Nome);
   Result := ConcatenarFonema(Result);
end;

function TCustomFonetizar.ConcatenarFonema(xFonema : string) : string;
var
   ChaveFonetica1, ChaveFonetica2, ChaveFonetica3 : string;
begin
   Result := '';
   ChaveFonetica1 := '';
   ChaveFonetica2 := '';
   ChaveFonetica3 := '';
   FPilhaNomeFonetico.Init;
//   if not assigned(FAbreviar) then
//      FAbreviar := TCustomAbreviar.Create(nil);
   if assigned(FAbreviar) then
   begin
      FAbreviar.SepararNomes(FPilhaNomeFonetico, xFonema, #32, direita);
      if FPilhaNomeFonetico.Posicao >= 1 then
         ChaveFonetica1 := FPilhaNomeFonetico.Pop;
      while FPilhaNomeFonetico.Posicao > 1 do
      begin
          ChaveFonetica2 := ChaveFonetica2 + FPilhaNomeFonetico.Pop;
      end;
      if FPilhaNomeFonetico.Posicao = 1 then
         ChaveFonetica3 := FPilhaNomeFonetico.Pop;
         Result := ChaveFonetica1 + ChaveFonetica3 +  ChaveFonetica2;
   end;
end;


procedure TCustomFonetizar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FFonemas <> nil) and (AComponent = Fonemas) then
       Fonemas := nil;
  end;
end;


procedure TCustomFonetizar.SetFonemas(Value : TCustomFonemas);
begin
  FFonemas := Value;
  if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

end.

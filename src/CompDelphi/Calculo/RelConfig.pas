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




unit RelConfig;

{$R-}

interface

uses Windows, SysUtils, classes, Dialogs, PRINTERS, NutCnst;

type

  TRelTipoIdentificacao = ( riNenhuma, riSimplificada, riCompleta );

  TRelatorio = class(TGUIDItem)
  private
    FProcessadorClassName: String;
    FDescricao: String;
    FFormClassName: String;
    FOrientacao: TPrinterOrientation;
    FReport: TObject;
    FNovaPagina: Boolean;
    FTipoIdentificacao: TRelTipoIdentificacao;
    FLinhaSeparadora: Integer;
    FIdentificacaoParaTodos: Boolean;
    FMostraTitulo: Boolean;
    procedure SetDescricao(const Value: String);
    procedure SetFormClassName(const Value: String);
    procedure SetOrientacao(const Value: TPrinterOrientation);
    procedure SetProcessadorClassName(const Value: String);
    procedure SetReport(const Value: TObject);
    procedure SetNovaPagina(const Value: Boolean);
    procedure SetTipoIdentificacao(const Value: TRelTipoIdentificacao);
    procedure SetLinhaSeparadora(const Value: Integer);
    procedure SetIdentificacaoParaTodos(const Value: Boolean);
    procedure SetMostraTitulo(const Value: Boolean);
  public
    property MostraTitulo: Boolean read FMostraTitulo write SetMostraTitulo;
    property Descricao : String read FDescricao write SetDescricao;
    property FormClassName : String read FFormClassName write SetFormClassName;
    property ProcessadorClassName : String read FProcessadorClassName write SetProcessadorClassName;
    property Orientacao : TPrinterOrientation read FOrientacao write SetOrientacao;
    property NovaPagina : Boolean read FNovaPagina write SetNovaPagina;
    property TipoIdentificacao : TRelTipoIdentificacao read FTipoIdentificacao write SetTipoIdentificacao;
    property IdentificacaoParaTodos : Boolean read FIdentificacaoParaTodos write SetIdentificacaoParaTodos;
    property LinhaSeparadora : Integer read FLinhaSeparadora write SetLinhaSeparadora;
    property Report : TObject read FReport write SetReport;
    function MySelf : TRelatorio;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  end;

implementation

{ TRelatorio  =================================================================}

function TRelatorio.MySelf: TRelatorio;
begin
   Result := Self;
end;

procedure TRelatorio.SetDescricao(const Value: String);
begin
  FDescricao := Value;
end;

procedure TRelatorio.SetFormClassName(const Value: String);
begin
  FFormClassName := Value;
end;

procedure TRelatorio.SetReport(const Value: TObject);
begin
  FReport := Value;
end;

procedure TRelatorio.SetOrientacao(const Value: TPrinterOrientation);
begin
  FOrientacao := Value;
end;

procedure TRelatorio.SetProcessadorClassName(const Value: String);
begin
  FProcessadorClassName := Value;
end;

procedure TRelatorio.SetNovaPagina(const Value: Boolean);
begin
  FNovaPagina := Value;
end;

{ Resets prop of component type if referenced component deleted }
procedure TRelatorio.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
   inherited Notification(AComponent, Operation);
   if Operation <> opRemove then
      Exit;
   if AComponent = FReport then
      FReport := nil
end;

procedure TRelatorio.SetTipoIdentificacao(
  const Value: TRelTipoIdentificacao);
begin
  FTipoIdentificacao := Value;
end;

procedure TRelatorio.SetLinhaSeparadora(const Value: Integer);
begin
  FLinhaSeparadora := Value;
end;

procedure TRelatorio.SetIdentificacaoParaTodos(const Value: Boolean);
begin
  FIdentificacaoParaTodos := Value;
end;

procedure TRelatorio.SetMostraTitulo(const Value: Boolean);
begin
  FMostraTitulo := Value;
end;

end.
 
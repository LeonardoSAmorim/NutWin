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




unit ConversaoBanco;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ConversaoCM, ConversaoErros, dbtables, db, dmConversao;

type
  TConversaoBanco = class(TComponent)
  private
    FDatabaseName: String;
    FSenha: String;
    FDatabaseNameNew: String;
    FOnAntesDeGravar: TAntesDeGravarEvent;
    FTemErro: Boolean;
    FCancelou: Boolean;
    FConverteu: Boolean;
    FUserName: String;
    procedure SetDatabaseName(const Value: String);
    procedure SetSenha(const Value: String);
    procedure SetDatabaseNameNew(const Value: String);
    procedure SetOnAntesDeGravar(const Value: TAntesDeGravarEvent);
    procedure SetCancelou(const Value: Boolean);
    procedure SetTemErro(const Value: Boolean);
    procedure SetConverteu(const Value: Boolean);
    procedure SetUserName(const Value: String);
    { Private declarations }
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    LimpaTabela:Boolean;
    property TemErro : Boolean read FTemErro write SetTemErro;
    property Cancelou : Boolean read FCancelou write SetCancelou;
    property Converteu : Boolean read FConverteu write SetConverteu;
    Constructor Create(AOwner:TComponent);override;
    Function Execute : boolean;
    Destructor Destroy ; override;

  published
    { Published declarations }
    property DatabaseName:String read FDatabaseName write SetDatabaseName;
    property DatabaseNameNew:String read FDatabaseNameNew write SetDatabaseNameNew;
    property Senha:String read FSenha write SetSenha;
    property UserName:String read FUserName write SetUserName;
    property OnAntesDeGravar:TAntesDeGravarEvent read FOnAntesDeGravar write SetOnAntesDeGravar;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TConversaoBanco]);
end;

{ TConversaoBanco }

constructor TConversaoBanco.Create(AOwner: TComponent);
begin
  inherited;
  LimpaTabela:=true;
end;

destructor TConversaoBanco.Destroy;
begin
  inherited;
end;

function TConversaoBanco.Execute: boolean;
var
  LfmConversao : TfmConversaoCM;
begin
  //Iniciando Conversão...
  Application.CreateForm( TdmConv, dmConv );
  LfmConversao := TfmConversaoCM.create(self);
  {Parametros para Inicialização}
  LfmConversao.psDataBase:=FDatabaseName;
  LfmConversao.psDataBaseNew:=FDataBaseNameNew;
  LfmConversao.PsSenha:=FSenha;
  LfmConversao.PsUserName:=FUserName;
  LfmConversao.SetOnAntesDeGravar(FOnAntesDeGravar);
  LfmConversao.SetLimpaTabela(LimpaTabela);
  {Fim Parâmetros}
  LfmConversao.show;
  Result:=LfmConversao.Converter;
  FConverteu := True;
  FTemErro := LfmConversao.TemErros;
  FCancelou := LfmConversao.Cancelou;
  LfmConversao.free;
  dmConv.Free;
end;


procedure TConversaoBanco.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if operation = opRemove then
  begin
  end;
end;

procedure TConversaoBanco.SetCancelou(const Value: Boolean);
begin
  ShowMessage( 'Esta propriedade não pode ser alterada' );
//  FCancelou := Value;
end;

procedure TConversaoBanco.SetConverteu(const Value: Boolean);
begin
  ShowMessage( 'Esta propriedade não pode ser alterada' );
//  FConverteu := Value;
end;

procedure TConversaoBanco.SetDatabaseName(const Value: String);
begin
  FDatabaseName := Value;
end;

procedure TConversaoBanco.SetDatabaseNameNew(const Value: String);
begin
  FDatabaseNameNew := Value;
end;

procedure TConversaoBanco.SetOnAntesDeGravar(
  const Value: TAntesDeGravarEvent);
begin
  FOnAntesDeGravar := Value;
end;

procedure TConversaoBanco.SetSenha(const Value: String);
begin
  FSenha := Value;
end;

procedure TConversaoBanco.SetTemErro(const Value: Boolean);
begin
  ShowMessage( 'Esta propriedade não pode ser alterada' );
//  FTemErro := Value;
end;

procedure TConversaoBanco.SetUserName(const Value: String);
begin
  FUserName := Value;
end;

end.

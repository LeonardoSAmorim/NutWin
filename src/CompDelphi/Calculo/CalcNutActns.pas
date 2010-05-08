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




unit CalcNutActns;

interface

uses Classes, ActnList, IOController, CalculoViewer, Escopo, forms, NutCnst,
     Dialogs, Measurement;

type
  { CalcNut actions }
  TCalcNutAction = class(TAction)
  private
    FIOController: TIOController;
    FShowCalcName: Boolean;
    FCalculoViewer: TCalculoViewer;
    FEscopo: TEscopo;
    procedure SetIOController(const Value: TIOController);
    procedure SetShowCalcName(const Value: Boolean);
    procedure SetCalculoViewer(const Value: TCalculoViewer);
    procedure SetEscopo(const Value: TEscopo);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function AllowExecute(const NomeCalculo : String; var Mensagem : String) : Boolean;
    function HandlesTarget(Target: TObject): Boolean; override;
    property IOController : TIOController read FIOController write SetIOController;
    property CalculoViewer : TCalculoViewer read FCalculoViewer write SetCalculoViewer;
    property ShowCalcName : Boolean read FShowCalcName write SetShowCalcName;
    property Escopo : TEscopo read FEscopo write SetEscopo;
  end;

  TCalcNutNovo = class(TCalcNutAction)
  private
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property IOController;
    property CalculoViewer;
    property ShowCalcName;
  end;

  TCalcNutAbrir = class(TCalcNutAction)
  private
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property IOController;
    property CalculoViewer;
    property ShowCalcName;
  end;

  TCalcNutGravar = class(TCalcNutAction)
  private
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property IOController;
    property ShowCalcName;
  end;

  TCalcNutGravarComo = class(TCalcNutAction)
  private
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property IOController;
    property ShowCalcName;
  end;

  TCalcNutFechar = class(TCalcNutAction)
  private
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property IOController;
    property CalculoViewer;
    property ShowCalcName;
  end;

  TCalcNutDefineCalculo = class(TCalcNutAction)
  private
    FTipoCalculo: TNomeCalculo;
    procedure SetTipoCalculo(const Value: TNomeCalculo);
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property TipoCalculo : TNomeCalculo read FTipoCalculo write SetTipoCalculo;
    property IOController;
    property CalculoViewer;
  end;

  TCalcNutCalcular = class(TCalcNutAction)
  private
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property IOController;
    property CalculoViewer;
    property Escopo;
  end;

var
   Aberto : Boolean;

procedure Register;

implementation

procedure Register;
begin

   RegisterActions('CalcNut', [ TCalcNutNovo, TCalcNutAbrir, TCalcNutGravar, TCalcNutFechar, TCalcNutGravarComo, TCalcNutDefineCalculo, TCalcNutCalcular ], TIOController );

end;

{ TCalcNutAction }

function TCalcNutAction.HandlesTarget(Target: TObject): Boolean;
begin
  { Only handle Target if we don't already have a IOController assigned }
  Result := (IOController <> nil);
end;

procedure TCalcNutAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then
     exit;
  if (AComponent = IOController) then
     IOController := nil;
  if (AComponent = CalculoViewer) then
     CalculoViewer := nil;
  if (AComponent = Escopo) then
     Escopo := nil;
end;

procedure TCalcNutAction.SetShowCalcName(const Value: Boolean);
begin
  FShowCalcName := Value;
end;

procedure TCalcNutAction.SetIOController(const Value: TIOController);
begin
  FIOController := Value;
end;

procedure TCalcNutAction.SetCalculoViewer(const Value: TCalculoViewer);
begin
  FCalculoViewer := Value;
end;

procedure TCalcNutAction.SetEscopo(const Value: TEscopo);
begin
  FEscopo := Value;
end;

function TCalcNutAction.AllowExecute(const NomeCalculo : String; var Mensagem : String): Boolean;
var
   mdSelRC,
   mdEscopoCriado : TMedida;
   mdDiretorio : TMedidaOrdinal;
   Diretorio : TStringList;
begin
   // considera, inicialmente, que não se pode calcular 'NomeCalculo'
   Result := False;
   Mensagem := '';

   // carrega lista de cálculos já efetuados (mdDiretorio)
   Diretorio := TStringList.Create;
   if FIOController.Calculo.Memoria.Acha('mdDiretorio', TObject( mdDiretorio ) ) then
      Diretorio.CommaText := mdDiretorio.ValorNumerico;

   // vazio significa que o calculo não existe
   if (NomeCalculo = '') then
      Mensagem := 'Cálculo não implementado!'
   // se uma recomendação nutricional calculada foi feita para um
   // plano alimentar, esta só pode ser modificada pelo mesmo
   else if (NomeCalculo = 'RecCalorica') and
           FIOController.Calculo.Memoria.Acha('mdSelRecCal', TObject( mdSelRC ) ) and
           ( mdSelRc.AsFloat <> 0 ) then  // 0 - Nenhuma
      Mensagem := 'A Recomendação de energia só pode ser calculada pelo Plano Alimentar, pois compartilha os mesmos resultados.'
   // uma preparação não pode ser feita se a memoria já tiver um cálculo que usa escopo
   else if (NomeCalculo = 'Preparacao') and
           FIOController.Calculo.Memoria.Acha('mdEscopoCriado', TObject( mdEscopoCriado ) ) and
           ( mdEscopoCriado.AsFloat <> 0 ) then  // <> 0 - True
      Mensagem := 'O cálculo preparação não pode ser executado para um indivíduo.'
   // se já foi feita uma preparação não posso calcular qualquer outro tipo de calculo
   else if (NomeCalculo <> 'Preparacao') and ( Diretorio.IndexOf( 'Preparacao' ) >= 0 ) then
      Mensagem := 'Uma preparação já foi calculada, portanto nenhum outro cálculo para um indivíduo pode ser feito.'
   // não há restrições para a execução do cálculo
   else
      Result := True;

   Diretorio.Free;
end;

{ TCalcNutNovo }

procedure TCalcNutNovo.ExecuteTarget(Target: TObject);
begin
   if IOController.Fechar then
      begin
         IOController.Novo;
         Aberto := True;
         if ShowCalcName and ( Owner is TForm ) then
            TForm( Owner ).Caption := 'Calculadora Nutricional - ' + FIOController.Calculo.Memoria.NomeArquivo;
         if Assigned( CalculoViewer ) then
            CalculoViewer.ShowPreview;
      end;
end;

procedure TCalcNutNovo.UpdateTarget(Target: TObject);
begin
   Enabled := ( not Aberto ) and ( not (CalculoViewer.Calculando) );
end;

{ TCalcNutAbrir }

procedure TCalcNutAbrir.ExecuteTarget(Target: TObject);
begin
//   if IOController.Fechar then
      if IOController.Abrir then
      begin
         if ShowCalcName and ( Owner is TForm ) then
            TForm( Owner ).Caption := 'Calculadora Nutricional - ' + FIOController.Calculo.Memoria.NomeArquivo;
         Aberto := True;
         if Assigned( CalculoViewer ) then
            CalculoViewer.ShowPreview;
      end;
end;

procedure TCalcNutAbrir.UpdateTarget(Target: TObject);
begin
   Enabled := not ( CalculoViewer.Calculando );
end;

{ TCalcNutGravar }

procedure TCalcNutGravar.ExecuteTarget(Target: TObject);
begin
   IOController.Gravar;
   if ShowCalcName and ( Owner is TForm ) then
      TForm( Owner ).Caption := 'Calculadora Nutricional - ' + FIOController.Calculo.Memoria.NomeArquivo;
end;

procedure TCalcNutGravar.UpdateTarget(Target: TObject);
begin
   Enabled := ( Aberto ) and not ( CalculoViewer.Calculando ) and ( IOController.Calculo.Memoria.Modified > 0 );
end;

{ TCalcNutGravarComo }

procedure TCalcNutGravarComo.ExecuteTarget(Target: TObject);
begin
   IOController.GravarComo;
   if ShowCalcName and ( Owner is TForm ) then
      TForm( Owner ).Caption := 'Calculadora Nutricional - ' + FIOController.Calculo.Memoria.NomeArquivo;
end;

procedure TCalcNutGravarComo.UpdateTarget(Target: TObject);
var
   mdEscopoCriado : TMedida;
begin
   Enabled := ( Aberto ) and not ( CalculoViewer.Calculando ) and
              FIOController.Calculo.Memoria.Acha( 'mdEscopoCriado', TObject( mdEscopoCriado ) ) and
              ( mdEscopoCriado.AsFloat > 0 );
end;

{ TCalcNutFechar }

procedure TCalcNutFechar.ExecuteTarget(Target: TObject);
begin
   if IOController.Fechar then
   begin
      Aberto := False;
      if ShowCalcName and ( Owner is TForm ) then
         TForm( Owner ).Caption := 'Calculadora Nutricional';
      if Assigned( CalculoViewer ) then
         CalculoViewer.FechaPreview;
   end;
end;

procedure TCalcNutFechar.UpdateTarget(Target: TObject);
begin
   Enabled := Aberto and  not ( CalculoViewer.Calculando );
end;

{ TCalcNutDefineCalculo }

procedure TCalcNutDefineCalculo.ExecuteTarget(Target: TObject);
begin
   if Assigned( CalculoViewer ) then
   begin
      CalculoViewer.DefineCalculo(FTipoCalculo);
   end;
end;

procedure TCalcNutDefineCalculo.SetTipoCalculo(const Value: TNomeCalculo);
begin
  FTipoCalculo := Value;
end;

procedure TCalcNutDefineCalculo.UpdateTarget(Target: TObject);
var
   Msg : String;
begin
   Enabled := not ( CalculoViewer.Calculando ) and not( IOController.Calculo.Memoria.Empty ) and
              AllowExecute(CalculoViewer.AntropButtons[FTipoCalculo].Calculo, Msg );
end;

{ TCalcNutCalcular }

procedure TCalcNutCalcular.ExecuteTarget(Target: TObject);
var
   Msg : String;
begin

   // Permite executar CalculoCorrente?
   if not AllowExecute( FCalculoViewer.CalculoCorrente, Msg ) then
      ShowMessage( Msg )
   else
      begin

         if not(FCalculoViewer.CalculoCorrente = 'Preparacao') and
            not(FCalculoViewer.CalculoCorrente = 'AtividadeFisica') then //*
            begin
               // Faz backup antes de mais nada
               FIOController.Calculo.BackupMemoria;
               // Cria variaveis de escopo, se necessario
               FIOController.DefineVariaveisEscopo( FCalculoViewer.CalculoCorrente );
               // Pede escopo
               if Escopo.Pegar then
                   begin
                      // Cria variaveis do calculo, se necessario
                      FIOController.DefineVariaveisCalculo( FCalculoViewer.CalculoCorrente );
                      // Calcular
                      FCalculoViewer.Calculando:=True;
                      FCalculoViewer.FechaPreview;
                   end
               else
                  // Restaurar memoria
                  FIOController.Calculo.RestoreMemoria;
            end
         else
            begin
               // Faz backup
               FIOController.Calculo.BackupMemoria;
               // Cria variaveis do calculo, se necessario
               FIOController.DefineVariaveisCalculo( FCalculoViewer.CalculoCorrente );
               // Calular
               FCalculoViewer.Calculando:=True;
               FCalculoViewer.FechaPreview;
            end;
      end;

{   if not (CalculoViewer.CalculoCorrente = '') then
         if not(FCalculoViewer.CalculoCorrente = 'Preparacao') and
      begin
        if Escopo.Pegar then
            begin
               CalculoViewer.Calculando:=True;
               CalculoViewer.FechaPreview;
            end;
      end
   else
      begin
         CalculoViewer.Calculando:=True;
         CalculoViewer.FechaPreview;
      end;}
end;

procedure TCalcNutCalcular.UpdateTarget(Target: TObject);
begin
   Enabled := (not CalculoViewer.Calculando ) and (not IOController.Calculo.Memoria.Empty )
   and (not CalculoViewer.PreviewBusy) and ( CalculoViewer.CalculoCorrente <> '' );
end;

end.

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




unit DBCalcNutActns;

interface

uses Classes, SysUtils, Dialogs, ActnList, DBIOController, CalculoViewer, Escopo, forms, NutCnst, db,
     measurement, Controls;

type
  TNotifyDataCalculoEvent = procedure( Sender : TObject; var DataCalculo : String; var CancelaCalculo : Boolean ) of Object;

  { DBCalcNut actions }
  TDBCalcNutAction = class(TAction)
  private
    FDBIOController: TDBIOController;
    FCalculoViewer: TCalculoViewer;
    FEscopo: TEscopo;
    FDataSource: TDataSource;
    FDataField: String;
    FOnBeforeCalcular: TnotifyEvent;
    FOnDefineDataCalculo: TNotifyDataCalculoEvent;
    FOnDefineAlmaHumana: TNotifyEvent;
    procedure SetDBIOController(const Value: TDBIOController);
    procedure SetCalculoViewer(const Value: TCalculoViewer);
    procedure SetEscopo(const Value: TEscopo);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetDataField(const Value: String);
    procedure SetOnBeforeCalcular(const Value: TnotifyEvent);
    procedure SetOnDefineAlmaHumana(const Value: TNotifyEvent);
    procedure SetOnDefineDataCalculo(const Value: TNotifyDataCalculoEvent);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function  AllowExecute(const NomeCalculo : String; var Mensagem : String) : Boolean;
    procedure ExecutaCalculoCorrente; virtual;
    procedure AbrirCalculoCorrente;

    function HandlesTarget(Target: TObject): Boolean; override;
    property DBIOController : TDBIOController read FDBIOController write SetDBIOController;
    property CalculoViewer : TCalculoViewer read FCalculoViewer write SetCalculoViewer;
    property Escopo : TEscopo read FEscopo write SetEscopo;
    property DataSource : TDataSource read FDataSource write SetDataSource;
    property DataField : String read FDataField write SetDataField;
    property OnBeforeCalcular : TnotifyEvent read FOnBeforeCalcular write SetOnBeforeCalcular;
    property OnDefineAlmaHumana : TNotifyEvent read FOnDefineAlmaHumana write SetOnDefineAlmaHumana;
    property OnDefineDataCalculo : TNotifyDataCalculoEvent read FOnDefineDataCalculo write SetOnDefineDataCalculo;

  end;

  TDBCalcNutNovo = class(TDBCalcNutAction)
  private
    FOnAfterNovoCalculo: TNotifyEvent;
    procedure SetOnAfterNovoCalculo(const Value: TNotifyEvent);
  protected
  public
    procedure ExecutaCalculoCorrente; override;
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property Escopo;
    property DBIOController;
    property CalculoViewer;
    property OnBeforeCalcular;
    property OnDefineAlmaHumana;
    property OnDefineDataCalculo;
    property OnAfterNovoCalculo : TNotifyEvent read FOnAfterNovoCalculo write SetOnAfterNovoCalculo;
  end;

  TDBCalcNutNovaPreparacao = class(TDBCalcNutNovo)
  private
  protected
  public
    procedure UpdateTarget(Target: TObject); override;
  published
  end;

  TDBCalcNutAbrir = class(TDBCalcNutAction)
  private
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property DBIOController;
    property CalculoViewer;
    property Escopo;
  end;

  TDBCalcNutAbrirDe = class(TDBCalcNutAction)
  private
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property DBIOController;
  end;

  TNotifyDefineKeysEvent = procedure( Sender : TObject; Dataset : TDataSet ) of Object;

  TDBCalcNutGravar = class(TDBCalcNutAction)
  private
    FOnDefineKeys: TNotifyDefineKeysEvent;
    procedure SetOnDefineKeys(const Value: TNotifyDefineKeysEvent);
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property DBIOController;
    property CalculoViewer;
    property OnDefineKeys : TNotifyDefineKeysEvent read FOnDefineKeys write SetOnDefineKeys;
  end;

  TDBCalcNutGravarComo = class(TDBCalcNutAction)
  private
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property DBIOController;
    property CalculoViewer;
  end;

  TDBCalcNutFechar = class(TDBCalcNutAction)
  private
  protected
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property Escopo;
    property DBIOController;
    property CalculoViewer;
  end;

  TDBCalcNutDefineCalculo = class(TDBCalcNutAction)
  private
    FTipoCalculo: TNomeCalculo;
    FOnAfterDefineCalculo: TNotifyEvent;
    FProcessadorAtual: TObject;
    procedure SetTipoCalculo(const Value: TNomeCalculo);
    procedure SetOnAfterDefineCalculo(const Value: TNotifyEvent);
  protected
  public
    property ProcessadorAtual : TObject read FProcessadorAtual;
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property Escopo;
    property TipoCalculo : TNomeCalculo read FTipoCalculo write SetTipoCalculo;
    property DBIOController;
    property CalculoViewer;
    property DataSource;
    property DataField;
    property OnAfterDefineCalculo : TNotifyEvent read FOnAfterDefineCalculo write SetOnAfterDefineCalculo;
  end;

  TDBCalcNutCalcular = class(TDBCalcNutAction)
  private
  protected
  public
    procedure ExecutaCalculoCorrente; override;
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property DBIOController;
    property CalculoViewer;
    property Escopo;
    property OnBeforeCalcular;
    property OnDefineAlmaHumana;
    property OnDefineDataCalculo;

  end;

var
   Novo : Boolean;

procedure Register;

implementation

procedure Register;
begin

   UnRegisterActions([ TDBCalcNutNovo, TDBCalcNutAbrir, TDBCalcNutGravar,
   TDBCalcNutFechar, TDBCalcNutGravarComo, TDBCalcNutDefineCalculo, TDBCalcNutCalcular,
   TDBCalcNutAbrirDe, TDBCalcNutNovaPreparacao ]);

   RegisterActions('DBCalcNut', [ TDBCalcNutNovo, TDBCalcNutAbrir, TDBCalcNutGravar,
   TDBCalcNutFechar, TDBCalcNutGravarComo, TDBCalcNutDefineCalculo, TDBCalcNutCalcular,
   TDBCalcNutAbrirDe, TDBCalcNutNovaPreparacao ], TDBIOController );

end;

{ TDBCalcNutAction }

function TDBCalcNutAction.HandlesTarget(Target: TObject): Boolean;
begin
  { Only handle Target if we don't already have a DBIOController assigned }
  Result := (DBIOController <> nil);
end;

procedure TDBCalcNutAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then
     exit;
  if (AComponent = DBIOController) then
     DBIOController := nil;
  if (AComponent = CalculoViewer) then
     CalculoViewer := nil;
  if (AComponent = Escopo) then
     Escopo := nil;
  if (AComponent = DataSource) then
     DataSource := nil;
end;

procedure TDBCalcNutAction.SetDBIOController(const Value: TDBIOController);
begin
  FDBIOController := Value;
end;

procedure TDBCalcNutAction.SetCalculoViewer(const Value: TCalculoViewer);
begin
  FCalculoViewer := Value;
end;

procedure TDBCalcNutAction.SetEscopo(const Value: TEscopo);
begin
  FEscopo := Value;
end;

procedure TDBCalcNutAction.SetDataSource(const Value: TDataSource);
begin
  FDataSource := Value;
end;

procedure TDBCalcNutAction.SetDataField(const Value: String);
begin
  FDataField := Value;
end;

procedure TDBCalcNutAction.ExecutaCalculoCorrente;
var
   Msg : String;
   mdData : TMedida;
   DataTemp : String;
   Cancelou : Boolean;
begin

   // Permite executar CalculoCorrente?
   if not AllowExecute( FCalculoViewer.CalculoCorrente, Msg ) then
      ShowMessage( Msg )
   else
      begin
         if not(FCalculoViewer.CalculoCorrente = 'Preparacao') and
            not(FCalculoViewer.CalculoCorrente = 'AtividadeFisica') and Novo then //*
            begin               // Faz backup antes de mais nada
               FDBIOController.Calculo.BackupMemoria;
               // Cria variaveis de escopo, se necessario
               FDBIOController.DefineVariaveisEscopo( FCalculoViewer.CalculoCorrente );
               // Seta data da visita
               if Assigned( FOnDefineDataCalculo ) then
                 begin
                   Cancelou := False;
                   FOnDefineDataCalculo( self, DataTemp, Cancelou );
                   if Cancelou then
                      exit;
                 end
               else
                   DataTemp := DateToStr( Date );

               if DBIOController.Calculo.Memoria.Acha( 'mdDataCalc', TObject( mdData ) ) then
                  mdData.ValorNumerico := DataTemp
               else
                  begin
                      ShowMessage( 'A data do cálculo não pode ser alterada!' );
                      exit;
                  end;

              // Passa os dados do cadastro para a alma
              if Assigned( FOnDefineAlmaHumana ) then
                 FOnDefineAlmaHumana(self);

               // Pede escopo
               if Escopo.Pegar( True ) then
                   begin
                      // Cria variaveis do calculo, se necessario
                      FDBIOController.DefineVariaveisCalculo( FCalculoViewer.CalculoCorrente );
                      // Antes de calcular
                      if Assigned(FOnBeforeCalcular) then
                         FOnBeforeCalcular( Self );
                      // Calcular
                      FCalculoViewer.Calculando:=True;
                      FCalculoViewer.FechaPreview;
                   end
               else
                  // Restaurar memoria
                  FDBIOController.Calculo.RestoreMemoria;
            end
         else
            begin
               // Faz backup
               FDBIOController.Calculo.BackupMemoria;
               // Cria variaveis do calculo, se necessario
               if Novo then
                  FDBIOController.DefineVariaveisCalculo( FCalculoViewer.CalculoCorrente );
               // Antes de calcular
               if Assigned(FOnBeforeCalcular) then
                  FOnBeforeCalcular( Self );
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

{

var
   Msg : String;
begin
   // Permite executar CalculoCorrente?
   if not AllowExecute( FCalculoViewer.CalculoCorrente, Msg ) then
      ShowMessage( Msg )
   else
      begin
         if assigned(FOnBeforeCalcular) then
            FOnBeforeCalcular( Self );
         if not(FCalculoViewer.CalculoCorrente = 'Preparacao') then
            begin
               if Escopo.Pegar( True ) then
                   begin
                      FCalculoViewer.Calculando:=True;
                      FCalculoViewer.FechaPreview;
                   end;
            end
         else
            begin
               FCalculoViewer.Calculando:=True;
               FCalculoViewer.FechaPreview;
            end;
      end;
end;}

procedure TDBCalcNutAction.AbrirCalculoCorrente;
begin
   if Assigned( FDBIOController.DataSource ) and
      ( FDBIOController.DataField <> '' ) then
   begin
      if FDBIOController.Fechar then
         begin
            FDBIOController.Calculo.Memoria.NomeArquivo := 'sasasadad';
            if not FDBIOController.DataSource.DataSet.IsEmpty and
               FDBIOController.Abrir then
               begin
                  if not(FCalculoViewer.CalculoCorrente = 'Preparacao') then
                     FEscopo.PreparaCorpoHumano;
                  FCalculoViewer.ShowPreview
               end
            else
               FCalculoViewer.ShowPreview
         end;
   end;
end;

//==============================================================================

procedure TDBCalcNutAction.SetOnBeforeCalcular(const Value: TnotifyEvent);
begin
  FOnBeforeCalcular := Value;
end;

function TDBCalcNutAction.AllowExecute(const NomeCalculo: String;
  var Mensagem: String): Boolean;
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
   if FDBIOController.Calculo.Memoria.Acha('mdDiretorio', TObject( mdDiretorio ) ) then
      Diretorio.CommaText := mdDiretorio.ValorNumerico;

   // vazio significa que o calculo não existe
   if (NomeCalculo = '') then
      Mensagem := 'Cálculo não implementado!'
   // se uma recomendação nutricional calculada foi feita para um
   // plano alimentar, esta só pode ser modificada pelo mesmo
   else if (NomeCalculo = 'RecCalorica') and
           FDBIOController.Calculo.Memoria.Acha('mdSelRecCal', TObject( mdSelRC ) ) and
           ( mdSelRc.AsFloat <> 0 ) then  // 0 - Nenhuma
      Mensagem := 'A Recomendação de energia só pode ser calculada pelo Plano Alimentar, pois compartilha os mesmos resultados.'
   // uma preparação não pode ser feita se a memoria já tiver um cálculo que usa escopo
   else if (NomeCalculo = 'Preparacao') and
           FDBIOController.Calculo.Memoria.Acha('mdEscopoCriado', TObject( mdEscopoCriado ) ) and
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

procedure TDBCalcNutAction.SetOnDefineAlmaHumana(
  const Value: TNotifyEvent);
begin
  FOnDefineAlmaHumana := Value;
end;

procedure TDBCalcNutAction.SetOnDefineDataCalculo(
  const Value: TNotifyDataCalculoEvent);
begin
  FOnDefineDataCalculo := Value;
end;

{ TDBCalcNutNovo }

procedure TDBCalcNutNovo.ExecutaCalculoCorrente;
begin
inherited;
end;

procedure TDBCalcNutNovo.ExecuteTarget(Target: TObject);
//#var
//#   mdData : TMedida;
//#   DataTemp : String;
//#   Cancelou : Boolean;
begin

   Novo := True;

   // Pega Data de Calculo
{#   if Assigned( FOnDefineDataCalculo ) then
      begin
         Cancelou := False;
         FOnDefineDataCalculo( self, DataTemp, Cancelou );
         if Cancelou then
            exit;
      end
   else
      DataTemp := DateToStr( Date );
}
   // inicializa a memoria com os defaults
   if DBIOController.Fechar then
   begin
      DBIOController.Calculo.Memoria.NomeArquivo := 'sasasadad';
      DBIOController.Novo;
   end;

   // seta descricao calculo readonly
//*   if Assigned( FOnAfterNovoCalculo ) then
//*      FOnAfterNovoCalculo( self );

   // atribui F1.mdData.Text := mdDataCalc
{   if DBIOController.Calculo.Memoria.Acha( 'mdDataCalc', TObject( mdData ) ) then
      mdData.ValorNumerico := DataTemp
   else
      begin
         ShowMessage( 'A data do cálculo não pode ser alterada!' );
         exit;
      end; }

   // Passa os dados do cadastro para a alma
{#   if Assigned( FOnDefineAlmaHumana ) then
      FOnDefineAlmaHumana(self);
}
   // Chama escopo e executa calculo modoorg
   ExecutaCalculoCorrente;

   // seta descricao calculo readonly
   if Assigned( FOnAfterNovoCalculo ) then
      FOnAfterNovoCalculo( self );

end;

procedure TDBCalcNutNovo.SetOnAfterNovoCalculo(
  const Value: TNotifyEvent);
begin
  FOnAfterNovoCalculo := Value;
end;

procedure TDBCalcNutNovo.UpdateTarget(Target: TObject);
begin
   if Assigned( CalculoViewer ) then
   Enabled := not (CalculoViewer.Calculando) //and ( DBIOController.Calculo.Memoria.Empty );
end;

{ TDBCalcNutAbrir }

procedure TDBCalcNutAbrir.ExecuteTarget(Target: TObject);
begin
   AbrirCalculoCorrente;
end;

procedure TDBCalcNutAbrir.UpdateTarget(Target: TObject);
begin
   if Assigned( CalculoViewer ) then
   Enabled := not ( CalculoViewer.Calculando );
end;

{ TDBCalcNutGravar }

procedure TDBCalcNutGravar.ExecuteTarget(Target: TObject);
begin
   if Novo then
      begin
          DBIOController.DataSource.DataSet.Append;
          if Assigned( FOnDefineKeys ) then
             FOnDefineKeys( self, DBIOController.DataSource.DataSet );
      end
   else
      DBIOController.DataSource.DataSet.Edit;
   DBIOController.Gravar;
   DBIOController.DataSource.DataSet.Post;
   Novo := False;
end;

procedure TDBCalcNutGravar.SetOnDefineKeys(
  const Value: TNotifyDefineKeysEvent);
begin
  FOnDefineKeys := Value;
end;

procedure TDBCalcNutGravar.UpdateTarget(Target: TObject);
begin
   if Assigned( CalculoViewer ) then
   Enabled := not ( CalculoViewer.Calculando ) and ( DBIOController.Calculo.Memoria.Modified > 0 );
end;

{ TDBCalcNutGravarComo }

procedure TDBCalcNutGravarComo.ExecuteTarget(Target: TObject);
begin
   DBIOController.GravarComo;
end;

procedure TDBCalcNutGravarComo.UpdateTarget(Target: TObject);
begin
   if Assigned( CalculoViewer ) then
   Enabled := not ( CalculoViewer.Calculando ) and not ( DBIOController.Calculo.Memoria.Empty );
end;

{ TDBCalcNutFechar }

procedure TDBCalcNutFechar.ExecuteTarget(Target: TObject);
begin
   if MessageDlg('Deseja realmente excluir os dados ? ' ,
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
      DBIOController.DataSource.DataSet.Delete;
      AbrirCalculoCorrente;
   end;
end;

procedure TDBCalcNutFechar.UpdateTarget(Target: TObject);
begin
   if Assigned( CalculoViewer ) then
   Enabled := not ( CalculoViewer.Calculando ) and  not ( DBIOController.Calculo.Memoria.Empty );
end;

{ TDBCalcNutDefineCalculo }

procedure TDBCalcNutDefineCalculo.ExecuteTarget(Target: TObject);
begin
   if Assigned( CalculoViewer ) then
      CalculoViewer.DefineCalculo(FTipoCalculo, False)
   else
      exit;
   DBIOController.DataSource := DataSource;
   DBIOController.DataField := DataField;
   FProcessadorAtual := CalculoViewer.AntropButtons[FTipoCalculo].Processador;
   if Assigned( FOnAfterDefineCalculo ) then
      FOnAfterDefineCalculo( self );

   AbrirCalculoCorrente;
end;

procedure TDBCalcNutDefineCalculo.SetOnAfterDefineCalculo(
  const Value: TNotifyEvent);
begin
  FOnAfterDefineCalculo := Value;
end;

procedure TDBCalcNutDefineCalculo.SetTipoCalculo(const Value: TNomeCalculo);
begin
  FTipoCalculo := Value;
end;

procedure TDBCalcNutDefineCalculo.UpdateTarget(Target: TObject);
begin
//   if Assigned( CalculoViewer ) then
   Enabled := True; //not ( CalculoViewer.Calculando ) and not( DBIOController.Calculo.Memoria.Empty );
end;

{ TDBCalcNutCalcular }

procedure TDBCalcNutCalcular.ExecutaCalculoCorrente;
begin
   inherited;
end;

procedure TDBCalcNutCalcular.ExecuteTarget(Target: TObject);
begin
   Novo := False;
   ExecutaCalculoCorrente;
end;

procedure TDBCalcNutCalcular.UpdateTarget(Target: TObject);
begin
   if Assigned( CalculoViewer ) then
   Enabled := not ( CalculoViewer.Calculando ) and not( DBIOController.Calculo.Memoria.Empty );
end;

{ TDBCalcNutAbrirDe }

procedure TDBCalcNutAbrirDe.ExecuteTarget(Target: TObject);
begin
   DBIOController.AbrirDe( '' );
   Novo := True;
end;

procedure TDBCalcNutAbrirDe.UpdateTarget(Target: TObject);
begin
   // precisa fazer a verificação se o arquivo .NUT é compatível com o
   // indivíduo corrente.
   Enabled := False;
end;

{ TDBCalcNutNovaPreparacao }

procedure TDBCalcNutNovaPreparacao.UpdateTarget(Target: TObject);
begin
   if Assigned( CalculoViewer ) then
      Enabled := not (CalculoViewer.Calculando) and ( DBIOController.Calculo.Memoria.Empty );
end;

end.

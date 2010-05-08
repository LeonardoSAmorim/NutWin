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




unit IOController;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Calculo, CalcAli, measurement, Procedimento, Memoria;

type
  TIOController = class(TComponent)
  private
    FNovoArquivo : Boolean;
    FOpenDialog: TOpenDialog;
    FSaveDialog: TSaveDialog;
    FCalculo: TCalculo;
    FCalculoDieta: TCalculodieta;
    FCalculoInquerito: TCalculoInquerito;
    FCalculoPreparacao: TCalculoPreparacao;
    FOnDepoisDeFechar: TNotifyEvent;
    FOnDepoisDeAbrir: TNotifyEvent;
    FOnDepoisDeNovo: TNotifyEvent;
    FOnDepoisDeGravar: TNotifyEvent;
    { Private methods of IOController }
    { Method to set variable and property values and create objects }
    procedure AutoInitialize;
    { Method to free any objects created by AutoInitialize }
    procedure AutoDestroy;
    procedure SetOpenDialog(const Value: TOpenDialog);
    procedure SetSaveDialog(const Value: TSaveDialog);
    procedure SetCalculo(const Value: TCalculo);
    procedure SetCalculoDieta(const Value: TCalculodieta);
    procedure SetCalculoInquerito(const Value: TCalculoInquerito);
    procedure SetCalculoPreparacao(const Value: TCalculoPreparacao);
    function MsgSalvarAo( Titulo, Arquivo : String ) : Integer;
    procedure SetOnDepoisDeAbrir(const Value: TNotifyEvent);
    procedure SetOnDepoisDeFechar(const Value: TNotifyEvent);
    procedure SetOnDepoisDeNovo(const Value: TNotifyEvent);
    procedure SetOnDepoisDeGravar(const Value: TNotifyEvent);
  protected
    { Protected declarations }
    procedure AbreCoProcessadores;
    procedure FechaCoProcessadores;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure Loaded; override;

    procedure Novo; virtual;
    procedure Atualizado; virtual;
    function Abrir( StartApp : Boolean = False ) : Boolean; virtual;
    function AbrirDe( Arquivo : String ) : Boolean; virtual;
    function Gravar : Boolean; virtual;
    function GravarComo : Boolean; virtual;
    function Fechar : Boolean; virtual;
    procedure DefineVariaveisEscopo( const NomeCalculo : String ); virtual;
    procedure DefineVariaveisCalculo( const NomeCalculo : String ); virtual;

  published
    { Published declarations }
    property Calculo : TCalculo read FCalculo write SetCalculo;
    property CalculoDieta : TCalculodieta read FCalculoDieta write SetCalculoDieta;
    property CalculoInquerito : TCalculoInquerito read FCalculoInquerito write SetCalculoInquerito;
    property CalculoPreparacao : TCalculoPreparacao read FCalculoPreparacao write SetCalculoPreparacao;
    property OpenDialog : TOpenDialog read FOpenDialog write SetOpenDialog;
    property SaveDialog : TSaveDialog read FSaveDialog write SetSaveDialog;
    property OnDepoisDeAbrir : TNotifyEvent read FOnDepoisDeAbrir write SetOnDepoisDeAbrir;
    property OnDepoisDeFechar : TNotifyEvent read FOnDepoisDeFechar write SetOnDepoisDeFechar;
    property OnDepoisDeNovo : TNotifyEvent read FOnDepoisDeNovo write SetOnDepoisDeNovo;
    property OnDepoisDeGravar : TNotifyEvent read FOnDepoisDeGravar write SetOnDepoisDeGravar;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Calculadora', [TIOController]);
end;

{ TIOController }

function TIOController.Abrir(StartApp: Boolean) : Boolean;
begin
   Result := False;
   if not Assigned( FOpenDialog ) then
      begin
         Result := False;
         exit;
      end;
   // Abrir por paramentro de linha de comando
   if StartApp then
      begin
         if not ( ParamCount > 0 ) then
            begin
               Result := False;
               exit;
            end
         else if not FileExists(ParamStr(1)) then
            begin
               ShowMessage( 'O arquivo ' + ParamStr(1) + ' não existe!' );
               Result := False;
               exit;
            end
         else
            begin
               Result := AbrirDe( ParamStr(1) );
               if Assigned( FOnDepoisDeAbrir ) and Result then
                  FOnDepoisDeAbrir( Self );
            end;
      end
   else
      begin
        // Escolhe um arquivo valido
        if FOpenDialog.Execute then
           if FOpenDialog.Files.Count > 0 then
              begin
                 Result := AbrirDe( FOpenDialog.Files.Strings[0] );
                 if Assigned( FOnDepoisDeAbrir ) and Result then
                    FOnDepoisDeAbrir( Self );
              end;
      end;
   // Aqui inicia a edicao do calculo aberto
   FCalculo.Memoria.Modified := 0;

end;

function TIOController.AbrirDe(Arquivo: String) : Boolean;
begin

   Result := False;
   if not Fechar then
      exit;

   with FCalculo do
   begin
      Memoria.NomeArquivo := Arquivo;
      if not Memoria.Abrir then
         begin
            ShowMessage( 'O arquivo ' + Arquivo + ' não é válido!' );
            Result := False;
            exit;
         end;
      AbreCoProcessadores;
   end;
   Result := True;
   // Aqui inicia a edicao do calculo aberto
   FCalculo.Memoria.Modified := 0;
end;

procedure TIOController.AbreCoProcessadores;
var
   mdTmp : TObject;
begin
   with FCalculo do
   begin
      // Abrindo/inicializando os demais processadores
      if Memoria.Acha( FCalculoDieta.NomeCalculo, mdTmp ) and Assigned( FCalculoDieta ) then
         begin
            FCalculoDieta.Abrir( True );
            // liga a lista de recomendação de energia com os nutrientes da
            // dieta para calcular o saldo
            FCalculoDieta.SetaRecNut;
         end;

//#      else
//#         FCalculoDieta.Novo( True );
      if Memoria.Acha( FCalculoInquerito.NomeCalculo, mdTmp ) and Assigned( FCalculoInquerito ) then
         begin
            FCalculoInquerito.Abrir( True );
//#      else
//#         FCalculoInquerito.Novo( True );
            FCalculoInquerito.SetaRecNut;
         end;
      if Memoria.Acha( FCalculoPreparacao.NomeCalculo, mdTmp ) and Assigned( FCalculoPreparacao ) then
         FCalculoPreparacao.Abrir( True );
//#      else
//#         FCalculoPreparacao.Novo( True );
      FNovoArquivo := False;
   end;
end;

procedure TIOController.Atualizado;
begin
   FCalculo.Memoria.Modified := 0;
   FNovoArquivo := False;
end;

procedure TIOController.AutoDestroy;
begin

end;

procedure TIOController.AutoInitialize;
begin

end;

constructor TIOController.Create(AOwner: TComponent);
begin
     { Call the Create method of the parent class }
     inherited Create(AOwner);

     { AutoInitialize sets the initial values of variables and      }
     { properties; also, it creates objects for properties of       }
     { standard Delphi object types (e.g., TFont, TTimer,           }
     { TPicture) and for any variables marked as objects.           }
     { AutoInitialize method is generated by Component Create.      }
     AutoInitialize;

     { Code to perform other tasks when the component is created }
end;

destructor TIOController.Destroy;
begin
     { AutoDestroy, which is generated by Component Create, frees any   }
     { objects created by AutoInitialize.                               }
     AutoDestroy;

     { Here, free any other dynamic objects that the component methods  }
     { created but have not yet freed.  Also perform any other clean-up }
     { operations needed before the component is destroyed.             }

     { Last, free the component by calling the Destroy method of the    }
     { parent class.                                                    }
     inherited Destroy;
end;

function TIOController.Fechar: Boolean;
var
   idResp : Integer;
begin
   Result := True;
   with FCalculo do
   begin
      if Memoria.Modified > 0 then
         begin
            idResp := MsgSalvarAo( 'Fechar', Memoria.NomeArquivo );
            case idResp of
               IDYES : begin
                          Result := Gravar;
                          if not Result then
                             exit;
                       end;
               IDNO : Result := True;
               IDCANCEL : begin
                             Result := False;
                             exit;
                          end;
            end;
         end;
         FechaCoProcessadores;
         Memoria.Limpar;
   end;

   if Assigned( FOnDepoisDeFechar ) and Result then
      FOnDepoisDeFechar( Self );

end;

procedure TIOController.FechaCoProcessadores;
begin
         // Faz o servico de fechar nos processadores auxiliares
         FCalculoDieta.Fechar;
//            ShowMessage( 'Não consegui fechar CalcDieta' );
         FCalculoInquerito.Fechar;
//            ShowMessage( 'Não consegui fechar CalcInquerito' );
         FCalculoPreparacao.Fechar;
//            ShowMessage( 'Não consegui fechar CalcPreparacao' );
end;

function TIOController.Gravar: Boolean;
begin
   Result := True;
   with FCalculo.Memoria do
   begin
      if not FNovoArquivo then
         Salvar
      else
         Result := GravarComo;
   end;
   if Result then
      begin
         if Assigned( FOnDepoisDeGravar ) then
            FOnDepoisDeGravar( Self );
         Atualizado;
      end;
end;

function TIOController.GravarComo: Boolean;
var
   mdTemp : TMedida;
begin
   with FCalculo.Memoria do
   begin
      if FNovoArquivo then
      begin
         if Acha( 'mdNomeIndividuo', TObject( mdTemp ) ) then
            FSaveDialog.FileName := mdTemp.ValorNumerico + '.' + FSaveDialog.DefaultExt
         else
            FSaveDialog.FileName := 'Nome não informado.NUT';
      end
      else
         FSaveDialog.FileName := NomeArquivo;
      Result := FSaveDialog.Execute;
      if Result then
         begin
            NomeArquivo := FSaveDialog.FileName;
            Salvar;
            Atualizado;
         end;
   end;
end;

procedure TIOController.Loaded;
begin
     inherited Loaded;

     { Perform any component setup that depends on the property
       values having been set }
end;

function TIOController.MsgSalvarAo(Titulo, Arquivo: String): Integer;
begin
   if Titulo = '' then Titulo := 'Cálculo';
   if Arquivo = '' then Arquivo := 'Nome não informado';
   Result := Application.MessageBox( PChar( 'Deseja salvar as alterações em ' + Arquivo + '?' ),
             PChar(Titulo ), MB_YESNOCANCEL );
end;

procedure TIOController.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FOpenDialog then
        FOpenDialog := nil;
     if AComponent = FSaveDialog then
        FSaveDialog := nil;
     if AComponent = FCalculo then
        FCalculo := nil;
     if AComponent = FCalculoDieta then
        FCalculoDieta := nil;
     if AComponent = FCalculoInquerito then
        FCalculoInquerito := nil;
     if AComponent = FCalculoPreparacao then
        FCalculoPreparacao := nil;
end;

procedure TIOController.Novo;
//#var
//#   mdMed : TMedida;
begin

   with FCalculo do
   begin
      Memoria.Limpar;
      // Preenche com variaveis de escopo, constantes, etc
      Procedimentos.Clear;
      Procedimentos.Add( 'prDiretorio' );
//#      Procedimentos.Add( 'prEscopo' );
//#      Procedimentos.Add( 'prConstantes' );
      CriaMedidas;
      // Cria Procedimentos de Antropometria
//#      CriaListaProc( Memoria, 'cxcaAntrop', 'caAntrop', psNone);
      // Cria Procedimentos de Recomendação Calórica
//#      CriaListaProc( Memoria, 'cxcaRecCal', 'caRecCal', psNone);
//#      SetEstadoProc( Memoria, 'cxcaRecCal', 'prRCFAODia', psChecked );
      // Seta a data do calculo
//#      if Memoria.Acha( 'mdDataCalc', TObject( mdMed )) then
//#         mdMed.ValorNumerico := DateToStr( Date );
      // Inicializa outros processadores
//#      FCalculoDieta.Novo( True );
//#      FCalculoInquerito.Novo( True );
//#      FCalculoPreparacao.Novo( True );
      FNovoArquivo := True;
      // Aqui inicia a edicao do novo calculo
      Memoria.Modified := 0;
   end;

   if Assigned( FOnDepoisDeNovo ) then
      FOnDepoisDeNovo( Self );

end;

procedure TIOController.SetCalculo(const Value: TCalculo);
begin
  FCalculo := Value;
end;

procedure TIOController.SetCalculoDieta(const Value: TCalculodieta);
begin
  FCalculoDieta := Value;
end;

procedure TIOController.SetCalculoInquerito(
  const Value: TCalculoInquerito);
begin
  FCalculoInquerito := Value;
end;

procedure TIOController.SetCalculoPreparacao(
  const Value: TCalculoPreparacao);
begin
  FCalculoPreparacao := Value;
end;

procedure TIOController.SetOpenDialog(const Value: TOpenDialog);
begin
  FOpenDialog := Value;
end;

procedure TIOController.SetSaveDialog(const Value: TSaveDialog);
begin
  FSaveDialog := Value;
end;

procedure TIOController.DefineVariaveisCalculo(const NomeCalculo: String);
var
   cxRecNut : TCaixa;
   mdDiretorio : TMedidaOrdinal;
   Diretorio : TStringList;
begin

   // Cálculo não implementado
   if NomeCalculo = '' then
      exit;


   with FCalculo do
   begin

      // carrega lista de cálculos já efetuados (mdDiretorio)
      Diretorio := TStringList.Create;
      if Calculo.Memoria.Acha('mdDiretorio', TObject( mdDiretorio ) ) then
         Diretorio.CommaText := mdDiretorio.ValorNumerico;
      // calculo já existe
      if ( Diretorio.IndexOf( NomeCalculo ) >= 0 ) then
         begin
            Diretorio.Free;
            exit;
         end;
      Diretorio.Free;

      // Antropometria
      if NomeCalculo = 'Antropometria' then
         begin
            // Cria Procedimentos de Antropometria
            CriaListaProc( Memoria, 'cxcaAntrop', 'caAntrop', psNone);
            // Valida calculos
            ValidaCalculo( 'vlcaAntrop', 'cxcaAntrop' );
            // Filtra Cálculos conforme configuração
            FiltraCalculo( Configuracao, 'cxcaAntrop' );
            // Torna o procedimento ECCP "Escondido", pois ele é usado só aqui
            SetEstadoProc( FCalculo.Memoria, 'cxcaAntrop', 'prECCP', psHidden );
         end
      // Recomendacao de energia ou plano alimentar
      else if (
              ( NomeCalculo = 'RecCalorica'    ) or
              ( NomeCalculo = 'PlanoAlimentar' ) or
              ( NomeCalculo = 'Inquerito' )
              ) and
              (
                not( Memoria.Acha( 'cxRecNut', TObject( cxRecNut ) ) ) or
                not( Memoria.Acha( 'cxRDA',    TObject( cxRecNut ) ) )
              ) then
         begin
            // Cria Procedimentos de Recomendação Calórica
            CriaListaProc( Memoria, 'cxcaRecCal', 'caRecCal', psNone);

            // Cria procedimento da RDA só para inquérito
            if ( NomeCalculo = 'Inquerito' ) or ( NomeCalculo = 'PlanoAlimentar' ) then
            begin
               // Criacao das medidas da lista de calculos de saida
               Procedimentos.Clear;
               Procedimentos.Add( 'prRCRDA' );
               CriaMedidas;
            end;

            // Valida calculos
{            SetEstadoProc( Memoria, 'cxcaRecCal', 'prRCFAODia', psChecked );
            SetEstadoProc( Memoria, 'cxcaRecCal', 'prRCPac', psChecked );
            SetEstadoProc( Memoria, 'cxcaRecCal', 'prRCRDA', psChecked );}
            ValidaCalculo( 'vlcaRecCal', 'cxcaRecCal' );
            FCalculoInquerito.SetaRecNut;
            FCalculoDieta.SetaRecNut;
         end;

      // Inicializa outros processadores
      if NomeCalculo = 'PlanoAlimentar' then
         FCalculoDieta.Novo( True )
      else if NomeCalculo = 'Inquerito' then
         FCalculoInquerito.Novo( True )
      else if NomeCalculo = 'Preparacao' then
         FCalculoPreparacao.Novo( True )
   end;
end;

procedure TIOController.DefineVariaveisEscopo( const NomeCalculo : String );
var
   mdMed : TMedida;
begin
   with FCalculo do
   begin
      // Cria escopo se não for preparacao ou Atividade Fisica e se ainda não foi criado
      if ( NomeCalculo <> 'Preparacao' ) and
         ( NomeCalculo <> 'AtividadeFisica' ) and
         Memoria.Acha( 'mdEscopoCriado', TObject( mdMed ) ) and
         ( mdMed.AsFloat = 0 ) then  //*
         begin
            Procedimentos.Clear;
            Procedimentos.Add( 'prEscopo' );
            Procedimentos.Add( 'prConstantes' );
            CriaMedidas;
            // Seta a data do calculo
            if Memoria.Acha( 'mdDataCalc', TObject( mdMed )) then
            begin
               mdMed.ValorNumerico := DateToStr( Date );
               mdMed.Valid := True;
            end;
         end;
   end;
end;

procedure TIOController.SetOnDepoisDeAbrir(const Value: TNotifyEvent);
begin
  FOnDepoisDeAbrir := Value;
end;

procedure TIOController.SetOnDepoisDeFechar(const Value: TNotifyEvent);
begin
  FOnDepoisDeFechar := Value;
end;

procedure TIOController.SetOnDepoisDeNovo(const Value: TNotifyEvent);
begin
  FOnDepoisDeNovo := Value;
end;

procedure TIOController.SetOnDepoisDeGravar(const Value: TNotifyEvent);
begin
  FOnDepoisDeGravar := Value;
end;

end.

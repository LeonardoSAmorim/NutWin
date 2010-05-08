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




unit CalculoTextViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, CalculoViewer, Measurement, Calculo, stdctrls, procedimento, memoria,
  ItemAlimentar, comctrls, NutCnst, RegConst2, RegEdit;

type

  TMedidaAlinhada = ( maNormal, maEsquerda, maCentraliza, maDireita, maQuebra );

  TFontStyles = set of TFontStyle;

  TCalculoTextViewer = class(TCalculoViewer)
  private
    FMedidaAlinhada: TMedidaAlinhada;
    FVerificaPrintable: Boolean;
    FVisor: TCustomMemo;
    FMedidas: TStringList;
    FMedidaEstilo : TStringList;
    FResultEstilo : TStringList;
    FProcedimentos: TStringList;
    FResultados: TStringList;
    FNumMedidas : Integer;
    FNumResultados : Integer;
    FOnAfterPreview: TNotifyEvent;
    procedure DadosIndividuo;
//    procedure DefAtributosVisor( Cor : TColor; Estilo : TFontStyles; Tamanho : Integer );
//    procedure DefParagrafoVisor( Alinhamento : TAlignment; IdentacaoEsquerda : Integer );
    procedure SetMedidaAlinhada(const Value: TMedidaAlinhada);
    procedure SetVerificaPrintable(const Value: Boolean);
    procedure SetVisor(const Value: TCustomMemo);

    function RightSpaces( S : String; L : Integer ) : String;
    function LeftSpaces( S : String; L : Integer ) : String;
    function MedidaText( Medida : TMedida ) : String;

    function ItemsAlimentares( NomeCaixa : String ) : Boolean;
    procedure SetOnAfterPreview(const Value: TNotifyEvent);
    { Private declarations }
  protected
    { Protected declarations }
    function Antropometria : Boolean;
    function RecCalorica : Boolean;
    function Inquerito : Boolean;
    function PlanoAlimentar : Boolean;
    function Preparacao : Boolean;
    function AtividadeFisica : Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure Loaded; override;
    function Execute : Boolean;
    procedure ShowPreview; override;
  published
    { Published declarations }
    property Visor : TCustomMemo read FVisor write SetVisor;
    property VerificaPrintable : Boolean read FVerificaPrintable write SetVerificaPrintable;
    property MedidaAlinhada : TMedidaAlinhada read FMedidaAlinhada write SetMedidaAlinhada;
    property OnBeforePreview;
    property OnAfterPreview : TNotifyEvent read FOnAfterPreview write SetOnAfterPreview;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Calculadora', [TCalculoTextViewer]);
end;

{ TCalculoTextViewer }

function TCalculoTextViewer.RightSpaces( S : String; L : Integer ) : String;
var I : Integer;
begin
      Result := S;
      for I := 0 to L do
          Result := Result + ' ';
      Result := Copy(Result, 1, L );
end;

function TCalculoTextViewer.LeftSpaces( S : String; L : Integer ) : String;
var I : Integer;
begin
      Result := S;
      for I := 0 to ( L - Length(S) ) do
          Result := ' ' + Result ;
end;

function TCalculoTextViewer.MedidaText( Medida : TMedida ) : String;
begin
      with Medida do
      case FMedidaAlinhada of
           maNormal : Result := Descricao + ' : ' + ValorNumericoFormatado + ' ' + UnidadeFormatada;
           maDireita : Result := RightSpaces( Descricao, 50 ) + ' : ' + ValorNumericoFormatado + ' ' + UnidadeFormatada;
           maEsquerda : Result := LeftSpaces( Descricao, 50 ) + ' : ' + ValorNumericoFormatado + ' ' + UnidadeFormatada;
           maQuebra : Result := Descricao + #13#10 + '     = ' + ValorNumericoFormatado + ' ' + UnidadeFormatada;
      end;
end;

function TCalculoTextViewer.Execute : Boolean;
begin
   if CalculoCorrente = 'Antropometria' then
      begin
         Result := Antropometria;
      end
   else if CalculoCorrente = 'RecCalorica' then
      begin
         Result := RecCalorica;
      end
   else if CalculoCorrente = 'Preparacao' then
      begin
         Result := Preparacao;
      end
   else if CalculoCorrente = 'Inquerito' then
      begin
         Result := Inquerito;
      end
   else if CalculoCorrente = 'PlanoAlimentar' then
      begin
         Result := PlanoAlimentar;
      end
   else if CalculoCorrente = 'AtividadeFisica' then
      begin
         Result := AtividadeFisica;
      end
   else
      begin
//         FVisor.Clear;
         Result := False;
      end;

end;

constructor TCalculoTextViewer.Create(AOwner: TComponent);
begin
  inherited;
  FMedidas := TStringList.Create;
  FProcedimentos := TStringList.Create;
  FResultados := TStringList.Create;
  FMedidaEstilo := TStringList.Create;
  FResultEstilo := TStringList.Create;
end;

destructor TCalculoTextViewer.Destroy;
begin
  FMedidaEstilo.Free;
  FResultEstilo.Free;
  FMedidas.Free;
  FProcedimentos.Free;
  FResultados.Free;
  inherited;
end;

function TCalculoTextViewer.Antropometria: Boolean;

   function PegaMedidasAntropometricas( var MoreData : Boolean ) : String;
   var
      Faz : Boolean;
   begin
      Result := '';
     if FVerificaPrintable then
        Faz := TMedida( FMedidas.Objects[FNumMedidas] ).Printable
     else
        Faz := True;
     if FNumMedidas < FMedidas.Count then
     begin
        if Faz then
        begin
           if Assigned(FMedidas.Objects[FNumMedidas]) then
              Result := '   ' + MedidaText( TMedida( FMedidas.Objects[FNumMedidas] ) )
           else
              Result := '   ' + FMedidas.Strings[FNumMedidas];
        end;
        Inc(FNumMedidas);
        MoreData := True;
     end
     else
        MoreData := False;

   end;

   function PegaResultadosAntropometricos( var MoreData: Boolean) : String;
   var
      Faz : Boolean;
   begin
      Result := '';
     if FVerificaPrintable then
        Faz := TMedida( FMedidas.Objects[FNumMedidas] ).Printable
     else
        Faz := True;
     if FNumResultados < FResultados.Count then
     begin
        if Faz then
        begin
           if Assigned(FResultados.Objects[FNumResultados]) then
              Result := '   ' + MedidaText( TMedida( FResultados.Objects[FNumResultados] ) )
           else
              Result := '   ' + FResultados.Strings[FNumResultados];
        end;
        Inc(FNumResultados);
        MoreData := True;
     end
     else
        MoreData := False;

   end;

var
   MoreData : Boolean;
   Valor : String;
begin
  Result := True;
  if not Assigned( FVisor ) then
     begin
        Result := False;
        exit;
     end;
  FVisor.Clear;
  Calculo.EncheListas( 'cxcaAntrop', FProcedimentos, FMedidas, FResultados );
  // Pega o mesmo da personalização
  if CarregaChaveString( CFGROOT, CFGPath, CFGPersonaFileName, Valor ) then
  begin
     // Formata listas de medidas conforme listas de estilos
     if FileExists( Valor + '\' + 'MedAntrop.sto' ) then
        FMedidaEstilo.LoadFromFile( Valor + '\' + 'MedAntrop.sto' );
     if FileExists( Valor + '\' + 'ResAntrop.sto' ) then
        FResultEstilo.LoadFromFile( Valor + '\' + 'ResAntrop.sto' );
  end;
  FormataListaMedidas( FMedidas, FMedidaEstilo );
  FormataListaMedidas( FResultados, FResultEstilo );
  // Inicializa variáveis
  FNumMedidas := 0;
  FNumResultados := 0;
  if FMedidas.Count > 0 then
  begin
     DadosIndividuo;
     FVisor.Lines.Add( 'Medidas' );
     MoreData := True;
     while MoreData do
        FVisor.Lines.Add( PegaMedidasAntropometricas( MoreData ) );
     if FResultados.Count > 0 then
        FVisor.Lines.Add( 'Resultados' );
     MoreData := True;
     while MoreData do
        FVisor.Lines.Add( PegaResultadosAntropometricos( MoreData ) );
  end
  else
  begin
    FVisor.Clear;
{    FVisor.Lines.Add( 'CÁLCULO ANTROPOMÉTRICO SELECIONADO!' );
    FVisor.Lines.Add( '' );
    FVisor.Lines.Add( 'PRESSIONE [CALCULAR] PARA FAZER O CÁLCULO.' ); }
  end;
end;

procedure TCalculoTextViewer.Loaded;
begin
  inherited;
end;

procedure TCalculoTextViewer.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     if AComponent = FVisor then
        FVisor := nil;
end;

procedure TCalculoTextViewer.SetMedidaAlinhada(const Value: TMedidaAlinhada);
begin
  FMedidaAlinhada := Value;
end;

procedure TCalculoTextViewer.SetVerificaPrintable(const Value: Boolean);
begin
  FVerificaPrintable := Value;
end;

procedure TCalculoTextViewer.SetVisor(const Value: TCustomMemo);
begin
  FVisor := Value;
end;

procedure TCalculoTextViewer.ShowPreview;
begin
   inherited;
   Execute;
   if Assigned( FOnAfterPreview ) then
      FOnAfterPreview( Self );
end;

function TCalculoTextViewer.Inquerito: Boolean;
var
   cxAux : TCaixa;
   mdAux : TMedida;
begin
  Result := True;
  if not Assigned( FVisor ) then
     begin
        Result := False;
        exit;
     end;
  FVisor.Clear;

  // procura caixa de Inquerito
  if Calculo.Memoria.Acha( 'cxcaInquerito1', TObject( cxAux ) ) and ( cxAux is TCaixa ) then
  begin
     // Imprimindo as medidas do Inquerito
     DadosIndividuo;
     FVisor.Lines.Add( 'Inquérito' );
//     FVisor.Lines.Add( cxAux.Descricao );
     if Calculo.Memoria.Acha( 'cxcaInquerito1CalcDesc', TObject( mdAux ) ) then
        FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
     if Calculo.Memoria.Acha( 'cxcaInquerito1DiasDeConsumo', TObject( mdAux ) ) then
        FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );

     FVisor.Lines.Add( '' );

     Result := ItemsAlimentares( 'cxcaInquerito1' );

{     if Calculo.Memoria.Acha( 'cxcaInquerito1Observacao', TObject( mdAux ) ) then
        FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
}
  end
  else
  begin
    FVisor.Clear;
{    FVisor.Lines.Add( 'CÁLCULO DE INQUERITO SELECIONADO!' );
    FVisor.Lines.Add( '' );
    FVisor.Lines.Add( 'PRESSIONE [CALCULAR] PARA FAZER O CÁLCULO.' ); }
  end;

end;

function TCalculoTextViewer.PlanoAlimentar: Boolean;
var
   cxAux : TCaixa;
   mdAux : TMedida;
begin
  Result := True;
  if not Assigned( FVisor ) then
     begin
        Result := False;
        exit;
     end;
  FVisor.Clear;

  // procura caixa de Inquerito
  if Calculo.Memoria.Acha( 'cxcaDieta1', TObject( cxAux ) ) and ( cxAux is TCaixa ) then
  begin
     // Imprimindo as medidas do Inquerito
     DadosIndividuo;
     FVisor.Lines.Add( 'Plano Alimentar' );
//     FVisor.Lines.Add( cxAux.Descricao );
     if Calculo.Memoria.Acha( 'cxcaDieta1CalcDesc', TObject( mdAux ) ) then
        FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );

     FVisor.Lines.Add( '' );

     Result := ItemsAlimentares( 'cxcaDieta1' );
  end
  else
  begin
    FVisor.Clear;
{    FVisor.Lines.Add( 'CÁLCULO DE PLANO ALIMENTAR SELECIONADO!' );
    FVisor.Lines.Add( '' );
    FVisor.Lines.Add( 'PRESSIONE [CALCULAR] PARA FAZER O CÁLCULO.' ); }
  end;

{     if Calculo.Memoria.Acha( 'cxcaDieta1Observacao', TObject( mdAux ) ) then
        FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
}
end;

function TCalculoTextViewer.Preparacao : Boolean;
var
   cxAux : TCaixa;
   mdAux : TMedida;
begin
  Result := True;
  if not Assigned( FVisor ) then
     begin
        Result := False;
        exit;
     end;
  FVisor.Clear;

  // procura caixa de Inquerito
  if Calculo.Memoria.Acha( 'cxcaPreparacao1', TObject( cxAux ) ) and ( cxAux is TCaixa ) then
  begin
     // Imprimindo as medidas do Inquerito
//     FVisor.Lines.Add( cxAux.Descricao );
     FVisor.Lines.Add( 'Preparação' );
     if Calculo.Memoria.Acha( 'cxcaPreparacao1CalcDesc', TObject( mdAux ) ) then
        FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
     if Calculo.Memoria.Acha( 'cxcaPreparacao1PesoFinal', TObject( mdAux ) ) then
        FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
{     if Calculo.Memoria.Acha( 'cxcaPreparacao1', TObject( mdAux ) ) then
        FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
}
     FVisor.Lines.Add( '' );

     Result := ItemsAlimentares( 'cxcaPreparacao1' );
  end
  else
  begin
    FVisor.Clear;
{    FVisor.Lines.Add( 'CÁLCULO DE PREPARACAO SELECIONADO!' );
    FVisor.Lines.Add( '' );
    FVisor.Lines.Add( 'PRESSIONE [CALCULAR] PARA FAZER O CÁLCULO.' ); }
  end;

{     if Calculo.Memoria.Acha( 'cxcaInquerito1Observacao', TObject( mdAux ) ) then
        FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
}
end;

function TCalculoTextViewer.RecCalorica: Boolean;
var
   cxAux : TCaixa;
   mdAux : TMedida;
   prAux : TProcedimento;
   I : Integer;
begin
  Result := True;
  prAux := nil;
  if not Assigned( FVisor ) then
     begin
        Result := False;
        exit;
     end;
  FVisor.Clear;

  // procura caixa de procedimentos de RecCalorica
  if Calculo.Memoria.Acha( 'cxcaRecCal', TObject( cxAux ) ) and ( cxAux is TCaixa ) then
  begin
    // Procura por um procedimento checado
    for I := 0 to cxAux.ComponentCount - 1 do
        if ( cxAux.Components[I] is TProcedimento ) and
           ( TProcedimento( cxAux.Components[I] ).Estado = psChecked  ) then
           prAux := TProcedimento( cxAux.Components[I] );
    // Achou um procedimento, vamos imprimi-lo
    if Assigned( prAux ) then
    with prAux do
    begin
       DadosIndividuo;
       // Descobre qual tipo de procedimento
       if Name = 'prRCFAODia' then
          begin
             // Imprimindo as medidas da RCFAODia
             FVisor.Lines.Add( prAux.Descricao );
             if Calculo.Memoria.Acha( 'mdAFDia', TObject( mdAux ) ) then
                FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
             if Calculo.Memoria.Acha( 'mdGER', TObject( mdAux ) ) then
                FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
             if Calculo.Memoria.Acha( 'mdRCFAODia', TObject( mdAux ) ) then
                FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
          end
       else if Name = 'prRCPac' then
          begin
             // Imprimindo as medidas da RCPac
             FVisor.Lines.Add( prAux.Descricao );
             if Calculo.Memoria.Acha( 'mdAFPAC', TObject( mdAux ) ) then
                FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
             if Calculo.Memoria.Acha( 'mdLesaoPac', TObject( mdAux ) ) then
                FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
             if Calculo.Memoria.Acha( 'mdTempCorpPac', TObject( mdAux ) ) then
                FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
             if Calculo.Memoria.Acha( 'mdGEBHB', TObject( mdAux ) ) then
                FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
             if Calculo.Memoria.Acha( 'mdRCPac', TObject( mdAux ) ) then
                FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
          end
       else if Name = 'prRCRDA' then
          begin
             // Imprimindo as medidas da RCRDA
             FVisor.Lines.Add( prAux.Descricao );
             if Calculo.Memoria.Acha( 'cxRecNut', TObject( cxAux ) ) and
                                    ( cxAux is TCaixa ) then
                begin
                   for I := 0 to cxAux.ComponentCount - 1 do
                       if ( cxAux.Components[I] is TMedida ) and
                          not ( TMedida( cxAux.Components[I] ).Empty ) then
                          FVisor.Lines.Add( '   ' + MedidaText( TMedida( cxAux.Components[I] ) ) );
                end;
          end;
    end;
  end
  else
  begin
    FVisor.Clear;
{    FVisor.Lines.Add( 'CÁLCULO DE RECOMENDACAO DE ENERGIA SELECIONADO!' );
    FVisor.Lines.Add( '' );
    FVisor.Lines.Add( 'PRESSIONE [CALCULAR] PARA FAZER O CÁLCULO.' ); }
  end;

end;


function TCalculoTextViewer.ItemsAlimentares(NomeCaixa: String) : Boolean;
var
//   iaAux : TItemAlimentar;
   cxAux : TCaixa;
   I : Integer;
   OldRefeicao : String;
begin
  Result := True;
  // procura caixa de itensAlimentares
  if Calculo.Memoria.Acha( NomeCaixa, TObject( cxAux ) ) and ( cxAux is TCaixa ) then
  begin
    OldRefeicao := 'Global';
{    FVisor.Lines.Add( LeftSpaces( 'Quant.', 10 ) + ' ' +
                      RightSpaces( 'Medida Caseira', 40 ) + ' ' +
                      RightSpaces( 'Alimento', 60 ) + ' ' +
                      LeftSpaces( 'Peso (g)', 10 ) );
}    // Procura por Itens alimentares
    for I := 0 to cxAux.ComponentCount - 1 do
        if ( cxAux.Components[I] is TItemAlimentar ) then
           with TItemAlimentar( cxAux.Components[I] ) do
           begin
               if OldRefeicao <> Refeicao then
                  begin
                      FVisor.Lines.Add( Refeicao );
                      OldRefeicao := Refeicao;
                  end;
               FVisor.Lines.Add( LeftSpaces( Quantidade, 10 ) + ' ' +
                                 RightSpaces( MedidaCaseira, 40 ) + ' ' +
                                 RightSpaces( Alimento, 60 ) + ' ' +
                                 LeftSpaces( FloatToStr(PesoEmGramas) + 'g', 11 ));
           end;
  end;
end;
{
procedure TCalculoTextViewer.DefAtributosVisor(Cor: TColor;
  Estilo: TFontStyles; Tamanho: Integer);
begin
   if Assigned(FVisor) and ( FVisor is TRichEdit ) then
   with TRichEdit( FVisor ).DefAttributes do begin
        Color := Cor;
        Style := Estilo;
        Size := Tamanho;
        Charset := ANSI_CHARSET;
        Pitch := fpFixed;
        Name := 'Lucida Console';
   end;
end;
}
procedure TCalculoTextViewer.DadosIndividuo;
var
   mdAux : TMedida;
begin
   // Imprimindo as medidas do Individuo
   FVisor.Lines.Add( 'Dados do Indivíduo' );
   if Calculo.Memoria.Acha( 'mdNomeIndividuo', TObject( mdAux ) ) then
      FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
   if Calculo.Memoria.Acha( 'mdSexo', TObject( mdAux ) ) then
      FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
   if Calculo.Memoria.Acha( 'mdDataCalc', TObject( mdAux ) ) then
      FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
   if Calculo.Memoria.Acha( 'mdDataNascimento', TObject( mdAux ) ) then
      FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
   if Calculo.Memoria.Acha( 'mdIdade', TObject( mdAux ) ) then
      FVisor.Lines.Add( '   ' + MedidaText( mdAux ) );
end;
{
procedure TCalculoTextViewer.DefParagrafoVisor(Alinhamento: TAlignment;
  IdentacaoEsquerda: Integer);
begin
   if Assigned(FVisor) and ( FVisor is TRichEdit ) then
   with TRichEdit( FVisor ).ParaGraph do begin
        Alignment := Alinhamento;
        LeftIndent := IdentacaoEsquerda;
   end;

end;
}
procedure TCalculoTextViewer.SetOnAfterPreview(const Value: TNotifyEvent);
begin
  FOnAfterPreview := Value;
end;

function TCalculoTextViewer.AtividadeFisica: Boolean;
begin
  Result := True;
  if not Assigned( FVisor ) then
     begin
        Result := False;
        exit;
     end;
  FVisor.Clear;
  FVisor.Lines.Add( 'CÁLCULO DE ATIVIDADE FÍSICA SELECIONADO!' );
  FVisor.Lines.Add( 'OBS.: ESTE CÁLCULO NÃO PODE SER GRAVADO OU IMPRESSO.' );
  FVisor.Lines.Add( 'PRESSIONE [CALCULAR] PARA FAZER O CÁLCULO.' );
end;

end.

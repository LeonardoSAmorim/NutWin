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




unit NovoInd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, VisorCal, Spin, PAINELMEDIDA,
  measurement, Memoria, Idade, Mask, ToolEdit, FnpNumericEdit,
  VisorMedida, Procedimento,
  Calculo, DescriptorManager, NutCnst, Boxes, PainelNasc;

  const IdadeGravidaMin: Integer = 9;  //anos
  const IdadeGravidaMax: Integer = 60; //anos
  const CriancaMenor : Integer = 36;    //meses
  const CriancaMaior : Integer = 24;    //meses
  const Idoso : Integer = 60;          //anos

type
  TfmNovoIndividuo = class(TForm)
    paNovoIndividuo: TPanel;
    bbNovoIndOk: TBitBtn;
    bbCancelar: TBitBtn;
    gbIdentificacao: TGroupBox;
    paEscSexo: TPainelMedida;
    laEscSexoDescricao: TLabel;
    laEscSexoUnidade: TLabel;
    cbEscSexoValor: TComboBox;
    paNascimento: TPainelNascimento;
    pmEscTempoGestante: TPainelMedida;
    laEscGestanteDescricao: TLabel;
    laEscGestanteUnidade: TLabel;
    pmEscTempoNutriz: TPainelMedida;
    laEscNutrizDescricao: TLabel;
    laEscNutrizUnidade: TLabel;
    gbEstadoFisico: TGroupBox;
    gbEscPeso: TGBoxMedida;
    laEscPesoUnidade: TLabel;
    rbEst: TRadioButton;
    rbExato: TRadioButton;
    gbEscEstatura: TGBoxMedida;
    laEscEstaturaUnidade: TLabel;
    edEscEstaturaValor: TFnpNumericEdit;
    rgPosicao: TRadioGroup;
    paIdoso: TPanel;
    rbEstatMed: TRadioButton;
    rbEstatEst: TRadioButton;
    paEscNomeIndividuo: TPainelMedida;
    laEscNomeIndDescricao: TLabel;
    laEscNomeIndUnidade: TLabel;
    edEscNomeIndValor: TEdit;
    gbExecoes: TGroupBox;
    vcEscopo: TVisorCalculo;
    chkGestante: TCheckBox;
    chkNutriz: TCheckBox;
    gbEscDataVisita: TGBoxMedida;
    laEscDataVisitaUnidade: TLabel;
    laEscDataVisitaDescricao: TLabel;
    deDataVisita: TDateEdit;
    edEscGestanteValor: TFnpNumericEdit;
    edEscNutrizValor: TFnpNumericEdit;
    fnpEscPesoValor: TFnpNumericEdit;
    vmIdadeAnos: TVisorMedida;
    vmIdadeDias: TVisorMedida;
    vmIdadeMeses: TVisorMedida;
    btDefFisico: TButton;
    Label1: TLabel;
    btCalcComp: TButton;
    vmPosicaoEstatura: TVisorMedida;
    laEscDeficienciaDescricao: TLabel;
    laEscDeficienciaValor: TLabel;
    laEscDeficienciaUnidade: TLabel;
    vmDefFisica: TVisorMedida;
    pmEscPesoPG: TPainelMedida;
    laPesoPGDescricao: TLabel;
    laPesoPGUnidade: TLabel;
    pmEscIdadeMenarca: TPainelMedida;
    laIdadeMenarcaDescricao: TLabel;
    laIdadeMenarcaUnidade: TLabel;
    fnpIdadeMenarcaValor: TFnpNumericEdit;
    fnpPesoPGValor: TFnpNumericEdit;
    procedure bbNovoIndOkClick(Sender: TObject);
    procedure bbCancelarClick(Sender: TObject);
    procedure paEscSexoChangeValue(Sender: TObject);
    procedure paNascimentoChangeIdade(Sender: TObject);
    procedure btCalcCompClick(Sender: TObject);
    procedure rgPosicaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btDefFisicoClick(Sender: TObject);
    procedure cbEscSexoValorChange(Sender: TObject);
    procedure chkGestanteClick(Sender: TObject);
    procedure chkNutrizClick(Sender: TObject);
    procedure fnpEscPesoValorInvalidEntry(Sender: TObject);
    procedure edEscEstaturaValorInvalidEntry(Sender: TObject);
    procedure edEscGestanteValorInvalidEntry(Sender: TObject);
    procedure edEscNutrizValorInvalidEntry(Sender: TObject);
    procedure deDataVisitaAcceptDate(Sender: TObject; var ADate: TDateTime;
      var Action: Boolean);
    procedure gbEscPesoChangeValue(Sender: TObject);
    procedure gbEscEstaturaChangeValue(Sender: TObject);
    procedure pmEscTempoNutrizChangeValue(Sender: TObject);
    procedure pmEscTempoGestanteChangeValue(Sender: TObject);
    procedure deDataVisitaExit(Sender: TObject);
    procedure pmEscPesoPGChangeValue(Sender: TObject);
    procedure pmEscIdadeMenarcaChangeValue(Sender: TObject);
    procedure fnpIdadeMenarcaValorInvalidEntry(Sender: TObject);
    procedure fnpPesoPGValorInvalidEntry(Sender: TObject);
  private
    FMostraInfoOK: Boolean;
    FValidaIndiv: Boolean;
    FModoOrganizador: Boolean;
    FCalculo: TCalculo;
    FIndicadores: TDescriptorManager;
    FConfiguracao: TMemoria;
    function LimitesValoresOk ( ListaLimites : TStrings ) : Boolean;
    procedure SetMostraInfoOK(const Value: Boolean);
    procedure SetValidaIndiv(const Value: Boolean);
    procedure SetModoOrganizador(const Value: Boolean);
    procedure SetCalculo(const Value: TCalculo);
    procedure SetConfiguracao(const Value: TMemoria);
    procedure SetIndicadores(const Value: TDescriptorManager);
    { Private declarations }
  public
    { Public declarations }
    procedure DefineVisibles;
    procedure PodeOk;
  published
    property Calculo : TCalculo read FCalculo write SetCalculo;
    property Indicadores : TDescriptorManager read FIndicadores write SetIndicadores;
    property Configuracao : TMemoria read FConfiguracao write SetConfiguracao;
    property ValidaIndiv : Boolean read FValidaIndiv write SetValidaIndiv default True;
    property MostraInfoOK : Boolean read FMostraInfoOK write SetMostraInfoOK default True;
    property ModoOrganizador : Boolean  read FModoOrganizador write SetModoOrganizador default False;
  end;

var
  fmNovoIndividuo: TfmNovoIndividuo;
  Escopo:TCaixa;

implementation

uses Deficien, ErrConsis, fmCompPrna;



{$R *.DFM}

procedure TfmNovoIndividuo.bbNovoIndOkClick(Sender: TObject);
var
GUIDAux,mdMed:TMedida;
Msg : TfmErrConsistencia;
RetCode : Boolean;
Limites : TStrings;
begin

    // Valida Limites
   Limites := TStringList.Create;
   RetCode:=LimitesValoresOk( Limites );
   if not RetCode then

      begin
      Msg:=TfmErrConsistencia.Create(self);
      Msg.lbIncons.Caption := 'Erro! Não posso continuar o cálculo.';
      Msg.lbIncons.Font.Color := clRed;
      Msg.btCancel.Default := True;
      Msg.lbIncons.Visible:=True;
      Msg.lbCons.Visible := False;
      Msg.btOk.Enabled := False;
      Msg.MemoExp.Lines.assign( Limites );
      Msg.MemoExp.Visible:=False;
      Msg.ShowModal;
      ModalResult:=mrNone;
      Msg.Free;
      Limites.Free;
      exit;
   end;
   Limites.Free;

   Msg:=TfmErrConsistencia.Create(self);
   FCalculo.Memoria.Acha('cxprEscopo',TObject(Escopo));
   FCalculo.Memoria.Acha('mdGUIDIndividuo',TObject(GUIDAux));
   GUIDAux.ValorNumerico:=CreateNewGUID;

{*   Hoje:=TMedida.Create(self);
   Hoje.Name:='mdHoje';
   Hoje.ValorNumerico:=DateToStr(Date);
   Hoje.Valid := True;
   Escopo.Acha('mdDataNascimento',TObject(Nasc));
   if Escopo.Acha('mdIdade',TObject(IdadeAux)) then
      IdadeAux.SetMedida (Nasc,Hoje)
   else
       begin
       IdadeAux:=TIdade.Create (Escopo,Nasc,Hoje);//Data Visita
       IdadeAux.Name:='mdIdade';
       IdadeAux.Valid := True;
       end;
}
   FIndicadores.Entradas := Escopo;
   if ValidaIndiv then
   begin

       // Valida calculos
      RetCode:=FIndicadores.Validate ('vlcaIMC','cxcaIMC','caIMC');

      if not RetCode then
         begin
         Msg.lbIncons.Visible:=True;
         Msg.lbCons.Visible := False;
         Msg.MemoExp.Lines := FIndicadores.Explanacao;
         Msg.MemoExp.Visible:=False;
         if Msg.ShowModal = mrOK then
            ModalResult:=mrOK;
         end
      else
         begin
            ModalResult:=mrOK;
      //****** Não precisa mostrar se está concistente
      {   Msg.lbIncons.Visible:=False;
         Msg.lbCons.Visible := True;
         Msg.MemoExp.Lines := FIndicadores.Explanacao;
         Msg.MemoExp.Visible:=False;
         if MostraInfoOK then
            if Msg.ShowModal = mrOK then
               ModalResult:=mrOK; }
         end;
   end
   else
       ModalResult:=mrOK;

//*Hoje.Free;

if ModalResult=mrOK then
   begin
    // Valida calculos
//#    FCalculo.ValidaCalculo( 'vlcaAntrop', 'cxcaAntrop' );
    //FCalculo.ValidaCalculo( 'vlRecCal', 'cxcaRecCal' );

    // Filtra Cálculos conforme configuração
//#    FCalculo.FiltraCalculo( FConfiguracao, 'cxcaAntrop' );
    //FCalculo.FiltraCalculo( dmMotherBoard.CfgMemoria, 'cxcaRecCal' );

    // Torna o procedimento ECCP "Escondido", pois ele é usado só aqui
//#    FCalculo.SetEstadoProc( FCalculo.Memoria, 'cxcaAntrop', 'prECCP', psHidden );
       if FCalculo.Memoria.Acha( 'mdPeso', TObject( mdMed ) ) then
          mdMed.Valid := True;
       if FCalculo.Memoria.Acha( 'mdEstatura', TObject( mdMed ) ) then
          mdMed.Valid := True;
    end;
    Msg.Free;

end;

procedure TfmNovoIndividuo.bbCancelarClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TfmNovoIndividuo.paEscSexoChangeValue(Sender: TObject);
begin
DefineVisibles;
end;


procedure TfmNovoIndividuo.SetMostraInfoOK(const Value: Boolean);
begin
  FMostraInfoOK := Value;
end;

procedure TfmNovoIndividuo.SetValidaIndiv(const Value: Boolean);
begin
  FValidaIndiv := Value;
end;

procedure TfmNovoIndividuo.DefineVisibles;
var
   mdDefTemCompPerna : TMedida;
   mdIdadeTemp : TIdade;
begin
// ATENÇÃO! Todas as referencia aos componentes TVisorCalculo deste form e nesta
//procedure DEVEM ser verificados quanto aa propriedade medida. Use Assigned para isto.
// Mesmo assim, se durante o processo de setting do vcEscopo algum evento vir
// para cá, vamos cair fora.
if vcEscopo.Setting then
   exit;

//Define Nutriz, Gestante
//*   paNascimento.mdIdade.ConvertToUnit('anos');

  if (not paNascimento.mdIdade.Empty) and
         Assigned(vmIdadeDias.Medida) and
         Assigned (vmIdadeMeses.Medida) and
         Assigned (vmIdadeAnos.Medida) then
     begin
        mdIdadeTemp := TIdade.Create(self);
        try
           mdIdadeTemp.assign( paNascimento.mdIdade );
           mdIdadeTemp.ConvertToUnit('dias');
           vmIdadeDias.Medida.ValorNumerico:=mdIdadeTemp.ValorNumerico;
           mdIdadeTemp.ConvertToUnit('meses');
           vmIdadeMeses.Medida.ValorNumerico:=mdIdadeTemp.ValorNumerico;
           mdIdadeTemp.ConvertToUnit('anos');
           vmIdadeAnos.Medida.ValorNumerico:=mdIdadeTemp.ValorNumerico;
        finally
           mdIdadeTemp.Free;
        end;
     end;

   if Assigned(vmIdadeAnos.Medida) then
   begin
      if (cbEscSexoValor.text = 'Feminino') and
         (vmIdadeAnos.Medida.AsFloat >= IdadeGravidaMin) and
         (vmIdadeAnos.Medida.AsFloat <= IdadeGravidaMax) then
         begin
            // Mostra entrada de dados de Gestante e Nutriz
            pmEscTempoGestante.Visible := True;
            pmEscPesoPG.Visible := True;
            pmEscIdadeMenarca.Visible := True;
            pmEscTempoNutriz.Visible := True;
         end
      else
         begin
            // Esconde entrada de dados de Gestante e Nutriz
            pmEscTempoGestante.Visible := False;
            pmEscPesoPG.Visible := False;
            pmEscIdadeMenarca.Visible := False;
            pmEscTempoNutriz.Visible := False;
         end;
   end;

  if Assigned (vmIdadeMeses.Medida) then
     rgPosicao.Visible:=(vmIdadeMeses.Medida.AsFloat >= CriancaMaior) and
                        (vmIdadeMeses.Medida.AsFloat <= CriancaMenor);

  // se não tem a medida mdDefTemCompPerna não posso calcular pelo comprimento da perna
  if Assigned (vmIdadeAnos.Medida) and FCalculo.Memoria.Acha( 'mdDefTemCompPerna', TObject( mdDefTemCompPerna ) ) then
     paIdoso.Visible:=(vmIdadeAnos.Medida.AsFloat >= Idoso) and (mdDefTemCompPerna.AsFloat <> 0);

  if Assigned (vmPosicaoEstatura.Medida) then
     begin
       // é sempre comprimento se criança for menor que 2 anos
       // e é sempre Estatura se criança for maior que 3 anos
       // vide tabelas NCHS
       if (vmIdadeMeses.Medida.AsFloat < CriancaMaior) then
         begin
           vmPosicaoEstatura.Medida.ValorNumerico:='Comprimento';
           rgPosicao.ItemIndex:=0;
         end
       else if (vmIdadeMeses.Medida.AsFloat > CriancaMenor) then
         begin
           vmPosicaoEstatura.Medida.ValorNumerico:='Estatura';
           rgPosicao.ItemIndex:=1;
         end
       else if not vmPosicaoEstatura.Medida.Empty then
         begin
          if (vmPosicaoEstatura.Medida.ValorNumerico='Comprimento') then
             rgPosicao.ItemIndex:=1
          else
             rgPosicao.ItemIndex:=0;
         end;
     end;

end;

procedure TfmNovoIndividuo.paNascimentoChangeIdade(Sender: TObject);
begin
DefineVisibles;
PodeOk;
end;

procedure TfmNovoIndividuo.btCalcCompClick(Sender: TObject);
var
CalcCompPerna : TfmCompPerna;
begin
CalcCompPerna:=TfmCompPerna.Create(self);
CalcCompPerna.Calculo := FCalculo;
CalcCompPerna.ShowModal;
CalcCompPerna.Free;
vcEscopo.Refresh;
end;


procedure TfmNovoIndividuo.rgPosicaoClick(Sender: TObject);
begin
if rgPosicao.ItemIndex = 0 then
   vmPosicaoEstatura.Medida.ValorNumerico:='Comprimento'
else
   vmPosicaoEstatura.Medida.ValorNumerico:='Estatura';

end;

procedure TfmNovoIndividuo.SetModoOrganizador(const Value: Boolean);
  procedure HabilitaControls (Parent : TWinControl; Estado : Boolean);
  var
  I : integer;
  begin
       for I:=0 to Parent.ControlCount-1 do
       begin
       Parent.Controls[I].Enabled:=Estado;
       end;
  end;
begin
  FModoOrganizador := Value;

  HabilitaControls(paEscSexo, not FModoOrganizador);
  HabilitaControls(paNascimento, not FModoOrganizador);
  HabilitaControls(paEscNomeIndividuo, not FModoOrganizador);
  HabilitaControls(gbEscDataVisita, not FModoOrganizador);

  if FModoOrganizador then
     ActiveControl:=fnpEscPesoValor ;

end;

procedure TfmNovoIndividuo.SetCalculo(const Value: TCalculo);
begin
  FCalculo := Value;
end;

procedure TfmNovoIndividuo.SetConfiguracao(const Value: TMemoria);
begin
  FConfiguracao := Value;
end;

procedure TfmNovoIndividuo.SetIndicadores(const Value: TDescriptorManager);
begin
  FIndicadores := Value;
end;

procedure TfmNovoIndividuo.FormShow(Sender: TObject);
var
   mdMed : TMedida;
   Obj : String;
begin
   vcEscopo.Calculo := FCalculo;
   vcEscopo.Container := self;
   Obj := '';

   vcEscopo.Refresh; // estou forçando para todas as medidas serem setadas antes do show terminar

   if not FModoOrganizador then
   begin
      // Define modo em que só nascimento ou idade podem ser editados
      paNascimento.ModoEnabled := False;
      edEscNomeIndValor.SetFocus;
   end
   else
      paNascimento.ModoEnabled := True;

   ValidaIndiv:=True;
   MostraInfoOK:=True;
   FModoOrganizador:=False;
   DefineVisibles; // tenho que chamar pois o refresh acima não chamou nos eventos dos visores medidas

  if FCalculo.Memoria.Acha( 'mdFatAjusDef', TObject( mdMed ) ) then
     mdMed.ValorNumerico := '1';
  if FCalculo.Memoria.Acha( 'mdDefFisica', TObject( mdMed ) ) then
     mdMed.ValorNumerico := 'Nenhuma';
  if FCalculo.Memoria.Acha( 'mdTempoGestante', TObject( mdMed ) ) then
     mdMed.ValorNumerico := '0';
  if FCalculo.Memoria.Acha( 'mdPesoPG', TObject( mdMed ) ) then
     mdMed.ValorNumerico := '0';
  if FCalculo.Memoria.Acha( 'mdIdadeMenarca', TObject( mdMed ) ) then
     mdMed.ValorNumerico := '0';
  if FCalculo.Memoria.Acha( 'mdTempoNutriz', TObject( mdMed ) ) then
     mdMed.ValorNumerico := '0';
  if FCalculo.Memoria.Acha( 'mdAscite', TObject( mdMed ) ) then
     mdMed.ValorNumerico := '0';
end;

procedure TfmNovoIndividuo.FormCreate(Sender: TObject);
begin
   vcEscopo.Calculo := FCalculo;
   vcEscopo.Container := self;
//   paNascimento.fnpIdadeValor.MinValue := 0;
//   paNascimento.fnpIdadeValor.MaxLength := 130;
   paNascimento.fnpIdadeValor.MaxLength := 4;
   paNascimento.fnpIdadeValor.Decimals := 0;
//   paNascimento.fnpIdadeValor.OnInvalidEntry :=
end;

procedure TfmNovoIndividuo.btDefFisicoClick(Sender: TObject);
var
   fmDefFis : TfmDeficiente;
   mdFatorAjuste : TMedida;
   mdDeficiencia : TMedidaOrdinal;
   mdPartesAmputadas : TMedidaOrdinal;
begin

   // Recupera valores para setagem no form
   if not FCalculo.Memoria.Acha( 'mdFatAjusDef', TObject( mdFatorAjuste ) ) then
      exit;
   if not FCalculo.Memoria.Acha( 'mdDefFisica', TObject( mdDeficiencia ) ) then
      exit;
   if not FCalculo.Memoria.Acha( 'mdPartesAmputadas', TObject( mdPartesAmputadas ) ) then
      exit;

   fmDefFis := TfmDeficiente.Create(self);
   with fmDefFis do
   begin

      Calculo := FCalculo;

      // Passa valores da memória para o form
      Deficiencia := mdDeficiencia.ValorNumerico;
      // Para enganar a concistencia que não aceita medidas vazias
      if mdPartesAmputadas.ValorNumerico = '[]' then
         ListaPartesAmputadas.Clear
      else
         ListaPartesAmputadas.CommaText := mdPartesAmputadas.ValorNumerico;
      FatorDef := mdFatorAjuste.AsFloat;

      ShowModal;
      if ModalResult = mrOk then
         begin
            // Passa valores do form para a memoria
            mdFatorAjuste.AsFloat := FatorDef;
            mdDeficiencia.ValorNumerico := Deficiencia;
            // Só pra enganar a concistencia que não aceita esta medida vazia
            if ListaPartesAmputadas.Count = 0 then
               mdPartesAmputadas.ValorNumerico := '[]'
            else
               mdPartesAmputadas.ValorNumerico := ListaPartesAmputadas.CommaText;
            vmDefFisica.Refresh;
            // Para atualizar controls da tela
            DefineVisibles;
         end;
      Free;
   end;
end;

procedure TfmNovoIndividuo.cbEscSexoValorChange(Sender: TObject);
begin

end;

// São limites que independem de unidade e não podem
// permitir que o programa prossiga
function TfmNovoIndividuo.LimitesValoresOk( ListaLimites : TStrings ): Boolean;
begin
   Result := True;
{ Desativando por enquanto pois tem validação nos fnp de edição
   if ( gbEscPeso.Medida.AsFloat <= 0 ) or ( gbEscPeso.Medida.AsFloat > 300 ) then
   begin
      ListaLimites.Add( 'O valor do peso tem que ser maior que 0 e menor igual a 300 kg' );
      Result := False;
   end;
   if ( gbEscEstatura.Medida.AsFloat <= 0 ) or ( gbEscEstatura.Medida.AsFloat > 250 ) then
   begin
      ListaLimites.Add( 'O valor da estatura tem que ser maior que 0 e menor igual a 250 cm' );
      Result := False;
   end;
   if (( deDataVisita.Date - paNascimento.deNascimento.Date ) <= 0 ) then
   begin
      ListaLimites.Add( 'O valor da idade tem que ser maior que 0 e menor igual a 130 anos' );
      Result := False;
   end;
   if chkGestante.Checked and ( pmEscTempoGestante.Medida.AsFloat <= 0 ) or
                              ( pmEscTempoGestante.Medida.AsFloat > 50 ) then
   begin
      ListaLimites.Add( 'O valor do tempo de gestante tem que ser maior que 0 e menor igual a 50 semanas' );
      Result := False;
   end;
   if chkNutriz.Checked and ( pmEscTempoNutriz.Medida.AsFloat <= 0 ) or
                            ( pmEscTempoNutriz.Medida.AsFloat > 100 ) then
   begin
      ListaLimites.Add( 'O valor do tempo de nutriz tem que ser maior que 0 e menor igual a 100 semanas' );
      Result := False;
   end;         }
end;

procedure TfmNovoIndividuo.chkGestanteClick(Sender: TObject);
begin
   if not chkGestante.Checked and Assigned( pmEscTempoGestante.Medida ) then
   begin
      pmEscTempoGestante.Medida.AsFloat := 0;
      pmEscTempoGestante.EntradaNumerica.Visible := False;
      pmEscTempoGestante.EntradaDeUnidade.Visible := False;
      pmEscPesoPG.Medida.AsFloat := 0;
      pmEscIdadeMenarca.Medida.AsFloat := 0;
      pmEscPesoPG.EntradaNumerica.Visible := False;
      pmEscPesoPG.EntradaDeUnidade.Visible := False;
      pmEscIdadeMenarca.EntradaNumerica.Visible := False;
      pmEscIdadeMenarca.EntradaDeUnidade.Visible := False;
   end
   else
   begin
      pmEscTempoGestante.Refresh;
      pmEscTempoGestante.EntradaNumerica.Visible := True;
      pmEscTempoGestante.EntradaDeUnidade.Visible := True;
      pmEscPesoPG.Refresh;
      pmEscIdadeMenarca.Refresh;
      pmEscPesoPG.EntradaNumerica.Visible := True;
      pmEscPesoPG.EntradaDeUnidade.Visible := True;
      pmEscIdadeMenarca.EntradaNumerica.Visible := True;
      pmEscIdadeMenarca.EntradaDeUnidade.Visible := True;
    end;
   PodeOk;
end;

procedure TfmNovoIndividuo.chkNutrizClick(Sender: TObject);
begin
   if not chkNutriz.Checked and Assigned( pmEscTempoNutriz.Medida ) then
   begin
      pmEscTempoNutriz.Medida.AsFloat := 0;
      pmEscTempoNutriz.EntradaNumerica.Visible := False;
      pmEscTempoNutriz.EntradaDeUnidade.Visible := False;
   end
   else
   begin
      pmEscTempoNutriz.Refresh;
      pmEscTempoNutriz.EntradaNumerica.Visible := True;
      pmEscTempoNutriz.EntradaDeUnidade.Visible := True;
   end;
   PodeOk;
end;

procedure TfmNovoIndividuo.fnpEscPesoValorInvalidEntry(Sender: TObject);
begin
if Self.ActiveControl.name <> bbCancelar.name then
begin
   ShowMessage( 'O peso deve estar entre: ' +  FloatToStr( fnpEscPesoValor.MinValue ) + ' e ' +
                                               FloatToStr( fnpEscPesoValor.MaxValue) );
   fnpEscPesoValor.SetFocus;
end;
end;

procedure TfmNovoIndividuo.edEscEstaturaValorInvalidEntry(Sender: TObject);
begin
if Self.ActiveControl.name <> bbCancelar.name then
begin
   ShowMessage( 'A Estatura deve estar entre: ' +  FloatToStr( edEscEstaturaValor.MinValue ) + ' e ' +
                                                   FloatToStr( edEscEstaturaValor.MaxValue) );
   edEscEstaturaValor.SetFocus;
end;
end;

procedure TfmNovoIndividuo.edEscGestanteValorInvalidEntry(Sender: TObject);
begin
if chkGestante.Checked and ( Self.ActiveControl.name <> bbCancelar.name ) then
begin
   ShowMessage( 'O tempo de gestação deve estar entre: ' +  FloatToStr( edEscGestanteValor.MinValue ) + ' e ' +
                                                            FloatToStr( edEscGestanteValor.MaxValue) );
   edEscGestanteValor.SetFocus;
end;
end;

procedure TfmNovoIndividuo.edEscNutrizValorInvalidEntry(Sender: TObject);
begin
if chkNutriz.Checked and ( Self.ActiveControl.name <> bbCancelar.name ) then
begin
   ShowMessage( 'O tempo de nutriz deve estar entre: ' +  FloatToStr( edEscNutrizValor.MinValue ) + ' e ' +
                                                          FloatToStr( edEscNutrizValor.MaxValue) );
   edEscNutrizValor.SetFocus;
end;
end;

procedure TfmNovoIndividuo.deDataVisitaAcceptDate(Sender: TObject;
  var ADate: TDateTime; var Action: Boolean);
begin
if ( ADate > Now ) and ( Self.ActiveControl.name <> bbCancelar.name ) then
begin
   ShowMessage( 'A data da visita não pode ser maior que a data de hoje' );
   Action := False;
   deDataVisita.Undo;
   deDataVisita.SetFocus;
end
else
begin
   Action := True;
end;
end;

procedure TfmNovoIndividuo.PodeOk;
var
   IdadeValorAnos : Double;
begin
if not (csLoading in self.ComponentState) and Assigned( vmIdadeAnos.Medida ) then
   begin
      try
         IdadeValorAnos := vmIdadeAnos.Medida.AsFloat
      except
         ShowMessage( 'Idade Anos não existe!' );
         raise;
      end;
      bbNovoIndOk.Enabled := (fnpEscPesoValor.MinValue <= fnpEscPesoValor.Value) and
                             (fnpEscPesoValor.MaxValue >= fnpEscPesoValor.Value) and
                             (edEscEstaturaValor.MinValue <= edEscEstaturaValor.Value) and
                             (edEscEstaturaValor.MaxValue >= edEscEstaturaValor.Value) and
                             (paNascimento.FmdIdadeMinima.AsFloat <= IdadeValorAnos ) and
                             (paNascimento.FmdIdadeMaxima.AsFloat >= IdadeValorAnos );
      if chkGestante.Checked and (edEscGestanteValor.Text <> '') and (edEscGestanteValor.Text <> '-')then
         bbNovoIndOk.Enabled := bbNovoIndOk.Enabled and
                               (edEscGestanteValor.MinValue <= edEscGestanteValor.Value) and
                               (edEscGestanteValor.MaxValue >= edEscGestanteValor.Value);
      if chkGestante.Checked and (fnpPesoPGValor.Text <> '') and (fnpPesoPGValor.Text <> '-')then
         bbNovoIndOk.Enabled := bbNovoIndOk.Enabled and
                               (fnpPesoPGValor.MinValue <= fnpPesoPGValor.Value) and
                               (fnpPesoPGValor.MaxValue >= fnpPesoPGValor.Value);
      if chkGestante.Checked and (fnpIdadeMenarcaValor.Text <> '') and (fnpIdadeMenarcaValor.Text <> '-')then
         bbNovoIndOk.Enabled := bbNovoIndOk.Enabled and
                               (fnpIdadeMenarcaValor.MinValue <= fnpIdadeMenarcaValor.Value) and
                               (fnpIdadeMenarcaValor.MaxValue >= fnpIdadeMenarcaValor.Value);
      if chkNutriz.Checked and (edEscNutrizValor.Text <> '') and (edEscNutrizValor.Text <> '-')then
         bbNovoIndOk.Enabled := bbNovoIndOk.Enabled and
                                (edEscNutrizValor.MinValue <= edEscNutrizValor.Value) and
                                (edEscNutrizValor.MaxValue >= edEscNutrizValor.Value);
   end;
end;

procedure TfmNovoIndividuo.gbEscPesoChangeValue(Sender: TObject);
begin
   PodeOk;
end;

procedure TfmNovoIndividuo.gbEscEstaturaChangeValue(Sender: TObject);
begin
   PodeOk;
end;

procedure TfmNovoIndividuo.pmEscTempoNutrizChangeValue(Sender: TObject);
begin
   PodeOk;
end;

procedure TfmNovoIndividuo.pmEscTempoGestanteChangeValue(Sender: TObject);
begin
   PodeOk;
end;

procedure TfmNovoIndividuo.deDataVisitaExit(Sender: TObject);
begin
if ( deDataVisita.Date > Now ) and ( Self.ActiveControl.name <> bbCancelar.name ) then
begin
   ShowMessage( 'A data da visita não pode ser maior que a data de hoje' );
   deDataVisita.Date := Now;
   deDataVisita.SetFocus;
end;

end;

procedure TfmNovoIndividuo.pmEscPesoPGChangeValue(Sender: TObject);
begin
   PodeOk;
end;

procedure TfmNovoIndividuo.pmEscIdadeMenarcaChangeValue(Sender: TObject);
begin
   PodeOk;
end;

procedure TfmNovoIndividuo.fnpIdadeMenarcaValorInvalidEntry(
  Sender: TObject);
begin
if Self.ActiveControl.name <> bbCancelar.name then
begin
   ShowMessage( 'A idade da menarca deve estar entre: ' +  FloatToStr( fnpIdadeMenarcaValor.MinValue ) + ' e ' +
                                                           FloatToStr( fnpIdadeMenarcaValor.MaxValue) );
   fnpIdadeMenarcaValor.SetFocus;
end;
end;

procedure TfmNovoIndividuo.fnpPesoPGValorInvalidEntry(Sender: TObject);
begin
if Self.ActiveControl.name <> bbCancelar.name then
begin
   ShowMessage( 'O peso pré-gestacional deve estar entre: ' +  FloatToStr( fnpPesoPGValor.MinValue ) + ' e ' +
                                                               FloatToStr( fnpPesoPGValor.MaxValue) );
   fnpPesoPGValor.SetFocus;
end;

end;

end.


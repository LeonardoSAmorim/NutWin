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




{ ****************************************************************** }
{                                                                    }
{   Delphi component TPainelNascimento                               }
{                                                                    }
{   Mostra medidas, seus valores numericos e suas unidades           }
{                                                                    }
{   Copyright © 1997 by DIS-EPM/UNIFESP                              }
{                                                                    }
{ ****************************************************************** }

unit PainelNasc;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     Boxes, ExtCtrls, StdCtrls, ComCtrls, Mask, typinfo, ToolEdit, FnpNEditBlank,
     FnpNumericEdit, Idade, Measurement;

type

   TMyForm = class(TCustomForm);
   TMyWCntrl = class(TWinControl);
   TMyButtonControl = class(TButtonControl);

   TPainelNascimento = class(TControlGroupBox)
      rbIdadeEstimada : TRadioButton;
      cbUnidadesIdade : TComboBox;
      deNascimento : TDateEdit;
      rbIdadeExata : TRadioButton;
      fnpIdadeValor : TFnpNEditBlank;
      FmdIdadeMaxima : TIdade;
      FmdIdadeMinima : TIdade;
    bvSeparador: TBevel;
      procedure PNascimentoEnter(Sender : TObject);
      procedure cbUnidadesIdadeEnter(Sender : TObject);
      procedure fnpIdadeValorKeyPress(Sender : TObject; var Key : Char);
      procedure rbIdadeExataClick(Sender : TObject);
      procedure rbIdadeEstimadaClick(Sender : TObject);
      procedure deNascimentoAcceptDate(Sender : TObject; var ADate : TDateTime; var Action : Boolean);
      procedure cbUnidadesIdadeChange(Sender : TObject);
      procedure deNascimentoChange(Sender : TObject);
      procedure fnpIdadeValorChange(Sender : TObject);
      procedure PNascimentoExit(Sender : TObject);
      procedure fnpIdadeValorEnter(Sender : TObject);
      procedure deNascimentoEnter(Sender : TObject);
   private
      FPrimeiraVez : boolean;
      FAlterado : boolean;
      FmdIdade : TIdade;
      FmdNascimento : TMedida;
      FmdReferencia : TMedida;
      FNomeMedidaNascimento : string;
      FNomeMedidaReferencia : string;
      FNomeMedidaIdade : string;
      FOnChangeIdade : TNotifyEvent;
      FDefDataExata : Boolean;
      FModoEnabled: Boolean;
      procedure SetAlterado(const Value : boolean);
      procedure SetmdIdade(const Value : TIdade);
      procedure SetmdNascimento(const Value : TMedida);
      procedure SetmdReferencia(const Value : TMedida);
      procedure SetNomeMedidaIdade(const Value : string);
      procedure SetNomeMedidaNascimento(const Value : string);
      procedure SetNomeMedidaReferencia(const Value : string);
      procedure SetOnChangeIdade(const Value : TNotifyEvent);
      procedure SetDefDataExata(const Value : Boolean);
    procedure SetModoEnabled(const Value: Boolean);
   protected
      UnidadeInFocus : boolean;
      ValorInFocus : boolean;
      DataNascInFocus : boolean;
      FLastKey : Char;
      FIdadeVisited : boolean;
      FDNascVisited : boolean;
      DefinindoNascimento : boolean;
      DefinindoIdade : boolean;
      procedure CMChildKey(var Message : TWMKey); message CM_CHILDKEY;
      procedure ChangeIdade;
      procedure IdadeInvalidEntry;
      procedure DNascInvalidEntry;
   public
      constructor Create(AOwner : TComponent);override;
      procedure GoAway(Backwards : Boolean);
      procedure GoToFNP;
      procedure GoToDateEdit;
      procedure GoToUnit;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      function DefineIdade : boolean;
      function DefineDNasc : boolean;
      function ValidaIdade(Valor, Unidade:string) : boolean;
      function ValidaNascimento(NewDNasc, Referencia : string) : boolean;
      function SetIdadeMaxima(Valor,Unidade : string) : boolean;
      function SetIdadeMinima(Valor, Unidade : string) : boolean;
      procedure Refresh;
      procedure SetIdadeSingPlural(VNum : integer);
   published
      property Align;
      property ModoEnabled : Boolean read FModoEnabled write SetModoEnabled; // criado para resolver problema de conversão
      property Alterado : boolean read FAlterado write SetAlterado default False;
      property DefDataExata : Boolean read FDefDataExata write SetDefDataExata default False;
      property mdIdade : TIdade read FmdIdade write SetmdIdade;
      property mdNascimento : TMedida read FmdNascimento write SetmdNascimento;
      property mdReferencia : TMedida read FmdReferencia write SetmdReferencia;
      property NomeMedidaIdade : string read FNomeMedidaIdade write SetNomeMedidaIdade;
      property NomeMedidaNascimento : string read FNomeMedidaNascimento write SetNomeMedidaNascimento;
      property NomeMedidaReferencia : string read FNomeMedidaReferencia write SetNomeMedidaReferencia;
      property OnChangeIdade : TNotifyEvent read FOnChangeIdade write SetOnChangeIdade;
   end;

procedure Register;

implementation

{$R *.DFM}

procedure Register;
begin
   RegisterComponents('Medida', [TPainelNascimento]);
end;

constructor TPainelNascimento.Create(AOwner: TComponent);
begin
   inherited;
   FModoEnabled := True; // é true por default
   FPrimeiraVez := True; // indica que é a primeira vez que entra no painel
   FAlterado := False;
   UnidadeInFocus := False;
   ValorInFocus := False;
   DataNascInFocus := False;
   FmdIdadeMinima.ValorNumerico := '0';
   FmdIdadeMinima.Unidade := 'anos';
   FmdIdadeMaxima.ValorNumerico := '130';
   FmdIdadeMaxima.Unidade := 'anos';
   FdefDataExata := False;
   FNomeMedidaIdade := 'mdIdade';
   FNomeMedidaNascimento := 'mdDataNascimento';
   FNomeMedidaReferencia := 'mdDataCalc';
   DefinindoNascimento := False;
   DefinindoIdade := False;
end;

procedure TPainelNascimento.PNascimentoEnter(Sender: TObject);
begin
   FIdadeVisited := False;
   FDNascVisited := False;
   Refresh;
   // Executa se não for a primeira vez
   if not FPrimeiraVez then
   begin
      if rbIdadeExata.Checked then
         GoToDateEdit
      else
         GoToFNP;
   end
   else
      FPrimeiraVez := False; // primeira vez já foi executada
end;

procedure TPainelNascimento.CMChildKey(var Message: TWMKey);
var
   Back : boolean;
begin
   //Verifica o sentido da navegacao (Tab ou Shift-Tab)
   Back := ssShift in KeyDataToShiftState(Message.KeyData );
   case Message.CharCode of
      //Escape, cai fora
      VK_ESCAPE :
         begin
            GoAway (Back);
         end;
      //Tab ou Enter
      VK_TAB, VK_RETURN:
         begin
            //Se esta parado na unidade da idade,
            //define a idade e cai fora
            if UnidadeInFocus then
               begin
                  if DefineIdade then
                     begin
                        GoAway (Back);
                     end;
                  Message.Result := 1;
                  exit;
               end;
            //Se esta parado no valor da idade
            //Se foi alterado o valor, vai pra unidade
            //Se ja pasou pela data de nascimento, cai fora
            //Se nao, pasa pelo campo Data de Nascimento
            if fnpIdadeValor.Focused then
               begin
               if FAlterado then
                  begin
                     GoToUnit;
                  end
               else
                  begin
                     if FDNascVisited then
                        GoAway (Back)
                     else if FModoEnabled then // só pode ir para a data se ela estiver enabled
                        GoToDateEdit
                     else
                        GoAway(Back); // caso contrário volta para outro control
                  end;
               end
            //Se esta parado na Data de Nascimento
            //Se foi alterado, verifica, atualiza os valores e cai fora
            //Senao, se ja pasou pela idade, cai fora
            //Senao pasa pelo campo idade
            else if deNascimento.Focused then
               begin
                  if FAlterado then
                     begin
                        if DefineDNasc then
                           GoAway(Back);
                     end
                  else
                     begin
                        if FIdadeVisited then
                           GoAway(Back)
                        else if FModoEnabled then // só vai para a idade se estiver enabled
                           GoToFNP
                        else
                           GoAway(Back); // caso contrário, volta para o control anterior
                        end;
                     end;
                  //Tratou a mensagem
                  Message.Result := 1;
               end
            else
               //Comportamento padrao
               inherited;
         end;
end;

//Deixa o foco na entrada de data
procedure TPainelNascimento.GoToDateEdit;
begin
   FDNascVisited := True;
   UnidadeInFocus := False;
   ValorInFocus := False;
   if deNascimento.Enabled then
      deNascimento.SetFocus;
end;

//Deixa o foco na entrada de valor numerico da idade
procedure TPainelNascimento.GoToFNP;
begin
   FIdadeVisited := True;
   UnidadeInFocus := False;
   DataNascInFocus := False;
   if fnpIdadeValor.Enabled then
      fnpIdadeValor.SetFocus;
end;

//Deixa o foco na entrada de unidades
procedure TPainelNascimento.GoToUnit;
begin
   with cbUnidadesIdade do
   begin
      if ItemIndex = -1 then
         ItemIndex := 0;
      if cbUnidadesIdade.Enabled then   
      SetFocus;
   end;
   UnidadeInFocus := True;
   ValorInFocus := False;
   DataNascInFocus := False;
end;

//Vai embora pro proximo control (pra frente ou pra tras)
procedure TPainelNascimento.GoAway(Backwards : Boolean);
var
   Form : TMyForm;
   List : TList;
begin
   List := TList.Create;
   Form := TMyForm(GetParentForm (self));
   try
      GetTabOrderList(List);
      if List.Count > 0 then
         begin
            if Backwards then
               Form.SelectNext(self, False, True)
            else
               Form.SelectNext(List[List.Count-1], True, True);
            FAlterado := False;
            UnidadeInFocus := False;
            ValorInFocus := False;
            DataNascInFocus := False;
         end;
   finally
      List.free;
   end;
end;

//Intercepta o teclado para pegar os shortcuts (a=anos,m=meses,d=dias)
procedure TPainelNascimento.fnpIdadeValorKeyPress(Sender: TObject; var Key: Char);
begin
   if (Key in ['0'..'9', DecimalSeparator, '-', #3, #8, #22, #24]) Then
      begin
         FLastKey := Key;
         FAlterado := True;
      end;
   case Key of
      'a','A':
         begin
            cbUnidadesIdade.ItemIndex:=Ord(anos);
            GoToUnit;
         end;
      'm','M':
         begin
            cbUnidadesIdade.ItemIndex:=Ord(meses);
            GoToUnit;
         end;
      'd','D':
         begin
            cbUnidadesIdade.ItemIndex:=Ord(dias);
            GoToUnit;
         end;
   end;
end;

procedure TPainelNascimento.SetAlterado(const Value: boolean);
begin
//     ReadOnly
end;

procedure TPainelNascimento.cbUnidadesIdadeEnter(Sender: TObject);
begin
   UnidadeInFocus := True;
end;

procedure TPainelNascimento.rbIdadeExataClick(Sender: TObject);
begin
   FAlterado := True;
   // Deixa só o control de data de nascimento
   if not FModoEnabled then
   begin
      deNascimento.Enabled := True;
      cbUnidadesIdade.Enabled := False;
      fnpIdadeValor.Enabled := False;
   end;
   GoToDateEdit;
end;

procedure TPainelNascimento.rbIdadeEstimadaClick(Sender: TObject);
begin
   FAlterado := True;
   // Deixa só os controls de idade
   if not FModoEnabled then
   begin
      deNascimento.Enabled := False;
      cbUnidadesIdade.Enabled := True;
      fnpIdadeValor.Enabled := True;
   end;
   GoToFNP;
end;

//Verifica se a data de nascimento nao e maior que a data de hoje
procedure TPainelNascimento.deNascimentoAcceptDate(Sender: TObject;
  var ADate: TDateTime; var Action: Boolean);
begin
   if ADate > Now then
   begin
      ShowMessage('A data de nascimento não pode ser maior que a data de hoje');
      deNascimento.Undo;
      if deNascimento.Enabled then
         deNascimento.SetFocus;
      Action := False;
   end
   else
   begin
      if DefineDNasc then
         Action:=True
      else
         Action:=False;
   end;
end;

//Saida do campo de edicao da data de nascimento
procedure TPainelNascimento.PNascimentoExit(Sender: TObject);
begin
   if UnidadeInFocus or ValorInFocus then
   begin
      if FAlterado then
         DefineIdade;
      Refresh;
   end
   else if DataNascInFocus then
   begin
      if FAlterado then
         DefineDNasc;
      end;
   FIdadeVisited := False;
   FDNascVisited := False;
end;

procedure TPainelNascimento.fnpIdadeValorEnter(Sender: TObject);
begin
   // Esconde nascimento pois foi escolhida a idade
   if not FModoEnabled then
   begin
      deNascimento.Enabled := False;
   end;
   ValorInFocus := True;
   fnpIdadeValor.SelectAll;
end;

procedure TPainelNascimento.deNascimentoEnter(Sender: TObject);
begin
   // Esconde a idade pois foi escolhida a data de nascimento
   if not FModoEnabled then
   begin
      cbUnidadesIdade.Enabled := False;
      fnpIdadeValor.Enabled := False;
   end;
   DataNascInFocus := True;
   deNascimento.SelectAll;
end;

//Mensagem de idade invalida
procedure TPainelNascimento.IdadeInvalidEntry;
begin
   FAlterado := False;
   ShowMessage('Idade Inválida');
end;

procedure TPainelNascimento.DNascInvalidEntry;
begin
   FAlterado := False;
   ShowMessage('Data de Nascimento Inválida');
end;

procedure TPainelNascimento.Notification(AComponent: TComponent; Operation: TOperation);
begin
   inherited Notification(AComponent, Operation);
   if Operation <> opRemove then
      Exit;
   if AComponent = FmdNascimento then
      FmdNascimento := nil;
   if AComponent = FmdIdade then
      FmdIdade := nil;
   if AComponent = Fmdreferencia then
      Fmdreferencia := nil;
end;

procedure TPainelNascimento.SetDefDataExata(const Value: Boolean);
begin
   FDefDataExata := Value;
   if (not ( csDesigning in ComponentState)) and
      (not (csLoading in ComponentState)) then
      if FDefDataExata then
         GoToDateEdit
      else
         GoToFNP;
end;

function TPainelNascimento.SetIdadeMaxima(Valor, Unidade: string): boolean;
var
   AuxIdade : TIdade;
begin
   Result := False;
   AuxIdade := TIdade.Create(self);
   AuxIdade.SetMedida(Valor, Unidade);
   if FmdIdadeMinima.GTE(AuxIdade) then
      ShowMessage('Idade Maxima não pode ser menor que a Idade Minima')
   else
      begin
         FmdIdadeMaxima.Assign(AuxIdade);
         Result := True;
      end;
end;

function TPainelNascimento.SetIdadeMinima(Valor, Unidade: string): boolean;
var
   AuxIdade : TIdade;
begin
   Result := False;
   AuxIdade := TIdade.Create(self);
   AuxIdade.SetMedida(Valor, Unidade);
   if not FmdIdadeMaxima.GTE(AuxIdade) then
      ShowMessage('Idade Minima não pode ser maior que a Idade Maxima')
   else
      begin
         FmdIdadeMinima.Assign(AuxIdade);
         Result := True;
      end;
end;

procedure TPainelNascimento.SetmdIdade(const Value: TIdade);
begin
   FmdIdade := Value;
   Refresh;
end;

procedure TPainelNascimento.SetmdNascimento(const Value: TMedida);
begin
   FmdNascimento := Value;
   Refresh;
end;

procedure TPainelNascimento.SetmdReferencia(const Value: TMedida);
begin
   FmdReferencia := Value;
   Refresh;
end;

procedure TPainelNascimento.SetNomeMedidaIdade(const Value: string);
begin
   FNomeMedidaIdade := Value;
end;

procedure TPainelNascimento.SetNomeMedidaNascimento(const Value: string);
begin
   FNomeMedidaNascimento := Value;
end;

procedure TPainelNascimento.SetNomeMedidaReferencia(const Value: string);
begin
   FNomeMedidaReferencia := Value;
end;

procedure TPainelNascimento.SetOnChangeIdade(const Value: TNotifyEvent);
begin
   FOnChangeIdade := Value;
end;

//      Validacao de Data Nascimento e Idade
function TPainelNascimento.ValidaIdade(Valor, Unidade: string): boolean;
var
   AuxIdade : TIdade;
begin
   AuxIdade := TIdade.Create(self);
   AuxIdade.SetMedida(Valor, Unidade);
   Result := AuxIdade.GTE(FmdIdadeMinima) and FmdIdadeMaxima.GTE(AuxIdade);
   AuxIdade.Free;
end;

function TPainelNascimento.ValidaNascimento(NewDNasc, Referencia: string): boolean;
var
   AuxIdade : TIdade;
   Nasc, Ref : TMedida;
begin
   Nasc := TMedida.Create(self);
   Nasc.ValorNumerico := NewDNasc;
   Ref := TMedida.Create(self);
   Ref.ValorNumerico := Referencia;
   AuxIdade := TIdade.Create(self, Nasc, Ref);
   Result := not AuxIdade.Empty;
   if Result then
      Result := AuxIdade.GTE(FmdIdadeMinima) and FmdIdadeMaxima.GTE(AuxIdade);
   AuxIdade.free;
   Ref.Free;
   Nasc.Free;
end;

//      DefineDNasc e DefineIdade
function TPainelNascimento.DefineDNasc:boolean;
var
   RefAux, NewNasc : TMedida;
   NewIdade:TIdade;
begin
   Result := False;
   DefinindoNascimento := True;
   RefAux := TMedida.Create(self);
   NewNasc := TMedida.Create(self);
   if Assigned(FmdReferencia) then
      RefAux.ValorNumerico := FmdReferencia.ValorNumerico
   else
      RefAux.ValorNumerico := DateToStr(Date);
   if ValidaNascimento(DateToStr(deNascimento.Date),RefAux.ValorNumerico) then
      begin
         Result := True;
         if Assigned(FmdNascimento) then
         begin
            FmdNascimento.ValorNumerico := DateToStr(deNascimento.Date);
            FmdNascimento.Estimated := False;
         end;
         NewNasc.ValorNumerico := DateToStr(deNascimento.Date);
         NewNasc.Estimated := False;
         if Assigned(FmdIdade) then
            FmdIdade.SetMedida(NewNasc, RefAux);
         NewIdade := TIdade.Create(self, NewNasc, RefAux);
         fnpIdadeValor.Value := NewIdade.AsFloat;
         cbUnidadesIdade.ItemIndex := GetEnumValue(TypeInfo(TUnidadesIdade), NewIdade.Unidade );
         NewIdade.free;
         ChangeIdade;
      end
   else
      DNascInvalidEntry;
   RefAux.Free;
   NewNasc.free;
   DefinindoNascimento := False;
end;

function TPainelNascimento.DefineIdade:boolean;
var
   Today : Tmedida;
   NewIdade : TIdade;
begin
   Result := False;
   DefinindoIdade := True;
   //Verifica Limites
   if ValidaIdade(IntToStr(fnpIdadeValor.AsInteger), GetEnumName(TypeInfo(TUnidadesIdade), cbUnidadesIdade.ItemIndex)) then
   begin
      Result := True;
      if Assigned(FmdIdade) then
      begin
         FmdIdade.ValorNumerico := IntToStr(fnpIdadeValor.AsInteger);
         FmdIdade.Unidade := GetEnumName(TypeInfo(TUnidadesIdade), cbUnidadesIdade.ItemIndex);
      end;
      NewIdade := TIdade.Create(self);
      NewIdade.SetMedida(IntToStr(fnpIdadeValor.AsInteger), GetEnumName(TypeInfo(TUnidadesIdade), cbUnidadesIdade.ItemIndex));
      //Medida de referencia da data atual
      Today := TMedida.Create(self);
      Today.Name := 'mdToday';
      Today.ValorNumerico := DateToStr(Date);
      if Assigned(FmdReferencia) and not FmdReferencia.Empty then
         deNascimento.Date := StrToDate(NewIdade.GetEstimatedDate(FmdReferencia))
      else
         deNascimento.Date := StrToDate(NewIdade.GetEstimatedDate(Today));
      if Assigned(FmdNascimento) then
      begin
         FmdNascimento.ValorNumerico := DateToStr(deNascimento.Date);
         FmdNascimento.Estimated := True;
      end;
      NewIdade.free;
      ChangeIdade;
      Today.free;
   end
   else
      IdadeInvalidEntry;
   DefinindoIdade := False;
end;

//      Rotinas de Change
procedure TPainelNascimento.ChangeIdade;
begin
   if Assigned (FOnChangeIdade) and FAlterado then
      FOnChangeIdade(self);
end;

procedure TPainelNascimento.cbUnidadesIdadeChange(Sender: TObject);
var
   MyIdEst : TMyButtonControl;
begin
   DefineIdade;
   MyIdEst := TMyButtonControl(rbIdadeEstimada);
   MyIdEst.ClicksDisabled := True;
   if not DefinindoNascimento then
   begin
      FAlterado := True;
      MyIdEst.Checked := True;
   end;
end;

procedure TPainelNascimento.deNascimentoChange(Sender: TObject);
var
   MyIdEx : TMyButtonControl;
begin
   MyIdEx := TMyButtonControl(rbIdadeExata);
   MyIdEx.ClicksDisabled := True;
   if not DefinindoIdade then
   begin
      MyIdEx.Checked := True;
      FAlterado := True;
   end;
end;

procedure TPainelNascimento.fnpIdadeValorChange(Sender: TObject);
var
   MyIdEst : TMyButtonControl;
begin
   MyIdEst := TMyButtonControl(rbIdadeEstimada);
   MyIdEst.ClicksDisabled := True;
   if fnpIdadeValor.Text = '' then
   begin
      if FLastKey = '1' then
         SetIdadeSingPlural(1)
      else
         SetIdadeSingPlural(2);
   end
   else
      SetIdadeSingPlural(fnpIdadeValor.AsInteger);
   if not DefinindoNascimento then
   begin
      FAlterado := True;
      MyIdEst.Checked := True;
   end;
end;

//    Rotinas Auxiliares : Refresh e SingularPlural
procedure TPainelNascimento.Refresh;
var
   MyIdEx, MyIdEst : TMyButtonControl;
begin
   MyIdEx := TMyButtonControl(rbIdadeExata);
   MyIdEx.ClicksDisabled := True;
   MyIdEst := TMyButtonControl(rbIdadeEstimada);
   MyIdEst.ClicksDisabled := True;
   if Assigned(mdIdade) and (not mdIdade.Empty) then
   begin
      fnpIdadeValor.Value := mdIdade.SetMelhorValor.AsFloat;
      cbUnidadesIdade.ItemIndex := GetEnumValue(TypeInfo(TUnidadesIdade), mdIdade.SetMelhorValor.Unidade);
   end
   else
   begin
      fnpIdadeValor.Value := 0;
      cbUnidadesIdade.ItemIndex := ord(anos );
   end;
   if Assigned(mdNascimento) then
   begin
      if (not mdNascimento.Empty) then
         deNascimento.Date := StrToDate(mdNascimento.ValorNumerico)
      else
         deNascimento.Date := Now;
      if mdNascimento.Estimated then
         DefineIdade
      else
         DefineDNasc;
   end
   else
   begin
      if Assigned(mdIdade) and (not mdIdade.Empty) then
         deNascimento.Date := StrToDate(mdIdade.GetEstimatedDate(mdReferencia))
      else
         deNascimento.Date:=Now;
//*      MyIdEst.Checked:=True;
      MyIdEx.Checked:=True;
   end;
   FAlterado:=False;
end;

procedure TPainelNascimento.SetIdadeSingPlural(VNum: integer);
var
   OldIndx : Integer;
begin
   with cbUnidadesIdade.Items do
   begin
      OldIndx := cbUnidadesIdade.ItemIndex;
      if VNum = 1 then
      begin
         Clear;
         Add('ano');
         Add('mes');
         Add('dia');
      end
      else
      begin
         Clear;
         Add('anos');
         Add('meses');
         Add('dias');
      end;
      cbUnidadesIdade.ItemIndex:=OldIndx;
   end;
end;

procedure TPainelNascimento.SetModoEnabled(const Value: Boolean);
begin
  FModoEnabled := Value;
end;

end.

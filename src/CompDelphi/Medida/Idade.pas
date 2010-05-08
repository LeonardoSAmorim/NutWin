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
{   Componentes Derivados de TMedida                                 }
{                                                                    }
{   Representa os diversos tipos de medidas                          }
{                                                                    }
{   Copyright © 1997 by DIS-EPM/UNIFESP                              }
{                                                                    }
{ ****************************************************************** }

unit Idade;

interface

uses Classes, SysUtils, Measurement, Controls;

type

   TUnidadesIdade = (anos, meses, dias);

   TIdade = class(TMedida)
   private
   protected
      function DefineStorage:Boolean; override;
      function GetUnidadeApresentacao: String; override;
      function GetValorApresentacao : String; override;
   public
      constructor Create(Owner : TComponent); overload; override;
      constructor Create(Owner : TComponent; Nascimento: TMedida; Referencia : TMedida); reintroduce; overload;
      constructor Create(Owner : TComponent; Nascimento, Referencia : TDate); reintroduce; overload;
      procedure SetValorNumerico(const Value : String); override;
      procedure SetUnidade(const Value : String); override;
      function SetMedida(Valor, Unidade : string): Boolean; overload; override;
      function SetMedida(Nascimento, Referencia : TMedida): Boolean; reintroduce; overload;
      function ConvertToUnit(NewUnit : string): TMedida; override;
      function AsFloatUnit(NewUnit: string) : Double; override;
      function GetEstimatedDate(Referencia : TMedida = nil): string; virtual;
      function GTE(AnOperand : TMedida) : Boolean; overload; override;
      function GTE(AnOperand : TIdade) : Boolean; reintroduce; overload;
      function SetMelhorValor : TMedida;
      function IsThisLeapYear(Reference : TDate): Boolean;
      procedure Loaded; override;
   published
     property Unidade stored True;
   end;

   TAgeLimit = class(TMeasureLimit)
   protected
      function CreatePoint(AOwner : TComponent; PName : string) : TMedida; override;
   end;

   TAgeInterval = class(TMeasurementInterval)
   protected
      function CreateLimit(AOwner : TComponent; LimitName : string) : TMeasureLimit; override;
   end;

   TAgeRanges = class(TMeasurementRanges)
   protected
      function CreateRange(AOwner : TComponent): TMeasurementIntervals; override;
   end;

procedure Register;

implementation

procedure Register;
begin
   { Register TMemoria with Nutricao as its
   default page on the Delphi component palette }
   RegisterComponents('Medida', [TIdade]);
   RegisterComponents('Medida', [TAgeRanges]);
end;

{ TIdade }

function TIdade.ConvertToUnit(NewUnit: string): TMedida;
begin
   //ATENCAO !!!!
   //Empty e' uma propriedade ReadOnly que e' salva no arquivo mais nao
   //e carregada de volta (pois e read only). Nem deveria ser salva, mais como no medida
   //SetEmpty e' um metodo virtual, algum filho pode converte-la em read-write algum dia.
   //O importante e que nao pode ser usada para saber se a medida esta vazia ou nao.
   //   if FEmpty then
   if (InternalStgValue = '') and (FValorNumerico='') then
      begin
         Result := self;
         exit;
      end;
   if NewUnit='anos' then
      begin
         FValorNumerico := FloatToStrF(Int(StrToInt(InternalStgValue)/365), ffFixed, 18, 0);
         FUnidade := 'anos';
      end
   else if NewUnit='meses'then
      begin
         FValorNumerico := FloatToStrF(Round((StrToInt(InternalStgValue)/365)*12), ffFixed, 18, 0);
         FUnidade := 'meses';
      end
   else if NewUnit = 'dias' then
      begin
         FValorNumerico := InternalStgValue;
         FUnidade := 'dias';
      end;
   Result := self;
end;

constructor TIdade.Create(Owner: TComponent);
begin
   inherited;
   InternalStgUnit := 'dias';
end;

constructor TIdade.Create(Owner: TComponent; Nascimento, Referencia: TMedida);
begin
   Create(Owner);
   SetMedida(Nascimento, Referencia);
end;

constructor TIdade.Create(Owner: TComponent; Nascimento, Referencia: TDate);
begin
   if Referencia < Nascimento then
      begin
         FValorNumerico := 'Invalido';
         FEmpty := True;
         exit;
      end;
   InternalStgValue := FloatToStrF(Int(Abs(Referencia-Nascimento)), ffFixed, 18, 0);
   InternalStgUnit := 'dias';
   FEmpty := False;
   if FUnidade = '' then
      FUnidade := 'anos';
   ConvertToUnit(FUnidade);
end;

function TIdade.DefineStorage: Boolean;
begin
   Result := False;
end;

function TIdade.GetEstimatedDate(Referencia: TMedida): string;
var
   Ref : TDate;
begin
   if not Assigned(Referencia) then
      Ref := Date
   else
      Ref := StrToDate(Referencia.ValorNumerico);
   DateSeparator := '/';
   ShortDateFormat := 'dd/mm/yyyy';
   Result := DateToStr(Ref-StrToInt(InternalStgValue)-Round(Int(StrToInt(InternalStgValue)/365)/4));
end;

function TIdade.GetUnidadeApresentacao: String;
begin
   // Idade = 0 não existe
   if (InternalStgValue = '') and (FValorNumerico='') then
      Result := InternalStgUnit
   else
      Result := FUnidade;
end;

function TIdade.GetValorApresentacao: String;
begin
   // Idade = 0 não existe
   if (InternalStgValue = '') and (FValorNumerico='') then
      Result := InternalStgValue
   else
      Result := FValorNumerico;
end;

function TIdade.GTE(AnOperand: TMedida): Boolean;
begin
   Result := (StrToInt(InternalStgValue) >= StrToInt((AnOperand as TIdade).InternalStgValue));
end;

function TIdade.GTE(AnOperand: TIdade): Boolean;
begin
   Result := (StrToInt(InternalStgValue) >= StrToInt(AnOperand.InternalStgValue));
end;

function TIdade.IsThisLeapYear(Reference: TDate): Boolean;
var
   Yr, Mnth, Day: Word;
begin
   DecodeDate(Reference, Yr, Mnth, Day);
   Result := IsLeapYear(Yr);
end;

procedure TIdade.Loaded;
begin
   inherited;
   SetMelhorValor;
end;

function TIdade.SetMedida(Nascimento, Referencia: TMedida): Boolean;
var
   NascDate : TDate;
   Ref : TDate;
begin
   DateSeparator := '/';
   ShortDateFormat := 'dd/mm/yyyy';
   if not Assigned(Nascimento) then
      begin
         FValorNumerico := 'Invalido';
         FEmpty := True;
         Result := False;
         exit;
      end;
   NascDate := StrToDate(Nascimento.ValorNumerico);
   if not Assigned(Referencia) then
      Ref := Date
   else
      Ref := StrToDate(Referencia.ValorNumerico);
   if Ref < NascDate then
      begin
         FValorNumerico := 'Invalido';
         FEmpty := True;
         Result := False;
         exit;
      end;
   InternalStgValue :=  FloatToStrF (Int(Abs(Ref-NascDate)), ffFixed, 18, 0);
   InternalStgUnit := 'dias';
   Result := True;
   FEmpty := False;
   // Estou chegando a idade a partir de datas, portanto
   // eu defino a unidade da idade
   if FUnidade = '' then
      FUnidade := 'anos';
   ConvertToUnit( 'anos' ); // FUnidade
   // Converte até chegar num valor <> 0  se não for 0
   // para menores de 3 anos deixar em meses
   if ( AsFloat < 3 ) and ( StrToFloat(InternalStgValue) > 0 ) then
   begin
      FUnidade := 'meses';
      ConvertToUnit(FUnidade);
      if AsFloat = 0  then
      begin
         FUnidade := 'dias';
         ConvertToUnit(FUnidade);
      end;
   end
end;

function TIdade.SetMedida(Valor, Unidade: string): Boolean;
begin
   Result := inherited SetMedida(Valor, Unidade);
   SetValorNumerico(FValorNumerico);
end;

function TIdade.SetMelhorValor: TMedida;
begin
   //ATENCAO !!!!
   //Empty e' uma propriedade ReadOnly que e' salva no arquivo mais nao
   //e carregada de volta (pois e read only). Nem deveria ser salva, mais como no medida
   //SetEmpty e' um metodo virtual, algum filho pode converte-la em read-write algum dia.
   //O importante e que nao pode ser usada para saber se a medida esta vazia ou nao.
   //   if FEmpty then
   if (InternalStgValue = '') and (FValorNumerico = '') then
      begin
         Result := self;
         exit;
      end;
   if FUnidade = '' then
      FUnidade := 'anos';
//*   ConvertToUnit(FUnidade);
   Result := ConvertToUnit(FUnidade); //*
{*   Result := ConvertToUnit('anos');
   if Result.ValorNumerico = '0' then
      Result := ConvertToUnit('meses')
   else if Result.ValorNumerico = '0' then
      Result := ConvertToUnit('dias');}
end;

procedure TIdade.SetUnidade(const Value: String);
begin
   inherited;
   SetValorNumerico(FValorNumerico);
end;

function TIdade.AsFloatUnit(NewUnit: string) : Double;
begin
   with TIdade.Create(nil) do
     try
        Assign(self);
        ConvertToUnit(NewUnit);
        Result := AsFloat;
     finally
        Free;
     end;
end;

procedure TIdade.SetValorNumerico(const Value: String);
var
   E : Integer;
   IntValue : Integer;
begin
   //Se for string vazio, nao e' um numero, mais estao querendo
   //apagar o valor
   if Value = '' then
      begin
         inherited;
         exit;
      end;
   //Se nao e' um string vazio, verifique se e um numero
   //Se for, ja fica convertido
   Val(Value, IntValue, E);
   if E <> 0 then
      exit;
   //OK. Processe
   inherited;
   InternalStgUnit := 'dias';
   if FUnidade = 'anos' then
      begin
         InternalStgValue := FloatToStrF(Int(StrToInt(Value)*365), ffFixed, 18, 0);
      end
   else if FUnidade='meses'then
      begin
         InternalStgValue := FloatToStrF(Int((StrToInt(Value)/12)*365), ffFixed, 18, 0);
      end
   else if FUnidade = 'dias' then
      begin
         InternalStgValue := Value;
      end;
end;

{ TAgeLimit }

function TAgeLimit.CreatePoint(AOwner: TComponent; PName: string): TMedida;
begin
   Result := TIdade.Create(AOwner, TDate(date), TDate(date));
   Result.name := PName;
end;

{ TAgeInterval }

function TAgeInterval.CreateLimit(AOwner: TComponent; LimitName: string): TMeasureLimit;
begin
   Result := TAgeLimit.Create(AOwner, LimitName);
end;

{ TAgeRanges }

function TAgeRanges.CreateRange(AOwner: TComponent): TMeasurementIntervals;
begin
   Result := TMeasurementIntervals.Create(self, TAgeInterval);
end;

end.

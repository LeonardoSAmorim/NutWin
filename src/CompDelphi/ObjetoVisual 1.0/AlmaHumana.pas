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
{   Delphi component TAlmaHumana                                     }
{                                                                    }
{   Alma Humana                                                      }
{                                                                    }
{   Copyright © 1997 by Nutrição DIS-EPM/UNIFESP                     }
{                                                                    }
{ ****************************************************************** }

unit AlmaHumana;

interface

uses SysUtils, Classes, Graphics, Controls, Measurement, Memoria, Idade;

type

   EInconsistencia = class(Exception);

   TAlmaHumana = class(TComponent)
   private
      FGUID: string;
      FSexo: string;
      FNome: string;
      FDataNascimento: TDate;
      FRepositorio: TMemoria;
      procedure SetDataNascimento(const Value: TDate);
      procedure SetGUID(const Value: string);
      procedure SetNome(const Value: string);
      procedure SetRepositorio(const Value: TMemoria);
      procedure SetSexo(const Value: string);
      procedure SetIdade (NovaIdade : string);
   protected
      procedure Notification(AComponent : TComponent; Operation : TOperation); override;
      function GetIdade : string;
   public
      procedure UpdateRepositorio;
      procedure Refresh;
      function IdadeAsIdade : TIdade;
   published
      property GUID : string read FGUID write SetGUID;
      property Nome : string read FNome write SetNome;
      property Sexo : string read FSexo write SetSexo;
      property DataNascimento : TDate read FDataNascimento write SetDataNascimento;
      property Repositorio : TMemoria read FRepositorio write SetRepositorio;
      property Idade : string read GetIdade write SetIdade;
   end;

procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('Calculadora', [TAlmaHumana]);
end;

{ TAlmaHumana }
function TAlmaHumana.GetIdade : string;
begin
   Result := IdadeAsIdade.ValorNumerico;
end;

function TAlmaHumana.IdadeAsIdade: TIdade;
var
   Ref : TDate;
   Visita : TMedida;
   SemRep : boolean;
begin
   SemRep := False;
   Ref := Date;
   if not Assigned(FRepositorio) then
   begin
      Ref := Date;
      SemRep := True;
   end
   else
   begin
   if FRepositorio.Acha('mdDataCalc', TObject(Visita)) then
      if Assigned(Visita) then
      begin
         if Visita.Empty then
            Ref := Date
         else
            Ref := StrToDate(Visita.ValorNumerico);
         end;
      end;
   Result := TIdade.Create(Owner, FDataNascimento, Ref);
   if SemRep and (FDataNascimento = 0) then
      Result.Clear;
end;

procedure TAlmaHumana.Notification(AComponent: TComponent; Operation: TOperation);
begin
   inherited Notification(AComponent, Operation);
   if Operation <> opRemove then
      Exit;
   if AComponent = FRepositorio then
      FRepositorio := nil;
end;

procedure TAlmaHumana.Refresh;
var
   NovoValor : TMedida;
begin
   if not Assigned(FRepositorio) then
      exit;
   if FRepositorio.Acha('mdSexo',TObject(NovoValor)) then
      if Assigned(NovoValor) then
      begin
         if NovoValor.Empty then
            FSexo := ''
         else
            FSexo := NovoValor.ValorNumerico;
      end;
   if FRepositorio.Acha('mdDataNascimento', TObject(NovoValor)) then
      if Assigned (NovoValor) then
      begin
         if NovoValor.Empty then
            FDataNascimento:=0
         else
            FDataNascimento := StrToDate(NovoValor.ValorNumerico);
      end;
   if FRepositorio.Acha('mdNomeIndividuo',TObject(NovoValor)) then
      if Assigned(NovoValor) then
      begin
         if NovoValor.Empty then
            FNome:=''
         else
            FNome:=NovoValor.ValorNumerico;
      end;
   if FRepositorio.Acha('mdGUIDIndividuo',TObject(NovoValor)) then
      if Assigned(NovoValor) then
      begin
         if NovoValor.Empty then
            FGUID := ''
         else
            FGUID := NovoValor.ValorNumerico;
      end;
end;

procedure TAlmaHumana.SetDataNascimento(const Value: TDate);
begin
   FDataNascimento := Value;
end;

procedure TAlmaHumana.SetGUID(const Value: string);
begin
   FGUID := Value;
end;

procedure TAlmaHumana.SetIdade(NovaIdade: string);
begin
//   ReadOnly
end;

procedure TAlmaHumana.SetNome(const Value: string);
begin
   FNome := Value;
end;

procedure TAlmaHumana.SetRepositorio(const Value: TMemoria);
begin
   FRepositorio := Value;
end;

procedure TAlmaHumana.SetSexo(const Value: string);
begin
   FSexo := Value;
end;

procedure TAlmaHumana.UpdateRepositorio;
var
   NovoValor : TMedida;
begin
   if FRepositorio.Acha ('mdSexo',TObject(NovoValor)) then
   begin
//      if NovoValor.Empty then
      NovoValor.ValorNumerico := FSexo
//      else
//         if NovoValor.ValorNumerico <> FSexo then
//            raise EInconsistencia.Create('Os Valores do Individuo diferentes do armazenado durante o calculo');
   end;
   if FRepositorio.Acha ('mdDataNascimento',TObject(NovoValor)) then
   begin
//      if NovoValor.Empty then
      NovoValor.ValorNumerico := DateToStr (FDataNascimento)
//      else
//         if NovoValor.ValorNumerico <> DateToStr(FDataNascimento) then
//            raise EInconsistencia.Create('Os Valores do Individuo diferentes do armazenado durante o calculo');
   end;
   if FRepositorio.Acha ('mdNomeIndividuo',TObject(NovoValor)) then
   begin
//      if NovoValor.Empty then
      NovoValor.ValorNumerico := FNome
//      else
//         if NovoValor.ValorNumerico <> FNome then
//            raise EInconsistencia.Create('Os Valores do Individuo diferentes do armazenado durante o calculo');
   end;
   if FRepositorio.Acha ('mdGUIDIndividuo',TObject(NovoValor)) then
   begin
//      if NovoValor.Empty then
      NovoValor.ValorNumerico := FGUID
//      else
//         if NovoValor.ValorNumerico <> FGUID then
//            raise EInconsistencia.Create('Os Valores do Individuo diferentes do armazenado durante o calculo');
   end;
end;

end.

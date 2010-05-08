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




{ **********************************************************************}
{                                                                       }
{   Delphi component TMacroNut                                          }
{                                                                       }
{   Calcula Macro Nutrientes                                            }
{                                                                       }
{   Copyright © 1998 by DIS-EPM/UNIFESP                                 }
{                                                                       }
{ **********************************************************************}

unit MacroNut;

interface

uses SysUtils, Classes, DB;

type
   TMacroNut = class(TComponent)
   private
      FDataField: String;
      FIDLipideos: String;
      FIDCarboidratos: String;
      FDataSource: TDataSource;
      FDataValue: String;
      FIDProteinas: String;
      FIDEnergia: String;
      procedure SetDataField(const Value: String);
      procedure SetDataSource(const Value: TDataSource);
      procedure SetIDCarboidratos(const Value: String);
      procedure SetIDLipideos(const Value: String);
      procedure SetDataValue(const Value: String);
      procedure SetIDProteinas(const Value: String);
      procedure SetIDEnergia(const Value: String);
   protected
   public
      Energia : Double;
      Proteinas : Double;
      Carboidratos : Double;
      Lipideos : Double;
      PorcentagemProteinas : Double;
      PorcentagemCarboidratos : Double;
      PorcentagemLipideos : Double;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function Calcular : Boolean;
   published
      property DataSource : TDataSource read FDataSource write SetDataSource;
      property DataField : String read FDataField write SetDataField;
      property DataValue : String read FDataValue write SetDataValue;
      property IDEnergia : String read FIDEnergia write SetIDEnergia;
      property IDProteinas : String read FIDProteinas write SetIDProteinas;
      property IDCarboidratos : String read FIDCarboidratos write SetIDCarboidratos;
      property IDLipideos : String read FIDLipideos write SetIDLipideos;
   end;

procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('Nutricao', [TMacroNut]);
end;

{ TMacroNut }

function TMacroNut.Calcular: Boolean;
var
   FTotCalPCL : Double;
   FCalPro : Double;
   FCalCarb : Double;
   FCalLip : Double;
begin
   if Assigned( FDataSource ) and (FDataField <> '') and (FDataValue <> '') and
      Assigned(FDataSource.DataSet) and (FDataSource.DataSet.Active )then
   with FDataSource do
   begin
      if DataSet.Locate( FDataField, FIDEnergia, [] ) then
         Energia := DataSet.FieldByName( FDataValue ).AsFloat
      else
         Energia := 0;
      if DataSet.Locate( FDataField, FIDProteinas, [] ) then
         Proteinas := DataSet.FieldByName( FDataValue ).AsFloat
      else
         Proteinas := 0;
      if DataSet.Locate( FDataField, FIDCarboidratos, [] ) then
         Carboidratos := DataSet.FieldByName( FDataValue ).AsFloat
      else
         Carboidratos := 0;
      if DataSet.Locate( FDataField, FIDLipideos, [] ) then
         Lipideos := DataSet.FieldByName( FDataValue ).AsFloat
      else
         Lipideos := 0;
   end;
   FCalPro := Proteinas * 4;
   FCalCarb := Carboidratos * 4;
   FCalLip := Lipideos * 9;
   FTotCalPCL := FCalPro + FCalCarb + FCalLip;
   if FTotCalPCL > 0 then
     begin
      PorcentagemProteinas := FCalPro / FTotCalPCL * 100;
      PorcentagemCarboidratos := FCalCarb / FTotCalPCL * 100;
      PorcentagemLipideos := FCalLip / FTotCalPCL * 100;
      Result := True;
     end
   else
     begin
        PorcentagemProteinas := 0;
        PorcentagemCarboidratos := 0;
        PorcentagemLipideos := 0;
        Result := False;
     end;
end;

constructor TMacroNut.Create(AOwner: TComponent);
begin
   inherited Create( AOwner );
end;

destructor TMacroNut.Destroy;
begin
   inherited Destroy;
end;

procedure TMacroNut.SetDataField(const Value: String);
begin
   FDataField := Value;
end;

procedure TMacroNut.SetDataSource(const Value: TDataSource);
begin
   FDataSource := Value;
end;

procedure TMacroNut.SetDataValue(const Value: String);
begin
   FDataValue := Value;
end;

procedure TMacroNut.SetIDCarboidratos(const Value: String);
begin
   FIDCarboidratos := Value;
end;

procedure TMacroNut.SetIDEnergia(const Value: String);
begin
   FIDEnergia := Value;
end;

procedure TMacroNut.SetIDLipideos(const Value: String);
begin
   FIDLipideos := Value;
end;

procedure TMacroNut.SetIDProteinas(const Value: String);
begin
   FIDProteinas := Value;
end;

end.

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
{   Delphi DataModule DMDescMgr                                      }
{                                                                    }
{   Copyright © 1997 by DIS-EPM/UNIFESP                              }
{                                                                    }
{ ****************************************************************** }

unit DMDescMgr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, DBTables;

type
  TDMDescritor = class(TDataModule)
    DSDescritor: TDataSource;
    Parametros: TTable;
    Valores: TTable;
    Descritores: TTable;
    DSParam: TDataSource;
    DSValores: TDataSource;
    DSDscrQt: TDataSource;
    Fontes: TTable;
    DescritoresCodigo: TStringField;
    DescritoresDescricao: TStringField;
    DSFontes: TDataSource;
    DescritoresFonte: TStringField;
    DescritoresFontes: TStringField;
    Medidas: TTable;
    DscQuantitativo: TTable;
    ParametrosCodQtyParm: TStringField;
    ParametrosUnidade: TStringField;
    ParametrosVALOR: TStringField;
    ParametrosDescritor: TStringField;
    ParametrosCodDscr: TStringField;
    ParametrosParametro: TStringField;
    DscQuantitativoCodDscr: TStringField;
    DscQuantitativoUnidadeVDep: TStringField;
    DscQuantitativoVarIndependente: TStringField;
    DscQuantitativoUnidadeVIndep: TStringField;
    DscQuantitativoDescritor2: TStringField;
    DscQuantitativoMedida2: TStringField;
    DscQuantitativoVIndep: TStringField;
    FontesFonte: TStringField;
    FontesDescricao: TStringField;
    DscQuantitativoMinVIndep: TStringField;
    DscQuantitativoMaxVIndep: TStringField;
    DscQuantitativoTipoIntervalo: TStringField;
    DscQuantitativoDelta: TFloatField;
    ValoresDscrID: TStringField;
    ValoresIntervalBegin: TFloatField;
    ValoresIntervalEnd: TFloatField;
    ValoresNormal: TFloatField;
    ValoresMean: TFloatField;
    ValoresStdDev: TFloatField;
    DescritoresRESPONSAVEL: TStringField;
    ValoresDESCRITOR: TStringField;
    DscQuantitativoVALORDEPENDENTE: TStringField;
    DescritoresDATACRIACAO: TDateTimeField;
    DescritoresULTIMAALTERACAO: TDateTimeField;
    ValoresINTERVALO: TIntegerField;
    DBDescritor: TDatabase;
    procedure DMDescritorCreate(Sender: TObject);
  private
  public
  end;

implementation

uses uAliasName;

{$R *.DFM}

procedure TDMDescritor.DMDescritorCreate(Sender: TObject);
begin
DBDescritor.AliasName := BDE_ALIAS_NAME;
end;

end.

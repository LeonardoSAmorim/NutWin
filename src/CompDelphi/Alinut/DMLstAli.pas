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
{   Datamodule do TCustomListaAlimento                                  }
{                                                                       }
{   Acesso as tabelas de Alimentos                                      }
{                                                                       }
{   Copyright © 1998 by DIS-EPM/UNIFESP                                 }
{                                                                       }
{ **********************************************************************}

unit DMLstAli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, stdctrls;

type
  TDMListaAlimento = class(TDataModule)
    dsGruAli: TDataSource;
    taGruAli: TTable;
    taNut: TTable;
    dsNut: TDataSource;
    taNutIDNUT: TStringField;
    taNutABREV: TStringField;
    taNutNOMENUT: TStringField;
    taNutUNIDADE: TStringField;
    taGruAliIDGRUALI: TStringField;
    taGruAliNOMEGRU: TStringField;
    dsQAli: TDataSource;
    dsOrigem: TDataSource;
    taOrigem: TTable;
    quAli: TQuery;
    dsUsuario: TDataSource;
    taUsuario: TTable;
    taUsuarioUsername: TStringField;
    taUsuarioSenha: TStringField;
    taOrigemIDORIG: TStringField;
    taOrigemDESCRICAO: TStringField;
    taAliGProt: TTable;
    taAliGProtIDALI: TStringField;
    taAliGProtIDGRUPROT: TStringField;
    taAliGProtIDMEDCAS: TStringField;
    taAliGProtQTDE: TStringField;
    taAliGProtMEDGR: TStringField;
    taAliGCal: TTable;
    taAliGCalIDALI: TStringField;
    taAliGCalIDGRUCAL: TStringField;
    taAliGCalIDMEDCAS: TStringField;
    taAliGCalQTDE: TStringField;
    taAliGCalMEDGR: TStringField;
  private
  public
  end;

var
  DMListaAlimento: TDMListaAlimento;

implementation

{$R *.DFM}

end.
 
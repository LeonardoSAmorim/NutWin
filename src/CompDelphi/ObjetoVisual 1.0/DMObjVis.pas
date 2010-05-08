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
{   DataModule TDMOV                                                 }
{                                                                    }
{   Copyright © 1997 by Nutrição DIS-EPM/UNIFESP                     }
{                                                                    }
{ ****************************************************************** }

unit DMObjVis;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     DB, DBTables;

type
  TDMOV = class(TDataModule)
    taVista: TTable;
    dsVista: TDataSource;
    dsAreaClick: TDataSource;
    taAreaClick: TTable;
    taAreaVista: TTable;
    dsAreaVista: TDataSource;
    dsCursores: TDataSource;
    taCursores: TTable;
    dsObjVis: TDataSource;
    taObjVis: TTable;
    taAreaVistaOBJETO: TStringField;
    taAreaVistaOVORDEM: TFloatField;
    taAreaVistaOVAREA: TStringField;
    taAreaVistaOVTOP: TFloatField;
    taAreaVistaOVLEFT: TFloatField;
    taAreaVistaOVHEIGHT: TFloatField;
    taAreaVistaOVWIDTH: TFloatField;
    taAreaVistaOVCAPTION: TStringField;
    taAreaVistaAREACLICK: TStringField;
    taObjVisOBJETO: TStringField;
    taObjVisVISTAINICIAL: TFloatField;
    taObjVisTOTALVISTAS: TFloatField;
    taAreaClickOVAREA: TStringField;
    taAreaClickDESCRICAO: TStringField;
    taAreaClickOVCURSOR: TStringField;
    taAreaClickAVI: TGraphicField;
    taVistaOBJETO: TStringField;
    taVistaOVORDEM: TFloatField;
    taVistaOVPICTURE: TGraphicField;
    taMedCorpo: TTable;
    taMedParte: TTable;
    taFaixaEtaria: TTable;
    taSexoIdadeCorp: TTable;
    taMedida: TTable;
    taAreaClickINSTRUCOES: TMemoField;
  private
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
  public
    property Active : Boolean read FActive write SetActive;
  end;

var
  DMOV: TDMOV;

implementation

{$R *.DFM}

{ TDMOV }

procedure TDMOV.SetActive(const Value: Boolean);
begin
   if (csLoading in ComponentState) then
   begin
//      dbOV.Connected := False;
      FActive := False;
      exit;
   end;
   if FActive <> Value then
   begin
      FActive:=Value;
      if Value then
      begin
//         if dbOV.Connected then // Jah conectado
//            FActive := True
//         else // Conectar!
         begin
//            dbOV.DataBaseName := 'DB'+self.Name;
//            dbOV.Connected := True;
//            if ( dbOV.Connected ) then
            begin
{                taVista.DataBaseName := dbOV.DataBaseName;
                 taAreaClick.DataBaseName := dbOV.DataBaseName;
                 taAreaVista.DataBaseName := dbOV.DataBaseName;
                 taCursores.DataBaseName := dbOV.DataBaseName;
                 taObjVis.DataBaseName := dbOV.DataBaseName;
                 taMedCorpo.DataBaseName:= dbOV.DataBaseName;
                 taMedParte.DataBaseName:= dbOV.DataBaseName;
                 taFaixaEtaria.DataBaseName:= dbOV.DataBaseName;
                 taSexoIdadeCorp.DataBaseName:= dbOV.DataBaseName;
                 taMedida.DatabaseName := dbOV.DataBaseName;
}
               taVista.Open;
               taAreaClick.Open;
               taAreaVista.Open;
               taCursores.Open;
               taObjVis.Open;
               taMedCorpo.Open;
               taMedParte.Open;
               taFaixaEtaria.Open;
               taSexoIdadeCorp.Open;
               taMedida.Open;
               FActive := True;
            end;
         end;
      end
      else
      begin
         taVista.Close;
         taAreaClick.Close;
         taAreaVista.Close;
         taCursores.Close;
         taObjVis.Close;
         taMedCorpo.Close;
         taMedParte.Close;
         taFaixaEtaria.Close;
         taSexoIdadeCorp.Close;
         taMedida.Close;
      end;
   end;
end;

end.

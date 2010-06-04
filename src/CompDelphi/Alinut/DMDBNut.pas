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




unit DMDBNut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables,CCSListaLinks,CCSDBListaLinks, Db;

type
  TdmDataBasesNut = class(TDataModule)
    dbOrg1: TDatabase;
  private
    FRestauraActive: Boolean;
    procedure SetRestauraActive(const Value: Boolean);
    { Private declarations }
  protected
  public
    { Public declarations }
    property RestauraActive : Boolean read FRestauraActive write SetRestauraActive;
    procedure DefineDM( DM : TComponent );
  end;
  procedure OpenTables( DM : TComponent );
  procedure CloseTables( DM : TComponent );

var
  dmDataBasesNut: TdmDataBasesNut;

implementation

{$R *.DFM}

{ TdmDataBasesNut }

procedure OpenTables( DM : TComponent );
var
I : integer;
begin
  for I:=0 to DM.ComponentCount -1 do
    if (DM.Components[I] is TDBDataSet) then
       TDBDataSet(DM.Components[I]).Open;
end;

procedure CloseTables( DM : TComponent );
var
I : integer;
begin
  for I:=0 to DM.ComponentCount -1 do
    if (DM.Components[I] is TDBDataSet) then
       TDBDataSet(DM.Components[I]).Close;
end;

procedure TdmDataBasesNut.DefineDM( DM : TComponent );
var
I, J : integer;
EstavaAberto : Boolean;
begin
  // Se apontou para um DataModule
  if Assigned(DM) then
  begin
     // Varre todos os DataBases novos
     for J := 0 to Self.ComponentCount -1 do
         if (Self.Components[J] is TDatabase) then
            // Varre todos os TDBDataSets do DataModule
            for I:=0 to DM.ComponentCount -1 do
                // Se os tags do DataBase (J) for igual ao DBDataSet (I)
                if (DM.Components[I] is TDBDataSet) and
                   ( Self.Components[J].Tag = DM.Components[I].Tag ) then
                begin
                   // Guarda estado para restaurar depois
                   EstavaAberto := TDBDataSet(DM.Components[I]).Active;
                   // seta novo DataBase
                   TDBDataSet(DM.Components[I]).Close;
                   TDBDataSet(DM.Components[I]).DatabaseName :=
                              TDatabase(Self.Components[J]).DatabaseName;
                   // Restaura estado do DBDataSet
                   if EstavaAberto and RestauraActive then
                      TDBDataSet(DM.Components[I]).Open;
                end
                else
                // Se for um componente CCSDBListaLinks tambem seta o seu DataBase
                if (DM.Components[I] is TCCSDBListaLinks) {and
                   ( Self.Components[J].Tag = DM.Components[I].Tag ) }then
                     TCCSDBListaLinks(DM.Components[I]).Database :=
                                      TDatabase(Self.Components[J]);

     // Desconecta todos os DataBase não usados (Tag<>0)
     for J := 0 to DM.ComponentCount -1 do
         if (DM.Components[J] is TDatabase) {and ( DM.Components[J].Tag <> 0 )} then
            TDatabase(DM.Components[J]).Connected := False;
   end;
end;

procedure TdmDataBasesNut.SetRestauraActive(const Value: Boolean);
begin
  FRestauraActive := Value;
end;

end.
 
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




unit PersistentCollectionReg;
{ ****************************************************************** }
{                                                                    }
{   PersistentCollectionReg.pas                                      }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   21/Marco/1999                                                    }
{                                                                    }
{ ****************************************************************** }
{
      Esta Unit foi montada para poder separar o editor de propriedade  do  per-
sistenteCollection, e com isso evitar as referencias circulares que ocorriam.
}

interface

uses
   Classes, Forms, DbTables, SysUtils, DsgnIntf, Edx02, PersistentCollection, MapPersistent;

type

  TMapProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TMapEditor = class(TDefaultEditor)
  private
  protected
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;



procedure Register;

implementation

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TMapPersistent), TCustomObjectSet, 'Map', TMapProperty);
end;

{
       Implementacao do editor de propriedades para carregar setar as listass

}

procedure TMapProperty.Edit;
var
  xMap : TMapPersistent;
  MapEditor: TFrmMapDialog02;
  FComponent : TComponent;
begin
   //este metodo acontece sempre que preciona os ... do object inspector
   //o primeiro componente da lsita e o componente dona da property
   FComponent := TComponent(GetComponent(0));
//   try
    //devolve a instacia da classe de ItemsDefault criado pelo component editado
    xMap := TMapPersistent(GetOrdValue);
    MapEditor := TFrmMapDialog02.Create(Application);
//    try
      //indicacao do control que ele tera de avaliar
      MapEditor.Control := TObjectSet(FComponent).Objeto;
      MapEditor.DataBaseName := TQuery(FComponent).DataBaseName;
      MapEditor.IndexEditor := ord(TObjectSet(FComponent).MapStyle);
      MapEditor.SQL.Assign(TQuery(FComponent).SQL);
      TObjectSet(FComponent).SetSQLOfIndex(TQuery(FComponent).SQL, 0);
      MapEditor.Map := xMap;
      MapEditor.ShowModal;

      //colocar quando o apply ja testar se existe antes
      //TObjectPersistent(TObjectSet(FComponent).Objeto).ApplyReference;

//     finally
      // mesmo qdo ocorrer erro o finally sera executado para limpar a memoria
      MapEditor.Free;
//     end;
{     except
       begin
          if TObjectSet(FComponent).DataBaseName <> '' then
             MessageDlg('Erro ao Iniciar Editor de Permissoes Default.', mtError, [mbOK], 0)
          else
             MessageDlg('DataBase deve ser setado.', mtError, [mbOK], 0);
       end;
    end;
}
end;

function TMapProperty.GetAttributes: TPropertyAttributes;
//defini o tipo de propriedade do objeto
begin
  Result := [paDialog, paSubProperties];
end;

procedure TMapEditor.EditProperty(PropertyEditor: TPropertyEditor;var Continue, FreeEditor: Boolean);
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'Map') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;

function TMapEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TMapEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Map'
  else Result := '';
end;

procedure TMapEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;

end.

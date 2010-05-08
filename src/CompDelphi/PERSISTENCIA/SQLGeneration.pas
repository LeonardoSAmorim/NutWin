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




unit SQLGeneration;
{ ****************************************************************** }
{                                                                    }
{   MapBinding.pas                                                   }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   06/Janeiro/20000                                                 }
{                                                                    }
{ ****************************************************************** }
{
 NOTAS
      01 - Os objetos desta unit foram retirados do editor de propriedades do
      mapeamento da persistencia

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Generation,
  MapPersistent, MapBinding, rtti;

type
  TGerarSQL = (gsSelect, gsCreate, gsDrop, gsInsert, gsUpdate, gsDelete);
  TKindSGDB = (ksInterbase, ksOracle);

//  TFieldKindSGDB = (fksString, fksDate, fksInteger);


  TSQLGeneration = class(TGeneration)
  private
    FMap: TMapPersistent;
    FResultSQL: TStrings;
    FBinding: TBinding;
    FMapComponent: TComponent;
    FSGDB : string;
    FMakebinding : boolean;
    procedure SetMap(const Value: TMapPersistent);
    procedure SetResultSQL(const Value: TStrings);
    function GetResultSQL : TStrings;
    procedure SetBinding(const Value: TBinding);
    procedure SetMapComponent(const Value: TComponent);
    function LenOfTypeOfSGDB(xType : string) : integer;
    function KeyOfSGDB : string;
    { Private declarations }
  protected
    { Protected declarations }
    FListaClassProperty : TStrings;
    FListaObjetos : TStrings;
    FListaProperty : TStrings;
    procedure DoBind(xMap : TMapPersistent; xMapComponent : TComponent; xMerge : boolean); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    //ponteiro para o mapiamento em memoria do componente
    function GetCompName(xClassName : string): string;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor destroy; override;
    procedure DoBinding;
    function MergeMap(xMap : TMapPersistent; xMapComponent : TComponent) : integer;
    function GerarSQL(TipoSQL : TGerarSql) : integer; virtual; abstract;
    function FirstSQL(TipoSQL : TGerarSQL) : boolean;
    function NextSQL(TipoSQL : TGerarSQL) : boolean;
    property Map : TMapPersistent read FMap write SetMap;
    property Binding : TBinding read FBinding write SetBinding;
  published
    { Published declarations }
    property ResultSQL : TStrings read GetResultSQL write SetResultSQL;
  //ponteiro para o mapiamento persistente  do component
    property MapComponent : TComponent read FMapComponent write SetMapComponent;
  end;


  TDMLGeneration = class(TSQLGeneration)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    function GerarSQL(TipoSQL : TGerarSql) : integer; override;
  published
    { Published declarations }
  end;

  TDDLGeneration = class(TSQLGeneration)
  private
    FMapDateFormat: String;
    FUseParam: boolean;
    { Private declarations }
    procedure CreateCreate;
    procedure CreateDrop;
    procedure CreateInsert;
    procedure CreateUpdate;
    procedure CreateDelete;
    procedure SetMapDateFormat(const Value: String);
    procedure SetUseParam(const Value: boolean);
  protected
    { Protected declarations }
  public
    { Public declarations }
    function GerarSQL(TipoSQL : TGerarSql) : integer; override;
  published
    { Published declarations }
    property MapDateFormat : String read FMapDateFormat write SetMapDateFormat;
    property UseParam : boolean read FUseParam write SetUseParam;
  end;

procedure Register;
const
  {
     Tipos de atributos suportados pelos seus respectivos bancos seguindo a ordem
  temos 0=paradox, 1=interbase, 2=oracle, com estes types o desenvolvedor pode-ra
  indicar qual e o tipo da property no banco respectivo, o edx sera capaz de iden-
  tificar o banco e colocar a lista correta de tipos para o mapiamento e para mon-
  tagem da DDL.
  }
  cPonto : char = '.';
  ArrayTypeOfSGDB: array[0..2, 0..14] of PChar =
  (
  ('SMALLINT',     'INTEGER',  'DECIMAL',         'NUMERIC',   'FLOAT',   'CHARACTER',
   'VARCHAR',      'DATE',     'BOOLEAN',         'BLOB',      'TIME',    'TIMESTAMP',
   'MONEY',        'AUTOINC',  'BYTES'),

  ('SHORT',        'FLOAT',    'DOUBLE PRECISION','CHAR',      'VARCHAR', 'DATE',
   'BLOB',         'ARRAY',    'NUMERIC',         '',          '',        '',
   '',             '',         ''),

  ('CHAR',         'RAW',      'DATE',            'NUMBER',    'LONG',    'LONG RAW',
   'FLOAT',        'VARCHAR2', 'VARCHAR',         '',          '',        '',
   '',             '',         '')
   );
   {
        Array indicando se o tipo precisa da indicacao de tamanho ou nao e se precisa
   quantos argumentos usa sendo que 0=nao precisa de argumento, 1=apenas o tamanho,
   2=tamanho e outro argumento.
   }
  ArrayLenOfSGDB: array[0..2, 0..14] of integer =
  (
  (0,              0,          2,                 2,           2,         1,
   1,              0,          0,                 2,           0,         0,
   0,              0,          1),

  (0,              0,          0,                 1,           1,         0,
   0,              0,          1,                -1,          -1,        -1,
  -1,             -1,         -1),

  (1,             1,           0,                 1,           0,         0,
   0,             1,           1,                -1,          -1,        -1,
  -1,            -1,          -1)
   );


implementation

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TDMLGeneration]);
  RegisterComponents('CCS-SIS', [TDDLGeneration]);
end;

{ TSQLGeneration }

procedure TSQLGeneration.DoBinding;
begin
  if assigned(FMap) and assigned(FMapComponent) then
  begin
    FBinding.Clear;
    FBinding.ObjectCount := 0;
    DoBind(FMap, FMapComponent, False);
  end else
      raise Exception.Create('DoBinding - Falta setar os objetos!');

end;

constructor TSQLGeneration.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FBinding := TBinding.Create;
  FResultSQL := TStringList.Create;
  FListaClassProperty := TStringList.Create;
  FListaProperty := TStringList.Create;
  FListaObjetos := TStringList.Create;

end;

destructor TSQLGeneration.destroy;
begin
  FResultSQL.Free;
  FBinding.Free;
  FListaClassProperty.Free;
  FListaProperty.Free;
  FListaObjetos.Free;
  inherited destroy;
end;

procedure TSQLGeneration.DoBind(xMap : TMapPersistent; xMapComponent : TComponent; xMerge : boolean);
var
  FRTTI : TRTTI;
  FMapAux : TMap;
  i, j, k, l, PosIndx : integer;
begin
  // Cria Objetos locais
  if assigned(xMap) and assigned(xMapComponent) then
  begin
    FMapAux := TMap.Create;
    FRTTI := TRTTI.Create(nil);
    FRTTI.control := xMapComponent;
    FListaClassProperty.assign(FRTTI.GetListaClassProperty);
//    showmessage(IntToStr(FListaClassProperty.Count));
    //Monta Lista de Objetos
    FListaObjetos.Assign(FRTTI.GetAncestors('TCCSListaLinks'));

  //arrumar que esta horrivel
    if FListaObjetos.IndexOf('TObjectAssociation') <> -1 then
       FListaObjetos.Assign(FRTTI.GetAncestors('TObjectAssociation'))
    else
      if FListaObjetos.IndexOf('TObjectPersistent') <> -1 then
         FListaObjetos.Assign(FRTTI.GetAncestors('TObjectPersistent'));
    //Monta a Lista de property por objeto
    for i := 0 to FListaObjetos.Count - 1 do
    begin
       FBinding.InsertObjectMapeamento(i + FBinding.ObjectCount, FListaObjetos[i], xMerge);
       FListaProperty.assign(FRTTI.SplitPropertyOfClass(FListaObjetos[i], FListaClassProperty));
       l := 0; //indica-ra o numero de propriedades do objeto
       for j := 0 to xMap.ListProperty.Count -1 do
       begin
         for k := 0 to FListaProperty.Count - 1 do
         begin
            if xMap.ListProperty[j] = FListaProperty[k] then
            begin
              FMapAux.PropertyOfObject := xMap.ListProperty[j];
              FMapAux.MapOfProperty := xMap.ListField[j];
              FMapAux.FieldLen := StrToInt(xMap.ListFieldLen[j]);
              FMapAux.FieldKey := StrToInt(xMap.ListFieldKey[j]);
              FMapAux.FieldType := xMap.ListFieldType[j];
              try
                FMapAux.FieldOrder := StrToInt(xMap.MapOrder[j]);
              except
                FMapAux.FieldOrder := 0;
              end;
              try
                FMapAux.FieldWhere := StrToInt(xMap.MapWhere[j]);
              except
                FMapAux.FieldWhere := 0;
              end;
              FBinding.InsertMapeamento(i + FBinding.ObjectCount, l, FMapAux);
              FBinding.Binding(i + FBinding.ObjectCount, l);
              inc(l);
              break;
            end;
         end;
         FBinding.SetPropertyCount(i + FBinding.ObjectCount, l);
       end;
    end;

    PosIndx:= FListaObjetos.IndexOf('TASSOCIACAOAGREGACAO');
    if (PosIndx <> -1)  then
    begin
      FListaObjetos[PosIndx] := xMapComponent.Name;
    end;

    //Destruir Objeto utilizado para a insercao
    FMapAux.Free;

    FBinding.ObjectCount := FBinding.ObjectCount + FListaObjetos.Count;

    //Destruir Objetos locais
    FRTTI.Free;
  end;
end;


function TSQLGeneration.GetResultSQL: TStrings;
begin
  Result := FResultSQL;
end;

function TSQLGeneration.KeyOfSGDB: string;
begin
   Result := ',';
   if FSGDB = 'INTRBASE' then Result := ' NOT NULL,';
end;

function TSQLGeneration.LenOfTypeOfSGDB(xType: string): integer;
{
         Metodo para encontrar o tamanho referente ao tipo definido para construir
a DDL.

}
var
   i, j : integer;
begin
   Result := -1;

   I := 2;
   if FSGDB = 'STANDARD' then i := 0;
   if FSGDB = 'INTRBASE' then i := 1;

   //Laco para achar o tamanho do tipo definido
   for j := 0 to 14 do
   begin
      if String(ArrayTypeOfSGDB[i, j]) = xType then
         Result := ArrayLenOfSGDB[i, j];
   end;

end;

procedure TSQLGeneration.Loaded;
begin
  inherited Loaded;
end;

procedure TSQLGeneration.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FMapComponent <> nil) and (AComponent = MapComponent) then
       MapComponent := nil;
  end;

end;

procedure TSQLGeneration.SetBinding(const Value: TBinding);
begin
  FBinding := Value;
end;

procedure TSQLGeneration.SetMap(const Value: TMapPersistent);
begin
  FMap := Value;
  if assigned(value) then
  begin
    if not (csLoading in ComponentState) then
    begin
    end;
  end;
end;


procedure TSQLGeneration.SetMapComponent(const Value: TComponent);
begin
  FMapComponent := Value;
  if assigned(value) then
  begin
    if not (csLoading in ComponentState) then
    begin
    end;
    Value.freenotification(self);
  end;
end;

procedure TSQLGeneration.SetResultSQL(const Value: TStrings);
begin
  FResultSQL.Assign(Value);
end;



function TSQLGeneration.FirstSQL(TipoSQL: TGerarSQL): boolean;
begin
  Result := False;
  if assigned(FBinding) and Assigned(FMap) and assigned(FMapComponent) then
  begin
    FBinding.ObjectIndex := 0;
    GerarSQL(TipoSQL);
    Result := true;
  end else
     raise Exception.Create('FirtSQL - Faltam Parametros');

end;

function TSQLGeneration.NextSQL(TipoSQL: TGerarSQL): boolean;
begin
  Result := False;
  if assigned(FBinding) and Assigned(FMap) and assigned(FMapComponent) then
  begin
    if FBinding.ObjectIndex < FBinding.ObjectCount - 1 then
    begin
      FBinding.ObjectIndex := FBinding.ObjectIndex + 1;
      GerarSQL(TipoSQL);
      Result := True;
    end;
  end else
     raise Exception.Create('NextSQL - Faltam Parametros');
end;

function TSQLGeneration.MergeMap(xMap : TMapPersistent; xMapComponent : TComponent) : integer;
begin
  if assigned(xMap) and assigned(FMap) then
  begin
    DoBind(xMap, xMapComponent, True);
  end else
     raise Exception.Create('MergeMap - Falta setar Objetos');
end;

{ TDMLGeneration }

function TDMLGeneration.GerarSQL(TipoSQL : TGerarSql) : integer;
{
     Os passos seguintes sao para montar join principal e os secundarios
se for necessario, ou seja caso exista associacoes com outros objetos  e
a referecia seja do tipo 1M ou NM.

}
var
  i,j, xCountParam : integer;
  xObjectName, xStrJoin1, xStrJoin2, xStrJoin3 : string;
  xSelect1, xFrom1, xWhere1, xWhere2, xProp1, xProp2 : string;
  xObject : TObject;
  MapAux : TMap;
begin
  if assigned(FMap) then
  begin
    //le primeiro Objeto
    FBinding.GetObjectMapeamento(0, xObjectName);

    //ARRUMAR ESTA PORCARIA RAPIDO ATE ....
    xObjectName := GetCompName(xObjectName);

    FResultSQL.Clear;

    //Estrutura comum do select
    xSelect1 := 'Select ' + 'os_' + xObjectName + '.*, ';

    //Estrutura comum do from
    xFrom1 := 'From ' + 'os_' + xObjectName + ', ';

    //Estrutura comum do where
    xWhere1 := 'Where ';
    xWhere2 := 'os_' + xObjectName + '.os_PrimaryOuid = ';

    //conta apartir da segunda tabela para evitar condicao redundante
    for i := 1 to FBinding.ObjectCount - 1 do
    begin
      FBinding.GetObjectMapeamento(i, xObjectName);
      xObjectName := GetCompName(xObjectName);
      xSelect1 := xSelect1 + 'os_' + xObjectName + '.*, ';
      xFrom1 := xFrom1 + 'os_' + xObjectName + ', ';
      //So cria where padrao para objetos que nao sejao de merge
      if not FBinding.ObjectIsMerge(i) then
        xWhere1 := xWhere1 + xWhere2 + 'os_' + xObjectName + '.os_PrimaryOUID and '
    end;

    //Montar where
    xCountParam := 1;
    for i := 0 to FBinding.ObjectCount - 1 do
    begin
      FBinding.GetObjectMapeamento(i, xObjectName);
      xObjectName := GetCompName(xObjectName);
      for j := 0 to FBinding.GetPropertyCount(i) - 1 do
      begin
         case TMap(FBinding.GetMapeamento(i, j)).FieldWhere of
           1 :
           begin
             xWhere1 := xWhere1 + xWhere2 + 'os_' + xObjectName + '.' +
                        TMap(FBinding.GetMapeamento(i, j)).MapOfProperty + ' and ';
           end;
           2 :
           begin
             xWhere1 := xWhere1 + 'os_' + xObjectName + '.' +
                        TMap(FBinding.GetMapeamento(i, j)).MapOfProperty + ' = :os_Param' + IntToStr(xCountParam) + ' and ';
             inc(xCountParam);
           end;
         end;
      end;
    end;

    //tirar o '.*, ' do xSelect1
    xStrJoin1 := copy(xSelect1, 1 ,length(xSelect1) - 2);

    //tirar o ', ' do xFrom1
    xStrJoin2 := copy(xFrom1, 1 ,length(xFrom1) - 2);

    //tirar o 'and  ' do xWhere
    xStrJoin3 := copy(xwhere1, 1 ,length(xWhere1) - 5);

    FResultSQL.Add('  ');
    FResultSQL.Add('  ');
    FResultSQL.Add(xStrJoin1);
    FResultSQL.Add(xStrJoin2);

    //o where so existe para mais de 2 tabelas
    if FBinding.ObjectCount > 1 then
       FResultSQL.Add(xStrJoin3);
    FResultSQL.Add('  ');
    FResultSQL.Add('  ');
  end;
end;

{ TDDLGeneration }

procedure TDDLGeneration.SetMapDateFormat(const Value: String);
begin
  FMapDateFormat := Value;
end;

procedure TDDLGeneration.CreateCreate;
var
  xObjectName, xStrDDL1 : string;
  i, j : integer;
  FMapAux : TMap;
begin
  //Verifica se ja existe alguma definicao para DDL
  if assigned (FMap) then
  begin
    FResultSQL.Clear;
    //Montar laco para repassar a definicao da tabela
    i := FBinding.ObjectIndex;
//    for i := 0 to FBinding.ObjectCount - 1 do
//    begin
    FBinding.GetObjectMapeamento(i, xObjectName);
    FResultSQL.Add('Object Name: ' + xObjectName);
//    FResultSQL.Add('DROP TABLE os_' + xObjectName);
    FResultSQL.Add('  ');
    FResultSQL.Add('CREATE TABLE os_' + xObjectName);
    FResultSQL.Add('( ');
    FResultSQL.Add('os_PrimaryOUID VARCHAR(40)' + KeyOfSGDB);
    for j := 0 to FBinding.GetPropertyCount(i) - 1 do
    begin
      if FBinding.GetBind(i, j) then
      begin
         //busca dados do mapiamento
         FMapAux := FBinding.GetMapeamento(i, j);

         //Inicializa str com nome da property
         xStrDDL1 := FMapAux.MapOfProperty +
                         #32 +
                         FMapAux.FieldType;

         //verifica se existe tamanho para setar
         case LenOfTypeOfSGDB(FMapAux.FieldType) of
         0 :
         xStrDDL1 := xStrDDL1 +
                         ',';
         1 :
         xStrDDL1 := xStrDDL1 +
                         '(' +
                         IntToStr(FMapAux.FieldLen) +
                         '),';
         2 :
         xStrDDL1 := xStrDDL1 +
                         '(' +
                         IntToStr(FMapAux.FieldLen) +
                         ',' +
                         '0' +  //colocar aqui uma varialve para conter o valor nao esquercer
                         '),';
         end;

         //Inseri definicao da property/field na DDL
         FResultSQL.Add(xStrDDL1);
      end;
    end;
    FResultSQL.Add('PRIMARY KEY (os_PrimaryOUID))');
    FResultSQL.Add('  ');
    FResultSQL.Add('  ');
//    end;
  end;
end;

procedure TDDLGeneration.CreateDrop;
var
  xObjectName : string;
  i : integer;
begin
  //Verifica se ja existe alguma definicao para DDL
  if assigned (FMap) then
  begin
    FResultSQL.Clear;
    i := FBinding.ObjectIndex;
    FBinding.GetObjectMapeamento(i, xObjectName);
    FResultSQL.Add('Object Name: ' + xObjectName);
    FResultSQL.Add('DROP TABLE os_' + xObjectName);
    FResultSQL.Add('  ');
  end;
end;

procedure TDDLGeneration.CreateInsert;
var
  i, j, k : integer;
  strInsert, strFields, strValues, xObject : string;
  FRTTI : TRTTI;
begin
  if assigned(FMap) and assigned(FMapComponent) then
  begin
    FRtti := TRTTI.Create(nil);
    FRTTI.Control := FMapComponent;
    FResultSQL.Clear;
    i := FBinding.ObjectIndex;
    FBinding.GetObjectMapeamento(i, xObject);
    strInsert := 'INSERT INTO ' + xObject;
    strFields := 'os_PrimaryOuid, ';
    strValues :=  '''' + FRtti.GetProperty('PrimaryOuid') +  ''', ';
    for j := 0 to FBinding.GetPropertyCount(i) - 1 do
    begin
      if TMap(FBinding.GetMapeamento(i, j)).Bind then
      begin
        strFields := StrFields + TMap(FBinding.GetMapeamento(i, j)).MapOfProperty + ', ';
        //Tratar valores levando em conta o tipo
        if FUseParam then
        begin
          strValues := strValues + ':' + TMap(FBinding.GetMapeamento(i, j)).MapOfProperty + ', ';
        end else
        begin
          case TMap(FBinding.GetMapeamento(i, j)).FieldKind of
            fksString :
            begin
              strValues := strValues + '''' + FRtti.GetProperty(TMap(FBinding.GetMapeamento(i, j)).PropertyOfObject) + ''', ';
            end;
            fksDate :
            begin
              strValues := strValues + FormatDateTime(FMapDateFormat, StrToDateTime(FRtti.GetProperty(TMap(FBinding.GetMapeamento(i, j)).PropertyOfObject))) + ''', ';
            end;
            fksInteger, fksFloat :
            begin
              strValues := strValues + FRtti.GetProperty(TMap(FBinding.GetMapeamento(i, j)).PropertyOfObject) + ', ';
            end;
          else
            strValues := strValues + '''erro'', ';
          end;
        end;
      end;
    end;
    //tirar o ', '
    strFields := copy(strFields, 1 ,length(strFields) - 2);
    strValues := copy(strValues, 1 ,length(strValues) - 2);

    FResultSQL.Add(strInsert + ' (' + strFields + ') ');
    FResultSQL.Add('Values (' + strValues +  ') ');
    FRtti.Destroy;
  end;
end;

procedure TDDLGeneration.CreateUpdate;
var
  i, j : integer;
  strFields, xObject : string;
  FRTTI : TRTTI;
begin
  if assigned(FMap) and assigned(FMapComponent) then
  begin
    FRtti := TRTTI.Create(nil);
    FRTTI.Control := FMapComponent;
    FResultSQL.Clear;
    i := FBinding.ObjectIndex;
    FBinding.GetObjectMapeamento(i, xObject);
    FResultSQL.Add('UPDATE ' + xObject + ' SET ');
    for j := 0 to FBinding.GetPropertyCount(i) - 1 do
    begin
      if TMap(FBinding.GetMapeamento(i, j)).Bind then
      begin
        if FUseParam then
        begin
           strFields := TMap(FBinding.GetMapeamento(i, j)).MapOfProperty + ' = :' + TMap(FBinding.GetMapeamento(i, j)).MapOfProperty + ', ';
        end else
        begin
          strFields := TMap(FBinding.GetMapeamento(i, j)).MapOfProperty + ' = ';
          case TMap(FBinding.GetMapeamento(i, j)).FieldKind of
            fksString :
            begin
              strFields := strFields + '''' + FRtti.GetProperty(TMap(FBinding.GetMapeamento(i, j)).PropertyOfObject) + ''', ';
            end;
            fksDate :
            begin
              strFields := strFields + FormatDateTime(FMapDateFormat, StrToDateTime(FRtti.GetProperty(TMap(FBinding.GetMapeamento(i, j)).PropertyOfObject))) + ''', ';
            end;
            fksInteger, fksFloat :
            begin
              strFields := strFields + FRtti.GetProperty(TMap(FBinding.GetMapeamento(i, j)).PropertyOfObject) + ', ';
            end;
          else
            strFields := strFields + '''erro'', ';
          end;
        end;
        FResultSql.Add(StrFields);
      end;
    end;
    if FUseParam then
       FResultSQL.Add('where os_PrimaryOuid = :os_PrimaryOuid')
    else
       FResultSQL.Add('where os_PrimaryOuid = ' + '''' + FRtti.GetProperty('PrimaryOuid') +  '''');
    FRtti.Destroy;
  end;
end;
procedure TDDLGeneration.CreateDelete;
var
  i, j : integer;
  xObject : string;
  FRTTI : TRTTI;
begin
  if assigned(FMap) and assigned(FMapComponent) then
  begin
    FRtti := TRTTI.Create(nil);
    FRTTI.Control := FMapComponent;
    FResultSQL.Clear;
    i := FBinding.ObjectIndex;
    FBinding.GetObjectMapeamento(i, xObject);
    FResultSQL.Add('delete from ' + xObject);
    if FUseParam then
       FResultSQL.Add('where os_PrimaryOuid = :os_PrimaryOuid')
    else
       FResultSQL.Add('where os_PrimaryOuid = ' + '''' + FRtti.GetProperty('PrimaryOuid') +  '''');
    FRtti.Destroy;
  end;
end;

function TDDLGeneration.GerarSQL(TipoSQL : TGerarSql) : integer;
{
         Criar a DDL referente ao mapiamento feito sobre  os  objetos  tendo  em
   vista seus tipos, tamanhos e definicao de nomes e respeitando  suas  associa-
   coes, sendo tratadas como referencias
}
begin
  case TipoSQL of
    gsCreate : CreateCreate;
    gsDrop   : CreateDrop;
    gsInsert : CreateInsert;
    gsupdate : CreateUpdate;
    gsdelete : CreateDelete;
  end;
end;

procedure TDDLGeneration.SetUseParam(const Value: boolean);
begin
  FUseParam := Value;
end;



function TSQLGeneration.GetCompName(xClassName: string): string;
begin
  if UpperCase(xClassName) = 'TASSOCIACAOAGREGACAO' then
     Result := MapComponent.Name
  else
     Result := xClassName;

end;

end.


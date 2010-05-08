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




unit Edx01;
{ ****************************************************************** }
{                                                                    }
{   Edx01.pas                                                        }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Dezembro/1998                                                 }
{                                                                    }
{ ****************************************************************** }
{
    NOTA 01
         A classe do editor de propriedade que ira chamar esta dialog esta    na
    unit PersistentcollectionReg.

         E O MapPersistent esta na unit MapPersistent;

    NOTA 02
        A property  IndexEditor tem a funcao de indicar qual e o tipo de  editor
    que sera usado para fazer o mapeamento.
        O Valor do IndexEditor sera setado apartir  da  property  MapStyle    do
    TObject.
        Se IndexEditor for igual a 0 entao o editor sera utilizado para fazer  o
    mapeamento de cada objeto em cada tabela selecionado e sera capaz de criar a
    DDL para a criacao das tabelas para os objetos, e gerar o join, estes  scri-
    pts poderao ser alterados pelo usuario;
        Se IndexEditor for igual a 1 entao o editor sera utilizado para fazer  o
    mapeamento de todas as propridedadas do objeto para um join que foi  montado
    previamente na property SQL do TObjectSet, e nao existera os combos referen-
    tes a selecao do objeto e da tabela, nem o botao DDL e Join.

    NOTA 03
        A property Editar foi incluida para possibilitar que o editor seja capaz
    de modificar seu comportamento dependendo do tipo de objeto que ele esteja e
    ditando.
        Caso seja do tipo eObjeto, nao serao incluidas muitas alteracoes, mas ca
    so seja do tipo eAssociation oi editor devera levar em consideracao que    o
    objeto que esta sendo editado mapeia um TAgregacaoAssociacao, e devera auto-
    maticamente criar a estrutura do objeto no banco 


}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, RTTI, Mask, CCSPilhas, Buttons, DBTables, Db,
  DBGrids, Menus, ComCtrls, ImgList, CCSListaLinks, MapPersistent,
  PersistentCollection, MapBinding, ItemLists;

type
  TEdicao = (eObject, eAssociation);

  TFrmMapDialog = class(TForm)
    PSelect: TPanel;
    Label1: TLabel;
    CBObject: TComboBox;
    Splitter1: TSplitter;
    CBTables: TComboBox;
    LTabelas: TLabel;
    PRodape: TPanel;
    RTTI1: TRTTI;
    Session1: TSession;
    Query1: TQuery;
    PopupMenu1: TPopupMenu;
    Bind1: TMenuItem;
    ImList: TImageList;
    UnBind1: TMenuItem;
    LVProperty: TListView;
    BitBtn3: TBitBtn;
    LVField: TListView;
    Splitter2: TSplitter;
    DefField1: TMenuItem;
    Pbotoes: TPanel;
    BBDDL: TBitBtn;
    BBOk: TBitBtn;
    BBCancel: TBitBtn;
    procedure CBObjectClick(Sender: TObject);
    procedure BBOkClick(Sender: TObject);
    procedure CBTablesClick(Sender: TObject);
    procedure BBDDLClick(Sender: TObject);
    procedure LVPropertyDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LVPropertyDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Bind1Click(Sender: TObject);
    procedure UnBind1Click(Sender: TObject);
    procedure BBCancelClick(Sender: TObject);
    procedure LVPropertyDblClick(Sender: TObject);
    procedure LVFieldMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DefField1Click(Sender: TObject);
  private
    { Private declarations }
    FListaClassProperty : TStrings;
    FListaProperty : TStrings;
    FPilhaProperty : TCustomPilhaStatica;
    FMap : TMapPersistent;
    FMapAux : TMap;
    FControl : TComponent;
    FDataBaseName : string;
    FBinding : TBinding;
    FFieldSelected : string;
    FIndexEditor: integer;
    FSQL: TSTrings;
    FSGDB : string;
    FAliasName: string;
    FCompName: string;
    FEditar: TEdicao;
    function SepararPropertyOfClass(xClassName : string) : TStrings;
    function ClassOfProperty(xPropertyName : string) : string;
    procedure SetMap(Value : TMapPersistent);
    procedure SetIndexEditor(const Value: integer);
    procedure SetSQL(const Value: TSTrings);
    function TypeOfSGDB(xType: TFieldKindSGDB) : string;
    function KeyOfSGDB : string;
    function LenOfTypeOfSGDB(xType : string) : integer;
    procedure SetAliasName(const Value: string);
    procedure SetCompName(const Value: string);
    function GetcompName : string;
    procedure SetEditar(const Value: TEdicao);

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    property Map : TMapPersistent read FMap write SetMap;
    property Control : TComponent read FControl write FControl;
    property CompName : string read GetCompName write SetCompName;
    property DataBaseName : string read FDataBaseName write FDataBaseName;
    property AliasName : string read FAliasName write SetAliasName;
    property IndexEditor : integer read FIndexEditor write SetIndexEditor;
    property Editar : TEdicao read FEditar write SetEditar;
    property SQL : TSTrings read FSQL write SetSQL;
  end;



var
  FrmMapDialog: TFrmMapDialog;

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

uses DefFields, DefDDL;

{$R *.DFM}
constructor TFrmMapDialog.Create(AOwner : TComponent);
begin
   inherited Create(AOWner);
   FListaClassProperty := TstringList.create;
   FListaProperty := TstringList.create;
   FSQL := TstringList.create;
   FPilhaProperty := TCustomPilhaStatica.Create(nil);
   FBinding := TBinding.Create;
//   FMapAux := TMap.Create;
end;

destructor TFrmMapDialog.destroy;
begin
   FListaClassProperty.free;
   FListaProperty.free;
   FSQL.Free;
   FPilhaProperty.Free;
   FBinding.free;
//   FMapAux.Free;
   inherited destroy;
end;
procedure TFrmMapDialog.CBObjectClick(Sender: TObject);
var
   i : integer;
   xNewitem : TListitem;
begin
    LVProperty.Items.Clear;
    for i := 0 to FBinding.GetPropertyCount(CBObject.ItemIndex) - 1 do
    begin
       xNewitem := LVProperty.Items.Add;
       FMapAux :=  FBinding.GetMapeamento(CbObject.ItemIndex, i);
       xNewItem.Caption := FMapAux.PropertyOfObject;
       xNewItem.SubItems.Add(FMapAux.MapOfProperty);
       xNewItem.ImageIndex := Ord(FBinding.GetBind(CbObject.ItemIndex, i)); //retorna 0 ou 1
    end;
end;


function TFrmmapdialog.SepararPropertyOfClass(xClassName : string) : TStrings;
var
   i : integer;
begin
   Result := TStringList.create;
   for i := 0 to FListaClassProperty.count - 1 do
   begin
       SepararNomes(FPilhaProperty, FListaClassProperty[i], cPonto, Direita);
       if (FPilhaProperty.Pop = xClassName) then
       begin
          Result.Add(JuntarNomes(FPilhaProperty, cPonto, Direita));
       end;
   end;
end;

function TFrmmapdialog.ClassOfProperty(xPropertyName : string) : string;
var
   i : integer;
   xClassName : string;
begin
   Result := '';
   for i := 0 to FListaClassProperty.count - 1 do
   begin
       SepararNomes(FPilhaProperty, FListaClassProperty[i], cPonto, Direita);
       xClassName := FPilhaProperty.Pop;
       if (FPilhaProperty.Pop = xPropertyName) then
       begin
          Result := xClassName;
       end;
   end;
end;


procedure TFrmMapDialog.SetMap(Value : TMapPersistent);
var
  i, j, k : integer;
  xNewitem : TListitem;
begin
   if assigned(value) then
   begin
      FMap := Value;
      if Session.FindDatabase(FDataBaseName)= nil then
         Session.OpenDatabase (FDataBaseName);
      session.GetTableNames(FDataBaseName, '', False, False, CBTables.Items);
      FSGDB := session.GetAliasDriverName(FDataBaseName);
      rtti1.control := FControl;
      query1.DatabaseName := FDataBaseName;
      FListaClassProperty.assign(rtti1.GetListaClassProperty);
      showmessage(IntToStr(FListaClassProperty.Count));

         // Cria um Map Auxiliar
         FMapAux := TMap.Create;
         //Monta Lista de Objetos
         CBObject.Items.Assign(rtti1.GetAncestors('TCCSListaLinks'));

         {
              As classes abaixo seram tiradas do mapeamento pois elas teram tra-
         tamento especifico.
              No caso de TObjectPersistent sera mapeado diretamente a proprieda-
         PrimaryOuid e sera criado o scrip do banco diretamente.
              Para o objeto TAssociacaoAgregacao, seram criados automaticamente
         os scripts de banco para representar a associacao
              O objeto  TObjectAssociation sera com o tempo retirado.
         }
         if CBObject.Items.IndexOf('TObjectAssociation') <> -1 then
            CBObject.Items.Assign(rtti1.GetAncestors('TObjectAssociation'))
         else
           if CBObject.Items.IndexOf('TObjectPersistent') <> -1 then
              CBObject.Items.Assign(rtti1.GetAncestors('TObjectPersistent'))
           else
             if CBObject.Items.IndexOf('TAssociacaoAgregacao') <> -1 then
                CBObject.Items.Assign(rtti1.GetAncestors('TAssociacaoAgregacao'));

         //Monta a Lista de property por objeto
         for i := 0 to CBObject.Items.Count - 1 do
         begin
            FBinding.InsertObjectMapeamento(i, CBObject.Items[i], false);
            FListaProperty.assign(SepararPropertyOfClass(CBObject.Items[i]));
            FBinding.SetPropertyCount(i, FListaProperty.Count);
            for k := 0 to FListaProperty.Count - 1 do
            begin
               FMapAux.PropertyOfObject := FListaProperty[k];
               FMapAux.MapOfProperty := 'Sem Mapeamento';
               FMapAux.Bind := False;
               //Atributos para criar DDL
               FMapAux.FieldType :='no type';
               FMapAux.FieldLen:= 0;
               FMapAux.FieldKey:= 0;
               FMapAux.FieldOrder := 0;
               FMapAux.FieldWhere := 0;
               FBinding.InsertMapeamento(i, k, FMapAux);
               FBinding.Unbinding(i, k);
            end;
         end;
         FMapAux.Free;
         FBinding.ObjectCount := CBObject.Items.Count;
      if Map.ListProperty.Count > 0 then
      begin
         {
           Verificar qual propliedade ja foi mapeada e marcar o mamepamento fazendo
           o binding
         }
         for k := 0 to FMap.ListProperty.Count - 1 do
         begin
            for i := 0 to FBinding.ObjectCount - 1 do
            begin
              for j := 0 to FBinding.GetPropertyCount(i) - 1 do
              begin
                 FMapAux := FBinding.GetMapeamento(i, j);
                 if FMap.ListProperty[k] = FMapAux.PropertyOfObject then
                 begin
                    FBinding.Binding(i, j);
                    FMapAux.MapOfProperty := FMap.ListField[k];
                    //Dados necessarios para gerar o script
                    FMapAux.FieldLen := StrToInt(FMap.ListFieldLen[k]);
                    FMapAux.FieldKey := StrToInt(FMap.ListFieldKey[k]);
                    FMapAux.FieldType := FMap.ListFieldType[k];
                    try
                      FMapAux.FieldOrder := StrToInt(FMap.MapOrder[k]);
                    except
                      FMapAux.FieldOrder := 0;
                    end;
                    try
                      FMapAux.FieldWhere := StrToInt(FMap.MapWhere[k]);
                    except
                      FMapAux.FieldWhere := 0;
                    end;

                    FBinding.SetMapeamento(i, j, FMapAux);
                    break;
                 end
              end;
            end;
         end;
      end;
      //NOTA 02
      if IndexEditor = 0 then
      begin
         //Esconder controls para ddl join
         LTabelas.Visible := false;
         CBTables.Visible := false;
         LVField.Visible := false;
      end;
      if IndexEditor = 1 then
      begin
         LVProperty.Items.Clear;
         for i := 0 to FBinding.ObjectCount - 1 do
         begin
           for j := 0 to FBinding.GetPropertyCount(i) - 1 do
           begin
              xNewitem := LVProperty.Items.Add;
              FMapAux := FBinding.GetMapeamento(i, j);
              xNewItem.Caption := FMapAux.PropertyOfObject;
              xNewItem.SubItems.Add(FMapAux.MapOfProperty);
              xNewItem.ImageIndex := Ord(FBinding.GetBind(i , j)); //retorna 0 ou 1
           end;
         end;
         PSelect.Visible := False;
         BBDDL.Visible := False;
         query1.Active := false;
         query1.SQL.Clear;
         query1.SQL.Assign(SQL);
         query1.Active := true;
         LVField.Items.Clear;
         for i := 0 to query1.FieldCount - 1 do
         begin
            xNewitem := LVField.Items.Add;
            xNewItem.Caption := query1.Fields[i].FieldName;
         end;
      end;
   end else
   showmessage('nil');
end;


procedure TFrmMapDialog.BBOkClick(Sender: TObject);
var
   i, j : integer;
begin
   Map.ListObject.Assign(CBObject.Items);
   Map.ListProperty.Clear;
   Map.ListField.Clear;
   Map.ListFieldLen.Clear;
   Map.ListFieldKey.Clear;
   Map.ListFieldType.Clear;
   Map.MapOrder.Clear;
   Map.MapWhere.Clear;
   for i := 0 to FBinding.ObjectCount - 1 do
     for j := 0 to FBinding.GetPropertyCount(i) - 1 do
     begin
        if FBinding.GetBind(i, j) then
        begin
           FMapAux := FBinding.GetMapeamento(i, j);
           Map.ListProperty.Add(FMapAux.PropertyOfObject);
           Map.ListField.Add(FMapAux.MapOfProperty);
           Map.ListFieldLen.Add(IntToStr(FMapAux.FieldLen));
           Map.ListFieldKey.Add(IntToStr(FMapAux.FieldKey));
           Map.ListFieldType.Add(FMapAux.FieldType);
           Map.MapOrder.Add(IntToStr(FMapAux.fieldOrder));
           Map.MapWhere.Add(IntToStr(FMapAux.fieldWhere));
        end;
     end;
end;



procedure TFrmMapDialog.CBTablesClick(Sender: TObject);
var
   i : integer;
   xNewItem : TListItem;
begin
    query1.Active := false;
    query1.SQL.Clear;
    query1.SQL.Add('Select * From ' + CBTables.text);
    query1.Active := true;
    LVField.Items.Clear;
    for i := 0 to query1.FieldCount - 1 do
    begin
       xNewitem := LVField.Items.Add;
       xNewItem.Caption := query1.Fields[i].FieldName;
    end;
end;

procedure TFrmMapDialog.BBDDLClick(Sender: TObject);
var
  i,j : integer;
  xDDLJoin : TStrings;
  xDDLJoinExt : TStringList;
  xStrDDLJoin1, xStrDDLJoin2, xStrDDLJoin3 : string;
  xSelect1, xFrom1, xWhere1, xWhere2, xProp1, xProp2 : string;
  xRTTI : TRTTI;
  xObject : TComponent;
  xCompName : string;
begin
   //criar form para visualizar DDL e Join
   FrmDefDDL := TFrmDefDDL.Create(self);

   //Cria objeto para fazer avaliacao das properties
   xRTTI := TRTTI.Create(nil);
   xRTTI.Control := FControl;

   //Definir DataBaseName
   FrmDefDDL.QryDDLJoin.DatabaseName := DataBaseName;

   {
   -----------------------------------------------------------------------------
         Criar a DDL referente ao mapiamento feito sobre  os  objetos  tendo  em
   vista seus tipos, tamanhos e definicao de nomes e respeitando  suas  associa-
   coes, sendo tratadas como referencias
   }

   //Verifica se ja existe alguma definicao para DDL
   if not (Map.MapDDL.Count > 0) then
   begin
      //rotina para  montar  DDL
      xDDLJoin := TStringList.Create;
      xDDLJoin.Clear;
      //Montar laco para repassar a definicao da tabela
      for i := 0 to FBinding.ObjectCount - 1 do
      begin
        FBinding.GetObjectMapeamento(i, xCompName);
        //Estou passando uma variavel aux porque nao posso passar um property como var acho melhor arrumar isso
        CompName := xCompName;
        xDDLJoin.Add('Object Name: ' + CompName);
        xDDLJoin.Add('DROP TABLE os_' + CompName);
        xDDLJoin.Add('  ');
        xDDLJoin.Add('end.////////////////////////////////');
        xDDLJoin.Add('  ');
        xDDLJoin.Add('CREATE TABLE os_' + CompName);
        xDDLJoin.Add('( ');
        xDDLJoin.Add('os_PrimaryOUID VARCHAR(40)' + KeyOfSGDB);
        for j := 0 to FBinding.GetPropertyCount(i) - 1 do
        begin
           if FBinding.GetBind(i, j) then
           begin
              //busca dados do mapiamento
              FMapAux := FBinding.GetMapeamento(i, j);

              //Inicializa str com nome da property
              xStrDDLJoin1 := FMapAux.MapOfProperty +
                              #32 +
                              FMapAux.FieldType;

              //verifica se existe tamanho para setar
              case LenOfTypeOfSGDB(FMapAux.FieldType) of
              0 :
              xStrDDLJoin1 := xStrDDLJoin1 +
                              ',';
              1 :
              xStrDDLJoin1 := xStrDDLJoin1 +
                              '(' +
                              IntToStr(FMapAux.FieldLen) +
                              '),';
              2 :
              xStrDDLJoin1 := xStrDDLJoin1 +
                              '(' +
                              IntToStr(FMapAux.FieldLen) +
                              ',' +
                              '0' +  //colocar aqui uma varialve para conter o valor nao esquercer
                              '),';
              end;

              //Inseri definicao da property/field na DDL
              xDDLJoin.Add(xStrDDLJoin1);
           end;
        end;
{
        j := Pos(',', xDDLJoin[k]);
        xStr := xDDLJoin[k];
        xStr[j] := ')';
        xDDLJoin[k] := xStr;
}
        xDDLJoin.Add('PRIMARY KEY (os_PrimaryOUID))');
        xDDLJoin.Add('  ');
        xDDLJoin.Add('end.////////////////////////////////');
        xDDLJoin.Add('  ');
      end;

      //Passar a DDL para o ListBox
      FrmDefDDL.MMDDL.Lines.Assign(xDDLJoin);


      {
      ------------------------------------------------------------------------
           Os passos seguintes sao para montar join principal e os secundarios
      se for necessario, ou seja caso exista associacoes com outros objetos  e
      a referecia seja do tipo 1M ou NM.

      }


      //le primeira tabela
      FBinding.GetObjectMapeamento(0, xCompName);
      CompName := xcompName;
      xDDLJoin.Clear;

      //inicia from
      xStrDDLJoin1 := 'select * from os_' + CompName + ', ';

      //Estrutura comum do select
      xSelect1 := 'Select os_' + CompName + '.*, ';

      //Estrutura comum do from
      xFrom1 := 'From os_' + CompName + ', ';

      //Estrutura comum do where
      xWhere1 := 'Where ';
      xWhere2 := 'os_' + CompName + '.os_PrimaryOuid = ';

      //conta apartir da segunda tabela para evitar condicao redundante
      for i := 1 to FBinding.ObjectCount - 1 do
      begin
        FBinding.GetObjectMapeamento(i, xCompName);
        CompName := xCompName;
        xSelect1 := xSelect1 + 'os_' + CompName + '.*, ';
        xFrom1 := xFrom1 + 'os_' + CompName + ', ';
        xWhere1 := xWhere1 + xWhere2 + 'os_' + CompName + '.os_PrimaryOUID and '
      end;

      //tirar o '.*, ' do xSelect1
      xStrDDLJoin1 := copy(xSelect1, 1 ,length(xSelect1) - 2);

      //tirar o ', ' do xFrom1
      xStrDDLJoin2 := copy(xFrom1, 1 ,length(xFrom1) - 2);

      //tirar o ', ' do xFrom1
      xStrDDLJoin3 := copy(xwhere1, 1 ,length(xWhere1) - 5);

      xDDLJoin.Add('  ');
      xDDLJoin.Add('end.////////////////////////////////');
      xDDLJoin.Add('  ');
      xDDLJoin.Add(xStrDDLJoin1);
      xDDLJoin.Add(xStrDDLJoin2);

      //o where so existe para mais de 2 tabelas
      if CBObject.Items.Count > 1 then
         xDDLJoin.Add(xStrDDLJoin3);
      xDDLJoin.Add('  ');
      xDDLJoin.Add('end.////////////////////////////////');
      xDDLJoin.Add('  ');

      //Passos para montar as queries referentes as associacoes
      FBinding.GetObjectMapeamento(0, xCompName);
      CompName := xCompName;
      for i := 0 to Map.ListProperty.Count - 1 do
      begin
        if (Map.ListFieldKey[i] <> '0') and (Map.ListFieldKey[i] <> '1') then
        begin
          //pega o ponteiro do obejeto referenciado

          xObject := TComponent(xRTTI.OwnerOfProperty(Map.ListProperty[i]));
          if assigned(xObject) then
          begin
            //Coloca o where referente a tabela referenciada
            xStrDDLJoin3 := xWhere1 + ' os_' + CompName + '.' + Map.ListField[i] + ' = :os_Param1';

            //Escreve query para faixa da referencia
            xDDLJoin.Add(xStrDDLJoin1);
            xDDLJoin.Add(copy(xFrom1, 1 ,length(xFrom1) - 2));
            xDDLJoin.Add(xStrDDLJoin3);
            xDDLJoin.Add('  ');
            xDDLJoin.Add('end.////////////////////////////////');
            xDDLJoin.Add('  ');

            //Monta Select para tabelas associadas
            xSelect1 := 'os_' + xObject.ClassName + '.os_PrimaryOuid in (select  os_' + CompName + '.' + Map.ListField[i];

            //Coloca a chave referente a referencia na query
            for j := 0 to Map.ListProperty.Count - 1 do
            begin
              if (Map.ListFieldKey[j] <> '0') and (Map.ListFieldKey[j] <> '1') then
              begin
                 //testa para nao fazer o join para ele mesmo
                 if j <> i then
                 begin
                    xObject := TComponent(xRTTI.OwnerOfProperty(Map.ListProperty[J]));
                    if assigned(xObject) then
                    begin
                      xStrDDLJoin3 := xWhere1 + ' os_' + CompName + '.' + Map.ListField[j] + ' = :os_Param1';
//                      xSelect1 := 'os_ ' + xObject.ClassName + '.os_PrimaryOuid in (select  os_' + CompName + '.' + Map.ListField[j];
                      //Escreve a query que sera usada no (  in  ) do objeto referencido
                      xDDLJoin.Add(xSelect1);
                      xDDLJoin.Add(copy(xFrom1, 1 ,length(xFrom1) - 2));
                      xDDLJoin.Add(xStrDDLJoin3 + ')');
                      xDDLJoin.Add('  ');
                      xDDLJoin.Add('end.////////////////////////////////');
                      xDDLJoin.Add('  ');
                 {
                      SepararNomes(FPilhaProperty, Map.ListProperty[j], cPonto, Esquerda);
                      xProp2 := FPilhaProperty.Pop;
                      if FPilhaProperty.Posicao > 0 then
                      begin
                         xProp1 := FPilhaProperty.Pop;
                         XDDLJoinExt := TStringList(TObjectSet(TObjectPersistent(xObject).ListaObjetos).Map.MapJoin);
                         if assigned(xDDLJoinExt) then
                         begin
//                            xDDLJoinExt.Add(xSelect1);
                         end;
                      end;
                  }
                      //TObjectSetX(TObjectPersistent(xObject).ListaObjetos).Map.ListProperty[i] := '';
                    end;
                 end;
              end;
            end;
          end;
        end;
      end;

      //Passar Join para ListBox
      FrmDefDDL.MMJoin.Lines.Assign(xDDLJoin);

      //Destruir TStrings
      xDDLJoin.Free;
   end else
   begin
      FrmDefDDL.MMDDL.Lines.Assign(Map.MapDDL);
      FrmDefDDL.MMJoin.Lines.Assign(Map.MapJoin);
   end;

   //Apresentar DDL e Join
   FrmDefDDL.ShowModal;

   //Seta DDL e Join se for necessario
   if FrmDefDDL.ModalResult = mrOk then
   begin
      Map.MapDDL.Assign(FrmDefDDL.MMDDL.Lines);
      Map.MapJoin.Assign(FrmDefDDL.MMJoin.Lines);
   end;

   //destruir instancias
   xRTTI.Free;
   FrmDefDDL.Free;
end;

function TFrmMapDialog.TypeOfSGDB(xType: TFieldKindSGDB): string;
begin
   Result := '';
   case xType of
      fksstring:
      begin
         if FSGDB = 'STANDARD' then
            Result := 'VARCHAR';
         if FSGDB = 'INTRBASE' then
            Result := 'VARCHAR';
      end;
      fksDate:
      begin
         Result := 'Date';
      end;
      fksInteger:
      begin
         Result := 'SHORT';
      end;
   end;
end;




procedure TFrmMapDialog.LVPropertyDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  xitem : TListitem;
  Linha, Coluna : integer;
begin
   xItem := LVProperty.GetItemAt(X, Y);
   if xItem <> nil then
   begin
      xitem.SubItems[0] := FFieldSelected;
      xItem.ImageIndex := 1;
      Linha := CBObject.ItemIndex;
      Coluna := xItem.Index;
      if IndexEditor = 1 then
      begin
         FBinding.IndexOfPropertyName(xItem.Caption, Linha, Coluna);
      end;
      FBinding.Binding(Linha, Coluna);
      FMapAux := FBinding.GetMapeamento(Linha, Coluna);
      FMapAux.PropertyOfObject := xItem.Caption;
      FMapAux.MapOfProperty := xItem.SubItems[0];
      FBinding.SetMapeamento(Linha, Coluna, FMapAux);
   end;
end;



procedure TFrmMapDialog.LVPropertyDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  xitem : TListitem;
begin
   xItem := LVProperty.GetItemAt(X, Y);
   if (sender is TStringGrid) and (xitem <> nil)  then
      accept := true;
end;

procedure TFrmMapDialog.Bind1Click(Sender: TObject);
var
   Linha, Coluna : integer;
begin
   with LVProperty do
   begin
      Linha := CBObject.ItemIndex;
      Coluna := ItemFocused.Index;
      //ver NOTA 02
      if IndexEditor = 1 then
      begin
         FBinding.IndexOfPropertyName(ItemFocused.Caption, Linha, Coluna);
      end;
      FBinding.Binding(Linha, Coluna);
      SepararNomes(FPilhaProperty, ItemFocused.Caption, cPonto, Esquerda);
      ItemFocused.SubItems[0] := 'os_' + FPilhaProperty.Pop;
      FMapAux := FBinding.GetMapeamento(Linha, Coluna);
      FMapAux.PropertyOfObject := ItemFocused.Caption;
      FMapAux.MapOfProperty := ItemFocused.SubItems[0];
      FBinding.SetMapeamento(Linha, Coluna, FMapAux);
      ItemFocused.ImageIndex := 1;
   end;
end;

procedure TFrmMapDialog.UnBind1Click(Sender: TObject);
var
   Linha, Coluna : integer;
begin
   with LVProperty do
   begin
      Linha := CBObject.ItemIndex;
      Coluna := ItemFocused.Index;
      //ver NOTA 02
      if IndexEditor = 1 then
      begin
         FBinding.IndexOfPropertyName(ItemFocused.Caption, Linha, Coluna);
      end;
      FBinding.Unbinding(Linha, Coluna);
      FMapAux := FBinding.GetMapeamento(Linha,Coluna);
      ItemFocused.SubItems[0] := 'Sem Mapeamento';
      FMapAux.PropertyOfObject := ItemFocused.Caption;
      FmapAux.MapOfProperty := 'Sem Mapeamento';
      FBinding.SetMapeamento(Linha, Coluna, FMapAux);
      ItemFocused.ImageIndex := 0;
   END;
end;


procedure TFrmMapDialog.BBCancelClick(Sender: TObject);
begin
   close;
end;

procedure TFrmMapDialog.SetIndexEditor(const Value: integer);
begin
  FIndexEditor := Value;
end;

procedure TFrmMapDialog.LVPropertyDblClick(Sender: TObject);
var
   Linha, Coluna : integer;
   xProp1, xProp2 : string;
begin
   with LVProperty do
   begin
      if assigned(ItemFocused) then
      begin
         Linha := CBObject.ItemIndex;
         Coluna := ItemFocused.Index;
         FMapAux := FBinding.GetMapeamento(Linha,Coluna);
         //ver NOTA 02
         if IndexEditor = 1 then
         begin
            FBinding.IndexOfPropertyName(ItemFocused.Caption, Linha, Coluna);
         end;
         if FBinding.GetBind(Linha, Coluna) then
         begin
            ItemFocused.ImageIndex := 0;
            FBinding.UnBinding(Linha, Coluna);
            ItemFocused.SubItems[0] := 'Sem Mapeamento';
            FMapAux.PropertyOfObject := ItemFocused.Caption;
            FmapAux.MapOfProperty := 'Sem Mapeamento';
            FBinding.SetMapeamento(Linha, Coluna, FMapAux);
         end else
         begin
            ItemFocused.ImageIndex := 1;
            FBinding.Binding(Linha, Coluna);
            SepararNomes(FPilhaProperty, ItemFocused.Caption, cPonto, Esquerda);
            xProp2 := FPilhaProperty.Pop;
            if FPilhaProperty.Posicao > 0 then
              xProp1 := FPilhaProperty.Pop
            else
              xProp1 := '';
            // ItemFocused.SubItems[0] := 'os_' + FPilhaProperty.Pop;
            ItemFocused.SubItems[0] := 'os_' + xProp1 + xProp2;
            FMapAux.PropertyOfObject := ItemFocused.Caption;
            FMapAux.MapOfProperty := ItemFocused.SubItems[0];
            FBinding.SetMapeamento(Linha, Coluna, FMapAux);
            DefField1Click(self);

            //Codigo para pegar a atualizacao do field
            FMapAux := FBinding.GetMapeamento(Linha,Coluna);
            ItemFocused.SubItems[0] := FMapAux.MapOfProperty;
         end;
      end;
   end;
end;

procedure TFrmMapDialog.LVFieldMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  xitem : TListitem;
begin
   xItem := LVField.GetItemAt(X, Y);
   if xItem <> nil then
   begin
      FFieldSelected := xItem.Caption;
   end;
end;

procedure TFrmMapDialog.SetSQL(const Value: TSTrings);
begin
  FSQL := Value;
end;

procedure TFrmMapDialog.DefField1Click(Sender: TObject);
var
   i, j, Linha, Coluna : integer;
begin
   with LVProperty do
   begin
      if (CBObject.ItemIndex = -1) or (not assigned(ItemFocused)) then exit;
      Linha := CBObject.ItemIndex;
      Coluna := ItemFocused.Index;
   end;
   FrmDefFields := TFrmDefFields.Create(self);
   //Acertar combo de tipos de acordo com o banco
   FrmDefFields.CbFieldType.Items.Clear;
   I := 2;
   if FSGDB = 'STANDARD' then i := 0;
   if FSGDB = 'INTRBASE' then i := 1;

   //Colocar types referentes ao banco corrente
   FrmDefFields.CbFieldType.Items.Clear;
   FrmDefFields.FListaTypeLen.Clear;
   for j := 0 to 14 do
   begin
      //Sair do laco se nao existir mais tipos
      if ArrayLenOfSGDB[i, j] = -1 then
         break;
      FrmDefFields.CbFieldType.Items.Add(String(ArrayTypeOfSGDB[i, j]));
      FrmDefFields.FListaTypeLen.Add(IntToStr(ArrayLenOfSGDB[i, j]));
   end;

   //Setar valores iniciais
   FMapAux := FBinding.GetMapeamento(Linha, Coluna);
   FrmDefFields.CbFieldType.Text := FMapAux.FieldType;
   FrmDefFields.SeFieldLen.Value := FmapAux.FieldLen;
   FrmDefFields.EdField.Text := FMapAux.MapOfProperty;
   FrmDefFields.CbKeyType.ItemIndex := FMapAux.FieldKey;
   FrmDefFields.chbWhere.checked := Boolean(FMapAux.FieldWhere);
   FrmDefFields.chbOrder.checked := Boolean(FMapAux.FieldOrder);

   FrmDefFields.ShowModal;

   //Atualizar Valores do objeto mapiado
   FMapAux.FieldType := FrmDefFields.CbFieldType.Text;
   FMapAux.FieldLen := FrmDefFields.SeFieldLen.Value;
   FMapAux.FieldKey := FrmDefFields.CbKeyType.ItemIndex;
   FMapAux.MapOfProperty := FrmDefFields.EdField.Text;
   FMapAux.FieldWhere := integer(FrmDefFields.chbWhere.checked);
   FMapAux.FieldOrder := integer(FrmDefFields.chbOrder.checked);
   FBinding.SetMapeamento(Linha, Coluna, FMapAux);

   FrmDefFields.Free;
end;

procedure TFrmMapDialog.SetAliasName(const Value: string);
begin
  FAliasName := Value;
end;

function TFrmMapDialog.LenOfTypeOfSGDB(xType: string): integer;
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

function TFrmMapDialog.KeyOfSGDB: string;
begin
   Result := ',';
   if FSGDB = 'INTRBASE' then Result := ' NOT NULL,';
end;

procedure TFrmMapDialog.SetCompName(const Value: string);
begin
  FCompName := Value;
end;

function TFrmMapDialog.GetCompName: string;
begin
  if UpperCase(FCompName) = 'TASSOCIACAOAGREGACAO' then
     Result := Control.Name
  else
     Result := FcompName;
end;

procedure TFrmMapDialog.SetEditar(const Value: TEdicao);
begin
  FEditar := Value;
end;

end.


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




unit PersistentCollection;
{ ****************************************************************** }
{                                                                    }
{   PersistentCollection.pas                                         }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Marco/1999                                                    }
{                                                                    }
{ ****************************************************************** }
{
 NOTAS
      01 - A property Notificando foi criada para nao ocorra notificacoes circu-
      lares, pois sempre que se inicia uma notificacao ela sera setada para true
      e so ao fim da notificacao ela passara para false, fazendo com que o obje-
      nao tente fazer mais notificacoes.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, MapPersistent, CCSListaLinks, rtti, CCSPilhas, ActiveX,
  SQLGeneration, MapBinding;

type
  TMapStyle = (MapDDL, MapJoin);
  //ACERTAR AMANHA ISTO POIS ESTE VALOR TEM QUE CHEGAR ATE O EDX PARA
  //PODER AJUDAR A OMATAR A DDL E O JOIN
  TReferenceState = (rNull, rInsert, rScroll, rEdit, rPost);

  //Definicao de um objeto para possuir opcoes de controle do TCustomObjectSet
  TOpcoesObjectSet = class(TPersistent)
  private
    FCancelarInsert: Boolean;
    FUsarDbWare: boolean;
    FUsarOuidExterno: boolean;
    FMontarOpen: boolean;
    FColocarOrderBy: boolean;
    FUsarDSQL: boolean;
    FExecNotification: boolean;
    procedure SetCancelarInsert(const Value: Boolean);
    procedure SetUsarDbWare(const Value: boolean);
    procedure SetUsarOuidExterno(const Value: boolean);
    procedure SetMontarOpen(const Value: boolean);
    procedure SetColocarOrderBy(const Value: boolean);
    procedure SetUsarDSQL(const Value: boolean);
    procedure SetExecNotification(const Value: boolean);
  protected
    constructor Create;
  
  published
    property CancelarInsert : Boolean read FCancelarInsert write SetCancelarInsert;
    property UsarDbWare : boolean read FUsarDbWare write SetUsarDbWare;
    property UsarOuidExterno : boolean read FUsarOuidExterno write SetUsarOuidExterno;
    property MontarOpen : boolean read FMontarOpen write SetMontarOpen;
    property ColocarOrderBy : boolean read FColocarOrderBy write SetColocarOrderBy;
    property UsarDSQL : boolean read FUsarDSQL write SetUsarDSQL;
    property ExecNotification : boolean read FExecNotification write SetExecNotification;
  end;

  TOpcoesObjectSetAssociation = class(TPersistent)
  private
    FExecNotification: boolean;
    procedure SetExecNotification(const Value: boolean);
  published
    property ExecNotification : boolean read FExecNotification write SetExecNotification;
  end;

  //Declara a classe para que possa ser usada anter de ser implementada
  TObjectPersistent = class;

  TCustomObjectSet = class(TQuery)
  private
    { Private declarations }
    FMap : TMapPersistent;
    FObjeto : TObjectPersistent;
    FPilhaPropertyClass : TCustomPilhaStatica;
    FMapStyle: TMapStyle;
    FObjetoModificador: TObjectPersistent;
    FValueOuid: string;
    FOpcoes: TOpcoesObjectSet;
    MarcaPosicao : string;
    FDMLObject: TDMLGeneration;
    procedure SetObjeto(Value : TObjectPersistent);
    function PropertyOfClass(PropClass : string) : string;
    procedure SetMapStyle(const Value: TMapStyle);
    procedure SetObjetoModificador(const Value: TObjectPersistent);
    procedure SetValueOuid(const Value: string);
    procedure SetOpcoes(const Value: TOpcoesObjectSet);
  protected
    { Protected declarations }
    FRTTIObjeto : TRTTI;
    FFieldsNames : TStrings;
    procedure DoChangeViewer(Sender: TObject); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure DoBeforePost; override;
    procedure DoAfterPost; override;
    procedure DoAfterScroll; override;
    procedure DoBeforeInsert; override;
    procedure DoAfterInsert; override;
    procedure DoBeforeOpen; override;
  public
    { Public declarations }
    SqlDefault : TStrings;
    class function CreateNewGUID: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AtivarSelectPrincipal;
    procedure SetSQLOfIndex(xSelect : TStrings; IdxForeign : integer);
    procedure MarcarPosicao;
    procedure RetornarPosicao;
    property ValueOuid : string read FValueOuid write SetValueOuid;
    property DMLObject : TDMLGeneration read FDMLObject;
    { Published declarations }
    property Objeto : TObjectPersistent read FObjeto write SetObjeto;
    property Map : TMapPersistent read FMap write FMap;
    property MapStyle : TMapStyle read FMapStyle write SetMapStyle;
    property ObjetoModificador : TObjectPersistent read FObjetoModificador write SetObjetoModificador;
    property Opcoes : TOpcoesObjectSet read FOpcoes write SetOpcoes;
  published
  end;

  TObjectSet = class(TCustomObjectSet)
  published
    { Published declarations }
    property Objeto;
    property Map;
    property MapStyle;
    property ObjetoModificador;
    property Opcoes;
  end;

  TObjectSetAssociation = class(TCustomObjectSet)
  private
    FOpcoesAssociacao: TOpcoesObjectSetAssociation;
    procedure SetOpcoesAssociacao(
      const Value: TOpcoesObjectSetAssociation);
    { Private declarations }
  protected
    { Protected declarations }
    procedure DoBeforePost; override;
    procedure DoAfterScroll; override;
    procedure DoAfterInsert; override;
    procedure loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    { Published declarations }
    property Objeto;
    property Map;
    property MapStyle;
    property ObjetoModificador;
    property Opcoes;
    property OpcoesAssociacao : TOpcoesObjectSetAssociation read FOpcoesAssociacao write SetOpcoesAssociacao;
  end;


  TBlobFieldObject = class(TBlobField)
  public
     procedure AssignTo(Dest: TPersistent); override;
  end;

  TObjectReference = class(TObject)
  public
     Reference : pointer;
     IdxForeign : integer;
     FieldName : string;
  end;

  TObjectPersistent = class(TCCSListaLinks)
  private
    { Private declarations }
    FListReference : TList;
    FListaObjetos: TCustomObjectSet;
    FPrimaryOuid: string;
    FNamePrimaryOuid: string;
    FNotificador: Pointer;
    FReferenceState: TReferenceState;
    FNotificando: Boolean;
    FOnSetIdentification: TNotifyEvent;
    FOuidNotificador: string;
    //Ponteiro para conter o endereco do obejto que inicio a notificacao
    procedure SetPrimaryOuid(const Value: string);
    procedure SetListaObjetos(const Value: TCustomObjectSet);
    procedure SetNamePrimaryOuid(const Value: string);
    procedure SetNotificador(const Value: Pointer);
    procedure SetReferenceState(const Value: TReferenceState);
    procedure SetNotificando(const Value: Boolean);
    procedure SetOnSetIdentification(const Value: TNotifyEvent);
    procedure SetOuidNotificador(const Value: string);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DeleteReference(Reference : Pointer);
    function ReferenceOf(Reference : Pointer) : TObjectReference;
    procedure Loaded; override;
    property NamePrimaryOuid : string read FNamePrimaryOuid write SetNamePrimaryOuid;
    property Notificando : Boolean read FNotificando write SetNotificando;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddReference(Reference : Pointer; IdxForeign : integer; FieldName : string);
    procedure ApplyReference; virtual;
    procedure ExecReference(Sender: TObject; xxValueOuid : string; IdxForeign : integer; xSql : TObject; ReferenceState : TReferenceState); virtual;
    procedure NotifyReference(Sender : TObject; ReferenceState : TReferenceState); virtual;
    function IndexQueryOfReference(xObject : pointer) : integer;
    property ListaObjetos : TCustomObjectSet read FListaObjetos write SetListaObjetos;
    property Notificador : Pointer read FNotificador write SetNotificador;
    property OuidNotificador : string read FOuidNotificador write SetOuidNotificador;
    property ReferenceState : TReferenceState read FReferenceState write SetReferenceState;
  published
    { Published declarations }
    property PrimaryOuid : string read FPrimaryOuid write SetPrimaryOuid;
    property OnSetIdentification : TNotifyEvent read FOnSetIdentification write SetOnSetIdentification;
  end;

  TObjectAssociation = class(TObjectPersistent)
  private
    { Private declarations }
    function PosOfPosSQL(PosObj, PosRef : integer) : integer;
    function IdentificarObjeto(xMapPersistent : TMapPersistent; xFindObject : TObject; xBinding : TBinding; TipoWhere : integer) : boolean;
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure NotifyReference(Sender : TObject; ReferenceState : TReferenceState); override;
    procedure ExecReference(Sender: TObject; xxValueOuid : string; IdxForeign : integer; xSql : TObject; ReferenceState : TReferenceState);  override;
  published
    { Published declarations }
  end;


procedure Register;

implementation

uses Misc001;

const
  cPonto : char = '.';

procedure Register;
begin
  RegisterComponents('Persistencia', [TObjectSet]);
  RegisterComponents('Persistencia', [TObjectSetAssociation]);
  //  RegisterComponentEditor(TCustomObjectSet, TMapEditor);
end;

constructor TCustomObjectSet.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FMap := TMapPersistent.Create;
   FRTTIObjeto := TRTTI.Create(nil);
   FPilhaPropertyClass := TCustomPilhaStatica(nil);
   FFieldsNames := TStringList.Create;
   SqlDefault := TStringList.Create;
   FOpcoes := TOpcoesObjectSet.Create;
   FDMLObject := TDMLGeneration.Create(nil);
   FValueOuid := '';
end;

destructor TCustomObjectSet.Destroy;
begin
   FMap.free;
   FRTTIObjeto.Free;
   FPilhaPropertyClass.free;
   FFieldsNames.free;
   SqlDefault.Free;
   FOpcoes.Free;
   FDMLObject.destroy;
   if assigned(FObjeto) then
      FObjeto.OnChangeViewer := nil;
   inherited Destroy;
end;

procedure TCustomObjectSet.Loaded;
begin
   inherited Loaded;
   try
     FDMLObject.MapComponent := FObjeto;
     FDMLObject.Map := FMap;
     FDMLObject.DoBinding;
     //Strings para armazer a query gerada no design
     if SQL.Count = 0 then
        exit;
     //Pega a lista de nomes de campos
     GetFieldNames (FFieldsNames);
   except
     on h1 : exception do
     begin
       NewLogRecord(' Erro TCustomObjectSet.Loaded do objeto: ' + self.name +
       ' com a mensagem: ' + h1.message);
       NewLogRecord('.... com a query: ' + sql.text + ' com a mensagem: ');
     end;
   end;
end;


procedure TCustomObjectSet.SetObjeto(Value : TObjectPersistent);
begin
   FObjeto := Value;
   if assigned(value) then
   begin
      //Seta o control para o Objeto definido, para obter RTTI
      FRTTIObjeto.Control := FObjeto;

      //Metodo para auxilar no tratamento da auteracao do viewer chegar ao Banco
      FObjeto.OnChangeViewer := DoChangeViewer;

      //passar para o TObjectPersistent meu ponteiro para ele poder me controlar
      FObjeto.ListaObjetos := self;


      if not (csLoading in ComponentState) then
      begin
      end;
      Value.freenotification(self);
   end;
end;

procedure TCustomObjectSet.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FObjeto <> nil) and (AComponent = Objeto) then
       Objeto := nil;
    if (FObjetoModificador <> nil) and (AComponent = ObjetoModificador) then
       ObjetoModificador := nil;
  end;
end;

procedure TCustomObjectSet.DoBeforePost;
var
   i : integer;
   xbf : TBlobFieldObject;
   pp : longint;
   xValue : string;
begin
  inherited DoBeforePost;
  {
            Se a propriedade UsarDbWare das Opcoes estiver ativo, o post sera
  dado usando os dados dos dbware, caso contrario o TCustomObjectSet ira ler o conteudo
  do Ojeto referenciado.

  }
  if not Opcoes.UsarDbWare then
  begin
    if Opcoes.UsarOuidExterno then
    begin
      try
        FieldByName('os_Primaryouid').AsString := FObjeto.PrimaryOuid;
      except
        FieldByName('os_Primaryouid').AsString := '';
      end;
    end;
    if assigned(FObjeto) then
    begin
       FObjeto.NotifyLinks(self, lUpdate);
       for i := 0 to MAP.ListProperty.Count - 1 do
       begin
         if not (Map.ListFieldType[i] = 'BLOB') then
         begin
            xValue := FRTTIObjeto.GetProperty(Map.ListProperty[i]);
//            showmessage('property-> ' + Map.ListProperty[i] + ' field-> ' + Map.ListField[i] + ' xValue-> ' + xValue);
            if (Map.ListFieldType[i] = 'DATE') and (xValue = '  /  /    ') then
               FieldByName(Map.ListField[i]).Clear
            else
               FieldByName(Map.ListField[i]).AsString := xValue;
         end else
         begin
            //Traz blob do banco de forma generica
            xBf := TBlobFieldObject(FieldByName(Map.ListField[i]));
            pp := StrToInt(FRTTIObjeto.GetProperty(Map.ListProperty[i]));
            //Codigo retirado da unit DB no metodo assign, ira verificar qual o
            //tipo do objeto que esta persistido no blob dentre os mais comuns

            //Acertar codigo para objetos desconhecidos
            if TPersistent(pp) is TBlobField then
              xbf.Assign(TBlobField(pp))
            else
              if TPersistent(pp)  is TStrings then
                xbf.Assign(TStrings(pp))
              else
                if TPersistent(pp)  is TBitmap then
                  xbf.Assign(TBitmap(pp))
                else
                  if (TPersistent(pp)  is TPicture) and (TPicture(pp).Graphic is TBitmap) then
                    xbf.Assign(TBitmap(TPicture(pp).Graphic))
                  else
                    xbf.Assign(TPersistent(pp))

         end;
       end;
    end;
  end;
end;

procedure TCustomObjectSet.DoAfterScroll;
var
   i : integer;
   xbf : TBlobFieldObject;
   PointerDestino : longint;
begin
   inherited DoAfterScroll;
   if assigned(FObjeto) then
   begin
      {
      pega a identificacao do objeto e colaca no control, como podera ocorrer maiamento
      de tabelas ja existentes e indentificadores ja existentes entao o uso do nome OUID
      pode complometer o uso em tabelas ja existentes. ISTO TEM QUE SER REVISTO PARA EVITAR
      PROBLEMAS
      }
      try
        FObjeto.PrimaryOuid := FieldByName('os_Primaryouid').AsString;
      except
        FObjeto.PrimaryOuid := '';
      end;

      for i := 0 to MAP.ListProperty.Count - 1 do
      begin
         if UpperCase(Map.ListFieldType[i]) = 'DATE'  then
         begin
           //Tratar tipo Date
           {
            Esta parte do codigo esta horrivel e precisa ser reavalidade e melhorada, mas hoje
            estou muito puto da vida e nao estou com saco, portanto arrumar mais tarde.
           }
           TDateTimeField(fieldbyname(Map.ListField[i])).DisplayFormat := 'dd/mm/yyyy';
           FRTTIObjeto.PutProperty(Map.ListProperty[i], FormatDateTime('dd/mm/yyyy', TDateTimeField(fieldbyname(Map.ListField[i])).Value));
//           showmessage(FormatDateTime('dd/mm/yyyy', TDateTimeField(fieldbyname(Map.ListField[i])).Value));
         end else
         begin
           if (Map.ListFieldType[i] = 'BLOB')  then
           begin
             ////olhar com urgencia para tratar blos
             PointerDestino := StrToInt(FRTTIObjeto.GetProperty(Map.ListProperty[i]));
             xBf := TBlobFieldObject(FieldByName(Map.ListField[i]));
             //Codigo retirado da unit DB no metodo assign, para poder atuzalizar
             //corretamente o field do tipo blob
             if TPersistent(PointerDestino) is TBlobField then
               xbf.assignto(TBlobField(PointerDestino))
             else
               if TPersistent(PointerDestino)  is TStrings then
                 xbf.assignto(TStrings(PointerDestino))
               else
                 if TPersistent(PointerDestino)  is TBitmap then
                   xbf.assignto(TBitmap(PointerDestino))
                 else
                   if (TPersistent(PointerDestino)  is TPicture) and (TPicture(PointerDestino).Graphic is TBitmap) then
                     xbf.assignto(TBitmap(TPicture(PointerDestino).Graphic))
                   else
                     xbf.assignto(TPersistent(PointerDestino));
             //Seta propriedade do objeto
             FRTTIObjeto.PutProperty(Map.ListProperty[i], IntToStr(PointerDestino));
           end else
           begin
             if not ((Map.ListFieldKey[i] = '3') or (Map.ListFieldKey[i] = '2')) then
             begin
//               showmessage('Objeto: ' + Self.Name + ' e PutProperty: ' + Map.ListProperty[i] + ' e  FieldByName: ' + Map.ListField[i] + ' Valor do bco : ' + FieldByName(Map.ListField[i]).AsString);
               FRTTIObjeto.PutProperty(Map.ListProperty[i], FieldByName(Map.ListField[i]).AsString)
             end;
           end;
         end;
      end;
      FObjeto.NotifyLinks(self, lLoad);
      //Condicao para evitar que se altere o objeto que deu inicio a notificacao
      if Assigned(FObjeto.Notificador) then
         FObjeto.NotifyReference(FObjeto.Notificador, FObjeto.ReferenceState)
      else
         FObjeto.NotifyReference(self, FObjeto.ReferenceState);
      //Ao final da notificacao, restabelece o estado da referencia
      Objeto.ReferenceState := rNull;
   end;
end;

procedure TCustomObjectSet.DoAfterInsert;
var
  j  : integer;
begin
   inherited DoAfterInsert;
   //Gera um novo Ouid e coloca na property do object que o identifica e ira tratar
   //de referenciar quem precisar, com o metodo NotifyReference

   //Verifica se o Ouid sera gerado aqui ou vira de fora
   if not Opcoes.UsarOuidExterno then
   begin
     FObjeto.PrimaryOuid := CreateNewGUID;
     for j := 0 to FFieldsNames.Count - 1 do
     begin
        if Pos('OS_PRIMARYOUID', FFieldsNames[j]) <> 0 then
        begin
           FieldByName(FFieldsNames[j]).AsString := FObjeto.PrimaryOuid;
        end;
     end;
   end;
   FObjeto.ReferenceState := rInsert;
end;


class function TCustomObjectSet.CreateNewGUID: string;
var
  NewGUID: TGUID;
  NewString : array [0..49] of WideChar;
begin
if Succeeded (CoCreateGuid(NewGUID)) then
   begin
   StringFromGUID2 (NewGUID, @NewString, 40);
   Result:= WideCharToString (NewString);
   end
else
    Result:='';
end;

//este metodo deve-ra ir para o TRTTI
function TCustomObjectSet.PropertyOfClass(PropClass: string): string;
var
   xClassName : string;
begin
   SepararNomes(FPilhaPropertyClass, PropClass, cPonto, Direita);
   xClassName := FPilhaPropertyClass.Pop;
   if not FPilhaPropertyClass.IsEmpty then
      Result := JuntarNomes(FPilhaPropertyClass, cPonto, Direita);

end;

procedure TCustomObjectSet.SetMapStyle(const Value: TMapStyle);
begin
  FMapStyle := Value;
end;

procedure TCustomObjectSet.DoChangeViewer(Sender: TObject);
begin
   if (state = dsBrowse) and not  (BOF and EOF) then
      edit;

end;

procedure TCustomObjectSet.SetObjetoModificador(const Value: TObjectPersistent);
begin
  FObjetoModificador := Value;
  if assigned(value) then
  begin
    Value.freenotification(self);
  end;
end;


procedure TCustomObjectSet.SetSQLOfIndex(xSelect : TStrings; IdxForeign : integer);
var
   i, j, xSqlcount : integer;
begin
  xSelect.Clear;
  xSqlCount := -1;
  for i := 0 to FMap.MapJoin.Count - 1 do
  begin
    if (FMap.MapJoin[i] = 'end.////////////////////////////////') then
    begin
      Inc(xSqlCount);
      if xSqlCount = IdxForeign then
      begin
        for j := I + 1 to FMap.MapJoin.Count - 1 do
        begin
          if not (FMap.MapJoin[j] = 'end.////////////////////////////////') then
             xSelect.Add(FMap.MapJoin[j])
          else
             break;
        end;
      end;
    end;
  end;
end;


{ TBlobFieldObject }

procedure TBlobFieldObject.AssignTo(Dest: TPersistent);
begin
   inherited AssignTo(Dest);
end;

{ TObjectPersistent }

constructor TObjectPersistent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListReference := TList.Create;
  FReferenceState := rNull;
  Notificando := False;
end;

destructor TObjectPersistent.Destroy;
begin
  while FListReference.Count > 0 do DeleteReference(FListReference.Last);
  FListReference.Free;
  inherited Destroy;
end;

procedure TObjectPersistent.Loaded;
begin
   ApplyReference;
end;

procedure TObjectPersistent.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FListaObjetos <> nil) and (AComponent = ListaObjetos) then
       ListaObjetos := nil;
  end;

end;

procedure TObjectPersistent.AddReference(Reference : Pointer; IdxForeign : integer; FieldName : string);
{
          Metodo para criar uma lista de objetos do tipo TObjectReference    que
representao a referencia, este objeto possui um ponteiro para o objeto  referen-
ciado, um indice indicando qual query devera ser usada, e o nome  do  field  que
sera usado para pegar o codigo da referencia que sera usando  para  enchergar  o
objeto da associacao;
}
var
  xObjectReference : TObjectReference;
begin
   if assigned(Reference) then
   begin
     xObjectReference := TObjectReference.Create;
     xObjectReference.Reference := Reference;
     xObjectReference.IdxForeign := IdxForeign;
     xObjectReference.FieldName := FieldName;
     FListReference.Add(xObjectReference);
   end;
end;

procedure TObjectPersistent.ApplyReference;
{
          Este metodo devera ser utilizado pelo loaded, e ira adcionar as refe-
rencias  dos objetos refenciados, usando o metodo OwnerOfProperty do TRTTI, ele
ira obter o ponteiro do objeto referenciado. Para que com este ele consiga mais
tarde avisar a sua referencia que ele foi modificado, e que ele deveria se atua-
lizar. Ele tambem ira passar para as referencia mais dois parametros que sao o
IdxForeign, que indica qual query devera ser rodada, e o fieldName, que indica
qual o field a referencia indica.
}
var
  i, xIdxForeign : integer;
  xRTTI : TRTTI;
  xObject : TObjectPersistent;
  xCountRef : integer;

begin
  if assigned(ListaObjetos) then
  begin
    if assigned(ListaObjetos.Map) then
    begin
      //cria um rtti para avaliar objeto
      xRTTI := TRTTI.Create(nil);

      //Passa o ponteiro do objeto em avaliacao para o rtti
      xRTTI.Control := self;

      //Fazer o contador de foring NM igual a 1 para representar 1a query
      xIdxForeign := 1;

      //Faz laco para verificar quantas associacoes do tipo NMForering existe
      xCountREf := 0;
      for i := 0 to ListaObjetos.Map.ListProperty.Count - 1 do
      begin
        if ListaObjetos.Map.ListFieldKey[i] = '3' then
        begin
           inc(xCountRef);
        end;
      end;
      {
      Inicia laca para encontrar o fieldKey diferentes de 0, que indicam, que o
      atributo e uma referencia
      }
      for i := 0 to ListaObjetos.Map.ListProperty.Count - 1 do
      begin
        if ListaObjetos.Map.ListFieldKey[i] <> '0' then
        begin
          //pega o ponteiro do obejeto referenciado
          xObject := TObjectPersistent(xRTTI.OwnerOfProperty(ListaObjetos.Map.ListProperty[I]));

          //Situacao M1
          if ListaObjetos.Map.ListFieldKey[i] = '1' then
          begin
             AddReference(xObject, 0, ListaObjetos.Map.ListField[i]);
          end;

          //Situacao 1M
          if ListaObjetos.Map.ListFieldKey[i] = '2' then
          begin
             AddReference(xObject, 1, ListaObjetos.Map.ListField[i]);
             //1 PARA IdxForeign PORQUE NAO VAI RODAR NADA NA ASSOCIACAO
             xObject.AddReference(self, 1, 'OS_PrimaryOuid');
          end;

          //Situacao NM ou NMN
          if ListaObjetos.Map.ListFieldKey[i] = '3' then
          begin
            AddReference(xObject, xIdxForeign, ListaObjetos.Map.ListField[i]);
            xObject.AddReference(self, xIdxForeign, 'OS_PrimaryOuid');
            inc(xIdxForeign, xCountRef);
          end;

        end;
      end;
      xRTTI.Free;
    end;
  end;
end;

procedure TObjectPersistent.NotifyReference(Sender : TObject; ReferenceState : TReferenceState);
{
          Este metodo tem a funcao de notificar todos os objetos que sao  refe-
renciados pelo objeto notificador, Estes objetos foram colocados     geralmente
usando o Map do ObjectSet, que no metodo ApplyReference  coloca todas as  refe-
rencias em uma lista com do metodo addReference colocando nesta lista o o  pon-
teiro para o objeto referenciado, o indice foreing e o nome do campo onde  esta
persistida o codigo do ponteiro.

}
var
   i : integer;
   xObjRef : TObjectReference;
   xObjPer : TObjectPersistent;
   xValueOuid : string;
begin
  try
    for i := 0 to FListReference.Count - 1 do
    begin
      //ponteiros somente para melhor a visualizacao do codigo
      xObjRef := FListReference[i];
      if xObjRef <> nil then
      begin
        xObjPer := TObjectPersistent(xObjRef.Reference);
        //numca chamar o notificador que inicio o processo.
        if sender = xObjPer then
           continue;
        xValueOuid := ListaObjetos.FieldByName(xObjRef.FieldName).AsString;
        if assigned(xObjPer) then
        begin
          {
              Chama metodo no objeto referenciado responsavel pela  mudanca, usa
          o sender para avisar ao exec quem foi que disparou a notificacao.
              O nil indica que nao a query neste tipo de objeto e o  indice  ira
          servir para encontrar a query o objeto destino
          }
          xObjPer.ExecReference(self, xValueOuid, xObjRef.IdxForeign, nil, ReferenceState);
        end;
      end;
    end;
  except
    on h1 : exception do
    begin
      NewLogRecord('Erro ! Metodo TObjectPersistent.NotifyReference do objeto: ' +
      Name + ' com message  ' + h1.message);
    end;
  end;
end;

procedure TObjectPersistent.ExecReference(Sender: TObject; xxValueOuid : string; IdxForeign : integer; xSql : TObject; ReferenceState : TReferenceState);
var
  xMo : boolean;
  xDML : TDMLGeneration;
begin
   {
   Inicia notificador com o valor de quem inicio a notificacao, pois apos o Open
   ocorre-ra um scroll, e o atributo notificador caso nao seja tratado seria  mo
   dificado para o self deste objeto, coisa que pode nao ser verdade. Pois a  no
   tificao se inicio fora daqui, e seu notificador deve ser identificado  ate  o
   fim do processo
   }
   try
     if assigned(ListaObjetos) then
     begin
       if not assigned(Notificador) then
          Notificador := Sender;
       if (IdxForeign = 0) and ListaObjetos.Active then
       begin
         ListaObjetos.Locate('OS_PRIMARYOUID', xxValueOuid, [loPartialKey, loCaseInsensitive]);
       end;
       if IdxForeign > 0 then
       begin
         ListaObjetos.close;
         if not(xSQL is TMapPersistent) then
         begin
           //Coloca a query referente ao objeto e depois soma a sub-querie
           ListaObjetos.SetSQLOfIndex(ListaObjetos.sql, 0);
           if (Pos('Where ', ListaObjetos.sql.text) = 0) then
              ListaObjetos.sql.Add('Where ' + TStringList(xSql).Text)
           else
              ListaObjetos.sql.Add('and ' + TStringList(xSql).Text);
         end else
         begin
           xDML := TDMLGeneration.Create(nil);
           xDML.MapComponent := self;
           xDML.Map := ListaObjetos.Map;
           xDML.DoBinding;
           xDML.MergeMap(TMapPersistent(xSQL), TComponent(sender));
           xDML.GerarSQL(gsSelect);
           ListaObjetos.sql.Assign(XDML.ResultSQL);
         end;
         ListaObjetos.ParamByName('os_Param1').AsString := xxValueOuid;
         try
           xMo := ListaObjetos.Opcoes.MontarOpen;
           ListaObjetos.Opcoes.MontarOpen := False;
           ListaObjetos.Open;
           ListaObjetos.Opcoes.MontarOpen := xMo;
         except
           NewLogRecord(self.name + ' Metodo - TObjectPersistent.ExecReference. Erro ao abrir nova query! --> ' + ListaObjetos.sql.text);
           showmessage('erro ao abrir nova query');
         end;
       end;
       //Libera notificador ao final do procedimento
       Notificador := nil;
     end;
   except
     on h1 : exception do
     begin
       NewLogRecord('Erro ! Metodo TObjectPersistent.ExecReference do objeto: ' +
       Name + ' com message  ' + h1.message);
     end;
   end;
end;

procedure TObjectPersistent.SetListaObjetos(const Value: TCustomObjectSet);
begin
  FListaObjetos := Value;
  if assigned(value) then
  begin
    Value.freenotification(self);
  end;
end;



procedure TObjectPersistent.DeleteReference(Reference: pointer);
begin
   FListReference.Delete(FListReference.IndexOf(Reference));
end;

procedure TObjectPersistent.SetNamePrimaryOuid(const Value: string);
begin
  FNamePrimaryOuid := Value;
end;


procedure TObjectPersistent.SetPrimaryOuid(const Value: string);
begin
  FPrimaryOuid := Value;
end;


procedure TObjectPersistent.SetNotificador(const Value: Pointer);
begin
  FNotificador := Value;
end;

procedure TObjectPersistent.SetReferenceState(
  const Value: TReferenceState);
begin
  FReferenceState := Value;
end;

procedure TObjectPersistent.SetNotificando(const Value: Boolean);
begin
  FNotificando := Value;
end;

procedure TObjectPersistent.SetOnSetIdentification(
  const Value: TNotifyEvent);
begin
  FOnSetIdentification := Value;
end;

function TObjectPersistent.IndexQueryOfReference(xObject: pointer): integer;
{
         Metodo para devolver a posicao do indice da query do objeto, para que
  outros objetos possam chamar o ExecReference diretamente, ou o sistema tb possa
  fazer a chamada diretamente.

}

var
   i : integer;
   xObjRef : TObjectReference;
begin
  Result := 0;
  for i := 0 to FListReference.Count - 1 do
  begin
    //ponteiros somente para melhor a visualizacao do codigo
    xObjRef := FListReference[i];
    if xObjRef <> nil then
      if xObject = xObjRef.Reference then
         Result := xObjRef.IdxForeign;
  end;
end;


procedure TObjectPersistent.SetOuidNotificador(const Value: string);
begin
  FOuidNotificador := Value;
end;

function TObjectPersistent.ReferenceOf(Reference: Pointer): TObjectReference;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to FListReference.Count - 1 do
  begin
    if FListReference.Items[i] = Reference then
       Result := FListReference.Items[i];
  end;
end;

{ TObjectAssociation }

constructor TObjectAssociation.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
end;

destructor TObjectAssociation.Destroy;
begin
  inherited Destroy;
end;

procedure TObjectAssociation.ExecReference(Sender: TObject; xxValueOuid : string; IdxForeign : integer; xSql : TObject; ReferenceState : TReferenceState);
var
  xMo : boolean;
begin
   {
   Inicia notificador com o valor de quem inicio a notificacao,  pois  apos  o
   o Open ocorre-ra um scroll, e a notificao caso nao seja tratado seria modifi-
   cada para mim mesmo, coisa que pode nao ser verdade. Pois a notificao inicio-
   se fora daqui, e seu notificador deve ser identificado ate o fim do procedsso
   }
   try
     if assigned(ListaObjetos) then
     begin
        if not assigned(Notificador) then
           Notificador := Sender;
        if ListaObjetos.Opcoes.ExecNotification then
        begin
          if IdxForeign = 0 then
          begin
            if ListaObjetos.Active then
               ListaObjetos.Locate('OS_PRIMARYOUID', xxValueOuid, [loPartialKey, loCaseInsensitive]);
          end else
          begin
            ListaObjetos.close;
            ListaObjetos.SetSQLOfIndex(ListaObjetos.sql, IdxForeign);
            ListaObjetos.ParamByName('os_Param1').AsString := xxValueOuid;
            try
              xMo := ListaObjetos.Opcoes.MontarOpen;
              ListaObjetos.Opcoes.MontarOpen := False;
              ListaObjetos.Open;
              ListaObjetos.Opcoes.MontarOpen := xMo;
            except
              NewLogRecord('Erro ! Metodo TObjectAssociation.ExecReference do objeto: ' +
              Name + 'com query: ' + ListaObjetos.Sql.Text);
            end;
          end;
        end else
        begin
          OuidNotificador := xxValueOuid;
          if Assigned(Notificador) then
             NotifyReference(Notificador, ReferenceState)
          else
             NotifyReference(self, ReferenceState);
        end;
        Notificador := nil;
     end;
   except
     on h1 : exception do
     begin
       NewLogRecord('Erro ! Metodo ExecReference do objeto: ' +
       Name + 'com message  ' + h1.message);
     end;
   end;
end;

function TObjectAssociation.IdentificarObjeto(
  xMapPersistent: TMapPersistent; xFindObject: TObject;
  xBinding: TBinding; TipoWhere : integer) : boolean;
var
  i, j : integer;
  xRTTI : TRTTI;
  xObjectName : string;
  xObject : TObject;
  xMapBinding : TMap;
begin
  Result := False;
  xRTTI := TRTTI.Create(nil);
  xRTTI.Control := self;
  //Lista todos que formam a associacao
  for i := 0 to xBinding.ObjectCount - 1 do
  begin
    xBinding.GetObjectMapeamento(i, xObjectName);
    //Lista todas as propriedaes do objeto para identificar notificador
    for j := 0 to xBinding.GetPropertyCount(i) - 1 do
    begin
      //procurar e identificar o notificador
      xObject := xRTTI.OwnerOfProperty(TMap(xBinding.GetMapeamento(i, j)).PropertyOfObject);
      if xFindObject = xObject then
      begin
         xMapBinding := xBinding.GetMapeamento(i, j);
         xMapPersistent.ListObject.Add(xObjectName);
         xMapPersistent.ListProperty.Add(xMapBinding.PropertyOfObject);
         xMapPersistent.listField.Add(xMapBinding.MapOfProperty);
         xMapPersistent.ListFieldLen.Add(IntToStr(xMapBinding.FieldLen));
         xMapPersistent.ListFieldKey.Add(InttoStr(xMapBinding.FieldKey));
         xMapPersistent.ListFieldType.Add(xMapBinding.FieldType);
         xMapPersistent.MapOrder.Add(IntToStr(xMapBinding.fieldOrder));
         xMapPersistent.MapWhere.Add(inttostr(TipoWhere));
         Result := True;
         break;
      end;
    end;
  end;
  xRTTI.Destroy;
end;

procedure TObjectAssociation.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;


procedure TObjectAssociation.NotifyReference(Sender: TObject;
  ReferenceState: TReferenceState);
{
                  Este metodo  e a especializacao do metodo do TObjectPersistent
que servira para notificar as associacoes, pois se o scroll partir do seus pro-
prio TCustomObjectSet, ele deve-ra simplesmente dar um locate nos objetos associados.

}
var
   i, j, k : integer;
   xObjRef : TObjectReference;
   xObjPer : TObjectPersistent;
   xObjectName, xValueOuid : String;
   xxSql : TStrings;
   xObjIdx : integer;
   xPosSql : integer;
   xNotificador, xNotificado : TObject;
   xRTTI : TRTTI;
   xMapPersistent : TMapPersistent;
   xMapBinding : TMap;
begin
//  if not Notificando then
//  begin
//    Notificando := True;
    if not ListaObjetos.Opcoes.UsarDSQL then
    begin
      //Procura a posicao do objeto notificador dentro da lista
      xObjIdx := 0;
      for i := 0 to FListReference.Count - 1 do
      begin
        if pointer(Sender) = Pointer(TObjectReference(FListReference[i]).Reference) then
        begin
           xObjIdx := i;
           break;
        end;
      end;

      xxSql := TStringList.Create;
      for i := 0 to FListReference.Count - 1 do
      begin
        //ponteiros somente para melhor a visualizacao do codigo
        xObjRef := FListReference[i];
        if xObjRef <> nil then
        begin
          xObjPer := TObjectPersistent(xObjRef.Reference);
          //Caso o objeto a ser notificado seja o notificador passa para o proximo
          if xObjPer = sender then
             continue;
          if ListaObjetos.ValueOuid = '' then
             if Sender = Pointer(ListaObjetos) then
                ListaObjetos.ValueOuid := ListaObjetos.FieldByName(xObjRef.FieldName).AsString
             else
                ListaObjetos.ValueOuid := OuidNotificador;


//          if ListaObjetos.ValueOuid = '' then
//             ListaObjetos.ValueOuid := ListaObjetos.FieldByName(xObjRef.FieldName).AsString;
          if assigned(xObjPer) then
          begin
           {
               Chama metodo no objeto referenciado responsavel pela mudanca,  usa  o
           sender para avisar ao exec quem foi que disparou a notificacao.
           }

           {                    -
                 Monta a query referente a referecia que sera notificada, para isso primeiro ira
           encontrar a posicao da query de acordo com a referencia usada, pois se tivesemos a re-
           lacao entre tres objetos por exemplo 1, 2 e 3. Quando o objeto 1 disparase as refrencias
           o objeto que cuida da associacao entre os os tres sitados, devera procurar dentro de um
           lista de joins qual e o join para esta chamada

           A tabela abaixo demonstra como as queries estao dispostas depois de sua criacao, usando
           sequinte regra, primeiro cria-se a query da associacao para um dado objeto e depois as
           sub-queries que irao rodar nos objetos relacionados para se atualizarem, estas queries
           serao geradas de acordo com a ordem de referencias de objetos que se apresentar no
           Map.MapJoin:

                                 0 1 2 3 4 5 6 7 8 9
                                 1 0 2 3 4 5 6 7 8 9
                                 2 0 1 3 4 5 6 7 8 9
                                 3 0 1 2 4 5 6 7 8 9
                                 4 0 1 2 3 5 6 7 8 9
                                 5 0 1 2 3 4 6 7 8 9
                                 6 0 1 2 3 4 5 7 8 9
                                 7 0 1 2 3 4 5 6 8 9
                                 8 0 1 2 3 4 5 6 7 9
                                 9 0 1 2 3 4 5 6 7 8

                Abstraindo apartir da tabela acima o metodo PosOfPosSQl, ira devolver a posicao]
           para cada objeto, da referencia a sub-query adequada para ele rodar.
                Observando a tabela acima fica facil observar que sempre ocorre um deslocamento
           para a direita dos do indices das referencias que forem maiores que a posicao do objeto
           dentro do ListReference e  para os objetos de menores estao axatamente na sua posicao e
           quando posicao do obejto procurado bate com a ordem da listreference a posicao e 1.

           No caso abaixo sera subtraido 1 pois o deslocamento e em relacao a query do objeto de
           associacao
           }
           if xObjRef.IdxForeign > 0 then
           begin
              xPosSql := PosOfPosSQL(i, xObjIdx);
              if xPosSql >= 0 then
                 ListaObjetos.SetSQLOfIndex(xxSql, (xObjRef.IdxForeign + xPosSql));
           end;

           //Geralmente os objetos referenciados sao do tipo TObjectPersistent, mas nao sempre
           if Sender = Pointer(ListaObjetos) then
           begin
             {
               Este IF foi colocado, porque muitas vezes o objeto do Tipo TObjectAssociation tem
               que chamar o exec de outro objeto do mesmo tipo, e sendo assim ele precisa saber
               informar qual e a query que o outro objeto devera rodarm usando o xObjref.IdxForeign
               como ponteiro para esta identificacao.
             }
             if xObjPer is TObjectAssociation then
                xObjPer.ExecReference(self, ListaObjetos.ValueOuid, xObjRef.IdxForeign, nil, ReferenceState)
             else
               xObjPer.ExecReference(self, ListaObjetos.ValueOuid, 0, nil, ReferenceState);
             {
             Limpa OUID para pegar a nova referencia quanto a notificacao parte
             de mim mesmo.
             }
             ListaObjetos.ValueOuid := '';
           end else
           begin
             if xPosSql >= 0 then
                xObjPer.ExecReference(self, ListaObjetos.ValueOuid, xObjRef.IdxForeign, xxSql, ReferenceState);
           end;
          end;
        end;
      end;
      xxSql.Free;
    end else
    begin
      // Notificacao dinamica
      if ListaObjetos.DMLObject.Binding.ObjectCount > 0 then
      begin
        xMapPersistent  := TMapPersistent.Create;
        for k := 0 to FListReference.Count - 1 do
        begin
          //ponteiros somente para melhor a visualizacao do codigo
          xObjRef := FListReference[k];
          if (xObjRef <> nil) then
          begin
            xObjPer := TObjectPersistent(xObjRef.Reference);
            if xObjPer = Sender then
               continue;

            //Identificar Notificador
            xMapPersistent.Clear;
            IdentificarObjeto(xMapPersistent, Sender, ListaObjetos.DMLObject.Binding, 2);

            if ListaObjetos.ValueOuid = '' then
               if Sender = Pointer(ListaObjetos) then
                  ListaObjetos.ValueOuid := ListaObjetos.FieldByName(xObjRef.FieldName).AsString
               else
                  ListaObjetos.ValueOuid := OuidNotificador;
            if assigned(xObjPer) then
            begin
              {
                  Chama metodo no objeto referenciado responsavel pela mudanca,  usa  o
              sender para avisar ao exec quem foi que disparou a notificacao.
              }

              //Identificar objeto que sera notificado
              IdentificarObjeto(xMapPersistent, xObjPer, ListaObjetos.DMLObject.Binding, 1);

              //Geralmente os objetos referenciados sao do tipo TObjectPersistent, mas nao sempre
              //caso eu mesmo tenha notificado pois ListaObjetos e meu ObjectSET
              if Sender = Pointer(ListaObjetos) then
              begin
                {
                  Este IF foi colocado, porque muitas vezes o objeto do Tipo TObjectAssociation tem
                  que chamar o exec de outro objeto do mesmo tipo, e sendo assim ele precisa saber
                  informar qual e a query que o outro objeto devera rodarm usando o xObjref.IdxForeign
                  como ponteiro para esta identificacao.
                }
                if xObjPer is TObjectAssociation then
                   xObjPer.ExecReference(self, ListaObjetos.ValueOuid, xObjRef.IdxForeign, nil, ReferenceState)
                else
                  xObjPer.ExecReference(self, ListaObjetos.ValueOuid, 0, nil, ReferenceState);
                {
                Limpa OUID para pegar a nova referencia quanto a notificacao parte
                de mim mesmo.
                }
                ListaObjetos.ValueOuid := '';
              end else
              begin
                xObjPer.ExecReference(self, ListaObjetos.ValueOuid, xObjRef.IdxForeign, xMapPersistent, ReferenceState);
              end;
            end;
          end;
        end;
        xMapPersistent.Destroy;
      end;
    end;
    ListaObjetos.ValueOuid := '';
//    Notificando := False;
//  end;
end;

function TObjectAssociation.PosOfPosSQL(PosObj, PosRef: integer): integer;
begin
   if PosRef < PosObj Then
      Result := PosRef + 1;
   if PosRef = PosObj Then
      Result := -1;
   if PosRef > PosObj Then
      Result := PosRef;
end;

{ TObjectSetAssociation }

constructor TObjectSetAssociation.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  OpcoesAssociacao := TOpcoesObjectSetAssociation.Create;

end;
destructor TObjectSetAssociation.Destroy;
begin
  OpcoesAssociacao.Destroy;   
  inherited destroy;
end;

procedure TObjectSetAssociation.DoAfterInsert;
begin
  inherited DoAfterInsert;
end;

procedure TObjectSetAssociation.DoAfterScroll;
begin
  inherited DoAfterScroll;
end;

procedure TObjectSetAssociation.DoBeforePost;
begin
  inherited DoBeforePost;
end;

procedure TCustomObjectSet.AtivarSelectPrincipal;
begin
   Close;
   SetSQLOfIndex(sql, 0);
   Open;
end;


procedure TCustomObjectSet.DoAfterPost;
begin
   inherited DoAfterPost;
   FObjeto.ReferenceState := rPost;
end;

procedure TCustomObjectSet.SetValueOuid(const Value: string);
begin
  FValueOuid := Value;
end;

procedure TObjectSetAssociation.loaded;
begin
   inherited loaded;

end;

procedure TObjectSetAssociation.SetOpcoesAssociacao(
  const Value: TOpcoesObjectSetAssociation);
begin
  FOpcoesAssociacao := Value;
end;

{ TOpcoesObjectSet }

constructor TOpcoesObjectSet.Create;
begin
end;

procedure TOpcoesObjectSet.SetCancelarInsert(const Value: Boolean);
begin
  FCancelarInsert := Value;
end;

procedure TOpcoesObjectSet.SetColocarOrderBy(const Value: boolean);
begin
  FColocarOrderBy := Value;
end;

procedure TOpcoesObjectSet.SetExecNotification(const Value: boolean);
begin
  FExecNotification := Value;
end;

procedure TOpcoesObjectSet.SetMontarOpen(const Value: boolean);
begin
  FMontarOpen := Value;
end;

procedure TOpcoesObjectSet.SetUsarDbWare(const Value: boolean);
begin
  FUsarDbWare := Value;
end;

procedure TCustomObjectSet.SetOpcoes(const Value: TOpcoesObjectSet);
begin
  FOpcoes := Value;
end;

procedure TCustomObjectSet.DoBeforeInsert;
{
          Metodo especializado para cancelar uma insercao, caso a propriedade
CancelarInsert esteja ativa.
}
begin
  inherited DoBeforeInsert;
  if Opcoes.CancelarInsert then
     abort;
end;

procedure TCustomObjectSet.RetornarPosicao;
begin
  Locate('OS_PRIMARYOUID', MarcaPosicao, [loPartialKey, loCaseInsensitive]);
end;

procedure TCustomObjectSet.MarcarPosicao;
begin
  if assigned(Objeto) then
    MarcaPosicao := Objeto.PrimaryOuid;

end;

procedure TOpcoesObjectSet.SetUsarDSQL(const Value: boolean);
begin
  FUsarDSQL := Value;
end;

procedure TOpcoesObjectSet.SetUsarOuidExterno(const Value: boolean);
begin
  FUsarOuidExterno := Value;
end;

procedure TCustomObjectSet.DoBeforeOpen;
{
          Este me
}
var
  i, j : integer;
  xObjectName : string;
begin
  if FOpcoes.MontarOpen then
  begin
    SetSQLOfIndex(sql, 0);
  end;
  if FOpcoes.ColocarOrderBy then
  begin
    //condicao para incluir o order by se existir
    {
    for i := FDMLObject.Binding.ObjectCount - 1 do
    begin
      FDMLObject.Binding.GetObjectMapeamento(i, xObjectName);
      for j := 0 to FDMLObject.Binding.GetPropertyCount(i) - 1 do
      begin
        if TMap(FDMLObject.Binding.GetMapeamento(i, j)).FieldOrder then
        begin
          Sql.add('os_' + xObjectName + '.' + TMap(FDMLObject.Binding.GetMapeamento(i, j)).MapOfProperty + ', ');
        end;
      end;
    end;
    }
  end;
  inherited DoBeforeOpen;
end;



{ TOpcoesObjectSetAssociation }

procedure TOpcoesObjectSetAssociation.SetExecNotification(
  const Value: boolean);
begin
  FExecNotification := Value;
end;




end.


saiu do osetass
ESTE METODO VAI SAIR TAMBEM
procedure TObjectSetAssociation.ExecReference(Sender: TObject;
  xxValueOuid: string; IdxForeign: integer; xSql: TObject; ReferenceState : TReferenceState);
{
             O ObjectSetAssociation tem a funcao de especializar este metodo pa-
tratar de forma correta a associacao;
}
var
  xMo : boolean;
begin
//  if Sender = Pointer(ObjetoModificador) then
//  begin
    if OpcoesAssociacao.ExecNotification then
    begin
      ValueOuid := xxValueOuid;
      if IdxForeign > 0 then
      begin
         close;
         SetSQLOfIndex(sql, IdxForeign);
         ParamByName('os_Param1').AsString := xxValueOuid;
         try
           xMo := FOpcoes.MontarOpen;
           FOpcoes.MontarOpen := False;
           Open;
           FOpcoes.MontarOpen := xMo;
         except
           showmessage('erro ao abrir nova query');
         end;
      end;
      ValueOuid := '';
    end else
    begin
      if assigned(FObjeto) then
      begin
        FObjeto.OuidNotificador := xxValueOuid;
        if Assigned(Objeto.Notificador) then
           FObjeto.NotifyReference(FObjeto.Notificador, FObjeto.ReferenceState)
        else
           FObjeto.NotifyReference(self, FObjeto.ReferenceState);
      end;
    end;
  //end else
  //coloqueiu esse eles eif para poder tratar o caso m1 nso OSA
  if not(Sender = Pointer(ObjetoModificador)) then
     if (IdxForeign = 0) and Active then
     begin
//    inherited ExecReference(Sender, xxValueOuid, IdxForeign, xSql, ReferenceState);
      Locate('OS_PRIMARYOUID', xxValueOuid, [loPartialKey, loCaseInsensitive]);
     end;
end;




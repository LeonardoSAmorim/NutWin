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




unit RTTI;
{ ****************************************************************** }
{                                                                    }
{   RTTI.pas                                                         }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   07/Setembro/1998                                                 }
{                                                                    }
{ ****************************************************************** }

{


          Componente para poder avaliar e setar as propriedades em tempo de
     execulsao, utilizando a RTTI, primeiro sera utilizado o metodo classinfo
     de TObject para poder obert um ponteiro para a tabela de informacaoes de
     propriedades que forma montadas e podem ser acessadas e setadas pelos meto
     dos definidos em TypInfo da VCL.

         class function TObject.ClassInfo: Pointer;
         asm
             MOV     EAX,[EAX].vmtTypeInfo
         end;
         O vmtTypeInfo e o deslocamento referente a posicao onde se encontra o
     ponteiro para a RTTI, com esse ponteiro e possivel montar as lista de pro
     priedas e fazer o que for necessario com elas.

          Com esse valor e possivel explorar a memoria na area que foi reservada
     para o componente seguindo as estruturas a seguir;

          O ponteriro que chega pelo TObject.ClassInfo a ponta para a tabela a
     que contem o nome da class e o tipo

        PPTypeInfo = ^PTypeInfo;
        PTypeInfo = ^TTypeInfo;
        TTypeInfo = record
            Kind: TTypeKind;
            Name: ShortString;
        end;

          Na proxima tabela se encontra os dados referentes a property acimma e
      pode ser acessada facilmente com o acrescimo no deslocamento da de cima o
      tamanho do nome. Como isso e possivel esta abaixo  escrito em assembry

      function GetTypeData(TypeInfo: PTypeInfo): PTypeData; assembler;
      asm
         ->    EAX Pointer to type info
         <-    EAX Pointer to type data
               it's really just to skip the kind and the name
        XOR     EDX,EDX
        MOV     DL,[EAX].TTypeInfo.Name.Byte[0] tamanho do nome;
        LEA     EAX,[EAX].TTypeInfo.Name[EDX+1] carrega em EAX o endereco
        referente a posicao do nome + seu tamanho + 1 ou seja a tabela seguinnte
        que e a TypeData descrita Abaixo.
     end;

     *****Observacoes
     *** Em Delphi os parametros em assembry seram passados seguindo a seguinte
     *** ordem primeiro parametro1, parametro2, parametro3, parametro4  em EAX,
     *** EDX, ECX e depois na pilhas seguindo os criterios referentes ao tipo, e
     *** o resultado sera sempre retornado em EAX
     ***************************************************************************

      apartir dessa possicao vc tem a tabela abaixo, esta tabe la sera montada
      dependendo do tipo da property;

        PTypeData = ^TTypeData;
        TTypeData = packed record
          case TTypeKind of
            tkUnknown, tkLString, tkWString, tkVariant: ();
            tkInteger, tkChar, tkEnumeration, tkSet, tkWChar: (
              OrdType: TOrdType;
              case TTypeKind of
                tkInteger, tkChar, tkEnumeration, tkWChar: (
                              MinValue: Longint;
                  MaxValue: Longint;
                  case TTypeKind of
                    tkInteger, tkChar, tkWChar: ();
                    tkEnumeration: (
                      BaseType: PPTypeInfo;
                      NameList: ShortString));
                tkSet: (
                  CompType: PPTypeInfo));
            tkFloat: (
              FloatType: TFloatType);
            tkString: (
              MaxLength: Byte);
            tkClass: (
              ClassType: TClass;
              ParentInfo: PPTypeInfo;
              PropCount: SmallInt;
              UnitName: ShortString);
            tkMethod: (
              MethodKind: TMethodKind;
              ParamCount: Byte;
              ParamList: array[0..1023] of Char);
            tkInterface: (
              IntfParent : PPTypeInfo; ancestor
              IntfFlags : TIntfFlags;
              GUID : TGUID;
              IntfUnit : ShortString;);
        end;


        Tambem e possivel chegar a tabela abaixo seguindo os mesmos criterios de
      deslocamento adotados acima pois eles estao todos na sequencia descrita o
      codigo abaixo em assembry demonstra isso
      function GetPropInfo(TypeInfo: PTypeInfo; const PropName: string): PPropInfo;
      assembler;
      asm
         ->    EAX Pointer to type info
               EDX Pointer to prop name
         <-    EAX Pointer to prop info

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ECX,EDX
        OR      EDX,EDX
        JE      @outerLoop
        MOV     CL,[EDX-4]
        MOV     CH,[EDX]
        AND     ECX,0DFFFH

@outerLoop:
        XOR     EBX,EBX
        MOV     BL,[EAX].TTypeInfo.Name.Byte[0]
        LEA     ESI,[EAX].TTypeInfo.Name[EBX+1] carrega em ESI a posicao efetiva
        de TypeData e com isso ele chegara ate PropData que esta logo em seguida
        MOV     BL,[ESI].TTypeData.UnitName.Byte[0]
        MOVZX   EDI,[ESI].TTypeData.UnitName[EBX+1].TPropData.PropCount como EBX
        contem o tamanho do ultimo campo da estrutura ele sabe onde esta o
        propertycount que faz parte PropData
        Mas percebe-se que vc devera conhecer qual e o tipo que vc possui pois o
        TypeData e montado deacordo com o tipo.
        TEST    EDI,EDI

        TPropData = packed record
         PropCount: Word;
         PropList: record end;
       end;

    Ja a Tabela de informacoes que esta abaixo  esta tb na sequencia  e podera
apontada da mesma forma pelo deslocamento e ela possui todas as property todas
em uma lista e tambem podem ser apontadas pelo deslocamento tal como abaixo

       LEA     EAX,[ESI].TTypeData.UnitName[EBX+1].TPropData.PropList na sequencia
do prorlist esta a lista de propertys e podem ser vasculhadas usando

@nextProperty:
        MOV     BH,0
        DEC     EDI
        LEA     EAX,[EAX].TPropInfo.Name[EBX+1]
        JNE     @innerLoop

  PPropInfo = ^TPropInfo;
  TPropInfo = packed record
    PropType: PPTypeInfo;
    GetProc: Pointer;
    SetProc: Pointer;
    StoredProc: Pointer;
    Index: Integer;
    Default: Longint;
    NameIndex: SmallInt;
    Name: ShortString;
  end;

  TPropInfoProc = procedure(PropInfo: PPropInfo) of object;

  PPropList = ^TPropList;

  Esta e a lista de properiedades descritas a acima que podem ser obtidas
facilmente utilizando o metodo
   function GetPropList(TypeInfo: PTypeInfo; TypeKinds: TTypeKinds;
           PropList: PPropList): Integer;

  TPropList = array[0..16379] of PPropInfo;
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  grids, typInfo, CCSPilhas,  stdctrls, ExtCtrls, db;

type
  PClassInfo = ^TTClassInfo;
  TTClassInfo = packed record
        xClass : pointer;
  end;
  PClassList = ^ArrayClassInfo;
  ArrayClassInfo = array[0..16379] of PClassInfo;

  TRTTI = class(TComponent)
  private
    //control a ser avaliado pelo seu RTTI
    FControl : TObject;
    //variavel para conter o control no caso de subproperty
    FControlAux : TObject;
    //Para atualizar list
    FRefresh : boolean;
    //ponteiro para aread de memoria onde esta o TypeInfo para o RTTI
    FTypeInfo  : PTypeInfo;
    //Tipos posiveis para as propriedaes
    FTypeKinds : TTypeKinds;
    //Numero de propriedades listadas
    FPropertyCount : integer;

    FItems : TStrings;
    FSubProperties : boolean;
    FPropertyNameAux : string;
    FPilhaPropriedades : TCCSPilhaStatica;
    FPilhaClasses : TCCSPilhaStatica;
    FListaTypeEventos : TStrings;
    procedure SetControl(Value : TObject);
    procedure SetRefresh(Value : boolean);
    procedure SetItems(Value : TStrings);
    function GetItems : TStrings;
    procedure AtualizarPropertyList;
    function PropertyOfString(PropertyString : string) : string;
    function GetPropClassList(TypeInfo: PTypeInfo; TypeKinds: TTypeKinds; PropList: PPropList; ClassList : PClassList): Integer;
    procedure AddType(pti: PTypeInfo); virtual;
    procedure MontarListaInfo;
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function GetPropertyList : TStrings;
    function GetPropertys : TStrings;
    function GetMethods : TStrings;
    function GetObject(PropertyName : string) : TObject;
    function HasProperty(PropertyName : string) : boolean;
    procedure PutProperty(PropertyName, Value : string); virtual;
    function GetProperty(PropertyName : string) : string; virtual;
    procedure PutMethod(PropertyName : string; Value : TMethod); virtual;
    function Getmethod(PropertyName : string) : TMethod;
    function GetMethodCount(PropertyName : string) : integer;
    function GetAncestors(ClasseBase : string) : TStrings;
    function ClassOfProperty(xPropertyName : string; ListaClassProperty : TStrings) : string;
    function SplitPropertyOfClass(xClassName : string; ListaClassProperty : TStrings) : TStrings;
    function GetListaClassProperty : TStrings;
    function OwnerOfProperty(PropertyName : string) : TObject;
    function ObjectOfProperty(PropertyName : string) : TObject;
    property Control : TObject read FControl write SetControl;
    property Items : TStrings read GetItems write SetItems;
  published
    { Published declarations }
    property Refresh : boolean read FRefresh write SetRefresh;
    property Kinds : TTypeKinds read FTypeKinds write FTypeKinds;
    property SubProperties : boolean read FSubProperties write FSubProperties default True;
  end;
  procedure GetPropClassInfos(TypeInfo: PTypeInfo; PropList: PPropList; ClassList: PClassList);

procedure Register;

implementation

const
  CPonto : char = '.';

procedure Register;
begin
//  RegisterComponents('CCS-SIS', [TRTTI]);
end;

constructor TRTTI.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FItems := TStringList.Create;
  TStringList(Fitems).sorted := true;
  FControl := nil;
   FTypeKinds := [tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface];
   FPropertyNameAux := '';
   FSubProperties := True;
   FPilhaPropriedades := TCCSPilhaStatica.create(nil);
   FPilhaClasses := TCCSPilhaStatica.create(nil);
   FListaTypeEventos := TStringList.Create;
   MontarListaInfo;
end;

destructor TRTTI.Destroy;
begin
  FItems.Free;
  FPilhaPropriedades.free;
  FPilhaClasses.free;
  FListaTypeEventos.Free;
  inherited Destroy;
end;

procedure TRTTI.SetControl(Value : TObject);
begin
   FControl := Value;
   FControlAux := Value;
   if assigned(value) then
   begin
      FTypeInfo := FControl.ClassInfo;
      if not (csLoading in ComponentState) then
      begin
      end;
      items.Clear;
      FPilhaClasses.Init;
//      AtualizarPropertyList;
      FPropertyNameAux := '';
   end;
end;

function TRTTI.GetItems : TStrings;
begin
     Result := FItems;
end;

procedure TRTTI.SetItems(Value : TStrings);
begin
     { Use Assign method because TStrings is an object type }
     FItems.Assign(Value);
end;


function TRTTI.GetObject(PropertyName: string): TObject;
{
    funcao para retornar o objeto da do tipo tkclass
}
var
  PropertyInfo : PPropInfo;
begin
   Result := nil;
   if (assigned(FControl)) and (PropertyName <> '') then
   begin
       FTypeInfo := FControl.ClassInfo;
       PropertyInfo := GetPropInfo(FTypeInfo, PropertyName);
       If (PropertyInfo <> nil) Then
       Begin
         if PropertyInfo^.PropType^.Kind = tkClass then
         begin
            Result := TObject(GetOrdProp(FControl, PropertyInfo));
         end;
       end;
   end;
end;

function TRTTI.hasProperty(PropertyName: string): boolean;
{
    funcao para verificar se o component possui a proprety
}
var
  PropertyInfo : PPropInfo;
begin
   Result:=False;
   if (assigned(FControl)) and (PropertyName <> '') then
   begin
      PropertyName := PropertyOfString(PropertyName);
      FTypeInfo := FControl.ClassInfo;
      PropertyInfo := GetPropInfo(FTypeInfo, PropertyName);
      Result := (PropertyInfo <> nil);
      FControl := FControlAux;
   end;
end;

procedure TRTTI.PutProperty(PropertyName, Value : string);
var
  PropertyInfo : PPropInfo;
begin
   if (assigned(FControl)) and (PropertyName <> '') then
   begin
      //pegar a propriedade a ser setada
      PropertyName := PropertyOfString(PropertyName);
      if FControl <> nil then
      begin
      //ClassInfo do no Control
         FTypeInfo := FControl.ClassInfo;
         if FTypeInfo <> nil then
         begin
            PropertyInfo := GetPropInfo(FTypeInfo, PropertyName);
            If (PropertyInfo <> nil) Then
            Begin
              Case PropertyInfo^.PropType^.Kind of
                tkInteger,tkChar,
                tkEnumeration      :
                begin
                   if value = '' then value := '0';
                   SetOrdProp(FControl, PropertyInfo, StrToInt(Value));
                end;
                tkFloat            :
                begin
                   if (PropertyInfo^.PropType^.Name = 'TDateTime') or
                      (PropertyInfo^.PropType^.Name = 'TDate') then
                   begin
                      try
                        if (PropertyInfo^.PropType^.Name = 'TDateTime') then
                            Value := FloatToStr(StrToDateTime(Value))
                        else
                            Value := FloatToStr(StrToDate(Value));
                      except
                         Value := '0';
                      end;
                   end;
                   if Trim(value) = '' then
                      Value := '0';
                   SetFloatProp(FControl, PropertyInfo, StrToFloat(Value));
                end;
                tkString,tkLString : SetStrProp(FControl, PropertyInfo, Value);
                tkClass :
                begin
                   try
                     TComponent(GetOrdProp(FControl, PropertyInfo)).assign(TComponent(StrToInt(Value)));
                   except
                     showmessage('erro setando classe da property' + PropertyName);
                   end;
                end;
              End;
            End;
         end;
      end;
      FControl := FControlAux;
   end;
end;

function TRTTI.GetProperty(PropertyName : string) : string;
{
   Metodo para ler o conteudo das propriedas dos componentes filhos de TObject
com o typeinfo que define uma estrutura da property e o getpropinfo que passa um
ponteiro para a propriedade;
}
var
  PropertyInfo : PPropInfo;
begin
   if assigned(FControl) and (PropertyName <> '') then
   begin
      PropertyName := PropertyOfString(PropertyName);
      FTypeInfo := FControl.ClassInfo;
      PropertyInfo := GetPropInfo(FTypeInfo, PropertyName);
      If (PropertyInfo <> nil) Then
      Begin
        Case PropertyInfo^.PropType^.Kind of
          tkInteger,tkChar, tkClass,
          tkEnumeration      : Result := IntToStr(GetOrdProp(FControl,PropertyInfo));
          tkFloat            :
          begin
             if (PropertyInfo^.PropType^.Name = 'TDateTime') or
                (PropertyInfo^.PropType^.Name = 'TDate') then
             begin
                try
                   if (PropertyInfo^.PropType^.Name = 'TDateTime') then
                   begin
                      DateTimeToString(Result, 'dd/mm/yyyy', GetFloatProp(FControl,PropertyInfo));
                      if Result = '30/12/1899' then
                         result := '  /  /    ';
                   end else
                      Result:= DateToStr(GetFloatProp(FControl,PropertyInfo))
                except
                   Result := '';
                end;
             end else
             begin
                Result:= FloatToStr(GetFloatProp(FControl,PropertyInfo));
             end;
          end;
          tkString,tkLString : REsult := GetStrProp(FControl,PropertyInfo);
        End;
      End;
      FControl := FControlAux;
   end;
end;

function TRTTI.Getmethod(PropertyName: string): TMethod;
var
  PropertyInfo : PPropInfo;
begin
   Result.code := nil;
   Result.data := nil;
   if assigned(FControl) and (PropertyName <> '') then
   begin
       PropertyName := PropertyOfString(PropertyName);
       FTypeInfo := FControl.ClassInfo;
       PropertyInfo := GetPropInfo(FTypeInfo, PropertyName);
       If (PropertyInfo <> nil) Then
       Begin
         if PropertyInfo^.PropType^.Kind = tkMethod then
         begin
            Result := GetMethodProp(FControl, PropertyInfo);
         End;
       End;
       FControl := FControlAux;
   end;
end;

function TRTTI.GetMethodCount(PropertyName: string): integer;
var
  PropData : PTypeData;
  i, j : integer;
  FPropertyList : PPropList;
begin
   new(FPropertyList);
   result := - 1;
   if assigned(FControl) and (PropertyName <> '') then
   begin
     PropertyName := PropertyOfString(PropertyName);
     FTypeKinds := [tkMethod];
     FTypeInfo := FControl.ClassInfo;
     FPropertyCount :=  GetPropList(FTypeInfo, FTypeKinds, FPropertyList);
     j:=0;
     for i := 0 to FPropertyCount - 1 do
     begin
       if FPropertyList[i]^.Name = PropertyName then
       begin
         j := FListaTypeEventos.IndexOf(FPropertyList[i]^.PropType^.Name);
         break;
       end;
     end;
     PropData := GetTypeData(PTypeInfo(FListaTypeEventos.Objects[j]));
     if PropData <> nil then
     begin
       Result := PropData^.ParamCount;
     End;
     FControl := FControlAux;
   end;
   dispose(FPropertyList);
end;


procedure TRTTI.PutMethod(PropertyName : string; Value : TMethod);
{
          Metodo para setar metodos dinamicamente, apartir do nome do metodo, devera se usado
          um parametro do tipo TMethod que 'eum record com dois parametros

         TMethod = record
             Code, Data: Pointer;
         end;

         **********
         ** Code devera ser preenchido como o o endereco do metodo a ser setado
         ** Data deve posuir o endereco do objeto dono do metodo;
         **********
}
var
  PropertyInfo : PPropInfo;
begin
   if assigned(FControl) and (PropertyName <> '') then
   begin
       PropertyName := PropertyOfString(PropertyName);
       FTypeInfo := FControl.ClassInfo;
       PropertyInfo := GetPropInfo(FTypeInfo, PropertyName);
       If (PropertyInfo <> nil) Then
       Begin
         if PropertyInfo^.PropType^.Kind = tkMethod then
         begin
            SetMethodProp(FControl, PropertyInfo, Value)
         End;
       End;
       FControl := FControlAux;
   end;
end;


function TRTTI.PropertyOfString(PropertyString : string) : string;
{
         Este metodo ira abrir um string do tipo prop.prop.prop ou obj.obj.prop
   ou seja ira abrir o string a procura do typeinfo do prop
}

var
   i : integer;
begin
  //Separa as propriedades do string
  Result := '';
  SepararNomes(FPilhaPropriedades, PropertyString, cPonto, Direita);
  //Laco para chegar ao novo Control
  for i := 1 to FPilhaPropriedades.Posicao - 1 do
  begin
     FControl := GetObject(FPilhaPropriedades.Pop);
     if FControl = nil then exit;
  end;
  Result := FPilhaPropriedades.Pop;
end;

procedure TRTTI.SetRefresh(Value : boolean);
begin
   if Value <> FRefresh then
   begin
      FRefresh := Value;
      if FRefresh then
      begin
         items.Clear;
//         AtualizarPropertyList;
         FPropertyNameAux := '';
      end;
   end;
end;

procedure TRTTI.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FControl <> nil) and (AComponent = Control) then
       Control := nil;
  end;
end;

procedure TRTTI.AtualizarPropertyList;
{
          Metodo que ira listar todas as propriedades do objeto em questao e suas subproperties
   se subproperties estiver true, para isto primeiro carrega todas as propriedades do objeto e
   depois verifica se ele possui objetos se possui comeca a chamar o metodo recursivamente para
   detalhar as subproperties.
}
var
   i, FCountClass : integer;
   PropertyNameAux2, PropertyNameAux3 : string;
   RTTIControl : TObject;
   //ponteiro com uma lista de DW para os property ingos da propriedades
   FPropertyList : PPropList;
begin
   new(FPropertyList);
   if assigned(FControl) then
   begin
      FTypeInfo := FControl.ClassInfo;
      FPropertyCount :=  GetPropList(FTypeInfo, FTypeKinds, FPropertyList);
      for i := 1 to FPropertyCount do
      begin
         Items.Add(FPropertyNameAux +  FPropertyList[i - 1]^.Name);
      end;
      if SubProperties then
      begin
          FCountClass :=  GetPropList(FTypeInfo, [tkclass], FPropertyList);
          for i := 1 to FCountClass do
          begin
             FPilhaClasses.Push(FPropertyList[i - 1]^.Name);
          end;
          for i := 1 to FCountClass do
          begin
             //Verifica se nao esta ocorrende referencia circular para evitar entrar em loop
             SepararNomes(FPilhaPropriedades, FPropertyNameAux, cPonto, Direita);
             PropertyNameAux3 := FPilhaClasses.Pop;
             if FPilhaPropriedades.IndexOf(PropertyNameAux3) = -1 then
             begin
                PropertyNameAux2 := FPropertyNameAux;
                FPropertyNameAux := FPropertyNameAux + PropertyNameAux3 + '.';
                RTTIControl := FControl;
                FControl := GetObject(PropertyNameAux3);
                AtualizarPropertyList;
                FControl := RTTIControl;
//                FControl := FControlAux;
                FPropertyNameAux := PropertyNameAux2;
             end;
          end;
      end;
      FControl := FControlAux;
   end;
  dispose(FPropertyList);
end;

function TRTTI.GetPropertyList : TStrings;
begin
   Result := TStringList.Create;
   FTypeKinds := [tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface];
   items.Clear;
   AtualizarPropertyList;
   FPropertyNameAux := '';
   Result.Assign(items);
end;

function TRTTI.GetPropertys : TStrings;
begin
   Result := TStringList.Create;
   FTypeKinds := [tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkWChar, tkLString, tkWString, tkclass];
   items.Clear;
   AtualizarPropertyList;
   FPropertyNameAux := '';
   Result.Assign(items);
end;

function TRTTI.GetMethods : TStrings;
begin
   Result := TStringList.Create;
   FTypeKinds := [tkMethod];
   items.Clear;
   AtualizarPropertyList;
   FPropertyNameAux := '';
   Result.Assign(items);
end;

function TRTTI.GetAncestors(ClasseBase : string) : TStrings;
{
         Metodo para montar um lista com com o IS A de um objeto
ate a ClasseBase
}
var
  ClassRef: TClass;
begin
  Result := TStringList.Create;
  ClassRef := FControl.ClassType;
  while (ClassRef <> nil) and (ClassRef.ClassName <> ClasseBase) do
  begin
    Result.Insert(0, ClassRef.ClassName);
    ClassRef := ClassRef.ClassParent;
  end;
end;


function TRTTI.GetListaClassProperty : TStrings;
{
            metodo para retornar uma lista de propriedades + a classe
a que a property o pertence dentro do IS A.
            Quando tiver tempo dar uma olhada melhor no algoritimo para otimizalo
e tirar alguns ifs.
}
var
   i, FPropertyCount, idxproperty : integer;
   PropertyAux : string;
   //Ponteiro para a lista de propriedades com seu class;
   FClassList : PClassList;
   FPropertyList : PPropList;
begin
   AtualizarPropertyList;
   new(FClassList);
   new(FPropertyList);
   Result := TStringList.Create;
   if assigned(FControl) then
   begin
      FTypeInfo := FControl.ClassInfo;
      FPropertyCount :=  GetPropClassList(FTypeInfo, FTypeKinds, FPropertyList, FClassList);
//    showmessage(inttostr(FPropertyCount));
      for i := 1 to FPropertyCount do
      begin
         PropertyAux := FPropertyList^[i - 1].Name;
         idxproperty := items.IndexOf(PropertyAux);
//       showmessage(PropertyAux);
         if idxproperty > -1 then
         begin
            Result.add(TClass(FClassList^[i - 1]).ClassName + '.' +FPropertyList^[i - 1].Name);
            If (idxProperty + 1) <= (Items.Count - 1) then
            begin
               inc(idxproperty);
               while (copy(items[idxproperty], 1, Length(PropertyAux)) = PropertyAux) and (idxproperty <= items.Count - 1) do
               begin
                  Result.add(TClass(FClassList^[i - 1]).ClassName + '.' + items[idxproperty]);
                  if (idxproperty + 1 <= items.Count - 1) then
                    inc(idxProperty)
                  else
                    break;
               end;
            end;
//           Result.add(TClass(FClassList^[i - 1]).ClassName + '.' +FPropertyList^[i - 1].Name);
         end;
      end;
   end;
   dispose(FClassList);
   dispose(FPropertyList);
end;

procedure GetPropClassInfos(TypeInfo: PTypeInfo; PropList: PPropList; ClassList: PClassList); assembler;
{
          Se o metodo fizer parte do objeto os parametros seguem outro criterio da passagem
   EAX, recebe um valor que deve ser o ponteiro para o proprio objeto e os outros parametnos seguem
   normalmente EDX, ECX
}
VAR
   xAdressClassList : integer;
   xAdressClass     : integer;

asm
        { ->    EAX Pointer to type info        }
        {       EDX Pointer to prop list        }
        {       ECX Pointer to Class list       }
        { <-    nothing                         }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     xAdressClassList, Ecx
        XOR     ECX,ECX
        MOV     ESI,EAX
        MOV     CL,[EAX].TTypeInfo.Name.Byte[0]
        MOV     EDI,EDX
        XOR     EAX,EAX
        MOVZX   ECX,[ESI].TTypeInfo.Name[ECX+1].TTypeData.PropCount
        REP     STOSD

@outerLoop:
        MOV     CL,[ESI].TTypeInfo.Name.Byte[0]
        LEA     ESI,[ESI].TTypeInfo.Name[ECX+1]
        MOV     CL,[ESI].TTypeData.UnitName.Byte[0]
        MOVZX   EAX,[ESI].TTypeData.UnitName[ECX+1].TPropData.PropCount
        TEST    EAX,EAX
        JE      @parent
        //PEGAR TCLASS
        PUSH    EAX
        MOV     EAX, [ESI].TTypeData.ClassType
        MOV     xAdressClass, EAX
        POP     EAX
        //RETORNAR AO ESTADO INICIAL
        LEA     EDI,[ESI].TTypeData.UnitName[ECX+1].TPropData.PropList

@innerLoop:
        MOVZX   EBX,[EDI].TPropInfo.NameIndex
        MOV     CL,[EDI].TPropInfo.Name.Byte[0]
        CMP     dword ptr [EDX+EBX*4], 0
        JNE     @alreadySet
        MOV     [EDX+EBX*4],EDI
        //MOVER TCLASS PARA LISTA
        PUSH    EDX
        PUSH    EAX
        MOV     EAX, xAdressClass
        MOV     EDX, xAdressClassList
        MOV     [EDX+EBX*4], EAX
        POP     EAX
        POP     EDX
        //RETORNAR AO ESTA INICIAL

@alreadySet:
        LEA     EDI,[EDI].TPropInfo.Name[ECX+1]
        DEC     EAX
        JNE     @innerLoop

@parent:
        MOV     ESI,[ESI].TTypeData.ParentInfo
        XOR     ECX,ECX
        TEST    ESI,ESI
        JE      @exit
        MOV     ESI,[ESI]
        JMP     @outerLoop
@exit:
        POP     EDI
        POP     ESI
        POP     EBX

end;

function TRTTI.GetPropClassList(TypeInfo: PTypeInfo; TypeKinds: TTypeKinds;
  PropList: PPropList; ClassList : PClassList): Integer;
var
  I, Count: Integer;
  PropInfo: PPropInfo;
  TempPropList: PPropList;
  TempClassList: PClassList;
begin
  Result := 0;
  Count := GetTypeData(TypeInfo)^.PropCount;
  if Count > 0 then
  begin
    GetMem(TempPropList, Count * SizeOf(Pointer));
    GetMem(TempClassList, Count * SizeOf(Pointer));
    try
      GetPropClassInfos(TypeInfo, TempPropList, TempClassList);
      for I := 0 to Count - 1 do
      begin
        PropInfo := TempPropList^[I];
        if PropInfo^.PropType^.Kind in TypeKinds then
        begin
          if PropList <> nil then
          begin
             PropList^[Result] := PropInfo;
             ClassList^[Result] := TempClassList^[i];
          end;
          Inc(Result);
        end;
      end;
    finally
      FreeMem(TempPropList, Count * SizeOf(Pointer));
      FreeMem(TempClassList, Count * SizeOf(Pointer));
    end;
  end;
end;

procedure TRTTI.AddType(pti: PTypeInfo);
begin
   FListaTypeEventos.AddObject(pti^.Name, TObject(pti));
end;

procedure TRTTI.MontarListaInfo;
begin
  AddType (TypeInfo (TNotifyEvent));
  AddType (TypeInfo (TFindMethodEvent));
  AddType (TypeInfo (THelpEvent));
  AddType (TypeInfo (TSetNameEvent));
  AddType (TypeInfo (TDragDropEvent));
  AddType (TypeInfo (TDrawItemEvent));
  AddType (TypeInfo (TMeasureItemEvent));
  AddType (TypeInfo (TScrollEvent));
  AddType (TypeInfo (TDragOverEvent));
  AddType (TypeInfo (TEndDragEvent));
  AddType (TypeInfo (TKeyEvent));
  AddType (TypeInfo (TKeyPressEvent));
  AddType (TypeInfo (TMouseEvent));
  AddType (TypeInfo (TMouseMoveEvent));
  AddType (TypeInfo (TStartDragEvent));
  AddType (TypeInfo (TCloseEvent));
  AddType (TypeInfo (TCloseQueryEvent));
  AddType (TypeInfo (TExceptionEvent));
  AddType (TypeInfo (TIdleEvent));
  AddType (TypeInfo (TMessageEvent));
  AddType (TypeInfo (TShowHintEvent));

  AddType (TypeInfo (TDataChangeEvent)); //from
  AddType (TypeInfo (TDataSetNotifyEvent)); //from
  //AddType (TypeInfo (TUpdateErrorEvent)); //from
 // AddType (TypeInfo (TUpdateRecordEvent)); //from
  AddType (TypeInfo (TFilterRecordEvent)); //from
end;

function TRTTI.OwnerOfProperty(PropertyName: string): TObject;
{
         Metodo para devolver o ponteiro referente ao objeto que
possui a propriedade.

}
var
   i : integer;
begin
  Result:=nil;
  //Separa as propriedades do string
  SepararNomes(FPilhaPropriedades, PropertyName, cPonto, Direita);

  //Laco irpegando o pointeiro de cada objeto da pilha ate a property
  for i := 1 to FPilhaPropriedades.Posicao - 1 do
  begin
     FControl := GetObject(FPilhaPropriedades.Pop);
     if FControl = nil then exit;
  end;
  Result := FControl;
  FControl := FControlAux;
end;

function TRTTI.ObjectOfProperty(PropertyName: string): TObject;
{
         Metodo para devolver o Ponteiro referente ao objeto  representado  pela
property tal como um TString, ou um Tfont, que sao mais comuns,  mas  principal-
mente para devolver referencias referentes a properties do tipo Object,  criadas
ou nao pelo usuario. Objeto1.Objeto2.Objeto3, com este metodo sera  retornado  o
ponteiro referente a property Objeto3, que e do tipo object.
         Caso nao encontre nenhum  ponteiro para property, podendo ser, porque a
property nao existe, ou nao e  do  tipo object, ou o objeto nao esta sendo refe-
renciado naquele momento ou nao foi refereciado.


         20/Marco/1999

         Nasceu com pela nescessidade do Edx01, ser capaz de setar o Objeto  Map
do TObjectSet, de um outro objeto nao referenciado diretamente.

}
var
   i : integer;
begin
  //inicializa result caso nao exista nada
  Result := nil;

  //Separa as propriedades do string
  SepararNomes(FPilhaPropriedades, PropertyName, cPonto, Direita);

  //Laco para chegar a ultima property
  for i := 1 to FPilhaPropriedades.Posicao  do
  begin
     Result := GetObject(FPilhaPropriedades.Pop);
     //Caso  a property nao for do tipo tkClass aborta laco
     if Result = nil then break;
  end;
end;

function TRTTI.SplitPropertyOfClass(xClassName: string;
   ListaClassProperty: TStrings): TStrings;
var
   i : integer;
begin
   Result := TStringList.create;
   for i := 0 to ListaClassProperty.count - 1 do
   begin
       SepararNomes(FPilhaPropriedades, ListaClassProperty[i], cPonto, Direita);
       if (FPilhaPropriedades.Pop = xClassName) then
       begin
          Result.Add(JuntarNomes(FPilhaPropriedades, cPonto, Direita));
       end;
   end;
end;

function TRTTI.ClassOfProperty(xPropertyName: string;
  ListaClassProperty: TStrings): string;
var
   i : integer;
   xClassName : string;
begin
   Result := '';
   for i := 0 to ListaClassProperty.count - 1 do
   begin
       SepararNomes(FPilhaPropriedades, ListaClassProperty[i], cPonto, Direita);
       xClassName := FPilhaPropriedades.Pop;
       if (FPilhaPropriedades.Pop = xPropertyName) then
       begin
          Result := xClassName;
       end;
   end;
end;

end.

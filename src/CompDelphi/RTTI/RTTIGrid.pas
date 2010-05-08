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




unit RTTIGrid;
{
          RTTI.pas
          07/Setembro/1998
          Por Luiz Quelves da Silva


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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, grids, typInfo;

type
  TRTTIGrid = class(TComponent)
  private
    //grid para conter as property e seus valores
    FStringGrid : TStringGrid;
    //control a ser avaliado pelo seu RTTIGrid
    FControl : TComponent;
    //Para atualizar string grid
    FRefresh : boolean;
    //ponteiro para aread de memoria onde esta o TypeInfo para o RTTIGrid
    FTypeInfo  : PTypeInfo;
    //Ponteiro para informacaoes da propriedade
    FPropertyInfo  : PpropInfo;
    //ponteiro com uma lista de DW para os property ingos da propriedades
    FPropertyList : PPropList;
    //Tipos posiveis para as propriedaes
    FTypeKinds : TTypeKinds;
    FPropertyCount : integer;
    procedure SetStringGrid(Value : TStringGrid);
    procedure SetControl(Value : TComponent);
    procedure SetRefresh(Value : boolean);
    procedure DoStringGridKeyPress(Sender: TObject; var Key: Char);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure AtualizarGrid;
  published
    { Published declarations }
    property Control : TComponent read FControl write SetControl;
    property StringGrid : TStringGrid read FStringGrid write SetStringGrid;
    property Refresh : boolean read FRefresh write SetRefresh;
    property Kinds : TTypeKinds read FTypeKinds write FTypeKinds;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TRTTIGrid]);
end;

constructor TRTTIGrid.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FControl := nil;
  FStringGrid := nil;
   FTypeKinds := [tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface];

{  FTypeKinds := [tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface];
}
   new(FPropertyList);
end;

destructor TRTTIGrid.Destroy;
begin
  if assigned(FStringGrid) then
     FStringGrid.OnKeyPress := nil;
  dispose(FPropertyList);
  inherited Destroy;
end;

procedure TRTTIGrid.SetControl(Value : TComponent);
begin
   FControl := Value;
   if assigned(value) then
   begin
      if not (csLoading in ComponentState) then
      begin
      end;
      Value.freenotification(self);
      AtualizarGrid;
   end;
end;

procedure TRTTIGrid.SetStringGrid(Value : TStringGrid);
begin
   FStringGrid := Value;
   if assigned(value) then
   begin
      if not (csLoading in ComponentState) then
      begin
      end;
      FStringGrid.OnKeyPress := DoStringGridKeyPress;
      FStringGrid.FreeNotification(self);
      AtualizarGrid;
   end;
end;

procedure TRTTIGrid.DoStringGridKeyPress(Sender: TObject; var Key: Char);
var
   PropertyName, Value  : string;
begin
   if assigned(FControl) and assigned(FStringGrid) then
   begin
      if key = #13 then
      begin
         PropertyName := FStringGrid.cells[0, FStringgrid.row];
         Value := FStringGrid.cells[1, FStringgrid.row];
         FPropertyInfo := GetPropInfo(FTypeInfo, PropertyName);
         If (FPropertyInfo <> nil) Then
         Begin
           Case FPropertyInfo^.PropType^.Kind of
             tkInteger,tkChar,
             tkEnumeration      : SetOrdProp(Control, FPropertyInfo, StrToInt(Value));
             tkFloat            : SetFloatProp(Control, FPropertyInfo, StrToFloat(Value));
             tkString,tkLString : SetStrProp(Control, FPropertyInfo, Value);
           End;
         end;
      end;
   end;
end;

procedure TRTTIGrid.SetRefresh(Value : boolean);
begin
   if Value <> FRefresh then
   begin
      FRefresh := Value;
      if FRefresh then
         AtualizarGrid;
   end;

end;
procedure TRTTIGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FControl <> nil) and (AComponent = Control) then
       Control := nil;
    if (FStringGrid <> nil) and (AComponent = StringGrid) then
       StringGrid := nil;
  end;
end;

procedure TRTTIGrid.AtualizarGrid;
var
   y : string;
   i : integer;
begin
   if assigned(FStringGrid) and assigned(FControl) then
   begin
      FTypeInfo := FControl.ClassInfo;
      FPropertyCount :=  GetPropList(FTypeInfo, FTypeKinds, FPropertyList);
      FStringGrid.RowCount := FPropertyCount + 1;
      FStringGrid.ColCount := 4;
      FStringGrid.DefaultColWidth := 120;
      FStringGrid.Width := 260;
      FStringGrid.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
                              goEditing];
      FStringgrid.Cells[0,0] := 'Property';
      FStringgrid.Cells[1,0] := 'Value';
      FStringgrid.Cells[2,0] := 'Tipo';
      FStringgrid.Cells[3,0] := 'Kind';
      for i := 1 to FPropertyCount do
      begin
         FStringgrid.Cells[0, i] := FPropertyList[i - 1]^.Name;
         y := '';
         case FPropertyList[i - 1]^.PropType^.Kind of
             tkInteger,tkChar,
             tkEnumeration      : y := IntToStr(GetOrdProp(FControl, FPropertyList[i - 1]));
             tkFloat            : y := FloatToStr(GetFloatProp(FControl, FPropertyList[i - 1]));
             tkString,tkLString : y := GetStrProp(FControl, FPropertyList[i - 1]);
         End;
         FStringgrid.Cells[1, i] := y;
         FStringgrid.Cells[2, i] := FPropertyList[i - 1]^.PropType^.Name;
         case FPropertyList[i - 1]^.PropType^.Kind of
            tkUnknown         : FStringgrid.Cells[3, i] := 'tkUnknown';
            tkInteger         : FStringgrid.Cells[3, i] := 'tkInteger';
            tkChar            : FStringgrid.Cells[3, i] := 'tkChar';
            tkEnumeration     : FStringgrid.Cells[3, i] := 'tkEnumeration';
            tkFloat           : FStringgrid.Cells[3, i] := 'tkFloat';
            tkString          : FStringgrid.Cells[3, i] := 'tkString';
            tkSet             : FStringgrid.Cells[3, i] := 'tkSet';
            tkClass           : FStringgrid.Cells[3, i] := 'tkClass';
            tkMethod          : FStringgrid.Cells[3, i] := 'tkMethod';
            tkWChar           : FStringgrid.Cells[3, i] := 'tkWChar';
            tkLString         : FStringgrid.Cells[3, i] := 'tkLString';
            tkWString         : FStringgrid.Cells[3, i] := 'tkWString';
            tkVariant         : FStringgrid.Cells[3, i] := 'tkVariant';
            tkArray           : FStringgrid.Cells[3, i] := 'tkArray';
            tkRecord          : FStringgrid.Cells[3, i] := 'tkRecord';
            tkInterface       : FStringgrid.Cells[3, i] := 'tkInterface';
         end;
      end;
   end;
end;

end.

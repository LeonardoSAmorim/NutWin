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
{   Constantes e Rotinas Comuns                                         }
{                                                                       }
{   Copyright © 1998 by DIS-EPM/UNIFESP                                 }
{                                                                       }
{ **********************************************************************}

unit NutCnst;

{$R-}

interface

uses Windows, SysUtils, classes, {qrepform, }Db, dbtables, forms, ActiveX,
     Menus, Dialogs, DbConsts, Controls, Math, PRINTERS;

const

  ID_CALCULADORA = 'CALCNUT';
  ID_ORGANIZADOR = 'ORGNUT';
  // Constantes de acesso ao sistema pelo menu
  MN_ACESSOLIBERADO = 0;
  MN_ACESSONEGADO = 1;
  MN_HABILITADO = 2;
  MN_DESABILITADO = 4;
  MN_VISIVEL = 8;
  MN_INVISIVEL = 16;
  // Mensagens de acesso ao sistema
  MSG_ACESSONEGADO = 'Acesso Negado';
  {Declare constants we're interested in}
  eKeyViol = 9729;
  eRequiredFieldMissing = 9732;
  eForeignKey = 9733;
  eDetailsExist = 9734;

   TEXTO_ENDERECO =    'NutWin - Programa de Apoio a Nutrição(R)'+chr(13)+chr(10)+
                       'Copyright (C) 2002-2010 Departamento de Informática em Saúde'+chr(13)+chr(10)+
                       'Universidade Federal de São Paulo - UNIFESP <www.unifesp.br>'+chr(13)+chr(10)+
                       chr(13)+chr(10)+chr(13)+chr(10)+
                       'http://sourceforge.net/projects/nutwin'+chr(13)+chr(10)+
                       chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+
                       'NutWin is free software.  See the GNU General Public '+
                       'License for more details. http://www.gnu.org/licenses/';

   TEXTO_CONTATO =     'Para entrar em contato, acesse o site '+
                       'do projeto NutWin no SourceForge.net.'+chr(13)+chr(10)+chr(13)+chr(10)+
                       TEXTO_ENDERECO;

type

   TConstantes = class(TComponent)
   private
    FCabecLinha: Integer;
    FCabecTexto: String;
    procedure SetCabecLinha(const Value: Integer);
    procedure SetCabecTexto(const Value: String);
   public
      property CabecLinha : Integer read FCabecLinha write SetCabecLinha;
      property CabecTexto : String read FCabecTexto write SetCabecTexto;
   end;

   TGUIDItemState = ( gsNone, gsChecked, gsDisabled, gsInvisible, gsHidden );

   TGUIDItem = class(TComponent)
   private
   public
      Guid : String;
      Exclusive : Boolean;
      State : TGUIDItemState;
   end;

   TTipoOrdem = ( toCrescente, toDecrescente, toNenhuma );

   TOrdenarEquivalente = ( oeAlimento, oeMedida );

   TNomeCalculo = ( ncNenhum, ncAntropometria, ncRecCalorica, ncAtivFisica, ncCalcEspeciais, ncPreparacao, ncInquerito, ncDieta, ncInqFreq, ncMetas);

// Converte GUID para um name valido de componente
function GuidToName( Guid : String; Prefixo : String = '' ) : String;
// Converte um nameGUID para um GUID valido
function NameToGuid( Name : String; Prefixo : String = '' ) : String;

   function GetConstantes : TConstantes;
   function GetPathExe : String;
   function CreateNewGUID : string;
   function InvalidRequiredField( DataSet : TDataset; AlertMessage : Boolean = True ) : TField;
   function AppIsAlreadyRunning(const sUniqueText: String) : Boolean;
   function SetMenuTag( Menu : TForm; sName : String; iTag : Integer ) : Boolean;
   function SetMenuListaTag( Menu : TForm; CommaTextNames : String; iTag : Integer ) : Boolean;
   function mudaSQL(criterio : String) : String;
   function ConverteuBD( LocalNomeBancoCVS, LocalNomeBanco, LocalNomeConversor : String ) : Integer;
   procedure FreeObject(var A : TObject);
   procedure FreeAndNil(var Obj);
   procedure ControlaKeyViolation(DataSet : TDataSet; E : EDatabaseError; var Action : TDataAction; Mens : String);
   procedure NumericoPositivoKeyPress(const EditTexto : String; var Key: Char);
   procedure FormataListaMedidas( ListaMedidas, ListaEstilo : TStringList );
   function FormatFloat2( StrFmt : String; Valor : Double; NZeros : Integer = 10 ) : String;
   function Round5(const Value: Double): Double;

implementation

// Converte GUID para um name valido de componente
function GuidToName( Guid : String; Prefixo : String = '' ) : String;
  procedure Replace(var Str : String; A, B : Char );
  begin
     while Pos(A, Str) > 0 do
       Str[Pos(A, Str)] := B;
  end;
begin
   Result := Guid;
   Replace( Result, '-', '_' );
   Replace( Result, '{', 'G' );
   Replace( Result, '}', 'U' );
   Result := Prefixo + Result;
end;

// Converte NameGUID para um GUID valido
function NameToGuid( Name : String; Prefixo : String = '' ) : String;
  procedure Replace(var Str : String; A, B : Char );
  begin
     while Pos(A, Str) > 0 do
       Str[Pos(A, Str)] := B;
  end;
begin
   Result := Name;
   if Prefixo <> '' then
      Result := StringReplace( Result, Prefixo, '', [rfIgnoreCase] );
   Replace( Result, '_', '-' );
   Replace( Result, 'G', '{' );
   Replace( Result, 'U', '}' );
end;

// Retorna path do exe
function GetPathExe : String;
var
    GsPathExe : String;
begin
    SetLength(GsPathExe, 255);
    Windows.GetModuleFileName(0, pChar(GsPathExe), 255);
    SetLength(GsPathExe, StrLen(pChar(GsPathExe)));
    GsPathExe := ExtractFilePath(GsPathExe);
    if GsPathExe[Length(GsPathExe)] <> '\' then
       GsPathExe := GsPathExe+'\';
    Result := GsPathExe;
end;

// Gera GUID
function CreateNewGUID: string;
var
   NewGUID : TGUID;
   NewString : array [0..49] of WideChar;
begin
   //new (pNewGUID);
   if Succeeded (CoCreateGuid(NewGUID)) then
      begin
         StringFromGUID2(NewGUID, @NewString, 40);
         Result := WideCharToString(NewString);
      end
   else
      Result:='';
end;

function InvalidRequiredField ( DataSet : TDataset; AlertMessage : Boolean = True ): TField;
var
   I: Integer;
begin
   for I := 0 to DataSet.Fields.Count - 1 do
    with DataSet.Fields[I] do
      if Required and not ReadOnly and (FieldKind = fkData) and IsNull then
      begin
        if AlertMessage then
           ShowMessage(Format(SFieldRequired, [DisplayName]));
        FocusControl;
        Result := DataSet.Fields[I];
        exit;
      end;
   Result := nil;
end;

(*
       Description  : Module to insure that just one copy of an application
                      is running at any given time.
                      Call AppIsAlreadyRunning in Project file, and
                      bypass everything if the function returns True.
                      Note that AppIsAlreadyRunning should only be called once.
                      Designed for Delphi 3 or higher, with long strings
                      enabled as default in compiler options.

       Copyright (c) 1999 ASI/EDI, Inc.  All rights reserved.
       Written by Bill Sorensen (tzimisce@mwaccess.net, www.Will.brinet.net).
       Source code published by permission of ASI/EDI, Inc. (www.asiedi.com).

       ASI/EDI Inc. and the author expressly disclaim any warranty,
       express or implied, for this code and documentation.
       Use it at your own risk.
     *)

function AppIsAlreadyRunning(const sUniqueText: String): Boolean;
begin
   // If the named Mutex already exists, there's another copy running.
   if OpenMutex(MUTEX_ALL_ACCESS,False,PChar(sUniqueText)) <> 0 then
      Result := True
   else
      Result := (CreateMutex(nil,False,PChar(sUniqueText)) = 0);
      // Otherwise, create a Mutex with a unique name.
      // This should succeed, unless we're out of resources.
      // Mutex handle is closed automatically when the process terminates.
      // Mutex is destroyed when the last handle to it is closed.
end;

function SetMenuTag( Menu : TForm; sName : String; iTag : Integer ) : Boolean;
var
   ItemMenu : TComponent;
begin
   Result := True;
   ItemMenu := Menu.FindComponent( sName );
   if Assigned( ItemMenu ) and ( ItemMenu is TMenuItem ) then
      TMenuItem( ItemMenu ).Tag := iTag
   else
      Result := False;
end;

function SetMenuListaTag( Menu : TForm; CommaTextNames : String; iTag : Integer ) : Boolean;
var
   I : Integer;
   Lista : TStringList;
begin
   Result := True;
   Lista := TStringList.Create;
   Try
      Lista.CommaText := CommaTextNames;
      for I := 0 to Lista.Count - 1 do
      begin
         if not SetMenuTag( Menu, Lista.Strings[I], iTag ) then
            begin
               Result := False;
               break;
            end;
      end;
   finally
      Lista.Free;
   end;
end;

function mudaSQL(criterio : String): String;
var
   i : Integer;
begin
   Result := '';
   criterio := UpperCase(criterio); // TRANSFORMA TUDO EM LETRAS MAIUSCULAS
   for i := 1 To Length(criterio) do
       Case Char(criterio[i]) of
           'A', 'À', 'Á', 'Ã', 'Ä', 'Â' :  Result := Result + '[AÀÁÃÄÂ]';
           'E', 'É', 'Ê', 'Ë' :            Result := Result + '[EÉÊË]';
           'I', 'Í', 'Î', 'Ï' :            Result := Result + '[IÍÎÏ]';
           'O', 'Ó', 'Ô', 'Ö', 'Õ' :       Result := Result + '[OÓÔÖÕ]';
           'U', 'Ú', 'Û', 'Ü' :            Result := Result + '[UÚÛÜ]';
           'C', 'Ç' :                      Result := Result + '[CÇ]';
       else
           Result := Result + criterio[i]
       end;
end;

procedure FreeObject(var A: TObject);
begin
   A.Free;
   A := nil;
end;

procedure FreeAndNil(var Obj);
var
   P: TObject;
begin
   P := TObject(Obj);
   TObject(Obj) := nil;  // clear the reference before destroying the object
   P.Free;
end;

procedure ControlaKeyViolation(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction; Mens : String);
var
  iDBIError: Integer;
begin
   if Mens = '' then
      Mens := ' Erro de Duplicação de Dados ! Insira outro nome ou valor ou Cancele os dados. ';
   if (E is EDBEngineError) then
   begin
     iDBIError := (E as EDBEngineError).Errors[0].Errorcode;
     case iDBIError of
      eKeyViol:
        begin
          MessageDlg(Mens, mtWarning,[mbOK], 0);
          Abort;
        end;
     end;
   end;
end;

// Permite a entrade somente de números positivos e ponto decimal
procedure NumericoPositivoKeyPress(const EditTexto : String; var Key: Char);
begin
   if not (Key in ['0'..'9', '.', ',', #8]) or
      ( ( ( Pos( '.', EditTexto ) > 0 ) or
      ( Pos( ',', EditTexto ) > 0 ) ) and
      ( ( Key = '.' ) or ( Key = ',' ) ) ) then
      Key := #0;
end;

procedure FormataListaMedidas(ListaMedidas, ListaEstilo: TStringList);

  function MedidaIndexOf( ListaCodMed : TStringList; CodMed : String ) : Integer;
  var I : Integer;
  begin
     Result := -1;
     for I := 0 to ListaCodMed.Count - 1 do
        if Assigned(ListaCodMed.Objects[I]) and
           (TComponent(ListaCodMed.Objects[I]).Name = Trim(CodMed)) then
           begin
              Result := I;
              break;
           end;
   end;
   function PegaCodMed( Str : String ) : String;
   var I : Integer;
   begin
      I := Pos(' ', Str);
      if I > 0 then
         Result := Copy(Str, 1, I)
      else
         Result := Str;
      Result := Trim(Result);
   end;

   function PegaDescMed( Str : String ) : String;
   var I : Integer;
   begin
      I := Pos(' ', Str);
      if I > 0 then
         Result := Copy(Str, I, Length(Str)-I+1)
      else
         Result := Str;
      Result := Trim(Result);
   end;

var
   I, J : Integer;
   ListaTemp : TStringList;
   LinhaBranco : Boolean;
begin
   LinhaBranco := False;
   // desliga ordenação se houver estilo
   if ListaEstilo.Count > 0 then
      ListaMedidas.Sorted := False
   else
      // se não há estilo, deixa na ordem alfabética
      exit;
   // lista temporária
   ListaTemp := TStringList.Create;
   try
      // varre lista de estilo
      for I := 0 to ListaEstilo.Count - 1 do
      begin
         // se consta da lista de estilo
//         J := ListaMedidas.IndexOf( Trim(ListaEstilo.Strings[I]) );
         J := MedidaIndexOf( ListaMedidas, PegaCodMed(ListaEstilo.Strings[I]) );
         if J >= 0 then
           begin
              // Adiciona na ordem que a lista de estilo pede
              ListaTemp.AddObject( ListaMedidas.Strings[J], ListaMedidas.Objects[J] );
              // Deleta, pois não será mais necessário
              ListaMedidas.Delete(J);
              LinhaBranco := False;
           end
         else if (Trim(ListaEstilo.Strings[I]) = '') and not LinhaBranco then
           begin
              // Adiciona pois deve ser um espaço
              ListaTemp.AddObject( '', nil );
              // Pra não ter mais que 1 linha em branco
              LinhaBranco := True;
           end;
      end;
      // copia lista temporária (agora ordenada) para lista de medidas
      for I := ListaTemp.Count - 1 downto 0 do
        begin
           ListaMedidas.InsertObject( 0, ListaTemp.Strings[I], ListaTemp.Objects[I] );
        end;
   finally
      ListaTemp.Free;
   end;
end;

function ConverteuBD( LocalNomeBancoCVS, LocalNomeBanco, LocalNomeConversor : String ) : Integer;
var
  StartInfo  : TStartupInfo;
  ProcInfo   : TProcessInformation;
  CreateOK   : Boolean;
begin
  Result := 0;
  if FileExists( LocalNomeBancoCVS ) then
  begin
     // Confirma conversão
     if FileExists( LocalNomeBanco ) then
        if (MessageDlg('ATENÇÃO! Agora será feito o processo de conversão.'+#13#10+
                        'Ele pode ser demorado, mas é indispensável para o uso do programa.'+#13#10+
                        'Deseja fazê-lo agora?',
                         mtConfirmation, [mbYes, mbNo], 0) = mrNo ) then
        begin
           Result := -1;
           exit;
        end;

     Screen.Cursor := crHourGlass;

     { fill with known state }
     FillChar(StartInfo,SizeOf(TStartupInfo),#0);
     FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
     StartInfo.cb := SizeOf(TStartupInfo);

     CreateOK := CreateProcess(PChar(LocalNomeConversor),nil, nil, nil,False,
                 CREATE_NEW_PROCESS_GROUP+NORMAL_PRIORITY_CLASS,
                 nil, nil, StartInfo, ProcInfo);

     { check to see if successful }
     if CreateOK then
       //may or may not be needed. Usually wait for child processes
       WaitForSingleObject(ProcInfo.hProcess, INFINITE);

     Screen.Cursor := crDefault;

     // Não deixa continuar se não comcluiu conversão
     if FileExists( LocalNomeBancoCVS ) then
     begin
         ShowMessage( 'A conversão da base de dados não foi concluída.'+#13#10+
                      'Contate o suporte e informe o problema.' );
         Result := -1;
         exit;
     end;

  end;

end;

{function FormatFloat2( StrFmt : String; Valor : Double ) : String;
var
   I : Integer;
begin
   I := 0;
   Result := FormatFloat( StrFmt, Valor );
   while ( StrToFloat( Result ) = 0 ) and ( Valor <> 0 ) and ( I < 10 ) do
   begin
      StrFmt := StrFmt + '0';
      Result := FormatFloat( StrFmt, Valor );
      Inc(I);
   end;
end;}

function FormatFloat2( StrFmt : String; Valor : Double; NZeros : Integer = 10 ) : String;
var
   a, b : Integer;
begin
   if Valor < 1 then // só para valores menores que 1. Ex.: 0.0001
   begin
      b := Length( StrFmt ) - Pos( '.', StrFmt ); // b índica quantas casa já tem depois do ponto
      if ( b > 0 ) and ( b < 10 ) then // só faz se tiver ponto ou menos casas que 10
      begin
         a := (NZeros - Length( IntToStr( Trunc( IntPower(10, NZeros) * Valor ) ) ) ) + 1; // calcula quantos zeros são necessários a mais
         if ( a > b ) then // só se faltar zeros
            StrFmt := StrFmt + Copy('0000000000', 1, a - b ); // completa com os zeros que faltam
      end;
   end;
   Result := FormatFloat( StrFmt, Valor );
end;

function Round5(const Value: Double): Double;
var
   Inteiro : Integer;
   Resto : Double;
begin
   Result := Value;
   Inteiro := Trunc( Value );
   Resto := Value - Inteiro;
   if Resto > 0.75 then
      Result := Inteiro + 1
   else if (( Resto >= 0.5 ) and ( Resto <= 0.75 )) or
           (( Resto >= 0.25) and ( Resto <= 0.5 )) then
      Result := Inteiro + 0.5
   else if Resto < 0.25 then
     begin
        if Inteiro = 0 then
           Result := 0.5
        else
           Result := Inteiro;
     end;
end;

{ TConstantes }

function GetConstantes : TConstantes;
begin
   Result := TConstantes( Application.FindComponent('Constantes') );
   if Result = nil then
   begin
      Result := TConstantes.Create( Application );
      Result.Name := 'Constantes';
   end;
end;

procedure TConstantes.SetCabecLinha(const Value: Integer);
begin
  FCabecLinha := Value;
end;

procedure TConstantes.SetCabecTexto(const Value: String);
begin
  FCabecTexto := Value;
end;

end.

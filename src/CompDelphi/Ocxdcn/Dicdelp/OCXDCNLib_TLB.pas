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




unit OCXDCNLib_TLB;

interface

uses
    dsgnintf, Activex, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Composite;

type
  TDicionario = class(TComponent) 
  private
    { Private fields of TDic }
    { Storage for property DataSourceName }
    FDataSourceName : String;
    FTipoDicionario : String;
    FSiglaDicionario: String;
    FNroFilhosMax : Smallint;
    FNroNiveisMax: Smallint;
    FNomeDicionario: String;
    FDataCriacao: TOleDate;
    FDataAlteracao: TOleDate;
    FFonteDicionario: String;
    FVersaoDicionario: String;
    FIDUsuario: String;
    FSenhaUsuario: String;
    { Storage for property BDAtivo }
    FPropertyAtiva : TOleBool;
    ANode : TComponentNode;

  protected

    procedure SetDataSourceName(Index: Integer; const Value: string);
    function GetDataSourceName(Index: Integer): string;

    procedure SetTipoDicionario(Index: Integer; const Value: string);
    function GetTipoDicionario(Index: Integer): string;

    procedure SetSiglaDicionario(Index: Integer; const Value: string);
    function GetSiglaDicionario(Index: Integer): string;

    procedure SetIntROProp(Index: Integer; Value: Smallint);
    function GetNroFilhosMax(Index: Integer): Smallint;
    function GetNroNiveisMax(Index: Integer): Smallint;

    procedure SetStrROProp(Index: Integer; const Value: string);
    function GetNomeDicionario(Index: Integer): string;

    procedure SetDtROProp(Index: Integer; const Value: TOleDate);
    function GetDataCriacao(Index: Integer): TOleDate;
    function GetDataAlteracao(Index: Integer): TOleDate;

    function GetFonteDicionario(Index: Integer): string;
    function GetVersaoDicionario(Index: Integer): string;

    procedure SetIdUsuario(Index: Integer; const Value: string);
    function GetIDUsuario(Index: Integer): string;

    procedure SetSenhaUsuario(Index: Integer; const Value: string);
    function GetSenhaUsuario(Index: Integer): string;

    procedure SetConnected(Index: Integer; Value: TOleBool);
    function GetConnected(Index: Integer): TOleBool;

    procedure SetPropertyAtiva(Index: Integer; Value: TOleBool);
    function GetPropertyAtiva(Index: Integer): TOleBool;

  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    function GetFirstSon(var Code, Description: WideString): TOleBool; stdcall;
    function GetNextBrother(var Code, Description: WideString): TOleBool; stdcall;
    function NextBrotherIsDone: TOleBool; stdcall;
    function GetLastSon(var Code, Description: WideString): TOleBool; stdcall;
    function GetPreviousBrother(var Code, Description: WideString): TOleBool; stdcall;
    function PreviousBrotherIsDone: TOleBool; stdcall;
    function GetCurrentParent(var Code, Description: WideString): TOleBool; stdcall;
    function GetCurrentSon(var Code, Description: WideString): Smallint; stdcall;
    function FindParents(const SonCode: WideString; var FirstFatherCode: WideString): Smallint; stdcall;
    function GetFirstParent(var Code, Description: WideString): TOleBool; stdcall;
    function GetNextParent(var Code, Description: WideString): TOleBool; stdcall;
    function FindDescriptionByCode(const Code: WideString; var Description: WideString): TOleBool; stdcall;
    function ConnectDictionary(const UserID, UserPassword: WideString): TOleBool;virtual; stdcall;
    function ExpandCode(const Code: WideString; var ChildrenNumber: Smallint): TOleBool; stdcall;
    procedure DisconnectDictionary;virtual; stdcall;
    function GetFirstCodeByDesc(var Code, Description: WideString): TOleBool;virtual; stdcall;
    function GetNextCodeByDesc(var Code, Description: WideString): TOleBool;virtual; stdcall;
    function FindCodeByDescription(var Code: WideString; const Description: WideString): Smallint;virtual; stdcall;
    function GetChildrenCount(const Code: WideString; var ChildrenNumber: Smallint): TOleBool; stdcall;
    function HasChilds(const Code: WideString): TOleBool; stdcall;
    function CollapseCode(const Code: WideString; var ChildrenNumber: Smallint): TOleBool; stdcall;
    procedure AboutBox; stdcall;
  published
    property DataSourceName: string index 1 read GetDataSourceName write SetDataSourceName;
    property TipoDicionario: string index 2 read GetTipoDicionario write SetTipoDicionario;
    property SiglaDicionario: string index 3 read GetSiglaDicionario write SetSiglaDicionario;
    property NroFilhosMax: Smallint index 5 read GetNroFilhosMax write SetIntROProp stored False;
    property NroNiveisMax: Smallint index 6 read GetNroNiveisMax write SetIntROProp stored False;
    property NomeDicionario: string index 7 read GetNomeDicionario write SetStrROProp stored False;
    property DataCriacao: TOleDate index 8 read GetDataCriacao write SetDtROProp stored False;
    property DataAlteracao: TOleDate index 9 read GetDataAlteracao write SetDtROProp stored False;
    property FonteDicionario: string index 10 read GetFonteDicionario write SetStrROProp stored False;
    property VersaoDicionario: string index 11 read GetVersaoDicionario write SetStrROProp stored False;
    property IDUsuario: string index 12 read GetIDUsuario write SetIdUsuario;
    property SenhaUsuario: string index 13 read GetSenhaUsuario write SetSenhaUsuario;
    property Connected: TOleBool index 14 read GetConnected write SetConnected;
    property DSNPropertyAtiva: TOleBool index 4 read GetPropertyAtiva write SetPropertyAtiva default True;
  end;

type
  TDicionarioEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure Register;

implementation

uses AboutDlg,PropDlg;

    procedure TDicionario.SetDataSourceName(Index: Integer; const Value: string);
    begin
    FDataSourceName:=Value;
    end;
    function TDicionario.GetDataSourceName(Index: Integer): string;
    begin
    Result:=FDataSourceName;
    end;

    procedure TDicionario.SetTipoDicionario(Index: Integer; const Value: string);
    begin
    FTipoDicionario:=Value;
    end;
    function TDicionario.GetTipoDicionario(Index: Integer): string;
    begin
    Result:=FTipoDicionario;
    end;

    procedure TDicionario.SetSiglaDicionario(Index: Integer; const Value: string);
    begin
    FSiglaDicionario:=Value;
    end;
    function TDicionario.GetSiglaDicionario(Index: Integer): string;
    begin
    Result:=FSiglaDicionario;
    end;
    function TDicionario.GetNomeDicionario(Index: Integer): string;
    begin
    Result:=FNomeDicionario;
    end;

    procedure TDicionario.SetIntROProp(Index: Integer; Value: Smallint);
    begin
    end;
    function TDicionario.GetNroFilhosMax(Index: Integer): Smallint;
    begin
    Result:=FNroFilhosMax;
    end;
    function TDicionario.GetNroNiveisMax(Index: Integer): Smallint;
    begin
    Result:=FNroNiveisMax;
    end;

    procedure TDicionario.SetDtROProp(Index: Integer; const Value: TOleDate);
    begin
    end;
    function TDicionario.GetDataCriacao(Index: Integer): TOleDate;
    begin
    Result:=FDataCriacao;
    end;
    function TDicionario.GetDataAlteracao(Index: Integer): TOleDate;
    begin
    Result:=FDataAlteracao;
    end;

    procedure TDicionario.SetStrROProp(Index: Integer; const Value: string);
    begin
    end;
    function TDicionario.GetFonteDicionario(Index: Integer): string;
    begin
    Result:=FFonteDicionario;
    end;
    function TDicionario.GetVersaoDicionario(Index: Integer): string;
    begin
    Result:=FVersaoDicionario;
    end;

    procedure TDicionario.SetIdUsuario(Index: Integer; const Value: string);
    begin
    FIDUsuario:=Value;
    end;
    function TDicionario.GetIDUsuario(Index: Integer): string;
    begin
    Result:=FIDUsuario;
    end;

    procedure TDicionario.SetSenhaUsuario(Index: Integer; const Value: string);
    begin
    FSenhaUsuario:=Value;
    end;
    function TDicionario.GetSenhaUsuario(Index: Integer): string;
    begin
    end;

    procedure TDicionario.SetConnected(Index: Integer; Value: TOleBool);
    begin
    end;
    function TDicionario.GetConnected(Index: Integer): TOleBool;
    begin
    Result:=False;
    if Assigned (ANode) and Assigned (ANode.m_Database) then
       Result:= ANode.m_Database.Connected;
    end;

    procedure TDicionario.SetPropertyAtiva(Index: Integer; Value: TOleBool);
    begin
    FPropertyAtiva:=Value;
    end;
    function TDicionario.GetPropertyAtiva(Index: Integer): TOleBool;
    begin
    Result:=FPropertyAtiva;
    end;

constructor TDicionario.Create (AOwner: TComponent);
begin
if not Assigned(ANode) then
   begin
   ANode:=  TComponentNode.Create(self);
   end;
inherited Create(AOwner);
   FPropertyAtiva:=True;
end;

destructor TDicionario.Destroy;
begin
   if Assigned(ANode) then
      begin
      if Assigned (ANode.m_Database) and ANode.m_OwnDatabase then
         ANode.m_Database.Connected:=False;
      ANode.Free;
      ANode:=nil;
      end;
   inherited Destroy;
end;


function TDicionario.GetFirstSon(var Code, Description: WideString): TOleBool; stdcall;
var
m_CodeAux, m_DescAux: string;
begin
Result:=FALSE;

m_CodeAux:='';
m_DescAux:='';

if Assigned(ANode) then
	Result := ANode.GetFirstSon(m_CodeAux,m_DescAux);

Code:=m_CodeAux;
Description:=m_DescAux;

end;

function TDicionario.GetNextBrother(var Code, Description: WideString): TOleBool; stdcall;
var
m_CodeAux, m_DescAux: string;
begin
Result:=FALSE;

m_CodeAux:='';
m_DescAux:='';

if Assigned(ANode) then
	Result := ANode.GetNextBrother(m_CodeAux,m_DescAux);

Code:=m_CodeAux;
Description:=m_DescAux;

end;

function TDicionario.NextBrotherIsDone: TOleBool; stdcall;
begin
Result:=FALSE;

if Assigned(ANode) then
	Result := ANode.NextBrotherIsDone();

end;

function TDicionario.GetLastSon(var Code, Description: WideString): TOleBool; stdcall;
var
m_CodeAux, m_DescAux: string;
begin
Result:=FALSE;

m_CodeAux:='';
m_DescAux:='';

if Assigned(ANode) then
	Result := ANode.GetLastSon(m_CodeAux,m_DescAux);

Code:=m_CodeAux;
Description:=m_DescAux;

end;

function TDicionario.GetPreviousBrother(var Code, Description: WideString): TOleBool; stdcall;
var
m_CodeAux, m_DescAux: string;
begin
Result:=FALSE;

m_CodeAux:='';
m_DescAux:='';

if Assigned(ANode) then
	Result := ANode.GetPreviousBrother(m_CodeAux,m_DescAux);

Code:=m_CodeAux;
Description:=m_DescAux;

end;

function TDicionario.PreviousBrotherIsDone: TOleBool; stdcall;
begin
Result:=FALSE;

if Assigned(ANode) then
	Result := ANode.PreviousBrotherIsDone;

end;

function TDicionario.GetCurrentParent(var Code, Description: WideString): TOleBool; stdcall;
var
m_CodeAux, m_DescAux: string;
begin
Result:=FALSE;

m_CodeAux:='';
m_DescAux:='';

if Assigned(ANode) then
	Result := ANode.GetCurrentParent(m_CodeAux,m_DescAux);

Code:=m_CodeAux;
Description:=m_DescAux;

end;

function TDicionario.GetCurrentSon(var Code, Description: WideString): Smallint; stdcall;
var
m_CodeAux, m_DescAux: string;
son_idx:smallint;
begin

m_CodeAux:='';
m_DescAux:='';
son_idx:=-1;

if Assigned(ANode) then
    son_idx := ANode.GetCurrentSon(m_CodeAux,m_DescAux);

Code:=m_CodeAux;
Description:=m_DescAux;

Result:=son_idx;
end;

function TDicionario.FindParents(const SonCode: WideString; var FirstFatherCode: WideString): Smallint; stdcall;
var
FFAux:string;
num_pais: smallint;
begin
FFAux:='';
num_pais := -1;

 if Assigned(ANode) then
    num_pais :=  ANode.FindParents(SonCode,FFAux);

FirstFatherCode:=FFAux;

Result:= num_pais;

end;

function TDicionario.GetFirstParent(var Code, Description: WideString): TOleBool; stdcall;
var
m_CodeAux, m_DescAux: string;
begin
Result:=FALSE;

m_CodeAux:='';
m_DescAux:='';

 if Assigned(ANode) then
    Result:=ANode.GetFirstParent(m_CodeAux,m_DescAux);

Code:=m_CodeAux;
Description:=m_DescAux;

end;

function TDicionario.GetNextParent(var Code, Description: WideString): TOleBool; stdcall;
var
m_CodeAux, m_DescAux: string;
begin
Result:=FALSE;

m_CodeAux:='';
m_DescAux:='';

 if Assigned(ANode) then
    Result:=ANode.GetNextParent(m_CodeAux,m_DescAux);

Code:=m_CodeAux;
Description:=m_DescAux;

end;

function TDicionario.FindDescriptionByCode(const Code: WideString; var Description: WideString): TOleBool; stdcall;
var
m_DescAux:string;
begin
Result:=FALSE;
m_DescAux:='';

if Assigned(ANode) then
        Result := ANode.FindDescriptionByCode(Code,m_DescAux);

Description:=m_DescAux;
end;

function TDicionario.ConnectDictionary(const UserID, UserPassword: WideString): TOleBool; stdcall;
var
UID : string;
UPW : string;
begin
 UID := UserID;
 UPW:=UserPassword;
 //Vou conectar num novo banco de dicionários
 //Por isso, desconecto tudo o que tiver aberto
 //liberando a memoria e os recordsets.



 //Se o dicionario foi criado, apague ele.
 if Assigned(ANode) then
  begin
  if Assigned (ANode.m_Database) and ANode.m_OwnDatabase then
    ANode.m_Database.Connected:=False;
  end
 else
     begin
     Result:=False;
     exit;
     end;

 //A02-Alteracao do UID e PassWord
 //Se os parametros são branco, prevalece o default das variáveis
 //da classe m_UserID e m_UserPass.
 //Caso contrario, as variaveis da classe são atualizadas com os valores
 //dos parametros UserID e UserPassword.

 //Retira brancos
 UID:=Trim(UID);
 UPW:=Trim(UPW);


 ANode.m_UserId:=UID;
 ANode.m_UserPw:=UPW;

	//Se tudo da certo, esta funcao retorna com o novo banco aberto
	if (ANode.InitRootNode (self)=True) then
           begin
           FDataAlteracao:=ANode.m_CCSISDIC.FieldByName ('data_alteracao').AsDateTime;

           FDataCriacao:=ANode.m_CCSISDIC.FieldByName ('data_criacao').AsDateTime;

           FFonteDicionario:=ANode.m_CCSISDIC.FieldByName ('fonte').AsString;

           FNomeDicionario:=ANode.m_CCSISDIC.FieldByName ('nome').AsString;

           FNroFilhosMax:=ANode.m_CCSISDIC.FieldByName ('max_filhos').AsInteger;

           FNroNiveisMax:=ANode.m_CCSISDIC.FieldByName ('num_niveis').AsInteger;

           FVersaoDicionario:=ANode.m_CCSISDIC.FieldByName ('versao').AsString;

           //Liberar tudo pois não será mais usado com este DSN
           //Sempre liberar antes de ir para uma caixa de dialogo.
           ANode.m_CCSISDIC.Close;

           Result:=True;
           end
        else
            Result:=False;

end;

function TDicionario.ExpandCode(const Code: WideString; var ChildrenNumber: Smallint): TOleBool; stdcall;
var
ChildNum: SmallInt;
begin
Result:=FALSE;
ChildNum:=0;

if Assigned(ANode) then
        Result := ANode.ExpandCode(Code,ChildNum);

ChildrenNumber:=ChildNum;
end;

procedure TDicionario.DisconnectDictionary;
begin
 //Se o dicionario foi criado, apague ele.
 if Assigned(ANode) then
    begin
    if Assigned(ANode.m_Database) and ANode.m_OwnDatabase then
       ANode.m_Database.Connected:=False;
    end;
end;

function TDicionario.GetFirstCodeByDesc(var Code, Description: WideString): TOleBool; stdcall;
var
m_CodeAux,m_DescAux: string;
begin
Result:=FALSE;

m_CodeAux:='';
m_DescAux:='';

if Assigned(ANode) then
        Result := ANode.GetFirstCodeByDesc(m_CodeAux,m_DescAux);

	Code:= m_CodeAux;
	Description:=m_DescAux;

end;

function TDicionario.GetNextCodeByDesc(var Code, Description: WideString): TOleBool; stdcall;
var
m_CodeAux,m_DescAux: string;
begin
Result:=FALSE;

m_CodeAux:='';
m_DescAux:='';

if Assigned(ANode) then
        Result := ANode.GetNextCodeByDesc(m_CodeAux,m_DescAux);

	Code:= m_CodeAux;
	Description:=m_DescAux;

end;

function TDicionario.FindCodeByDescription(var Code: WideString; const Description: WideString): Smallint; stdcall;
var
m_CodeAux: string;
begin

Result := -1;

m_CodeAux:='';

if Assigned(ANode) then
        Result := ANode.FindCodeByDescription(m_CodeAux,Description);

Code:=m_CodeAux;
end;

function TDicionario.GetChildrenCount(const Code: WideString; var ChildrenNumber: Smallint): TOleBool; stdcall;
var
ChildNum : Smallint;
begin
Result:=FALSE;
ChildNum:=-1;

if Assigned(ANode) then
        Result := ANode.GetChildrenCount(Code,ChildNum);

ChildrenNumber:=ChildNum;

end;

function TDicionario.HasChilds (const Code: WideString): TOleBool; stdcall;
begin
Result:=False;

if Assigned(ANode) then
        Result := ANode.HasChilds(Code);

end;

function TDicionario.CollapseCode(const Code: WideString; var ChildrenNumber: Smallint): TOleBool; stdcall;
var
ChildNum : Smallint;
begin
Result:=FALSE;
ChildNum:=0;

if Assigned(ANode) then
        Result := ANode.CollapseCode(Code,ChildNum);

ChildrenNumber:=ChildNum;
end;

procedure TDicionario.AboutBox;
var
Abt :TDlgAbout;
begin
Abt := TDlgAbout.Create(Application);
Abt.ShowModal;
end;


{ TDicionarioEditor }


procedure TDicionarioEditor.ExecuteVerb(Index: Integer);
var
PrpDlg:TPropPageDlg;
ADic:TDicionario;
begin
  case Index of
    0: begin
       end;
    1: begin
       ADic:=(Component As TDicionario);
       PrpDlg:=TPropPageDlg.CreatePP(Application,ADic.DataSourceName,
                                     ADic.TipoDicionario,ADic.SiglaDicionario,
                                     ADic.DSNPropertyAtiva);

       PrpDlg.ShowModal;

       ADic.DataSourceName:=PrpDlg.DSName;
       ADic.TipoDicionario:=PrpDlg.Tipo;
       ADic.SiglaDicionario:=PrpDlg.Sigla;
       ADic.DSNPropertyAtiva:=PrpDlg.ChBoxAtiva.Checked;
       PrpDlg.Free;

       if Designer <> nil then Designer.Modified;
       end;
    2: TDicionario(Component).AboutBox;
  end;
end;

function TDicionarioEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit';
    1: Result := 'Properties...';
    2: Result := 'About...';
  end;
end;

function TDicionarioEditor.GetVerbCount: Integer;
begin
 Result := 3;
end;


procedure Register;
begin
  RegisterComponents('Dicionario', [TDicionario]);
  RegisterComponentEditor(TDicionario, TDicionarioEditor);
end;

end.

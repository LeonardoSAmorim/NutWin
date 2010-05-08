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




unit Composite;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables;

type
  TComponentNode = class(TDataModule)
    m_Tab_PF: TQuery;
    m_PFHasCh: TTable;
    m_Flat_Table: TTable;
    m_FindParentRec: TTable;
    m_Flat_Like: TQuery;
    CGenericLikeDescr: TDataSource;
    CJoinPF: TDataSource;
    CFlatTable: TDataSource;
    CPaisQuery: TDataSource;
    CPFTable: TDataSource;
    m_CCSISDIC: TTable;
    procedure m_DatabaseLogin(Database: TDatabase; LoginParams: TStrings);
  private
    { Private declarations }
  protected
    m_SQLJoinPF_Flat : String;
    m_SQLLike : String;
    m_szCurrentCodeNode : String;
    m_bIsOnBegin : Boolean;
    m_bIsOnEnd : Boolean;
    m_bIsEmpty : Boolean;
    m_RecordCount : Longint;
    m_CurrentRecord : Longint;
    m_ParentCount: Longint;
    m_nCurrentParentRecord : Longint;
    m_CurrentFoundCode : Longint;
    m_nFoundCount : Longint;
    m_bParentIsEmpty : Boolean;
    m_bCodeIsEmpty : Boolean;

    m_FieldCodigo : string;
    m_FieldDescricao : string;
    m_FieldPai : string;
    m_FieldFilho : string;

    m_FilterFlat : string;
    m_FilterPais : string;
    m_FilterFilhos : string;

    m_sTableNamePF: string;
    m_sTableNameFlat: string;
    m_NomeBanco:string;
    sSelect: string;
    sFrom : string;
    sFilter : string;
    sFieldOneName : string;
    sFieldTwoName : string;

    DicName : string;
    
    procedure MontaQuerys (Sigla: String);
    procedure MontaJoin (Join:TQuery;Codigo: string);
    procedure PreparaTabelas (DBAlias: string);

  public
    { Public declarations }
    m_Database : TDatabase;
    m_UserPw,m_UserId : string;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    class function CreateRootNode (AContainer: TComponent): TComponentNode;
    function InitRootNode (AContainer: TComponent): Boolean;
    function GetComposite : TComponentNode;virtual;
    function ExpandCode(Code : String; var ChildrenNumber: Smallint):Boolean;
    function GetChildrenCount(Code: string; var ChildrenNumber:Smallint):Boolean;
    function GetNextBrother(var Code: string; var Description: string):Boolean;
    function NextBrotherIsDone : Boolean;
    function GetLastSon(var Code:string; var Description: string): Boolean;
    function GetPreviousBrother(var Code: string; var Description: string): boolean;
    function PreviousBrotherIsDone: Boolean;
    function GetCurrentParent(var Code:string; var Description:string) : Boolean;
    function GetCurrentSon(var Code:string; var Description: string) : SmallInt;
    function FindParents( SonCode: string; var  FirstFather:string):SmallInt;
    function GetFirstParent(var Code: string; var Description: string): Boolean;
    function GetNextParent(var Code: string; var Description: string) : Boolean;
    function FindCodeByDescription(var Code: string; Description:string): SmallInt;
    function GetFirstCodeByDesc(var Code: string; var Description: string): Boolean;
    function GetNextCodeByDesc(var Code: string; var Description: string): Boolean;
    function CollapseCode( Code: string; var ChildrenNumber: SmallInt): Boolean;

    function HasChilds(Code: string): Boolean;
    function FindDescriptionByCode(Code: string; var Description: string): Boolean;
    function GetFirstSon(var Code, Description: string):Boolean;

 end;


var
  ComponentNode: TComponentNode;

implementation

uses OCXDCNLib_TLB;

{$R *.DFM}
constructor TComponentNode.Create(AOwner : TComponent);
begin
    inherited Create(AOwner);
     m_szCurrentCodeNode:='';
     m_RecordCount:=0;
     m_CurrentRecord:=0;
     m_bIsEmpty:=TRUE;
     m_ParentCount:=0;
     m_bIsOnEnd:=FALSE;
     m_bIsOnBegin:=FALSE;
     m_nCurrentParentRecord:=0;
     m_CurrentFoundCode:=0;
     m_nFoundCount:=0;
     m_bParentIsEmpty:=TRUE;
     m_bCodeIsEmpty:=TRUE;


end;

destructor TComponentNode.Destroy;
begin
if Assigned (m_Database) and m_Database.Connected then
   m_Database.Connected:=False;

inherited Destroy;
end;

class function TComponentNode.CreateRootNode (AContainer: TComponent): TComponentNode;
var
DicContainer : TDicionario;
begin
DicContainer:= AContainer as TDicionario;
Result:=Nil;
end;

function TComponentNode.InitRootNode (AContainer: TComponent): Boolean;
var
DicContainer : TDicionario;
begin
DicContainer:= AContainer as TDicionario;
DicName := DicContainer.Name;

MontaQuerys (DicContainer.SiglaDicionario);
PreparaTabelas(DicContainer.DataSourceName);


if not Assigned (m_Database) then
   begin
   Result:=False;
   exit;
   end;

      try
       m_Database.Open;
      except
       On E: EDataBaseError do
          begin
          ShowMessage('Dicionario - Erro no Banco : (InitRootNode)'+ #13+#10 + E.Message + #13+#10+
                      'Para Paradox nao esquecer os *.MB (*.DB,*.PX,*.MB)');
          Result:= False;
          exit;
          end;
       end;

      try
       m_CCSISDIC.Open;
      except
       On E: EDataBaseError do
          begin
          ShowMessage('Dicionario - Erro na tabela CCSISDIC : (InitRootNode)'+ #13+#10 + E.Message);
          Result:= False;
          exit;
          end;
       end;

MontaJoin(m_Tab_PF,'ROOT');
m_szCurrentCodeNode:='ROOT';
m_bIsOnBegin:=FALSE;
m_bIsOnEnd:=FALSE;

      try
      m_Tab_PF.Open;
      except
       On E : EDataBaseError do
          begin
          ShowMessage('Dicionario - Erro na Query : ' + m_SQLJoinPF_Flat + ' Join de Pais e Filhos : (InitRootNode)'+ #13+#10 + E.Message + #13+#10+ 'Parametro Codigo = ROOT' );
          end;
       end;

m_bIsEmpty:=m_Tab_PF.IsEmpty;

if m_bIsEmpty then
   begin
   Result:=False;
   exit;
   end;

m_Tab_PF.FetchAll;
m_RecordCount:=m_Tab_PF.RecordCount;
m_Tab_PF.First;
m_bIsOnBegin:=True;
Result:=True;

end;



function TComponentNode.GetComposite : TComponentNode;
begin
Result:=nil;
end;

function TComponentNode.ExpandCode(Code : String; var ChildrenNumber: Smallint):boolean;
var
Aux: string;
begin
//Se da algum problema com este método, m_bIsEmpty=TRUE,
//impedindo dos outros métodos darem pau.
if not Assigned (m_Database) or not (m_Database.Connected = True) then
   begin
   ChildrenNumber:=-1;			//-1 indica erro
   Result:= False;
   m_bIsEmpty:=True;
   exit;
   end;
   if (HasChilds (Code)) then
      begin
      //Se o recordset esta aberto, fecha ele
      if (m_Tab_PF.Active) then m_Tab_PF.Close;

      //Atualiza o novo parametro
      MontaJoin (m_Tab_PF, Code);

      try
            m_Tab_PF.Open;
      except
       On E : EDataBaseError do
          begin

          ShowMessage('Dicionario - Erro na Query Join de Pais e Filhos : (ExpandCode)'+ #13+#10 + E.Message + #13+#10+ 'Parametro Codigo = '+ Code );

          m_RecordCount:=0;
          m_CurrentRecord:=0;
          m_bIsEmpty:=TRUE;			// The recordset is empty
          m_bIsOnBegin:=False;
          m_bIsOnEnd:=False;
          ChildrenNumber:=-1;			//-1 indica erro
          Result:= False;
          exit;
          end;
       end;

       m_bIsEmpty:=m_Tab_PF.IsEmpty;

       if m_bIsEmpty then
          begin
          //Nao deve acontecer nunca
          m_RecordCount:=0;
          m_CurrentRecord:=0;
          m_bIsEmpty:=TRUE;			// The recordset is empty
          m_bIsOnBegin:=False;
          m_bIsOnEnd:=False;
          ChildrenNumber:=-1;			//-1 indica erro
          Result:= False;
          exit;
          end;

      m_Tab_PF.FetchAll;
      //Conta a quantidade de registros
      m_RecordCount:=m_Tab_PF.RecordCount;

      m_bIsEmpty:=FALSE;			// The recordset has one record

      m_CurrentRecord:=0;
      ChildrenNumber:=m_RecordCount;

      m_Tab_PF.First;			// First record is current again
      m_bIsOnBegin:=TRUE;

      m_szCurrentCodeNode:=Code;

      Result:= TRUE;
      exit;

      end
   else
       begin
       //Checa se o codigo e valido
       if (FindDescriptionByCode(Code, Aux)) then
           begin
           ChildrenNumber:=0;	// Valor Valido
           Result:= FALSE;	//Nao tem filhos, nao da pra expandir
           exit;
           end;
       end;

ChildrenNumber:=-1;		//-1 indica erro
Result:=FALSE;
end;

function  TComponentNode.GetChildrenCount(Code: string; var ChildrenNumber:smallint):Boolean;
var
Desc_Aux:string;
begin
     //Se tem erro, o numero de filhos é inválido
     ChildrenNumber:=-1;


     //Verifica o Banco de dados
     if not Assigned (m_Database) or not (m_Database.Connected = True) then
        begin
        ChildrenNumber:=-1;			//-1 indica erro
        Result:= False;
        exit;
        end;

     //Se o recordset esta aberto, fecha ele
     if (m_PFHasCh.Active) then
        m_PFHasCh.Close;

     //Seta o novo parametro
     m_PFHasCh.Filter:=m_FilterFilhos + '''' + Code + '''';
     m_PFHasCh.Filtered:=True;

       try
       m_PFHasCh.Open;
       except
       On E : EDataBaseError do
          begin
          ShowMessage('Dicionario - Erro na tabela de pesquisa de filhos (GetChildrenCount): '+ #13+#10 + E.Message + #13+#10+ 'Filtro : ' + m_PFHasCh.Filter);
          ChildrenNumber:=-1;			//-1 indica erro
          Result:= False;
          exit;
          end;
       end;

    //Se o codigo e uma folha, ele nao esta como chave da tabela
    //pais e filhos. Ele nao tem Filhos.
    //Retorna FALSE com numero de filhos = 0
    if( m_PFHasCh.IsEmpty ) then
        begin
        //Checa se o codigo e valido
        if (not FindDescriptionByCode(Code, Desc_Aux)) then
           begin
           Result:=False; //Codigo invalido => ChildrenNumber = -1
           ChildrenNumber:=-1;
           exit;
           end;

        ChildrenNumber:=0;
        Result := False;
        exit;
        end;


    //Conta a quantidade de registros
    ChildrenNumber:=m_PFHasCh.RecordCount;
    Result:=True;
    exit;
end;

function TComponentNode.GetFirstSon(var Code, Description: string):Boolean;
begin
	if( m_bIsEmpty) then		// The recordset is empty?
		begin
		Code:='';
		Description:='';
		Result:= False;		// Yes
                exit;
		end;

	m_Tab_PF.First;				// First record is current again

	m_CurrentRecord:=0;
	m_bIsOnBegin:=TRUE;
	m_bIsOnEnd:=FALSE;


	Code := m_Tab_PF.FieldByName(sFieldOneName).AsString;

	Description := m_Tab_PF.FieldByName (sFieldTwoName).AsString;

	Result:= True;

end;

function TComponentNode.GetNextBrother(var Code: string; var Description: string):Boolean;
begin
   if( m_bIsEmpty or m_bIsOnEnd or (m_RecordCount=1)) then		// The recordset is empty?
           begin
           Code:='';
           Description:='';
           Result:= False;		// Yes
           exit;
           end;


   m_Tab_PF.Next;

   m_CurrentRecord:=m_CurrentRecord+1;

   Code := m_Tab_PF.FieldByName (sFieldOneName).AsString;

   Description := m_Tab_PF.FieldByName (sFieldTwoName).AsString;

   m_bIsOnBegin:=FALSE;


   // The recordset is finished?
   if ((m_CurrentRecord +1) >= m_RecordCount ) then
	m_bIsOnEnd:=True
   else
   	m_bIsOnEnd:=False;

   Result:= TRUE;

end;

function TComponentNode.NextBrotherIsDone : Boolean;
begin
  if( m_bIsEmpty or (m_RecordCount=1)) then	// The recordset is empty?
      begin
      Result:= TRUE;				// Yes
      exit;
      end;

  if (m_bIsOnEnd=TRUE and m_bIsOnBegin=FALSE) then	// The recordset is finished?
      begin
      Result:= TRUE;				// Yes
      exit;
      end;

  Result:= FALSE;

end;

function TComponentNode.GetLastSon(var Code:string; var Description: string): Boolean;
begin
	if( m_bIsEmpty) then		// The recordset is empty?
            begin
            Code:='';
            Description:='';
            Result:= FALSE;		// Yes
            exit;
            end;

	m_Tab_PF.Last;				// Last record is current now

	m_CurrentRecord:=m_RecordCount-1;

        Code := m_Tab_PF.FieldByName (sFieldOneName).AsString;

        Description := m_Tab_PF.FieldByName (sFieldTwoName).AsString;

	m_bIsOnBegin:=FALSE;
	m_bIsOnEnd:=TRUE;


	Result:= TRUE;

end;

function TComponentNode.GetPreviousBrother(var Code: string; var Description: string): boolean;
begin
    if( m_bIsEmpty or m_bIsOnBegin or (m_RecordCount=1)) then		// The recordset is empty?
        begin
        Code:='';
        Description:='';
        Result:= FALSE;		// Yes
        exit;
        end;


    m_Tab_PF.Prior;

    Code := m_Tab_PF.FieldByName (sFieldOneName).AsString;

    Description := m_Tab_PF.FieldByName (sFieldTwoName).AsString;

    m_CurrentRecord:=m_CurrentRecord-1;

    m_bIsOnEnd:=FALSE;

    if (m_CurrentRecord <> 0) then	// The recordset is finished?
            m_bIsOnBegin:=TRUE
    else
            m_bIsOnBegin:=FALSE;

    Result:= TRUE;

end;

function TComponentNode.PreviousBrotherIsDone: Boolean;
begin
  if( m_bIsEmpty or (m_RecordCount=1)) then		// The recordset is empty?
      begin
      Result:= TRUE;				// Yes
      exit;
      end;

  if (m_bIsOnBegin=TRUE and m_bIsOnEnd=FALSE) then		// The recordset is on the begin?
      begin
      Result:=TRUE;		// Yes
      exit;
      end;

  Result:= FALSE;

end;

function TComponentNode.GetCurrentParent(var Code:string; var Description:string) : Boolean;
begin

  Code := m_szCurrentCodeNode;

  //Se o pai corrente é inválido (por falha no ExpandCode colapsando)
  //retorna FALSE
  if ((Code='') or (Code = ' ')) then
     begin
     Result:= FALSE;
     exit;
     end;

  Result:= FindDescriptionByCode (Code, Description);

end;

function TComponentNode.GetCurrentSon(var Code:string; var Description: string) : SmallInt;
begin
  if( m_bIsEmpty) then		// The recordset is empty?
      begin
      Code:='';
      Description:='';
      Result:= 0;	// Yes
      exit;
      end;

  Code := m_Tab_PF.FieldByName (sFieldOneName).AsString;

  Description := m_Tab_PF.FieldByName (sFieldTwoName).AsString;

  Result:= m_CurrentRecord;
end;


function TComponentNode.FindParents( SonCode: string; var  FirstFather:string):SmallInt;
var
SAux : string;
begin

     //VERIFY (m_pDatabase);
     //Verifica o Banco de dados
     if not Assigned (m_Database) or not (m_Database.Connected = True) then
        begin
        FirstFather:='';			//-1 indica erro
        Result:= -1;
        exit;
        end;

     //Default = Nao temos lista de pais
     m_bParentIsEmpty:=TRUE;

     //Se pasei o ROOT, retorna FALSE pois ele nao tem pai.
     sAux:=Trim(SonCode);
     if (CompareText(sAux,'ROOT')=0) then
        begin
        //m_bParentIsEmpty==TRUE pois nao temos registros para o ROOT
        FirstFather:=SonCode;
        Result:= 0;
        exit;
        end;



      if (m_FindParentRec.Active) then
              m_FindParentRec.Close;

      m_FindParentRec.Filter:=m_FilterPais + '''' + SonCode + '''';
      m_FindParentRec.Filtered:=True;

      try
         //Teste bbd aberto, open==ok, no data found, e se
         //da algum problema retorna -1 com CodePai vazio
         m_FindParentRec.Open;
      except
      On E : EDataBaseError do
         begin
         ShowMessage('Dicionario - Erro na tabela de pesquisa de pais (FindParents): ' + #13+#10+ E.Message + #13+#10+ 'Filtro: ' + m_FindParentRec.Filter);
         FirstFather:='';
         Result:= -1;
         exit;
         end;
      end;

       if( m_FindParentRec.IsEmpty ) then
           begin
           //O código é invalido ou
           //o código está na tabela Flat mais não foi incluso na
           //tabela Pais-Filhos (a tabela foi mal preenchida?).
           //De qualquer jeito : Não tem Pai. ERRO!
           m_FindParentRec.Close;

           FirstFather:='';
           Result:= -1;
           exit;
           end;

       m_FindParentRec.FetchAll;
       m_ParentCount:=m_FindParentRec.RecordCount;


       //Conta a quantidade de registros
       m_ParentCount:=m_FindParentRec.RecordCount;


       m_FindParentRec.First;			// First record is current again

       m_nCurrentParentRecord:=1;

       FirstFather := m_FindParentRec.FieldByName(m_FieldPai).AsString;

       m_bParentIsEmpty:=FALSE;

       Result:= m_ParentCount;
end;

function TComponentNode.GetFirstParent(var Code: string; var Description: string): Boolean;
begin
   if( m_bParentIsEmpty) then		// The recordset is empty?
       begin
       Code:='';
       Description:='';
       Result:= FALSE;				// Yes
       exit;
       end;

   m_FindParentRec.First;			// First record is current again

   m_nCurrentParentRecord:=1;

   Code := m_FindParentRec.FieldByName(m_FieldPai).AsString;

   Result:= FindDescriptionByCode (Code, Description);

end;

function TComponentNode.GetNextParent(var Code: string; var Description: string) : Boolean;
begin
  if( m_bParentIsEmpty or (m_ParentCount=1)) then		// The recordset is empty?
      begin
      Code:='';
      Description:='';
      Result:= FALSE;
      exit;
      end;

  if (m_nCurrentParentRecord >= m_ParentCount) then
     begin
     Code:='';
     Description:='';
     Result:= FALSE;
     exit;
     end;

  m_nCurrentParentRecord := m_nCurrentParentRecord + 1;

  m_FindParentRec.Next;

  Code := m_FindParentRec.FieldByName(m_FieldPai).AsString;

  Result:= FindDescriptionByCode (Code, Description);

end;


function TComponentNode.FindDescriptionByCode(Code: string; var Description: string): Boolean;
var
SAux : string;
begin
     //VERIFY (m_pDatabase);
     //Verifica o Banco de dados
     if not Assigned (m_Database) or not (m_Database.Connected = True) then
        begin
        Description:='';			// indica erro
        Result:= False;
        exit;
        end;

    //Se o codigo e ROOT, entao retorna ROOT como descricao
    sAux:=Trim(Code);
    if (CompareText(sAux,'ROOT')=0) then
       begin
       Description:=Code;
       Result:=True;
       exit;
       end;


    //Se o recordset esta aberto, fecha ele
    if (m_Flat_Table.Active) then
        m_Flat_Table.Close;

    //Atualiza o parametro
    m_Flat_Table.Filter:=m_FilterFlat + '''' + Code + '''';
    m_Flat_Table.Filtered:=True;

    try
    m_Flat_Table.Open;
    except
    On E : EDataBaseError do
       begin
       ShowMessage('Dicionario - Erro na tabela Flat (FindDescByCode): '+ #13+#10 + E.Message + #13+#10+ 'Filtro : ' + m_Flat_Table.Filter);
       Description:='';			//-1 indica erro
       Result:= False;
       exit;
       end;
    end;

    if( m_Flat_Table.IsEmpty ) then
        begin
        // O codigo nao e valido pois nao existe na tabela Flat
        Description:='';
        Result:= False;
        exit;
        end;

    //O codigo e chave primaria da tabela por isso
    //assumo que nao vai ter registros repetidos

    Description := m_Flat_Table.FieldByName(m_FieldDescricao).AsString;
    Result:= TRUE;
end;

function TComponentNode.FindCodeByDescription(var Code: string; Description:string): SmallInt;
var
SAux : string;
begin
//Teste bbd aberto, open==ok, no data found, e se
//da algum problema retorna FALSE com CodePai vazio
//VERIFY (m_pDatabase);
//Verifica o Banco de dados
if not Assigned (m_Database) or not (m_Database.Connected = True) then
   begin
   Description:='';			// indica erro
   Result:= -1;
   exit;
   end;

m_bCodeIsEmpty:=TRUE;

//Se algo da errado, codigo invalido
Code := '';

//Se pasei o ROOT como descrição, retorna ROOT como código.
sAux:=Trim(Description);
if (CompareText(sAux,'ROOT')=0) then
   begin
   Code:=Description;
   Result:=1;
   exit;
   end;


if (m_Flat_Like.Active) then
        m_Flat_Like.Close;

m_Flat_Like.SQL.Clear;
m_Flat_Like.SQL.Add(m_SQLLike + ''''+ Description +'''');

try
m_Flat_Like.Open;
except
On E : EDataBaseError do
   begin
   ShowMessage('Dicionario - Erro na Query Like (FindCodeByDesc): '+ #13+#10 + E.Message + #13+#10+ 'Query: ' + m_SQLLike + ''''+ Description +'''');
   Code:='';			//-1 indica erro
   Result:= -1;
   exit;
   end;
end;



//Não ha nenhum código com esta descrição
if ( m_Flat_Like.IsEmpty ) then
   begin
   m_Flat_Like.Close;

   Code:='';
   Result:= 0;
   exit;
   end;


//Conta a quantidade de registros
m_nFoundCount:=0;

m_Flat_Like.FetchAll;

m_nFoundCount:=m_Flat_Like.RecordCount;

m_Flat_Like.First;			// First record is current again

m_CurrentFoundCode:=1;

Code := m_Flat_Like.FieldByName(m_FieldCodigo).AsString;

m_bCodeIsEmpty:=FALSE;


Result:= m_nFoundCount;

end;

function TComponentNode.GetFirstCodeByDesc(var Code: string; var Description: string): Boolean;
begin
if( m_bCodeIsEmpty) then		// The recordset is empty?
    begin
    Code:='';
    Description:='';
    Result:= FALSE;				// Yes
    exit;
    end;

m_Flat_Like.First;			// First record is current again

m_CurrentFoundCode:=1;

Code := m_Flat_Like.FieldByName(m_FieldCodigo).AsString;

Description := m_Flat_Like.FieldByName(m_FieldDescricao).AsString;

Result:= TRUE;

end;

function TComponentNode.GetNextCodeByDesc(var Code: string; var Description: string): Boolean;
begin
if( m_bCodeIsEmpty or (m_nFoundCount=1)) then		// The recordset is empty?
    begin
    Code:='';
    Description:='';
    Result:= FALSE;				// Yes
    exit;
    end;

if (m_CurrentFoundCode >= m_nFoundCount) then
   begin
    Code:='';
    Description:='';
    Result:= FALSE;				// Yes
    exit;
    end;

m_CurrentFoundCode := m_CurrentFoundCode + 1;

m_Flat_Like.Next;

Code := m_Flat_Like.FieldByName(m_FieldCodigo).AsString;

Description := m_Flat_Like.FieldByName(m_FieldDescricao).AsString;

Result:= TRUE;


end;

function TComponentNode.HasChilds(Code: string): Boolean;
begin
    if not Assigned (m_Database) or not (m_Database.Connected = True) then
      begin
      Result:= False;
      exit;
      end;



    if (m_PFHasCh.Active) then
       m_PFHasCh.Close;

    //Atualiza o parametro
    m_PFHasCh.Filter:=m_FilterFilhos + '''' + Code + '''';
    m_PFHasCh.Filtered:=True;

    try
    m_PFHasCh.Open;
    except
    On E : EDataBaseError do
       begin
       ShowMessage('Dicionario - Erro na tabela de pesquisa de filhos (HasChilds): '+ #13+#10 + E.Message + #13+#10+ 'Filtro: ' + m_PFHasCh.Filter);
       Result:= False;
       exit;
       end;
    end;

    if( m_PFHasCh.IsEmpty ) then
        begin
        //Se o codigo e uma folha, ele nao esta como chave da tabela
        //pais e filhos. Ele nao tem Filhos.
        //Retorna FALSE
        Result:= False;
        exit;
        end;


    //Tem Filhos
    Result:= TRUE;
end;

function TComponentNode.CollapseCode( Code: string; var ChildrenNumber: SmallInt): Boolean;
var
sAux: string;
ParentCode: string;
begin

//Verifica o Banco de dados
//Se o banco esta fechado, retorna erro
if not Assigned (m_Database) or not (m_Database.Connected = True) then
   begin
   ChildrenNumber:=-1;			// indica erro
   Result:= FALSE;
   exit;
   end;



//Se pasei o ROOT, expande o ROOT
sAux:=Trim(Code);
if (CompareText(sAux,'ROOT')=0) then
   begin
   if (ExpandCode (Code,ChildrenNumber)) then
       begin
       Result:= FALSE; //o ROOT nao pode ser colapsado
       exit;
       end
   else
       begin
       m_szCurrentCodeNode:='';
       m_bIsEmpty:=TRUE;			// The recordset is empty
       m_RecordCount:=0;
       m_CurrentRecord:=0;
       m_bIsOnBegin:=False;
       m_bIsOnEnd:=FALSE;
       ChildrenNumber:=-1;			//-1 indica erro
       Result:= FALSE;
       exit;
       end;
   end;


//CollapseCode
if (FindParents(Code,ParentCode)<>0) then
   begin
   if (ExpandCode (ParentCode,ChildrenNumber)) then
      begin
      m_szCurrentCodeNode:=ParentCode;
      Result:= TRUE;
      exit;
      end;
   end;

//Deu algum problema
m_szCurrentCodeNode:='';

m_bIsEmpty:=TRUE;			// The recordset is empty
m_RecordCount:=0;
m_CurrentRecord:=0;
m_bIsOnBegin:= False;
m_bIsOnEnd:=FALSE;
ChildrenNumber:=-1;			//-1 indica erro

Result:= FALSE;

end;

procedure TComponentNode.PreparaTabelas (DBAlias: string);
begin
if Assigned (m_Database) and (m_Database.Connected) then
   m_Database.Connected:=False;

  m_NomeBanco := DBAlias;
  m_Database := Session.FindDatabase(m_NomeBanco);

  if (m_Database = nil) then                              { database doesn't exist for session so,}
    begin
        try
    //    m_Database := Session.OpenDatabase(m_NomeBanco);                            { create and open it}
        m_Database:= TDatabase.Create(Owner);
        m_Database.AliasName := m_NomeBanco;
        m_Database.OnLogin := m_DatabaseLogin;
        m_Database.DatabaseName := m_NomeBanco;
        m_Database.Open;
        except
        On E : EDataBaseError do
           begin
           ShowMessage('Dicionario - Erro na abertura do Banco '+ #13+#10 + E.Message + #13+#10);
           exit;
           end;
        end;
    end;

  if not Assigned (m_Database) then
     exit;

    m_Tab_PF.DatabaseName:= m_NomeBanco;

    m_PFHasCh.DatabaseName:= m_NomeBanco;
    m_PFHasCh.TableName :=m_sTableNamePF;

    m_Flat_Table.DatabaseName:= m_NomeBanco;
    m_Flat_Table.TableName:=m_sTableNameFlat;

    m_FindParentRec.DatabaseName:= m_NomeBanco;
    m_FindParentRec.TableName:=m_sTableNamePF;

    m_CCSISDIC.DatabaseName:=m_NomeBanco;
    m_CCSISDIC.TableName:='CCSISDIC';

    m_Flat_Like.DatabaseName:= m_NomeBanco;
    m_Flat_Like.SQL.Clear;

end;


procedure TComponentNode.MontaQuerys (Sigla: String);
var
 sTableName : String;
begin
////////////////////////////////////////////////////
//          Prepara nome de tabelas
////////////////////////////////////////////////////
m_sTableNamePF:= Sigla+'_PF';
m_sTableNameFlat:=Sigla;

////////////////////////////////////////////////////
//          Prepara nome de campos
////////////////////////////////////////////////////
m_FieldCodigo :=  'cod_' + Sigla;
m_FieldDescricao := 'descr_' + Sigla;
m_FieldPai := 'codpai_' + Sigla;
m_FieldFilho := 'codfilho_' + Sigla;


////////////////////////////////////////////////////
//Prepara parametros da Query Join Pais-Filhos, Flat
////////////////////////////////////////////////////

{ Query que esta classe monta para pais e filhos
PARAMETERS [?] Text;
SELECT ATC_PF.codfilho_ATC AS FIELDONE, ATC.descr_ATC AS FIELDTWO
FROM ATC, ATC_PF
WHERE ATC.cod_ATC = ATC_PF.codfilho_ATC
AND ATC_PF.codpai_ATC=?
ORDER BY ATC_PF.codfilho_ATC;
}

     //Inicializo os nomes dos campos desta tabela para a clausula SELECT
     //Fica assim : ATC_PF.codfilho_ATC, ATC.descr_ATC
     sFieldOneName := m_FieldFilho;//Sigla + '_PF.codfilho_' + Sigla;
     sFieldTwoName := m_FieldDescricao;//Sigla + '.descr_' + Sigla;

     //Inicializo o nome da tabela de trabalho para a montagem da clausula FROM
     // Fica assim : "ATC"+ "," + "ATC"+ "_PF" = ATC,ATC_PF
     // o FROM e acrescentado automaticamente pela classe CRecordset
     sTableName := Sigla +', ' + Sigla + '_PF';

     //SQL:= 'SELECT ' +  sFieldOneName + ' AS FIELDONE, ' +  sFieldTwoName + ' AS FIELDTWO FROM ' + sTableName + ' WHERE ' +  sFilter;
     sSelect := 'SELECT ' +  sFieldOneName + ', ' +  sFieldTwoName ;

     sFrom :=  ' FROM ' + sTableName;

     //Inicializo a clausula WHERE da consulta para o Join
     //Fica assim : ATC.cod_ATC = ATC_PF.codfilho_ATC AND ATC_PF.codpai_ATC=?
     sFilter := ' WHERE (' + Sigla + '.cod_' + Sigla + ' = ' + Sigla + '_PF.codfilho_' + Sigla + ') AND ((' + Sigla + '_PF.codpai_' + Sigla + '= ';



////////////////////////////////////////////////////
//Prepara parametros da Tabela Flat (codigo,descricao)
//Foi montada direto como tabela m_Flat_Table
//Prepara so o Filtro
////////////////////////////////////////////////////

{Query que esta classe monta para codigo e descricao
PARAMETERS [?] Text;
SELECT ATC.descr_ATC
FROM ATC
WHERE ATC.cod_ATC=?
SQL :=  'SELECT ' +  m_FieldCodigo + ', ' +  m_FieldDescricao + ' FROM ' + sTableName + 'WHERE ' +  sFilter;
}


m_FilterFlat:= m_FieldCodigo + '= ';



////////////////////////////////////////////////////
//Prepara parametros da Query Like
////////////////////////////////////////////////////

{ Query que esta classe monta para codigo e descricao
PARAMETERS [?] Text;
SELECT cod_ATC AS FIELDONE,descr_ATC AS FIELDTWO
FROM ATC
WHERE descr_ATC LIKE 'Description'
}


m_SQLLike :=  'SELECT ' +  m_FieldCodigo + ', ' +  m_FieldDescricao + ' FROM ' + Sigla + ' WHERE ' +  m_FieldDescricao + ' LIKE ';

////////////////////////////////////////////////////
//Prepara parametros da Tabela dos Filhos e dos Pais
//Foi montado direto como filter na m_PFHasCh e
//m_FindParentRec
//Prepara so o Filtro
////////////////////////////////////////////////////

{ Query que esta classe monta para codigo_pai e codigo_filho
PARAMETERS [?] Text;
SELECT ATC_PF.codpai_ATC,ATC_PF.codfilho_ATC
FROM ATC_PF
WHERE ATC_PF.codfilho_ATC=?

//Inicializo o nome da tabela de trabalho
// Fica assim : "ATC"+ "_PF" = ATC_PF
sTableName := Sigla + '_PF';
//Inicializo os nomes dos campos desta tabela
//Fica assim : codpai_ATC, codfilho_ATC
m_FieldCodigo := 'codpai_' + Sigla;
m_FieldDescricao := 'codfilho_' + Sigla;
//Inicializo a clausula WHERE da consulta
sFilter := m_FieldTwoName + '=:Filho';

SQL :=  'SELECT ' +  m_FieldCodigo + ', ' +  m_FieldDescricao + ' FROM ' + sTableName + 'WHERE ' +  sFilter;
}

m_FilterPais:='codfilho_' + Sigla + '= ';


{ Query que esta classe monta para codigo_pai e codigo_filho
PARAMETERS [?] Text;
SELECT ATC_PF.codpai_ATC,ATC_PF.codfilho_ATC
FROM ATC_PF
WHERE ATC_PF.codpai_ATC=?

//Inicializo o nome da tabela de trabalho
// Fica assim : "ATC"+ "_PF" = ATC_PF
sTableName := Sigla + '_PF';
//Inicializo os nomes dos campos desta tabela
//Fica assim : codpai_ATC, codfilho_ATC
m_FieldCodigo := 'codpai_' + Sigla;
m_FieldDescricao := 'codfilho_' + Sigla;
//Inicializo a clausula WHERE da consulta
sFilter := m_FieldCodigo + '=:Codigo';

SQL :=  'SELECT ' +  m_FieldCodigo + ', ' +  m_FieldDescricao + ' FROM ' + sTableName + 'WHERE ' +  sFilter;
}

m_FilterFilhos:= m_FieldPai +' = ';
end;

procedure TComponentNode.MontaJoin (Join:TQuery;Codigo: string);
begin
Join.SQL.Clear;
Join.SQL.Add (sSelect);
Join.SQL.Add (sFrom);
Join.SQL.Add (sFilter + '''' + Codigo + '''))');

m_SQLJoinPF_Flat := sSelect + sFrom + sFilter + '''' + Codigo + '''))';

end;

procedure TComponentNode.m_DatabaseLogin(Database: TDatabase;
  LoginParams: TStrings);
begin

LoginParams.Values['USERNAME'] := m_UserId;

LoginParams.Values['PASSWORD'] := m_UserPw;

end;

end.

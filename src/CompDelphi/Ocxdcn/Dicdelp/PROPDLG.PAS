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




unit PropDlg;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,Dialogs,
  StdCtrls, ExtCtrls, Forms, ComCtrls, Mask, DBCtrls, DBTables, DB;

type
  TPropPageDlg = class(TForm)
    BtnOK: TButton;
    BtnCncel: TButton;
    BtnHlp: TButton;
    PgCntrlPropriedadesDic: TPageControl;
    TbShtDicionario: TTabSheet;
    GBoxFonteDados: TGroupBox;
    LblDSName: TLabel;
    LblTipoDic: TLabel;
    LblSiglaDic: TLabel;
    CBoxTipo: TComboBox;
    CBoxDSN: TComboBox;
    ChBoxAtiva: TCheckBox;
    BtnAjuda: TButton;
    BtnAbout: TButton;
    LblNome: TLabel;
    LblFonte: TLabel;
    LblCriado: TLabel;
    LblAlterado: TLabel;
    DBEdNome: TDBEdit;
    DBEdFonte: TDBEdit;
    DBEdCriacao: TDBEdit;
    DBEdAlteracao: TDBEdit;
    DBEdVersao: TDBEdit;
    DBEdNiveis: TDBEdit;
    DBEdFilhos: TDBEdit;
    LblVersao: TLabel;
    LblNiveis: TLabel;
    LblFilhos: TLabel;
    QrySigla: TQuery;
    QryTipo: TQuery;
    DSTipo: TDataSource;
    DSSigla: TDataSource;
    TabDicCorp: TTable;
    DSDicCorp: TDataSource;
    CBoxSigla: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure CBoxDSNChange(Sender: TObject);
    procedure CBoxTipoChange(Sender: TObject);
    procedure CBoxSiglaChange(Sender: TObject);
    procedure BtnAboutClick(Sender: TObject);
    procedure BtnAjudaClick(Sender: TObject);
    procedure ChBoxAtivaClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    DBDic : TDatabase;
    { Private declarations }
    procedure NewDSName;
    procedure LimpaCombos;
  public
    { Public declarations }
    DSName: string;
    Tipo: string;
    Sigla: string;
    constructor CreatePP(Sender: TObject;NovoDSN,NovoTipo,NovaSigla:string;BoxAtiva:Boolean);
  end;

var
  PropPageDlg: TPropPageDlg;

implementation

uses AboutDlg,OCXRes;

{$R *.DFM}


constructor TPropPageDlg.CreatePP(Sender: TObject;NovoDSN,NovoTipo,NovaSigla:string;BoxAtiva:Boolean);
begin


  Create (Sender as TComponent);

  DSName:=NovoDSN;
  Tipo:=NovoTipo;
  Sigla:=NovaSigla;
  ChBoxAtiva.Checked:=BoxAtiva;
  ChBoxAtivaClick(Self);

end;

procedure TPropPageDlg.FormCreate(Sender: TObject);
begin
{ First, disable the TTable & TQuery objects. }
if QrySigla.Active then
      QrySigla.Close;
if QryTipo.Active then
      QryTipo.Close;
if TabDicCorp.Active then
      TabDicCorp.Close;

if Assigned (DBDic) and (DBDic.Connected = True) Then
    DBDic.Connected := False;

end;

procedure TPropPageDlg.NewDSName ;
begin

  {Operação demorada}
  Screen.Cursor := crHourglass;

  { Preencha a lista de Alias}
  with CBoxDSN do
  begin
    Items.Clear;
    Style:=csDropDownList;
    Session.GetAliasNames(Items);
    if (DSName='') then
       ItemIndex:=-1
    else
        ItemIndex:=Items.IndexOf(DSName);
        if ((CBoxDSN.ItemIndex = -1) and (DSName <> '')) then
           begin

               MessageDlg( 'Não existem database alias definidos com o nome: ' + DSName + #13#10 +
                      'Utilize o aplicativo BDE Configuration.',
                       mtError, [mbOK], 0 );
               DSName:='';
           end;
  end;




  {Fim da operação}
  Screen.Cursor := crDefault;

  { Verifque que existem alias definidos }
  if CBoxDSN.Items.Count < 1 then
    MessageDlg( 'Não existem database alias definidos. ' + #13#10 +
                'Você precisa definir pelo menos um. ' + #13#10 +
                'Utilize o aplicativo BDE Configuration.',
                 mtError, [mbOK], 0 );

  { Default the drop-down list to the first value in the list }
  CBoxTipo.Style:=csDropDownList;
  CBoxTipo.Enabled :=False;
  CBoxSigla.Enabled :=False;
  CBoxSigla.Style:=csDropDownList;

  CBoxDSNChange(self);

end;

procedure TPropPageDlg.CBoxDSNChange(Sender: TObject);
var
Tabelas: TStringList;
begin

if (ChBoxAtiva.Checked = False) then
   begin
   DSName:=CBoxDSN.Text;
   exit;
   end;

if ((DSName='') and (CBoxDSN.ItemIndex=-1)) then exit;

Tabelas := TStringList.Create;
Screen.Cursor := crHourglass;
try
   if Assigned (DBDic) and (DBDic.Connected = True) Then
       Begin
       { First, disable the TTable & TQuery objects. }
       if QrySigla.Active then
          QrySigla.Close;
       if QryTipo.Active then
          QryTipo.Close;
       if TabDicCorp.Active then
          TabDicCorp.Close;
       DBDic.Connected := False;
       CBoxTipo.Items.Clear;
       CBoxTipo.Enabled :=False;
       CBoxSigla.Items.Clear;
       CBoxSigla.Enabled :=False;
       end;

//   DBDic.AliasName := CBoxDSN.Items[CBoxDSN.ItemIndex]; //Era DatabaseName

  DBDic := Session.FindDatabase(CBoxDSN.Items[CBoxDSN.ItemIndex]);

  if (DBDic = nil) then                              { database doesn't exist for session so,}
    DBDic := Session.OpenDatabase(CBoxDSN.Items[CBoxDSN.ItemIndex]);                            { create and open it}

  if not Assigned (DBDic) then
     exit;

   DBDic.LoginPrompt:=True;
   DBDic.Connected := True;
   QrySigla.DatabaseName := CBoxDSN.Items[CBoxDSN.ItemIndex];
   QryTipo.DatabaseName := CBoxDSN.Items[CBoxDSN.ItemIndex];
   TabDicCorp.DatabaseName := CBoxDSN.Items[CBoxDSN.ItemIndex];
//    IDS_TABCORP
   Session.GetTableNames(CBoxDSN.Items[CBoxDSN.ItemIndex],    { alias pra investigar }
                        '',                                   { Tabela dos dicionários }
                        False,                                { sem extensào do arquivo }
                        False,                                { nào procura tabelas de systema }
                        Tabelas);                             { lista dos resultados }

   if Pos (IDS_TABCORP,Tabelas.Text) < 1 then
      begin
      MessageDlg( IDS_DSN_SEM_DCNRIO,mtError, [mbOK], 0 );
      Screen.Cursor := crDefault;
      Exit;
      end;

finally
   Screen.Cursor := crDefault;
end;

{Open tables}
with QryTipo do
     begin
     if Active then
        Close;
     SQL.Text:='SELECT DISTINCT tipo FROM '+ IDS_TABCORP;
     Open;
     First;
     CBoxTipo.Clear;
     while not EOF do
           begin
                CBoxTipo.Items.Add (FieldByName ('tipo').AsString);
                Next;
           end;
     if (Tipo <> '') then
        begin
        if (CBoxTipo.Items.IndexOf(Tipo) = -1) then
           CBoxTipo.Items.Add (Tipo);

        CBoxTipo.ItemIndex :=CBoxTipo.Items.IndexOf(Tipo);
        end
     else
        CBoxTipo.ItemIndex :=0;

     CBoxTipo.Enabled:=True;
     end;

CBoxTipoChange(self);

end;

procedure TPropPageDlg.CBoxTipoChange(Sender: TObject);
begin
if TabDicCorp.Active then
   TabDicCorp.Close;

if (self.ChBoxAtiva.Checked = False) then
   begin
   Tipo:=CBoxTipo.Text;
   exit;
   end;

with QrySigla do
     begin
     if Active then
        Close;
     SQL.Clear;
     SQL.Text:='SELECT sigla FROM '+ IDS_TABCORP + ' WHERE tipo =:Tipo';
     ParamByName('Tipo').AsString:= CBoxTipo.Items[CBoxTipo.ItemIndex];
     Open;
     First;
     CBoxSigla.Clear;
     while not EOF  do
           begin
                CBoxSigla.Items.Add (FieldByName ('sigla').AsString);
                Next;
           end;
     if (Sigla <> '') then
        begin
        if (CBoxSigla.Items.IndexOf(Sigla) = -1) then
           CBoxSigla.Items.Add (Sigla);

        CBoxSigla.ItemIndex :=CBoxSigla.Items.IndexOf(Sigla);
        end
     else
        CBoxSigla.ItemIndex :=0;
     CBoxSigla.Enabled:=True;
     end;
TabDicCorp.TableName:=IDS_TABCORP;
TabDicCorp.Open;

CBoxSiglaChange(self);
end;

procedure TPropPageDlg.CBoxSiglaChange(Sender: TObject);
begin

if (self.ChBoxAtiva.Checked = False) then
   begin
   Sigla:=CBoxSigla.Text;
   exit;
   end;

   TabDicCorp.Locate ('sigla',CBoxSigla.Items[CBoxSigla.ItemIndex],[]);
   
end;

procedure TPropPageDlg.BtnAboutClick(Sender: TObject);
var
DlgAbout : TDlgAbout;
begin
DlgAbout:=TDlgAbout.Create(Owner);
DlgAbout.ShowModal;
end;

procedure TPropPageDlg.BtnAjudaClick(Sender: TObject);
begin
  //Application.HelpContext(102);   {Alternativa}
  Application.HelpJump ('OperacaoPropriedades');
end;

procedure TPropPageDlg.ChBoxAtivaClick(Sender: TObject);
begin

   if ChBoxAtiva.Checked Then
     NewDSName
   else
     Begin
       if QrySigla.Active then
          QrySigla.Close;
       if QryTipo.Active then
          QryTipo.Close;
       if TabDicCorp.Active then
          TabDicCorp.Close;
       if Assigned (DBDic) and(DBDic.Connected = True) Then
          DBDic.Connected := False;
       if (CBoxDSN.ItemIndex <> -1) then DSName:=CBoxDSN.Items[CBoxDSN.ItemIndex];
       if (CBoxTipo.ItemIndex <> -1) then Tipo:=CBoxTipo.Items[CBoxTipo.ItemIndex];
       if (CBoxSigla.ItemIndex <> -1) then Sigla:=CBoxSigla.Items[CBoxSigla.ItemIndex];
       LimpaCombos;

     end;

end;

procedure TPropPageDlg.BtnOKClick(Sender: TObject);
begin
DSName:= CBoxDSN.Text;//Items[CBoxDSN.ItemIndex];
Tipo  := CBoxTipo.Text;//Items[CBoxTipo.ItemIndex];
Sigla := CBoxSigla.Text;//Items[CBoxSigla.ItemIndex];
end;

procedure TPropPageDlg.LimpaCombos;
begin
      //Preparacao do combo Data Source Name
       with CBoxDSN do
            begin
            Items.Clear;
            ItemIndex:=-1;
            if (DSName <> '') then
               begin
               Items.Add (DSName);
               ItemIndex:=0;
               end;
            Style:=csDropDown;
            Enabled :=True;
            end;


       //Preparacao do combo tipo, os quatro defaults ficam na lista.
       with CBoxTipo do
            begin
            Clear;
            ItemIndex:=-1;
            Style:=csDropDown;
            if (Tipo <> '') then
               begin
               Items.Add(Tipo);
               ItemIndex:=0;
               end
            else
                begin
                Items.Add(IDS_DEF_TIPOADM);
                Items.Add(IDS_DEF_TIPOPROC);
                Items.Add(IDS_DEF_TIPODROG);
                Items.Add(IDS_DEF_TIPODIAG);
                ItemIndex:=-1;
                end;
            Enabled :=True;
            end;


	//Preparacao do combo sigla
        with CBoxSigla do
            begin
            Items.Clear;
            ItemIndex:=-1;
            Style:=csDropDown;
            if (Sigla <> '') then
               begin
               Items.Add(Sigla);
               ItemIndex:=0;
               end;
            Enabled :=True;
            end;
end;

end.

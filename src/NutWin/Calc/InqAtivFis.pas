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




unit InqAtivFis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, DBCtrls, StdCtrls, Grids, DBGrids, Db, DBTables, Buttons,
  ActnList, DBMyNav, Mask, FnpNumericEdit, Wizard, NutCnst;

type
  TfmInqAtivFis = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    grAtivSelec: TDBGrid;
    Label3: TLabel;
    latotkcal: TLabel;
    edTotCal1: TEdit;
    Label5: TLabel;
    Label7: TLabel;
    tbT19bk: TTable;
    DST19bk: TDataSource;
    tbAtivFis: TTable;
    DSAtivFis: TDataSource;
    tbT19bkCOEFA: TFloatField;
    TbT19bkCOEFB: TFloatField;
    sbPassa: TSpeedButton;
    Label6: TLabel;
    edMedia: TEdit;
    qrCalcula: TQuery;
    TbT19: TTable;
    TbT19COEFA: TFloatField;
    TbT19COEFB: TFloatField;
    TbT19bkGUID: TStringField;
    TbT19bkDESCATIVFI: TStringField;
    TbT19GUID: TStringField;
    TbT19DESCATIVFI: TStringField;
    DST19: TDataSource;
    tbAtivFisGUID: TStringField;
    tbAtivFisTEMPO: TFloatField;
    tbAtivFisKcal: TStringField;
    tbAtivFisAtividade: TStringField;
    tbAtivFisAtiv: TStringField;
    dbAtivFis: TDatabase;
    dsCalcula: TDataSource;
    acAtivFis: TActionList;
    LocAtivFis: TAction;
    btLimpaTabelaAtFis: TButton;
    mnAtivFis: TDBMyNav;
    deTempo: TDBEdit;
    paAtiv: TPanel;
    grListaAtividades: TDBGrid;
    Label1: TLabel;
    edLocAtiv: TEdit;
    Label2: TLabel;
    laTempo: TLabel;
    Label8: TLabel;
    edPeso: TFnpNumericEdit;
    edDias: TFnpNumericEdit;
    LimparTabela: TAction;
    Label9: TLabel;
    edTotCal: TLabel;
    procedure tbAtivFisCalcFields(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure LocalizaAtivFis(Sender: TObject);
    procedure sbPassaClick(Sender: TObject);
    procedure grListaAtividadesDblClick(Sender: TObject);
    procedure edLocAtivChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tbAtivFisNewRecord(DataSet: TDataSet);
    procedure mnAtivFisClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure tbAtivFisAfterPost(DataSet: TDataSet);
    procedure LimparTabelaExecute(Sender: TObject);
    procedure grListaAtividadesCellClick(Column: TColumn);
    procedure edPesoInvalidEntry(Sender: TObject);
    procedure edDiasInvalidEntry(Sender: TObject);
    procedure edDiasExit(Sender: TObject);
    procedure edPesoExit(Sender: TObject);
    procedure tbAtivFisPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DSAtivFisDataChange(Sender: TObject; Field: TField);
    procedure grAtivSelecDblClick(Sender: TObject);
  private
    { Private declarations }
     procedure Calcular;
     procedure PedeTempo;
     procedure Limpar;
  public
    TotalKcal : double ;
    { Public declarations }
  end;

var
  fmInqAtivFis: TfmInqAtivFis;


implementation

uses fmTempoAtivF, uAliasName;

{$R *.DFM}

procedure TfmInqAtivFis.Calcular;
var
 sSql : string;

begin
   if not tbAtivFis.Active then
      exit;
   tbAtivFis.Refresh;
   qrCalcula.Close;
   qrCalcula.Sql.Clear ;
   sSql := 'Select Sum(( ' + FloattoStr(edPeso.value) + ' * T19.CoefA +T19.CoefB) * AtivFis.Tempo) as Somatoria ';
   sSql := sSql + ' From AtivFis,T19 Where AtivFis.Guid = T19.Guid ';
   qrCalcula.SQL.Add( sSQL );
   qrCalcula.Open;
   edTotCal.Caption := FormatFloat('######0.0',qrCalcula.Fieldbyname('Somatoria').asFloat);
   if edTotCal.Caption <> '' then
       edMedia.Text := FormatFloat('######0.0',qrCalcula.Fieldbyname('Somatoria').asFloat/strtofloat(edDias.text));
   qrCalcula.Close;
end;

procedure TfmInqAtivFis.tbAtivFisCalcFields(DataSet: TDataSet);
Var
Ativ : double;

begin
   if tbAtivFis.Fieldbyname('TEMPO').asFloat > 0 then
   begin
     if tbT19bk.Active = true then
     begin
       if tbT19bk.Locate('GUID',tbAtivFis.Fieldbyname('GUID').asString ,[]) then
       begin
          tbAtivFis.Fieldbyname('Ativ').asString := tbT19bk.Fieldbyname('DESCATIVFI').asString ;
          Ativ :=  (tbT19bk.Fieldbyname('COEFA').asFloat * edPeso.value + tbT19bk.Fieldbyname('COEFB').asFloat);
          tbAtivFis.Fieldbyname('KCal').asString := FormatFloat('#####0.0',( (Ativ * tbAtivFis.Fieldbyname('TEMPO').asFloat)));
       end;
     end;
   end;
end;

procedure TfmInqAtivFis.FormShow(Sender: TObject);
begin
      if tbAtivFis.IsEmpty then
         self.Tag := WZ_INVALIDNODE
      else
         //Nao existem mais forms
         //Pode terminar direto se houver um item
         self.Tag:=0;
      //Refresh do Wizard, que esta conectado no OnClick
      Click;

   // calcular;
   // tbAtivFis.Refresh;
end;

procedure TfmInqAtivFis.LocalizaAtivFis(Sender: TObject);
begin
// procuro a atividade fisica na tabela para ver se já tenho cadastrada

   if not(tbAtivFis.Locate('GUID',tbT19.Fieldbyname('GUID').asString,[])) then
   begin
      // se nao está já cadastrada, cadastro ...
         tbAtivFis.Insert;
         tbAtivFis.Fieldbyname('GUID').asString := tbT19.Fieldbyname('GUID').asString;
         PedeTempo;
         tbAtivFis.Post;
    end
  else
    // se já está cadastrada, dou um aviso
    ShowMessage('Esta Atividade Física já foi cadastrada.');

  edLocAtiv.Clear;
  grAtivSelec.Columns[1].Grid.Fields[1].FocusControl;
end;

procedure TfmInqAtivFis.sbPassaClick(Sender: TObject);
begin
if (StrtoFloat(edPeso.Text) < 1) or (StrtoFloat(edPeso.Text) > 450) then
   begin
     ShowMessage('O valor do Peso Corporal deve estar entre 1 a 450 kg');
     try
      edPeso.SetFocus
     except
      // caso dê erro para setar o foco, ele sai sem mensagem.
      // Isto pode acontecer quando é clicado o botao cancelar do Wizard. Como nao tenho acesso a ele,
      // utilizo este método.
     end;
   end
else
   begin
     LocalizaAtivFis(sender);
     Calcular;
   end;  
end;

procedure TfmInqAtivFis.grListaAtividadesDblClick(Sender: TObject);
begin
   LocalizaAtivFis(sender);
end;

procedure TfmInqAtivFis.edLocAtivChange(Sender: TObject);
begin

  tbT19.Locate('DescAtivFi',edLocAtiv.Text,[loCaseInsensitive,lopartialkey]);
end;

procedure TfmInqAtivFis.FormCreate(Sender: TObject);
begin
dbAtivFis.AliasName := BDE_ALIAS_NAME;
      dbAtivFis.Connected := True;
      tbT19bk.Open;
      tbT19.Open;
      tbAtivFis.Open;

      TotalKCal := 0;
      Limpar;
end;

procedure TfmInqAtivFis.tbAtivFisNewRecord(DataSet: TDataSet);
begin
//   tbAtivFis.Fieldbyname('TEMPO').asFloat := 0;
end;

procedure TfmInqAtivFis.mnAtivFisClick(Sender: TObject; Button: TMyNavigateBtn);
begin
   if button = nbPost then
        Calcular
   else if button = nbEdit then
   begin
      tbAtivFis.Edit;
      PedeTempo;
      tbAtivFis.Post;
      Calcular;
      grAtivSelec.Columns[1].Grid.Fields[1].FocusControl;
   end
   else if button = nbDelete then
      Calcular;
end;

procedure TfmInqAtivFis.tbAtivFisAfterPost(DataSet: TDataSet);
begin
    Calcular;
end;

procedure TfmInqAtivFis.LimparTabelaExecute(Sender: TObject);
begin
  if MessageDlg('Confirma a limpeza de todos os itens acima?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
     Limpar;
  end;
end;

procedure TfmInqAtivFis.grListaAtividadesCellClick(Column: TColumn);
begin
   edLocAtiv.Text := ''; 
end;

procedure TfmInqAtivFis.edPesoInvalidEntry(Sender: TObject);
begin
 //  if TForm( self ).Visible then
 //  begin
 //    ShowMessage('O valor deve estar entre 1 a 450 kg');
 //    try
 //     edPeso.SetFocus
 //    except
      // caso dê erro para setar o foco, ele sai sem mensagem.
      // Isto pode acontecer quando é clicado o botao cancelar do Wizard. Como nao tenho acesso a ele,
      // utilizo este método.
 //    end;
 //  end;
end;

procedure TfmInqAtivFis.edDiasInvalidEntry(Sender: TObject);
begin
   if TForm( self ).Visible then
   begin
      ShowMessage('O valor deve estar entre 1 e 30 dias.');
      edDias.SetFocus;
   end;
end;

procedure TfmInqAtivFis.edDiasExit(Sender: TObject);
begin
    Calcular;
end;

procedure TfmInqAtivFis.edPesoExit(Sender: TObject);
begin
if (StrtoFloat(edPeso.Text) < 1) or (StrtoFloat(edPeso.Text) > 450) then
   begin
     ShowMessage('O valor do Peso Corporal deve estar entre 1 a 450 kg');
     try
      edPeso.SetFocus
     except
      // caso dê erro para setar o foco, ele sai sem mensagem.
      // Isto pode acontecer quando é clicado o botao cancelar do Wizard. Como nao tenho acesso a ele,
      // utilizo este método.
     end;
   end
else
    Calcular;
end;

procedure TfmInqAtivFis.tbAtivFisPostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
    ControlaKeyViolation( Dataset, E, Action, '' );
end;

procedure TfmInqAtivFis.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
      dbAtivFis.Connected := False;
end;

procedure TfmInqAtivFis.DSAtivFisDataChange(Sender: TObject;
  Field: TField);
begin
      if tbAtivFis.IsEmpty then
         self.Tag := WZ_INVALIDNODE
      else
         //Nao existem mais forms
         //Pode terminar direto se houver um item
         self.Tag:=0;
      //Refresh do Wizard, que esta conectado no OnClick
      Click;
end;

procedure TfmInqAtivFis.PedeTempo;
var
   F : TfmTempoAtivFis;
begin
   try
      F := TfmTempoAtivFis.Create(self);
      F.deAtividades.DataSource := DSAtivFis;
      F.deAtividades.DataField := 'ATIVIDADE';
      F.deTempo.DataSource := DSAtivFis;
      F.deTempo.DataField := 'TEMPO';
      F.ShowModal;
   finally
      F.Free;
   end;
end;

procedure TfmInqAtivFis.Limpar;
  begin
    // limpa a tabela de atividades fisicas
    tbAtivFis.Active := False;
    try
      tbAtivFis.EmptyTable ;
    except
      ShowMessage('Não consegui limpar a tabela.');
    end;
    tbAtivFis.Active := True;
    Calcular;
  end;

procedure TfmInqAtivFis.grAtivSelecDblClick(Sender: TObject);
begin
   if not tbAtivFis.IsEmpty then
   begin
      tbAtivFis.Edit;
      PedeTempo;
      tbAtivFis.Post;
      Calcular;
      grAtivSelec.Columns[1].Grid.Fields[1].FocusControl;
   end;
end;

end.
   
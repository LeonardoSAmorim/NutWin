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




unit dmHelp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  hhcomponent, DBTables, Db, axctrls, RegEdit, RegConst2, extctrls, comctrls;

type
  TdmHlp = class(TDataModule)
    HtmlHelp: THtmlHelp;
    taHlp: TTable;
    dsHlp: TDataSource;
    dbHlp: TDatabase;
    taHlpFiles: TTable;
    dsHlpFiles: TDataSource;
    taHlpTOPICID: TStringField;
    taHlpMAP: TIntegerField;
    taHlpFILEID: TIntegerField;
    taHlpFilesFILEID: TIntegerField;
    taHlpFilesFILENAME: TStringField;
    taHlpHLPFILE: TStringField;
    taHlpTOPICNAME: TStringField;
    procedure HtmlHelpHtmlHelpContext(Sender: TObject; var Data: Integer);
    procedure dmHlpCreate(Sender: TObject);
    procedure dmHlpDestroy(Sender: TObject);
  private
    { Private declarations }
     FormsBuildedList : TStringList;
  public
    { Public declarations }
  end;

var
  dmHlp: TdmHlp;

implementation

uses fmCadHelp, uAliasName;

{$R *.DFM}

procedure TdmHlp.HtmlHelpHtmlHelpContext(Sender: TObject;
  var Data: Integer);

procedure SetLastFormIn( ActForm : TForm; FormsBuilded : TStringList );
var
   I, J : Integer;
   ActFormIn : TForm;
   ActPanelIn : TPanel;
begin
   // Procura por Paineis no Form Atual
   ActFormIn := ActForm;
   for I := 0 to ActFormIn.ComponentCount - 1 do
      if ( ActFormIn.Components[I] is TPanel ) then
        begin
         // Agora varre o Painel a procura de Forms
         ActPanelIn := TPanel( ActFormIn.Components[I] );
         for J := 0 to ActPanelIn.ComponentCount - 1 do
             if ( ActPanelIn.Components[J] is TForm ) and TForm(ActPanelIn.Components[J]).Visible then
              begin
                 FormsBuilded.Add( ActPanelIn.Components[J].Name );
                 FormsBuilded.Add( ActPanelIn.Components[J].ClassName );
                 SetLastFormIn( TForm( ActPanelIn.Components[J] ), FormsBuilded );
              end;
        end;
end;

function LocateInBuildedList( Field : String; FormsList : TStringList; var Data : Integer ) : Boolean;
var
   I : Integer;
begin
   Result := False;
   for I := 0 to FormsList.Count - 1 do
      with dmHlp.taHlp do
      if Locate( Field, FormsList.Strings[I], [] ) then
         begin
            Data := FieldByName( 'MAP').AsInteger;
            Result := True;
            exit;
         end;
end;

var
   F : TfmCadHlp;
   ActFrm : TForm;
   ActCtrl, ActCtrlParent : TControl;
   MainPath : String;
   I, TopicID : Integer;
//   I : Integer;
begin
   ActCtrlParent := nil;
   ActFrm := Screen.ActiveForm;
   // não dá pra chamar um help context sem from em foco
   if ActFrm = nil then
   begin
      exit;
   end;

   // Seta o último form de uma cadeia de InFormBuider
   FormsBuildedList.Clear;
   SetLastFormIn(ActFrm, FormsBuildedList );

   ActCtrl := Screen.ActiveForm.ActiveControl;
   // Se o PageControl tiver o foco, a ActivePage será o ActCtrl
   if ( ActCtrl <> nil ) and (ActCtrl is TPageControl ) then
      ActCtrl := TPageControl(ActCtrl).ActivePage
   // Se quiser por help para o TabSheet que contém o ActCtrl
   else if (ActCtrl <> nil) then
      begin
         ActCtrlParent := ActCtrl.Parent;
         while Assigned(ActCtrlParent) do
             if (ActCtrlParent is TTabSheet) then
                break
             else
                ActCtrlParent := ActCtrlParent.Parent;
      end;

   if not CarregaChaveString(CFGRoot, CFGPath, 'Path', MainPath ) then
   begin
      ShowMessage( 'Erro de leitura da Chave: Path'  );
      Data := 0;
      exit;
   end;

//========== só em caso de DESENVOLVIMENTO ========================
{ with dmHlp.taHlp do
 if taValidade.FieldByName( 'DESENVOLVIMENTO' ).AsString = 'T' then
   begin
    // para atualizar o ponteiro pro form abaixo
    // Pela classe do control ativo
    // Pelo nome do control ativo
    if Assigned(ActCtrl) and
        Locate( 'TOPICID', ActCtrl.Name, [] ) then
        Data := FieldByName( 'MAP').AsInteger
    else if  Assigned(ActCtrl) and
        Locate( 'TOPICID', ActCtrl.ClassName, [] ) then
        Data := FieldByName( 'MAP').AsInteger
    // Pela ActCtrlParent do ActCtrl
    else if  Assigned(ActCtrlParent) and (ActCtrlParent is TTabSheet) and
        Locate( 'TOPICID', ActCtrlParent.Name, [] ) then
        Data := FieldByName( 'MAP').AsInteger
    // Pelo nome do form ativo
    else if Locate( 'TOPICID', ActFrm.Name, [] ) then
        Data := FieldByName( 'MAP').AsInteger
    // Pela classe do form ativo
    else if Locate( 'TOPICID', ActFrm.ClassName, [] ) then
        Data := FieldByName( 'MAP').AsInteger
    // Pela Classe ou nome de um form inserido
    // Se alguem tiver o foco, mas não tiver help entra neste caso
    else if ( FormsBuildedList.Count > 0 ) and
         LocateInBuildedList( 'TOPICID', FormsBuildedList, TopicID ) then
         Data := TopicID
    else
       begin
          ShowMessage( 'Ajuda não disponível. Cadastre uma!' );
          Data := 0;
       end;

   F := TfmCadHlp.Create(self);
   try

     if FileExists( MainPath + '\Help\' + dmHlp.taHlpFiles.FieldByName( 'FILENAME').AsString + '.h' ) then
        F.ListBox1.items.LoadFromFile( MainPath + '\Help\' + dmHlp.taHlpFiles.FieldByName( 'FILENAME').AsString + '.h' );
     // Adiciona os forms, controls e tabsheets ativos para escolha
     F.rgEmFoco.Items.Add( ActFrm.Name );
     F.rgEmFoco.Items.Add( ActFrm.ClassName );
     if ( ActCtrl <> nil ) then
     begin
        // Incluir na lista pois o parent do control é um TabSheet
        if Assigned(ActCtrlParent) and (ActCtrlParent is TTabSheet) then
           F.rgEmFoco.Items.Add( ActCtrlParent.Name );
        F.rgEmFoco.Items.Add( ActCtrl.Name );
        F.rgEmFoco.Items.Add( ActCtrl.ClassName );
     end;
     // Adiciona os forms inseridos para escolha
     for I := 0 to FormsBuildedList.Count - 1 do
        F.rgEmFoco.Items.Add( FormsBuildedList.Strings[I] );

     F.rgEmFoco.ItemIndex := F.rgEmFoco.Items.IndexOf( dmHlp.taHlp.FieldByName( 'TOPICID').AsString ) ;
     if F.rgEmFoco.ItemIndex < 0 then
        F.rgEmFoco.ItemIndex := 0;
     if F.ListBox1.ItemIndex < 0 then
       F.ListBox1.ItemIndex := 0;

     F.ShowModal;
     if F.ModalResult = mrCancel then
       begin
        Data := 0;
        exit;
       end;
   finally
     F.Free;
   end;
 end;}
//==============================================================================

   with dmHlp.taHlp do
   begin
    // Pela classe do control ativo
    if Assigned(ActCtrl) and
        Locate( 'TOPICID', ActCtrl.Name, [] ) then
        Data := FieldByName( 'MAP').AsInteger
    // Pelo nome do control ativo
    else if  Assigned(ActCtrl) and
        Locate( 'TOPICID', ActCtrl.ClassName, [] ) then
        Data := FieldByName( 'MAP').AsInteger
    // Pela ActCtrlParent do ActCtrl
    else if  Assigned(ActCtrlParent) and (ActCtrlParent is TTabSheet) and
        Locate( 'TOPICID', ActCtrlParent.Name, [] ) then
        Data := FieldByName( 'MAP').AsInteger
    // Pelo nome do form ativo
    else if Locate( 'TOPICID', ActFrm.Name, [] ) then
        Data := FieldByName( 'MAP').AsInteger
    // Pela classe do form ativo
    else if Locate( 'TOPICID', ActFrm.ClassName, [] ) then
        Data := FieldByName( 'MAP').AsInteger
    // Pela Classe ou nome de um form inserido
    // Se alguem tiver o foco, mas não tiver help entra neste caso
    else if ( FormsBuildedList.Count > 0 ) and
         LocateInBuildedList( 'TOPICID', FormsBuildedList, TopicID ) then
         Data := TopicID
    else
       begin
          ShowMessage( 'Ajuda não disponível' );
          Data := 0;
          exit;
       end;

    if FieldByName( 'HLPFILE').AsString <> '' then
       begin
          HtmlHelp.ChmFile := MainPath + '\Help\' + FieldByName( 'HLPFILE' ).AsString + '.chm';
          if not FileExists( HtmlHelp.ChmFile ) then
          begin
             ShowMessage( 'Arquivo de ajuda: ' + HtmlHelp.ChmFile + ' não encontrado' );
             Data := 0;
             exit;
          end;
       end
    else
       begin
          ShowMessage( 'Referência do arquivo de ajuda: ' + FieldByName( 'FILEID' ).AsString + ' não encontrada' );
          Data := 0;
          exit;
       end;
   end;
end;

procedure TdmHlp.dmHlpCreate(Sender: TObject);
begin
dbHlp.AliasName := BDE_ALIAS_NAME;
openAllTables(self);
   FormsBuildedList := TStringList.Create;
end;

procedure TdmHlp.dmHlpDestroy(Sender: TObject);
begin
   FormsBuildedList.Free;
end;

end.

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




unit UOpSist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, DBCtrls, ExtCtrls, DBMyNav, ComCtrls, Mask,
  ExtDlgs, jpeg, RegEdit, RegConst2, Grids, DBGrids, DBCGrids, MmLstBox,
  MoveItens, Buttons, DBActns, ActnList, InsFrm, Person, NutCnst;

type
  TOpcoes = (opTodos, opCadastro, opMenu, opRelatorios, opNutrientes, opOrdemNutrientes);
  TfmOpcoesSistema = class(TForm)
    pcOpcoes: TPageControl;
    teMenu: TTabSheet;
    imSalaFormal: TImage;
    rgFundo: TRadioGroup;
    teRelatorios: TTabSheet;
    odOpcoes: TOpenPictureDialog;
    imSalaInformal: TImage;
    tsSenha: TTabSheet;
    pcSenhasSupUsu: TPageControl;
    tsSenhaSupervisor: TTabSheet;
    tsSenhaUsuarios: TTabSheet;
    laSenhaSupervisor: TLabel;
    laUsername: TLabel;
    deUsername: TDBEdit;
    nvSenha: TDBMyNav;
    grSenha: TDBGrid;
    buCancela: TButton;
    paSenha: TPanel;
    laSenha: TLabel;
    Label11: TLabel;
    edSenhaConfirma: TEdit;
    edSenha: TEdit;
    edSenhaAtual: TEdit;
    laSenhaAtual: TLabel;
    alCadSenha: TActionList;
    CadSenhaCancela: TDataSetCancel;
    CadSenhaDel: TDataSetDelete;
    CadSenhaEdit: TDataSetEdit;
    CadSenhaIns: TDataSetInsert;
    CadSenhaSal: TDataSetPost;
    laNomeUsuario: TLabel;
    deUsernameUsuario: TDBEdit;
    paSenhas: TPanel;
    laSenhaUsu: TLabel;
    laSenhaConfUsu: TLabel;
    laSenhaAtualUsuario: TLabel;
    edSenhaConfUsu: TEdit;
    edSenhaUsu: TEdit;
    edSenhaAtualUsuario: TEdit;
    laSenhaUsuario: TLabel;
    CadSenhaUsuEdit: TDataSetEdit;
    CadSenhaUsuSal: TDataSetPost;
    CadSenhaUsuCanc: TDataSetCancel;
    bbMenuOk: TBitBtn;
    bbMenuCanc: TBitBtn;
    ifNutrienteCalculadora: TInFormBuilder;
    nvUsuarios: TDBMyNav;
    buFechar: TButton;
    Panel1: TPanel;
    drCabecLinha: TDBRadioGroup;
    Label1: TLabel;
    lbPersona: TListBox;
    deCabecTexto: TDBEdit;
    laTexto: TLabel;
    Label2: TLabel;
    nvPersona: TDBMyNav;
    Button1: TButton;
    procedure rgFundoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure nvSenhaClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure sbCancelarSenhaClick(Sender: TObject);
    procedure CadSenhaInsExecute(Sender: TObject);
    procedure CadSenhaEditExecute(Sender: TObject);
    procedure CadSenhaSalExecute(Sender: TObject);
    procedure CadSenhaDelExecute(Sender: TObject);
    procedure CadSenhaCancelaExecute(Sender: TObject);
    procedure CadSenhaUsuEditExecute(Sender: TObject);
    procedure CadSenhaUsuSalExecute(Sender: TObject);
    procedure CadSenhaUsuCancExecute(Sender: TObject);
    procedure bbMenuOkClick(Sender: TObject);
    procedure bbMenuCancClick(Sender: TObject);
    procedure buCancelaClick(Sender: TObject);
    procedure nvSenhaBeforeAction(Sender: TObject; Button: TMyNavigateBtn;
      var SkipAction: Boolean);
    procedure nvUsuariosClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure buFecharClick(Sender: TObject);
    procedure pcOpcoesChange(Sender: TObject);
    procedure nvPersonaClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure CadPersonaSalExecute(Sender: TObject);
    procedure CadPersonaEditExecute(Sender: TObject);
    procedure CadPersonaCancelaExecute(Sender: TObject);

  private

    { Private declarations }
    FAvaliacao : Boolean;
    procedure GetPersona;
  public
    { Public declarations }
    function Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
    function Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
  end;

var
  fmOpcoesSistema: TfmOpcoesSistema;

implementation

uses Pessoa, OpcSalas, NutMenu, DMNutrien, fmNutAcomp, DMSemaf;

{$R *.DFM}

procedure TfmOpcoesSistema.rgFundoClick(Sender: TObject);
begin
    if rgFundo.ItemIndex = 0 then
      begin
       imSalaFormal.Visible := True;
       imSalaInformal.Visible := False;
      end
    else if rgFundo.ItemIndex = 1 then
      begin
       imSalaFormal.Visible := False;
       imSalaInformal.Visible := True;
      end
    else
      begin
       imSalaFormal.Visible := False;
       imSalaInformal.Visible := False;
      end;
end;

procedure TfmOpcoesSistema.FormCreate(Sender: TObject);


begin
    pcOpcoes.ActivePage := teMenu;

    // Abre o banco de usuarios
    DMPessoa.TbUsuarios.Active := True;

    // Posiciona no usuario logado
    DMPessoa.TbUsuarios.Locate( 'USERNAME', DMPessoa.UsuarioLogado , [] );

 {  if CarregaChaveInteger( CFGRoot, CFGPath, OPCTela, Valor ) then
      rgFundo.ItemIndex := Valor
   else
      if not CriaChaveInteger( CFGRoot, CFGPath, OPCDica, OPCTelaDefault ) then
         ShowMessage( 'Erro de criação da Chave: ' + OPCTela )
      else
         rgFundo.ItemIndex := OPCTelaDefault; }
 //   DMNutrientes.TbNutrientesbk.First;

      if DMPessoa.TbUsuarios.Locate('USERNAME',DMPessoa.UsuarioLogado,[]) then
        rgFundo.ItemIndex := DMPessoa.TbUsuarios.FieldByName('FUNDO_TELA').AsInteger
     else
        rgFundo.ItemIndex := OPCTelaDefault;



    if DMPessoa.UsuarioLogado = 'SUPERVISOR' then
       begin
         tsSenhaUsuarios.TabVisible := False;
         tsSenhaSupervisor.TabVisible := True;
       end
    else
       begin
         tsSenhaUsuarios.TabVisible := True;
         tsSenhaSupervisor.TabVisible := False;
       end;

       GetPersona;

end;

procedure TfmOpcoesSistema.Button3Click(Sender: TObject);
begin
   Close;
end;

procedure TfmOpcoesSistema.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;


procedure TfmOpcoesSistema.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if key = CHR(VK_RETURN) then
   begin
      key := #0 ;
      if (Sender is TDBGrid) then
         TDBGrid(Sender).Perform(WM_KeyDown, VK_Tab, 0)
      else
         Perform(Wm_NextDlgCtl,0,0);
   end;

end;

procedure TfmOpcoesSistema.nvSenhaClick(Sender: TObject; Button: TMyNavigateBtn);
begin

   if Button = nbInsert  then  // se for inserir
   begin
     CadSenhaInsExecute(Sender);
   end
   else if Button = nbPost  then  // se for salvar
   begin
     CadSenhaSalExecute(Sender);
   end
   else if Button = nbEdit  then  // se for editar
   begin
     CadSenhaEditExecute(Sender);
   end
   else if Button = nbCancel  then  // se for Cancelar
   begin
     CadSenhaCancelaExecute(Sender);
   end
   else if Button = nbDelete  then  // se for excluir
   begin
     CadSenhaDelExecute(Sender);
   end;

end;

procedure TfmOpcoesSistema.sbCancelarSenhaClick(Sender: TObject);
begin
     paSenha.Visible := False;
     edSenha.Text := '';
     edSenhaConfirma.Text := '' ;  // limpa o campo de confirmação da senha

     laSenhaAtual.Enabled := False;
     edSenhaAtual.Enabled := False;

     DMPessoa.TbUsuarios.Cancel;

end;

procedure TfmOpcoesSistema.CadSenhaInsExecute(Sender: TObject);
begin
     deUsername.Enabled := True;
     deUsername.SetFocus;
     paSenha.Visible := True;
     laSenhaAtual.Enabled := False;
     edSenhaAtual.Text := '';
     edSenhaAtual.Enabled := False;
     edSenha.Text := '';
     edSenhaConfirma.Text := '' ;  // limpa o campo de confirmação da senha
     DMPessoa.TbUsuarios.Insert;
end;

procedure TfmOpcoesSistema.CadSenhaEditExecute(Sender: TObject);
begin
   if DMPessoa.UsuarioLogado = 'SUPERVISOR' then
      deUsername.Enabled := False
   else
      deUsername.Enabled := True;

     paSenha.Visible := True;
     laSenhaAtual.Enabled := True;
     edSenhaAtual.Text := '';
     edSenhaAtual.Enabled := True;
     edSenhaAtual.SetFocus;
     edSenhaAtual.Text := '' ;
     edSenha.Text := '';
     edSenhaConfirma.Text := '' ;  // limpa o campo de confirmação da senha

     DMPessoa.TbUsuarios.Edit;
end;

procedure TfmOpcoesSistema.CadSenhaSalExecute(Sender: TObject);
var
  boSenhaAtual : boolean;
  boSenhas :  boolean;

begin
     boSenhaAtual := True;
     boSenhas := True;

     // Verifica se a senha atual está correta
     if DMPessoa.TbUsuarios.state = dsEdit then
        begin
           if DMPessoa.Cript(edSenhaAtual.text) <> DMPessoa.TbUsuarios.Fieldbyname('Senha').asString then
              boSenhaAtual := False;
        end;
     // Verifica se as duas senhas estão iguais
     if edSenha.Text <> edSenhaConfirma.Text then
          boSenhas := False;

     // Configura
     if  (boSenhaAtual = False) and (boSenhas = False) then
         begin
          ShowMessage( 'A Senha Atual e as demais não conferem. Tente novamente.');
          edSenhaAtual.Text := '' ;
          edSenha.text := '';
          edSenhaConfirma.text := '';
          edSenhaAtual.SetFocus;
         end
     else if boSenhaAtual = False then
         begin
          ShowMessage( 'A Senha Atual não confere. Tente novamente.');
          edSenhaAtual.Text := '' ;
          edSenhaAtual.SetFocus;
         end
     else if boSenhas = False then
         begin
          ShowMessage( 'A Senha e sua Confirmação não conferem. Tente novamente.');
          edSenha.text := '';
          edSenhaConfirma.text := '';
          edSenha.SetFocus;
         end
     else
         begin
          //criptografa a senha
          DMPessoa.TbUsuarios.Fieldbyname('Senha').asString := DMPessoa.Cript(edSenha.Text) ;
          DMPessoa.TbUsuarios.Post;
          paSenha.Visible := False;
          edSenhaAtual.text := '';
          edSenha.text := '';
          edSenhaConfirma.text := '';
         end;


     if DMPessoa.TbUsuarios.state <> dsEdit then
      begin
       laSenhaAtual.Enabled := False;
       edSenhaAtual.Enabled := False;
      end;



end;

procedure TfmOpcoesSistema.CadSenhaDelExecute(Sender: TObject);
begin
    if DMPessoa.TbUsuarios.Fieldbyname('Username').asString = 'SUPERVISOR' then
       ShowMessage('O SUPERVISOR não pode ser excluído.')
    else
    begin
       if MessageDlg('Deseja excluir os dados ?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          DMPessoa.TbUsuarios.Delete;
    end;
end;

procedure TfmOpcoesSistema.CadSenhaCancelaExecute(Sender: TObject);
begin
   paSenha.Visible := False;
   DMPessoa.TbUsuarios.Cancel;
end;

procedure TfmOpcoesSistema.CadSenhaUsuEditExecute(Sender: TObject);
begin
     paSenhas.Visible := True;
     laSenhaAtualUsuario.Enabled := True;
     edSenhaAtualUsuario.Enabled := True;
     edSenhaAtualUsuario.SetFocus;

     edSenhaAtualUsuario.Text := '' ;
     edSenhaUsu.Text := '';
     edSenhaConfUsu.Text := '' ;  // limpa o campo de confirmação da senha

     DMPessoa.TbUsuarios.Edit;
end;

procedure TfmOpcoesSistema.CadSenhaUsuSalExecute(Sender: TObject);
var
  boSenhaAtual : boolean;
  boSenhas :  boolean;

begin
     boSenhaAtual := True;
     boSenhas := True;

     // Verifica se a senha atual está correta
     if DMPessoa.TbUsuarios.state = dsEdit then
        begin
           if DMPessoa.Cript(edSenhaAtualUsuario.text) <> DMPessoa.TbUsuarios.Fieldbyname('Senha').asString then
              boSenhaAtual := False;
        end;
     // Verifica se as duas senhas estão iguais
     if edSenhaUsu.Text <> edSenhaConfUsu.Text then
          boSenhas := False;

     // Configura
     if  (boSenhaAtual = False) and (boSenhas = False) then
         begin
          ShowMessage( 'A Senha Atual e as demais não conferem. Tente novamente.');
          edSenhaAtualUsuario.Text := '' ;
          edSenhaUsu.text := '';
          edSenhaConfUsu.text := '';
          edSenhaAtualUsuario.SetFocus;
         end
     else if boSenhaAtual = False then
         begin
          ShowMessage( 'A Senha Atual não confere. Tente novamente.');
          edSenhaAtualUsuario.Text := '' ;
          edSenhaAtualUsuario.SetFocus;
         end
     else if boSenhas = False then
         begin
          ShowMessage( 'A Senha e sua Confirmação não conferem. Tente novamente.');
          edSenhaUsu.text := '';
          edSenhaConfUsu.text := '';
          edSenhaUsu.SetFocus;
         end
     else
         begin
          //criptografa a senha
          DMPessoa.TbUsuarios.Fieldbyname('Senha').asString := DMPessoa.Cript(edSenhaUsu.Text) ;
          DMPessoa.TbUsuarios.Post;
          paSenhas.Visible := False;
          edSenhaAtualUsuario.text := '';
          edSenhaUsu.text := '';
          edSenhaConfUsu.text := '';
         end;


     if DMPessoa.TbUsuarios.state <> dsEdit then
      begin
       laSenhaAtualUsuario.Enabled := False;
       edSenhaAtualUsuario.Enabled := False;
      end;



end;

procedure TfmOpcoesSistema.CadSenhaUsuCancExecute(Sender: TObject);
begin
   paSenhas.Visible := False;
   DMPessoa.TbUsuarios.Cancel;
end;

procedure TfmOpcoesSistema.bbMenuOkClick(Sender: TObject);
begin
//    if not GravaChaveInteger( CFGRoot, CFGPath, OPCTela, rgFundo.ItemIndex ) then
//        ShowMessage( 'Erro de gravação da Chave: ' + OPCTela )

     if DMPessoa.TbUsuarios.Locate('USERNAME',DMPessoa.UsuarioLogado,[]) then
        begin // 0 = False e 1 = True
          DMPessoa.TbUsuarios.Edit;
          DMPessoa.TbUsuarios.FieldByName('FUNDO_TELA').AsInteger := rgFundo.ItemIndex;
          DMPessoa.TbUsuarios.Post;
          with fmOpcSalas do
          begin
            Container := fm_MenuNut.pa_Menu_Visual;
            Modal := False;
            EventoObjetoSala := fm_MenuNut.ClickObjetoSala;
            case rgFundo.ItemIndex of
              0 : ShowSala2;
              1 : ShowSala1;
              2 : ShowSala0;
            end;
          end;
        end;
    Close;
end;

procedure TfmOpcoesSistema.bbMenuCancClick(Sender: TObject);
begin
   Close;
end;

procedure TfmOpcoesSistema.buCancelaClick(Sender: TObject);
begin
  DMPessoa.TbUsuarios.Cancel;
  DMPessoa.TbUsuarios.Active := False;
  Close;
end;

procedure TfmOpcoesSistema.nvSenhaBeforeAction(Sender: TObject;
  Button: TMyNavigateBtn; var SkipAction: Boolean);
begin
   // Estou forçando este uso, para poder utilizar os actions
   SkipAction := True;
end;

procedure TfmOpcoesSistema.nvUsuariosClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
   if Button = nbPost  then  // se for salvar
   begin
     CadSenhaUsuSalExecute(Sender);
   end
   else if Button = nbEdit  then  // se for editar
   begin
     CadSenhaUsuEditExecute(Sender);
   end
   else if Button = nbCancel  then  // se for Cancelar
   begin
     CadSenhaUsuCancExecute(Sender);
   end;

end;

procedure TfmOpcoesSistema.buFecharClick(Sender: TObject);
begin
  DMPessoa.TbUsuarios.Cancel;
  DMPessoa.TbUsuarios.Active := False;
  Close;
end;

procedure TfmOpcoesSistema.pcOpcoesChange(Sender: TObject);
begin
   // Senhas Supervisor
   if (pcSenhasSupUsu.ActivePage <> tsSenhaSupervisor ) and
      (tsSenhaSupervisor.TabVisible = True ) then
   begin
      if (DMPessoa.TbUsuarios.State = dsInsert) or (DMPessoa.TbUsuarios.State = dsEdit) then
         begin
          pcOpcoes.ActivePage := tsSenha;
          pcSenhasSupUsu.ActivePage := tsSenhaSupervisor;
          ShowMessage('Salve ou Cancele seus dados antes de sair.');
         end;
   end ;

   // Senhas Usuarios
   if (pcSenhasSupUsu.ActivePage <> tsSenhaUsuarios ) and
      (tsSenhaUsuarios.TabVisible = True ) then
   begin
      if (DMPessoa.TbUsuarios.State = dsInsert) or (DMPessoa.TbUsuarios.State = dsEdit) then
         begin
          pcOpcoes.ActivePage := tsSenha;
          pcSenhasSupUsu.ActivePage := tsSenhaUsuarios;
          ShowMessage('Salve ou Cancele seus dados antes de sair.');
         end;
   end ;
end;

function TfmOpcoesSistema.Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Trava pasta escolhida, assim mais de uma pessoa NÃO pode acessar
         essa pasta esteja ela na mesma máquina ou nao.
  **)
  Result := dmSemaforo.TravaRecurso('OpP_' + sNomeDaPasta, 'Tabelas de opções do Indivíduo');
  if not Result then
    ShowMessage('Pasta em uso, favor tentar novamente mais tarde!');
end;

function TfmOpcoesSistema.Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Limpa recurso da tabela
  assim não fica preso para essa aplicação
  **)
  Result := dmSemaforo.LiberaRecurso('OpP_' + sNomeDaPasta);
end;

procedure TfmOpcoesSistema.nvPersonaClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin

   if Button = nbPost  then  // se for salvar
   begin
     CadPersonaSalExecute(Sender);
   end
   else if Button = nbEdit  then  // se for editar
   begin
     CadPersonaEditExecute(Sender);
   end
   else if Button = nbCancel  then  // se for Cancelar
   begin
     CadPersonaCancelaExecute(Sender);
   end;

end;

procedure TfmOpcoesSistema.CadPersonaCancelaExecute(Sender: TObject);
begin
   DMPessoa.TbUsuarios.Cancel;
   drCabecLinha.Enabled := False;
   deCabecTexto.Enabled := False;
   GetPersona;
end;

procedure TfmOpcoesSistema.CadPersonaEditExecute(Sender: TObject);
begin
   DMPessoa.TbUsuarios.Edit;
   drCabecLinha.Enabled := True;
   deCabecTexto.Enabled := True;
   GetPersona;
end;

procedure TfmOpcoesSistema.CadPersonaSalExecute(Sender: TObject);
begin

   if FAvaliacao then
   begin
         ShowMessage( 'Esta versão é de avaliação, portanto não é permitido alterar qualquer linha.' );
         exit
   end
   else if (drCabecLinha.ItemIndex = 1) or (drCabecLinha.ItemIndex = 2) then
      begin
         ShowMessage( 'Esta linha não pode ser alterada.' );
         exit
      end;
//   else if (( Trim(deCabecTexto.Text) = '' ) or  (Length(deCabecTexto.Text) < 5)) and (drCabecLinha.ItemIndex<>0)then
//      begin
//         ShowMessage( 'Esta linha tem que ter ao menos 5 caracteres.' );
//         exit;
//      end;

   DMPessoa.TbUsuarios.Post;
   drCabecLinha.Enabled := False;
   deCabecTexto.Enabled := False;
   GetPersona;

   // seta as constantes para os relatórios
   with TConstantes( GetConstantes ) do
   begin
      CabecLinha := StrToInt(drCabecLinha.Value);
      CabecTexto := deCabecTexto.Text;
   end;

end;

const   ALERTA =  'VERSÃO NÃO PERSONALIZADA!';

procedure TfmOpcoesSistema.GetPersona;
var
   Valor: String;
   Personalizou : Boolean;
   i : Integer;
   Persona : TStringList;
begin
   i := 0;
   Personalizou := False;
   Persona := TStringList.Create;
   try
      // Forma de pegar uma chave que não seja do registro do windows
      if CarregaChaveString( CFGROOT, CFGPath, CFGPersonaFileName, Valor ) and
         FileExists(Valor+'\'+PersonaFileName()+'.cfg') then
         begin
            i := LoadPersona(Valor+'\'+PersonaFileName()+'.cfg', Persona, '', False);
            case i of
               1 : ShowMessage( HD_INVALIDO );
               2 : ShowMessage( SERIAL_INVALIDO );
               3 : ShowMessage( ARQUIVO_DANIFICADO );
            else
               Personalizou := True;
            end;
         end;
   finally
      if not Personalizou or (i > 0) then
      begin
         Persona.Clear;
         Persona.Add(ALERTA + ' - ' + ALERTA);
         Persona.Add(ALERTA + ' - ' + ALERTA);
         Persona.Add(ALERTA + ' - ' + ALERTA);
      end;
      lbPersona.Items.Clear;
      lbPersona.Items.Add( Persona.Strings[0] );
      lbPersona.Items.Add( Persona.Strings[1] );
      lbPersona.Items.Add( Persona.Strings[2] );
      if ( drCabecLinha.Value <> '0' ) AND ( drCabecLinha.Value <> '' ) then
         lbPersona.Items.Strings[ StrToInt(drCabecLinha.Value)-1 ] := deCabecTexto.Text;
      Persona.Free;
   end;
end;

end.

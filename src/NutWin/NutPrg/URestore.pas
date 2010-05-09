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




unit URestore;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FileCtrl, Buttons, Backup, Gauges, RegEdit, RegConst2, NutCnst;

type
  TfmRestore = class(TForm)
    paBottom: TPanel;
    paRight: TPanel;
    buFechar_Cancelar: TButton;
    buRecuperar: TButton;
    paClient: TPanel;
    gbCaminho: TGroupBox;
    rbLocalOriginal: TRadioButton;
    rbOutroLocal: TRadioButton;
    OpenDialog: TOpenDialog;
    edArquivo: TEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    drOutroDrive: TDriveComboBox;
    diOutroDiretorio: TDirectoryListBox;
    laCaminho: TLabel;
    laEmAndamento: TLabel;
    gaPorcentagem: TGauge;
    laTitulo: TLabel;

    procedure BitBtn1Click(Sender: TObject);
    procedure rbOutroLocalClick(Sender: TObject);
    procedure rbLocalOriginalClick(Sender: TObject);
    procedure buRecuperarClick(Sender: TObject);
    procedure Restorefile2NeedDisk(Sender: TObject; DiskID: Word; var Continue: Boolean);
    procedure RestoreFile2Progress(Sender: TObject; FileName: String; Percent: TPercentage; var Continue: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure buFechar_CancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure drOutroDriveChange(Sender: TObject);
    procedure BackupFile2Error(Sender: TObject; const Error: Integer;
      ErrString: String);
  private
    { Private declarations }
    FsDrive: Char;
  public
    { Public declarations }
    MainPath : String;
    BackupFile: TBackupFile;
    function Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
    function Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
  end;

var
   fmRestore: TfmRestore;

implementation

uses DMSemaf, Services;

{$R *.DFM}

procedure TfmRestore.BitBtn1Click(Sender: TObject);
Var
   ListaArq: TStringlist;
begin
   ListaArq := TStringlist.Create;
   with OpenDialog do
   begin
      if Execute then
      begin
         laTitulo.Caption := BackupFile.GetArchiveTitle(FileName,ListaArq);
         if laTitulo.Caption <> '' then //Se for ='', Arquivo é inválido!!
         begin
            edArquivo.Text := FileName;
            FsDrive := FileName[1];
         end;
         ListaArq.Free;
      end;
   end;
end;

procedure TfmRestore.rbOutroLocalClick(Sender: TObject);
begin
   drOutroDrive.Enabled := rbOutroLocal.Checked;
   diOutroDiretorio.Enabled := rbOutroLocal.Checked;
   if rbOutroLocal.Checked then
   begin
      diOutroDiretorio.Color := clWindow;
      drOutroDrive.Color := clWindow;
   end
   else
   begin
      diOutroDiretorio.Color := clBtnFace;
      drOutroDrive.Color := clBtnFace;
   end;
end;

procedure TfmRestore.rbLocalOriginalClick(Sender: TObject);
begin

   diOutroDiretorio.Directory := MainPath +'\MyNutWin\';
   drOutroDrive.Drive := diOutroDiretorio.Drive;
   drOutroDrive.Enabled := rbOutroLocal.Checked;
   diOutroDiretorio.Enabled := rbOutroLocal.Checked;
   if rbOutroLocal.Checked then
   begin
      diOutroDiretorio.Color := clWindow;
      drOutroDrive.Color := clWindow;
   end
   else
   begin
      diOutroDiretorio.Color := clBtnFace;
      drOutroDrive.Color := clBtnFace;
   end;
end;

procedure TfmRestore.buRecuperarClick(Sender: TObject);
var
   LsDestino: String;
begin
   if edArquivo.Text = '' then
   begin
      MessageDlg('Nenhum arquivo foi selecionado!',mtInformation,[mbOk],0);
      Exit;
   end;
   BackupFile.Restoremode  := rmAll;
   if rbLocalOriginal.Checked then
      LsDestino := ''
   else
   begin
      LsDestino := diOutroDiretorio.Directory;
   end;
   BackupFile.RestoreFullPath := False;
   buRecuperar.Enabled := False;
   buFechar_Cancelar.Caption := 'Cancelar';
   StopSvc('MySql', '');
   if BackupFile.Restore(edArquivo.Text, LsDestino) then
      MessageDlg('Recuperação concluída!',mtInformation,[mbOk],0)
   else
      MessageDlg('A recuperação falhou ou foi interrompida!',mtInformation,[mbOk],0);
   buRecuperar.Enabled := True;
   buFechar_Cancelar.Caption := '&Fechar';
   StartSvc('MySql', '');
end;

procedure TfmRestore.Restorefile2NeedDisk(Sender: TObject; DiskID: Word; var Continue: Boolean);
begin
      if MessageDlg('Insira o disco '+IntToStr(DiskID)+' no drive '+UpperCase(FsDrive)+' e'+#13#10+
                    'pressione OK para continuar.', mtConfirmation, [mbOK, mbCancel], 0) = mrCancel then
      begin
         Continue := False;
         Exit;
      end;
end;

procedure TfmRestore.RestoreFile2Progress(Sender: TObject; FileName: String; Percent: TPercentage; var Continue: Boolean);
begin
   with gaPorcentagem do
   begin
      laEmAndamento.Visible := Percent < 100;
      buRecuperar.Enabled := Percent >= 100;
      paClient.Enabled := Percent >= 100;
      Visible := Percent < 100;
      if Visible then
         Progress := Percent;
   end;
end;

procedure TfmRestore.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
   if BackupFile.Busy then
      BackupFile.Stop
end;

procedure TfmRestore.buFechar_CancelarClick(Sender: TObject);
begin
   if BackupFile.Busy then
      BackupFile.Stop
   else
      Close;
end;

procedure TfmRestore.FormCreate(Sender: TObject);

begin


    BackupFile := TBackupFile.Create(self);
   BackupFile.Version := '3.00';
   BackupFile.BackupMode := bmIncremental;
   BackupFile.CompressionLevel := clFastest;
   BackupFile.RestoreMode := rmAll;
   BackupFile.MaxSize := 0;
   BackupFile.SetArchiveFlag := True;
   BackupFile.OnProgress := RestoreFile2Progress;
   BackupFile.OnNeedDisk := Restorefile2NeedDisk;
   BackupFile.OnError := BackupFile2Error;
   BackupFile.RestoreFullPath := False;
   BackupFile.SaveFileID := False;
      if not CarregaChaveString(CFGRoot, CFGPath, 'ProgramDataPath', MainPath ) then
      begin
         ShowMessage( 'Erro de leitura da Chave: Path'  );
         exit;
      end;

//   diOutroDiretorio.Directory := MainPath +'\IBDADOS\BDADOS.GDB';
      diOutroDiretorio.Directory := MainPath +'\MyNutWin\';
end;

procedure TfmRestore.drOutroDriveChange(Sender: TObject);
begin
   diOutroDiretorio.Drive := drOutroDrive.Drive;
end;

procedure TfmRestore.BackupFile2Error(Sender: TObject; const Error: Integer;
  ErrString: String);
begin
   ShowMessage(errString);
end;

function TfmRestore.Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Trava pasta escolhida, assim mais de uma pessoa NÃO pode acessar
         essa pasta esteja ela na mesma máquina ou nao.
  **)
  Result := true; //dmSemaforo.TravaRecurso('Res_' + sNomeDaPasta, 'Restore');
  // não posso usar semaforo aqui, pois o datamodule dmSemafora não existe mais
  if not Result then
    ShowMessage('Pasta em uso, favor tentar novamente mais tarde!');
end;

function TfmRestore.Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Limpa recurso da tabela
  assim não fica preso para essa aplicação
  **)
  Result := true; //dmSemaforo.LiberaRecurso('Res_' + sNomeDaPasta);
  // não posso usar semaforo aqui, pois o datamodule dmSemafora não existe mais
end;

end.
 
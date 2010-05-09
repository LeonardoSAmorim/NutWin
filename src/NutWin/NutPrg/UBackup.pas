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




unit UBackup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,  ExtCtrls, Backup, ComCtrls, Gauges, FileUtil;

type
  TfmBackup = class(TForm)
    paBottom: TPanel;
    paRight: TPanel;
    paClient: TPanel;
    Arquivo: TLabel;
    edArquivo: TEdit;
    BitBtn1: TBitBtn;
    buCopiar: TButton;
    buFechar_Cancelar: TButton;
    gaPorcentagem: TGauge;
    SaveDialog: TSaveDialog;
    laEmAndamento: TLabel;
    Label1: TLabel;
    edTitulo: TEdit;
    paAguarde: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure buCopiarClick(Sender: TObject);
    procedure Backupfile2NeedDisk(Sender: TObject; DiskID: Word; var Continue: Boolean);
    procedure buFechar_CancelarClick(Sender: TObject);
    procedure Backupfile2Progress(Sender: TObject; FileName: String; Percent: TPercentage; var Continue: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Backupfile2Error(Sender: TObject; const Error: Integer;
      ErrString: String);
  private
    { Private declarations }
    FsDrive: Char;
  public
     pListaDeArquivos:TStrings;
     BackupFile: TBackupFile;
    { Public declarations }
    function Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
    function Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
  end;

var
   fmBackup: TfmBackup;

implementation

uses DMSemaf, Services;

{$R *.DFM}

procedure TfmBackup.BitBtn1Click(Sender: TObject);
begin
   with SaveDialog do
   begin
      FileName := edArquivo.Text;
      if Execute then
      begin
         FsDrive := FileName[1];
         edArquivo.Text := FileName;

      end;

   end;
end;

procedure TfmBackup.buCopiarClick(Sender: TObject);


begin
     StopSvc('MySql', '');
   if edArquivo.Text = '' then
   begin
      MessageDlg('Nenhum arquivo selecionado!',mtInformation,[mbOk],0);
      Exit;
   end;
   BackupFile.MaxSize := 0;
   BackupFile.BackupTitle := edTitulo.Text;
   BackupFile.BackupMode := bmAll;
   BackupFile.CompressionLevel := clMax;
   BackupFile.SaveFileID := False;
   //Arquivos
   buCopiar.Enabled := False;
   buFechar_Cancelar.Caption := 'Cancelar';
   if BackupFile.Backup(pListaDeArquivos, edArquivo.Text) then
      MessageDlg('Cópia concluída!'+#13#10+'Compressão de '+IntToStr(BackupFile.compressionRate)+'%',mtInformation,[mbOk],0)
   else
      MessageDlg('O procedimento de cópia falhou ou foi interrompido!',mtInformation,[mbOk],0);
   buCopiar.Enabled := True;
   buFechar_Cancelar.Caption := '&Fechar';

   StartSvc('MySql', '');

end;

procedure TfmBackup.Backupfile2NeedDisk(Sender: TObject; DiskID: Word; var Continue: Boolean);
begin
      MessageDlg('Disco Cheio!', mtError, [mbOK],0);
      Continue := False;
end;

procedure TfmBackup.buFechar_CancelarClick(Sender: TObject);
begin
   if BackupFile.Busy then
      BackupFile.Stop
   else
      Close;
end;

procedure TfmBackup.Backupfile2Progress(Sender: TObject; FileName: String; Percent: TPercentage; var Continue: Boolean);
begin
   with gaPorcentagem do
   begin
      laEmAndamento.Visible := Percent < 100;
      buCopiar.Enabled := Percent >= 100;
      paClient.Enabled := Percent >= 100;
      Visible := Percent < 100;
      if Visible then
         Progress := Percent;
   end;
end;

procedure TfmBackup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if BackupFile.Busy then
   begin
      BackupFile.Stop;
      Action := caNone;
   end
   else
      Action := caFree;
end;

procedure TfmBackup.FormCreate(Sender: TObject);
begin
   fsDrive := 'C';//Default
   pListaDeArquivos := TStringList.Create;
   BackupFile := TBackupFile.Create(self);
   BackupFile.Version := '3.00';
   BackupFile.BackupMode := bmIncremental;
   BackupFile.CompressionLevel := clFastest;
   BackupFile.RestoreMode := rmAll;
   BackupFile.MaxSize := 0;
   BackupFile.SetArchiveFlag := True;
   BackupFile.OnProgress := Backupfile2Progress;
   BackupFile.OnNeedDisk := Backupfile2NeedDisk;
   BackupFile.OnError := Backupfile2Error;
   BackupFile.RestoreFullPath := False;
   BackupFile.SaveFileID := False;
end;

procedure TfmBackup.FormDestroy(Sender: TObject);
begin
   pListaDeArquivos.Free;

end;

procedure TfmBackup.Backupfile2Error(Sender: TObject; const Error: Integer; ErrString: String);
begin
   ShowMessage(errString);
end;

function TfmBackup.Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Trava pasta escolhida, assim mais de uma pessoa NÃO pode acessar
         essa pasta esteja ela na mesma máquina ou nao.
  **)
  Result := true; //dmSemaforo.TravaRecurso('Bkp_' + sNomeDaPasta, 'Backup');
    // não posso usar semaforo aqui, pois o datamodule dmSemafora não existe mais
  if not Result then
    ShowMessage('Pasta em uso, favor tentar novamente mais tarde!');
end;

function TfmBackup.Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Limpa recurso da tabela
  assim não fica preso para essa aplicação
  **)
  Result := true; //dmSemaforo.LiberaRecurso('Res_' + sNomeDaPasta);
  // não posso usar semaforo aqui, pois o datamodule dmSemafora não existe mais
end;

end.
 
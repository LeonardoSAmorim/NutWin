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
  StdCtrls, Buttons, DiskInfo, ExtCtrls, Backup, ComCtrls, Gauges, FileUtil;

type
  TfmBackup = class(TForm)
    paBottom: TPanel;
    paRight: TPanel;
    paClient: TPanel;
    Arquivo: TLabel;
    edArquivo: TEdit;
    BitBtn1: TBitBtn;
    DiskInfo: TDiskInfo;
    Label2: TLabel;
    buCopiar: TButton;
    buFechar_Cancelar: TButton;
    BackupFile: TBackupFile;
    gaPorcentagem: TGauge;
    SaveDialog: TSaveDialog;
    laEmAndamento: TLabel;
    Label1: TLabel;
    edTitulo: TEdit;
    laTipoDrive: TLabel;
    paAguarde: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure buCopiarClick(Sender: TObject);
    procedure BackupFileNeedDisk(Sender: TObject; DiskID: Word; var Continue: Boolean);
    procedure buFechar_CancelarClick(Sender: TObject);
    procedure BackupFileProgress(Sender: TObject; FileName: String; Percent: TPercentage; var Continue: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BackupFileError(Sender: TObject; const Error: Integer;
      ErrString: String);
  private
    { Private declarations }
    FsDrive: Char;
  public
     pListaDeArquivos:TStrings;
    { Public declarations }
    function Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
    function Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
  end;

var
   fmBackup: TfmBackup;

implementation

uses DMSemaf;

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
         //Pegando informação do disco
         try
         DiskInfo.Disk := FileName[1];
         except
            MessageDlg('Erro na leitura do drive selecionado!',mtError,[mbOk],0);
            Exit;
         end;
      end;
      case DiskInfo.DriveType of
         dtFloppy: laTipoDrive.Caption := 'Disquete';
         dtFixed: laTipoDrive.Caption := 'Disco Rígido';
         dtNetwork: laTipoDrive.Caption := 'Drive de Rede';
         dtCDROM: laTipoDrive.Caption := 'CD-ROM';
         dtRAM: laTipoDrive.Caption := 'RAM';
      end;
   end;
end;

procedure TfmBackup.buCopiarClick(Sender: TObject);
begin
   if edArquivo.Text = '' then
   begin
      MessageDlg('Nenhum arquivo selecionado!',mtInformation,[mbOk],0);
      Exit;
   end;
   DiskInfo.Disk := FsDrive; //Relendo o Drive
   if DiskInfo.DriveType = dtFloppy then
   begin
      if MessageDlg('Atenção! O procedimento de cópia de segurança irá'+#13#10+
                    'apagar o conteúdo do(s) disco(s). Confirma?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
      begin
         if MessageDlg('Insira o disco 1 no drive '+UpperCase(FsDrive)+' e'+#13#10+
                       'pressione OK para iniciar.', mtConfirmation, [mbOK, mbCancel], 0) = mrOK then
         begin
            paAguarde.Visible := True;
            fmBackup.Refresh;
            ClearDir(DiskInfo.Disk+':\', True);
            paAguarde.Visible := False;
            fmBackup.Refresh;
            DiskInfo.Disk := FsDrive;
         end
         else
            Exit;
      end
      else
         Exit;
  //    SetVolumeLabel(PChar(FsDrive),'BkpNW-1');
      BackupFile.MaxSize := DiskInfo.DiskFree;
   end
   else
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
end;

procedure TfmBackup.BackupFileNeedDisk(Sender: TObject; DiskID: Word; var Continue: Boolean);
begin
      if MessageDlg('Insira o disco '+IntToStr(DiskID)+' no drive '+UpperCase(FsDrive)+' e'+#13#10+
                    'pressione OK para continuar.', mtConfirmation, [mbOK, mbCancel], 0) = mrOK then
      begin
         paAguarde.Visible := True;
         fmBackup.Refresh;
         ClearDir(DiskInfo.Disk+':\', True);
         paAguarde.Visible := False;
         fmBackup.Refresh;
         DiskInfo.Disk := FsDrive;
      end
      else
      begin
         Continue := False;
         Exit;
      end;
      BackupFile.MaxSize := DiskInfo.DiskFree;
     // SetVolumeLabel(PChar(FsDrive),PChar('BkpNW-'+IntToStr(DiskID)));
end;

procedure TfmBackup.buFechar_CancelarClick(Sender: TObject);
begin
   if BackupFile.Busy then
      BackupFile.Stop
   else
      Close;
end;

procedure TfmBackup.BackupFileProgress(Sender: TObject; FileName: String; Percent: TPercentage; var Continue: Boolean);
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
   fsDrive := 'A';//Default
   {
   pListaDeArquivos - Lista dos Arquivos a serem Copiados...
   Para outras aplicações que não o Clinic Manager, mude este
   valor logo após o Create deste form, não esqueçam de Limpa-la
   Exemplo,
      Application.CreateForm(TfmBackup, fmBackup);
      fmBackup.pListaDeArquivos.clear;
      fmBackup.pListaDeArquivos.add('GuideLines.mdb');
      ...
      fmBackup.show;
   }


   pListaDeArquivos := TStringList.Create;
end;

procedure TfmBackup.FormDestroy(Sender: TObject);
begin
   pListaDeArquivos.Free;
end;

procedure TfmBackup.BackupFileError(Sender: TObject; const Error: Integer; ErrString: String);
begin
   ShowMessage(errString);
end;

function TfmBackup.Travapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Trava pasta escolhida, assim mais de uma pessoa NÃO pode acessar
         essa pasta esteja ela na mesma máquina ou nao.
  **)
  Result := dmSemaforo.TravaRecurso('Bkp_' + sNomeDaPasta, 'Backup');
  if not Result then
    ShowMessage('Pasta em uso, favor tentar novamente mais tarde!');
end;

function TfmBackup.Liberapasta(sNomeDaPasta: string='Tabelas'): boolean;
begin
  (**
  Jair - Limpa recurso da tabela
  assim não fica preso para essa aplicação
  **)
  Result := dmSemaforo.LiberaRecurso('Bkp_' + sNomeDaPasta);
end;

end.

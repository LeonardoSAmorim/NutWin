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




unit Sobre;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Registry, lslAboutBoxDialog, lslVersionInfo, NutCnst;

type
  TfmSobre = class(TForm)
    buOK: TButton;
    buInfo: TButton;
    buSuporte: TButton;
    imCliWin: TImage;
    laVersao: TLabel;
    laTitulo_Usuario: TLabel;
    laNome_Usuario: TLabel;
    laDescricao: TLabel;
    laCopyright: TLabel;
    laNome_Produto: TLabel;
    laUsuario: TLabel;
    paUsuario: TPanel;
    meDireitos_Legais: TMemo;
    laNome_Usuario2: TLabel;
    laNome_Empresa: TLabel;
    laTitutlo_ID_Produto: TLabel;
    laID_Produto: TLabel;
    beLinha: TBevel;
    lslSobre: TlslAboutBoxDialog;
    laTipo_Versao: TLabel;
    procedure buInfoClick(Sender: TObject);
    procedure buSuporteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure buOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FNomeUsuario: String;
    procedure SetNomeUsuario(const Value: String);
    { Private declarations }
  public
    { Public declarations }
    property NomeUsuario : String read FNomeUsuario write SetNomeUsuario;
  end;

var
  fmSobre: TfmSobre;

implementation

//uses Usuario, dmConecta, InfoSistema, Procedures;
uses InfoSistema;

{$R *.DFM}

procedure TfmSobre.buInfoClick(Sender: TObject);
var
   F : TfmInfoSistema;
begin
   F := TfmInfoSistema.Create(self);
   F.ShowModal;
   F.Free;
end;

procedure TfmSobre.buSuporteClick(Sender: TObject);
begin
   MessageDlg( TEXTO_ENDERECO,mtCustom,[mbOk],1);
end;

procedure TfmSobre.FormCreate(Sender: TObject);
var GtrReg : TRegistry;
    LsVersao, TipoVersao : String;
    LtffPreRelease : TFileFlag;
begin
   laNome_Produto.Caption := lslSobre.VersionInfo.ProductName;
   laCopyright.Caption := lslSobre.VersionInfo.CompanyName+#13#10+lslSobre.VersionInfo.LegalCopyright;
   laVersao.Caption := 'Versão '+lslSobre.VersionInfo.ProductVersion.AsString;
//*   dmConexao.taValidade.Active := True;
{*   if dmConexao.taValidade.FieldByName('Desenvolvimento').AsBoolean = True then
      LsVersao := ' - Versão de Desenvolvimento'
   else if dmConexao.taValidade.FieldByName('Versao_Avaliacao').AsBoolean = True then
      LsVersao := ' - Versão de Avaliação'
   else }
      LsVersao := '';
//*   dmConexao.taValidade.Active := False;
   LtffPreRelease := vsPreRelease;
   if lslsobre.VersionInfo.FileFlags = [LtffPreRelease] then
      laDescricao.Caption := 'Beta '+lslSobre.VersionInfo.FileVersion.AsString+LsVersao+#13#10+lslSobre.VersionInfo.FileDescription
   else
      laDescricao.Caption := lslSobre.VersionInfo.FileVersion.AsString+LsVersao+#13#10+lslSobre.VersionInfo.FileDescription;
   GtrReg := TRegistry.Create;
   GtrReg.RootKey := HKey_Local_Machine;
   GtrReg.OpenKey('\Software\DIS-EPM\NUTWIN',False);
   try
      TipoVersao := GtrReg.ReadString('Tipo');
      if TipoVersao <> '' then
         laTipo_Versao.Caption := 'Tipo: ' + TipoVersao;
   except on E:Exception do
      laTipo_Versao.Caption := '*** Tipo não disponível ***'
   end;
   try
      laNome_Usuario2.Caption := GtrReg.ReadString('Name');
   except on E:Exception do
      laNome_Usuario2.Caption := '*** Nome não disponível ***'
   end;
   try
      laNome_Empresa.Caption := GtrReg.ReadString('Company');
   except on E:Exception do
      laNome_Empresa.Caption := '*** Empresa não disponível ***'
   end;
   try
      laID_Produto.Caption := GtrReg.ReadString('Serial');
   except on E:Exception do
      laID_Produto.Caption := '*** não disponível ***'
   end;
   GtrReg.Free;
//*   Centraliza_Form(Self);
end;

procedure TfmSobre.buOKClick(Sender: TObject);
begin
   Close;
end;

procedure TfmSobre.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfmSobre.SetNomeUsuario(const Value: String);
begin
   FNomeUsuario := Value;
   if FNomeUsuario <> '' then
   begin
      laNome_Usuario.Caption := FNomeUsuario;
      laNome_Usuario.Visible := True;
      laTitulo_Usuario.Visible := True;
   end;
end;

end.

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
  StdCtrls, ExtCtrls, Registry, NutCnst, VersionInfo;

type
  TfmSobre = class(TForm)
    buOK: TButton;
    buInfo: TButton;
    buSuporte: TButton;
    imCliWin: TImage;
    laVersao: TLabel;
    laDescricao: TLabel;
    laCopyright: TLabel;
    laNome_Produto: TLabel;
    meDireitos_Legais: TMemo;
    beLinha: TBevel;

    laTipo_Versao: TLabel;
    procedure buInfoClick(Sender: TObject);
    procedure buSuporteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure buOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FNomeUsuario: String;

    { Private declarations }
  public
    { Public declarations }
    lslSobre: TVersionInfo;

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
   lslSobre := TVersionInfo.create();

   laNome_Produto.Caption := lslSobre.ProductName;
   laCopyright.Caption := lslSobre.CompanyName+#13#10+lslSobre.LegalCopyright;
   laVersao.Caption := 'Versão '+lslSobre.ProductVersion;
      LsVersao := '';

   LtffPreRelease := vsPreRelease;
   if lslsobre.FileFlags = [LtffPreRelease] then
      laDescricao.Caption := 'Beta '+lslSobre.FileVersion.AsString+LsVersao+#13#10+lslSobre.FileDescription
   else
      laDescricao.Caption := lslSobre.FileVersion.AsString+LsVersao+#13#10+lslSobre.FileDescription;
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


end.

 
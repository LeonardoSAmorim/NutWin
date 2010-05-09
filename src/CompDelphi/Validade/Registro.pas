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




unit Registro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, registry, dbtables, lslAboutBoxDialog,
  RegEdit, RegConst2, Person, PersonaDialog, VersionInfo;
type
  TfmRegistro = class(TForm)

    laNome_Produto: TLabel;
    laCopyright: TLabel;
    laUsuario: TLabel;
    laVersao: TLabel;
    beLinha: TBevel;
    laTitulo_Usuario: TLabel;
    laNome_Usuario: TLabel;
    imCliWin: TImage;
    laDescricao: TLabel;
    buSuporte: TButton;
    meDireitos_Legais: TMemo;
    paUsuario: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edNome: TEdit;
    edEmpresa: TEdit;
    edSerie: TEdit;
    buRegistrar: TButton;
    buCancelar: TButton;
    odPersona: TOpenDialog;
    procedure buRegistrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure buCancelarClick(Sender: TObject);
    procedure buSuporteClick(Sender: TObject);
  private
    { Private declarations }
    FtrReg:TRegistry;
    Function Testa_NS2(LsSerial,LsSistema: String): Integer;
  public
    lslSobre : TVersionInfo;
    PsSistema:String;
    PsVersao:String;
    PsSession:String;
    PsDataBase:String;
    PsTabela:String;
    {Parametros de saída}
    PfRegistrou:Boolean;
  end;

var
  fmRegistro: TfmRegistro;
  Function Testa_NS(LsSerial,LsSistema,LsVersao: String): Integer;
  Function AtualizaTabelaValidade(LsSerie:String):Boolean;
implementation

{$R *.DFM}

Function AtualizaTabelaValidade(LsSerie:String):Boolean;
var
   ta_Ultimo: TTable;
begin
  Result:=false;
  try
    ta_Ultimo := TTable.Create(nil);
    with ta_ultimo do
    begin
      DataBaseName := 'dbVal';
      tableName := 'Validade';
      active := true;
      //Gravando
      edit;
      fieldByName('Desenvolvimento').AsString:= 'F';
      fieldByName('Versao_Avaliacao').AsString:= 'F';
      fieldByName('Data_Instalacao').AsString:='';
      fieldByName('Data_Ultimo_Acesso').AsString:='';
      fieldByName('Retrocesso').AsString:= 'F';
      fieldByName('Contador').AsInteger:=0;
      fieldByName('Validade').AsInteger:=0;
      fieldByName('Serial').AsString:=LsSerie;
      post;
      Result:=true;
    end;
    ta_Ultimo.free;
  except
   On e:Exception do
   begin
     MessageDlg(e.message,mtError,[mbOk],0);
   end;
 end;
end;

Function TfmRegistro.Testa_NS2(LsSerial,LsSistema: String): Integer;
var
   LsVersao : String;
begin
    LsVersao := FormatFloat( '00', fmRegistro.lslSobre.FileVersion.Major );
    Result := Testa_NS(LsSerial,LsSistema,LsVersao);
end;

Function Testa_NS(LsSerial,LsSistema,LsVersao: String): Integer;
{ Resultados da Função
  0 - OK
  1 - No. Série tamanho inválido
  2 - NS de outro sistema
  3 - NS de outra versão
  4 - NS fora da faixa válida (<0 ou > 9999)
  5 - NS Inválido
  6 - NS de Avaliação
}
var
   LiCont, LiNum, LiInc2, LiInc3, LiInc5, LiNumant : Integer;
   Li64Prod : Int64;
   LsSerialOrig, LsSerialEncr, LsSerialResu : String;
begin
   if Length(LsSerial) <> 16 then
   begin
      Result := 1;
      Exit;
   end;
   LsSerialEncr := '';
   LiCont := 1;
   while LiCont <= Length(LsSerial)-1 do
   begin
      LsSerialEncr := LsSerialEncr+LsSerial[LiCont];
      LiCont := LiCont+2;
   end;
   LsSerialOrig := '';
   LiCont := 2;
   while LiCont <= Length(LsSerial) do
   begin
      LsSerialOrig := LsSerialOrig+LsSerial[LiCont];
      LiCont := LiCont+2;
   end;
   if Copy(LsSerialOrig,1,2) <> LsSistema then
   begin
      Result := 2;
      Exit;
   end;
   if Copy(LsSerialOrig,3,2) <> LsVersao then
   begin
      Result := 3;
      Exit;
   end;
   if (Copy(LsSerialOrig,5,4) < '0000') or (Copy(LsSerialOrig,5,4) >'9999') then
   begin
      Result := 4;
      Exit;
   end;
   if (Copy(LsSerialOrig,5,4) = '0000') then
   begin
      Result := 6;
      Exit;
   end;
   Li64Prod := 1;
   for LiCont := 1 to Length(LsSerialOrig) do
      Li64Prod := Li64Prod*Ord(LsSerialOrig[LiCont]);
   LiInc2 := 2;
   LiInc3 := 3;
   LiInc5 := 5;
   LsSerialResu := '';
   for LiCont := 1 to Length(LsSerialOrig) do
   begin
      LiNum := 256-LiCont-Ord(LsSerialOrig[LiCont]);
      LiNumant := LiNum;
      while (chr(LiNum) < '0') or ((chr(LiNum) > '9') and (chr(LiNum) < 'A')) or (chr(LiNum) > 'Z') do
      begin
         if chr(LiNum) < '0' then
            LiInc2 := LiInc2+1;
         if (chr(LiNum) > '9') and (chr(LiNum) < 'A') then
            LiInc3 := LiInc3+1;
         if chr(LiNum) > 'Z' then
            LiInc5 := LiInc5+1;
         LiNum := LiNum-(Li64Prod Mod (LiInc2*LiInc3*LiInc5));
         if LiNum < 0 then
            LiNum := LiNum*-1;
         if LiNum = LiNumant then
            LiNum := LiNum-1;
      end;
      while LiNum > 255 do
         LiNum := LiNum-256;
      LsSerialResu := LsSerialResu+Chr(LiNum);
   end;
   if LsSerialEncr <> LsSerialResu then
      Result := 5
   else
      Result := 0;
end;

procedure TfmRegistro.buRegistrarClick(Sender: TObject);
Var
  LiResult:Integer;
  Persona : TStringList;
  FName, Valor : String;
  PersonaDlgDir : TfmDialogPersonaDir;
  FalhouSeExistir : Boolean;
begin
  FalhouSeExistir := False; 
  LiResult:=Testa_NS2(edSerie.text,PsSistema);
  if LiResult=0 then
  begin
    // Personalização
    ShowMessage( 'Agora será solicitado o local onde se encontra o arquivo de Personalização.' );
    FName := PersonaFileName( edSerie.text );
    odPersona.FileName := FName;

    PersonaDlgDir := TfmDialogPersonaDir.Create(self);
    PersonaDlgDir.flArquivos.Mask := FName + '.cfg';
    PersonaDlgDir.ShowModal;
    if PersonaDlgDir.ModalResult = mrOk then
    begin
       Persona := TStringList.Create;
       try
         if CarregaChaveString( CFGROOT, CFGPath, CFGPersonaFileName, Valor ) then
          begin
            if not FileExists( Valor+'\'+FName+'.cfg' ) and ( Valor <> PersonaDlgDir.dlDiretorios.Directory )then
               begin
                  //                  Persona.LoadFromFile( PersonaDlgDir.dlDiretorios.Directory + '\' + FName + '.cfg' );
                  if 0 = LoadPersona(PersonaDlgDir.dlDiretorios.Directory + '\' + FName + '.cfg', Persona, edSerie.text) then
                    begin
                    //                     Persona.SaveToFile( Valor+'\'+FName+'.cfg' )
                     if CopyFile( PChar(PersonaDlgDir.dlDiretorios.Directory + '\' + FName + '.cfg'), PChar(Valor+'\'+FName+'.cfg'), FalhouSeExistir) and (FalhouSeExistir) then
                       begin
                          ShowMessage( 'Falha durante cópia da personalização!' );
                          exit;
                       end;
                    end
                  else
                    begin
                     ShowMessage( 'Arquivo de Personalização inválido!' );
                     exit;
                    end;
               end
            else
               begin
                 ShowMessage( 'Já existe uma personalização gravada!' );
                 exit;
               end;
          end
         else
          begin
             ShowMessage( 'Não foi possível localizar diretório da personalização.' + #13+#10+
                          'Personalização não realizada!' );
             exit;
          end;
       finally
         Persona.Free;
         PersonaDlgDir.Free;
       end;
       //Gravando No. de série no registro do Windows
       FtrReg.writestring('name',ednome.text);
       FtrReg.writestring('company',edEmpresa.text);
       FtrReg.writestring('Serial',edSerie.text);
       //Atualizar tab Validade
       If AtualizaTabelaValidade(edSerie.text) then
          close;
       PfRegistrou:=True;
    end;
  end
//  Else if LiResult=1 then
//    MessageDlg('Número de série tamanho inválido',mtError,[mbOk],0)
  Else if LiResult=2 then
    MessageDlg('Números de séries de outros programas não são válidos',mtError,[mbOk],0)
  Else if LiResult=3 then
    MessageDlg('Números de séries de outras versões não são válidos',mtError,[mbOk],0)
  Else if LiResult=6 then
    MessageDlg('Número de série de avaliação do programa não é permitido',mtError,[mbOk],0)
  Else
    MessageDlg('Número de série inválido',mtError,[mbOk],0);
end;

procedure TfmRegistro.FormCreate(Sender: TObject);
var LsVersao : String;
    LtffPreRelease : TFileFlag;
begin
   lslSobre:= TVersionInfo.create();
   lslSobre.LegalCopyright  :=      'O programa de Apoio à Nutrição é  protegido  pela  lei'+
      'nº 7.646/87,  que dispõe sobre a proteção da proprie-'+
      'dade  intelectual de programas  de computador e  sua '+
      'comercialização no país.  A reprodução não  autoriza-'+
      'da  constituirá crime com pena prevista na lei.';

   PfRegistrou:=false;
   FtrReg := TRegistry.Create;
   FtrReg.RootKey := HKey_Local_Machine;
   FtrReg.OpenKey('\Software\DIS-EPM\NUTWIN',False);
   EdNome.text := FtrReg.ReadString('Name');
   EdEmpresa.text := FtrReg.ReadString('Company');
   laNome_Produto.Caption := lslSobre.ProductName;
   laCopyright.Caption := lslSobre.CompanyName+#13#10+lslSobre.LegalCopyright;
   laVersao.Caption := 'Versão '+lslSobre.ProductVersion;
   LtffPreRelease := vsPreRelease;
   if lslsobre.FileFlags = [LtffPreRelease] then
      laDescricao.Caption := 'Beta '+lslSobre.FileVersion.AsString+LsVersao+#13#10+lslSobre.FileDescription
   else
      laDescricao.Caption := lslSobre.FileVersion.AsString+LsVersao+#13#10+lslSobre.FileDescription;
end;

procedure TfmRegistro.FormDestroy(Sender: TObject);
begin
  FtrReg.Free;
end;

procedure TfmRegistro.buCancelarClick(Sender: TObject);
begin
  PfRegistrou:=false;
  close;
end;

procedure TfmRegistro.buSuporteClick(Sender: TObject);
begin
   MessageDlg('Universidade Federal de São Paulo - A/C Suporte'+chr(13)+chr(10)+
              'Departamento de Informática em Saúde'+chr(13)+chr(10)+
              'Rua Botucatu, 862 - Ed. José Leal Prado - Térreo'+chr(13)+chr(10)+
              'Vila Clementino'+chr(13)+chr(10)+
              'São Paulo - SP'+chr(13)+chr(10)+
              '04023-062'+chr(13)+chr(10)+chr(13)+chr(10)+
              'Tel.: (0xx11) 5574-5234 / 5576-4521'+chr(13)+chr(10)+
              'FAX: (0xx11) 5572-6601'+chr(13)+chr(10)+chr(13)+chr(10)+
              'Contato: Suporte'+chr(13)+chr(10)+
              'Web: http://www.unifesp.br'+chr(13)+chr(10)+
              'E-mail: nutricao@dis.epm.br'
              ,mtInformation,[mbOk],0);
end;

end.
     
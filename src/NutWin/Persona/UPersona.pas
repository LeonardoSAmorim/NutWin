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




unit UPersona;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RegEdit, RegConst2, ExtCtrls, Person, Crc2, PersonaDialog;

type

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    Button4: TButton;
    Edit6: TEdit;
    Edit7: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Edit9: TEdit;
    Label11: TLabel;
    Bevel1: TBevel;
    Edit8: TEdit;
    Button5: TButton;
    Label12: TLabel;
    rgTipo: TRadioGroup;
    Edit10: TEdit;
    Label8: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure rgTipoClick(Sender: TObject);
  private
    { Private declarations }
    Persona : TStringList;
  public
    { Public declarations }
    Silent : Boolean;
  end;

var
  Form1: TForm1;

implementation

uses qrepform, fmTestPersona;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
   Texto : String;
   i : Integer;
   FName, S : String;
   PersonaDlgDir : TfmDialogPersonaDir;
   UserNum : Integer;
begin
   S := Edit9.Text;
   UserNum := StrToInt( S[10] + S[12] + S[14] + S[16] );
   if ( UserNum > 0 ) and ( rgTipo.itemIndex = 0 ) then
      begin
          ShowMessage( 'Este número de série não pode ser de avaliação.');
          exit;
      end
   else if ( UserNum = 0 ) and ( rgTipo.itemIndex > 0 ) then
      begin
          ShowMessage( 'Este número de série só pode ser de avaliação.');
          exit;
      end;
   if Length(Trim( Edit1.Text + Edit2.Text + Edit3.Text + Edit4.Text + Edit5.Text )) < 30 then
      begin
          ShowMessage( 'O conteúdo das linhas de cabeçalho e rodapé deve ter ao menos 30 caracteres.');
          exit;
      end;


   FName := PersonaFileName( Edit9.text );
   PersonaDlgDir := TfmDialogPersonaDir.Create(self);
  Try
   PersonaDlgDir.flArquivos.Mask := FName + '.cfg';
   if Silent then
   begin
      PersonaDlgDir.dlDiretorios.Directory := ParamStr(10);
      PersonaDlgDir.ModalResult := mrOk;
   end
   else
      PersonaDlgDir.ShowModal;
   if PersonaDlgDir.ModalResult = mrOk then
   begin
      if FileExists(PersonaDlgDir.dlDiretorios.Directory + '\' + FName + '.cfg') then
         if MessageDlg( 'A personalização ' + PersonaDlgDir.dlDiretorios.Directory + '\' + FName + '.cfg' + ' já existe, Deseja gravar mesmo assim?',
            mtConfirmation, [mbYes, mbNo], 0) = mrNo then
            exit;
      Persona.Clear;
      Persona.Add(Encrypt(Edit1.Text, SeedSerial(Edit9.Text), cyHexa));
      Persona.Add(Encrypt(Edit2.Text, SeedSerial(Edit9.Text), cyHexa));
      Persona.Add(Encrypt(Edit3.Text, SeedSerial(Edit9.Text), cyHexa));
      Persona.Add(Encrypt(Edit4.Text, SeedSerial(Edit9.Text), cyHexa));
      Persona.Add(Encrypt(Edit5.Text, SeedSerial(Edit9.Text), cyHexa));
      Persona.Add(Encrypt(Edit6.Text, SeedSerial(Edit9.Text), cyHexa));
      Persona.Add(Encrypt(Edit7.Text, SeedSerial(Edit9.Text), cyHexa));
      Persona.Add(Encrypt(Edit9.Text, SeedSerial(Edit9.Text), cyHexa));
      Persona.Add(Encrypt(Edit8.Text, SeedSerial(Edit9.Text), cyHexa));
      Persona.Add(Encrypt(Edit10.Text, SeedSerial(Edit9.Text), cyHexa));
      Texto := '';
      for i := 0 to Persona.Count - 1 do
          Texto := Texto + Persona.Strings[i];
      Persona.Add(IntToHex(GetCRC32ForStr(Texto),8));
      Persona.SaveToFile( PersonaDlgDir.dlDiretorios.Directory + '\' + FName + '.cfg' );
      Label12.Caption := Persona.Strings[9];
   end;
  finally
     PersonaDlgDir.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   Valor : String;
begin
   Persona := TStringList.Create;
   if CarregaChaveString( CFGROOT, CFGPath, CFGPersonaFileName, Valor ) then
      begin
         OpenDialog1.InitialDir := ExtractFilePath(Valor);
         SaveDialog1.InitialDir := ExtractFilePath(Valor);
      end;
      Button3Click(self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   Persona.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   i : Integer;
   FName : String;
   PersonaDlgDir : TfmDialogPersonaDir;
begin
   FName := PersonaFileName( Edit9.text );
   PersonaDlgDir := TfmDialogPersonaDir.Create(self);
  Try
   PersonaDlgDir.flArquivos.Mask := FName + '.cfg';
   PersonaDlgDir.ShowModal;
   if PersonaDlgDir.ModalResult = mrOk then
   begin
      i := LoadPersona(PersonaDlgDir.dlDiretorios.Directory + '\' + FName + '.cfg', Persona, Edit9.Text, True);
      case i of
         1 : ShowMessage( HD_INVALIDO );
         2 : ShowMessage( SERIAL_INVALIDO );
         3 : ShowMessage( ARQUIVO_DANIFICADO );
         else
             begin
                Edit1.Text := Persona.Strings[0];
                Edit2.Text := Persona.Strings[1];
                Edit3.Text := Persona.Strings[2];
                Edit4.Text := Persona.Strings[3];
                Edit5.Text := Persona.Strings[4];
                Edit6.Text := Persona.Strings[5];
                Edit9.Text := Persona.Strings[7];
                Edit8.Text := Persona.Strings[8];
                Edit10.Text := Persona.Strings[9];
                Label12.Caption := Persona.Strings[10];
                if Edit6.Text = 'T' then
                  begin
                     if StrToInt( Edit7.Text ) > 60 then
                      rgTipo.ItemIndex := 2  // Cedido
                     else
                      rgTipo.ItemIndex := 0; // Avaliação
                  end
                else
                   RgTipo.ItemIndex := 1; // Produção
             end;
             Edit7.Text := Persona.Strings[6];
      end;
   end;
  finally
     PersonaDlgDir.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   Edit1.Clear;
   Edit2.Clear;
   Edit3.Clear;
   Edit4.Clear;
   Edit5.Clear;
   Edit6.Text := 'T';
   Edit7.Text := '30';
   Edit10.Text := '1';
   Edit8.Text := 'NENHUMA';
   rgTipo.ItemIndex := 0;
   label12.Caption := '';
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   F : TfmTestePersona;
begin
   qrepform.Chave := Edit9.Text;
   F := TfmTestePersona.Create(self);
   F.Report.PreviewModal;
   F.Free;
end;


procedure TForm1.Button5Click(Sender: TObject);
var
   P : TStringList;
   i : Integer;
   Texto : String;
begin
   P := TStringList.Create;
   if OpenDialog1.Execute then
   begin
      P.LoadFromFile(OpenDialog1.FileName);
      Texto := '';
      for i := 0 to P.Count - 2 do
          Texto := Texto + P.Strings[i];
      label12.Caption := IntToHex(GetCRC32ForStr(Texto),8);
   end;
   P.Free
end;

procedure TForm1.rgTipoClick(Sender: TObject);
begin
   case rgTipo.ItemIndex of
        0 : begin
               Edit6.Text := 'T'; // Avaliaçao
               Edit7.Enabled := True;
               Edit7.Text := '30';
               Edit10.Text := '2';
            end;
        1 : begin
               Edit6.Text := 'F'; // Produção
               Edit7.Enabled := False;
               Edit7.Text := '0';
            end;
        2 : begin
               Edit6.Text := 'T'; // Cedido
               Edit7.Enabled := True;
               Edit7.Text := '180';
            end;
   end;
end;

end.

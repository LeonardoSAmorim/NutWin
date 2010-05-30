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




unit Validade;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, ExtCtrls, StdCtrls, DB, Registry, DBCtrls, Grids, DBGrids, RegEdit,
  RegConst2, Person, dmValidade, NutCnst, GIFImage;

const
   REGISTRO_VENCIDO    = 0;
   REGISTRO_DESENV     = 1;
   REGISTRO_AVALIACAO  = 2;
   REGISTRO_OK =  3;
   PERSONA_INEXISTENTE = 4;
   PERSONA_DANIFICADA = 5;

type
    TfmValidade = class(TForm)
    buOk: TButton;
    Label1: TLabel;
    Shape1: TShape;
    Image3: TImage;
    Image1: TImage;


    procedure buOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FsVersao: String;
  public
    { Public declarations }
    TipoValidade : Integer;
    FdmValida : TdmValida;
    DataBaseName : String;
    PfRegistrou : Boolean;
    function LicencasPermitidas( var MsgErro : String ): integer;
end;

var
   fmValidade: TfmValidade;

implementation

{$R *.DFM}



Procedure TfmValidade.buOkClick(Sender: TObject);
begin
            Exit;

end;

procedure TfmValidade.FormCreate(Sender: TObject);
var
  Valor, Valor2 : String;
  LvContador: Real;
  Persona : TStringList;
begin
label1.Caption := 'Ocorreu um erro na execuçãodo programa!'+chr(13)+chr(10)+ TEXTO_CONTATO;
   FdmValida := TdmValida.Create(self);
   FdmValida.DataBaseName := DataBaseName;
   TipoValidade := REGISTRO_OK;

   try

    // Aqui pode-se fazer a Conversão compactação e conexão ao Banco

    // Atualiza banco confome Persona.cfg só se banco for vazio e se persona existir
    Persona := TStringList.Create;
    Try
      if CarregaChaveString( CFGROOT, CFGPath, CFGPersonaFileName, Valor ) and
         /// // /CarregaChaveString( CFGROOT, CFGPath, CFGSerial, Valor2 ) and
         /// // /FileExists( Valor+'\'+PersonaFileName(Valor2)+'.cfg' ) then
         FileExists( Valor+'\'+PersonaFileName()+'.cfg' ) then
      begin
         /// // /if LoadPersona(Valor+'\'+PersonaFileName(Valor2)+'.cfg', Persona, Valor2) = 0 then
if          LoadPersona(Valor+'\'+PersonaFileName()+'.cfg', Persona, Valor2) = 0 then
         with FdmValida.taValidade do
         begin
            Active := True;
            if IsEmpty then
            begin
                Append;
                fieldByName('Desenvolvimento').AsString:= 'F';
                FieldByName( 'Versao_Avaliacao' ).AsString := Persona.Strings[5];
                fieldByName('Data_Instalacao').AsString:='';
                fieldByName('Data_Ultimo_Acesso').AsString:='';
                fieldByName('Retrocesso').AsString:= 'F';
                fieldByName('Contador').AsInteger:=0;
                FieldByName( 'Validade' ).AsString := Persona.Strings[6];
                fieldByName('Serial').AsString:='';
                fieldByName('Licencas').AsString := '1000000';//Persona.Strings[9];
                Post;
            end; // else manda vê pois já foi registrado
            Active := False;
         end
         else
            begin
               label1.Caption := 'Arquivo persona danificado!'+chr(13)+chr(10)+ TEXTO_CONTATO;
               buOk.Visible := False;

               TipoValidade := PERSONA_INEXISTENTE;
            end;
      end
      else
         begin
               label1.Caption := 'Arquivo persona não existe!'+chr(13)+chr(10)+ TEXTO_CONTATO;
             buOk.Visible := False;
            
            TipoValidade := PERSONA_DANIFICADA;
         end;
    finally
      Persona.Free;
    end;

    if ( TipoValidade <> PERSONA_INEXISTENTE ) and
       ( TipoValidade <> PERSONA_DANIFICADA ) then
    begin
      FdmValida.taValidade.Active := True;
      if FdmValida.taValidade.FieldByName('Desenvolvimento').AsString = 'T' then
      begin
//         edSenha.Text := '123890';
         TipoValidade := REGISTRO_DESENV;
      end;


    end;

   except on E:Exception do
     MessageDlg(E.Message,mtError,[mbOk],0);
   end;
end;

procedure TfmValidade.FormDestroy(Sender: TObject);
begin
   FdmValida.Free;
end;

function TfmValidade.LicencasPermitidas( var MsgErro : String ): integer;
var
  Valor, Valor2 : String;
  Persona : TStringList;
begin
    Result := 1000000;
end;

end.

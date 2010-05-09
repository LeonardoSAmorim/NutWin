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
  RegConst2, Person, Registro, dmValidade, NutCnst;

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
    buRegistro: TButton;
    Label1: TLabel;
    Function PegaRegistro:Boolean;
    Function VerificaRegistroDoNutWin:Boolean;
    procedure buOkClick(Sender: TObject);
    procedure buRegistroClick(Sender: TObject);
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

Function TfmValidade.PegaRegistro:Boolean;
begin
   Application.CreateForm(TfmRegistro, fmRegistro);
   fmRegistro.PsSistema := 'NU';
   fmRegistro.PsVersao := FormatFloat( '00', fmRegistro.lslSobre.FileVersion.Major );
   fmRegistro.ShowModal;
   Result := fmRegistro.PfRegistrou;
   PfRegistrou := fmRegistro.PfRegistrou;
   if Result then
      TipoValidade := REGISTRO_OK;
   fmRegistro.Free;
end;

Function TfmValidade.VerificaRegistroDoNutWin:Boolean;
Var
   LsSerieNaTabela: String;
   LsSerieNoRegistro: String;
   LtrReg: TRegistry;
begin
   Result := True;
   FdmValida.taValidade.Active := True;
   LsSerieNaTabela := FdmValida.taValidade.FieldByName('Serial').AsString;
   //Registro do windows
   LtrReg := TRegistry.Create;
   LtrReg.RootKey := HKey_Local_Machine;
   LtrReg.OpenKey(CFGPath,False);
   LsSerieNoRegistro := LtrReg.ReadString(CFGSerial);
   if (LsSerieNaTabela = '') and (LsSerieNoRegistro = '') then
      Result:=PegaRegistro
   else if (LsSerieNaTabela = '') and (LsSerieNoRegistro <> '') then
   begin
      if Testa_NS( LsSerieNoRegistro, 'NU', FsVersao )=0 then //OK
         AtualizaTabelaValidade( LsSerieNoRegistro )
      else
         Result := PegaRegistro;
   end
   else if ((LsSerieNaTabela <> '')and((LsSerieNoRegistro = '') or (LsSerieNaTabela<>LsSerieNoRegistro)))
        or((LsSerieNaTabela <> '')and(LsSerieNoRegistro <> '')) then
   begin
      if Testa_NS( LsSerieNaTabela, 'NU', FsVersao )<>0 then //Nao OK
      begin
         if Testa_NS( LsSerieNoRegistro, 'NU', FsVersao )<>0 then //Nao OK
            Result:=PegaRegistro
         else
            AtualizaTabelaValidade( LsSerieNoRegistro )
      end
      else
         LtrReg.writestring(CFGSerial,LsSerieNaTabela); //Gravar no registro do Windows
   end;
   LtrReg.Free;
end;

Procedure TfmValidade.buOkClick(Sender: TObject);
begin
   try
      //Confirmar Registro
      With FdmValida.taValidade do
      begin
        Active := True;
        if (FieldByName('Desenvolvimento').AsString = 'F') and
           (FieldByName('Versao_Avaliacao').AsString = 'F') then
        begin
          if not VerificaRegistroDoNutWin then
          begin
            Exit;
          end;
        end;
      end;
   except on E:Exception do
      MessageDlg(E.Message,mtError,[mbOk],0);
   end;
   Close;
end;

procedure TfmValidade.FormCreate(Sender: TObject);
var
  Valor, Valor2 : String;
  LvContador: Real;
  Persona : TStringList;
begin
   FdmValida := TdmValida.Create(self);
   FdmValida.DataBaseName := DataBaseName;
   TipoValidade := REGISTRO_VENCIDO;

   try

    // Aqui pode-se fazer a Conversão compactação e conexão ao Banco

    // Atualiza banco confome Persona.cfg só se banco for vazio e se persona existir
    Persona := TStringList.Create;
    Try
      if CarregaChaveString( CFGROOT, CFGPath, CFGPersonaFileName, Valor ) and
         CarregaChaveString( CFGROOT, CFGPath, CFGSerial, Valor2 ) and
         FileExists( Valor+'\'+PersonaFileName(Valor2)+'.cfg' ) then
      begin
         if LoadPersona(Valor+'\'+PersonaFileName(Valor2)+'.cfg', Persona, Valor2) = 0 then
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
                fieldByName('Licencas').AsString := Persona.Strings[9];
                Post;
            end; // else manda vê pois já foi registrado
            Active := False;
         end
         else
            begin
               label1.Caption := 'Arquivo persona danificado!'+chr(13)+chr(10)+ TEXTO_CONTATO;
               buOk.Visible := False;
               buRegistro.Visible := False;
               TipoValidade := PERSONA_INEXISTENTE;
            end;
      end
      else
         begin
               label1.Caption := 'Arquivo persona não existe!'+chr(13)+chr(10)+ TEXTO_CONTATO;
             buOk.Visible := False;
            buRegistro.Visible := False;
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
      if FdmValida.taValidade.FieldByName('Versao_Avaliacao').AsString = 'T' then
      begin
//         laVersao_Avaliacao.Visible := True;
         FdmValida.taValidade.Edit;
         if FdmValida.taValidade.FieldByName('Data_Instalacao').AsDateTime = 0 then
         begin
            FdmValida.taValidade.FieldByName('Data_Instalacao').AsDateTime := StrToDate(DateToStr(Now()));
            FdmValida.taValidade.FieldByName('Contador').AsInteger := 1;
         end
         else
            if StrToDate(DateToStr(Now())) <> StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Ultimo_Acesso').AsDateTime)) then
            begin
               LvContador := FdmValida.taValidade.FieldByName('Contador').AsInteger;
               if StrToDate(DateToStr(Now())) >= StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Instalacao').AsDateTime)) then
                  if (FdmValida.taValidade.FieldByName('Retrocesso').AsString = 'T') or (StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Ultimo_Acesso').AsDateTime)) > StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Instalacao').AsDateTime))) then
                  begin
                     if FdmValida.taValidade.FieldByName('Retrocesso').AsString = 'F' then
                        FdmValida.taValidade.FieldByName('Retrocesso').AsString := 'T';
                     if StrToDate(DateToStr(Now())) > StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Ultimo_Acesso').AsDateTime)) then
                        FdmValida.taValidade.FieldByName('Contador').AsVariant :=  LvContador + StrToDate(DateToStr(Now())) - StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Ultimo_Acesso').AsDateTime))
                     else
                        FdmValida.taValidade.FieldByName('Contador').AsVariant := LvContador + StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Ultimo_Acesso').AsDateTime)) - StrToDate(DateToStr(Now()));
                  end
                  else
                     FdmValida.taValidade.FieldByName('Contador').AsVariant := 1 + StrToDate(DateToStr(Now())) - StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Instalacao').AsDateTime))
               else
               begin
                  if StrToDate(DateToStr(Now())) > StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Ultimo_Acesso').AsDateTime)) then
                     FdmValida.taValidade.FieldByName('Contador').AsVariant :=  LvContador + StrToDate(DateToStr(Now())) - StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Ultimo_Acesso').AsDateTime))
                  else
                     FdmValida.taValidade.FieldByName('Contador').AsVariant := LvContador + StrToDate(DateToStr(FdmValida.taValidade.FieldByName('Data_Ultimo_Acesso').AsDateTime)) - StrToDate(DateToStr(Now()));
	          			FdmValida.taValidade.FieldByName('Retrocesso').AsString := 'T';
		  end;
            end;
	 FdmValida.taValidade.FieldByName('Data_Ultimo_Acesso').AsDateTime := StrToDate(DateToStr(Now()));
	 FdmValida.taValidade.Post;
         if FdmValida.taValidade.FieldByName('Contador').AsInteger <= FdmValida.taValidade.FieldByName('Validade').AsInteger then
         begin
            label1.Caption := 'Você está no '+IntToStr(FdmValida.taValidade.FieldByName('Contador').AsInteger)+'º dia de um total de '+IntToStr(FdmValida.taValidade.FieldByName('Validade').AsInteger)+chr(13)+chr(10)+'para a avaliação do software.'+chr(13)+chr(10)+ TEXTO_CONTATO;
            TipoValidade := REGISTRO_AVALIACAO;
         end
         else
         begin
            label1.Caption := 'Expirou o período de avaliação!'+chr(13)+chr(10)+ TEXTO_CONTATO;
            buOk.Visible := False;
            buRegistro.Visible := True;
            TipoValidade := REGISTRO_VENCIDO;
         end;
//^^          FdmValida.taValidade.Active := False;
      end
      else
      begin
         TipoValidade := REGISTRO_OK;
      end;
    end;
   except on E:Exception do
     MessageDlg(E.Message,mtError,[mbOk],0);
   end;
end;

procedure TfmValidade.buRegistroClick(Sender: TObject);
begin
  if PegaRegistro then
  begin
    Close;
    buOk.Visible := True;
    buRegistro.Visible := False;
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
    Result := -1;
    // Atualiza banco confome Persona.cfg só se banco for vazio e se persona existir
    Persona := TStringList.Create;
    Try
      if CarregaChaveString( CFGROOT, CFGPath, CFGPersonaFileName, Valor ) and
         CarregaChaveString( CFGROOT, CFGPath, CFGSerial, Valor2 ) and
         FileExists( Valor+'\'+PersonaFileName(Valor2)+'.cfg' ) then
      begin
         if LoadPersona(Valor+'\'+PersonaFileName(Valor2)+'.cfg', Persona, Valor2) = 0 then
         begin
            Result := StrToInt(Persona.Strings[9]);
         end
         else
            begin
               MsgErro := 'Arquivo persona danificado!'+chr(13)+chr(10)+ TEXTO_CONTATO;
            end;
      end
      else
         begin
            MsgErro := 'Arquivo persona não existe!'+chr(13)+chr(10)+ TEXTO_CONTATO;
            TipoValidade := PERSONA_DANIFICADA;
         end;
    finally
      Persona.Free;
    end;
end;

end.

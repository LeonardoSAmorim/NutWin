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




unit qrepform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, NutCnst,
  ExtCtrls, QuickRpt, Qrctrls, jpeg, RegConst2, RegEdit, RxGIF, DelayedOpIndicator, Person, RelConfig;


const

   ALERTA =  'VERSÃO NÃO PERSONALIZADA!'; // #86+#69+#82#+#83+#65+#79+#32+#78+#65+#79+#32+#65+#85+#84+#79+#82+#73+#90+#65+#68+#65;

type


  TFormReport = class(TForm)
    Report: TQuickRep;
    qbTitulo: TQRBand;
    qiLogo: TQRImage;
    qtCabecalho: TQRRichText;
    qbRodape: TQRBand;
    qtRodape: TQRRichText;
    qsLinhaRodape: TQRShape;
    qyPagina: TQRSysData;
    qlTituloSistema: TQRLabel;
    qcSubTitulo: TQRBand;
    qrsTitulo: TQRSysData;
    procedure FormCreate(Sender: TObject);
    procedure ReportEndPage(Sender: TCustomQuickRep);
    procedure ReportStartPage(Sender: TCustomQuickRep);
  private
    FDelayedOpIndicator: TDelayedOpIndicator;
    FConfigPath: String;
    FNovaPagina: Boolean;
    { Private declarations }
    procedure SetDelayedOpIndicator(const Value: TDelayedOpIndicator);
    procedure SetConfigPath(const Value: String);
    procedure SetNovaPagina(const Value: Boolean);
    procedure SetCabecalho;
  protected
    property ConfigPath : String read FConfigPath write SetConfigPath;
  public
    { Public declarations }
    property NovaPagina : Boolean read FNovaPagina write SetNovaPagina;
    property DelayedOpIndicator : TDelayedOpIndicator read FDelayedOpIndicator write SetDelayedOpIndicator;
    function GetIDReport : String; virtual;
    procedure SetRelConfig( const Value : TRelatorio ); virtual;
  end;

var
    Chave : String;

implementation



{$R *.DFM}

procedure TFormReport.FormCreate(Sender: TObject);
var
   Valor: String;
   Persona : TStringList;

   i : Integer;
   Linha : Integer;
   Texto : String;
begin

   i := 0;


 Persona := TStringList.Create;

 try
   // Forma de pegar uma chave que não seja do registro do windows

   if CarregaChaveString( CFGROOT, CFGPath, CFGPersonaFileName, Valor ) and

      FileExists(Valor+'\'+PersonaFileName()+'.cfg') then
     begin
       LoadPersona(Valor+'\'+PersonaFileName()+'.cfg', Persona, '', False);
     end;
 finally

         if CarregaChaveString( CFGROOT, CFGPath, CFGLogoFileName, Valor ) and
            FileExists(Valor+'\'+PersonaFileName()+'.bmp') then
            begin
               qiLogo.Picture.LoadFromFile( Valor+'\'+PersonaFileName()+'.bmp' );
               if ( LowerCase(PersonaFileName()) <> 'persona')  then
                  SetCabecalho;
            end
         else
            qiLogo.Enabled := False;


   // Pega o mesmo da personalização
   if CarregaChaveString( CFGROOT, CFGPath, CFGPersonaFileName, Valor ) then
      FConfigPath := Valor
   else
      FConfigPath := '';

   // seta as constantes para os relatórios
   with TConstantes( GetConstantes ) do
   begin
      if (CabecLinha >= 1) and (CabecLinha<=3) and (Length(Trim(CabecTexto)) > 0) then
         Persona.Strings[CabecLinha-1] := CabecTexto;
   end;

   qtCabecalho.Lines.Clear;
   qtCabecalho.Lines.Add(Persona.Strings[0]);
   qtCabecalho.Lines.Add(Persona.Strings[1]);
   qtCabecalho.Lines.Add(Persona.Strings[2]);

   qtRodape.Lines.Clear;
   qtRodape.Lines.Add(Persona.Strings[3]);
   qtRodape.Lines.Add(Persona.Strings[4]);

   // Gambiarra porque estava comendo a última linha do rodapé na InkJet
   qtRodape.Top := qtRodape.Top - 17;
   qsLinhaRodape.Top := qsLinhaRodape.Top - 12;
   qcSubTitulo.Height := qcSubTitulo.Height - 26;
   qrsTitulo.Top := qrsTitulo.Top - 13;

   Persona.Free;
 end;

end;

procedure TFormReport.SetDelayedOpIndicator(
  const Value: TDelayedOpIndicator);
begin
  FDelayedOpIndicator := Value;
  if Value <> nil then
     Value.FreeNotification(Self);
end;

procedure TFormReport.ReportEndPage(Sender: TCustomQuickRep);
begin
  // finaliza indicação de operação demorada
  if Assigned( FDelayedOpIndicator ) then
     FDelayedOpIndicator.Finish;
end;

procedure TFormReport.ReportStartPage(Sender: TCustomQuickRep);
begin
  // indica operação demorada
  if Assigned( FDelayedOpIndicator ) then
     FDelayedOpIndicator.Start;
end;

function TFormReport.GetIDReport: String;
begin
   Result := '';
end;

procedure TFormReport.SetConfigPath(const Value: String);
begin
  FConfigPath := Value;
end;

procedure TFormReport.SetNovaPagina(const Value: Boolean);
begin
  FNovaPagina := Value;
end;

// Fica vazio
procedure TFormReport.SetRelConfig(const Value: TRelatorio);
begin
end;

procedure TFormReport.SetCabecalho;
var
   Dif : Integer;
begin
   // Seta atributos para pegar dimenções do BitMap
   qiLogo.Stretch := False;
   qiLogo.Center := False;
   qiLogo.AutoSize := True;
   // O logo não pode passar da altura da banda cabecalho e
   // nem de 1/3 da largura da banda, se acontecer, reduzir o tamanho
   // com stretch para estes limites
   if ((qiLogo.Height+qiLogo.Top) > qbTitulo.Height) or
      ((qiLogo.Width+qiLogo.Left) > (qbTitulo.Width div 3)) then
   begin
      qiLogo.AutoSize := False;
      qiLogo.Stretch := True;
      qiLogo.Height := qbTitulo.Height-qiLogo.Top;
      qiLogo.Width := (qbTitulo.Width div 3)-qiLogo.Left;
   end;
   // Calcula Diferença de largura
   Dif := qbTitulo.Width - (qiLogo.Width + qiLogo.Left);
   // Só altera dimensões do logo se o seu bitmap for maior que o tamanho default
   if (Dif > 0) and (qiLogo.Width > 64) then
   begin
      qtCabecalho.Left := (( Dif - qtCabecalho.Width ) div 2) + qiLogo.Left + qiLogo.Width;
      qiLogo.BringToFront;
   end
   else // volta atributos anteriores pois o tamanho é >= ao default
   begin
      qiLogo.Stretch := True;
      qiLogo.AutoSize := False;
   end;
end;

end.


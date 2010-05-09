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




unit InfoSistema;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, jpeg, MPlayer;

type
  TfmInfoSistema = class(TForm)
    paBottom: TPanel;
    paRight: TPanel;
    buFechar: TButton;
    buFoto: TButton;
    paClient: TPanel;
    paEquipe: TPanel;
    imEquipe: TImage;
    reCreditos: TRichEdit;
    procedure buFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure buFotoClick(Sender: TObject);
    procedure buFecharKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    pDis : String;
  public
    { Public declarations }
  end;

var
  fmInfoSistema: TfmInfoSistema;

implementation

{$R *.DFM}


procedure TfmInfoSistema.buFecharClick(Sender: TObject);
begin
   Close;
end;

procedure TfmInfoSistema.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if PDis = 'DIS-UNI' then
   begin
      PDis := 'DIS-UNIF';
      Action := caNone;
   end
   else
      Action := caFree;
end;

procedure TfmInfoSistema.buFotoClick(Sender: TObject);
begin
   if buFoto.Caption = 'Fo&to' then
   begin
      buFoto.Caption := '&Créditos';
    //  spEquipe.Visible := False;
      paEquipe.Visible := True;
      imEquipe.Visible := True;
   end
   else
   begin
      buFoto.Caption := 'Fo&to';
   //   spEquipe.Visible := True;
      paEquipe.Visible := False;
      imEquipe.Visible := False;
   end;
end;

procedure TfmInfoSistema.buFecharKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = 'D' then
   begin
      if PDis = '' then
         PDis := 'D'
      else
         PDis := '';
   end
   else if Key = 'I' then
   begin
      if PDis = 'D' then
         PDis := 'DI'
      else if PDis = 'DIS-UN' then
         PDis := 'DIS-UNI'
      else
         PDis := '';
   end
   else if Key = 'S' then
   begin
      if PDis = 'DI' then
         PDis := 'DIS'
      else if PDis = 'DIS-UNIFE' then
         PDis := 'DIS-UNIFES'
      else
         PDis := '';
   end
   else if Key = '-' then
   begin
      if PDis = 'DIS' then
         PDis := 'DIS-'
      else
         PDis := '';
   end
   else if Key = 'U' then
   begin
      if PDis = 'DIS-' then
         PDis := 'DIS-U'
      else
         PDis := '';
   end
   else if Key = 'N' then
   begin
      if PDis = 'DIS-U' then
         PDis := 'DIS-UN'
      else
         PDis := '';
   end
   else if Key = 'E' then
   begin
      if PDis = 'DIS-UNIF' then
         PDis := 'DIS-UNIFE'
      else if PDis = 'DIS-UNIFESP/' then
         PDis := 'DIS-UNIFESP/E'
      else
         PDis := '';
   end
   else if Key = 'P' then
   begin
      if PDis = 'DIS-UNIFES' then
         PDis := 'DIS-UNIFESP'
      else if PDis = 'DIS-UNIFESP/E' then
         PDis := 'DIS-UNIFESP/EP'
      else
         PDis := '';
   end
   else if Key = '/' then
   begin
      if PDis = 'DIS-UNIFESP' then
         PDis := 'DIS-UNIFESP/'
      else
         PDis := '';
   end
   else if Key = 'M' then
   begin
      if PDis = 'DIS-UNIFESP/EP' then
         PDis := 'DIS-UNIFESP/EPM'
      else
         PDis := '';
   end
   else
      PDis := '';
   if Pdis = 'DIS-UNIFESP/EPM' then
   begin
      buFoto.Left := 248;
      buFoto.Visible := True;
   end;
end;

procedure TfmInfoSistema.FormCreate(Sender: TObject);
begin
    with reCreditos do
    begin
       lines.Clear;
       font.color := clBlack;
       lines.Add('Referência para citações bibliográficas:');
       lines.Add('ANÇÃO MS, CUPPARI L, DRAIBE SA, SIGULEM D.');

       SelAttributes.Style := [fsbold];
       lines.Add(' Programa de Apoio à Nutrição - NutWin ');

       SelAttributes.Style := [];

       lines.Add(' Versão 1.6. São Paulo: Departamento de Informática em Saúde - SPDM -');
       lines.Add(' Unifesp/EPM, 2009.');
       lines.Add(' ');
       lines.Add('Coordenação do Projeto: ');
       lines.Add('Prof. Dr. Meide Silva Anção');
       lines.Add(' ');
       lines.Add('Conhecimento: ');
       lines.Add('Profa. Dra. Lilian Cuppari ');
       lines.Add('Prof. Dr. Meide Silva Anção ');
       lines.Add('Profa. Dra. Silvia Eloisa Priore ');
       lines.Add('Profa. Dra. Sylvia do Carmo Franceschini ');
       lines.Add('');
       lines.Add('Equipe Técnica:');
       lines.Add('Ione Santos Lopes ');
       lines.Add('Pablo Jorge Madril ');
       lines.Add('Wagner Gomes Bastos ');
       lines.Add('Sergio de Azevedo Melo ');
       lines.Add('');
       lines.Add('Arte Gráfica: ');
       lines.Add('Keith Chen de Cristo ');
       lines.Add('Renata Pompeu Zanardi ');

    end;
end;

end.

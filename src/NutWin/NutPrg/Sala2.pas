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




unit Sala2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, MSala2, USalas, jpeg, Menus;

type

  TfmSala2 = class(TForm)
    imSala2: TImage;
    imJanelaAberta: TImage;
    imPortaAberta: TImage;
    imPrateleira: TImage;
    imGaveta1Aberta: TImage;
    imGaveta2Aberta: TImage;
    imGaveta3Aberta: TImage;
    imCalculadoraIluminada: TImage;
    imLupaIluminada: TImage;
    imCanetaIluminada: TImage;
    imPapeisIluminados: TImage;
    puTabelas: TPopupMenu;
    puIndiv: TMenuItem;
    puAlim: TMenuItem;
    puOpcoes: TPopupMenu;
    mnOpInd: TMenuItem;
    mnOpAlim: TMenuItem;
    mnOpSist: TMenuItem;
    puRelatorios: TPopupMenu;
    puRelIndiv: TMenuItem;
    puRelAlim: TMenuItem;
    puPesquisa: TPopupMenu;
    PesqAntrop1: TMenuItem;
    PesqInq: TMenuItem;
    puIndividuo: TPopupMenu;
    mnNovoInd: TMenuItem;
    mnLocIndiv: TMenuItem;
    puAlimento: TPopupMenu;
    mnNovoAli: TMenuItem;
    mnLocAli: TMenuItem;
    procedure imSala2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imPortaAbertaClick(Sender: TObject);
    procedure imJanelaAbertaClick(Sender: TObject);
    procedure imPrateleiraClick(Sender: TObject);
    procedure imGaveta1AbertaClick(Sender: TObject);
    procedure imGaveta2AbertaClick(Sender: TObject);
    procedure imGaveta3AbertaClick(Sender: TObject);
    procedure imCalculadoraIluminadaClick(Sender: TObject);
    procedure imLupaIluminadaClick(Sender: TObject);
    procedure imPapeisIluminadosClick(Sender: TObject);
    procedure imCanetaIluminadaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure puIndivClick(Sender: TObject);
    procedure puAlimClick(Sender: TObject);
    procedure mnOpIndClick(Sender: TObject);
    procedure mnOpAlimClick(Sender: TObject);
    procedure mnOpSistClick(Sender: TObject);
    procedure puRelIndivClick(Sender: TObject);
    procedure puRelAlimClick(Sender: TObject);
    procedure PesqAntrop1Click(Sender: TObject);
    procedure PesqInqClick(Sender: TObject);
    procedure mnNovoIndClick(Sender: TObject);
    procedure mnLocIndivClick(Sender: TObject);
    procedure mnNovoAliClick(Sender: TObject);
    procedure mnLocAliClick(Sender: TObject);
  private
    { Private declarations }
     FX, FY : Integer;
     FFormMascara : TfmMascSala2;
     ImagemCorrente : TImage;
     FOnClickObjetoSala : TObjetoSalaEvent;
  protected
    procedure ClickObjetoSala(ObjetoSala: TObjetoSala);
  public
    { Public declarations }
    property FormMascara : TfmMascSala2 read FFormMascara write FFormMascara;
    procedure Iluminar( Imagem : TImage );
    property OnClickObjetoSala : TObjetoSalaEvent read FOnClickObjetoSala write FOnClickObjetoSala;
  end;

var
  fmSala2: TfmSala2;

implementation

uses OpcSalas;

{$R *.DFM}

procedure TfmSala2.ClickObjetoSala(ObjetoSala: TObjetoSala);
begin
   if Assigned( FOnClickObjetoSala ) then
      FOnClickObjetoSala( self, ObjetoSala );
end;

procedure TfmSala2.Iluminar( Imagem : TImage );
begin
   If ( Imagem = nil ) and ( ImagemCorrente <> nil ) then
     begin
      ImagemCorrente.SendToBack;
     end
   else if ( ImagemCorrente <> nil ) then
     begin
      if ImagemCorrente.Name <> Imagem.Name then
         ImagemCorrente.SendToBack
      else
         Imagem.BringToFront;
     end;
   ImagemCorrente := Imagem;
end;

procedure TfmSala2.imSala2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FX := X;
  FY := Y;
  fmOpcSalas.Caption := 'X=' + IntToStr( X ) + ' Y=' + IntToStr( Y ) + ' Cor = ' + IntToStr( FFormMascara.imMascSala2.Canvas.Pixels[X, Y] );
  if TImage( Sender ).Name = 'imSala2' then
  begin
  if clPORTA = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imPortaAberta );
//      fmSala2.Caption := fmSala2.Caption + ' PORTA';
     end
   else if clFUNDO = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
     begin
      Iluminar( nil );
//      fmSala2.Caption := fmSala2.Caption + ' FUNDO';
     end
   else if clPRATELEIRA = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imPrateleira );
//      fmSala2.Caption := fmSala2.Caption + ' PRATELEIRA';
     end
   else if clJANELA = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imJanelaAberta );
//      fmSala2.Caption := fmSala2.Caption + ' JANELA';
     end
   else if clCALCULADORA = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imCalculadoraIluminada );
//      fmSala2.Caption := fmSala2.Caption + ' CALCULADORA';
     end
   else if clPAPEIS = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imPapeisIluminados );
//      fmSala2.Caption := fmSala2.Caption + ' PAPEIS';
     end
   else if clCANETA = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imCanetaIluminada );
//      fmSala2.Caption := fmSala2.Caption + ' CANETA';
     end
   else if clLUPA = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imLupaIluminada );
//      fmSala2.Caption := fmSala2.Caption + ' LUPA';
     end
   else if clGAVETA1 = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
      begin
         Iluminar( imGaveta1Aberta );
//         fmSala2.Caption := fmSala2.Caption + ' INDIVÍDUOS';
      end
   else if clGAVETA2 = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
      begin
         Iluminar( imGaveta2Aberta );
//         fmSala2.Caption := fmSala2.Caption + ' ALIMENTOS';
      end
   else if clGAVETA3 = FFormMascara.imMascSala2.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imGaveta3Aberta );
//      fmSala2.Caption := fmSala2.Caption + ' TABELAS';
     end
   else
      Iluminar( nil );
   end
end;

procedure TfmSala2.imPortaAbertaClick(Sender: TObject);
begin
   ClickObjetoSala( osPorta );
end;

procedure TfmSala2.imJanelaAbertaClick(Sender: TObject);
begin
   puPesquisa.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osJanela );
end;

procedure TfmSala2.imPrateleiraClick(Sender: TObject);
begin
   ClickObjetoSala( osPrateleira );
end;

procedure TfmSala2.imGaveta1AbertaClick(Sender: TObject);
begin
   puIndividuo.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osGaveta1 );
end;

procedure TfmSala2.imGaveta2AbertaClick(Sender: TObject);
begin
   puAlimento.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osGaveta2 );
end;

procedure TfmSala2.imGaveta3AbertaClick(Sender: TObject);
begin
   puTabelas.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osGaveta3 );
end;

procedure TfmSala2.imCalculadoraIluminadaClick(Sender: TObject);
begin
   ClickObjetoSala( osCalculadora );
end;

procedure TfmSala2.imLupaIluminadaClick(Sender: TObject);
begin
   ClickObjetoSala( osLupa );
end;

procedure TfmSala2.imPapeisIluminadosClick(Sender: TObject);
begin
   puRelatorios.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osPapeis );
end;

procedure TfmSala2.imCanetaIluminadaClick(Sender: TObject);
begin
   puOpcoes.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osCaneta );
end;

procedure TfmSala2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   FFormMascara.Free;
   Action := caFree;
end;

procedure TfmSala2.puIndivClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta3a );
end;

procedure TfmSala2.puAlimClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta3b );
end;

procedure TfmSala2.mnOpIndClick(Sender: TObject);
begin
  ClickObjetoSala( osCanetaOpInd );
end;

procedure TfmSala2.mnOpAlimClick(Sender: TObject);
begin
  ClickObjetoSala( osCanetaOpAlim );
end;

procedure TfmSala2.mnOpSistClick(Sender: TObject);
begin
  ClickObjetoSala( osCanetaOpSist );
end;
procedure TfmSala2.puRelIndivClick(Sender: TObject);
begin
  ClickObjetoSala( osPapeisInd ) ;
end;

procedure TfmSala2.puRelAlimClick(Sender: TObject);
begin
  ClickObjetoSala( osPapeisAlim ) ;
end;

procedure TfmSala2.PesqAntrop1Click(Sender: TObject);
begin
  ClickObjetoSala( osJanela1 ) ;
end;

procedure TfmSala2.PesqInqClick(Sender: TObject);
begin
  ClickObjetoSala( osJanela2 ) ;
end;

procedure TfmSala2.mnNovoIndClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta1a );
end;

procedure TfmSala2.mnLocIndivClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta1b );
end;

procedure TfmSala2.mnNovoAliClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta2a );
end;

procedure TfmSala2.mnLocAliClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta2b );
end;

end.

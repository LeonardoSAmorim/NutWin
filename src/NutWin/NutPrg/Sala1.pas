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




unit Sala1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, MSala1, USalas, Jpeg, Menus;

type

  TfmSala1 = class(TForm)
    imSala1: TImage;
    imGaveta1Aberta: TImage;
    imJanelaAberta: TImage;
    imPortaAberta: TImage;
    imPrateleira: TImage;
    imGaveta2Aberta: TImage;
    imGaveta3Aberta: TImage;
    imPapeisIluminados: TImage;
    imCanetaIluminada: TImage;
    imLupaIluminada: TImage;
    imCalculadoraIluminada: TImage;
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
    procedure imSala1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imPortaAbertaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imJanelaAbertaClick(Sender: TObject);
    procedure imPrateleiraClick(Sender: TObject);
    procedure imGaveta1AbertaClick(Sender: TObject);
    procedure imGaveta2AbertaClick(Sender: TObject);
    procedure imGaveta3AbertaClick(Sender: TObject);
    procedure imCalculadoraIluminadaClick(Sender: TObject);
    procedure imLupaIluminadaClick(Sender: TObject);
    procedure imCanetaIluminadaClick(Sender: TObject);
    procedure imPapeisIluminadosClick(Sender: TObject);
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
    FFormMascara : TfmMascSala1;
    ImagemCorrente : TImage;
    FOnClickObjetoSala : TObjetoSalaEvent;
  protected
    procedure ClickObjetoSala(ObjetoSala: TObjetoSala);
  public
    { Public declarations }
    property FormMascara : TfmMascSala1 read FFormMascara write FFormMascara;
    procedure Iluminar( Imagem : TImage );
    property OnClickObjetoSala : TObjetoSalaEvent read FOnClickObjetoSala write FOnClickObjetoSala;
  end;

var
  fmSala1: TfmSala1;

implementation

uses OpcSalas;

{$R *.DFM}

procedure TfmSala1.ClickObjetoSala(ObjetoSala: TObjetoSala);
begin
   if Assigned( FOnClickObjetoSala ) then
      FOnClickObjetoSala( self, ObjetoSala );
end;

procedure TfmSala1.Iluminar( Imagem : TImage );
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
        begin
         Imagem.BringToFront;
//         Imagem.Cursor := crHandPoint;
        end;
     end;
   ImagemCorrente := Imagem;
end;


procedure TfmSala1.imSala1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  FX := X;
  FY := Y;
  fmOpcSalas.Caption := 'X=' + IntToStr( X ) + ' Y=' + IntToStr( Y ) + ' Cor = ' + IntToStr( FFormMascara.imMascSala1.Canvas.Pixels[X, Y] );
  if TImage( Sender ).Name = 'imSala1' then
  begin
  if clPORTA = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imPortaAberta );
//      fmSala1.Caption := fmSala1.Caption + ' PORTA';
     end
   else if clFUNDO = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
     begin
      Iluminar( nil );
//      fmSala1.Caption := fmSala1.Caption + ' FUNDO';
     end
   else if clPRATELEIRA = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imPrateleira );
//      fmSala1.Caption := fmSala1.Caption + ' PRATELEIRA';
     end
   else if clJANELA = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imJanelaAberta );
//      fmSala1.Caption := fmSala1.Caption + ' JANELA';
     end
   else if clCALCULADORA = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imCalculadoraIluminada );
//      fmSala1.Caption := fmSala1.Caption + ' CALCULADORA';
     end
   else if clPAPEIS = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imPapeisIluminados );
//      fmSala1.Caption := fmSala1.Caption + ' PAPEIS';
     end
   else if clCANETA = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imCanetaIluminada );
//      fmSala1.Caption := fmSala1.Caption + ' CANETA';
     end
   else if clLUPA = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imLupaIluminada );
//      fmSala1.Caption := fmSala1.Caption + ' LUPA';
     end
   else if clGAVETA1 = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
      begin
         Iluminar( imGaveta1Aberta );
//         fmSala1.Caption := fmSala1.Caption + ' INDIVÍDUOS';
      end
   else if clGAVETA2 = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
      begin
         Iluminar( imGaveta2Aberta );
//         fmSala1.Caption := fmSala1.Caption + ' ALIMENTOS';
      end
   else if clGAVETA3 = FFormMascara.imMascSala1.Canvas.Pixels[X, Y] then
     begin
      Iluminar( imGaveta3Aberta );
//      fmSala1.Caption := fmSala1.Caption + ' TABELAS';
     end
   else
      Iluminar( nil );
   end
end;

procedure TfmSala1.imPortaAbertaClick(Sender: TObject);
begin
   ClickObjetoSala( osPorta );
end;

procedure TfmSala1.FormCreate(Sender: TObject);
begin
   Screen.Cursors[1] := LoadCursor(HInstance, 'c:\software\borland\delphi 3\images\cursors\handpnt.cur');
   imSala1.Cursor := 1;
end;

procedure TfmSala1.imJanelaAbertaClick(Sender: TObject);
begin
   puPesquisa.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osJanela );
end;

procedure TfmSala1.imPrateleiraClick(Sender: TObject);
begin
   ClickObjetoSala( osPrateleira );
end;

procedure TfmSala1.imGaveta1AbertaClick(Sender: TObject);
begin
   puIndividuo.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osGaveta1 );
end;

procedure TfmSala1.imGaveta2AbertaClick(Sender: TObject);
begin
   puAlimento.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osGaveta2 );
end;

procedure TfmSala1.imGaveta3AbertaClick(Sender: TObject);
begin
   puTabelas.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osGaveta3 );
end;

procedure TfmSala1.imCalculadoraIluminadaClick(Sender: TObject);
begin
   ClickObjetoSala( osCalculadora );
end;

procedure TfmSala1.imLupaIluminadaClick(Sender: TObject);
begin
   ClickObjetoSala( osLupa );
end;

procedure TfmSala1.imCanetaIluminadaClick(Sender: TObject);
begin
   puOpcoes.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osCaneta );
end;

procedure TfmSala1.imPapeisIluminadosClick(Sender: TObject);
begin
   puRelatorios.Popup(Application.MainForm.Left+TForm(Owner).Left+FX,Application.MainForm.top+TForm(Owner).Top+FY);
//   ClickObjetoSala( osPapeisInd );
end;

procedure TfmSala1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    FFormMascara.Free;
    Action := caFree;
end;

procedure TfmSala1.puIndivClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta3a );
end;

procedure TfmSala1.puAlimClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta3b );
end;

procedure TfmSala1.mnOpIndClick(Sender: TObject);
begin
  ClickObjetoSala( osCanetaOpInd );
end;

procedure TfmSala1.mnOpAlimClick(Sender: TObject);
begin
  ClickObjetoSala( osCanetaOpAlim );
end;

procedure TfmSala1.mnOpSistClick(Sender: TObject);
begin
  ClickObjetoSala( osCanetaOpSist );
end;

procedure TfmSala1.puRelIndivClick(Sender: TObject);
begin
  ClickObjetoSala( osPapeisInd ) ;
end;

procedure TfmSala1.puRelAlimClick(Sender: TObject);
begin
  ClickObjetoSala( osPapeisAlim ) ;
end;

procedure TfmSala1.PesqAntrop1Click(Sender: TObject);
begin
  ClickObjetoSala( osJanela1 );
end;

procedure TfmSala1.PesqInqClick(Sender: TObject);
begin
  ClickObjetoSala( osJanela2 );
end;

procedure TfmSala1.mnNovoIndClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta1a );
end;

procedure TfmSala1.mnLocIndivClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta1b );
end;

procedure TfmSala1.mnNovoAliClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta2a );
end;

procedure TfmSala1.mnLocAliClick(Sender: TObject);
begin
   ClickObjetoSala( osGaveta2b );
end;

end.

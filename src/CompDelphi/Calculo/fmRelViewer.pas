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




unit fmRelViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  QRPrntr, QuickRpt, Buttons, ComCtrls, Menus, ExtCtrls, Measurement, DelayedOpIndicator,
  StdCtrls;

type
  TRelViewer = class(TForm)
    QRPreview: TQRPreview;
    psPreviewButtons: TPageScroller;
    p_ImpPreview: TPrinterSetupDialog;
    puGoTo: TPopupMenu;
    Medidas1: TMenuItem;
    Resultados1: TMenuItem;
    Cabealho1: TMenuItem;
    Rodap1: TMenuItem;
    Identificao1: TMenuItem;
    paBotoes: TPanel;
    btnZoomIn: TSpeedButton;
    btnZoomOut: TSpeedButton;
    btnZoomToFit: TSpeedButton;
    btnPrint: TSpeedButton;
    btGoTo: TSpeedButton;
    btnNextPage: TSpeedButton;
    btnPrevPage: TSpeedButton;
    btnLastPage: TSpeedButton;
    btnPriorPage: TSpeedButton;
    paProgresso: TPanel;
    pbProgresso: TProgressBar;
    laProgresso: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnPrevPageClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure QRPreviewPageAvailable(Sender: TObject; PageNum: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btnLastPageClick(Sender: TObject);
    procedure btnPriorPageClick(Sender: TObject);
    procedure btnZoomToFitClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btGoToClick(Sender: TObject);
    procedure Indivduo1Click(Sender: TObject);
    procedure Medidas1Click(Sender: TObject);
    procedure Resultados1Click(Sender: TObject);
    procedure Cabealho1Click(Sender: TObject);
    procedure Rodap1Click(Sender: TObject);
    procedure QRPreviewProgressUpdate(Sender: TObject; Progress: Integer);
  private
    { Private declarations }
    FQRPrinter : TQRPrinter;
    FShowButtons: Boolean;
    FDelayedOpIndicator: TDelayedOpIndicator;
    procedure Init;
    procedure UpdateButtons;
    procedure SetShowButtons(const Value: Boolean);
    procedure SetDelayedOpIndicator(const Value: TDelayedOpIndicator);
  public
    { Public declarations }
    bPleaseInit : Boolean;
    bCanPrint: boolean;
    sTitle : string;
    constructor CreatePreview(AOwner : TComponent; aQRPrinter : TQRPrinter);
    property QRPrinter : TQRPrinter read FQRPrinter write FQRPrinter;
    property ShowButtons : Boolean read FShowButtons write SetShowButtons;
    // indicador de operação demorada
    property DelayedOpIndicator : TDelayedOpIndicator read FDelayedOpIndicator write SetDelayedOpIndicator;
  end;


implementation

//+ uses DMMBoard;

{$R *.DFM}

constructor TRelViewer.CreatePreview(AOwner : TComponent; aQRPrinter : TQRPrinter);
begin

  inherited Create(AOwner);
  QRPrinter := aQRPrinter;
  QRPreview.QRPrinter := aQRPrinter;
  if (QRPrinter <> nil) and (QRPrinter.Title <> '') then Application.Hint := QRPrinter.Title;
end;

procedure TRelViewer.UpdateButtons;
begin
  with QRPreview do
  begin
    btnPrevPage.Enabled := PageNumber > 1;
    btnNextPage.Enabled := PageNumber < QRPreview.QRPrinter.PageCount;
    btnLastPage.Enabled := PageNumber < QRPreview.QRPrinter.PageCount;
    btnPriorPage.Enabled := PageNumber > 1;
  end;
end;

procedure TRelViewer.Init;
//var
//  OffSet: integer;
begin
  if bPleaseInit then
  begin
    { Force the preview to come up in the zoom setting that we want}
    QRPreview.Zoom := 70;

//    FShowButtons := True;

    { If the caller reports want to disable printing, then it will set}
    { the following boolean to false }
    if not bCanPrint then
      btnPrint.Enabled := bCanPrint;
    UpdateButtons;

    bPleaseInit := False;
  end;
end;

procedure TRelViewer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Release;
   Action:=caFree;
end;

procedure TRelViewer.btnZoomInClick(Sender: TObject);
begin
  QRPreview.VertScrollBar.Position := 0;
  QRPreview.HorzScrollBar.Position := 0;
  Application.ProcessMessages;
  with QRPreview do
    Zoom := Zoom + 10;
end;

procedure TRelViewer.btnZoomOutClick(Sender: TObject);
begin
  QRPreview.VertScrollBar.Position := 0;
  QRPreview.HorzScrollBar.Position := 0;
  Application.ProcessMessages;
  with QRPreview do
    if Zoom > 10 then
      Zoom := Zoom - 10;
end;

procedure TRelViewer.btnPrevPageClick(Sender: TObject);
begin
  Application.ProcessMessages;
  with QRPreview do
    if PageNumber > 1 then
      PageNumber := PageNumber - 1;
  UpdateButtons;
end;

procedure TRelViewer.btnNextPageClick(Sender: TObject);
begin
  Application.ProcessMessages;
  with QRPreview do
    if PageNumber < QRPreview.QRPrinter.PageCount then
      PageNumber := PageNumber + 1;
  UpdateButtons;
end;

procedure TRelViewer.FormShow(Sender: TObject);
begin
  { Signal ourselves that we need to update the form }
  bPleaseInit := True;
  QRPreview.Zoom := 70;

end;

procedure TRelViewer.QRPreviewPageAvailable(Sender: TObject;
  PageNum: Integer);
begin
  Init;
  with Application do
  begin
  if PageNum = 1 then
    Hint := QRPreview.QRPrinter.Title + ' - 1 página'
  else
    Hint := QRPreview.QRPrinter.Title + ' - ' + IntToStr(PageNum) + ' páginas';

  case QRPreview.QRPrinter.Status of
    mpReady: Hint := Hint + ' Pronto';
    mpBusy: Hint := Hint + ' Ocupado';
    mpFinished: Hint := Hint + ' Concluido';
  end;
  end;
  UpdateButtons;
end;

procedure TRelViewer.FormCreate(Sender: TObject);
begin
  { We can disable functionality at runtime }
  bCanPrint := True;
end;

procedure TRelViewer.btnLastPageClick(Sender: TObject);
begin
   Application.ProcessMessages;
   QRPreview.PageNumber := QRPreview.QRPrinter.PageCount;
   UpdateButtons;
end;

procedure TRelViewer.btnPriorPageClick(Sender: TObject);
begin
   Application.ProcessMessages;
   QRPreview.PageNumber := 1;
   UpdateButtons;
end;

procedure TRelViewer.btnZoomToFitClick(Sender: TObject);
begin
   QRPreview.VertScrollBar.Position := 0;
   QRPreview.HorzScrollBar.Position := 0;
   Application.ProcessMessages;
   QRPreview.Zoom := 70;
end;

procedure TRelViewer.btnPrintClick(Sender: TObject);
begin
   Application.ProcessMessages;
   if p_ImpPreview.Execute then
      QRPreview.QRPrinter.Print;
end;

procedure TRelViewer.btGoToClick(Sender: TObject);
begin
   puGoTo.Popup(btGoto.ClientOrigin.X,btGoto.ClientOrigin.Y);
end;

procedure TRelViewer.Indivduo1Click(Sender: TObject);
begin
   QRPreview.PageNumber := 1;
   QRPreview.VertScrollBar.Position := 100;
end;

procedure TRelViewer.Medidas1Click(Sender: TObject);
begin
   QRPreview.PageNumber := 1;
   QRPreview.VertScrollBar.Position := 200;

end;

procedure TRelViewer.Resultados1Click(Sender: TObject);
begin
   QRPreview.PageNumber := 1;
   QRPreview.VertScrollBar.Position := 300;
end;

procedure TRelViewer.Cabealho1Click(Sender: TObject);
begin
   QRPreview.VertScrollBar.Position := 0;
end;

procedure TRelViewer.Rodap1Click(Sender: TObject);
begin
   QRPreview.VertScrollBar.Position := QRPreview.VertScrollBar.Range;
end;

procedure TRelViewer.SetShowButtons(const Value: Boolean);
begin
  FShowButtons := Value;
  paBotoes.Visible := FShowButtons;
end;

procedure TRelViewer.SetDelayedOpIndicator(
  const Value: TDelayedOpIndicator);
begin
  FDelayedOpIndicator := Value;
  if Value <> nil then
     Value.FreeNotification(Self);
end;

procedure TRelViewer.QRPreviewProgressUpdate(Sender: TObject;
  Progress: Integer);
begin
     // Mostra barra de progresso (só quando é banco de dados)
     pbProgresso.Position := Progress;
     if Progress = 100 then
        paProgresso.Visible := False
     else if not paProgresso.Visible then
        paProgresso.Visible := True;
end;

end.

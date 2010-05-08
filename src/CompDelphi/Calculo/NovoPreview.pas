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





unit NovoPreview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,qrprntr,quickrpt, Buttons, ComCtrls;

type
  // We need the ParentReport property from TQRCompositeWinControl.  As of
  // the 3.0.4 release, this property is protected.  We create a descendant
  // class and that will give us access to the property
  TQRPatch = class(TQRCompositeWinControl)
  end;

  TfmNovoPreview = class(TForm)
    QRPreview1: TQRPreview;
    StatusBar: TStatusBar;
    ProgressBar: TProgressBar;
    psPreviewButtons: TPageScroller;
    btnSave: TBitBtn;
    btnPrint: TBitBtn;
    btnNextPage: TBitBtn;
    btnPrevPage: TBitBtn;
    btnZoomIn: TBitBtn;
    btnZoomOut: TBitBtn;
    btnClose: TBitBtn;
    btnOpen: TBitBtn;
    paBotoes: TPanel;
    laPagTotal: TLabel;
    procedure btnPrintClick(Sender: TObject);
    procedure btnPrevPageClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure QRPreview1PageAvailable(Sender: TObject; PageNum: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSaveClick(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure QRPreview1ProgressUpdate(Sender: TObject; Progress: Integer);
  private
    { Private declarations }
    FQRPrinter : TQRPrinter;
    procedure Init;
    procedure UpdateButtons;
//    procedure SetMyWindow;
  public
    { Public declarations }
    pQuickreport : TQuickRep;
    bPleaseInit : Boolean;
    bCanPrint: boolean;
    sStatus,
    sTitle : string;
    constructor CreatePreview(AOwner : TComponent; aQRPrinter : TQRPrinter);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property QRPrinter : TQRPrinter read FQRPrinter write FQRPrinter;
  end;

var
  fmNovoPreview: TfmNovoPreview;
  PrintPreviewImage,
  CanPrint: boolean;

implementation

uses qrselect;

{$R *.DFM}

constructor TfmNovoPreview.CreatePreview(AOwner : TComponent; aQRPrinter : TQRPrinter);
begin
  inherited Create(AOwner);
  QRPrinter := aQRPrinter;
  // Connect the preview component to the report's qrprinter object
  QRPreview1.QRPrinter := aQRPrinter;
  if (QRPrinter <> nil) and (QRPrinter.Title <> '') then
    Caption := QRPrinter.Title;
end;

procedure TfmNovoPreview.UpdateButtons;
begin
  with QRPreview1 do
  begin
    btnPrevPage.Enabled := PageNumber > 1;
    btnNextPage.Enabled := PageNumber < QRPreview1.QRPrinter.PageCount;
  end;
  StatusBar.Panels[0].Text := sStatus;
//  StatusBar.Panels[1].Text := 'Página ' + IntToStr(QRPreview1.PageNumber) + ' de ' +
//    IntToStr(QRPreview1.QRPrinter.PageCount);
    laPagTotal.Caption := 'Página ' + IntToStr(QRPreview1.PageNumber) + ' de ' +
    IntToStr(QRPreview1.QRPrinter.PageCount);
end;

procedure TfmNovoPreview.btnPrintClick(Sender: TObject);
begin
  // The Master property of the QRPrinter object is the
  // report (unless it's a composite report).

  // If you set the QRPrinter->Master property to NULL, the report will
  // not render the report again when you print, it will just copy the
  // metafiles used by the preview to the printer.
  if PrintPreviewImage then
    QRPreview1.QRPrinter.Master := nil;

  if (qrprinter.master <> nil) and (qrprinter.master is TQRCompositeWinControl) then
  begin
   // Standard QR printer dialog
    with TQRPatch(qrprinter.master).ParentReport do
    begin
      PrinterSettings.Title := 'Programa de Apoio à Decisão';
      PrinterSetup;
      if tag = 0 then
        print;
    end;
  end
  else
  begin
    if (qrprinter.master <> nil) then
    begin
      with TCustomQuickRep(qrprinter.master) do
      begin
        PrinterSettings.Title := 'Programa de Apoio à Decisão';
        PrinterSetup;
        if tag = 0 then
          print;
      end;
    end
    else
    begin
      // When you have a QRP file, you can't use
      // the printersetup dialog.  In this case
      // we use a simple dialog to allow the user
      // to select the printer
      with TfrmSelectPrinter.Create(application) do
      begin
        PrinterIndex := qrprinter.printerindex;
        ShowModal;
        if ModalResult = mrOk then
        begin
          qrprinter.printerindex := cbprinters.ItemIndex;
          qrprinter.print;
        end;
        free;
      end;
    end;
  end;
end;

procedure TfmNovoPreview.btnPrevPageClick(Sender: TObject);
begin
  Application.ProcessMessages;
  with QRPreview1 do
    if PageNumber > 1 then
      PageNumber := PageNumber - 1;
  UpdateButtons;
end;

procedure TfmNovoPreview.btnNextPageClick(Sender: TObject);
begin
  Application.ProcessMessages;

  with QRPreview1 do
    if PageNumber < QRPreview1.QRPrinter.PageCount then
      PageNumber := PageNumber + 1;
  UpdateButtons;
end;

procedure TfmNovoPreview.btnZoomInClick(Sender: TObject);
begin
  Application.ProcessMessages;
  with QRPreview1 do
    Zoom := Zoom + 10;
end;

procedure TfmNovoPreview.btnZoomOutClick(Sender: TObject);
begin
  Application.ProcessMessages;
  with QRPreview1 do
    if Zoom > 10 then
      Zoom := Zoom - 10;
end;

procedure TfmNovoPreview.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNovoPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  QRPrinter.ClosePreview(Self);
  QRPreview1.QRPrinter := nil;
//  Free;
  Action := caFree;
end;
{
procedure TfmNovoPreview.SetMyWindow;
var
  wp: TWindowPlacement;
  Rec: TRect;
begin
  // Get the client area of the desktop so we can force the preview
  // to use all of the available space.  This keeps the user from
  // minizing the form.
  SystemParametersInfo(SPI_GETWORKAREA, 0, @Rec, 0);
  wp.length := sizeof(wp);
  GetWindowPlacement(handle, @wp);
  wp.rcNormalposition := rec;
  setwindowplacement(handle, @wp);
end;
}
procedure TfmNovoPreview.FormShow(Sender: TObject);
begin
  bPleaseInit := True;
end;

procedure TfmNovoPreview.Init;
var
  OffSet: integer;
begin
  if bPleaseInit then
  begin
    { Force the preview to come up in the zoom setting that we want}
//    QRPreview1.ZoomToFit;

    { If the caller reports want to disable printing, then it will set}
    { the following boolean to false }
    if not bCanPrint then
    begin
      btnPrint.Enabled := bCanPrint;
      btnPrint.Visible := bCanPrint;

      // Shift the rest of the buttons over to fill the space of the hidden control
      OffSet := btnPrevPage.Left - btnPrint.Left;
      btnNextPage.Left := btnNextPage.Left - Offset;
      btnPrevPage.Left := btnPrevPage.Left - Offset;
      btnZoomIn.Left := btnZoomIn.Left - Offset;
      btnZoomOut.Left := btnZoomOut.Left - Offset;
      btnOpen.Left := btnOpen.Left - Offset;
      btnSave.Left := btnSave.Left - Offset;
      btnClose.Left := btnClose.Left - Offset;
    end;
    UpdateButtons;

    bPleaseInit := False;
  end;
end;

procedure TfmNovoPreview.QRPreview1PageAvailable(Sender: TObject;
  PageNum: Integer);
var
  sTitle: string;
begin
  Init;

  sTitle := QRPreview1.QRPrinter.Title;
  if sTitle = '' then
    sTitle := 'Relatório sem título';

  if PageNum = 1 then
    Caption := sTitle + ' - página 1'
  else
    Caption := sTitle + ' - ' + IntToStr(PageNum) + ' páginas';

  case QRPreview1.QRPrinter.Status of
    mpReady: sStatus := 'Pronto';
    mpBusy: sStatus := 'Ocupado';
    mpFinished: begin
                   sStatus := 'Terminado';
                   btnClose.Enabled := True;
                   btnPrint.Enabled := True;
                end;
  end;
  UpdateButtons;
end;

procedure TfmNovoPreview.FormCreate(Sender: TObject);
begin
  { We can disable the print functionality at runtime }
  bCanPrint := True;
  // Put the progress bar on the statusbar
  ProgressBar.Parent := StatusBar;

  // Get the client area of the desktop
//  SetMyWindow;
end;

procedure TfmNovoPreview.btnOpenClick(Sender: TObject);
begin
  // Prompt the user for a saved report.
  with TOpenDialog.Create(Application) do
  try
    Title := 'Carregar Relatório';
    Filter := 'Arquivo QuickReport (*.' +cQRPDefaultExt + ')|*.' + cqrpDefaultExt;
    if Execute then
      if FileExists(FileName) then
      begin
        qrprinter.master := nil;
        QRPrinter.Load(Filename);
        QRPreview1.PageNumber := 1;
        QRPreview1.PreviewImage.PageNumber := 1;
        Caption := 'Visualizando relatório gravado - ' + FileName + ' - ' + IntToStr(QRPrinter.PageCount) + ' pages';
        UpdateButtons;
      end
      else
        ShowMessage('Erro!  Arquivo não existe');
  finally
    free;
  end;
end;

procedure TfmNovoPreview.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Let the user navigate through the preview by the keyboard
  if ssAlt in Shift then begin
    case Key of
      vk_Down  : With QRPreview1.VertScrollBar do
                   Position := Position + trunc(Range / 10);
      vk_Up    : With QRPreview1.VertScrollBar do
                   Position := Position - trunc(Range / 10);
      vk_Left  : With QRPreview1.HorzScrollBar do
                   Position := Position - trunc(Range / 10);
      vk_Right : With QRPreview1.HorzScrollBar do
                   Position := Position + trunc(Range / 10);
    end;
  end;
  case Key of
    VK_Next : btnNextPageClick(Self);
    VK_Prior : btnPrevPageClick(Self);
    VK_Home : begin
      QRPreview1.PageNumber := 1;
      Application.ProcessMessages;
      UpdateButtons;
    end;
    VK_End : begin
      QRPreview1.PageNumber := QRPreview1.QRPrinter.PageCount;
      Application.ProcessMessages;
      UpdateButtons;
    end;
    VK_Escape : btnCloseClick(self)
   end;
end;

procedure TfmNovoPreview.btnSaveClick(Sender: TObject);
var
  aExportFilter : TQRExportFilter;
begin
  aExportFilter := nil;
  with TSaveDialog.Create(Application) do
  try
    Title := 'Gravar relatório';
    Filter := QRExportFilterLibrary.SaveDialogFilterString;
    DefaultExt := cQRPDefaultExt;
    if Execute then
    begin
      if FilterIndex = 1 then
        QRPrinter.Save(Filename)
      else
      begin
        try
          aExportFilter := TQRExportFilterLibraryEntry(
            QRExportFilterLibrary.Filters[FilterIndex - 2]).ExportFilterClass.Create(Filename);
          QRPrinter.ExportToFilter(aExportFilter);
        finally
          aExportFilter.Free
        end
      end
    end;
  finally
    Free;
  end;
end;

procedure TfmNovoPreview.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  aRect: TRect;
begin
  if Panel = StatusBar.Panels[2] then begin
    aRect := Rect;
    InflateRect(aRect, 1, 1);
    ProgressBar.BoundsRect := aRect;
  end;
end;

procedure TfmNovoPreview.QRPreview1ProgressUpdate(Sender: TObject;
  Progress: Integer);
begin
  ProgressBar.Position := Progress;
  if (Progress = 0) or (Progress = 100) then
    ProgressBar.Position := 0;
end;

{
  // When you use the RegisterPreviewClass() function, it
  // registers that preview class as the default preview.
  case cbPreview.ItemIndex of
    1: RegisterPreviewClass(TQRMDIPreviewInterface);
  else
    RegisterPreviewClass(TQRStandardPreviewInterface);
  end;
  cbPrint.Enabled := cbPreview.ItemIndex > 0;
  cbRender.Enabled := cbPreview.ItemIndex > 0;
end;

procedure TfrmCustomMain.cbRenderClick(Sender: TObject);
begin
  // Set some options
  prev2_32.PrintPreviewImage := cbRender.Checked;
end;
}

procedure TfmNovoPreview.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
{     if AComponent = FQRPrinter then
        begin
           ShowMessage( 'Estão tentando me derrubar, mas eu vou antes!!!' );
           Close;
//           FQRPrinter := nil;
        end;  }
end;

initialization
  CanPrint := true;
  PrintPreviewImage := false;

end.



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




unit CalculoViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, InsFrm, NutCnst, QRPrntr, quickrpt, fmRelViewer, Buttons, Menus,
  Calculo, //  NutWiz,
  qrepform, CalculoEditor, DelayedOpIndicator;

type

  TBeforePreviewEvent = procedure( Sender : TObject; var Cancel : Boolean ) of Object;

  TQckReportClass = class of TFormReport;

  TAntBtnRec = record
                   Calculo  : string;
                   RepClass : TQckReportClass;
                   Processador : TObject;
                end;

   CalcButtons = array[Low(TNomeCalculo)..High(TNomeCalculo)] of TAntBtnRec;

  TCalculoViewer = class(TPanel)
  private
    { Private declarations }
    FCancel : Boolean;

    FNovoRegistro: Boolean;
    FEndingApplication: Boolean;
    FCalculando: Boolean;
    FStartingApplication: Boolean;
    FCalculoCorrente: string;
    FProcessadorAtual: TObject;
    FWizardClassName: string;
    FCalculo: TCalculo;
    FBarraCalculo: TControl;
    FWizardModal: Boolean;
    FOnAfterWizardTerminate: TNotifyEvent;
    FOnAfterWizardCancel: TNotifyEvent;
    FDelayedOpIndicator: TDelayedOpIndicator;
    FPrint: Boolean;
    FOnBeforePreview: TBeforePreviewEvent;
    FOnWizardCancel: TNotifyEvent;
    FOnBeforeWizardTerminate: TNotifyEvent;
    FOnWizardTerminate: TNotifyEvent;
    FOnBeforeWizardCancel: TNotifyEvent;
    procedure Iniciar;
    procedure PreviewMsg;
    procedure AtivaWizardMsg;
    procedure FimWizard (Sender: TObject); //para OnClose ( ; var Action: TCloseAction)

    { Method to set variable and property values and create objects }
    procedure AutoInitialize;
    { Method to free any objects created by AutoInitialize }
    procedure AutoDestroy;
    procedure SetCalculoCorrente(const Value: string);
    procedure SetCalculando(const Value: Boolean);
    procedure SetEndingApplication(const Value: Boolean);
    procedure SetNovoRegistro(const Value: Boolean);
    procedure SetStartingApplication(const Value: Boolean);
    procedure SetProcessadorAtual(const Value: TObject);
    procedure SetWizardClassName(const Value: string);
    procedure SetCalculo(const Value: TCalculo);
    procedure SetBarraCalculo(const Value: TControl);
    procedure SetWizardModal(const Value: Boolean);
    procedure SetOnAfterWizardCancel(const Value: TNotifyEvent);
    procedure SetOnAfterWizardTerminate(const Value: TNotifyEvent);
    procedure SetDelayedOpIndicator(const Value: TDelayedOpIndicator);
    procedure SetPrint(const Value: Boolean);
    procedure SetOnBeforePreview(const Value: TBeforePreviewEvent);
    function GetPreviewBusy: Boolean;
    procedure SetOnBeforeWizardCancel(const Value: TNotifyEvent);
    procedure SetOnBeforeWizardTerminate(const Value: TNotifyEvent);
    procedure SetOnWizardCancel(const Value: TNotifyEvent);
    procedure SetOnWizardTerminate(const Value: TNotifyEvent);

  protected
    { Protected declarations }
  public
    { Public declarations }
    CurrentReport: TFormReport;
    CurrentViewer: TRelViewer;
    CurrentRepClass: TQckReportClass;
    FormCalcInicial : String;

    AntropButtons : CalcButtons;
    FormClassWizard : TFormClass;

    property ProcessadorAtual : TObject read FProcessadorAtual write SetProcessadorAtual;

    property StartingApplication : Boolean read FStartingApplication write SetStartingApplication;
    property EndingApplication : Boolean read FEndingApplication write SetEndingApplication;
    property CalculoCorrente : string read FCalculoCorrente write SetCalculoCorrente;
    property Calculando : Boolean read FCalculando write SetCalculando;
    property PreviewBusy : Boolean read GetPreviewBusy;
    property NovoRegistro : Boolean read FNovoRegistro write SetNovoRegistro;

    procedure DefineCalculo (NovoCalculo : TNomeCalculo; Show : Boolean = True);
    procedure RefreshPreview;
    procedure ShowPreview; virtual;
    function  HidePreview : Boolean;
    function  FechaPreview : Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure Loaded; override;
  published
    { Published declarations }
    // Indicador de operação demorada
    property DelayedOpIndicator : TDelayedOpIndicator read FDelayedOpIndicator write SetDelayedOpIndicator;
    property OnBeforeWizardCancel : TNotifyEvent read FOnBeforeWizardCancel write SetOnBeforeWizardCancel;
    property OnWizardCancel : TNotifyEvent read FOnWizardCancel write SetOnWizardCancel;
    property OnAfterWizardCancel : TNotifyEvent read FOnAfterWizardCancel write SetOnAfterWizardCancel;
    property OnBeforeWizardTerminate : TNotifyEvent read FOnBeforeWizardTerminate write SetOnBeforeWizardTerminate;
    property OnWizardTerminate : TNotifyEvent read FOnWizardTerminate write SetOnWizardTerminate;
    property OnAfterWizardTerminate : TNotifyEvent read FOnAfterWizardTerminate write SetOnAfterWizardTerminate;
    property WizardClassName : string read FWizardClassName write SetWizardClassName;
    property WizardModal : Boolean read FWizardModal write SetWizardModal;
    property Calculo : TCalculo read FCalculo write SetCalculo;
    property BarraCalculo : TControl read FBarraCalculo write SetBarraCalculo;
    property Print : Boolean read FPrint write SetPrint;
    property OnBeforePreview : TBeforePreviewEvent read FOnBeforePreview write SetOnBeforePreview;
  end;

var
  LogMesg : TStringList;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Calculadora', [TCalculoViewer]);
end;

{ TCalculoViewer }

constructor TCalculoViewer.Create(AOwner: TComponent);
begin
     { Call the Create method of the parent class }
     inherited Create(AOwner);

     { AutoInitialize sets the initial values of variables and      }
     { properties; also, it creates objects for properties of       }
     { standard Delphi object types (e.g., TFont, TTimer,           }
     { TPicture) and for any variables marked as objects.           }
     { AutoInitialize method is generated by Component Create.      }
     AutoInitialize;

     { Code to perform other tasks when the component is created }
end;

destructor TCalculoViewer.Destroy;
begin
     { AutoDestroy, which is generated by Component Create, frees any   }
     { objects created by AutoInitialize.                               }
     AutoDestroy;

     { Here, free any other dynamic objects that the component methods  }
     { created but have not yet freed.  Also perform any other clean-up }
     { operations needed before the component is destroyed.             }

     { Last, free the component by calling the Destroy method of the    }
     { parent class.                                                    }
     inherited Destroy;
end;

procedure TCalculoViewer.Loaded;
begin
     inherited Loaded;

     { Perform any component setup that depends on the property
       values having been set }
end;

procedure TCalculoViewer.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FCalculo then
        FCalculo := nil;
     if AComponent = FBarraCalculo then
        FBarraCalculo := nil
     else if AComponent = FDelayedOpIndicator then
        FDelayedOpIndicator := nil;
end;

procedure TCalculoViewer.ShowPreview;
begin
//*    if Assigned(FBarraCalculo) then
//*       FBarraCalculo.Visible := True;
    PreviewMsg;
end;

function TCalculoViewer.HidePreview: Boolean;
begin
   // Esconde Viewer
   Result:=True;
//*   if Assigned(FBarraCalculo) then
//*      FBarraCalculo.Visible := False;
   Caption := '';
end;

function TCalculoViewer.FechaPreview: Boolean;
begin
   // Esconde Viewer
   Result:=HidePreview;
   // Está Calculando e escondido
   if FCalculando and Result then
      begin
         AtivaWizardMsg;
      end;
end;

procedure TCalculoViewer.AtivaWizardMsg;
var
   Wiz : TCalculoEditor;
   WizClassRef : TEditorReference;
begin
   // inicializa instancia e classe do wizard
   Wiz:=nil;
//@   WizClassRef:=nil;

   // Existe um calculo valido escolhido?
   if (FCalculoCorrente <> '') then
       begin
       // Cria a classe do wizard e cria-a
       WizClassRef:=TEditorReference(GetClass(FWizardClassName));
       if Assigned(WizClassRef) then
          Wiz:=WizClassRef.Create(self, not(FWizardModal) );
       if Assigned(Wiz) then
          begin
             // Define alguns paramentros do wizard
             Wiz.OnDestroy:=FimWizard;
             Wiz.OnBeforeTerminate := OnBeforeWizardTerminate;
             Wiz.OnTerminate := OnWizardTerminate;
             Wiz.OnAfterTerminate := OnAfterWizardTerminate;
             Wiz.OnBeforeCancel := OnBeforeWizardCancel;
             Wiz.OnCancel := OnWizardCancel;
             Wiz.OnAfterCancel := OnAfterWizardCancel;
             Wiz.AtivaW (FCalculoCorrente);
          end
       end
   else
       begin
       ShowMessage('Calculo não implementado');
       FimWizard(self);
       end;
end;

procedure TCalculoViewer.FimWizard(Sender: TObject);
begin
   // Desliga o Calculando, pois sai do wizard
   FCalculando := False;
//*   if Assigned(FBarraCalculo) then
//*      FBarraCalculo.Visible := True;
   // Atualiza viewer
//   PreviewMsg;
   ShowPreview;
end;

procedure TCalculoViewer.AutoInitialize;
begin
   // Define variaveis
   Iniciar;
end;

procedure TCalculoViewer.AutoDestroy;
begin
end;

procedure TCalculoViewer.Iniciar;
begin
   // Define algumas variáveis
end;

procedure TCalculoViewer.PreviewMsg;
begin

   FCancel := False;
   if Assigned( FOnBeforePreview ) then
      FOnBeforePreview( Self, FCancel );

   // Mostra o que tem pra mostrar
   self.Caption := FCalculoCorrente;

end;

procedure TCalculoViewer.RefreshPreview;
begin
   // Mostra o que tem pra mostrar
   self.Caption := FCalculoCorrente;
end;

procedure TCalculoViewer.DefineCalculo(NovoCalculo: TNomeCalculo;
  Show: Boolean);
begin
   FCalculoCorrente := AntropButtons[NovoCalculo].Calculo;
   FProcessadorAtual := AntropButtons[NovoCalculo].Processador;
   if Show then
      ShowPreview;
end;

procedure TCalculoViewer.SetBarraCalculo(const Value: TControl);
begin
  FBarraCalculo := Value;
//*  if Assigned(FBarraCalculo) then
//*     FBarraCalculo.Visible := False;
end;

procedure TCalculoViewer.SetOnBeforePreview(const Value: TBeforePreviewEvent);
begin
  FOnBeforePreview := Value;
end;

function TCalculoViewer.GetPreviewBusy: Boolean;
begin
  Result:= False;
end;

procedure TCalculoViewer.SetCalculoCorrente(const Value: string);
begin
  FCalculoCorrente := Value;
end;

procedure TCalculoViewer.SetCalculando(const Value: Boolean);
begin
  FCalculando := Value;
end;

procedure TCalculoViewer.SetEndingApplication(const Value: Boolean);
begin
  FEndingApplication := Value;
end;

procedure TCalculoViewer.SetNovoRegistro(const Value: Boolean);
begin
  FNovoRegistro := Value;
end;

procedure TCalculoViewer.SetStartingApplication(const Value: Boolean);
begin
  FStartingApplication := Value;
end;

procedure TCalculoViewer.SetProcessadorAtual(const Value: TObject);
begin
  FProcessadorAtual := Value;
end;

procedure TCalculoViewer.SetWizardClassName(const Value: string);
begin
  FWizardClassName := Value;
end;

procedure TCalculoViewer.SetCalculo(const Value: TCalculo);
begin
  FCalculo := Value;
end;

procedure TCalculoViewer.SetWizardModal(const Value: Boolean);
begin
  FWizardModal := Value;
end;

procedure TCalculoViewer.SetOnAfterWizardCancel(const Value: TNotifyEvent);
begin
  FOnAfterWizardCancel := Value;
end;

procedure TCalculoViewer.SetOnAfterWizardTerminate(
  const Value: TNotifyEvent);
begin
  FOnAfterWizardTerminate := Value;
end;

procedure TCalculoViewer.SetDelayedOpIndicator(
  const Value: TDelayedOpIndicator);
begin
  FDelayedOpIndicator := Value;
  if Value <> nil then
     Value.FreeNotification(Self);
end;

procedure TCalculoViewer.SetPrint(const Value: Boolean);
begin
  FPrint := Value;
end;

procedure TCalculoViewer.SetOnBeforeWizardCancel(
  const Value: TNotifyEvent);
begin
  FOnBeforeWizardCancel := Value;
end;

procedure TCalculoViewer.SetOnBeforeWizardTerminate(
  const Value: TNotifyEvent);
begin
  FOnBeforeWizardTerminate := Value;
end;

procedure TCalculoViewer.SetOnWizardCancel(const Value: TNotifyEvent);
begin
  FOnWizardCancel := Value;
end;

procedure TCalculoViewer.SetOnWizardTerminate(const Value: TNotifyEvent);
begin
  FOnWizardTerminate := Value;
end;

end.

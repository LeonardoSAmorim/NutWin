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




unit OpcSalas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, USalas, Sala1, Sala2, MSala1, MSala2,
  ComCtrls, Menus, InsFrm;

type
  TfmOpcSalas = class(TForm)
    paSalas: TPanel;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Opes1: TMenuItem;
    Nenhuma1: TMenuItem;
    Informal1: TMenuItem;
    Formal1: TMenuItem;
    ifSala1: TInFormBuilder;
    ifSala2: TInFormBuilder;
    procedure ClickObjetoSala( Sender : TObject; ObjetoSala : TObjetoSala );
    procedure Sair1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Nenhuma1Click(Sender: TObject);
    procedure Informal1Click(Sender: TObject);
    procedure Formal1Click(Sender: TObject);
  private
    { Private declarations }
    FContainer : TWinControl;
    FModal : Boolean;
    FEventoObjetoSala : TObjetoSalaEvent;
  public
    { Public declarations }
    property EventoObjetoSala : TObjetoSalaEvent read FEventoObjetoSala write FEventoObjetoSala;
    property Container : TWinControl read FContainer write FContainer;
    property Modal : Boolean read FModal write FModal;
    procedure ShowSala0;
    procedure ShowSala1;
    procedure ShowSala2;
  end;

var
  fmOpcSalas: TfmOpcSalas;

implementation

{$R *.DFM}

procedure TfmOpcSalas.ShowSala0;
begin
   ifSala1.CloseInForm;
   ifSala2.CloseInForm;
end;

procedure TfmOpcSalas.ShowSala1;
begin
   ifSala1.CriaFormInterno( TfmSala1 );
   TfmSala1( ifSala1.FormBuilded ).FormMascara := TfmMascSala1.Create(self);
   TfmSala1( ifSala1.FormBuilded ).OnClickObjetoSala := FEventoObjetoSala;
   ifSala1.ShowInForm;
end;

procedure TfmOpcSalas.ShowSala2;
begin
   ifSala2.CriaFormInterno( TfmSala2 );
   TfmSala2( ifSala2.FormBuilded ).FormMascara := TfmMascSala2.Create(self);
   TfmSala2( ifSala2.FormBuilded ).OnClickObjetoSala := FEventoObjetoSala;
   ifSala2.ShowInForm;
end;

procedure TfmOpcSalas.ClickObjetoSala( Sender : TObject; ObjetoSala : TObjetoSala );
begin
   Case ObjetoSala of
      osPorta : Close;
      osPrateleira : ShowMessage( 'Prateleira' );
      osGaveta1a : ShowMessage( 'Gaveta1a' );
      osGaveta1b : ShowMessage( 'Gaveta1b' );
      osGaveta2a : ShowMessage( 'Gaveta2a' );
      osGaveta2b : ShowMessage( 'Gaveta2b' );
      osGaveta3a : ShowMessage( 'Gaveta3a' );
      osGaveta3b : ShowMessage( 'Gaveta3b' );
      osCalculadora : ShowMessage( 'Calculadora' );
      osLupa : ShowMessage( 'Lupa' );
      osCanetaOpInd : ShowMessage( 'CanetaOpInd' );
      osCanetaOpAlim : ShowMessage( 'CanetaOpAlim' );
      osCanetaOpSist : ShowMessage( 'CanetaOpSist' );
      osPapeisAlim  : ShowMessage( 'PapeisAlim' );
      osPapeisInd   : ShowMessage( 'PapeisInd' );
      osJanela1 : ShowMessage( 'Janela1' );
      osJanela2 : ShowMessage( 'Janela2' );
   end;
end;

//==============================================================================

procedure TfmOpcSalas.Sair1Click(Sender: TObject);
begin
   Close;
end;

procedure TfmOpcSalas.FormCreate(Sender: TObject);
begin
   EventoObjetoSala := ClickObjetoSala; // Veja modelo em ClickObjetoSala
   Container := paSalas;
   Modal := False;
end;

procedure TfmOpcSalas.Nenhuma1Click(Sender: TObject);
begin
   Nenhuma1.Checked := True;
   ShowSala0;
end;

procedure TfmOpcSalas.Informal1Click(Sender: TObject);
begin
   Informal1.Checked := True;
   ShowSala1;
end;

procedure TfmOpcSalas.Formal1Click(Sender: TObject);
begin
   Formal1.Checked := True;
   ShowSala2;
end;

end.

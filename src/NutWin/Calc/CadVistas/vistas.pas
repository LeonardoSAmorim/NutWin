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




unit vistas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, Grids, DBGrids, DBCtrls, ExtCtrls, ExtDlgs;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    DBImage1: TDBImage;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Table1: TTable;
    Button1: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    laX: TLabel;
    laY: TLabel;
    DataSource2: TDataSource;
    taAreaVista: TTable;
    DBGrid2: TDBGrid;
    DBNavigator2: TDBNavigator;
    Table1OBJETO: TStringField;
    Table1OVORDEM: TFloatField;
    Table1OVPICTURE: TGraphicField;
    taAreaVistaOBJETO: TStringField;
    taAreaVistaOVORDEM: TFloatField;
    taAreaVistaOVAREA: TStringField;
    taAreaVistaOVTOP: TFloatField;
    taAreaVistaOVLEFT: TFloatField;
    taAreaVistaOVHEIGHT: TFloatField;
    taAreaVistaOVWIDTH: TFloatField;
    taAreaVistaOVCAPTION: TStringField;
    Database1: TDatabase;
    procedure Button1Click(Sender: TObject);
    procedure DBImage1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DataSource2DataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
    Ponto : TLabel;
  end;

var
  Form1: TForm1;

implementation

uses uAliasName;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
     if OpenPictureDialog1.Execute then
     begin
        Table1.Edit;
        DBImage1.Picture.LoadFromFile( OpenPictureDialog1.FileName );
     end;
end;

procedure TForm1.DBImage1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   laX.Caption := 'X= ' + IntToStr( X );
   laY.Caption := 'Y= ' + IntToStr( Y );
   Ponto.Left := Y;
   Ponto.Top := X;
   taAreaVista.Edit;
   taAreaVista.FieldByName( 'OVTOP' ).AsInteger := Y;
   taAreaVista.FieldByName( 'OVLEFT' ).AsInteger := X;
   taAreaVista.Post;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Database1.AliasName := BDE_ALIAS_NAME;
openAllTables(self);
   Ponto := TLabel.Create( DBImage1 );
   Ponto.Parent := DBImage1;
   Ponto.Caption := 'x';
   Ponto.font.Color := clRed;
   Ponto.Color := clWhite;
//   Ponto.Font.style := [fsBold];
   Ponto.Transparent := True;
   Ponto.Top := 10;
   Ponto.Left := 10;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Ponto.Free;
end;

procedure TForm1.DataSource2DataChange(Sender: TObject; Field: TField);
begin
   if assigned( Ponto ) then
   begin
   Ponto.Top := taAreaVista.FieldByName( 'OVTOP' ).AsInteger;
   Ponto.Left := taAreaVista.FieldByName( 'OVLEFT' ).AsInteger;
   Ponto.Caption := taAreaVista.FieldByName( 'OVCAPTION' ).AsString;
   end;
end;

end.

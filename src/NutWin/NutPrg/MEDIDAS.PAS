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




unit Medidas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, ComCtrls, ExtCtrls, Grids, DBGrids, DB, DBTables,
  Buttons, Mask;

type
  TfrmMedidas = class(TForm)
    pnlMedidas: TPanel;
    pgcMedidas: TPageControl;
    pnlMedTitulo: TPanel;
    tbsCadastro: TTabSheet;
    tbsLocalizar: TTabSheet;
    tbMedidas: TTable;
    DBGrid1: TDBGrid;
    tbMedidasCODMED: TAutoIncField;
    tbMedidasNOME: TStringField;
    tbMedidasGRUPO: TStringField;
    tbMedidasVOLUME_ML: TFloatField;
    tbMedidasFOTO: TBlobField;
    DataSource1: TDataSource;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBComboBox1: TDBComboBox;
    dlgAbreFoto: TOpenDialog;
    DBEdit6: TDBEdit;
    TreeView1: TTreeView;
    Label7: TLabel;
    DBNavigator1: TDBNavigator;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btbFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMedidas: TfrmMedidas;

implementation

uses NutMenu;

{$R *.DFM}

procedure TfrmMedidas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     tbMedidas.Active := False;
     Action := caFree
end;

procedure TfrmMedidas.btbFecharClick(Sender: TObject);
begin
     tbMedidas.Active := False;
     Close;
end;

procedure TfrmMedidas.FormCreate(Sender: TObject);
begin
     pgcMedidas.ActivePage := tbsCadastro;
     tbMedidas.Active := True;
end;

procedure TfrmMedidas.DBGrid1DblClick(Sender: TObject);
begin
     pgcMedidas.ActivePage := tbsCadastro;
end;

end.

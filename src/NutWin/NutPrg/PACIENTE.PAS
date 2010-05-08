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




unit Paciente;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Buttons, DBCtrls, DB, Mask, DBTables,
  Grids, DBGrids, Tabs, OleCtrls, GraphSvr, Spin;

type
  TfrmPacientes = class(TForm)
    procedure btbFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btAnamAlimAlterarClick(Sender: TObject);
    procedure btAnamMedAlterarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPacientes: TfrmPacientes;

implementation

uses NutMenu, AnamAlim, AnamMed;

{$R *.DFM}

procedure TfrmPacientes.btbFecharClick(Sender: TObject);
begin
     tbPacientes.Active := False;
     Close;
end;

procedure TfrmPacientes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     tbPacientes.Active := False;
     Action := caFree
end;

procedure TfrmPacientes.FormCreate(Sender: TObject);
begin
     pgcPacientes.ActivePage := tbsCadastro;
     tbPacientes.Active := True;
end;

procedure TfrmPacientes.DBGrid1DblClick(Sender: TObject);
begin
     pgcPacientes.ActivePage := tbsCadastro;
end;

procedure TfrmPacientes.btAnamAlimAlterarClick(Sender: TObject);
begin
     Application.CreateForm(Tfm_Anam_Alim, fm_Anam_Alim);
end;

procedure TfrmPacientes.btAnamMedAlterarClick(Sender: TObject);
begin
     Application.CreateForm(Tfm_Anam_Med, fm_Anam_Med);
end;

end.

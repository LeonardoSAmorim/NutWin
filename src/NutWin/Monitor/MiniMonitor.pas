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




unit MiniMonitor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBCtrls, ExtCtrls, Grids, DBGrids, DBTables, StdCtrls, Spin;

type
  TfmSemaforo = class(TForm)
    grSemaforo: TDBGrid;
    pnNav: TPanel;
    DBNavigator1: TDBNavigator;
    dsSemaforo: TDataSource;
    dbSemaforo: TDatabase;
    tbSemaforo: TTable;
    tmSemaforo: TTimer;
    ckAutoRefresh: TCheckBox;
    seTempo: TSpinEdit;
    Label1: TLabel;
    procedure tmSemaforoTimer(Sender: TObject);
    procedure ckAutoRefreshClick(Sender: TObject);
    procedure seTempoChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSemaforo: TfmSemaforo;

implementation

{$R *.DFM}

procedure TfmSemaforo.tmSemaforoTimer(Sender: TObject);
begin
  tbSemaforo.Refresh;
  grSemaforo.Repaint;
end;

procedure TfmSemaforo.ckAutoRefreshClick(Sender: TObject);
begin
   tmSemaforo.Enabled := ckAutoRefresh.Checked;
end;

procedure TfmSemaforo.seTempoChange(Sender: TObject);
begin
 if  ckAutoRefresh.Checked then
     tmSemaforo.Interval := (seTempo.Value * 1000);
end;

procedure TfmSemaforo.FormShow(Sender: TObject);
begin
   fmSemaforo.Top := 0;
   fmSemaforo.Left := 0;
end;

end.

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




unit fmCfgCalculos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, Memoria, CheckLst, Procedimento, Registry, RegConst2;

type
  TfmConfigCalculos = class(TForm)
    paCfgCalculos: TPanel;
    bbCfgCalcCancelar: TBitBtn;
    bbCfgCalcOk: TBitBtn;
    ckProcAntrop: TCheckListBox;
    laCfgCalcAntrop: TLabel;
    gbCfgCalcAntrop: TGroupBox;
    bbCfgCalcAntropTodos: TBitBtn;
    bbCfgCalcAntropNenhum: TBitBtn;
    procedure bbCfgCalcOkClick(Sender: TObject);
    procedure bbCfgCalcAntropTodosClick(Sender: TObject);
    procedure bbCfgCalcAntropNenhumClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function LoadCfgAntrop : Boolean;
    procedure SaveCfgAntrop;
    function CriaCfgAntrop : Boolean;
  end;

var
  fmConfigCalculos: TfmConfigCalculos;

implementation

uses DMMBoard;

{$R *.DFM}

{ TfmConfigCalculos }

function TfmConfigCalculos.CriaCfgAntrop: Boolean;
begin
   Result := True;
end;

function TfmConfigCalculos.LoadCfgAntrop: Boolean;
var
   AuxCx,
   AuxPr : TComponent;
   I : Integer;
   GtrReg : TRegistry;
   Path : String;
begin
   Result := True;
   ckProcAntrop.Clear;
   GtrReg := TRegistry.Create;
   GtrReg.RootKey := HKey_Local_Machine;
   GtrReg.OpenKey(CFGPath,False);
   try
      Path := GtrReg.ReadString(CFGPersonaFileName);
      with dmMotherBoard.CfgMemoria do
      begin
         NomeArquivo := Path + '\CFGCalcNut.cfg';
         if not Abrir then
            ShowMessage( 'Não consegui abrir configurações de cálculos.' );
      end;
   except on E:Exception do
      ShowMessage( 'Não consegui achar configurações de cálculos.' );
   end;
   GtrReg.Free;
   with dmMotherBoard do
   begin
      AuxCx := CfgMemoria.FindComponent( 'cxcaAntrop' );
      if Assigned( AuxCx ) then
         if ( AuxCx is TCaixa ) then
            For I := 0 to AuxCx.ComponentCount - 1 do
            begin
               AuxPr := AuxCx.Components[I];
               if ( AuxPr is TProcedimento ) then
                  if TProcedimento( AuxPr ).Estado <> psHidden then
                     ckProcAntrop.Items.AddObject(TProcedimento(AuxPr).Descricao, AuxPr);
               Result := True;
            end;
   end;
   For I := 0 to ckProcAntrop.Items.Count - 1 do
       ckProcAntrop.Checked[I] := not(TProcedimento(ckProcAntrop.Items.Objects[I]).Estado = psInvisible );
end;

procedure TfmConfigCalculos.SaveCfgAntrop;
var
    GtrReg : TRegistry;
    Path : String;
begin
   GtrReg := TRegistry.Create;
   GtrReg.RootKey := HKey_Local_Machine;
   GtrReg.OpenKey(CFGPath,False);
   try
      Path := GtrReg.ReadString(CFGPersonaFileName);
      with dmMotherBoard.CfgMemoria do
      begin
         NomeArquivo := Path + '\CFGCalcNut.cfg';
         Salvar;
      end;
   except on E:Exception do
      ShowMessage( 'Não consegui gravar configurações de cálculos.' );
   end;
   GtrReg.Free;
end;

procedure TfmConfigCalculos.bbCfgCalcOkClick(Sender: TObject);
var
   I : Integer;
begin
   For I := 0 to ckProcAntrop.Items.Count - 1 do
      if ckProcAntrop.Checked[I] then
         TProcedimento( ckProcAntrop.Items.Objects[I] ).Estado := psNone
      else
         TProcedimento( ckProcAntrop.Items.Objects[I] ).Estado := psInvisible;
   SaveCfgAntrop;
end;

procedure TfmConfigCalculos.bbCfgCalcAntropTodosClick(Sender: TObject);
var
   I : Integer;
begin
   For I := 0 to ckProcAntrop.Items.Count - 1 do
       ckProcAntrop.Checked[I] := True;
end;

procedure TfmConfigCalculos.bbCfgCalcAntropNenhumClick(Sender: TObject);
var
   I : Integer;
begin
   For I := 0 to ckProcAntrop.Items.Count - 1 do
       ckProcAntrop.Checked[I] := False;
end;

procedure TfmConfigCalculos.FormShow(Sender: TObject);
begin
   LoadCfgAntrop;
end;

end.

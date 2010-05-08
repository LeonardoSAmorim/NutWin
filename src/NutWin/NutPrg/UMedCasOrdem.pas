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




unit UMedCasOrdem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MmLstBox, ExtCtrls, MoveItens;

type
  TfmMedCasOrdem = class(TForm)
    miMedCas: TMoveItens;
    laOrdem: TLabel;
    mmMedCas: TMmListBox;
    btOK: TButton;
    btCancela: TButton;
    btSubir: TButton;
    btDescer: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMedCasOrdem: TfmMedCasOrdem;

implementation

uses DMMedidas, DMAliPrep;

{$R *.DFM}

procedure TfmMedCasOrdem.FormCreate(Sender: TObject);
begin
  miMedCas.Visible := True;
   DMedidas.TbMCOrdPad.First;
   mmMedCas.Items.Clear;
   While not DMedidas.TbMCOrdPad.Eof do
   begin
     mmMedCas.AddDescricaoGUID( DMedidas.TbMCOrdPadNomeMedida.asString,DMedidas.TbMCOrdPadIDMEDCAS.asString);
     DMedidas.TbMCOrdPad.Next;
   end;
   //miMedCas.SetFocus;
end;

procedure TfmMedCasOrdem.btOKClick(Sender: TObject);
var
I : integer;

begin
   for I:=0 to (mmMedCas.Items.Count - 1) do
   begin
      DMedidas.TbMedidasCaseiras.DisableControls;
      if DMedidas.TbMedidasCaseiras.Locate('IDALI;IDMEDCAS', VarArrayOf([DMAlimentos.TbAlimento['IDALI'],mmMedCas.GUID[I]]), [] )then
      begin
        DMedidas.TbMedidasCaseiras.Edit;
        DMedidas.TbMedidasCaseiras.FieldByName('ORDPADRAO').asInteger := I;
        DMedidas.TbMedidasCaseiras.Post;
        DMedidas.TbMCOrdPad.Refresh;
        DMedidas.TbMedidasCaseiras.EnableControls;
        Close;
      end;
   end;


end;

procedure TfmMedCasOrdem.btCancelaClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMedCasOrdem.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree; 
end;

end.

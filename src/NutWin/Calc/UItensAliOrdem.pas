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




unit UItensAliOrdem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MmLstBox, ExtCtrls, MoveItens, CalcAli;

type
  TfmItensAliOrdem = class(TForm)
    miItensAli: TMoveItens;
    laOrdem: TLabel;
    mmItensAli: TMmListBox;
    btOK: TButton;
    btCancela: TButton;
    btSubir: TButton;
    btDescer: TButton;
    procedure btOKClick(Sender: TObject);
    procedure btCancelaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FCalcAli: TCustomCalculoAlimentar;
    procedure SetCalcAli(const Value: TCustomCalculoAlimentar);
    { Private declarations }
  public
    { Public declarations }
     property CalcAli : TCustomCalculoAlimentar read FCalcAli write SetCalcAli;

  end;

var
  fmItensAliOrdem: TfmItensAliOrdem;

implementation

{$R *.DFM}

procedure TfmItensAliOrdem.btOKClick(Sender: TObject);
var
   I : integer;
begin
   with FCalcAli.DMCalculoAlimentar.taItensAli do
   begin
      DisableControls;
      for I := 0 to (mmItensAli.Items.Count - 1) do
      begin
         if Locate('GUID', mmItensAli.GUID[I], [] )then
         begin
           Edit;
           FieldByName('ITEM').asInteger := I;
           Post;
         end;
      end;
      Refresh;
      EnableControls;
   end;
   Close;
end;

procedure TfmItensAliOrdem.btCancelaClick(Sender: TObject);
begin
   Close;
end;

procedure TfmItensAliOrdem.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfmItensAliOrdem.SetCalcAli(const Value: TCustomCalculoAlimentar);
begin
   FCalcAli := Value;
end;

procedure TfmItensAliOrdem.FormShow(Sender: TObject);
begin
   mmItensAli.Items.Clear;
   with FCalcAli.DMCalculoAlimentar.taItensAli do
   begin
      First;
      While not Eof do
      begin
        if FieldByName('QUANT').AsInteger =  0 then
           mmItensAli.AddDescricaoGUID( FieldByName('NOMEALI').AsString + '; ' +
                                        FieldByName('PESO').AsString + 'g',
                                        FieldByName('GUID').AsString)
        else
           mmItensAli.AddDescricaoGUID( FieldByName('NOMEALI').AsString + '; ' +
                                        FieldByName('QUANT').AsString + '; ' +
                                        FieldByName('NOMEMED').AsString + '; ' +
                                        FieldByName('PESO').AsString + 'g',
                                        FieldByName('GUID').AsString);
        Next;
      end;
   end;
end;

end.

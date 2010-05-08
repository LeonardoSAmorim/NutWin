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




unit USelIndiv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MmLstBox, ExtCtrls, MontaLst, Grids, DBGrids;

type

  TGUID = class( TComponent )
  private
  public
     Guid : String
  end;

  TfmPSelIndiv = class(TForm)
    mlIndiv: TMontaLista;
    lbEntr: TMmListBox;
    lbSaida: TMmListBox;
    bbSaida: TBitBtn;
    bbEntr: TBitBtn;
    bbTudoSai: TBitBtn;
    bbTudoEnt: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lbEntrClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPSelIndiv: TfmPSelIndiv;

implementation

uses DMPesq;

{$R *.DFM}

procedure TfmPSelIndiv.FormCreate(Sender: TObject);
var
   AuxGUID : TGUID;
begin
   {DMPesquisa.TbPessoa.First;
   While not DMPesquisa.TbPessoa.EOF do
       begin
        lbEntr.items.add( DMPesquisa.TbPessoaNomePess.asString);
        DMPesquisa.TbPessoa.Next;
       end;   }
    DMPesquisa.PesPastasSelec ;
    While not DMPesquisa.TbPesqTemp1.EOF do
      begin
       AuxGUID := TGUID.Create( self );
       AuxGUID.Guid := DMPesquisa.TbPesqTemp1IdPessoa.AsString;
//       lbEntr.items.add( DMPesquisa.TbPesqTemp1NomeCompleto.asString);
       lbEntr.items.AddObject( DMPesquisa.TbPesqTemp1NomeCompleto.asString,AuxGUID);
       DMPesquisa.TbPesqTemp1.Next;
      end;
end;
procedure TfmPSelIndiv.lbEntrClick(Sender: TObject);
var
   I : Integer;
begin
   for I := lbEntr.Items.Count - 1 DownTo 0 do
     if lbEntr.Selected[I] then
     begin
        Label1.Caption := TGUID( lbEntr.Items.Objects[I] ).GUID
     end;  
end;

end.

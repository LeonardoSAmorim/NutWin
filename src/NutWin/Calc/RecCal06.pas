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




unit RecCal06;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Memoria, RDA, ExtCtrls, PAINELMEDIDA, ComCtrls, RecNutViewer,
  CCSListaLinks, CCSDBListaLinks, Calculo, MemoriaViewer, Wizard, VisorCal, CalcAli;

type
  TfmRecCal06 = class(TForm)
    paRecNut: TPanel;
    RecNutViewer: TRecNutViewer;
    gbRDA: TGroupBox;
    lvRecNut: TListView;
    pmFaixaRDA: TPainelMedida;
    laFaixaRDADescricao: TLabel;
    laFaixaRDAValor: TLabel;
    laFaixaRDAUnidade: TLabel;
    vcFaixaRDA: TVisorCalculo;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRecCal06: TfmRecCal06;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRecCal06.FormShow(Sender: TObject);
begin
   Try
      dmMotherBoard.RDA.CriaRDA;
   except
     on E: Exception do begin
      Tag := WZ_INVALIDNODE;
      Click;
      ShowMessage( E.Message );
      exit;
     end;
   end;
   RecNutViewer.Refresh(self);
   lvRecNut.Items[0].Selected:=True;
   vcFaixaRDA.Refresh;
   lvRecNut.SetFocus;
end;

procedure TfmRecCal06.FormCreate(Sender: TObject);
begin
    // Seta o co-processador de RDA
    with dmMotherBoard do
    begin
       RDA.Memoria := caProcessador.memoria;
       if Assigned( ProcessadorAtual ) then
       begin
          RDA.CaixaRDA := TCalculoAlimentar( ProcessadorAtual ).CaixaRecNut;
          RecNutViewer.CaixaRecNut := TCalculoAlimentar( ProcessadorAtual ).CaixaRecNut;
       end;   
    end;
end;

end.

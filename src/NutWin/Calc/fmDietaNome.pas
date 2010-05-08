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




unit fmDietaNome;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PAINELMEDIDA, ExtCtrls, Wizard;

type
  TfmPlanoAlimentarNome = class(TForm)
    paPlanoAlimentar: TPanel;
    laPlanoAliInstrucoes: TLabel;
    pmNomePlanoAli: TPainelMedida;
    laNomePlanoAli: TLabel;
    laNomePlanoAliUnidade: TLabel;
    edNomePlanoAliEntrada: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure edNomePlanoAliEntradaKeyPress(Sender: TObject;
      var Key: Char);
    procedure edNomePlanoAliEntradaChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function PodeAvancar : Boolean;
  end;

var
  fmPlanoAlimentarNome: TfmPlanoAlimentarNome;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmPlanoAlimentarNome.FormCreate(Sender: TObject);
begin
   pmNomePlanoAli.Medida := dmMotherBoard.CalcDieta.DescricaoCalculo;
    // Seta o co-processador de RDA
    with dmMotherBoard do
    begin
       RDA.Memoria := caProcessador.memoria;
       if Assigned( ProcessadorAtual ) then
       begin
          RDA.CaixaRDA := CalcInquerito.CaixaRecNut;
       end;
    end;

end;

procedure TfmPlanoAlimentarNome.FormShow(Sender: TObject);
begin
   edNomePlanoAliEntradaChange(Sender);
   edNomePlanoAliEntrada.SetFocus;
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
end;

procedure TfmPlanoAlimentarNome.FormHide(Sender: TObject);
begin
   pmNomePlanoAli.Update;
   self.Tag:=0;
end;

function TfmPlanoAlimentarNome.PodeAvancar: Boolean;
begin
   // preciso de um nome de preparação (retirado a pedido da Lilian em 9/07/02)
{   if ( edNomePlanoAliEntrada.Text = '' ) then
       begin
          Result := False;
       end
   else }
      Result := True;
end;

procedure TfmPlanoAlimentarNome.edNomePlanoAliEntradaKeyPress(
  Sender: TObject; var Key: Char);
begin
   if Key = #27 then
      begin
         dmMotherBoard.Wizard.Cancelar;
         Key := #0;
      end
   else if Key = #13 then
      begin
         if PodeAvancar then
            dmMotherBoard.Wizard.Avancar;
         Key := #0;
      end;
end;

procedure TfmPlanoAlimentarNome.edNomePlanoAliEntradaChange(
  Sender: TObject);
begin
    if PodeAvancar then 
       self.Tag := 0
    else
       self.Tag := WZ_INVALIDNODE;
    Click;
end;

end.

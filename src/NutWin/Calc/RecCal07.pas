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




unit RecCal07;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, PAINELMEDIDA, VisorCal, measurement;

type
  TfmRecCal07 = class(TForm)
    paRecCal07: TPanel;
    qrRecCal07: TGroupBox;
    pmRecCal07: TPainelMedida;
    laRecEnergiaDescricao: TLabel;
    laRecEnergiaValor: TLabel;
    laRecEnergiaUnidade: TLabel;
    vsRecCal07: TVisorCalculo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRecCal07: TfmRecCal07;

implementation

uses DMMBoard;

{$R *.DFM}

procedure TfmRecCal07.FormShow(Sender: TObject);
var
   LMed,
   LProc : TStringList;
//   I : Integer;
begin
   LProc := TStringList.Create;
   with dmMotherBoard do
   begin
      LMed := caProcessador.ListaMedida;
      if LMed.IndexOf( 'mdRCFAODia' ) >= 0 then
          pmRecCal07.NomeMedida := LMed.Strings[LMed.IndexOf( 'mdRCFAODia' )]
      else if LMed.IndexOf( 'mdRCPac' ) >= 0 then
          pmRecCal07.NomeMedida := LMed.Strings[LMed.IndexOf( 'mdRCPac' )]
      else if LMed.Count > 0 then
          pmRecCal07.NomeMedida := '';
      LProc.Assign( caProcessador.Procedimentos );
      caProcessador.Execute;
      caProcessador.Procedimentos.Assign( LProc );
   end;
   LProc.Free;
   vsRecCal07.Refresh;
end;

end.

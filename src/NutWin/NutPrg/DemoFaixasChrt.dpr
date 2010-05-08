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




program DemoFaixasChrt;

uses
  Forms,
  UGrafAc in 'UGrafAc.pas' {fmGrafAcomp},
  qrepform in '..\..\CompDelphi\Calculo\QREPFORM.pas' {FormReport},
  fmRelGraficos in 'Relatorios\fmRelGraficos.pas' {RelGraficos},
  DMGraf in 'DMGraf.pas' {dmGraficos: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdmGraficos, dmGraficos);
  Application.CreateForm(TfmGrafAcomp, fmGrafAcomp);
  Application.Run;
end.

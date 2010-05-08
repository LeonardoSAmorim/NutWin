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




program ClicImage;

uses
  Forms,
  Sala1 in 'Sala1.pas' {fmSala1},
  MSala1 in 'MSala1.pas' {fmMascSala1},
  MSala2 in 'MSala2.pas' {fmMascSala2},
  Sala2 in 'Sala2.pas' {fmSala2},
  OpcSalas in 'OpcSalas.pas' {fmOpcSalas},
  USalas in 'USalas.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmOpcSalas, fmOpcSalas);
  Application.Run;
end.

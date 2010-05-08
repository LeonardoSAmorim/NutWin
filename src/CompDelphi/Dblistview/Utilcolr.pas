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




unit Utilcolr;

interface

{$IFDEF WIN32}
uses Windows, Graphics;
{$ELSE}
uses WinTypes, Graphics;
{$ENDIF}

const
  NumPaletteEntries = 32;

var
  PaletteEntries: array[0..NumPaletteEntries - 1] of TPaletteEntry;


function GetColor(Couleur:Integer): TColor;
function GetColorEx(Couleur:Integer): TColor;

implementation

{$IFDEF WIN32}
uses SysUtils, Consts, StdCtrls;
{$ELSE}
uses SysUtils, WinProcs, Consts, StdCtrls;
{$ENDIF}

function GetColor(Couleur:Integer): TColor;
var
  PalIndex: Integer;
begin
  GetPaletteEntries(GetStockObject(DEFAULT_PALETTE), 0, NumPaletteEntries,
                    PaletteEntries);
  if Couleur < 8 then
    PalIndex:= Couleur
  else
    PalIndex:= Couleur + 4;
  with PaletteEntries[PalIndex] do
    Result := TColor(RGB(peRed, peGreen, peBlue));
end;

function GetColorEx(Couleur:Integer): TColor;
begin
  GetPaletteEntries(GetStockObject(DEFAULT_PALETTE), 0, NumPaletteEntries,
                    PaletteEntries);
  with PaletteEntries[Couleur] do
    Result := TColor(RGB(peRed, peGreen, peBlue));
end;

end.
 
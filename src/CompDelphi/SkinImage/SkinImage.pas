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




unit SkinImage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
Controls, Forms, Dialogs, 
  ExtCtrls;

type
  TSkinImage = class(TImage)
  private

  protected
    { Protected declarations }
    function BitmapToRegion(bmp: TBitmap) : dword;
    procedure OwnerShow(Sender : TObject);
  public
    constructor Create(AOwner : TComponent); override;
  published
    { Published declarations }
  end;

procedure Register;

var
  Ready : Boolean;

implementation

procedure Register;
begin
  RegisterComponents('Miscelanea', [TSkinImage]);
end;

{ TSkinImage }

constructor TSkinImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if NOT (csDesigning in ComponentState) then
    with TForm(AOwner) do
    begin
      BorderStyle := bsNone;
      Self.Top := 0;
      Self.Left := 0;
      OnShow := OwnerShow;
    end;
end;

function TSkinImage.BitmapToRegion(bmp: TBitmap) : dword;
var ix,iy : integer;    // loop variables
    tc    : TColor;     // transparentColor
    b1    : boolean;    // am looking through "real" pixels (no transparent pixels)
    c1    : cardinal;   // region helper variable
    i1    : integer;    // first position of real pixel
begin
  Result := 0;
  i1 := 0;
  // memory transparent color
  tc := bmp.transparentColor and $FFFFFF;
  with bmp.canvas do
    // scan through all lines
    for iy := 0 to bmp.height - 1 do
    begin
      b1 := False;
      // scan through all pixels in this line
      for ix:=0 to bmp.Width - 1 do
        // did we find the first/last real pixel in a row
        if (pixels[ix, iy] and $FFFFFF <> tc) <> b1 then begin
          // yes, and it was the last pixel,
          //so we can add a line style region...
          if b1 then begin
            c1:=CreateRectRgn(i1,iy,ix,iy+1);
            if result<>0 then
              begin
                // it's not the first region
                CombineRgn(Result, Result, c1, RGN_OR);
                DeleteObject(c1);
                // it's the first region
              end
            else
              Result := c1;
          end else i1 := ix;
          // change mode, looking for the first or last real pixel?
          b1:=not b1;
        end;
      // was the last pixel in this row a real pixel?
      if b1 then begin
        c1:=CreateRectRgn(i1, iy, bmp.width-1, iy+1);
        if (Result <> 0) then
          begin
            CombineRgn(Result, Result, c1, RGN_OR);
            DeleteObject(c1);
          end
        else
          Result := c1;
      end;
    end;
end;

procedure TSkinImage.OwnerShow(Sender: TObject);
var
  Region : HRGN;
begin
  if NOT Ready then
  begin
    Ready := True;
    Region := BitmapToRegion(Picture.Bitmap);
    SetWindowRgn(TForm(Owner).Handle, Region, True);
    DeleteObject(Region);
  end;
end;

initialization
  Ready := False;
end.

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




unit CompControl;
{ ****************************************************************** }
{                                                                    }
{   CompControl.pas                                                  }
{   Por Luiz Quelves da Silva                                        }
{   CCSSIS/CIS-EPM/UNIFESP                                           }
{   01/Agosto/1998                                                   }
{                                                                    }
{ ****************************************************************** }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,extctrls ;

type
  TCompControl = class(TGraphicControl)
  private
    { Private declarations }
  protected
    { Protected declarations }
    FBitMap : TBitMap;
    procedure Paint; override;
    procedure loaded; override;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
  end;

implementation

constructor TCompControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 24;
  Height := 24;
  Visible := false;
  FBitMap := TBitMap.Create;
  if (csDesigning in ComponentState) then
  begin
     try
       FBitMap.LoadFromResourceName(HInstance, classname);
     except
      begin
       try
        FBitMap.LoadFromResourceName(HInstance, 'TCompControl');
       except
       FBitMap.Free;
       end;
      end;
     end;
  end;
end;

procedure TCompControl.Loaded;
begin
  inherited Loaded;
end;

destructor TCompControl.Destroy;
begin
  if Assigned (FBitmap) then
     FBitmap.free;
  inherited Destroy;
end;


procedure TCompControl.Paint;
{
          Metodo para pintar o quadro do bitmap
}
var
  Rect: TRect;
begin
  inherited Paint;
  Width  := 24;
  Height := 24;
  Rect := GetClientRect;
  with Canvas do
  begin
    Brush.Color := clwhite;
    FillRect(Rect);
    Brush.Style := bscross ;
    Font := Self.Font;
    if Assigned (FBitmap) then
       Canvas.StretchDraw(Rect, FBitMap);
  end;
end;



procedure TCompControl.WMSize(var Message: TWMSize);
begin
 Width  := 24;
 Height := 24;
end;

end.

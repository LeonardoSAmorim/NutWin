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




{ ****************************************************************** }
{                                                                    }
{   Delphi component TFnpNEditBlank                                  }
{                                                                    }
{   Derivado do TFnpNumericEdit Fredrik Nordbakke                    }
{                                                                    }
{   Copyright © 1997 by Nutrição DIS-EPM/UNIFESP                     }
{                                                                    }
{ ****************************************************************** }

unit FnpNEditBlank;

interface

uses SysUtils, Classes, Graphics, FnpNumericEdit;

type

   TFnpNEditBlank = class(TFnpNumericEdit)
   private
      FEmpty: Boolean;
      FOldColor : TColor;
      FOldFontColor : TColor;
      FStarted : Boolean;
      procedure SetEmpty(const Value: Boolean);
   protected
      procedure DoEnter; override;
      procedure DoExit; override;
      procedure KeyPress(var Key: Char); override;
      procedure Change; override;
   public
      constructor Create(AOwner: TComponent); override;
   published
      property Empty : Boolean read FEmpty write SetEmpty;
   end;

procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('Medida', [TFnpNEditBlank]);
end;

{ TFnpNEditBlank }

procedure TFnpNEditBlank.Change;
begin
   inherited Change;
   if Empty and ( self.Value <> 0 ) then
      Empty := False;
end;

constructor TFnpNEditBlank.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FOldColor := self.Color;
   FOldFontColor := self.Font.Color;
end;

procedure TFnpNEditBlank.DoEnter;
begin
   if FEmpty then
   begin
      self.Color := FOldColor;
      self.Font.Color := FOldFontColor;
   end;
   inherited DoEnter;
end;

procedure TFnpNEditBlank.DoExit;
begin
   if FEmpty then
   begin
      self.Color := clWhite;
      self.Font.Color := clWhite;
   end;
   inherited DoExit;
end;

procedure TFnpNEditBlank.KeyPress(var Key: Char);
begin
   inherited KeyPress(Key);
   if Empty and ( Key <> #0 ) then
      Empty := False;
end;

procedure TFnpNEditBlank.SetEmpty(const Value: Boolean);
begin
   if Value = FEmpty then
      exit;
   FEmpty := Value;
   if FEmpty then
      begin
//        self.Value := 0;
         FOldColor := self.Color;
         FOldFontColor := self.Font.Color;
         self.Color := clWhite;
         self.Font.Color := clWhite;
         FStarted := True;
      end
   else if FStarted then
      begin
         self.Color := FOldColor;
         self.Font.Color := FOldFontColor;
      end;
end;

end.

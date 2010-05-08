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
{   Delphi component DelayedOpIndicator                              }
{                                                                    }
{   Mostra indicador de demora                                       }
{                                                                    }
{   Copyright © 2000 by DIS-EPM/UNIFESP                              }
{                                                                    }
{ ****************************************************************** }

unit DelayedOpIndicator;

interface

uses Classes, SysUtils, Dialogs, Controls, Forms;

type

   TDelayedOpIndicator = class(TComponent)
   private
   protected
   public
      procedure Start; virtual;
      procedure Finish; virtual;
   published
   end;

   TDelayedOpCursor = class(TDelayedOpIndicator)
   private
      FOldCursor : TStringList;
      FInStart : Boolean;
      FActive: Boolean;
      FWaitCursor: TCursor;
      procedure SetActive(const Value: Boolean);
      procedure SetWaitCursor(const Value: TCursor);
   protected
      procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
      procedure Loaded; override;
   public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Start; override;
      procedure Finish; override;
      function CursorCount : Integer;
   published
      property Active : Boolean read FActive write SetActive;
      property WaitCursor : TCursor read FWaitCursor write SetWaitCursor;
   end;

   TDelayedOpProgressBar = class(TDelayedOpIndicator)
   private
   protected
   public
      procedure Start; override;
      procedure Finish; override;
   published
   end;

procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('Miscelanea', [TDelayedOpCursor]);
end;

{ TDelayedOpCursor }

constructor TDelayedOpCursor.Create(AOwner: TComponent);
begin
   inherited;
   FOldCursor := TStringList.Create;
end;

destructor TDelayedOpCursor.Destroy;
begin
   FOldCursor.Free;
   inherited;
end;

procedure TDelayedOpCursor.Loaded;
begin
   inherited;
end;

procedure TDelayedOpCursor.Notification(AComponent: TComponent; AOperation: TOperation);
begin
   inherited Notification(AComponent, AOperation);
end;

procedure TDelayedOpCursor.SetActive(const Value: Boolean);
begin
   FActive := Value;
end;

procedure TDelayedOpCursor.SetWaitCursor(const Value: TCursor);
begin
   FWaitCursor := Value
end;

procedure TDelayedOpCursor.Start;
begin
   inherited;
   if FActive then
   begin
      FInStart := True;
      FOldCursor.Add( IntToStr( Ord( Screen.Cursor ) ) );
      if ( Screen.Cursor <> FWaitCursor )then
         begin
            Screen.Cursor := FWaitCursor;
         end;
   end;
end;

procedure TDelayedOpCursor.Finish;
begin
   if FActive or FInStart then
      begin
         if ( FOldCursor.Count = 0 ) then
            ShowMessage( 'Não há cursor na pilha para restaurar.' )
         else
            begin
               if Screen.Cursor <> StrToInt( FOldCursor.Strings[FoldCursor.Count - 1] ) then
                  Screen.Cursor := StrToInt( FOldCursor.Strings[FoldCursor.Count - 1] );
               FOldCursor.Delete(FOldCursor.Count - 1);
               FInStart := False;
            end;
      end;
   inherited;
end;

function TDelayedOpCursor.CursorCount: Integer;
begin
   Result := FOldCursor.Count;
end;

{ TDelaiedOpIndicator }

procedure TDelayedOpIndicator.Finish;
begin

end;

procedure TDelayedOpIndicator.Start;
begin

end;

{ TDelayedOpProgressBar }

procedure TDelayedOpProgressBar.Finish;
begin
   inherited;
end;

procedure TDelayedOpProgressBar.Start;
begin
   inherited;
end;

end.

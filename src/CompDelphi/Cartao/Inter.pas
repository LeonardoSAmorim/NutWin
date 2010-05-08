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




unit Inter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type

  IMyInterface = interface
    procedure P1;
    procedure P2;
  end;

  TMyP1P2 = class(TComponent, IMyInterface)
  public
    procedure P1;
    procedure P2;
  end;


  TMyP3P4 = class(TComponent, IMyInterface)
  public
    procedure P1;
    procedure P2;
  end;


  TMyClass = class(TComponent, IMyInterface)

  private
    FMyObject: TComponent;
    FMyInterface: IMyInterface;
    procedure SetMyObject(const Value: TComponent);
  published
    property MyInterface: IMyInterface read FMyInterface write FMyInterface implements IMyInterface;
    property MyObject : TComponent read FMyObject write SetMyObject;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TMyClass]);
  RegisterComponents('CCS-SIS', [TMyP1P2]);
  RegisterComponents('CCS-SIS', [TMyP3P4]);
end;

{ TMyP1P2 }

procedure TMyP1P2.P1;
begin
   showmessage('p1');
end;

procedure TMyP1P2.P2;
begin
   showmessage('p2');
end;

{ TMyClass }

procedure TMyClass.SetMyObject(const Value: TComponent);
begin
  FMyObject := Value;
end;

{ TMyP3P4 }

procedure TMyP3P4.P1;
begin
   showmessage('p3');

end;

procedure TMyP3P4.P2;
begin
   showmessage('p4');

end;

end.

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




{*******************************************************}
{                                                       }
{       Componentes de apoio                            }
{                                                       }
{       Copyright © 1997 by DIS-EPM/UNIFESP             }
{                                                       }
{*******************************************************}

unit BwsrHier;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  THierarchyBrowser = class(TForm)
    OkButton: TButton;
    CancelBtn: TButton;
    procedure OkButtonClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Code: string;
    Description: string;
  end;

var
  HierarchyBrowser : THierarchyBrowser;

implementation

{$R *.DFM}

procedure THierarchyBrowser.OkButtonClick(Sender: TObject);
begin
  Code := '1';
  Description := 'Teste';
  ModalResult := mrOK;
end;

procedure THierarchyBrowser.CancelBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

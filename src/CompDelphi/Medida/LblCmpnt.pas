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

unit LblCmpnt;

interface

uses Classes, DsgnIntf, stdctrls, QRCTRLS, BwsrHier, Forms;

type

   TLabeledComponentsProperty = class(TComponentProperty)
   public
      procedure GetValues(Proc: TGetStrProc); override;
   end;

   THierarchyProperty = class (TStringProperty)
   public
      function GetAttributes : TPropertyAttributes; override;
      procedure Edit; override;
   end;

implementation

procedure TLabeledComponentsProperty.GetValues(Proc: TGetStrProc);
var
   I: Integer;
begin
   with  Designer.Form do
      for I := 0 to ComponentCount -1 do
         if (Components[I] is TCustomEdit) or
            (Components[I] is TCustomLabel)or
            (Components[I] is TCustomComboBox) or
            (Components[I] is TQRLabel) then
            Proc(Components[I].Name);
end;

function THierarchyProperty.GetAttributes: TPropertyAttributes;
begin
   Result := [paDialog];
end;

procedure THierarchyProperty.Edit;
var
   BrowserDialog: THierarchyBrowser;
begin
   BrowserDialog := THierarchyBrowser.Create(Application);
   if BrowserDialog.ShowModal <> 0 then
      SetStrValue (BrowserDialog.Description);
end;

end.

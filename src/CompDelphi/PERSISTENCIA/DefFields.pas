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




unit DefFields;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons;

type
  TFrmDefFields = class(TForm)
    SeFieldLen: TSpinEdit;
    CbFieldType: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    BBOk: TBitBtn;
    BBCancel: TBitBtn;
    SeFieldLen2: TSpinEdit;
    EdField: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    CbKeyType: TComboBox;
    Label5: TLabel;
    CHBWhere: TCheckBox;
    CHBOrder: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
    FListaTypeLen : TStrings;
    constructor Create(AOWner : TComponent); override;
    destructor destroy; override;
  end;

var
  FrmDefFields: TFrmDefFields;

implementation

{$R *.DFM}

{ TFrmDefFields }

constructor TFrmDefFields.Create(AOWner: TComponent);
begin
   inherited create(AOWner);
   FListaTypeLen := TStringList.Create;

end;

destructor TFrmDefFields.destroy;
begin
   FListaTypeLen.Free;
   inherited destroy;
end;

end.

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




unit UCadMed;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, DBCtrls, Grids, DBGrids, ExtCtrls, DBMyNav, db;

type
  TfmCadMed = class(TForm)
    bbOk: TBitBtn;
    bbCancela: TBitBtn;
    Label7: TLabel;
    Label12: TLabel;
    dbMedida: TDBEdit;
    DBMyNav4: TDBMyNav;
    DBGrid10: TDBGrid;
    procedure bbOkClick(Sender: TObject);
    procedure bbCancelaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCadMed: TfmCadMed;

implementation

uses DMMedidas, Alimento;

{$R *.DFM}

procedure TfmCadMed.bbOkClick(Sender: TObject);
begin
   // Verifico se o campo está em branco. Caso esteja, não deixo prosseguir
   if  dbMedida.Text = '' then
       begin
         ShowMessage('Nome da Medida Inválido.');
         dbMedida.SetFocus;
       end
   else
       begin
         // Se cadastrou uma nova medida, já atribuo ao campo
            if (DMedidas.TbMedidas.State = dsInsert) or  (DMedidas.TbMedidas.State = dsEdit) then
               begin
                DMedidas.TbMedidas.Post ;
                DMedidas.TBMedidasCaseiras.FieldByName('IDMEDCAS').asString :=
                         DMedidas.TbMedidas.FieldByName('IDMEDCAS').asString ;
               end;
           ModalResult := mrOk ;

       end;

end;

procedure TfmCadMed.bbCancelaClick(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TfmCadMed.FormShow(Sender: TObject);
begin
   DMedidas.TbMedidas.Insert;
   dbMedida.SetFocus;

end;

end.

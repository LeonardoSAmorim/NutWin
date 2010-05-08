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




unit UPrinc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, NutCnst, Grids, DBGrids;

type
  TfmTelaPrincipal = class(TForm)
    paOpcaoInicial: TPanel;
    Label1: TLabel;
    rgOpcaoInicial: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure rgOpcaoInicialClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmTelaPrincipal: TfmTelaPrincipal;

implementation

uses DMPesq, Pessoa;

{$R *.DFM}

procedure TfmTelaPrincipal.FormCreate(Sender: TObject);
begin
 // Crio um codigo que vai acompanhar toda a pesquisa e depois ser destruído
    DMPesquisa.stCodigoControleUsuario := CreateNewGUID;
    DMPesquisa.stOpcaoSelecaoInicial := '1'; // inicialmente seto como selecão de individuos
    if DMPesquisa.Sequencia = 'Pesquisa' then        // Antropometria
       Tag := 1
    else
       Tag := 2;                                     // Inquerito
end;

procedure TfmTelaPrincipal.rgOpcaoInicialClick(Sender: TObject);
begin
    DMPesquisa.TbPessoa.Refresh;
    DMPesquisa.TbPessoabk.Refresh;
    DMPesquisa.TbCadPastas.Refresh;
    DMPesquisa.TbPastas.Refresh;

    if (DMPesquisa.TbCadPastasbk.RecordCount = 0) and (rgOpcaoInicial.ItemIndex = 0) then
       begin
        ShowMessage('Não temos Indivíduos associados com Pastas.');
        rgOpcaoInicial.ItemIndex := 1;
       end
    else if rgOpcaoInicial.ItemIndex = 0 then
       begin
       DMPesquisa.stOpcaoSelecaoInicial := OP_PASTAS;
       Tag := 0;
       end
    else if DMPesquisa.Sequencia = 'Pesquisa' then
       begin
       DMPesquisa.stOpcaoSelecaoInicial := OP_PESSOAS;
       Tag := 1;
       end
    else if DMPesquisa.Sequencia = 'PesqInq' then
       begin
       DMPesquisa.stOpcaoSelecaoInicial := OP_INQUERITOS;
       Tag := 2;
       end;
    Click;

end;

end.

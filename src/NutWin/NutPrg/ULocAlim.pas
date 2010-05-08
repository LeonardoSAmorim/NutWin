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




unit ULocAlim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Tabs, Grids, DBGrids, StdCtrls, ExtCtrls, DBMyNav, Db, CAlimento,
  CCSListaLinks, CCSDBListaLinks, CLstAli, Menus, SelGruAli, SelAliOrg, SelNut,
  NutCnst, DMAliPrep, Buttons;

type
  TfmLocAlim = class(TForm)
    Panel1: TPanel;
    laPesqAli: TLabel;
    edNav: TEdit;
    grAli: TDBGrid;
    TsNav: TTabSet;
    nvAlim: TDBMyNav;
    puListaAlimento: TPopupMenu;
    Ordenarpor1: TMenuItem;
    Nome1: TMenuItem;
    Nutriente1: TMenuItem;
    MedidaPoro1: TMenuItem;
    Preo1: TMenuItem;
    Frequenciadeuso1: TMenuItem;
    Sentidodaordenao1: TMenuItem;
    Ascendente1: TMenuItem;
    Decrescente1: TMenuItem;
    N2: TMenuItem;
    Filtrarpor1: TMenuItem;
    GrupoAlimentar1: TMenuItem;
    Origem1: TMenuItem;
    mnSeparador1: TMenuItem;
    Restaurardefaults1: TMenuItem;
    sbFiltrar: TSpeedButton;
    sbLocalizar: TSpeedButton;
    btLocAlim: TButton;
    btLocCan: TButton;
    procedure FormShow(Sender: TObject);
    procedure edNavChange(Sender: TObject);
    procedure TsNavChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure grAliTitleClick(Column: TColumn);
    procedure puListaAlimentoPopup(Sender: TObject);
    procedure Ascendente1Click(Sender: TObject);
    procedure Decrescente1Click(Sender: TObject);
    procedure Nome1Click(Sender: TObject);
    procedure Frequenciadeuso1Click(Sender: TObject);
    procedure GrupoAlimentar1Click(Sender: TObject);
    procedure Origem1Click(Sender: TObject);
    procedure grAlimentoKeyPress(Sender: TObject; var Key: Char);
    procedure Nutriente1Click(Sender: TObject);
    procedure Restaurardefaults1Click(Sender: TObject);
    procedure sbFiltrarClick(Sender: TObject);
    procedure sbLocalizarClick(Sender: TObject);
    procedure grAliEnter(Sender: TObject);
    procedure edNavKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FIDAliEscolhido: string;
    { Private declarations }
    procedure MontaTitulo;
    procedure SetIDAliEscolhido(const Value: string);
  public
    { Public declarations }
    property IDAliEscolhido: string read FIDAliEscolhido write SetIDAliEscolhido;
    procedure RestauraDefaults;
    procedure TrocaTipoOrdem;
  end;

var
  fmLocAlim: TfmLocAlim;

implementation

uses Alimento, DMMBoard;

{$R *.DFM}

procedure TfmLocAlim.FormShow(Sender: TObject);
begin
  RestauraDefaults;
end;

procedure TfmLocAlim.edNavChange(Sender: TObject);
var
  SalvaCursor: TCursor;
begin
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }
  try
    if sbFiltrar.Down then
    begin
      dmMotherBoard.ListaAlimento.FiltrarDoInicio := False;
      dmMotherBoard.ListaAlimento.FiltrarNomeAlimento := edNav.Text;
      TsNav.Visible := False;
    end
    else
    begin
      if dmMotherBoard.ListaAlimento.FiltrarNomeAlimento <> '' then
        dmMotherBoard.ListaAlimento.FiltrarNomeAlimento := '';
      dmMotherBoard.ListaAlimento.LocalizaNomeAlimento := edNav.Text;
      if dmMotherBoard.ListaAlimento.OrdenarAlimentoPor = oaNome then
        TsNav.Visible := True;
    end;
  finally
    Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  end;
end;

procedure TfmLocAlim.TsNavChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  AllowChange := dmMotherBoard.ListaAlimento.Localizar(TsNav.Tabs.Strings[NewTab], [loCaseInsensitive, loPartialKey]);
end;

procedure TfmLocAlim.FormCreate(Sender: TObject);
var
  SalvaCursor: TCursor;
begin
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }
  try
    grAli.DataSource := dmMotherBoard.dsLstAli;
  finally
    Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  end;
end;

//----------------------------------------------------------------------

procedure TfmLocAlim.grAliTitleClick(Column: TColumn);
begin
  TrocaTipoOrdem;
end;

procedure TfmLocAlim.puListaAlimentoPopup(Sender: TObject);
begin
  with dmMotherBoard.ListaAlimento do
  begin
    Ascendente1.Checked := (TipoDeOrdem = toCrescente);
    Decrescente1.Checked := (TipoDeOrdem = toDecrescente);
    Nome1.Checked := (OrdenarAlimentoPor = oaNome);
    Nutriente1.Checked := (OrdenarAlimentoPor = oaNutrientes);
    Frequenciadeuso1.Checked := (OrdenarAlimentoPor = oaFrequenciaUso);
    GrupoAlimentar1.Checked := FiltrarPorGrupoAlimentar;
    Origem1.Checked := FiltrarPorOrigem;
    MontaTitulo;
  end;
end;

procedure TfmLocAlim.Ascendente1Click(Sender: TObject);
begin
  if not Ascendente1.Checked then
    TrocaTipoOrdem;
end;

procedure TfmLocAlim.Decrescente1Click(Sender: TObject);
begin
  if not Decrescente1.Checked then
    TrocaTipoOrdem;
end;

procedure TfmLocAlim.Nome1Click(Sender: TObject);
var
  SalvaCursor: TCursor;
begin
  if not Nome1.Checked then
  begin
    SalvaCursor := Screen.Cursor; { Salva cursor atual }
    Screen.Cursor := crHourglass; { Mostra ampulheta }
    try
      dmMotherBoard.ListaAlimento.OrdenarAlimentoPor := oaNome;
    finally
      Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
    end;
    TsNav.Visible := True;
    grAli.Columns[0].Width := 450;
    grAli.Columns[1].Width := 0;
  end;
end;

procedure TfmLocAlim.Frequenciadeuso1Click(Sender: TObject);
var
  SalvaCursor: TCursor;
begin
  if not Frequenciadeuso1.Checked then
  begin
    SalvaCursor := Screen.Cursor; { Salva cursor atual }
    Screen.Cursor := crHourglass; { Mostra ampulheta }
    try
      dmMotherBoard.ListaAlimento.OrdenarAlimentoPor := oaFrequenciaUso;
    finally
      Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
    end;
    TsNav.Visible := False;
    grAli.Columns[0].Width := 350;
    grAli.Columns[1].Width := 100;
    grAli.Columns[1].Title.Caption := 'Freq. Uso';
  end;
end;

procedure TfmLocAlim.GrupoAlimentar1Click(Sender: TObject);
var
  F: TfmSelGruAli;
  SalvaCursor: TCursor;
begin
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }
  try
    dmMotherBoard.ListaAlimento.FiltrarPorGrupoAlimentar := True;
  finally
    Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  end;
  F := TfmSelGruAli.Create(Self);
  F.ShowModal;
  if F.ModalResult = mrCancel then
    dmMotherBoard.ListaAlimento.FiltrarPorGrupoAlimentar := False;
  F.Free;
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }
  try
    dmMotherBoard.ListaAlimento.Refresh;
  finally
    Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  end;
  MontaTitulo;
end;

procedure TfmLocAlim.Origem1Click(Sender: TObject);
var
  F: TfmAliOrigem;
  SalvaCursor: TCursor;
begin
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }
  try
    dmMotherBoard.ListaAlimento.FiltrarPorOrigem := True;
  finally
    Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  end;
  F := TfmAliOrigem.Create(Self);
  F.ShowModal;
  if F.ModalResult = mrCancel then
    dmMotherBoard.ListaAlimento.FiltrarPorOrigem := False;
  F.Free;
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }
  try
    dmMotherBoard.ListaAlimento.Refresh;
  finally
    Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  end;
  MontaTitulo;
end;

procedure TfmLocAlim.grAlimentoKeyPress(Sender: TObject; var Key: Char);
begin
  dmMotherBoard.ListaAlimento.Localizar(Key, [loCaseInsensitive, loPartialKey]);
end;

procedure TfmLocAlim.Nutriente1Click(Sender: TObject);
var
  F: TfmSelNutriente;
  SalvaCursor: TCursor;
begin
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }
  try
    dmMotherBoard.ListaAlimento.OrdenarAlimentoPor := oaNutrientes;
  finally
    Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  end;
  F := TfmSelNutriente.Create(Self);
  F.ShowModal;
  if F.ModalResult = mrCancel then
    dmMotherBoard.ListaAlimento.OrdenarAlimentoPor := oaNome;
  F.Free;
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }
  try
    dmMotherBoard.ListaAlimento.Refresh;
  finally
    Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  end;
  if dmMotherBoard.ListaAlimento.OrdenarAlimentoPor = oaNutrientes then
  begin
    TsNav.Visible := False;
    grAli.Columns[0].Width := 350;
    grAli.Columns[1].Width := 100;
    with dmMotherBoard.ListaAlimento.IDNutriente.DataSet do
      grAli.Columns[1].Title.Caption := FieldByName('NOMENUT').AsString + ' (' +
        FieldByName('UNIDADE').AsString + ')';
  end;
end;

procedure TfmLocAlim.Restaurardefaults1Click(Sender: TObject);
begin
  RestauraDefaults;
end;

procedure TfmLocAlim.sbFiltrarClick(Sender: TObject);
begin
  edNavChange(Sender);
  edNav.SetFocus;
end;

procedure TfmLocAlim.sbLocalizarClick(Sender: TObject);
begin
  edNavChange(Sender);
  edNav.SetFocus;
end;

procedure TfmLocAlim.TrocaTipoOrdem;
var
  SalvaCursor: TCursor;
begin
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }
  try
    with dmMotherBoard.ListaAlimento do
      if TipoDeOrdem = toCrescente then
        TipoDeOrdem := toDecrescente
      else
        TipoDeOrdem := toCrescente;
  finally
    Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  end;
end;

procedure TfmLocAlim.MontaTitulo;
var
  Separador: string;
begin
  with dmMotherBoard.ListaAlimento do
  begin
    grAli.Columns[0].Title.Caption := '';
    if FiltrarPorGrupoAlimentar then
    begin
      grAli.Columns[0].Title.Caption := grAli.Columns[0].Title.Caption +
        IDGrupoAlimentar.DataSet.FieldByName('NOMEGRU').AsString;
      Separador := '; ';
    end
    else
      Separador := '';
    if FiltrarPorOrigem then
      grAli.Columns[0].Title.Caption := grAli.Columns[0].Title.Caption +
        Separador + IDOrigem.DataSet.FieldByName('DESCRICAO').AsString;
    if grAli.Columns[0].Title.Caption = '' then
      grAli.Columns[0].Title.Caption := 'ALIMENTO';
  end;

end;

procedure TfmLocAlim.RestauraDefaults;
var
  SalvaCursor: TCursor;
begin
  SalvaCursor := Screen.Cursor; { Salva cursor atual }
  Screen.Cursor := crHourglass; { Mostra ampulheta }
  try
    dmMotherBoard.ListaAlimento.DefineDefaults;
    edNav.Text := '';
    sbLocalizar.Down := True;
    MontaTitulo;
    grAli.Columns[0].Width := 450;
    grAli.Columns[1].Width := 0;
    TsNav.Visible := True;
    TsNav.TabIndex := 0;
    edNav.SetFocus;
    dmMotherBoard.ListaAlimento.Refresh;
  finally
    Screen.Cursor := SalvaCursor; { Sempre retorna ao normal }
  end;
end;

procedure TfmLocAlim.grAliEnter(Sender: TObject);
begin
  if not sbFiltrar.Down then
    edNav.Text := '';
end;

procedure TfmLocAlim.edNavKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) or (Key = VK_UP) then
    grAli.SetFocus;
end;

procedure TfmLocAlim.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  // só porque o componente ListaAli não está funcionando direito
  FIDAliEscolhido := grAli.DataSource.DataSet.FieldByName('IDALI').AsString;
end;

procedure TfmLocAlim.SetIDAliEscolhido(const Value: string);
begin
  FIDAliEscolhido := Value;
end;

end.


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




unit Antrop01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Spin, ObjVis, PAINELMEDIDA, VisorCal, Measurement,
  checklst,DMMBoard, ImgList, ComCtrls, MemoriaViewer, GlueAntrop, Wizard, NutCnst;

type
  TfmAntrop02 = class(TForm)
    paAntropMedidas: TPanel;
    gbAntropMedidas: TGroupBox;
    sbCorpoAjuda: TSpeedButton;
    sbCorpoAdipometro: TSpeedButton;
    sbCorpoFitaMetrica: TSpeedButton;
    sbCorpoAnterior: TSpeedButton;
    sbCorpoProximo: TSpeedButton;
    pmAntropMedidas: TPainelMedida;
    laAntropUnidade: TLabel;
    edAntropValor: TEdit;
    vcAntrop02: TVisorCalculo;
    ovCorpoHumano: TObjetoVisual;
    laAntropDescricao: TLabel;
    AntropInputControl1: TAntropInputControl;
    lvAntropMedidas: TListView;
    ImageList1: TImageList;
    procedure sbCorpoAnteriorClick(Sender: TObject);
    procedure sbCorpoProximoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbCorpoAjudaClick(Sender: TObject);
    procedure edAntropValorExit(Sender: TObject);
    procedure edAntropValorKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses fmHpAntrop;

//uses DMMBoard;

{$R *.DFM}


procedure TfmAntrop02.sbCorpoAnteriorClick(Sender: TObject);
begin
   // Volta uma vista (frame)
   ovCorpoHumano.RetrocedeVista;
   AntropInputControl1.IndicaMedidasVista;
end;

procedure TfmAntrop02.sbCorpoProximoClick(Sender: TObject);
begin
   // Avanca uma vista (frame)
   ovCorpoHumano.AvancaVista;
   AntropInputControl1.IndicaMedidasVista;
end;


procedure TfmAntrop02.FormShow(Sender: TObject);
begin
//   if dmMotherBoard.CriaListaMedidasUsadas( 'cxcaAntrop', 'mdMedidasAntropUsadas' ) then
//      ShowMessage( 'Apaguei medidas' );
   // Configurando componente corpo humano
{   with ovCorpoHumano.Corpo do
   begin
      // Inicializa Corpo humano
      DataSourceName := 'DBCalcNut';
      // Verifica o sexo e seta a figura correspondente
      if dmMotherBoard.caProcessador.Memoria.Acha( 'mdSexo', TObject( mdMed ) ) then
         begin
            if mdMed.ValorNumerico = 'Masculino' then
               NomeObjetoVisual := 'MADULTO'
            else
               NomeObjetoVisual := 'FADULTO';
         end
      else
         // Veja se ela foi criada na memoria.
         ShowMessage( 'Erro: a medida mdSexo não existe! - TfmAntrop02.FormShow' );
      Active := True;}
//      SelecionaPontosCalculo (dmMotherBoard.caProcessador.ListaParametro);

      ovCorpoHumano.AtualizaVista;

{      // Verifica se tem alguma medida para entrar
      if ovCorpoHumano.Corpo.PontosSensiveisPorFace.Count = 0 then
         begin
            paAntropMedidas.Enabled := False;
            ShowMessage( 'Não há medidas para serem digitadas para os cálculos ' +
                         'escolhidos. Pode clicar em terminar para calculá-los.' );
         end
      else
         paAntropMedidas.Enabled := True;

   end;
}   // Outra configuracoes
   with dmMotherBoard.caProcessador do
   begin
      // Limpa medida de entrada (painel e controls)
      pmAntropMedidas.NomeMedida := '';
      pmAntropMedidas.Medida := nil;
      TEdit( pmAntropMedidas.EntradaNumerica ).Text := '';
      TLabel( pmAntropMedidas.EntradaDeUnidade ).Caption := '';
      TLabel( pmAntropMedidas.SaidaDescricao ).Caption := '';
      // Monta lista de medidas para vista corrente
      AntropInputControl1.Refresh(self);
      AntropInputControl1.IndicaMedidasVista;

   end;
lvAntropMedidas.Items[0].Selected:=True;
lvAntropMedidas.SetFocus;
edAntropValorExit(Sender);
end;


procedure TfmAntrop02.FormCreate(Sender: TObject);
begin
   // Forca esta referencia, pois vive perdendo
   vcAntrop02.Calculo := dmMotherBoard.caProcessador;
   Tag:=0;
end;



procedure TfmAntrop02.sbCorpoAjudaClick(Sender: TObject);
var
   F : TfmHelpAntrop;
begin
  // dependendo da medida selecionada, ativar o link correto
//  Application.HelpCommand(HELP_FINDER, 0);
   F := TfmHelpAntrop.Create(self);
   F.diFotoMedAntrop.DataSource := ovCorpoHumano.Corpo.DMOV.dsAreaClick;
   F.diFotoMedAntrop.DataField := 'AVI';
   F.drDescMedAntrop.DataSource := ovCorpoHumano.Corpo.DMOV.dsAreaClick;
   F.drDescMedAntrop.DataField := 'INSTRUCOES';
   ovCorpoHumano.Corpo.DMOV.taAreaClick.Locate( 'OVAREA', pmAntropMedidas.Medida.Name, [] );
   if F.diFotoMedAntrop.Picture.Graphic.Empty then
    begin
      F.diFotoMedAntrop.Visible := False;
      F.drDescMedAntrop.Height := 200;
    end
   else
    begin
      F.diFotoMedAntrop.Visible := True;
      F.drDescMedAntrop.Height := 80;
    end;
   F.ShowModal;
   F.Free;
end;

procedure TfmAntrop02.edAntropValorExit(Sender: TObject);
begin
   //Acerta os botoes do wizard
   if AntropInputControl1.TemMedidaVazia or
      AntropInputControl1.TemMedidaInvalida then
      // alguma medida está vazia, não dá para terminar
      Tag:=WZ_INVALIDNODE
   else
      // ok, pode terminar
      self.Tag:=0;
   //Refresh do Wizard, que esta conectado no OnClick
   Click;
end;

procedure TfmAntrop02.edAntropValorKeyPress(Sender: TObject;
  var Key: Char);
begin
   NumericoPositivoKeyPress( edAntropValor.Text, Key );
end;

end.

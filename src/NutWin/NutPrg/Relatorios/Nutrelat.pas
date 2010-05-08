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




unit NutRelat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, quickrpt, Grids, DBGrids, checklst, DBCtrls, db,
  DBCGrids, NutCnst ;

type
  TfmRelatorios = class(TForm)
    pgcRelatorio: TPageControl;
    tbsRelAlimentos: TTabSheet;
    rgTipo: TRadioGroup;
    rgListagem: TRadioGroup;
    gbPesqAli: TGroupBox;
    btPrev: TButton;
    edPesqAli: TEdit;
    grPesqAli: TDBGrid;
    tbsTabAlim: TTabSheet;
    paTabAli: TPanel;
    gbFichaAli: TGroupBox;
    clFichaAli: TCheckListBox;
    btPrevTab: TButton;
    btFechar: TButton;
    btFecharTA: TButton;
    tbsSubstitutos: TTabSheet;
    Panel1: TPanel;
    rgSubs: TRadioGroup;
    clSubsCal: TCheckListBox;
    btVisEquiv: TButton;
    brFecharEquiv: TButton;
    grSProt: TDBGrid;
    btImprimir: TButton;
    btImpTab: TButton;
    btImpEquiv: TButton;
    clTabAli: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qrCompAliFichaAddReports(Sender: TObject);
    procedure btPrevClick(Sender: TObject);
    procedure rgTipoClick(Sender: TObject);
    procedure edPesqAliChange(Sender: TObject);
    procedure btPrevTabClick(Sender: TObject);
    procedure btVisEquivClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btFecharClick(Sender: TObject);
    procedure btFecharTAClick(Sender: TObject);
    procedure brFecharEquivClick(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure btImpTabClick(Sender: TObject);
    procedure btImpEquivClick(Sender: TObject);

  private
    { Private declarations }
    FReport  : TQuickRep ;
    Lista    : TStringList;
    procedure SetReport(Value : TQuickRep);
    function ConfigRelAli : Boolean;
    function ConfigRelTabAli : Boolean;
    function ConfigRelEqu : Boolean;
  public
    { Public declarations }
     property Report : TQuickRep read FReport write SetReport;
//     procedure DesabBandasPess ;
     procedure DesabBandasAli ;
     procedure LimpaMemoriaAlim;
//     procedure CriaRelPessoa;
     procedure CriaRelAlimentos;
     procedure CriaRelTabAlim;
     procedure CriaRelTotais;
     function BuscaComponente( NomeComponente : string ) : boolean ;

  end;

var
  fmRelatorios: TfmRelatorios;

implementation

uses DMRelat, URelAliNut, URelAliMed, UAliSubsCal,
  UAliOrdAlf, UAliOrdGAli, UAliOrigem, UAliFicha,  URelTAli,
  URTAGCal, URTANut, URTAMCas, URTAOrigem, URTASCal, DMRelPess, URelPesList, DMRelMed, DMRElNut, DMRelPrAli, DMRelSuCal,
  RelTot, RelSCal, URelSProt, URTAGPro, URTASProt;

{$R *.DFM}

procedure TfmRelatorios.DesabBandasAli;
// desabilita todas as faixas do relatorio para facilitar a configuracao.
begin
   with fmAliFicha do
     begin
       qbAlim.Enabled     := False;
       qbTitMed.Enabled   := False;
       qbAliMed.Enabled   := False;
       qbTitNut.Enabled   := False;
       qbAliNut.Enabled   := False;
       qbTitSCal.Enabled  := False;
       qbSubsCal.Enabled  := False;
       qbTitPreco.Enabled := False;
       qbAliPreco.Enabled := False;
     end;

end;

procedure TfmRelatorios.CriaRelTotais;
begin
end;

function TfmRelatorios.BuscaComponente( NomeComponente : string ) : boolean ;
begin
   // Verifica se o componente ja' existe na aplicacao
   if Application.FindComponent( NomeComponente ) = nil then
      Result := False
   else
      Result := True;
end;

procedure TfmRelatorios.CriaRelAlimentos;
begin
   // cria datamodulos
//   DmRelatAli      := TDMRelatAli.Create(self);
//   DMRelMedidas    := TDMRelMedidas.Create(self);
//   DMRelNutrientes := TDMRelNutrientes.Create(self);
//   DmRelPreco      := TDMRelPreco.Create(self);
//   DMRelSCal       := TDMRelSCal.Create(self);
   // cria relatorios
//   fmAliFicha      := TfmAliFicha.Create(self);
//   fmAliOrdAlf     := TfmAliOrdAlf.Create(self);
//   fmAliOrdGAli    := TfmAliOrdGAli.Create(self);
//   fmRlAliOrigem   := TfmRlAliOrigem.Create(self);
//   fmRelTotAli  := TfmRelTotAli.Create(self);
//   fmRelSProt := TfmRelSProt.Create(self);
//   fmRelSCal := TfmRelSCal.Create(self);
end;

procedure TfmRelatorios.CriaRelTabAlim;
begin
//   fmRTAGAli    := TfmRTAGAli.Create( self );
//   fmRTAGCal    := TfmRTAGCal.Create( self );
//   fmRTANut     := TfmRTANut.Create( self );
//   fmRTAMCas    := TfmRTAMCas.Create( self );
//   fmRTAOrigem  := TfmRTAOrigem.Create( self );
//   fmRTASCal    := TfmRTASCal.Create( self );

end;

procedure TfmRelatorios.LimpaMemoriaAlim ;
begin
   // liberando os relatorios da memoria
   if fmAliFicha <> nil then
      FreeAndNil(fmAliFicha);
   if fmAliOrdAlf <> nil then
      FreeAndNil(fmAliOrdAlf);
   if fmAliOrdGAli <> nil then
      FreeAndNil(fmAliOrdGAli);
   if fmRlAliOrigem <> nil then
      FreeAndNil(fmRlAliOrigem);
//   if fmRelAli <> nil then
//      FreeAndNil(fmRelAli);
   if fmRelAliSubs <> nil then
      FreeAndNil(fmRelAliSubs);
   if fmRelTotAli <> nil then
      FreeAndNil(fmRelTotAli);
   if fmRTAGAli <> nil then
      FreeAndNil(fmRTAGAli);
   if fmRTAGCal <> nil then
      FreeAndNil(fmRTAGCal);
   if fmRTAGPro <> nil then
      FreeAndNil(fmRTAGPro);
   if fmRTANut <> nil then
      FreeAndNil(fmRTANut);
   if fmRTAMCas <> nil then
      FreeAndNil(fmRTAMCas);
   if fmRTAOrigem <> nil then
      FreeAndNil(fmRTAOrigem);
   if fmRelSProt <> nil then
      FreeAndNil(fmRelSProt);
   if fmRelSCal <> nil then
      FreeAndNil(fmRelSCal);
   if fmRTASCal <> nil then
      FreeAndNil(fmRTASCal);
   if fmRTASProt <> nil then
      FreeAndNil(fmRTASProt);
   Report := nil;

 {
   // liberando os datamodules
   DMRelatAli.free;
   DMRelMedidas.free;
   DMRelNutrientes.free;
//   DMRelPessoa.free;
   DMRelPreco.free;
   DMRelSCal.free;
  }
end;

procedure TfmRelatorios.SetReport(Value : TQuickRep);
begin
  FReport:=Value;
end;

procedure TfmRelatorios.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   DmRelatAli.free;
   DMRelMedidas.free;
   DMRelNutrientes.free;
   DmRelPreco.free;
   DMRelSCal.free;

   Lista.Free;

   LimpaMemoriaAlim;

 //  Action := caFree;
end;

procedure TfmRelatorios.qrCompAliFichaAddReports(Sender: TObject);
 begin
{  with qrCompAliFicha do
  begin
    // adiciono sempre este cabecalho
    Reports.Add(fmRelAli.qrAli);
    if fmRelatorios.ckRelAliNut.Checked then
       // se quero nutrientes ...
       Reports.Add(fmRelAliNut.qrRelAliNut);
    if fmRelatorios.ckRelAliMed.checked then
       // se quero medidas caseiras ...
       Reports.Add(fmRelAliMed.qrRelAliMed);
    if fmRelatorios.ckRelAliSubs.checked then
       // se quero substitutos calóricos ...
       Reports.Add(fmRelAliSubs.qrRelAliSubs);
    Reports.Add(fmRelAliRod.qrRelAliRod);

  end;}
 end;

procedure TfmRelatorios.btPrevClick(Sender: TObject);
begin
Screen.Cursor := crHourGlass;

   if ConfigRelAli then
      begin
         try
          Report.PreviewModal;
         finally
          LimpaMemoriaAlim; // dá um free em vários itens
         end;
      end;
 Screen.Cursor := crDefault;
end;

procedure TfmRelatorios.rgTipoClick(Sender: TObject);
begin
   // se for ficha
   if rgTipo.ItemIndex = 0 then
      begin
       // gbFicha.Enabled := HabilitaFicha(True);
        rgListagem.Visible := False;
        gbPesqAli.Visible  := True ;
        gbFichaAli.Visible := True ;
        //Report := CompositeReport;
//        Application.CreateForm(TfmAliFicha, fmAliFicha);
//        Report := fmAliFicha.Report;
      end
   else if rgTipo.ItemIndex = 1 then
      begin
        //gbFicha.Enabled := HabilitaFicha(False) ;
        rgListagem.Visible := True;
        gbPesqAli.Visible  := False ;
        gbFichaAli.Visible := False ;
//        Report := nil ;
      end
   else
      begin                      // Listagem
        rgListagem.Visible := False;
        gbPesqAli.Visible  := False ;
        gbFichaAli.Visible := False ;
//        Application.CreateForm(TfmRelTotAli, fmRelTotAli);
//        Report := fmRelTotAli.Report;
      end

end;


procedure TfmRelatorios.edPesqAliChange(Sender: TObject);
begin
   DMRelatAli.TbAlim.Locate('Nome', edPesqAli.Text, [loPartialKey] );

end;

procedure TfmRelatorios.btPrevTabClick(Sender: TObject);
begin
    Screen.Cursor := crHourGlass;
    if ConfigRelTabAli then
      begin
         try
          Report.PreviewModal;
         finally
          LimpaMemoriaAlim; // dá um free em vários itens
         end;
      end;
    Screen.Cursor := crDefault;
end;

procedure TfmRelatorios.btVisEquivClick(Sender: TObject);
begin
   Screen.Cursor := crHourGlass;
      if rgSubs.ItemIndex = 0 then // Equivalentes de Energia
         begin
          DMRelSCAl.qrSubsCal.Close;
          DMRelSCAl.qrSubsCal.Open;
        end
      else
         begin
          DMRelSCAl.qrSubsProt.Close;  // Equivalente de Proteina
          DMRelSCAl.qrSubsProt.Open;
         end;


      if ConfigRelEqu then
         begin
         try
          Report.PreviewModal;
         finally
          LimpaMemoriaAlim; // dá um free em vários itens
         end;
         end;
//      DMRelSCal.TbAliGProtbk.Filtered := False;
//      DMRelSCal.TbAliGCalbk.Filtered := False;
   Screen.Cursor := crDefault;

end;

procedure TfmRelatorios.FormCreate(Sender: TObject);
var
//  nI : integer;
//  cod : string;
  stGrupo : string ;
  Controle : boolean;
begin

   pgcRelatorio.ActivePage := tbsRelAlimentos;
   DmRelatAli   := TDmRelatAli.Create(self);
   DMRelMedidas := TDMRelMedidas.Create(self);
   DMRelNutrientes := TDMRelNutrientes.Create(self);
   DmRelPreco      := TDmRelPreco.Create(self);
   DMRelSCal       := TDMRelSCal.Create(self);

   controle := True;
   stGrupo := '';
   Lista := TStringList.create;
   Lista.Clear;
   clSubsCal.Items.Clear;
   DMRelSCAl.TbGruCal.First;
   while controle do
   begin
     // adiciona no checklist e no stringlist
     clSubsCal.Items.Add( DMRelSCAl.TbGruCal.Fieldbyname('NOME').asString );
     Lista.Add( DMRelSCAl.TbGruCal.Fieldbyname('IDGRUCAL').asString );
     DMRelSCAl.TbGruCal.Next;
     if DMRelSCAl.TbGruCal.Eof then
        Controle := False;
    end;
end;

procedure TfmRelatorios.btFecharClick(Sender: TObject);
begin
   if ( Report <> nil ) and ( Report.Printer <> nil ) and ( Report.Printer.ShowingPreview ) then
   begin
      ShowMessage( 'Feche a visualização atual para poder fechar esta janela' );
      exit;
   end;
   Close;
end;

procedure TfmRelatorios.btFecharTAClick(Sender: TObject);
begin
   if ( Report <> nil ) and ( Report.Printer <> nil ) and ( Report.Printer.ShowingPreview ) then
   begin
      ShowMessage( 'Feche a visualização atual para poder fechar esta janela' );
      exit;
   end;

  Close;
end;

procedure TfmRelatorios.brFecharEquivClick(Sender: TObject);
begin
   if ( Report <> nil ) and ( Report.Printer <> nil ) and ( Report.Printer.ShowingPreview ) then
   begin
      ShowMessage( 'Feche a visualização atual para poder fechar esta janela' );
      exit;
   end;
   DMRelSCAl.qrSubsCal.Close;
   DMRelSCAl.qrSubsProt.Close;

   Close;
end;

function TfmRelatorios.ConfigRelAli: Boolean;
var
  Config : string;
begin
   Result := True;

   if ( Report <> nil ) and ( Report.Printer <> nil ) and ( Report.Printer.ShowingPreview ) then
   begin
      ShowMessage( 'Feche a visualização atual para poder fechar esta janela' );
      Result := False;
      exit;
   end;

   // se for ficha
   if rgTipo.ItemIndex = 0 then  // Ficha Alimentar
      begin
      if fmAliFicha = nil then
         fmAliFicha := TfmAliFicha.Create(self);
      Report := fmAliFicha.Report; 
      Config  := 'IDALI = ''' + DMRelatAli.TbAlimIDALI.asString  + '''' ;
      DMRelatAli.TbAlim.Filter   := Config ;
      DMRelatAli.TbAlim.Filtered := True;
      fmRelatorios.DesabBandasAli;
      if clFichaAli.Checked[0] then        // dados alimentares
           fmAliFicha.qbAlim.Enabled := True ;
      if clFichaAli.Checked[1] then        //  medidas caseiras
           begin
           fmAliFicha.qbTitMed.Enabled := True ;
           fmAliFicha.qbAliMed.Enabled := True ;
           end;
      if clFichaAli.Checked[2] then        // nutrientes
           begin
           fmAliFicha.qbTitNut.Enabled := True ;
           fmAliFicha.qbAliNut.Enabled := True ;
           end;
      if clFichaAli.Checked[3] then        // subst. caloricos
           begin
             fmAliFicha.qbTitSCal.Enabled   := True;
             fmAliFicha.qbSubsCal.Enabled := True;
           end;
      if clFichaAli.Checked[4] then        // preco alimentar
           begin
             fmAliFicha.qbTitPreco.Enabled   := True;
             fmAliFicha.qbAliPreco.Enabled := True;
           end;
      if clFichaAli.Checked[5] then        // preco alimentar
           begin
             fmAliFicha.qbTitSProt.Enabled   := True;
             fmAliFicha.qbSubsProt.Enabled := True;
           end;
      end
   else if rgTipo.ItemIndex = 1 then  // Ordem Alfabetica
        begin
        if rgListagem.ItemIndex = 0 then
           begin
           if fmAliOrdAlf = nil then
              Application.CreateForm( TfmAliOrdAlf, fmAliOrdAlf );
           Report := fmAliOrdAlf.Report;
           end
        else if rgListagem.ItemIndex = 1 then  // Ordem por Grupo Alimentar
           begin
           if fmAliOrdGAli = nil then
              Application.CreateForm( TfmAliOrdGAli, fmAliOrdGAli );
           Report := fmAliOrdGAli.Report; 
           end
        else if rgListagem.ItemIndex = 2 then     // Alimentos por origem
           begin
           if fmRlAliOrigem = nil then
              Application.CreateForm( TfmRlAliOrigem, fmRlAliOrigem );
           Report := fmRlAliOrigem.Report;
           end;
        end
   else if rgTipo.ItemIndex = 2 then   // Total de Alimentos
      begin
      if fmRelTotAli = nil then
         Application.CreateForm( TfmRelTotAli, fmRelTotAli );
      Report := fmRelTotAli.Report;
      end;

   if Report = nil then
      begin
         ShowMessage( 'Verifique se escolheu corretamente seu relatório. ');
         Result := False;
      end;

end;

procedure TfmRelatorios.btImprimirClick(Sender: TObject);
begin
   if MessageDlg('Confirma a impressão?', mtConfirmation,
         [mbYes, mbNo], 0) = mrYes then
      begin
       if ConfigRelAli then
         begin
//          try
             Report.Print;
//          finally
//             LimpaMemoriaAlim; // dá um free em vários itens
//          end;
         end;
      end;
end;

procedure TfmRelatorios.btImpTabClick(Sender: TObject);
begin
   if MessageDlg('Confirma a impressão?', mtConfirmation,
         [mbYes, mbNo], 0) = mrYes then
      begin
       if ConfigRelTabAli then
         begin
//         try
          Report.Print;
//         finally
//          LimpaMemoriaAlim; // dá um free em vários itens
//         end;
        end;
      end;
end;

function TfmRelatorios.ConfigRelEqu: Boolean;
//var
//  nI : integer;
//  cod : string;
//  stGrupo : string ;
//  Controle : boolean;
begin
    Result := True;

   { if  rgSubs.ItemIndex = 0 then // caso seja subst. caloricos
      begin
      if fmRelSCal = nil then
         fmRelSCal := TfmRelSCal.Create(self);
      Report := fmRelSCal.Report;
      For nI := 0 to ( clSubsCal.items.count -1 ) do   // vejo quantos itens foram selecionados
        begin
          // do item selecionado, pego seu guid.
          if clSubsCal.Checked[nI] then
          begin
            cod := Lista.Strings[nI];
            // faco o filtro dos itens que desejo imprimir
            stGrupo := stGrupo +  ' IDGRUCAL = '+''''+ cod +'''' + ' or ';
          end;
        end;

      if stGrupo <> '' then
        begin
         // preparo a variavel, tirando o or do final e filtro a tabela aligcal.
         Delete( stGrupo, (Length(stGrupo)-3), 3);
         DMRelSCal.TbAliGCalbk.Filter := stGrupo;
         DMRelSCal.TbAliGCalbk.Filtered := True;
        end
      else
        DMRelSCal.TbAliGCalbk.Filtered := False;

      end
    else  // caso seja subst. proteicos
      begin
       { For nI := 0 to grSProt.SelectedRows.Count - 1 do   // vejo quantos itens foram selecionados
         begin
          // do item selecionado, pego seu guid.
          grSProt.DataSource.DataSet.GotoBookmark(pointer(grSProt.SelectedRows.Items[nI]));
          cod := grSProt.DataSource.DataSet.Fieldbyname('IDGRUPROT').asString ;
          // faco o filtro dos itens que desejo imprimir
          stGrupo := stGrupo +  ' IDGRUPROT = '+''''+ cod +'''' + ' or ';
         end;

        if stGrupo <> '' then
        begin
         // preparo a variavel, tirando o or do final e filtro a tabela aligcal.
         Delete( stGrupo, (Length(stGrupo)-3), 3);
         DMRelSCal.TbAliGProtbk.Filter := stGrupo;
         DMRelSCal.TbAliGProtbk.Filtered := True;
        end
       else
        DMRelSCal.TbAliGProtbk.Filtered := False;
        if fmRelSProt = nil then
           fmRelSProt := TfmRelSProt.Create(self);
        Report := fmRelSProt.Report;
      end;                                        }

   if  rgSubs.ItemIndex = 0 then // caso seja subst. caloricos
      begin
         if fmRelSCal = nil then
            Application.CreateForm( TfmRelSCal, fmRelSCal );
         Report := fmRelSCal.Report;
      end
      else
      begin
         if fmRelSProt = nil then
           Application.CreateForm( TfmRelSProt, fmRelSProt  );
         Report := fmRelSProt.Report;
      end;

      if Report = nil then
      begin
         ShowMessage( 'Verifique se escolheu corretamente seu relatório. ');
         Result := False;
      end;

end;

procedure TfmRelatorios.btImpEquivClick(Sender: TObject);
begin
   Screen.Cursor := crHourGlass;
      if rgSubs.ItemIndex = 0 then // Equivalentes de Energia
         begin
          DMRelSCAl.qrSubsCal.Close;
          DMRelSCAl.qrSubsCal.Open;
        end
      else
         begin
          DMRelSCAl.qrSubsProt.Close;  // Equivalente de Proteina
          DMRelSCAl.qrSubsProt.Open;
         end;

   if MessageDlg('Confirma a impressão?', mtConfirmation,
         [mbYes, mbNo], 0) = mrYes then
      begin
       if ConfigRelEqu then
         begin
//          try
             Report.Print;
//          finally
//             LimpaMemoriaAlim; // dá um free em vários itens
//          end;
         end;
//        DMRelSCal.TbAliGProtbk.Filtered := False;
//        DMRelSCal.TbAliGCalbk.Filtered := False;
   Screen.Cursor := crDefault;
      end;

end;

function TfmRelatorios.ConfigRelTabAli: Boolean;
begin
   Result := True;
   if ( Report <> nil ) and ( Report.Printer <> nil ) and ( Report.Printer.ShowingPreview ) then
   begin
      ShowMessage( 'Feche a visualização atual para poder fechar esta janela' );
      Result := False;
      exit;
   end;

 with clTabAli do
 begin

   if ItemIndex = 0 then            // Grupo alimentar
      begin
      if fmRTAGAli = nil then
         Application.CreateForm( TfmRTAGAli, fmRTAGAli );
         Report := fmRTAGAli.Report;
      end
   else if ItemIndex = 1  then            // Grupo de energia
      begin
      if fmRTAGCal = nil then
         Application.CreateForm( TfmRTAGCal, fmRTAGCal );
         Report := fmRTAGCal.Report;
      end
   else if ItemIndex = 2 then            // Medidas Caseiras
      begin
      if fmRTAMCas = nil then
         Application.CreateForm( TfmRTAMCas, fmRTAMCas  );
         Report := fmRTAMCas.Report;
      end
   else if ItemIndex = 3 then            // Nutrientes
      begin
      if fmRTANut = nil then
         Application.CreateForm( TfmRTANut, fmRTANut );
         Report := fmRTANut.Report;
       end
   else if ItemIndex = 4 then            // Origem
      begin
      if fmRTAOrigem = nil then
         Application.CreateForm( TfmRTAOrigem, fmRTAOrigem );
         Report := fmRTAOrigem.Report;
      end
   else if ItemIndex = 5 then            // Grupo de Proteinas
      begin
      if fmRTAGPro = nil then
         Application.CreateForm( TfmRTAGPro, fmRTAGPro );
         Report := fmRTAGPro.Report;
      end
   else if ItemIndex = 6 then            // Relação de Grupos de Energia
      begin
      if fmRTASCal = nil then
         Application.CreateForm( TfmRTASCal, fmRTASCal );
         Report := fmRTASCal.Report;
      end
   else if ItemIndex = 7 then            // Relação de Grupos Proteicos
      begin
      if fmRTASProt = nil then
         Application.CreateForm( TfmRTASProt, fmRTASProt );
         Report := fmRTASProt.Report;
      end

 end;

      if Report = nil then
      begin
         ShowMessage( 'Verifique se escolheu corretamente seu relatório. ');
         Result := False;
      end;


end;

end.

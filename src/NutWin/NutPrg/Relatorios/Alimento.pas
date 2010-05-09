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




unit Alimento;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls, ExtCtrls, Spin, Grids, DBGrids, ComCtrls, Buttons,
  Mask, dbpersis, Tabs, DBMyNav, db, qrprntr, Menus, OrgTeste, DBActns,
  ActnList, DBCGrids, NutCnst, MmLstBox, MoveItens, RXDBCtrl, HintListBox;

type
  TfmAlim = class(TForm)
    Bevel1: TBevel;
    pcAlimentos: TPageControl;
    teAliNutrientes: TTabSheet;
    be_Ali_Nutrientes: TBevel;
    teAliMedidas: TTabSheet;
    teAliSubstitutos: TTabSheet;
    teAliPreparacao: TTabSheet;
    teAliPreco: TTabSheet;
    Label7: TLabel;
    dePreco: TDBEdit;
    Label10: TLabel;
    paSubsCal: TPanel;
    laGruSub: TLabel;
    nvNutr: TDBMyNav;
    nvPreco: TDBMyNav;
    dbGruSub: TDBLookupComboBox;
    nvAligCal: TDBMyNav;
    puCadMedidas: TPopupMenu;
    Cadastrar1: TMenuItem;
    laCal: TLabel;
    Label14: TLabel;
    lbEquiv: TLabel;
    Label20: TLabel;
    laQtdeMed: TLabel;
    Label5: TLabel;
    paPrep: TPanel;
    DBGrid2: TDBGrid;
    DBMemo1: TDBMemo;
    Label11: TLabel;
    DBEdit1: TDBEdit;
    Label6: TLabel;
    DBMyNav4: TDBMyNav;
    laPesqAli: TLabel;
    DBMyNav5: TDBMyNav;
    Label15: TLabel;
    Button2: TButton;
    paMCSCal: TPanel;
    Label16: TLabel;
    cbQtdeMed: TDBComboBox;
    Label8: TLabel;
    lcMedCasSC: TDBLookupListBox;
    rgPreco: TRadioGroup;
    paMCPr: TPanel;
    Label9: TLabel;
    Label4: TLabel;
    deQtde: TDBEdit;
    llMedCasPr: TDBLookupListBox;
    paGr: TPanel;
    deMCPrgr: TDBEdit;
    Label3: TLabel;
    laGr: TLabel;
    rgSubsCal: TRadioGroup;
    paGrSCal: TPanel;
    deGrMed: TDBEdit;
    Label17: TLabel;
    Label13: TLabel;
    teAliSubsProt: TTabSheet;
    paSP: TPanel;
    Label18: TLabel;
    laProt: TLabel;
    Label21: TLabel;
    lbEquivProt: TLabel;
    Label23: TLabel;
    Label26: TLabel;
    dbGruSubProt: TDBLookupComboBox;
    nvSubsProt: TDBMyNav;
    paMCSProt: TPanel;
    Label27: TLabel;
    Label28: TLabel;
    cbQtdeMedSP: TDBComboBox;
    lcMedCasSP: TDBLookupListBox;
    rgSubsProt: TRadioGroup;
    paGrSProt: TPanel;
    Label29: TLabel;
    deGrMedSP: TDBEdit;
    laCal100: TLabel;
    teDadosAli: TTabSheet;
    pnAli: TPanel;
    la_Ali_Nome: TLabel;
    la_Ali_Apelido: TLabel;
    la_Ali_Grupo: TLabel;
    Label12: TLabel;
    deNomeAli: TDBEdit;
    DBLookupComboBox2: TDBLookupComboBox;
    lcGrupo: TDBLookupComboBox;
    deNAliSimp: TDBEdit;
    paAlimento: TPanel;
    btNavProximo: TSpeedButton;
    btNavAnterior: TSpeedButton;
    btFechar: TBitBtn;
    DBText1: TDBText;
    pcBotAlim: TPageControl;
    teAlimento: TTabSheet;
    sbNovAlim: TSpeedButton;
    sbCanAlim: TSpeedButton;
    sbExcAlim: TSpeedButton;
    tePreparacao: TTabSheet;
    sbNovPrep: TSpeedButton;
    sbExcPrep: TSpeedButton;
    sbAltPrep: TSpeedButton;
    teMedidas: TTabSheet;
    sbNovMed: TSpeedButton;
    sbAltMed: TSpeedButton;
    sbExcMed: TSpeedButton;
    teNutrientes: TTabSheet;
    sbNovNutr: TSpeedButton;
    sbAltNutr: TSpeedButton;
    sbExcNutr: TSpeedButton;
    teSubsCal: TTabSheet;
    sbNovSCal: TSpeedButton;
    sbAltSCal: TSpeedButton;
    sbExcSCal: TSpeedButton;
    tePreco: TTabSheet;
    sbNovPreco: TSpeedButton;
    sbAltPreco: TSpeedButton;
    sbExcPreco: TSpeedButton;
    teSubsProt: TTabSheet;
    sbNovSProt: TSpeedButton;
    sbAltSProt: TSpeedButton;
    sbExcSProt: TSpeedButton;
    alAlimento: TActionList;
    AlimProx: TDataSetNext;
    AlimAnt: TDataSetPrior;
    AlimCan: TDataSetCancel;
    AlimDel: TDataSetDelete;
    AlimEdi: TDataSetEdit;
    AlimNov: TDataSetInsert;
    sbAltAlim: TSpeedButton;
    PrepDel: TDataSetDelete;
    PrepEdi: TDataSetEdit;
    PrepNov: TDataSetInsert;
    NutDel: TDataSetDelete;
    NutNov: TDataSetInsert;
    sbCanMed: TSpeedButton;
    MedCan: TDataSetCancel;
    MedDel: TDataSetDelete;
    MedEdi: TDataSetEdit;
    MedNov: TDataSetInsert;
    SpeedButton1: TSpeedButton;
    SCalCan: TDataSetCancel;
    SCalDel: TDataSetDelete;
    SCalEdi: TDataSetEdit;
    SCalNov: TDataSetInsert;
    sbCanSprot: TSpeedButton;
    SProtCan: TDataSetCancel;
    SProtDel: TDataSetDelete;
    SProtEdi: TDataSetEdit;
    SProtNov: TDataSetInsert;
    SpeedButton2: TSpeedButton;
    PrecoCan: TDataSetCancel;
    PrecoDel: TDataSetDelete;
    PrecoEdi: TDataSetEdit;
    PrecoNov: TDataSetInsert;
    sbSalAlim: TSpeedButton;
    AlimSal: TDataSetPost;
    NutSal: TDataSetPost;
    MedSal: TDataSetPost;
    SCalSal: TDataSetPost;
    SProtSal: TDataSetPost;
    PrecoSal: TDataSetPost;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    NutCan: TDataSetCancel;
    SpeedButton6: TSpeedButton;
    sbSalSProt: TSpeedButton;
    SpeedButton7: TSpeedButton;
    laInformNut: TLabel;
    laSelec: TLabel;
    laVisNut: TLabel;
    Panel2: TPanel;
    laQtdeMedSP: TLabel;
    Label25: TLabel;
    SProtControleGProt: TAction;
    SCalControleGCal: TAction;
    ChecaGravacaoAlim: TAction;
    lbPreparacao: TRichEdit;
    Label19: TLabel;
    NutEdi: TAction;
    paMed: TPanel;
    Label2: TLabel;
    lcMed: TDBLookupComboBox;
    deValor: TDBEdit;
    Label1: TLabel;
    naMedCas: TDBMyNav;
    MedPro: TDataSetNext;
    MedAnt: TDataSetPrior;
    sbNovaMed: TSpeedButton;
    grMCas: TDBGrid;
    paPreparacao: TPanel;
    paNut: TPanel;
    teNomeNut: TDBText;
    teValorNut: TDBEdit;
    teUnidNut: TDBText;
    miMedCas: TMoveItens;
    mmMedCas: TMmListBox;
    btMudaOrd: TButton;
    btOK: TButton;
    btCancela: TButton;
    grNutVisao: TRxDBGrid;
    btLocAlim: TBitBtn;
    deObsAli: TDBEdit;
    procedure btFecharClick(Sender: TObject);
//    procedure buNutClick(Sender: TObject);
    procedure btApllyUpdateClick(Sender: TObject);
    procedure DBGrid3CellClick(Column: TColumn);
    procedure sdQtdeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sdNutChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Cadastrar1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure deMCPrgrClick(Sender: TObject);
    procedure deQtdeExit(Sender: TObject);
    procedure rgPrecoClick(Sender: TObject);
    procedure llMedCasPrClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgSubsCalClick(Sender: TObject);
    procedure deGrMedClick(Sender: TObject);
    procedure lcMedCasSCClick(Sender: TObject);
    procedure pcAlimentosChange(Sender: TObject);
    procedure rgSubsProtClick(Sender: TObject);
    procedure lcMedCasSPClick(Sender: TObject);
    procedure deGrMedSPClick(Sender: TObject);
    procedure sbNovMedClick(Sender: TObject);
    procedure sbAltMedClick(Sender: TObject);
    procedure sbExcMedClick(Sender: TObject);
    procedure sbExcNutrClick(Sender: TObject);
    procedure sbAltNutrClick(Sender: TObject);
    procedure sbNovSCalClick(Sender: TObject);
    procedure sbAltSCalClick(Sender: TObject);
    procedure sbExcSCalClick(Sender: TObject);
    procedure sbNovPrecoClick(Sender: TObject);
    procedure sbAltPrecoClick(Sender: TObject);
    procedure sbExcPrecoClick(Sender: TObject);
    procedure sbNovSProtClick(Sender: TObject);
    procedure sbAltSProtClick(Sender: TObject);
    procedure sbExcSProtClick(Sender: TObject);
    procedure PrepNovExecute(Sender: TObject);
    procedure PrepEdiExecute(Sender: TObject);
    procedure PrepDelExecute(Sender: TObject);
    procedure NutNovExecute(Sender: TObject);
    procedure AlimNovExecute(Sender: TObject);
    procedure deNomeAliChange(Sender: TObject);
    procedure AlimSalExecute(Sender: TObject);
    procedure NutSalExecute(Sender: TObject);
    procedure SProtEdiExecute(Sender: TObject);
    procedure SProtNovExecute(Sender: TObject);
    procedure SProtCanExecute(Sender: TObject);
    procedure SProtSalExecute(Sender: TObject);
    procedure cbQtdeMedSPChange(Sender: TObject);
    procedure SProtControleGProtExecute(Sender: TObject);
    procedure cbQtdeMedChange(Sender: TObject);
    procedure SCalControleGCalExecute(Sender: TObject);
    procedure SCalNovExecute(Sender: TObject);
    procedure SCalEdiExecute(Sender: TObject);
    procedure SCalSalExecute(Sender: TObject);
    procedure ChecaGravacaoAlimExecute(Sender: TObject);
    procedure NutEdiExecute(Sender: TObject);
    procedure sbNovaMedClick(Sender: TObject);
    procedure AlimEdiExecute(Sender: TObject);
    procedure AlimCanExecute(Sender: TObject);
    procedure MedCanExecute(Sender: TObject);
    procedure MedNovExecute(Sender: TObject);
    procedure MedDelExecute(Sender: TObject);
    procedure MedEdiExecute(Sender: TObject);
    procedure MedSalExecute(Sender: TObject);
    procedure NutCanExecute(Sender: TObject);
    procedure NutDelExecute(Sender: TObject);
    procedure btCancelaClick(Sender: TObject);
    procedure btMudaOrdClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure grNutVisaoGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure teAliPreparacaoShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure AlimDelExecute(Sender: TObject);

  private
    { Private declarations }
    stProt   : string;
    stProtGr : string;
    stMedCasProt : string;
    stCal    : string;
    stCalGr  : string;
    stMedCasCal : string;


  public
    { Public declarations }
//    RelPrep : TfmRelPrep01 ;
    procedure ConfAlimPreco ;
    procedure ConfAlimSubsCal;
    procedure ConfAlimSubsProt;
    procedure ConfAlimPreparacao;
    procedure MostraBotoesAlim ;
    procedure SPEquiv;
    procedure SPMedCas;
    procedure SPTotal;
    procedure SCEquiv;
    procedure SCMedCas;
    procedure SCTotal;
    procedure NutTrocaGrid;

  end;

var
  fmAlim: TfmAlim;

implementation

uses {USelNut,}DMAliPrep, DMNutrien, DMSubstCal,
  DMMedidas, DMPrecoAlim, NutMenu, TabAli, ULocAlim, UListaNut, UCadMed,
  CalcNutr, DumpMem;

{$R *.DFM}

procedure TfmAlim.NutTrocaGrid;
begin
   paNut.Visible := False;
   NutSal.DataSource.DataSet.Refresh;
   DMNutrientes.TbNutrientesbk.Refresh;
   laInformNut.Visible := False;
   ConfAlimSubsCal;
   ConfAlimSubsProt;
end;

procedure TfmAlim.SCEquiv;
begin
  // Controle do Equivalente
  if dbGruSub.Text <> '' then
     begin
      if DMSubsCalorico.TbGruCal.Locate('IDGRUCAL', DMSubsCalorico.TbAliGCalIDGRUCAL.asString, []) then
         stCalGr :=  DMSubsCalorico.TbGruCalCALORIAS.asString
      else
         stCalGr := '0';
      lbEquiv.Caption := DMSubsCalorico.Equivalente( stCalGr, stCal );
     end
  else
      lbEquiv.Caption := '' ;
end;

procedure TfmAlim.SCMedCas;
begin
    // Traz o valor da medida caseira selecionada
    if  DMedidas.TbMedidasCaseiras.Locate( 'IDMEDCAS', DMSubsCalorico.TbAliGCalIdMedCas.asString, [])  then
        stMedCasCal := DMedidas.TbMedidasCaseirasVALOR.asString
    else
        stMedCasCal := '';
    // Controle das opcoes da Quantidade
        laQtdeMed.Caption := DMSubsCalorico.AproximaMedida( lbEquiv.Caption,
                               stMedCasCal );
        cbQtdeMed.Items := DMSubsCalorico.AchaMedida( laQtdeMed.caption);

end;

procedure TfmAlim.SCTotal;
begin
   // Totaliza
   if cbQtdeMed.Text = '' then
      deGrMed.Text  :=  stMedCasCal
   else
      deGrMed.Text := FloattoStr(StrtoFloat(stMedCasCal) *  StrtoFloat(cbQtdeMed.Text));

end;






procedure TfmAlim.SPEquiv;
begin
    // Controle do Equivalente
    if dbGruSubProt.Text <> '' then
      begin
       if DMSubsCalorico.TbGruProt.Locate('IDGRUPROT', DMSubsCalorico.TbAliGProtIDGRUPROT.asString,[] ) then
          stProtGr := DMSubsCalorico.TbGruProtPROTEINAS.asString
       else
          stProtGr := '0'  ;
          lbEquivProt.Caption := DMSubsCalorico.Equivalente( stProtGr, stProt );
      end
    else
          lbEquivProt.Caption := '' ;

end;

procedure TfmAlim.SPMedCas;
begin
    // Traz o valor da medida caseira selecionada
    if  DMedidas.TbMedidasCaseiras.Locate( 'IDMEDCAS', DMSubsCalorico.TbAliGProtIdMedCas.asString, [])  then
        stMedCasProt := DMedidas.TbMedidasCaseirasVALOR.asString
    else
        stMedCasProt := '';
    // Controle das opcoes da Quantidade
        laQtdeMedSP.Caption := DMSubsCalorico.AproximaMedida( lbEquivProt.Caption,
                               stMedCasProt );
        cbQtdeMedSP.Items := DMSubsCalorico.AchaMedida( laQtdeMedSP.caption);
end;

procedure TfmAlim.SPTotal;
begin
   // Totaliza
   if cbQtdeMedSP.Text = '' then
      deGrMedSP.Text  :=  stMedCasProt
   else
      deGrMedSP.Text := FloattoStr(StrtoFloat(stMedCasProt) *  StrtoFloat(cbQtdeMedSP.Text));

end;


procedure TfmAlim.MostraBotoesAlim;
begin
   pcBotAlim.ActivePage:=pcBotAlim.Pages[pcAlimentos.ActivePage.PageIndex];
end;

procedure TfmAlim.ConfAlimPreparacao;
begin
   if DMAlimentos.TbAlimento.FieldByName('Prep').asString = 'T' then
      teAliPreparacao.TabVisible := True
   else
      teAliPreparacao.TabVisible := False;

end;

procedure TfmAlim.ConfAlimSubsProt;

begin

         // Controle das Proteinas

         stProt := DMNutrientes.AchaValorNutriente('{B01C0040-AEE3-11D2-B4C0-00609723104C}'); // Proteína
         if stProt = '' then
           begin
             stProt := '0';
             laProt.Caption := '';
             //ShowMessage('Cadastre o nutriente Proteinas antes de cadastrar o Substituto Proteico');
             teAliSubsProt.TabVisible := False ;
           end
         else
           begin
             teAliSubsProt.TabVisible := True ;
             laProt.Caption := 'Em 100 g do Alimento temos ' + Trim( stProt ) + ' g de Proteinas';

           // Controle do Equivalente
           SPEquiv;

        // Controle da Medida e resultado em gramas
        // if lcMedCasSP.SelectedItem <> '' then
        if DMSubsCalorico.TbAliGProtIDMEDCAS.asString <> '' then
           begin
             // Traz o valor da medida caseira selecionada
              SPMedCas;

             // Totaliza
              SPTotal;

            end;
                    // Controle da inicializacao
          if  DMSubsCalorico.TbAliGProtIDMEDCAS.asString = '' then // nao tem medida cadastrada
              rgSubsProt.ItemIndex := 1
          else
              rgSubsProt.ItemIndex := 0 ;

      end;

end;

procedure TfmAlim.ConfAlimSubsCal;

begin
         // Controle das Calorias
         stCal := DMNutrientes.AchaValorNutriente('{B01C0044-AEE3-11D2-B4C0-00609723104C}'); // Calorias
         if stCal = '' then
           begin
             stCal := '0';
             laCal.Caption := '';
            // ShowMessage('Cadastre o nutriente Energia antes de cadastrar o Equivalente Energético')
            teAliSubstitutos.TabVisible := False ;
        end
         else
           begin     // Completo o valor das calorias
             teAliSubstitutos.TabVisible := True;
             laCal.Caption := 'Em 100 g do Alimento temos ' + Trim( stCal ) + ' cal';
             laCal100.Caption :=  stCal;

             // Controle do Equivalente
              SCEquiv;

            // Controle da Medida e resultado em gramas
            // if lcMedCasSC.SelectedItem <> '' then
            if DMSubsCalorico.TbAliGCalIDMEDCAS.asString <> '' then
               begin
                // Traz o valor da medida caseira selecionada
                SCMedCas;

                // Totaliza
                SCTotal;
               end;

            // Controle da inicializaçao
            if DMSubsCalorico.TbAliGCalIDMEDCAS.asString = '' then // nao tem medida cadastrada
               rgSubsCal.ItemIndex := 1
             else
               rgSubsCal.ItemIndex := 0 ;
          end;
end;

procedure TfmAlim.ConfAlimPreco;
begin
  if pcAlimentos.ActivePage = teAliPreco then
     begin
      if DMAlimentos.TbPrecoAliIDMEDCAS.asString = '' then
         rgPreco.ItemIndex := 1
      else
         rgPreco.ItemIndex := 0 ;
     end;
end;



procedure TfmAlim.btFecharClick(Sender: TObject);
begin
    Close;
end;


{var
I : integer;
begin
with DMAlimentos.DBOrganizador  do
     begin
//     StartTransaction;
     Try
      for I :=0 to DatasetCount -1 do
          begin
          if DataSets[I].CachedUpdates=True  then //and ((DataSets[I].State = dsEdit) or (DataSets[I].State = dsInsert))
          begin
          DataSets[I].ApplyUpdates;
          DataSets[I].CommitUpdates;
          end;
          if (DataSets[I].Name <>'') then
             DataSets[I].Refresh;
          end;
 //    DMAlimento.QAlim2.Close;
//     DMAlimento.QAlim2.Open;
     except
//      Rollback;
      raise;
     end;
//     Commit;
     end;

    Close;
end; }
{
procedure TfmAlim.buNutClick(Sender: TObject);
begin
    fmSelecNut := TfmSelecNut.Create( self );
    fmSelecNut.ShowModal;
    fmSelecNut.free;
end;
}
procedure TfmAlim.btApllyUpdateClick(Sender: TObject);
begin
   DMAlimentos.GravaDados;
end;
{var
I : integer;
begin
with DMAlimento.DBOrganizador do
     begin
//     StartTransaction;
     Try
      for I :=0 to DatasetCount -1 do
          begin
          if DataSets[I].CachedUpdates=True  then //and ((DataSets[I].State = dsEdit) or (DataSets[I].State = dsInsert))
          begin
          DataSets[I].ApplyUpdates;
          DataSets[I].CommitUpdates;
          end;
          if (DataSets[I].Name <>'') then
             DataSets[I].Refresh;
          end;
     DMAlimento.QAlim2.Close;
     DMAlimento.QAlim2.Open;
//     DMFisico.QAlim2.Refresh;
//     DMFisico.TbIngredientes.Refresh;
//       DMFisico.TbIngredientes.Close;
//       DMFisico.TbIngredientes.Open;
     except
//      Rollback;
      raise;
     end;
//     Commit;
     end;
end;
 }
procedure TfmAlim.DBGrid3CellClick(Column: TColumn);
begin
    DMNutrientes.TbAliNut.Refresh;
end;

procedure TfmAlim.sdQtdeChange(Sender: TObject);
begin
    DMNutrientes.TbAliNut.Refresh;
end;

procedure TfmAlim.FormCreate(Sender: TObject);
begin
    Application.CreateForm(TfmLocAlim, fmLocAlim);
    Application.CreateForm(TfmListNut, fmListNut);
//  RelPrep := TfmRelPrep01.Create(self);
    pcAlimentos.ActivePage := teDadosAli;
    pcBotAlim.ActivePage   := teAlimento;
    ConfAlimPreco;
   // ConfAlimSubsCal;
    ConfAlimSubsProt;
    //ConfAlimPreparacao;

end;

procedure TfmAlim.sdNutChange(Sender: TObject);
begin
    DMNutrientes.TbAliNut.Refresh;
end;

procedure TfmAlim.Button3Click(Sender: TObject);
begin
   DMALimentos.TbAlimento.Next;
end;

procedure TfmAlim.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   fm_MenuNut.HabilitaMenu;
   fmLocAlim.free;
   fmListNut.free;

   ChecaGravacaoAlimExecute(Sender);
   Action:=caFree;
end;

procedure TfmAlim.Cadastrar1Click(Sender: TObject);
begin
    Application.CreateForm( TfmTabAli, fmTabAli );
    fmTabAli.pgcTabelas.ActivePage := fmTabAli.tsTAMedCas;
    fmTabAli.ShowModal;
    fmTabAli.Free;
end;

procedure TfmAlim.Button2Click(Sender: TObject);
begin
   fmListNut.WindowState := wsNormal;
   fmListNut.lvNutCalc.Items.Clear;
   fmListNut.Show;
end;

procedure TfmAlim.deMCPrgrClick(Sender: TObject);
begin
// caso tenha uma medida caseira cadastrada, devo apaga-la e sua unidade.
  if DMAlimentos.TbPrecoAliIDMEDCAS.asString <> '' then
  begin
        if MessageDlg('As informações cadastradas serão apagadas.',
         mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          DMAlimentos.TbPrecoAli.Edit;
          DMAlimentos.TbPrecoAliIDMEDCAS.asString := '' ;
          DMAlimentos.TbPrecoAliQTDE.asFloat     := 0  ;
          deMCPrgr.SetFocus;
        end;

  end;
end;

procedure TfmAlim.deQtdeExit(Sender: TObject);
begin
    if DMAlimentos.TbPrecoAliIDMEDCAS.asString <> '' then
       begin
       if (DMAlimentos.TbPrecoAli.State <> dsEdit )  or
          (DMAlimentos.TbPrecoAli.State <> dsInsert) then
          DMAlimentos.TbPrecoAli.Edit;
       DMAlimentos.TbPrecoAliMEDGR.asString := FloattoStr (
              ( DMAlimentos.TbMCPrecoVALOR.asFloat * DMAlimentos.TbPrecoAliQTDE.asFloat ));
       end;
end;

procedure TfmAlim.rgPrecoClick(Sender: TObject);
begin
  if rgPreco.ItemIndex = 0 then   // Medidas Caseiras
     begin
       if (DMAlimentos.TbMCPreco.IsEmpty) and
          ((DMAlimentos.TbPrecoAli.State = dsEdit) or  (DMAlimentos.TbPrecoAli.State = dsInsert)) then
          begin
           ShowMessage( 'Não existe Medida Caseira cadastrada para este Alimento.');
           rgPreco.ItemIndex := 1 ;
           paMCPr.Visible := False;
           paGr.Enabled   := True;
          end
       else
         begin
          paMCPr.Visible := True;
          paGr.Enabled   := False;
         end; 
      end
  else     // gramas
     begin
      paMCPr.Visible := False;
      paGr.Enabled   := True;
     end;


end;

procedure TfmAlim.llMedCasPrClick(Sender: TObject);
begin
    with DMAlimentos do
      begin
       TbPrecoAliMEDGR.asString := FloattoStr( TbPrecoAliQTDE.asFloat * TbMCPrecoVALOR.asFloat ) ;
      end;
end;

procedure TfmAlim.FormShow(Sender: TObject);
begin
   fmCalcNutr.ifFormWizard.Container := paPreparacao;
   pcAlimentos.ActivePage := teDadosAli;
   pcBotAlim.ActivePage   := teAlimento;
   ConfAlimPreco;
   ConfAlimSubsCal;
   ConfAlimSubsProt;
   ConfAlimPreparacao;
   Dump.Show;
end;

procedure TfmAlim.rgSubsCalClick(Sender: TObject);
begin
 if rgSubsCal.ItemIndex = 0 then   // Medidas Caseiras
     begin
       if (DMAlimentos.TbMCSC.IsEmpty) and
          ((DMSubsCalorico.TbAliGCal.State = dsEdit) or  (DMSubsCalorico.TbAliGCal.State = dsInsert)) then
          begin
           ShowMessage( 'Não existe Medida Caseira cadastrada para este Alimento.');
           rgSubsCal.ItemIndex := 1 ;
           paMCSCal.Visible := False;
           paGrSCal.Enabled   := True;
          end
       else
         begin
           paMCSCal.Visible := True;
           paGrSCal.Enabled   := False;
         end;
      end
  else     // gramas
     begin
      paMCSCal.Visible := False;
      paGrSCal.Enabled   := True;
     end;

end;

procedure TfmAlim.deGrMedClick(Sender: TObject);
begin
// caso tenha uma medida caseira cadastrada, devo apaga-la e sua unidade.
  if DMSubsCalorico.TbAliGCalIDMEDCAS.asString <> '' then    // tiver medida cadastradas
  begin
        if MessageDlg('As informações cadastradas serão apagadas.',
         mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          DMSubsCalorico.TbAliGCal.Edit;
          DMSubsCalorico.TbAliGCalIDMEDCAS.asString := '' ;
          DMSubsCalorico.TbAliGCalQTDE.asFloat      := 0  ;
          deGrMed.SetFocus;
        end;

  end;
end;

procedure TfmAlim.lcMedCasSCClick(Sender: TObject);
begin
      // devo limpar o campo da quantidade para que o usuario escolha o valor correto
     DMSubsCalorico.TbAliGCalQTDE.asString  := '0';
     DMSubsCalorico.TbAliGCalMEDGR.asString := '0';
     SCMedCas;
     // gravo no campo das gramas o valor relativo a multiplicacao da quantidade pelo valor
     // das medidas
     SCTotal;
end;

procedure TfmAlim.pcAlimentosChange(Sender: TObject);
begin
   MostraBotoesAlim;  // Sincroniza os botoes.
   // Configuracao de alimentos
   if pcAlimentos.ActivePage = teDadosAli then
    begin
    end

   // Configuracao de Nutrientes
   else if pcAlimentos.ActivePage = teAliNutrientes then
    begin
    end

   // Configuracao para Medidas Caseiras
   else if pcAlimentos.ActivePage = teAliMedidas then
    begin
    end

   // Configuracao para Substitutos Caloricos
   else if pcAlimentos.ActivePage = teAliSubstitutos then
     ConfAlimSubsCal

   // Configuracao para Preco
   else if pcAlimentos.ActivePage = teAliPreco then
     ConfAlimPreco

   // Configuracao para Substitutos Proteicos
   else if pcAlimentos.ActivePage = teAliSubsProt then
      ConfAlimSubsProt ;

    // Em qualquer mudanca de pastinha, devo salvar meus dados. Por isso checo todos os bancos e seu estado.

    if (DMAlimentos.TbAlimento.State = dsEdit) or (DMAlimentos.TbAlimento.State = dsInsert) then
       begin
         if MessageDlg('Deseja salvar os dados de Alimentos ?',mtConfirmation, [mbYes, mbNo], 0) = mrNo then
            DMAlimentos.TbAlimento.Cancel
         else
            DMAlimentos.TbAlimento.Post;
       end

    else if (DMNutrientes.TbAliNut.State = dsEdit) or (DMNutrientes.TbAliNut.State = dsInsert) then
       begin
        if MessageDlg('Deseja salvar os dados dos Nutrientes ?',mtConfirmation, [mbYes, mbNo], 0) = mrNo then
           DMNutrientes.TbAliNut.Cancel
        else
           DMNutrientes.TbAliNut.Post;
       end

     else if (DMedidas.TbMedidasCaseiras.State = dsEdit) or (DMedidas.TbMedidasCaseiras.State = dsInsert) then
       begin
         if MessageDlg('Deseja salvar os dados das Medidas Caseiras ?',mtConfirmation, [mbYes, mbNo], 0) = mrNo then
            DMedidas.TbMedidasCaseiras.Cancel
         else
            DMedidas.TbMedidasCaseiras.Post;
       end

      else if (DMSubsCalorico.TbAliGCal.State = dsEdit) or (DMSubsCalorico.TbAliGCal.State = dsInsert) then
       begin
       if MessageDlg('Deseja salvar os dados dos Equivalentes Energéticos ?',mtConfirmation, [mbYes, mbNo], 0) = mrNo then
          DMSubsCalorico.TbAliGCal.Cancel
       else
          DMSubsCalorico.TbAliGCal.Post;
       end

      else if (DMAlimentos.TbPrecoAli.State = dsEdit) or (DMAlimentos.TbPrecoAli.State = dsInsert) then
       begin
       if MessageDlg('Deseja salvar os dados dos Precos ?',mtConfirmation, [mbYes, mbNo], 0) = mrNo then
          DMAlimentos.TbPrecoAli.Cancel
       else
          DMAlimentos.TbPrecoAli.Post;
       end

      else if (DMSubsCalorico.TbAliGProt.State = dsEdit) or (DMSubsCalorico.TbAliGProt.State = dsInsert) then
       begin
       if MessageDlg('Deseja salvar os dados dos Equivalentes Proteicos ?',mtConfirmation, [mbYes, mbNo], 0) = mrNo then
          DMSubsCalorico.TbAliGProt.Cancel
       else
          DMSubsCalorico.TbAliGProt.Post;
       end;


end;

procedure TfmAlim.rgSubsProtClick(Sender: TObject);
begin
 if rgSubsProt.ItemIndex = 0 then   // Medidas Caseiras
     begin
       if (DMAlimentos.TbMCSP.IsEmpty) and
          ((DMSubsCalorico.TbAliGProt.State = dsEdit) or  (DMSubsCalorico.TbAliGProt.State = dsInsert)) then
          begin
           ShowMessage( 'Não existe Medida Caseira cadastrada para este Alimento.');
           rgSubsProt.ItemIndex := 1 ;
           paMCSProt.Visible := False;
           paGrSProt.Enabled   := True;
          end
       else
         begin
           paMCSProt.Visible := True;
           paGrSProt.Enabled   := False;
         end;
      end
  else     // gramas
     begin
      paMCSProt.Visible := False;
      paGrSProt.Enabled   := True;
     end;

end;

procedure TfmAlim.lcMedCasSPClick(Sender: TObject);
begin
     // devo limpar o campo da quantidade para que o usuario escolha o valor correto
     DMSubsCalorico.TbAliGProtQTDE.asString  := '0';
     DMSubsCalorico.TbAliGProtMEDGR.asString := '0';
     SPMedCas;
     // gravo no campo das gramas o valor relativo a multiplicacao da quantidade pelo valor
     // das medidas
     SPTotal;
end;

procedure TfmAlim.deGrMedSPClick(Sender: TObject);
begin
// caso tenha uma medida caseira cadastrada, devo apaga-la e sua unidade.
  if DMSubsCalorico.TbAliGProtIDMEDCAS.asString <> '' then    // tiver medida cadastradas
  begin
        if MessageDlg('As informações cadastradas serão apagadas.',
         mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          DMSubsCalorico.TbAliGProt.Edit;
          DMSubsCalorico.TbAliGProtIDMEDCAS.asString := '' ;
          DMSubsCalorico.TbAliGProtQTDE.asFloat      := 0  ;
          deGrMedSP.SetFocus;
        end;

  end;
end;

procedure TfmAlim.sbNovMedClick(Sender: TObject);
begin
  // naMedCas.BtnClick(nbInsert);
end;

procedure TfmAlim.sbAltMedClick(Sender: TObject);
begin
   //naMedCas.BtnClick(nbEdit);
end;

procedure TfmAlim.sbExcMedClick(Sender: TObject);
begin
   //naMedCas.BtnClick(nbDelete);
end;

procedure TfmAlim.sbExcNutrClick(Sender: TObject);
begin
  // nvNutr.BtnClick(nbDelete);
end;

procedure TfmAlim.sbAltNutrClick(Sender: TObject);
begin
   //nvNutr.BtnClick(nbEdit);
end;

procedure TfmAlim.sbNovSCalClick(Sender: TObject);
begin
   //nvAligCal.BtnClick(nbInsert);
end;

procedure TfmAlim.sbAltSCalClick(Sender: TObject);
begin
   //nvAligCal.BtnClick(nbEdit);
end;

procedure TfmAlim.sbExcSCalClick(Sender: TObject);
begin
   //nvAligCal.BtnClick(nbDelete);
end;

procedure TfmAlim.sbNovPrecoClick(Sender: TObject);
begin
//   nvPreco.BtnClick(nbInsert);
end;

procedure TfmAlim.sbAltPrecoClick(Sender: TObject);
begin
//   nvPreco.BtnClick(nbEdit);
end;

procedure TfmAlim.sbExcPrecoClick(Sender: TObject);
begin
//   nvPreco.BtnClick(nbDelete);
end;

procedure TfmAlim.sbNovSProtClick(Sender: TObject);
begin
   //nvSubsProt.BtnClick(nbInsert);
end;

procedure TfmAlim.sbAltSProtClick(Sender: TObject);
begin
//   nvSubsProt.BtnClick(nbEdit);
end;

procedure TfmAlim.sbExcSProtClick(Sender: TObject);
begin
//   nvSubsProt.BtnClick(nbDelete);
end;

procedure TfmAlim.PrepNovExecute(Sender: TObject);
begin
   DMAlimentos.DSPreparac.DataSet.DisableControls;
   OrgCalc.Inicializar( DMAlimentos.DSPreparac, 'Prep' , ncPreparacao);
   OrgCalc.Novo( 'IDALI', DMAlimentos.TbAlimentoIDALI.AsString, 'Data', DateToStr( Date ), ncPreparacao );
   DMAlimentos.DSPreparac.DataSet.EnableControls;

end;

procedure TfmAlim.PrepEdiExecute(Sender: TObject);
begin
   DMAlimentos.DSPreparac.DataSet.DisableControls;
   OrgCalc.Inicializar( DMAlimentos.DSPreparac, 'Prep' , ncPreparacao);
   OrgCalc.Alterar( ncPreparacao );
   DMAlimentos.DSPreparac.DataSet.EnableControls;

end;

procedure TfmAlim.PrepDelExecute(Sender: TObject);
begin
   OrgCalc.Inicializar( DMAlimentos.DSPreparac, 'Prep' , ncPreparacao);
   OrgCalc.Excluir;
end;

procedure TfmAlim.NutNovExecute(Sender: TObject);
begin
{    fmSelecNut := TfmSelecNut.Create( self );
    fmSelecNut.ShowModal;
    fmSelecNut.free;     }
    laInformNut.Visible := True;
    paNut.Visible := True;
    // verifico se achei o determinado nutriente. Se for editar ou incluo e posiciono.
    if DMNutrientes.TbAliNut.Locate('IDNUT', DMNutrientes.TbNutrientesbkIDNUT.asString, []) then
       begin
       DMNutrientes.TbAliNut.Edit;
       end
    else
       begin
       DMNutrientes.TbAliNut.Insert;
       DMNutrientes.TbAliNutIDNUT.asString := DMNutrientes.TbNutrientesbkIDNUT.asString ;
       end;

    ConfAlimSubsCal;
    ConfAlimSubsProt;
end;

procedure TfmAlim.AlimNovExecute(Sender: TObject);
begin
// posiciono quando for um novo registro em Alimentos
  pnAli.Enabled := True ;
  AlimNov.DataSource.DataSet.Insert;

// desativo estas pastas. So volto a ativa-las quando salvar.
   teAliNutrientes.TabVisible := False;
   teAliMedidas.TabVisible    := False;
   teAliPreco.TabVisible      := False;


// Configuracao para Preco e Substitutos Caloricos
   ConfAlimPreco;
   ConfAlimSubsCal;
   ConfAlimSubsProt;

end;

procedure TfmAlim.deNomeAliChange(Sender: TObject);
begin
   ConfAlimPreparacao;
   ConfAlimSubsCal;
   ConfAlimSubsProt;
   DmNutrientes.TbNutrientesbk.Refresh;
   DMedidas.TbMedidasCaseiras.Locate ('IDMEDCAS',DMedidas.qrMedCIndexadaIDMEDCAS.AsString, []);


end;

procedure TfmAlim.AlimSalExecute(Sender: TObject);
begin
   // se for Preparacao devo marcar o campo Prep como True .
   if AlimSal.DataSource.DataSet.FieldByName('IDGRUALI').asString =
      '{88DD9369-66F8-11D1-A6A0-008048B86BEE}' then
       AlimSal.DataSource.DataSet.FieldByName('Prep').AsString := 'T'
   else
       AlimSal.DataSource.DataSet.FieldByName('Prep').AsString := 'F';
   AlimSal.DataSource.DataSet.Post;
   // ativo estas pastas
   teAliNutrientes.TabVisible := True;
   teAliMedidas.TabVisible    := True;
   teAliPreco.TabVisible      := True;

// Configuro os substitutos
   ConfAlimSubsProt;
   ConfAlimPreparacao;
   pnAli.SetFocus;
   pnAli.Enabled := False ;

   // se for Preparacao devo forçar a inclusão de alimentos  .
   if (AlimSal.DataSource.DataSet.FieldByName('IDGRUALI').asString =
      '{88DD9369-66F8-11D1-A6A0-008048B86BEE}' ) and
      ( DMAlimentos.TbPreparac.RecordCount = 0 ) then
       PrepNovExecute(Sender);

end;

procedure TfmAlim.NutSalExecute(Sender: TObject);
begin
   if (NutSal.DataSource.DataSet.State = dsEdit) or
      (NutSal.DataSource.DataSet.State = dsInsert) then
       NutSal.DataSource.DataSet.Post;

end;

procedure TfmAlim.SProtEdiExecute(Sender: TObject);
begin
  SProtNov.DataSource.DataSet.Edit;
  paSP.Enabled := True;
end;

procedure TfmAlim.SProtNovExecute(Sender: TObject);
begin
  SProtNov.DataSource.DataSet.Insert;
  paSP.Enabled := True;
end;

procedure TfmAlim.SProtCanExecute(Sender: TObject);
begin
  SProtNov.DataSource.DataSet.Cancel;
  paSP.Enabled := False;
end;

procedure TfmAlim.SProtSalExecute(Sender: TObject);
begin
  if (SProtNov.DataSource.DataSet.Fieldbyname('MedGr').asString = '') and
     (SProtNov.DataSource.DataSet.Fieldbyname('IDMEDCAS').asString <> '') then
     begin
     ShowMessage('Complete a quantidade da Medida Caseira' );
     cbQtdeMedSP.SetFocus;
     end
  else
     begin
     SProtNov.DataSource.DataSet.Post;
     paSP.Enabled := False;
     end;
end;

procedure TfmAlim.cbQtdeMedSPChange(Sender: TObject);
begin
 if  (DMSubsCalorico.TbAliGProtIDMEDCAS.asString <> '') and (cbQtdeMedSP.Text <> '')  then  // se tiver medida caseira selecionada
      DMSubsCalorico.TbAliGProtMEDGR.asString := FloattoStr( StrtoFloat( cbQtdeMedSP.text) * StrtoFloat(stMedCasProt) )
   else
      DMSubsCalorico.TbAliGProtMEDGR.asString := '';
end;

procedure TfmAlim.SProtControleGProtExecute(Sender: TObject);
begin
   // Controla se o alimento do Grupo GORDURAS tem mais de 40 calorias e nao deixa cadastrar ..
   if DMSubsCalorico.TbAliGProtIdGruProt.AsString = '{9A77FF42-8F40-11D2-8C95-00609723109D}' then
      begin
      if stCal <> '' then
         begin
           if StrtoFloat(stCal) > 40 then
              begin
               ShowMessage('Este Grupo Proteico não é permitido, pois o alimento tem mais que 40 calorias em 100 g.');
               DMSubsCalorico.TbAliGProt.Cancel;
              end;
         end
      else
         begin
          ShowMessage('Cadastre as Energias antes de escolher o Equivalente Proteico.' );
          DMSubsCalorico.TbAliGProt.Cancel;
         end;
      end;

   SPEquiv;
end;

procedure TfmAlim.cbQtdeMedChange(Sender: TObject);
begin
 if  (DMSubsCalorico.TbAliGCalIDMEDCAS.asString <> '') and (cbQtdeMed.Text <> '')  then  // se tiver medida caseira selecionada
      DMSubsCalorico.TbAliGCalMEDGR.asString := FloattoStr( StrtoFloat( cbQtdeMed.text) * StrtoFloat(stMedCasCal) )
   else
      DMSubsCalorico.TbAliGCalMEDGR.asString := '';
end;

procedure TfmAlim.SCalControleGCalExecute(Sender: TObject);
begin
   SCEquiv;
end;

procedure TfmAlim.SCalNovExecute(Sender: TObject);
begin
  SCalNov.DataSource.DataSet.Insert;
  paSubsCal.Enabled := True;
end;

procedure TfmAlim.SCalEdiExecute(Sender: TObject);
begin
  SCalNov.DataSource.DataSet.Edit;
  paSubsCal.Enabled := True;
end;

procedure TfmAlim.SCalSalExecute(Sender: TObject);
begin
  if (SCalNov.DataSource.DataSet.Fieldbyname('MedGr').asString = '') and
     (SCalNov.DataSource.DataSet.Fieldbyname('IDMEDCAS').asString <> '') then
     begin
     ShowMessage('Complete a quantidade da Medida Caseira' );
     cbQtdeMed.SetFocus;
     end
  else
     begin
     SCalNov.DataSource.DataSet.Post;
     paSubsCal.Enabled := False;
     end;
end;


procedure TfmAlim.ChecaGravacaoAlimExecute(Sender: TObject);
begin
    with DMAlimentos do
    begin
    if (TbAlimento.State = dsEdit)   or (TbAlimento.State = dsInsert)   then
        TbAlimento.Post ;
    if (TbPreparac.State = dsEdit) or (TbPreparac.State = dsInsert) then
        TbPreparac.Post ;
    if (TbPrecoAli.State = dsEdit) or (TbPrecoAli.State = dsInsert) then
        TbPrecoAli.Post ;
    end;
    if (DMNutrientes.TbAliNut.State = dsEdit) or (DMNutrientes.TbAliNut.State = dsInsert) then
        DMNutrientes.TbAliNut.Post ;
    if (DMedidas.TbMedidasCaseiras.State = dsEdit) or (DMedidas.TbMedidasCaseiras.State = dsInsert) then
        DMedidas.TbMedidasCaseiras.Post ;
    with DMSubsCalorico do
    begin
    if (TbAliGCal.State = dsEdit)   or (TbAliGCal.State = dsInsert)   then
        TbAliGCal.Post ;
    if (TbAliGProt.State = dsEdit) or (TbAliGProt.State = dsInsert) then
        TbAliGProt.Post ;
    end;

end;

procedure TfmAlim.NutEdiExecute(Sender: TObject);
begin
    // verifico se achei o determinado nutriente. Se for editar ou incluo e posiciono.
    // caso seja da USDA que mandamos, não deixamos alterar.
    if (DMAlimentos.TbAlimentoIDORIG.asString = '{B970DAE1-B505-11D1-B683-00001D13DDBD}' ) and
       (DMNutrientes.TbNutrientesbkIDORIG.asString = '{B970DAE1-B505-11D1-B683-00001D13DDBD}') then
       ShowMessage('Os valores dos Nutrientes vindos da Tabela da USDA, não poderão ser alterados.' )
    else
    begin
     // so deixo alterar se nao for do grupo de Preparação
     if DMAlimentos.TbAlimentoIDGRUALI.asString = '{88DD9369-66F8-11D1-A6A0-008048B86BEE}' then
        ShowMessage('Nutrientes da Preparação/Receita são calculados pelo Sistema' )
     else
      begin
        //grNut.Visible := True;
        paNut.Visible := True;
        if DMNutrientes.TbAliNut.Locate('IDNUT', DMNutrientes.TbNutrientesbkIDNUT.asString, []) then
          begin
          DMNutrientes.TbAliNut.Edit;
          end
        else
          begin
          DMNutrientes.TbAliNut.Insert;
          DMNutrientes.TbAliNutIDNUT.asString := DMNutrientes.TbNutrientesbkIDNUT.asString ;
          // focando a alteracao
          teValorNut.SetFocus;
          end
      end;
     end;
end;

procedure TfmAlim.sbNovaMedClick(Sender: TObject);
begin
    Application.CreateForm( TfmCadMed, fmCadMed );

    with DMedidas.DSMedidasCaseiras do
    begin
     if (State = dsInsert) or (State = dsEdit) then
         //DMedidas.TbMedidasCaseirasIDMEDCAS.AsString := '' ;
        Dataset.Cancel ;
    end;
    fmCadMed.ShowModal;
    fmCadMed.Free;
end;

procedure TfmAlim.AlimEdiExecute(Sender: TObject);
begin

      // se o alimento for da USDA, não poderá ser alterado ...
      if AlimNov.DataSource.DataSet.FieldByName('IDORIG').asString = '{B970DAE1-B505-11D1-B683-00001D13DDBD}' then
         ShowMessage(' Dados originários da Tabela USDA, não podem ser alterados.' )
      else
      begin
         pnAli.Enabled := True ;
         AlimNov.DataSource.DataSet.Edit;
      end;

end;

procedure TfmAlim.AlimCanExecute(Sender: TObject);
begin
   AlimCan.DataSource.DataSet.Cancel;
      // ativo estas pastas
   teAliNutrientes.TabVisible := True;
   teAliMedidas.TabVisible    := True;
   teAliPreco.TabVisible      := True;

   pnAli.SetFocus;
   pnAli.Enabled := False ;
end;

procedure TfmAlim.MedCanExecute(Sender: TObject);
begin
    MedCan.DataSource.DataSet.Cancel;
    paMed.Enabled := False;
end;

procedure TfmAlim.MedNovExecute(Sender: TObject);
begin
    paMed.Enabled := True;
    MedNov.DataSource.DataSet.Insert;
    paMed.Enabled := True;
end;

procedure TfmAlim.MedDelExecute(Sender: TObject);
begin
    paMed.Enabled := True;
    MedDel.DataSource.DataSet.Delete;
    paMed.Enabled := False;

end;
procedure TfmAlim.MedEdiExecute(Sender: TObject);
begin
    paMed.Enabled := True;
    MedEdi.DataSource.DataSet.Edit;
    paMed.SetFocus;

end;

procedure TfmAlim.MedSalExecute(Sender: TObject);
begin
    MedSal.DataSource.DataSet.Post;
//    DMedidas.qrMedCIndexada.Active := False ;
//    DMedidas.qrMedCIndexada.Active := True ;
    DMedidas.qrMedCIndexada.DataSource.DataSet.Refresh;
//    DMedidas.qrMedCIndexada.Refresh;
    paMed.SetFocus;
    paMed.Enabled := False;

end;

procedure TfmAlim.NutCanExecute(Sender: TObject);
begin
    paNut.Visible := False;
    DMNutrientes.TbAliNut.Cancel;
    DMNutrientes.TbNutrientesbk.Refresh;
end;

procedure TfmAlim.NutDelExecute(Sender: TObject);
var
Cod : string;
begin
    paNut.Visible := False;

    //localizo  o registro em AliNut. Caso tenha, deve deletar
    if DMNutrientes.TbAliNut.Locate('IDNUT', DMNutrientes.TbNutrientesbkIDNUT.asString, []) then
       begin
        Cod := DMNutrientes.TbAliNutIDNUT.asString;
        DMNutrientes.TbAliNut.Delete ;
       end
    else
       DMNutrientes.TbAliNut.Cancel;

     //Vejo se está sendo apagado Energia ou Proteina, caso seja, devo alterar a pasta.
     if ( Cod = '{B01C0044-AEE3-11D2-B4C0-00609723104C}') or
        ( Cod = '{B01C0040-AEE3-11D2-B4C0-00609723104C}') then
        begin
          ConfAlimSubsCal;
          ConfAlimSubsProt;
        end;
     DMNutrientes.TbNutrientesbk.Refresh;
end;

procedure TfmAlim.btCancelaClick(Sender: TObject);
begin
    miMedCas.Visible := False;

end;

procedure TfmAlim.btMudaOrdClick(Sender: TObject);
begin
   miMedCas.Visible := True;
   DMedidas.TbMCOrdPad.First;
   mmMedCas.Items.Clear;
   While not DMedidas.TbMCOrdPad.Eof do
   begin
     mmMedCas.AddDescricaoGUID( DMedidas.TbMCOrdPadNomeMedida.asString,DMedidas.TbMCOrdPadIDMEDCAS.asString);
     DMedidas.TbMCOrdPad.Next;
   end;
end;

procedure TfmAlim.btOKClick(Sender: TObject);
var
I : integer;

begin
   miMedCas.Visible := False;
   for I:=0 to (mmMedCas.Items.Count - 1) do
   begin
      if DMedidas.TbMCOrdPad.Locate('IDMEDCAS', mmMedCas.GUID[I], [] )then
      begin
        DMedidas.TbMCOrdPad.Edit;
        DMedidas.TbMCOrdPadORDPADRAO.asInteger := I;
        DMedidas.TbMCOrdPad.Post;
      end;
   end;


end;

procedure TfmAlim.grNutVisaoGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
   if Field.DataSet.FieldByName('IDORIG').asString <> '{B970DAE1-B505-11D1-B683-00001D13DDBD}' then
   begin
      AFont.Color := clBlue;
   end;
end;

procedure TfmAlim.teAliPreparacaoShow(Sender: TObject);
begin
//fmCalcNutr.ShowPreview;
end;

procedure TfmAlim.BitBtn1Click(Sender: TObject);
begin
     fmLocAlim.WindowState := wsNormal;
     fmLocAlim.edNav.Text := '';
     fmLocAlim.Show;
   //ALimentos.TbAlimento.Prior;
end;

procedure TfmAlim.AlimDelExecute(Sender: TObject);
begin
   AlimCan.DataSource.DataSet.Delete;
   pnAli.Enabled := False ;
end;

end.

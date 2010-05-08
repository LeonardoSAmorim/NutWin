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




unit NutRelatInd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, quickrpt, Grids, DBGrids, checklst, DBCtrls, db, NutCnst ;

type
  TfmNutRelInd = class(TForm)
    pgcRelatorio: TPageControl;
    tbsRelIndividuos: TTabSheet;
    rgTipoPes: TRadioGroup;
    rgList: TRadioGroup;
    gbPesqPess: TGroupBox;
    CompositeReport: TQuickRep;
    qrCompTabPes: TQRCompositeReport;
    CompReportTabPes: TQuickRep;
    edPesqPess: TEdit;
    grPess: TDBGrid;
    gbFichaPess: TGroupBox;
    clFichaPess: TCheckListBox;
    btPrevPes: TButton;
    btFechar: TButton;
    tbsTabIndiv: TTabSheet;
    btVisTabPes: TButton;
    btFecharTabInd: TButton;
    btImprimir: TButton;
    btImpTabInd: TButton;
    rgTabPes: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edPesqPessChange(Sender: TObject);
    procedure rgTipoPesClick(Sender: TObject);
    procedure btPrevPesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btVisTabPesClick(Sender: TObject);
    procedure btFecharClick(Sender: TObject);
    procedure btFecharTabIndClick(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure btImpTabIndClick(Sender: TObject);
  private
    { Private declarations }
    FReport  : TQuickRep ;
    procedure SetReport(Value : TQuickRep);
    function ConfiguraReport : Boolean;
    function ConfiguraReport2 : Boolean;
  public
    { Public declarations }
     property Report : TQuickRep read FReport write SetReport;
     procedure DesabBandasPess ;
     procedure LimpaMemoriaInd;
     function BuscaComponente( NomeComponente : string ) : boolean ;
  end;

var
  fmNutRelInd: TfmNutRelInd;

implementation

uses DMRelat, URTPCid, URTPCor, URTPEst, URTPInst, URTANac, URTPPessoa, URTPUsuario, UPess,
  DMRelPess, URelPesList, Pessoa, RelTot, RelTotPess, URPessoasPastas,URPastasPessoas;

{$R *.DFM}

procedure TfmNutRelInd.DesabBandasPess;
// desabilita todas as faixas do relatorio para facilitar a configuracao.
begin
   with fmRelPess do
     begin
       qbDadosPess.Enabled   := False;
       qsdDadosCompl.Enabled := False;
       qsdEnd.Enabled        := False;
       qbTelCab.Enabled      := False;
       qrTelefone.Enabled    := False;
       qrAnamNutr.Enabled    := False;
       qrAntrop.Enabled      := False;
       qrInqAlim.Enabled     := False;
       qrPlanoAlim.Enabled   := False;
       qrExLab.Enabled       := False;
       qrPastas.Enabled      := False;
     end;
end;

function TfmNutRelInd.BuscaComponente( NomeComponente : string ) : boolean ;
begin
   // Verifica se o componente ja' existe na aplicacao
   if Application.FindComponent( NomeComponente ) = nil then
      Result := False
   else
      Result := True;
end;

procedure TfmNutRelInd.LimpaMemoriaInd ;
begin
   // liberando os relatorios da memoria
   if fmRelPesList <> nil then
      FreeAndNil( fmRelPesList );
   if fmRelPess <> nil then
      FreeAndNil( fmRelPess );
   if fmRelTotPess <> nil then
      FreeAndNil( fmRelTotPess );
   if fmRTPCid <> nil then
      FreeAndNil( fmRTPCid );
   if fmRTPCor <> nil then
      FreeAndNil( fmRTPCor );
   if fmRTPEst <> nil then
      FreeAndNil( fmRTPEst );
   if fmRTPInst <> nil then
      FreeAndNil( fmRTPInst );
   if fmRTPNac <> nil then
      FreeAndNil( fmRTPNac );
   if fmRTPProf <> nil then
      FreeAndNil( fmRTPProf );
   if fmRTPUsuario <> nil then
      FreeAndNil( fmRTPUsuario );
   if fmRelPessoasporPastas <> nil then
      FreeAndNil( fmRelPessoasporPastas );
   if fmRelPastasporPessoas <> nil then
      FreeAndNil( fmRelPastasporPessoas );
   Report := nil;
end;

procedure TfmNutRelInd.SetReport(Value : TQuickRep);
begin
  FReport:=Value;
end;

procedure TfmNutRelInd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     DMRelPessoa.free;
     LimpaMemoriaInd;
 //    Action := caFree;
end;

procedure TfmNutRelInd.edPesqPessChange(Sender: TObject);
begin
   DMRelPessoa.TbPessoa.Locate('NomePess', edPesqPess.Text, [loPartialKey] );
end;

procedure TfmNutRelInd.rgTipoPesClick(Sender: TObject);
begin
   if rgTipoPes.ItemIndex = 0 then // Ficha
      begin
        gbPesqPess.Visible  := True;
        gbFichaPess.Visible := True;
        rgList.Visible      := False;
      end
   else if rgTipoPes.ItemIndex = 1 then
      begin                      // Listagem
        gbPesqPess.Visible  := False;
        gbFichaPess.Visible := False;
        rgList.Visible      := True;
      end
   else     // Totais
      begin                      // Listagem
        gbPesqPess.Visible  := False;
        gbFichaPess.Visible := False;
        rgList.Visible      := False;
 //       Report := fmRelTotPess.Report;
      end
end;

procedure TfmNutRelInd.btPrevPesClick(Sender: TObject);
begin
    Screen.Cursor := crHourGlass;

      if ConfiguraReport then
         begin
          try
             Report.PreviewModal;
          finally
             LimpaMemoriaInd; // dá um free em vários itens
          end;
         end;

    Screen.Cursor := crDefault;
end;

procedure TfmNutRelInd.FormCreate(Sender: TObject);
begin
   Application.CreateForm(TDMRelPessoa, DMRelPessoa);
   pgcRelatorio.ActivePage := tbsRelIndividuos ;
end;

procedure TfmNutRelInd.btVisTabPesClick(Sender: TObject);
begin
    Screen.Cursor := crHourGlass;
 
      if ConfiguraReport2 then
         begin
          try
             Report.PreviewModal;
          finally
             LimpaMemoriaInd; // dá um free em vários itens
          end;
         end;
     Screen.Cursor := crDefault;
end;

procedure TfmNutRelInd.btFecharClick(Sender: TObject);
begin
   Close;
end;

procedure TfmNutRelInd.btFecharTabIndClick(Sender: TObject);
begin
  Close;
end;

function TfmNutRelInd.ConfiguraReport: Boolean;
var
  Config : string;
begin
   Result := True;

   if rgTipoPes.ItemIndex = 0 then // Ficha
      begin
      if fmRelPess = nil then
         Application.CreateForm(TfmRelPess, fmRelPess);
      Report := fmRelPess.Report; //qrPess
      end
   else if rgTipoPes.ItemIndex = 1 then
        begin
          if  rgList.ItemIndex = 0 then    // Listagem
              begin
              if fmRelPesList = nil then
                 Application.CreateForm(TfmRelPesList, fmRelPesList);
              Report := fmRelPesList.Report;
              end
          else if  rgList.ItemIndex = 1   then  // Pessoas Por Pastas
              begin
              if fmRelPessoasporPastas = nil then
                 Application.CreateForm(TfmRelPessoasporPastas, fmRelPessoasporPastas);
              Report := fmRelPessoasporPastas.Report;
              end
          else if  rgList.ItemIndex = 2  then   // Pessoas Por Pastas
              begin
              if fmRelPastasporPessoas = nil then
                 Application.CreateForm(TfmRelPastasporPessoas, fmRelPastasporPessoas);
              Report := fmRelPastasporPessoas.Report;
              end
        end
   else     // Totais
        begin
        if fmRelTotPess = nil then
           Application.CreateForm(TfmRelTotPess, fmRelTotPess);
        Report := fmRelTotPess.Report;    // Listagem
        end;
   if Report.Owner.name = 'fmRelPess' then
      Begin
//        Config  := 'NomePess = ''' + fmRelatorios.grPess.SelectedField.AsString  + '''' ;
        Config  := 'IDPessoa = ''' + DMRelPessoa.TbPessoaIDPessoa.asString  + '''' ;
        DMRelPessoa.TbPessoa.Filter := Config ;
        DMRelPessoa.TbPessoa.Filtered := True;

        fmNutRelInd.DesabBandasPess;

        if clFichaPess.Checked[0] then  // dados pessoais
           fmRelPess.qbDadosPess.Enabled := True ;
        if clFichaPess.Checked[1] then  // dados complementares
           fmRelPess.qsdDadosCompl.Enabled := True ;
        if clFichaPess.Checked[2] then  // endereco
           fmRelPess.qsdEnd.Enabled := True ;
        if clFichaPess.Checked[3] then  // telefones
           begin
             fmRelPess.qbTelCab.Enabled   := True;
             fmRelPess.qrTelefone.Enabled := True;
           end;
        if clFichaPess.Checked[4] then  // Anamnese Nutricional
           fmRelPess.qrAnamNutr.Enabled := True;
//        if clFichaPess.Checked[5] then  // Antropometria
//           fmRelPess.qrAntrop.Enabled   := True;
//        if clFichaPess.Checked[6] then  // Inquerito Alimentar
//           fmRelPess.qrInqAlim.Enabled  := True;
//        if clFichaPess.Checked[7] then  // Plano Alimentar
//           fmRelPess.qrPlanoAlim.Enabled := True;
        if clFichaPess.Checked[5] then  // Exames Laboratoriais
           fmRelPess.qrExLab.Enabled     := True;
        if clFichaPess.Checked[6] then  // Pastas
           fmRelPess.qrPastas.Enabled    := True;

      End;
      if Report = nil then
      begin
         ShowMessage( 'Verifique se escolheu corretamente seu relatório. ');
         Result := False;
      end;
end;

procedure TfmNutRelInd.btImprimirClick(Sender: TObject);
begin
   if MessageDlg('Confirma a impressão?', mtConfirmation,
         [mbYes, mbNo], 0) = mrYes then
      begin
       if ConfiguraReport then
         begin
          try
             Report.Print;
          finally
             LimpaMemoriaInd; // dá um free em vários itens
          end;
         end;
      end;
end;

procedure TfmNutRelInd.btImpTabIndClick(Sender: TObject);
begin
   if MessageDlg('Confirma a impressão?', mtConfirmation,
         [mbYes, mbNo], 0) = mrYes then
      begin
       if ConfiguraReport2 then
         begin
          try
             Report.Print;
          finally
             LimpaMemoriaInd; // dá um free em vários itens
          end;
         end;
      end;

end;

function TfmNutRelInd.ConfiguraReport2: Boolean;
begin
 Result := True;
 with rgTabPes do
 begin

   if ItemIndex = 0 then
      begin
      if fmRTPCid = nil then
         begin
             Application.CreateForm(TfmRTPCid, fmRTPCid);
             Report := fmRTPCid.Report;
         end
      else
         Result := False;
      end
   else if ItemIndex = 1  then
      begin
      if fmRTPCor = nil then
         begin
            Application.CreateForm(TfmRTPCor, fmRTPCor);
            Report := fmRTPCor.Report;
         end
      else
         Result := False;
      end
   else if ItemIndex = 2  then
      begin
      if fmRTPEst = nil then
         begin
            Application.CreateForm(TfmRTPEst, fmRTPEst);
            Report := fmRTPEst.Report;
         end
      else
         Result := False;
      end
   else if ItemIndex = 3  then
      begin
      if fmRTPInst = nil then
         begin
            Application.CreateForm(TfmRTPInst, fmRTPInst);
            Report := fmRTPInst.Report;
         end
      else
         Result := False;
      end
   else if ItemIndex = 4  then
      begin
      if fmRTPNac = nil then
         begin
            Application.CreateForm(TfmRTPNac, fmRTPNac);
            Report := fmRTPNac.Report;
         end
      else
         Result := False;
      end
   else if ItemIndex = 5  then
      begin
      if fmRTPProf = nil then
         begin
             Application.CreateForm(TfmRTPProf, fmRTPProf);
             Report := fmRTPProf.Report;
         end
      else
         Result := False;
      end
   else if ItemIndex = 6  then
      begin
      if fmRTPUsuario = nil then
         begin
             Application.CreateForm(TfmRTPUsuario, fmRTPUsuario);
             Report := fmRTPUsuario.Report;
         end
      else
         Result := False;
      end;
 end;

end;

end.

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




unit UCadPastas;

interface      

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBListView98, StdCtrls, DBCtrls, Menus, Grids, DBGrids, ComCtrls, Buttons,
  ExtCtrls, DBMyNav, Mask, db, ImgList, ActnList;

type
  TfmCadPastas = class(TForm)
    pcPastas: TPageControl;
    ilFigPastas1: TImageList;
    tsPastas: TTabSheet;
    lvPastas: TDBListView;
    btFechar: TButton;
    sbModo: TSpeedButton;
    laIndiv: TLabel;
    ilFigPastas: TImageList;
    tsIndPas: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    tsPasInd: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    puIndividuos: TPopupMenu;
    puCadPastas: TPopupMenu;
    VerIndiv: TMenuItem;
    AtribuirparaPastas1: TMenuItem;
    VisualizaodasPastas1: TMenuItem;
    ExcluirIndivduos1: TMenuItem;
    tsCadPastas: TTabSheet;
    CadPastas: TMenuItem;
    laPastas: TLabel;
    tePastas: TDBText;
    laExplicacao: TLabel;
    SpeedButton4: TSpeedButton;
    lvPess: TDbListView;
    grPasta: TDBGrid;
    grInd: TDBGrid;
    grPastas: TDBGrid;
    DBGrid4: TDBGrid;
    DBText2: TDBText;
    dePastas: TDBText;
    deInd: TDBText;
    dePasta: TDBText;
    DBMyNav1: TDBMyNav;
    paCadPastas: TPanel;
    deNome: TDBEdit;
    Label7: TLabel;
    spVisual: TSpeedButton;
    lvCadPastas: TDbListView;
    nvPastas: TDBMyNav;
    teSobr: TDBText;
    procedure btFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure sbModoClick(Sender: TObject);
    procedure deNomeKeyPress(Sender: TObject; var Key: Char);
    procedure lvPastasDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvPastasDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure VerIndivClick(Sender: TObject);
    procedure CadPastasClick(Sender: TObject);
    procedure spVisualClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure nvPastasClick(Sender: TObject; Button: TMyNavigateBtn);
    procedure lvCadPastasClick(Sender: TObject);
    procedure lvPessClick(Sender: TObject);
    procedure pcPastasChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCadPastas: TfmCadPastas;

implementation

uses Pessoa;



{$R *.DFM}

procedure TfmCadPastas.btFecharClick(Sender: TObject);
begin
   if (DMPessoa.TbPastas.State = dsInsert) or (DMPessoa.TbPastas.State = dsEdit) then  // Cadastramento de Pastas sem salvar
    begin
       if MessageDlg('Deseja salvar seus dados ? ', mtConfirmation,
         [mbYes, mbNo], 0) = mrYes then
         begin
          DMPessoa.TbPastas.Post;
         end
       else
         begin
          DMPessoa.TbPastas.Cancel;
         end;
    end;
    Close;

end;

procedure TfmCadPastas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     Action := caFree ;
end;

procedure TfmCadPastas.Button2Click(Sender: TObject);
begin
    DMPessoa.TbCadPastas.Insert;
    DMPessoa.TbCadPastasIdPasta.AsString   := DMPessoa.TbPastasIdPasta.AsString;
    DMPessoa.TbCadPastasIdPessoa.asString  := DMPessoa.TbPessoaIDPessoa.AsString;
    DMPessoa.TbCadPastasDataCad.AsDateTime := Date() ;
    DMPessoa.TbCadPastas.Post;
end;

procedure TfmCadPastas.sbModoClick(Sender: TObject);
begin
    if  lvPastas.ViewStyle = vsIcon  then
        lvPastas.ViewStyle := vsList
    else if  lvPastas.ViewStyle = vsList  then
        lvPastas.ViewStyle := vsReport
    else if  lvPastas.ViewStyle = vsReport  then
        lvPastas.ViewStyle := vsSmallIcon
    else if  lvPastas.ViewStyle = vsSmallIcon  then
        lvPastas.ViewStyle := vsIcon ;
end;

procedure TfmCadPastas.deNomeKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(13) then
       begin
       key := chr(0);
       if (DMPessoa.TbPastas.State = dsEdit) or
          (DMPessoa.TbPastas.State = dsInsert) then
           begin
            DMPessoa.TbPastas.Post ;
            DMPessoa.TbPastasbk.Refresh;
           end;
       end;

end;

procedure TfmCadPastas.lvPastasDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   Accept := Source is TdbListView;
end;

procedure TfmCadPastas.lvPastasDragDrop(Sender, Source: TObject; X,
  Y: Integer);


begin
  if (Sender is TdbListView) and (Source is TdbListView) and not (DMPessoa.TbPastas.IsEmpty) then
  begin
     lvPastas.selected := lvPastas.GetItemAt(x,y);
     if MessageDlg('Movendo '+ Trim(DMPessoa.TbPessoabk.FieldByName('NomePess').AsString) + ' ' + DMPessoa.TbPessoabkSobrPess.AsString
         + ' para ' + DMPessoa.TbPastas.FieldByName('NomePasta').AsString , mtConfirmation,
       [mbYes, mbNo], 0) = mrYes then
       begin
        with DMPessoa do
        begin
          try
           begin
            if TbCadPastas.Locate('IDPESSOA;IDPASTA',VarArrayOf([TbPessoabk['IdPessoa'], TbPastas['IdPasta']]),[]) then
               ShowMessage(' Este indivíduo já está cadastrado ! ')
            else
               begin
                TbCadPastasbk.Insert;
                TbCadPastasbk.Fieldbyname('IdPasta').AsString   := TbPastas.FieldByName('IdPasta').asString;
                TbCadPastasbk.Fieldbyname('IdPessoa').asString  := TbPessoabk.Fieldbyname('IdPessoa').asString ;
                TbCadPastasbk.Fieldbyname('DataCad').AsDateTime := Date();
                TbCadPastasbk.Post ;
                TbCadPastasbk.Refresh;
                TbCadPastasInd.Refresh;
                TbCadPastas.Refresh;

                ShowMessage( 'Atribuição feita com sucesso !!!');
               end
           end
         except
            TbCadPastasbk.Cancel;
         end;
       end;
      end;
     end
     else
     // Caso esteja sem nenhuma pasta cadastrada
      begin
         ShowMessage('Cadastre as pastas antes de fazer a atribuição.'); 

      end;

end;

procedure TfmCadPastas.VerIndivClick(Sender: TObject);
begin

    pcPastas.ActivePage := tsIndPas;
end;

procedure TfmCadPastas.CadPastasClick(Sender: TObject);
begin
    pcPastas.ActivePage := tsCadPastas;
end;

procedure TfmCadPastas.spVisualClick(Sender: TObject);
begin
    if  lvCadPastas.ViewStyle = vsIcon  then
        lvCadPastas.ViewStyle := vsList
    else if  lvCadPastas.ViewStyle = vsList  then
        lvCadPastas.ViewStyle := vsReport
    else if  lvCadPastas.ViewStyle = vsReport  then
        lvCadPastas.ViewStyle := vsSmallIcon
    else if  lvCadPastas.ViewStyle = vsSmallIcon  then
        lvCadPastas.ViewStyle := vsIcon ;
end;

procedure TfmCadPastas.SpeedButton4Click(Sender: TObject);
begin
    if  lvPess.ViewStyle = vsIcon  then
        lvPess.ViewStyle := vsList
    else if  lvPess.ViewStyle = vsList  then
        lvPess.ViewStyle := vsReport
    else if  lvPess.ViewStyle = vsReport  then
        lvPess.ViewStyle := vsSmallIcon
    else if  lvPess.ViewStyle = vsSmallIcon  then
        lvPess.ViewStyle := vsIcon ;
end;

procedure TfmCadPastas.FormCreate(Sender: TObject);
begin
    pcPastas.ActivePage := tsIndPas;
    DMPessoa.TbPessoabk.GotoBookmark(DMPessoa.TbPessoa.GetBookmark);
 
end;

procedure TfmCadPastas.nvPastasClick(Sender: TObject;
  Button: TMyNavigateBtn);
begin
   paCadPastas.Enabled := True;
   if ( button = nbEdit ) or ( button = nbInsert ) then
     deNome.SetFocus
   else
     paCadPastas.Enabled := False;
   DMPessoa.TbPastasbk.Refresh;


end;

procedure TfmCadPastas.lvCadPastasClick(Sender: TObject);
begin
    DMPessoa.TbPastas.GotoBookmark(DMPessoa.TbPastasbk.GetBookmark);
end;

procedure TfmCadPastas.lvPessClick(Sender: TObject);
begin
     if DMPessoa.TbPessoabk.RecordCount = 0 then
     begin
        ShowMessage('Não temos nenhuma pessoa cadastrada.');
     end

     else
      begin
       lvPess.DragMode := dmManual;
       lvPess.DragMode := dmAutomatic ;
       lvPess.BeginDrag( true, 1);
      end;
end;

procedure TfmCadPastas.pcPastasChange(Sender: TObject);
begin
   // verifica se inseriu ou editou e esqueceu de salvar
   if (pcPastas.ActivePage <> tsCadPastas) and
      ((DMPessoa.TbPastas.State = dsInsert) or (DMPessoa.TbPastas.State = dsEdit)) then  // Cadastramento de Pastas
      begin
        pcPastas.ActivePage := tsCadPastas; // posiciona e pede para gravar
        ShowMessage('Atenção ! Use o botão Salvar para gravar seus dados ou Cancelar para desistir.');
      end
   else
   begin
    if pcPastas.ActivePage = tsIndPas then  // Indivíduos pelas Pastas
      begin
        DMPessoa.TbCadPastas.Refresh;
        DMPessoa.TbPastas.Refresh;
      end
    else if pcPastas.ActivePage = tsPasInd then  // Pastas pelos Indivíduos
      begin
        DMPessoa.TbPessoabk.Refresh;
        DMPessoa.TbCadPastasInd.Refresh;
      end
    else if pcPastas.ActivePage = tsCadPastas then  // Cadastramento de Pastas
      begin
       // DMPessoa.TbPastasbk.Refresh;
       // DMPessoa.TbPastas.Refresh;
        DMPessoa.TbPastas.First;
      end
    else if pcPastas.ActivePage = tsPastas then     // Atribuição de Indivíduos nas Pastas
      begin
        DMPessoa.TbPastas.Refresh;
        DMPessoa.TbPastas.First;
      end ;
   end;
end;

end.

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




unit UDupAlim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, RXDBCtrl, StdCtrls, ExtCtrls, db, DBMyNav, Buttons,
  DBCtrls, Mask, NutCnst, RXLookup;

type
  TfmDupAlim = class(TForm)
    paDuplAlim: TPanel;
    grAlim: TRxDBGrid;
    edAlim: TEdit;
    laPesqAli: TLabel;
    DBMyNav1: TDBMyNav;
    btDupl: TBitBtn;
    btCancelar: TBitBtn;
    paConfDupl: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btOk: TBitBtn;
    btCanc: TBitBtn;
    deAlim: TDBEdit;
    lcOrigem: TRxDBLookupCombo;
    edOrigem: TEdit;
    laDupl2: TLabel;
    laDupl: TLabel;
    procedure grAlimGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure edAlimClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btDuplClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btCancClick(Sender: TObject);
    procedure btFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lcOrigemChange(Sender: TObject);
    procedure edOrigemExit(Sender: TObject);
    procedure lcOrigemEnter(Sender: TObject);
    procedure lcOrigemCloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDupAlim: TfmDupAlim;

implementation

uses DMAliPrep, NutMenu;

{$R *.DFM}

procedure TfmDupAlim.grAlimGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
   // se for diferente da USDA, coloca azul
   if Field.DataSet.FieldByName('IDORIG').asString <> '{B970DAE1-B505-11D1-B683-00001D13DDBD}' then
      AFont.Color := clBlue;
   if Field.DataSet.FieldByName('PREP').asString = 'T' then
     Background := clGray;

end;

procedure TfmDupAlim.edAlimClick(Sender: TObject);
begin
    edAlim.Text := '';
end;

procedure TfmDupAlim.FormShow(Sender: TObject);
begin
     DMAlimentos.TbAlimentoBk.First;
end;

procedure TfmDupAlim.btCancelarClick(Sender: TObject);
begin
     Close;
end;

procedure TfmDupAlim.btDuplClick(Sender: TObject);
  var
  stNomeAli : string ;
  Cont : Integer;

begin
   // Seto a variavel com o codigo e nome do alimento a Duplicar
   DMAlimentos.CodAlimentoADuplicar := DMAlimentos.TbAlimentoBK.Fieldbyname('IDALI').asString ;
   DMAlimentos.AlimentoADuplicar := DMAlimentos.TbAlimentoBK.Fieldbyname('NOME').asString ;

   // Posiciono em TbAlimento para que possa duplicar este registro ...

  if DMAlimentos.TbAlimento.Locate( 'IDALI', DMAlimentos.TbAlimentoBK.Fieldbyname('IDALI').asString, [] ) then
  begin
    stNomeAli := DMAlimentos.TbAlimento.Fieldbyname('NOME').asString ;
    Cont := 2;
    // Só posso fazer se não for uma Preparação.
    if DMAlimentos.TbAlimento.Fieldbyname('IDGRUALI').asString <> '{88DD9369-66F8-11D1-A6A0-008048B86BEE}' then
    begin
        // acrescento uma nova identificação para este alimento
        stNomeAli := '('+ inttostr(Cont)+')' + DMAlimentos.TbAlimento.Fieldbyname('NOME').asString ;
        // se a nova identificação já existir, vou tentando outras ... ate´achar ...
        while DMAlimentos.TbAlimentobk.Locate( 'NOME', stNomeAli, [] ) do
        begin
          Cont := Cont + 1;
          stNomeAli := '('+ InttoStr(Cont)+')' + DMAlimentos.TbAlimento.FieldByName('NOME').asString ;
        end;
        paConfDupl.Visible := True;
        laDupl.Caption := DMAlimentos.AlimentoADuplicar;
        
        // vou gravar no banco TbAlimentobk as alterações que fiz ...
        DMAlimentos.TbAlimentoBk.Insert;
        DMAlimentos.TbAlimentoBk.FieldByName('IDALI').asString := CreateNewGUID;
        DMAlimentos.TbAlimentoBk.FieldByName('NOME').asString := stNomeAli;
        DMAlimentos.TbAlimentoBk.FieldByName('IDGRUALI').asString := DMAlimentos.TbAlimento.FieldByName('IDGRUALI').asString;
        DMAlimentos.TbAlimentoBk.FieldByName('PREP').AsString  := 'F';
    end
    else
    begin
        ShowMessage(' Não posso Duplicar uma Preparação' );
    end;
  end
  else
  begin
    ShowMessage(' Ocorreram Problemas na Duplicação. Tente novamente!' );
    DMAlimentos.TbAlimentoBk.Refresh;
  end;
end;

procedure TfmDupAlim.btOkClick(Sender: TObject);

begin
   if DMAlimentos.TbAlimentoBk.Fieldbyname('NOME').asString = ''  then
      begin
        ShowMessage('O campo Nome tem que ter um valor.');
        deAlim.SetFocus;
      end
   else if DMAlimentos.TbAlimentoBk.Fieldbyname('IDORIG').asString = '' then
      begin
       ShowMessage('O campo Origem tem que ter um valor.');
       lcOrigem.SetFocus;
      end
   else
       begin
         DMAlimentos.TbAlimentoBk.Post;

          // Faco uma query para pegar todos os dados nutricionais do alimento a ser duplicado
         DMAlimentos.qrDuplicaAlim.Active := False;
         DMAlimentos.qrDuplicaAlim.Params[0].AsString := DMAlimentos.CodAlimentoADuplicar ;
         DMAlimentos.qrDuplicaAlim.Active := True;

         paConfDupl.Visible := False;

         // Gravo os nutrientes

         DMAlimentos.qrDuplicaAlim.First;
         While not DMAlimentos.qrDuplicaAlim.Eof  do
         begin
           DMAlimentos.TbAliNutBK.Insert;
           DMAlimentos.TbAliNutBK.Fieldbyname('IDALI').asString := DMAlimentos.TbAlimentoBk.Fieldbyname('IDALI').asString;
           DMAlimentos.TbAliNutBK.Fieldbyname('IDNUT').asString := DMAlimentos.qrDuplicaAlim.Fieldbyname('IDNUT').asString ;
           DMAlimentos.TbAliNutBK.Fieldbyname('VALOR').asFloat  := DMAlimentos.qrDuplicaAlim.Fieldbyname('VALOR').asFloat;
           DMAlimentos.TbAliNutBK.Post;

           DMAlimentos.qrDuplicaAlim.Next;
         end ;

           DMAlimentos.TbAliNutBK.Refresh;

         paConfDupl.Visible := False;
         edAlim.Text := '' ;

      end ;

end;

procedure TfmDupAlim.btCancClick(Sender: TObject);
begin
   DMAlimentos.TbAlimentoBk.Cancel;
   paConfDupl.Visible := False;
   Close;
end;

procedure TfmDupAlim.btFecharClick(Sender: TObject);
begin
   DMAlimentos.TbAlimentoBk.Cancel;
   paConfDupl.Visible := False;
   Close;
end;

procedure TfmDupAlim.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    fm_MenuNut.HabilitaMenu;
    Action := caFree;
end;

procedure TfmDupAlim.lcOrigemChange(Sender: TObject);
begin

     // Verificar se a Origem é a USDA que mandamos. Se for, ele não deixa colocar.
     if  DMAlimentos.TbAlimentoBk.fieldbyname('IDORIG').AsString = '{B970DAE1-B505-11D1-B683-00001D13DDBD}' then
         begin
            ShowMessage('Escolha outra Origem.');
            lcOrigem.ResetField;
         end;
end;

procedure TfmDupAlim.edOrigemExit(Sender: TObject);
begin
    edOrigem.Visible := False;
    lcOrigem.Visible := True ;

 // se nao achar a origem, grava uma nova
      if edOrigem.Text = '' then
         begin
             DMAlimentos.TbAlimentobk.Edit;
             DMAlimentos.TbAlimentobk.Fieldbyname('IDORIG').asString := '' ;
         end
      else
       begin
        if not DMAlimentos.TbOrigem.Locate('DESCRICAO', edOrigem.Text, [loCaseInsensitive] ) then
         begin
           try
             DMAlimentos.TbOrigem.Insert;
             DMAlimentos.TbOrigem.Fieldbyname('DESCRICAO').asString := edOrigem.Text;
             DMAlimentos.TbOrigem.Post;
           except
             on Exception do ShowMessage( 'Erro na Inserção!!');
           end;
         end;

        // se achei a origem, ela já estando cadastrada ...
        DMAlimentos.TbAlimentobk.Edit;
        DMAlimentos.TbAlimentobk.Fieldbyname('IDORIG').asString := DMAlimentos.TbOrigem.Fieldbyname('IDORIG').asString ;

       end;


end;

procedure TfmDupAlim.lcOrigemEnter(Sender: TObject);
begin
// Filtra o banco origem para nao aparecer a USDA
    DMAlimentos.TbOrigem.Filtered := True;
end;

procedure TfmDupAlim.lcOrigemCloseUp(Sender: TObject);
begin
// Controlar inclusao de nova Origem

  If lcOrigem.Text = 'Nova Origem' then
     begin
        lcOrigem.Visible := False;
        edOrigem.Visible := True ;
        edOrigem.Text := '';
        edOrigem.SetFocus;
     end;

// Libera o banco origem para aparecer a USDA
    DMAlimentos.TbOrigem.Filtered := False;

end;

end.

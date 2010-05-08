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




unit DelForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, ExtCtrls, OCXDCNLib_TLB, DicNut;

type
  TfrDelete = class(TForm)
    HowDel: TRadioGroup;
    OK: TButton;
    Cancel: TButton;
    lbNodes: TListBox;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    dbeCodPai: TDBText;
    GroupBox2: TGroupBox;
    dbeCodeNode: TDBText;
    dbeDescNode: TDBText;
    DBText1: TDBText;
    procedure OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    pai,filho : string;
  end;


implementation

uses DMFrml;

{$R *.DFM}

procedure TfrDelete.OKClick(Sender: TObject);
var
I : Integer;
Desc, FilhoArvore, PaiArvore : WideString;
CountOfPais: integer;
begin

case HowDel.ItemIndex of
     0:
       begin
       with DMFormulas.PaisFilhos do
       if Locate('codpai_CNUT;codfilho_CNUT',VarArrayOf([pai,filho]),[]) then
          begin
          Delete;
          end;
       end;
     1:
       begin
       with DMFormulas.PaisFilhos do
       if Locate('codpai_CNUT;codfilho_CNUT',VarArrayOf([pai,filho]),[]) then
          begin
          Delete;
          end;
       for I:= 0 to lbNodes.Items.Count-1 do
           begin
           FilhoArvore:=lbNodes.Items[I];
           CountOfPais:=DMFormulas.Formulas.FindParents(FilhoArvore,PaiArvore);
           if lbNodes.Items.IndexOf(PaiArvore) <> -1 then
            with DMFormulas.PaisFilhos do
              begin
              if Locate('codpai_CNUT;codfilho_CNUT',VarArrayOf([PaiArvore,FilhoArvore]),[]) then
                 begin
                 Delete;
                 end;
              end;
           if CountOfPais > 1 then
              while DMFormulas.Formulas.GetNextParent(PaiArvore,Desc) do
                    begin
                    if lbNodes.Items.IndexOf(PaiArvore) <> -1 then
                      with DMFormulas.PaisFilhos do
                       begin
                       if Locate('codpai_CNUT;codfilho_CNUT',VarArrayOf([PaiArvore,FilhoArvore]),[]) then
                          begin
                          Delete;
                          end;
                       end;
                    end;
           end;
       end;
     2:
       begin
       with DMFormulas.PaisFilhos do
       if Locate('codpai_CNUT;codfilho_CNUT',VarArrayOf([pai,filho]),[]) then
          begin
          Delete;
          end;
       for I:= 0 to lbNodes.Items.Count-1 do
           begin
           FilhoArvore:=lbNodes.Items[I];
           CountOfPais:=DMFormulas.Formulas.FindParents(FilhoArvore,PaiArvore);
           if lbNodes.Items.IndexOf(PaiArvore) <> -1 then
              begin
              with DMFormulas.PaisFilhos do
                   begin
                   if Locate('codpai_CNUT;codfilho_CNUT',VarArrayOf([PaiArvore,FilhoArvore]),[]) then
                      begin
                      Delete;
                      end;
                   end;

              with DMFormulas.Flat do
                   begin
                   if Locate('cod_CNUT',FilhoArvore,[]) then
                      begin
                      Delete;
                      end;
                   end;

              with DMFormulas.TabFrml do
                   begin
                   if not Locate('Name',FilhoArvore,[]) then
                      begin
                      Delete;
                      end;
                   end;

              with DMFormulas.TabTab do
                   begin

                   if not Locate('Name',FilhoArvore,[]) then
                      begin
                      Delete;
                      end;
                   end;

              with DMFormulas.TabMed do
                   begin
                   if not Locate('Name',FilhoArvore,[]) then
                      begin
                      Delete;
                      end;
                   end;
              end;
           if CountOfPais > 1 then
              while DMFormulas.Formulas.GetNextParent(PaiArvore,Desc) do
                    begin
                    if lbNodes.Items.IndexOf(PaiArvore) <> -1 then
                       begin
                       with DMFormulas.PaisFilhos do
                            if Locate('codpai_CNUT;codfilho_CNUT',VarArrayOf([PaiArvore,FilhoArvore]),[]) then
                               begin
                               Delete;
                               end;

                       with DMFormulas.Flat do
                            if Locate('cod_CNUT',FilhoArvore,[]) then
                               begin
                               Delete;
                               end;


                       with DMFormulas.TabFrml do
                            begin
                            if not Locate('Name',FilhoArvore,[]) then
                               begin
                               Delete;
                               end;
                            end;

                       with DMFormulas.TabTab do
                            begin
                            if not Locate('Name',FilhoArvore,[]) then
                               begin
                               Delete;
                               end;
                            end;

                       with DMFormulas.TabMed do
                            begin
                            if not Locate('Name',FilhoArvore,[]) then
                               begin
                               Delete;
                               end;
                            end;
                        end;
                    end;
              end;
           end;
       end;
ModalResult:=mrOK;
end;

procedure TfrDelete.FormCreate(Sender: TObject);
var
Nodos : TStringList;
begin
   pai:=DMFormulas.PaisFilhos.FieldByName ('codpai_CNUT').AsString;
   filho:=DMFormulas.PaisFilhos.FieldByName ('codfilho_CNUT').AsString;
   Nodos:=TStringList.Create;
   lbNodes.Clear;
   DMFormulas.Formulas.ListAll(DMFormulas.Flat.FieldByName('cod_CNUT').AsString,Nodos);
   lbNodes.Items:=Nodos;
   Nodos.Free;
end;

end.

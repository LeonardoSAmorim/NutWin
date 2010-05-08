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




unit UPesqWiz;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Wizard;

type
  TfmPesq = class(TForm)
    wzPesq: TWizard;
    bbVoltar: TBitBtn;
    bbAvancar: TBitBtn;
    bbCancela: TBitBtn;
    bbTermina: TBitBtn;
    paWiz: TPanel;
    procedure wzPesqCreateForm(Sender: TObject; FormName: String;
      var FormClass: TFormClass; var Form: TForm);
    procedure FormCreate(Sender: TObject);
    procedure wzPesqProximoForm(Sender: TObject; FormAtual: String;
      var FormSeguinte: String; var Terminar: Boolean);
    procedure bbCancelaClick(Sender: TObject);
    procedure bbTerminaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Todos    : boolean;
    PesqAlim : boolean;
  end;

var
  fmPesq: TfmPesq;

implementation

uses UApresent, UIndiv, Unit1, USelDados, USelIndiv, USelRef, USelAlim,
  USelNut, UAlim, UFreqNut;

{$R *.DFM}

procedure TfmPesq.wzPesqCreateForm(Sender: TObject; FormName: String;
  var FormClass: TFormClass; var Form: TForm);
begin
   if FormName = 'fmPApresent' then
      begin
         FormClass := TfmPApresent ;
         Form      :=  fmPApresent ;
      end
   else if FormName = 'fmPSelIndiv' then
      begin
         FormClass := TfmPSelIndiv ;
         Form      :=  fmPSelIndiv ;
      end
   else if FormName = 'fmPPastas' then
      begin
         FormClass := TfmPPastas ;
         Form      := fmPPastas  ;
      end
   else if FormName = 'fmPSelDados' then
      begin
         FormClass := TfmPSelDados ;
         Form      := fmPSelDados  ;
      end
   else if FormName = 'fmPSelRef' then
      begin
         FormClass := TfmPSelRef ;
         Form      := fmPSelRef  ;
      end
   else if FormName = 'fmPSelAlim' then
      begin
         FormClass := TfmPSelAlim ;
         Form      := fmPSelAlim  ;
      end
   else if FormName = 'fmPSelNut' then
      begin
         FormClass := TfmPSelNut ;
         Form      := fmPSelNut  ;
      end
   else if FormName = 'fmPInq' then
      begin
         FormClass := TfmPInq ;
         Form      :=  fmPInq ;
      end
   else if FormName = 'fmPFrqNut' then
      begin
         FormClass := TfmPFrqNut ;
         Form      :=  fmPFrqNut ;
      end

end;

procedure TfmPesq.FormCreate(Sender: TObject);
begin
   wzPesq.Iniciar( 'fmPApresent' ) ;
end;

procedure TfmPesq.wzPesqProximoForm(Sender: TObject; FormAtual: String;
  var FormSeguinte: String; var Terminar: Boolean);
begin
   if FormAtual = 'fmPApresent' then
      begin
        if Todos then
           begin
              FormSeguinte := 'fmPSelDados' ;
           end
        else
           FormSeguinte := 'fmPPastas';
      end
   else if FormAtual = 'fmPPastas' then
      begin
        FormSeguinte := 'fmPSelDados' ;
      end
   else if FormAtual = 'fmPSelDados' then
      begin
        FormSeguinte := 'fmPSelIndiv' ;
      end
   else if FormAtual = 'fmPSelIndiv' then
      begin
         FormSeguinte := 'fmPInq' ;
      end
   else if  FormAtual = 'fmPInq' then
      begin
         FormSeguinte := 'fmPSelRef' ;
      end
   else if  FormAtual = 'fmPSelRef' then
      begin
         FormSeguinte := 'fmPFrqNut'
      end
    else if  FormAtual = 'fmPFrqNut' then
      begin
          if PesqAlim then
           begin
              FormSeguinte := 'fmPSelAlim' ;
              Terminar     := True      ;
           end
        else
           FormSeguinte := 'fmPSelNut';
           Terminar     := True      ;
      end

end;




procedure TfmPesq.bbCancelaClick(Sender: TObject);
begin
   Close;
end;

procedure TfmPesq.bbTerminaClick(Sender: TObject);
begin
   Close;
end;

end.

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




unit CacheDic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OCXDCNLib_TLB, DicNut, ComCtrls, TreeDic, ExtCtrls, Menus, Db,
  DBTables, ActiveX;

type
  TfmCacheDic = class(TForm)
    Panel1: TPanel;
    TreeDic1: TTreeDic;
    ListBox1: TListBox;
    Panel2: TPanel;
    TreeDic2: TTreeDic;
    ListBox2: TListBox;
    Panel3: TPanel;
    ListBox3: TListBox;
    TreeDic3: TTreeDic;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    Table1: TTable;
    Cache1: TMenuItem;
    Criar1: TMenuItem;
    N1: TMenuItem;
    Ativa1: TMenuItem;
    Desativa1: TMenuItem;
    CacheDic1: TCacheDic;
    Table1CODPROC: TStringField;
    Table1COMPPROC: TStringField;
    Table1MEDIDA: TStringField;
    Table1IDCACHE: TStringField;
    Database1: TDatabase;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TreeDic1Click(Sender: TObject; Code, Description: String);
    procedure TreeDic2Click(Sender: TObject; Code, Description: String);
    procedure TreeDic3Click(Sender: TObject; Code, Description: String);
    procedure Sair1Click(Sender: TObject);
    procedure Criar1Click(Sender: TObject);
    procedure Ativa1Click(Sender: TObject);
    procedure Desativa1Click(Sender: TObject);
  private
    { Private declarations }
    Lista : TStringList;
  public
    { Public declarations }
  end;

var
  fmCacheDic: TfmCacheDic;

function CreateNewGUID: string;

implementation

{$R *.DFM}

// Cria GUID
function CreateNewGUID: string;
var
   NewGUID: TGUID;
   NewString : array [0..49] of WideChar;
begin
   //new (pNewGUID);
   if Succeeded (CoCreateGuid(NewGUID)) then
      begin
      StringFromGUID2 (NewGUID, @NewString, 40);
      Result:= WideCharToString (NewString);
      end
   else
       Result:='';
end;

procedure TfmCacheDic.Button1Click(Sender: TObject);
begin
CacheDic1.CollectListInstances( 'prIMC',Lista );
ListBox1.Items := Lista;
end;

procedure TfmCacheDic.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Lista.Free;
end;

procedure TfmCacheDic.FormCreate(Sender: TObject);
begin
   Lista := TStringList.Create;

end;

procedure TfmCacheDic.TreeDic1Click(Sender: TObject; Code, Description: String);
begin
Lista.Clear;
CacheDic1.CollectAllInstances( Code,Lista );
ListBox1.Items := Lista;
if CacheDic1.Cached then
   ListBox1.Color := clRed
else
   ListBox1.Color := clWhite;
end;

procedure TfmCacheDic.TreeDic2Click(Sender: TObject; Code, Description: String);
begin
Lista.Clear;
CacheDic1.ListAll( Code,Lista );
ListBox2.Items := Lista;
if CacheDic1.Cached then
   ListBox2.Color := clRed
else
   ListBox2.Color := clWhite;

end;

procedure TfmCacheDic.TreeDic3Click(Sender: TObject; Code, Description: String);
begin
Lista.Clear;
CacheDic1.CollectListInstances( Code,Lista );
ListBox3.Items := Lista;
{if CacheDic1.Cached then
   ListBox3.Color := clRed
else
   ListBox3.Color := clWhite;}
end;

procedure TfmCacheDic.Sair1Click(Sender: TObject);
begin
Close;
end;

procedure TfmCacheDic.Criar1Click(Sender: TObject);
var
   calc, proc, med : Integer;
   ListaCalc,
   ListaProc,
   ListaMed : TStringList;
   Classe,
   ProcAtual : String;
   oldActiveCache : Boolean;
begin

   ProcAtual := 'XYZ';

   ListaCalc := TStringList.Create;
   ListaProc := TStringList.Create;
   ListaMed  := TStringList.Create;

   ListaCalc.Add( 'caAntrop' );
   ListaCalc.Add( 'caRecCal' );
   ListaCalc.Add( 'vlcaAntrop' );

   OldActiveCache := CacheDic1.ActiveCache;
   CacheDic1.ActiveCache := False;

  with Table1 do
  begin
   while not IsEmpty do Delete;
   for calc := 0 to ListaCalc.Count - 1 do
   begin
      ListaProc.Clear;

      CacheDic1.ListAll( ListaCalc.Strings[calc], ListaProc );

      for proc := 0 to ListaProc.Count - 1 do
      begin
         CacheDic1.GetAttributeByCode(ListaProc.Strings[proc], 'TIPO', Classe );
         if Classe = 'PROCEDIMENTO' then
         begin
            ProcAtual := ListaProc.Strings[proc];
            Append;
            FieldByName( 'IDCACHE' ).AsString := CreateNewGUID;
            FieldByName( 'CODPROC' ).AsString := ProcAtual;
            FieldByName( 'COMPPROC' ).AsString := ProcAtual;
            FieldByName( 'MEDIDA' ).AsString := 'F';
            if ListaMed.Count > 0 then
               ShowMessage( 'Houve um erro!' );

            CacheDic1.CollectAllInstances( ProcAtual, ListaMed );

         end
         else
         begin
            Append;
            FieldByName( 'IDCACHE' ).AsString := CreateNewGUID;
            FieldByName( 'CODPROC' ).AsString := ProcAtual;
            FieldByName( 'COMPPROC' ).AsString := ListaProc.Strings[proc];
            ListaMed.Sort;
            if ListaMed.Find( ListaProc.Strings[proc], Med ) then
             begin
               FieldByName( 'MEDIDA' ).AsString := 'T';
               ListaMed.Delete(Med);
             end
            else
               FieldByName( 'MEDIDA' ).AsString := 'F';
         end;
      end;
   end;
  end;

  CacheDic1.ActiveCache := OldActiveCache;

   ListaMed.Free;
   ListaProc.Free;
   ListaCalc.Free;

end;

procedure TfmCacheDic.Ativa1Click(Sender: TObject);
begin
   if not Ativa1.Checked then
     begin
      Ativa1.Checked := True;
      CacheDic1.ActiveCache := True;
     end;
end;

procedure TfmCacheDic.Desativa1Click(Sender: TObject);
begin
   if not Desativa1.Checked then
     begin
      Desativa1.Checked := True;
      CacheDic1.ActiveCache := False;
     end;

end;

end.

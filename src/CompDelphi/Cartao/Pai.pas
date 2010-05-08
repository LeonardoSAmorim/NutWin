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




unit Pai;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CCSListaLinks, CNSDBSUS, DBTables, CNSLib;

type
  TPai = class(TCustomDB)
  private
    { Private declarations }
    FNome : string;
    FCodigo : string;
    FCanUpdateInterno : boolean;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure CreateTable; override;
    procedure DropTable; override;
    procedure Carregar(P1, P2, P3, P4 : string); override;
    procedure Atualizar; override;
    procedure Novo; override;
    procedure Excluir; override;
//    property CanUpdade : boolean read FCanUpdateInterno write FCanUpdateInterno;
  published
    property AtivarFields;
    property DataSource;
    property CNSDataBase;
    property Banco;
    { Published declarations }
    property Nome : string read FNome write FNome;
    property Codigo : string read FCodigo write FCodigo;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TPai]);
end;

constructor TPai.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TableName := 'Pai';
  ObjectView.Add('select * from Pai');
end;

procedure TPai.CreateTable;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('CREATE TABLE  Pai');
         sql.add('( ');
         sql.add('Codigo      char(04),');
         sql.add('Nome     varchar(40)');
         sql.add(' )');
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
         except
            showmessage('erro pai');
            CNSDataBase.RollBack;
         end;
      end;
   end;
end;

procedure TPai.DropTable;
begin
   inherited DropTable;
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('DROP TABLE Filho');
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
         except
            CNSDataBase.RollBack;
            showmessage('erro destruindo Pai');
         end;
      end;
   end;
end;


procedure TPai.Carregar(P1, P2, P3, P4 : string);
var
   i : integer;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('select * from Pai where Codigo = :Codigo');
         ParamByName('Codigo').AsString := P1;
         Open;
         if not eof then
         begin
             FNome := FieldByName('Nome').AsString;
             FCanUpdateInterno := True;
         end else
         begin
             FNome := '';
             FCodigo := '';
             FCanUpdateInterno := False;
         end;
         FCodigo := P1;
         NotifyLinks(self, lLoad);
      end;
   end;
   CanUpdate := FCanUpdateInterno;
end;

procedure TPai.Atualizar;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         if not FCanUpdateInterno then
         begin
            sql.add(' INSERT INTO Pai (Codigo, Nome)');
            sql.add(' VALUES            (:Codigo, :Nome)');
            FCanUpdateInterno := True;
         end else
         begin
            sql.add(' UPDATE  Pai   SET Nome = :Nome');
            sql.add(' where Codigo = :Codigo');
            FCanUpdateInterno := True;
         end;
         //Dispara a notificacao para pedir as prop
         NotifyLinks(self, lUpDate);
         ParamByName('Codigo').AsString := FCodigo;
         ParamByName('Nome').AsString := FNome;
         //Avisa a componentes para passar os dados que eles estao tratando se ele existir;
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
            //Atulizar os componetes visuais que usam estas properties
            NotifyLinks(self, lRefreshViewer)
         except
             CNSDataBase.RollBack;
             showmessage('Atualizar Pai');
         end;
      end;
   end;
end;


procedure TPai.Novo;
{
         Metodo para iniciar propriedades com vazios;
}
var
   i : integer;
begin
   FCodigo := '';
   FNome := '';
   CanUpdate := False;
   FCanUpdateInterno := False;
   NotifyLinks(self, lRefreshViewer);
end;


procedure TPai.Excluir;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         if CanUpdate then
         begin
            sql.add('DELETE FROM  Pai');
            sql.add('where Codigo = :Codigo');
            NotifyLinks(self, lUpDate);
            ParamByName('Codigo').AsString := FCodigo;
            try
               CNSDataBase.StartTransaction;
               ExecSql;
               CNSDataBase.Commit;
               //Atualizar os componetes
               NotifyLinks(self, lRefreshViewer);
            except
               CNSDataBase.RollBack;
               showmessage('delete filho');
            end;
         end;
      end;
   end;
end;


end.

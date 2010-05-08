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




unit Filho;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CCSListaLinks, CNSDBSUS, Pai, DBTables;

type
  TFilho = class(TPai)
  private
    { Private declarations }
    FCanUpdateInterno : boolean;
    FAtributoFilho : string;
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
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
    property ExcluirHeranca;
    property AtributoFilho : string read FAtributoFilho write FAtributoFilho;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TFilho]);
end;

constructor TFilho.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TableName := 'Filho';
  ObjectView.Clear;
  ObjectView.Add('select * from Pai, Filho');
  ObjectView.Add('where Pai.Codigo = Filho.Codigo');
end;

destructor TFilho.Destroy;
begin
  inherited Destroy;
end;

procedure TFilho.CreateTable;
begin
   inherited CreateTable;
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('CREATE TABLE  Filho');
         sql.add('( ');
         sql.add('Codigo                char(04),');
         sql.add('AtributoFilho     varchar(10)');
         sql.add(' )');
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
         except
            showmessage('erro Filho');
            CNSDataBase.RollBack;
         end;
         close;
         sql.clear;
         sql.add('CREATE VIEW FILHOVIEW AS SELECT');
         sql.add('Filho.AtributoFilho ATFilho, Pai.Nome Nome');
         sql.add('From Filho, Pai');
         sql.add('where Filho.Codigo = Pai.Codigo');
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
         except
            showmessage('erro view filho');
            CNSDataBase.RollBack;
         end;
      end;
   end;
end;

procedure TFilho.DropTable;
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
            showmessage('erro destruindo filho');
         end;
      end;
   end;
end;


procedure TFilho.Carregar(P1, P2, P3, P4 : string);
var
   i : integer;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('select * from Filho where Codigo = :Codigo');
         ParamByName('Codigo').AsString := P1;
         Open;
         if not eof then
         begin
             FAtributoFilho := FieldByName('AtributoFilho').AsString;
             FCanUpdateInterno := True;
         end else
         begin
             FAtributoFilho := '';
             FCanUpdateInterno := False;
         end;
         Codigo := P1;
         NotifyLinks(self, lLoad);
      end;
   end;
   inherited Carregar(p1, p2, p3, p4);
   CanUpdate := FCanUpDateInterno;
end;

procedure TFilho.Atualizar;
begin
   inherited Atualizar;
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         if not FCanUpdateInterno then
         begin
            sql.add(' INSERT INTO Filho (Codigo, AtributoFilho)');
            sql.add(' VALUES            (:Codigo, :AtributoFilho)');
            FCanUpdateInterno := True;
         end else
         begin
            sql.add(' UPDATE  Filho SET AtributoFilho = :AtributoFilho');
            sql.add(' where Codigo = :Codigo');
            FCanUpdateInterno := True;
         end;
         //Dispara a notificacao para pedir as prop
         ParamByName('Codigo').AsString := Codigo;
         ParamByName('AtributoFilho').AsString := FAtributoFilho;
         //Avisa a componentes para passar os dados que eles estao tratando se ele existir;
         try
            CNSDataBase.StartTransaction;
            ExecSql;
            CNSDataBase.Commit;
            //Atulizar os componetes visuais que usam estas properties
         except
            CNSDataBase.RollBack;
            showmessage('Atualizar filho');
         end;
      end;
   end;
end;

procedure TFilho.Novo;
{
         Metodo para iniciar propriedades com vazios;
}
var
   i : integer;
begin
   FAtributoFilho := '';
   FCanUpdateInterno := False;
   inherited Novo;
end;


procedure TFilho.Excluir;
begin
   if ExcluirHeranca then
      inherited Excluir;
   if assigned(DataSource) and assigned(DataSource.Dataset) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         if FCanUpdateInterno then
         begin
            sql.add('DELETE FROM  Filho');
            sql.add(' where Codigo = :Codigo');
            ParamByName('Codigo').AsString := Codigo;
            try
               CNSDataBase.StartTransaction;
               ExecSql;
               CNSDataBase.Commit;
               //Atualizar os componetes
            except
               CNSDataBase.RollBack;
               showmessage('delete filho');
            end;
         end;
      end;
   end;
end;

end.

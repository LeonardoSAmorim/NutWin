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




{ ****************************************************************** }
{                                                                    }
{   VCL component TCNSLog                                            }
{                                                                    }
{                                                                    }
{                                                                    }
{   on 20 July 1998 at 10:26                                         }
{                                                                    }
{   Copyright © 1998 by CCS-SIS Consórcio de Componentes de Software }
{                                                                    }
{ ****************************************************************** }

unit CNSLog;

interface

uses WinTypes, WinProcs, Messages, SysUtils, Classes, Controls, Dialogs,
     Forms, Graphics, Dbtables, Db , CNSCartaoSUS, CNSLote,
     CNSDBSus, CNSLib, CNSPessoa;

type
  TCNSVersaoStatus = (ocultar, mostrar);
  TCNSLog = class(TCNSDBSUS)
    private
      { Private fields of TCNSLog }
        FVersao : TCNSVersaoStatus;
        { Storage for property CodTran }
        FCodTran : String;
//        FDataSource : TDataSource;
        { Storage for property UsuarioAfetado }
        FUsuarioAfetado : TCNSUsuario;
        { Storage for property FuncResponsavel }
        FFuncResponsavel : TCNSPessoa;
        FLoteAfetado : TCNSLote;

      { Private methods of TCNSLog }
        { Method to set variable and property values and create objects }
        procedure AutoInitialize;
        { Method to free any objects created by AutoInitialize }
        procedure AutoDestroy;
        procedure SetVersao( mostra : TCNSVersaoStatus);

    protected
      { Protected fields of TCNSLog }

      { Protected methods of TCNSLog }
        { Resets prop of component type if referenced component deleted }
        procedure Notification(AComponent : TComponent; Operation : TOperation); override;
        procedure Loaded; override;

    public
      { Public fields and properties of TCNSLog }

      { Public methods of TCNSLog }
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        function Execute : Boolean;
        procedure InsereLog(ct : String);
        procedure LimpaLog;
        { Codigo da transação }
        property CodTran : String read FCodTran write FCodTran;
    published
      { Published properties of TCNSLog }
        property Versao : TCNSVersaoStatus
                 read FVersao write SetVersao;
//        property DataSource : TDataSource read FDataSource write FDataSource;
        property UsuarioAfetado : TCNSUsuario
             read FUsuarioAfetado write FUsuarioAfetado;
        property LoteAfetado : TCNSLote
             read FLoteAfetado write FLoteAfetado;
        property FuncResponsavel : TCNSPessoa
             read FFuncResponsavel write FFuncResponsavel;

  end;
var
   verstr: String;
procedure Register;

implementation

procedure Register;
begin
     { Register TCNSLog with CARTAO as its
       default page on the Delphi component palette }
     RegisterComponents('CARTAO', [TCNSLog]);
end;

{ Method to set variable and property values and create objects }
procedure TCNSLog.AutoInitialize;
begin
     
     FVersao := ocultar;
     verstr := 'TCNSLOG - Versao 1.0 de 21/09/1998';
end; { of AutoInitialize }

{ Resets prop of component type if referenced component deleted }
procedure TCNSLog.Notification(AComponent : TComponent; Operation : TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of 
       this component been deleted?  If so, update 
       the property. }
//     if AComponent = FDataSource then
//        FDataSource := nil;
     if AComponent = FFuncResponsavel then
        FFuncResponsavel := nil;
     if AComponent = FLoteAfetado then
        FLoteAfetado := nil;
     if AComponent = FUsuarioAfetado then
        FUsuarioAfetado := nil;
end;

{ Method to free any objects created by AutoInitialize }
procedure TCNSLog.AutoDestroy;
begin
     { No objects from AutoInitialize to free }
end; { of AutoDestroy }

constructor TCNSLog.Create(AOwner: TComponent);
begin
     { Call the Create method of the parent class }
     inherited Create(AOwner);

     { AutoInitialize sets the initial values of variables and      }
     { properties; also, it creates objects for properties of       }
     { standard Delphi object types (e.g., TFont, TTimer,           }
     { TPicture) and for any variables marked as objects.           }
     { AutoInitialize method is generated by Component Create.      }
     AutoInitialize;

     { Code to perform other tasks when the component is created }

end;

destructor TCNSLog.Destroy;
begin
     { AutoDestroy, which is generated by Component Create, frees any   }
     { objects created by AutoInitialize.                               }
     AutoDestroy;

     { Here, free any other dynamic objects that the component methods  }
     { created but have not yet freed.  Also perform any other clean-up }
     { operations needed before the component is destroyed.             }

     { Last, free the component by calling the Destroy method of the    }
     { parent class.                                                    }
     inherited Destroy;
end;

procedure TCNSLog.Loaded;
begin
     inherited Loaded;

     { Perform any component setup that depends on the property
       values having been set }

end;

function TCNSLog.Execute : Boolean;
begin
     { Perform the component operation }

     { Return True if the operation was successful, False otherwise }
     Result := True
end;

procedure TCNSLog.SetVersao( mostra : TCNSVersaoStatus);
begin
     { mostra a versao - somente para tempo de projeto }

     if mostra = mostrar then
     begin
     ShowMessage(verstr);
     FVersao := ocultar;
     end;
end;
procedure TCNSLog.LimpaLog;
var Linha : String;
    i : shortint;
    filen : String;
    arqtxt : TextFile;
    dial : TOpenDialog;
    e : ELog;
begin
   if assigned(DataSource) and assigned(DataSource.DataSet) then
   begin
      with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('SELECT * FROM log');
         try
           open;
         except
             on h1 : EDatabaseError do
               begin
               e := ELog.Create('E0012 - Erro lendo linhas do log para limpar');
               e.CodErro := 1;
               raise e;
               end;
         end;
         dial:=TOpenDialog.Create(Application);
         if dial.Execute then
            begin
            filen := dial.FileName;
            end
         else
            begin
            dial.Free;
            exit;
            end;
         AssignFile(arqtxt,filen);
         dial.Free;
         Rewrite(arqtxt);
         while not EOF do
           begin
           i := 5 - length(FieldByName('Lote_Afetado').AsString);
           Linha := FieldByName('Cod_Tran').AsString +
               FormatDateTime('dd/mm/yyyy hh:mm',FieldByName('Dt_Tran').AsDateTime) +
               FieldByName('Func_Resp').AsString +
               FieldByName('Pis_Afetado').AsString +
               FieldByName('Lote_Afetado').AsString + brancos(i);
           writeln(arqtxt,linha);
           next;
           end;
        try
           // este e um caso especial em que o proprio metodo
           // executa o commit
           CNSDataBase.StartTransaction;
           close;
           sql.clear;
           sql.add('DELETE FROM log ');
           ExecSQL;
           close;
           sql.clear;
           sql.add('INSERT INTO log ');
           sql.add(' (Cod_Tran, Dt_Tran, Func_Resp, Pis_Afetado, Lote_Afetado)');
           sql.add(' VALUES(''INSE'',:SYSDATE,:pisfunc,NULL,NULL)');
           ParamByName('SYSDATE').AsDateTime := (now);
           if assigned(FuncResponsavel) then
              ParamByName('pisfunc').AsString := FuncResponsavel.pis
           else
           begin
               e := ELog.Create('E0013 - Log deve estar Ligado ao Funcionario');
               e.CodErro := 13;
               raise e;
           end;

           ExecSQL;
           CloseFile(arqtxt);
           CNSDataBase.Commit;
         except
            on h1 : EDatabaseError do
               begin
               e := ELog.Create('E0013 - Erro ao eliminar linhas do log'+ h1.message);
               CNSDatabase.RollBack;
               e.CodErro := 1;
               raise e;
               end;
         end;
      end;
   end;
end;

procedure TCNSLog.InsereLog( ct: string );
var
   e : ELog;
begin
   if assigned(DataSource) and assigned(DataSource.DataSet) then
   begin
   with DataSource.Dataset as TQuery do
      begin
         close;
         sql.clear;
         sql.add('INSERT INTO log ');
         sql.add(' (Cod_Tran, Dt_Tran, Func_Resp, Pis_Afetado, Lote_Afetado)');
         sql.add(' VALUES(:ct,:SYSDATE,:pisfunc,');
         if  UsuarioAfetado = nil then
             sql.add('NULL,')
         else
           sql.add(':pisusu,');
         if  Loteafetado = nil then
             sql.add('NULL)')
         else
             sql.add(':Lote)');
         if  UsuarioAfetado <> nil then
         ParamByName('pisusu').AsString := UsuarioAfetado.pis;
         if  Loteafetado <> nil then
             ParamByName('lote').AsInteger := LoteAfetado.Lote;
         ParamByName('SYSDATE').AsDateTime := (now);
         ParamByName('pisfunc').AsString := FuncResponsavel.pis;
         ParamByName('ct').AsString := ct;
         try
           ExecSQL;
         except
            on h2 : EDBEngineError do
               begin
               e := ELog.Create('E0011 - Erro ao inserir registro no log - ' + h2.message);
               e.CodErro := 1;
               raise e;
               end;
            on h1 : EDatabaseError do
               begin
               e := ELog.Create('E0011 - Erro ao inserir registro no log - ' + h1.message);
               e.CodErro := 1;
               raise e;
               end;
         end;
      end;
   end;
end;


end.

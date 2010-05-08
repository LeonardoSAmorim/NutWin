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




unit DMSemaf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, NutCnst, dmlock;

type
  TdmSemaforo = class(TDataModule)
    BDSemaforo: TDatabase;
    taUsuarios: TTable;
    dsUsuario: TDataSource;
    qrySemaforo: TQuery;
    procedure dmSemaforoCreate(Sender: TObject);
    procedure dmSemaforoDestroy(Sender: TObject);
  private
    { Private declarations }
    FUsuarioDono: string;
    FAplicID: string;
    FLock : Tdmlockbd;
    FAplicacoesAtivas : Integer;
    procedure SetUsuarioDono(const Value: string);
    procedure SetAplicID(const Value: string);
  public
    { Public declarations }
    property AplicID: string read FAplicID write SetAplicID;
    property UsuarioDono: string read FUsuarioDono write SetUsuarioDono;
    function GetAplicacoesAtivas( Atualizado : boolean=True) : Integer;
    function TravaRecurso(Recurso: string; Descricao: string = 'Desconhecido'): Boolean;
    function LiberaRecurso(Recurso: string): Boolean;
    function LiberaRecursosUsuario( AppID : String='' ): Boolean;
    function LiberaTodosRecursosOrfaos: Integer;
  end;

var
  dmSemaforo: TdmSemaforo;

implementation

{$R *.DFM}

{ TdmSemaforo }

function TdmSemaforo.LiberaRecurso(Recurso: string): Boolean;
begin
  Result := True;
  with TQuery.Create(self) do
  begin
    DatabaseName := BDSemaforo.DatabaseName;
    sql.Clear;
    sql.Text := 'Select count(*) as qtd ' +
      'From SEMAFORO ' +
      'Where ((APPID = ' + QuotedStr(trim(FAplicID)) + ') and ' +
      '      (RECURSO = ' + QuotedStr(trim(Recurso)) + ')) ';
    try
      Active := true;
    except on E: Exception do
      begin
        ShowMessage('Erro no banco, favor acionar suporte! ' + #13 + #10 +
          E.Message);
        Result := False;
        Exit;
      end;
    end;
    if FieldByName('qtd').AsInteger > 0 then
    begin
      try
        with TQuery.Create(Self) do
        begin
          DatabaseName := BDSemaforo.DatabaseName;
          sql.Clear;
          sql.Text := 'Delete from SEMAFORO ' +
            'Where ((APPID = ' + QuotedStr(trim(FAplicID)) + ') and ' +
            '      (RECURSO = ' + QuotedStr(trim(Recurso)) + ')) ';
          ExecSQL;
        end;
      except
        Result := False;
      end;
    end;
  end;
end;

function TdmSemaforo.LiberaTodosRecursosOrfaos: Integer;
var
   qryAplicAtivo,
   qryAplicExcluir : TQuery;
   strAplicID : String;
begin
  Result := 0;
  qryAplicAtivo := TQuery.Create(Self);
  with qryAplicAtivo do
  begin
    try
      DatabaseName := BDSemaforo.DatabaseName;
      sql.Clear;
      sql.Text := 'SELECT * from SEMAFORO where DSC_RECURSO = "' + Trim(APP_LOCK_LABEL) + '"';
      Prepare;
      open;
      while not eof do
      begin
        strAplicID := FieldByName('APPID').AsString;
        qryAplicExcluir := TQuery.Create(Self);
        try
           with qryAplicExcluir do
           begin
              DatabaseName := BDSemaforo.DatabaseName;
              sql.Clear;
              sql.Text := 'DELETE from SEMAFORO where APPID = ' + QuotedStr( strAplicID );
              Prepare;
              ExecSQL;
           end;
           next;
        except
           Inc(Result);
           next;
        end;
      end;
    except
      Result := -1;
    end;
  end;
end;

(**
  Essa rotina trava o Recurso na rede e na máquina

**)

function TdmSemaforo.TravaRecurso(Recurso: string; Descricao: string = 'Desconhecido'): Boolean;
begin
  Result := True;
  if FAplicID = '' then
  begin
     ShowMessage('Erro no banco (AplicID vazio), favor acionar suporte! ');
     exit;
  end;
  with TQuery.Create(self) do
  begin
    try
      DatabaseName := BDSemaforo.DatabaseName;
      try
          sql.Clear;
          sql.Text := 'Insert into SEMAFORO ' +
          '(RECURSO,APPID,DSC_RECURSO,USERNAME,DT_TRAVAMENTO) ' +
          'values (' + QuotedStr(trim(Recurso)) + ', '
          + QuotedStr(trim(FAplicID)) +  ', '
          + QuotedStr(trim(Descricao)) + ', '
          + QuotedStr(trim(FUsuarioDono)) + ', '
//          + QuotedStr('08/19/2003 11:33:44') + ')';
          + QuotedStr(FormatDateTime( 'mm/dd/yyyy hh:mm:ss', now)) + ')';
//         sql.SaveToFile('c:\resultado.txt');
          Prepare;
          ExecSQL;
      // trata somente o key violation (9729) como registro travado, pois os demais são erros mesmo.    
      except on E: EDBEngineError do
        begin
            if TDBError(e.Errors[0]).ErrorCode <> 9729 then
               ShowMessage('Erro no banco, favor acionar suporte! ' + #13 + #10 +
                           E.Message );
          Result := False;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TdmSemaforo.dmSemaforoCreate(Sender: TObject);
begin
  FAplicacoesAtivas := LiberaTodosRecursosOrfaos;
  if FAplicacoesAtivas < 0 then
  begin
     ShowMessage( 'Problemas ao tentar liberar recursos não ativos. Isto não impede o uso do sistema, mas degrada o tempo de resposta do sistema a longo prazo.' );
  end;
  FAplicID := NutCnst.CreateNewGUID;
  FLock := Tdmlockbd.Create(self);
  if not TravaRecurso( FAplicID, APP_LOCK_LABEL ) then
     Showmessage('Não consegui travar aplicação.');
  if not FLock.TravaAplicacao(FAplicID) then
  begin
     FAplicID := '';
     Showmessage('Não consegui travar aplicação');
  end;
end;

procedure TdmSemaforo.SetUsuarioDono(const Value: string);
begin
  FUsuarioDono := Value;
end;

function TdmSemaforo.LiberaRecursosUsuario( AppID : String='' ): Boolean;
begin
  if AppID = '' then
     AppID := FAplicID;
  Result := True;
  with TQuery.Create(nil) do
  begin
    DatabaseName := BDSemaforo.DatabaseName;
    sql.Clear;
    sql.Clear;
    sql.Text := 'Delete from SEMAFORO where APPID=' + QuotedStr(trim(AppID));
    try
      Prepare;
      ExecSQL;
    except on E: Exception do
      begin
        ShowMessage('Erro no banco, favor acionar suporte! ' + #13 + #10 +
          E.Message);
        Result := False;
      end;
    end;
  end;
end;

procedure TdmSemaforo.dmSemaforoDestroy(Sender: TObject);
begin
  if FAplicID <> '' then
  begin
    if not FLock.LiberaAplicacao then
       Showmessage('Não consegui destravar aplicação');
    FLock.Free;
    if not self.LiberaRecursosUsuario then
       Showmessage('Não consegui liberar aplicação.');
  end;
  dmSemaforo := nil;
end;

procedure TdmSemaforo.SetAplicID(const Value: string);
begin
  FAplicID := Value;
end;

function TdmSemaforo.GetAplicacoesAtivas( Atualizado : boolean=True) : Integer;
begin
  if Atualizado then
  begin
     FAplicacoesAtivas := LiberaTodosRecursosOrfaos;
  end;
  result := FAplicacoesAtivas;
end;

end.


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




unit CNActns;

interface

uses Classes, ActnList, Memoria, Calculo, Dialogs;

type
  { DataSet actions }
  TMemoriaAction = class(TAction)
  private
    FCalculo: TCalculo;
    procedure SetCalculo(Value: TCalculo);
  protected
    function GetMemoria(Target: TObject): TMemoria; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function HandlesTarget(Target: TObject): Boolean; override;
    property Calculo : TCalculo read FCalculo write SetCalculo;
  end;

  TMemoriaAbrir = class(TMemoriaAction)
  private
    FOpenDialog: TOpenDialog;
    procedure SetOpenDialog(const Value: TOpenDialog);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property Calculo;
    property OpenDialog : TOpenDialog read FOpenDialog write SetOpenDialog;
  end;

  TMemoriaDBAbrir = class(TMemoriaAbrir)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property Calculo;
    property OpenDialog;
  end;

  TMemoriaSalvar = class(TMemoriaAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property Calculo;
  end;

  TMemoriaFechar = class(TMemoriaAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property Calculo;
  end;

  TMemoriaEditar = class(TMemoriaAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property Calculo;
  end;

var
   Aberto : Boolean;


procedure Register;

implementation

procedure Register;
begin

   RegisterActions('Memoria', [TMemoriaAbrir, TMemoriaSalvar, TMemoriaFechar, TMemoriaEditar, TMemoriaDBAbrir], TCalculo);

end;

{ TMemoriaAction }

function TMemoriaAction.GetMemoria(Target: TObject): TMemoria;
begin
  { We could cast Target as a TCalculo since HandlesTarget "should" be
    called before ExecuteTarget and UpdateTarget, however, we're being safe. }
  Result := Calculo.Memoria;
end;

function TMemoriaAction.HandlesTarget(Target: TObject): Boolean;
begin
  { Only handle Target if we don't already have a DataSource assigned and the
    Target is a TDataSource with a non nil DataSet assigned. }
  Result := (Calculo <> nil) and (Calculo.Memoria <> nil);
end;

procedure TMemoriaAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Calculo) then Calculo := nil;
end;

procedure TMemoriaAction.SetCalculo(Value: TCalculo);
begin
  if Value <> FCalculo then
  begin
    FCalculo := Value;
    if Value <> nil then Value.FreeNotification(Self);
  end;
end;

{ TMemoriaAbrir }

procedure TMemoriaAbrir.ExecuteTarget(Target: TObject);
begin
  with GetMemoria(Target) do
  begin
     if not Assigned( FOpenDialog ) then
        exit;
     FOpenDialog.FileName := 'Nome não informado.NUT';
     if FOpenDialog.Execute then
     begin
        NomeArquivo := FOpenDialog.FileName;
        Abrir;
        Aberto := True;
        UpdateViewer;
     end;
  end;
end;

procedure TMemoriaAbrir.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = OpenDialog) then OpenDialog := nil;
end;

procedure TMemoriaAbrir.SetOpenDialog(const Value: TOpenDialog);
begin
  FOpenDialog := Value;
end;

procedure TMemoriaAbrir.UpdateTarget(Target: TObject);
begin
  with GetMemoria(Target) do
    Enabled := not Aberto;
end;

{ TMemoriaSalvar }

procedure TMemoriaSalvar.ExecuteTarget(Target: TObject);
begin
  with GetMemoria(Target) do
  begin
     Salvar;
     Modified := 0;
  end;
end;

procedure TMemoriaSalvar.UpdateTarget(Target: TObject);
begin
  with GetMemoria(Target) do
    Enabled := (Modified > 0 ) and ( NomeArquivo <> '' );
end;

{ TMemoriaFechar }

procedure TMemoriaFechar.ExecuteTarget(Target: TObject);
begin
  with GetMemoria(Target) do
  begin
      Limpar;
      Modified := 0;
      Aberto := False;
      UpdateViewer;
  end;
end;

procedure TMemoriaFechar.UpdateTarget(Target: TObject);
begin
  with GetMemoria(Target) do
    Enabled := Aberto;
end;

{ TMemoriaEditar }

procedure TMemoriaEditar.ExecuteTarget(Target: TObject);
begin
  with GetMemoria(Target) do
  begin
//@      AddModified;
  end;
end;

procedure TMemoriaEditar.UpdateTarget(Target: TObject);
begin
  with GetMemoria(Target) do
    Enabled := Aberto;
end;

{ TMemoriaDBAbrir }

procedure TMemoriaDBAbrir.ExecuteTarget(Target: TObject);
begin
inherited ExecuteTarget( Target );
ShowMessage( 'DBAbrir' );
end;

procedure TMemoriaDBAbrir.UpdateTarget(Target: TObject);
begin
inherited UpdateTarget( Target );

end;

end.

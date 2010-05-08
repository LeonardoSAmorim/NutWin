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




unit CardSus;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DsgnIntf, dbctrls, cnsdbsuS, DSFields, DSFieldsReg, db;

type
  TCardSUS = class(TCustomDB)
  private
    { Private declarations }
    FTitulo : string;
    FNome : TDSFields;
    FDataNascimento : TDSFields;
    FRic : TDSFields;
    FCodigoMunicipio : TDSFields;
    FMunicipio : TDSFields;
  protected
    { Protected declarations }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DSChange(Sender: TObject; Field: TField); override;
    procedure SetarDataSetFields; override;
    procedure ResetarDataSetFields; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure print; virtual;

  published
    { Published declarations }
    property Titulo : string  read FTitulo write FTitulo;
    property Nome : TDSFields  read FNome write FNome;
    property DataNascimento : TDSFields read FDataNascimento write FDataNascimento;
    property Ric : TDSFields read FRic write FRic;
    property CodigoMunicipio : TDSFields read FCodigoMunicipio write FCodigoMunicipio;
    property Municipio : TDSFields read FMunicipio write FMunicipio;
  end;

procedure Register;

implementation

//uses cartaobechara;

procedure Register;
begin
  RegisterComponents('CCS-SIS', [TCardSUS]);
  RegisterPropertyEditor(TypeInfo(TDSFields), TCardSUS, 'Nome', TDSFieldsProperty);
  RegisterPropertyEditor(TypeInfo(TDSFields), TCardSUS, 'DataNascimento', TDSFieldsProperty);
  RegisterPropertyEditor(TypeInfo(TDSFields), TCardSUS, 'Municipio', TDSFieldsProperty);
  RegisterPropertyEditor(TypeInfo(TDSFields), TCardSUS, 'CodigoMunicipio', TDSFieldsProperty);
  RegisterPropertyEditor(TypeInfo(TDSFields), TCardSUS, 'Cidade', TDSFieldsProperty);
  RegisterPropertyEditor(TypeInfo(TDSFields), TCardSUS, 'Ric', TDSFieldsProperty);
end;

constructor TCardSUS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  formbechara := TFormBechara.Create(self);
  FNome := TDSFields.Create;
  FDataNascimento := TDSFields.Create;
  FRic := TDSFields.Create;
  FCodigoMunicipio := TDSFields.Create;
  FMunicipio := TDSFields.Create;
end;

procedure TCardSUS.Loaded;
begin
  inherited Loaded;
end;


destructor TCardSUS.Destroy;
begin
  inherited Destroy;
  FNome.Free;
  FDataNascimento.Free;
  FRic.Free;
  FCodigoMunicipio.Free;
  FMunicipio.Free;
end;

procedure TCardSUS.SetarDataSetFields;
begin
  inherited SetarDataSetFields;
{  FNome.DataSet := DataSet;
  FDataNascimento.DataSet := DataSet;
  FRic.DataSet := DataSet;
  FCodigoMunicipio.DataSet := DataSet;
  FMunicipio.DataSet := DataSet;
  }

  FNome.DataSet := DataSource.DataSet;
  FDataNascimento.DataSet := DataSource.DataSet;
  FRic.DataSet := DataSource.DataSet;
  FCodigoMunicipio.DataSet := DataSource.DataSet;
  FMunicipio.DataSet := DataSource.DataSet;
end;

procedure TCardSUS.ResetarDataSetFields;
begin
  inherited ResetarDataSetFields;
  FNome.DataSet := nil;
  FDataNascimento.DataSet := nil;
  FRic.DataSet := nil;
  FCodigoMunicipio.DataSet := nil;
  FMunicipio.DataSet := nil;
end;

procedure TCardSUS.DSChange(Sender: TObject; Field: TField);
begin
   if FNome.DataSet <> nil then
   begin
   FNome.Data := DataSource.DataSet.FieldByName(FNome.Field).AsString;
   FRic.Data := DataSource.DataSet.FieldByName(FRic.Field).AsString;
   FDataNascimento.Data := DataSource.DataSet.FieldByName(FDataNascimento.Field).AsString;
   FCodigoMunicipio.Data := DataSource.DataSet.FieldByName(FCodigoMunicipio.Field).AsString;
   FMunicipio.Data := DataSource.DataSet.FieldByName(FMunicipio.Field).AsString;
   end;
end;

procedure TCardSUS.print;
begin
{
   begin
      if FMunicipio <> nil then
         formbechara.QRLabel4.Caption := Municipio.Data;
      if FNome <> nil then
         formbechara.QRLabel1.Caption := 'Nome : ' + FNome.Data;
      if FDataNascimento <> nil then
         formbechara.QRLabel2.Caption := 'Data Nascimento : ' + FDataNascimento.Data;
      if FRic <> nil then
         formbechara.QRLabel2.Caption := 'Municipio : ' + FRic.Data;
      if FCodigoMunicipio <> nil then
         formbechara.QRLabel3.Caption := 'Cod. Municipio : ' + FCodigoMunicipio.Data;

      formbechara.qrBarCode2.text := '010789436390000790'+'12350268308003304557';
      formbechara.qrcartao.Print;
   end;
}
end;


procedure TCardSUS.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
  end;
end;

end.

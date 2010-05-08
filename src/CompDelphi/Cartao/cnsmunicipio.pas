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




unit CNSMunicipio;

interface

uses WinTypes, WinProcs, Messages, SysUtils, Classes, Controls, dialogs,
     Forms, Graphics, Db,dbctrls, dbtables,CCSListaLinks, CNSDBSUS, CNSLib, cnsufederal;

type
    //Indica por qual chave deve ser usado para carregar
    TPropertyKeyMunicipio = (pCodIBGE, pDescricao, pDescricaoSigla);
    TCNSMunicipio = class(TCNSDBSUS)
    private
        FCodIBGE : String;
        FDescricao : String;
        FUF : TCNSUF;
        FCarregarPor : TPropertyKeyMunicipio;

        procedure SetUF(Value : TCNSUF);

    protected
        procedure Loaded; override;
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        function Execute : Boolean;
        procedure Carregar(P1, P2, P3, P4 : String); override;
        function Validar : Boolean;
        procedure ListaMunicipios(Lista : TStrings);

    published
        property CodIBGE : String read FCodIBGE write FCodIBGE;
        property Descricao : String read FDescricao write FDescricao;
        property UF : TCNSUF read FUF write SetUF;
        property CarregarPor : TPropertyKeyMunicipio read FCarregarPor write FCarregarPor;
  end;

procedure Register;

implementation


procedure Register;
begin
     RegisterComponents('Cartao', [TCNSMunicipio]);
end;


constructor TCNSMunicipio.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
    TableName := 'MUNICIPIO';
    ObjectView.Add('select * from MUNICIPIO');
end;

destructor TCNSMunicipio.Destroy;
begin
     inherited Destroy;
end;

procedure TCNSMunicipio.Loaded;
begin
     inherited Loaded;
end;

procedure TCNSMunicipio.SetUF(Value : TCNSUF);
begin
   FUF := Value;
   if Value <> nil then
   begin
      Value.FreeNotification(Self);
   end;
end;

procedure TCNSMunicipio.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if (FUF <> nil) and (AComponent = UF) then
       UF := nil;
  end;
end;



function TCNSMunicipio.Execute : Boolean;
begin
     Result := True
end;

{ Recupera descricao a partir do codigo }
procedure TCNSMunicipio.Carregar(P1, P2, P3, P4 : String);
var
   e : EMunicipio;
   xCodUF : string;
begin
   with (DataSource.DataSet)  as TQuery do
   begin
      close;
      sql.clear;
      case CarregarPor of
         pCodIbge :
         begin
            sql.add('select * from municipio where cod_ibge = :codmun');
            ParamByName('codmun').AsString := P1;
         end;
         pDescricao :
         begin
            sql.add('select * from municipio where Descricao = :Descricao');
            ParamByName('Descricao').AsString := P1;
         end;
         pDescricaoSigla :
         begin
            UF.CarregarPor := pSiglaUF;
            UF.Carregar(P2, '','','');
            UF.CarregarPor := pCodUF;
            sql.add('select * from municipio where Descricao = :Descricao and  Cod_ibge like ' + '''' + UF.CodUF + '%' + '''');
            ParamByName('Descricao').AsString := P1;
         end;
      end;
      try
         Open;
         if Eof then
          begin
            descricao := '';
            CodIBGE := '';
          end  else
          begin
            CodIBGE := Fieldbyname('Cod_IBGE').asString;
            descricao := Fieldbyname('descricao').asString;
            //caaregar unidade federal
          end;
          UF.Carregar(string(copy(CodIBGE,1, 2)), '', '', '');
          NotifyLinks(Self, LLoad);
      except
         on h1 : EDatabaseError do
            begin
            e := EMunicipio.CreateFmt('E0022 - Erro ao ler dados do municipio - %s '+ h1.message
                                      ,[codIBGE]);
            e.CodErro := 9;
            raise e;
            end;
         on h2 : EDBEngineError do
            begin
            e := EMunicipio.CreateFmt('E0022 - Erro ao ler dados do municipio - %s '+ h2.message
                                      ,[codIBGE]);
            e.CodErro := 9;
            raise e;
            end;
      end;

   end;
end;

function TCNSMunicipio.Validar : Boolean;
begin
    Carregar(CodIBGE,'','','');
    if (descricao = '') then
       result := true
    else
       result := false;
end;


procedure TCNSMunicipio.ListaMunicipios(Lista : TStrings);
var
   e : EMunicipio;
   i : integer;
   xDescricao : string;
begin
   if assigned(DataSource) and assigned(DataSource.Dataset) and assigned(UF) then
   begin
      with (DataSource.DataSet)  as TQuery do
      begin
         Lista.Clear;
         close;
         sql.clear;
         sql.add('select * from municipio order by descricao');
         try
            Open;
            first;
            while not Eof do
            begin
               UF.Carregar(string(copy(Fieldbyname('Cod_IBGE').asString,1, 2)), '', '', '');
               xDescricao := Fieldbyname('Descricao').asString;
               Lista.Add(xDescricao + brancos(30 - length(xDescricao)) + ' ' + UF.Sigla);
               next;
            end;
         except
            on h1 : EDatabaseError do
               begin
                  e := EMunicipio.CreateFmt('E0022 - Erro ao ler dados do municipio - %s '+ h1.message
                                         ,[codIBGE]);
                  e.CodErro := 9;
                  raise e;
               end;
            on h2 : EDBEngineError do
               begin
                  e := EMunicipio.CreateFmt('E0022 - Erro ao ler dados do municipio - %s '+ h2.message
                                            ,[codIBGE]);
                  e.CodErro := 9;
                  raise e;
               end;
         end;
      end;
   end;
end;


end.

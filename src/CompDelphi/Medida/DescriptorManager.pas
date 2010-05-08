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
{   Delphi component TDescriptorManager                              }
{                                                                    }
{   Gerenciador de Descritores                                       }
{                                                                    }
{   Copyright © 1997 by DIS-EPM/UNIFESP                              }
{                                                                    }
{ ****************************************************************** }

unit DescriptorManager;

interface

uses SysUtils, Classes, Forms, DB, dbtables, CCSDBListaLinks,
     Memoria, DMDescMgr, Calculo, Procedimento, Measurement, Idade;

type

   TDescriptorManager = class(TCCSDBListaLinks)
   private
      FDescDM : TDMDescritor;
      FEntradas: TCaixa;
      FInvalidos: TStringList;
      FValidos: TStringList;
      FVazios: TStringList;
      FExplanacao: TStringList;
      FProcessador: TCalculo;
      procedure SetEntradas(const Value: TCaixa);
      procedure SetProcessador(const Value: TCalculo);
{      procedure SetInvalidos(const Value: TStringList);
      procedure SetValidos(const Value: TStringList);
      procedure SetVazios(const Value: TStringList);
      procedure SetExplanacao(const Value: TStringList);}
   protected
      procedure Loaded; override;
   public
      procedure Notification(AComponent : TComponent; Operation : TOperation); override;
      constructor Create (Owner : TComponent);override;
      destructor Destroy; override;
      function Validate( Calculo,CaixaProcedimentos, Procedimento : String ): Boolean;
      function ValidateData (InputData: TCaixa;var Explanacao:TStringList): boolean;
      procedure ProcesseInconsistencias (Incons : TStringList);
   published
      property Entradas : TCaixa read FEntradas write SetEntradas;
      property Validos : TStringList read FValidos;
      property Invalidos : TStringList read FInvalidos;
      property Vazios : TStringList read FVazios;
      property Explanacao : TStringList read FExplanacao ;
      property Processador : TCalculo read FProcessador write SetProcessador;
   end;

procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('Calculadora', [TDescriptorManager]);
end;

{ TDescriptorManager }

constructor TDescriptorManager.Create(Owner: TComponent);
begin
   inherited;
   Application.CreateForm (TDMDescritor, FDescDM);
   if not Assigned(FValidos) then
      begin
         FValidos := TStringList.Create;
      end;
   if not Assigned(FInvalidos) then
      FInvalidos := TStringList.Create;
   if not Assigned(FVazios) then
      FVazios := TStringList.Create;
   if not Assigned(FExplanacao) then
      FExplanacao := TStringList.Create;
end;

destructor TDescriptorManager.Destroy;
begin
   inherited;
   FValidos.Free;
   FInvalidos.Free;
   FVazios.Free;
   FExplanacao.Free;
end;

procedure TDescriptorManager.Loaded;
var
   I: integer;
begin
   inherited;
   //Define o DataModule
   DM := FDescDM;
   for I:=0 to FDescDM.ComponentCount - 1 do
       if FDescDM.Components[I] is TDBDataSet then
          TDBDataSet(FDescDM.Components[I]).Active := True;
end;

procedure TDescriptorManager.Notification(AComponent: TComponent; Operation: TOperation);
begin
   inherited Notification(AComponent, Operation);
   if Operation <> opRemove then
      Exit;
   if AComponent = FProcessador then
      FProcessador := nil
end;

procedure TDescriptorManager.SetEntradas(const Value: TCaixa);
begin
   FEntradas := Value;
end;
{
procedure TDescriptorManager.SetExplanacao(const Value: TStringList);
begin
   FExplanacao := Value;
end;

procedure TDescriptorManager.SetInvalidos(const Value: TStringList);
begin
   FInvalidos := Value;
end;

procedure TDescriptorManager.SetValidos(const Value: TStringList);
begin
   FValidos := Value;
end;

procedure TDescriptorManager.SetVazios(const Value: TStringList);
begin
//   if Assigned (FVazios) and Assigned(FindComponent(FVazios.Name)) then
//      begin
//         RemoveComponent (FVazios);
//      end;
   FVazios := Value;
end;
}
procedure TDescriptorManager.SetProcessador(const Value: TCalculo);
begin
   FProcessador := Value;
end;

function TDescriptorManager.Validate( Calculo, CaixaProcedimentos, Procedimento : String ): Boolean;
var
   AuxCx,
   AuxPr : TComponent;
   I : Integer;
   meMemAux, OldMem : TMemoria;
   OldProcedimentos : TStringList;
   mdClassificacaoEtaria, mdTemp : TMedidaOrdinal;
begin
   { *** Desativando verificação pelo IMC }
   Result := False;
   if (not Assigned (FProcessador)) or
      (not Assigned(FProcessador.Memoria)) then
      exit;

   //Cria uma memoria auxiliar e copia o conteudo da principal
   meMemAux := TMemoria.Create (FProcessador.Memoria.Owner );
   meMemAux.Assign(FProcessador.Memoria);
   //Exchange de memorias
   OldMem := FProcessador.Memoria;
   FProcessador.Memoria := meMemAux;

   // Cria procedimentos de Classificacao Etaria na memória auxiliar, pois
   // só me interessa o resultado da classificação
   OldProcedimentos := TStringList.Create;
   mdClassificacaoEtaria := TMedidaOrdinal.Create(self);
   Try
      OldProcedimentos.Assign( FProcessador.Procedimentos );
      FProcessador.Procedimentos.Clear;
      FProcessador.CriaListaProc( FProcessador.Memoria, 'cxcaClassificaMedidas', 'prClassificacaoEtariaGenerica', psNone);
      FProcessador.Procedimentos.Add( 'prClassificacaoEtariaGenerica' );
      FProcessador.CriaMedidas;
      FProcessador.Execute;
      FProcessador.Procedimentos.Clear;
      FProcessador.Procedimentos.Assign( OldProcedimentos );
      if FProcessador.Memoria.Acha( 'mdClassificacaoEtaria', TObject( mdClassificacaoEtaria ) ) then
      begin
          // Passa classificação Etária calculada para a memória anterior
         if OldMem.Acha( 'mdClassificacaoEtaria', TObject( mdTemp ) ) and
            Assigned( mdClassificacaoEtaria ) then
            mdTemp.Assign( mdClassificacaoEtaria );
      end;
   finally
      OldProcedimentos.Free;
      mdClassificacaoEtaria.Free;
   end;

   // Cria Procedimentos de IMC
   FProcessador.CriaListaProc( FProcessador.Memoria, CaixaProcedimentos, Procedimento, psNone);
   FProcessador.ValidaCalculo( Calculo, CaixaProcedimentos );
   FProcessador.Procedimentos.Clear;
   AuxCx := FProcessador.Memoria.FindComponent( CaixaProcedimentos );
   if Assigned( AuxCx ) then
    if ( AuxCx is TCaixa ) then
     with (AuxCx as TCaixa ) do
     begin
        For I := 0 to AuxCx.ComponentCount - 1 do
        begin
           AuxPr := AuxCx.Components[I];
           if ( AuxPr is TProcedimento ) then
           with (AuxPr as TProcedimento ) do
           begin
              if (Estado = psChecked) or (Estado = psNone) then
              begin
                 FProcessador.Procedimentos.Add( AuxPr.Name )
              end;
           end;
        end;
        FProcessador.CriaMedidas;
        FProcessador.Execute;
     end;
   Result := ValidateData(Entradas,FExplanacao);
   // Limpa procedimentos já calculados senão dá problema no Terminar
   FProcessador.Procedimentos.Clear;
   // Chaveando para a memória anterior
   FProcessador.Memoria := OldMem;
   meMemAux.Free;
end;


function TDescriptorManager.ValidateData(InputData: TCaixa;var Explanacao : TStringList): boolean;
var
   I : integer;
//   J, K : integer;
   IndepName,NewFilter : string;
   IndepMedida, ParamMedida, DepMedida : TMedida;
   MaxIndep,MinIndep, ActualValue : real;
   AchouDesc : boolean;
   AchouDescGeral : boolean;
   AchouParam : boolean;
   DescGeralDescricao, DescGeralFonte, DescGeralValNum, DescGeralUnid,DescGeralDesc : string;
   Discriminante : integer;
   DeltaMean : real;
   ExpMedVal, ExpParmVal, InconsDesc, SemDescrDesc, SemDescrMed,NaoVerifDesc, NaoVerifMed : TStringList;
begin
   Discriminante := 3; // a pedido do Meide em 12/04/2001
   Result := True;
   if not Assigned(Explanacao) then
      exit;
   if not Assigned(Vazios) then
      exit;
   if not Assigned(Invalidos) then
      exit;
   if not Assigned(Validos) then
      exit;
   ExpMedVal := TStringList.Create;
   ExpParmVal := TStringList.Create;
   InconsDesc := TStringList.Create;
   SemDescrDesc := TStringList.Create;
   SemDescrMed := TStringList.Create;
   NaoVerifDesc := TStringList.Create;
   NaoVerifMed := TStringList.Create;
   Explanacao.Clear;
   with FDescDM do
   begin
   {* with Explanacao do
      begin
         Add('------------------------------------');
         Add ('Analise de Consistencia.');
         Add('------------------------------------');
         Add ('Valores das Medidas : ');
         Add (' ');
         for I := 0 to InputData.ComponentCount - 1 do
             begin
                DepMedida := TMedida(InputData.Components[I]);
                if (DepMedida.Empty ) then
                   Vazios.AddObject(DepMedida.Name,DepMedida)
                else
                   Add (DepMedida.Descricao + ' = '+ DepMedida.ValorNumerico + ' '+DepMedida.Unidade );
             end;
         if Vazios.Count > 0 then
            begin
               Add ('-----');
               Add ('Medidas que não foram preenchidas com valores :');
               Add (' ');
               for I := 0 to Vazios.Count - 1 do
                  Add(TMedida(Vazios.Objects[I]).Name);
            end;
         Add(' ');
         Add('-------------------------------------------------------');
         Add('Resultado da Analise');
         Add('-------------------------------------------------------');
         Add(' ');
      end;
}
      //Vai consistir todos os valores.
      //Por isso asume eles invalidos.
      for I := 0 to InputData.ComponentCount - 1 do
          if (InputData.Components[i] is TMedida) then
             TMedida(InputData.Components[i]).Valid := False;
      //Para toda a lista de medidas
      for I := 0 to InputData.ComponentCount - 1 do
          begin
             DepMedida := (InputData.Components[i] as TMedida);
             //Pegue uma medida
             with DepMedida, DscQuantitativo do
             //Se a medida nao foi validada ainda
             if (Valid or Empty) then Continue else
             begin
                //Filtre os Descritores que existem pra ela
                Filtered := False;
                Filter := 'VALORDEPENDENTE = ' + '''' + DepMedida.Name + '''';
                Filtered := True;
                NewFilter := Filter;
                if RecordCount <> 0 then
                begin
                   //Para cada um dos descritores existentes...
                   First;
                   AchouDesc := False;
                   AchouDescGeral := False;
                   while not EOF do
                   begin
                      //Pegue o nome da variavel independente...
                      IndepName := FieldByName('VARINDEPENDENTE').AsString;
                      //..e verifique se ela se encontra na lista de medidas fornecida
                      //IndepMedida := (InputData.FindComponent(IndepName) as TMedida);
                      InputData.Acha(IndepName,TObject(IndepMedida));
                      //Se nao achou no escopo, pode estar na memoria
                      //(quando chamado pela rotina anterior, e'a memoria auxiliar)
                      if ((not Assigned(IndepMedida)) or IndepMedida.Empty)then
                      begin
                         FProcessador.Memoria.Acha (IndepName,TObject(IndepMedida));
                         if ((not Assigned(IndepMedida)) or IndepMedida.Empty)then
                         begin
                            //Caso nao exista na lista fornecida ou esteja vazia, este descritor nao nos é
                            //util. Exclua ele e procure outros descritores.
                            NewFilter := NewFilter + ' AND VARINDEPENDENTE <> ' + '''' + IndepName + '''';
                            Filtered := False;
                            Filter := NewFilter;
                            Filtered := True;
                            First;
                         end
                         else
                         //Existe na memoria auxiliar, quer dizer, e o resultado de um calculo
                         //Entao e' um descritor geral pra ser usado quando todo o resto falha
                         begin
                            //Caso a variavel independente tenha sido fornecida,
                            //Verifique se ela esta dentro do range do descritor
                            //pra o qual temos dados.
                            //Primeiro, deixe a medida da variavel independente nas unidades
                            //do descritor
//*                            IndepMedida.ConvertToUnit(FieldByName('UNIDADEVINDEP').AsString);
//*                            ActualValue := IndepMedida.AsFloat;
                            //* Usar a function AsFloatUnit para não mudar a unidade da medida
                            ActualValue := IndepMedida.AsFloatUnit(FieldByName('UNIDADEVINDEP').AsString);
                            MaxIndep := FieldByName('MAXVINDEP').AsFloat;
                            MinIndep := FieldByName('MINVINDEP').AsFloat;
                            if ((ActualValue < MinIndep) or (ActualValue > MaxIndep)) then
                            begin
                               //Se esta fora do range, exclua apenas
                               //este descritor e pase pro proximo
                               NewFilter := NewFilter + ' AND CODDSCR <> ' + '''' + FieldByName('CODDSCR').AsString + '''';
                               Next;
                            end
                            else
                            begin
                               //Um descritor generico validou a variavel
                               AchouDescGeral := True;
                               //Guarde os valores pra depois
                               DescGeralDescricao := DescritoresDescricao.AsString;
                               DescGeralFonte := DescritoresFonte.AsString;
                               DescGeralValNum := IndepMedida.ValorNumerico;
                               DescGeralUnid := IndepMedida.Unidade;
                               DescGeralDesc := IndepMedida.Descricao;
                               //Passe pro proximo descritor
                               Next;
                            end;
                         end;
                      end
                      else
                      begin
                         //Caso a variavel independente tenha sido fornecida,
                         //Verifique se ela esta dentro do range do descritor
                         //pra o qual temos dados.
                         //Primeiro, deixe a medida da variavel independente nas unidades
                         //do descritor
//*                         IndepMedida.ConvertToUnit(FieldByName('UNIDADEVINDEP').AsString);
//*                         ActualValue := IndepMedida.AsFloat;
                         //* Usar a function AsFloatUnit para não mudar a unidade da medida
                         ActualValue := IndepMedida.AsFloatUnit(FieldByName('UNIDADEVINDEP').AsString);
                         MaxIndep := FieldByName('MAXVINDEP').AsFloat;
                         MinIndep := FieldByName('MINVINDEP').AsFloat;
                         if ((ActualValue < MinIndep) or (ActualValue > MaxIndep)) then
                         begin
                            //Se esta fora do range, exclua apenas
                            //este descritor e pase pro proximo
                            NewFilter := NewFilter + ' AND CODDSCR <> ' + '''' + FieldByName('CODDSCR').AsString + '''';
                            Next;
                         end
                         else
                         begin
                            //Se esta dentro do range, verifique os parametros
                            Parametros.First;
                            AchouParam := False;
                            while not Parametros.EOF do
                            begin
                               //Procure o parametro dentro da lista de medidas
                               //ParamMedida := (InputData.FindComponent(Parametros.FieldByName('CODQTYPARM').AsString) as TMedida);
                               InputData.Acha(Parametros.FieldByName('CODQTYPARM').AsString, TObject(ParamMedida));
                               if ((not Assigned(ParamMedida)) or ParamMedida.Empty) then
                               begin
                                  //Se nao achou o parametro, o descritor nao nos serve
                                  //exclua este descritor e pase pro proximo
                                  NewFilter := NewFilter + ' AND CODDSCR <> ' + '''' + FieldByName('CODDSCR').AsString + '''';
                                  Next;
                                  AchouParam := False;
                                  Break;
                               end
                               else
                               begin
                                  //Verifique o valor do Parametro
                                  ParamMedida.ConvertToUnit(Parametros.FieldByName('UNIDADE').AsString);
                                  if ParamMedida.ValorNumerico <> Parametros.FieldByName('VALOR').AsString then
                                  begin
                                     //Se nao o parametro nao tem o valor necesario, o descritor nao nos serve
                                     //exclua este descritor e pase pro proximo
                                     NewFilter := NewFilter + ' AND CODDSCR <> ' + '''' + FieldByName('CODDSCR').AsString + '''';
                                     Next;
                                     AchouParam := False;
                                     Break;
                                  end
                                  else
                                  begin
                                     //Parametro Valido
                                     ParamMedida.Valid := True;
                                     Validos.AddObject(ParamMedida.Name, ParamMedida);
                                     ExpParmVal.Add(ParamMedida.Descricao + ' = ' + ParamMedida.ValorNumerico +  ' ' + ParamMedida.Unidade +
                                                    '; Parametro da tabela ' + DescritoresDescricao.AsString + ' Fonte : '+ DescritoresFonte.AsString);
                                     //Proximo parametro
                                     Parametros.Next;
                                     AchouParam := True;
                                  end;
                               end;
                            end;
                            //Se os parametros estao corretos,
                            //entao podemos validar a
                            //variavel dependente.
                            if (not AchouParam) then
                               continue;
                            //Primeiro converta ela nas unidades do descritor
                            TIdade( DepMedida).ConvertToUnit(FieldByName('UNIDADEVDEP').AsString);
                            //Procure o valor Independente
                            Valores.Active := True;
                            AchouDesc := True;
                            //Se existem valores para a variavel dependente
                            if not(Valores.IsEmpty) then
                            begin
                               Valores.FindNearest([FieldByName('CODDSCR').AsString, IndepMedida.AsFloatUnit(FieldByName('UNIDADEVINDEP').AsString)]); //ValorNumerico ]);
                               //Valide o valor Dependente
                               DeltaMean := abs(DepMedida.AsFloat - Valores.FieldByName('MEAN').AsFloat);
                               if ((DepMedida.AsFloat <= 0) or (DeltaMean >
                                  (Discriminante * Valores.FieldByName('STDDEV').AsFloat))) then
                               begin
                                  //Valor Invalido
                                  Valid := False;
                                  InconsDesc.Add(DepMedida.Descricao + ': Valor inconsistente segundo a tabela = ' +
                                                 DescritoresDescricao.AsString + ' Fonte : ' + DescritoresFonte.AsString);
                                  InconsDesc.Add('Valor : ' + DepMedida.ValorNumerico + ', Valor Medio Esperado (P50) :' +
                                                 Valores.FieldByName('MEAN').AsString + ', Desvio Padrão : '+Valores.FieldByName('STDDEV').AsString + '.');
                                  //Pasa para o proximo valor da lista
                               end
                               else
                               begin
                                  //Valor valido, ele e os outros parametros
                                  Valid := True;
                                  IndepMedida.Valid := True;
                                  Validos.AddObject(DepMedida.Name, DepMedida);
                                  Validos.AddObject(IndepMedida.Name, IndepMedida);
                                  ExpMedVal.Add(DepMedida.Descricao + ' = ' + DepMedida.ValorNumerico +  ' ' + DepMedida.Unidade +
                                                '; Variavel dependente da tabela :' + DescritoresDescricao.AsString + ' Fonte : ' + DescritoresFonte.AsString);
                                  ExpMedVal.Add(IndepMedida.Descricao + ' = ' + IndepMedida.ValorNumerico + ' ' + IndepMedida.Unidade +
                                                '; Variavel independente da tabela :' + DescritoresDescricao.AsString + ' Fonte : ' + DescritoresFonte.AsString);
                                  //Pasa para o proximo valor da lista
                               end;
                            end;
                            Valores.Active := False;
                            Break;
                         end;
                      end;
                   end;
                   if not AchouDesc then
                   begin
                      if AchouDescGeral then
                      begin
                         //Apenas checou range de variavel independente.
                         //Nao tem valor definido para a dependente.
                         //Valor valido, ele e os outros parametros
                         Valid := True;
                         IndepMedida.Valid := True;
                         Validos.AddObject(DepMedida.Name, DepMedida);
                         ExpMedVal.Add(DepMedida.Descricao + ' = ' + DepMedida.ValorNumerico +  ' ' + DepMedida.Unidade +
                                       '; Usando critério genérico :' + DescGeralDescricao + ', Fonte : '+ DescGeralFonte + ', ' +
                         DescGeralDesc + ' = ' + DescGeralValNum + ' ' + DescGeralUnid);
                         //Pasa para o proximo valor da lista
                      end
                      else
                      begin
                         Valid := True; // a pedido da Lilian por causa da gestante
                         SemDescrDesc.Add(DepMedida.Descricao + ' = ' + DepMedida.ValorNumerico +  ' '
                                          + DepMedida.Unidade +
                                          ' : Nenhum dos indicadores disponiveis consiste esta medida.');
                         SemDescrMed.AddObject (DepMedida.Name, DepMedida);
                      end;
                   end;
                end
                else
                begin
                    Valid := True;
                    NaoVerifDesc.Add(DepMedida.Descricao + ' : Aceita sem verificação.Sem indicadores para ela.');
                    //Result := False;
                    //ShowMessage ('Sem descritor para : '+Descricao);
                end;
             end;
          end;
          for I := 0 to InputData.ComponentCount - 1 do
              Result := Result and TMedida(InputData.Components[I]).Valid;
          if (ExpMedVal.Count > 0) then
          begin
             ExpMedVal.Insert(0, '------------------------------------');
             ExpMedVal.Insert(1, 'Valores consistentes ');
             ExpMedVal.Insert(2, '------------------------------------');
             ExpMedVal.Add(' ');
             ExpMedVal.Add(' ');
          end;
          ProcesseInconsistencias(InconsDesc);
          if (InconsDesc.Count > 0) then
          begin
             InconsDesc.Insert(0, '------------------------------------');
             InconsDesc.Insert(1, 'Valores Inconsistentes ');
             InconsDesc.Insert(2, '------------------------------------');
             InconsDesc.Add(' ');
             InconsDesc.Add(' ');
          end;
          if (SemDescrDesc.Count > 0) then
          begin
             SemDescrDesc.Insert(0, '------------------------------------');
             SemDescrDesc.Insert(1, 'Valores Inconsistentes : sem Descritor para eles');
             SemDescrDesc.Insert(2, '------------------------------------');
             SemDescrDesc.Add(' ');
             SemDescrDesc.Add(' ');
          end;
          if (NaoVerifDesc.Count > 0) then
          begin
             NaoVerifDesc.Insert(0 ,'------------------------------------------------');
             NaoVerifDesc.Insert(1 ,'Valores Nao Analizados por falta de Informações ');
             NaoVerifDesc.Insert(2 ,'------------------------------------------------');
             NaoVerifDesc.Add(' ');
             NaoVerifDesc.Add(' ');
          end;
          if (ExpParmVal.Count > 0) then
          begin
             ExpParmVal.Insert(0, '------------------------------------');
             ExpParmVal.Insert(1, 'Parametros validos de Tabelas');
             ExpParmVal.Insert(2, '------------------------------------');
             ExpParmVal.Add(' ');
             ExpParmVal.Add(' ');
          end;
          Explanacao.AddStrings(InconsDesc);
          // Este primeiro a pedido da Lilian
          //* Explanacao.AddStrings(SemDescrDesc);
          //* Explanacao.AddStrings(ExpMedVal);
          //* Explanacao.AddStrings(ExpParmVal);
          //* Explanacao.AddStrings(NaoVerifDesc);
          ExpMedVal.Free;
          ExpParmVal.Free;
          InconsDesc.Free;
          NaoVerifDesc.Free;
          SemDescrDesc.Free;
          SemDescrMed.Free; //Achei!!!!
          NaoVerifMed.Free;
   end;
end;

procedure TDescriptorManager.ProcesseInconsistencias(Incons: TStringList);
begin

end;


end.

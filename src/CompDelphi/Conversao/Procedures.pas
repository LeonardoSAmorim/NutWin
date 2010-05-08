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




unit procedures;

interface

uses
Windows,forms, DB, DBTables, SysUtils, stdctrls, grids,Dialogs, Mask, comctrls, classes,
controls;

{ Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables,  StdCtrls, DB, Menus, Registry, lslVersionInfo;}

{Dif_Data}
procedure dif_data(data_ini:Tdatetime;data_fim :Tdatetime;
          var age_anos:integer;var age_meses:integer;
          var age_dias:integer;var unidade_idade:char);
{Zeros_esq}
Function zeros_esq(ms_conv: Integer; mi_tamcampo : Integer):String;
{verif_exist_registro}
Function verif_exist_registro(qu_selecao:tquery;linha_sql:string):boolean;
{exec_sql}
Procedure exec_sql(qu_exec:tquery;linha_sql:string);
{exeq_sqlat}
Procedure exec_sqlat(qu_exec:tquery;linha_sql:string);
{CripSenha}
Function CripSenha(ms_Senha:string;mi_CodCrip:integer):string;
{FindString}
Function FindString(LsTexto:string; LsToFind:string):boolean;
{FindDescr_Sexo}
Function FindDescr_Sexo(ps_CodSexo:string):String;
{RLock}
Function RLock (PTabela:TTable):Boolean;
{FindStringCombo}
Function FindStringCombo (var pCombo:TCombobox; pString:String):Boolean;
{GetDigito}
Function GetDigito (LsNumero:String):String;
{MesToStr}
Function MesToStr(pMes:Integer):String;
{Space}
Function Space(pQtdSpc:integer):String;
{Replicar}
Function Replicar(pString:String; pQtd:integer):String;
{Poe Espaco}
Function PoeEspaco(pString:String; pTam:integer):String;
{FindDescricaoDocumento}
Function FindDescricaoDocumento(ps_Doc:String):String;
{preencheComboUFCRM}
procedure preencheComboUF(var pcb_uf:TCombobox);
{FindDescricaoUF}
Function FindDescricaoUF(ps_UF:String):String;
{Verif_SabadoDomigo}
Function Verif_SabadoDomingo(pd_Data:TDateTime):Boolean;
{FormataNumero}
Function FormataNumero(lr_Valor:Real;li_Int,li_Dec:Integer):String;
{ExcluiLinhaDoGrid}
Procedure ExcluiLinhaDoGrid(Var sg_Grid:TStringGrid;li_lin:Integer);
{LocalizaNoGrid}
Function LocalizaNoGrid(Ls_Valor:String;Var sg_Grid:TStringGrid;Li_col:Integer):Boolean;
{ReplicarCaracter}
Function ReplicarCaracter(ls_Caract:String;li_Qtd:Integer):String;
{MesExtenso}
Function MesExtenso(LiMes:Integer):String;
{DiaExtenso}
Function DiaSemanaExtenso(LdtData:TDateTime):String;
{LocalizaForm}
Function LocalizaForm(ls_NomeForm:String):Boolean;
{FormularioEstaCriado}
Function FormularioEstaCriado(LForm:Tform):Boolean;
{PegaUltimoDiaMes}
Function PegaUltimoDiaMes(LData:TDateTime):Integer;
{Preenche a combo com os dados de uma tabela}
procedure MontaComboGenerico(var pcb_combo: Tcombobox; pta_tabela: TTable; ps_codigo: string);
{Gravação de dados do paciente - pega o codigo do item escolhido para gravar na tabela}
procedure Pega_Codigo_ComboGenerico(var pcb_combo: Tcombobox; pta_tabela: TTable; ps_codigo, ps_descr, ps_cpgravacao: string; pta_tabelaGravacao: TTable);
{Recuperação de dados dopaciente - Busca na tabela o codigo e tras a descricao na combo }
procedure Pega_Descr_ComboGenerico(var pcb_combo: Tcombobox; pta_tabela: TTable; ps_codigo, ps_descr: string; pta_tabelaLeitura:TTable);
{ValidaHora}
Function ValidaHora(lsHora:String):Boolean;
{CopiaTabelas}
Function CopiaTabelas(LtaOrigem:TDBDataSet;Var LtaDestino:TTable):Boolean;
{CopiaRegistro}
Function CopiaRegistro(LtaOrigem:TDBDataSet;Var LtaDestino:TTable):Boolean;
{Plural}
function Plural(ps_palavra: string): string;
{VerificaPlural}
Function VerificaPlural(LiQtd:real;LsPalavra:String):String;
{PegaNomeArqTemp}
Function PegaNomeArqTemp:String;
{Preenche a Combo tipo DropDownList com Descricao e um código nao posição 101 (que não aparecerá para o usuário}
procedure PreencheComboDescrCodigo(var LcbCombo: Tcombobox; LtaTabela: TDBDataSet; LsCpoDescr,LsCpoCodigo: string);
{Posiciona a combo na linha onde for encontrada o CODIGO desejado
 Só serve para quem preencheu a combo com a rotina PreencheComboDescrCodigo }
Procedure PosicionaCombobox(var LcbCombo:TCombobox; LsCodigo:String);
{StrBranco}
function StrBranco(Sender: TObject; ps_var: string; pi_tam: integer): string;
{ColocaTagsNoTexto}
Procedure ColocaTagsNoTexto(Var LreTexto:TRichEdit);
{PegaCabecPara}
Function PegaCabecPara(LiIdade:Integer;LsSexo:String):String;
{Centraliza Formulário}
procedure Centraliza_Form(Formulario: TForm);
{VerificaCpf}
Function VerificaCpf(LsCPF:String):Boolean;
{VerificaCGC}
Function VerificaCGC(LsCGC:String):Boolean;
{PreencheCbDuracao}
Procedure PreencheCbDuracao(var cbDuracao:TCombobox;LiQtd:Integer);
{ConverteDuracaoEmDias}
Function ConverteDuracaoEmDias(LsValDuracao,LsDuracao:String):Integer;
{PosicionaNoEditPesquisa}
Procedure PosicionaNoEditPesquisa(Key:Char; EdPesquisa:TCustomEdit);
{SubstituirTexto}
Function SubstituirTexto(Var LsTexto:String;LsEncontrar,LsSubstituir:String):Boolean;
{PegaQtdDigitosAno}
Function PegaQtdDigitosAno:Integer;
{HabilitaControls}
Procedure HabilitaControls(LWinControl:TWinControl;lfStatus,LfLabel:Boolean);
{Esta função recebe um texto e devolve uma lista de palavras}
Function PegaPalavrasDoTexto(LsTexto:String):TStringList;
{Esta função serve para ler arquivos}
function Ler_Arquivo(ms_arq:string):String;
{Tira_Brancos}
procedure Tira_Brancos(LsCampo: TEdit);
{CorrigeCvDateSQLAccess, Veja comentários na implementação}
Procedure CorrigeCvDateSQLAccess(Var LsSql:String);
{PegaDiretorioDoWindows}
Function PegaDiretorioDoWindows:String;
{PegaDiretorioTemporario}
Function PegaDiretorioTemporario:String;
{IncluirLinhaNoGrid}
Procedure IncluirLinhaNoGrid(Var sg_Grid:TStringGrid;li_int:Integer);


implementation

Procedure dif_data(data_ini:Tdatetime;
                     data_fim:Tdatetime;
                     var age_anos:integer;
                     var age_meses:integer;
                     var age_dias:integer ;
                     var unidade_idade:char );


{
Esta procedure calcula a diferenca entre duas datas, devolvendo
a diferenca em anos, meses e dias
parametros by value:
           sao os parametros de entrada da procedure,
           ou seja, as duas datas para se calcular a diferenca onde :
           data_ini = data a partir de onde desejo calcular a idade;
           data_fim = data final para o calculo do intervalo;
            as datas sao do tipo TDATETIME.
           exemplo p/calcular a idade: data_ini = data_de_nasc
                                       data_fim = date() ou data de hoje
           by name:
              age_anos : idade em anos : integer;
              age_meses: idade em meses :integer;
              age_dias : idade em dias :integer;
              unidade_idade  'A'= anos , 'M' = meses, 'D'=dias : char;
******************************************************************
}
 var idade_atual: double;
     idade_calc:integer;
     temp:string;

begin

// idade_atual:= date() - fd_data_nasc.asfloat ;
// inicializo as variáveis que sao os parametros de saida
   age_anos:= 0; age_meses:= 0; age_dias:=0;
   if data_fim < data_ini
      then
      MessageDlg('Erro nas datas fornecidas!',mtError,[mbOk],0)
      else
      begin
      idade_atual:= data_fim  - data_ini ;


      if idade_atual  > 365
      then begin
               idade_calc:=trunc(idade_atual/365);
               age_anos:= idade_calc;
               unidade_idade:= 'A' ;
            end
      else if idade_atual < 30
               then  begin
                     str(trunc(idade_atual),temp);
                     age_dias:= trunc(idade_atual);
                     unidade_idade := 'D';
                     end
                else begin
                    idade_calc :=trunc(idade_atual/30) ;
                    age_meses :=idade_calc;
                    age_dias:= idade_calc mod 30;
                    unidade_idade := 'M';
                  end;
       end;

end;

 // procedure para executar comando SQL
 // parametros by value:
 //                     qu_exec    = objeto TQUERY para executar a query
 //                     linha_sql  = linha com comando SQL

 Procedure exec_sql(qu_exec:tquery;linha_sql:string);
 begin
   with qu_exec do
   begin
     close;
     sql.clear;
     CorrigeCvDateSQLAccess(Linha_sql);
     sql.add(linha_sql);
     prepare;
     open;
   end;
 end;

  Procedure exec_sqlat(qu_exec:tquery;linha_sql:string);
 // procedure para executar comando SQL para atualizar registros
 // parametros by value:
 //                     qu_exec    = objeto TQUERY para executar a query
 //                     linha_sql  = linha com comando SQL


 begin
   with qu_exec do
   begin
     close;
     sql.clear;
     sql.add(linha_sql);
     execsql;
   end;
 end;

 Function verif_exist_registro(qu_selecao:tquery;linha_sql:string):boolean;
 // procedure para executar comando SQL
 // parametros by value:
 //                     qu_exec    = objeto TQUERY para executar a query
 //                     linha_sql  = linha com comando SQL
 begin

   exec_sql(qu_selecao,linha_sql);
   qu_selecao.first;
   verif_exist_registro:=not(qu_selecao.eof);
 end;

Function zeros_esq(ms_conv: Integer; mi_tamcampo : Integer):String;
 {
 Esta função recebe dois valores: ms_conv que indica qual a numero a
 ser transformado e mi_tamcampo que indica o tamanho do campo que
 ira receber a string convertida com zeros a esquerda.
 Exemplo zeros_esq(55,5) ira devolver => 00055
 }
  var
    mi_tam : Integer;
    ms_zeros :String;
  begin
    ms_zeros := '0000000000000000000'; // ate 20 zeros a esq
    mi_tam := (mi_tamcampo-LENGTH(TRIM(IntToStr(ms_conv))));
    Result := COPY(ms_zeros,1,mi_tam) + IntToStr(ms_conv);
  end;

{Esta função serve para INCRIPTAR OU DESCRIPTAR senhas.
Parametros : Senha - Senha do usuário
             CodCrip - Este é uma espécie de senha para incriptar ou
                       descriptar senhas. Utilize o mesmo codigo para as
                       duas funcionalidades

                       Exemplo: Se usar o valor 10 para incriptar, tera
                                que utilizá-lo para descriptar

                                CripSenha('DISNEY',10) = '¢§£ôƒ¿'
                                CripSenha('¢§£ôƒ¿',10) = DISNEY }
{CRIPSENHA}
Function cripSenha(ms_Senha:string;mi_CodCrip:integer):string;
var
  mc_asc:char;
  ms_Aux:string;
  ms_Aux1:string;
  k:integer;
begin
  ms_Senha := uppercase(Trim(ms_senha));
  Ms_Aux  := '';
  Ms_Aux1 := '';

  for K := 1 to length(ms_Senha) do
  begin
    mc_Asc := Ms_Senha[K];
    mi_codCrip := mi_CodCrip+length(ms_senha);
    Ms_Aux1 := chr(255+Mi_CodCrip-ord(mc_asc));
    Ms_Aux := Ms_Aux + Ms_Aux1;
  end;
  CripSenha := ms_aux;
end;

{ FindString
  Localiza uma Palavra dentro de uma outra String
  Parametros:
     LsTexto - String de caracteres a ser pesquisada
     LsToFind - Palavra a ser localizada na LsTexto

  Retorna
     True - Se localizar
     False - Se nao localizar
}
Function FindString(LsTexto:string; LsToFind:string):boolean;
var
  i,mi_len1,mi_len2:integer;
begin
  mi_len1 := length(LsTexto);
  mi_len2 := length(LsToFind);
  result:=false;
  for i:=1 to (mi_len1+1-mi_len2) do
  begin
    if AnsiUpperCase(copy(LsTexto,i,mi_len2)) = AnsiUpperCase(LsToFind) then
      Result:=True;
  end;
end;

{ Esta funcao serve para retornar a descricao do sexo.
 PARAMETROS : Os parametros podem ser tanto a letra como um numero,
            por exemplo: 1 = F = Feminino
                         2 = M = Masculino
                         3 = I =  Indeterminado
 }

 Function FindDescr_Sexo(ps_CodSexo:string):String;
Const
 Array_Sexo: array[1..3] of String =
  ('FEMININO','MASCULINO','INDETERMINADO');
var
   I:integer;
begin
  // Se o PARAMETRO FOR PASSADO COMO NUMERO, CONVERTER PARA LETRA.
  if ps_codSexo = '1' then ps_CodSexo := 'F';
  if ps_codSexo = '2' then ps_CodSexo := 'M';
  if ps_codSexo = '3'then ps_CodSexo := 'I';

  for I := 1 to 3 do
  begin
    if Copy(Array_Sexo[I],1,1) = Ps_CodSexo then
      FindDescr_Sexo := Array_Sexo[I];
    //end
  end;
end;

{ Esta funcao serviria para verificar se um registro esta sendo
  utilizado por alguem. No Oracle esta funcao nao funciona. Portanto
  nao esta sendo utilizada por nenhuma rotina no projeto da eco
}
Function RLock (PTabela:TTable):Boolean;
begin
  Result := False;
  Try
    PTabela.Edit;
  except on Er:EDBEngineError do begin
    if Er.Errors[0].ErrorCode = 10241 then
      result := True;
    end;
  end;
end;

{
  Posiciona uma Combobox em um determinado item.
  Por exemplo se voce tem um combo de Estados (Sao Paulo, Rio, Minas ...)
  e que que a combobox fique posiciona no estado de Santa Catarina)
Parametros
  pCombobox - A combobox desejada
  pString - A String a ser localizada na combo

Retorna
  Se localizou o nao a string dentro da combobox
}
Function FindStringCombo (var pCombo:TCombobox; pString:String):Boolean;
Var i:integer;
Begin
  Result:=false;
  i:=0;
  While i <= pCombo.Items.Count-1 do
  begin
    pCombo.itemindex := i;
    If FindString(PCombo.Text,pString) then
    begin
      Result := true;
      i:=pCombo.items.count-1; //Forca a saida do While.
    end;
    inc(i);
  end;
End;
{
Retorna o digito conferidor de um numero.
Esta função é a mesma utilizada pelo CGC e algums bancos como Banco do
Brasil e Bradesco.
Parametros
  pNumero : Recebe um numero inteiro e retorna o seu digito

Retorno
  Digito conferidor do numero.

}
Function GetDigito (LsNumero:String):String;
Var
  i, Produto, Multiplicador, Digito: Integer;
  mi_dig:Integer;
Begin
  try
    mi_Dig := 1;
    While mi_dig <= 2 do
      begin
      Produto:=0;
      Multiplicador := 2;
      For i := Length(LsNumero) DownTo 1 do
      begin
        Produto := Produto + StrToInt(Copy(LsNumero, i, 1)) * Multiplicador;
        If Multiplicador = 9 then
          Multiplicador := 2
        else
          Multiplicador := Multiplicador + 1;
      end;
      Produto:=(Produto Mod 11);
      Digito := 11 - Produto;
      If (Digito = 10) Or (Digito = 11) then
        Digito := 0;
      {Concatena o Numero com o Digito e reaplica a formula para
      obter o outro digito}
      LsNumero := LsNumero + IntToStr(Digito);
      Inc(mi_Dig);
    End;
    //Pega somente o digito do numero
    Result := Copy(LsNumero,Length(LsNumero)-1,2);
  except
    Result:='';
  end;
End;

{MesToStr
 Recebe um mes em valor numererico e retorna uma String, correspondente ao
 mes desejado. A string e retornada em ingles, por causa do oracle
 Exemplo: pMes=1  Result:='JAN'
          pMes=2  Result:='FEB'
          pMes=3  Result:='MAR'

  Parametros
     pMes: Mes
  Retorno
     uma string de 3 caracteres correspondente ao mes
}

Function MesToStr(pMes:Integer):String;
Var
ms_Meses:String;
Begin
  ms_meses:='JanFebMarAprMaiJunJulAugSepOctNovDec';
  Result := Copy(ms_meses,((pMes - 1) * 3 + 1), 3);
end;

{
  Esta Funcao retorna a quantidade de espacos em branco
  que desejar;
  Exemplo: Space(5) => '     ' (5 espacos em branco)
}
Function Space(pQtdSpc:Integer):String;
Var
  I:Integer;
  ms_String:String;
begin
  ms_String:='';
  for i:=1 to pQtdSpc do
    ms_String:=Ms_String+' ';

  Result:=ms_String;
end;
{
 Esta funcao recebe uma string e preenche o que nao esta sendo ocupado
 com espacos em branco. Se nao consegui ser claro, aqui vai um exemplo:
 PoeEspaco('Aldisney', 15) ==> 'Aldisney       '
                               [--15 posicoes--]
}
function PoeEspaco(pString:String; pTam:integer):String;
begin
  Result:=pString+Space(pTam - length(pString));
end;
{
 Esta funcao replica em uma string a quantidade
 que desejar. Por exemplo:
 Replicar('-', 10) ==>  '----------'
}
Function Replicar(pString:String; pQtd:integer):String;
Var
  I:Integer;
begin
  result:='';
  for i:=1 to pQtd do
    Result:=Result+pString;
end;

{FindDescricaoDocumento}
Function FindDescricaoDocumento(ps_Doc:String):String;
begin
  if ps_Doc='CN' then
     Result:='Certidao de Nascimento';
  if ps_Doc='RG' then
     Result:='Registro Geral';
  if ps_Doc='TE' then
     Result:='Título de Eleitor';
  if ps_Doc='RE' then
     Result:='Registro Estadual';
  if ps_Doc='CC' then
     Result:='Certidão de Casamento';
  if ps_Doc='CT' then
     Result:='Carteira de Trabalho';
  if ps_Doc='CH' then
     Result:='Carteira Habilitação';
  if ps_Doc='CF' then
     Result:='CPF';
  if ps_Doc='CR' then
     Result:='Reservista';
  if ps_Doc='PA' then
     Result:='Passaporte';
  if ps_Doc='RC' then
     Result:='Registro Civil';
end;

{PreencheComboUF}
procedure preencheComboUF(var pcb_uf:TCombobox);
begin
  with pcb_uf do
  Begin
    items.add('Alagoas                               -AL');
    items.add('Bahia                                 -BA');
    items.add('Sergipe                               -SE');
    items.add('Pernambuco                            -PE');
    items.add('Paraiba                               -PB');
    items.add('Rio Grande do Norte                   -RN');
    items.add('Maranhão                              -MA');
    items.add('Piauí                                 -PI');
    items.add('Ceará                                 -CE');
    items.add('Amapá                                 -AP');
    items.add('Pará                                  -PA');
    items.add('Amazonas                              -AM');
    items.add('Roraima                               -RR');
    items.add('Rondônia                              -RO');
    items.add('Acre                                  -AC');
    items.add('Tocantins                             -TO');
    items.add('Goias                                 -GO');
    items.add('Mato Grosso                           -MT');
    items.add('Mato Grosso do Sul                    -MS');
    items.add('Rio de Janeiro                        -RJ');
    items.add('São Paulo                             -SP');
    items.add('Minas Gerais                          -MG');
    items.add('Espirito Santo                        -ES');
    items.add('Parana                                -PR');
    items.add('Santa Catarina                        -SC');
    items.add('Rio Grande do Sul                     -RS');
  end;
end;

{FindDescricaoUF}
Function FindDescricaoUF(ps_UF:String):String;
begin
  if ps_UF = 'AL' then
    Result:='Alagoas';
  if ps_UF = 'BA' then
    Result:='Bahia';
  if ps_UF = 'SE' then
    Result:='Sergipe';
  if ps_UF = 'PE' then
    Result:='Pernambuco';
  if ps_UF = 'PB' then
    Result:='Paraiba';
  if ps_UF = 'RN' then
    Result:='Rio Grande do Norte';
  if ps_UF = 'MA' then
    Result:='Maranhão';
  if ps_UF = 'PI' then
    Result:='Piauí';
  if ps_UF = 'CE' then
    Result:='Ceará';
  if ps_UF = 'AP' then
    Result:='Amapá';
  if ps_UF = 'PA' then
    Result:='Pará';
  if ps_UF = 'AM' then
    Result:='Amazonas';
  if ps_UF = 'RR' then
    Result:='Roraima';
  if ps_UF = 'RO' then
    Result:='Rondônia';
  if ps_UF = 'AC' then
    Result:='Acre';
  if ps_UF = 'TO' then
    Result:='Tocantins';
  if ps_UF = 'GO' then
    Result:='Goias';
  if ps_UF = 'MT' then
    Result:='Mato Grosso';
  if ps_UF = 'MS' then
    Result:='Mato Grosso do Sul';
  if ps_UF = 'RJ' then
    Result:='Rio de Janeiro';
  if ps_UF = 'SP' then
    Result:='São Paulo';
  if ps_UF = 'MG' then
    Result:='Minas Gerais';
  if ps_UF = 'ES' then
    Result:='Espirito Santo';
  if ps_UF = 'PR' then
    Result:='Parana';
  if ps_UF = 'SC' then
    Result:='Santa Catarina';
  if ps_UF = 'RS' then
    Result:='Rio Grande do Sul';
end;
{Verif_SabadoDomingo}
Function Verif_SabadoDomingo(pd_Data:TDateTime):Boolean;
begin
 if (DayOfWeek(pd_Data)=7) or (DayOfWeek(pd_Data)=1) then
   result := true
 else
   result := false;
end;


Function FormataNumero(lr_Valor:Real;li_Int,li_Dec:Integer):String;
var
  ls_valor,ls_mascara:string;
  li_tam:integer;
begin
  ls_mascara:='%0.'+IntToStr(li_dec)+'f';
  ls_valor:= Format(ls_mascara, [lr_valor]);
  li_tam:=li_int+li_dec+1;
  Result:=copy(ls_valor,1+Length(ls_valor)-li_tam,li_tam);


end;

{Esta Procedure, exclui uma linha do StringGrid, digamos que voce queira excluir
 a linha 3 e o grid possui 6 linhas, portanto a exclusao pega a linha
  4 passa para a 3,
  5 passa para a 4,
  6 passa para a 5,
  e a 6 é excluída. Lembre-se que o stringGrid só excluir a última linha, ou melhor
  ele nao exclui somente esconde, portanto lembre-se de limpar a linha antes de
  escondê-la, senão quando pedir mais uma linha, esta virá com o que estava
  preenchido antes

  Parâmetros
  sg_grid - passada por referencia, é o grid da qual deseja excluir a linha
  li_lin - A linha que vai ser excluída
  }
{IncluirLinhaNoGrid}
Procedure IncluirLinhaNoGrid(Var sg_Grid:TStringGrid;li_int:Integer);
var
 i,li_col:integer;
begin
  //Adicionando uma linha no final do grid
  sg_grid.RowCount:=sg_grid.RowCount+1;
  For i:=sg_grid.RowCount-1 downto li_int do
  begin
    //Copiando a linha corrente para a linha seguinte
    for li_col:=0 to sg_grid.ColCount-1 do
      sg_grid.cells[li_col,i+1]:=sg_grid.cells[li_col,i]
  end;
  //limpando a linha solicitada
  for li_col:=0 to sg_grid.ColCount-1 do
    sg_grid.cells[li_col,li_int]:=''
end;

Procedure ExcluiLinhaDoGrid(Var sg_Grid:TStringGrid;li_lin:Integer);
var
 li_col:integer;
begin
  While li_lin < sg_grid.RowCount-1 do //Fazer somente até a penultima linha
  begin
    for li_col:=0 to sg_grid.ColCount-1 do
    begin
      sg_grid.cells[li_col,li_lin]:=sg_grid.cells[li_col,li_lin+1]
    end;
    li_lin:=li_lin+1;
  end;
  //Limpando a última linha antes de excluuí-la (veja coment. acima)
  for li_col:=0 to sg_grid.ColCount do
    sg_grid.cells[li_col,li_lin]:='';
  sg_grid.RowCount:=sg_grid.RowCount-1;
end;

{Serve para localiza se existe no Grid. Para usar passe como parametro
 o Grid que deseja fazer a busca, o Valor e qual Coluna}
Function LocalizaNoGrid(Ls_Valor:String;Var sg_Grid:TStringGrid;Li_col:Integer):Boolean;
var
 li_Lin:integer;
begin
  result:=false;
  for li_Lin:=0 to sg_grid.RowCount-1 do
  begin
    //Se Achar o valor no Grid, retorna True;
    if sg_grid.cells[li_col,li_lin] = Ls_Valor then
    begin
      Result:=true;
      exit;
    end;
  end;

end;


Function ReplicarCaracter(ls_Caract:String;li_Qtd:Integer):String;
var
  i:integer;
begin
  result:='';
  for i:=1 to li_qtd do
    result:=result+ls_Caract;
end;

{MesExtenso}
Function MesExtenso(LiMes:Integer):String;
begin
  case LiMes of
     1: Result:='Janeiro';
     2: Result:='Fevereiro';
     3: Result:='Março';
     4: Result:='Abril';
     5: Result:='Maio';
     6: Result:='Junho';
     7: Result:='Julho';
     8: Result:='Agosto';
     9: Result:='Setembro';
    10: Result:='Outubro';
    11: Result:='Novembro';
    12: Result:='Dezembro';
  else
    MessageDlg('Função MesExtenso: Mes Inválido!',mtError,[mbOk],0);
  end;

end;
{DiaSemanaExtenso}
Function DiaSemanaExtenso(LdtData:TDateTime):String;
Var
  LiDiaSemana:Integer;
begin
  LiDiaSemana:=DayOfWeek(LdtData);
  Case LiDiaSemana of
    1: Result:='Domingo';
    2: Result:='Segunda';
    3: Result:='Terça';
    4: Result:='Quarta';
    5: Result:='Quinta';
    6: Result:='Sexta';
    7: Result:='Sábado';
  end;
end;

Function LocalizaForm(ls_NomeForm:String):Boolean;
var
  I : integer;
begin
  { Procura o nome do form na lista de forms que foram criados }
  result:=false;
  for  I:=0 to Screen.FormCount-1 do  begin
    if UpperCase(screen.Forms[I].Name)=UpperCase(ls_NomeForm) then
       result:=True;
  end;
end;

Function FormularioEstaCriado(LForm:Tform):Boolean;
begin
  if LForm = Nil then
    result := false
  else
    if LForm.parent = nil then
      result := false
    else
      result := true;

end;

Function PegaUltimoDiaMes(LData:TDateTime):Integer;
Var
  LiMes,LiAno:Integer;
  LsData:String;
begin
  LsData:=FormatDateTime('dd/mm/yyyy',LData);
  LiMes:=StrToInt(Copy(LsData,4,2));
  LiAno:=StrToInt(Copy(LsData,7,4));
  if LiMes in [1,3,5,7,8,10,12] then
    Result:=31
  else
    if LiMes in [4,6,9,11] then
      Result:=30
    else //Fevereiro
       if (LiAno mod 4) = 0 then  //Ano Bisexto
         Result:=29
       else
         Result:=28;
end;

Procedure MontaComboGenerico(var pcb_combo: Tcombobox; pta_tabela: TTable; ps_codigo: string);
var LsTextoCombo : String;
begin
   LsTextoCombo := pcb_combo.Text;
   pta_tabela.Refresh;    // Para pegar a Tabela de Profissoes atualizada - Bia 23/08
   pta_tabela.First;
   pcb_combo.Clear;
   while Not pta_tabela.Eof do
   begin
     pcb_combo.Items.Add(pta_tabela.FieldByName(ps_codigo).AsString);
     pta_tabela.Next;
   end;
   if LsTextoCombo <> '' then
      pcb_combo.ItemIndex := pcb_combo.Items.IndexOf(LsTextoCombo);
end;

procedure Pega_Codigo_ComboGenerico(var pcb_combo: Tcombobox;
pta_tabela: TTable; ps_codigo, ps_descr, ps_cpGravacao: string; pta_tabelaGravacao:TTable);
{pcb_combo          = é o nome da combobox em tela (TComboBox).Exem: cbBairro
 pta_TabelaGravacao = é o nome da tabela (e tb do datamodulo) onde será gravado a informação. Ex:taPacComplemento
 pta_Tabela         = é o nome da tabela (e tb do datamodulo) que onde será lido a informação. Ex: taBairro
 ps_codigo          = é o nome do campo da tabela onde será lido a informação. Ex: cod_bairro de taBairro
 ps_descr           = é o nome do campo de pta_tabela em que o item escolhido em combobox será procurado.Ex: descr_bairro de taBairro
 ps_cpGravacao      = é o nome do campo da tabela onde será gravado a informação. Ex: cod_bairro de taPacComplemento
}
begin
   if length(pcb_combo.text) <> 0 then
   begin
      pta_tabela.Locate(ps_descr,pcb_combo.text,[loCaseInsensitive]);
      if not pta_tabela.eof then
      begin
         pta_tabelaGravacao.fieldByName(ps_cpGravacao).asString:=
         pta_tabela.fieldByName(ps_codigo).asString;
      end;
   end;
end;

procedure Pega_Descr_ComboGenerico(var pcb_combo: TComboBox;pta_tabela: TTable; ps_codigo, ps_descr: string; pta_tabelaLeitura:TTable);
{pcb_combo  = é o nome da combobox em tela (TComboBox)
 pta_tabela = é o nome da tabela (e tb do datamodulo) que serviu para alimentar a combobox.Exem:taCor
 ps_codigo  = é o nome do campo da tabela onde será procurado a informação. Ex: cod_cor
 ps_descr   = é o nome do campo de pta_tabela que será lido para preenhcer a combobox. Ex: descr_cor de taCor
 pta_tabelaLeitura = é o nome da tabela que armazena o código do item escolhido da combobox.Exem: taPaciente que armazena o código da cor
}
begin
   pcb_combo.text := pta_tabelaLeitura.fieldByName(ps_codigo).asString;
   if length(pcb_combo.text) <> 0 then
   begin
      pta_tabela.Locate(ps_codigo,pcb_combo.text,[loCaseInsensitive]);
      if not pta_tabela.eof then
         pcb_combo.text := pta_tabela.fieldByName(ps_descr).asString;
   end
   else pcb_combo.text := '';
end;
{ValidaHora}
Function ValidaHora(lsHora:String):Boolean;
var
  LHora:TDateTime;
begin
  LHora:=Time;
  try
    LHora:=StrToTime(LsHora);
    result:=true;
  except
    messageDlg('Hora inválida!',mtError,[mbOk],0);
    result:=false;
  end;
  //Esta linha é so para tira o Hint do Delphi "Value assigned to LHora never used
  if (LHora = time) and (result = true) then
     result := true;
end;

Function CopiaTabelas(LtaOrigem:TDBDataSet;Var LtaDestino:TTable):Boolean;
begin
  try
    ltaOrigem.First;
    While not ltaOrigem.eof do
    begin
      CopiaRegistro(ltaOrigem,LtaDestino);
      ltaOrigem.next;
    end;
    result:=true;
  except
    on e:exception do
    begin
      messageDlg(E.Message,mtError,[mbOk],0);
      Result:=false;
    end;
  end;
end;

{Copia todo o registro POSICIONADO de uma tabela ORIGEM para outra
 de mesma estrutura (DESTINO) }
Function CopiaRegistro(LtaOrigem:TDBDataSet;Var LtaDestino:TTable):Boolean;
var
  i:integer;
  LsCampo:String;
begin
  Try
    LtaDestino.Insert;
    for i:=0 to LtaOrigem.FieldCount-1 do
    begin
      //So vale para campos que existam fisicamente na tabela.
      //Ignorando os campos Lockup, calculados, etc.
      try
        if LtaOrigem.Fields[i].FieldKind = fkData then
        begin
          LsCampo:=LtaOrigem.Fields[i].fieldName;
          if LtaDestino.FieldList.Find(LsCampo)<>nil then //Se encontrar o campo...
            LtaDestino.FieldByName(LsCampo).value:=LtaOrigem.FieldByName(LsCampo).value;
        end;
      Except
        On E:Exception do
        Begin
          messageDlg(E.Message,mtError,[mbOk],0);
        end;
      end;
    end;
    LtaDestino.post;
    LtaDestino.refresh;
    result:=true;
  except
    On E:Exception do
    Begin
      messageDlg(E.Message,mtError,[mbOk],0);
      Result:=false;
    end;
  end;
end;

function Plural(ps_palavra: string): string;
var li_tpalavra, li_i: integer;
    ls_pedaco: string;
begin
      li_tpalavra := length(ps_palavra);
      for li_i := 1 to li_tpalavra do
         if copy(ps_palavra,li_i,1) = ' ' then
         begin
            ls_pedaco   := copy(ps_palavra,li_i,li_tpalavra);
            ps_palavra  := copy(ps_palavra,1,li_i-1);
            li_tpalavra := length(ps_palavra);
         end;
      if ((copy(ps_palavra,li_tpalavra,1) = 'a')  or
          (copy(ps_palavra,li_tpalavra,1) = 'e')  or
          (copy(ps_palavra,li_tpalavra,1) = 'i')  or
          (copy(ps_palavra,li_tpalavra,1) = 'o')  or
          (copy(ps_palavra,li_tpalavra,1) = 'u')  or
          (copy(ps_palavra,li_tpalavra,1) = 'y'))  then

          ps_palavra := ps_palavra + 's';

      if ((copy(ps_palavra,li_tpalavra,1) = 'A')  or
          (copy(ps_palavra,li_tpalavra,1) = 'E')  or
          (copy(ps_palavra,li_tpalavra,1) = 'I')  or
          (copy(ps_palavra,li_tpalavra,1) = 'O')  or
          (copy(ps_palavra,li_tpalavra,1) = 'U')  or
          (copy(ps_palavra,li_tpalavra,1) = 'Y')) then

          ps_palavra := ps_palavra + 'S';

      if (copy(ps_palavra,li_tpalavra - 2,3) = 'ção')  then
         ps_palavra := copy(ps_palavra,1,li_tpalavra - 2) + 'ões';
      if (copy(ps_palavra,li_tpalavra - 2,3) = 'ÇÃO') then
          ps_palavra := copy(ps_palavra,1,li_tpalavra - 2) + 'ÕES';

      if (copy(ps_palavra,li_tpalavra - 2,3) = 'lar')  then
         ps_palavra := ps_palavra + 'es';
      if (copy(ps_palavra,li_tpalavra - 2,3) = 'LAR') then
          ps_palavra := ps_palavra + 'ES';

      if (copy(ps_palavra,li_tpalavra,1) = 'l')  then
          ps_palavra := copy(ps_palavra,1,li_tpalavra - 1) + 'is';
      if (copy(ps_palavra,li_tpalavra,1) = 'L') then
          ps_palavra := copy(ps_palavra,1,li_tpalavra - 1) + 'IS';

      if (copy(ps_palavra,li_tpalavra,1) = 'm')  then
          ps_palavra := copy(ps_palavra,1,li_tpalavra - 1) + 'ns';
      if (copy(ps_palavra,li_tpalavra,1) = 'M') then
          ps_palavra := copy(ps_palavra,1,li_tpalavra - 1) + 'NS';

      ps_palavra := ps_palavra + ls_pedaco;

      result := ps_palavra;
end;
{Esta função, verifica se deve ou não chamar a função Plural (acima)
 depende da quantidade informada de algumas gambiarrazinhas (Sorry, hehehehe)}
Function VerificaPlural(LiQtd:real;LsPalavra:String):String;
begin
  Result:=LsPalavra; //Se for ml,mg,kg,km,etc retorna a própria palavra
  //Gambiarra para resolver um problema da receita
  if UpperCase(LsPalavra)='ML' then  exit;
  if UpperCase(LsPalavra)='MG' then  exit;
  if UpperCase(LsPalavra)='KG' then  exit;
  if UpperCase(LsPalavra)='KM' then  exit;
  if UpperCase(LsPalavra)='M' then  exit;
  if UpperCase(LsPalavra)='G' then  exit;
  if UpperCase(LsPalavra)='L' then  exit;
  //Se chegar até aqui e LiQtd>1, então chamar a função Plural de "Procedures.pas"
  if LiQtd > 1 then
    Result := Plural(LsPalavra);
end;



{Esta função devolve um nome de arquivo temporário que não exista
 ATENÇÃO:
   Esta funnção não cria o arquivo, devolve somente a string com um nome de
   arquivo como sugestão, portanto é importante que voce Crie o arquivo
   FISICAMENTE no disco logo após a chamada dessa função}
Function PegaNomeArqTemp:String;
Var
  LfFaca:boolean;
  LWinDir,LsArquivo:String;
begin
  // Initialize Variable
  LWinDir:=PegaDiretorioDoWindows;
  LfFaca:=true;
  LsArquivo:='';
  While LfFaca do  //Faca ate gerar um arquivo que não exista
  begin
    Randomize;
    LsArquivo:=LWinDir+'\temp\'+'CM'+IntToStr(Random(999999))+'.CIS';
    if not FileExists(LsArquivo) then
      LfFaca:=false; //Sai do loop
  end;
  result:=LsArquivo;
end;
{PreencheComboDescrCodigo}
procedure PreencheComboDescrCodigo(var LcbCombo: Tcombobox; LtaTabela: TDBDataSet; LsCpoDescr,LsCpoCodigo: string);
Var
  LsTemp:String;
begin
   if not LtaTabela.active then LtaTabela.open;
   LtaTabela.first;
   LcbCombo.items.clear;
   while Not LtaTabela.eof do
   begin
     LsTemp:=LtaTabela.fieldByName(LsCpoDescr).AsString;
     LsTemp:=LsTemp+Space(100-Length(LsTemp))+LtaTabela.fieldByName(LsCpoCodigo).AsString;
     LcbCombo.items.add(LsTemp);
     LtaTabela.Next;
   end;
   {Exemplo de como pegar o código da combo
     LsCodigo := copy(cbCombo.text,101,10)}
end;

{Posiciona a combo na linha onde for encontrada o CODIGO desejado
 Só serve para quem preencheu a combo com a rotina PreencheComboDescrCodigo }
Procedure PosicionaCombobox(var LcbCombo:TCombobox; LsCodigo:String);
Var
  i:integer;
  LfAchou:Boolean;
begin
  LfAchou:=true;
  For i:=0 to LcbCombo.items.count-1 do
  begin
    If LsCodigo = Trim(Copy(LcbCombo.Items[i],101,20)) then
    begin
      LcbCombo.itemIndex := i;
      LfAchou:=true;
      break; //sair do For
    end;
  end;
  if not LfAchou then
    LcbCombo.itemIndex:=-1;
end;

function StrBranco(Sender: TObject; ps_var: string; pi_tam: integer): string;
var ls_branco, ls_var, ls_letra: string;
    li_i: integer;
begin
   if Length(Trim(ps_var)) <> 0 then
      if ((pi_tam = 4) and (Length(Trim(ps_var)) > 2)) or ((pi_tam = 8) and (Length(Trim(ps_var)) > 5)) then
      begin
         for li_i := 1 to Length(ps_var) do
         begin
            ls_letra := Copy(ps_var,li_i,1);
            if ls_letra <> ' ' then ls_var := ls_var + ls_letra;
         end;
         ps_var := ls_var;
         ls_branco := '          ' ;
         StrBranco := Copy(ls_branco,1,pi_tam - Length(TrimLeft(ps_var))) + TrimLeft(ps_var);
      end
      else
      begin
         ShowMessage('O Número informado não é correto. Tente novamente!');
         (Sender as TMaskEdit).Setfocus;
      end
end;

Procedure ColocaTagsNoTexto(Var LreTexto:TRichEdit);
Var
  I:Integer;
  LsVar:String;
begin
  with LreTexto do
  begin
    for i:=0 to Lines.Count-1 do
    begin
      LsVar:=Trim(Lines[i]);
      If LsVar<>'' then
      begin
        if LsVar[1] = '[' then //Se tiver apagar...
          LsVar := Trim(Copy(LsVar,2,Length(LsVar)));
        if LsVar[Length(LsVar)]=']' then //Se Tiver apagar...
          LsVar := Trim(Copy(LsVar,1,Length(LsVar)-1));
        Lines[i]:='['+LsVar+']';
      end;
    end;
  end;
end;

Function PegaCabecPara(LiIdade:Integer;LsSexo:String):String;
begin
  if (LsSexo='M') and (LiIdade >= 18) then
      Result := 'Para o Sr. ';
  if (LsSexo='M') and (LiIdade < 18) then
      Result := 'Para o Menor ';
  if (LsSexo='F') and (LiIdade >= 18) then
      Result := 'Para a Sra. ';
  if (LsSexo='F') and (LiIdade < 18) then
      Result := 'Para a Menor ';
end;

procedure Centraliza_Form(Formulario: TForm);
var LvTop, LvLeft : Variant;
   LMDIForm : TForm;
   LToolBar : TToolBar;
   LStatusBar : TStatusBar;
begin
   LMDIForm := Application.MainForm;
   LToolBar := (LMDIForm.FindComponent('tbMenu') as TToolBar);
   LStatusBar := (LMDIForm.FindComponent('stMenu') as TStatusBar);
   if Screen.Height = 480 then
      if Formulario.Height > 360 then
         Formulario.Height := 360;
   if Screen.Width = 640 then
      if Formulario.Width > 632 then
         Formulario.Width := 632;
   if Formulario.FormStyle = fsMDIChild then
   begin
      LvTop := (LMDIForm.ClientHeight-LToolBar.Height-LStatusBar.Height-Formulario.Height)/2;
      LvLeft := (LMDIForm.ClientWidth-Formulario.Width)/2;
   end
   else
   begin
      LvTop := (LMDIForm.Height-Formulario.Height)/2;
      LvLeft := (LMDIForm.Width-Formulario.Width)/2;
   end;
   if Formulario.FormStyle = fsMDIChild then
   begin
      Formulario.Show;
      if formulario.WindowState <> wsMaximized then
      begin
        if Trunc(LvTop) < 3 then
           Formulario.Top := 0
        else
           Formulario.Top := Trunc(LvTop);
        if Trunc(LvLeft) < 3 then
           Formulario.Left := 0
        else
           Formulario.Left := Trunc(LvLeft);
      end;     
   end
   else
   begin
      if Formulario.Height > (LMDIForm.ClientHeight-LToolBar.Height-LStatusBar.Height) then
         Formulario.Top := LMDIForm.Top+44+LToolBar.Height
      else
         Formulario.Top := LMDIForm.Top+LToolBar.Height+Trunc(LvTop)-4;
      Formulario.Left := LMDIForm.Left+Trunc(LvLeft);
   end;
end;

Function VerificaCpf(LsCPF:String):Boolean;
VAR
  WCPFCALC : STRING;
  WSOMACPF : INTEGER;
  WSX1     : SHORTINT;
  WCPFDIGT : INTEGER;
begin
 if (LsCPF <> '   .   .   -  ') and
    (LsCPF <> '') then
 BEGIN
   try
     LsCPF := Copy(LsCPF,1,3)+Copy(LsCPF,5,3)+
     Copy(LsCPF,9,3)+Copy(LsCPF,13,2);
     wcpfcalc := copy(LsCPF, 1, 9);
     wsomacpf := 0;
     for wsx1:= 1 to 9 DO
       wsomacpf := wsomacpf + strtoint(copy(wcpfcalc, wsx1, 1)) * (11 - wsx1);
     wcpfdigt:= 11 - wsomacpf mod 11;
     if wcpfdigt in [10,11] then
     BEGIN
       wcpfcalc:= wcpfcalc + '0';
     END
     else
     BEGIN
       wcpfcalc := wcpfcalc +  inttoStr(wcpfdigt);
     END;
     wsomacpf:= 0;
     for wsx1:= 1 to 10 DO
       wsomacpf := wsomacpf + strtoint(copy(wcpfcalc, wsx1, 1)) * (12 - wsx1);
     wcpfdigt:= 11 - wsomacpf mod 11;
     if wcpfdigt in [10,11] then
     BEGIN
       wcpfcalc:= wcpfcalc + '0';
     END
     else
     BEGIN
       wcpfcalc := wcpfcalc +  inttoStr(wcpfdigt);
     END;
     if LsCPF <> wcpfcalc then
     begin
       Result := false;
     end
     else
       Result := true;
   except
     on econverterror do
     begin
       Result := false;
     end
   end
 END
 else
 begin
   result:=false;
 end;
end;

Function VerificaCGC(LsCGC:String):Boolean;
var
  LfCGCValido:Boolean;
  lsDigito:String;
begin
  if LsCGC <> '' then
  begin
    LfCGCValido:=true;
    if Length(LsCGC) < 18 then
      LfCGCValido:=False
    else
    begin
      //pegar somente o digito
      LsDigito:=Copy(LsCGC,17,2);
      //Exemplo: 12.345.678/0001-99
      //Tirar os pontos, a barra e o digito (123456780001)
      LsCGC:=Copy(lsCGC,1,2)+Copy(LsCGC,4,3)+Copy(LsCGC,8,3)+Copy(LsCGC,12,4);
      if LsDigito <> GetDigito(LsCGC) then
        LfCGCValido:=false;
    end;
  end
  else
    LfCGCValido:=false;

  Result := LfCGCValido;
end;

Procedure PreencheCbDuracao(var cbDuracao:TCombobox;LiQtd:Integer);
var
  LiIndex:Integer;
begin
  with cbDuracao do
  begin
     liIndex:=ItemIndex;
     clear;
     if LiQtd = 0 then
     begin
       items.Add('(Uso Contínuo)');
       itemIndex:=0;
       exit;
     end;
     if LiQtd = 1 then
     begin
       items.Add('dia');
       items.Add('semana');
       items.Add('mês');
       items.Add('ano');
     end
     else
     begin
       items.Add('dias');
       items.Add('semanas');
       items.Add('meses');
       items.Add('anos');
     end;
     itemIndex:=LiIndex;
  end;
end;

Function ConverteDuracaoEmDias(LsValDuracao,LsDuracao:String):Integer;
Var
  LiDias:Integer;
Begin
  Result:=0;
  If (LsValDuracao='')or(LsDuracao='') then
  begin
    exit;
  end;
  LiDias:=0;
  If UpperCase(LsDuracao[1])='D' then //Dias
    LiDias := StrToInt(LsValDuracao);
  If UpperCase(LsDuracao[1])='S' then //Semanas
    LiDias := StrToInt(LsValDuracao) * 7;
  if UpperCase(LsDuracao[1])='M' then //Meses
    LiDias := StrToInt(LsValDuracao) * 30;
  if UpperCase(LsDuracao[1])='A' then //Anos
    LiDias := StrToInt(LsValDuracao) * 365;

  Result:=LiDias;
end;

{Esta função dever ser usada para DbGrids que tem um Edit correspondete para
 fazer a localização no Grid.
 Quando uma tecla for pressionada (no DBGrid), a função fará um SetFocus
 no Edit de pesquisa correspondente ao Grid.
 Esta função deverá ser chamada apartir do Evento OnKeyPress, não pode ser
 apartir do OnKeyDown ou OnKeyUp, porque estes devolvem o ASCII da Tecla
 pressionada, e não a tecla. Por exemplo, ao invez de "A" ela devolve "65"}

Procedure PosicionaNoEditPesquisa(Key:Char; EdPesquisa:TCustomEdit);
begin
  if FindString('ABCDEFGHIJKLMNOPQRSTUVXYWZ0123456789',Key) then
  begin
    if (EdPesquisa is TMaskEdit) then
      //Se não colocar o Cast, ele mata a máscara do MaskEdit;
      TMaskEdit(edPesquisa).text:=Key
    else
      edPesquisa.text:=Key;
    edPesquisa.setFocus;
    //Deselecionado o texto selecionado
    edPesquisa.SelStart:=1;
  end;
end;

{Substitui uma palavra em todo o texto.
 Exemplo Substituir
  LsTexto = "Sorria para todos"
  LsEncontrar:="Todos"
  LsSubstituir:="mim"
  Chamada da função...
  SubstituirTexto(LsTexto,LsEncontrar,LsSubstituir)
  Resultado : "Sorria para mim"
  }

Function SubstituirTexto(Var LsTexto:String;LsEncontrar,LsSubstituir:String):Boolean;
var
  Lmemo : Tmemo;
  LiRes:Integer;
begin
  result:=false;
  Lmemo := Tmemo.Create(nil);
  LMemo.visible := false;
  LMemo.Parent := Screen.activeForm;
  Lmemo.Text := LsTexto;
  with Lmemo do
  begin
    LiRes:=Pos(LsEncontrar,text);
    While LiRes <> 0 do
    begin
      SelStart := LiRes-1;
      SelLength := Length(LsEncontrar);
      SelText := LsSubstituir;
      LiRes:=Pos(LsEncontrar,text);
      result:=true;
    end;
  end;
  LsTexto := LMemo.text;
  LMemo.free;
end;

{PegaQtdDigitosAno}
Function PegaQtdDigitosAno:Integer;
begin
  result:=0;
  if Length(DateToStr(Date))=8 then
    result:=2;
  if Length(DateToStr(Date))=9 then
    result:=3;
  if Length(DateToStr(Date))=8 then
    result:=4;
end;
{
}
Procedure HabilitaControls(LWinControl:TWinControl;lfStatus,LfLabel:Boolean);
var
  I: Integer;
  ChildControl: TControl;
begin

  //  padados.enabled := LfStatus;
  for I:= 0 to LWinControl.ControlCount -1 do
  begin
    ChildControl := LWinControl.Controls[I];
    if (LfLabel) or ( (Not LfLabel) and (not (ChildControl is TLabel)) ) then
        ChildControl.enabled := LfStatus;
  end;
end;


{Esta função recebe um texto e devolve uma lista de palavras
Exemplo: LsTexto = "Pedro de Toledo"
         LslLista[0]:"Pedro"
         LslLista[1]:="de"
         LslLista[2]:="Toledo"}

Function PegaPalavrasDoTexto(LsTexto:String):TStringList;
var
  LslLista:TStringList;
  LsPalavra:String;
  i:integer;
begin
  LsPalavra:='';
  LslLista:=TStringList.Create;
  For i:=1 to length(LsTexto) do
  begin
    if LsTexto[i]<>' ' then
      LsPalavra:=LsPalavra+LsTexto[i]
    else
      if LsPalavra<>'' then
      begin
        LslLista.add(LsPalavra);
        LsPalavra:='';
      end;
  end;
  LslLista.add(LsPalavra);
  Result:=LslLista
end;

function Ler_Arquivo(ms_arq:string):String;
var
  ms_conteudo, ms_linha:string;
  F: TextFile;
begin
  try
    AssignFile(F,ms_arq);
    Reset(F);
    while not Eof(F) do
    begin
      readln(f,ms_linha);
      ms_conteudo:=ms_conteudo+trim(ms_linha);
    end;
    CloseFile(F);
    result:=trim(ms_conteudo);
  except
    on e:exception do
    begin
      result:=e.message;
    end;
  end;

end;

procedure Tira_Brancos(LsCampo: TEdit);
var LsN1, LsN2: string;
    LiNum: integer;
begin
   LsCampo.Text := Trim(LsCampo.Text);
   while Pos('  ',LsCampo.Text) > 0 do
   begin
      LiNum := Pos('  ',LsCampo.Text);
      LsN1 := Copy(LsCampo.Text,1,LiNum);
      LsN2 := Copy(LsCampo.Text,LiNum+2,Length(LsCampo.Text));
      LsCampo.Text := LsN1 + LsN2;
   end;
end;
{Esta procedure serve para corrigir o SQL do Access.
 A função CvDate do SQL considera o formato da data do sistema operacional. Portanto
 a sintaxe varia de acordo com a tipo de data do Sistema Operacional (não a do Delphi) ou
 seja, se for sistema Americano, a sintaxe seria, por exemplo
    CvDate('12/31/1999')
 e se for no sistema Brasileiro, ela seria
    CvDate('31/12/1999')

 Como este problema foi detectado muito tarde, todas as queries foram geradas
 no sintaxe brasileira, ou seja, dd/mm/aaaa.
 Esta função vai ter que verificar qual é o tipo de data do sistema operacional,
 e fazer esta conversão, caso exista o comando CvDate.}

Procedure CorrigeCvDateSQLAccess(Var LsSql:String);
var
  LsDataNoFormatoDelphi,LsDataNoFormatoMDY:String;
  LiLenCvDate,LiPos,LiLen1,LiLenTexto,LiLenDate:Integer;
begin
    //Pega o formato da Data no Windows dd/mm/aaaa,  mm/dd/aaaa, etc...
    Lilen1 := length(LsSql);
    //Pegar Tamanho do texto na Sintaxe CvDate('31/12/2000')...
    LiLenCvDate := length('CVDATE(');
    LiLenDate:=length(ShortDateFormat);
    LiLenTexto := length('CVDATE("")')+LiLenDate;
    for LiPos:=1 to (Lilen1+1-LiLenCvDate) do
    begin
      if AnsiUpperCase(copy(LsSql,LiPos,LiLenCvDate)) = 'CVDATE(' then //Se achou ...
      begin
        //Substituindo a palavra CvDate('31/12/1999') por #12/31/1999#
        LsDataNoFormatoDelphi:=copy(LsSql,LiPos+LiLenCvDate+1,LiLenDate);
        LsDataNoFormatoMDY:=FormatDateTime('MM/DD/YYYY',StrToDate(LsDataNoFormatoDelphi));
        LsSql:=Copy(LsSql,1,LiPos-1)+'#'+LsDataNoFormatoMDY+'#'+
               Copy(LsSql,LiPos+LiLenTexto,Length(LsSql))
      end;
    end;
 end;

Function PegaDiretorioDoWindows:String;
var
  LsWinDir:String;
  LiLength:integer;
begin
  //Pegando Diretório do Windows
  LiLength := 255;
  setLength(LsWinDir, LiLength);
  LiLength := GetWindowsDirectory(PChar(LsWinDir), LiLength);
  setLength(LsWinDir, LiLength);
  Result:=LsWinDir;
end;

Function PegaDiretorioTemporario:String;
var
  LsWinDir:String;
  LiLength:integer;
begin
  //Pegando Diretório do Windows
  LiLength := 255;
  setLength(LsWinDir, LiLength);
  GetTempPath(LiLength, PChar(LsWinDir));
  setLength(LsWinDir, LiLength);
end;
end.


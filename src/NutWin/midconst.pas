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





 

unit MidConst;

interface

resourcestring
  { DBClient }
  SNoDataProvider = 'Provedor ou pacote de dados ausente';
  SInvalidDataPacket = 'Pacote de dados inválido';
  SRefreshError = 'É necessário aplicar as alterações antes de atualizar os dados';
  SProviderInvalid = 'Provedor inválido. O Provedor foi liberado pelo servidor de aplicativos';
  SServerNameBlank = 'Não é possível conectar, %s deve conter um ServerName ou ServerGUID válido';
  SRepositoryIdBlank = 'Não é possível conectar, %s deve conter um ''id'' de repositório válido';
  SAggsGroupingLevel = 'Nível de agrupamento excede a conta do campo de índice corrente';
  SAggsNoSuchLevel = 'Nível de agrupamento não definido';
  SNoCircularReference = 'Fornecimento não permitido de referências circulares';

  { MConnect }
  SSocketReadError = 'Erro durante a leitura do conector';
  SInvalidProviderName = 'Provedor de nome não foi reconhecido pelo servidor';
  SBadVariantType = 'Tipo variante não suportado: %s';
  SInvalidAction = 'Ação recebida inválida';

  { Resolver }
  SInvalidResponse = 'Resposta inválida';
  SRecordChanged = 'Registro alterado por outro usuário';
  SRecordNotFound = 'Registro não encontrado';
  STooManyRecordsModified = 'A atualização afetou mais de 1 registro.';

  { Provider }
  SInvalidOptParamType = 'O valor não pode ser armazenado em um parâmetro opcional';
  SMissingDataSet = 'Propriedade do ''DataSet'' ausente';
  SConstraintFailed = 'Falha no limite de registro ou campo.';
  SField = 'Field';
  SReadOnlyProvider = 'Não é possível aplicar as atualizações em um provedor ''ReadOnly''';
  SNoKeySpecified = 'Inpossibilitado de encontrar o registro.  Nenhuma chave especificada';
  SFieldNameTooLong = 'O nome do campo não pode ser maior do que %d caracteres.  Tente ' +
                      'configurar o  ''ObjectView'' para Verdadeiro no dataset';
  SNoDataSets = 'Não é possível determinar-se o dataset quando se está usando datasets aninhados ou referências';
  SRecConstFail = 'Preparação do limite de registro falhou com o erro "%s"';
  SFieldConstFail = 'Preparação do limite de campo falhou com o erro "%s"';
  SDefExprFail = 'Preparação de expressão padrão falhou com o erro "%s"';
  SArrayElementError = 'Elementos de vetor do tipo %s não são suportados'; 
  SNoTableName = 'Inpossibilitado de encontrar registros.  Nome da tabela não encontrado.';

  { ObjectBroker }
  SNoServers = 'Nenhum servidor disponível';

  { Socket Connection }
  SReturnError = 'Valor de retorno esperado não recebido';
  SNoWinSock2 = 'WinSock 2 deve ser instalado para usar o soquete de conexão';

implementation

end.

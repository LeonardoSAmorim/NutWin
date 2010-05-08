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





 

unit DbConsts;

interface

resourcestring
  SInvalidFieldSize = 'Tamanho de campo inválido';
  SInvalidFieldKind = 'Tipo de campo inválido';
  SInvalidFieldRegistration = 'Registro de campo inválido';
  SUnknownFieldType = 'Campo ''%s'' é de um tipo desconhecido';
  SFieldNameMissing = 'Nome de campo ausente';
  SDuplicateFieldName = 'Nome de campo duplicado ''%s''';
  SFieldNotFound = '%s: Campo ''%s'' não encontrado';
  SFieldAccessError = 'Não se pode acessar o campo ''%s'' como tipo %s';
  SFieldValueError = 'Valor inválido para o campo ''%s''';
  SFieldRangeError = '%g não é um valor válido para o campo ''%s''. Os limites são de %g a %g';
  SInvalidIntegerValue = '''%s'' não é um valor inteiro válido para o campo ''%s''';
  SInvalidBoolValue = '''%s'' não é um valor boleano válido para o campo ''%s''';
  SInvalidFloatValue = '''%s'' não é um valor de ponto flutuante válido para o campo ''%s''';
  SFieldTypeMismatch = 'Campo ''%s'' não é do tipo esperado';
  SFieldSizeMismatch = 'Tamanho não coincide com o campo ''%s'', esperando: %d atual: %d';
  SInvalidVarByteArray = 'Tipo ou tamanho de variante inválido';
  SFieldOutOfRange = 'Valor do campo ''%s'' está fora dos limites';
  SBCDOverflow = '(''Overflow'')';
  SFieldRequired = 'Campo ''%s'' tem que ter um valor';
  SDataSetMissing = 'Campo ''%s'' não tem nenhum ''dataset''';
  SInvalidCalcType = 'Campo ''%s'' não pode ser calculado ou ser um campo ''lookup''';
  SFieldReadOnly = 'Campo ''%s'' não pode ser modificado';
  SFieldIndexError = 'Campo índice além dos limites';
  SNoFieldIndexes = 'Nenhum índice ativo no momento';
  SNotIndexField = 'Campo ''%s'' não é indexado e não pode ser modificado';
  SIndexFieldMissing = 'Não é possível acessar campo indexado ''%s''';
  SDuplicateIndexName = 'Nome de índice duplicado ''%s''';
  SNoIndexForFields = '''%s'' não tem nenhum índice para os campos ''%s''';
  SIndexNotFound = 'Índice ''%s'' não encontrado';
  SDuplicateName = 'Nome duplicado ''%s'' em %s';
  SCircularDataLink = '''DataLinks'' circulares não são permitidos';
  SLookupInfoError = 'Informação ''lookup'' para o campo ''%s'' está incompleta';
  SDataSourceChange = '''DataSource'' não pode ser alterado';
  SNoNestedMasterSource = '''Datasets'' aninhados não podem ter um ''MasterSource''';
  SDataSetOpen = 'Não é possível executar esta operação em um ''dataset'' aberto';
  SNotEditing = '''Dataset'' não está em modo de edição ou inserção';
  SDataSetClosed = 'Não é possível executar esta operação em um ''dataset'' fechado';
  SDataSetEmpty = 'Não é possível executar esta operação em um ''dataset'' vazio';
  SDataSetReadOnly = 'Não é possível modificar um ''dataset'' somente para leitura';
  SNestedDataSetClass = '''Dataset'' aninhado precisa herdar de %s';
  SExprTermination = 'Expressão de filtro incorretamente finalizada';
  SExprNameError = 'Nome de campo não finalizado';
  SExprStringError = 'Constante ''string'' não finalizada';
  SExprInvalidChar = 'Expressão de filtro de caracter inválida: ''%s''';
  SExprNoLParen = '''('' esperado mas %s encontrado(a)';
  SExprNoRParen = ''')'' Esperado mas %s encontrado(a)';
  SExprNoRParenOrComma = ''')'' ou '','' esperado mas %s encontrado(a)';
  SExprExpected = 'Expressão esperada mas %s encontrado(a)';
  SExprBadField = 'Campo ''%s'' não pode ser usado em uma expressao de filtro';
  SExprBadNullTest = '''NULL'' somente permitido com ''='' e ''<>''';
  SExprRangeError = 'Constante além dos limites';
  SExprNotBoolean = 'Campo ''%s'' não é do tipo Boleano';
  SExprIncorrect = 'Expressão de filtro incorretamente formada';
  SExprNothing = 'nada';
  SExprTypeMis = 'Tipo não coincide na expressão';
  SExprBadScope = 'A operação não pode agregar valores misturados com um valor variante de registro';
  SExprNoArith = 'Expressões aritméticas em filtro não são suportadas';
  SExprNotAgg = 'A expressão não é uma expressão agregada';
  SExprBadConst = 'A constante não é do tipo correto %s';
  SExprNoAggFilter = 'Expressões agregadas não são permitidas em filtros';
  SExprEmptyInList = 'A lista de predicados ''IN'' não deve estar vazia';
  SInvalidKeywordUse = 'Uso inválido de palavra-chave';
  STextFalse = 'Falso';
  STextTrue = 'Verdadeiro';
  SParameterNotFound = 'Parâmetro ''%s'' não encontrado';
  SInvalidVersion = 'Impossível carregar parâmetros ''bind''';
  SParamTooBig = 'Parâmetro ''%s'', não pode salvar dados maiores de %d ''bytes''';
  SParamBadFieldType = 'Campo ''%s'' é de um tipo não suportado';
  SAggActive = 'A propriedade não pode ser modificada enquanto a agregação estiver ativa';

  { DBCtrls }
  SFirstRecord = 'Primeiro registro';
  SPriorRecord = 'Registro anterior';
  SNextRecord = 'Próximo registro';
  SLastRecord = 'Último registro';
  SInsertRecord = 'Inserir registro';
  SDeleteRecord = 'Excluir registro';
  SEditRecord = 'Editar record';
  SPostEdit = 'Gravar edição';
  SCancelEdit = 'Cancelar edição';
  SRefreshRecord = 'Atualizar dados';
  SDeleteRecordQuestion = 'Exclui registro?';
  SDeleteMultipleRecordsQuestion = 'Exclui todos os registros selecionados?';
  SRecordNotFound = 'Registro não encontrado';
  SDataSourceFixed = 'Operação não permitida em um ''DBCtrlGrid''';
  SNotReplicatable = 'O controle não pode ser usado em um ''DBCtrlGrid''';
  SPropDefByLookup = 'Propiedade já definida por um campo ''lookup''';
  STooManyColumns = '''Grid'' requerido para exibir mais de 256 colunas';

  { DBLogDlg }
  SRemoteLogin = 'Login remoto';

  { DBOleEdt }
  SDataBindings = 'Dados vinculados...';

implementation

end.

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






unit WebConst;

interface

resourcestring
  sInvalidActionRegistration = 'Ação de registro inválida';
  sOnlyOneDataModuleAllowed = 'Apenas um módulo de dados por aplicação';
  sNoDataModulesRegistered = 'Nenhum módulo de dados registrados';
  sNoDispatcherComponent = 'Nenhum componente despachante encontrado no módulo de dados';
  sOnlyOneDispatcher = 'Apenas um despachante Web por módulo de formulários/dados';
  sDuplicateActionName = 'Nome de ação duplicada';
  sTooManyActiveConnections = 'Número máximo de conexões simultâneas excedido. ' +
                              'Por favor tente novamente mais tarde';
  sHTTPItemName = 'Nome';
  sHTTPItemURI = 'Informação de caminho';
  sHTTPItemEnabled = 'Habilitado';
  sHTTPItemDefault = 'Padrão';

  sInternalServerError = '<html><title>Erro interno do servidor 500</title>'#13#10 +
                         '<h1>Erro interno do servidor 500</h1><hr>'#13#10 +
                         'Exceção: %s<br>'#13#10 +
                         'Mensagem: %s<br></html>'#13#10;
  sDocumentMoved = '<html><title>Documento Movido 302</title>'#13#10 +
                   '<body><h1>Objeto Movido</h1><hr>'#13#10 +
                   'Este Objeto pode ser encontrado <a HREF="%s">here.</a><br>'#13#10 +
                   '<br></body></html>'#13#10;

  sResNotFound = 'Recurso %s não encontrado';

  sTooManyColumns = 'Muitas colunas da tabela';
  sFieldNameColumn = 'Campo Nome';
  sFieldTypeColumn = 'Campo Tipo';

  sInvalidMask = '''%s'' é uma máscara inválida em (%d)';


implementation

end.


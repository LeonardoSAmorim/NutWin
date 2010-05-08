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





 

unit OleConst;

interface

resourcestring
  SBadPropValue = '''%s'' não é um valor de propriedade válido';
  SCannotActivate = 'Falha na ativação do controle OLE';
  SNoWindowHandle = 'Não é possível obter o ''handle'' da janela do controle OLE';
  SOleError = 'Erro OLE %.8x';
  SVarNotObject = 'A variante não referencia um objeto OLE';
  SVarNotAutoObject = 'A variante não referencia um objeto ''automation''';
  SNoMethod = 'O método ''%s'' não é suportado por objeto OLE';
  SLinkProperties = 'Propriedades da conexão';
  SInvalidLinkSource = 'Não é possivel conectar a uma origem inválida.';
  SCannotBreakLink = '''Break'' na operação de conexão não é suportado.';
  SLinkedObject = 'Conectado %s';
  SEmptyContainer = 'Operação não permitida em um ''container'' OLE';
  SInvalidVerb = 'Verbo de objeto inválido';
  SPropDlgCaption = '%s Propriedades';
  SInvalidStreamFormat = 'Formato ''stream'' inválido';
  SInvalidLicense = 'A informação de licença para %s é inválida';
  SNotLicensed = 'A informação de licença para %s não foi encontrada. Você não pode usar este controle no modo de desenho';

implementation

end.


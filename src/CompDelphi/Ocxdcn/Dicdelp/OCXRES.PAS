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




unit OCXRes;

interface
resourcestring
  IDS_TABCORP = 'CCSISDIC';
  IDS_DSN_SEM_DCNRIO ='A tabela CCSISDIC não foi achada' + #13#10 +'neste DSN. Escolha outra fonte de dados. ' + #13#10 +'Utilize o aplicativo BDE Configuration.';
  IDS_DIC_SEM_TIPO = 'Lista de Tipos vazia.\nNão existem tipos de dicionarios nesta tabela de dicionarios.\nVerificar no banco de dados se foi\ndefinido o tipo para os dicionarios.';
  IDS_CMBTIPO_SEM_MEM = 'Não ha memoria suficiente para \napresentar todos os tipos de dicionário.';
  IDS_DIC_SEM_DIC = 'Não existe nenhum dicionário do tipo escolhido.';
  IDS_CMBSIGLA_SEM_MEM = 'Não ha memória suficiente para\napresentar todos os dicionários\ndotipo escolhido.';
  IDS_DEF_TIPOADM  = 'ADM';
  IDS_DEF_TIPOPROC = 'PROC';
  IDS_DEF_TIPODROG = 'DROG';
  IDS_DEF_TIPODIAG = 'DIAG';

implementation

end.
 
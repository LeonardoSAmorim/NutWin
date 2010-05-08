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




unit IBConst;

interface

resourcestring
  srSamples = 'Exemplos';
  SNoEventsRegistered  = 'Você precisa registrar os eventos antes de enfileirá-los';
  SInvalidDBConnection = 'O componente não está conectado a um banco de dados aberto';
  SInvalidDatabase     = '''''%s'''' não está conectado a um banco de dados InterBase';
  SInvalidCancellation = 'Você não pode chamar ''CancelEvents'' através de um ''OnEventAlert handler''';
  SInvalidEvent        = 'Evento em branco inválido adicionado a lista de eventos ''EventAlerter''';
  SInvalidQueueing     = 'Você não pode chamar ''QueueEvents'' através de um ''OnEventAlert handler''';
  SInvalidRegistration = 'Você não pode registrar ou tirar o registro de eventos através de um ''OnEventAlert handler''';

implementation

end.
  

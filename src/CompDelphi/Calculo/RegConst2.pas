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




unit RegConst2;

interface

uses Windows;

const
  CFGPath : PChar = '\SOFTWARE\DIS-EPM\NUTWIN-1.6';
  CFGRoot : HKEY = HKEY_LOCAL_MACHINE;

  CFGVersaoCalc : String = 'VERSAO CALCNUT';
  CFGVersaoCalcDefault : String = 'BETA X.XX (DEMO)'; // Versão da Calculadora
  CFGPersonaFileName : String = 'PERSONA FILE NAME';
  CFGLogoFileName : String = 'LOGO FILE NAME';
  CFGSerial : String = 'Serial';

  OPCDica : String = 'MOSTRA DICA';
  OPCDicaDefault : Boolean = True; // Mostrar Dica na Abertura
  OPCTela : String = 'FUNDO TELA';
  OPCTelaDefault : Integer = 0; // 0 - Tela formal, 1 - Tela Informal 3 - Nenhuma

  OPCmnOrgAcessoNegado = 'MN_ACESSONEGADO'; // String do tipo CommaText com
                                           // os Names dos items de Menu com acesso negado


implementation

end.
 
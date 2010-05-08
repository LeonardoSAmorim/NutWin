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




unit USalas;

interface

const
   clPORTA = 65535;
   clJANELA = 255;
   clPRATELEIRA = 16711935;
   clGAVETA1 = 8404992;
   clGAVETA2 = 0;
   clGAVETA3 = 8388863;
   clCALCULADORA = 32768;
   clLUPA = 8421504;
   clCANETA = 16776960;
   clPAPEIS = 65280;
   clFUNDO = 16777215;
   clPASTA = 4227327;

type
  TObjetoSala = ( osPorta, osPrateleira, osGaveta1a, osGaveta1b, osGaveta2a, osGaveta2b, osGaveta3, osGaveta3a, osGaveta3b, osCalculadora,
                   osLupa, osCanetaOpInd, osCanetaOpAlim, osCanetaOpSist, osPapeisInd, osPapeisAlim, osJanela1, osJanela2 );
  TObjetoSalaEvent = procedure (Sender: TObject; ObjetoSala: TObjetoSala) of object;


implementation

end.
 
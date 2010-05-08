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




program PRelatorio;

uses
  Forms,
  Unit1 in 'Unit1.pas' {fmRelAli},
  Nutrelat in 'Nutrelat.pas' {fmRelatorios},
  UAliSubsCal in 'UAliSubsCal.pas' {fmRelAliSubs},
  UAliOrdAlf in 'UAliOrdAlf.pas' {fmAliOrdAlf},
  UAliOrdGAli in 'UAliOrdGAli.pas' {fmAliOrdGAli},
  UAliOrigem in 'UAliOrigem.pas' {fmAliOrigem},
  DMRelat in 'DMRelat.pas' {DMRelatAli: TDataModule},
  DMRelPess in 'DMRelPess.pas' {DMRelPessoa: TDataModule},
  DMRelMed in 'DMRelMed.pas' {DMRelMedidas: TDataModule},
  DMRElNut in 'DMRElNut.pas' {DMRelNutrientes: TDataModule},
  DMRelPrAli in 'DMRelPrAli.pas' {DMRelPreco: TDataModule},
  DMRelSuCal in 'DMRelSuCal.pas' {DMRelSCAl: TDataModule},
  UAliFicha in 'UAliFicha.pas' {fmAliFicha},
  UPess in 'UPess.pas' {fmRelPess},
  URelTAli in 'URelTAli.pas' {fmRTAGAli},
  URTAGCal in 'URTAGCal.pas' {fmRTAGCal},
  URTANut in 'URTANut.pas' {fmRTANut},
  URTAMCas in 'URTAMCas.pas' {fmRTAMCas},
  URTAOrigem in 'URTAOrigem.pas' {fmRTAOrigem},
  URTASCal in 'URTASCal.pas' {fmRTASCal},
  URTANac in 'URTANac.pas' {fmRTPNac},
  URTPInst in 'URTPInst.pas' {fmRTPInst},
  URTPPessoa in 'URTPPessoa.pas' {fmRTPProf},
  URTPCor in 'URTPCor.pas' {fmRTPCor},
  URTPCid in 'URTPCid.pas' {fmRTPCid},
  URTPEst in 'URTPEst.pas' {fmRTPEst},
  URTPDDD in 'URTPDDD.pas' {fmRTPDDD},
  URTPCep in 'URTPCep.pas' {fmRTPCep},
  URTPUsuario in 'URTPUsuario.pas' {fmRTPUsuario},
  URelPesList in 'URelPesList.pas' {fmRelPesList};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmRelatorios, fmRelatorios);
  Application.Run;
end.

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




program plock2;

uses
  Forms,
  Dialogs,
  lock2 in 'lock2.pas' {fmLockDemo},
  dmlock in 'dmlock.pas' {dmLockBD: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmLockBD, dmLockBD);
  if dmlockbd.TravaBancoDados then
  begin
     dmlockbd.LiberaBancoDados; // só para poder fazer teste de travamento no form seguinte
     Application.CreateForm(TfmLockDemo, fmLockDemo);
     Application.Run;
  end
  else
  begin
     dmlockbd.Free;
     ShowMessage( 'Já existe uma aplicação usando o banco em modo exclusivo!' );
  end;
end.


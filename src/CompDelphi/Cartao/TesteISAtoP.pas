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




unit TesteISAtoP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PersistentCollection;

type
  TTesteISAtoPofA = class(TObjectPersistent)
  private
    FA: string;
    procedure SetA(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property A : string read FA write SetA;
  end;

  TTesteISAtoPofB = class(TTesteISAtoPofA)
  private
    FB: string;
    procedure SetB(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property B : string read FB write SetB;
  end;

  TTesteISAtoPofC = class(TTesteISAtoPofB)
  private
    FC: string;
    procedure SetC(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property C : string read FC write SetC;
  end;

  TTesteISAtoPofD = class(TTesteISAtoPofC)
  private
    FD: string;
    procedure SetD(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property D : string read FD write SetD;
  end;

  TTesteISAtoPofE = class(TTesteISAtoPofD)
  private
    FE: string;
    procedure SetE(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property E : string read FE write SetE;
  end;

  TTesteISAtoPofF = class(TTesteISAtoPofE)
  private
    FF: string;
    procedure SetF(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property F : string read FF write SetF;
  end;

  TTesteISAtoPofG = class(TTesteISAtoPofF)
  private
    FG: string;
    procedure SetG(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property G : string read FG write SetG;
  end;

  TTesteISAtoPofH = class(TTesteISAtoPofG)
  private
    FH: string;
    procedure SetH(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property H : string read FH write SetH;
  end;

  TTesteISAtoPofI = class(TTesteISAtoPofH)
  private
    FI: string;
    procedure SetI(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property I : string read FI write SetI;
  end;

  TTesteISAtoPofJ = class(TTesteISAtoPofI)
  private
    FJ: string;
    procedure SetJ(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property J : string read FJ write SetJ;
  end;

  TTesteISAtoPofK = class(TTesteISAtoPofJ)
  private
    FK: string;
    procedure SetK(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property K : string read FK write SetK;
  end;

  TTesteISAtoPofL = class(TTesteISAtoPofK)
  private
    FL: string;
    procedure SetL(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property L : string read FL write SetL;
  end;

  TTesteISAtoPofM = class(TTesteISAtoPofL)
  private
    FM: string;
    procedure SetM(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property M : string read FM write SetM;
  end;

  TTesteISAtoPofN = class(TTesteISAtoPofM)
  private
    FN: string;
    procedure SetN(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property N : string read FN write SetN;
  end;

  TTesteISAtoPofO = class(TTesteISAtoPofN)
  private
    FO: string;
    procedure SetO(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property O : string read FO write SetO;
  end;

  TTesteISAtoPofP = class(TTesteISAtoPofO)
  private
    FP: string;
    procedure SetP(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property P : string read FP write SetP;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofA]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofB]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofC]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofD]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofE]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofF]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofG]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofH]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofI]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofJ]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofK]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofL]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofM]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofN]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofO]);
  RegisterComponents('Teste Percistencia', [TTesteISAtoPofP]);
end;

{ TTesteISAtoP }

procedure TTesteISAtoPofA.SetA(const Value: string);
begin
  FA := Value;
end;

{ TTesteISAtoPofB }

procedure TTesteISAtoPofB.SetB(const Value: string);
begin
  FB := Value;
end;

{ TTesteISAtoPofC }

procedure TTesteISAtoPofC.SetC(const Value: string);
begin
  FC := Value;
end;

{ TTesteISAtoPofD }

procedure TTesteISAtoPofD.SetD(const Value: string);
begin
  FD := Value;
end;

{ TTesteISAtoPofE }

procedure TTesteISAtoPofE.SetE(const Value: string);
begin
  FE := Value;
end;

{ TTesteISAtoPofF }

procedure TTesteISAtoPofF.SetF(const Value: string);
begin
  FF := Value;
end;

{ TTesteISAtoPofG }

procedure TTesteISAtoPofG.SetG(const Value: string);
begin
  FG := Value;
end;

{ TTesteISAtoPofH }

procedure TTesteISAtoPofH.SetH(const Value: string);
begin
  FH := Value;
end;

{ TTesteISAtoPofI }

procedure TTesteISAtoPofI.SetI(const Value: string);
begin
  FI := Value;
end;

{ TTesteISAtoPofJ }

procedure TTesteISAtoPofJ.SetJ(const Value: string);
begin
  FJ := Value;
end;

{ TTesteISAtoPofK }

procedure TTesteISAtoPofK.SetK(const Value: string);
begin
  FK := Value;
end;

{ TTesteISAtoPofL }

procedure TTesteISAtoPofL.SetL(const Value: string);
begin
  FL := Value;
end;

{ TTesteISAtoPofM }

procedure TTesteISAtoPofM.SetM(const Value: string);
begin
  FM := Value;
end;

{ TTesteISAtoPofN }

procedure TTesteISAtoPofN.SetN(const Value: string);
begin
  FN := Value;
end;

{ TTesteISAtoPofO }

procedure TTesteISAtoPofO.SetO(const Value: string);
begin
  FO := Value;
end;

{ TTesteISAtoPofP }

procedure TTesteISAtoPofP.SetP(const Value: string);
begin
  FP := Value;
end;

end.

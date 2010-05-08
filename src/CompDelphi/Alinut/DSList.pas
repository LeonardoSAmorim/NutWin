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




unit DSList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MMSystem, DB;

type
  TDSList = class;
  TDSs = class;
  TDS = class;
  TDSNut = class;

  TDSList = class(TComponent)
  private
    { Private declarations }
    FDSs: TDSs;
    procedure SetDSs(const Value: TDSs);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property DSs: TDSs read FDSs write SetDSs;
  end;

  TDSs = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TDS;
    procedure SetItem(Index: Integer; const Value: TDS);
  protected
    procedure Update(Item: TDS); reintroduce;
  public
    constructor Create(AOwner: TComponent);

    function Add: TDS;
    function Insert(Index: Integer): TDS;

    property Items[Index: Integer]: TDS
      read GetItem
      write SetItem; default;
  end;

  TDS = class(TCollectionItem)
  private
    FDSNut: TDSNut;
    procedure SetDSNut(const Value: TDSNut);
  protected
  public
    destructor Destroy; override;
  published
    property DSNut: TDSNut read FDSNut write SetDSNut;
  end;

  TDSNut = class(TDataSource)
  private
    FDS: TDS;
  protected
  public
    destructor Destroy; override;
  published
  end;

implementation

{ TDSList }

constructor TDSList.Create(AOwner: TComponent);
begin
  inherited;
  FDSs := TDSs.Create(AOwner);
end;

destructor TDSList.Destroy;
begin
  FDSs.Free;
  inherited;
end;

procedure TDSList.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  if Operation = opRemove then
    for I:=FDSs.Count-1 downto 0 do
      if FDSs[I].DSNut = AComponent then begin
        //Break the link
        FDSs[I].DSNut := nil;
        FDSs[I].Free;
      end;
  inherited;
end;

procedure TDSList.SetDSs(const Value: TDSs);
begin
  FDSs.Assign(Value);
end;

{ TDSs }

function TDSs.Add: TDS;
begin
  Result := TDS(inherited Add);
end;

constructor TDSs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner, TDS);
end;

function TDSs.GetItem(Index: Integer): TDS;
begin
  Result := TDS(inherited GetItem(Index));
end;

function TDSs.Insert(Index: Integer): TDS;
begin
  Result := TDS(inherited Insert(Index));
end;

procedure TDSs.SetItem(Index: Integer; const Value: TDS);
begin
  inherited SetItem(Index, Value);
end;

procedure TDSs.Update(Item: TDS);
begin
  inherited Update(Item);
end;

{ TDS }

destructor TDS.Destroy;
var
  WS: TDSNut;
begin
  WS := FDSNut;
  DSNut := nil;
  if WS <> nil then begin
    //Break the link back
    WS.FDS := nil;
    WS.Free;
  end;
  
  inherited;
end;

procedure TDS.SetDSNut(const Value: TDSNut);
begin
  if FDSNut <> nil then FDSNut.FDS := nil;
  FDSNut := Value;
  if Value <> nil then Value.FDS := Self;
end;

{ TDSNut }

destructor TDSNut.Destroy;
var
  WV: TDS;
begin
  WV := FDS;
  FDS := nil;
  if WV <> nil then begin
    //Break link
    WV.DSNut := nil;
    WV.Free;
  end;
  inherited;
end;

initialization
  RegisterClass(TDSNut);

end.

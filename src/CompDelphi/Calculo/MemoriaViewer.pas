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




unit MemoriaViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Measurement, Memoria, Calculo, DicNut, OCXDCNLib_TLB, stdctrls,comctrls,db;

type

//-----------------------------------------------
//  TMemoriaViewer - Classe Abstrata
//-----------------------------------------------

  TMemoriaViewer = class(TComponent)
  private
    FViewer: TWinControl;
    FProcessador: TCalculo;
    { Private declarations }
  protected
    { Protected declarations }
        // Resets prop of component type if referenced component deleted
    procedure SetViewer(const Value: TWinControl);virtual;
    procedure SetProcessador(const Value: TCalculo);virtual;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  public
    { Public declarations }
    procedure UpdateViewer;virtual;abstract;
  published
    { Published declarations }
    property Viewer : TWinControl read FViewer write SetViewer;
    property Processador : TCalculo read FProcessador write SetProcessador;
  end;

  TAntropViewer = class(TMemoriaViewer)
  private
    FDataSet : TDataSet; // Wagner
    FDicMedidas: TDicionario;
    { Private declarations }
  protected
    { Protected declarations }
    procedure SetDicMedidas(const Value: TDicionario);virtual;
    procedure SetDataSet(const Value: TDataSet);virtual;
        // Resets prop of component type if referenced component deleted
        procedure Notification(AComponent : TComponent; Operation : TOperation); override;
  public
    { Public declarations }
        procedure UpdateViewer;override;
  published
    { Published declarations }
    property DicMedidas : TDicionario read FDicMedidas write SetDicMedidas;
    property DataSet : TDataSet read FDataSet write SetDataSet; // Wagner
  end;

function DoisDecimais ( S: string):string;
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Calculadora', [TAntropViewer]);
end;

function DoisDecimais ( S: string):string;
var
Virgula: integer;
begin
Virgula:= LastDelimiter(',.',S);
if Virgula=0 then
   Result:=S
else
    Result:=Copy(S,1, Virgula+2);
end;

{ TMemoriaViewer }

{ Resets prop of component type if referenced component deleted }
procedure TMemoriaViewer.Notification(AComponent : TComponent; Operation : TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FViewer then
        FViewer := nil;
     if AComponent = FProcessador then
        FProcessador := nil;
end; { of Notification }

procedure TMemoriaViewer.SetProcessador(const Value: TCalculo);
begin
  FProcessador := Value;
end;

procedure TMemoriaViewer.SetViewer(const Value: TWinControl);
begin
  FViewer := Value;
end;


{ TAntropViewer}

procedure TAntropViewer.Notification(AComponent : TComponent; Operation : TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FDicMedidas then
        FDicMedidas := nil;
     if AComponent = FDataSet then
        FDataSet := nil;
end; { of Notification }

procedure TAntropViewer.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

procedure TAntropViewer.SetDicMedidas(const Value: TDicionario);
begin
  FDicMedidas := Value;
end;

procedure TAntropViewer.UpdateViewer;
var
   StartPos, EndPos : Integer;
   MedidaText : string;
   Med : TMedida;
begin
   if (FDataSet <> nil) and
      (FViewer <> nil) and (FViewer is TRichEdit)  and (Processador <> nil) and (Processador.Memoria  <> nil) then
      with FViewer as TRichEdit, FDicMedidas as TAttributedDic do
      begin

      Lines.Clear;
      Paragraph.Alignment:= taLeftJustify;
      with SelAttributes do
        begin
          Style := [fsBold, fsItalic,fsUnderline];
          Size := 14;
        end;

      Lines.Add('Medidas Antropométricas');

      with SelAttributes do
        begin
          Style := [];
          Size := 10;
        end;

      Paragraph.FirstIndent := 10;

      FDataSet.Close;
      FDataSet.Filter := 'CALCULO = ' + '''' + 'ANTROP' + '''' + ' AND ' +
                         'TIPO = ' + '''' + 'MEDIDA' + '''';
      FDataSet.Open;
      while not FDataSet.Eof do
      begin
        if Processador.Memoria.Acha( FDataSet.FieldByName( 'MEDIDA' ).AsString, TObject( Med ) ) then
          begin

             StartPos:=SelStart;
             MedidaText:= Med.Descricao + ' = ' +
                          DoisDecimais(Med.ValorNumerico)  + ' ' +
                          Med.Unidade;
             Lines.Add( MedidaText );
             EndPos := SelStart;
             SelStart:=StartPos;
             SelLength:= Length (Med.Descricao);
             SelAttributes.Style := [fsBold];
             SelAttributes.Size := 10;
             SelStart:=StartPos+SelLength;
             SelLength:=Length (MedidaText) - SelLength - 2;
             SelAttributes.Style:=[];
             SelAttributes.Size := 10;
             SelStart:=EndPos;

          end;
        FDataSet.Next;
      end;

//==============================================================================

      Paragraph.FirstIndent := 0;
      SelLength:=0;

      Lines.Add('');

      with SelAttributes do
        begin
          Style := [fsBold, fsItalic,fsUnderline];
          Size := 14;
        end;

      Lines.Add('Resultados dos Calculos');

      with SelAttributes do
        begin
          Style := [];
          Size := 10;
        end;

      Paragraph.FirstIndent := 10;


      FDataSet.Close;
      FDataSet.Filter := 'CALCULO = ' + '''' + 'ANTROP' + '''' + ' AND ' +
                         'TIPO = ' + '''' + 'RESULTADO' + '''';
      FDataSet.Open;
      while not FDataSet.Eof do
      begin
        if Processador.Memoria.Acha( FDataSet.FieldByName( 'MEDIDA' ).AsString, TObject( Med ) ) then
          begin

             StartPos:=SelStart;
             MedidaText:= Med.Descricao + ' = ' +
                          DoisDecimais(Med.ValorNumerico)  + ' ' +
                          Med.Unidade;
             Lines.Add( MedidaText );
             EndPos := SelStart;
             SelStart:=StartPos;
             SelLength:= Length (Med.Descricao);
             SelAttributes.Style := [fsBold];
             SelAttributes.Size := 10;
             SelStart:=StartPos+SelLength;
             SelLength:=Length (MedidaText) - SelLength - 2;
             SelAttributes.Style:=[];
             SelAttributes.Size := 10;
             SelStart:=EndPos;

          end;
        FDataSet.Next;
      end;
      end;
end;

{procedure TAntropViewer.UpdateViewer;
var
   i, j, StartPos, EndPos : Integer;
   desc : WideString;
   Tipo, MedidaText : string;
begin
   if (FDicMedidas <> nil) and (FDicMedidas is TAttributedDic) and
      (FViewer <> nil) and (FViewer is TRichEdit)  and (Processador <> nil) then
      with FViewer as TRichEdit, FDicMedidas as TAttributedDic do
      begin

      Lines.Clear;
      Paragraph.Alignment:= taLeftJustify;
      with SelAttributes do
        begin
          Style := [fsBold, fsItalic,fsUnderline];
          Size := 14;
        end;

      Lines.Add('Medidas Antropométricas');

      with SelAttributes do
        begin
          Style := [];
          Size := 10;
        end;

      Paragraph.FirstIndent := 10;

      for i := 0 to Processador.Memoria.ListaObj.Count - 1 do
        if ( Processador.Memoria.ListaObj.Objects[i] is TMedida ) then
         if GetAttributeByCode(TMedida( Processador.Memoria.ListaObj.Objects[i] ).Name,'TIPO',Tipo) then
          if Tipo = 'MEDIDA' then
          begin

             StartPos:=SelStart;
             MedidaText:= TMedida( Processador.Memoria.ListaObj.Objects[i] ).Descricao + ' = ' +
                        TMedida( Processador.Memoria.ListaObj.Objects[i] ).ValorNumerico  + ' ' +
                        TMedida( Processador.Memoria.ListaObj.Objects[i] ).Unidade;
             Lines.Add( MedidaText );
             EndPos := SelStart;
             SelStart:=StartPos;
             SelLength:= Length (TMedida( Processador.Memoria.ListaObj.Objects[i] ).Descricao);
             SelAttributes.Style := [fsBold];
             SelAttributes.Size := 10;
             SelStart:=StartPos+SelLength;
             SelLength:=Length (MedidaText) - SelLength - 2;
             SelAttributes.Style:=[];
             SelAttributes.Size := 10;
             SelStart:=EndPos;

          end;

      Paragraph.FirstIndent := 0;
      SelLength:=0;

      Lines.Add('');

      with SelAttributes do
        begin
          Style := [fsBold, fsItalic,fsUnderline];
          Size := 14;
        end;

      Lines.Add('Resultados dos Calculos');

      with SelAttributes do
        begin
          Style := [];
          Size := 10;
        end;

      Paragraph.FirstIndent := 10;


      for i := 0 to Processador.Memoria.ListaObj.Count - 1 do
        if ( Processador.Memoria.ListaObj.Objects[i] is TMedida ) then
         if GetAttributeByCode(TMedida( Processador.Memoria.ListaObj.Objects[i] ).Name,'TIPO',Tipo) then
          if Tipo = 'RESULTADO' then
          begin

             StartPos:=SelStart;
             MedidaText:= TMedida( Processador.Memoria.ListaObj.Objects[i] ).Descricao + ' = ' +
                        DoisDecimais(TMedida( Processador.Memoria.ListaObj.Objects[i] ).ValorNumerico)  + ' ' +
                        TMedida( Processador.Memoria.ListaObj.Objects[i] ).Unidade;
             Lines.Add( MedidaText );
             EndPos := SelStart;
             SelStart:=StartPos;
             SelLength:= Length (TMedida( Processador.Memoria.ListaObj.Objects[i] ).Descricao);
             SelAttributes.Style := [fsBold];
             SelAttributes.Size := 10;
             SelStart:=StartPos+SelLength;
             SelLength:=Length (MedidaText) - SelLength - 2;
             SelAttributes.Style:=[];
             SelAttributes.Size := 10;
             SelStart:=EndPos;

          end;
      end;
end;}

end.

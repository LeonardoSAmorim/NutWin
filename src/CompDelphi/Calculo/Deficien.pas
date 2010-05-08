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




unit Deficien;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, TypInfo, Calculo, Measurement;

const
  PORC_PARAPLEGIA = 7.5;
  PORC_TETRAPLEGIA = 12.5;
  PORC_CORPO_INTEIRO = 100; //100.3;
  PORC_TRONCO_CABECA = 48.2; //49.7;
  PORC_BRACO = 4.2;//3.5;
  PORC_ANTE_BRACO = 2.3;
  PORC_MAO = 0.8;
  PORC_COXA = 11.5;//11.8;
  PORC_PERNA = 5.3;
  PORC_PE = 1.8;

type

  TPartesDoCorpo = ( paAnteBracoDireito, paAnteBracoEsquerdo,
                     paBracoDireito, paBracoEsquerdo,
                     paMaoDireita, paMaoEsquerda,
                     paCoxaDireita, paCoxaEsquerda,
                     paPernaDireita, paPernaEsquerda,
                     paPeDireito, paPeEsquerdo );
  TPartesAmputadas = set of TPartesDoCorpo;

  TfmDeficiente = class(TForm)
    paDeficiente: TPanel;
    rgTipoDeficiencia: TRadioGroup;
    bbDefOk: TBitBtn;
    bbDefCancela: TBitBtn;
    paAmputado: TPanel;
    imTronco: TImage;
    imEsqBraco: TImage;
    imDirBraco: TImage;
    imEsqCoxa: TImage;
    imDirCoxa: TImage;
    imEsqAnteBraco: TImage;
    imDirAnteBraco: TImage;
    imDirPerna: TImage;
    imEsqPerna: TImage;
    imDirMao: TImage;
    imEsqMao: TImage;
    imDirPe: TImage;
    imEsqPe: TImage;
    laExplicacao: TLabel;
    laAviso: TLabel;
    procedure imDirBracoClick(Sender: TObject);
    procedure imDirAnteBracoClick(Sender: TObject);
    procedure imDirMaoClick(Sender: TObject);
    procedure imEsqBracoClick(Sender: TObject);
    procedure imEsqAnteBracoClick(Sender: TObject);
    procedure imEsqMaoClick(Sender: TObject);
    procedure rgTipoDeficienciaClick(Sender: TObject);
    procedure imDirCoxaClick(Sender: TObject);
    procedure imEsqCoxaClick(Sender: TObject);
    procedure imDirPernaClick(Sender: TObject);
    procedure imEsqPernaClick(Sender: TObject);
    procedure imDirPeClick(Sender: TObject);
    procedure imEsqPeClick(Sender: TObject);
    procedure imTroncoClick(Sender: TObject);
    procedure bbDefOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FCalculo: TCalculo;
    procedure SetCalculo(const Value: TCalculo);
    { Private declarations }
  public
    { Public declarations }
     FatorDef : Double;
     Deficiencia : String;
     ListaPartesAmputadas : TStringList;
     PartesAmputadas : TPartesAmputadas;
  published
     property Calculo : TCalculo read FCalculo write SetCalculo;
  end;

var
  fmDeficiente: TfmDeficiente;

implementation

{$R *.DFM}

procedure TfmDeficiente.imDirBracoClick(Sender: TObject);
begin
   if imDirBraco.Visible then
      begin
         imDirAnteBraco.Visible := False;
         imDirBraco.Visible := False;
         imDirMao.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imDirAnteBraco.Visible := True;
         imDirBraco.Visible := True;
         imDirMao.Visible := True;
      end;
end;

procedure TfmDeficiente.imDirAnteBracoClick(Sender: TObject);
begin
   if imDirAnteBraco.Visible then
      begin
         imDirBraco.Visible := True;
         imDirAnteBraco.Visible := False;
         imDirMao.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imDirAnteBraco.Visible := True;
         imDirBraco.Visible := True;
         imDirMao.Visible := True;
      end;
end;

procedure TfmDeficiente.imDirMaoClick(Sender: TObject);
begin
   if imDirAnteBraco.Visible then
      begin
         imDirAnteBraco.Visible := True;
         imDirBraco.Visible := True;
         imDirMao.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imDirAnteBraco.Visible := True;
         imDirBraco.Visible := True;
         imDirMao.Visible := True;
      end;
end;

procedure TfmDeficiente.imEsqBracoClick(Sender: TObject);
begin
   if imEsqBraco.Visible then
      begin
         imEsqAnteBraco.Visible := False;
         imEsqBraco.Visible := False;
         imEsqMao.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imEsqAnteBraco.Visible := True;
         imEsqBraco.Visible := True;
         imEsqMao.Visible := True;
      end;
end;

procedure TfmDeficiente.imEsqAnteBracoClick(Sender: TObject);
begin
   if imEsqAnteBraco.Visible then
      begin
         imEsqBraco.Visible := True;
         imEsqAnteBraco.Visible := False;
         imEsqMao.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imEsqAnteBraco.Visible := True;
         imEsqBraco.Visible := True;
         imEsqMao.Visible := True;
      end;
end;

procedure TfmDeficiente.imEsqMaoClick(Sender: TObject);
begin
   if imEsqMao.Visible then
      begin
         imEsqAnteBraco.Visible := True;
         imEsqBraco.Visible := True;
         imEsqMao.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imEsqAnteBraco.Visible := True;
         imEsqBraco.Visible := True;
         imEsqMao.Visible := True;
      end;

end;

procedure TfmDeficiente.rgTipoDeficienciaClick(Sender: TObject);
begin
   imTronco.Tag := 2;
   imTroncoClick(Sender);
   paAmputado.Visible := False;
   bbDefOk.Enabled := True;
   if rgTipoDeficiencia.ItemIndex = 3 then
      begin
         paAmputado.Visible := True;
         FatorDef := 0;
         if ListaPartesAmputadas.Count = 0 then
            bbDefOk.Enabled := False
         else
            bbDefOk.Enabled := True;
      end;

end;

procedure TfmDeficiente.imDirCoxaClick(Sender: TObject);
begin
   if imDirCoxa.Visible then
      begin
         imDirCoxa.Visible := False;
         imDirPerna.Visible := False;
         imDirPe.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imDirCoxa.Visible := True;
         imDirPerna.Visible := True;
         imDirPe.Visible := True;
      end;
end;

procedure TfmDeficiente.imEsqCoxaClick(Sender: TObject);
begin
   if imEsqCoxa.Visible then
      begin
         imEsqCoxa.Visible := False;
         imEsqPerna.Visible := False;
         imEsqPe.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imEsqCoxa.Visible := True;
         imEsqPerna.Visible := True;
         imEsqPe.Visible := True;
      end;
end;

procedure TfmDeficiente.imDirPernaClick(Sender: TObject);
begin
   if imDirPerna.Visible then
      begin
         imDirCoxa.Visible := True;
         imDirPerna.Visible := False;
         imDirPe.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imDirCoxa.Visible := True;
         imDirPerna.Visible := True;
         imDirPe.Visible := True;
      end;
end;

procedure TfmDeficiente.imEsqPernaClick(Sender: TObject);
begin
   if imEsqPerna.Visible then
      begin
         imEsqCoxa.Visible := True;
         imEsqPerna.Visible := False;
         imEsqPe.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imEsqCoxa.Visible := True;
         imEsqPerna.Visible := True;
         imEsqPe.Visible := True;
      end;
end;

procedure TfmDeficiente.imDirPeClick(Sender: TObject);
begin
   if imDirPe.Visible then
      begin
         imDirCoxa.Visible := True;
         imDirPerna.Visible := True;
         imDirPe.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imDirCoxa.Visible := True;
         imDirPerna.Visible := True;
         imDirPe.Visible := True;
      end;
end;

procedure TfmDeficiente.imEsqPeClick(Sender: TObject);
begin
   if imEsqPe.Visible then
      begin
         imEsqCoxa.Visible := True;
         imEsqPerna.Visible := True;
         imEsqPe.Visible := False;
         bbDefOk.Enabled := True;
      end
   else
      begin
         imEsqCoxa.Visible := True;
         imEsqPerna.Visible := True;
         imEsqPe.Visible := True;
      end;
end;

procedure TfmDeficiente.imTroncoClick(Sender: TObject);
begin
   if imTronco.Tag = 0 then
      begin
         imDirAnteBraco.Visible := False;
         imDirBraco.Visible := False;
         imDirMao.Visible := False;
         imEsqAnteBraco.Visible := False;
         imEsqBraco.Visible := False;
         imEsqMao.Visible := False;
         imDirCoxa.Visible := False;
         imDirPerna.Visible := False;
         imDirPe.Visible := False;
         imEsqCoxa.Visible := False;
         imEsqPerna.Visible := False;
         imEsqPe.Visible := False;
         bbDefOk.Enabled := True;
         imTronco.Tag := 1;
      end
   else
      begin
        imDirAnteBraco.Visible := True;
        imDirBraco.Visible := True;
        imDirMao.Visible := True;
        imEsqAnteBraco.Visible := True;
        imEsqBraco.Visible := True;
        imEsqMao.Visible := True;
        imDirCoxa.Visible := True;
        imDirPerna.Visible := True;
        imDirPe.Visible := True;
        imEsqCoxa.Visible := True;
        imEsqPerna.Visible := True;
        imEsqPe.Visible := True;
        // caso especial
        if imTronco.Tag = 2 then
           bbDefOk.Enabled := False;
        imTronco.Tag := 0;
      end;
end;

//==============================================================================

procedure TfmDeficiente.bbDefOkClick(Sender: TObject);
var
  PartesDoCorpo : TPartesDoCorpo;

  mdDefTemTriceps,
  mdDefTemBiceps,
  mdDefTemCircBraco,
  mdDefTemCircPunho,
  mdDefTemCompPerna : TMedida;

begin

   // Inicializa variaveis
   Deficiencia := '';
   PartesAmputadas := [];
   ListaPartesAmputadas.Clear;

   // Calcula o fator
   if rgTipoDeficiencia.ItemIndex = 0 then
      begin
          FatorDef := PORC_CORPO_INTEIRO;
          Deficiencia := 'Nenhuma';
      end
   else if rgTipoDeficiencia.ItemIndex = 1 then
      begin
         FatorDef := PORC_CORPO_INTEIRO - PORC_PARAPLEGIA;
         Deficiencia := 'Paraplegia';
      end
   else if rgTipoDeficiencia.ItemIndex = 2 then
      begin
         FatorDef := PORC_CORPO_INTEIRO - PORC_TETRAPLEGIA;
         Deficiencia := 'Tetraplegia';
      end
   else if rgTipoDeficiencia.ItemIndex = 3 then
      begin
         Deficiencia := 'Amputação';
         FatorDef := PORC_TRONCO_CABECA;
         if imDirAnteBraco.Visible then
            FatorDef := FatorDef + PORC_ANTE_BRACO
         else
            PartesAmputadas := PartesAmputadas + [paAnteBracoDireito];
         if imDirBraco.Visible then
            FatorDef := FatorDef + PORC_BRACO
         else
            PartesAmputadas := PartesAmputadas + [paBracoDireito];
         if imDirMao.Visible then
            FatorDef := FatorDef + PORC_MAO
         else
            PartesAmputadas := PartesAmputadas + [paMaoDireita];
         if imEsqAnteBraco.Visible then
            FatorDef := FatorDef + PORC_ANTE_BRACO
         else
            PartesAmputadas := PartesAmputadas + [paAnteBracoEsquerdo];
         if imEsqBraco.Visible then
            FatorDef := FatorDef + PORC_BRACO
         else
            PartesAmputadas := PartesAmputadas + [paBracoEsquerdo];
         if imEsqMao.Visible then
            FatorDef := FatorDef + PORC_MAO
         else
            PartesAmputadas := PartesAmputadas + [paMaoEsquerda];
         if imDirCoxa.Visible then
            FatorDef := FatorDef + PORC_COXA
         else
            PartesAmputadas := PartesAmputadas + [paCoxaDireita];
         if imDirPerna.Visible then
            FatorDef := FatorDef + PORC_PERNA
         else
            PartesAmputadas := PartesAmputadas + [paPernaDireita];
         if imDirPe.Visible then
            FatorDef := FatorDef + PORC_PE
         else
            PartesAmputadas := PartesAmputadas + [paPeDireito];
         if imEsqCoxa.Visible then
            FatorDef := FatorDef + PORC_COXA
         else
            PartesAmputadas := PartesAmputadas + [paCoxaEsquerda];
         if imEsqPerna.Visible then
            FatorDef := FatorDef + PORC_PERNA
         else
            PartesAmputadas := PartesAmputadas + [paPernaEsquerda];
         if imEsqPe.Visible then
            FatorDef := FatorDef + PORC_PE
         else
            PartesAmputadas := PartesAmputadas + [paPeEsquerdo];
      end;

   // Aqui teremos o fator em porcentagem do peso do corpo
   // onde PORC_CORPO_INTEIRO eh 100%, portanto converter para fator 1
   FatorDef := FatorDef / PORC_CORPO_INTEIRO ;

   // Converte set of Enum para Lista de partes de string
   for PartesDoCorpo := Low(TPartesDoCorpo) to High(TPartesDoCorpo) do
   begin
      if ( PartesDoCorpo in PartesAmputadas ) then
         ListaPartesAmputadas.Add( GetEnumName( TypeInfo( TPartesDoCorpo ), Ord(PartesDoCorpo)));
   end;

   //Seta variaveis DefTem...
   with FCalculo.Memoria do
   begin
      if not Acha( 'mdDefTemTriceps', TObject( mdDefTemTriceps ) ) then
         exit;
      if not Acha( 'mdDefTemBiceps', TObject( mdDefTemBiceps ) ) then
         exit;
      if not Acha( 'mdDefTemCircBraco', TObject( mdDefTemCircBraco ) ) then
         exit;
      if not Acha( 'mdDefTemCircPunho', TObject( mdDefTemCircPunho ) ) then
         exit;
      if not Acha( 'mdDefTemCompPerna', TObject( mdDefTemCompPerna ) ) then
         exit;
   end;

   // Se os braços estão amputados
   if ( paBracoEsquerdo in PartesAmputadas ) and
      ( paBracoDireito in PartesAmputadas ) then
      begin
         mdDefTemTriceps.AsFloat := 0;
         mdDefTemBiceps.AsFloat := 0;
         mdDefTemCircBraco.AsFloat := 0;
      end
   else
      begin
         mdDefTemTriceps.AsFloat := -1;
         mdDefTemBiceps.AsFloat := -1;
         mdDefTemCircBraco.AsFloat := -1;
      end;

   // Se os antebraços estão amputados
   if ( paAnteBracoEsquerdo in PartesAmputadas ) and
      ( paAnteBracoDireito in PartesAmputadas ) then
       mdDefTemCircPunho.AsFloat := 0
   else
       mdDefTemCircPunho.AsFloat := -1;


   // Se as pernas estão amputadas       
   if ( paPernaEsquerda in PartesAmputadas ) and
      ( paPernaDireita in PartesAmputadas ) then
      begin
         mdDefTemCompPerna.AsFloat := 0;
      end
   else
      begin
         mdDefTemCompPerna.AsFloat := -1;
      end;

end;

procedure TfmDeficiente.FormCreate(Sender: TObject);
const
   COMPL_HINT = ' do peso total';
begin
   Deficiencia := '';
   PartesAmputadas := [];
   ListaPartesAmputadas := TStringList.Create;
   imDirAnteBraco.Hint := FormatFloat( '##0.00%', PORC_ANTE_BRACO ) + COMPL_HINT;
   imDirBraco.Hint := FormatFloat( '##0.00%', PORC_BRACO ) + COMPL_HINT;
   imDirMao.Hint := FormatFloat( '##0.00%', PORC_MAO ) + COMPL_HINT;
   imEsqAnteBraco.Hint := FormatFloat( '##0.00%', PORC_ANTE_BRACO ) + COMPL_HINT;
   imEsqBraco.Hint := FormatFloat( '##0.00%', PORC_BRACO ) + COMPL_HINT;
   imEsqMao.Hint := FormatFloat( '##0.00%', PORC_MAO ) + COMPL_HINT;
   imDirCoxa.Hint := FormatFloat( '##0.00%', PORC_COXA ) + COMPL_HINT;
   imDirPerna.Hint := FormatFloat( '##0.00%', PORC_PERNA ) + COMPL_HINT;
   imDirPe.Hint := FormatFloat( '##0.00%', PORC_PE ) + COMPL_HINT;
   imEsqCoxa.Hint := FormatFloat( '##0.00%', PORC_COXA ) + COMPL_HINT;
   imEsqPerna.Hint := FormatFloat( '##0.00%', PORC_PERNA ) + COMPL_HINT;
   imEsqPe.Hint := FormatFloat( '##0.00%', PORC_PE ) + COMPL_HINT;
end;

procedure TfmDeficiente.FormShow(Sender: TObject);
var
   I : Integer;
begin

   // Cuida da atualização da janela conforme os parametros setados
   if Deficiencia = 'Nenhuma' then
      rgTipoDeficiencia.ItemIndex := 0
   else if Deficiencia = 'Paraplegia' then
      rgTipoDeficiencia.ItemIndex := 1
   else if Deficiencia = 'Tetraplegia' then
      rgTipoDeficiencia.ItemIndex := 2
   else if Deficiencia = 'Amputação' then
      begin
         rgTipoDeficiencia.ItemIndex := 3;

         // Converte Lista de partes de string para set of Enum
         PartesAmputadas := [];
         for I := 0 to ListaPartesAmputadas.Count - 1 do
         begin
            PartesAmputadas := PartesAmputadas +
                               [TPartesDoCorpo( GetEnumValue( TypeInfo( TPartesDoCorpo ), ListaPartesAmputadas.Strings[I] ))];
         end;

         // Lado Direito Superior
         imDirAnteBraco.Visible := not ( paAnteBracoDireito in PartesAmputadas );
         imDirBraco.Visible := not ( paBracoDireito in PartesAmputadas );
         imDirMao.Visible := not ( paMaoDireita in PartesAmputadas );

         // Lado Esquerdo Superior
         imEsqAnteBraco.Visible := not ( paAnteBracoEsquerdo in PartesAmputadas );
         imEsqBraco.Visible := not ( paBracoEsquerdo in PartesAmputadas );
         imEsqMao.Visible := not ( paMaoEsquerda in PartesAmputadas );

         // Lado Direito Inferior
         imDirCoxa.Visible := not ( paCoxaDireita in PartesAmputadas );
         imDirPerna.Visible := not ( paPernaDireita in PartesAmputadas );
         imDirPe.Visible := not ( paPeDireito in PartesAmputadas );

         // Lado Esquerdo Inferior
         imEsqCoxa.Visible := not ( paCoxaEsquerda in PartesAmputadas );
         imEsqPerna.Visible := not ( paPernaEsquerda in PartesAmputadas );
         imEsqPe.Visible := not ( paPeEsquerdo in PartesAmputadas );
      end
end;

procedure TfmDeficiente.FormDestroy(Sender: TObject);
begin
   ListaPartesAmputadas.Free;
end;

procedure TfmDeficiente.SetCalculo(const Value: TCalculo);
begin
  FCalculo := Value;
end;

end.

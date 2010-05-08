library NWInstUtils;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses

  SysUtils,
  Classes;


Function Testa_NS(Serial,Sistema,Versao: PAnsiChar): Integer; stdcall;
{ Resultados da Função
  0 - OK
  1 - No. Série tamanho inválido
  2 - NS de outro sistema
  3 - NS de outra versão
  4 - NS fora da faixa válida (<0 ou > 9999)
  5 - NS Inválido
  6 - NS de Avaliação
}
var
   LiCont, LiNum, LiInc2, LiInc3, LiInc5, LiNumant : Integer;
   Li64Prod : Int64;
   LsSerialOrig, LsSerialEncr, LsSerialResu : String;
   LsSerial,LsSistema,LsVersao: string;
begin
LsSerial := Serial;
LsSistema := Sistema;
LsVersao :=Versao;

   if Length(LsSerial) <> 16 then
   begin
      Result := 1;
      Exit;
   end;
   LsSerialEncr := '';
   LiCont := 1;
   while LiCont <= Length(LsSerial)-1 do
   begin
      LsSerialEncr := LsSerialEncr+LsSerial[LiCont];
      LiCont := LiCont+2;
   end;
   LsSerialOrig := '';
   LiCont := 2;
   while LiCont <= Length(LsSerial) do
   begin
      LsSerialOrig := LsSerialOrig+LsSerial[LiCont];
      LiCont := LiCont+2;
   end;
   if Copy(LsSerialOrig,1,2) <> LsSistema then
   begin
      Result := 2;
      Exit;
   end;
   if Copy(LsSerialOrig,3,2) <> LsVersao then
   begin
      Result := 3;
      Exit;
   end;
   if (Copy(LsSerialOrig,5,4) < '0000') or (Copy(LsSerialOrig,5,4) >'9999') then
   begin
      Result := 4;
      Exit;
   end;
   if (Copy(LsSerialOrig,5,4) = '0000') then
   begin
      Result := 6;
      Exit;
   end;
   Li64Prod := 1;
   for LiCont := 1 to Length(LsSerialOrig) do
      Li64Prod := Li64Prod*Ord(LsSerialOrig[LiCont]);
   LiInc2 := 2;
   LiInc3 := 3;
   LiInc5 := 5;
   LsSerialResu := '';
   for LiCont := 1 to Length(LsSerialOrig) do
   begin
      LiNum := 256-LiCont-Ord(LsSerialOrig[LiCont]);
      LiNumant := LiNum;
      while (chr(LiNum) < '0') or ((chr(LiNum) > '9') and (chr(LiNum) < 'A')) or (chr(LiNum) > 'Z') do
      begin
         if chr(LiNum) < '0' then
            LiInc2 := LiInc2+1;
         if (chr(LiNum) > '9') and (chr(LiNum) < 'A') then
            LiInc3 := LiInc3+1;
         if chr(LiNum) > 'Z' then
            LiInc5 := LiInc5+1;
         LiNum := LiNum-(Li64Prod Mod (LiInc2*LiInc3*LiInc5));
         if LiNum < 0 then
            LiNum := LiNum*-1;
         if LiNum = LiNumant then
            LiNum := LiNum-1;
      end;
      while LiNum > 255 do
         LiNum := LiNum-256;
      LsSerialResu := LsSerialResu+Chr(LiNum);
   end;
   if LsSerialEncr <> LsSerialResu then
      Result := 5
   else
      Result := 0;
end;

exports Testa_NS;

end.

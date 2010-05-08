program MiniReg;

{ MiniReg v1.0 by Jordan Russell

  Note: For Delphi 3+, you'll need to change "OLE2" below to "ActiveX". }

uses
  Windows, OLE2;

{x$R *.RES}

procedure RegisterServer (const Filename: String);
var
  LibHandle: THandle;
  RegisterServerProc: function: HRESULT; stdcall;
begin
  LibHandle := LoadLibrary(PChar(Filename));
  if LibHandle <> 0 then
    try
      @RegisterServerProc := GetProcAddress(LibHandle, 'DllRegisterServer');
      if Assigned(@RegisterServerProc) then 
        RegisterServerProc;
    finally
      FreeLibrary (LibHandle);
    end;
end;

begin
  if ParamCount <> 1 then
    Exit;
  CoInitialize (nil);
  try
    RegisterServer (ParamStr(1));
  finally
    CoUninitialize;
  end;
end.

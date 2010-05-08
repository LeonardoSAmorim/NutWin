{
program adds a alias to the BDE configuration file

 parameters:
   0: programname + path (standard parameter of OS)
   1: Name of alias
      if begins with '-' then delete first if exist
                         else do nothing if exist
   2: path to data directory
   3: BDE driver name

Bugfix: Savierhs Lopez Arteaga 3.1.2001
        AddAlias didn't delete alias with beginning '-'
}

program AddAlias;

uses
  Windows, SysUtils, BDE;

var
  GAlias:    string  = 'New';
  GDriver:   string = szPARADOX;
  GAliasDir: string;
  FParams:   string;
  FDrvName:  string;
  FDelete:   boolean;
  i:         integer;

function StrToOem(const AnsiStr: string): string;
begin
  SetLength(Result, Length(AnsiStr));
  if Length(Result) > 0 then
    CharToOem(PChar(AnsiStr), PChar(Result));
end;


{----------------------------------------------------------------------------------------}
begin
  for i := 1 to ParamCount do
  begin
    case i of
      1: GAlias    := ParamStr(1);
      2: GAliasDir := ParamStr(2);
      3: GDriver   := ParamStr(3);
    end;
  end;

  //default alias
  if GAliasDir = '' then GAliasDir := ExtractFilePath(ParamStr(0))+'Data';

  //should delete alias first? separate alias name
  if GAlias[1] = '-' then
  begin
    FDelete := True;
    //GAlias := Copy(GAlias, 1, Length(GAlias)); Bug
    Delete(GAlias, 1, 1);                    //Fix by Savierhs Lopez Artega
  end else FDelete := False;

  FDrvName := GDriver;
  //set Parameters, the driver and server name
  if (CompareText(GDriver, szCFGDBSTANDARD) = 0) or
     (CompareText(GDriver, szPARADOX) = 0)       or
     (CompareText(GDriver, szDBASE) = 0)         or
     (CompareText(GDriver, szFOXPRO) = 0)        or
     (CompareText(GDriver, szASCII) = 0)         then
  begin
    if (CompareText(GDriver, szCFGDBSTANDARD) = 0) then FDrvName := szPARADOX;

    //set parameters for the new alias
    FParams := Format('%s:"%s"',  [szCFGDBPATH, GAliasDir]) +
               Format(';%s:"%s"', [szCFGDBDEFAULTDRIVER, GDriver]) +
               Format(';%s:"%s"', [szCFGDBENABLEBCD, szCFGFALSE]);
  end else begin
    if (CompareText(GDriver, 'INTRBASE') = 0)
    then FParams := Format('%s:"%s"',  [szSERVERNAME, GAliasDir])
    else FParams := Format('%s:"%s"',  [szDATABASENAME, GAliasDir]);

    //add other Parameters here !!!!!!!!!!!!!!!!!
  end;

  DbiInit(nil);
  try
    if FDelete then
      try
        DbiDeleteAlias(nil, PChar(GAlias));
      except
      end;

    try
      DbiAddAlias(nil, PChar(StrToOem(GAlias)),
                       PChar(StrToOem(FDrvName)),
                       PChar(FParams), True);
      DbiCfgSave(nil, nil, True);
    except
    end;

  finally
    DbiExit();
  end;

end.
//----------------------------------------------------------------------------------------





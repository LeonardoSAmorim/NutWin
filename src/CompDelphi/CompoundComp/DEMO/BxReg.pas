{*******************************************************}
{                                                       }
{       Delphi Visual Component Library                 }
{                                                       }
{       Composites registration unit                    }
{       Composite Components Pack (CCPack)              }
{                                                       }
{       Copyright (c) 1997-99 Sergey Orlik              }
{                                                       }
{     Written by:                                       }
{       Sergey Orlik                                    }
{       product manager                                 }
{       Russia, C.I.S. and Baltic States (former USSR)  }
{       Inprise Moscow office                           }
{       Internet:  sorlik@inprise.ru                    }
{       www.geocities.com/SiliconValley/Way/9006/       }
{                                                       }
{*******************************************************}

unit BxReg;

interface
uses
  Classes, DsgnIntf, BxDual, BxRichTB;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Composites',[TBxDualList]);
  RegisterComponents('Composites',[TBxRichToolBar]);
end;

end.
 
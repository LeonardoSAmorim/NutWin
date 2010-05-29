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
// If not, see <http://www.gnu.org/licenses/>.unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinSvc, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
    HEAP_GENERATE_EXCEPTIONS = $00000004;
    HEAP_NO_SERIALIZE = $00000001;
    HEAP_ZERO_MEMORY = $00000008;
var
  Form1: TForm1;

implementation

uses Services;

{$R *.DFM}

{
//
// Propósito
// Estabelece uma conexão com o Service Control Manager no computador
// especificado e abre o Banco de dados do Service Control Manager especificado
//
// Parametros:
// MachineName [in, optional]
// Nome do computador alvo. Se for especificado um string Nulo ou vazio,
// a funcao se conecta com o Service Control Manager local.
// Ex: '\\MyComputer'
//     '127.0.0.1'
//     '
//
// DatabaseName [in, optional]
// O nome do banco de dados do service control manager.
// Este parametro deve ser configurado com SERVICES_ACTIVE_DATABASE.
// se for nulo, o SERVICES_ACTIVE_DATABASE é assumido por default.
//
// dwDesiredAccess [in]
//   Direitos de acesso com o qual pretende-se abir o service control manager.
//   Antes de conceder o direito de acesso solicitado, o sistema verifica o
//   token da chamada do processo com o  discretionary access-control list
//   do descriptor associado com o service control manager.
//   O valor SC_MANAGER_CONNECT é implicitamente especificado pela chamada a
//   esta this funcao.
//
// Referências:
// MSDN>MSDN Library>Win32 and COM Development>Service Reference>Service Functions>OpenSCManager Function
//     http://msdn.microsoft.com/en-us/library/ms684323%28VS.85%29.aspx
//




function openServiceControlManager(MachineName:string;
             DatabaseName:string; DesiredAccess: LongWord):SC_HANDLE;
         var
            lastError: cardinal;
            errMsg:string;
            lpMachineName : PAnsiChar; // maquina
            lpDatabaseName: PAnsiChar; // servicos
         begin

         if( Length(lpMachineName) >0 ) then
             lpMachineName := PAnsiChar(MachineName)
         else
             lpMachineName := nil;

         if ( Length( DatabaseName ) >0 )then
            lpDatabaseName:= PAnsiChar(DatabaseName)
         else
            lpDatabaseName := nil;

         result := OpenSCManager(lpMachineName,
                       lpDatabaseName,
                       DesiredAccess );

         if ( 0 = result) then
            begin
            lastError := GetLastError();
            case lastError of
                   ERROR_ACCESS_DENIED:
                       errMsg := 'The requested access was denied.';
                   ERROR_DATABASE_DOES_NOT_EXIST:
                       errMsg := 'The specified database does not exist.';
                   ERROR_INVALID_PARAMETER:
                       errMsg := 'A specified parameter is invalid.';
                   NO_ERROR:;
                   else
                       errMsg := 'Unexpected error.';
            end; //case
            raise exception.create(
                  format('OpenSCManager failed: (%d) - %s', [lastError, errMsg]));
            end;

         end;

procedure closeServiceControlManager(schSCManager: SC_HANDLE);
    begin
    CloseServiceHandle(schSCManager);
    end;


// Parametros
//
// schSCManager [in]
//    Maninpulador para o service control manager database.
//    A funcao  openServiceControlManager retourna este manipulador.
//
// ServiceName [in]
//    Nome do serviço que será aberto.
//
// DesiredAccess [in]
//    Permissão de aceso ao serviço.
//

function OpenService(schSCManager:SC_HANDLE;
                     szSvcName: PAnsiChar;
                     DesiredAccess: Cardinal):cardinal;
    var
       lastError: cardinal;
       errMsg:string;

    begin
    result := WinSvc.OpenService( schSCManager, szSvcName, DesiredAccess);

    if ( 0 = result) then
       begin
       lastError := GetLastError();
       case lastError of
              ERROR_ACCESS_DENIED:
                  errMsg := 'The requested access was denied.';
              ERROR_INVALID_HANDLE:
                  errMsg := 'The specified handle is invalid.';
              ERROR_INVALID_NAME:
                  errMsg := 'The specified service name is invalid.';
              ERROR_SERVICE_DOES_NOT_EXIST:
                  errMsg := 'The specified service does not exist.';
              NO_ERROR:;
              else
                  errMsg := 'Unexpected error.';
       end; //case

       raise exception.create(
             format('OpenService failed: (%d) - %s', [lastError, errMsg]));
       end;

    end;

//Parameters
//
//hService [in]
//
//    A handle to the service. This handle is returned by the OpenService or the CreateService function, and it must have the SERVICE_QUERY_STATUS access right. For more information, see Service Security and Access Rights.
//lpServiceStatus [out]
//
//    A pointer to a SERVICE_STATUS structure that receives the status information.

function ServiceStatus(schService:cardinal):TServiceStatus;
    var
       lastError: cardinal;
       errMsg:string;

    begin

    if ( not QueryServiceStatus( schService, result) ) then
      begin
       lastError := GetLastError();
       case lastError of
              ERROR_ACCESS_DENIED:
                  errMsg := 'The requested access was denied.';
              ERROR_INVALID_HANDLE:
                  errMsg := 'The specified handle is invalid.';
              NO_ERROR:;
              else
                  errMsg := 'Unexpected error.';
       end; //case

       raise exception.create(
             format('QueryServiceStatus failed: (%d) - %s', [lastError, errMsg]));

      end;

    end;



//Parameters
//
//hService [in]
//
//    A handle to the service. This handle is returned by the OpenService or CreateService function, and it must have the SERVICE_START access right. For more information, see Service Security and Access Rights.
//dwNumServiceArgs [in]
//
//    The number of strings in the lpServiceArgVectors array. If lpServiceArgVectors is NULL, this parameter can be zero.
//lpServiceArgVectors [in, optional]
//
//    The null-terminated strings to be passed to the ServiceMain function for the service as arguments. If there are no arguments, this parameter can be NULL. Otherwise, the first argument (lpServiceArgVectors[0]) is the name of the service, followed by any additional arguments (lpServiceArgVectors[1] through lpServiceArgVectors[dwNumServiceArgs-1]).
//
//    Driver services do not receive these arguments.


procedure SendStartService(schService: Cardinal);
    var
       lpServiceArgVectors: PChar;
       lastError: cardinal;
       errMsg:string;

    begin
    if ( not WinSvc.StartService(
               schService,  // handle to service
               0,           // number of arguments
               lpServiceArgVectors) ) then      // no arguments
        begin
        lastError := GetLastError();
        case lastError of
              ERROR_ACCESS_DENIED:
                  errMsg := 'The requested access was denied.';
              ERROR_INVALID_HANDLE:
                  errMsg := 'The specified handle is invalid.';
              ERROR_PATH_NOT_FOUND:
                  errMsg := 'The service binary file could not be found.';
              ERROR_SERVICE_ALREADY_RUNNING:
                  errMsg := 'An instance of the service is already running.';
              ERROR_SERVICE_DATABASE_LOCKED:
                  errMsg := 'The database is locked.';
              ERROR_SERVICE_DEPENDENCY_DELETED:
                  errMsg := 'The service depends on a service that does not exist or has been marked for deletion.';
              ERROR_SERVICE_DEPENDENCY_FAIL:
                  errMsg := 'The service depends on another service that has failed to start.';
              ERROR_SERVICE_DISABLED:
                  errMsg := 'The service has been disabled.';
              ERROR_SERVICE_LOGON_FAILED:
                  errMsg := 'The service did not start due to a logon failure.';
              ERROR_SERVICE_MARKED_FOR_DELETE:
                  errMsg := 'The service has been marked for deletion.';
              ERROR_SERVICE_NO_THREAD:
                  errMsg := 'A thread could not be created for the service.';
              ERROR_SERVICE_REQUEST_TIMEOUT:
                  errMsg := 'The service has been timed out.';
              NO_ERROR:;
              else
                  errMsg := 'Unexpected error.';
        end; //case

        raise exception.create(
             format('StartService failed: (%d) - %s', [lastError, errMsg]));



        end

    end;

//
// Propósito:
//   Inicia o Serviço (window service) especificado por SvcName,
//   se possivel
//
// Parameters:
//   SvcName: Nome do serviço
//
// Return value:
//   None
//
// Veja também
// c:\> %SystemRoot%\system32\services.msc
// c:\> sc [nome_do_servidor] start nome_do_serviço [argumentos_de_serviço]
// c:\> net start [serviço]

procedure StartSvc(SvcName: string);
    var

    DesiredAccess: Cardinal; // Access
    // openSCManager
    schSCManager: SC_HANDLE;    // SCM database
    MachineName : string; // maquina
    DatabaseName: string; // servicos

    // openService
    schService :DWORD;
    szSvcName: PAnsiChar; // name of service

    // querySercideStatus
    ssStatus:TServiceStatus;

    //
    dwOldCheckPoint: DWORD;
    dwStartTickCount: DWORD;
    dwWaitTime: DWORD;
    dwBytesNeeded: DWORD;
 //
    lpServiceArgVectors: PChar;
    begin

    try
        // Get a handle to the SCM database.

        MachineName := '127.0.0.1';  // Máquina local
        DatabaseName := SERVICES_ACTIVE_DATABASE; // servicos ativos
        DesiredAccess := SC_MANAGER_ALL_ACCESS; // full Access
        schSCManager := openServiceControlManager(MachineName, DatabaseName, DesiredAccess );


        // Get a handle to the service.

        DesiredAccess := SERVICE_ALL_ACCESS; // full Access
        szSvcName := pchar(SvcName);

        schService := OpenService( schSCManager, szSvcName, DesiredAccess);
        // Check the status in case the service is not stopped.

        ssStatus := ServiceStatus(schService);

        // Check if the service is already running. It would be possible
        // to stop the service here, but for simplicity this example just returns.
        if( (ssStatus.dwCurrentState <> SERVICE_STOPPED) and (ssStatus.dwCurrentState <> SERVICE_STOP_PENDING)) then
            begin
            Form1.Memo1.Lines.Add('Cannot start the service because it is already running');
            exit;
            end;

        // Save the tick count and initial checkpoint.

        dwStartTickCount := GetTickCount();
        dwOldCheckPoint := ssStatus.dwCheckPoint;

        // Wait for the service to stop before attempting to start it.


        while (ssStatus.dwCurrentState = SERVICE_STOP_PENDING) do
            begin
            // Do not wait longer than the wait hint. A good interval is
            // one-tenth of the wait hint but not less than 1 second
            // and not more than 10 seconds.

            dwWaitTime := ssStatus.dwWaitHint div 10;

            if( dwWaitTime < 1000 ) then
                dwWaitTime := 1000
            else if ( dwWaitTime > 10000 ) then
                 dwWaitTime := 10000;

            Sleep( dwWaitTime );

            // Check the status until the service is no longer stop pending.

            ssStatus := ServiceStatus(schService);

            if ( ssStatus.dwCheckPoint > dwOldCheckPoint ) then
                begin
                // Continue to wait and check.

                dwStartTickCount := GetTickCount();
                dwOldCheckPoint := ssStatus.dwCheckPoint;
                end
            else
                begin
                if(GetTickCount()-dwStartTickCount > ssStatus.dwWaitHint) then
                    begin
                    Form1.Memo1.Lines.Add('Timeout waiting for service to stop');
                    exit;
                    end;
                end;
            end;


        // Attempt to start the service.
        lpServiceArgVectors:= nil;

        SendStartService(schService);
        Form1.Memo1.Lines.Add('Service start pending...');

        // Check the status until the service is no longer start pending.


        ssStatus := ServiceStatus(schService);

        // Save the tick count and initial checkpoint.

        dwStartTickCount := GetTickCount();
        dwOldCheckPoint := ssStatus.dwCheckPoint;

        while (ssStatus.dwCurrentState = SERVICE_START_PENDING)do
            begin
            // Do not wait longer than the wait hint. A good interval is
            // one-tenth the wait hint, but no less than 1 second and no
            // more than 10 seconds.

            dwWaitTime := ssStatus.dwWaitHint div 10;

            if( dwWaitTime < 1000 ) then
                dwWaitTime := 1000
            else if ( dwWaitTime > 10000 ) then
                dwWaitTime := 10000;

            Sleep( dwWaitTime );

            // Check the status again.
            try
               ssStatus := ServiceStatus(schService);
            except
                Form1.Memo1.Lines.Add('QueryServiceStatusEx failed: '+ intToStr(GetLastError()));
                break;
            end;

            if ( ssStatus.dwCheckPoint > dwOldCheckPoint ) then
               begin
               // Continue to wait and check.

               dwStartTickCount := GetTickCount();
               dwOldCheckPoint := ssStatus.dwCheckPoint;
               end
            else
                begin
                if(GetTickCount()-dwStartTickCount > ssStatus.dwWaitHint) then
                    begin
                    // No progress made within the wait hint.
                    break;
                    end;
                end;
            end;

        // Determine whether the service is running.

        if (ssStatus.dwCurrentState = SERVICE_RUNNING) then
            begin
            Form1.Memo1.Lines.Add('Service started successfully.');
            end
        else
            begin
            Form1.Memo1.Lines.Add('Service not started.'#13#10+
            '  Current State: '+intToStr( ssStatus.dwCurrentState)+#13#10+
            '  Exit Code: '+intToStr( ssStatus.dwWin32ExitCode)+#13#10+
            '  Check Point: '+intToStr( ssStatus.dwCheckPoint)+#13#10+
            '  Wait Hint: '+intToStr( ssStatus.dwWaitHint)+#13#10);
            end;
    finally
        CloseServiceHandle(schService);
        CloseServiceHandle(schSCManager);
    end;
end;


function StopDependentServices(schSCManager: SC_HANDLE; schService :DWORD):boolean;
    var
        i: DWORD;
        dwBytesNeeded: DWORD;
        dwCount: DWORD;
        dwWaitTime: DWORD;
        lpDependencies: PEnumServiceStatus;
        ess: TEnumServiceStatus;
        hDepService: SC_HANDLE;
        ssp: TServiceStatus;

        dwStartTime: DWORD;
        dwTimeout: DWORD; // 30-second time-out
        ssStatus:TServiceStatus;

    begin
    lpDependencies:= nil;
    dwStartTime:= GetTickCount();
    dwTimeout:= 30000; // 30-second time-out


    // Pass a zero-length buffer to get the required buffer size.
    EnumDependentServices( schService,
                           SERVICE_ACTIVE,
                           lpDependencies^,
                           0,
                           dwBytesNeeded,
                           dwCount );
    if ( EnumDependentServices( schService,
                                SERVICE_ACTIVE,
                                lpDependencies^,
                                0,
                                dwBytesNeeded,
                                dwCount ) ) then
        begin
        // If the Enum call succeeds, then there are no dependent
        // services, so do nothing.
        result := TRUE;
        exit;
        end
    else // if ( EnumDependentServices ...
        begin
        if ( GetLastError() <> ERROR_MORE_DATA ) then
            begin
            result := FALSE; // Unexpected error
            exit
            end;

        // Allocate a buffer for the dependencies.
        lpDependencies := HeapAlloc( GetProcessHeap(), HEAP_ZERO_MEMORY,
                                     dwBytesNeeded );

        if ( lpDependencies = nil) then
            begin
            result := FALSE;
            exit;
            end;

        try
            // Enumerate the dependencies.
            if ( not EnumDependentServices( schService,
                                            SERVICE_ACTIVE,
                                            lpDependencies^,
                                            dwBytesNeeded,
                                            dwBytesNeeded,
                                            dwCount ) ) then
                begin
                result := FALSE;
                exit
                end;

            for  i := 0 to dwCount-1 do
                begin
                ess := PEnumServiceStatus(pchar(lpDependencies) + i*sizeof(PEnumServiceStatus))^;
                // Open the service.
                hDepService := OpenService( schSCManager,
                                            ess.lpServiceName,
                                            SERVICE_STOP or SERVICE_QUERY_STATUS );

                if ( hDepService = 0) then
                    begin
                    result := FALSE;
                    exit;
                    end;

                try
                    // Send a stop code.
                    if ( not ControlService( hDepService,
                                             SERVICE_CONTROL_STOP,
                                             ssp ) ) then
                        begin
                        result := FALSE;
                        exit;
                        end;

                    // Wait for the service to stop.
                    while ( ssp.dwCurrentState <> SERVICE_STOPPED ) do
                        begin
                        dwWaitTime := ssStatus.dwWaitHint div 10;
                        if( dwWaitTime < 1000 ) then
                            dwWaitTime := 1000
                        else if ( dwWaitTime > 10000 ) then
                            dwWaitTime := 10000;
                        Sleep( dwWaitTime );

                        if ( not WinSvc.QueryServiceStatus( schService, ssStatus) ) then
                            begin
                            result :=FALSE;
                            exit
                            end;

                        if ( ssp.dwCurrentState = SERVICE_STOPPED ) then
                            break;

                        if ( GetTickCount() - dwStartTime > dwTimeout )  then
                            begin
                            result := FALSE;
                            exit;
                            end;
                        end; // while ( ssp.dwCurrentState ...
                finally
                   // Always release the service handle.
                    WinSvc.CloseServiceHandle( hDepService );
                end; // try ... finally ...
                end; // for
        finally
            // Always free the enumeration buffer.
            HeapFree( GetProcessHeap(), 0, lpDependencies );
        end; // try ... finally

        result := TRUE;
        end; //// if ( EnumDependentServices ... else ..
    end; // function StopDependentServices

//Parameters
//
//hService [in]
//
//    A handle to the service. This handle is returned by the OpenService or CreateService function. The access rights required for this handle depend on the dwControl code requested.
//dwControl [in]
//
//    This parameter can be one of the following control codes.

function SendStopService(schService: Cardinal):TServiceStatus;
    var

       lastError: cardinal;
       errMsg:string;

    begin
    if ( not WinSvc.ControlService( schService, SERVICE_CONTROL_STOP,result) ) then
            begin
         lastError := GetLastError();
        case lastError of
              ERROR_ACCESS_DENIED:
                  errMsg := 'The requested access was denied.';
              ERROR_DEPENDENT_SERVICES_RUNNING:
                  errMsg := 'The service cannot be stopped because other running services are dependent on it.';
              ERROR_INVALID_HANDLE:
                  errMsg := 'The specified handle is invalid.';
              ERROR_INVALID_PARAMETER:
                  errMsg := 'The requested control code is undefined.';
              ERROR_INVALID_SERVICE_CONTROL:
                  errMsg := 'The requested control code is not valid, or it is unacceptable to the service.';
              ERROR_SERVICE_CANNOT_ACCEPT_CTRL:
                  errMsg := 'TThe requested control code cannot be sent to the service.';
              ERROR_SERVICE_NOT_ACTIVE:
                  errMsg := 'The service has not been started.';
              ERROR_SERVICE_REQUEST_TIMEOUT:
                  errMsg := 'The service has been timed out.';
              ERROR_SHUTDOWN_IN_PROGRESS:
                  errMsg := 'The system is shutting down.';

              NO_ERROR:;
              else
                  errMsg := 'Unexpected error.';
        end; //case

        raise exception.create(
             format('StartService failed: (%d) - %s', [lastError, errMsg]));



        end

    end;


procedure StopSvc(SvcName: string);
    var
        MachineName : string; // maquina
        DatabaseName: string; // servicos
        DesiredAccess: LongWord; // Access
        schSCManager: SC_HANDLE;    // SCM database
        schService :DWORD;
        szSvcName: PAnsiChar; // name of service

        ssp: TServiceStatus;
        dwStartTime: DWORD;
        dwBytesNeeded: DWORD ;
        dwTimeout: DWORD; // time-out
        dwWaitTime: DWORD ;

    begin
    dwStartTime := GetTickCount();
    dwTimeout := 30000; // 30-second time-out

    // Get a handle to the SCM database.
    MachineName := '127.0.0.1';  // Máquina local
    DatabaseName := SERVICES_ACTIVE_DATABASE; // servicos ativos
    try
        DesiredAccess := SC_MANAGER_ALL_ACCESS; // full Access

        schSCManager := openServiceControlManager(MachineName, DatabaseName, DesiredAccess );


        // Get a handle to the service.

        DesiredAccess := SERVICE_STOP or
                         SERVICE_QUERY_STATUS or
                         SERVICE_ENUMERATE_DEPENDENTS;
        szSvcName := pchar(SvcName);
        schService := OpenService( schSCManager, szSvcName, DesiredAccess);

        // Make sure the service is not already stopped.
        ssp := ServiceStatus(schService);

        if( ssp.dwCurrentState = SERVICE_STOPPED) then
            begin
            Form1.Memo1.Lines.Add('Service is already stopped');
            exit;
            end;


        // If a stop is pending, wait for it.

        while ( ssp.dwCurrentState = SERVICE_STOP_PENDING ) do
            begin

            Form1.Memo1.Lines.Add('Service stop pending...');

            // Do not wait longer than the wait hint. A good interval is
            // one-tenth of the wait hint but not less than 1 second
            // and not more than 10 seconds.

            dwWaitTime := ssp.dwWaitHint div 10;

            if( dwWaitTime < 1000 )then
                dwWaitTime := 1000
            else if ( dwWaitTime > 10000 ) then
                dwWaitTime := 10000;

            Sleep( dwWaitTime );

            ssp := ServiceStatus(schService);

            if ( ssp.dwCurrentState = SERVICE_STOPPED )then
                begin
                Form1.Memo1.Lines.Add('Service stopped successfully.');
                exit;
                end;

            if ( GetTickCount() - dwStartTime > dwTimeout )then
                begin
                Form1.Memo1.Lines.Add('Service stop timed out.\n');
                exit;
                end;

            end; //while

        // If the service is running, dependencies must be stopped first.

        StopDependentServices( schSCManager, schService );

        // Send a stop code to the service.
        ssp := SendStopService(schService);

        // Wait for the service to stop.

        while ( ssp.dwCurrentState <> SERVICE_STOPPED )do
            begin
            dwWaitTime := ssp.dwWaitHint div 10;
            if( dwWaitTime < 1000 ) then
                dwWaitTime := 1000
            else if ( dwWaitTime > 10000 ) then
                 dwWaitTime := 10000;
            Sleep( dwWaitTime );

            ssp := ServiceStatus( schService );

            if ( ssp.dwCurrentState = SERVICE_STOPPED ) then
                break;

            if ( GetTickCount() - dwStartTime > dwTimeout ) then
                begin
                Form1.Memo1.Lines.Add('Wait timed out\n' );
                exit;
                end;

            end; // while ...
        Form1.Memo1.Lines.Add('Service stopped successfully.');
        finally
        WinSvc.CloseServiceHandle(schService);
        WinSvc.CloseServiceHandle(schSCManager);
        end;

    end; // procedure

}
{
//
// Propósito:
//   Inicia o Serviço (window service) especificado por SvcName,
//   se possivel
//
// Parameters:
//   SvcName: Nome do serviço
//
// Return value:
//   None
//
// Veja também
// c:\> %SystemRoot%\system32\services.msc
// c:\> sc [nome_do_servidor] start nome_do_serviço [argumentos_de_serviço]
// c:\> net start [serviço]

procedure StartSvc2(SvcName: string);
var

dwDesiredAccess: DWORD; // Access
// openSCManager
schSCManager: SC_HANDLE;    // SCM database
lpMachineName : PAnsiChar; // maquina
lpDatabaseName: PAnsiChar; // servicos

// openService
schService :DWORD;
szSvcName: PAnsiChar; // name of service

// querySercideStatus
ssStatus:TServiceStatus;

//
 dwOldCheckPoint: DWORD;
 dwStartTickCount: DWORD;
 dwWaitTime: DWORD;
 dwBytesNeeded: DWORD;


 //
lpServiceArgVectors: PChar;
begin


// Get a handle to the SCM database.

lpMachineName := nil;  // Máquina local
lpDatabaseName := nil; // servicos ativos
dwDesiredAccess := SC_MANAGER_ALL_ACCESS; // full Access
schSCManager := WinSvc.OpenSCManager(lpMachineName, lpDatabaseName, dwDesiredAccess );

if ( 0 = schSCManager) then
   begin
   Form1.Memo1.Lines.Add('OpenSCManager failed: ' + intToStr(GetLastError()));
   exit;
   end;


// Get a handle to the service.

dwDesiredAccess := SERVICE_ALL_ACCESS; // full Access
szSvcName := pchar(SvcName);
schService := WinSvc.OpenService( schSCManager, szSvcName, SERVICE_ALL_ACCESS);

if ( 0 = schService ) then
   begin
   Form1.Memo1.Lines.Add('OpenService failed: ' + intToStr(GetLastError()));
   WinSvc.CloseServiceHandle(schSCManager);
   exit
   end;


    // Check the status in case the service is not stopped.

   if ( not WinSvc.QueryServiceStatus( schService, ssStatus) ) then
      begin
      Form1.Memo1.Lines.Add('QueryServiceStatusEx failed: ' + intToStr(GetLastError()));
      CloseServiceHandle(schService);
      CloseServiceHandle(schSCManager);
      exit;
      end;

    // Check if the service is already running. It would be possible
    // to stop the service here, but for simplicity this example just returns.


   if( (ssStatus.dwCurrentState <> SERVICE_STOPPED) and (ssStatus.dwCurrentState <> SERVICE_STOP_PENDING)) then
       begin
        Form1.Memo1.Lines.Add('Cannot start the service because it is already running');
        WinSvc.CloseServiceHandle(schService);
        WinSvc.CloseServiceHandle(schSCManager);
        exit;
        end;

    // Save the tick count and initial checkpoint.

    dwStartTickCount := GetTickCount();
    dwOldCheckPoint := ssStatus.dwCheckPoint;

    // Wait for the service to stop before attempting to start it.


    while (ssStatus.dwCurrentState = SERVICE_STOP_PENDING) do
    begin
        // Do not wait longer than the wait hint. A good interval is
        // one-tenth of the wait hint but not less than 1 second
        // and not more than 10 seconds.

        dwWaitTime := ssStatus.dwWaitHint div 10;

        if( dwWaitTime < 1000 ) then
            dwWaitTime := 1000
        else if ( dwWaitTime > 10000 ) then
            dwWaitTime := 10000;

        Sleep( dwWaitTime );

        // Check the status until the service is no longer stop pending.

        if ( not QueryServiceStatus( schService, ssStatus) ) then
        begin
            Form1.Memo1.Lines.Add('QueryServiceStatusEx failed '+ intToStr(GetLastError()));
            WinSvc.CloseServiceHandle(schService);
            WinSvc.CloseServiceHandle(schSCManager);
            exit;
        end;

        if ( ssStatus.dwCheckPoint > dwOldCheckPoint ) then
        begin
            // Continue to wait and check.

            dwStartTickCount := GetTickCount();
            dwOldCheckPoint := ssStatus.dwCheckPoint;
        end
        else
        begin
            if(GetTickCount()-dwStartTickCount > ssStatus.dwWaitHint) then
            begin
                Form1.Memo1.Lines.Add('Timeout waiting for service to stop');
                WinSvc.CloseServiceHandle(schService);
                WinSvc.CloseServiceHandle(schSCManager);
                exit;
            end;
        end;
    end;


    // Attempt to start the service.
    lpServiceArgVectors:= nil;

     if ( not WinSvc.StartService(
            schService,  // handle to service
            0,           // number of arguments
            lpServiceArgVectors) ) then      // no arguments
    begin
        Form1.Memo1.Lines.Add('StartService failed: '+ intToStr(GetLastError()));

        WinSvc.CloseServiceHandle(schService);
        WinSvc.CloseServiceHandle(schSCManager);
        exit;
    end
    else Form1.Memo1.Lines.Add('Service start pending...');

    // Check the status until the service is no longer start pending.

    if ( not WinSvc.QueryServiceStatus( schService, ssStatus) ) then
    begin
        Form1.Memo1.Lines.Add('QueryServiceStatusEx failed: '+ intToStr(GetLastError()));
        WinSvc.CloseServiceHandle(schService);
        WinSvc.CloseServiceHandle(schSCManager);
        exit;
    end;

    // Save the tick count and initial checkpoint.

    dwStartTickCount := GetTickCount();
    dwOldCheckPoint := ssStatus.dwCheckPoint;

    while (ssStatus.dwCurrentState = SERVICE_START_PENDING)do
    begin
        // Do not wait longer than the wait hint. A good interval is
        // one-tenth the wait hint, but no less than 1 second and no
        // more than 10 seconds.

        dwWaitTime := ssStatus.dwWaitHint div 10;

        if( dwWaitTime < 1000 ) then
            dwWaitTime := 1000
        else if ( dwWaitTime > 10000 ) then
            dwWaitTime := 10000;

        Sleep( dwWaitTime );

        // Check the status again.

        if ( not QueryServiceStatus( schService, ssStatus) ) then
        begin
            Form1.Memo1.Lines.Add('QueryServiceStatusEx failed: '+ intToStr(GetLastError()));
            break;
        end;

        if ( ssStatus.dwCheckPoint > dwOldCheckPoint ) then
           begin
            // Continue to wait and check.

            dwStartTickCount := GetTickCount();
            dwOldCheckPoint := ssStatus.dwCheckPoint;
        end
        else
        begin
            if(GetTickCount()-dwStartTickCount > ssStatus.dwWaitHint) then
            begin
                // No progress made within the wait hint.
                break;
            end;
        end;
    end;

    // Determine whether the service is running.

    if (ssStatus.dwCurrentState = SERVICE_RUNNING) then
    begin
        Form1.Memo1.Lines.Add('Service started successfully.');
    end
    else
    begin
        Form1.Memo1.Lines.Add('Service not started.'#13#10+
        '  Current State: '+intToStr( ssStatus.dwCurrentState)+#13#10+
        '  Exit Code: '+intToStr( ssStatus.dwWin32ExitCode)+#13#10+
        '  Check Point: '+intToStr( ssStatus.dwCheckPoint)+#13#10+
        '  Wait Hint: '+intToStr( ssStatus.dwWaitHint)+#13#10);
    end;

    WinSvc.CloseServiceHandle(schService);
    WinSvc.CloseServiceHandle(schSCManager);




end;
}

// refs.:
// http://msdn.microsoft.com/en-us/library/ms686321%28VS.85%29.aspx
// http://msdn.microsoft.com/en-us/library/ms686335%28VS.85%29.aspx
// http://msdn.microsoft.com/en-us/library/aa366597%28VS.85%29.aspx
// http://www.2p.cz/files/2p.cz/downloads/howto/windows_nt_service_dual_interface.pdf
// http://www.sandon.it/?q=node/9
// delphi helpi Win32 Programmer's Reference

{
function StopDependentServices2(schSCManager: SC_HANDLE; schService :DWORD):boolean;
    var
        i: DWORD;
        dwBytesNeeded: DWORD;
        dwCount: DWORD;
        dwWaitTime: DWORD;
        lpDependencies: PEnumServiceStatus;
        ess: TEnumServiceStatus;
        hDepService: SC_HANDLE;
        ssp: TServiceStatus;

        dwStartTime: DWORD;
        dwTimeout: DWORD; // 30-second time-out
        ssStatus:TServiceStatus;

    begin
    lpDependencies:= nil;
    dwStartTime:= GetTickCount();
    dwTimeout:= 30000; // 30-second time-out


    // Pass a zero-length buffer to get the required buffer size.
    EnumDependentServices( schService,
                           SERVICE_ACTIVE,
                           lpDependencies^,
                           0,
                           dwBytesNeeded,
                           dwCount );
    if ( EnumDependentServices( schService,
                                SERVICE_ACTIVE,
                                lpDependencies^,
                                0,
                                dwBytesNeeded,
                                dwCount ) ) then
        begin
        // If the Enum call succeeds, then there are no dependent
        // services, so do nothing.
        result := TRUE;
        exit;
        end
    else // if ( EnumDependentServices ...
        begin
        if ( GetLastError() <> ERROR_MORE_DATA ) then
            begin
            result := FALSE; // Unexpected error
            exit
            end;

        // Allocate a buffer for the dependencies.
        lpDependencies := HeapAlloc( GetProcessHeap(), HEAP_ZERO_MEMORY,
                                     dwBytesNeeded );

        if ( lpDependencies = nil) then
            begin
            result := FALSE;
            exit;
            end;

        try
            // Enumerate the dependencies.
            if ( not EnumDependentServices( schService,
                                            SERVICE_ACTIVE,
                                            lpDependencies^,
                                            dwBytesNeeded,
                                            dwBytesNeeded,
                                            dwCount ) ) then
                begin
                result := FALSE;
                exit
                end;

            for  i := 0 to dwCount-1 do
                begin
                ess := PEnumServiceStatus(pchar(lpDependencies) + i*sizeof(PEnumServiceStatus))^;
                // Open the service.
                hDepService := OpenService( schSCManager,
                                            ess.lpServiceName,
                                            SERVICE_STOP or SERVICE_QUERY_STATUS );

                if ( hDepService = 0) then
                    begin
                    result := FALSE;
                    exit;
                    end;

                try
                    // Send a stop code.
                    if ( not ControlService( hDepService,
                                             SERVICE_CONTROL_STOP,
                                             ssp ) ) then
                        begin
                        result := FALSE;
                        exit;
                        end;

                    // Wait for the service to stop.
                    while ( ssp.dwCurrentState <> SERVICE_STOPPED ) do
                        begin
                        dwWaitTime := ssStatus.dwWaitHint div 10;
                        if( dwWaitTime < 1000 ) then
                            dwWaitTime := 1000
                        else if ( dwWaitTime > 10000 ) then
                            dwWaitTime := 10000;
                        Sleep( dwWaitTime );

                        if ( not WinSvc.QueryServiceStatus( schService, ssStatus) ) then
                            begin
                            result :=FALSE;
                            exit
                            end;

                        if ( ssp.dwCurrentState = SERVICE_STOPPED ) then
                            break;

                        if ( GetTickCount() - dwStartTime > dwTimeout )  then
                            begin
                            result := FALSE;
                            exit;
                            end;
                        end; // while ( ssp.dwCurrentState ...
                finally
                   // Always release the service handle.
                    WinSvc.CloseServiceHandle( hDepService );
                end; // try ... finally ...
                end; // for
        finally
            // Always free the enumeration buffer.
            HeapFree( GetProcessHeap(), 0, lpDependencies );
        end; // try ... finally

        result := TRUE;
        end; //// if ( EnumDependentServices ... else ..
    end; // function StopDependentServices



procedure StopSvc2(SvcName: string);
    var
        lpMachineName : PAnsiChar; // maquina
        lpDatabaseName: PAnsiChar; // servicos
        dwDesiredAccess: DWORD; // Access
        schSCManager: SC_HANDLE;    // SCM database
        schService :DWORD;
        szSvcName: PAnsiChar; // name of service

        ssp: TServiceStatus;
        dwStartTime: DWORD;
        dwBytesNeeded: DWORD ;
        dwTimeout: DWORD; // time-out
        dwWaitTime: DWORD ;

    begin
    dwStartTime := GetTickCount();
    dwTimeout := 30000; // 30-second time-out

    // Get a handle to the SCM database.
    lpMachineName := nil;  // Máquina local
    lpDatabaseName := nil; // servicos ativos
    dwDesiredAccess := SC_MANAGER_ALL_ACCESS; // full Access
    schSCManager := WinSvc.OpenSCManager(lpMachineName, lpDatabaseName, dwDesiredAccess );

    if ( 0 = schSCManager) then
        begin
        Form1.Memo1.Lines.Add('OpenSCManager failed: ' + intToStr(GetLastError()));
        exit;
        end;


    // Get a handle to the service.
    // Get a handle to the service.

    dwDesiredAccess := SERVICE_ALL_ACCESS; // full Access
    szSvcName := pchar(SvcName);
    schService := WinSvc.OpenService( schSCManager, szSvcName, SERVICE_STOP or
                               SERVICE_QUERY_STATUS or
                               SERVICE_ENUMERATE_DEPENDENTS);


    if ( 0 = schService ) then
        begin
        Form1.Memo1.Lines.Add('OpenService failed: ' + intToStr(GetLastError()));
        WinSvc.CloseServiceHandle(schSCManager);
        exit
        end;


    // Make sure the service is not already stopped.
    if ( not WinSvc.QueryServiceStatus( schService, ssp) ) then
        begin
        Form1.Memo1.Lines.Add('QueryServiceStatusEx failed: ' + intToStr(GetLastError()));
        CloseServiceHandle(schService);
        CloseServiceHandle(schSCManager);
        exit;
        end;

    if( ssp.dwCurrentState = SERVICE_STOPPED) then
        begin
        Form1.Memo1.Lines.Add('Service is already stopped');
        WinSvc.CloseServiceHandle(schService);
        WinSvc.CloseServiceHandle(schSCManager);
        exit;
        end;


    // If a stop is pending, wait for it.

    while ( ssp.dwCurrentState = SERVICE_STOP_PENDING ) do
        begin

        Form1.Memo1.Lines.Add('Service stop pending...');

        // Do not wait longer than the wait hint. A good interval is
        // one-tenth of the wait hint but not less than 1 second
        // and not more than 10 seconds.

        dwWaitTime := ssp.dwWaitHint div 10;

        if( dwWaitTime < 1000 )then
            dwWaitTime := 1000
        else if ( dwWaitTime > 10000 ) then
            dwWaitTime := 10000;

        Sleep( dwWaitTime );

        if ( not WinSvc.QueryServiceStatus( schService, ssp) ) then
           begin
           Form1.Memo1.Lines.Add('QueryServiceStatusEx failed: ' + intToStr(GetLastError()));
           WinSvc.CloseServiceHandle(schService);
           WinSvc.CloseServiceHandle(schSCManager);
           exit;
           end;

        if ( ssp.dwCurrentState = SERVICE_STOPPED )then
            begin
            Form1.Memo1.Lines.Add('Service stopped successfully.');
            WinSvc.CloseServiceHandle(schService);
            WinSvc.CloseServiceHandle(schSCManager);
            exit;
            end;

        if ( GetTickCount() - dwStartTime > dwTimeout )then
            begin
            Form1.Memo1.Lines.Add('Service stop timed out.\n');
            WinSvc.CloseServiceHandle(schService);
            WinSvc.CloseServiceHandle(schSCManager);
            exit;
            end;

        end; //while

        // If the service is running, dependencies must be stopped first.

        StopDependentServices( schSCManager, schService );

        // Send a stop code to the service.

        if ( not WinSvc.ControlService( schService, SERVICE_CONTROL_STOP,ssp) ) then
            begin
            Form1.Memo1.Lines.Add('ControlService failed: ' + intToStr(GetLastError()));
            WinSvc.CloseServiceHandle(schService);
            WinSvc.CloseServiceHandle(schSCManager);
            exit;
            end;

        // Wait for the service to stop.

        while ( ssp.dwCurrentState <> SERVICE_STOPPED )do
            begin
            dwWaitTime := ssp.dwWaitHint div 10;
            if( dwWaitTime < 1000 ) then
                dwWaitTime := 1000
            else if ( dwWaitTime > 10000 ) then
                 dwWaitTime := 10000;
            Sleep( dwWaitTime );

            if ( not QueryServiceStatus( schService, ssp) ) then
                begin
                Form1.Memo1.Lines.Add('QueryServiceStatusEx failed: ' + intToStr(GetLastError()));
                WinSvc.CloseServiceHandle(schService);
                WinSvc.CloseServiceHandle(schSCManager);
                exit;
                end;

            if ( ssp.dwCurrentState = SERVICE_STOPPED ) then
                break;

            if ( GetTickCount() - dwStartTime > dwTimeout ) then
                begin
                Form1.Memo1.Lines.Add('Wait timed out\n' );
                WinSvc.CloseServiceHandle(schService);
                WinSvc.CloseServiceHandle(schSCManager);
                exit;
                end;

            end; // while ...
        Form1.Memo1.Lines.Add('Service stopped successfully.');
        WinSvc.CloseServiceHandle(schService);
        WinSvc.CloseServiceHandle(schSCManager);

    end; // procedure
}


procedure TForm1.Button2Click(Sender: TObject);
begin

StopSvc(Edit2.text, Edit1.text);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
startSvc(Edit2.text, Edit1.text);
end;
procedure TForm1.FormCreate(Sender: TObject);
begin
services.LogStrings := Memo1.Lines;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin

case StatusSvc(Edit2.text, Edit1.text) of
    scsReserved:
        Memo1.Lines.Add('    Status: Unknow');
    scsStopped:
        Memo1.Lines.Add('    Status: Stopped');
    scsStarting:
        Memo1.Lines.Add('    Status: Starting');
    scsStopping:
        Memo1.Lines.Add('    Status: Stopping');
    scsRunning:
        Memo1.Lines.Add('    Status: Running');
    scsContinuePending:
        Memo1.Lines.Add('    Status: ContinuePending');
    scsPausing:
        Memo1.Lines.Add('    Status: Pausing');
    scsPaused:
        Memo1.Lines.Add('    Status: Paused');
end; //case

end;

end.


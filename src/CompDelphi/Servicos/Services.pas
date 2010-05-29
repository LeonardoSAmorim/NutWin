unit Services;


interface
uses WinSvc, classes;
type TServiceCurrState = (scsReserved,
                       scsStopped,
                       scsStarting,
                       scsStopping,
                       scsRunning,
                       scsContinuePending,
                       scsPausing,
                       scsPaused
                       );
procedure StartSvc(SvcName: string; MachineName:string);

procedure StopSvc(SvcName: string; MachineName:string);
function StatusSvc(SvcName: string; MachineName:string):TServiceCurrState;

var
   LogStrings: TStrings = nil;

implementation

uses Windows,  SysUtils;

const
    HEAP_GENERATE_EXCEPTIONS = $00000004;
    HEAP_NO_SERIALIZE = $00000001;
    HEAP_ZERO_MEMORY = $00000008;

procedure Log( str: String );
    begin
    if ( assigned(LogStrings)) then
       LogStrings.Add(str);
    end;

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
//     'localhost'
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
// retorno
// Em caso de sucesso, o valor de retorno é um manipulador para o banco de dados
// do service control manager database especificado.
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

         if( Length( MachineName ) >0 ) then
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

//  Parametros
//
// schSCManager [in]
//    Maninpulador para o service control manager database.
//    A funcao  openServiceControlManager retourna este manipulador.

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

// Parametros
//
// schSCManager [in]
//    Maninpulador para o service control manager database.
//    A funcao  openServiceControlManager retourna este manipulador.
//
// retorno
//    Um ponteiro para TServiceStatus que recebe as informações de status.

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

// consulta o status do serviço pelo nome
function StatusSvc(SvcName: string; MachineName : string):TServiceCurrState;
    var

    DesiredAccess: Cardinal; // Access
    // openSCManager
    schSCManager: SC_HANDLE;    // SCM database

    DatabaseName: string; // servicos

    // openService
    schService :DWORD;
    szSvcName: PAnsiChar; // name of service

    // querySercideStatus
    ssStatus:TServiceStatus;

    begin
    schSCManager := 0;
    schService :=0;
    try
        // Get a handle to the SCM database.

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

        result := TServiceCurrState( ssStatus.dwCurrentState );

    finally
        CloseServiceHandle(schService);
        CloseServiceHandle(schSCManager);
    end;
    end;


//Parametros
//
// schSCManager [in]
//    Maninpulador para o service control manager database.
//    A funcao  openServiceControlManager retourna este manipulador.
//


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

procedure StartSvc(SvcName: string; MachineName : string);
    var

    DesiredAccess: Cardinal; // Access
    // openSCManager
    schSCManager: SC_HANDLE;    // SCM database
     // maquina
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

    begin
    schSCManager := 0;
    schService :=0;

    try
        // Get a handle to the SCM database.


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
            Log('Cannot start the service because it is already running');
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
            else if ( dwWaitTime > 3000 ) then
                 dwWaitTime := 3000;

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
                    Log('Timeout waiting for service to stop');
                    exit;
                    end;
                end;
            end;


        // Attempt to start the service.


        SendStartService(schService);
        Log('Service start pending...');

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
            else if ( dwWaitTime > 3000 ) then
                dwWaitTime := 3000;

            Sleep( dwWaitTime );

            // Check the status again.
            try
               ssStatus := ServiceStatus(schService);
            except
                Log('QueryServiceStatusEx failed: '+ intToStr(GetLastError()));
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
            Log('Service started successfully.');
            end
        else
            begin
            Log('Service not started.'#13#10+
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
                        else if ( dwWaitTime > 3000 ) then
                            dwWaitTime := 3000;
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


procedure StopSvc(SvcName: string; MachineName: string);
    var
        DatabaseName: string; // servicos
        DesiredAccess: LongWord; // Access
        schSCManager: SC_HANDLE;    // SCM database
        schService :DWORD;
        szSvcName: PAnsiChar; // name of service

        ssp: TServiceStatus;
        dwStartTime: DWORD;

        dwTimeout: DWORD; // time-out
        dwWaitTime: DWORD ;

    begin
    dwStartTime := GetTickCount();
    dwTimeout := 30000; // 30-second time-out
    schSCManager := 0;
    schService :=0;

    // Get a handle to the SCM database.

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
            Log('Service is already stopped');
            exit;
            end;


        // If a stop is pending, wait for it.

        while ( ssp.dwCurrentState = SERVICE_STOP_PENDING ) do
            begin

            Log('Service stop pending...');

            // Do not wait longer than the wait hint. A good interval is
            // one-tenth of the wait hint but not less than 1 second
            // and not more than 10 seconds.

            dwWaitTime := ssp.dwWaitHint div 10;

            if( dwWaitTime < 1000 )then
                dwWaitTime := 1000
            else if ( dwWaitTime > 3000 ) then
                dwWaitTime := 3000;

            Sleep( dwWaitTime );

            ssp := ServiceStatus(schService);

            if ( ssp.dwCurrentState = SERVICE_STOPPED )then
                begin
                Log('Service stopped successfully.');
                exit;
                end;

            if ( GetTickCount() - dwStartTime > dwTimeout )then
                begin
                Log('Service stop timed out.\n');
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
            else if ( dwWaitTime > 3000 ) then
                 dwWaitTime := 3000;
            Sleep( dwWaitTime );

            ssp := ServiceStatus( schService );

            if ( ssp.dwCurrentState = SERVICE_STOPPED ) then
                break;

            if ( GetTickCount() - dwStartTime > dwTimeout ) then
                begin
                Log('Wait timed out\n' );
                exit;
                end;

            end; // while ...
        Log('Service stopped successfully.');
        finally
        WinSvc.CloseServiceHandle(schService);
        WinSvc.CloseServiceHandle(schSCManager);
        end;

    end; // procedure


end.

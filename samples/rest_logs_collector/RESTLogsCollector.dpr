program RESTLogsCollector;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Signal,
  MVCFramework.Commons,
  MVCFramework.REPLCommandsHandlerU,
  Web.ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  IdHTTPWebBrokerBridge,
  LogsCollectorControllerU in 'LogsCollectorControllerU.pas',
  MainWMU in 'MainWMU.pas' {MyWebModule: TWebModule},
  LoggerProConfig in 'LoggerProConfig.pas',
  LoggerPro.FileAppender in '..\..\LoggerPro.FileAppender.pas',
  LoggerPro in '..\..\LoggerPro.pas';

{$R *.res}

procedure RunServer(APort: Integer);
var
  lServer: TIdHTTPWebBrokerBridge;
begin
  Writeln('** LoggerPro RESTLogsCollector [DMVCFramework Server ** build ' + DMVCFRAMEWORK_VERSION + ']');
  lServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    lServer.DefaultPort := APort;

    { more info about MaxConnections
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_MaxConnections.html }
    lServer.MaxConnections := 0;

    { more info about ListenQueue
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_ListenQueue.html }
    lServer.ListenQueue := 200;
    lServer.Active := True;
    Write('CTRL + C to EXIT');
    WaitForTerminationSignal;
  finally
    lServer.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  IsMultiThread := True;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;
    RunServer(8080);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.

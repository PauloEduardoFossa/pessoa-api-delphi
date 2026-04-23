unit uConexao;

interface

uses
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Comp.Client,
  System.IOUtils;

type
  TConexao = class
  private
    class var FConnection: TFDConnection;

    class function GetDatabasePath: string; static;
    class procedure ConfigurarConexao; static;

  public
    class procedure Inicializar; static;
    class procedure Finalizar; static;

    class function GetConnection: TFDConnection; static;
    class function NovaConexao: TFDConnection; static;
  end;

implementation

uses
  System.SysUtils;

{ TConexao }

class function TConexao.GetDatabasePath: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'database\pessoa.db');
end;

class procedure TConexao.ConfigurarConexao;
var
  LDBPath: string;
begin
  LDBPath := GetDatabasePath;

  ForceDirectories(ExtractFilePath(LDBPath));

  FConnection := TFDConnection.Create(nil);

  FConnection.DriverName := 'SQLite';
  FConnection.LoginPrompt := False;

  FConnection.Params.Clear;
  FConnection.Params.Add('Database=' + LDBPath);
  FConnection.Params.Add('LockingMode=Normal');
  FConnection.Params.Add('ForeignKeys=On');
  FConnection.Params.Add('DriverID=SQLite');

  FConnection.Connected := True;

  FConnection.ExecSQL('PRAGMA foreign_keys = ON;');
end;

class procedure TConexao.Inicializar;
begin
  if not Assigned(FConnection) then
    ConfigurarConexao;
end;

class function TConexao.NovaConexao: TFDConnection;
var
  LDBPath: string;
begin
  LDBPath := GetDatabasePath;

  Result := TFDConnection.Create(nil);
  Result.DriverName := 'SQLite';
  Result.LoginPrompt := False;

  Result.Params.Clear;
  Result.Params.Add('Database=' + LDBPath);
  Result.Params.Add('LockingMode=Normal');
  Result.Params.Add('ForeignKeys=On');
  Result.Params.Add('DriverID=SQLite');

  Result.Connected := True;
  Result.ExecSQL('PRAGMA foreign_keys = ON;');
end;

class procedure TConexao.Finalizar;
begin
  if Assigned(FConnection) then
  begin
    FConnection.Close;
    FreeAndNil(FConnection);
  end;
end;

class function TConexao.GetConnection: TFDConnection;
begin
  if not Assigned(FConnection) then
    raise Exception.Create('Conexão não inicializada');

  Result := FConnection;
end;

end.

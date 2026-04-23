unit uDatabase.Connection;

interface

uses
  FireDAC.Comp.Client;

type
  TDatabaseInitializer = class
  public
    class function TableExists(AConnection: TFDConnection; const ATableName: string): Boolean;
    class procedure InitializeDatabase(AConnection: TFDConnection);
  end;

implementation

uses
  Data.DB,
  FireDAC.Stan.Param,
  System.SysUtils;

{ TDatabaseInitializer }

class procedure TDatabaseInitializer.InitializeDatabase(AConnection: TFDConnection);
var
  LDBPath: string;
begin
  LDBPath := ExtractFilePath(ParamStr(0)) + 'database\Pessoa.db';

  if not TableExists(AConnection, 'pessoa') then
  begin
    ForceDirectories(ExtractFilePath(LDBPath));

    AConnection.Params.Database := LDBPath;
    AConnection.Connected := True;

    AConnection.ExecSQL('CREATE TABLE pessoa (' +
                            'idpessoa INTEGER PRIMARY KEY AUTOINCREMENT,' +
                            'flnatureza INTEGER NOT NULL,' +
                            'dsdocumento TEXT NOT NULL,' +
                            'nmprimeiro TEXT NOT NULL,' +
                            'nmsegundo TEXT NOT NULL,' +
                            'dtregistro DATE)');

    AConnection.ExecSQL('CREATE TABLE endereco ('+
                            'idendereco INTEGER PRIMARY KEY AUTOINCREMENT,'+
                            'idpessoa INTEGER NOT NULL,'+
                            'dscep TEXT,'+
                            'FOREIGN KEY (idpessoa)'+
                            '    REFERENCES pessoa(idpessoa)'+
                            '    ON DELETE CASCADE'+
                        ');');

    AConnection.ExecSQL('CREATE INDEX endereco_idpessoa ON endereco (idpessoa);');

    AConnection.ExecSQL('CREATE TABLE endereco_integracao ('+
                            'idendereco INTEGER PRIMARY KEY,'+
                            'dsuf TEXT,'+
                            'nmcidade TEXT,'+
                            'nmbairro TEXT,'+
                            'nmlogradouro TEXT,'+
                            'dscomplemento TEXT,'+
                            'FOREIGN KEY (idendereco)'+
                            '    REFERENCES endereco(idendereco)'+
                            '    ON DELETE CASCADE'+
                            ');');
  end
  else
  begin
    AConnection.Params.Database := LDBPath;
    AConnection.Connected := True;
  end;
end;

class function TDatabaseInitializer.TableExists(AConnection: TFDConnection; const ATableName: string): Boolean;
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := AConnection;
    LQry.SQL.Text :=
      'SELECT name FROM sqlite_master ' +
      ' WHERE type = ''table'' '+
      '   AND name = :name';

    LQry.ParamByName('name').AsString := ATableName;
    LQry.Open;

    Result := not LQry.IsEmpty;
  finally
    LQry.Free;
  end;
end;

end.


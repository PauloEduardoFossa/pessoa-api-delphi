unit uPessoaApiService;

interface

uses
  System.SysUtils,
  System.Net.HttpClient,
  System.Net.URLClient;

type
  TPessoaApiService = class
  private
    FBaseUrl: string;
    FHttp: THTTPClient;
  public
    constructor Create(const ABaseUrl: string);
    destructor Destroy; override;

    function Inserir(const AJson: string): string;
    function Alterar(AIdPessoa: Int64; const AJson: string): string;
    function Excluir(AIdPessoa: Int64): string;
    function ObterPorId(AIdPessoa: Int64): string;
    function Listar: string;
    function InserirLote(const AJson: string): string;
    function IntegrarCeps: string;
  end;

implementation

uses
  System.Classes;

constructor TPessoaApiService.Create(const ABaseUrl: string);
begin
  inherited Create;
  FBaseUrl := ABaseUrl;
  FHttp := THTTPClient.Create;
  FHttp.ConnectionTimeout := 10000;
  FHttp.ResponseTimeout := 30000;
end;

destructor TPessoaApiService.Destroy;
begin
  FHttp.Free;
  inherited;
end;

function TPessoaApiService.Inserir(const AJson: string): string;
var
  LResponse: IHTTPResponse;
  LContent: TStringStream;
begin
  LContent := TStringStream.Create(AJson, TEncoding.UTF8);
  try
    LResponse := FHttp.Post(FBaseUrl + '/pessoas', LContent, nil,
      [TNetHeader.Create('Content-Type', 'application/json')]);
    Result := LResponse.ContentAsString(TEncoding.UTF8);
  finally
    LContent.Free;
  end;
end;

function TPessoaApiService.Alterar(AIdPessoa: Int64; const AJson: string): string;
var
  LResponse: IHTTPResponse;
  LContent: TStringStream;
begin
  LContent := TStringStream.Create(AJson, TEncoding.UTF8);
  try
    LResponse := FHttp.Put(FBaseUrl + '/pessoas/' + AIdPessoa.ToString, LContent, nil,
      [TNetHeader.Create('Content-Type', 'application/json')]);
    Result := LResponse.ContentAsString(TEncoding.UTF8);
  finally
    LContent.Free;
  end;
end;

function TPessoaApiService.Excluir(AIdPessoa: Int64): string;
var
  LResponse: IHTTPResponse;
begin
  LResponse := FHttp.Delete(FBaseUrl + '/pessoas/' + AIdPessoa.ToString);
  Result := LResponse.ContentAsString(TEncoding.UTF8);
end;

function TPessoaApiService.ObterPorId(AIdPessoa: Int64): string;
var
  LResponse: IHTTPResponse;
begin
  LResponse := FHttp.Get(FBaseUrl + '/pessoas/' + AIdPessoa.ToString);
  Result := LResponse.ContentAsString(TEncoding.UTF8);
end;

function TPessoaApiService.Listar: string;
var
  LResponse: IHTTPResponse;
begin
  LResponse := FHttp.Get(FBaseUrl + '/pessoas');
  Result := LResponse.ContentAsString(TEncoding.UTF8);
end;

function TPessoaApiService.InserirLote(const AJson: string): string;
var
  LResponse: IHTTPResponse;
  LContent: TStringStream;
begin
  LContent := TStringStream.Create(AJson, TEncoding.UTF8);
  try
    LResponse := FHttp.Post(FBaseUrl + '/pessoas/lote', LContent, nil,
      [TNetHeader.Create('Content-Type', 'application/json')]);
    Result := LResponse.ContentAsString(TEncoding.UTF8);
  finally
    LContent.Free;
  end;
end;

function TPessoaApiService.IntegrarCeps: string;
var
  LResponse: IHTTPResponse;
  LContent: TStringStream;
begin
  LContent := TStringStream.Create('', TEncoding.UTF8);
  try
    LResponse := FHttp.Post(FBaseUrl + '/integracao/ceps', LContent, nil,
      [TNetHeader.Create('Content-Type', 'application/json')]);
    Result := LResponse.ContentAsString(TEncoding.UTF8);
  finally
    LContent.Free;
  end;
end;

end.

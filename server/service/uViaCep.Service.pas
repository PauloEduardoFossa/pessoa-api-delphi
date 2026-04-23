unit uViaCep.Service;

interface

uses
  uEnderecoIntegracao.Model;

type
  TViaCepService = class
  public
    function ConsultarCep(const ACep: string; AIdEndereco: Int64): TEnderecoIntegracao;
  end;

implementation

uses
  System.SysUtils,
  System.JSON,
  System.Net.HttpClient,
  System.Net.URLClient;

function ApenasNumeros(const ATexto: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(ATexto) do
    if CharInSet(ATexto[I], ['0'..'9']) then
      Result := Result + ATexto[I];
end;

function TViaCepService.ConsultarCep(const ACep: string;
  AIdEndereco: Int64): TEnderecoIntegracao;
var
  LHttp: THTTPClient;
  LResponse: IHTTPResponse;
  LJson: TJSONObject;
  LCep: string;
  LErro: Boolean;
begin
  LCep := ApenasNumeros(ACep);

  if LCep = '' then
    raise Exception.Create('CEP não informado.');

  LHttp := THTTPClient.Create();
  try
    LHttp.ConnectionTimeout := 15000;
    LHttp.ResponseTimeout := 30000;

    try
      LResponse := LHttp.Get('https://viacep.com.br/ws/' + LCep + '/json/');
    except
      on E: ENetHTTPClientException do
        raise Exception.Create('Timeout ou falha de comunicação com ViaCEP para o CEP ' + LCep + '.');
    end;

    if LResponse.StatusCode <> 200 then
      raise Exception.Create('Erro ao consultar ViaCEP.');

    LJson := TJSONObject.ParseJSONValue(LResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
    try
      if not Assigned(LJson) then
        raise Exception.Create('Resposta inválida da ViaCEP.');

      LErro := LJson.GetValue<Boolean>('erro', False);
      if LErro then
        raise Exception.Create('CEP não encontrado.');

      Result := TEnderecoIntegracao.Create;
      Result.IdEndereco := AIdEndereco;
      Result.DsUf := LJson.GetValue<string>('uf', '');
      Result.NmCidade := LJson.GetValue<string>('localidade', '');
      Result.NmBairro := LJson.GetValue<string>('bairro', '');
      Result.NmLogradouro := LJson.GetValue<string>('logradouro', '');
      Result.DsComplemento := LJson.GetValue<string>('complemento', '');
    finally
      LJson.Free;
    end;
  finally
    LHttp.Free;
  end;
end;

end.

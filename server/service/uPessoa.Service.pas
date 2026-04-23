unit uPessoa.Service;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uPessoa.Model,
  uPessoa.Repository,
  uEndereco.Repository;

type
  TPessoaService = class
  private
    FConnection: TFDConnection;
    FPessoaRepository: TPessoaRepository;
    FEnderecoRepository: TEnderecoRepository;

    procedure ValidarPessoa(APessoa: TPessoa);
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    function Listar: TObjectList<TPessoa>;
    function ObterPorId(AIdPessoa: Int64): TPessoa;

    procedure Inserir(APessoa: TPessoa);
    procedure InserirLote(ALista: TList<TPessoa>);
    procedure Alterar(APessoa: TPessoa);
    procedure Excluir(AIdPessoa: Integer);
  end;

implementation

uses
  Data.DB,
  FireDAC.Stan.Param,
  uConstants;

{ TPessoaService }

constructor TPessoaService.Create(AConnection: TFDConnection);
begin
  inherited Create;

  FConnection := AConnection;
  FPessoaRepository := TPessoaRepository.Create(FConnection);
  FEnderecoRepository := TEnderecoRepository.Create(FConnection);
end;

destructor TPessoaService.Destroy;
begin
  FPessoaRepository.Free;
  FEnderecoRepository.Free;
  inherited;
end;

procedure TPessoaService.ValidarPessoa(APessoa: TPessoa);
begin
  if not Assigned(APessoa) then
    raise Exception.Create('Pessoa não informada.');

  if APessoa.FlNatureza <= 0 then
    raise Exception.Create('Natureza inválida.');

  if Trim(APessoa.DsDocumento) = '' then
    raise Exception.Create('Documento é obrigatório.');

  if Trim(APessoa.NmPrimeiro) = '' then
    raise Exception.Create('Primeiro nome é obrigatório.');

  if Trim(APessoa.NmSegundo) = '' then
    raise Exception.Create('Segundo nome é obrigatório.');

  if not Assigned(APessoa.Endereco) then
    raise Exception.Create('Endereço é obrigatório.');
end;

procedure TPessoaService.Inserir(APessoa: TPessoa);
var
  LIdPessoa: Int64;
begin
  ValidarPessoa(APessoa);

  FConnection.StartTransaction;
  try
    LIdPessoa := FPessoaRepository.Inserir(APessoa);
    APessoa.IdPessoa := LIdPessoa;

    APessoa.Endereco.IdPessoa := LIdPessoa;
    FEnderecoRepository.Inserir(APessoa.Endereco);

    FConnection.Commit;
  except
    on E: Exception do
    begin
      if FConnection.InTransaction then
        FConnection.Rollback;
      raise;
    end;
  end;
end;

procedure TPessoaService.InserirLote(ALista: TList<TPessoa>);
var
  LQryPessoa: TFDQuery;
  LQryEndereco: TFDQuery;
  i: Integer;
  LIdPessoa: Int64;
begin
  LQryPessoa := TFDQuery.Create(nil);
  LQryEndereco := TFDQuery.Create(nil);
  try
    LQryPessoa.Connection := FConnection;
    LQryEndereco.Connection := FConnection;

    LQryPessoa.SQL.Text := INSERT_PESSOA_LOTE;

    LQryPessoa.ParamByName('flnatureza').DataType := ftInteger;
    LQryPessoa.ParamByName('dsdocumento').DataType := ftString;
    LQryPessoa.ParamByName('nmprimeiro').DataType := ftString;
    LQryPessoa.ParamByName('nmsegundo').DataType := ftString;
    LQryPessoa.ParamByName('dtregistro').DataType := ftDate;

    LQryPessoa.Prepare;


    LQryEndereco.SQL.Text := INSERT_ENDERECO_LOTE;

    LQryEndereco.ParamByName('idpessoa').DataType := ftLargeint;
    LQryEndereco.ParamByName('dscep').DataType := ftString;

    LQryEndereco.Prepare;

    FConnection.StartTransaction;

    try
      for i := 0 to ALista.Count - 1 do
      begin
        LQryPessoa.ParamByName('flnatureza').AsInteger := ALista[i].FlNatureza;
        LQryPessoa.ParamByName('dsdocumento').AsString := ALista[i].DsDocumento;
        LQryPessoa.ParamByName('nmprimeiro').AsString := ALista[i].NmPrimeiro;
        LQryPessoa.ParamByName('nmsegundo').AsString := ALista[i].NmSegundo;
        LQryPessoa.ParamByName('dtregistro').AsDate := ALista[i].DtRegistro;

        LQryPessoa.ExecSQL;

        LIdPessoa := FConnection.ExecSQLScalar('SELECT last_insert_rowid()');

        LQryEndereco.ParamByName('idpessoa').AsLargeInt := LIdPessoa;
        LQryEndereco.ParamByName('dscep').AsString := ALista[i].Endereco.DsCep;

        LQryEndereco.ExecSQL;

        if (i mod 1000 = 0) then
        begin
          FConnection.Commit;
          FConnection.StartTransaction;
        end;
      end;

      FConnection.Commit;
    except
      FConnection.Rollback;
      raise;
    end;

  finally
    LQryPessoa.Free;
    LQryEndereco.Free;
  end;
end;

function TPessoaService.Listar: TObjectList<TPessoa>;
var
  LPessoa: TPessoa;
begin
  Result := FPessoaRepository.Listar;

  for LPessoa in Result do
    LPessoa.Endereco := FEnderecoRepository.ObterPorIdPessoa(LPessoa.IdPessoa);
end;

function TPessoaService.ObterPorId(AIdPessoa: Int64): TPessoa;
begin
  if AIdPessoa <= 0 then
    raise Exception.Create('Id da pessoa inválido.');

  Result := FPessoaRepository.ObterPorId(AIdPessoa);

  if not Assigned(Result) then
    raise Exception.Create('Pessoa não encontrada.');

  Result.Endereco := FEnderecoRepository.ObterPorIdPessoa(AIdPessoa);
end;

procedure TPessoaService.Alterar(APessoa: TPessoa);
begin
  ValidarPessoa(APessoa);

  if APessoa.IdPessoa <= 0 then
    raise Exception.Create('Id da pessoa inválido para alteração.');

  FConnection.StartTransaction;
  try
    FPessoaRepository.Atualizar(APessoa);

    APessoa.Endereco.IdPessoa := APessoa.IdPessoa;
    FEnderecoRepository.Atualizar(APessoa.Endereco);

    FConnection.Commit;
  except
    on E: Exception do
    begin
      if FConnection.InTransaction then
        FConnection.Rollback;
      raise;
    end;
  end;
end;

procedure TPessoaService.Excluir(AIdPessoa: Integer);
begin
  if AIdPessoa <= 0 then
    raise Exception.Create('Id da pessoa inválido para exclusão.');

  FConnection.StartTransaction;
  try
    FPessoaRepository.Excluir(AIdPessoa);
    FConnection.Commit;
  except
    on E: Exception do
    begin
      if FConnection.InTransaction then
        FConnection.Rollback;
      raise;
    end;
  end;
end;

end.

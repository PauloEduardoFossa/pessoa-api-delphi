unit uEndereco.Repository;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uEndereco.Model,
  uRepository.Interfaces;

type
  TEnderecoRepository = class(TInterfacedObject, IEnderecoRepository)
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);

    function ObterPorIdPessoa(AIdPessoa: Int64): TEndereco;
    procedure Inserir(AEndereco: TEndereco);
    procedure Atualizar(AEndereco: TEndereco);
  end;

implementation

uses
  uConstants,
  Data.DB,
  FireDAC.Stan.Param;

{ TEmpreendimentoRepository }

procedure TEnderecoRepository.Atualizar(AEndereco: TEndereco);
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConnection;

    LQry.SQL.Text := UPDATE_ENDERECO;

    LQry.ParamByName('idpessoa').AsInteger := AEndereco.IDPessoa;
    LQry.ParamByName('dscep').AsString := AEndereco.dsCEP;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

constructor TEnderecoRepository.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

procedure TEnderecoRepository.Inserir(AEndereco: TEndereco);
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConnection;
    LQry.SQL.Text := INSERT_ENDERECO;

    LQry.ParamByName('idpessoa').AsInteger  := AEndereco.idPessoa;
    LQry.ParamByName('dscep').AsString       := AEndereco.dsCep;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

function TEnderecoRepository.ObterPorIdPessoa(AIdPessoa: Int64): TEndereco;
var
  LQry: TFDQuery;
begin
  Result := nil;

  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := FConnection;

    LQry.SQL.Text := CONSULTA_ENDERECO + FILTRO_ENDERECO;

    LQry.ParamByName('idpessoa').AsInteger := AIdPessoa;

    LQry.Open;

    if not LQry.IsEmpty then
    begin
      Result := TEndereco.Create;

      Result.IDEndereco := LQry.FieldByName('idendereco').AsInteger;

      Result.IDPessoa := LQry.FieldByName('idpessoa').AsInteger;

      Result.DsCEP := LQry.FieldByName('dscep').AsString;
    end;
  finally
    LQry.Free;
  end;
end;

end.

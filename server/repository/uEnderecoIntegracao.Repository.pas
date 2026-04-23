unit uEnderecoIntegracao.Repository;

interface

uses
  FireDAC.Comp.Client,
  uEnderecoIntegracao.Model;

type
  TEnderecoIntegracaoRepository = class
  private
    FConnection: TFDConnection;

  public
    constructor Create(AConnection: TFDConnection);

    procedure InserirOuAtualizar(AEnderecoIntegracao: TEnderecoIntegracao);
  end;

implementation

uses
  Data.DB,
  FireDAC.Stan.Param;

constructor TEnderecoIntegracaoRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

procedure TEnderecoIntegracaoRepository.InserirOuAtualizar(
  AEnderecoIntegracao: TEnderecoIntegracao);
var
  LQry: TFDQuery;
  LExiste: Boolean;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConnection;

    LQry.SQL.Text :=
      'SELECT 1 FROM endereco_integracao WHERE idendereco = :idendereco';
    LQry.ParamByName('idendereco').AsLargeInt := AEnderecoIntegracao.IdEndereco;
    LQry.Open;

    LExiste := not LQry.IsEmpty;
    LQry.Close;

    if LExiste then
    begin
      LQry.SQL.Text :=
        'UPDATE endereco_integracao SET ' +
        ' dsuf = :dsuf, ' +
        ' nmcidade = :nmcidade, ' +
        ' nmbairro = :nmbairro, ' +
        ' nmlogradouro = :nmlogradouro, ' +
        ' dscomplemento = :dscomplemento ' +
        'WHERE idendereco = :idendereco';
    end
    else
    begin
      LQry.SQL.Text :=
        'INSERT INTO endereco_integracao ' +
        ' (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) ' +
        'VALUES ' +
        ' (:idendereco, :dsuf, :nmcidade, :nmbairro, :nmlogradouro, :dscomplemento)';
    end;

    LQry.ParamByName('idendereco').AsLargeInt := AEnderecoIntegracao.IdEndereco;
    LQry.ParamByName('dsuf').AsString := AEnderecoIntegracao.DsUf;
    LQry.ParamByName('nmcidade').AsString := AEnderecoIntegracao.NmCidade;
    LQry.ParamByName('nmbairro').AsString := AEnderecoIntegracao.NmBairro;
    LQry.ParamByName('nmlogradouro').AsString := AEnderecoIntegracao.NmLogradouro;
    LQry.ParamByName('dscomplemento').AsString := AEnderecoIntegracao.DsComplemento;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

end.

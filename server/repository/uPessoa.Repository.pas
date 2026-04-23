unit uPessoa.Repository;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uPessoa.Model,
  uRepository.Interfaces;

type
  TPessoaRepository = class(TInterfacedObject, IPessoaRepository)
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);

    function Inserir(APessoa: TPessoa): Int64;
    function Listar: TObjectList<TPessoa>;
    function ObterPorId(AIdPessoa: Int64): TPessoa;
    procedure Atualizar(APessoa: TPessoa);
    procedure Excluir(AIdPessoa: Int64);
  end;

implementation

uses
  uConstants,
  Data.DB,
  FireDAC.Stan.Param;

{ TEmpreendimentoRepository }

procedure TPessoaRepository.Atualizar(APessoa: TPessoa);
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConnection;

    LQry.SQL.Text := UPDATE_PESSOA;

    LQry.ParamByName('flnatureza').AsInteger := APessoa.FlNatureza;
    LQry.ParamByName('dsdocumento').AsString := APessoa.DsDocumento ;
    LQry.ParamByName('nmprimeiro').AsString  := APessoa.NmPrimeiro;
    LQry.ParamByName('nmsegundo').AsString   := APessoa.NmSegundo ;
    LQry.ParamByName('idpessoa').AsInteger   := APessoa.IdPessoa;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

constructor TPessoaRepository.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

procedure TPessoaRepository.Excluir(AIdPessoa: Int64);
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConnection;
    LQry.SQL.Text := DELETE_PESSOA;
    LQry.ParamByName('idpessoa').AsInteger := AIdPessoa;
    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

function TPessoaRepository.Inserir(APessoa: TPessoa): Int64;
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := FConnection;
    LQry.SQL.Text := INSERT_PESSOA;

    LQry.ParamByName('dtregistro').AsDateTime := APessoa.DtRegistro;
    LQry.ParamByName('flnatureza').AsInteger  := APessoa.FlNatureza;
    LQry.ParamByName('dsdocumento').AsString  := APessoa.DsDocumento;
    LQry.ParamByName('nmprimeiro').AsString   := APessoa.NmPrimeiro;
    LQry.ParamByName('nmsegundo').AsString    := APessoa.NmSegundo;

    LQry.ExecSQL;

    Result := Trunc(FConnection.ExecSQLScalar('SELECT last_insert_rowid()'));
  finally
    LQry.Free;
  end;
end;

function TPessoaRepository.Listar: TObjectList<TPessoa>;
var
  LQry: TFDQuery;
  LPessoa: TPessoa;
begin

  Result := TObjectList<TPessoa>.Create;

  LQry := TFDQuery.Create(nil);

  try

    LQry.Connection := FConnection;

    LQry.SQL.Text := CONSULTA_PESSOA;

    LQry.Open;

    while not LQry.Eof do
    begin

      LPessoa := TPessoa.Create;

      LPessoa.IDPessoa := LQry.FieldByName('idpessoa').AsInteger;

      LPessoa.FlNatureza  := LQry.FieldByName('flnatureza').AsInteger;

      LPessoa.DsDocumento := LQry.FieldByName('dsdocumento').AsString;

      LPessoa.NmPrimeiro := LQry.FieldByName('nmprimeiro').AsString;

      LPessoa.NmSegundo := LQry.FieldByName('nmsegundo').AsString;

      LPessoa.DtRegistro := LQry.FieldByName('dtregistro').AsDateTime;

      Result.Add(LPessoa);

      LQry.Next;

    end;

  finally
    LQry.Free;
  end;
end;

function TPessoaRepository.ObterPorId(AIdPessoa: Int64): TPessoa;
var
  LQry: TFDQuery;
begin
  Result := nil;

  LQry := TFDQuery.Create(nil);

  try
    LQry.Connection := FConnection;

    LQry.SQL.Text := CONSULTA_PESSOA + FILTRO_PESSOA;

    LQry.ParamByName('idpessoa').AsInteger := AIdPessoa;

    LQry.Open;

    if not LQry.IsEmpty then
    begin
      Result := TPessoa.Create;

      Result.IDPessoa := LQry.FieldByName('idpessoa').AsInteger;

      Result.FlNatureza := LQry.FieldByName('flnatureza').AsInteger;

      Result.DsDocumento := LQry.FieldByName('dsdocumento').AsString;

      Result.NmPrimeiro := LQry.FieldByName('nmprimeiro').AsString;

      Result.NmSegundo := LQry.FieldByName('nmsegundo').AsString;

      Result.DtRegistro := LQry.FieldByName('dtregistro').AsDateTime;
    end;
  finally
    LQry.Free;
  end;
end;

end.

unit uAtualizaCep.Thread;

interface

uses
  System.Classes;

type
  TCepItem = class
  public
    IdEndereco: Int64;
    Cep: string;
  end;

  TAtualizaCepThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

implementation

uses
  System.Generics.Collections,
  System.SysUtils,
  FireDAC.Comp.Client,
  uConstants,
  uConexao,
  uViaCep.Service,
  uEnderecoIntegracao.Model,
  uEnderecoIntegracao.Repository;

constructor TAtualizaCepThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
end;

procedure TAtualizaCepThread.Execute;
var
  LConnectionRead: TFDConnection;
  LConnectionWrite: TFDConnection;
  LQry: TFDQuery;
  LViaCepService: TViaCepService;
  LRepository: TEnderecoIntegracaoRepository;
  LEnderecoIntegracao: TEnderecoIntegracao;
  LLista: TObjectList<TCepItem>;
  LItem: TCepItem;
begin
  LConnectionRead := TConexao.NovaConexao;
  LConnectionWrite := TConexao.NovaConexao;
  LQry := TFDQuery.Create(nil);
  LViaCepService := TViaCepService.Create;
  LRepository := TEnderecoIntegracaoRepository.Create(LConnectionWrite);
  LLista := TObjectList<TCepItem>.Create(True);

  try
    LQry.Connection := LConnectionRead;
    LQry.SQL.Text := CONSULTA_ENDERECO_CEP;

    LQry.Open;

    while not LQry.Eof do
    begin
      LItem := TCepItem.Create;
      LItem.IdEndereco := LQry.FieldByName('idendereco').AsLargeInt;
      LItem.Cep := LQry.FieldByName('dscep').AsString;
      LLista.Add(LItem);

      LQry.Next;
    end;

    LQry.Close;

    for LItem in LLista do
    begin
      if Terminated then
        Break;

      try
        LEnderecoIntegracao := LViaCepService.ConsultarCep(LItem.Cep, LItem.IdEndereco);
        try
          LRepository.InserirOuAtualizar(LEnderecoIntegracao);
        finally
          LEnderecoIntegracao.Free;
        end;
      except
        on E: Exception do
        begin
          // Fazer log
        end;
      end;

      Sleep(2000);
    end;
  finally
    LLista.Free;
    LRepository.Free;
    LViaCepService.Free;
    LQry.Free;
    LConnectionRead.Free;
    LConnectionWrite.Free;
  end;
end;

end.

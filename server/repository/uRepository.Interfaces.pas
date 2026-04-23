unit uRepository.Interfaces;

interface

uses
  System.Generics.Collections,
  uEndereco.Model,
  uPessoa.Model;

type
  IPessoaRepository = interface
    ['{9E552AF8-3160-46FA-96F7-05ECDD9BFFDF}']

    function Inserir(APessoa: TPessoa): Int64;
    function Listar: TObjectList<TPessoa>;
    function ObterPorId(AIdPessoa: Int64): TPessoa;
    procedure Atualizar(APessoa: TPessoa);
    procedure Excluir(AIdPessoa: Int64);
  end;


  IEnderecoRepository = interface
    ['{438C0E33-D273-484F-99A8-D82C6D6EB1D5}']

    function ObterPorIdPessoa(AIdPessoa: Int64): TEndereco;
    procedure Inserir(AEndereco: TEndereco);
    procedure Atualizar(AEndereco: TEndereco);
  end;

implementation

end.

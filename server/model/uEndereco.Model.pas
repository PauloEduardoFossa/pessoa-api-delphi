unit uEndereco.Model;

interface

type
  TEndereco = class
  private
    FIDEndereco: Int64;
    FIDPessoa: Int64;
    FDsCEP: string;
  public
    property IDEndereco: Int64 read FIDEndereco write FIDEndereco;
    property IDPessoa: Int64 read FIDPessoa write FIDPessoa;
    property DsCEP: string read FDsCEP write FDsCEP;
  end;

implementation

end.

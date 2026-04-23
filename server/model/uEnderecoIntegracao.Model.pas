unit uEnderecoIntegracao.Model;

interface

type
  TEnderecoIntegracao = class
  private
    FIdEndereco: Int64;
    FDsUf: string;
    FNmCidade: string;
    FNmBairro: string;
    FNmLogradouro: string;
    FDsComplemento: string;
  public
    property IdEndereco: Int64 read FIdEndereco write FIdEndereco;
    property DsUf: string read FDsUf write FDsUf;
    property NmCidade: string read FNmCidade write FNmCidade;
    property NmBairro: string read FNmBairro write FNmBairro;
    property NmLogradouro: string read FNmLogradouro write FNmLogradouro;
    property DsComplemento: string read FDsComplemento write FDsComplemento;
  end;

implementation

end.

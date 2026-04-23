unit uPessoa.Model;

interface

uses
  uEndereco.Model;

type
  TPessoa= class
  private
    FIDPessoa: Int64;
    FFlNatureza: Integer;
    FDsDocumento: string;
    FNmPrimeiro: string;
    FNmSegundo: string;
    FDtRegistro: TDate;
    FEndereco: TEndereco;
  public
    constructor Create();
    destructor Destroy(); override;

    property IDPessoa: Int64 read FIDPessoa write FIDPessoa;
    property FlNatureza: Integer read FFlNatureza write FFlNatureza;
    property DsDocumento: string read FDsDocumento write FDsDocumento;
    property NmPrimeiro: string read FNmPrimeiro write FNmPrimeiro;
    property NmSegundo: string read FNmSegundo write FNmSegundo;
    property DtRegistro: TDate read FDtRegistro write FDtRegistro;
    property Endereco: TEndereco read FEndereco write FEndereco;
  end;

implementation

{ TPessoa }

constructor TPessoa.Create;
begin
  inherited;
  FEndereco := TEndereco.Create;
end;

destructor TPessoa.Destroy;
begin
  FEndereco.Free;
  inherited;
end;

end.

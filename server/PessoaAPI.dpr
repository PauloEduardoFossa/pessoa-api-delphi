program PessoaAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  uPessoa.Controller in 'controller\uPessoa.Controller.pas',
  uDatabase.Connection in 'infra\uDatabase.Connection.pas',
  uPessoa.Model in 'model\uPessoa.Model.pas',
  uRepository.Interfaces in 'repository\uRepository.Interfaces.pas',
  uPessoa.Repository in 'repository\uPessoa.Repository.pas',
  uConstants in 'common\uConstants.pas',
  uConexao in 'infra\uConexao.pas',
  uEndereco.Model in 'model\uEndereco.Model.pas',
  uEndereco.Repository in 'repository\uEndereco.Repository.pas',
  uPessoa.Service in 'service\uPessoa.Service.pas',
  uPing.Controller in 'controller\uPing.Controller.pas',
  uEnderecoIntegracao.Model in 'model\uEnderecoIntegracao.Model.pas',
  uEnderecoIntegracao.Repository in 'repository\uEnderecoIntegracao.Repository.pas',
  uViaCep.Service in 'service\uViaCep.Service.pas',
  uAtualizaCep.Thread in 'thread\uAtualizaCep.Thread.pas',
  uIntegracaoCep.Controller in 'controller\uIntegracaoCep.Controller.pas',
  System.SysUtils;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    Writeln('====================================');
    Writeln('   API iniciada com sucesso');
    Writeln('   Porta: 9000');
    Writeln('   URL: http://localhost:9000');
    Writeln('====================================');

    TConexao.Inicializar;
    try
      TDatabaseInitializer.InitializeDatabase(TConexao.GetConnection);

      RegistrarRotasPing;
      RegistrarRotasPessoa;
      RegistrarRotasIntegracaoCep;

      THorse.Listen(9000,
        procedure
        begin
          Writeln('Servidor rodando...');
        end);
    finally
      TConexao.Finalizar;
    end;
 except
    on E: Exception do
    begin
      Writeln('ERRO AO INICIAR A API:');
      Writeln(E.ClassName + ': ' + E.Message);
      Readln;
    end;
  end;
end.

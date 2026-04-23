program PessoaClient;

uses
  Vcl.Forms,
  uPrincipal in 'forms\uPrincipal.pas' {FormPrincipal},
  uPessoaApiService in 'services\uPessoaApiService.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.

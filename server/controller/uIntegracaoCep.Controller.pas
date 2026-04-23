unit uIntegracaoCep.Controller;

interface

procedure RegistrarRotasIntegracaoCep;

implementation

uses
  System.JSON,
  Horse,
  uAtualizaCep.Thread;

procedure RegistrarRotasIntegracaoCep;
begin
  THorse.Post('/integracao/ceps',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LThread: TAtualizaCepThread;
      LJson: TJSONObject;
    begin
      LThread := TAtualizaCepThread.Create;
      LThread.Start;

      LJson := TJSONObject.Create;
      try
        LJson.AddPair('sucesso', TJSONBool.Create(True));
        LJson.AddPair('mensagem', 'Processo de integração de CEP iniciado.');

        Res.Status(202)
           .ContentType('application/json')
           .Send(LJson.ToJSON);
      finally
        LJson.Free;
      end;
    end
  );
end;

end.

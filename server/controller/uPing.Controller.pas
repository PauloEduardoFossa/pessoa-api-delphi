unit uPing.Controller;

interface

procedure RegistrarRotasPing;

implementation

uses
  Horse,
  System.SysUtils;

procedure RegistrarRotasPing;
begin
  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      try
        Res.Send('pong');
      except
        on E: Exception do
          Res.Status(400).Send(E.Message);
      end;
    end);
end;

end.

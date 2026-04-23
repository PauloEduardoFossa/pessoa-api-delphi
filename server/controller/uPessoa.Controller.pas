unit uPessoa.Controller;

interface

procedure RegistrarRotasPessoa;

implementation

uses
  System.Generics.Collections,
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  Horse,
  uConexao,
  uPessoa.Model,
  uEndereco.Model,
  uPessoa.Service;

function JsonToPessoa(const AJson: string): TPessoa;
var
  LJsonObj: TJSONObject;
  LJsonEndereco: TJSONObject;
  LDate: TDateTime;
begin
  Result := TPessoa.Create;
  LJsonObj := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
  try
    if not Assigned(LJsonObj) then
      raise Exception.Create('JSON inválido.');

    Result.FlNatureza := LJsonObj.GetValue<Integer>('flnatureza', 0);
    Result.DsDocumento := LJsonObj.GetValue<string>('dsdocumento', '');
    Result.NmPrimeiro := LJsonObj.GetValue<string>('nmprimeiro', '');
    Result.NmSegundo := LJsonObj.GetValue<string>('nmsegundo', '');

    if LJsonObj.TryGetValue<TDateTime>('dtregistro', LDate) then
      Result.DtRegistro := LDate
    else if TryISO8601ToDate(LJsonObj.GetValue<string>('dtregistro', ''), LDate) then
      Result.DtRegistro := LDate;

    LJsonEndereco := LJsonObj.GetValue<TJSONObject>('endereco');
    if Assigned(LJsonEndereco) then
    begin
      if not Assigned(Result.Endereco) then
        Result.Endereco := TEndereco.Create;

      Result.Endereco.DsCep := LJsonEndereco.GetValue<string>('dscep', '');
    end;
  finally
    LJsonObj.Free;
  end;
end;

function JsonArrayToPessoas(const AJson: string): TObjectList<TPessoa>;
var
  LJsonArray: TJSONArray;
  I: Integer;
begin
  Result := TObjectList<TPessoa>.Create(True);

  LJsonArray := TJSONObject.ParseJSONValue(AJson) as TJSONArray;
  try
    if not Assigned(LJsonArray) then
      raise Exception.Create('JSON de lote inválido.');

    for I := 0 to LJsonArray.Count - 1 do
      Result.Add(JsonToPessoa(LJsonArray.Items[I].ToJSON));
  finally
    LJsonArray.Free;
  end;
end;

function PessoaToJson(APessoa: TPessoa): TJSONObject;
var
  LEnderecoJson: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('idpessoa', TJSONNumber.Create(APessoa.IdPessoa));
  Result.AddPair('flnatureza', TJSONNumber.Create(APessoa.FlNatureza));
  Result.AddPair('dsdocumento', APessoa.DsDocumento);
  Result.AddPair('nmprimeiro', APessoa.NmPrimeiro);
  Result.AddPair('nmsegundo', APessoa.NmSegundo);
  Result.AddPair('dtregistro', DateToISO8601(APessoa.DtRegistro));

  if Assigned(APessoa.Endereco) then
  begin
    LEnderecoJson := TJSONObject.Create;
    LEnderecoJson.AddPair('idendereco', TJSONNumber.Create(APessoa.Endereco.IdEndereco));
    LEnderecoJson.AddPair('idpessoa', TJSONNumber.Create(APessoa.Endereco.IdPessoa));
    LEnderecoJson.AddPair('dscep', APessoa.Endereco.DsCep);
    Result.AddPair('endereco', LEnderecoJson);
  end;
end;

function PessoasToJson(APessoas: TObjectList<TPessoa>): TJSONArray;
var
  LPessoa: TPessoa;
begin
  Result := TJSONArray.Create;

  for LPessoa in APessoas do
    Result.AddElement(PessoaToJson(LPessoa));
end;

function JsonSucesso(const AMensagem: string; AIdPessoa: Int64 = 0): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('sucesso', TJSONBool.Create(True));
  Result.AddPair('mensagem', AMensagem);

  if AIdPessoa > 0 then
    Result.AddPair('idpessoa', TJSONNumber.Create(AIdPessoa));
end;

procedure RegistrarRotasPessoa;
begin
  THorse.Post('/pessoas',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LPessoa: TPessoa;
      LService: TPessoaService;
      LJsonRetorno: TJSONObject;
    begin
      LPessoa := nil;
      LService := nil;
      LJsonRetorno := nil;

      try
        LPessoa := JsonToPessoa(Req.Body);
        LService := TPessoaService.Create(TConexao.GetConnection);

        LService.Inserir(LPessoa);

        LJsonRetorno := JsonSucesso('Pessoa cadastrada com sucesso.', LPessoa.IdPessoa);

        Res
          .Status(201)
          .ContentType('application/json')
          .Send<TJSONObject>(LJsonRetorno);
      except
        on E: Exception do
        begin
          if Assigned(LJsonRetorno) then
            LJsonRetorno.Free;

          Res
            .Status(400)
            .ContentType('application/json')
            .Send(
              TJSONObject.Create
                .AddPair('sucesso', TJSONBool.Create(False))
                .AddPair('mensagem', E.Message)
            );
        end;
      end;

      LService.Free;
      LPessoa.Free;
    end
  );

  THorse.Put('/pessoas/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LPessoa: TPessoa;
      LService: TPessoaService;
      LJsonRetorno: TJSONObject;
    begin
      LPessoa := nil;
      LService := nil;
      LJsonRetorno := nil;

      try
        LPessoa := JsonToPessoa(Req.Body);
        LPessoa.IdPessoa := StrToInt64Def(Req.Params['id'], 0);

        LService := TPessoaService.Create(TConexao.GetConnection);
        LService.Alterar(LPessoa);

        LJsonRetorno := JsonSucesso('Pessoa alterada com sucesso.', LPessoa.IdPessoa);

        Res
          .Status(200)
          .ContentType('application/json')
          .Send<TJSONObject>(LJsonRetorno);
      except
        on E: Exception do
        begin
          if Assigned(LJsonRetorno) then
            LJsonRetorno.Free;

          Res
            .Status(400)
            .ContentType('application/json')
            .Send(
              TJSONObject.Create
                .AddPair('sucesso', TJSONBool.Create(False))
                .AddPair('mensagem', E.Message)
            );
        end;
      end;

      LService.Free;
      LPessoa.Free;
    end
  );

  THorse.Delete('/pessoas/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LService: TPessoaService;
      LIdPessoa: Int64;
      LJsonRetorno: TJSONObject;
    begin
      LService := nil;
      LJsonRetorno := nil;

      try
        LIdPessoa := StrToInt64Def(Req.Params['id'], 0);

        LService := TPessoaService.Create(TConexao.GetConnection);
        LService.Excluir(LIdPessoa);

        LJsonRetorno := JsonSucesso('Pessoa excluída com sucesso.', LIdPessoa);

        Res
          .Status(200)
          .ContentType('application/json')
          .Send<TJSONObject>(LJsonRetorno);
      except
        on E: Exception do
        begin
          if Assigned(LJsonRetorno) then
            LJsonRetorno.Free;

          Res
            .Status(400)
            .ContentType('application/json')
            .Send(
              TJSONObject.Create
                .AddPair('sucesso', TJSONBool.Create(False))
                .AddPair('mensagem', E.Message)
            );
        end;
      end;

      LService.Free;
    end
  );

  THorse.Get('/pessoas/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LService: TPessoaService;
      LPessoa: TPessoa;
      LJson: TJSONObject;
    begin
      LService := nil;
      LPessoa := nil;
      LJson := nil;

      try
        LService := TPessoaService.Create(TConexao.GetConnection);
        LPessoa := LService.ObterPorId(StrToInt64Def(Req.Params['id'], 0));
        LJson := PessoaToJson(LPessoa);

        Res.Status(200).ContentType('application/json').Send(LJson.ToJSON);
      except
        on E: Exception do
        begin
          if Assigned(LJson) then
            LJson.Free;

          Res.Status(400).ContentType('application/json')
             .Send(TJSONObject.Create
               .AddPair('sucesso', TJSONBool.Create(False))
               .AddPair('mensagem', E.Message)
               .ToJSON);
        end;
      end;

      LJson.Free;
      LPessoa.Free;
      LService.Free;
    end
  );

  THorse.Get('/pessoas',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LService: TPessoaService;
      LPessoas: TObjectList<TPessoa>;
      LJson: TJSONArray;
    begin
      LService := nil;
      LPessoas := nil;
      LJson := nil;

      try
        LService := TPessoaService.Create(TConexao.GetConnection);
        LPessoas := LService.Listar;
        LJson := PessoasToJson(LPessoas);

        Res.Status(200).ContentType('application/json').Send(LJson.ToJSON);
      except
        on E: Exception do
        begin
          if Assigned(LJson) then
            LJson.Free;

          Res.Status(400).ContentType('application/json')
             .Send(TJSONObject.Create
               .AddPair('sucesso', TJSONBool.Create(False))
               .AddPair('mensagem', E.Message)
               .ToJSON);
        end;
      end;

      LJson.Free;
      LPessoas.Free;
      LService.Free;
    end
  );

  THorse.Post('/pessoas/lote',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LService: TPessoaService;
      LPessoas: TObjectList<TPessoa>;
      LJsonRetorno: TJSONObject;
    begin
      LService := nil;
      LPessoas := nil;
      LJsonRetorno := nil;

      try
        LPessoas := JsonArrayToPessoas(Req.Body);
        LService := TPessoaService.Create(TConexao.GetConnection);
        LService.InserirLote(LPessoas);

        LJsonRetorno := TJSONObject.Create;
        LJsonRetorno.AddPair('sucesso', TJSONBool.Create(True));
        LJsonRetorno.AddPair('mensagem', 'Lote processado com sucesso.');
        LJsonRetorno.AddPair('quantidade', TJSONNumber.Create(LPessoas.Count));

        Res.Status(201).ContentType('application/json').Send(LJsonRetorno.ToJSON);
      except
        on E: Exception do
        begin
          if Assigned(LJsonRetorno) then
            LJsonRetorno.Free;

          Res.Status(400).ContentType('application/json')
             .Send(TJSONObject.Create
               .AddPair('sucesso', TJSONBool.Create(False))
               .AddPair('mensagem', E.Message)
               .ToJSON);
        end;
      end;

      LJsonRetorno.Free;
      LPessoas.Free;
      LService.Free;
    end
  );
end;

end.

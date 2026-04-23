unit uPrincipal;

interface

uses
  System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB, Vcl.DBGrids,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Vcl.Grids;

type
  TFormPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    edtNmPrimeiro: TEdit;
    lblNmPrimeiro: TLabel;
    lblNmSegundo: TLabel;
    edtNmSegundo: TEdit;
    lblDsDocumento: TLabel;
    edtDsDocumento: TEdit;
    lblFlNatureza: TLabel;
    cboFlNatureza: TComboBox;
    lblDsCep: TLabel;
    edtDsCEP: TEdit;
    Panel3: TPanel;
    btnInserir: TButton;
    btnAlterar: TButton;
    btnExcluir: TButton;
    btnBuscar: TButton;
    btnListar: TButton;
    btnEnviarLote: TButton;
    btnIntegrarCEP: TButton;
    lblIdPessoa: TLabel;
    edtIdPessoa: TEdit;
    gpbConfig: TGroupBox;
    lblUrlAPI: TLabel;
    edtUrlAPI: TEdit;
    OpenDialog1: TOpenDialog;
    mtPessoas: TFDMemTable;
    dsPessoas: TDataSource;
    btnLimpar: TButton;
    gpbRetornoAPI: TGroupBox;
    memJSON: TMemo;
    gpbPessoas: TGroupBox;
    DBGrid: TDBGrid;
    procedure btnInserirClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure btnIntegrarCEPClick(Sender: TObject);
    procedure btnEnviarLoteClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure DBGridCellClick(Column: TColumn);
    procedure btnLimparClick(Sender: TObject);
  private
    function JsonEhErro(const AJson: string; out AMensagem: string): Boolean;

    procedure AjustarTitulosGrid;
    procedure CarregarCamposDoDataset;
    procedure CarregarJsonNoDataset(const AJson: string);
    procedure CarregarObjetoJsonNoDataSet(const AJson: string);
    procedure ConfigurarMemTablePessoas;
    procedure LimparTela();
    procedure ValidarCampos;
    procedure ValidarIdPessoa(AIdPessoa: Int64);

  public

  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  uPessoaApiService,
  System.SysUtils,
  System.JSON;

{$R *.dfm}

procedure TFormPrincipal.AjustarTitulosGrid;
begin
  if DBGrid.Columns.Count = 0 then
    Exit;

  DBGrid.Columns[0].Title.Caption := 'ID';
  DBGrid.Columns[1].Title.Caption := 'Natureza';
  DBGrid.Columns[2].Title.Caption := 'Documento';
  DBGrid.Columns[3].Title.Caption := 'Primeiro Nome';
  DBGrid.Columns[4].Title.Caption := 'Segundo Nome';
  DBGrid.Columns[5].Title.Caption := 'Data Registro';
  DBGrid.Columns[6].Title.Caption := 'CEP';
end;

procedure TFormPrincipal.btnAlterarClick(Sender: TObject);
var
  LService: TPessoaApiService;
  LJson: string;
  LIdPessoa: Int64;
begin
  try
    ValidarIdPessoa(StrToInt64Def(edtIdPessoa.Text, -1));
    ValidarCampos;

    LService := TPessoaApiService.Create(edtUrlAPI.Text);
    try
      LJson :=
        '{' +
        '"flnatureza": ' + (cboFlNatureza.ItemIndex + 1).ToString + ',' +
        '"dsdocumento": "' + edtDsDocumento.Text + '",' +
        '"nmprimeiro": "' + edtNmPrimeiro.Text + '",' +
        '"nmsegundo": "' + edtNmSegundo.Text + '",' +
        '"endereco": {' +
        '  "dscep": "' + edtDsCep.Text + '"' +
        '}' +
        '}';

      memJSON.Lines.Text := LService.Alterar(StrToInt64(edtIdPessoa.Text), LJson);
    finally
      LService.Free;
    end;

    ShowMessage('Pessoa alterada com sucesso.');
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TFormPrincipal.btnBuscarClick(Sender: TObject);
var
  LService: TPessoaApiService;
  LJson: string;
  LMsgErro: string;
  LIdPessoa: Int64;
begin
  try
    ValidarIdPessoa(StrToInt64Def(edtIdPessoa.Text, -1));

    LService := TPessoaApiService.Create(edtUrlAPI.Text);
    try
      LJson := LService.ObterPorId(StrToInt64(edtIdPessoa.Text));
      memJSON.Lines.Text := LJson;

      if JsonEhErro(LJson, LMsgErro) then
      begin
        ShowMessage(LMsgErro);
        Exit;
      end;

      CarregarObjetoJsonNoDataSet(LJson);

    finally
      LService.Free;
    end;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TFormPrincipal.btnEnviarLoteClick(Sender: TObject);
var
  LService: TPessoaApiService;
  LJson: TStringList;
begin
  if not OpenDialog1.Execute then
    Exit;

  LJson := TStringList.Create;
  LService := TPessoaApiService.Create(edtUrlAPI.Text);
  try
    LJson.LoadFromFile(OpenDialog1.FileName, TEncoding.UTF8);
    memJSON.Lines.Text := LService.InserirLote(LJson.Text);
  finally
    LService.Free;
    LJson.Free;
  end;
end;

procedure TFormPrincipal.btnExcluirClick(Sender: TObject);
var
  LService: TPessoaApiService;
begin
  try
    ValidarIdPessoa(StrToInt64Def(edtIdPessoa.Text, -1));

    if MessageDlg('Deseja realmente excluir a pessoa?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

    LService := TPessoaApiService.Create(edtUrlAPI.Text);
    try
      memJSON.Lines.Text := LService.Excluir(StrToInt64(edtIdPessoa.Text));
    finally
      LService.Free;
    end;

    ShowMessage('Pessoa excluída com sucesso.');

    LimparTela;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TFormPrincipal.btnInserirClick(Sender: TObject);
var
  LService: TPessoaApiService;
  LJson: string;
begin
  ValidarCampos;

  LService := TPessoaApiService.Create(edtUrlAPI.Text);
  try
    LJson :=
      '{' +
      '"flnatureza": ' + (cboFlNatureza.ItemIndex + 1).ToString + ',' +
      '"dsdocumento": "' + edtDsDocumento.Text + '",' +
      '"nmprimeiro": "' + edtNmPrimeiro.Text + '",' +
      '"nmsegundo": "' + edtNmSegundo.Text + '",' +
      '"dtregistro": "' + FormatDateTime('yyyy-mm-dd', Date) + '",' +
      '"endereco": {' +
      '  "dscep": "' + edtDsCep.Text + '"' +
      '}' +
      '}';

    memJSON.Lines.Text := LService.Inserir(LJson);
  finally
    LService.Free;
  end;
end;

procedure TFormPrincipal.btnIntegrarCEPClick(Sender: TObject);
var
  LService: TPessoaApiService;
begin
  LService := TPessoaApiService.Create(edtUrlAPI.Text);
  try
    memJSON.Lines.Text := LService.IntegrarCeps;
  finally
    LService.Free;
  end;
end;

procedure TFormPrincipal.btnLimparClick(Sender: TObject);
begin
  ConfigurarMemTablePessoas;
  memJSON.Lines.Clear;
  LimparTela;
end;

procedure TFormPrincipal.btnListarClick(Sender: TObject);
var
  LService: TPessoaApiService;
  LJson: string;
begin
  try
    LService := TPessoaApiService.Create(edtUrlAPI.Text);
    try
      LJson := LService.Listar;
      memJSON.Lines.Text := LJson;
      CarregarJsonNoDataset(LJson);
      AjustarTitulosGrid;
    finally
      LService.Free;
    end;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TFormPrincipal.CarregarCamposDoDataset;
begin
  if mtPessoas.IsEmpty then
    Exit;

  edtIdPessoa.Text := mtPessoas.FieldByName('idpessoa').AsString;
  cboFlNatureza.ItemIndex := mtPessoas.FieldByName('flnatureza').AsInteger -1;
  edtDsDocumento.Text := mtPessoas.FieldByName('dsdocumento').AsString;
  edtNmPrimeiro.Text := mtPessoas.FieldByName('nmprimeiro').AsString;
  edtNmSegundo.Text := mtPessoas.FieldByName('nmsegundo').AsString;
  edtDsCep.Text := mtPessoas.FieldByName('dscep').AsString;
end;

procedure TFormPrincipal.CarregarJsonNoDataset(const AJson: string);
var
  LJsonArray: TJSONArray;
  LJsonObj: TJSONObject;
  LJsonEndereco: TJSONObject;
  I: Integer;
begin
  ConfigurarMemTablePessoas;
  mtPessoas.DisableControls;
  try
    mtPessoas.EmptyDataSet;

    LJsonArray := TJSONObject.ParseJSONValue(AJson) as TJSONArray;
    try
      if not Assigned(LJsonArray) then
        raise Exception.Create('JSON inválido para carga da grid.');

      for I := 0 to LJsonArray.Count - 1 do
      begin
        LJsonObj := LJsonArray.Items[I] as TJSONObject;
        if not Assigned(LJsonObj) then
          Continue;

        mtPessoas.Append;
        mtPessoas.FieldByName('idpessoa').AsLargeInt := LJsonObj.GetValue<Int64>('idpessoa', 0);
        mtPessoas.FieldByName('flnatureza').AsInteger := LJsonObj.GetValue<Integer>('flnatureza', 0);
        mtPessoas.FieldByName('dsdocumento').AsString := LJsonObj.GetValue<string>('dsdocumento', '');
        mtPessoas.FieldByName('nmprimeiro').AsString := LJsonObj.GetValue<string>('nmprimeiro', '');
        mtPessoas.FieldByName('nmsegundo').AsString := LJsonObj.GetValue<string>('nmsegundo', '');
        mtPessoas.FieldByName('dtregistro').AsString := LJsonObj.GetValue<string>('dtregistro', '');

        LJsonEndereco := LJsonObj.GetValue<TJSONObject>('endereco');
        if Assigned(LJsonEndereco) then
          mtPessoas.FieldByName('dscep').AsString :=
            LJsonEndereco.GetValue<string>('dscep', '')
        else
          mtPessoas.FieldByName('dscep').AsString := '';

        mtPessoas.Post;
      end;
    finally
      LJsonArray.Free;
    end;
  finally
    mtPessoas.EnableControls;
  end;
end;

procedure TFormPrincipal.CarregarObjetoJsonNoDataSet(const AJson: string);
var
  LObj: TJSONObject;
  LEndereco: TJSONObject;
begin
  if not mtPessoas.Active then
    ConfigurarMemTablePessoas;

  mtPessoas.DisableControls;
  try
    mtPessoas.EmptyDataSet;

    LObj := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
    try
      if not Assigned(LObj) then
        raise Exception.Create('JSON inválido.');

      mtPessoas.Append;
      mtPessoas.FieldByName('idpessoa').AsLargeInt := LObj.GetValue<Int64>('idpessoa', 0);
      mtPessoas.FieldByName('flnatureza').AsInteger := LObj.GetValue<Integer>('flnatureza', 0);
      mtPessoas.FieldByName('dsdocumento').AsString := LObj.GetValue<string>('dsdocumento', '');
      mtPessoas.FieldByName('nmprimeiro').AsString := LObj.GetValue<string>('nmprimeiro', '');
      mtPessoas.FieldByName('nmsegundo').AsString := LObj.GetValue<string>('nmsegundo', '');
      mtPessoas.FieldByName('dtregistro').AsString := LObj.GetValue<string>('dtregistro', '');

      LEndereco := LObj.GetValue<TJSONObject>('endereco');
      if Assigned(LEndereco) then
      begin
        if mtPessoas.FindField('idendereco') <> nil then
          mtPessoas.FieldByName('idendereco').AsLargeInt :=
            LEndereco.GetValue<Int64>('idendereco', 0);

        if mtPessoas.FindField('dscep') <> nil then
          mtPessoas.FieldByName('dscep').AsString :=
            LEndereco.GetValue<string>('dscep', '');
      end
      else
      begin
        if mtPessoas.FindField('idendereco') <> nil then
          mtPessoas.FieldByName('idendereco').Clear;

        if mtPessoas.FindField('dscep') <> nil then
          mtPessoas.FieldByName('dscep').Clear;
      end;

      mtPessoas.Post;
    finally
      LObj.Free;
    end;
  finally
    mtPessoas.EnableControls;
  end;
end;

procedure TFormPrincipal.ConfigurarMemTablePessoas;
begin
  mtPessoas.Close;
  mtPessoas.FieldDefs.Clear;

  mtPessoas.FieldDefs.Add('idpessoa', ftLargeint);
  mtPessoas.FieldDefs.Add('flnatureza', ftInteger);
  mtPessoas.FieldDefs.Add('dsdocumento', ftString, 20);
  mtPessoas.FieldDefs.Add('nmprimeiro', ftString, 100);
  mtPessoas.FieldDefs.Add('nmsegundo', ftString, 100);
  mtPessoas.FieldDefs.Add('dtregistro', ftString, 10);
  mtPessoas.FieldDefs.Add('dscep', ftString, 15);

  mtPessoas.CreateDataSet;
end;

procedure TFormPrincipal.DBGridCellClick(Column: TColumn);
begin
  CarregarCamposDoDataset;
end;

function TFormPrincipal.JsonEhErro(const AJson: string; out AMensagem: string): Boolean;
var
  LObj: TJSONObject;
  LSucesso: Boolean;
begin
  Result := False;
  AMensagem := '';

  LObj := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
  try
    if not Assigned(LObj) then
      Exit;

    if LObj.TryGetValue<Boolean>('sucesso', LSucesso) then
    begin
      if not LSucesso then
      begin
        AMensagem := LObj.GetValue<string>('mensagem', 'Erro desconhecido.');
        Result := True;
      end;
    end;
  finally
    LObj.Free;
  end;
end;

procedure TFormPrincipal.LimparTela;
begin
  edtIdPessoa.Clear;
  cboFlNatureza.ItemIndex := -1;
  edtDsDocumento.Clear;
  edtNmPrimeiro.Clear;
  edtNmSegundo.Clear;
  edtDsCep.Clear;
end;

procedure TFormPrincipal.ValidarCampos;
begin
   if (cboFlNatureza.ItemIndex = -1) then
   begin
    cboFlNatureza.SetFocus;
    raise Exception.Create('Informe a natureza.');
   end;

  if Trim(edtDsDocumento.Text) = EmptyStr then
  begin
    edtDsDocumento.SetFocus;
    raise Exception.Create('Informe o documento.');
  end;

  if Trim(edtNmPrimeiro.Text) = EmptyStr then
  begin
    edtNmPrimeiro.SetFocus;
    raise Exception.Create('Informe o primeiro nome.');
  end;

  if Trim(edtNmSegundo.Text) = EmptyStr then
  begin
    edtNmSegundo.SetFocus;
    raise Exception.Create('Informe o segundo nome.');
  end;

  if Trim(edtDsCep.Text) = EmptyStr then
  begin
    edtDsCep.SetFocus;
    raise Exception.Create('Informe o CEP.');
  end;

  if Length(edtDsCep.Text) <> 8 then
  begin
    edtDsCep.SetFocus;
    raise Exception.Create('CEP deve conter 8 dígitos.');
  end;
end;

procedure TFormPrincipal.ValidarIdPessoa(AIdPessoa: Int64);
begin
  if AIdPessoa = -1 then
  begin
    edtIdPessoa.SetFocus;
    raise Exception.Create('Informe o ID da pessoa ou ID da pessoa inválido.');
  end;
end;

end.

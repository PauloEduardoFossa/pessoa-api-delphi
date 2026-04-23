object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'PessoaClient'
  ClientHeight = 619
  ClientWidth = 705
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 57
    Width = 705
    Height = 136
    Align = alTop
    TabOrder = 1
    object lblNmPrimeiro: TLabel
      Left = 40
      Top = 70
      Width = 84
      Height = 15
      Caption = 'Primeiro Nome:'
    end
    object lblNmSegundo: TLabel
      Left = 40
      Top = 100
      Width = 86
      Height = 15
      Caption = 'Segundo Nome:'
    end
    object lblDsDocumento: TLabel
      Left = 280
      Top = 40
      Width = 66
      Height = 15
      Caption = 'Documento:'
    end
    object lblFlNatureza: TLabel
      Left = 280
      Top = 70
      Width = 50
      Height = 15
      Caption = 'Natureza:'
    end
    object lblDsCep: TLabel
      Left = 280
      Top = 100
      Width = 24
      Height = 15
      Caption = 'CEP:'
    end
    object lblIdPessoa: TLabel
      Left = 40
      Top = 40
      Width = 53
      Height = 15
      Caption = 'ID Pessoa:'
    end
    object edtNmPrimeiro: TEdit
      Left = 135
      Top = 67
      Width = 121
      Height = 23
      TabOrder = 1
    end
    object edtNmSegundo: TEdit
      Left = 135
      Top = 97
      Width = 121
      Height = 23
      TabOrder = 2
    end
    object edtDsDocumento: TEdit
      Left = 375
      Top = 37
      Width = 121
      Height = 23
      TabOrder = 3
    end
    object cboFlNatureza: TComboBox
      Left = 375
      Top = 67
      Width = 121
      Height = 23
      Style = csDropDownList
      TabOrder = 4
      Items.Strings = (
        '1 - F'#237'sica'
        '2 - Jur'#237'dica')
    end
    object edtDsCEP: TEdit
      Left = 375
      Top = 97
      Width = 121
      Height = 23
      NumbersOnly = True
      TabOrder = 5
    end
    object edtIdPessoa: TEdit
      Left = 135
      Top = 37
      Width = 121
      Height = 23
      NumbersOnly = True
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 570
    Width = 705
    Height = 49
    Align = alBottom
    TabOrder = 2
    object btnInserir: TButton
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 75
      Height = 37
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Inserir'
      TabOrder = 0
      OnClick = btnInserirClick
    end
    object btnAlterar: TButton
      AlignWithMargins = True
      Left = 91
      Top = 6
      Width = 75
      Height = 37
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Alterar'
      TabOrder = 1
      OnClick = btnAlterarClick
    end
    object btnExcluir: TButton
      AlignWithMargins = True
      Left = 176
      Top = 6
      Width = 75
      Height = 37
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Excluir'
      TabOrder = 2
      OnClick = btnExcluirClick
    end
    object btnBuscar: TButton
      AlignWithMargins = True
      Left = 261
      Top = 6
      Width = 75
      Height = 37
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Buscar'
      TabOrder = 3
      OnClick = btnBuscarClick
    end
    object btnListar: TButton
      AlignWithMargins = True
      Left = 346
      Top = 6
      Width = 75
      Height = 37
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Listar'
      TabOrder = 4
      OnClick = btnListarClick
    end
    object btnEnviarLote: TButton
      AlignWithMargins = True
      Left = 431
      Top = 6
      Width = 75
      Height = 37
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Enviar Lote'
      TabOrder = 5
      OnClick = btnEnviarLoteClick
    end
    object btnIntegrarCEP: TButton
      AlignWithMargins = True
      Left = 516
      Top = 6
      Width = 75
      Height = 37
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Integrar CEP'
      TabOrder = 6
      OnClick = btnIntegrarCEPClick
    end
    object btnLimpar: TButton
      AlignWithMargins = True
      Left = 601
      Top = 6
      Width = 75
      Height = 37
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Limpar'
      TabOrder = 7
      OnClick = btnLimparClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 193
    Width = 705
    Height = 377
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object gpbRetornoAPI: TGroupBox
      Left = 0
      Top = 0
      Width = 705
      Height = 105
      Align = alTop
      Caption = ' Retorno API '
      TabOrder = 0
      object memJSON: TMemo
        Left = 2
        Top = 17
        Width = 701
        Height = 144
        Align = alTop
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object gpbPessoas: TGroupBox
      Left = 0
      Top = 105
      Width = 705
      Height = 272
      Align = alClient
      Caption = ' Pessoas Cadastradas '
      TabOrder = 1
      object DBGrid: TDBGrid
        Left = 2
        Top = 17
        Width = 701
        Height = 253
        Align = alClient
        DataSource = dsPessoas
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnCellClick = DBGridCellClick
      end
    end
  end
  object gpbConfig: TGroupBox
    Left = 0
    Top = 0
    Width = 705
    Height = 57
    Align = alTop
    Caption = ' Configura'#231#227'o '
    TabOrder = 0
    object lblUrlAPI: TLabel
      Left = 40
      Top = 25
      Width = 45
      Height = 15
      Caption = 'URL API:'
    end
    object edtUrlAPI: TEdit
      Left = 135
      Top = 22
      Width = 361
      Height = 23
      TabOrder = 0
      Text = 'http://localhost:9000/'
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 528
    Top = 88
  end
  object mtPessoas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 312
    Top = 384
  end
  object dsPessoas: TDataSource
    DataSet = mtPessoas
    Left = 392
    Top = 384
  end
end

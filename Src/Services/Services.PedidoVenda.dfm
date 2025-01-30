inherited ServicePedidoVenda: TServicePedidoVenda
  Height = 340
  Width = 377
  object qryCliente: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT '
      '  `c`.`codigo`,'
      '  `c`.`nome`,'
      '  `c`.`cidade`,'
      '  `c`.`uf`'
      'FROM'
      '  `clientes` `c`'
      'WHERE'
      '  `c`.`codigo` = :cod')
    Left = 40
    Top = 208
    ParamData = <
      item
        Name = 'COD'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object qryClientecodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object qryClientenome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 255
    end
    object qryClientecidade: TStringField
      FieldName = 'cidade'
      Origin = 'cidade'
      Required = True
      Size = 255
    end
    object qryClienteuf: TStringField
      FieldName = 'uf'
      Origin = 'uf'
      Required = True
      Size = 2
    end
  end
  object qryProduto: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT '
      '  `p`.`codigo`,'
      '  `p`.`descricao`,'
      '  `p`.`preco_venda`'
      'FROM'
      '  `produtos` `p`'
      'WHERE'
      '  p.`codigo` = :cod')
    Left = 112
    Top = 208
    ParamData = <
      item
        Name = 'COD'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryProdutocodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object qryProdutodescricao: TStringField
      FieldName = 'descricao'
      Origin = 'descricao'
      Required = True
      Size = 255
    end
    object qryProdutopreco_venda: TSingleField
      AutoGenerateValue = arDefault
      FieldName = 'preco_venda'
      Origin = 'preco_veenda'
    end
  end
  object qryPedido: TFDQuery
    AfterOpen = qryPedidoAfterOpen
    AfterClose = qryPedidoAfterClose
    Connection = FDConnection
    SQL.Strings = (
      'SELECT '
      '  `ped`.`numero_pedido`,'
      '  `ped`.`data_emissao`,'
      '  `ped`.`codigo_cliente`,'
      '  `ped`.`valor_total`'
      'FROM'
      '  `pedidos` `ped`'
      'WHERE'
      '  `ped`.`numero_pedido` IS NULL')
    Left = 184
    Top = 208
    object qryPedidonumero_pedido: TIntegerField
      FieldName = 'numero_pedido'
      Origin = 'numero_pedido'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryPedidodata_emissao: TDateTimeField
      FieldName = 'data_emissao'
      Origin = 'data_emissao'
      Required = True
    end
    object qryPedidocodigo_cliente: TIntegerField
      FieldName = 'codigo_cliente'
      Origin = 'codigo_cliente'
      Required = True
    end
    object qryPedidovalor_total: TSingleField
      AutoGenerateValue = arDefault
      FieldName = 'valor_total'
      Origin = 'valor_total'
    end
  end
  object qryPedidoProduto: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT '
      '  `pedprod`.`codigo`,'
      '  `pedprod`.`numero_pedido`,'
      '  `pedprod`.`codigo_produto`,'
      '  `pedprod`.`quantidade`,'
      '  `pedprod`.`valor_unitario`,'
      '  `pedprod`.`valor_total`'
      'FROM'
      '  `pedidos_produtos` `pedprod`'
      'WHERE'
      '  `pedprod`.`numero_pedido` = :nroPedido')
    Left = 272
    Top = 208
    ParamData = <
      item
        Name = 'NROPEDIDO'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object qryPedidoProdutocodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object qryPedidoProdutonumero_pedido: TIntegerField
      FieldName = 'numero_pedido'
      Origin = 'numero_pedido'
      Required = True
    end
    object qryPedidoProdutocodigo_produto: TIntegerField
      FieldName = 'codigo_produto'
      Origin = 'codigo_produto'
      Required = True
    end
    object qryPedidoProdutoquantidade: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'quantidade'
      Origin = 'quantidade'
    end
    object qryPedidoProdutovalor_unitario: TSingleField
      AutoGenerateValue = arDefault
      FieldName = 'valor_unitario'
      Origin = 'valor_unitario'
    end
    object qryPedidoProdutovalor_total: TSingleField
      AutoGenerateValue = arDefault
      FieldName = 'valor_total'
      Origin = 'valor_total'
    end
  end
  object FDMemTable: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale]
    FormatOptions.MaxBcdPrecision = 2147483647
    FormatOptions.MaxBcdScale = 1073741823
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 272
    Top = 280
    object FDMemTablecodigo_produto: TIntegerField
      FieldName = 'codigo_produto'
      Required = True
    end
    object FDMemTabledescricao_produto: TStringField
      FieldName = 'descricao_produto'
      Size = 255
    end
    object FDMemTablequantidade: TIntegerField
      FieldName = 'quantidade'
    end
    object FDMemTablevalor_unitario: TSingleField
      FieldName = 'valor_unitario'
      DisplayFormat = ',0.00'
    end
    object FDMemTablevalor_total: TSingleField
      FieldName = 'valor_total'
      DisplayFormat = ',0.00'
    end
  end
  object qryCarregaPedido: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT '
      '  `ped`.`numero_pedido`,'
      '  `ped`.`data_emissao`,'
      '  `ped`.`codigo_cliente`,'
      '  `ped`.`valor_total`,'
      '  `pedprod`.`codigo`,'
      '  `pedprod`.`codigo_produto`,'
      '  `pedprod`.`quantidade`,'
      '  `pedprod`.`valor_unitario`,'
      '  `pedprod`.`valor_total` as valor_total_item,'
      '  `c`.`nome`,'
      '  `p`.`descricao`'
      'FROM'
      '  `pedidos` `ped`'
      '  INNER JOIN `clientes` `c` '
      '    ON (`ped`.`codigo_cliente` = `c`.`codigo`)'
      '  INNER JOIN `pedidos_produtos` `pedprod` '
      '    ON (`ped`.`numero_pedido` = `pedprod`.`numero_pedido`)'
      '  INNER JOIN `produtos` `p` '
      '    ON (`pedprod`.`codigo_produto` = `p`.`codigo`)'
      ''
      'WHERE'
      '  `ped`.`numero_pedido` = :nroPedido'
      ''
      'ORDER BY'
      '  `pedprod`.`codigo`')
    Left = 40
    Top = 280
    ParamData = <
      item
        Position = 1
        Name = 'NROPEDIDO'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object qryCarregaPedidonumero_pedido: TIntegerField
      FieldName = 'numero_pedido'
      Origin = 'numero_pedido'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryCarregaPedidodata_emissao: TDateTimeField
      FieldName = 'data_emissao'
      Origin = 'data_emissao'
      Required = True
    end
    object qryCarregaPedidocodigo_cliente: TIntegerField
      FieldName = 'codigo_cliente'
      Origin = 'codigo_cliente'
      Required = True
    end
    object qryCarregaPedidovalor_total: TSingleField
      AutoGenerateValue = arDefault
      FieldName = 'valor_total'
      Origin = 'valor_total'
    end
    object qryCarregaPedidocodigo: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCarregaPedidocodigo_produto: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'codigo_produto'
      Origin = 'codigo_produto'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCarregaPedidoquantidade: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'quantidade'
      Origin = 'quantidade'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCarregaPedidovalor_unitario: TSingleField
      AutoGenerateValue = arDefault
      FieldName = 'valor_unitario'
      Origin = 'valor_unitario'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCarregaPedidovalor_total_item: TSingleField
      AutoGenerateValue = arDefault
      FieldName = 'valor_total_item'
      Origin = 'valor_total'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryCarregaPedidonome: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome'
      Origin = 'nome'
      ProviderFlags = []
      ReadOnly = True
      Size = 255
    end
    object qryCarregaPedidodescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'descricao'
      Origin = 'descricao'
      ProviderFlags = []
      ReadOnly = True
      Size = 255
    end
  end
end

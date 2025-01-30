unit Services.PedidoVenda;

interface

uses
  System.SysUtils, System.Classes, Providers.Connection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Stan.StorageBin;

type
  TServicePedidoVenda = class(TProviderConnection)
    qryCliente: TFDQuery;
    qryClientecodigo: TFDAutoIncField;
    qryClientenome: TStringField;
    qryClientecidade: TStringField;
    qryClienteuf: TStringField;
    qryProduto: TFDQuery;
    qryProdutocodigo: TFDAutoIncField;
    qryProdutodescricao: TStringField;
    qryProdutopreco_venda: TSingleField;
    qryPedido: TFDQuery;
    qryPedidoProduto: TFDQuery;
    FDMemTable: TFDMemTable;
    FDMemTablecodigo_produto: TIntegerField;
    FDMemTablequantidade: TIntegerField;
    FDMemTablevalor_unitario: TSingleField;
    FDMemTablevalor_total: TSingleField;
    FDMemTabledescricao_produto: TStringField;
    qryPedidonumero_pedido: TIntegerField;
    qryPedidodata_emissao: TDateTimeField;
    qryPedidocodigo_cliente: TIntegerField;
    qryPedidovalor_total: TSingleField;
    qryPedidoProdutocodigo: TFDAutoIncField;
    qryPedidoProdutonumero_pedido: TIntegerField;
    qryPedidoProdutocodigo_produto: TIntegerField;
    qryPedidoProdutoquantidade: TIntegerField;
    qryPedidoProdutovalor_unitario: TSingleField;
    qryPedidoProdutovalor_total: TSingleField;
    qryCarregaPedido: TFDQuery;
    qryCarregaPedidonumero_pedido: TIntegerField;
    qryCarregaPedidodata_emissao: TDateTimeField;
    qryCarregaPedidocodigo_cliente: TIntegerField;
    qryCarregaPedidovalor_total: TSingleField;
    qryCarregaPedidocodigo: TIntegerField;
    qryCarregaPedidocodigo_produto: TIntegerField;
    qryCarregaPedidoquantidade: TIntegerField;
    qryCarregaPedidovalor_unitario: TSingleField;
    qryCarregaPedidovalor_total_item: TSingleField;
    qryCarregaPedidonome: TStringField;
    qryCarregaPedidodescricao: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure qryPedidoAfterClose(DataSet: TDataSet);
    procedure qryPedidoAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetCliente(ACodigo: Integer): TFDQuery;
    function GetProduto(ACodigo: Integer): TFDQuery;
    function AddItem(Codigo, Descricao, Qtde, VlrUnit: string): Boolean;
    function GetTotalPedido: Double;
    function GetNumeroPedidoSeq: Integer;
    procedure LimpaPedidoTmp;
    function GravarPedido: Boolean;
    function CarregarPedido(ANumPedido: Integer): TFDQuery;
    function CancelarPedido(ANumPedido: Integer): Boolean;
    procedure CarregaPedidoProduto;
  end;

  implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Providers.Util;

{$R *.dfm}

{ TServicePedidoVenda }

function TServicePedidoVenda.AddItem(Codigo, Descricao, Qtde,
  VlrUnit: string): Boolean;
begin
  if not (FDMemTable.State in [dsEdit, dsInsert]) then
    FDMemTable.Append;
  FDMemTablecodigo_produto.Value := Codigo.ToInteger;
  FDMemTabledescricao_produto.Value := Descricao;
  FDMemTablequantidade.Value := Qtde.ToInteger;
  FDMemTablevalor_unitario.Value := VlrUnit.ToDouble;
  FDMemTablevalor_total.Value := (VlrUnit.ToDouble * Qtde.ToInteger);
  FDMemTable.Post;
end;

function TServicePedidoVenda.CancelarPedido(ANumPedido: Integer): Boolean;
const
  SQL_DEL_PED = 'DELETE FROM `pedidos` WHERE `pedidos`.`numero_pedido` = %d';
  SQL_DEL_PED_PROD = 'DELETE FROM `pedidos_produtos` WHERE `pedidos_produtos`.`numero_pedido` = %d';
begin
  Result := False;

  FDConnection.TxOptions.AutoCommit := False;
  FDConnection.StartTransaction;
  try
    FDConnection.ExecSQL(Format(SQL_DEL_PED_PROD, [ANumPedido]));
    FDConnection.ExecSQL(Format(SQL_DEL_PED, [ANumPedido]));
    FDConnection.Commit;

    Result := True;
  except
    On E: Exception do
    begin
      FDConnection.Rollback;
      TProviderUtil.Error('Ocorreu um erro ao cancelar o pedido.' +
        sLineBreak + 'Erro: ' + E.Message);
    end;
  end;

  FDConnection.Close;
end;

procedure TServicePedidoVenda.CarregaPedidoProduto;
begin
  LimpaPedidoTmp;

  qryCarregaPedido.First;
  while not qryCarregaPedido.Eof do
  begin
    FDMemTable.Append;
    FDMemTablecodigo_produto.Value := qryCarregaPedidocodigo_produto.Value;
    FDMemTabledescricao_produto.Value := qryCarregaPedidodescricao.Value;
    FDMemTablequantidade.Value := qryCarregaPedidoquantidade.Value;
    FDMemTablevalor_unitario.Value := qryCarregaPedidovalor_unitario.Value;
    FDMemTablevalor_total.Value := qryCarregaPedidovalor_total.Value;
    FDMemTable.Post;

    qryCarregaPedido.Next;
  end;
end;

function TServicePedidoVenda.CarregarPedido(ANumPedido: Integer): TFDQuery;
begin
  if qryCarregaPedido.Active then
    qryCarregaPedido.Close;
  qryCarregaPedido.Params[0].AsInteger := ANumPedido;
  qryCarregaPedido.Open;

  Result := qryCarregaPedido;
end;

procedure TServicePedidoVenda.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FDMemTable.CreateDataSet;
end;

function TServicePedidoVenda.GetCliente(ACodigo: Integer): TFDQuery;
begin
  if qryCliente.Active then
    qryCliente.Close;
  qryCliente.ParamByName('cod').AsInteger := ACodigo;
  qryCliente.Open;

  Result := qryCliente;
end;

function TServicePedidoVenda.GetNumeroPedidoSeq: Integer;
var
  LSQL: string;
  LQuery: TFDQuery;
begin
  LSQL :=
    ' SELECT' +
    '   COALESCE(MAX(`p`.`numero_pedido`), 0) + 1' +
    ' FROM' +
    '   `pedidos` `p`';

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FDConnection;
    LQuery.Open(LSQL);
    Result := LQuery.Fields[0].AsInteger;
  finally
    FreeAndNil(LQuery);
  end;
end;

function TServicePedidoVenda.GetProduto(ACodigo: Integer): TFDQuery;
begin
  if qryProduto.Active then
    qryProduto.Close;
  qryProduto.ParamByName('cod').AsInteger := ACodigo;
  qryProduto.Open;

  Result := qryProduto;
end;

function TServicePedidoVenda.GetTotalPedido: Double;
begin
  Result := 0;
  //--

  FDMemTable.DisableControls;
  try
    FDMemTable.First;
    while not FDMemTable.Eof do
    begin
      Result := Result + FDMemTablevalor_total.Value;
      FDMemTable.Next;
    end;
  finally
    FDMemTable.EnableControls;
  end;
end;

function TServicePedidoVenda.GravarPedido: Boolean;
begin
  Result := False;

  if qryPedido.Active then
    qryPedido.Close;
  qryPedido.Open;

  FDMemTable.DisableControls;
  try
    FDConnection.TxOptions.AutoCommit := False;
    FDConnection.StartTransaction;
    try
      qryPedido.Insert;
      qryPedidonumero_pedido.Value := GetNumeroPedidoSeq;
      qryPedidodata_emissao.Value := Now;
      qryPedidocodigo_cliente.Value := qryClientecodigo.Value;
      qryPedidovalor_total.Value := GetTotalPedido;
      qryPedido.Post;

      FDMemTable.First;
      while not FDMemTable.Eof do
      begin
        qryPedidoProduto.Insert;
        qryPedidoProdutonumero_pedido.Value := qryPedidonumero_pedido.Value;
        qryPedidoProdutocodigo_produto.Value := FDMemTablecodigo_produto.Value;
        qryPedidoProdutoquantidade.Value := FDMemTablequantidade.Value;
        qryPedidoProdutovalor_unitario.Value := FDMemTablevalor_unitario.Value;
        qryPedidoProdutovalor_total.Value := FDMemTablevalor_total.Value;
        qryPedidoProduto.Post;

        FDMemTable.Next;
      end;

      FDConnection.Commit;
      Result := True;
    except
      On E: Exception do
      begin
        FDConnection.Rollback;
        TProviderUtil.Error('Ocorreu um erro ao gravar o pedido no banco dados.' +
          sLineBreak + 'Erro: ' + E.Message);
      end;
    end;

  finally
    FDMemTable.EnableControls;
  end;
end;

procedure TServicePedidoVenda.LimpaPedidoTmp;
begin
  while (FDMemTable.RecordCount > 0) do
    FDMemTable.Delete;
end;

procedure TServicePedidoVenda.qryPedidoAfterClose(DataSet: TDataSet);
begin
  inherited;
  qryPedidoProduto.Close;
end;

procedure TServicePedidoVenda.qryPedidoAfterOpen(DataSet: TDataSet);
begin
  inherited;
  qryPedidoProduto.ParamByName('NROPEDIDO').AsInteger := qryPedidonumero_pedido.Value;
  qryPedidoProduto.Open;
end;

end.

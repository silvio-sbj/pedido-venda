unit Views.PedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons,
  Vcl.DBCtrls, Vcl.Imaging.pngimage, Providers.Connection, Services.PedidoVenda;

type
  TMain = class(TForm)
    shpCodCliente: TShape;
    lblCodCiente: TLabel;
    edtCodCliente: TEdit;
    lblCliente: TLabel;
    shpCliente: TShape;
    edtCliente: TEdit;
    Bevel1: TBevel;
    shpCodProduto: TShape;
    lblCodProduto: TLabel;
    edtCodProduto: TEdit;
    lblProduto: TLabel;
    shpProduto: TShape;
    edtProduto: TEdit;
    shpQuantidade: TShape;
    lblQuantidade: TLabel;
    shpValorUnitario: TShape;
    lblPrecoVenda: TLabel;
    edtValorUnitario: TEdit;
    shpTotalItem: TShape;
    lblTotalItem: TLabel;
    edtTotalItem: TEdit;
    grdLista: TDBGrid;
    lblLista: TLabel;
    edtQuantidade: TEdit;
    shpLista: TShape;
    shpLista2: TShape;
    shpLista3: TShape;
    btnAdicionar: TButton;
    imgLogo: TImage;
    Bevel2: TBevel;
    shpTotalPedido: TShape;
    lblTotalPedido: TLabel;
    edtTotalPedido: TEdit;
    btnGravarPedido: TButton;
    DataSource: TDataSource;
    Bevel3: TBevel;
    btnCarregarPedido: TButton;
    btnCancelarPedido: TButton;
    procedure FormShow(Sender: TObject);
    procedure edtCodClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure grdListaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdListaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure edtCodClienteChange(Sender: TObject);
    procedure btnCarregarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
  private
    { Private declarations }
    FService: TProviderConnection;
    procedure InitForm;
    function ItemOK: Boolean;
    procedure LimpaItem;
    procedure CarregaItem;
    function CarregarPedido(ANumPedido: Integer): Boolean;
    function CarregouPedido: Boolean;
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses
  Providers.Util;

{ TMain }

procedure TMain.btnAdicionarClick(Sender: TObject);
begin
  if CarregouPedido then
  begin
    TProviderUtil.Error('O pedido não pode ser modificado');
    InitForm;
    (FService as TServicePedidoVenda).LimpaPedidoTmp;
    (FService as TServicePedidoVenda).qryCarregaPedido.Close;
    Exit;
  end;

  if (edtCodCliente.Text = '') then
  begin
    edtCodCliente.SetFocus;
    raise Exception.Create('O cliente não foi selecionado');
  end;

  if ItemOK then
    if (FService as TServicePedidoVenda).AddItem(
      edtCodProduto.Text, edtProduto.Text, edtQuantidade.Text, edtValorUnitario.Text) then
    begin
      edtTotalPedido.Text := FormatFloat(',0.00', (FService as TServicePedidoVenda).GetTotalPedido);
      LimpaItem;
    end;
end;

procedure TMain.btnCancelarPedidoClick(Sender: TObject);
var
  LNumPedido: string;
begin
  if InputQuery('WKTech', 'Informe o número do pedido:', LNumPedido) then
  begin
    try
      LNumPedido.ToInteger;
      if (FService as TServicePedidoVenda).CancelarPedido(LNumPedido.ToInteger) then
      begin
        TProviderUtil.Information('Operação realizada com sucesso');
        InitForm;
      end;
    except
      raise Exception.Create('Número inválido');
    end;
  end;
end;

procedure TMain.btnCarregarPedidoClick(Sender: TObject);
var
  LNumPedido: string;
begin
  if InputQuery('WKTech', 'Informe o número do pedido:', LNumPedido) then
  begin
    try
      LNumPedido.ToInteger;
      CarregarPedido(LNumPedido.ToInteger);
    except
      raise Exception.Create('Número inválido');
    end;
  end;
end;

procedure TMain.btnGravarPedidoClick(Sender: TObject);
begin
  if CarregouPedido then
  begin
    TProviderUtil.Error('O pedido não pode ser modificado');
    InitForm;
    (FService as TServicePedidoVenda).LimpaPedidoTmp;
    (FService as TServicePedidoVenda).qryCarregaPedido.Close;
    Exit;
  end;

  if (edtCodCliente.Text = '') then
  begin
    edtCodCliente.SetFocus;
    raise Exception.Create('O cliente não foi selecionado');
  end;

  if DataSource.DataSet.IsEmpty then
    raise Exception.Create('Não há produtos no pedido');

  if TProviderUtil.Confirmation('Finalizar pedido?') then
    if (FService as TServicePedidoVenda).GravarPedido then
    begin
      TProviderUtil.Information(
        Format('Operação realizada com sucesso.' + sLineBreak + 'Nro. Pedido: %.6d',
        [(FService as TServicePedidoVenda).qryPedidonumero_pedido.Value]));

      InitForm;
      (FService as TServicePedidoVenda).LimpaPedidoTmp;
      (FService as TServicePedidoVenda).FDConnection.Close;
    end;
end;

procedure TMain.CarregaItem;
begin
  with (FService as TServicePedidoVenda) do
  begin
    edtCodProduto.Text := FDMemTablecodigo_produto.AsString;
    edtProduto.Text := FDMemTabledescricao_produto.Value;
    edtQuantidade.Text := FDMemTablequantidade.AsString;
    edtValorUnitario.Text := FormatFloat(',0.00',  FDMemTablevalor_unitario.Value);
    edtTotalItem.Text := FormatFloat(',0.00',  FDMemTablequantidade.Value * FDMemTablevalor_unitario.Value);
    edtQuantidade.SetFocus;
  end;
end;

function TMain.CarregarPedido(ANumPedido: Integer): Boolean;
begin
  Result := False;
  with (FService as TServicePedidoVenda) do
  begin
    if CarregarPedido(ANumPedido).IsEmpty then
    begin
      TProviderUtil.Error('Pedido não encontrado');
      Exit;
    end;

    qryCarregaPedido.First;
    edtCodCliente.Text := qryCarregaPedidocodigo_cliente.AsString;
    edtCliente.Text := qryCarregaPedidonome.Value;
    edtCodProduto.Clear;
    edtProduto.Clear;
    edtQuantidade.Clear;
    edtValorUnitario.Clear;
    edtTotalItem.Clear;
    edtTotalPedido.Text := FormatFloat(',0.00', qryCarregaPedidovalor_total.Value);

    CarregaPedidoProduto;

    Result := True;
  end;
end;

function TMain.CarregouPedido: Boolean;
begin
  Result := False;
  with (FService as TServicePedidoVenda) do
  begin
    if qryCarregaPedido.Active then
      Result := (qryCarregaPedido.RecordCount > 0);
  end;
end;

procedure TMain.edtCodClienteChange(Sender: TObject);
begin
  btnCarregarPedido.Visible := (edtCodCliente.Text = '');
  btnCancelarPedido.Visible := (edtCodCliente.Text = '');
end;

procedure TMain.edtCodClienteKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
var
  LCod: string;
begin
  if (Key = VK_RETURN) then
    if (edtCodCliente.Text <> '') then
    begin
      LCod := edtCodCliente.Text;
      if (FService as TServicePedidoVenda).GetCliente(LCod.ToInteger).IsEmpty then
        raise Exception.Create('Cliente não encontrado');

      edtCliente.Text := (FService as TServicePedidoVenda).qryClientenome.Value;
      edtCodProduto.SetFocus;
    end;
end;

procedure TMain.edtCodProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LCod: string;
begin
  if (Key = VK_RETURN) then
    if (edtCodProduto.Text <> '') then
    begin
      LCod := edtCodProduto.Text;
      if (FService as TServicePedidoVenda).GetProduto(LCod.ToInteger).IsEmpty then
        raise Exception.Create('Produto não encontrado');

      edtProduto.Text := (FService as TServicePedidoVenda).qryProdutodescricao.Value;
      edtQuantidade.Text := '1';
      edtValorUnitario.Text := FormatFloat(',0.00',  (FService as TServicePedidoVenda).qryProdutopreco_venda.Value);
      edtTotalItem.Text := edtValorUnitario.Text;
      edtQuantidade.SetFocus;
    end;
end;

procedure TMain.edtQuantidadeChange(Sender: TObject);
var
  LQtde: string;
begin
  if (edtCodProduto.Text <> '') and (edtQuantidade.Text <> '') then
  begin
    LQtde := edtQuantidade.Text;
    edtTotalItem.Text := FormatFloat(',0.00', (FService as TServicePedidoVenda).qryProdutopreco_venda.Value * LQtde.ToInteger);
  end;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  InitForm;

  FService := TServicePedidoVenda.Create(nil);
  DataSource.DataSet := (FService as TServicePedidoVenda).FDMemTable;
end;

procedure TMain.grdListaDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (State = []) then
  begin
    if Odd(DataSource.DataSet.RecNo) then
      (Sender as TDBGrid).Canvas.Brush.Color := clWhite
    else
      (Sender as TDBGrid).Canvas.Brush.Color := $00F1F2F3;
  end;

  (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TMain.grdListaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      begin
        Key := 0;
        if (DataSource.DataSet.RecordCount > 0) then
        begin
          DataSource.DataSet.Edit;
          CarregaItem;
        end;
      end;

    VK_DELETE:
      begin
        Key := 0;
        if (DataSource.DataSet.RecordCount > 0) then
        begin
          DataSource.DataSet.Delete;
          edtTotalPedido.Text := FormatFloat(',0.00', (FService as TServicePedidoVenda).GetTotalPedido);
        end;
      end;
  end;

end;

procedure TMain.InitForm;
begin
  edtCodCliente.Clear;
  edtCliente.Clear;
  edtCodProduto.Clear;
  edtProduto.Clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;
  edtTotalItem.Clear;
  edtTotalPedido.Clear;

  btnCarregarPedido.Visible := True;
  btnCancelarPedido.Visible := True;

  edtCodCliente.SetFocus;
end;

function TMain.ItemOK: Boolean;
begin
  Result := (edtCodProduto.Text <> '') and (edtQuantidade.Text <> '') and
    (edtValorUnitario.Text <> '') and (edtTotalItem.Text <> '');
end;

procedure TMain.LimpaItem;
begin
  edtCodProduto.Clear;
  edtProduto.Clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;
  edtTotalItem.Clear;
  edtCodProduto.SetFocus;
end;

end.

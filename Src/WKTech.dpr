program WKTech;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Views.PedidoVenda in 'Views\Views.PedidoVenda.pas' {Main},
  Providers.Connection in 'Providers\Providers.Connection.pas' {ProviderConnection: TDataModule},
  Services.PedidoVenda in 'Services\Services.PedidoVenda.pas' {ServicePedidoVenda: TDataModule},
  Providers.Util in 'Providers\Providers.Util.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'WK Technology - Módulo de Pedido de Vendas';
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TMain, Main);
  Application.Run;
end.

unit Providers.Connection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.IniFiles;

type
  TProviderConnection = class(TDataModule)
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    FDConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TProviderConnection.DataModuleCreate(Sender: TObject);
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'WKTech.ini');
  try
    FDConnection.Params.Clear;
    FDConnection.Params.Add('DriverID=MySQL');
    FDConnection.Params.Add('Database=' + LIniFile.ReadString('WKTech.AppPedVenda', 'Database', 'wktech'));
    FDConnection.Params.Add('User_Name=' + LIniFile.ReadString('WKTech.AppPedVenda', 'Username', 'root'));
    FDConnection.Params.Add('Password=' + LIniFile.ReadString('WKTech.AppPedVenda', 'Password', ''));
    FDConnection.Params.Add('Server' + LIniFile.ReadString('WKTech.AppPedVenda', 'Server', 'localhost'));
    FDConnection.Params.Add('Port=' + LIniFile.ReadString('WKTech.AppPedVenda', 'Port', '3306'));
    FDPhysMySQLDriverLink.VendorLib := LIniFile.ReadString('WKTech.AppPedVenda', 'VendorLib', 'libmysql.dl');
  finally
    FreeAndNil(LIniFile);
  end;
end;

end.

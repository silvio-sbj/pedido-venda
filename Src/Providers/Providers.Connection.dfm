object ProviderConnection: TProviderConnection
  OnCreate = DataModuleCreate
  Height = 240
  Width = 323
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    VendorLib = 
      'C:\Program Files (x86)\MySQL\MySQL Connector C 6.1\lib\libmysql.' +
      'dll'
    Left = 132
    Top = 113
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=wktech'
      'User_Name=root'
      'Password=SilvioBJunior76!'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 136
    Top = 32
  end
end

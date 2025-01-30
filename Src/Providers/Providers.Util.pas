unit Providers.Util;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TProviderUtil = class
    class function Confirmation(AMessage: string): Boolean;
    class procedure Error(AMessage: string);
    class procedure Information(AMessage: string);
    class procedure Warning(AMessage: string);
  end;

implementation

{ TProviderUtil }

class function TProviderUtil.Confirmation(AMessage: string): Boolean;
var
  LForm: TForm;
begin
   LForm := CreateMessageDialog(AMessage, mtConfirmation, [mbYes, mbNo]);
   try
     LForm.Caption := 'Confirmação';
     (LForm.FindComponent('Yes') as TButton).Caption := 'Sim';
     (LForm.FindComponent('No') as TButton).Caption := 'Não';
     Result := (LForm.ShowModal = mrYes);
   finally
     FreeAndNil(LForm);
   end;
end;

class procedure TProviderUtil.Error(AMessage: string);
var
  LForm: TForm;
begin
  LForm := CreateMessageDialog(AMessage, mtError, [mbOK]);
  try
    LForm.Caption := 'Erro';
    LForm.ShowModal;
  finally
    FreeAndNil(LForm);
  end;
end;

class procedure TProviderUtil.Information(AMessage: string);
var
  LForm: TForm;
begin
   LForm := CreateMessageDialog(AMessage, mtInformation, [mbOK]);
   try
     LForm.Caption := 'Informação';
     LForm.ShowModal;
   finally
     FreeAndNil(LForm);
   end;
end;

class procedure TProviderUtil.Warning(AMessage: string);
var
  LForm: TForm;
begin
   LForm := CreateMessageDialog(AMessage, mtWarning, [mbOK]);
   try
     LForm.Caption := 'Aviso';
     LForm.ShowModal;
   finally
     FreeAndNil(LForm);
   end;
end;

end.

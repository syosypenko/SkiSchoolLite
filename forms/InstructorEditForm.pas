unit InstructorEditForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  DatabaseModule,
  Entities,
  ValidationUtils;

type
  TInstructorEditForm = class(TForm)
    Label1: TLabel;
    edtInstructorName: TEdit;
    Label2: TLabel;
    edtEmail: TEdit;
    Label3: TLabel;
    edtPhone: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FInstructor: TInstructor;
    FDatabaseModule: TDatabaseModule;
    FIsNewInstructor: Boolean;
  public
    procedure LoadInstructor(AInstructor: TInstructor; AIsNew: Boolean; ADatabase: TDatabaseModule);
  end;

implementation

{$R *.dfm}

procedure TInstructorEditForm.LoadInstructor(AInstructor: TInstructor; AIsNew: Boolean; ADatabase: TDatabaseModule);
begin
  FInstructor := AInstructor;
  FDatabaseModule := ADatabase;
  FIsNewInstructor := AIsNew;

  if not AIsNew then
  begin
    Caption := 'Edit Instructor';
    edtInstructorName.Text := FInstructor.Name;
    edtEmail.Text := FInstructor.Email;
    edtPhone.Text := FInstructor.Phone;
  end
  else
  begin
    Caption := 'New Instructor';
  end;
end;

procedure TInstructorEditForm.btnSaveClick(Sender: TObject);
begin
  try
    if not TValidationUtils.IsRequiredField(edtInstructorName.Text) then
    begin
      MessageDlg('Validation Error' + sLineBreak + 'Please enter an instructor name.', mtError, [mbOK], 0);
      Exit;
    end;

    if not TValidationUtils.IsValidEmail(edtEmail.Text) then
    begin
      MessageDlg('Validation Error' + sLineBreak + 'Please enter a valid email address.', mtError, [mbOK], 0);
      Exit;
    end;

    if not TValidationUtils.IsValidPhoneNumber(edtPhone.Text) then
    begin
      MessageDlg('Validation Error' + sLineBreak + 'Please enter a valid phone number.', mtError, [mbOK], 0);
      Exit;
    end;

    FInstructor.Name := edtInstructorName.Text;
    FInstructor.Email := edtEmail.Text;
    FInstructor.Phone := edtPhone.Text;

    if FIsNewInstructor then
    begin
      FDatabaseModule.AddInstructor(FInstructor.Name, FInstructor.Email, FInstructor.Phone);
      MessageDlg('Success' + sLineBreak + 'Instructor registered successfully.', mtInformation, [mbOK], 0);
    end
    else
    begin
      FDatabaseModule.UpdateInstructor(FInstructor);
      MessageDlg('Success' + sLineBreak + 'Instructor updated successfully.', mtInformation, [mbOK], 0);
    end;

    ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg('Error' + sLineBreak + 'Error saving instructor: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TInstructorEditForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

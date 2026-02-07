unit StudentEditForm;

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
  TStudentEditForm = class(TForm)
    Label1: TLabel;
    edtStudentName: TEdit;
    Label2: TLabel;
    edtEmail: TEdit;
    Label3: TLabel;
    edtPhone: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FStudent: TStudent;
    FDatabaseModule: TDatabaseModule;
    FIsNewStudent: Boolean;
  public
    procedure LoadStudent(AStudent: TStudent; AIsNew: Boolean; ADatabase: TDatabaseModule);
  end;

implementation

{$R *.dfm}

procedure TStudentEditForm.LoadStudent(AStudent: TStudent; AIsNew: Boolean; ADatabase: TDatabaseModule);
begin
  FStudent := AStudent;
  FDatabaseModule := ADatabase;
  FIsNewStudent := AIsNew;

  if not AIsNew then
  begin
    Caption := 'Edit Student';
    edtStudentName.Text := FStudent.Name;
    edtEmail.Text := FStudent.Email;
    edtPhone.Text := FStudent.Phone;
  end
  else
  begin
    Caption := 'New Student';
  end;
end;

procedure TStudentEditForm.btnSaveClick(Sender: TObject);
begin
  try
    if not TValidationUtils.IsRequiredField(edtStudentName.Text) then
    begin
      MessageDlg('Validation Error' + sLineBreak + 'Please enter a student name.', mtError, [mbOK], 0);
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

    FStudent.Name := edtStudentName.Text;
    FStudent.Email := edtEmail.Text;
    FStudent.Phone := edtPhone.Text;

    if FIsNewStudent then
    begin
      FDatabaseModule.AddStudent(FStudent.Name, FStudent.Email, FStudent.Phone);
      MessageDlg('Success' + sLineBreak + 'Student registered successfully.', mtInformation, [mbOK], 0);
    end
    else
    begin
      FDatabaseModule.UpdateStudent(FStudent);
      MessageDlg('Success' + sLineBreak + 'Student updated successfully.', mtInformation, [mbOK], 0);
    end;

    ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg('Error' + sLineBreak + 'Error saving student: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TStudentEditForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

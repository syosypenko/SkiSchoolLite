unit CourseEditForm;

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
  Vcl.ComCtrls,
  Vcl.Samples.Spin,
  DatabaseModule,
  Entities,
  ValidationUtils;

type
  TCourseEditForm = class(TForm)
    Label1: TLabel;
    edtCourseName: TEdit;
    Label2: TLabel;
    dtpStartDate: TDateTimePicker;
    Label3: TLabel;
    dtpEndDate: TDateTimePicker;
    Label4: TLabel;
    cmbLevel: TComboBox;
    Label5: TLabel;
    spnMaxStudents: TSpinEdit;
    btnSave: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FCourse: TCourse;
    FDatabaseModule: TDatabaseModule;
    FIsNewCourse: Boolean;
  public
    procedure LoadCourse(ACourse: TCourse; AIsNew: Boolean; ADatabase: TDatabaseModule);
  end;

implementation

{$R *.dfm}

procedure TCourseEditForm.FormCreate(Sender: TObject);
begin
  cmbLevel.Items.Clear;
  cmbLevel.Items.Add('Beginner');
  cmbLevel.Items.Add('Intermediate');
  cmbLevel.Items.Add('Advanced');
  cmbLevel.ItemIndex := 0;

  spnMaxStudents.MinValue := 1;
  spnMaxStudents.MaxValue := 100;
  spnMaxStudents.Value := 15;
end;

procedure TCourseEditForm.LoadCourse(ACourse: TCourse; AIsNew: Boolean; ADatabase: TDatabaseModule);
begin
  FCourse := ACourse;
  FDatabaseModule := ADatabase;
  FIsNewCourse := AIsNew;

  if not AIsNew then
  begin
    Caption := 'Edit Course';
    edtCourseName.Text := FCourse.Name;
    dtpStartDate.Date := FCourse.StartDate;
    dtpEndDate.Date := FCourse.EndDate;
    cmbLevel.ItemIndex := cmbLevel.Items.IndexOf(FCourse.Level);
    spnMaxStudents.Value := FCourse.MaxStudents;
  end
  else
  begin
    Caption := 'New Course';
    dtpStartDate.Date := Date;
    dtpEndDate.Date := Date;
  end;
end;

procedure TCourseEditForm.btnSaveClick(Sender: TObject);
begin
  try
    if Trim(edtCourseName.Text) = '' then
    begin
      MessageDlg('Validation Error' + sLineBreak + 'Please enter a course name.', mtError, [mbOK], 0);
      Exit;
    end;

    if not TValidationUtils.IsValidDateRange(dtpStartDate.Date, dtpEndDate.Date) then
    begin
      MessageDlg('Validation Error' + sLineBreak + 'End date must be after start date.', mtError, [mbOK], 0);
      Exit;
    end;

    FCourse.Name := edtCourseName.Text;
    FCourse.StartDate := dtpStartDate.Date;
    FCourse.EndDate := dtpEndDate.Date;
    FCourse.Level := cmbLevel.Items[cmbLevel.ItemIndex];
    FCourse.MaxStudents := spnMaxStudents.Value;

    if FIsNewCourse then
    begin
      FDatabaseModule.AddCourse(FCourse.Name, FCourse.StartDate, FCourse.EndDate, FCourse.Level, FCourse.MaxStudents);
      MessageDlg('Success' + sLineBreak + 'Course created successfully.', mtInformation, [mbOK], 0);
    end
    else
    begin
      FDatabaseModule.UpdateCourse(FCourse);
      MessageDlg('Success' + sLineBreak + 'Course updated successfully.', mtInformation, [mbOK], 0);
    end;

    ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg('Error' + sLineBreak + 'Error saving course: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TCourseEditForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

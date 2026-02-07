unit AssignmentEditForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  DatabaseModule,
  Entities;

type
  TAssignmentEditForm = class(TForm)
    Label1: TLabel;
    cmbCourse: TComboBox;
    Label2: TLabel;
    cmbInstructor: TComboBox;
    Label3: TLabel;
    dtpAssignedDate: TDateTimePicker;
    btnSave: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FAssignment: TAssignment;
    FDatabaseModule: TDatabaseModule;
    FIsNewAssignment: Boolean;
  public
    procedure LoadAssignment(AAssignment: TAssignment; AIsNew: Boolean; ADatabase: TDatabaseModule);
  end;

implementation

{$R *.dfm}

procedure TAssignmentEditForm.FormCreate(Sender: TObject);
begin
  dtpAssignedDate.Date := Date;
end;

procedure TAssignmentEditForm.LoadAssignment(AAssignment: TAssignment; AIsNew: Boolean; ADatabase: TDatabaseModule);
var
  Courses: TList<TCourse>;
  Instructors: TList<TInstructor>;
  I: Integer;
  Course: TCourse;
  Instructor: TInstructor;
begin
  FAssignment := AAssignment;
  FDatabaseModule := ADatabase;
  FIsNewAssignment := AIsNew;

  Courses := FDatabaseModule.GetAllCourses;
  try
    for I := 0 to Courses.Count - 1 do
    begin
      Course := Courses[I];
      cmbCourse.Items.AddObject(Course.Name, TObject(NativeInt(Course.ID)));
    end;
  finally
    for I := 0 to Courses.Count - 1 do
      Courses[I].Free;
    Courses.Free;
  end;

  Instructors := FDatabaseModule.GetAllInstructors;
  try
    for I := 0 to Instructors.Count - 1 do
    begin
      Instructor := Instructors[I];
      cmbInstructor.Items.AddObject(Instructor.Name, TObject(NativeInt(Instructor.ID)));
    end;
  finally
    for I := 0 to Instructors.Count - 1 do
      Instructors[I].Free;
    Instructors.Free;
  end;

  if not AIsNew then
  begin
    Caption := 'Edit Assignment';
    for I := 0 to cmbCourse.Items.Count - 1 do
      if Integer(NativeInt(cmbCourse.Items.Objects[I])) = FAssignment.CourseID then
        cmbCourse.ItemIndex := I;

    for I := 0 to cmbInstructor.Items.Count - 1 do
      if Integer(NativeInt(cmbInstructor.Items.Objects[I])) = FAssignment.InstructorID then
        cmbInstructor.ItemIndex := I;

    dtpAssignedDate.Date := FAssignment.AssignedDate;
  end
  else
  begin
    Caption := 'New Assignment';
    if cmbCourse.Items.Count > 0 then cmbCourse.ItemIndex := 0;
    if cmbInstructor.Items.Count > 0 then cmbInstructor.ItemIndex := 0;
  end;
end;

procedure TAssignmentEditForm.btnSaveClick(Sender: TObject);
begin
  try
    if cmbCourse.ItemIndex < 0 then
    begin
      MessageDlg('Validation Error' + sLineBreak + 'Please select a course.', mtError, [mbOK], 0);
      Exit;
    end;

    if cmbInstructor.ItemIndex < 0 then
    begin
      MessageDlg('Validation Error' + sLineBreak + 'Please select an instructor.', mtError, [mbOK], 0);
      Exit;
    end;

    FAssignment.CourseID := Integer(NativeInt(cmbCourse.Items.Objects[cmbCourse.ItemIndex]));
    FAssignment.InstructorID := Integer(NativeInt(cmbInstructor.Items.Objects[cmbInstructor.ItemIndex]));
    FAssignment.AssignedDate := dtpAssignedDate.Date;

    if FIsNewAssignment then
    begin
      FDatabaseModule.AddAssignment(FAssignment.CourseID, FAssignment.InstructorID);
      MessageDlg('Success' + sLineBreak + 'Assignment created successfully.', mtInformation, [mbOK], 0);
    end
    else
    begin
      FDatabaseModule.UpdateAssignment(FAssignment);
      MessageDlg('Success' + sLineBreak + 'Assignment updated successfully.', mtInformation, [mbOK], 0);
    end;

    ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg('Error' + sLineBreak + 'Error saving assignment: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TAssignmentEditForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

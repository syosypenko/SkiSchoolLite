unit BookingEditForm;

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
  TBookingEditForm = class(TForm)
    Label1: TLabel;
    cmbCourse: TComboBox;
    Label2: TLabel;
    cmbStudent: TComboBox;
    Label3: TLabel;
    dtpBookingDate: TDateTimePicker;
    Label4: TLabel;
    cmbStatus: TComboBox;
    btnSave: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FBooking: TBooking;
    FDatabaseModule: TDatabaseModule;
    FIsNewBooking: Boolean;
  public
    procedure LoadBooking(ABooking: TBooking; AIsNew: Boolean; ADatabase: TDatabaseModule);
  end;

implementation

{$R *.dfm}

procedure TBookingEditForm.FormCreate(Sender: TObject);
begin
  cmbStatus.Items.Clear;
  cmbStatus.Items.Add('Active');
  cmbStatus.Items.Add('Cancelled');
  cmbStatus.Items.Add('Completed');
  cmbStatus.ItemIndex := 0;
  dtpBookingDate.Date := Date;
end;

procedure TBookingEditForm.LoadBooking(ABooking: TBooking; AIsNew: Boolean; ADatabase: TDatabaseModule);
var
  Courses: TList<TCourse>;
  Students: TList<TStudent>;
  I: Integer;
  Course: TCourse;
  Student: TStudent;
begin
  FBooking := ABooking;
  FDatabaseModule := ADatabase;
  FIsNewBooking := AIsNew;

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

  Students := FDatabaseModule.GetAllStudents;
  try
    for I := 0 to Students.Count - 1 do
    begin
      Student := Students[I];
      cmbStudent.Items.AddObject(Student.Name, TObject(NativeInt(Student.ID)));
    end;
  finally
    for I := 0 to Students.Count - 1 do
      Students[I].Free;
    Students.Free;
  end;

  if not AIsNew then
  begin
    Caption := 'Edit Booking';
    for I := 0 to cmbCourse.Items.Count - 1 do
      if Integer(NativeInt(cmbCourse.Items.Objects[I])) = FBooking.CourseID then
        cmbCourse.ItemIndex := I;

    for I := 0 to cmbStudent.Items.Count - 1 do
      if Integer(NativeInt(cmbStudent.Items.Objects[I])) = FBooking.StudentID then
        cmbStudent.ItemIndex := I;

    dtpBookingDate.Date := FBooking.BookingDate;
    cmbStatus.ItemIndex := cmbStatus.Items.IndexOf(FBooking.Status);
  end
  else
  begin
    Caption := 'New Booking';
    if cmbCourse.Items.Count > 0 then cmbCourse.ItemIndex := 0;
    if cmbStudent.Items.Count > 0 then cmbStudent.ItemIndex := 0;
  end;
end;

procedure TBookingEditForm.btnSaveClick(Sender: TObject);
begin
  try
    if cmbCourse.ItemIndex < 0 then
    begin
      MessageDlg('Validation Error' + sLineBreak + 'Please select a course.', mtError, [mbOK], 0);
      Exit;
    end;

    if cmbStudent.ItemIndex < 0 then
    begin
      MessageDlg('Validation Error' + sLineBreak + 'Please select a student.', mtError, [mbOK], 0);
      Exit;
    end;

    FBooking.CourseID := Integer(NativeInt(cmbCourse.Items.Objects[cmbCourse.ItemIndex]));
    FBooking.StudentID := Integer(NativeInt(cmbStudent.Items.Objects[cmbStudent.ItemIndex]));
    FBooking.BookingDate := dtpBookingDate.Date;
    FBooking.Status := cmbStatus.Items[cmbStatus.ItemIndex];

    if FIsNewBooking then
    begin
      FDatabaseModule.AddBooking(FBooking.CourseID, FBooking.StudentID);
      MessageDlg('Success' + sLineBreak + 'Booking created successfully.', mtInformation, [mbOK], 0);
    end
    else
    begin
      FDatabaseModule.UpdateBooking(FBooking);
      MessageDlg('Success' + sLineBreak + 'Booking updated successfully.', mtInformation, [mbOK], 0);
    end;

    ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg('Error' + sLineBreak + 'Error saving booking: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TBookingEditForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

unit MainForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.ExtCtrls,
  DatabaseModule,
  Entities,
  CourseEditForm,
  StudentEditForm,
  InstructorEditForm,
  BookingEditForm,
  AssignmentEditForm,
  CSVExportUtils;

type
  TMainForm = class(TForm)
    PageControl: TPageControl;
    CoursesTab: TTabSheet;
    StudentsTab: TTabSheet;
    InstructorsTab: TTabSheet;
    BookingsTab: TTabSheet;
    AssignmentsTab: TTabSheet;
    ReportsTab: TTabSheet;
    PanelCourses: TPanel;
    btnNewCourse: TButton;
    btnEditCourse: TButton;
    btnDeleteCourse: TButton;
    btnSearchCourse: TButton;
    CoursesGrid: TStringGrid;
    PanelStudents: TPanel;
    btnNewStudent: TButton;
    btnEditStudent: TButton;
    btnDeleteStudent: TButton;
    btnSearchStudent: TButton;
    StudentsGrid: TStringGrid;
    PanelInstructors: TPanel;
    btnNewInstructor: TButton;
    btnEditInstructor: TButton;
    btnDeleteInstructor: TButton;
    btnSearchInstructor: TButton;
    InstructorsGrid: TStringGrid;
    PanelBookings: TPanel;
    btnNewBooking: TButton;
    btnEditBooking: TButton;
    btnDeleteBooking: TButton;
    BookingsGrid: TStringGrid;
    PanelAssignments: TPanel;
    btnNewAssignment: TButton;
    btnEditAssignment: TButton;
    btnDeleteAssignment: TButton;
    AssignmentsGrid: TStringGrid;
    PanelReports: TPanel;
    btnGenerateReport: TButton;
    btnExportCSV: TButton;
    ReportMemo: TMemo;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNewCourseClick(Sender: TObject);
    procedure btnNewStudentClick(Sender: TObject);
    procedure btnNewInstructorClick(Sender: TObject);
    procedure btnNewBookingClick(Sender: TObject);
    procedure btnNewAssignmentClick(Sender: TObject);
    procedure btnGenerateReportClick(Sender: TObject);
    procedure btnExportCSVClick(Sender: TObject);
  private
    FDatabaseModule: TDatabaseModule;
    procedure LoadCoursesData;
    procedure LoadStudentsData;
    procedure LoadInstructorsData;
    procedure LoadBookingsData;
    procedure LoadAssignmentsData;
  public
    property DatabaseModule: TDatabaseModule read FDatabaseModule;
  end;

var
  MainFormInstance: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FDatabaseModule := TDatabaseModule.Create(Self);
  FDatabaseModule.OpenConnection;
  StatusBar.SimpleText := 'Connected to database';

  LoadCoursesData;
  LoadStudentsData;
  LoadInstructorsData;
  LoadBookingsData;
  LoadAssignmentsData;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FDatabaseModule.Free;
end;

procedure TMainForm.LoadCoursesData;
var
  Courses: TList<TCourse>;
  I: Integer;
  Course: TCourse;
begin
  CoursesGrid.RowCount := 1;
  CoursesGrid.Cells[0, 0] := 'ID';
  CoursesGrid.Cells[1, 0] := 'Name';
  CoursesGrid.Cells[2, 0] := 'Level';
  CoursesGrid.Cells[3, 0] := 'Start Date';
  CoursesGrid.Cells[4, 0] := 'End Date';
  CoursesGrid.Cells[5, 0] := 'Max Students';

  Courses := FDatabaseModule.GetAllCourses;
  try
    CoursesGrid.RowCount := Courses.Count + 1;
    for I := 0 to Courses.Count - 1 do
    begin
      Course := Courses[I];
      CoursesGrid.Cells[0, I + 1] := IntToStr(Course.ID);
      CoursesGrid.Cells[1, I + 1] := Course.Name;
      CoursesGrid.Cells[2, I + 1] := Course.Level;
      CoursesGrid.Cells[3, I + 1] := DateToStr(Course.StartDate);
      CoursesGrid.Cells[4, I + 1] := DateToStr(Course.EndDate);
      CoursesGrid.Cells[5, I + 1] := IntToStr(Course.MaxStudents);
    end;
  finally
    for I := 0 to Courses.Count - 1 do
      Courses[I].Free;
    Courses.Free;
  end;
end;

procedure TMainForm.LoadStudentsData;
var
  Students: TList<TStudent>;
  I: Integer;
  Student: TStudent;
begin
  StudentsGrid.RowCount := 1;
  StudentsGrid.Cells[0, 0] := 'ID';
  StudentsGrid.Cells[1, 0] := 'Name';
  StudentsGrid.Cells[2, 0] := 'Email';
  StudentsGrid.Cells[3, 0] := 'Phone';

  Students := FDatabaseModule.GetAllStudents;
  try
    StudentsGrid.RowCount := Students.Count + 1;
    for I := 0 to Students.Count - 1 do
    begin
      Student := Students[I];
      StudentsGrid.Cells[0, I + 1] := IntToStr(Student.ID);
      StudentsGrid.Cells[1, I + 1] := Student.Name;
      StudentsGrid.Cells[2, I + 1] := Student.Email;
      StudentsGrid.Cells[3, I + 1] := Student.Phone;
    end;
  finally
    for I := 0 to Students.Count - 1 do
      Students[I].Free;
    Students.Free;
  end;
end;

procedure TMainForm.LoadInstructorsData;
var
  Instructors: TList<TInstructor>;
  I: Integer;
  Instructor: TInstructor;
begin
  InstructorsGrid.RowCount := 1;
  InstructorsGrid.Cells[0, 0] := 'ID';
  InstructorsGrid.Cells[1, 0] := 'Name';
  InstructorsGrid.Cells[2, 0] := 'Email';
  InstructorsGrid.Cells[3, 0] := 'Phone';

  Instructors := FDatabaseModule.GetAllInstructors;
  try
    InstructorsGrid.RowCount := Instructors.Count + 1;
    for I := 0 to Instructors.Count - 1 do
    begin
      Instructor := Instructors[I];
      InstructorsGrid.Cells[0, I + 1] := IntToStr(Instructor.ID);
      InstructorsGrid.Cells[1, I + 1] := Instructor.Name;
      InstructorsGrid.Cells[2, I + 1] := Instructor.Email;
      InstructorsGrid.Cells[3, I + 1] := Instructor.Phone;
    end;
  finally
    for I := 0 to Instructors.Count - 1 do
      Instructors[I].Free;
    Instructors.Free;
  end;
end;

procedure TMainForm.LoadBookingsData;
var
  Bookings: TList<TBooking>;
  I: Integer;
  Booking: TBooking;
  Student: TStudent;
  Course: TCourse;
begin
  BookingsGrid.RowCount := 1;
  BookingsGrid.Cells[0, 0] := 'Booking ID';
  BookingsGrid.Cells[1, 0] := 'Course';
  BookingsGrid.Cells[2, 0] := 'Student';
  BookingsGrid.Cells[3, 0] := 'Booking Date';
  BookingsGrid.Cells[4, 0] := 'Status';

  Bookings := FDatabaseModule.GetAllBookings;
  try
    BookingsGrid.RowCount := Bookings.Count + 1;
    for I := 0 to Bookings.Count - 1 do
    begin
      Booking := Bookings[I];
      Course := FDatabaseModule.GetCourse(Booking.CourseID);
      Student := FDatabaseModule.GetStudent(Booking.StudentID);
      try
        BookingsGrid.Cells[0, I + 1] := IntToStr(Booking.BookingID);
        BookingsGrid.Cells[1, I + 1] := Course.Name;
        BookingsGrid.Cells[2, I + 1] := Student.Name;
        BookingsGrid.Cells[3, I + 1] := DateToStr(Booking.BookingDate);
        BookingsGrid.Cells[4, I + 1] := Booking.Status;
      finally
        Course.Free;
        Student.Free;
      end;
    end;
  finally
    for I := 0 to Bookings.Count - 1 do
      Bookings[I].Free;
    Bookings.Free;
  end;
end;

procedure TMainForm.LoadAssignmentsData;
var
  Assignments: TList<TAssignment>;
  I: Integer;
  Assignment: TAssignment;
  Instructor: TInstructor;
  Course: TCourse;
begin
  AssignmentsGrid.RowCount := 1;
  AssignmentsGrid.Cells[0, 0] := 'Assignment ID';
  AssignmentsGrid.Cells[1, 0] := 'Course';
  AssignmentsGrid.Cells[2, 0] := 'Instructor';
  AssignmentsGrid.Cells[3, 0] := 'Assigned Date';

  Assignments := FDatabaseModule.GetAllAssignments;
  try
    AssignmentsGrid.RowCount := Assignments.Count + 1;
    for I := 0 to Assignments.Count - 1 do
    begin
      Assignment := Assignments[I];
      Course := FDatabaseModule.GetCourse(Assignment.CourseID);
      Instructor := FDatabaseModule.GetInstructor(Assignment.InstructorID);
      try
        AssignmentsGrid.Cells[0, I + 1] := IntToStr(Assignment.AssignmentID);
        AssignmentsGrid.Cells[1, I + 1] := Course.Name;
        AssignmentsGrid.Cells[2, I + 1] := Instructor.Name;
        AssignmentsGrid.Cells[3, I + 1] := DateToStr(Assignment.AssignedDate);
      finally
        Course.Free;
        Instructor.Free;
      end;
    end;
  finally
    for I := 0 to Assignments.Count - 1 do
      Assignments[I].Free;
    Assignments.Free;
  end;
end;

procedure TMainForm.btnNewCourseClick(Sender: TObject);
var
  Form: TCourseEditForm;
  Course: TCourse;
begin
  Course := TCourse.Create;
  try
    Form := TCourseEditForm.Create(Self);
    try
      Form.LoadCourse(Course, True, FDatabaseModule);
      if Form.ShowModal = mrOk then
        LoadCoursesData;
    finally
      Form.Free;
    end;
  finally
    Course.Free;
  end;
end;

procedure TMainForm.btnNewStudentClick(Sender: TObject);
var
  Form: TStudentEditForm;
  Student: TStudent;
begin
  Student := TStudent.Create;
  try
    Form := TStudentEditForm.Create(Self);
    try
      Form.LoadStudent(Student, True, FDatabaseModule);
      if Form.ShowModal = mrOk then
        LoadStudentsData;
    finally
      Form.Free;
    end;
  finally
    Student.Free;
  end;
end;

procedure TMainForm.btnNewInstructorClick(Sender: TObject);
var
  Form: TInstructorEditForm;
  Instructor: TInstructor;
begin
  Instructor := TInstructor.Create;
  try
    Form := TInstructorEditForm.Create(Self);
    try
      Form.LoadInstructor(Instructor, True, FDatabaseModule);
      if Form.ShowModal = mrOk then
        LoadInstructorsData;
    finally
      Form.Free;
    end;
  finally
    Instructor.Free;
  end;
end;

procedure TMainForm.btnNewBookingClick(Sender: TObject);
var
  Form: TBookingEditForm;
  Booking: TBooking;
begin
  Booking := TBooking.Create;
  try
    Form := TBookingEditForm.Create(Self);
    try
      Form.LoadBooking(Booking, True, FDatabaseModule);
      if Form.ShowModal = mrOk then
        LoadBookingsData;
    finally
      Form.Free;
    end;
  finally
    Booking.Free;
  end;
end;

procedure TMainForm.btnNewAssignmentClick(Sender: TObject);
var
  Form: TAssignmentEditForm;
  Assignment: TAssignment;
begin
  Assignment := TAssignment.Create;
  try
    Form := TAssignmentEditForm.Create(Self);
    try
      Form.LoadAssignment(Assignment, True, FDatabaseModule);
      if Form.ShowModal = mrOk then
        LoadAssignmentsData;
    finally
      Form.Free;
    end;
  finally
    Assignment.Free;
  end;
end;

procedure TMainForm.btnGenerateReportClick(Sender: TObject);
var
  Courses: TList<TCourse>;
  I: Integer;
  Course: TCourse;
  StudentCount: Integer;
begin
  ReportMemo.Clear;
  ReportMemo.Lines.Add('=== SKI SCHOOL MANAGEMENT REPORT ===');
  ReportMemo.Lines.Add('Generated: ' + DateTimeToStr(Now));
  ReportMemo.Lines.Add('');
  ReportMemo.Lines.Add('--- STUDENTS PER COURSE ---');

  Courses := FDatabaseModule.GetAllCourses;
  try
    for I := 0 to Courses.Count - 1 do
    begin
      Course := Courses[I];
      StudentCount := FDatabaseModule.GetStudentCountPerCourse(Course.ID);
      ReportMemo.Lines.Add(Course.Name + ': ' + IntToStr(StudentCount) + ' students');
    end;
  finally
    for I := 0 to Courses.Count - 1 do
      Courses[I].Free;
    Courses.Free;
  end;

  StatusBar.SimpleText := 'Report generated successfully';
end;

procedure TMainForm.btnExportCSVClick(Sender: TObject);
var
  ExportPath: string;
begin
  ExportPath := ExtractFilePath(ParamStr(0)) + 'courses_export.csv';
  if TCSVExportUtils.ExportCoursesToCSV(FDatabaseModule, ExportPath) then
    ShowMessage('CSV exported to: ' + ExportPath)
  else
    ShowMessage('CSV export failed.');
end;

end.

unit DatabaseModule;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  FireDAC.Comp.UI,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Stan.Param,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.Intf,
  FireDAC.VCLUI.Wait,
  Entities,
  ValidationUtils;

type
  TDatabaseModule = class(TDataModule)
  private
    FFDConnection: TFDConnection;
    FWaitCursor: TFDGUIxWaitCursor;
    procedure CreateTables;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetConnection: TFDConnection;
    function IsConnected: Boolean;
    procedure OpenConnection;
    procedure CloseConnection;

    function AddInstructor(const AName, AEmail, APhone: string): Integer;
    function GetInstructor(AID: Integer): TInstructor;
    function GetAllInstructors: TList<TInstructor>;
    function UpdateInstructor(AInstructor: TInstructor): Boolean;
    function DeleteInstructor(AID: Integer): Boolean;

    function AddCourse(const AName: string; AStartDate, AEndDate: TDate;
      const ALevel: string; AMaxStudents: Integer): Integer;
    function GetCourse(AID: Integer): TCourse;
    function GetAllCourses: TList<TCourse>;
    function UpdateCourse(ACourse: TCourse): Boolean;
    function DeleteCourse(AID: Integer): Boolean;

    function AddStudent(const AName, AEmail, APhone: string): Integer;
    function GetStudent(AID: Integer): TStudent;
    function GetAllStudents: TList<TStudent>;
    function UpdateStudent(AStudent: TStudent): Boolean;
    function DeleteStudent(AID: Integer): Boolean;

    function AddBooking(ACourseID, AStudentID: Integer): Integer;
    function GetBooking(ABookingID: Integer): TBooking;
    function GetAllBookings: TList<TBooking>;
    function GetBookingsByCourse(ACourseID: Integer): TList<TBooking>;
    function GetBookingsByStudent(AStudentID: Integer): TList<TBooking>;
    function UpdateBooking(ABooking: TBooking): Boolean;
    function DeleteBooking(ABookingID: Integer): Boolean;
    function IsStudentBookedInCourse(AStudentID, ACourseID: Integer): Boolean;

    function AddAssignment(ACourseID, AInstructorID: Integer): Integer;
    function GetAssignment(AAssignmentID: Integer): TAssignment;
    function GetAllAssignments: TList<TAssignment>;
    function GetAssignmentsByCourse(ACourseID: Integer): TList<TAssignment>;
    function GetAssignmentsByInstructor(AInstructorID: Integer): TList<TAssignment>;
    function UpdateAssignment(AAssignment: TAssignment): Boolean;
    function DeleteAssignment(AAssignmentID: Integer): Boolean;

    function GetStudentCountPerCourse(ACourseID: Integer): Integer;
    function GetInstructorWorkload(AInstructorID: Integer): Integer;
  end;

var
  DatabaseModuleInstance: TDatabaseModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TDatabaseModule.Create(AOwner: TComponent);
var
  DatabasePath: string;
begin
  inherited Create(AOwner);

  FWaitCursor := TFDGUIxWaitCursor.Create(Self);

  DatabasePath := ExtractFilePath(ParamStr(0)) + 'SkiSchool.db';

  FFDConnection := TFDConnection.Create(Self);
  FFDConnection.DriverName := 'SQLite';
  FFDConnection.Params.Database := DatabasePath;
  FFDConnection.LoginPrompt := False;
  FFDConnection.Open;

  CreateTables;
end;

destructor TDatabaseModule.Destroy;
begin
  if FFDConnection.Connected then
    FFDConnection.Close;
  inherited Destroy;
end;

procedure TDatabaseModule.CreateTables;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;

    Query.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS Instructors (' +
      '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
      '  Name TEXT NOT NULL,' +
      '  Email TEXT NOT NULL UNIQUE,' +
      '  Phone TEXT NOT NULL,' +
      '  CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP' +
      ')';
    Query.ExecSQL;

    Query.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS Courses (' +
      '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
      '  Name TEXT NOT NULL,' +
      '  StartDate DATE NOT NULL,' +
      '  EndDate DATE NOT NULL,' +
      '  Level TEXT NOT NULL CHECK(Level IN (''Beginner'', ''Intermediate'', ''Advanced'')),' +
      '  MaxStudents INTEGER DEFAULT 15,' +
      '  CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP' +
      ')';
    Query.ExecSQL;

    Query.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS Students (' +
      '  ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
      '  Name TEXT NOT NULL,' +
      '  Email TEXT NOT NULL UNIQUE,' +
      '  Phone TEXT NOT NULL,' +
      '  CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP' +
      ')';
    Query.ExecSQL;

    Query.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS Bookings (' +
      '  BookingID INTEGER PRIMARY KEY AUTOINCREMENT,' +
      '  CourseID INTEGER NOT NULL,' +
      '  StudentID INTEGER NOT NULL,' +
      '  BookingDate DATE NOT NULL DEFAULT CURRENT_DATE,' +
      '  Status TEXT DEFAULT ''Active'' CHECK(Status IN (''Active'', ''Cancelled'', ''Completed'')),' +
      '  FOREIGN KEY (CourseID) REFERENCES Courses(ID) ON DELETE CASCADE,' +
      '  FOREIGN KEY (StudentID) REFERENCES Students(ID) ON DELETE CASCADE,' +
      '  UNIQUE(CourseID, StudentID)' +
      ')';
    Query.ExecSQL;

    Query.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS Assignments (' +
      '  AssignmentID INTEGER PRIMARY KEY AUTOINCREMENT,' +
      '  CourseID INTEGER NOT NULL,' +
      '  InstructorID INTEGER NOT NULL,' +
      '  AssignedDate DATE NOT NULL DEFAULT CURRENT_DATE,' +
      '  FOREIGN KEY (CourseID) REFERENCES Courses(ID) ON DELETE CASCADE,' +
      '  FOREIGN KEY (InstructorID) REFERENCES Instructors(ID) ON DELETE CASCADE,' +
      '  UNIQUE(CourseID, InstructorID)' +
      ')';
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetConnection: TFDConnection;
begin
  Result := FFDConnection;
end;

function TDatabaseModule.IsConnected: Boolean;
begin
  Result := FFDConnection.Connected;
end;

procedure TDatabaseModule.OpenConnection;
begin
  if not FFDConnection.Connected then
    FFDConnection.Open;
end;

procedure TDatabaseModule.CloseConnection;
begin
  if FFDConnection.Connected then
    FFDConnection.Close;
end;

function TDatabaseModule.AddInstructor(const AName, AEmail, APhone: string): Integer;
var
  Query: TFDQuery;
begin
  Result := -1;

  if not TValidationUtils.IsRequiredField(AName) then
    raise Exception.Create('Instructor name is required.');
  if not TValidationUtils.IsValidEmail(AEmail) then
    raise Exception.Create('Invalid email format.');
  if not TValidationUtils.IsValidPhoneNumber(APhone) then
    raise Exception.Create('Invalid phone number.');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'INSERT INTO Instructors (Name, Email, Phone) VALUES (:Name, :Email, :Phone)';
    Query.ParamByName('Name').AsString := AName;
    Query.ParamByName('Email').AsString := AEmail;
    Query.ParamByName('Phone').AsString := APhone;
    Query.ExecSQL;

    Query.SQL.Text := 'SELECT last_insert_rowid() as ID';
    Query.Open;
    if not Query.Eof then
      Result := Query.FieldByName('ID').AsInteger;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetInstructor(AID: Integer): TInstructor;
var
  Query: TFDQuery;
begin
  Result := TInstructor.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Instructors WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AID;
    Query.Open;
    if not Query.Eof then
    begin
      Result.ID := Query.FieldByName('ID').AsInteger;
      Result.Name := Query.FieldByName('Name').AsString;
      Result.Email := Query.FieldByName('Email').AsString;
      Result.Phone := Query.FieldByName('Phone').AsString;
      Result.CreatedDate := Query.FieldByName('CreatedDate').AsDateTime;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetAllInstructors: TList<TInstructor>;
var
  Query: TFDQuery;
  Instructor: TInstructor;
begin
  Result := TList<TInstructor>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Instructors ORDER BY Name';
    Query.Open;
    while not Query.Eof do
    begin
      Instructor := TInstructor.Create;
      Instructor.ID := Query.FieldByName('ID').AsInteger;
      Instructor.Name := Query.FieldByName('Name').AsString;
      Instructor.Email := Query.FieldByName('Email').AsString;
      Instructor.Phone := Query.FieldByName('Phone').AsString;
      Instructor.CreatedDate := Query.FieldByName('CreatedDate').AsDateTime;
      Result.Add(Instructor);
      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.UpdateInstructor(AInstructor: TInstructor): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  if not Assigned(AInstructor) or (AInstructor.ID <= 0) then
    Exit;

  if not TValidationUtils.IsRequiredField(AInstructor.Name) then
    raise Exception.Create('Instructor name is required.');
  if not TValidationUtils.IsValidEmail(AInstructor.Email) then
    raise Exception.Create('Invalid email format.');
  if not TValidationUtils.IsValidPhoneNumber(AInstructor.Phone) then
    raise Exception.Create('Invalid phone number.');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'UPDATE Instructors SET Name = :Name, Email = :Email, Phone = :Phone WHERE ID = :ID';
    Query.ParamByName('Name').AsString := AInstructor.Name;
    Query.ParamByName('Email').AsString := AInstructor.Email;
    Query.ParamByName('Phone').AsString := AInstructor.Phone;
    Query.ParamByName('ID').AsInteger := AInstructor.ID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.DeleteInstructor(AID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  if AID <= 0 then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'DELETE FROM Instructors WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.AddCourse(const AName: string; AStartDate, AEndDate: TDate;
  const ALevel: string; AMaxStudents: Integer): Integer;
var
  Query: TFDQuery;
begin
  Result := -1;
  if not TValidationUtils.IsRequiredField(AName) then
    raise Exception.Create('Course name is required.');
  if not TValidationUtils.IsValidDateRange(AStartDate, AEndDate) then
    raise Exception.Create('Invalid date range.');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'INSERT INTO Courses (Name, StartDate, EndDate, Level, MaxStudents) VALUES (:Name, :StartDate, :EndDate, :Level, :MaxStudents)';
    Query.ParamByName('Name').AsString := AName;
    Query.ParamByName('StartDate').AsDateTime := AStartDate;
    Query.ParamByName('EndDate').AsDateTime := AEndDate;
    Query.ParamByName('Level').AsString := ALevel;
    Query.ParamByName('MaxStudents').AsInteger := AMaxStudents;
    Query.ExecSQL;

    Query.SQL.Text := 'SELECT last_insert_rowid() as ID';
    Query.Open;
    if not Query.Eof then
      Result := Query.FieldByName('ID').AsInteger;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetCourse(AID: Integer): TCourse;
var
  Query: TFDQuery;
begin
  Result := TCourse.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Courses WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AID;
    Query.Open;
    if not Query.Eof then
    begin
      Result.ID := Query.FieldByName('ID').AsInteger;
      Result.Name := Query.FieldByName('Name').AsString;
      Result.StartDate := Query.FieldByName('StartDate').AsDateTime;
      Result.EndDate := Query.FieldByName('EndDate').AsDateTime;
      Result.Level := Query.FieldByName('Level').AsString;
      Result.MaxStudents := Query.FieldByName('MaxStudents').AsInteger;
      Result.CreatedDate := Query.FieldByName('CreatedDate').AsDateTime;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetAllCourses: TList<TCourse>;
var
  Query: TFDQuery;
  Course: TCourse;
begin
  Result := TList<TCourse>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Courses ORDER BY StartDate DESC';
    Query.Open;
    while not Query.Eof do
    begin
      Course := TCourse.Create;
      Course.ID := Query.FieldByName('ID').AsInteger;
      Course.Name := Query.FieldByName('Name').AsString;
      Course.StartDate := Query.FieldByName('StartDate').AsDateTime;
      Course.EndDate := Query.FieldByName('EndDate').AsDateTime;
      Course.Level := Query.FieldByName('Level').AsString;
      Course.MaxStudents := Query.FieldByName('MaxStudents').AsInteger;
      Course.CreatedDate := Query.FieldByName('CreatedDate').AsDateTime;
      Result.Add(Course);
      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.UpdateCourse(ACourse: TCourse): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  if not Assigned(ACourse) or (ACourse.ID <= 0) then
    Exit;

  if not TValidationUtils.IsRequiredField(ACourse.Name) then
    raise Exception.Create('Course name is required.');
  if not TValidationUtils.IsValidDateRange(ACourse.StartDate, ACourse.EndDate) then
    raise Exception.Create('Invalid date range.');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'UPDATE Courses SET Name = :Name, StartDate = :StartDate, EndDate = :EndDate, Level = :Level, MaxStudents = :MaxStudents WHERE ID = :ID';
    Query.ParamByName('Name').AsString := ACourse.Name;
    Query.ParamByName('StartDate').AsDateTime := ACourse.StartDate;
    Query.ParamByName('EndDate').AsDateTime := ACourse.EndDate;
    Query.ParamByName('Level').AsString := ACourse.Level;
    Query.ParamByName('MaxStudents').AsInteger := ACourse.MaxStudents;
    Query.ParamByName('ID').AsInteger := ACourse.ID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.DeleteCourse(AID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  if AID <= 0 then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'DELETE FROM Courses WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.AddStudent(const AName, AEmail, APhone: string): Integer;
var
  Query: TFDQuery;
begin
  Result := -1;
  if not TValidationUtils.IsRequiredField(AName) then
    raise Exception.Create('Student name is required.');
  if not TValidationUtils.IsValidEmail(AEmail) then
    raise Exception.Create('Invalid email format.');
  if not TValidationUtils.IsValidPhoneNumber(APhone) then
    raise Exception.Create('Invalid phone number.');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'INSERT INTO Students (Name, Email, Phone) VALUES (:Name, :Email, :Phone)';
    Query.ParamByName('Name').AsString := AName;
    Query.ParamByName('Email').AsString := AEmail;
    Query.ParamByName('Phone').AsString := APhone;
    Query.ExecSQL;

    Query.SQL.Text := 'SELECT last_insert_rowid() as ID';
    Query.Open;
    if not Query.Eof then
      Result := Query.FieldByName('ID').AsInteger;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetStudent(AID: Integer): TStudent;
var
  Query: TFDQuery;
begin
  Result := TStudent.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Students WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AID;
    Query.Open;
    if not Query.Eof then
    begin
      Result.ID := Query.FieldByName('ID').AsInteger;
      Result.Name := Query.FieldByName('Name').AsString;
      Result.Email := Query.FieldByName('Email').AsString;
      Result.Phone := Query.FieldByName('Phone').AsString;
      Result.CreatedDate := Query.FieldByName('CreatedDate').AsDateTime;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetAllStudents: TList<TStudent>;
var
  Query: TFDQuery;
  Student: TStudent;
begin
  Result := TList<TStudent>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Students ORDER BY Name';
    Query.Open;
    while not Query.Eof do
    begin
      Student := TStudent.Create;
      Student.ID := Query.FieldByName('ID').AsInteger;
      Student.Name := Query.FieldByName('Name').AsString;
      Student.Email := Query.FieldByName('Email').AsString;
      Student.Phone := Query.FieldByName('Phone').AsString;
      Student.CreatedDate := Query.FieldByName('CreatedDate').AsDateTime;
      Result.Add(Student);
      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.UpdateStudent(AStudent: TStudent): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  if not Assigned(AStudent) or (AStudent.ID <= 0) then
    Exit;

  if not TValidationUtils.IsRequiredField(AStudent.Name) then
    raise Exception.Create('Student name is required.');
  if not TValidationUtils.IsValidEmail(AStudent.Email) then
    raise Exception.Create('Invalid email format.');
  if not TValidationUtils.IsValidPhoneNumber(AStudent.Phone) then
    raise Exception.Create('Invalid phone number.');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'UPDATE Students SET Name = :Name, Email = :Email, Phone = :Phone WHERE ID = :ID';
    Query.ParamByName('Name').AsString := AStudent.Name;
    Query.ParamByName('Email').AsString := AStudent.Email;
    Query.ParamByName('Phone').AsString := AStudent.Phone;
    Query.ParamByName('ID').AsInteger := AStudent.ID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.DeleteStudent(AID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  if AID <= 0 then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'DELETE FROM Students WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.AddBooking(ACourseID, AStudentID: Integer): Integer;
var
  Query: TFDQuery;
begin
  Result := -1;
  if (ACourseID <= 0) or (AStudentID <= 0) then
    raise Exception.Create('Invalid course or student ID.');
  if IsStudentBookedInCourse(AStudentID, ACourseID) then
    raise Exception.Create('Student is already enrolled in this course.');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'INSERT INTO Bookings (CourseID, StudentID, BookingDate, Status) VALUES (:CourseID, :StudentID, CURRENT_DATE, :Status)';
    Query.ParamByName('CourseID').AsInteger := ACourseID;
    Query.ParamByName('StudentID').AsInteger := AStudentID;
    Query.ParamByName('Status').AsString := 'Active';
    Query.ExecSQL;

    Query.SQL.Text := 'SELECT last_insert_rowid() as ID';
    Query.Open;
    if not Query.Eof then
      Result := Query.FieldByName('ID').AsInteger;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetBooking(ABookingID: Integer): TBooking;
var
  Query: TFDQuery;
begin
  Result := TBooking.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Bookings WHERE BookingID = :BookingID';
    Query.ParamByName('BookingID').AsInteger := ABookingID;
    Query.Open;
    if not Query.Eof then
    begin
      Result.BookingID := Query.FieldByName('BookingID').AsInteger;
      Result.CourseID := Query.FieldByName('CourseID').AsInteger;
      Result.StudentID := Query.FieldByName('StudentID').AsInteger;
      Result.BookingDate := Query.FieldByName('BookingDate').AsDateTime;
      Result.Status := Query.FieldByName('Status').AsString;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetAllBookings: TList<TBooking>;
var
  Query: TFDQuery;
  Booking: TBooking;
begin
  Result := TList<TBooking>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Bookings WHERE Status = ''Active'' ORDER BY BookingDate DESC';
    Query.Open;
    while not Query.Eof do
    begin
      Booking := TBooking.Create;
      Booking.BookingID := Query.FieldByName('BookingID').AsInteger;
      Booking.CourseID := Query.FieldByName('CourseID').AsInteger;
      Booking.StudentID := Query.FieldByName('StudentID').AsInteger;
      Booking.BookingDate := Query.FieldByName('BookingDate').AsDateTime;
      Booking.Status := Query.FieldByName('Status').AsString;
      Result.Add(Booking);
      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetBookingsByCourse(ACourseID: Integer): TList<TBooking>;
var
  Query: TFDQuery;
  Booking: TBooking;
begin
  Result := TList<TBooking>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Bookings WHERE CourseID = :CourseID AND Status = ''Active'' ORDER BY BookingDate';
    Query.ParamByName('CourseID').AsInteger := ACourseID;
    Query.Open;
    while not Query.Eof do
    begin
      Booking := TBooking.Create;
      Booking.BookingID := Query.FieldByName('BookingID').AsInteger;
      Booking.CourseID := Query.FieldByName('CourseID').AsInteger;
      Booking.StudentID := Query.FieldByName('StudentID').AsInteger;
      Booking.BookingDate := Query.FieldByName('BookingDate').AsDateTime;
      Booking.Status := Query.FieldByName('Status').AsString;
      Result.Add(Booking);
      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetBookingsByStudent(AStudentID: Integer): TList<TBooking>;
var
  Query: TFDQuery;
  Booking: TBooking;
begin
  Result := TList<TBooking>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Bookings WHERE StudentID = :StudentID AND Status = ''Active'' ORDER BY BookingDate DESC';
    Query.ParamByName('StudentID').AsInteger := AStudentID;
    Query.Open;
    while not Query.Eof do
    begin
      Booking := TBooking.Create;
      Booking.BookingID := Query.FieldByName('BookingID').AsInteger;
      Booking.CourseID := Query.FieldByName('CourseID').AsInteger;
      Booking.StudentID := Query.FieldByName('StudentID').AsInteger;
      Booking.BookingDate := Query.FieldByName('BookingDate').AsDateTime;
      Booking.Status := Query.FieldByName('Status').AsString;
      Result.Add(Booking);
      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.UpdateBooking(ABooking: TBooking): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  if not Assigned(ABooking) or (ABooking.BookingID <= 0) then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'UPDATE Bookings SET Status = :Status WHERE BookingID = :BookingID';
    Query.ParamByName('Status').AsString := ABooking.Status;
    Query.ParamByName('BookingID').AsInteger := ABooking.BookingID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.DeleteBooking(ABookingID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  if ABookingID <= 0 then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'DELETE FROM Bookings WHERE BookingID = :BookingID';
    Query.ParamByName('BookingID').AsInteger := ABookingID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.IsStudentBookedInCourse(AStudentID, ACourseID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT COUNT(*) as Count FROM Bookings WHERE StudentID = :StudentID AND CourseID = :CourseID AND Status = ''Active''';
    Query.ParamByName('StudentID').AsInteger := AStudentID;
    Query.ParamByName('CourseID').AsInteger := ACourseID;
    Query.Open;
    if not Query.Eof then
      Result := Query.FieldByName('Count').AsInteger > 0;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.AddAssignment(ACourseID, AInstructorID: Integer): Integer;
var
  Query: TFDQuery;
begin
  Result := -1;
  if (ACourseID <= 0) or (AInstructorID <= 0) then
    raise Exception.Create('Invalid course or instructor ID.');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'INSERT INTO Assignments (CourseID, InstructorID, AssignedDate) VALUES (:CourseID, :InstructorID, CURRENT_DATE)';
    Query.ParamByName('CourseID').AsInteger := ACourseID;
    Query.ParamByName('InstructorID').AsInteger := AInstructorID;
    Query.ExecSQL;

    Query.SQL.Text := 'SELECT last_insert_rowid() as ID';
    Query.Open;
    if not Query.Eof then
      Result := Query.FieldByName('ID').AsInteger;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetAssignment(AAssignmentID: Integer): TAssignment;
var
  Query: TFDQuery;
begin
  Result := TAssignment.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Assignments WHERE AssignmentID = :AssignmentID';
    Query.ParamByName('AssignmentID').AsInteger := AAssignmentID;
    Query.Open;
    if not Query.Eof then
    begin
      Result.AssignmentID := Query.FieldByName('AssignmentID').AsInteger;
      Result.CourseID := Query.FieldByName('CourseID').AsInteger;
      Result.InstructorID := Query.FieldByName('InstructorID').AsInteger;
      Result.AssignedDate := Query.FieldByName('AssignedDate').AsDateTime;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetAllAssignments: TList<TAssignment>;
var
  Query: TFDQuery;
  Assignment: TAssignment;
begin
  Result := TList<TAssignment>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Assignments ORDER BY AssignedDate DESC';
    Query.Open;
    while not Query.Eof do
    begin
      Assignment := TAssignment.Create;
      Assignment.AssignmentID := Query.FieldByName('AssignmentID').AsInteger;
      Assignment.CourseID := Query.FieldByName('CourseID').AsInteger;
      Assignment.InstructorID := Query.FieldByName('InstructorID').AsInteger;
      Assignment.AssignedDate := Query.FieldByName('AssignedDate').AsDateTime;
      Result.Add(Assignment);
      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetAssignmentsByCourse(ACourseID: Integer): TList<TAssignment>;
var
  Query: TFDQuery;
  Assignment: TAssignment;
begin
  Result := TList<TAssignment>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Assignments WHERE CourseID = :CourseID ORDER BY AssignedDate';
    Query.ParamByName('CourseID').AsInteger := ACourseID;
    Query.Open;
    while not Query.Eof do
    begin
      Assignment := TAssignment.Create;
      Assignment.AssignmentID := Query.FieldByName('AssignmentID').AsInteger;
      Assignment.CourseID := Query.FieldByName('CourseID').AsInteger;
      Assignment.InstructorID := Query.FieldByName('InstructorID').AsInteger;
      Assignment.AssignedDate := Query.FieldByName('AssignedDate').AsDateTime;
      Result.Add(Assignment);
      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetAssignmentsByInstructor(AInstructorID: Integer): TList<TAssignment>;
var
  Query: TFDQuery;
  Assignment: TAssignment;
begin
  Result := TList<TAssignment>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT * FROM Assignments WHERE InstructorID = :InstructorID ORDER BY AssignedDate DESC';
    Query.ParamByName('InstructorID').AsInteger := AInstructorID;
    Query.Open;
    while not Query.Eof do
    begin
      Assignment := TAssignment.Create;
      Assignment.AssignmentID := Query.FieldByName('AssignmentID').AsInteger;
      Assignment.CourseID := Query.FieldByName('CourseID').AsInteger;
      Assignment.InstructorID := Query.FieldByName('InstructorID').AsInteger;
      Assignment.AssignedDate := Query.FieldByName('AssignedDate').AsDateTime;
      Result.Add(Assignment);
      Query.Next;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.UpdateAssignment(AAssignment: TAssignment): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  if not Assigned(AAssignment) or (AAssignment.AssignmentID <= 0) then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'UPDATE Assignments SET CourseID = :CourseID, InstructorID = :InstructorID WHERE AssignmentID = :AssignmentID';
    Query.ParamByName('CourseID').AsInteger := AAssignment.CourseID;
    Query.ParamByName('InstructorID').AsInteger := AAssignment.InstructorID;
    Query.ParamByName('AssignmentID').AsInteger := AAssignment.AssignmentID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.DeleteAssignment(AAssignmentID: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  if AAssignmentID <= 0 then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'DELETE FROM Assignments WHERE AssignmentID = :AssignmentID';
    Query.ParamByName('AssignmentID').AsInteger := AAssignmentID;
    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetStudentCountPerCourse(ACourseID: Integer): Integer;
var
  Query: TFDQuery;
begin
  Result := 0;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT COUNT(*) as StudentCount FROM Bookings WHERE CourseID = :CourseID AND Status = ''Active''';
    Query.ParamByName('CourseID').AsInteger := ACourseID;
    Query.Open;
    if not Query.Eof then
      Result := Query.FieldByName('StudentCount').AsInteger;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TDatabaseModule.GetInstructorWorkload(AInstructorID: Integer): Integer;
var
  Query: TFDQuery;
begin
  Result := 0;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    Query.SQL.Text := 'SELECT COUNT(*) as CourseCount FROM Assignments WHERE InstructorID = :InstructorID';
    Query.ParamByName('InstructorID').AsInteger := AInstructorID;
    Query.Open;
    if not Query.Eof then
      Result := Query.FieldByName('CourseCount').AsInteger;
    Query.Close;
  finally
    Query.Free;
  end;
end;

end.

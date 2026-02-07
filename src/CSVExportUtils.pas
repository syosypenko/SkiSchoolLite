unit CSVExportUtils;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Entities,
  DatabaseModule;

type
  TCSVExportUtils = class(TObject)
  public
    class function ExportCoursesToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean; static;
    class function ExportStudentsToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean; static;
    class function ExportInstructorsToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean; static;
    class function ExportBookingsToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean; static;
    class function ExportAssignmentsToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean; static;
    class function ExportStudentCountReportToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean; static;
    class function ExportInstructorWorkloadReportToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean; static;
  private
    class function EscapeCSVField(const AField: string): string; static;
  end;

implementation

class function TCSVExportUtils.EscapeCSVField(const AField: string): string;
begin
  if (Pos(',', AField) > 0) or (Pos('"', AField) > 0) or (Pos(#13, AField) > 0) then
    Result := '"' + StringReplace(AField, '"', '""', [rfReplaceAll]) + '"'
  else
    Result := AField;
end;

class function TCSVExportUtils.ExportCoursesToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean;
var
  Courses: TList<TCourse>;
  I: Integer;
  Course: TCourse;
  CSV: TStringList;
begin
  Result := False;
  CSV := TStringList.Create;
  try
    CSV.Add('ID,Name,Level,StartDate,EndDate,MaxStudents');

    Courses := ADatabase.GetAllCourses;
    try
      for I := 0 to Courses.Count - 1 do
      begin
        Course := Courses[I];
        CSV.Add(
          IntToStr(Course.ID) + ',' +
          EscapeCSVField(Course.Name) + ',' +
          Course.Level + ',' +
          DateToStr(Course.StartDate) + ',' +
          DateToStr(Course.EndDate) + ',' +
          IntToStr(Course.MaxStudents)
        );
      end;
    finally
      for I := 0 to Courses.Count - 1 do
        Courses[I].Free;
      Courses.Free;
    end;

    CSV.SaveToFile(AFilePath);
    Result := True;
  finally
    CSV.Free;
  end;
end;

class function TCSVExportUtils.ExportStudentsToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean;
var
  Students: TList<TStudent>;
  I: Integer;
  Student: TStudent;
  CSV: TStringList;
begin
  Result := False;
  CSV := TStringList.Create;
  try
    CSV.Add('ID,Name,Email,Phone');

    Students := ADatabase.GetAllStudents;
    try
      for I := 0 to Students.Count - 1 do
      begin
        Student := Students[I];
        CSV.Add(
          IntToStr(Student.ID) + ',' +
          EscapeCSVField(Student.Name) + ',' +
          EscapeCSVField(Student.Email) + ',' +
          EscapeCSVField(Student.Phone)
        );
      end;
    finally
      for I := 0 to Students.Count - 1 do
        Students[I].Free;
      Students.Free;
    end;

    CSV.SaveToFile(AFilePath);
    Result := True;
  finally
    CSV.Free;
  end;
end;

class function TCSVExportUtils.ExportInstructorsToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean;
var
  Instructors: TList<TInstructor>;
  I: Integer;
  Instructor: TInstructor;
  CSV: TStringList;
begin
  Result := False;
  CSV := TStringList.Create;
  try
    CSV.Add('ID,Name,Email,Phone');

    Instructors := ADatabase.GetAllInstructors;
    try
      for I := 0 to Instructors.Count - 1 do
      begin
        Instructor := Instructors[I];
        CSV.Add(
          IntToStr(Instructor.ID) + ',' +
          EscapeCSVField(Instructor.Name) + ',' +
          EscapeCSVField(Instructor.Email) + ',' +
          EscapeCSVField(Instructor.Phone)
        );
      end;
    finally
      for I := 0 to Instructors.Count - 1 do
        Instructors[I].Free;
      Instructors.Free;
    end;

    CSV.SaveToFile(AFilePath);
    Result := True;
  finally
    CSV.Free;
  end;
end;

class function TCSVExportUtils.ExportBookingsToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean;
var
  Bookings: TList<TBooking>;
  I: Integer;
  Booking: TBooking;
  Course: TCourse;
  Student: TStudent;
  CSV: TStringList;
begin
  Result := False;
  CSV := TStringList.Create;
  try
    CSV.Add('BookingID,CourseName,StudentName,BookingDate,Status');

    Bookings := ADatabase.GetAllBookings;
    try
      for I := 0 to Bookings.Count - 1 do
      begin
        Booking := Bookings[I];
        Course := ADatabase.GetCourse(Booking.CourseID);
        Student := ADatabase.GetStudent(Booking.StudentID);
        try
          CSV.Add(
            IntToStr(Booking.BookingID) + ',' +
            EscapeCSVField(Course.Name) + ',' +
            EscapeCSVField(Student.Name) + ',' +
            DateToStr(Booking.BookingDate) + ',' +
            Booking.Status
          );
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

    CSV.SaveToFile(AFilePath);
    Result := True;
  finally
    CSV.Free;
  end;
end;

class function TCSVExportUtils.ExportAssignmentsToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean;
var
  Assignments: TList<TAssignment>;
  I: Integer;
  Assignment: TAssignment;
  Course: TCourse;
  Instructor: TInstructor;
  CSV: TStringList;
begin
  Result := False;
  CSV := TStringList.Create;
  try
    CSV.Add('AssignmentID,CourseName,InstructorName,AssignedDate');

    Assignments := ADatabase.GetAllAssignments;
    try
      for I := 0 to Assignments.Count - 1 do
      begin
        Assignment := Assignments[I];
        Course := ADatabase.GetCourse(Assignment.CourseID);
        Instructor := ADatabase.GetInstructor(Assignment.InstructorID);
        try
          CSV.Add(
            IntToStr(Assignment.AssignmentID) + ',' +
            EscapeCSVField(Course.Name) + ',' +
            EscapeCSVField(Instructor.Name) + ',' +
            DateToStr(Assignment.AssignedDate)
          );
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

    CSV.SaveToFile(AFilePath);
    Result := True;
  finally
    CSV.Free;
  end;
end;

class function TCSVExportUtils.ExportStudentCountReportToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean;
var
  Courses: TList<TCourse>;
  I: Integer;
  Course: TCourse;
  StudentCount: Integer;
  CSV: TStringList;
begin
  Result := False;
  CSV := TStringList.Create;
  try
    CSV.Add('CourseName,Level,StartDate,EndDate,StudentCount,MaxCapacity');

    Courses := ADatabase.GetAllCourses;
    try
      for I := 0 to Courses.Count - 1 do
      begin
        Course := Courses[I];
        StudentCount := ADatabase.GetStudentCountPerCourse(Course.ID);
        CSV.Add(
          EscapeCSVField(Course.Name) + ',' +
          Course.Level + ',' +
          DateToStr(Course.StartDate) + ',' +
          DateToStr(Course.EndDate) + ',' +
          IntToStr(StudentCount) + ',' +
          IntToStr(Course.MaxStudents)
        );
      end;
    finally
      for I := 0 to Courses.Count - 1 do
        Courses[I].Free;
      Courses.Free;
    end;

    CSV.SaveToFile(AFilePath);
    Result := True;
  finally
    CSV.Free;
  end;
end;

class function TCSVExportUtils.ExportInstructorWorkloadReportToCSV(ADatabase: TDatabaseModule; const AFilePath: string): Boolean;
var
  Instructors: TList<TInstructor>;
  I: Integer;
  Instructor: TInstructor;
  Workload: Integer;
  CSV: TStringList;
begin
  Result := False;
  CSV := TStringList.Create;
  try
    CSV.Add('InstructorName,Email,AssignedCourses');

    Instructors := ADatabase.GetAllInstructors;
    try
      for I := 0 to Instructors.Count - 1 do
      begin
        Instructor := Instructors[I];
        Workload := ADatabase.GetInstructorWorkload(Instructor.ID);
        CSV.Add(
          EscapeCSVField(Instructor.Name) + ',' +
          EscapeCSVField(Instructor.Email) + ',' +
          IntToStr(Workload)
        );
      end;
    finally
      for I := 0 to Instructors.Count - 1 do
        Instructors[I].Free;
      Instructors.Free;
    end;

    CSV.SaveToFile(AFilePath);
    Result := True;
  finally
    CSV.Free;
  end;
end;

end.

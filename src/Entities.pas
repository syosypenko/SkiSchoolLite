unit Entities;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TInstructor = class(TObject)
  private
    FID: Integer;
    FName: string;
    FEmail: string;
    FPhone: string;
    FCreatedDate: TDateTime;
  public
    constructor Create;
    procedure Assign(Source: TInstructor);
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
    property Email: string read FEmail write FEmail;
    property Phone: string read FPhone write FPhone;
    property CreatedDate: TDateTime read FCreatedDate write FCreatedDate;
  end;

  TCourse = class(TObject)
  private
    FID: Integer;
    FName: string;
    FStartDate: TDate;
    FEndDate: TDate;
    FLevel: string;
    FMaxStudents: Integer;
    FCreatedDate: TDateTime;
  public
    constructor Create;
    procedure Assign(Source: TCourse);
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
    property StartDate: TDate read FStartDate write FStartDate;
    property EndDate: TDate read FEndDate write FEndDate;
    property Level: string read FLevel write FLevel;
    property MaxStudents: Integer read FMaxStudents write FMaxStudents;
    property CreatedDate: TDateTime read FCreatedDate write FCreatedDate;
  end;

  TStudent = class(TObject)
  private
    FID: Integer;
    FName: string;
    FEmail: string;
    FPhone: string;
    FCreatedDate: TDateTime;
  public
    constructor Create;
    procedure Assign(Source: TStudent);
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
    property Email: string read FEmail write FEmail;
    property Phone: string read FPhone write FPhone;
    property CreatedDate: TDateTime read FCreatedDate write FCreatedDate;
  end;

  TBooking = class(TObject)
  private
    FBookingID: Integer;
    FCourseID: Integer;
    FStudentID: Integer;
    FBookingDate: TDate;
    FStatus: string;
  public
    constructor Create;
    procedure Assign(Source: TBooking);
    property BookingID: Integer read FBookingID write FBookingID;
    property CourseID: Integer read FCourseID write FCourseID;
    property StudentID: Integer read FStudentID write FStudentID;
    property BookingDate: TDate read FBookingDate write FBookingDate;
    property Status: string read FStatus write FStatus;
  end;

  TAssignment = class(TObject)
  private
    FAssignmentID: Integer;
    FCourseID: Integer;
    FInstructorID: Integer;
    FAssignedDate: TDate;
  public
    constructor Create;
    procedure Assign(Source: TAssignment);
    property AssignmentID: Integer read FAssignmentID write FAssignmentID;
    property CourseID: Integer read FCourseID write FCourseID;
    property InstructorID: Integer read FInstructorID write FInstructorID;
    property AssignedDate: TDate read FAssignedDate write FAssignedDate;
  end;

implementation

constructor TInstructor.Create;
begin
  inherited Create;
  FID := 0;
  FName := '';
  FEmail := '';
  FPhone := '';
  FCreatedDate := Now;
end;

procedure TInstructor.Assign(Source: TInstructor);
begin
  if Assigned(Source) then
  begin
    FID := Source.FID;
    FName := Source.FName;
    FEmail := Source.FEmail;
    FPhone := Source.FPhone;
    FCreatedDate := Source.FCreatedDate;
  end;
end;

constructor TCourse.Create;
begin
  inherited Create;
  FID := 0;
  FName := '';
  FStartDate := 0;
  FEndDate := 0;
  FLevel := 'Beginner';
  FMaxStudents := 15;
  FCreatedDate := Now;
end;

procedure TCourse.Assign(Source: TCourse);
begin
  if Assigned(Source) then
  begin
    FID := Source.FID;
    FName := Source.FName;
    FStartDate := Source.FStartDate;
    FEndDate := Source.FEndDate;
    FLevel := Source.FLevel;
    FMaxStudents := Source.FMaxStudents;
    FCreatedDate := Source.FCreatedDate;
  end;
end;

constructor TStudent.Create;
begin
  inherited Create;
  FID := 0;
  FName := '';
  FEmail := '';
  FPhone := '';
  FCreatedDate := Now;
end;

procedure TStudent.Assign(Source: TStudent);
begin
  if Assigned(Source) then
  begin
    FID := Source.FID;
    FName := Source.FName;
    FEmail := Source.FEmail;
    FPhone := Source.FPhone;
    FCreatedDate := Source.FCreatedDate;
  end;
end;

constructor TBooking.Create;
begin
  inherited Create;
  FBookingID := 0;
  FCourseID := 0;
  FStudentID := 0;
  FBookingDate := 0;
  FStatus := 'Active';
end;

procedure TBooking.Assign(Source: TBooking);
begin
  if Assigned(Source) then
  begin
    FBookingID := Source.FBookingID;
    FCourseID := Source.FCourseID;
    FStudentID := Source.FStudentID;
    FBookingDate := Source.FBookingDate;
    FStatus := Source.FStatus;
  end;
end;

constructor TAssignment.Create;
begin
  inherited Create;
  FAssignmentID := 0;
  FCourseID := 0;
  FInstructorID := 0;
  FAssignedDate := 0;
end;

procedure TAssignment.Assign(Source: TAssignment);
begin
  if Assigned(Source) then
  begin
    FAssignmentID := Source.FAssignmentID;
    FCourseID := Source.FCourseID;
    FInstructorID := Source.FInstructorID;
    FAssignedDate := Source.FAssignedDate;
  end;
end;

end.

program SkiSchoolLiteDelphi12;

uses
  Vcl.Forms,
  MainForm in 'forms\MainForm.pas' {MainForm},
  CourseEditForm in 'forms\CourseEditForm.pas' {CourseEditForm},
  StudentEditForm in 'forms\StudentEditForm.pas' {StudentEditForm},
  InstructorEditForm in 'forms\InstructorEditForm.pas' {InstructorEditForm},
  BookingEditForm in 'forms\BookingEditForm.pas' {BookingEditForm},
  AssignmentEditForm in 'forms\AssignmentEditForm.pas' {AssignmentEditForm},
  DatabaseModule in 'src\DatabaseModule.pas' {DatabaseModule: TDataModule},
  Entities in 'src\Entities.pas',
  ValidationUtils in 'src\ValidationUtils.pas',
  CSVExportUtils in 'src\CSVExportUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDatabaseModule, DatabaseModuleInstance);
  Application.CreateForm(TMainForm, MainFormInstance);
  Application.Run;
end.

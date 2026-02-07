object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Ski School Management Lite (Delphi 12)'
  ClientHeight = 720
  ClientWidth = 1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 1080
    Height = 696
    Align = alClient
    TabOrder = 0
    object CoursesTab: TTabSheet
      Caption = 'Courses'
      object PanelCourses: TPanel
        Left = 0
        Top = 0
        Width = 1072
        Height = 48
        Align = alTop
        TabOrder = 0
        object btnNewCourse: TButton
          Left = 8
          Top = 10
          Width = 100
          Height = 25
          Caption = 'New Course'
          TabOrder = 0
          OnClick = btnNewCourseClick
        end
        object btnEditCourse: TButton
          Left = 116
          Top = 10
          Width = 100
          Height = 25
          Caption = 'Edit Course'
          TabOrder = 1
        end
        object btnDeleteCourse: TButton
          Left = 224
          Top = 10
          Width = 100
          Height = 25
          Caption = 'Delete Course'
          TabOrder = 2
        end
        object btnSearchCourse: TButton
          Left = 332
          Top = 10
          Width = 100
          Height = 25
          Caption = 'Search'
          TabOrder = 3
        end
      end
      object CoursesGrid: TStringGrid
        Left = 0
        Top = 48
        Width = 1072
        Height = 620
        Align = alClient
        ColCount = 6
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 1
      end
    end
    object StudentsTab: TTabSheet
      Caption = 'Students'
      ImageIndex = 1
      object PanelStudents: TPanel
        Left = 0
        Top = 0
        Width = 1072
        Height = 48
        Align = alTop
        TabOrder = 0
        object btnNewStudent: TButton
          Left = 8
          Top = 10
          Width = 100
          Height = 25
          Caption = 'New Student'
          TabOrder = 0
          OnClick = btnNewStudentClick
        end
        object btnEditStudent: TButton
          Left = 116
          Top = 10
          Width = 100
          Height = 25
          Caption = 'Edit Student'
          TabOrder = 1
        end
        object btnDeleteStudent: TButton
          Left = 224
          Top = 10
          Width = 100
          Height = 25
          Caption = 'Delete Student'
          TabOrder = 2
        end
        object btnSearchStudent: TButton
          Left = 332
          Top = 10
          Width = 100
          Height = 25
          Caption = 'Search'
          TabOrder = 3
        end
      end
      object StudentsGrid: TStringGrid
        Left = 0
        Top = 48
        Width = 1072
        Height = 620
        Align = alClient
        ColCount = 4
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 1
      end
    end
    object InstructorsTab: TTabSheet
      Caption = 'Instructors'
      ImageIndex = 2
      object PanelInstructors: TPanel
        Left = 0
        Top = 0
        Width = 1072
        Height = 48
        Align = alTop
        TabOrder = 0
        object btnNewInstructor: TButton
          Left = 8
          Top = 10
          Width = 120
          Height = 25
          Caption = 'New Instructor'
          TabOrder = 0
          OnClick = btnNewInstructorClick
        end
        object btnEditInstructor: TButton
          Left = 136
          Top = 10
          Width = 110
          Height = 25
          Caption = 'Edit Instructor'
          TabOrder = 1
        end
        object btnDeleteInstructor: TButton
          Left = 254
          Top = 10
          Width = 120
          Height = 25
          Caption = 'Delete Instructor'
          TabOrder = 2
        end
        object btnSearchInstructor: TButton
          Left = 382
          Top = 10
          Width = 100
          Height = 25
          Caption = 'Search'
          TabOrder = 3
        end
      end
      object InstructorsGrid: TStringGrid
        Left = 0
        Top = 48
        Width = 1072
        Height = 620
        Align = alClient
        ColCount = 4
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 1
      end
    end
    object BookingsTab: TTabSheet
      Caption = 'Bookings'
      ImageIndex = 3
      object PanelBookings: TPanel
        Left = 0
        Top = 0
        Width = 1072
        Height = 48
        Align = alTop
        TabOrder = 0
        object btnNewBooking: TButton
          Left = 8
          Top = 10
          Width = 110
          Height = 25
          Caption = 'New Booking'
          TabOrder = 0
          OnClick = btnNewBookingClick
        end
        object btnEditBooking: TButton
          Left = 126
          Top = 10
          Width = 110
          Height = 25
          Caption = 'Edit Booking'
          TabOrder = 1
        end
        object btnDeleteBooking: TButton
          Left = 244
          Top = 10
          Width = 120
          Height = 25
          Caption = 'Delete Booking'
          TabOrder = 2
        end
      end
      object BookingsGrid: TStringGrid
        Left = 0
        Top = 48
        Width = 1072
        Height = 620
        Align = alClient
        ColCount = 5
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 1
      end
    end
    object AssignmentsTab: TTabSheet
      Caption = 'Assignments'
      ImageIndex = 4
      object PanelAssignments: TPanel
        Left = 0
        Top = 0
        Width = 1072
        Height = 48
        Align = alTop
        TabOrder = 0
        object btnNewAssignment: TButton
          Left = 8
          Top = 10
          Width = 120
          Height = 25
          Caption = 'New Assignment'
          TabOrder = 0
          OnClick = btnNewAssignmentClick
        end
        object btnEditAssignment: TButton
          Left = 136
          Top = 10
          Width = 120
          Height = 25
          Caption = 'Edit Assignment'
          TabOrder = 1
        end
        object btnDeleteAssignment: TButton
          Left = 264
          Top = 10
          Width = 130
          Height = 25
          Caption = 'Delete Assignment'
          TabOrder = 2
        end
      end
      object AssignmentsGrid: TStringGrid
        Left = 0
        Top = 48
        Width = 1072
        Height = 620
        Align = alClient
        ColCount = 4
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 1
      end
    end
    object ReportsTab: TTabSheet
      Caption = 'Reports'
      ImageIndex = 5
      object PanelReports: TPanel
        Left = 0
        Top = 0
        Width = 1072
        Height = 48
        Align = alTop
        TabOrder = 0
        object btnGenerateReport: TButton
          Left = 8
          Top = 10
          Width = 130
          Height = 25
          Caption = 'Generate Report'
          TabOrder = 0
          OnClick = btnGenerateReportClick
        end
        object btnExportCSV: TButton
          Left = 146
          Top = 10
          Width = 120
          Height = 25
          Caption = 'Export CSV'
          TabOrder = 1
          OnClick = btnExportCSVClick
        end
      end
      object ReportMemo: TMemo
        Left = 0
        Top = 48
        Width = 1072
        Height = 620
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 696
    Width = 1080
    Height = 24
    Panels = <>
    SimplePanel = True
    SimpleText = 'Ready'
  end
end

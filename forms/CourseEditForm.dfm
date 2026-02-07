object CourseEditForm: TCourseEditForm
  Left = 0
  Top = 0
  Caption = 'Course'
  ClientHeight = 280
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 77
    Height = 13
    Caption = 'Course Name:'
  end
  object edtCourseName: TEdit
    Left = 16
    Top = 32
    Width = 385
    Height = 21
    TabOrder = 0
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 54
    Height = 13
    Caption = 'Start Date:'
  end
  object dtpStartDate: TDateTimePicker
    Left = 16
    Top = 80
    Width = 185
    Height = 21
    Date = 45250.000000000000000000
    Time = 0.750000000000000000
    TabOrder = 1
  end
  object Label3: TLabel
    Left = 216
    Top = 64
    Width = 49
    Height = 13
    Caption = 'End Date:'
  end
  object dtpEndDate: TDateTimePicker
    Left = 216
    Top = 80
    Width = 185
    Height = 21
    Date = 45250.000000000000000000
    Time = 0.750000000000000000
    TabOrder = 2
  end
  object Label4: TLabel
    Left = 16
    Top = 112
    Width = 31
    Height = 13
    Caption = 'Level:'
  end
  object cmbLevel: TComboBox
    Left = 16
    Top = 128
    Width = 185
    Height = 21
    Style = csDropDownList
    TabOrder = 3
  end
  object Label5: TLabel
    Left = 216
    Top = 112
    Width = 69
    Height = 13
    Caption = 'Max Students:'
  end
  object spnMaxStudents: TSpinEdit
    Left = 216
    Top = 128
    Width = 185
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 4
    Value = 15
  end
  object btnSave: TButton
    Left = 240
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 5
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 326
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = btnCancelClick
  end
end

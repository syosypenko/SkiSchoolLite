object AssignmentEditForm: TAssignmentEditForm
  Left = 0
  Top = 0
  Caption = 'Assignment'
  ClientHeight = 240
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
    Width = 40
    Height = 13
    Caption = 'Course:'
  end
  object cmbCourse: TComboBox
    Left = 16
    Top = 32
    Width = 385
    Height = 21
    Style = csDropDownList
    TabOrder = 0
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 56
    Height = 13
    Caption = 'Instructor:'
  end
  object cmbInstructor: TComboBox
    Left = 16
    Top = 80
    Width = 385
    Height = 21
    Style = csDropDownList
    TabOrder = 1
  end
  object Label3: TLabel
    Left = 16
    Top = 112
    Width = 73
    Height = 13
    Caption = 'Assigned Date:'
  end
  object dtpAssignedDate: TDateTimePicker
    Left = 16
    Top = 128
    Width = 185
    Height = 21
    Date = 45250.000000000000000000
    Time = 0.750000000000000000
    TabOrder = 2
  end
  object btnSave: TButton
    Left = 240
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 326
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
end

object StudentEditForm: TStudentEditForm
  Left = 0
  Top = 0
  Caption = 'Student'
  ClientHeight = 220
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 77
    Height = 13
    Caption = 'Student Name:'
  end
  object edtStudentName: TEdit
    Left = 16
    Top = 32
    Width = 385
    Height = 21
    TabOrder = 0
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 32
    Height = 13
    Caption = 'Email:'
  end
  object edtEmail: TEdit
    Left = 16
    Top = 80
    Width = 385
    Height = 21
    TabOrder = 1
  end
  object Label3: TLabel
    Left = 16
    Top = 112
    Width = 34
    Height = 13
    Caption = 'Phone:'
  end
  object edtPhone: TEdit
    Left = 16
    Top = 128
    Width = 385
    Height = 21
    TabOrder = 2
  end
  object btnSave: TButton
    Left = 240
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 326
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
end

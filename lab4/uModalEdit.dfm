object frmEdit: TfrmEdit
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077'/'#1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
  ClientHeight = 162
  ClientWidth = 212
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object leName: TLabeledEdit
    Left = 8
    Top = 24
    Width = 193
    Height = 21
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
    TabOrder = 0
  end
  object lePages: TLabeledEdit
    Left = 8
    Top = 72
    Width = 193
    Height = 21
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = #1057#1090#1088#1072#1085#1080#1094#1099
    TabOrder = 1
  end
  object cbChild: TCheckBox
    Left = 8
    Top = 99
    Width = 193
    Height = 17
    Caption = #1071#1074#1083#1103#1077#1090#1089#1103' '#1087#1086#1076#1090#1077#1088#1084#1080#1085#1086#1084'?'
    TabOrder = 2
  end
  object btnOk: TButton
    Left = 8
    Top = 122
    Width = 91
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 111
    Top = 122
    Width = 90
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end

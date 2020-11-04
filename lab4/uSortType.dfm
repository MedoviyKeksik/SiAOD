object frmSortType: TfrmSortType
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1058#1080#1087' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1080
  ClientHeight = 177
  ClientWidth = 207
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
  object btnOk: TButton
    Left = 8
    Top = 143
    Width = 86
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 112
    Top = 143
    Width = 86
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object rgSortBy: TRadioGroup
    Left = 8
    Top = 8
    Width = 190
    Height = 65
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1086
    ItemIndex = 0
    Items.Strings = (
      #1053#1072#1079#1074#1072#1085#1080#1102
      #1053#1086#1084#1077#1088#1072#1084' '#1089#1090#1088#1072#1085#1080#1094)
    TabOrder = 2
  end
  object rgSortOrder: TRadioGroup
    Left = 8
    Top = 72
    Width = 190
    Height = 65
    Caption = #1055#1086#1088#1103#1076#1086#1082
    ItemIndex = 0
    Items.Strings = (
      #1055#1086' '#1074#1086#1079#1088#1072#1089#1090#1072#1085#1080#1102
      #1055#1086' '#1091#1073#1099#1074#1072#1085#1080#1102)
    TabOrder = 3
  end
end

object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Labirinth'
  ClientHeight = 547
  ClientWidth = 756
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = menuMain
  OldCreateOrder = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object imgMain: TImage
    Left = 16
    Top = 16
    Width = 505
    Height = 505
    OnMouseMove = imgMainMouseMove
    OnMouseUp = imgMainMouseUp
  end
  object lblLevel: TLabel
    Left = 544
    Top = 16
    Width = 28
    Height = 13
    Caption = 'Floor:'
    WordWrap = True
  end
  object btnStart: TButton
    Left = 544
    Top = 465
    Width = 193
    Height = 56
    Caption = 'Start'
    TabOrder = 0
    OnClick = btnStartClick
  end
  object comboFloor: TComboBox
    Left = 544
    Top = 35
    Width = 194
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    OnChange = comboFloorChange
  end
  object menuMain: TMainMenu
    Left = 600
    Top = 264
  end
end

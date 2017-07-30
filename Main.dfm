object frmMain: TfrmMain
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'I Hear, Thanks! (beta version)'
  ClientHeight = 106
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 377
    Height = 89
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 60
      Height = 13
      Caption = 'Choose file: '
    end
    object btnStart: TButton
      Left = 16
      Top = 54
      Width = 74
      Height = 23
      Caption = 'Go'
      TabOrder = 0
      OnClick = btnStartClick
    end
    object txtFilename: TEdit
      Left = 16
      Top = 27
      Width = 267
      Height = 21
      TabOrder = 1
    end
    object btnChooseFile: TButton
      Left = 293
      Top = 27
      Width = 74
      Height = 23
      Caption = 'Browse...'
      TabOrder = 2
      OnClick = btnChooseFileClick
    end
    object chkShellIntegration: TCheckBox
      Left = 114
      Top = 54
      Width = 97
      Height = 17
      Caption = 'Shell Integration'
      TabOrder = 3
    end
    object chkAlwaysOnTop: TCheckBox
      Left = 238
      Top = 54
      Width = 97
      Height = 17
      Caption = 'Always On Top'
      TabOrder = 4
      OnClick = chkAlwaysOnTopClick
    end
  end
end

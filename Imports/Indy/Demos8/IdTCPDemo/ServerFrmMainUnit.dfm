object ServerFrmMain: TServerFrmMain
  Left = 192
  Top = 107
  Width = 454
  Height = 221
  Caption = 'Test-Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object CBServerActive: TCheckBox
    Left = 4
    Top = 4
    Width = 57
    Height = 17
    Caption = 'active'
    TabOrder = 0
    OnClick = CBServerActiveClick
  end
  object Protocol: TMemo
    Left = 4
    Top = 28
    Width = 437
    Height = 161
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Server: TIdTCPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 47110
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = ServerConnect
    OnExecute = ServerExecute
    OnDisconnect = ServerDisconnect
    ReplyExceptionCode = 0
    ReplyUnknownCommand.NumericCode = 0
    ThreadMgr = IdThreadMgrDefault1
    Left = 184
    Top = 76
  end
  object IdThreadMgrDefault1: TIdThreadMgrDefault
    Left = 224
    Top = 76
  end
end
inherited fmEditRBPms_Agent: TfmEditRBPms_Agent
  Left = 588
  Top = 271
  Caption = 'fmEditRBPms_Agent'
  ClientHeight = 203
  ClientWidth = 305
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 18
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = '������������:'
  end
  object lbNote: TLabel [1]
    Left = 34
    Top = 70
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = '��������:'
  end
  object lbSortNumber: TLabel [2]
    Left = 40
    Top = 123
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = '�������:'
  end
  object lbOffice: TLabel [3]
    Left = 56
    Top = 44
    Width = 31
    Height = 13
    Alignment = taRightJustify
    Caption = '����:'
    FocusControl = ComboBoxOffice
  end
  object lbPhone: TLabel [4]
    Left = 39
    Top = 94
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = '�������:'
  end
  inherited pnBut: TPanel
    Top = 165
    Width = 305
    TabOrder = 7
    inherited Panel2: TPanel
      Left = 120
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 146
    TabOrder = 6
  end
  object edName: TEdit [7]
    Left = 97
    Top = 14
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edNote: TEdit [8]
    Left = 97
    Top = 66
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edNameChange
  end
  object edSort: TEdit [9]
    Left = 97
    Top = 120
    Width = 46
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = '1'
    OnChange = edSortChange
  end
  object udSort: TUpDown [10]
    Left = 143
    Top = 120
    Width = 15
    Height = 21
    Associate = edSort
    Min = 1
    Position = 1
    TabOrder = 4
    Wrap = False
    OnChanging = udSortChanging
  end
  object ComboBoxOffice: TComboBox [11]
    Left = 97
    Top = 40
    Width = 199
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = edNameChange
  end
  object edPhone: TEdit [12]
    Left = 97
    Top = 91
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 5
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 264
    Top = 137
  end
end
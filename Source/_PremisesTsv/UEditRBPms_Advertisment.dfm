inherited fmEditRBPms_Advertisment: TfmEditRBPms_Advertisment
  Left = 520
  Top = 306
  Caption = 'fmEditRBPms_Advertisment'
  ClientHeight = 209
  ClientWidth = 309
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 10
    Top = 16
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = '������������:'
  end
  object lbNote: TLabel [1]
    Left = 36
    Top = 43
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = '��������:'
  end
  object lbAmount: TLabel [2]
    Left = 27
    Top = 68
    Width = 62
    Height = 13
    Alignment = taRightJustify
    Caption = '����������:'
  end
  object lbTypeOperation: TLabel [3]
    Left = 16
    Top = 96
    Width = 73
    Height = 13
    Alignment = taRightJustify
    Caption = '��� ��������:'
  end
  object LabelSortnumber: TLabel [4]
    Left = 42
    Top = 122
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = '�������:'
  end
  inherited pnBut: TPanel
    Top = 171
    Width = 309
    TabOrder = 8
    inherited Panel2: TPanel
      Left = 124
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 152
    TabOrder = 7
  end
  object edName: TEdit [7]
    Left = 99
    Top = 12
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edNote: TEdit [8]
    Left = 99
    Top = 39
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edNameChange
  end
  object edAmount: TEdit [9]
    Left = 99
    Top = 66
    Width = 46
    Height = 21
    TabOrder = 2
    Text = '1'
    OnChange = edAmountChange
  end
  object udAmount: TUpDown [10]
    Left = 146
    Top = 66
    Width = 15
    Height = 21
    Associate = edAmount
    Min = 1
    Max = 999
    Position = 1
    TabOrder = 3
    Wrap = False
    OnChanging = udAmountChanging
  end
  object cmbTypeOperation: TComboBox [11]
    Left = 99
    Top = 93
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = edNameChange
  end
  object EditSortnumber: TEdit [12]
    Left = 99
    Top = 120
    Width = 46
    Height = 21
    TabOrder = 5
    Text = '0'
    OnChange = edAmountChange
  end
  object UpDownSortnumber: TUpDown [13]
    Left = 145
    Top = 120
    Width = 15
    Height = 21
    Associate = EditSortnumber
    Min = 0
    Max = 999
    Position = 0
    TabOrder = 6
    Wrap = False
    OnChanging = udAmountChanging
  end
  inherited IBTran: TIBTransaction
    Left = 219
    Top = 29
  end
end

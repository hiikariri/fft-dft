object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 824
  ClientWidth = 1293
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Chart1: TChart
    Left = 167
    Top = 24
    Width = 1113
    Height = 250
    Legend.Visible = False
    Title.Text.Strings = (
      'Raw ECG (ML II)')
    BottomAxis.Title.Caption = 'Time (s)'
    LeftAxis.Title.Caption = 'Amplitude'
    View3D = False
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      38
      15
      38)
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      HoverElement = [heCurrent]
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 145
    Height = 233
    Caption = 'Control Panel'
    TabOrder = 1
    object btn_process: TBitBtn
      Left = 16
      Top = 25
      Width = 113
      Height = 40
      Caption = 'Process'
      TabOrder = 0
      OnClick = btn_processClick
    end
    object btn_close: TBitBtn
      Left = 16
      Top = 182
      Width = 113
      Height = 40
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 1
    end
    object LabeledEdit1: TLabeledEdit
      Left = 16
      Top = 87
      Width = 113
      Height = 23
      EditLabel.Width = 108
      EditLabel.Height = 15
      EditLabel.Caption = 'Sampling Frequency'
      TabOrder = 2
      Text = ''
    end
    object Edit1: TEdit
      Left = 16
      Top = 116
      Width = 113
      Height = 23
      TabOrder = 3
      Text = '600'
    end
  end
  object Chart3: TChart
    Left = 775
    Top = 288
    Width = 505
    Height = 250
    Legend.CheckBoxes = True
    Title.Text.Strings = (
      'MLII DFT Result')
    BottomAxis.Title.Caption = 'Frequency (Hz)'
    LeftAxis.Title.Caption = 'Magnitude'
    View3D = False
    TabOrder = 2
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      27
      15
      27)
    ColorPaletteIndex = 13
    object Series3: TLineSeries
      HoverElement = [heCurrent]
      Title = 'ECG'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series5: TLineSeries
      HoverElement = [heCurrent]
      Title = 'P'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series6: TLineSeries
      HoverElement = [heCurrent]
      Title = 'QRS'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series7: TLineSeries
      HoverElement = [heCurrent]
      Title = 'T/U'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series14: TLineSeries
      HoverElement = [heCurrent]
      SeriesColor = 16711808
      Title = 'ECG Windowed'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object ListBox1: TListBox
    Left = 8
    Top = 247
    Width = 145
    Height = 66
    ItemHeight = 15
    TabOrder = 3
  end
  object Chart2: TChart
    Left = 167
    Top = 288
    Width = 602
    Height = 250
    Legend.CheckBoxes = True
    Title.Text.Strings = (
      'Sampled Raw ECG')
    BottomAxis.Title.Caption = 'Time (s)'
    LeftAxis.Title.Caption = 'Amplitude'
    View3D = False
    TabOrder = 4
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      38
      15
      38)
    ColorPaletteIndex = 13
    object Series2: TLineSeries
      HoverElement = [heCurrent]
      Title = 'Raw Signal'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series13: TLineSeries
      HoverElement = [heCurrent]
      SeriesColor = clRed
      Title = 'Localized Signal'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Chart4: TChart
    Left = 775
    Top = 555
    Width = 505
    Height = 250
    Title.Text.Strings = (
      'Extraction Result')
    BottomAxis.Title.Caption = 'Time (s)'
    LeftAxis.Title.Caption = 'Amplitude'
    View3D = False
    TabOrder = 5
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series4: TLineSeries
      HoverElement = [heCurrent]
      Title = 'P and T Extraction'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series12: TLineSeries
      HoverElement = [heCurrent]
      Title = 'QRS Extraction'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Chart5: TChart
    Left = 167
    Top = 555
    Width = 602
    Height = 250
    Legend.CheckBoxes = True
    Title.Text.Strings = (
      'Filter Result')
    BottomAxis.Title.Caption = 'Time (s)'
    LeftAxis.Title.Caption = 'Amplitude'
    View3D = False
    TabOrder = 6
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series8: TLineSeries
      HoverElement = [heCurrent]
      Title = 'P Filtered'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series9: TLineSeries
      HoverElement = [heCurrent]
      Title = 'QRS Filtered'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series10: TLineSeries
      HoverElement = [heCurrent]
      Title = 'T/U Filtered'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series11: TLineSeries
      HoverElement = [heCurrent]
      Title = 'Raw Signal'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object ListBox2: TListBox
    Left = 8
    Top = 319
    Width = 145
    Height = 66
    ItemHeight = 15
    TabOrder = 7
  end
  object ListBox3: TListBox
    Left = 8
    Top = 391
    Width = 145
    Height = 66
    ItemHeight = 15
    TabOrder = 8
  end
  object ListBox4: TListBox
    Left = 8
    Top = 463
    Width = 145
    Height = 66
    ItemHeight = 15
    TabOrder = 9
  end
  object open_dialog1: TOpenDialog
    FileName = 'D:\ITS\MATKUL\Semester 5\PSB\ecg freq analysis\ecg 100.dat'
    Left = 16
    Top = 544
  end
end

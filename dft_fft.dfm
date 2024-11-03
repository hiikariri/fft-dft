object Form1: TForm1
  Left = 710
  Top = 33
  Caption = 'Control Panel'
  ClientHeight = 796
  ClientWidth = 1473
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDesigned
  TextHeight = 13
  object cht1: TChart
    Left = 168
    Top = 24
    Width = 425
    Height = 250
    Legend.Visible = False
    Title.Text.Strings = (
      'Raw Signal')
    BottomAxis.Title.Caption = 'Time (s)'
    LeftAxis.Title.Caption = 'Amplitude'
    View3D = False
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      HoverElement = [heCurrent]
      SeriesColor = clRed
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object grp1: TGroupBox
    Left = 8
    Top = 16
    Width = 145
    Height = 265
    Caption = 'Control Panel'
    TabOrder = 1
    object btn1: TBitBtn
      Left = 16
      Top = 176
      Width = 113
      Height = 33
      Caption = 'Process'
      TabOrder = 0
      OnClick = btn1Click
    end
    object lbledt1: TLabeledEdit
      Left = 16
      Top = 40
      Width = 113
      Height = 21
      EditLabel.Width = 116
      EditLabel.Height = 13
      EditLabel.Caption = 'Sampling Frequency (fs)'
      TabOrder = 1
      Text = '256'
    end
    object lbledt2: TLabeledEdit
      Left = 16
      Top = 104
      Width = 113
      Height = 21
      EditLabel.Width = 74
      EditLabel.Height = 13
      EditLabel.Caption = 'Sample Size (N)'
      TabOrder = 2
      Text = '512'
    end
    object btn2: TBitBtn
      Left = 16
      Top = 216
      Width = 113
      Height = 33
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 3
    end
    object lbledt3: TLabeledEdit
      Left = 16
      Top = 144
      Width = 113
      Height = 21
      EditLabel.Width = 82
      EditLabel.Height = 13
      EditLabel.Caption = 'Signal Frequency'
      TabOrder = 4
      Text = '0.25'
    end
    object txt1: TStaticText
      Left = 8
      Top = 64
      Width = 131
      Height = 17
      Caption = 'fs = k *  N, k = 1, 2, 3, ...'
      TabOrder = 5
    end
  end
  object cht2: TChart
    Left = 168
    Top = 280
    Width = 425
    Height = 250
    Legend.Visible = False
    Title.Text.Strings = (
      'DFT')
    BottomAxis.Title.Caption = 'Frequency (Hz)'
    LeftAxis.Title.Caption = 'Magnitude'
    View3D = False
    TabOrder = 2
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object barSeries2: TBarSeries
      HoverElement = []
      BarPen.Visible = False
      Marks.Visible = False
      Marks.Callout.Length = 8
      SeriesColor = clRed
      BarWidthPercent = 40
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object cht3: TChart
    Left = 168
    Top = 536
    Width = 425
    Height = 250
    Legend.Visible = False
    Title.Text.Strings = (
      'FFT')
    BottomAxis.Title.Caption = 'Frequency (Hz)'
    LeftAxis.Title.Caption = 'Magnitude'
    View3D = False
    TabOrder = 3
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object barSeries3: TBarSeries
      HoverElement = []
      BarPen.Visible = False
      Marks.Visible = False
      Marks.Callout.Length = 8
      SeriesColor = clRed
      BarWidthPercent = 35
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object cht6: TChart
    Left = 1040
    Top = 280
    Width = 425
    Height = 250
    Legend.Visible = False
    Title.Text.Strings = (
      'IDFT')
    BottomAxis.Title.Caption = 'Time (s)'
    LeftAxis.Title.Caption = 'Amplitude'
    View3D = False
    TabOrder = 4
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series2: TLineSeries
      HoverElement = [heCurrent]
      SeriesColor = clRed
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object cht7: TChart
    Left = 1040
    Top = 536
    Width = 425
    Height = 250
    Legend.Visible = False
    Title.Text.Strings = (
      'IFFT')
    BottomAxis.Title.Caption = 'Time (s)'
    LeftAxis.Title.Caption = 'Amplitude'
    View3D = False
    TabOrder = 5
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      27
      15
      27)
    ColorPaletteIndex = 13
    object Series3: TLineSeries
      HoverElement = [heCurrent]
      Selected.Hover.Visible = False
      SeriesColor = clRed
      LinePen.Color = clRed
      LinePen.EndStyle = esFlat
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      TreatNulls = tnIgnore
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object cht4: TChart
    Left = 608
    Top = 280
    Width = 417
    Height = 249
    Legend.Visible = False
    Title.Text.Strings = (
      'DFT Magnitude Normalization')
    BottomAxis.Title.Caption = 'Frequency'
    LeftAxis.Title.Caption = 'Magnitude'
    View3D = False
    TabOrder = 6
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object barSeries4: TBarSeries
      HoverElement = []
      BarPen.Visible = False
      Marks.Visible = False
      Marks.Callout.Length = 8
      SeriesColor = clRed
      BarWidthPercent = 35
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object cht5: TChart
    Left = 608
    Top = 536
    Width = 417
    Height = 250
    Legend.Visible = False
    Title.Text.Strings = (
      'FFT Magnitude Normalization')
    BottomAxis.Title.Caption = 'Frequency'
    LeftAxis.Title.Caption = 'Magnitude'
    View3D = False
    TabOrder = 7
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object barSeries5: TBarSeries
      HoverElement = []
      BarPen.Visible = False
      Marks.Visible = False
      Marks.Callout.Length = 8
      SeriesColor = clRed
      BarWidthPercent = 35
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
end

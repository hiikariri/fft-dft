unit ecg_freq_domain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Math, System.IOUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, VCLTee.Series, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  VCLTee.TeeProcs, VCLTee.Chart, System.Generics.Collections, Vcl.Mask;

type
  TForm1 = class(TForm)
    Chart1: TChart;
    btn_process: TBitBtn;
    GroupBox1: TGroupBox;
    btn_close: TBitBtn;
    Series1: TLineSeries;
    open_dialog1: TOpenDialog;
    Chart3: TChart;
    Series3: TLineSeries;
    LabeledEdit1: TLabeledEdit;
    ListBox1: TListBox;
    Edit1: TEdit;
    Chart2: TChart;
    Series2: TLineSeries;
    Chart4: TChart;
    Series4: TLineSeries;
    Series5: TLineSeries;
    Series6: TLineSeries;
    Series7: TLineSeries;
    Chart5: TChart;
    Series8: TLineSeries;
    Series9: TLineSeries;
    Series10: TLineSeries;
    Series11: TLineSeries;
    Series12: TLineSeries;
    Series13: TLineSeries;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Series14: TLineSeries;
    procedure LoadECGData(var time_data, mlii_data, v5_data: TArray<Double>);
    procedure btn_processClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  time_data, mlii_data, mlii_data_windowed, v5_data, p, qrs, t_u : TArray<Double>;
  time_sampling, frequency_sampling : Double;
  total_data_size, length_used : Integer;

implementation

{$R *.dfm}
type
  TComplex = record
    Re, Im: Double;
  end;
  TArrayOfComplex = array of TComplex;
  TArrayOfDouble = array of Double;
  TDFTResult = record
    magnitude: TArrayOfDouble;
    real_part: TArrayOfDouble;
    imag_part: TArrayOfDouble;
  end;

function hanning_windowing(data: TArray<Double>): TArray<Double>;
var
  i, N: Integer;
  wh: TArray<Double>;
begin
  N := Length(data);
  SetLength(wh, N);

  for i := 0 to N - 1 do
    wh[i] := data[i] * (0.5 * (1 - Cos(2 * Pi * i / (N - 1))));

  Result := wh;
end;

function complex_multiply(a, b: TComplex): TComplex;
begin
  Result.Re := a.Re * b.Re - a.Im * b.Im;
  Result.Im := a.Re * b.Im + a.Im * b.Re;
end;

function make_complex(re, im: Double): TComplex;
begin
  Result.Re := re;
  Result.Im := im;
end;

function complex_magnitude(c: TComplex): Double;
begin
  Result := Sqrt(c.Re * c.Re + c.Im * c.Im);
end;

function dft(input_data: TArrayOfComplex): TDFTResult;
var
  i, k, length_used: Integer;
begin
  length_used := Length(input_data);
  SetLength(Result.real_part, length_used);
  SetLength(Result.imag_part, length_used);
  SetLength(Result.magnitude, length_used);

  // Initialize arrays to zero
  for i := 0 to length_used - 1 do
  begin
    Result.real_part[i] := 0;
    Result.imag_part[i] := 0;
  end;

  for i := 0 to length_used - 1 do
  begin
    for k := 0 to length_used - 1 do
    begin
      Result.real_part[i] := Result.real_part[i] + input_data[k].Re * Cos(2 * Pi * i * k / length_used);
      Result.imag_part[i] := Result.imag_part[i] - input_data[k].Re * Sin(2 * Pi * i * k / length_used);
    end;
  end;

  for i := 0 to length_used - 1 do
  begin
    Result.magnitude[i] := Sqrt(Sqr(Result.real_part[i]) + Sqr(Result.imag_part[i]));
  end;
end;

procedure calculateMPF(ListBox1: TListBox; mlii_dft_result: TDFTResult);
var
  i: Integer;
  mlii_power: TArrayOfDouble;
  total_power, cumulative_power, half_power: Double;
  center_freq, mean_power_freq, freq: Double;
begin
  // Initialize Power Spectrum for MLII data
  SetLength(mlii_power, length_used);
  total_power := 0.0;

  // Calculate power for each frequency component and total power
  for i := 0 to length_used - 1 do
  begin
    mlii_power[i] := Sqr(mlii_dft_result.real_part[i]) + Sqr(mlii_dft_result.imag_part[i]);
    total_power := total_power + mlii_power[i];
  end;

  // Avoid division by zero if total power is zero
  if total_power = 0 then
  begin
    ListBox1.Items.Add('Total power is zero, cannot calculate MPF or CF.');
    Exit;
  end;

  // Calculate Mean Power Frequency (MPF)
  mean_power_freq := 0.0;
  for i := 0 to length_used - 1 do
  begin
    freq := i * frequency_sampling / length_used;
    mean_power_freq := mean_power_freq + (freq * mlii_power[i] / total_power);
  end;

  // Calculate Center Frequency (CF)
  half_power := total_power / 2.0;
  cumulative_power := 0.0;
  center_freq := 0.0;
  for i := 0 to length_used - 1 do
  begin
    cumulative_power := cumulative_power + mlii_power[i];
    if cumulative_power >= half_power then
    begin
      center_freq := i * frequency_sampling / length_used;
      Break;
    end;
  end;

  // Display calculated frequencies
  ListBox1.Items.Add('Mean Power Freq: ' + FloatToStr(mean_power_freq));
  ListBox1.Items.Add('Center Freq: ' + FloatToStr(center_freq));
end;

function designFIRBandpass(filterOrder: Integer; lowCutoff, highCutoff: Double): TArray<Double>;
var
  i: Integer;
  wc1, wc2: Double;
  n: Integer;
begin
  SetLength(Result, filterOrder + 1);
  wc1 := 2 * Pi * lowCutoff / frequency_sampling;
  wc2 := 2 * Pi * highCutoff / frequency_sampling;
  n := filterOrder div 2;

  // Calculate filter coefficients
  for i := 0 to filterOrder do
  begin
    if (i - n) = 0 then
      Result[i] := (wc2 - wc1) / Pi
    else
      Result[i] := (Sin(wc2 * (i - n)) - Sin(wc1 * (i - n))) / (Pi * (i - n));

    // Apply Hamming window
    Result[i] := Result[i] * (0.54 - 0.46 * Cos(2 * Pi * i / filterOrder));
  end;
end;

function applyFIRFilter(input: TArray<Double>; coefficients: TArray<Double>): TArray<Double>;
var
  i, j: Integer;
  sum: Double;
  filterOrder: Integer;
begin
  SetLength(Result, Length(input));
  filterOrder := Length(coefficients) - 1;

  for i := 0 to High(input) do
  begin
    sum := 0;
    for j := 0 to filterOrder do
    begin
      if (i - j) >= 0 then
        sum := sum + coefficients[j] * input[i - j];
    end;
    Result[i] := sum;
  end;
end;

function FIRBandpassFilter(lowCutoff, highCutoff: Double): TFunc<TArray<Double>, TArray<Double>>;
var
  filterOrder: Integer;
  coefficients: TArray<Double>;
begin
  filterOrder := 100; // You can adjust this value based on your needs
  coefficients := designFIRBandpass(filterOrder, lowCutoff, highCutoff);

  Result := function(input: TArray<Double>): TArray<Double>
  begin
    Result := applyFIRFilter(input, coefficients);
  end;
end;

function BackwardForwardFilter(data: TArray<Double>; filterFunc: TFunc<TArray<Double>, TArray<Double>>): TArray<Double>;
var
  forwardFiltered, reversed: TArray<Double>;
  i: Integer;
begin
  // Forward filtering
  forwardFiltered := filterFunc(data);

  // Reverse the signal
  SetLength(reversed, Length(forwardFiltered));
  for i := 0 to High(forwardFiltered) do
    reversed[i] := forwardFiltered[High(forwardFiltered) - i];

  // Backward filtering
  reversed := filterFunc(reversed);

  // Reverse again to get the final result
  SetLength(Result, Length(reversed));
  for i := 0 to High(reversed) do
    Result[i] := reversed[High(reversed) - i];
end;

function MovingAverage(orderFilter: Integer): TFunc<TArray<Double>, TArray<Double>>;
begin
  Result := function(input: TArray<Double>): TArray<Double>
  var
    i, j: Integer;
    sum: Double;
  begin
    SetLength(Result, Length(input));
    for i := 0 to High(input) do
    begin
      sum := 0;
      for j := 0 to orderFilter - 1 do
      begin
        if (i - j) >= 0 then
          sum := sum + input[i - j];
      end;
      Result[i] := sum / orderFilter;
    end;
  end;
end;

procedure TForm1.btn_processClick(Sender: TObject);
var
  i : Integer;
  mlii_sum, p_time_start, p_time_end, qrs_time_start, qrs_time_end, tu_time_start, tu_time_end: Double;
  frequency_data: TArrayOfComplex;
  mlii_one_signal_complex, mlii_complex, mlii_window_complex, p_complex, qrs_complex, tu_complex: TArrayOfComplex;
  p_data, qrs_data, tu_data: TArray<Double>;
  mlii_dft_result, mlii_window_dft_result, p_dft_result, qrs_dft_result, tu_dft_result: TDFTResult;
  filtered_p, filtered_qrs, filtered_t: TArray<Double>;
begin
  Series1.Clear;
  Series2.Clear;
  Series3.Clear;
  Series4.Clear;
  Series5.Clear;
  Series6.Clear;
  Series7.Clear;
  Series8.Clear;
  Series9.Clear;
  Series10.Clear;
  Series11.Clear;
  Series12.Clear;
  Series13.Clear;
  Series14.Clear;
  mlii_sum := 0;
  length_used := StrToInt(Edit1.Text);
  LoadECGData(time_data, mlii_data, v5_data);

  total_data_size := Length(mlii_data);

  SetLength(p_data, length_used);
  SetLength(qrs_data, length_used);
  SetLength(tu_data, length_used);

  time_sampling := 60.0 / total_data_size;
  frequency_sampling := 1 / time_sampling;
  LabeledEdit1.Text := FloatToStr(frequency_sampling);

  p_time_start := 0.82;
  p_time_end := 0.91;
  qrs_time_start := 0.96;
  qrs_time_end := 1.08;
  tu_time_start := 1.32;
  tu_time_end := 1.63;

  // Calculate the mean for each data set for detrending
  for i := Low(time_data) to High(time_data) do
  begin
    mlii_sum := mlii_sum + mlii_data[i];
  end;

  for i := Low(mlii_data) to High(mlii_data) do
  begin
    mlii_data[i] := mlii_data[i] - (mlii_sum / total_data_size);
    Series1.AddXY(time_data[i], mlii_data[i]);
  end;

  for i := 0 to length_used - 1 do
  begin
    p_data[i] := 0;
    qrs_data[i] := 0;
    tu_data[i] := 0;
  end;

  for i := Round(p_time_start * frequency_sampling) to Round(p_time_end * frequency_sampling) do
  begin
    p_data[i] := mlii_data[i];
  end;

  for i := Round(qrs_time_start * frequency_sampling) to Round(qrs_time_end * frequency_sampling) do
  begin
    qrs_data[i] := mlii_data[i];
  end;

  for i := Round(tu_time_start * frequency_sampling) to Round(tu_time_end * frequency_sampling) do
  begin
    tu_data[i] := mlii_data[i];
  end;

  SetLength(mlii_data, length_used);

  mlii_data_windowed := hanning_windowing(mlii_data);

  for i := Low(mlii_data) to High(mlii_data) do
  begin
    Series13.AddXY(time_data[i], mlii_data_windowed[i]);
    Series2.AddXY(time_data[i], mlii_data[i]);
  end;

  p_data := hanning_windowing(p_data);
  qrs_data := hanning_windowing(qrs_data);
  tu_data := hanning_windowing(tu_data);

  SetLength(mlii_complex, length_used);
  SetLength(mlii_window_complex, length_used);
  SetLength(p_complex, length_used);
  SetLength(qrs_complex, length_used);
  SetLength(tu_complex, length_used);

  for i := 0 to length_used - 1 do
  begin
    mlii_complex[i] := make_complex(mlii_data[i], 0.0);
    mlii_window_complex[i] := make_complex(mlii_data_windowed[i], 0.0);
    p_complex[i] := make_complex(p_data[i], 0.0);
    qrs_complex[i] := make_complex(qrs_data[i], 0.0);
    tu_complex[i] := make_complex(tu_data[i], 0.0);
  end;

  // Perform DFT on the windowed data
  mlii_dft_result := dft(mlii_complex);
  mlii_window_dft_result := dft(mlii_window_complex);
  p_dft_result := dft(p_complex);
  qrs_dft_result := dft(qrs_complex);
  tu_dft_result := dft(tu_complex);

  // Plot frequency domain data up to Nyquist frequency
  for i := 0 to Round(length_used / 2) do
  begin
    Series3.AddXY(i * frequency_sampling / length_used, mlii_dft_result.magnitude[i]);
    Series14.AddXY(i * frequency_sampling / length_used, mlii_window_dft_result.magnitude[i]);
    Series5.AddXY(i * frequency_sampling / length_used, p_dft_result.magnitude[i]);
    Series6.AddXY(i * frequency_sampling / length_used, qrs_dft_result.magnitude[i]);
    Series7.AddXY(i * frequency_sampling / length_used, tu_dft_result.magnitude[i]);
  end;

  Listbox1.Items.Add('Raw Signal');
  Listbox2.Items.Add('P wave');
  Listbox3.Items.Add('QRS Complex Wave');
  Listbox4.Items.Add('T/U Wave');

  calculateMPF(ListBox1, mlii_dft_result);
  calculateMPF(ListBox2, p_dft_result);
  calculateMPF(ListBox3, qrs_dft_result);
  calculateMPF(ListBox4, tu_dft_result);

  // Apply FIR bandpass filters with backward-forward filtering
  filtered_p := BackwardForwardFilter(mlii_data_windowed, FIRBandpassFilter(0.5, 10));   // P wave (0.5-10 Hz)
  filtered_qrs := BackwardForwardFilter(mlii_data_windowed, FIRBandpassFilter(14, 30));  // QRS complex (14-30 Hz)
  filtered_t := BackwardForwardFilter(mlii_data_windowed, FIRBandpassFilter(0.5, 10));   // T wave (0.5-10 Hz)

  for i := 0 to High(filtered_p) do
  begin
    filtered_p[i] := Abs(filtered_p[i]);
    filtered_qrs[i] := Abs(filtered_qrs[i]);
    filtered_t[i] := Abs(filtered_t[i]);
  end;

  // Apply Moving Average with backward-forward filtering
  filtered_p := BackwardForwardFilter(filtered_p, MovingAverage(10));
  filtered_qrs := BackwardForwardFilter(filtered_qrs, MovingAverage(10));
  filtered_t := BackwardForwardFilter(filtered_t, MovingAverage(10));

  for i := 0 to High(filtered_p) do
  begin
    if (filtered_qrs[i] > 0.1) then
    begin
      filtered_p[i] := 0;
      filtered_t[i] := 0;
    end;
  end;

  // Plot filtered signals
  for i := 0 to High(filtered_p) do
  begin
    Series8.AddXY(time_data[i], filtered_p[i]);
    Series9.AddXY(time_data[i], filtered_qrs[i]);
    Series10.AddXY(time_data[i], filtered_t[i]);
    Series11.AddXY(time_data[i], mlii_data[i]);
  end;

  for i := 0 to High(mlii_data) do
    begin
      Series4.AddXY(time_data[i], 2 * mlii_data_windowed[i] * filtered_t[i]);
      Series12.AddXY(time_data[i], mlii_data_windowed[i] * filtered_qrs[i]);
    end;
end;

procedure TForm1.LoadECGData(var time_data, mlii_data, v5_data: TArray<Double>);
var
  Lines: TStringList;
  Line: string;
  Fields: TArray<string>;
  i: Integer;
begin
  Lines := TStringList.Create;
  try
    open_dialog1.Filter := 'DAT Files (*.dat)|*.dat|All Files (*.*)|*.*';
    open_dialog1.Title := 'Select ECG Data File';

    if open_dialog1.Execute then
    begin
      Lines.LoadFromFile(open_dialog1.FileName);

      // Skip the first two header lines
      if Lines.Count > 2 then
      begin
        SetLength(time_data, Lines.Count - 2);
        SetLength(mlii_data, Lines.Count - 2);
        SetLength(v5_data, Lines.Count - 2);

        for i := 2 to Lines.Count - 1 do
        begin
          Line := Lines[i];
          Fields := Line.Split([#9]); // Split by tab character
          if Length(Fields) >= 3 then // Ensure there are enough fields
          begin
            try
              time_data[i - 2] := StrToFloat(Fields[0]);
              mlii_data[i - 2] := StrToFloat(Fields[1]); // MLII data
              v5_data[i - 2] := StrToFloat(Fields[2]);   // V5 data
            except
              on E: EConvertError do
              begin
                ShowMessage('Error converting data on line ' + IntToStr(i + 1) + ': ' + E.Message);
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    Lines.Free; // Free the TStringList
  end;
end;

end.


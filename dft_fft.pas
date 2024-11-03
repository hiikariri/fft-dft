unit dft_fft;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, TeeProcs, TeEngine, Chart, Math,
  Series, VclTee.TeeGDIPlus, Vcl.Mask;

type
  TForm1 = class(TForm)
    cht1: TChart;
    grp1: TGroupBox;
    btn1: TBitBtn;
    lbledt1: TLabeledEdit;
    lbledt2: TLabeledEdit;
    Series1: TLineSeries;
    btn2: TBitBtn;
    cht2: TChart;
    lbledt3: TLabeledEdit;
    txt1: TStaticText;
    barSeries2: TBarSeries;
    cht3: TChart;
    barSeries3: TBarSeries;
    cht6: TChart;
    cht7: TChart;
    Series2: TLineSeries;
    cht4: TChart;
    cht5: TChart;
    barSeries5: TBarSeries;
    barSeries4: TBarSeries;
    Series3: TLineSeries;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  sampling_freq, signal_freq: Double;
  data_size: Integer;

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
  TIFFTResult = record
    magnitude: TArrayOfDouble;
    real_part: TArrayOfDouble;
    imag_part: TArrayOfDouble;
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

function function_generator(lbledt: TLabeledEdit): TArrayOfComplex;
var
  i: Integer;
  time : Double;
  function_result: TArrayOfComplex;
  data : TComplex;
begin
  SetLength(function_result, data_size);
  signal_freq := StrToFloat(lbledt.Text);
  for i := 0 to data_size - 1 do
  begin
    time := i / sampling_freq;
    data.Re := 3.0 + 5.0 * Sin(2 * Pi * signal_freq * time);
    data.Im := 0;
    function_result[i] := data;
  end;
  Result := function_result;
end;

function dft(input_data: TArrayOfComplex): TDFTResult;
var
  i, k: Integer;
begin
  SetLength(Result.real_part, data_size);
  SetLength(Result.imag_part, data_size);
  SetLength(Result.magnitude, data_size);

  // Initialize arrays to zero
  for i := 0 to data_size - 1 do
  begin
    Result.real_part[i] := 0;
    Result.imag_part[i] := 0;
  end;

  for i := 0 to data_size - 1 do
  begin
    for k := 0 to data_size - 1 do
    begin
      Result.real_part[i] := Result.real_part[i] + input_data[k].Re * Cos(2 * Pi * i * k / data_size);
      Result.imag_part[i] := Result.imag_part[i] - input_data[k].Re * Sin(2 * Pi * i * k / data_size);
    end;
  end;

  for i := 0 to data_size - 1 do
  begin
    Result.magnitude[i] := Sqrt(Sqr(Result.real_part[i]) + Sqr(Result.imag_part[i]));
  end;
end;

function idft(Series : TLineSeries; real : TArrayOfDouble; imag : TArrayOfDouble) : TArrayOfDouble;
var
  i, k : Integer;
  real_IDFT, imag_IDFT, IDFT_result : TArrayOfDouble;
begin
  Series.Clear;
  SetLength(real_IDFT, data_size);
  SetLength(imag_IDFT, data_size);
  SetLength(IDFT_result, data_size);
  for i := 0 to data_size - 1 do
  begin
    for k := 0 to data_size - 1 do
    begin
      real_IDFT[i] := real_IDFT[i] + real[k] * Cos(2 * PI * k * i/data_size);
      imag_IDFT[i] := imag_IDFT[i] - imag[k] * Sin(2 * PI * k * i/data_size);
    end;
    IDFT_result[i] := (real_IDFT[i] + imag_IDFT[i])/data_size;
    Series.AddXY(i/sampling_freq, IDFT_result[i]);
  end;
  Result := IDFT_result;
end;

function fft_new(input_data: TArrayOfComplex ; inverse: Boolean): TIFFTResult;
var
  m, lim1, lim2, lim3, l, r, i, j, k: integer;
  angle, cos1, sin1, temp_real, temp_imag, factor: Extended;
  result_struct: TIFFTResult;
begin
  factor := data_size;

  // Initialize result arrays
  SetLength(result_struct.real_part, data_size);
  SetLength(result_struct.imag_part, data_size);
  SetLength(result_struct.magnitude, data_size);

  // Copy input data for in-place modification
  for k := 0 to data_size - 1 do
  begin
    result_struct.real_part[k] := input_data[k].Re;
    result_struct.imag_part[k] := input_data[k].Im;
  end;

  // Calculate the power of 2 for the data size
  m := Round(Ln(data_size) / Ln(2));

  // Bit-reversal reordering
  lim2 := data_size div 2;
  j := 0;
  for i := 0 to data_size - 2 do
  begin
    if i < j then
    begin
      temp_real := result_struct.real_part[i];
      temp_imag := result_struct.imag_part[i];
      result_struct.real_part[i] := result_struct.real_part[j];
      result_struct.imag_part[i] := result_struct.imag_part[j];
      result_struct.real_part[j] := temp_real;
      result_struct.imag_part[j] := temp_imag;
    end;

    l := lim2;
    while (l >= 1) and (j >= l) do
    begin
      j := j - l;
      l := l div 2;
    end;
    j := j + l;
  end;

  // FFT computation using the Cooley-Tukey in-place algorithm
  for i := 1 to m do
  begin
    lim1 := 1 shl (i - 1);
    lim2 := 1 shl (m - i);
    for l := 0 to lim2 - 1 do
    begin
      for r := 0 to lim1 - 1 do
      begin
        lim3 := r + l * 2 * lim1;
        angle := -2 * Pi * r * lim2 / data_size;
        if inverse then angle := -angle;
        cos1 := Cos(angle);
        sin1 := Sin(angle);

        temp_real := result_struct.real_part[lim3 + lim1] * cos1 - result_struct.imag_part[lim3 + lim1] * sin1;
        temp_imag := result_struct.real_part[lim3 + lim1] * sin1 + result_struct.imag_part[lim3 + lim1] * cos1;

        result_struct.real_part[lim3 + lim1] := result_struct.real_part[lim3] - temp_real;
        result_struct.imag_part[lim3 + lim1] := result_struct.imag_part[lim3] - temp_imag;

        result_struct.real_part[lim3] := result_struct.real_part[lim3] + temp_real;
        result_struct.imag_part[lim3] := result_struct.imag_part[lim3] + temp_imag;
      end;
    end;
  end;

  // Scaling for inverse FFT and calculating magnitude
  for k := 0 to data_size - 1 do
  begin
    if inverse then
    begin
      result_struct.real_part[k] := result_struct.real_part[k] / factor;
      result_struct.imag_part[k] := result_struct.imag_part[k] / factor;
    end;
    // Calculate the magnitude
    result_struct.magnitude[k] := Sqrt(Sqr(result_struct.real_part[k]) + Sqr(result_struct.imag_part[k]));
  end;

  // Return the result structure
  Result := result_struct;
end;

function ifft(Series: TLineSeries; freq_real, freq_imag: TArrayOfDouble): TArrayOfDouble;
var
  i, n: Integer;
  complex_freq : TArrayOfComplex;
  fft_result: TIFFTResult;
begin
  Series.Clear;
  SetLength(complex_freq, data_size);
  for i := 0 to data_size - 1 do
  begin
    complex_freq[i] := make_complex(freq_real[i], freq_imag[i]);
  end;
  // Perform inverse FFT
  fft_result := fft_new(complex_freq, true);  // true for inverse transform

  SetLength(Result, data_size);
  for i := 0 to data_size - 1 do
  begin
    Result[i] := fft_result.real_part[i];
    Series.AddXY(i / sampling_freq, Result[i]);
  end;
end;

function normalize(real_part: TArrayOfDouble; imag_part: TArrayOfDouble): TArrayOfDouble;
var
  amp: TArrayOfDouble;
  i, half_size: integer;
begin
  // Set the size of the amplitude array
  SetLength(amp, data_size + 1);

  // Calculate half of the data size
  half_size := data_size div 2;

  // Calculate amplitude for the second half of the FFT result
  for i := half_size + 1 to data_size - 1 do
  begin
    amp[i - half_size] := sqrt(real_part[i] * real_part[i] + imag_part[i] * imag_part[i]) / (data_size / 2.0);
  end;

  // Calculate amplitude for the first half of the FFT result
  for i := 1 to half_size do
  begin
    amp[i + half_size] := sqrt(real_part[i] * real_part[i] + imag_part[i] * imag_part[i]) / (data_size / 2.0);
  end;

  // Adjust the midpoint amplitude value
  amp[half_size] := amp[half_size] / 2.0;

  // Return the amplitude array
  Result := amp;
end;

procedure TForm1.btn1Click(Sender: TObject);
var
  i: Integer;
  dft_result : TDFTResult;
  fft_result : TIFFTResult;
  raw_signal : TArrayOfComplex;
  idft_result, ifft_result, dft_normalize_result, fft_normalize_result: TArrayOfDouble;
begin
  sampling_freq := StrToFloat(lbledt1.Text);
  data_size := StrToInt(lbledt2.Text);

  SetLength(raw_signal, data_size);
  raw_signal := function_generator(lbledt3);

  dft_result := dft(raw_signal);
  fft_result := fft_new(raw_signal, false);

  idft_result := IDFT(Series2, dft_result.real_part, dft_result.imag_part);
  ifft_result := IFFT(Series3, fft_result.real_part, fft_result.imag_part);

  fft_normalize_result := normalize(fft_result.real_part, fft_result.imag_part);
  dft_normalize_result := normalize(dft_result.real_part, dft_result.imag_part);

  Series1.Clear;
  barSeries2.Clear;
  barSeries3.Clear;
  barSeries4.Clear;
  barSeries5.Clear;

  for i := 0 to data_size - 1 do
  begin
    Series1.AddXY(i / sampling_freq, raw_signal[i].Re);
    barSeries4.AddXY(i * sampling_freq / data_size, dft_normalize_result[i]);
    barSeries5.AddXY(i * sampling_freq / data_size, fft_normalize_result[i]);
  end;

  for i := 0 to Round(data_size / 2) do
  begin
    barSeries2.AddXY(i * sampling_freq / data_size, dft_result.magnitude[i]);
    barSeries3.AddXY(i * sampling_freq / data_size, fft_result.magnitude[i]);
  end;
end;

end.

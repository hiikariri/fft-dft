program dft_fft_pr;

uses
  Forms,
  dft_fft in 'dft_fft.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

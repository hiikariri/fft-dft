program ecg_freq_domain_pr;

uses
  Vcl.Forms,
  ecg_freq_domain in 'ecg_freq_domain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

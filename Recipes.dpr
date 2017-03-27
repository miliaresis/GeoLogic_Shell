program Recipes;

uses
  Forms,
  Central in 'Central.pas' {Form4},
  io in 'io.pas',
  Imageform in 'Imageform.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
   Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

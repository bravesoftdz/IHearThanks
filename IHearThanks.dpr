program IHearThanks;

{%File 'TwoDesk\DIRECTIVES.INC'}
{%File 'TwoDesk\Versions.inc'}
{%File 'TwoDesk\TwoDeskVersion.INC'}

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  TwoDeskRegExp in 'TwoDesk\TwoDeskRegExp.pas',
  TwoDeskVersion in 'TwoDesk\TwoDeskVersion.pas',
  TwoDeskSafeMem in 'TwoDesk\TwoDeskSafeMem.pas',
  c_rtl in 'TwoDesk\c_rtl.pas',
  pcre_intf in 'TwoDesk\pcre_intf.pas',
  SubRip in 'SubRip.pas',
  Subtitles in 'Subtitles.pas',
  MicroDvd in 'MicroDvd.pas',
  MyUtilities in 'MyUtilities.pas',
  SubViewer in 'SubViewer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'I Hear, Thanks!';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

unit Subtitles;

interface

    function RemoveDeafness(Filename: string): boolean;
    function DefineFileType(Filename: string): integer;

implementation
uses
    Main, Windows, SysUtils, MyUtilities, SubRip, MicroDvd, SubViewer;

const
    SUBRIP = 1;
    MICRODVD = 2;
    SUBVIEWER = 3;
    UNDEFINED = 9;
    EMPTY = '$^';

function DefineFileType(Filename: string): integer;
var
fileCheck: TextFile;
sLine:string;
nLines: byte;
begin

    Result := UNDEFINED;
    nLines := 0;

    try
        AssignFile(fileCheck, Filename);
        Reset(fileCheck);
    except
        MessageBox(frmMain.Handle, 'Could not open "' + 'filename' + '"', 'mais', MB_OK);
    end;

    repeat
    begin
        Inc(nLines);
        Readln(fileCheck, sLine);
        if PatternMatch(SUBRIP_TIME, sLine, True) then
        begin
            Result := SUBRIP;
            CloseFile(fileCheck);
            Exit;
        end;
    end;
    until EOF(fileCheck) or (nLines > 6);
    //done with subrip

    Reset(fileCheck);
    nLines := 0;
    repeat
    begin
        Inc(nLines);
        Readln(fileCheck, sLine);
        Trim(sLine);
        if PatternMatch(MICRODVD_TIME, sLine, True) then
        begin
            Result := MICRODVD;
            CloseFile(fileCheck);
            Exit;
        end;

    end;
    until EOF(fileCheck) or (nLines > 3);
    //done with microdvd

    Reset(fileCheck);
    nLines := 0;
    repeat
    begin
        Inc(nLines);
        Readln(fileCheck, sLine);
        Trim(sLine);
        if PatternMatch(SUBVIEWER_TIME , sLine, True) then
        begin
            Result := SUBVIEWER;
            CloseFile(fileCheck);
            Exit;
        end;

    end;
    until EOF(fileCheck) or (nLines > 20);
    //done with subviewer

    CloseFile(fileCheck);

end;

function RemoveDeafness(Filename: string): boolean;
var
iFileType: integer;
begin

    RemoveDeafness := true;
    iFileType := DefineFileType(Filename);
    Case iFileType of
        SUBRIP:
            RemoveSubRip(Filename);
        MICRODVD:
            RemoveMicroDvd(Filename);
        SUBVIEWER:
            begin
            MessageBox(frmMain.Handle, 'Sorry, this type of subtitle isn''t supported yet due to handling of "[BR]" tags.', 'Type unsupported.', MB_OK + MB_ICONEXCLAMATION);
            RemoveDeafness := false;
            //RemoveSubViewer(Filename);
            end;
    end;

end;


end.

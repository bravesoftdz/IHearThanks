unit MicroDvd;

interface

const
    MICRODVD_TIME = '({[0-9]*}){2}';
    OPENTAG = '\[|\(';
    CLOSETAG = '\]|\)';
    MICRODVD_PIPED_NAME_PREFIX = '\|[A-Z ]+:';

function RemoveMicroDvd(Filename: string): boolean;
function RemoveMicroDvdTagsFromLine(sLine:string): string;


implementation
uses
    Windows, TwoDeskRegExp, MyUtilities, SysUtils;


function RemoveMicroDvd(Filename: string): boolean;
var
fileSub: TextFile;
fileNew: TextFile;
sLine:string;
begin

    AssignFile(fileSub, Filename);
    Reset(fileSub);

    AssignFile(fileNew, Filename + '.new');
    Rewrite(fileNew);

    repeat
    begin
        Readln(fileSub, sLine);
        sLine := RemoveMicroDvdTagsFromLine(sLine);
        if ValidTextLine(sLine) then
            Writeln(fileNew, Trim(sLine));
    end;
    until EOF(fileSub);

    Closefile(fileSub);
    Closefile(fileNew);

    RenameFile(Filename, Filename + '.old');
    RenameFile(Filename + '.new', Filename);

    Result := True;
end;

function RemoveMicroDvdTagsFromLine(sLine:string): string;
var
iBeginTag, iEndTag: integer;
sTime: string;
iEndTime: integer;
iBeginPrefix, iEndPrefix: integer;
begin

    PatternMatch(MICRODVD_TIME, sLine, True, nil, @iEndTime);
    sTime := Copy(sLine, 1, iEndTime);
    Delete(sLine, 1, iEndTime);

    repeat
    begin
        iBeginTag := RegExpPos(OPENTAG, sLine);
        iEndTag := RegExpPos(CLOSETAG, sLine);
        Delete(sLine, iBeginTag, iEndTag - iBeginTag + 1);
    end;
    until (iBeginTag = 0) or (iEndTag = 0);

    Delete(sLine, iBeginTag, Length(sLine));
    Delete(sLine, 1, iEndTag);

    sLine := Trim(sLine);

    if PatternMatch(NAME_PREFIX, sLine) then
        Delete(sLine, 1, Pos(':', sLine));

    repeat
    begin
        iBeginPrefix := RegExpPos(MICRODVD_PIPED_NAME_PREFIX, sLine);
        if iBeginPrefix < 1 then break;
        iEndPrefix := RegExpPos(':', sLine, iBeginPrefix);
        Delete(sLine, iBeginPrefix + 1, iEndPrefix - iBeginPrefix + 1);
    end;
    until PatternMatch(MICRODVD_PIPED_NAME_PREFIX, sLine) = False;

    sLine := Trim(sLine);

    if Pos('|', sLine) = 1 then
        Delete(sLine, 1, 1);

    //fazer aqui pq depois de grudar o sTime ele bate os numeros
    if not ValidTextLine(sLine) then
        Result := ''
    else
        Result := sTime + sLine;

end;

end.

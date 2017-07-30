unit SubRip;

interface

const
    SUBRIP_NUMBER = '^\d*$';
    SUBRIP_TIME = '^([0-9]{2}:){2}[0-9]{2},[0-9]{3} --> ([0-9]{2}:){2}[0-9]{2},[0-9]{3}$';
    OPENTAG = '\[|\(';
    CLOSETAG = '\]|\)';

function RemoveSubRip(Filename: string): boolean;
function RemoveSubRipTagsFromLine(sLine:string): string;


implementation
uses
    Windows, TwoDeskRegExp, MyUtilities, SysUtils;

function RemoveSubRip(Filename: string): boolean;
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
        sLine := RemoveSubRipTagsFromLine(sLine);
        if ValidTextLine(sLine) then
            Writeln(fileNew, Trim(sLine))
        else
            Writeln(fileNew, '');
    end;
    until EOF(fileSub);

    Closefile(fileSub);
    Closefile(fileNew);

    RenameFile(Filename, Filename + '.old');
    RenameFile(Filename + '.new', Filename);

    GambiarraFeroz(Filename);

    Result := True;
end;

function RemoveSubRipTagsFromLine(sLine:string): string;
var
iBeginTag, iEndTag: integer;
begin
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

    sLine := Trim(sLine);

    if Pos('|', sLine) = 1 then
        Delete(sLine, 1, 1);

    Result := sLine;

end;

end.

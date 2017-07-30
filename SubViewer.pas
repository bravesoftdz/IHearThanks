unit SubViewer;

interface

const
    SUBVIEWER_TIME = '([0-9]{2}:){2}[0-9]{2}.[0-9]{2},([0-9]{2}:){2}[0-9]{2}.[0-9]{2}';
    OPENTAG = '\[|\(';
    CLOSETAG = '\]|\)';

function RemoveSubViewer(Filename: string): boolean;
function RemoveSubViewerTagsFromLine(sLine:string): string;


implementation
uses
    Windows, TwoDeskRegExp, MyUtilities, SysUtils;

function RemoveSubViewer(Filename: string): boolean;
var
fileSub: TextFile;
fileNew: TextFile;
sLine:string;
begin

    AssignFile(fileSub, Filename);
    Reset(fileSub);
    AssignFile(fileNew, Filename + '.new');
    Rewrite(fileNew);

    //to avoid removing infos on begining of file
    repeat
    begin
        Readln(fileSub, sLine);
        Writeln(fileNew, Trim(sLine));
    end;
    until PatternMatch(SUBVIEWER_TIME, sLine);

    repeat
    begin
        Readln(fileSub, sLine);
        sLine := RemoveSubViewerTagsFromLine(sLine);
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

function RemoveSubViewerTagsFromLine(sLine:string): string;
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

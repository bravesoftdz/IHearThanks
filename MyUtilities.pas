unit MyUtilities;

interface

const
    CONTAIN_TEXT = '[A-Za-z0-9]';
    CONTAIN_LETTERS = '[A-Za-z]';

    NAME_PREFIX = '^[A-Z \.]+:';

function PatternMatch(Pattern, Text: string; TrimText: boolean = False; const StartPos: PInteger = nil; const EndPos: PInteger = nil):boolean;
function ValidTextLine(Line:string):Boolean;
function GambiarraFeroz(Filename:string): Boolean;

implementation
uses
    TwoDeskRegExp, SysUtils;

function PatternMatch(Pattern, Text: string; TrimText: boolean = False; const StartPos: PInteger = nil; const EndPos: PInteger = nil):boolean;
var
RegExp: TtdRegExp;
begin

    RegExp := TtdRegExp.Create(nil);
    RegExp.Options := RegExp.Options + [roEmptyValid];
    if TrimText = True then
        Text := Trim(Text);
    RegExp.Pattern := Pattern;
    RegExp.Text := Text;
    Result := (RegExp.NextMatch = True);
    if Assigned(StartPos) and (StartPos <> nil) then StartPos^ := RegExp.MatchStart;
    if Assigned(EndPos) and (EndPos <> nil) then EndPos^ := RegExp.MatchEnd;
    RegExp.Free();

end;

function ValidTextLine(Line:string):Boolean;
begin

    Line := StringReplace(Line, '<i>', '', [rfReplaceAll, rfIgnoreCase]);
    Line := StringReplace(Line, '</i>', '', [rfReplaceAll, rfIgnoreCase]);

    if (Line = '') or PatternMatch(CONTAIN_TEXT, Line) then
        Result := True
    else
        Result := False;
end;

//remove partes da legenda referentes a texto vazio (fode bsplayer)
function GambiarraFeroz(Filename:string): Boolean;
var
fileGamb: TextFile;
sTextLines, sTmp, sTimeLine, sNextLine, sLine, sWholeFile:string;
SUBRIP_TIME, SUBRIP_NUMBER:string;
Count:integer;
begin

    SUBRIP_TIME := '^([0-9]{2}:){2}[0-9]{2},[0-9]{3} --> ([0-9]{2}:){2}[0-9]{2},[0-9]{3}$';
    SUBRIP_NUMBER := '^\d*$';
    AssignFile(fileGamb, Filename);
    Reset(fileGamb);

    Count := 0;

    repeat begin
        if (PatternMatch(SUBRIP_TIME, sTimeLine) = false) or (Trim(sTimeLine) = '') then
            Readln(fileGamb, sTimeLine);
        if PatternMatch(SUBRIP_TIME, sTimeLine) and (not EOF(FileGamb)) then
        begin
            repeat begin
                Readln(fileGamb, sTmp);
                if PatternMatch(SUBRIP_TIME, sTmp) then begin
                    sTimeLine := sTmp;
                    continue;
                end;

                if PatternMatch(CONTAIN_LETTERS, sTmp) then
                    sTextLines := sTextLines + sTmp + #13+#10;
            end;
            until EOF(fileGamb) or (Trim(sTmp) <> '') and (PatternMatch(SUBRIP_TIME, sTmp) or PatternMatch(SUBRIP_NUMBER, sTmp));
        end;
        if PatternMatch(CONTAIN_LETTERS, sTextLines) then begin
            Inc(Count);
            sWholeFile := sWholeFile + IntToStr(Count) + #13+#10;
            sWholeFile := sWholeFile + sTimeLine + #13+#10;
            sWholeFile := sWholeFile + sTextLines + #13+#10;
        end;
        sTimeLine := '';
        sTextLines := '';
    end;
    until EOF(fileGamb);




    Close(fileGamb);
    AssignFile(fileGamb, Filename);
    Rewrite(fileGamb);
    Write(fileGamb, sWholeFile);
    Close(fileGamb);

    Result := True;


end;


end.

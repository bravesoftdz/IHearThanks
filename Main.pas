unit Main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Subtitles, MyUtilities, ShellApi, ComCtrls, Registry,
  ExtCtrls;

type
    TfrmMain = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnStart: TButton;
    txtFilename: TEdit;
    btnChooseFile: TButton;
    chkShellIntegration: TCheckBox;
    chkAlwaysOnTop: TCheckBox;
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChangeContextMenu(Extension, Name: string; Remove: boolean = false);
    procedure chkAlwaysOnTopClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnChooseFileClick(Sender: TObject);

    private

    public
        { Public declarations }
    end;

var
    frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnChooseFileClick(Sender: TObject);
begin
    MessageBox(frmMain.Handle, 'Not implemented yet.', 'Sorry.', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
    if RemoveDeafness(txtFilename.Text) = true then
        MessageBox(frmMain.Handle, PAnsiChar('Removed deafness tags from ' + ExtractFilename(txtFilename.Text)), 'Done', MB_ICONINFORMATION);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
myReg:TRegistry;
begin
//to remember: '' is the 'default' value of a key

    DragAcceptFiles(frmMain.Handle, False);

    ChangeContextMenu('.sub', 'MicroDVD/SubViewer Subtitles', not chkShellIntegration.Checked);
    ChangeContextMenu('.srt', 'SubRip Subtitles', not chkShellIntegration.Checked);
    ChangeContextMenu('.txt', 'DIVX Subtitle', not chkShellIntegration.Checked);

    myReg := TRegistry.Create;
    myReg.RootKey := HKEY_LOCAL_MACHINE;
    myReg.OpenKey('Software\Mumu HQ\I Hear Thanks', True);

    myReg.WriteBool('Shell Integration', chkShellIntegration.Checked);

    myReg.CloseKey();
    myReg.Free();

end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
myReg:TRegistry;
begin

    if ParamStr(1) = '-remove' then
    begin
        if RemoveDeafness(ParamStr(2))= true then
            MessageBox(frmMain.Handle, PAnsiChar('Removed deafness tags from ' + ExtractFilename(ParamStr(2))), 'Done', MB_ICONINFORMATION);
        Application.Terminate;
    end;

    DragAcceptFiles(frmMain.Handle, True);

    myReg := TRegistry.Create;
    myReg.RootKey := HKEY_LOCAL_MACHINE;
    myReg.OpenKey('Software\Mumu HQ\I Hear Thanks', True);

    if not myReg.ValueExists('Shell Integration') then
        myReg.WriteBool('Shell Integration', False)
    else
        chkShellIntegration.Checked := myReg.ReadBool('Shell Integration');

    myReg.CloseKey;
    myReg.Free();

end;


procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

    if (Key = VK_F9) and (Shift = [ssCtrl]) then
        MessageBox(frmMain.Handle, 'Te amo, baby sexy sugar morticinha. :@@@@@@@@@@@~', 'mnhmhmhhh :}', MB_ICONEXCLAMATION);

end;

procedure TfrmMain.WMDropFiles(var Msg: TWMDropFiles);
var
    CFileName: array[0..MAX_PATH] of Char;
begin
    try
        if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0 then
        begin
            Msg.Result := 0;
            txtFilename.Text := CFileName;
        end;
    finally
        DragFinish(Msg.Drop);
    end;
end;

procedure TfrmMain.ChangeContextMenu(Extension, Name: string; Remove: boolean = false);
var
myReg:TRegistry;
sExtKeyName:string;
begin
    //melhor estudar shell extensions antes de fazer coisa feia
    //e tavez precise de COM primeiro...
    //Context menu handler nome da bosta...
    //shell contextmenu
    //explorer contextmenu

    myReg := TRegistry.Create;
    myReg.RootKey := HKEY_CLASSES_ROOT;

    if Remove = True then
    begin
        myReg.CloseKey;
        myReg.DeleteKey(Name + '\Shell\Remove Deaf Tags\Command');
        Exit;
    end;

    myReg.OpenKey(Extension, True); //true cria se ainda nao existe
    sExtKeyName := myReg.ReadString('');

    if sExtKeyName = '' then
    begin
        sExtKeyName := Name;
        myReg.WriteString('', sExtKeyName);
    end;
    myReg.CloseKey;

    myReg.OpenKey(sExtKeyName + '\Shell\Remove Deaf Tags\Command', True);
    myReg.WriteString('','"' + Application.ExeName + '" -remove "%1"');
    myReg.CloseKey;
end;

procedure TfrmMain.chkAlwaysOnTopClick(Sender: TObject);
begin
    if chkAlwaysOnTop.Checked then SetWindowPos(frmMain.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE)
        else SetWindowPos(frmMain.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE)
end;

end.







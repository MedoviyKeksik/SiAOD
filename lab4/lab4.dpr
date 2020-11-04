program lab4;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uList in 'uList.pas',
  uBase in 'uBase.pas',
  uHash in 'uHash.pas',
  uOpenHashTable in 'uOpenHashTable.pas',
  uModalEdit in 'uModalEdit.pas' {frmEdit},
  uSortType in 'uSortType.pas' {frmSortType},
  uFind in 'uFind.pas' {frmFind},
  uCommon in 'uCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmEdit, frmEdit);
  Application.CreateForm(TfrmSortType, frmSortType);
  Application.CreateForm(TfrmFind, frmFind);
  Application.Run;
end.

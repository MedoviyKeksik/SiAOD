unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uList, uBase, uHash, uOpenHashTable, uModalEdit, uCommon, uSortType, uFind, Vcl.ComCtrls, Vcl.ToolWin, System.Actions, Vcl.ActnList,
  Vcl.Menus;

type
  TfrmMain = class(TForm)
    menuMain: TMainMenu;
    alMain: TActionList;
    tvMain: TTreeView;
    actAdd: TAction;
    actEdit: TAction;
    actDelete: TAction;
    actSort: TAction;
    actFind: TAction;
    tbMain: TToolBar;
    tbtnAdd: TToolButton;
    tbtnDelete: TToolButton;
    tbtnEdit: TToolButton;
    tbtnSort: TToolButton;
    tbtnFind: TToolButton;
    actView: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actViewExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure alMainUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actEditExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actSortExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
  private
    FData: TTerm;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function ListToString(const x: TList<Integer>): String;
var
  p: TList<Integer>.TDataP;
begin
  Result := '';
  p := x.Front;
  while p <> nil do
  begin
    if (Result <> '') then
      Result := Result + ', ';
    Result := Result + IntToStr(p^.Data);
    p := p^.Next;
  end;
end;

function GetText(const X: TTerm): String;
begin
  Result := X.Title + '   ' + ListToString(X.Pages);
end;

function HashStr(const s: string): THash;
const
  AlphabetSz = 257;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(s) do
  begin
    Result := Result + ord(s[i]);
    Result := Result * AlphabetSz;
    Result := Result mod HashMod;
  end;
end;

function HashTerm(const x: TTerm): THash;
begin
  Result := HashStr(x.Title);
end;

function Parse(Str: String): TList<Integer>;
var
  Now: Integer;
  I: Integer;
begin
  Result := TList<Integer>.Create;
  Now := 0;
  for I := 1 to Length(Str) do
  begin
    if IsDigit(Str[i]) then
    begin
      Now := Now * 10;
      Now := Now + Ord(Str[i]) - Ord('0');
    end
    else
    begin
      if Now <> 0 then
      begin
        Result.PushBack(Now);
        Now := 0;
      end;
    end;
  end;
  if (Now <> 0) then
    Result.PushBack(Now);
  Result.Sort(Less);
end;

function TermEqual(const a, b: TTerm): Boolean;
begin
  if Length(a.Title) = Length(b.Title) then
    Result := a.Title = b.Title
  else if Length(a.Title) > Length(b.Title) then
    Result := False
  else Result := Copy(a.Title, 1, Length(b.Title)) = b.Title;
end;

procedure TfrmMain.actAddExecute(Sender: TObject);
var
  Name: String;
  Pages: String;
  IsChild: Boolean;
  Res: Integer;
  DataPointer: TList<TTerm>.TDataP;
  Data: TTerm;
begin
  if Assigned(tvMain.Selected) then
  begin
    Name := '';
    Pages := '';
    IsChild := True;
    Res := frmEdit.FillAndShow(Name, Pages, IsChild);
    if Res = mrOk then
    begin
      Data.Title := Name;
      Data.Pages := Parse(Pages);
      Data.SubTerm := TOpenHashTable<TTerm>.Create(HashTerm, TermEqual);
      if IsChild then
      begin
        DataPointer := TTermP(tvMain.Selected.Data)^.Data.SubTerm.Insert(Data);
        tvMain.Items.AddChildObject(tvMain.Selected, GetText(Data), DataPointer);
      end
      else
      begin
        if Assigned(tvMain.Selected.Parent) then
          DataPointer := TTermP(tvMain.Selected.Parent.Data)^.Data.SubTerm.Insert(Data)
        else
          DataPointer := FData.SubTerm.Insert(Data);
        tvMain.Items.AddObject(tvMain.Selected, GetText(Data), DataPointer);
      end;
    end;
  end
  else
  begin
    Name := '';
    Pages := '';
    IsChild := False;
    frmEdit.cbChild.Enabled := False;
    Res := frmEdit.FillAndShow(Name, Pages, IsChild);
    frmEdit.cbChild.Enabled := True;
    if Res = mrOk then
    begin
      Data.Title := Name;
      Data.Pages := Parse(Pages);
      Data.SubTerm := TOpenHashTable<TTerm>.Create(HashTerm, TermEqual);
      DataPointer := FData.SubTerm.Insert(Data);
      tvMain.Items.AddObject(tvMain.Selected, GetText(Data), DataPointer);
    end;
  end;
end;

procedure TfrmMain.actDeleteExecute(Sender: TObject);

  procedure Del(V: TTerm);
  var
    Tmp: TList<TTerm>.TDataP;
    I: Integer;
  begin
    for I := 0 to V.SubTerm.Size - 1 do
    begin
      Tmp := V.SubTerm.Table[I].Front;
      while Tmp <> nil do
      begin
        Del(Tmp^.Data);
        Tmp := Tmp^.Next;
      end;
    end;
    V.SubTerm.Free;
    V.Pages.Free;
  end;

var
  Now: TList<TTerm>.TDataP;
begin
  Now := TTermP(tvMain.Selected.Data);
  if (Assigned(tvMain.Selected.Parent)) then
    TTermP(tvMain.Selected.Parent.Data).Data.SubTerm.Erase(Now)
  else
    FData.SubTerm.Erase(Now);
  Del(Now^.Data);
  tvMain.Items.Delete(tvMain.Selected);
end;

procedure TfrmMain.actEditExecute(Sender: TObject);
var
  Name: String;
  Pages: String;
  IsChild: Boolean;
  Res: Integer;
  Now: TTerm;
  DataPointer: TList<TTerm>.TDataP;
begin
  Now := TTermP(tvMain.Selected.Data)^.Data;
  frmEdit.cbChild.Enabled := False;
  Name := Now.Title;
  Pages := ListToString(Now.Pages);
  IsChild := False;
  Res := frmEdit.FillAndShow(Name, Pages, IsChild);
  frmEdit.cbChild.Enabled := True;
  if Res = mrOk then
  begin
    Now.Title := Name;
    Now.Pages.Destroy;
    Now.Pages := Parse(Pages);

    if Assigned(tvMain.Selected.Parent) then
    begin
      TTermP(tvMain.Selected.Parent.Data)^.Data.SubTerm.Erase(tvMain.Selected.Data);
      DataPointer := TTermP(tvMain.Selected.Parent.Data)^.Data.SubTerm.Insert(Now);
    end
    else
    begin
      FData.SubTerm.Erase(tvMain.Selected.Data);
      DataPointer := FData.SubTerm.Insert(Now);
    end;

    tvMain.Selected.Text := GetText(Now);
    tvMain.Selected.Data := DataPointer;
  end;
end;

procedure TfrmMain.actFindExecute(Sender: TObject);
begin
  frmFind.CustomModal(tvMain.Items);
end;

function LessAlpha(const a, b: TTerm): Boolean;
begin
  Result := a.Title < b.Title;
end;

function LessList(const a, b: TTerm): Boolean;
var
  Tmpa, Tmpb: TList<Integer>.TDataP;
begin
  Tmpa := a.Pages.Front;
  Tmpb := b.Pages.Front;
  while (Tmpa <> nil) and (Tmpb <> nil) and (Tmpa^.Data = Tmpb^.Data) do
  begin
    Tmpa := Tmpa^.Next;
    Tmpb := Tmpb^.Next;
  end;
  if (Tmpa = nil) then Result := True
  else if (TmpB = nil) then Result := False
  else Result := Tmpa^.Data < Tmpb^.Data;
end;

function LessNodeAlpha(A, B, Data: Longint): Integer; stdcall;
var
  Res: Integer;
begin
  if LessAlpha(TTermP(TTreeNode(A).Data)^.Data, TTermP(TTreeNode(B).Data)^.Data) then Result := -1
  else Result := 1;
  if Data = 1 then Result := -Result;
end;

function LessNodeList(A, B, Data: Longint): Integer; stdcall;
begin
  if LessList(TTermP(TTreeNode(A).Data)^.Data, TTermP(TTreeNode(B).Data)^.Data) then Result := -1
  else Result := 1;
  if Data = 1 then Result := -Result;
end;

procedure TfrmMain.actSortExecute(Sender: TObject);
var
  SortBy, SortOrder: Boolean;
  Res, SortOrderParam: Integer;
  I: Integer;
begin
  Res := frmSortType.ShowAndGet(SortBy, SortOrder);
  SortOrderParam := 0;
  if not SortOrder then SortOrderParam := 1;
  
  if SortBy then
    tvMain.Items.CustomSort(@LessNodeList, SortOrderParam, True)
  else
    tvMain.Items.CustomSort(@LessNodeAlpha, SortOrderParam, True);
end;

procedure TfrmMain.actViewExecute(Sender: TObject);
begin
  //
end;

procedure TfrmMain.alMainUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  actEdit.Enabled := Assigned(tvMain.Selected);
  actDelete.Enabled := Assigned(tvMain.Selected);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  tmp: TList<Integer>;
begin
  tmp := TList<Integer>.Create;
  tmp.Sort(Less);
  FData.SubTerm := TOpenHashTable<TTerm>.Create(HashTerm, TermEqual);
end;

end.

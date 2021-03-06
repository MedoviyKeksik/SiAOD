unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, System.Generics.Collections,
  Vcl.StdCtrls;

type
  TState = (stEmpty, stWall, stPlayer, stDoor);
  TDynArray = array of TState;
  TDynMatrix = array of TDynArray;
  TPath = array of TPoint;
  TDynArrayInt = array of Integer;
  TDynMatrixInt = array of TDynArrayInt;

  TLevel = class(TComponent)
  private
    FHeigth, FWidth: Integer;
    FNumHeight, FNumWidth: Integer;
    FColor: TColor;
    FMatrix: TDynMatrix;
    FStartPoint: TPoint;
    FEndPoint: TPoint;
    FPath: TPath;
    FStep: Integer;
    FTimer: TTimer;
    FCanvas: TCanvas;
    FImg: TImage;
    procedure OnTimer(Sender: TObject);
    procedure DrawPlayer(Rect: TRect); overload;
    procedure DrawPlayer(Cell: TPoint); overload;
  public
    constructor Create(ACanvas: TCanvas; Width, Heigth: Integer); overload;
    constructor Create(Image: TImage); overload;
    destructor Destroy;
    procedure UpdateSize;
    procedure Animate;
    procedure Draw;
    procedure GetPath;
    property Heigth: Integer read FHeigth write FHeigth;
    property Width: Integer read FWidth write FWidth;
    property NumHeigth: Integer read FNumHeight write FNumHeight;
    property NumWidth: Integer read FNumWidth write FNumWidth;
    property Color: TColor read FColor write FColor;
    property Matrix: TDynMatrix read FMatrix write FMatrix;
    property Start: TPoint read FStartPoint write FStartPoint;
    property Finish: TPoint read FEndPoint write FEndPoint;
    procedure ReadFile(var F: Text);
    procedure ReDraw;
  end;

  TDynArrayLevel = array of TLevel;

  TfrmMain = class(TForm)
    imgMain: TImage;
    menuMain: TMainMenu;
    btnStart: TButton;
    comboFloor: TComboBox;
    lblLevel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure comboFloorChange(Sender: TObject);
    procedure ReDraw;
    procedure imgMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FLevels: TDynArrayLevel;
    FCurrentLevel, FNumberLevels: Integer;
    { Private declarations }
  public
    { Public declarations }
  end;


var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TLevel }

procedure TLevel.Animate;
begin
  FTimer.Enabled := True;
end;

constructor TLevel.Create(ACanvas: TCanvas; Width, Heigth: Integer);
begin
  FTimer := TTimer.Create(Self);
  FTimer.Interval := 100;
  FTimer.OnTimer := OnTimer;
  FTimer.Enabled := False;
  FStep := 0;
  FWidth := Width;
  FHeigth := Heigth;
  FCanvas := ACanvas;
end;

constructor TLevel.Create(Image: TImage);
begin
  FImg := Image;
  Create(Image.Canvas, Image.Width, Image.Height);
end;

destructor TLevel.Destroy;
begin
  FTimer.Free;
  Inherited;
end;

procedure TLevel.Draw;
var
  WidthStep, HeightStep: Real;
  I, J: Integer;
  Cell: TRect;
begin
  WidthStep := (FWidth - 1) / FNumWidth;
  HeightStep := (FHeigth - 1) / FNumHeight;

  for I := 0 to FNumWidth do
  begin
    FCanvas.MoveTo(Round(WidthStep * I), 0);
    FCanvas.LineTo(Round(WidthStep * I), FHeigth);
  end;

  for I := 0 to FNumHeight do
  begin
    FCanvas.MoveTo(0, Round(I * HeightStep));
    FCanvas.LineTo(FWidth, Round(I * HeightStep));
  end;

  for I := 0 to FNumHeight - 1 do
    for J := 0 to FNumWidth - 1 do
    begin
      Cell.Top := Round(I * HeightStep);
      Cell.Left := Round(J * WidthStep);
      Cell.Width := Round(FWidth / NumWidth);
      Cell.Height := Round(FHeigth / NumHeigth);
      case Matrix[I][J] of
        stWall:
        begin
          FCanvas.Brush.Color := Color;
          FCanvas.FloodFill(Cell.CenterPoint.X, Cell.CenterPoint.Y, clWhite, fsSurface);
        end;
        stPlayer: DrawPlayer(Cell);
        stDoor:
        begin
          FCanvas.Brush.Color := clPurple;
          FCanvas.FillRect(Cell);
        end;
      end;
    end;

end;

procedure TLevel.DrawPlayer(Cell: TPoint);
var
  Tmp: TPoint;
  HeigthStep: Double;
  WidthStep: Double;
begin
  HeigthStep := FHeigth / FNumHeight;
  WidthStep := FWidth / FNumWidth;
  DrawPlayer(Rect(Round(Cell.Y * WidthStep), Round(Cell.X * HeigthStep), Round((Cell.Y + 1) * WidthStep), Round((Cell.X + 1) * HeigthStep)));
end;

procedure TLevel.DrawPlayer(Rect: TRect);
var
  TmpWidth: Real;
  TmpHeigth: Real;
begin
  FCanvas.Brush.Color := clRed;
  TmpWidth := FWidth / FNumWidth;
  TmpHeigth := FHeigth / FNumHeight;
  Rect.Left := Rect.Left + Round(TmpWidth / 4);
  Rect.Top := Rect.Top + Round(TmpHeigth / 4);
  Rect.Width := Round(TmpWidth / 2);
  Rect.Height := Round(TmpHeigth / 2);
  FCanvas.Ellipse(Rect);
end;

procedure TLevel.GetPath;

  function IsValid(Point: TPoint): Boolean;
  begin
    Result := (0 <= Point.X) and (Point.X < NumHeigth) and (0 <= Point.Y) and (Point.Y < NumWidth);
  end;

var
  delta: array[0..3] of TPoint;
  Q: TQueue<TPoint>;
  Now, Next: TPoint;
  I: Integer;
  tmp: TDynMatrixInt;
  J: Integer;
begin
  delta[0] := Point(0, 1);
  delta[1] := Point(0, -1);
  delta[2] := Point(1, 0);
  delta[3] := Point(-1, 0);
  SetLength(tmp, NumHeigth);
  for I := 0 to NumHeigth - 1 do
    SetLength(tmp[I], NumWidth);

  Q := TQueue<TPoint>.Create;
  Q.Enqueue(Start);
  tmp[Start.X][Start.Y] := 1;
  while Q.Count > 0 do
  begin
    Now := Q.Dequeue;
    for I := 0 to 3 do
      if IsValid(Now + delta[i]) then
      begin
        Next := Now + delta[i];
        if (tmp[Next.X][Next.Y] = 0) and (FMatrix[Next.X][Next.Y] <> stWall) then
        begin
          Q.Enqueue(Next);
          tmp[Next.X][Next.Y] := tmp[Now.X][Now.Y] + 1;
        end;
      end;
  end;
  SetLength(FPath, tmp[Finish.X][Finish.Y] + 1);
  Now := Finish;
  FPath[tmp[Finish.X][Finish.Y] - 1] := Finish;
  FPath[tmp[Finish.X][Finish.Y]] := Start;
  for I := tmp[Finish.X][Finish.Y] - 2 downto 0 do
  begin
    for J := 0 to 3 do
      if IsValid(now + delta[J]) then
      begin
        Next := Now + delta[J];
        if (tmp[Now.X][Now.Y] = tmp[Next.X][Next.Y] + 1) then
        begin
          FPath[I] := Next;
          Break;
        end;
      end;
    Now := Next;
  end;
end;

procedure TLevel.OnTimer(Sender: TObject);
begin
  if (FStep > 0) and (FStep < Length(FPath)) and (FMatrix[FPath[FStep - 1].X][FPath[FStep - 1].Y] <> stDoor) then
    FMatrix[FPath[FStep - 1].X][FPath[FStep - 1].Y] := stEmpty;
  if (FStep < Length(FPath)) and (FMatrix[FPath[FStep].X][FPath[FStep].Y] <> stDoor) then
    FMatrix[FPath[FStep].X][FPath[FStep].Y] := stPlayer;

  if FStep >= Length(FPath) then
  begin
    FTimer.Enabled := False;
    FStep := 0;
  end
  else
    Inc(FStep);
  ReDraw;
end;

procedure TLevel.ReadFile(var F: Text);
var
  I, J: Integer;
  Tmp: Integer;
  R, G, B: Integer;
begin
  ReadLn(F, FNumHeight, FNumWidth, R, G, B, FStartPoint.X, FStartPoint.Y, FEndPoint.X, FEndPoint.Y);
  UpdateSize;
  FColor := RGB(R, G, B);
  for I := 0 to FNumHeight - 1 do
    for J := 0 to FNumWidth - 1 do
    begin
      Read(F, Tmp);
      FMatrix[I][J] := TState(Tmp);
    end;
end;

procedure TLevel.ReDraw;
begin
  with FImg.Canvas do
  begin
    Brush.Color := clWhite;
    FillRect(Rect(0, 0, FImg.Width, FImg.Height));
  end;
  Draw;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  FLevels[FCurrentLevel].GetPath;
  FLevels[FCurrentLevel].Animate;
end;

procedure TfrmMain.comboFloorChange(Sender: TObject);
var
  Index: Integer;
begin
  btnStart.Enabled := True;
  FCurrentLevel := (Sender as TComboBox).ItemIndex;
  ReDraw;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  I, J: Integer;
  F: TextFile;
begin
  btnStart.Enabled := False;
  FCurrentLevel := -1;
  AssignFile(F, 'Level.txt');
  Reset(F);
  Read(F, FNumberLevels);

  SetLength(FLevels, FNumberLevels);
  for I := 0 to FNumberLevels - 1 do
  begin
    FLevels[I] := TLevel.Create(imgMain);
    FLevels[I].ReadFile(F);
    comboFloor.Items.Add(IntToStr(I + 1) + ' floor');
  end;
  CloseFile(F);
end;

procedure TfrmMain.FormPaint(Sender: TObject);
begin
  if FCurrentLevel >= 0 then
    FLevels[FCurrentLevel].Draw;
end;

procedure TfrmMain.imgMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  CurLevel: TLevel;
  Cell: TPoint;
  WidthStep, HeigthStep: Real;
begin
  if FCurrentLevel >= 0 then
  begin
    CurLevel := FLevels[FCurrentLevel];
    WidthStep := CurLevel.Width / CurLevel.NumWidth;
    HeigthStep := CurLevel.Heigth / CurLevel.NumHeigth;
    Cell := Point(Trunc(Y / HeigthStep), Trunc(X / WidthStep));
    CurLevel.ReDraw;
    if CurLevel.Matrix[Cell.X][Cell.Y] = stEmpty then
    begin
      imgMain.Canvas.Brush.Color := clBlue;
      imgMain.Canvas.Brush.Style := bsDiagCross;
      imgMain.Canvas.Rectangle(Rect(Round(Cell.Y * WidthStep), Round(Cell.X * HeigthStep), Round((Cell.Y + 1) * WidthStep), Round((Cell.X + 1) * HeigthStep)));
      imgMain.Canvas.Brush.Style := bsSolid;
    end;
  end;
end;

procedure TfrmMain.imgMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  CurLevel: TLevel;
  Cell: TPoint;
  WidthStep, HeigthStep: Real;
begin
  if FCurrentLevel >= 0 then
  begin
    CurLevel := FLevels[FCurrentLevel];
    WidthStep := CurLevel.Width / CurLevel.NumWidth;
    HeigthStep := CurLevel.Heigth / CurLevel.NumHeigth;
    Cell := Point(Trunc(Y / HeigthStep), Trunc(X / WidthStep));
    if (CurLevel.Matrix[Cell.X][Cell.Y] = stEmpty) then
    begin
      CurLEvel.Matrix[CurLevel.Start.X][CurLevel.Start.Y] := stEmpty;
      CurLevel.Matrix[Cell.X][Cell.Y] := stPlayer;
      CurLevel.Start := Cell;
    end;
    CurLevel.ReDraw;
  end;
end;

procedure TfrmMain.ReDraw;
begin
  FLevels[FCurrentLevel].ReDraw;
end;

procedure TLevel.UpdateSize;
var
  I: Integer;
begin
  SetLength(FMatrix, FNumHeight);;
  for I := 0 to NumHeigth - 1 do
    SetLength(FMatrix[I], FNumWidth);
end;

end.

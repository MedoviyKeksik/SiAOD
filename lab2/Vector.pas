unit Vector;

interface

type
  TVector<T> = class
  private
    FData: array of T;
    FDataSize: Integer;
    FReservedSize: Integer;

    function ReadAt(const Ind: Integer): T;
    procedure WriteAt(const Ind: Integer; const Value: T);

  public
    constructor Create;
    destructor Destroy;

    function Front: T;
    function Back: T;
    procedure Erase(const Id: Integer);
    procedure PushBack(const X: T);

    function Size: Integer;
    function Empty: Boolean;

    procedure Clear;
    procedure Reserve(const X: Integer);

    property At[const Index: Integer]: T read ReadAt write WriteAt;
  end;

implementation

{ TVector<T> }

function TVector<T>.Back: T;
begin
  Result := FData[FDataSize - 1];
end;

procedure TVector<T>.Clear;
begin
  FDataSize := 0;
  FReservedSize := 1;
  SetLength(FData, FReservedSize);
end;

constructor TVector<T>.Create;
begin
  FDataSize := 0;
  FReservedSize := 1;
  SetLength(FData, FReservedSize);
end;

destructor TVector<T>.Destroy;
begin
  FReservedSize := 0;
  SetLength(FData, FReservedSize);
  inherited;
end;

function TVector<T>.Empty: Boolean;
begin
  Result := FDataSize = 0;
end;

procedure TVector<T>.Erase(const Id: Integer);
var
  I: Integer;
begin
  Dec(FDataSize);
  for I := Id to FDataSize - 1 do
    FData[I] := FData[I + 1];
end;

function TVector<T>.Front: T;
begin
  Result := FData[0];
end;

procedure TVector<T>.PushBack(const X: T);
begin
  if FDataSize = FReservedSize then
  begin
    FReservedSize := FReservedSize shl 1;
    SetLength(FData, FReservedSize);
  end;
  FData[FDataSize] := X;
  Inc(FDataSize);
end;

function TVector<T>.ReadAt(const Ind: Integer): T;
begin
  Result := FData[Ind];
end;

procedure TVector<T>.Reserve(const X: Integer);
begin
  FDataSize := X;
  FReservedSize := X;
  SetLength(FData, FReservedSize);
end;

function TVector<T>.Size: Integer;
begin
  Result := FDataSize;
end;

procedure TVector<T>.WriteAt(const Ind: Integer; const Value: T);
begin
  FData[Ind] := Value;
end;

end.

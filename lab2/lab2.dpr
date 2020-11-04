program lab2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  Vector;

type
  TNodeP = ^TNode;
  TNode = record
    Power: Integer;
    k: Integer;
    Next: TNodeP;
  end;

function BinPower(a, n: Integer): Integer;
begin
  if n = 0 then Result := 1
  else if (n and 1) = 1 then Result := BinPower(a, n - 1) * a
  else Result := BinPower(Sqr(a), n shr 1);
end;

function Equality(p, q: TNodeP): Boolean;
begin
  Result := True;
  while Result and (p <> Nil) and (q <> Nil) do
  begin
    if (p^.Power <> q^.Power) or (p^.k <> q^.k) then
      Result := False;
    p := p^.Next;
    q := q^.Next;
  end;
end;

function Meaning(p: TNodeP; x: Integer): Integer;
begin
  Result := 0;
  while p <> Nil do
  begin
    Result := Result + p^.k * BinPower(x, p^.Power);
    p := p^.Next;
  end;
end;

procedure Add(var p: TNodeP; q, r: TNodeP);
var
  Head, Tmp: TNodeP;
begin
  if (r <> Nil) and (q <> Nil) then
  begin
    New(Head);
    Head^.Next := Nil;
    Tmp := Head;
    while (r <> Nil) and (q <> Nil) do
    begin
      New(Tmp^.Next);
      Tmp := Tmp^.Next;
      Tmp^.Next := Nil;
      if (r^.Power = q^.Power) then
      begin
        Tmp^.Power := r^.Power;
        Tmp^.k := r^.k + q^.k;
        r := r^.Next;
        q := q^.Next;
      end
      else if (r^.Power > q^.Power) then
      begin
        Tmp^.Power := r^.Power;
        Tmp^.k := r^.k;
        r := r^.Next;
      end
      else
      begin
        Tmp^.Power := q^.Power;
        Tmp^.k := q^.k;
        q := q^.Next;
      end;
    end;

    while r <> Nil do
    begin
      New(Tmp^.Next);
      Tmp := Tmp^.Next;
      Tmp^.Next := Nil;
      Tmp^.Power := r^.Power;
      Tmp^.k := r^.k;
      r := r^.Next;
    end;

    while q <> Nil do
    begin
      New(Tmp^.Next);
      Tmp := Tmp^.Next;
      Tmp^.Next := Nil;
      Tmp^.Power := r^.Power;
      Tmp^.k := r^.k;
      r := r^.Next;
    end;

    p := Head^.Next;
    Dispose(Head);
  end;
end;

function FetchMenu(const L, R: Integer; Msg: String = 'Выберите пункт меню: '; Flag: Boolean = False): Integer;
var
  S: String;
  ErrPos: Integer;
begin
  Write(Msg);
  ReadLn(S);
  S := Trim(S);
  Val(S, Result, ErrPos);
  while ((Flag) or (Result <> -1)) and ((ErrPos <> 0) or (Result > R) or (Result < L)) do
  begin
    WriteLn('Неверный ввод. Попробуйте еще раз.');
    ReadLn(S);
    S := Trim(S);
    Val(S, Result, ErrPos);
  end;
end;

procedure ListInput(var p: TNodeP);
var
  MaxPower, k: Integer;
  I: Integer;
  Head, Tmp: TNodeP;
begin
  MaxPower := FetchMenu(0, 2000000, 'Введите максимальную степень многочлена: ', True);
  New(Head);
  Head^.Next := Nil;
  Tmp := Head;
  for I := MaxPower downto 0 do
  begin
    Write('Степень ', I, ', Коэффициент: ');
    ReadLn(k);
    if k <> 0 then
    begin
      New(Tmp^.Next);
      Tmp := Tmp^.Next;
      Tmp^.Next := Nil;
      Tmp^.Power := I;
      Tmp^.k := k;
    end;
  end;
  p := Head^.Next;
end;

procedure WriteList(p: TNodeP);
begin
  if p <> Nil then
  begin
    while (p^.Next <> Nil) do
    begin
      Write(p^.k, '*x^', p^.Power, ' + ');
      p := p^.Next;
    end;
    if p^.Power = 0 then
      Writeln(p^.k)
    else
      Writeln(p^.k, '*x^', p^.Power);
  end;
end;

procedure Pause;
begin
  WriteLn('Press Enter to continue...');
  ReadLn;
end;

procedure Menu;
begin
  WriteLn('1. Ввод многочлена');
  WriteLn('2. Вывод многочлена');
  WriteLn('3. Проверить на равенство многочлены (Equality)');
  WriteLn('4. Вычислить значение многочлена (Meaning)');
  WriteLn('5. Вычисление суммы многочлена (Add)');
  WriteLn('6. Выход');
end;

var
  p, q, r: TNodeP;
  Now, tmp, tmp1, tmp2: Integer;
  Data: TVector<TNodeP>;

begin
  Data := TVector<TNodeP>.Create;
  Menu;
  Now := FetchMenu(1, 6);
  while Now <> 6 do
  begin
    case Now of
      1:
      begin
        ListInput(p);
        Data.PushBack(p);
        WriteLn('List index: ', Data.Size);
      end;
      2:
      begin
        tmp := FetchMenu(1, Data.Size, 'Введите индекс списка (1-' + IntToStr(Data.Size) + '):');
        if (tmp <> -1) then
          WriteList(Data.At[tmp - 1]);
      end;
      3:
      begin
        tmp := FetchMenu(1, Data.Size, 'Введите индекс первого списка (1-' + IntToStr(Data.Size) + '):');
        if (tmp <> -1) then
        begin
          tmp1 := FetchMenu(1, Data.Size, 'Введите индекс второго списка (1-' + IntToStr(Data.Size) + '):');
          if (tmp1 <> -1) then
          begin
            if Equality(Data.At[tmp - 1], Data.At[tmp1 - 1]) then
              WriteLn('Equal')
            else
              WriteLn('Not equal');
          end;
        end;
      end;
      4:
      begin
        tmp := FetchMenu(1, Data.Size, 'Введите индекс списка (1-' + IntToStr(Data.Size) + '):');
        if (tmp <> -1) then
        begin
          Write('Введите число x: ');
          ReadLn(tmp1);
          WriteLn('Result = ', Meaning(Data.At[tmp - 1], tmp1));
        end;
      end;
      5:
      begin
        tmp := FetchMenu(1, Data.Size, 'Введите индекс первого списка (1-' + IntToStr(Data.Size) + '):');
        if (tmp <> -1) then
        begin
          tmp1 := FetchMenu(1, Data.Size, 'Введите индекс второго списка (1-' + IntToStr(Data.Size) + '):');
          if (tmp1 <> -1) then
          begin
            Add(p, Data.At[tmp - 1], Data.At[tmp1 - 1]);
            Data.PushBack(p);
            WriteLn('List Index = ', Data.Size);
            WriteList(p);
          end;
        end;
      end;
    end;
    Menu;
    Now := FetchMenu(1, 6);
  end;
  Pause;
end.

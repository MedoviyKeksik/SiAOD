unit uHash;

interface

const
  HashMod = 1000000000 + 7;

type
  THash = UInt64;
  THashF<T> = function(const X: T): THash;

implementation

end.

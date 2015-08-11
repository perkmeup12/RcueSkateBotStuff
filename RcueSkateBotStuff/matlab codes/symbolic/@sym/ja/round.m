%ROUND  シンボリック行列の要素単位の丸め
%
%   Y = ROUND(X) は、X の要素を最も近い整数に丸めます。
%   2 つの整数の中間の値は、0 から離れたところに丸められます。
%   例:
%      x = sym(-5/2)
%      [fix(x) floor(x) round(x) ceil(x) frac(x)]
%      = [ -2, -3, -3, -2, -1/2]
%
%   参考 SYM/FLOOR, SYM/CEIL, SYM/FIX, SYM/FRAC.


%   Copyright 1993-2008 The MathWorks, Inc.

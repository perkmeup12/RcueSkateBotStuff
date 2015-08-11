%FLOOR  シンボリック行列の要素単位の切捨て
%
%   Y = FLOOR(X) は、X よりも小さい (整数 <= X) 数の最大の整数の行列です。
%   例:
%      x = sym(-5/2)
%      [fix(x) floor(x) round(x) ceil(x) frac(x)]
%      = [ -2, -3, -3, -2, -1/2]
%
%   参考 SYM/ROUND, SYM/CEIL, SYM/FIX, SYM/FRAC.


%   Copyright 1993-2008 The MathWorks, Inc.

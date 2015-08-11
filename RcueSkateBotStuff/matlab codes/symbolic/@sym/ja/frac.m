%FRAC  シンボリック行列の要素単位の小数部
%
%   Y = FRAC(X) は、X の要素の小数部の行列です。
%   FRAC(X) = X - FIX(X) です。
%   例:
%      x = sym(-5/2)
%      [fix(x) floor(x) round(x) ceil(x) frac(x)]
%      = [ -2, -3, -3, -2, -1/2]
%
%   参考 SYM/ROUND, SYM/CEIL, SYM/FLOOR, SYM/FIX.


%   Copyright 1993-2008 The MathWorks, Inc.

%FACTOR  シンボリックな因数分解
%
%   FACTOR(S) は、S がシンボリック行列のとき、S を要素毎に因数分解します。
%   S が、すべて整数の要素を含む場合、素因数分解が計算されます。2^52 より
%   大きい整数を因数分解するには、FACTOR(SYM('N')) を使用します。
%
%   例:
%
%      factor(x^9-1) is
%      (x - 1)*(x^2 + x + 1)*(x^6 + x^3 + 1)
%
%      factor(sym('12345678901234567890')) は、以下のようになります。
%      2*3^2*5*101*3541*3607*3803*27961
%
%   参考 SYM/FACTOR, SYM/SIMPLIFY, SYM/EXPAND, SYM/SIMPLE, SYM/COLLECT.


%   Copyright 1993-2009 The MathWorks, Inc.

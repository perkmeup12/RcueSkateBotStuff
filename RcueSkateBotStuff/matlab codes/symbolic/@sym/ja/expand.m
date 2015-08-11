%EXPAND  シンボリックな展開
%
%   EXPAND(S) は、シンボリック式 S の各々の要素を因数の積として書き出します。
%   EXPAND は、主に多項式を展開しますが、三角関数や指数関数、対数関数のような
%   数学関数も展開します。
%
%   例:
%      expand((x+1)^3) は x^3+3*x^2+3*x+1 を返します。
%      expand(sin(x+y)) は sin(x)*cos(y)+cos(x)*sin(y) を返します。
%      expand(exp(x+y)) は exp(x)*exp(y) を返します。
%
%   参考 SYM/SIMPLIFY, SYM/SIMPLE, SYM/FACTOR, SYM/COLLECT.


%   Copyright 1993-2008 The MathWorks, Inc.

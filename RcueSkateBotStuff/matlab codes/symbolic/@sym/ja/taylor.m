%TAYLOR  テイラー級数展開
%
%   TAYLOR(f) は、f に対して 5 次の Maclaurin 多項式近似です。3 つのパラメータ
%   を任意の順序で与えることができます。TAYLOR(f, n) は、(n-1) 次の Maclaurin 
%   多項式です。TAYLOR(f, a) は、点 a に関するテイラー多項式近似を求めます。
%   TAYLOR(f, x) は、FINDSYM(f) の代わりに独立変数 x を使います。
%
%   例:
%      taylor(exp(-x))   は、以下を返します。
%        x^4/24 - x^5/120 - x^3/6 + x^2/2 - x + 1
%      taylor(log(x),6,1)   は、以下を返します。
%        x - (x - 1)^2/2 + (x - 1)^3/3 - (x - 1)^4/4 + (x - 1)^5/5 - 1
%      taylor(sin(x),pi/2,6)   は、以下を返します。
%        (pi/2 - x)^4/24 - (pi/2 - x)^2/2 + 1
%      taylor(x^t,3,t)   は、以下を返します。
%        (t^2*log(x)^2)/2 + t*log(x) + 1
%
%   参考 SYM/FINDSYM, SYM/SYMSUM.


%   Copyright 1993-2009 The MathWorks, Inc.

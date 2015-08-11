%COLLECT  係数をまとめる
%
%   COLLECT(S,v) は、シンボリック行列 S の各々の要素を v の多項式とみなし、 
%   Sを v のべき乗の形式で書き直します。COLLECT(S) は、FINDSYM で決定される
%   デフォルト変数を使います。
%
%   例:
%      collect(x^2*y + y*x - x^2 - 2*x)  returns (y - 1)*x^2 + (y - 2)*x
%
%      f = -1/4*x*exp(-2*x)+3/16*exp(-2*x)
%      collect(f,exp(-2*x)) は -(x/4 - 3/16)/exp(2*x) を返します。
%
%   参考 SYM/SIMPLIFY, SYM/SIMPLE, SYM/FACTOR, SYM/EXPAND, SYM/FINDSYM.


%   Copyright 1993-2009 The MathWorks, Inc.

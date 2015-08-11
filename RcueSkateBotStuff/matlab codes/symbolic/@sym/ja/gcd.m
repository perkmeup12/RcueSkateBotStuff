%GCD  最大公約数
%
%   G = GCD(A,B) は、A と B のシンボリックな最大公約数です。
%   G = GCD(A,B,X) は、FINDSYM(A,1) の代わりに変数 X を使います。[
%   G,C,D] = GCD(A,B,...) は、G = A*C + B*D となるような C と D も返します。
%
%   例:
%      syms x
%      gcd(x^3-3*x^2+3*x-1,x^2-5*x+4)
%      は x-1 を返します。
%
%   参考 SYM/LCM.


%   Copyright 1993-2008 The MathWorks, Inc.

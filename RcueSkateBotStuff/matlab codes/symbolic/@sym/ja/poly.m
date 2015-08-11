%POLY  シンボリックな特性多項式
%
%   POLY(A) は、シンボリック行列 A の特性多項式を計算します。
%   結果は、'x' または 't' によるシンボリックな多項式になります。
%
%   POLY(A, v) は、'x' の代わりに 'v' を使います。v はシンボリック式です。
%
%   例:
%      poly([a b; c d]) は x^2 + (- a - d)*x + a*d - b*c を返します。
%
%   参考 SYM/POLY, SYM/POLY2SYM, SYM/SYM2POLY, SYM/JORDAN, SYM/EIG, 
%        SYM/SOLVE.


%   Copyright 1993-2009 The MathWorks, Inc.

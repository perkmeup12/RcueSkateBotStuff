%COEFFS  多変数多項式の係数
%
%   C = COEFFS(P) は、P のすべての不定方程式に関する多項式 P の係数を返します。
%   C = COEFFS(P,X) は、X に関する多項式 P の係数を返します。
%   [C,T] = COEFFS(P,...) は、P の項の式列も返します。係数と P の項の間で 
%   1 対 1 で一致します。
%
%   例:
%      syms x
%      t = 2 + (3 + 4*log(x))^2 - 5*log(x);
%      coeffs(expand(t)) = [ 11, 19, 16]
%
%      syms a b c x
%      y = a + b*sin(x) + c*sin(2*x)
%      coeffs(y,sin(x)) = [a + c*sin(2*x), b]
%      coeffs(expand(y),sin(x)) = [a, b + 2*c*cos(x)]
%
%      syms x y
%      z = 3*x^2*y^2 + 5*x*y^3
%      coeffs(z) = [5, 3]
%      coeffs(z,x) = [5*y^3, 3*y^2]
%      [c,t] = coeffs(z,y) は c = [5*x, 3*x^2], t = [y^3, y^2] を返します。
%
%   参考 SYM/SYM2POLY.


%   Copyright 1993-2009 The MathWorks, Inc.

%SORT  シンボリックなベクトル、あるいは多項式の並べ替え
%
%   Y = SORT(V) は、シンボリックベクトルの要素 V を数値的に、あるいは
%   辞書式の順序に並べ替えます。
%   Y = SORT(P) は、多項式 P の項を降順に並べ替えます。
%
%   例:
%      syms a b c d e x
%      sort(sym(magic(3))) = [1,2,3,4,5,6,7,8,9]
%      sort([a c e b d]) = [a b c d e]
%      sort([a c e b d]*x.^(0:4).') =
%         d*x^4 + b*x^3 + e*x^2 + c*x + a
%
%   参考 SYM/SYM2POLY, SYM/COEFFS.


%   Copyright 1993-2008 The MathWorks, Inc.

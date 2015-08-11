%MOD  シンボリック行列の要素単位の剰余
%
%   整数の要素を持つシンボリック行列 A と B に対する C = MOD(A,B) は、B に
%   よる A の要素単位の除算の正の余りです。多項式の入力を持つ行列 A に対して、
%   MOD(A,B) は、個々の係数に適用されます。
%
%   例:
%      ten = sym('10');
%      mod(2^ten,ten^3)
%      24
%
%      syms x
%      mod(x^3-2*x+999,10)
%      x^3+8*x+9
%
%   参考 SYM/QUOREM.


%   Copyright 1993-2008 The MathWorks, Inc.

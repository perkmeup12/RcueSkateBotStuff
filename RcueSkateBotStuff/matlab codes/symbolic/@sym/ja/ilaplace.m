%ILAPLACE  逆ラプラス変換
%
%   F = ILAPLACE(L) は、デフォルトの独立変数 s を持つスカラのシンボリック
%   オブジェクト L の逆ラプラス変換です。デフォルトの出力は、t の関数です。
%   L = L(t) の場合、ILAPLACE は、x の関数 F = F(x) を返します。
%   定義により、F(t) = int(L(s)*exp, (s*t), s, c-i*inf, c+i*inf) で、
%   ここで、c は実数値で、L(s) のすべての特異点がライン s = c の左側に
%   なるように選択し、i = sqrt(-1) において、積分は s について計算されます。
%
%   F = ILAPLACE(L, y)は、デフォルトの t の代わりに、y の関数 F を計算します。
%       ILAPLACE(L,y) <=> F(y) = int(L(y)*exp(s*y),s,c-i*inf,c+i*inf)
%   ここで、y はスカラのシンボリックオブジェクトです。
%
%   F = ILAPLACE(L, y, x) は、デフォルトの t の代わりに、x の関数 F を計算し、
%   y について積分します。
%   ILAPLACE(L,y,x) <=> F(y) = int(L(y)*exp(x*y),y,c-i*inf,c+i*inf)
%
%   例:
%      syms s t w x y
%      ilaplace(1/(s-1)) は exp(t) を返します。
%      ilaplace(1/(t^2+1)) は sin(x) を返します。
%      ilaplace(t^(-sym(5/2)),x) は 4/3/pi^(1/2)*x^(3/2) を返します。
%      ilaplace(y/(y^2 + w^2),y,x) は cos(w*x) を返します。
%      ilaplace(sym('laplace(F(x),x,s)'),s,x) は F(x) を返します。
%
%   参考 SYM/LAPLACE, SYM/IFOURIER, SYM/IZTRANS.


%   Copyright 1993-2008 The MathWorks, Inc.

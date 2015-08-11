%LAPLACE  ラプラス変換
%
%   L = LAPLACE(F) は、デフォルトの独立変数 t を持つスカラのシンボリック
%   オブジェクト F のラプラス変換です。デフォルトの出力は、s の関数です。
%   F = F(s) の場合、LAPLACE は t の関数 L = L(t) を返します。
%   定義により、L(s) = int(F(t)*exp(-s*t),0,inf) で、t について積分します。
%
%   L = LAPLACE(F, t) は、デフォルトの s の代わりに、t の関数 L を計算します。 
%   LAPLACE(F,t) <=> L(t) = int(F(x)*exp(-t*x),0,inf)
%
%   L = LAPLACE(F, w, z) は、デフォルトの s の代わりに、z の関数 L を
%   計算します (w について積分します)。
%   LAPLACE(F,w,z) <=> L(z) = int(F(w)*exp(-z*w),0,inf)
%
%   例:
%      syms a s t w x
%      laplace(t^5) は 120/s^6 を返します。
%      laplace(exp(a*s)) は 1/(t-a) を返します。
%      laplace(sin(w*x),t) は w/(t^2+w^2) を返します。
%      laplace(cos(x*w),w,t) は t/(t^2+x^2) を返します。
%      laplace(x^sym(3/2),t) は 3/4*pi^(1/2)/t^(5/2) を返します。
%      laplace(diff(sym('F(t)'))) は laplace(F(t),t,s)*s-F(0) を返します。
%
%   参考 SYM/ILAPLACE, SYM/FOURIER, SYM/ZTRANS.


%   Copyright 1993-2008 The MathWorks, Inc.

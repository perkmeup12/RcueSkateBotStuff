%IZTRANS  逆 Z-変換
%
%   f = IZTRANS(F) は、デフォルトの独立変数 z を持つスカラシンボリック
%   オブジェクト F の逆 Z-変換です。デフォルトの出力は、n の関数 
%   F = F(z) => f = f(n) です。F = F(n) ならば、IZTRANS は、k の関数 
%   f = f(k) を返します。
%   f = IZTRANS(F, k) は、デフォルトの n の代わりに、k の関数 f を計算します。
%   ここで、m はスカラシンボリックオブジェクトです。
%   f = IZTRANS(F, w, k) は、デフォルトの symvar(F) の代わりに、w の関数 
%   F を計算し、k の関数 F = F(w) と f = f(k) を返します。
%
%   例:
%      iztrans(z/(z-2)) は 2^n を返します。
%      iztrans(exp(x/z), z, k) は x^k/k! を返します。
%
%   参考 SYM/ZTRANS, SYM/LAPLACE, SYM/FOURIER.


%   Copyright 1993-2008 The MathWorks, Inc.

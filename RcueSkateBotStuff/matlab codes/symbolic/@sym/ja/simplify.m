%SIMPLIFY  シンボリックな簡略化
%
%   SIMPLIFY(S) は、シンボリック行列 S の各要素を簡略化します。
%   SIMPLIFY(S,N) は、N 回のステップで簡略化を検索します。
%   N のデフォルト値は 50 です。
%
%   例:
%      simplify(sin(x)^2 + cos(x)^2) は 1 です。
%      simplify(exp(c*log(sqrt(alpha+beta))))
%
%   参考 SYM/SIMPLE, SYM/FACTOR, SYM/EXPAND, SYM/COLLECT.


%   Copyright 1993-2009 The MathWorks, Inc.

%SIMPLE  シンボリック式または行列の最もシンプルなフォームの検索
%
%   SIMPLE(S) は、S のそれぞれに異なる代数的な簡略化を試行し、どのように 
%   S の表現の長さを短くしたかを表示しながら、最も短い表現を返します。
%   S はシンボリックオブジェクトです。S が行列の場合、結果は行列全体が
%   最も短くなる表現です。個々の要素が最も短いとは限りません。
%
%   [R,HOW] = SIMPLE(S) は、簡略化の途中結果を表示しませんが、最も短い表現と
%   共に、特定の簡略化の方法を示す文字列が得られます。R はシンボリック式です。
%   HOW は文字列です。
%
%   例:
%
%      S                          R                  How
%
%      cos(x)^2+sin(x)^2          1                  simplify
%      2*cos(x)^2-sin(x)^2        3*cos(x)^2-1       simplify
%      cos(x)^2-sin(x)^2          cos(2*x)           simplify
%      cos(x)+i*sin(x)            exp(i*x)           rewrite(exp)
%      (x+1)*x*(x-1)              x^3-x              simplify(100)
%      x^3+3*x^2+3*x+1            (x+1)^3            simplify
%      cos(3*acos(x))             4*x^3-3*x          simplify(100)
%
%   参考 SYM/SIMPLIFY, SYM/FACTOR, SYM/EXPAND, SYM/COLLECT.


%   Copyright 1993-2009 The MathWorks, Inc.

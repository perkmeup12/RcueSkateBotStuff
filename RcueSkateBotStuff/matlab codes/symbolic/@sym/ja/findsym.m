%FINDSYM  シンボリック式または行列内の変数の検出
%
%   FINDSYM(S) は、S がシンボリックなスカラ、または行列の場合、S の中の
%   すべてのシンボリック変数を含む文字列を返します。変数は、辞書順にカンマ
%   区切りで返されます。シンボリック変数を含んでいない場合、FINDSYM は
%   空文字列を返します。定数 pi, i, j は、変数とはみなされません。
%
%   FINDSYM(S,N) は、'x' または 'X' に近い N 個のシンボリック変数を返します。
%   大文字の変数は、小文字の変数より前に返されます。
%
%   例:
%      findsym(alpha+a+b) は、以下を返します。
%       a, alpha, b
%
%      findsym(cos(alpha)*b*x1 + 14*y,2) は、以下を返します。
%       x1,y
%
%      findsym(y*(4+3*i) + 6*j) は、以下を返します。
%       y


%   Copyright 1993-2009 The MathWorks, Inc.

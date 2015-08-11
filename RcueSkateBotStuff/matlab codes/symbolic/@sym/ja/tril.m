%TRIL  シンボリックな下三角行列
%
%   TRIL(X) は、X の下三角部分です。
%   TRIL(X, K) は、X の K 番目の対角上とその下側の要素です。
%   K = 0 は主対角 K > 0 は主対角の上側の対角、K < 0 は主対角の下側の対角です。
%
%   例:
%
%      以下のデータと仮定します。
%      A =
%         [   a,   b,   c ]
%         [   1,   2,   3 ]
%         [ a+1, b+2, c+3 ]
%
%      tril(A) は、以下の結果を返します。
%         [   a,   0,   0 ]
%         [   1,   2,   0 ]
%         [ a+1, b+2, c+3 ]
%
%      tril(A,1) は、以下の結果を返します。
%         [   a,   b,   0 ]
%         [   1,   2,   3 ]
%         [ a+1, b+2, c+3 ]
%
%      tril(A,-1) は、以下の結果を返します。
%         [   0,   0,   0 ]
%         [   1,   0,   0 ]
%         [ a+1, b+2,   0 ]
%
%   参考 SYM/TRIU.


%   Copyright 1993-2008 The MathWorks, Inc.

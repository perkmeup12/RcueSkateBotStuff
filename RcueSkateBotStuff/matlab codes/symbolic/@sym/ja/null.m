%NULL  ヌル空間に対する基底
%
%   Z = NULL(A) の列は、A のヌル空間に対する基底を形成します。
%   SIZE(Z, 2) は、A の退化次数です。
%   A*Z は、零行列になります。
%   A がフルランクの場合、Z は空行列になります。
%
%   例:
%
%     null(sym(magic(4))) は、以下になります。
%
%     -1
%     -3
%      3
%      1
%
%   参考 SYM/COLSPACE.


%   Copyright 1993-2009 The MathWorks, Inc.

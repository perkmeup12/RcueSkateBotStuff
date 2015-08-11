% HEAVISIDE   シンボリックなStep関数
%
% HEAVISIDE(X) は、X < 0 に対して 0、X > 0 に対して 1、X == 0 のとき 
% NaN になります。
% HEAVISIDE(X) は、厳密に言えば関数ではなく、むしろ
%    diff(heaviside(x)) = dirac(x)
% となる分布です。
%
%    参考 DIRAC.


%   Copyright 1993-2004 The MathWorks, Inc.

% DIRAC   シンボリックなDelta関数
%
% DIRAC(X) は、X == 0 が無限になる以外は、すべての X に対してゼロです。
% DIRAC(X) は、厳密に言えば関数ではなく、どちらかといえば、
%   int(dirac(x-a)*f(x),-inf,inf) = f(a)
% と
%   diff(heaviside(x),x) = dirac(x)
% となる分布です。
%
%    参考 HEAVISIDE.


%   Copyright 1993-2004 The MathWorks, Inc.

function Y = dirac(X)
%DIRAC  Delta function.
%    DIRAC(X) is zero for all X, except X == 0 where it is infinite.
%    DIRAC(X) is not a function in the strict sense, but rather a
%    distribution with int(dirac(x-a)*f(x),-inf,inf) = f(a) and
%    diff(heaviside(x),x) = dirac(x).
%    See also HEAVISIDE.

%   Copyright 1993-2012 The MathWorks, Inc.

Y = zeros(size(X),'like',X);
Y(X == 0) = Inf;
Y(imag(X) ~= 0) = NaN;
Y(isnan(X)) = NaN;

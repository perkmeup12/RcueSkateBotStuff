function Y = dirac(X)
%DIRAC  Symbolic delta function.
%    DIRAC(X) is zero for all X, except X == 0 where it is infinite.
%    DIRAC(X) is not a function in the strict sense, but rather a
%    distribution with int(dirac(x-a)*f(x),-inf,inf) = f(a) and
%    diff(heaviside(x),x) = dirac(x).
%
%    See also SYM/HEAVISIDE.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'dirac');
end

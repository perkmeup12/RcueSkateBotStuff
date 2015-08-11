function Y = heaviside(X)
%HEAVISIDE    Symbolic step function.
%    HEAVISIDE(X) is 0 for X < 0, 1 for X > 0, and 1/2 for X == 0.
%    HEAVISIDE(X) is not a function in the strict sense, but rather
%    a distribution with diff(heaviside(x)) = dirac(x).
%
%    See also SYM/DIRAC.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'heaviside');
end

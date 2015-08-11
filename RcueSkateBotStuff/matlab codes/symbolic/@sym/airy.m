function y = airy(k,x)
%AIRY Airy function.
%   W = AIRY(X) is the Airy function, Ai(x).
%   W = AIRY(0,X) is the same as AIRY(x).
%   W = AIRY(1,X) is the derivative, Ai'(x).
%   W = AIRY(2,X) is the Airy function of the second kind, Bi(x).
%   W = AIRY(3,X) is the derivative, Bi'(x).
%
%   Reference:
%       [1] Abramowitz, Milton; Stegun, Irene A., eds., "Chapter 10",
%       Handbook of Mathematical Functions with Formulas, Graphs, and
%       Mathematical Tables, New York: Dover, pp. 446, 1965.

%   Copyright 2013 The MathWorks, Inc.

if nargin == 1
    x = k;
    k = sym(0);
end
y = privBinaryOp(k, x, 'symobj::vectorizeSpecfunc', 'symobj::airy', 'infinity');
end

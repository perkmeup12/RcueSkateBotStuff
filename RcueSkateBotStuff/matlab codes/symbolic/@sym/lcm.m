function c = lcm(a,b)
%LCM    Least common multiple.
%   C = LCM(A,B) is the symbolic least common multiple of A and B.
%
%   Example:
%      syms x
%      factor(lcm(x^3-3*x^2+3*x-1,x^2-5*x+4))
%      returns (x-1)^3*(x-4)
%
%   See also SYM/GCD.

%   Copyright 1993-2011 The MathWorks, Inc.

c = privBinaryOp(a, b, 'lcm');

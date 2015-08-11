function r = rank(A)
%RANK   Symbolic matrix rank.
%   RANK(A) is the rank of the symbolic matrix A.
%
%   Example:
%       rank([a b;c d]) is 2.

%   Copyright 2013 The MathWorks, Inc.

if any(any(~isfinite(A)))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end
r = privUnaryOp(A, 'symobj::rank');
end

function Y = expm(X)
%EXPM   Symbolic matrix exponential.
%   EXPM(A) is the matrix exponential of the symbolic matrix A.
%
%   Examples:
%      syms t
%      A = [0 1; -1 0]
%      expm(t*A)
%
%      A = sym(gallery(5))
%      expm(t*A)

%   Copyright 2013 The MathWorks, Inc.

if any(any(~isfinite(X)))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end
Y = privUnaryOp(X, 'symobj::expm');
end
